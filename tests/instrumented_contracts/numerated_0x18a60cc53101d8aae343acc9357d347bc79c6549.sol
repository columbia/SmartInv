1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    * as the code is not actually created until after the constructor finishes.
9    * @param _addr address to check
10    * @return whether the target address is a contract
11    */
12   function isContract(address _addr) internal view returns (bool) {
13     uint256 size;
14     // XXX Currently there is no better way to check if there is a contract in an address
15     // than to check the size of the code at that address.
16     // See https://ethereum.stackexchange.com/a/14016/36603
17     // for more details about how this works.
18     // TODO Check this again before the Serenity release, because all addresses will be
19     // contracts then.
20     // solium-disable-next-line security/no-inline-assembly
21     assembly { size := extcodesize(_addr) }
22     return size > 0;
23   }
24 
25 }
26 
27 interface ERC165 {
28 
29   /**
30    * @notice Query if a contract implements an interface
31    * @param _interfaceId The interface identifier, as specified in ERC-165
32    * @dev Interface identification is specified in ERC-165. This function
33    * uses less than 30,000 gas.
34    */
35   function supportsInterface(bytes4 _interfaceId)
36     external
37     view
38     returns (bool);
39 }
40 
41 contract SupportsInterfaceWithLookup is ERC165 {
42 
43   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
44   /**
45    * 0x01ffc9a7 ===
46    *   bytes4(keccak256('supportsInterface(bytes4)'))
47    */
48 
49   /**
50    * @dev a mapping of interface id to whether or not it's supported
51    */
52   mapping(bytes4 => bool) internal supportedInterfaces;
53 
54   /**
55    * @dev A contract implementing SupportsInterfaceWithLookup
56    * implement ERC165 itself
57    */
58   constructor()
59     public
60   {
61     _registerInterface(InterfaceId_ERC165);
62   }
63 
64   /**
65    * @dev implement supportsInterface(bytes4) using a lookup table
66    */
67   function supportsInterface(bytes4 _interfaceId)
68     external
69     view
70     returns (bool)
71   {
72     return supportedInterfaces[_interfaceId];
73   }
74 
75   /**
76    * @dev private method for registering an interface
77    */
78   function _registerInterface(bytes4 _interfaceId)
79     internal
80   {
81     require(_interfaceId != 0xffffffff);
82     supportedInterfaces[_interfaceId] = true;
83   }
84 }
85 
86 library SafeMath {
87 
88   /**
89   * @dev Multiplies two numbers, throws on overflow.
90   */
91   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
92     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
93     // benefit is lost if 'b' is also tested.
94     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95     if (_a == 0) {
96       return 0;
97     }
98 
99     c = _a * _b;
100     assert(c / _a == _b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
108     // assert(_b > 0); // Solidity automatically throws when dividing by 0
109     // uint256 c = _a / _b;
110     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
111     return _a / _b;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
118     assert(_b <= _a);
119     return _a - _b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
126     c = _a + _b;
127     assert(c >= _a);
128     return c;
129   }
130 }
131 
132 contract ERC721Basic is ERC165 {
133 
134   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
135   /*
136    * 0x80ac58cd ===
137    *   bytes4(keccak256('balanceOf(address)')) ^
138    *   bytes4(keccak256('ownerOf(uint256)')) ^
139    *   bytes4(keccak256('approve(address,uint256)')) ^
140    *   bytes4(keccak256('getApproved(uint256)')) ^
141    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
142    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
143    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
144    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
145    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
146    */
147 
148   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
149   /*
150    * 0x4f558e79 ===
151    *   bytes4(keccak256('exists(uint256)'))
152    */
153 
154   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
155   /**
156    * 0x780e9d63 ===
157    *   bytes4(keccak256('totalSupply()')) ^
158    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
159    *   bytes4(keccak256('tokenByIndex(uint256)'))
160    */
161 
162   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
163   /**
164    * 0x5b5e139f ===
165    *   bytes4(keccak256('name()')) ^
166    *   bytes4(keccak256('symbol()')) ^
167    *   bytes4(keccak256('tokenURI(uint256)'))
168    */
169 
170   event Transfer(
171     address indexed _from,
172     address indexed _to,
173     uint256 indexed _tokenId
174   );
175   event Approval(
176     address indexed _owner,
177     address indexed _approved,
178     uint256 indexed _tokenId
179   );
180   event ApprovalForAll(
181     address indexed _owner,
182     address indexed _operator,
183     bool _approved
184   );
185 
186   function balanceOf(address _owner) public view returns (uint256 _balance);
187   function ownerOf(uint256 _tokenId) public view returns (address _owner);
188   function exists(uint256 _tokenId) public view returns (bool _exists);
189 
190   function approve(address _to, uint256 _tokenId) public;
191   function getApproved(uint256 _tokenId)
192     public view returns (address _operator);
193 
194   function setApprovalForAll(address _operator, bool _approved) public;
195   function isApprovedForAll(address _owner, address _operator)
196     public view returns (bool);
197 
198   function transferFrom(address _from, address _to, uint256 _tokenId) public;
199   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
200     public;
201 
202   function safeTransferFrom(
203     address _from,
204     address _to,
205     uint256 _tokenId,
206     bytes _data
207   )
208     public;
209 }
210 
211 contract ERC721Enumerable is ERC721Basic {
212   function totalSupply() public view returns (uint256);
213   function tokenOfOwnerByIndex(
214     address _owner,
215     uint256 _index
216   )
217     public
218     view
219     returns (uint256 _tokenId);
220 
221   function tokenByIndex(uint256 _index) public view returns (uint256);
222 }
223 
224 contract ERC721Metadata is ERC721Basic {
225   function name() external view returns (string _name);
226   function symbol() external view returns (string _symbol);
227   function tokenURI(uint256 _tokenId) public view returns (string);
228 }
229 
230 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
231 }
232 
233 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
234 
235   using SafeMath for uint256;
236   using AddressUtils for address;
237 
238   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
239   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
240   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
241 
242   // Mapping from token ID to owner
243   mapping (uint256 => address) internal tokenOwner;
244 
245   // Mapping from token ID to approved address
246   mapping (uint256 => address) internal tokenApprovals;
247 
248   // Mapping from owner to number of owned token
249   mapping (address => uint256) internal ownedTokensCount;
250 
251   // Mapping from owner to operator approvals
252   mapping (address => mapping (address => bool)) internal operatorApprovals;
253 
254   constructor()
255     public
256   {
257     // register the supported interfaces to conform to ERC721 via ERC165
258     _registerInterface(InterfaceId_ERC721);
259     _registerInterface(InterfaceId_ERC721Exists);
260   }
261 
262   /**
263    * @dev Gets the balance of the specified address
264    * @param _owner address to query the balance of
265    * @return uint256 representing the amount owned by the passed address
266    */
267   function balanceOf(address _owner) public view returns (uint256) {
268     require(_owner != address(0));
269     return ownedTokensCount[_owner];
270   }
271 
272   /**
273    * @dev Gets the owner of the specified token ID
274    * @param _tokenId uint256 ID of the token to query the owner of
275    * @return owner address currently marked as the owner of the given token ID
276    */
277   function ownerOf(uint256 _tokenId) public view returns (address) {
278     address owner = tokenOwner[_tokenId];
279     require(owner != address(0));
280     return owner;
281   }
282 
283   /**
284    * @dev Returns whether the specified token exists
285    * @param _tokenId uint256 ID of the token to query the existence of
286    * @return whether the token exists
287    */
288   function exists(uint256 _tokenId) public view returns (bool) {
289     address owner = tokenOwner[_tokenId];
290     return owner != address(0);
291   }
292 
293   /**
294    * @dev Approves another address to transfer the given token ID
295    * The zero address indicates there is no approved address.
296    * There can only be one approved address per token at a given time.
297    * Can only be called by the token owner or an approved operator.
298    * @param _to address to be approved for the given token ID
299    * @param _tokenId uint256 ID of the token to be approved
300    */
301   function approve(address _to, uint256 _tokenId) public {
302     address owner = ownerOf(_tokenId);
303     require(_to != owner);
304     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
305 
306     tokenApprovals[_tokenId] = _to;
307     emit Approval(owner, _to, _tokenId);
308   }
309 
310   /**
311    * @dev Gets the approved address for a token ID, or zero if no address set
312    * @param _tokenId uint256 ID of the token to query the approval of
313    * @return address currently approved for the given token ID
314    */
315   function getApproved(uint256 _tokenId) public view returns (address) {
316     return tokenApprovals[_tokenId];
317   }
318 
319   /**
320    * @dev Sets or unsets the approval of a given operator
321    * An operator is allowed to transfer all tokens of the sender on their behalf
322    * @param _to operator address to set the approval
323    * @param _approved representing the status of the approval to be set
324    */
325   function setApprovalForAll(address _to, bool _approved) public {
326     require(_to != msg.sender);
327     operatorApprovals[msg.sender][_to] = _approved;
328     emit ApprovalForAll(msg.sender, _to, _approved);
329   }
330 
331   /**
332    * @dev Tells whether an operator is approved by a given owner
333    * @param _owner owner address which you want to query the approval of
334    * @param _operator operator address which you want to query the approval of
335    * @return bool whether the given operator is approved by the given owner
336    */
337   function isApprovedForAll(
338     address _owner,
339     address _operator
340   )
341     public
342     view
343     returns (bool)
344   {
345     return operatorApprovals[_owner][_operator];
346   }
347 
348   /**
349    * @dev Transfers the ownership of a given token ID to another address
350    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
351    * Requires the msg sender to be the owner, approved, or operator
352    * @param _from current owner of the token
353    * @param _to address to receive the ownership of the given token ID
354    * @param _tokenId uint256 ID of the token to be transferred
355   */
356   function transferFrom(
357     address _from,
358     address _to,
359     uint256 _tokenId
360   )
361     public
362   {
363     require(isApprovedOrOwner(msg.sender, _tokenId));
364     require(_from != address(0));
365     require(_to != address(0));
366 
367     clearApproval(_from, _tokenId);
368     removeTokenFrom(_from, _tokenId);
369     addTokenTo(_to, _tokenId);
370 
371     emit Transfer(_from, _to, _tokenId);
372   }
373 
374   /**
375    * @dev Safely transfers the ownership of a given token ID to another address
376    * If the target address is a contract, it must implement `onERC721Received`,
377    * which is called upon a safe transfer, and return the magic value
378    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
379    * the transfer is reverted.
380    *
381    * Requires the msg sender to be the owner, approved, or operator
382    * @param _from current owner of the token
383    * @param _to address to receive the ownership of the given token ID
384    * @param _tokenId uint256 ID of the token to be transferred
385   */
386   function safeTransferFrom(
387     address _from,
388     address _to,
389     uint256 _tokenId
390   )
391     public
392   {
393     // solium-disable-next-line arg-overflow
394     safeTransferFrom(_from, _to, _tokenId, "");
395   }
396 
397   /**
398    * @dev Safely transfers the ownership of a given token ID to another address
399    * If the target address is a contract, it must implement `onERC721Received`,
400    * which is called upon a safe transfer, and return the magic value
401    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
402    * the transfer is reverted.
403    * Requires the msg sender to be the owner, approved, or operator
404    * @param _from current owner of the token
405    * @param _to address to receive the ownership of the given token ID
406    * @param _tokenId uint256 ID of the token to be transferred
407    * @param _data bytes data to send along with a safe transfer check
408    */
409   function safeTransferFrom(
410     address _from,
411     address _to,
412     uint256 _tokenId,
413     bytes _data
414   )
415     public
416   {
417     transferFrom(_from, _to, _tokenId);
418     // solium-disable-next-line arg-overflow
419     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
420   }
421 
422   /**
423    * @dev Returns whether the given spender can transfer a given token ID
424    * @param _spender address of the spender to query
425    * @param _tokenId uint256 ID of the token to be transferred
426    * @return bool whether the msg.sender is approved for the given token ID,
427    *  is an operator of the owner, or is the owner of the token
428    */
429   function isApprovedOrOwner(
430     address _spender,
431     uint256 _tokenId
432   )
433     internal
434     view
435     returns (bool)
436   {
437     address owner = ownerOf(_tokenId);
438     // Disable solium check because of
439     // https://github.com/duaraghav8/Solium/issues/175
440     // solium-disable-next-line operator-whitespace
441     return (
442       _spender == owner ||
443       getApproved(_tokenId) == _spender ||
444       isApprovedForAll(owner, _spender)
445     );
446   }
447 
448   /**
449    * @dev Internal function to mint a new token
450    * Reverts if the given token ID already exists
451    * @param _to The address that will own the minted token
452    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
453    */
454   function _mint(address _to, uint256 _tokenId) internal {
455     require(_to != address(0));
456     addTokenTo(_to, _tokenId);
457     emit Transfer(address(0), _to, _tokenId);
458   }
459 
460   /**
461    * @dev Internal function to burn a specific token
462    * Reverts if the token does not exist
463    * @param _tokenId uint256 ID of the token being burned by the msg.sender
464    */
465   function _burn(address _owner, uint256 _tokenId) internal {
466     clearApproval(_owner, _tokenId);
467     removeTokenFrom(_owner, _tokenId);
468     emit Transfer(_owner, address(0), _tokenId);
469   }
470 
471   /**
472    * @dev Internal function to clear current approval of a given token ID
473    * Reverts if the given address is not indeed the owner of the token
474    * @param _owner owner of the token
475    * @param _tokenId uint256 ID of the token to be transferred
476    */
477   function clearApproval(address _owner, uint256 _tokenId) internal {
478     require(ownerOf(_tokenId) == _owner);
479     if (tokenApprovals[_tokenId] != address(0)) {
480       tokenApprovals[_tokenId] = address(0);
481     }
482   }
483 
484   /**
485    * @dev Internal function to add a token ID to the list of a given address
486    * @param _to address representing the new owner of the given token ID
487    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
488    */
489   function addTokenTo(address _to, uint256 _tokenId) internal {
490     require(tokenOwner[_tokenId] == address(0));
491     tokenOwner[_tokenId] = _to;
492     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
493   }
494 
495   /**
496    * @dev Internal function to remove a token ID from the list of a given address
497    * @param _from address representing the previous owner of the given token ID
498    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
499    */
500   function removeTokenFrom(address _from, uint256 _tokenId) internal {
501     require(ownerOf(_tokenId) == _from);
502     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
503     tokenOwner[_tokenId] = address(0);
504   }
505 
506   /**
507    * @dev Internal function to invoke `onERC721Received` on a target address
508    * The call is not executed if the target address is not a contract
509    * @param _from address representing the previous owner of the given token ID
510    * @param _to target address that will receive the tokens
511    * @param _tokenId uint256 ID of the token to be transferred
512    * @param _data bytes optional data to send along with the call
513    * @return whether the call correctly returned the expected magic value
514    */
515   function checkAndCallSafeTransfer(
516     address _from,
517     address _to,
518     uint256 _tokenId,
519     bytes _data
520   )
521     internal
522     returns (bool)
523   {
524     if (!_to.isContract()) {
525       return true;
526     }
527     bytes4 retval = ERC721Receiver(_to).onERC721Received(
528       msg.sender, _from, _tokenId, _data);
529     return (retval == ERC721_RECEIVED);
530   }
531 }
532 
533 contract Trophy is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
534 
535     // Use solidity-stringutils
536     using strings for *;
537 
538     // Token name
539     string internal name_;
540 
541     // Token symbol
542     string internal symbol_;
543 
544     // Mapping from owner to list of owned token IDs
545     mapping(address => uint256[]) public ownedTokens;
546 
547     // Mapping from token ID to index of the owner tokens list
548     mapping(uint256 => uint256) public ownedTokensIndex;
549 
550     // Array with all token ids, used for enumeration
551     uint256[] public allTokens;
552 
553     // Mapping from token id to position in the allTokens array
554     mapping(uint256 => uint256) public allTokensIndex;
555 
556     // Super administrator for this contract
557     address public manager;
558 
559     // Next token identifier
560     uint256 public nextTokenId = 1;
561 
562     // Next token type
563     uint256 public nextTokenType = 1;
564 
565     // URI prefix for all token URIs
566     string public tokenURIPrefix;
567 
568     // Types associated with tokens
569     mapping (uint256 => uint256) public tokenTypes;
570 
571     // Owners of types
572     mapping (uint256 => address) public tokenTypeIssuers;
573 
574     // A mapping of token id to issuer
575     mapping (uint256 => address) public tokenIssuer;
576 
577     // A map of tokens by a type
578     mapping (uint256 => uint256[]) public tokensByType;
579 
580     // Event emitted upon token type creation
581     event TokenTypeCreated(
582         address _issuer,
583         uint256 _type,
584         uint256 _timestamp
585     );
586 
587     // Event emmited upon token is issued
588     event TokenIssued(
589         address _issuer,
590         address _owner,
591         uint256 _type,
592         uint256 _tokenId,
593         uint256 _timestamp
594     );
595 
596     // Event emmited upon token is revoked
597     event TokenRevoked(
598         address _issuer,
599         address _owner,
600         uint256 _type,
601         uint256 _tokenId,
602         uint256 _timestamp
603     );
604 
605     // Event emmited upon token issuance is transferred
606     event IssuanceTransferred(
607         uint256 _type,
608         address _oldIssuer,
609         address _newIssuer,
610         uint256 _timestamp
611     );
612 
613     // Event emmited upon transfer all tokens
614     event TransferAll(
615         address _oldAddress,
616         address _newAddress,
617         uint256 _timestamp
618     );
619 
620     /**
621     * @dev Constructor function
622     */
623     constructor(string _name, string _symbol, string _tokenURIPrefix) public {
624         name_ = _name;
625         symbol_ = _symbol;
626         manager = msg.sender;
627         tokenURIPrefix = _tokenURIPrefix;
628 
629         // register the supported interfaces to conform to ERC721 via ERC165
630         _registerInterface(InterfaceId_ERC721Enumerable);
631         _registerInterface(InterfaceId_ERC721Metadata);
632     }
633 
634     /**
635      * @dev Gets the token name
636      * @return string representing the token name
637      */
638     function name() external view returns (string) {
639         return name_;
640     }
641 
642     /**
643      * @dev Gets the token symbol
644      * @return string representing the token symbol
645      */
646     function symbol() external view returns (string) {
647         return symbol_;
648     }
649 
650     /**
651      * @dev Returns an URI for a given token ID
652      * Throws if the token ID does not exist. May return an empty string.
653      * @param _tokenId uint256 ID of the token to query
654      */
655     function tokenURI(uint256 _tokenId) public view returns (string) {
656         require(tokenOwner[_tokenId] != address(0));
657         return tokenURIPrefix.toSlice().concat(uint2str(_tokenId).toSlice());
658     }
659 
660     /**
661      * @dev Gets the token ID at a given index of the tokens list of the requested owner
662      * @param _owner address owning the tokens list to be accessed
663      * @param _index uint256 representing the index to be accessed of the requested tokens list
664      * @return uint256 token ID at the given index of the tokens list owned by the requested address
665      */
666     function tokenOfOwnerByIndex(
667         address _owner,
668         uint256 _index
669     )
670     public
671     view
672     returns (uint256)
673     {
674         require(_index < balanceOf(_owner));
675         return ownedTokens[_owner][_index];
676     }
677 
678     /**
679     * @dev Gets the total amount of tokens stored by the contract
680     * @return uint256 representing the total amount of tokens
681      */
682     function totalSupply() public view returns (uint256) {
683         return allTokens.length;
684     }
685 
686     /**
687     * @dev Gets the token ID at a given index of all the tokens in this contract
688     * Reverts if the index is greater or equal to the total number of tokens
689     * @param _index uint256 representing the index to be accessed of the tokens list
690     * @return uint256 token ID at the given index of the tokens list
691      */
692     function tokenByIndex(uint256 _index) public view returns (uint256) {
693         require(_index < totalSupply());
694         return allTokens[_index];
695     }
696 
697     /**
698      * @dev Implements ERC 721
699      */
700     function implementsERC721() public pure returns (bool) {
701         return true;
702     }
703 
704     /**
705     * @dev Creates a new token type
706     * @param _issuer address of the new token type issuer
707     */
708     function createType(address _issuer) external {
709         require(
710             msg.sender == manager || msg.sender == _issuer,
711             "Only managers can issue trophies on behalf of others."
712         );
713 
714         tokenTypeIssuers[nextTokenType] = _issuer;
715         emit TokenTypeCreated(_issuer, nextTokenType, block.timestamp); // solium-disable-line security/no-block-members
716         nextTokenType++;
717     }
718 
719     /**
720      * @dev Issues a new token
721      * @param _issuer address of the new token type issuer
722      */
723     function issue(address _issuer, address _owner, uint256 _type) public {
724         require(
725             (msg.sender == manager && tokenTypeIssuers[_type] != 0) || (msg.sender == _issuer && tokenTypeIssuers[_type] == _issuer), // solium-disable-line indentation
726             "Only managers and issuers can issue trophies."
727         );
728 
729         _mint(_owner, nextTokenId);
730         tokenTypes[nextTokenId] = _type;
731         tokensByType[_type].push(nextTokenId);
732 
733         emit TokenIssued(
734             _issuer,
735             _owner,
736             _type,
737             nextTokenId,
738             block.timestamp // solium-disable-line security/no-block-members
739         );
740 
741         nextTokenId++;
742     }
743 
744     /**
745      * @dev issues the same token to many addresses
746      * @param _issuer address of the new token type issuer
747      * @param _owners an array of addresses of token holders
748      * @param _type type of an token
749      */
750     function issueBatch(address _issuer, address[] _owners, uint256 _type) external {
751         require(_owners.length > 0, "Owners cannot be empty");
752 
753         for (uint256 index = 0; index < _owners.length; index++ ) {
754             issue(_issuer, _owners[index], _type);
755         }
756     }
757 
758     /**
759      * @dev Revokes issuance permissions to another address
760      */
761     function revoke(uint256 _tokenId) external {
762         address owner = tokenOwner[_tokenId];
763         uint256 tokenType = tokenTypes[_tokenId];
764         address issuer = tokenTypeIssuers[tokenType];
765 
766         require(
767             msg.sender == manager || msg.sender == issuer || msg.sender == owner,
768             "Only managers, owners, and issuers of the trophy can revoke them."
769         );
770 
771         _burn(owner, _tokenId);
772 
773         uint256 tokenIndex;
774         bool tokenFound;
775         for (uint256 i = 0; i < tokensByType[tokenType].length; i++) {
776             if (tokensByType[tokenType][i] == _tokenId) {
777                 tokenIndex = i;
778                 tokenFound = true;
779                 break;
780             }
781         }
782         require(tokenFound, "token not found");
783 
784         uint256 lastTokenIndex = tokensByType[tokenType].length.sub(1);
785         uint256 lastToken = tokensByType[tokenType][lastTokenIndex];
786 
787         tokensByType[tokenType][tokenIndex] = lastToken;
788         tokensByType[tokenType][lastTokenIndex] = 0;
789 
790         emit TokenRevoked(
791             issuer,
792             owner,
793             tokenType,
794             _tokenId,
795             block.timestamp // solium-disable-line security/no-block-members
796         );
797     }
798 
799     /**
800     * @dev Transfers issuance permissions to another address
801     */
802     function transferIssuer(uint256 _type, address _oldIssuer, address _newIssuer) external {
803         require(
804             msg.sender == manager || (msg.sender == _oldIssuer && tokenTypeIssuers[_type] == _oldIssuer),
805             "Only managers and issuers can transfer issuance of trophies."
806         );
807 
808         tokenTypeIssuers[_type] = _newIssuer;
809         emit IssuanceTransferred(
810             _type,
811             _oldIssuer,
812             _newIssuer,
813             block.timestamp // solium-disable-line security/no-block-members
814         );
815     }
816 
817     /**
818     * @dev Transfers all tokens to a new address
819      */
820     function transferAll(uint256 _type, address _oldAddress, address _newAddress) external {
821         require(
822             msg.sender == manager || (msg.sender == _oldAddress && tokenTypeIssuers[_type] == _oldAddress),
823             "Only managers and issuers can transfer all tokens to a new address."
824         );
825 
826         for (uint256 i = 0; i < ownedTokens[_oldAddress].length; i++) {
827             uint256 token = ownedTokens[_oldAddress][i];
828             removeTokenFrom(_oldAddress, token);
829             addTokenTo(_newAddress, token);
830         }
831         emit TransferAll(_oldAddress, _newAddress, block.timestamp); // solium-disable-line security/no-block-members
832     }
833 
834     /**
835      * @dev Restrict all transfers
836      */
837     function transferFrom(address _from, address _to, uint256 _tokenId) public {
838         require(false, "Transfers of trophies are not allowed.");
839     }
840 
841     /**
842      * @dev Restrict all transfers
843      */
844     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
845         require(false, "Transfers of trophies are not allowed.");
846     }
847 
848     /**
849      * @dev Restrict all transfers
850      */
851     function setApprovalForAll(address _to, bool _approved) public {
852         require(false, "Transfers of trophies are not allowed.");
853     }
854 
855     /**
856      * @dev Restrict all transfers
857      */
858     function approve(address _to, uint256 _tokenId) public {
859         require(false, "Transfers of trophies are not allowed.");
860     }
861 
862     /**
863      * @dev Internal function to mint a new token
864      * Reverts if the given token ID already exists
865      * @param _to address the beneficiary that will own the minted token
866      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
867      */
868     function _mint(address _to, uint256 _tokenId) internal {
869         super._mint(_to, _tokenId);
870 
871         allTokensIndex[_tokenId] = allTokens.length;
872         allTokens.push(_tokenId);
873     }
874 
875     /**
876     * @dev Internal function to burn a specific token
877     * Reverts if the token does not exist
878         * @param _owner owner of the token to burn
879         * @param _tokenId uint256 ID of the token being burned by the msg.sender
880      */
881     function _burn(address _owner, uint256 _tokenId) internal {
882         super._burn(_owner, _tokenId);
883 
884         // Reorg all tokens array
885         uint256 tokenIndex = allTokensIndex[_tokenId];
886         uint256 lastTokenIndex = allTokens.length.sub(1);
887         uint256 lastToken = allTokens[lastTokenIndex];
888 
889         allTokens[tokenIndex] = lastToken;
890         allTokens[lastTokenIndex] = 0;
891 
892         allTokens.length--;
893         allTokensIndex[_tokenId] = 0;
894         allTokensIndex[lastToken] = tokenIndex;
895     }
896 
897     /**
898     * @dev Internal function to add a token ID to the list of a given address
899     * @param _to address representing the new owner of the given token ID
900     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
901      */
902     function addTokenTo(address _to, uint256 _tokenId) internal {
903         super.addTokenTo(_to, _tokenId);
904         uint256 length = ownedTokens[_to].length;
905         ownedTokens[_to].push(_tokenId);
906         ownedTokensIndex[_tokenId] = length;
907     }
908 
909     /**
910     * @dev Internal function to remove a token ID from the list of a given address
911     * @param _from address representing the previous owner of the given token ID
912     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
913      */
914     function removeTokenFrom(address _from, uint256 _tokenId) internal {
915         super.removeTokenFrom(_from, _tokenId);
916 
917         // To prevent a gap in the array, we store the last token in the index of the token to delete, and
918         // then delete the last slot.
919         uint256 tokenIndex = ownedTokensIndex[_tokenId];
920         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
921         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
922 
923         ownedTokens[_from][tokenIndex] = lastToken;
924         // This also deletes the contents at the last position of the array
925         ownedTokens[_from].length--;
926 
927         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
928         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
929         // the lastToken to the first position, and then dropping the element placed in the last position of the list
930 
931         ownedTokensIndex[_tokenId] = 0;
932         ownedTokensIndex[lastToken] = tokenIndex;
933     }
934 
935     /**
936     * @dev Converts a uint256 to a decimal string
937     */
938     function uint2str(uint256 i) internal pure returns (string) {
939         if (i == 0) return "0";
940         uint256 j = i;
941         uint256 m = i;
942         uint256 length;
943         while (j != 0){
944             length++;
945             j /= 10;
946         }
947         bytes memory bstr = new bytes(length);
948         uint256 k = length - 1;
949         while (m != 0){
950             bstr[k--] = byte(48 + m % 10);
951             m /= 10;
952         }
953         return string(bstr);
954     }
955 }
956 
957 contract ERC721Receiver {
958   /**
959    * @dev Magic value to be returned upon successful reception of an NFT
960    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
961    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
962    */
963   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
964 
965   /**
966    * @notice Handle the receipt of an NFT
967    * @dev The ERC721 smart contract calls this function on the recipient
968    * after a `safetransfer`. This function MAY throw to revert and reject the
969    * transfer. Return of other than the magic value MUST result in the
970    * transaction being reverted.
971    * Note: the contract address is always the message sender.
972    * @param _operator The address which called `safeTransferFrom` function
973    * @param _from The address which previously owned the token
974    * @param _tokenId The NFT identifier which is being transferred
975    * @param _data Additional data with no specified format
976    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
977    */
978   function onERC721Received(
979     address _operator,
980     address _from,
981     uint256 _tokenId,
982     bytes _data
983   )
984     public
985     returns(bytes4);
986 }
987 
988 library strings {
989     struct slice {
990         uint _len;
991         uint _ptr;
992     }
993 
994     function memcpy(uint dest, uint src, uint len) private pure {
995         // Copy word-length chunks while possible
996         for(; len >= 32; len -= 32) {
997             assembly {
998                 mstore(dest, mload(src))
999             }
1000             dest += 32;
1001             src += 32;
1002         }
1003 
1004         // Copy remaining bytes
1005         uint mask = 256 ** (32 - len) - 1;
1006         assembly {
1007             let srcpart := and(mload(src), not(mask))
1008             let destpart := and(mload(dest), mask)
1009             mstore(dest, or(destpart, srcpart))
1010         }
1011     }
1012 
1013     /*
1014      * @dev Returns a slice containing the entire string.
1015      * @param self The string to make a slice from.
1016      * @return A newly allocated slice containing the entire string.
1017      */
1018     function toSlice(string memory self) internal pure returns (slice memory) {
1019         uint ptr;
1020         assembly {
1021             ptr := add(self, 0x20)
1022         }
1023         return slice(bytes(self).length, ptr);
1024     }
1025 
1026     /*
1027      * @dev Returns the length of a null-terminated bytes32 string.
1028      * @param self The value to find the length of.
1029      * @return The length of the string, from 0 to 32.
1030      */
1031     function len(bytes32 self) internal pure returns (uint) {
1032         uint ret;
1033         if (self == 0)
1034             return 0;
1035         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1036             ret += 16;
1037             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1038         }
1039         if (self & 0xffffffffffffffff == 0) {
1040             ret += 8;
1041             self = bytes32(uint(self) / 0x10000000000000000);
1042         }
1043         if (self & 0xffffffff == 0) {
1044             ret += 4;
1045             self = bytes32(uint(self) / 0x100000000);
1046         }
1047         if (self & 0xffff == 0) {
1048             ret += 2;
1049             self = bytes32(uint(self) / 0x10000);
1050         }
1051         if (self & 0xff == 0) {
1052             ret += 1;
1053         }
1054         return 32 - ret;
1055     }
1056 
1057     /*
1058      * @dev Returns a slice containing the entire bytes32, interpreted as a
1059      *      null-terminated utf-8 string.
1060      * @param self The bytes32 value to convert to a slice.
1061      * @return A new slice containing the value of the input argument up to the
1062      *         first null.
1063      */
1064     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1065         // Allocate space for `self` in memory, copy it there, and point ret at it
1066         assembly {
1067             let ptr := mload(0x40)
1068             mstore(0x40, add(ptr, 0x20))
1069             mstore(ptr, self)
1070             mstore(add(ret, 0x20), ptr)
1071         }
1072         ret._len = len(self);
1073     }
1074 
1075     /*
1076      * @dev Returns a new slice containing the same data as the current slice.
1077      * @param self The slice to copy.
1078      * @return A new slice containing the same data as `self`.
1079      */
1080     function copy(slice memory self) internal pure returns (slice memory) {
1081         return slice(self._len, self._ptr);
1082     }
1083 
1084     /*
1085      * @dev Copies a slice to a new string.
1086      * @param self The slice to copy.
1087      * @return A newly allocated string containing the slice's text.
1088      */
1089     function toString(slice memory self) internal pure returns (string memory) {
1090         string memory ret = new string(self._len);
1091         uint retptr;
1092         assembly { retptr := add(ret, 32) }
1093 
1094         memcpy(retptr, self._ptr, self._len);
1095         return ret;
1096     }
1097 
1098     /*
1099      * @dev Returns the length in runes of the slice. Note that this operation
1100      *      takes time proportional to the length of the slice; avoid using it
1101      *      in loops, and call `slice.empty()` if you only need to know whether
1102      *      the slice is empty or not.
1103      * @param self The slice to operate on.
1104      * @return The length of the slice in runes.
1105      */
1106     function len(slice memory self) internal pure returns (uint l) {
1107         // Starting at ptr-31 means the LSB will be the byte we care about
1108         uint ptr = self._ptr - 31;
1109         uint end = ptr + self._len;
1110         for (l = 0; ptr < end; l++) {
1111             uint8 b;
1112             assembly { b := and(mload(ptr), 0xFF) }
1113             if (b < 0x80) {
1114                 ptr += 1;
1115             } else if(b < 0xE0) {
1116                 ptr += 2;
1117             } else if(b < 0xF0) {
1118                 ptr += 3;
1119             } else if(b < 0xF8) {
1120                 ptr += 4;
1121             } else if(b < 0xFC) {
1122                 ptr += 5;
1123             } else {
1124                 ptr += 6;
1125             }
1126         }
1127     }
1128 
1129     /*
1130      * @dev Returns true if the slice is empty (has a length of 0).
1131      * @param self The slice to operate on.
1132      * @return True if the slice is empty, False otherwise.
1133      */
1134     function empty(slice memory self) internal pure returns (bool) {
1135         return self._len == 0;
1136     }
1137 
1138     /*
1139      * @dev Returns a positive number if `other` comes lexicographically after
1140      *      `self`, a negative number if it comes before, or zero if the
1141      *      contents of the two slices are equal. Comparison is done per-rune,
1142      *      on unicode codepoints.
1143      * @param self The first slice to compare.
1144      * @param other The second slice to compare.
1145      * @return The result of the comparison.
1146      */
1147     function compare(slice memory self, slice memory other) internal pure returns (int) {
1148         uint shortest = self._len;
1149         if (other._len < self._len)
1150             shortest = other._len;
1151 
1152         uint selfptr = self._ptr;
1153         uint otherptr = other._ptr;
1154         for (uint idx = 0; idx < shortest; idx += 32) {
1155             uint a;
1156             uint b;
1157             assembly {
1158                 a := mload(selfptr)
1159                 b := mload(otherptr)
1160             }
1161             if (a != b) {
1162                 // Mask out irrelevant bytes and check again
1163                 uint256 mask = uint256(-1); // 0xffff...
1164                 if(shortest < 32) {
1165                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1166                 }
1167                 uint256 diff = (a & mask) - (b & mask);
1168                 if (diff != 0)
1169                     return int(diff);
1170             }
1171             selfptr += 32;
1172             otherptr += 32;
1173         }
1174         return int(self._len) - int(other._len);
1175     }
1176 
1177     /*
1178      * @dev Returns true if the two slices contain the same text.
1179      * @param self The first slice to compare.
1180      * @param self The second slice to compare.
1181      * @return True if the slices are equal, false otherwise.
1182      */
1183     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1184         return compare(self, other) == 0;
1185     }
1186 
1187     /*
1188      * @dev Extracts the first rune in the slice into `rune`, advancing the
1189      *      slice to point to the next rune and returning `self`.
1190      * @param self The slice to operate on.
1191      * @param rune The slice that will contain the first rune.
1192      * @return `rune`.
1193      */
1194     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1195         rune._ptr = self._ptr;
1196 
1197         if (self._len == 0) {
1198             rune._len = 0;
1199             return rune;
1200         }
1201 
1202         uint l;
1203         uint b;
1204         // Load the first byte of the rune into the LSBs of b
1205         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1206         if (b < 0x80) {
1207             l = 1;
1208         } else if(b < 0xE0) {
1209             l = 2;
1210         } else if(b < 0xF0) {
1211             l = 3;
1212         } else {
1213             l = 4;
1214         }
1215 
1216         // Check for truncated codepoints
1217         if (l > self._len) {
1218             rune._len = self._len;
1219             self._ptr += self._len;
1220             self._len = 0;
1221             return rune;
1222         }
1223 
1224         self._ptr += l;
1225         self._len -= l;
1226         rune._len = l;
1227         return rune;
1228     }
1229 
1230     /*
1231      * @dev Returns the first rune in the slice, advancing the slice to point
1232      *      to the next rune.
1233      * @param self The slice to operate on.
1234      * @return A slice containing only the first rune from `self`.
1235      */
1236     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1237         nextRune(self, ret);
1238     }
1239 
1240     /*
1241      * @dev Returns the number of the first codepoint in the slice.
1242      * @param self The slice to operate on.
1243      * @return The number of the first codepoint in the slice.
1244      */
1245     function ord(slice memory self) internal pure returns (uint ret) {
1246         if (self._len == 0) {
1247             return 0;
1248         }
1249 
1250         uint word;
1251         uint length;
1252         uint divisor = 2 ** 248;
1253 
1254         // Load the rune into the MSBs of b
1255         assembly { word:= mload(mload(add(self, 32))) }
1256         uint b = word / divisor;
1257         if (b < 0x80) {
1258             ret = b;
1259             length = 1;
1260         } else if(b < 0xE0) {
1261             ret = b & 0x1F;
1262             length = 2;
1263         } else if(b < 0xF0) {
1264             ret = b & 0x0F;
1265             length = 3;
1266         } else {
1267             ret = b & 0x07;
1268             length = 4;
1269         }
1270 
1271         // Check for truncated codepoints
1272         if (length > self._len) {
1273             return 0;
1274         }
1275 
1276         for (uint i = 1; i < length; i++) {
1277             divisor = divisor / 256;
1278             b = (word / divisor) & 0xFF;
1279             if (b & 0xC0 != 0x80) {
1280                 // Invalid UTF-8 sequence
1281                 return 0;
1282             }
1283             ret = (ret * 64) | (b & 0x3F);
1284         }
1285 
1286         return ret;
1287     }
1288 
1289     /*
1290      * @dev Returns the keccak-256 hash of the slice.
1291      * @param self The slice to hash.
1292      * @return The hash of the slice.
1293      */
1294     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1295         assembly {
1296             ret := keccak256(mload(add(self, 32)), mload(self))
1297         }
1298     }
1299 
1300     /*
1301      * @dev Returns true if `self` starts with `needle`.
1302      * @param self The slice to operate on.
1303      * @param needle The slice to search for.
1304      * @return True if the slice starts with the provided text, false otherwise.
1305      */
1306     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1307         if (self._len < needle._len) {
1308             return false;
1309         }
1310 
1311         if (self._ptr == needle._ptr) {
1312             return true;
1313         }
1314 
1315         bool equal;
1316         assembly {
1317             let length := mload(needle)
1318             let selfptr := mload(add(self, 0x20))
1319             let needleptr := mload(add(needle, 0x20))
1320             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1321         }
1322         return equal;
1323     }
1324 
1325     /*
1326      * @dev If `self` starts with `needle`, `needle` is removed from the
1327      *      beginning of `self`. Otherwise, `self` is unmodified.
1328      * @param self The slice to operate on.
1329      * @param needle The slice to search for.
1330      * @return `self`
1331      */
1332     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1333         if (self._len < needle._len) {
1334             return self;
1335         }
1336 
1337         bool equal = true;
1338         if (self._ptr != needle._ptr) {
1339             assembly {
1340                 let length := mload(needle)
1341                 let selfptr := mload(add(self, 0x20))
1342                 let needleptr := mload(add(needle, 0x20))
1343                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1344             }
1345         }
1346 
1347         if (equal) {
1348             self._len -= needle._len;
1349             self._ptr += needle._len;
1350         }
1351 
1352         return self;
1353     }
1354 
1355     /*
1356      * @dev Returns true if the slice ends with `needle`.
1357      * @param self The slice to operate on.
1358      * @param needle The slice to search for.
1359      * @return True if the slice starts with the provided text, false otherwise.
1360      */
1361     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1362         if (self._len < needle._len) {
1363             return false;
1364         }
1365 
1366         uint selfptr = self._ptr + self._len - needle._len;
1367 
1368         if (selfptr == needle._ptr) {
1369             return true;
1370         }
1371 
1372         bool equal;
1373         assembly {
1374             let length := mload(needle)
1375             let needleptr := mload(add(needle, 0x20))
1376             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1377         }
1378 
1379         return equal;
1380     }
1381 
1382     /*
1383      * @dev If `self` ends with `needle`, `needle` is removed from the
1384      *      end of `self`. Otherwise, `self` is unmodified.
1385      * @param self The slice to operate on.
1386      * @param needle The slice to search for.
1387      * @return `self`
1388      */
1389     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1390         if (self._len < needle._len) {
1391             return self;
1392         }
1393 
1394         uint selfptr = self._ptr + self._len - needle._len;
1395         bool equal = true;
1396         if (selfptr != needle._ptr) {
1397             assembly {
1398                 let length := mload(needle)
1399                 let needleptr := mload(add(needle, 0x20))
1400                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1401             }
1402         }
1403 
1404         if (equal) {
1405             self._len -= needle._len;
1406         }
1407 
1408         return self;
1409     }
1410 
1411     // Returns the memory address of the first byte of the first occurrence of
1412     // `needle` in `self`, or the first byte after `self` if not found.
1413     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1414         uint ptr = selfptr;
1415         uint idx;
1416 
1417         if (needlelen <= selflen) {
1418             if (needlelen <= 32) {
1419                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1420 
1421                 bytes32 needledata;
1422                 assembly { needledata := and(mload(needleptr), mask) }
1423 
1424                 uint end = selfptr + selflen - needlelen;
1425                 bytes32 ptrdata;
1426                 assembly { ptrdata := and(mload(ptr), mask) }
1427 
1428                 while (ptrdata != needledata) {
1429                     if (ptr >= end)
1430                         return selfptr + selflen;
1431                     ptr++;
1432                     assembly { ptrdata := and(mload(ptr), mask) }
1433                 }
1434                 return ptr;
1435             } else {
1436                 // For long needles, use hashing
1437                 bytes32 hash;
1438                 assembly { hash := keccak256(needleptr, needlelen) }
1439 
1440                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1441                     bytes32 testHash;
1442                     assembly { testHash := keccak256(ptr, needlelen) }
1443                     if (hash == testHash)
1444                         return ptr;
1445                     ptr += 1;
1446                 }
1447             }
1448         }
1449         return selfptr + selflen;
1450     }
1451 
1452     // Returns the memory address of the first byte after the last occurrence of
1453     // `needle` in `self`, or the address of `self` if not found.
1454     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1455         uint ptr;
1456 
1457         if (needlelen <= selflen) {
1458             if (needlelen <= 32) {
1459                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1460 
1461                 bytes32 needledata;
1462                 assembly { needledata := and(mload(needleptr), mask) }
1463 
1464                 ptr = selfptr + selflen - needlelen;
1465                 bytes32 ptrdata;
1466                 assembly { ptrdata := and(mload(ptr), mask) }
1467 
1468                 while (ptrdata != needledata) {
1469                     if (ptr <= selfptr)
1470                         return selfptr;
1471                     ptr--;
1472                     assembly { ptrdata := and(mload(ptr), mask) }
1473                 }
1474                 return ptr + needlelen;
1475             } else {
1476                 // For long needles, use hashing
1477                 bytes32 hash;
1478                 assembly { hash := keccak256(needleptr, needlelen) }
1479                 ptr = selfptr + (selflen - needlelen);
1480                 while (ptr >= selfptr) {
1481                     bytes32 testHash;
1482                     assembly { testHash := keccak256(ptr, needlelen) }
1483                     if (hash == testHash)
1484                         return ptr + needlelen;
1485                     ptr -= 1;
1486                 }
1487             }
1488         }
1489         return selfptr;
1490     }
1491 
1492     /*
1493      * @dev Modifies `self` to contain everything from the first occurrence of
1494      *      `needle` to the end of the slice. `self` is set to the empty slice
1495      *      if `needle` is not found.
1496      * @param self The slice to search and modify.
1497      * @param needle The text to search for.
1498      * @return `self`.
1499      */
1500     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1501         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1502         self._len -= ptr - self._ptr;
1503         self._ptr = ptr;
1504         return self;
1505     }
1506 
1507     /*
1508      * @dev Modifies `self` to contain the part of the string from the start of
1509      *      `self` to the end of the first occurrence of `needle`. If `needle`
1510      *      is not found, `self` is set to the empty slice.
1511      * @param self The slice to search and modify.
1512      * @param needle The text to search for.
1513      * @return `self`.
1514      */
1515     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1516         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1517         self._len = ptr - self._ptr;
1518         return self;
1519     }
1520 
1521     /*
1522      * @dev Splits the slice, setting `self` to everything after the first
1523      *      occurrence of `needle`, and `token` to everything before it. If
1524      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1525      *      and `token` is set to the entirety of `self`.
1526      * @param self The slice to split.
1527      * @param needle The text to search for in `self`.
1528      * @param token An output parameter to which the first token is written.
1529      * @return `token`.
1530      */
1531     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1532         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1533         token._ptr = self._ptr;
1534         token._len = ptr - self._ptr;
1535         if (ptr == self._ptr + self._len) {
1536             // Not found
1537             self._len = 0;
1538         } else {
1539             self._len -= token._len + needle._len;
1540             self._ptr = ptr + needle._len;
1541         }
1542         return token;
1543     }
1544 
1545     /*
1546      * @dev Splits the slice, setting `self` to everything after the first
1547      *      occurrence of `needle`, and returning everything before it. If
1548      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1549      *      and the entirety of `self` is returned.
1550      * @param self The slice to split.
1551      * @param needle The text to search for in `self`.
1552      * @return The part of `self` up to the first occurrence of `delim`.
1553      */
1554     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1555         split(self, needle, token);
1556     }
1557 
1558     /*
1559      * @dev Splits the slice, setting `self` to everything before the last
1560      *      occurrence of `needle`, and `token` to everything after it. If
1561      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1562      *      and `token` is set to the entirety of `self`.
1563      * @param self The slice to split.
1564      * @param needle The text to search for in `self`.
1565      * @param token An output parameter to which the first token is written.
1566      * @return `token`.
1567      */
1568     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1569         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1570         token._ptr = ptr;
1571         token._len = self._len - (ptr - self._ptr);
1572         if (ptr == self._ptr) {
1573             // Not found
1574             self._len = 0;
1575         } else {
1576             self._len -= token._len + needle._len;
1577         }
1578         return token;
1579     }
1580 
1581     /*
1582      * @dev Splits the slice, setting `self` to everything before the last
1583      *      occurrence of `needle`, and returning everything after it. If
1584      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1585      *      and the entirety of `self` is returned.
1586      * @param self The slice to split.
1587      * @param needle The text to search for in `self`.
1588      * @return The part of `self` after the last occurrence of `delim`.
1589      */
1590     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1591         rsplit(self, needle, token);
1592     }
1593 
1594     /*
1595      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1596      * @param self The slice to search.
1597      * @param needle The text to search for in `self`.
1598      * @return The number of occurrences of `needle` found in `self`.
1599      */
1600     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1601         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1602         while (ptr <= self._ptr + self._len) {
1603             cnt++;
1604             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1605         }
1606     }
1607 
1608     /*
1609      * @dev Returns True if `self` contains `needle`.
1610      * @param self The slice to search.
1611      * @param needle The text to search for in `self`.
1612      * @return True if `needle` is found in `self`, false otherwise.
1613      */
1614     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1615         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1616     }
1617 
1618     /*
1619      * @dev Returns a newly allocated string containing the concatenation of
1620      *      `self` and `other`.
1621      * @param self The first slice to concatenate.
1622      * @param other The second slice to concatenate.
1623      * @return The concatenation of the two strings.
1624      */
1625     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1626         string memory ret = new string(self._len + other._len);
1627         uint retptr;
1628         assembly { retptr := add(ret, 32) }
1629         memcpy(retptr, self._ptr, self._len);
1630         memcpy(retptr + self._len, other._ptr, other._len);
1631         return ret;
1632     }
1633 
1634     /*
1635      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1636      *      newly allocated string.
1637      * @param self The delimiter to use.
1638      * @param parts A list of slices to join.
1639      * @return A newly allocated string containing all the slices in `parts`,
1640      *         joined with `self`.
1641      */
1642     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1643         if (parts.length == 0)
1644             return "";
1645 
1646         uint length = self._len * (parts.length - 1);
1647         for(uint i = 0; i < parts.length; i++)
1648             length += parts[i]._len;
1649 
1650         string memory ret = new string(length);
1651         uint retptr;
1652         assembly { retptr := add(ret, 32) }
1653 
1654         for(i = 0; i < parts.length; i++) {
1655             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1656             retptr += parts[i]._len;
1657             if (i < parts.length - 1) {
1658                 memcpy(retptr, self._ptr, self._len);
1659                 retptr += self._len;
1660             }
1661         }
1662 
1663         return ret;
1664     }
1665 }