1 pragma solidity ^0.4.21;
2 
3 // The contract uses code from zeppelin-solidity library
4 // licensed under MIT license
5 // https://github.com/OpenZeppelin/zeppelin-solidity
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC721 Non-Fungible Token Standard basic interface
38  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
39  */
40 contract ERC721Basic {
41     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
42     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
43     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
44 
45     function balanceOf(address _owner) public view returns (uint256 _balance);
46     function ownerOf(uint256 _tokenId) public view returns (address _owner);
47     function exists(uint256 _tokenId) public view returns (bool _exists);
48 
49     function approve(address _to, uint256 _tokenId) public;
50     function getApproved(uint256 _tokenId) public view returns (address _operator);
51 
52     function setApprovalForAll(address _operator, bool _approved) public;
53     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
54 
55     function transferFrom(address _from, address _to, uint256 _tokenId) public;
56     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
57     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
58 }
59 
60 /**
61  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
62  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
63  */
64 contract ERC721Enumerable is ERC721Basic {
65     function totalSupply() public view returns (uint256);
66     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
67     function tokenByIndex(uint256 _index) public view returns (uint256);
68 }
69 
70 
71 /**
72  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
73  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
74  */
75 contract ERC721Metadata is ERC721Basic {
76     function name() public view returns (string _name);
77     function symbol() public view returns (string _symbol);
78     function tokenURI(uint256 _tokenId) public view returns (string);
79 }
80 
81 
82 /**
83  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
84  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
85  */
86 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
87 }
88 
89 /**
90  * @title ERC721 token receiver interface
91  * @dev Interface for any contract that wants to support safeTransfers
92  *  from ERC721 asset contracts.
93  */
94 contract ERC721Receiver {
95     /**
96      * @dev Magic value to be returned upon successful reception of an NFT
97      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
98      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
99      */
100     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
101 
102     /**
103      * @notice Handle the receipt of an NFT
104      * @dev The ERC721 smart contract calls this function on the recipient
105      *  after a `safetransfer`. This function MAY throw to revert and reject the
106      *  transfer. This function MUST use 50,000 gas or less. Return of other
107      *  than the magic value MUST result in the transaction being reverted.
108      *  Note: the contract address is always the message sender.
109      * @param _from The sending address
110      * @param _tokenId The NFT identifier which is being transfered
111      * @param _data Additional data with no specified format
112      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
113      */
114     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
115 }
116 
117 /**
118  * @title ERC721 Non-Fungible Token Standard basic implementation
119  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
120  */
121 contract ERC721BasicToken is ERC721Basic {
122     using SafeMath for uint256;
123 
124     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
125     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
126     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
127 
128     // Mapping from token ID to owner
129     mapping (uint256 => address) internal tokenOwner;
130 
131     // Mapping from token ID to approved address
132     mapping (uint256 => address) internal tokenApprovals;
133 
134     // Mapping from owner to number of owned token
135     mapping (address => uint256) internal ownedTokensCount;
136 
137     // Mapping from owner to operator approvals
138     mapping (address => mapping (address => bool)) internal operatorApprovals;
139 
140     /**
141     * @dev Guarantees msg.sender is owner of the given token
142     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
143     */
144     modifier onlyOwnerOf(uint256 _tokenId) {
145         require(ownerOf(_tokenId) == msg.sender);
146         _;
147     }
148 
149     /**
150     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
151     * @param _tokenId uint256 ID of the token to validate
152     */
153     modifier canTransfer(uint256 _tokenId) {
154         require(isApprovedOrOwner(msg.sender, _tokenId));
155         _;
156     }
157 
158     /**
159     * @dev Gets the balance of the specified address
160     * @param _owner address to query the balance of
161     * @return uint256 representing the amount owned by the passed address
162     */
163     function balanceOf(address _owner) public view returns (uint256) {
164         require(_owner != address(0));
165         return ownedTokensCount[_owner];
166     }
167 
168     /**
169     * @dev Gets the owner of the specified token ID
170     * @param _tokenId uint256 ID of the token to query the owner of
171     * @return owner address currently marked as the owner of the given token ID
172     */
173     function ownerOf(uint256 _tokenId) public view returns (address) {
174         address owner = tokenOwner[_tokenId];
175         require(owner != address(0));
176         return owner;
177     }
178 
179     /**
180     * @dev Returns whether the specified token exists
181     * @param _tokenId uint256 ID of the token to query the existance of
182     * @return whether the token exists
183     */
184     function exists(uint256 _tokenId) public view returns (bool) {
185         address owner = tokenOwner[_tokenId];
186         return owner != address(0);
187     }
188 
189     /**
190     * @dev Approves another address to transfer the given token ID
191     * @dev The zero address indicates there is no approved address.
192     * @dev There can only be one approved address per token at a given time.
193     * @dev Can only be called by the token owner or an approved operator.
194     * @param _to address to be approved for the given token ID
195     * @param _tokenId uint256 ID of the token to be approved
196     */
197     function approve(address _to, uint256 _tokenId) public {
198         address owner = ownerOf(_tokenId);
199         require(_to != owner);
200         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
201 
202         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
203             tokenApprovals[_tokenId] = _to;
204             emit Approval(owner, _to, _tokenId);
205         }
206     }
207 
208     /**
209      * @dev Gets the approved address for a token ID, or zero if no address set
210      * @param _tokenId uint256 ID of the token to query the approval of
211      * @return address currently approved for a the given token ID
212      */
213     function getApproved(uint256 _tokenId) public view returns (address) {
214         return tokenApprovals[_tokenId];
215     }
216 
217     /**
218     * @dev Sets or unsets the approval of a given operator
219     * @dev An operator is allowed to transfer all tokens of the sender on their behalf
220     * @param _to operator address to set the approval
221     * @param _approved representing the status of the approval to be set
222     */
223     function setApprovalForAll(address _to, bool _approved) public {
224         require(_to != msg.sender);
225         operatorApprovals[msg.sender][_to] = _approved;
226         emit ApprovalForAll(msg.sender, _to, _approved);
227     }
228 
229     /**
230      * @dev Tells whether an operator is approved by a given owner
231      * @param _owner owner address which you want to query the approval of
232      * @param _operator operator address which you want to query the approval of
233      * @return bool whether the given operator is approved by the given owner
234      */
235     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
236         return operatorApprovals[_owner][_operator];
237     }
238 
239     /**
240     * @dev Transfers the ownership of a given token ID to another address
241     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
242     * @dev Requires the msg sender to be the owner, approved, or operator
243     * @param _from current owner of the token
244     * @param _to address to receive the ownership of the given token ID
245     * @param _tokenId uint256 ID of the token to be transferred
246     */
247     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
248         require(_from != address(0));
249         require(_to != address(0));
250 
251         clearApproval(_from, _tokenId);
252         removeTokenFrom(_from, _tokenId);
253         addTokenTo(_to, _tokenId);
254 
255         emit Transfer(_from, _to, _tokenId);
256     }
257 
258     /**
259     * @dev Safely transfers the ownership of a given token ID to another address
260     * @dev If the target address is a contract, it must implement `onERC721Received`,
261     *  which is called upon a safe transfer, and return the magic value
262     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
263     *  the transfer is reverted.
264     * @dev Requires the msg sender to be the owner, approved, or operator
265     * @param _from current owner of the token
266     * @param _to address to receive the ownership of the given token ID
267     * @param _tokenId uint256 ID of the token to be transferred
268     */
269     function safeTransferFrom(
270         address _from,
271         address _to,
272         uint256 _tokenId
273     )
274         public
275         canTransfer(_tokenId)
276     {
277         safeTransferFrom(_from, _to, _tokenId, "");
278     }
279 
280     /**
281     * @dev Safely transfers the ownership of a given token ID to another address
282     * @dev If the target address is a contract, it must implement `onERC721Received`,
283     *  which is called upon a safe transfer, and return the magic value
284     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
285     *  the transfer is reverted.
286     * @dev Requires the msg sender to be the owner, approved, or operator
287     * @param _from current owner of the token
288     * @param _to address to receive the ownership of the given token ID
289     * @param _tokenId uint256 ID of the token to be transferred
290     * @param _data bytes data to send along with a safe transfer check
291     */
292     function safeTransferFrom(
293         address _from,
294         address _to,
295         uint256 _tokenId,
296         bytes _data
297     )
298         public
299         canTransfer(_tokenId)
300     {
301         transferFrom(_from, _to, _tokenId);
302         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
303     }
304 
305     /**
306      * @dev Returns whether the given spender can transfer a given token ID
307      * @param _spender address of the spender to query
308      * @param _tokenId uint256 ID of the token to be transferred
309      * @return bool whether the msg.sender is approved for the given token ID,
310      *  is an operator of the owner, or is the owner of the token
311      */
312     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
313         address owner = ownerOf(_tokenId);
314         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
315     }
316 
317     /**
318     * @dev Internal function to mint a new token
319     * @dev Reverts if the given token ID already exists
320     * @param _to The address that will own the minted token
321     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
322     */
323     function _mint(address _to, uint256 _tokenId) internal {
324         require(_to != address(0));
325         addTokenTo(_to, _tokenId);
326         emit Transfer(address(0), _to, _tokenId);
327     }
328 
329     /**
330     * @dev Internal function to burn a specific token
331     * @dev Reverts if the token does not exist
332     * @param _tokenId uint256 ID of the token being burned by the msg.sender
333     */
334     function _burn(address _owner, uint256 _tokenId) internal {
335         clearApproval(_owner, _tokenId);
336         removeTokenFrom(_owner, _tokenId);
337         emit Transfer(_owner, address(0), _tokenId);
338     }
339 
340     /**
341     * @dev Internal function to clear current approval of a given token ID
342     * @dev Reverts if the given address is not indeed the owner of the token
343     * @param _owner owner of the token
344     * @param _tokenId uint256 ID of the token to be transferred
345     */
346     function clearApproval(address _owner, uint256 _tokenId) internal {
347         require(ownerOf(_tokenId) == _owner);
348         if (tokenApprovals[_tokenId] != address(0)) {
349             tokenApprovals[_tokenId] = address(0);
350             emit Approval(_owner, address(0), _tokenId);
351         }
352     }
353 
354     /**
355     * @dev Internal function to add a token ID to the list of a given address
356     * @param _to address representing the new owner of the given token ID
357     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
358     */
359     function addTokenTo(address _to, uint256 _tokenId) internal {
360         require(tokenOwner[_tokenId] == address(0));
361         tokenOwner[_tokenId] = _to;
362         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
363     }
364 
365     /**
366     * @dev Internal function to remove a token ID from the list of a given address
367     * @param _from address representing the previous owner of the given token ID
368     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
369     */
370     function removeTokenFrom(address _from, uint256 _tokenId) internal {
371         require(ownerOf(_tokenId) == _from);
372         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
373         tokenOwner[_tokenId] = address(0);
374     }
375 
376     /**
377      * Returns whether the target address is a contract
378      * @dev This function will return false if invoked during the constructor of a contract,
379      *  as the code is not actually created until after the constructor finishes.
380      * @param _user address to check
381      * @return whether the target address is a contract
382      */
383     function _isContract(address _user) internal view returns (bool) {
384         uint size;
385         assembly { size := extcodesize(_user) }
386         return size > 0;
387     }
388 
389     /**
390     * @dev Internal function to invoke `onERC721Received` on a target address
391     * @dev The call is not executed if the target address is not a contract
392     * @param _from address representing the previous owner of the given token ID
393     * @param _to target address that will receive the tokens
394     * @param _tokenId uint256 ID of the token to be transferred
395     * @param _data bytes optional data to send along with the call
396     * @return whether the call correctly returned the expected magic value
397     */
398     function checkAndCallSafeTransfer(
399         address _from,
400         address _to,
401         uint256 _tokenId,
402         bytes _data
403     )
404         internal
405         returns (bool)
406     {
407         if (!_isContract(_to)) {
408             return true;
409         }
410         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
411         return (retval == ERC721_RECEIVED);
412     }
413 
414 }
415 
416 contract Owned {
417     address owner;
418 
419     modifier onlyOwner {
420         require(msg.sender == owner);
421         _;
422     }
423 
424     /// @dev Contract constructor
425     function Owned() public {
426         owner = msg.sender;
427     }
428 }
429 
430 contract HeroLogicInterface {
431     function isTransferAllowed(address _from, address _to, uint256 _tokenId) public view returns (bool);
432 }
433 
434 contract ETHero is Owned, ERC721, ERC721BasicToken {
435 
436     struct HeroData {
437         uint16 fieldA;
438         uint16 fieldB;
439         uint32 fieldC;
440         uint32 fieldD;
441         uint32 fieldE;
442         uint64 fieldF;
443         uint64 fieldG;
444     }
445 
446     // Token name
447     string internal name_;
448 
449     // Token symbol
450     string internal symbol_;
451 
452     // Mapping from owner to list of owned token IDs
453     mapping (address => uint256[]) internal ownedTokens;
454 
455     // Mapping from token ID to index of the owner tokens list
456     mapping(uint256 => uint256) internal ownedTokensIndex;
457 
458     // Array with all token ids, used for enumeration
459     uint256[] internal allTokens;
460 
461     // Mapping from token id to position in the allTokens array
462     mapping(uint256 => uint256) internal allTokensIndex;
463 
464     // Prefix for token URIs
465     string public tokenUriPrefix = "https://eth.town/hero-image/";
466 
467     // Interchangeable logic contract
468     address public logicContract;
469 
470     // Incremental uniqueness index for the genome
471     uint32 public uniquenessIndex = 0;
472     // Last token ID
473     uint256 public lastTokenId = 0;
474 
475     // Users' active heroes
476     mapping(address => uint256) public activeHero;
477 
478     // Hero data
479     mapping(uint256 => HeroData) public heroData;
480 
481     // Genomes
482     mapping(uint256 => uint256) public genome;
483 
484     event ActiveHeroChanged(address indexed _from, uint256 _tokenId);
485 
486     modifier onlyLogicContract {
487         require(msg.sender == logicContract || msg.sender == owner);
488         _;
489     }
490 
491     /**
492     * @dev Constructor function
493     */
494     function ETHero() public {
495         name_ = "ETH.TOWN Hero";
496         symbol_ = "HERO";
497     }
498 
499     /**
500     * @dev Sets the token's interchangeable logic contract
501     */
502     function setLogicContract(address _logicContract) external onlyOwner {
503         logicContract = _logicContract;
504     }
505 
506     /**
507     * @dev Gets the token name
508     * @return string representing the token name
509     */
510     function name() public view returns (string) {
511         return name_;
512     }
513 
514     /**
515     * @dev Gets the token symbol
516     * @return string representing the token symbol
517     */
518     function symbol() public view returns (string) {
519         return symbol_;
520     }
521 
522     /**
523     * @dev Internal function to check if transferring a specific token is allowed
524     * @param _from transfer from
525     * @param _to transfer to
526     * @param _tokenId token to transfer
527     */
528     function _isTransferAllowed(address _from, address _to, uint256 _tokenId) internal view returns (bool) {
529         if (logicContract == address(0)) {
530             return true;
531         }
532 
533         HeroLogicInterface logic = HeroLogicInterface(logicContract);
534         return logic.isTransferAllowed(_from, _to, _tokenId);
535     }
536 
537     /**
538     * @dev Appends uint (in decimal) to a string
539     * @param _str The prefix string
540     * @param _value The uint to append
541     * @return resulting string
542     */
543     function _appendUintToString(string _str, uint _value) internal pure returns (string) {
544         uint maxLength = 100;
545         bytes memory reversed = new bytes(maxLength);
546         uint i = 0;
547         while (_value != 0) {
548             uint remainder = _value % 10;
549             _value = _value / 10;
550             reversed[i++] = byte(48 + remainder);
551         }
552         i--;
553 
554         bytes memory inStrB = bytes(_str);
555         bytes memory s = new bytes(inStrB.length + i + 1);
556         uint j;
557         for (j = 0; j < inStrB.length; j++) {
558             s[j] = inStrB[j];
559         }
560         for (j = 0; j <= i; j++) {
561             s[j + inStrB.length] = reversed[i - j];
562         }
563         return string(s);
564     }
565 
566     /**
567     * @dev Returns an URI for a given token ID
568     * @dev Throws if the token ID does not exist
569     * @param _tokenId uint256 ID of the token to query
570     */
571     function tokenURI(uint256 _tokenId) public view returns (string) {
572         require(exists(_tokenId));
573         return _appendUintToString(tokenUriPrefix, genome[_tokenId]);
574     }
575 
576     /**
577     * @dev Gets the token ID at a given index of the tokens list of the requested owner
578     * @param _owner address owning the tokens list to be accessed
579     * @param _index uint256 representing the index to be accessed of the requested tokens list
580     * @return uint256 token ID at the given index of the tokens list owned by the requested address
581     */
582     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
583         require(_index < balanceOf(_owner));
584         return ownedTokens[_owner][_index];
585     }
586 
587     /**
588     * @dev Gets the total amount of tokens stored by the contract
589     * @return uint256 representing the total amount of tokens
590     */
591     function totalSupply() public view returns (uint256) {
592         return allTokens.length;
593     }
594 
595     /**
596     * @dev Gets the token ID at a given index of all the tokens in this contract
597     * @dev Reverts if the index is greater or equal to the total number of tokens
598     * @param _index uint256 representing the index to be accessed of the tokens list
599     * @return uint256 token ID at the given index of the tokens list
600     */
601     function tokenByIndex(uint256 _index) public view returns (uint256) {
602         require(_index < totalSupply());
603         return allTokens[_index];
604     }
605 
606     /**
607     * @dev Internal function to add a token ID to the list of a given address
608     * @param _to address representing the new owner of the given token ID
609     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
610     */
611     function addTokenTo(address _to, uint256 _tokenId) internal {
612         super.addTokenTo(_to, _tokenId);
613         uint256 length = ownedTokens[_to].length;
614         ownedTokens[_to].push(_tokenId);
615         ownedTokensIndex[_tokenId] = length;
616 
617         if (activeHero[_to] == 0) {
618             activeHero[_to] = _tokenId;
619             emit ActiveHeroChanged(_to, _tokenId);
620         }
621     }
622 
623     /**
624     * @dev Internal function to remove a token ID from the list of a given address
625     * @param _from address representing the previous owner of the given token ID
626     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
627     */
628     function removeTokenFrom(address _from, uint256 _tokenId) internal {
629         super.removeTokenFrom(_from, _tokenId);
630 
631         uint256 tokenIndex = ownedTokensIndex[_tokenId];
632         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
633         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
634 
635         ownedTokens[_from][tokenIndex] = lastToken;
636         ownedTokens[_from][lastTokenIndex] = 0;
637         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
638         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
639         // the lastToken to the first position, and then dropping the element placed in the last position of the list
640 
641         ownedTokens[_from].length--;
642         ownedTokensIndex[_tokenId] = 0;
643         ownedTokensIndex[lastToken] = tokenIndex;
644 
645         // If a hero is removed from its owner, it no longer can be their active hero
646         if (activeHero[_from] == _tokenId) {
647             activeHero[_from] = 0;
648             emit ActiveHeroChanged(_from, 0);
649         }
650     }
651 
652     /**
653     * @dev Internal function to mint a new token
654     * @dev Reverts if the given token ID already exists
655     * @param _to address the beneficiary that will own the minted token
656     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
657     */
658     function _mint(address _to, uint256 _tokenId) internal {
659         require(_to != address(0));
660         addTokenTo(_to, _tokenId);
661         emit Transfer(address(0), _to, _tokenId);
662 
663         allTokensIndex[_tokenId] = allTokens.length;
664         allTokens.push(_tokenId);
665     }
666 
667     /**
668     * @dev External function to mint a new token
669     * @dev Reverts if the given token ID already exists
670     * @param _to address the beneficiary that will own the minted token
671     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
672     */
673     function mint(address _to, uint256 _tokenId) external onlyLogicContract {
674         _mint(_to, _tokenId);
675     }
676 
677     /**
678     * @dev Internal function to burn a specific token
679     * @dev Reverts if the token does not exist
680     * @param _owner owner of the token to burn
681     * @param _tokenId uint256 ID of the token being burned by the msg.sender
682     */
683     function _burn(address _owner, uint256 _tokenId) internal {
684         clearApproval(_owner, _tokenId);
685         removeTokenFrom(_owner, _tokenId);
686         emit Transfer(_owner, address(0), _tokenId);
687 
688         // Reorg all tokens array
689         uint256 tokenIndex = allTokensIndex[_tokenId];
690         uint256 lastTokenIndex = allTokens.length.sub(1);
691         uint256 lastToken = allTokens[lastTokenIndex];
692 
693         allTokens[tokenIndex] = lastToken;
694         allTokens[lastTokenIndex] = 0;
695 
696         allTokens.length--;
697         allTokensIndex[_tokenId] = 0;
698         allTokensIndex[lastToken] = tokenIndex;
699 
700         // Clear genome data
701         if (genome[_tokenId] != 0) {
702             genome[_tokenId] = 0;
703         }
704     }
705 
706     /**
707     * @dev External function to burn a specific token
708     * @dev Reverts if the token does not exist
709     * @param _owner owner of the token to burn
710     * @param _tokenId uint256 ID of the token being burned by the msg.sender
711     */
712     function burn(address _owner, uint256 _tokenId) external onlyLogicContract {
713         _burn(_owner, _tokenId);
714     }
715 
716     /**
717     * @dev Transfers the ownership of a given token ID to another address
718     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
719     * @dev Requires the msg sender to be the owner, approved, or operator
720     * @param _from current owner of the token
721     * @param _to address to receive the ownership of the given token ID
722     * @param _tokenId uint256 ID of the token to be transferred
723     */
724     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
725         require(_isTransferAllowed(_from, _to, _tokenId));
726         super.transferFrom(_from, _to, _tokenId);
727     }
728 
729     /**
730     * @dev Safely transfers the ownership of a given token ID to another address
731     * @dev If the target address is a contract, it must implement `onERC721Received`,
732     *  which is called upon a safe transfer, and return the magic value
733     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
734     *  the transfer is reverted.
735     * @dev Requires the msg sender to be the owner, approved, or operator
736     * @param _from current owner of the token
737     * @param _to address to receive the ownership of the given token ID
738     * @param _tokenId uint256 ID of the token to be transferred
739     */
740     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
741         public
742         canTransfer(_tokenId)
743     {
744         require(_isTransferAllowed(_from, _to, _tokenId));
745         super.safeTransferFrom(_from, _to, _tokenId);
746     }
747 
748     /**
749     * @dev Safely transfers the ownership of a given token ID to another address
750     * @dev If the target address is a contract, it must implement `onERC721Received`,
751     *  which is called upon a safe transfer, and return the magic value
752     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
753     *  the transfer is reverted.
754     * @dev Requires the msg sender to be the owner, approved, or operator
755     * @param _from current owner of the token
756     * @param _to address to receive the ownership of the given token ID
757     * @param _tokenId uint256 ID of the token to be transferred
758     * @param _data bytes data to send along with a safe transfer check
759     */
760     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)
761         public
762         canTransfer(_tokenId)
763     {
764         require(_isTransferAllowed(_from, _to, _tokenId));
765         super.safeTransferFrom(_from, _to, _tokenId, _data);
766     }
767 
768     /**
769     * @dev Allows to transfer a token to another owner
770     * @param _to transfer to
771     * @param _tokenId token to transfer
772     */
773     function transfer(address _to, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
774         require(_isTransferAllowed(msg.sender, _to, _tokenId));
775         require(_to != address(0));
776 
777         clearApproval(msg.sender, _tokenId);
778         removeTokenFrom(msg.sender, _tokenId);
779         addTokenTo(_to, _tokenId);
780 
781         emit Transfer(msg.sender, _to, _tokenId);
782     }
783 
784     /**
785     * @dev Sets the specified token as user's active Hero
786     * @param _tokenId the hero token to set as active
787     */
788     function setActiveHero(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
789         activeHero[msg.sender] = _tokenId;
790         emit ActiveHeroChanged(msg.sender, _tokenId);
791     }
792 
793     /**
794     * @dev Queries list of tokens owned by a specific address
795     * @param _owner the address to get tokens of
796     */
797     function tokensOfOwner(address _owner) external view returns (uint256[]) {
798         return ownedTokens[_owner];
799     }
800 
801     /**
802     * @dev Gets the genome of the active hero
803     * @param _owner the address to get hero of
804     */
805     function activeHeroGenome(address _owner) public view returns (uint256) {
806         uint256 tokenId = activeHero[_owner];
807         if (tokenId == 0) {
808             return 0;
809         }
810 
811         return genome[tokenId];
812     }
813 
814     /**
815     * @dev Increments uniqueness index. Overflow intentionally allowed.
816     */
817     function incrementUniquenessIndex() external onlyLogicContract {
818         uniquenessIndex ++;
819     }
820 
821     /**
822     * @dev Increments lastTokenId
823     */
824     function incrementLastTokenId() external onlyLogicContract {
825         lastTokenId ++;
826     }
827 
828     /**
829     * @dev Allows (re-)setting the uniqueness index
830     * @param _uniquenessIndex new value
831     */
832     function setUniquenessIndex(uint32 _uniquenessIndex) external onlyOwner {
833         uniquenessIndex = _uniquenessIndex;
834     }
835 
836     /**
837     * @dev Allows (re-)setting lastTokenId
838     * @param _lastTokenId new value
839     */
840     function setLastTokenId(uint256 _lastTokenId) external onlyOwner {
841         lastTokenId = _lastTokenId;
842     }
843 
844     /**
845     * @dev Allows setting hero data for a hero
846     * @param _tokenId hero to set data for
847     * @param _fieldA data to set
848     * @param _fieldB data to set
849     * @param _fieldC data to set
850     * @param _fieldD data to set
851     * @param _fieldE data to set
852     * @param _fieldF data to set
853     * @param _fieldG data to set
854     */
855     function setHeroData(
856         uint256 _tokenId,
857         uint16 _fieldA,
858         uint16 _fieldB,
859         uint32 _fieldC,
860         uint32 _fieldD,
861         uint32 _fieldE,
862         uint64 _fieldF,
863         uint64 _fieldG
864     ) external onlyLogicContract {
865         heroData[_tokenId] = HeroData(
866             _fieldA,
867             _fieldB,
868             _fieldC,
869             _fieldD,
870             _fieldE,
871             _fieldF,
872             _fieldG
873         );
874     }
875 
876     /**
877     * @dev Allows setting hero genome
878     * @param _tokenId token to set data for
879     * @param _genome genome data to set
880     */
881     function setGenome(uint256 _tokenId, uint256 _genome) external onlyLogicContract {
882         genome[_tokenId] = _genome;
883     }
884 
885     /**
886     * @dev Allows the admin to forcefully transfer a token from one address to another
887     * @param _from transfer from
888     * @param _to transfer to
889     * @param _tokenId token to transfer
890     */
891     function forceTransfer(address _from, address _to, uint256 _tokenId) external onlyLogicContract {
892         require(_from != address(0));
893         require(_to != address(0));
894 
895         clearApproval(_from, _tokenId);
896         removeTokenFrom(_from, _tokenId);
897         addTokenTo(_to, _tokenId);
898 
899         emit Transfer(_from, _to, _tokenId);
900     }
901 
902     /**
903     * @dev External function to set the token URI prefix for all tokens
904     * @param _uriPrefix prefix string to assign
905     */
906     function setTokenUriPrefix(string _uriPrefix) external onlyOwner {
907         tokenUriPrefix = _uriPrefix;
908     }
909 
910 
911 }