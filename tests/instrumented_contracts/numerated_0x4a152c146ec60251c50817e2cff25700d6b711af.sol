1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipRenounced(address indexed previousOwner);
15     event OwnershipTransferred(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20 
21     /**
22      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23      * account.
24      */
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**
38      * @dev Allows the current owner to relinquish control of the contract.
39      */
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipRenounced(owner);
42         owner = address(0);
43     }
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to a newOwner.
47      * @param _newOwner The address to transfer ownership to.
48      */
49     function transferOwnership(address _newOwner) public onlyOwner {
50         _transferOwnership(_newOwner);
51     }
52 
53     /**
54      * @dev Transfers control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57     function _transferOwnership(address _newOwner) internal {
58         require(_newOwner != address(0));
59         emit OwnershipTransferred(owner, _newOwner);
60         owner = _newOwner;
61     }
62 }
63 
64 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
65 
66 /**
67  * @title ERC721 Non-Fungible Token Standard basic interface
68  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
69  */
70 contract ERC721Basic {
71     event Transfer(
72         address indexed _from,
73         address indexed _to,
74         uint256 _tokenId
75     );
76     event Approval(
77         address indexed _owner,
78         address indexed _approved,
79         uint256 _tokenId
80     );
81     event ApprovalForAll(
82         address indexed _owner,
83         address indexed _operator,
84         bool _approved
85     );
86 
87     function balanceOf(address _owner) public view returns (uint256 _balance);
88     function ownerOf(uint256 _tokenId) public view returns (address _owner);
89     function exists(uint256 _tokenId) public view returns (bool _exists);
90 
91     function approve(address _to, uint256 _tokenId) public;
92     function getApproved(uint256 _tokenId)
93     public view returns (address _operator);
94 
95     function setApprovalForAll(address _operator, bool _approved) public;
96     function isApprovedForAll(address _owner, address _operator)
97     public view returns (bool);
98 
99     function transferFrom(address _from, address _to, uint256 _tokenId) public;
100     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
101     public;
102 
103     function safeTransferFrom(
104         address _from,
105         address _to,
106         uint256 _tokenId,
107         bytes _data
108     )
109     public;
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
113 
114 /**
115  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
116  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
117  */
118 contract ERC721Enumerable is ERC721Basic {
119     function totalSupply() public view returns (uint256);
120     function tokenOfOwnerByIndex(
121         address _owner,
122         uint256 _index
123     )
124     public
125     view
126     returns (uint256 _tokenId);
127 
128     function tokenByIndex(uint256 _index) public view returns (uint256);
129 }
130 
131 
132 /**
133  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
134  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
135  */
136 contract ERC721Metadata is ERC721Basic {
137     function name() public view returns (string _name);
138     function symbol() public view returns (string _symbol);
139     function tokenURI(uint256 _tokenId) public view returns (string);
140 }
141 
142 
143 /**
144  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
145  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
146  */
147 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
148 }
149 
150 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
151 
152 /**
153  * @title ERC721 token receiver interface
154  * @dev Interface for any contract that wants to support safeTransfers
155  *  from ERC721 asset contracts.
156  */
157 contract ERC721Receiver {
158     /**
159      * @dev Magic value to be returned upon successful reception of an NFT
160      *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
161      *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
162      */
163     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
164 
165     /**
166      * @notice Handle the receipt of an NFT
167      * @dev The ERC721 smart contract calls this function on the recipient
168      *  after a `safetransfer`. This function MAY throw to revert and reject the
169      *  transfer. This function MUST use 50,000 gas or less. Return of other
170      *  than the magic value MUST result in the transaction being reverted.
171      *  Note: the contract address is always the message sender.
172      * @param _from The sending address
173      * @param _tokenId The NFT identifier which is being transfered
174      * @param _data Additional data with no specified format
175      * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
176      */
177     function onERC721Received(
178         address _from,
179         uint256 _tokenId,
180         bytes _data
181     )
182     public
183     returns(bytes4);
184 }
185 
186 // File: zeppelin-solidity/contracts/math/SafeMath.sol
187 
188 /**
189  * @title SafeMath
190  * @dev Math operations with safety checks that throw on error
191  */
192 library SafeMath {
193 
194     /**
195     * @dev Multiplies two numbers, throws on overflow.
196     */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
198         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         c = a * b;
206         assert(c / a == b);
207         return c;
208     }
209 
210     /**
211     * @dev Integer division of two numbers, truncating the quotient.
212     */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         // assert(b > 0); // Solidity automatically throws when dividing by 0
215         // uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217         return a / b;
218     }
219 
220     /**
221     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
222     */
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         assert(b <= a);
225         return a - b;
226     }
227 
228     /**
229     * @dev Adds two numbers, throws on overflow.
230     */
231     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
232         c = a + b;
233         assert(c >= a);
234         return c;
235     }
236 }
237 
238 // File: zeppelin-solidity/contracts/AddressUtils.sol
239 
240 /**
241  * Utility library of inline functions on addresses
242  */
243 library AddressUtils {
244 
245     /**
246      * Returns whether the target address is a contract
247      * @dev This function will return false if invoked during the constructor of a contract,
248      *  as the code is not actually created until after the constructor finishes.
249      * @param addr address to check
250      * @return whether the target address is a contract
251      */
252     function isContract(address addr) internal view returns (bool) {
253         uint256 size;
254         // XXX Currently there is no better way to check if there is a contract in an address
255         // than to check the size of the code at that address.
256         // See https://ethereum.stackexchange.com/a/14016/36603
257         // for more details about how this works.
258         // TODO Check this again before the Serenity release, because all addresses will be
259         // contracts then.
260         // solium-disable-next-line security/no-inline-assembly
261         assembly { size := extcodesize(addr) }
262         return size > 0;
263     }
264 
265 }
266 
267 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
268 
269 /**
270  * @title ERC721 Non-Fungible Token Standard basic implementation
271  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
272  */
273 contract ERC721BasicToken is ERC721Basic {
274     using SafeMath for uint256;
275     using AddressUtils for address;
276 
277     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
278     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
279     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
280 
281     // Mapping from token ID to owner
282     mapping (uint256 => address) internal tokenOwner;
283 
284     // Mapping from token ID to approved address
285     mapping (uint256 => address) internal tokenApprovals;
286 
287     // Mapping from owner to number of owned token
288     mapping (address => uint256) internal ownedTokensCount;
289 
290     // Mapping from owner to operator approvals
291     mapping (address => mapping (address => bool)) internal operatorApprovals;
292 
293     /**
294      * @dev Guarantees msg.sender is owner of the given token
295      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
296      */
297     modifier onlyOwnerOf(uint256 _tokenId) {
298         require(ownerOf(_tokenId) == msg.sender);
299         _;
300     }
301 
302     /**
303      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
304      * @param _tokenId uint256 ID of the token to validate
305      */
306     modifier canTransfer(uint256 _tokenId) {
307         require(isApprovedOrOwner(msg.sender, _tokenId));
308         _;
309     }
310 
311     /**
312      * @dev Gets the balance of the specified address
313      * @param _owner address to query the balance of
314      * @return uint256 representing the amount owned by the passed address
315      */
316     function balanceOf(address _owner) public view returns (uint256) {
317         require(_owner != address(0));
318         return ownedTokensCount[_owner];
319     }
320 
321     /**
322      * @dev Gets the owner of the specified token ID
323      * @param _tokenId uint256 ID of the token to query the owner of
324      * @return owner address currently marked as the owner of the given token ID
325      */
326     function ownerOf(uint256 _tokenId) public view returns (address) {
327         address owner = tokenOwner[_tokenId];
328         require(owner != address(0));
329         return owner;
330     }
331 
332     /**
333      * @dev Returns whether the specified token exists
334      * @param _tokenId uint256 ID of the token to query the existence of
335      * @return whether the token exists
336      */
337     function exists(uint256 _tokenId) public view returns (bool) {
338         address owner = tokenOwner[_tokenId];
339         return owner != address(0);
340     }
341 
342     /**
343      * @dev Approves another address to transfer the given token ID
344      * @dev The zero address indicates there is no approved address.
345      * @dev There can only be one approved address per token at a given time.
346      * @dev Can only be called by the token owner or an approved operator.
347      * @param _to address to be approved for the given token ID
348      * @param _tokenId uint256 ID of the token to be approved
349      */
350     function approve(address _to, uint256 _tokenId) public {
351         address owner = ownerOf(_tokenId);
352         require(_to != owner);
353         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
354 
355         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
356             tokenApprovals[_tokenId] = _to;
357             emit Approval(owner, _to, _tokenId);
358         }
359     }
360 
361     /**
362      * @dev Gets the approved address for a token ID, or zero if no address set
363      * @param _tokenId uint256 ID of the token to query the approval of
364      * @return address currently approved for the given token ID
365      */
366     function getApproved(uint256 _tokenId) public view returns (address) {
367         return tokenApprovals[_tokenId];
368     }
369 
370     /**
371      * @dev Sets or unsets the approval of a given operator
372      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
373      * @param _to operator address to set the approval
374      * @param _approved representing the status of the approval to be set
375      */
376     function setApprovalForAll(address _to, bool _approved) public {
377         require(_to != msg.sender);
378         operatorApprovals[msg.sender][_to] = _approved;
379         emit ApprovalForAll(msg.sender, _to, _approved);
380     }
381 
382     /**
383      * @dev Tells whether an operator is approved by a given owner
384      * @param _owner owner address which you want to query the approval of
385      * @param _operator operator address which you want to query the approval of
386      * @return bool whether the given operator is approved by the given owner
387      */
388     function isApprovedForAll(
389         address _owner,
390         address _operator
391     )
392     public
393     view
394     returns (bool)
395     {
396         return operatorApprovals[_owner][_operator];
397     }
398 
399     /**
400      * @dev Transfers the ownership of a given token ID to another address
401      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
402      * @dev Requires the msg sender to be the owner, approved, or operator
403      * @param _from current owner of the token
404      * @param _to address to receive the ownership of the given token ID
405      * @param _tokenId uint256 ID of the token to be transferred
406     */
407     function transferFrom(
408         address _from,
409         address _to,
410         uint256 _tokenId
411     )
412     public
413     canTransfer(_tokenId)
414     {
415         require(_from != address(0));
416         require(_to != address(0));
417 
418         clearApproval(_from, _tokenId);
419         removeTokenFrom(_from, _tokenId);
420         addTokenTo(_to, _tokenId);
421 
422         emit Transfer(_from, _to, _tokenId);
423     }
424 
425     /**
426      * @dev Safely transfers the ownership of a given token ID to another address
427      * @dev If the target address is a contract, it must implement `onERC721Received`,
428      *  which is called upon a safe transfer, and return the magic value
429      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
430      *  the transfer is reverted.
431      * @dev Requires the msg sender to be the owner, approved, or operator
432      * @param _from current owner of the token
433      * @param _to address to receive the ownership of the given token ID
434      * @param _tokenId uint256 ID of the token to be transferred
435     */
436     function safeTransferFrom(
437         address _from,
438         address _to,
439         uint256 _tokenId
440     )
441     public
442     canTransfer(_tokenId)
443     {
444         // solium-disable-next-line arg-overflow
445         safeTransferFrom(_from, _to, _tokenId, "");
446     }
447 
448     /**
449      * @dev Safely transfers the ownership of a given token ID to another address
450      * @dev If the target address is a contract, it must implement `onERC721Received`,
451      *  which is called upon a safe transfer, and return the magic value
452      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
453      *  the transfer is reverted.
454      * @dev Requires the msg sender to be the owner, approved, or operator
455      * @param _from current owner of the token
456      * @param _to address to receive the ownership of the given token ID
457      * @param _tokenId uint256 ID of the token to be transferred
458      * @param _data bytes data to send along with a safe transfer check
459      */
460     function safeTransferFrom(
461         address _from,
462         address _to,
463         uint256 _tokenId,
464         bytes _data
465     )
466     public
467     canTransfer(_tokenId)
468     {
469         transferFrom(_from, _to, _tokenId);
470         // solium-disable-next-line arg-overflow
471         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
472     }
473 
474     /**
475      * @dev Returns whether the given spender can transfer a given token ID
476      * @param _spender address of the spender to query
477      * @param _tokenId uint256 ID of the token to be transferred
478      * @return bool whether the msg.sender is approved for the given token ID,
479      *  is an operator of the owner, or is the owner of the token
480      */
481     function isApprovedOrOwner(
482         address _spender,
483         uint256 _tokenId
484     )
485     internal
486     view
487     returns (bool)
488     {
489         address owner = ownerOf(_tokenId);
490         // Disable solium check because of
491         // https://github.com/duaraghav8/Solium/issues/175
492         // solium-disable-next-line operator-whitespace
493         return (
494         _spender == owner ||
495         getApproved(_tokenId) == _spender ||
496         isApprovedForAll(owner, _spender)
497         );
498     }
499 
500     /**
501      * @dev Internal function to mint a new token
502      * @dev Reverts if the given token ID already exists
503      * @param _to The address that will own the minted token
504      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
505      */
506     function _mint(address _to, uint256 _tokenId) internal {
507         require(_to != address(0));
508         addTokenTo(_to, _tokenId);
509         emit Transfer(address(0), _to, _tokenId);
510     }
511 
512     /**
513      * @dev Internal function to burn a specific token
514      * @dev Reverts if the token does not exist
515      * @param _tokenId uint256 ID of the token being burned by the msg.sender
516      */
517     function _burn(address _owner, uint256 _tokenId) internal {
518         clearApproval(_owner, _tokenId);
519         removeTokenFrom(_owner, _tokenId);
520         emit Transfer(_owner, address(0), _tokenId);
521     }
522 
523     /**
524      * @dev Internal function to clear current approval of a given token ID
525      * @dev Reverts if the given address is not indeed the owner of the token
526      * @param _owner owner of the token
527      * @param _tokenId uint256 ID of the token to be transferred
528      */
529     function clearApproval(address _owner, uint256 _tokenId) internal {
530         require(ownerOf(_tokenId) == _owner);
531         if (tokenApprovals[_tokenId] != address(0)) {
532             tokenApprovals[_tokenId] = address(0);
533             emit Approval(_owner, address(0), _tokenId);
534         }
535     }
536 
537     /**
538      * @dev Internal function to add a token ID to the list of a given address
539      * @param _to address representing the new owner of the given token ID
540      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
541      */
542     function addTokenTo(address _to, uint256 _tokenId) internal {
543         require(tokenOwner[_tokenId] == address(0));
544         tokenOwner[_tokenId] = _to;
545         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
546     }
547 
548     /**
549      * @dev Internal function to remove a token ID from the list of a given address
550      * @param _from address representing the previous owner of the given token ID
551      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
552      */
553     function removeTokenFrom(address _from, uint256 _tokenId) internal {
554         require(ownerOf(_tokenId) == _from);
555         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
556         tokenOwner[_tokenId] = address(0);
557     }
558 
559     /**
560      * @dev Internal function to invoke `onERC721Received` on a target address
561      * @dev The call is not executed if the target address is not a contract
562      * @param _from address representing the previous owner of the given token ID
563      * @param _to target address that will receive the tokens
564      * @param _tokenId uint256 ID of the token to be transferred
565      * @param _data bytes optional data to send along with the call
566      * @return whether the call correctly returned the expected magic value
567      */
568     function checkAndCallSafeTransfer(
569         address _from,
570         address _to,
571         uint256 _tokenId,
572         bytes _data
573     )
574     internal
575     returns (bool)
576     {
577         if (!_to.isContract()) {
578             return true;
579         }
580         bytes4 retval = ERC721Receiver(_to).onERC721Received(
581             _from, _tokenId, _data);
582         return (retval == ERC721_RECEIVED);
583     }
584 }
585 
586 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
587 
588 /**
589  * @title Full ERC721 Token
590  * This implementation includes all the required and some optional functionality of the ERC721 standard
591  * Moreover, it includes approve all functionality using operator terminology
592  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
593  */
594 contract ERC721Token is ERC721, ERC721BasicToken {
595     // Token name
596     string internal name_;
597 
598     // Token symbol
599     string internal symbol_;
600 
601     // Mapping from owner to list of owned token IDs
602     mapping(address => uint256[]) internal ownedTokens;
603 
604     // Mapping from token ID to index of the owner tokens list
605     mapping(uint256 => uint256) internal ownedTokensIndex;
606 
607     // Array with all token ids, used for enumeration
608     uint256[] internal allTokens;
609 
610     // Mapping from token id to position in the allTokens array
611     mapping(uint256 => uint256) internal allTokensIndex;
612 
613     // Optional mapping for token URIs
614     mapping(uint256 => string) internal tokenURIs;
615 
616     /**
617      * @dev Constructor function
618      */
619     constructor(string _name, string _symbol) public {
620         name_ = _name;
621         symbol_ = _symbol;
622     }
623 
624     /**
625      * @dev Gets the token name
626      * @return string representing the token name
627      */
628     function name() public view returns (string) {
629         return name_;
630     }
631 
632     /**
633      * @dev Gets the token symbol
634      * @return string representing the token symbol
635      */
636     function symbol() public view returns (string) {
637         return symbol_;
638     }
639 
640     /**
641      * @dev Returns an URI for a given token ID
642      * @dev Throws if the token ID does not exist. May return an empty string.
643      * @param _tokenId uint256 ID of the token to query
644      */
645     function tokenURI(uint256 _tokenId) public view returns (string) {
646         require(exists(_tokenId));
647         return tokenURIs[_tokenId];
648     }
649 
650     /**
651      * @dev Gets the token ID at a given index of the tokens list of the requested owner
652      * @param _owner address owning the tokens list to be accessed
653      * @param _index uint256 representing the index to be accessed of the requested tokens list
654      * @return uint256 token ID at the given index of the tokens list owned by the requested address
655      */
656     function tokenOfOwnerByIndex(
657         address _owner,
658         uint256 _index
659     )
660     public
661     view
662     returns (uint256)
663     {
664         require(_index < balanceOf(_owner));
665         return ownedTokens[_owner][_index];
666     }
667 
668     /**
669      * @dev Gets the total amount of tokens stored by the contract
670      * @return uint256 representing the total amount of tokens
671      */
672     function totalSupply() public view returns (uint256) {
673         return allTokens.length;
674     }
675 
676     /**
677      * @dev Gets the token ID at a given index of all the tokens in this contract
678      * @dev Reverts if the index is greater or equal to the total number of tokens
679      * @param _index uint256 representing the index to be accessed of the tokens list
680      * @return uint256 token ID at the given index of the tokens list
681      */
682     function tokenByIndex(uint256 _index) public view returns (uint256) {
683         require(_index < totalSupply());
684         return allTokens[_index];
685     }
686 
687     /**
688      * @dev Internal function to set the token URI for a given token
689      * @dev Reverts if the token ID does not exist
690      * @param _tokenId uint256 ID of the token to set its URI
691      * @param _uri string URI to assign
692      */
693     function _setTokenURI(uint256 _tokenId, string _uri) internal {
694         require(exists(_tokenId));
695         tokenURIs[_tokenId] = _uri;
696     }
697 
698     /**
699      * @dev Internal function to add a token ID to the list of a given address
700      * @param _to address representing the new owner of the given token ID
701      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
702      */
703     function addTokenTo(address _to, uint256 _tokenId) internal {
704         super.addTokenTo(_to, _tokenId);
705         uint256 length = ownedTokens[_to].length;
706         ownedTokens[_to].push(_tokenId);
707         ownedTokensIndex[_tokenId] = length;
708     }
709 
710     /**
711      * @dev Internal function to remove a token ID from the list of a given address
712      * @param _from address representing the previous owner of the given token ID
713      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
714      */
715     function removeTokenFrom(address _from, uint256 _tokenId) internal {
716         super.removeTokenFrom(_from, _tokenId);
717 
718         uint256 tokenIndex = ownedTokensIndex[_tokenId];
719         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
720         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
721 
722         ownedTokens[_from][tokenIndex] = lastToken;
723         ownedTokens[_from][lastTokenIndex] = 0;
724         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
725         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
726         // the lastToken to the first position, and then dropping the element placed in the last position of the list
727 
728         ownedTokens[_from].length--;
729         ownedTokensIndex[_tokenId] = 0;
730         ownedTokensIndex[lastToken] = tokenIndex;
731     }
732 
733     /**
734      * @dev Internal function to mint a new token
735      * @dev Reverts if the given token ID already exists
736      * @param _to address the beneficiary that will own the minted token
737      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
738      */
739     function _mint(address _to, uint256 _tokenId) internal {
740         super._mint(_to, _tokenId);
741 
742         allTokensIndex[_tokenId] = allTokens.length;
743         allTokens.push(_tokenId);
744     }
745 
746     /**
747      * @dev Internal function to burn a specific token
748      * @dev Reverts if the token does not exist
749      * @param _owner owner of the token to burn
750      * @param _tokenId uint256 ID of the token being burned by the msg.sender
751      */
752     function _burn(address _owner, uint256 _tokenId) internal {
753         super._burn(_owner, _tokenId);
754 
755         // Clear metadata (if any)
756         if (bytes(tokenURIs[_tokenId]).length != 0) {
757             delete tokenURIs[_tokenId];
758         }
759 
760         // Reorg all tokens array
761         uint256 tokenIndex = allTokensIndex[_tokenId];
762         uint256 lastTokenIndex = allTokens.length.sub(1);
763         uint256 lastToken = allTokens[lastTokenIndex];
764 
765         allTokens[tokenIndex] = lastToken;
766         allTokens[lastTokenIndex] = 0;
767 
768         allTokens.length--;
769         allTokensIndex[_tokenId] = 0;
770         allTokensIndex[lastToken] = tokenIndex;
771     }
772 
773 }
774 
775 // File: contracts/MTArtefact.sol
776 
777 contract TVCrowdsale {
778     uint256 public currentRate;
779     function buyTokens(address _beneficiary) public payable;
780 }
781 
782 contract TVToken {
783     function transfer(address _to, uint256 _value) public returns (bool);
784     function safeTransfer(address _to, uint256 _value, bytes _data) public;
785 }
786 
787 contract MTArtefact is Ownable, ERC721Token {
788 
789     address public wallet;
790     address public TVTokenAddress;
791     address public TVCrowdsaleAddress;
792     uint public typesCount;
793 
794     uint internal incrementId = 0;
795     address internal checkAndBuySender;
796     bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
797 
798     modifier onlyOwnerOrManager() {
799         require(msg.sender == owner || manager == msg.sender);
800         _;
801     }
802 
803     struct Artefact {
804         uint id;
805         uint typeId;
806     }
807 
808     struct ArtefactPack {
809         uint id;
810         string name;
811         uint count;
812         uint price;
813         bool disabled;
814         bool created;
815     }
816 
817     address public manager;
818     mapping(uint => Artefact) public artefacts;
819     mapping(uint => ArtefactPack) public packs;
820 
821     event TokenReceived(address from, uint value, bytes data, uint packId);
822     event ChangeAndBuyPack(address buyer, uint rate, uint price, uint packId);
823 
824     constructor(
825         address _TVTokenAddress,
826         address _TVCrowdsaleAddress,
827         address _manager,
828         address _wallet,
829         uint _typesCount) public ERC721Token("MTArtefact Token", "MTAT") {
830 
831         manager = _manager;
832         wallet = _wallet;
833         TVTokenAddress = _TVTokenAddress;
834         TVCrowdsaleAddress = _TVCrowdsaleAddress;
835         typesCount = _typesCount;
836     }
837 
838     function mint(address to, uint typeId) public onlyOwnerOrManager {
839         incrementId++;
840         super._mint(to, incrementId);
841         artefacts[incrementId] = Artefact(incrementId, typeId);
842     }
843 
844     function burn(uint tokenId) public onlyOwnerOf(tokenId) {
845         super._burn(msg.sender, tokenId);
846         delete artefacts[tokenId];
847     }
848 
849     function setPack(uint id, string name, uint count, uint price, bool disabled) public onlyOwnerOrManager {
850         packs[id].name = name;
851         packs[id].count = count;
852         packs[id].price = price;
853         packs[id].disabled = disabled;
854         packs[id].created = true;
855     }
856 
857     function setTypesCount(uint _typesCount) public onlyOwnerOrManager {
858         typesCount = _typesCount;
859     }
860 
861     function openPack(uint packId, address to) internal {
862         uint count = packs[packId].count;
863 
864         for (uint i = 0; i < count; i++) {
865             incrementId++;
866             uint artefactTypeId = getRandom(typesCount, incrementId) + 1;
867             super._mint(to, incrementId);
868             artefacts[incrementId] = Artefact(incrementId, artefactTypeId);
869         }
870     }
871 
872     function changeAndBuyPack(uint packId) public payable {
873         require(packs[packId].created);
874         require(!packs[packId].disabled);
875         uint rate = TVCrowdsale(TVCrowdsaleAddress).currentRate();
876         uint priceWei = packs[packId].price / rate;
877         require(priceWei == msg.value);
878 
879         TVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
880         bytes memory data = toBytes(packId);
881         checkAndBuySender = msg.sender;
882         TVToken(TVTokenAddress).safeTransfer(this, packs[packId].price, data);
883 
884         emit ChangeAndBuyPack(msg.sender, rate, priceWei, packId);
885     }
886 
887     function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
888         require(msg.sender == TVTokenAddress);
889         uint packId = uint256(convertBytesToBytes32(_data));
890         require(packs[packId].created);
891         require(!packs[packId].disabled);
892         require(packs[packId].price == _value);
893         TVToken(TVTokenAddress).transfer(wallet, _value);
894         _from = this == _from ? checkAndBuySender : _from;
895         checkAndBuySender = address(0);
896         openPack(packId, _from);
897 
898         emit TokenReceived(_from, _value, _data, packId);
899         return TOKEN_RECEIVED;
900     }
901 
902     function getRandom(uint max, uint mix) internal view returns (uint random) {
903         random = bytesToUint(keccak256(abi.encodePacked(blockhash(block.number - 1), mix))) % max;
904     }
905 
906     function changeWallet(address _wallet) public onlyOwnerOrManager {
907         wallet = _wallet;
908     }
909 
910     function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
911         TVTokenAddress = newAddress;
912     }
913 
914     function changeTVCrowdsaleAddress(address newAddress) public onlyOwnerOrManager {
915         TVCrowdsaleAddress = newAddress;
916     }
917 
918     function setManager(address _manager) public onlyOwner {
919         manager = _manager;
920     }
921 
922     function convertBytesToBytes32(bytes inBytes) internal pure returns (bytes32 out) {
923         if (inBytes.length == 0) {
924             return 0x0;
925         }
926 
927         assembly {
928             out := mload(add(inBytes, 32))
929         }
930     }
931 
932     function bytesToUint(bytes32 b) internal pure returns (uint number){
933         for (uint i = 0; i < b.length; i++) {
934             number = number + uint(b[i]) * (2 ** (8 * (b.length - (i + 1))));
935         }
936     }
937 
938     function toBytes(uint256 x) internal pure returns (bytes b) {
939         b = new bytes(32);
940         assembly {mstore(add(b, 32), x)}
941     }
942 
943 }