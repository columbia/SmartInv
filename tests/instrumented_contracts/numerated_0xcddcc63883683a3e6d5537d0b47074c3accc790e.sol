1 pragma solidity ^0.4.23;
2 
3 /************************************************
4  *
5  * Star Cards - Verifiably unique celebrity collectibles
6  * Authors: Dick Oranges & Eggy Bagelface
7  *
8  * MD5: 696fa8ba0f25d6d6f8391e37251736bc
9  * SHA256: ba3178b5d13ec7b05cf3ebaae2be797cc0eb6756eac455426f2b1d70f17cefae
10  *
11  ************************************************/
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19     /**
20      * @dev Multiplies two numbers, throws on overflow.
21      */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32      * @dev Integer division of two numbers, truncating the quotient.
33      */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50      * @dev Adds two numbers, throws on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 
60 /**
61  * Utility library of inline functions on addresses
62  */
63 library AddressUtils {
64 
65     /**
66      * Returns whether the target address is a contract
67      * @dev This function will return false if invoked during the constructor of a contract,
68      *  as the code is not actually created until after the constructor finishes.
69      * @param addr address to check
70      * @return whether the target address is a contract
71      */
72     function isContract(address addr) internal view returns (bool) {
73         uint256 size;
74         // XXX Currently there is no better way to check if there is a contract in an address
75         // than to check the size of the code at that address.
76         // See https://ethereum.stackexchange.com/a/14016/36603
77         // for more details about how this works.
78         // TODO Check this again before the Serenity release, because all addresses will be
79         // contracts then.
80         assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
81         return size > 0;
82     }
83 }
84 
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92     
93     address public owner;
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     /**
97      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98      * account.
99      */
100     constructor() public {
101         owner = msg.sender;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address newOwner) public onlyOwner {
117         require(newOwner != address(0));
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 }
122 
123 
124 /**
125  * @title ERC721 Non-Fungible Token Standard basic interface
126  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
127  */
128 contract ERC721Basic {
129     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
130     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
131     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
132 
133     function balanceOf(address _owner) public view returns (uint256 _balance);
134     function ownerOf(uint256 _tokenId) public view returns (address _owner);
135     function owned(uint256 _tokenId) public view returns (bool _owned);
136 
137     function approve(address _to, uint256 _tokenId) public;
138     function getApproved(uint256 _tokenId) public view returns (address _operator);
139 
140     function setApprovalForAll(address _operator, bool _approved) public;
141     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
142 
143     function transferFrom(address _from, address _to, uint256 _tokenId) public;
144     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
145     function safeTransferFrom(
146         address _from,
147         address _to,
148         uint256 _tokenId,
149         bytes _data
150     )
151         public;
152 }
153 
154 
155 /**
156  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
157  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
158  */
159 contract ERC721Enumerable is ERC721Basic {
160     function totalSupply() public view returns (uint256);
161     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
162     function tokenByIndex(uint256 _index) public view returns (uint256);
163 }
164 
165 
166 /**
167  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
168  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
169  */
170 contract ERC721Metadata is ERC721Basic {
171     function name() public view returns (string _name);
172     function symbol() public view returns (string _symbol);
173     function tokenURI(uint256 _tokenId) public view returns (string);
174 }
175 
176 
177 /**
178  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
179  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
180  */
181 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
182 }
183 
184 
185 pragma solidity ^0.4.21;
186 
187 
188 /**
189  * @title ERC721 token receiver interface
190  * @dev Interface for any contract that wants to support safeTransfers
191  *  from ERC721 asset contracts.
192  */
193 contract ERC721Receiver {
194     /**
195      * @dev Magic value to be returned upon successful reception of an NFT
196      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
197      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
198      */
199     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
200 
201     /**
202      * @notice Handle the receipt of an NFT
203      * @dev The ERC721 smart contract calls this function on the recipient
204      *  after a `safetransfer`. This function MAY throw to revert and reject the
205      *  transfer. This function MUST use 50,000 gas or less. Return of other
206      *  than the magic value MUST result in the transaction being reverted.
207      *  Note: the contract address is always the message sender.
208      * @param _from The sending address
209      * @param _tokenId The NFT identifier which is being transfered
210      * @param _data Additional data with no specified format
211      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
212      */
213     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
214 }
215 
216 
217 
218 /**
219  * @title ERC721 Non-Fungible Token Standard basic implementation
220  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
221  */
222 contract ERC721BasicToken is ERC721Basic {
223     using SafeMath for uint256;
224     using AddressUtils for address;
225 
226     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
227     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
228     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
229 
230     // Mapping from token ID to owner
231     mapping (uint256 => address) internal tokenOwner;
232 
233     // Mapping from token ID to approved address
234     mapping (uint256 => address) internal tokenApprovals;
235 
236     // Mapping from owner to number of owned token
237     mapping (address => uint256) internal ownedTokensCount;
238 
239     // Mapping from owner to operator approvals
240     mapping (address => mapping (address => bool)) internal operatorApprovals;
241 
242     /**
243      * @dev Guarantees msg.sender is owner of the given token
244      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
245      */
246     modifier onlyOwnerOf(uint256 _tokenId) {
247         require(ownerOf(_tokenId) == msg.sender);
248         _;
249     }
250 
251     /**
252      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
253      * @param _tokenId uint256 ID of the token to validate
254      */
255     modifier canTransfer(uint256 _tokenId) {
256         require(isApprovedOrOwner(msg.sender, _tokenId));
257         _;
258     }
259 
260     /**
261      * @dev Gets the balance of the specified address
262      * @param _owner address to query the balance of
263      * @return uint256 representing the amount owned by the passed address
264      */
265     function balanceOf(address _owner) public view returns (uint256) {
266         require(_owner != address(0));
267         return ownedTokensCount[_owner];
268     }
269 
270     /**
271      * @dev Gets the owner of the specified token ID
272      * @param _tokenId uint256 ID of the token to query the owner of
273      * @return owner address currently marked as the owner of the given token ID
274      */
275     function ownerOf(uint256 _tokenId) public view returns (address) {
276         address owner = tokenOwner[_tokenId];
277         require(owner != address(0));
278         return owner;
279     }
280 
281     /**
282      * @dev Returns whether the specified token is owned
283      * @param _tokenId uint256 ID of the token to query the existance of
284      * @return whether the token is owned
285      */
286     function owned(uint256 _tokenId) public view returns (bool) {
287         address owner = tokenOwner[_tokenId];
288         return owner != address(0);
289     }
290 
291     /**
292      * @dev Approves another address to transfer the given token ID
293      * @dev The zero address indicates there is no approved address.
294      * @dev There can only be one approved address per token at a given time.
295      * @dev Can only be called by the token owner or an approved operator.
296      * @param _to address to be approved for the given token ID
297      * @param _tokenId uint256 ID of the token to be approved
298      */
299     function approve(address _to, uint256 _tokenId) public {
300         address owner = ownerOf(_tokenId);
301         require(_to != owner);
302         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
303 
304         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
305             tokenApprovals[_tokenId] = _to;
306             emit Approval(owner, _to, _tokenId);
307         }
308     }
309 
310     /**
311      * @dev Gets the approved address for a token ID, or zero if no address set
312      * @param _tokenId uint256 ID of the token to query the approval of
313      * @return address currently approved for a the given token ID
314      */
315     function getApproved(uint256 _tokenId) public view returns (address) {
316         return tokenApprovals[_tokenId];
317     }
318 
319     /**
320      * @dev Sets or unsets the approval of a given operator
321      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
322      * @param _to operator address to set the approval
323      * @param _approved representing the status of the approval to be set
324      */
325     function setApprovalForAll(address _to, bool _approved) public {
326         require(_to != msg.sender);
327         operatorApprovals[msg.sender][_to] = _approved;
328         emit ApprovalForAll(msg.sender, _to, _approved);
329     }
330 
331     /**
332      * @dev Tells whether an operator is approved by a given owner
333      * @param _owner owner address which you want to query the approval of
334      * @param _operator operator address which you want to query the approval of
335      * @return bool whether the given operator is approved by the given owner
336      */
337     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
338         return operatorApprovals[_owner][_operator];
339     }
340 
341     /**
342      * @dev Transfers the ownership of a given token ID to another address
343      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
344      * @dev Requires the msg sender to be the owner, approved, or operator
345      * @param _from current owner of the token
346      * @param _to address to receive the ownership of the given token ID
347      * @param _tokenId uint256 ID of the token to be transferred
348      */
349     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
350         require(_from != address(0));
351         require(_to != address(0));
352 
353         clearApproval(_from, _tokenId);
354         removeTokenFrom(_from, _tokenId);
355         addTokenTo(_to, _tokenId);
356 
357         emit Transfer(_from, _to, _tokenId);
358     }
359 
360     /**
361      * @dev Safely transfers the ownership of a given token ID to another address
362      * @dev If the target address is a contract, it must implement `onERC721Received`,
363      *  which is called upon a safe transfer, and return the magic value
364      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
365      *  the transfer is reverted.
366      * @dev Requires the msg sender to be the owner, approved, or operator
367      * @param _from current owner of the token
368      * @param _to address to receive the ownership of the given token ID
369      * @param _tokenId uint256 ID of the token to be transferred
370      */
371     function safeTransferFrom(
372         address _from,
373         address _to,
374         uint256 _tokenId
375     )
376         public
377         canTransfer(_tokenId)
378     {
379         // solium-disable-next-line arg-overflow
380         safeTransferFrom(_from, _to, _tokenId, "");
381     }
382 
383     /**
384      * @dev Safely transfers the ownership of a given token ID to another address
385      * @dev If the target address is a contract, it must implement `onERC721Received`,
386      *  which is called upon a safe transfer, and return the magic value
387      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
388      *  the transfer is reverted.
389      * @dev Requires the msg sender to be the owner, approved, or operator
390      * @param _from current owner of the token
391      * @param _to address to receive the ownership of the given token ID
392      * @param _tokenId uint256 ID of the token to be transferred
393      * @param _data bytes data to send along with a safe transfer check
394      */
395     function safeTransferFrom(
396         address _from,
397         address _to,
398         uint256 _tokenId,
399         bytes _data
400     )
401         public
402         canTransfer(_tokenId)
403     {
404         transferFrom(_from, _to, _tokenId);
405         // solium-disable-next-line arg-overflow
406         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
407     }
408 
409     /**
410      * @dev Returns whether the given spender can transfer a given token ID
411      * @param _spender address of the spender to query
412      * @param _tokenId uint256 ID of the token to be transferred
413      * @return bool whether the msg.sender is approved for the given token ID,
414      *  is an operator of the owner, or is the owner of the token
415      */
416     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
417         address owner = ownerOf(_tokenId);
418         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
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
472         internal
473         returns (bool)
474     {
475         if (!_to.isContract()) {
476             return true;
477         }
478         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
479         return (retval == ERC721_RECEIVED);
480     }
481 }
482 
483 
484 /**
485  * @title Full ERC721 Token
486  * This implementation includes all the required and some optional functionality of the ERC721 standard
487  * Moreover, it includes approve all functionality using operator terminology
488  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
489  */
490 contract ERC721Token is ERC721, ERC721BasicToken {
491 
492     // Token name
493     string internal name_;
494 
495     // Token symbol
496     string internal symbol_;
497 
498     // Token supply
499     uint256 internal totalSupply_;
500 
501     // Mapping from owner to list of owned token IDs
502     mapping (address => uint256[]) internal ownedTokens;
503 
504     // Mapping from token ID to index of the owner tokens list
505     mapping(uint256 => uint256) internal ownedTokensIndex;
506 
507     // Optional mapping for token URIs
508     mapping(uint256 => string) internal tokenURIs;
509 
510     /**
511      * @dev Constructor function
512      */
513     constructor(string _name, string _symbol, uint256 _totalSupply) public {
514         name_ = _name;
515         symbol_ = _symbol;
516         totalSupply_ = _totalSupply;
517     }
518 
519     /**
520      * @dev Gets the token name
521      * @return string representing the token name
522      */
523     function name() public view returns (string) {
524         return name_;
525     }
526 
527     /**
528      * @dev Gets the token symbol
529      * @return string representing the token symbol
530      */
531     function symbol() public view returns (string) {
532         return symbol_;
533     }
534 
535     /**
536      * @dev Returns an URI for a given token ID
537      * @dev Throws if the token is not owned. May return an empty string.
538      * @param _tokenId uint256 ID of the token to query
539      */
540     function tokenURI(uint256 _tokenId) public view returns (string) {
541         require(owned(_tokenId));
542         return tokenURIs[_tokenId];
543     }
544 
545     /**
546      * @dev Gets the total token supply
547      * @return uint256 representing the total token supply
548      */
549     function totalSupply() public view returns (uint256) {
550         return totalSupply_;
551     }
552 
553     /**
554      * @dev Internal function to set the token URI for a given token
555      * @dev Reverts if the token ID is not owned
556      * @param _tokenId uint256 ID of the token to set its URI
557      * @param _uri string URI to assign
558      */
559     function _setTokenURI(uint256 _tokenId, string _uri) internal {
560         require(owned(_tokenId));
561         tokenURIs[_tokenId] = _uri;
562     }
563 
564     /**
565      * @dev Gets the token ID at a given index of the tokens list of the requested owner
566      * @param _owner address owning the tokens list to be accessed
567      * @param _index uint256 representing the index to be accessed of the requested tokens list
568      * @return uint256 token ID at the given index of the tokens list owned by the requested address
569      */
570     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
571         require(_index < balanceOf(_owner));
572         return ownedTokens[_owner][_index];
573     }
574 
575     /**
576      * @dev Gets the token ID at a given index of all the tokens in this contract
577      * @dev Reverts if the index is greater or equal to the total number of tokens
578      * @param _index uint256 representing the index to be accessed of the tokens list
579      * @return uint256 token ID at the given index of the tokens list
580      */
581     function tokenByIndex(uint256 _index) public view returns (uint256) {
582         require(_index < totalSupply());
583         return _index;
584     }
585 
586     /**
587      * @dev Internal function to add a token ID to the list of a given address
588      * @param _to address representing the new owner of the given token ID
589      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
590      */
591     function addTokenTo(address _to, uint256 _tokenId) internal {
592         super.addTokenTo(_to, _tokenId);
593         uint256 length = ownedTokens[_to].length;
594         ownedTokens[_to].push(_tokenId);
595         ownedTokensIndex[_tokenId] = length;
596     }
597 
598     /**
599      * @dev Internal function to remove a token ID from the list of a given address
600      * @param _from address representing the previous owner of the given token ID
601      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
602      */
603     function removeTokenFrom(address _from, uint256 _tokenId) internal {
604         super.removeTokenFrom(_from, _tokenId);
605 
606         uint256 tokenIndex = ownedTokensIndex[_tokenId];
607         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
608         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
609 
610         ownedTokens[_from][tokenIndex] = lastToken;
611         ownedTokens[_from][lastTokenIndex] = 0;
612         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
613         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
614         // the lastToken to the first position, and then dropping the element placed in the last position of the list
615 
616         ownedTokens[_from].length--;
617         ownedTokensIndex[_tokenId] = 0;
618         ownedTokensIndex[lastToken] = tokenIndex;
619     }
620 }
621 
622 contract ERC165 {
623 
624     bytes4 constant ERC165InterfaceId = bytes4(keccak256("supportsInterface(bytes4)"));
625     bytes4 constant ERC721InterfaceId = 0x80ac58cd;
626     bytes4 constant ERC721EnumerableInterfaceId = 0x780e9d63;
627     bytes4 constant ERC721MetadataInterfaceId = 0x5b5e139f;
628     bytes4 constant ERC721TokenReceiverInterfaceId = 0xf0b9e5ba;
629 
630     /// @notice Query if a contract implements an interface
631     /// @param interfaceID The interface identifier, as specified in ERC-165
632     /// @dev Interface identification is specified in ERC-165. This function
633     ///  uses less than 30,000 gas.
634     /// @return `true` if the contract implements `interfaceID` and
635     ///  `interfaceID` is not 0xffffffff, `false` otherwise
636     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
637         return
638             ((interfaceID == ERC165InterfaceId) ||
639             (interfaceID == ERC721InterfaceId) ||
640             (interfaceID == ERC721EnumerableInterfaceId) ||
641             (interfaceID == ERC721MetadataInterfaceId) ||
642             (interfaceID == ERC721TokenReceiverInterfaceId));
643     }
644 }
645 
646 contract StarCards is Ownable, ERC721Token, ERC165 {
647 
648     // The card database can be verified using these checksums.
649     string constant public dataset_md5checksum = "696fa8ba0f25d6d6f8391e37251736bc";
650     string constant public dataset_sha256checksum = "ba3178b5d13ec7b05cf3ebaae2be797cc0eb6756eac455426f2b1d70f17cefae";
651 
652     // The card database can be downloaded at this URL.
653     string public databaseDownloadUrl = "ftp://starcards.my/starCardsDataset.json";
654     
655     uint256 constant public editionSize = 345;
656     uint256 constant public minimumBid = 0.001 ether;
657     uint256 constant public timeBetweenEditions = 1 days;
658     uint256 constant public initializationDelay = 3 days;
659 
660     struct ReleaseAuction {
661         Bid highestBid;
662         uint additionalTime;
663         bool completed;
664     }
665 
666     struct Bid {
667         uint value;
668         uint timePlaced;
669         address bidder;
670     }
671 
672     event NewBid(uint id, uint value, uint timePlaced, address bidder);
673 
674     mapping(address => uint) public pendingWithdrawals;
675     mapping(uint => ReleaseAuction) releaseAuctions;
676 
677     uint256 public contractInitializationTime;
678 
679     constructor() ERC721Token("Star Cards", "STAR", 586155) public payable {
680         owner = msg.sender;
681         contractInitializationTime = now + initializationDelay;
682     }
683 
684     function setDatabaseDownloadUrl(string url) public onlyOwner {
685         databaseDownloadUrl = url;
686     }
687 
688     function getCurrentEdition() public view returns (uint256) {
689         uint256 secondsSinceContractInitialization = SafeMath.sub(now, contractInitializationTime);
690         return SafeMath.div(secondsSinceContractInitialization, timeBetweenEditions);
691     }
692 
693     function getEditionReleaseTime(uint edition) public view returns (uint256) {
694         return SafeMath.add(contractInitializationTime, (SafeMath.mul(edition, timeBetweenEditions)));
695     }
696 
697     function getEdition(uint id) public view onlyValidTokenIds(id) returns (uint256) {
698         return SafeMath.div(id, editionSize);
699     }
700 
701     function isReleased(uint id) public view onlyValidTokenIds(id) returns (bool) {
702         return getEdition(id) <= getCurrentEdition();
703     }
704 
705     function getReleaseAuctionEndTime(uint id) public view onlyValidTokenIds(id) returns (uint) {
706         uint256 timeFromRelease = SafeMath.add(timeBetweenEditions, releaseAuctions[id].additionalTime);
707         return SafeMath.add(getEditionReleaseTime(getEdition(id)), timeFromRelease);
708     }
709 
710     function releaseAuctionEnded(uint id) public view onlyValidTokenIds(id) returns (bool) {
711         return (isReleased(id) && (getReleaseAuctionEndTime(id) < now));
712     }
713 
714     function getHighestBidder(uint id) public view onlyValidTokenIds(id) returns (address) {
715         return releaseAuctions[id].highestBid.bidder;
716     }
717 
718     function getHighestBid(uint id) public view onlyValidTokenIds(id) returns (uint) {
719         return releaseAuctions[id].highestBid.value;
720     }
721 
722     function getAdditionalTime(uint id) public view onlyValidTokenIds(id) returns (uint) {
723         return releaseAuctions[id].additionalTime;
724     }
725 
726     function getRemainingTime(uint id) public view onlyValidTokenIds(id) returns (uint) {
727         uint endTime = getReleaseAuctionEndTime(id);
728         if (endTime > now) {
729             return SafeMath.sub(endTime, now);
730         } else {
731             return 0;
732         }
733     }
734 
735     function getAllTokens(address owner) public view returns (uint[]) {
736         uint size = ownedTokens[owner].length;
737         uint[] memory result = new uint[](size);
738         for (uint i = 0; i < size; i++) {
739             result[i] = ownedTokens[owner][i];
740         }
741         return result;
742     }
743 
744     // Complete the release auction.
745     function completeReleaseAuction(uint id) payable external onlyReleasedTokens(id) {
746 
747         require(releaseAuctionEnded(id));
748 
749         ReleaseAuction storage auction = releaseAuctions[id];
750 
751         require(!auction.completed);
752 
753         address newOwner;
754         uint payout;
755 
756         if (auction.highestBid.bidder == address(0)) {
757             require(msg.value >= minimumBid);
758             newOwner = msg.sender;
759             payout = msg.value;
760         } else {
761             newOwner = auction.highestBid.bidder;
762             payout = auction.highestBid.value;
763         }
764 
765         addTokenTo(newOwner, id);
766 
767         pendingWithdrawals[owner] = SafeMath.add(pendingWithdrawals[owner], payout);
768 
769         auction.completed = true;
770     }
771 
772     // Place a bid on an active auction.
773     function placeBid(uint id) payable external onlyReleasedTokens(id) {
774 
775         require(!releaseAuctionEnded(id)); // Ensure release auction has not expired.
776 
777         ReleaseAuction storage auction = releaseAuctions[id];
778 
779         // Ensure new bid is greater than or equal to current bid plus minimum bid increase.
780         require(msg.value >= auction.highestBid.value + minimumBid);
781 
782         // Reset auction timeout.
783         auction.additionalTime = SafeMath.add(auction.additionalTime, timeBetweenEditions - getRemainingTime(id));
784 
785         // Refund previous bidder if there is one.
786         if (auction.highestBid.bidder != address(0)) {
787             pendingWithdrawals[auction.highestBid.bidder] = SafeMath.add(pendingWithdrawals[auction.highestBid.bidder], auction.highestBid.value);
788         }
789 
790         // Update highest bid.
791         auction.highestBid = Bid(msg.value, now, msg.sender);
792 
793         emit NewBid(id, msg.value, now, msg.sender);
794     }
795 
796     // Withdraw a bid that was overbid.
797     function withdraw() external returns (bool) {
798         uint amount = pendingWithdrawals[msg.sender];
799         if (amount > 0) {
800             // It is important to set this to zero because the recipient
801             // can call this function again as part of the receiving call
802             // before `send` returns.
803             pendingWithdrawals[msg.sender] = 0;
804 
805             if (!msg.sender.send(amount)) {
806                 // No need to call throw here, just reset the amount owing
807                 pendingWithdrawals[msg.sender] = amount;
808                 return false;
809             }
810         }
811         return true;
812     }
813 
814     // Token must be released to execute
815     modifier onlyReleasedTokens(uint id) {
816         require(isReleased(id));
817         _;
818     }
819 
820     // Token id must be in range
821     modifier onlyValidTokenIds(uint id) {
822         require(id < totalSupply());
823         _;
824     }
825   
826     function() external payable {
827         revert();
828     }
829 }