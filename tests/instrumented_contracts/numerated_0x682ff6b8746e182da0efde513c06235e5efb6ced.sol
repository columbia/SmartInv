1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
25     */
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     /**
32     * @dev Adds two numbers, throws on overflow.
33     */
34     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
35         c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49     address public owner;
50 
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55     /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72      * @dev Allows the current owner to transfer control of the contract to a newOwner.
73      * @param newOwner The address to transfer ownership to.
74      */
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0));
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 
81 }
82 
83 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
84 
85 /**
86  * @title ERC721 Non-Fungible Token Standard basic interface
87  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
88  */
89 contract ERC721Basic {
90     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
91     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
92     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
93 
94     function balanceOf(address _owner) public view returns (uint256 _balance);
95     function ownerOf(uint256 _tokenId) public view returns (address _owner);
96     function exists(uint256 _tokenId) public view returns (bool _exists);
97 
98     function approve(address _to, uint256 _tokenId) public;
99     function getApproved(uint256 _tokenId) public view returns (address _operator);
100 
101     function setApprovalForAll(address _operator, bool _approved) public;
102     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
103 
104     function transferFrom(address _from, address _to, uint256 _tokenId) public;
105     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
106     function safeTransferFrom(
107         address _from,
108         address _to,
109         uint256 _tokenId,
110         bytes _data
111     )
112     public;
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
116 
117 /**
118  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
119  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
120  */
121 contract ERC721Enumerable is ERC721Basic {
122     function totalSupply() public view returns (uint256);
123     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
124     function tokenByIndex(uint256 _index) public view returns (uint256);
125 }
126 
127 
128 /**
129  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
130  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
131  */
132 contract ERC721Metadata is ERC721Basic {
133     function name() public view returns (string _name);
134     function symbol() public view returns (string _symbol);
135     function tokenURI(uint256 _tokenId) public view returns (string);
136 }
137 
138 
139 /**
140  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
141  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
142  */
143 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
144 }
145 
146 // File: openzeppelin-solidity/contracts/AddressUtils.sol
147 
148 /**
149  * Utility library of inline functions on addresses
150  */
151 library AddressUtils {
152 
153     /**
154      * Returns whether the target address is a contract
155      * @dev This function will return false if invoked during the constructor of a contract,
156      *  as the code is not actually created until after the constructor finishes.
157      * @param addr address to check
158      * @return whether the target address is a contract
159      */
160     function isContract(address addr) internal view returns (bool) {
161         uint256 size;
162         // XXX Currently there is no better way to check if there is a contract in an address
163         // than to check the size of the code at that address.
164         // See https://ethereum.stackexchange.com/a/14016/36603
165         // for more details about how this works.
166         // TODO Check this again before the Serenity release, because all addresses will be
167         // contracts then.
168         assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
169         return size > 0;
170     }
171 
172 }
173 
174 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  *  from ERC721 asset contracts.
180  */
181 contract ERC721Receiver {
182     /**
183      * @dev Magic value to be returned upon successful reception of an NFT
184      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
185      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
186      */
187     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
188 
189     /**
190      * @notice Handle the receipt of an NFT
191      * @dev The ERC721 smart contract calls this function on the recipient
192      *  after a `safetransfer`. This function MAY throw to revert and reject the
193      *  transfer. This function MUST use 50,000 gas or less. Return of other
194      *  than the magic value MUST result in the transaction being reverted.
195      *  Note: the contract address is always the message sender.
196      * @param _from The sending address
197      * @param _tokenId The NFT identifier which is being transfered
198      * @param _data Additional data with no specified format
199      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
200      */
201     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
202 }
203 
204 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
205 
206 /**
207  * @title ERC721 Non-Fungible Token Standard basic implementation
208  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
209  */
210 contract ERC721BasicToken is ERC721Basic {
211     using SafeMath for uint256;
212     using AddressUtils for address;
213 
214     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
215     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
216     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
217 
218     // Mapping from token ID to owner
219     mapping (uint256 => address) internal tokenOwner;
220 
221     // Mapping from token ID to approved address
222     mapping (uint256 => address) internal tokenApprovals;
223 
224     // Mapping from owner to number of owned token
225     mapping (address => uint256) internal ownedTokensCount;
226 
227     // Mapping from owner to operator approvals
228     mapping (address => mapping (address => bool)) internal operatorApprovals;
229 
230     /**
231      * @dev Guarantees msg.sender is owner of the given token
232      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
233      */
234     modifier onlyOwnerOf(uint256 _tokenId) {
235         require(ownerOf(_tokenId) == msg.sender);
236         _;
237     }
238 
239     /**
240      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
241      * @param _tokenId uint256 ID of the token to validate
242      */
243     modifier canTransfer(uint256 _tokenId) {
244         require(isApprovedOrOwner(msg.sender, _tokenId));
245         _;
246     }
247 
248     /**
249      * @dev Gets the balance of the specified address
250      * @param _owner address to query the balance of
251      * @return uint256 representing the amount owned by the passed address
252      */
253     function balanceOf(address _owner) public view returns (uint256) {
254         require(_owner != address(0));
255         return ownedTokensCount[_owner];
256     }
257 
258     /**
259      * @dev Gets the owner of the specified token ID
260      * @param _tokenId uint256 ID of the token to query the owner of
261      * @return owner address currently marked as the owner of the given token ID
262      */
263     function ownerOf(uint256 _tokenId) public view returns (address) {
264         address owner = tokenOwner[_tokenId];
265         require(owner != address(0));
266         return owner;
267     }
268 
269     /**
270      * @dev Returns whether the specified token exists
271      * @param _tokenId uint256 ID of the token to query the existance of
272      * @return whether the token exists
273      */
274     function exists(uint256 _tokenId) public view returns (bool) {
275         address owner = tokenOwner[_tokenId];
276         return owner != address(0);
277     }
278 
279     /**
280      * @dev Approves another address to transfer the given token ID
281      * @dev The zero address indicates there is no approved address.
282      * @dev There can only be one approved address per token at a given time.
283      * @dev Can only be called by the token owner or an approved operator.
284      * @param _to address to be approved for the given token ID
285      * @param _tokenId uint256 ID of the token to be approved
286      */
287     function approve(address _to, uint256 _tokenId) public {
288         address owner = ownerOf(_tokenId);
289         require(_to != owner);
290         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
291 
292         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
293             tokenApprovals[_tokenId] = _to;
294             emit Approval(owner, _to, _tokenId);
295         }
296     }
297 
298     /**
299      * @dev Gets the approved address for a token ID, or zero if no address set
300      * @param _tokenId uint256 ID of the token to query the approval of
301      * @return address currently approved for a the given token ID
302      */
303     function getApproved(uint256 _tokenId) public view returns (address) {
304         return tokenApprovals[_tokenId];
305     }
306 
307     /**
308      * @dev Sets or unsets the approval of a given operator
309      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
310      * @param _to operator address to set the approval
311      * @param _approved representing the status of the approval to be set
312      */
313     function setApprovalForAll(address _to, bool _approved) public {
314         require(_to != msg.sender);
315         operatorApprovals[msg.sender][_to] = _approved;
316         emit ApprovalForAll(msg.sender, _to, _approved);
317     }
318 
319     /**
320      * @dev Tells whether an operator is approved by a given owner
321      * @param _owner owner address which you want to query the approval of
322      * @param _operator operator address which you want to query the approval of
323      * @return bool whether the given operator is approved by the given owner
324      */
325     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
326         return operatorApprovals[_owner][_operator];
327     }
328 
329     /**
330      * @dev Transfers the ownership of a given token ID to another address
331      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
332      * @dev Requires the msg sender to be the owner, approved, or operator
333      * @param _from current owner of the token
334      * @param _to address to receive the ownership of the given token ID
335      * @param _tokenId uint256 ID of the token to be transferred
336     */
337     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
338         require(_from != address(0));
339         require(_to != address(0));
340 
341         clearApproval(_from, _tokenId);
342         removeTokenFrom(_from, _tokenId);
343         addTokenTo(_to, _tokenId);
344 
345         emit Transfer(_from, _to, _tokenId);
346     }
347 
348     /**
349      * @dev Safely transfers the ownership of a given token ID to another address
350      * @dev If the target address is a contract, it must implement `onERC721Received`,
351      *  which is called upon a safe transfer, and return the magic value
352      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
353      *  the transfer is reverted.
354      * @dev Requires the msg sender to be the owner, approved, or operator
355      * @param _from current owner of the token
356      * @param _to address to receive the ownership of the given token ID
357      * @param _tokenId uint256 ID of the token to be transferred
358     */
359     function safeTransferFrom(
360         address _from,
361         address _to,
362         uint256 _tokenId
363     )
364     public
365     canTransfer(_tokenId)
366     {
367         // solium-disable-next-line arg-overflow
368         safeTransferFrom(_from, _to, _tokenId, "");
369     }
370 
371     /**
372      * @dev Safely transfers the ownership of a given token ID to another address
373      * @dev If the target address is a contract, it must implement `onERC721Received`,
374      *  which is called upon a safe transfer, and return the magic value
375      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
376      *  the transfer is reverted.
377      * @dev Requires the msg sender to be the owner, approved, or operator
378      * @param _from current owner of the token
379      * @param _to address to receive the ownership of the given token ID
380      * @param _tokenId uint256 ID of the token to be transferred
381      * @param _data bytes data to send along with a safe transfer check
382      */
383     function safeTransferFrom(
384         address _from,
385         address _to,
386         uint256 _tokenId,
387         bytes _data
388     )
389     public
390     canTransfer(_tokenId)
391     {
392         transferFrom(_from, _to, _tokenId);
393         // solium-disable-next-line arg-overflow
394         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
395     }
396 
397     /**
398      * @dev Returns whether the given spender can transfer a given token ID
399      * @param _spender address of the spender to query
400      * @param _tokenId uint256 ID of the token to be transferred
401      * @return bool whether the msg.sender is approved for the given token ID,
402      *  is an operator of the owner, or is the owner of the token
403      */
404     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
405         address owner = ownerOf(_tokenId);
406         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
407     }
408 
409     /**
410      * @dev Internal function to mint a new token
411      * @dev Reverts if the given token ID already exists
412      * @param _to The address that will own the minted token
413      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
414      */
415     function _mint(address _to, uint256 _tokenId) internal {
416         require(_to != address(0));
417         addTokenTo(_to, _tokenId);
418         emit Transfer(address(0), _to, _tokenId);
419     }
420 
421     /**
422      * @dev Internal function to clear current approval of a given token ID
423      * @dev Reverts if the given address is not indeed the owner of the token
424      * @param _owner owner of the token
425      * @param _tokenId uint256 ID of the token to be transferred
426      */
427     function clearApproval(address _owner, uint256 _tokenId) internal {
428         require(ownerOf(_tokenId) == _owner);
429         if (tokenApprovals[_tokenId] != address(0)) {
430             tokenApprovals[_tokenId] = address(0);
431             emit Approval(_owner, address(0), _tokenId);
432         }
433     }
434 
435     /**
436      * @dev Internal function to add a token ID to the list of a given address
437      * @param _to address representing the new owner of the given token ID
438      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
439      */
440     function addTokenTo(address _to, uint256 _tokenId) internal {
441         require(tokenOwner[_tokenId] == address(0));
442         tokenOwner[_tokenId] = _to;
443         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
444     }
445 
446     /**
447      * @dev Internal function to remove a token ID from the list of a given address
448      * @param _from address representing the previous owner of the given token ID
449      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
450      */
451     function removeTokenFrom(address _from, uint256 _tokenId) internal {
452         require(ownerOf(_tokenId) == _from);
453         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
454         tokenOwner[_tokenId] = address(0);
455     }
456 
457     /**
458      * @dev Internal function to invoke `onERC721Received` on a target address
459      * @dev The call is not executed if the target address is not a contract
460      * @param _from address representing the previous owner of the given token ID
461      * @param _to target address that will receive the tokens
462      * @param _tokenId uint256 ID of the token to be transferred
463      * @param _data bytes optional data to send along with the call
464      * @return whether the call correctly returned the expected magic value
465      */
466     function checkAndCallSafeTransfer(
467         address _from,
468         address _to,
469         uint256 _tokenId,
470         bytes _data
471     )
472     internal
473     returns (bool)
474     {
475         if (!_to.isContract()) {
476             return true;
477         }
478         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
479         return (retval == ERC721_RECEIVED);
480     }
481 }
482 
483 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
484 
485 /**
486  * @title Full ERC721 Token
487  * This implementation includes all the required and some optional functionality of the ERC721 standard
488  * Moreover, it includes approve all functionality using operator terminology
489  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
490  */
491 contract ERC721Token is ERC721, ERC721BasicToken {
492     // Token name
493     string internal name_;
494 
495     // Token symbol
496     string internal symbol_;
497 
498     // Mapping from owner to list of owned token IDs
499     mapping (address => uint256[]) internal ownedTokens;
500 
501     // Mapping from token ID to index of the owner tokens list
502     mapping(uint256 => uint256) internal ownedTokensIndex;
503 
504     // Array with all token ids, used for enumeration
505     uint256[] internal allTokens;
506 
507     // Mapping from token id to position in the allTokens array
508     mapping(uint256 => uint256) internal allTokensIndex;
509 
510     // Optional mapping for token URIs
511     mapping(uint256 => string) internal tokenURIs;
512 
513     /**
514      * @dev Constructor function
515      */
516     constructor(string _name, string _symbol) public {
517         name_ = _name;
518         symbol_ = _symbol;
519     }
520 
521     /**
522      * @dev Gets the token name
523      * @return string representing the token name
524      */
525     function name() public view returns (string) {
526         return name_;
527     }
528 
529     /**
530      * @dev Gets the token symbol
531      * @return string representing the token symbol
532      */
533     function symbol() public view returns (string) {
534         return symbol_;
535     }
536 
537     /**
538      * @dev Returns an URI for a given token ID
539      * @dev Throws if the token ID does not exist. May return an empty string.
540      * @param _tokenId uint256 ID of the token to query
541      */
542     function tokenURI(uint256 _tokenId) public view returns (string) {
543         require(exists(_tokenId));
544         return tokenURIs[_tokenId];
545     }
546 
547     /**
548      * @dev Gets the token ID at a given index of the tokens list of the requested owner
549      * @param _owner address owning the tokens list to be accessed
550      * @param _index uint256 representing the index to be accessed of the requested tokens list
551      * @return uint256 token ID at the given index of the tokens list owned by the requested address
552      */
553     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
554         require(_index < balanceOf(_owner));
555         return ownedTokens[_owner][_index];
556     }
557 
558     /**
559      * @dev Gets the total amount of tokens stored by the contract
560      * @return uint256 representing the total amount of tokens
561      */
562     function totalSupply() public view returns (uint256) {
563         return allTokens.length;
564     }
565 
566     /**
567      * @dev Gets the token ID at a given index of all the tokens in this contract
568      * @dev Reverts if the index is greater or equal to the total number of tokens
569      * @param _index uint256 representing the index to be accessed of the tokens list
570      * @return uint256 token ID at the given index of the tokens list
571      */
572     function tokenByIndex(uint256 _index) public view returns (uint256) {
573         require(_index < totalSupply());
574         return allTokens[_index];
575     }
576 
577     /**
578      * @dev Internal function to set the token URI for a given token
579      * @dev Reverts if the token ID does not exist
580      * @param _tokenId uint256 ID of the token to set its URI
581      * @param _uri string URI to assign
582      */
583     function _setTokenURI(uint256 _tokenId, string _uri) internal {
584         require(exists(_tokenId));
585         tokenURIs[_tokenId] = _uri;
586     }
587 
588     /**
589      * @dev Internal function to add a token ID to the list of a given address
590      * @param _to address representing the new owner of the given token ID
591      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
592      */
593     function addTokenTo(address _to, uint256 _tokenId) internal {
594         super.addTokenTo(_to, _tokenId);
595         uint256 length = ownedTokens[_to].length;
596         ownedTokens[_to].push(_tokenId);
597         ownedTokensIndex[_tokenId] = length;
598     }
599 
600     /**
601      * @dev Internal function to remove a token ID from the list of a given address
602      * @param _from address representing the previous owner of the given token ID
603      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
604      */
605     function removeTokenFrom(address _from, uint256 _tokenId) internal {
606         super.removeTokenFrom(_from, _tokenId);
607 
608         uint256 tokenIndex = ownedTokensIndex[_tokenId];
609         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
610         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
611 
612         ownedTokens[_from][tokenIndex] = lastToken;
613         ownedTokens[_from][lastTokenIndex] = 0;
614         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
615         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
616         // the lastToken to the first position, and then dropping the element placed in the last position of the list
617 
618         ownedTokens[_from].length--;
619         ownedTokensIndex[_tokenId] = 0;
620         ownedTokensIndex[lastToken] = tokenIndex;
621     }
622 
623     /**
624      * @dev Internal function to mint a new token
625      * @dev Reverts if the given token ID already exists
626      * @param _to address the beneficiary that will own the minted token
627      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
628      */
629     function _mint(address _to, uint256 _tokenId) internal {
630         super._mint(_to, _tokenId);
631 
632         allTokensIndex[_tokenId] = allTokens.length;
633         allTokens.push(_tokenId);
634     }
635 
636 }
637 
638 // File: contracts/Graffiti.sol
639 /**
640  * @dev See https://fytoken.github.io/
641  * Get sworn at by important people on the blockchain. Auction off that token. Get rich. Simple right?
642  * Also, FYT token will solve world hunger, relativity theory's shortcomings, interplanetory travel and 
643  * that small problem of consciousness.
644  */
645 contract FYouToken is Ownable, ERC721Token {
646     using SafeMath for uint256;
647 
648 
649     modifier onlyTwoMil() {
650         require(fYouTokens < 2000001);
651         _;
652     }
653 
654     struct Graffiti {
655         bool exists;
656         string message;
657         string infoUrlOrIPFSHash;
658     }
659 
660 
661     mapping(uint256 => Graffiti) private tokenGraffiti;
662 
663     uint256 private fYouTokens;
664 
665     constructor() public ERC721Token("F You Token", "FYT") {
666 
667     }
668 
669     // finney i.e. 0.001 eth
670     uint256 private fee = 1;
671     
672     /**
673      * @dev Function to create a token and associate it with Graffiti. 
674      * If both message and url are empty then those can be set again. 
675      * If any of the message or url are set, then both are prevented from furhter modification
676      * @param _schmuck the address to which the token will be created. Usually same as address of function invoker.
677      * @param _clearTextMessageJustToBeSuperClear The string Graffiti.
678      * @param _infoUrlOrIPFSHash the url or ipfs hash that has more metadata about this Graffiti.
679      */
680     function fYou(address _schmuck, string _clearTextMessageJustToBeSuperClear, string _infoUrlOrIPFSHash) external payable onlyTwoMil {
681         require(_schmuck != address(0) && msg.value == (fee * (1 finney)));
682 
683         _fYou(_schmuck, fYouTokens, _clearTextMessageJustToBeSuperClear, _infoUrlOrIPFSHash);
684         fYouTokens = fYouTokens + 1;
685         feesAvailableForWithdraw = feesAvailableForWithdraw.add(msg.value);
686     }
687 
688     /**
689      * @dev Use this to create more than 1 token at a time. Max is 10 tokens. Graffiti can be added to the tokens by owner later on.
690      * @param _to the address to which the token will be created. Usually same as address of function invoker.
691      * @param _numTokens number of tokens to create.
692      */
693     function giantFYou(address _to, uint256 _numTokens) external payable onlyTwoMil {
694         require(_to != address(0) && _numTokens > 0 && _numTokens < 11 && msg.value == (fee.mul(_numTokens) * (1 finney)));
695         uint tokensCount = _numTokens.add(fYouTokens);
696         require(allTokens.length < 2000001 && tokensCount < 2000001);
697         for (uint256 i = 0; i < _numTokens; i++) {
698         _fYou(_to, (fYouTokens + i), '', '');
699         }
700         fYouTokens = tokensCount;
701         feesAvailableForWithdraw = feesAvailableForWithdraw.add(msg.value);
702     }
703 
704     /**
705      * @dev Use this function to add graffiti to tokens that the address owns. If graffiti is already present it will throw.
706      * @param _tokenId the token id to which the graffiti is to be associated.
707      * @param _clearTextMessageJustToBeSuperClear The string Graffiti.
708      * @param _infoUrlOrIPFSHash the url or ipfs hash that has more metadata about this Graffiti.
709      */
710     function paintGraffiti(uint256 _tokenId, string _clearTextMessageJustToBeSuperClear, string _infoUrlOrIPFSHash) external onlyOwnerOf(_tokenId) {
711         _addGraffiti(_tokenId, _clearTextMessageJustToBeSuperClear, _infoUrlOrIPFSHash);
712     }
713 
714     function _fYou(address _to, uint _tokenId, string _clearTextMessageJustToBeSuperClear, string _infoUrlOrIPFSHash) internal {
715         _addGraffiti(_tokenId, _clearTextMessageJustToBeSuperClear, _infoUrlOrIPFSHash);
716         _mint(_to, _tokenId);
717     }
718 
719     function _addGraffiti(uint256 _tokenId, string _clearTextMessageJustToBeSuperClear, string _infoUrlOrIPFSHash) private {
720         // prevent modification of any existing graffiti.
721         require(tokenGraffiti[_tokenId].exists == false);
722         bytes memory msgSize = bytes(_clearTextMessageJustToBeSuperClear);
723         bytes memory urlSize = bytes(_infoUrlOrIPFSHash);
724         if (urlSize.length > 0 || msgSize.length > 0) {
725             tokenGraffiti[_tokenId] = Graffiti(true, _clearTextMessageJustToBeSuperClear, _infoUrlOrIPFSHash);
726         }
727     }
728 
729     function tokenMetadata(uint256 _tokenId) external constant returns (string infoUrlOrIPFSHash) {
730         return tokenGraffiti[_tokenId].infoUrlOrIPFSHash;
731     }
732 
733     function getGraffiti(uint256 _tokenId) external constant returns (string message, string infoUrlOrIPFSHash) {
734         Graffiti memory graffiti = tokenGraffiti[_tokenId];
735         return (graffiti.message, graffiti.infoUrlOrIPFSHash);
736     }
737 
738     function tokensOf(address _owner) external view returns(uint256[]) {
739         return ownedTokens[_owner];
740     }
741 
742     function setFee(uint256 _fee) external onlyOwner {
743         fee = _fee;
744     }
745 
746     uint256 private feesAvailableForWithdraw;
747 
748     function getFeesAvailableForWithdraw() external view onlyOwner returns (uint256) {
749         return feesAvailableForWithdraw;
750     }
751 
752     function withdrawFees(address _to, uint256 _amount) external onlyOwner {
753         /**
754          * Withdraw fees collected by the contract. Only the owner or arbitrator can call this.
755          */
756         require(_amount <= feesAvailableForWithdraw);
757         // Also prevents underflow
758         feesAvailableForWithdraw = feesAvailableForWithdraw.sub(_amount);
759         _to.transfer(_amount);
760     }
761 }