1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    *  as the code is not actually created until after the constructor finishes.
9    * @param addr address to check
10    * @return whether the target address is a contract
11    */
12   function isContract(address addr) internal view returns (bool) {
13     uint256 size;
14     // XXX Currently there is no better way to check if there is a contract in an address
15     // than to check the size of the code at that address.
16     // See https://ethereum.stackexchange.com/a/14016/36603
17     // for more details about how this works.
18     // TODO Check this again before the Serenity release, because all addresses will be
19     // contracts then.
20     // solium-disable-next-line security/no-inline-assembly
21     assembly { size := extcodesize(addr) }
22     return size > 0;
23   }
24 
25 }
26 
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 contract Ownable {
74   address public owner;
75 
76 
77   event OwnershipRenounced(address indexed previousOwner);
78   event OwnershipTransferred(
79     address indexed previousOwner,
80     address indexed newOwner
81   );
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to relinquish control of the contract.
102    */
103   function renounceOwnership() public onlyOwner {
104     emit OwnershipRenounced(owner);
105     owner = address(0);
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114   }
115 
116   /**
117    * @dev Transfers control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function _transferOwnership(address _newOwner) internal {
121     require(_newOwner != address(0));
122     emit OwnershipTransferred(owner, _newOwner);
123     owner = _newOwner;
124   }
125 }
126 
127 contract ERC721Basic {
128   event Transfer(
129     address indexed _from,
130     address indexed _to,
131     uint256 _tokenId
132   );
133   event Approval(
134     address indexed _owner,
135     address indexed _approved,
136     uint256 _tokenId
137   );
138   event ApprovalForAll(
139     address indexed _owner,
140     address indexed _operator,
141     bool _approved
142   );
143 
144   function balanceOf(address _owner) public view returns (uint256 _balance);
145   function ownerOf(uint256 _tokenId) public view returns (address _owner);
146   function exists(uint256 _tokenId) public view returns (bool _exists);
147 
148   function approve(address _to, uint256 _tokenId) public;
149   function getApproved(uint256 _tokenId)
150     public view returns (address _operator);
151 
152   function setApprovalForAll(address _operator, bool _approved) public;
153   function isApprovedForAll(address _owner, address _operator)
154     public view returns (bool);
155 
156   function transferFrom(address _from, address _to, uint256 _tokenId) public;
157   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
158     public;
159 
160   function safeTransferFrom(
161     address _from,
162     address _to,
163     uint256 _tokenId,
164     bytes _data
165   )
166     public;
167 }
168 
169 contract ERC721Enumerable is ERC721Basic {
170   function totalSupply() public view returns (uint256);
171   function tokenOfOwnerByIndex(
172     address _owner,
173     uint256 _index
174   )
175     public
176     view
177     returns (uint256 _tokenId);
178 
179   function tokenByIndex(uint256 _index) public view returns (uint256);
180 }
181 
182 contract ERC721Metadata is ERC721Basic {
183   function name() public view returns (string _name);
184   function symbol() public view returns (string _symbol);
185   function tokenURI(uint256 _tokenId) public view returns (string);
186 }
187 
188 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
189 }
190 
191 contract ERC721BasicToken is ERC721Basic {
192   using SafeMath for uint256;
193   using AddressUtils for address;
194 
195   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
196   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
197   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
198 
199   // Mapping from token ID to owner
200   mapping (uint256 => address) internal tokenOwner;
201 
202   // Mapping from token ID to approved address
203   mapping (uint256 => address) internal tokenApprovals;
204 
205   // Mapping from owner to number of owned token
206   mapping (address => uint256) internal ownedTokensCount;
207 
208   // Mapping from owner to operator approvals
209   mapping (address => mapping (address => bool)) internal operatorApprovals;
210 
211   /**
212    * @dev Guarantees msg.sender is owner of the given token
213    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
214    */
215   modifier onlyOwnerOf(uint256 _tokenId) {
216     require(ownerOf(_tokenId) == msg.sender);
217     _;
218   }
219 
220   /**
221    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
222    * @param _tokenId uint256 ID of the token to validate
223    */
224   modifier canTransfer(uint256 _tokenId) {
225     require(isApprovedOrOwner(msg.sender, _tokenId));
226     _;
227   }
228 
229   /**
230    * @dev Gets the balance of the specified address
231    * @param _owner address to query the balance of
232    * @return uint256 representing the amount owned by the passed address
233    */
234   function balanceOf(address _owner) public view returns (uint256) {
235     require(_owner != address(0));
236     return ownedTokensCount[_owner];
237   }
238 
239   /**
240    * @dev Gets the owner of the specified token ID
241    * @param _tokenId uint256 ID of the token to query the owner of
242    * @return owner address currently marked as the owner of the given token ID
243    */
244   function ownerOf(uint256 _tokenId) public view returns (address) {
245     address owner = tokenOwner[_tokenId];
246     require(owner != address(0));
247     return owner;
248   }
249 
250   /**
251    * @dev Returns whether the specified token exists
252    * @param _tokenId uint256 ID of the token to query the existence of
253    * @return whether the token exists
254    */
255   function exists(uint256 _tokenId) public view returns (bool) {
256     address owner = tokenOwner[_tokenId];
257     return owner != address(0);
258   }
259 
260   /**
261    * @dev Approves another address to transfer the given token ID
262    * @dev The zero address indicates there is no approved address.
263    * @dev There can only be one approved address per token at a given time.
264    * @dev Can only be called by the token owner or an approved operator.
265    * @param _to address to be approved for the given token ID
266    * @param _tokenId uint256 ID of the token to be approved
267    */
268   function approve(address _to, uint256 _tokenId) public {
269     address owner = ownerOf(_tokenId);
270     require(_to != owner);
271     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
272 
273     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
274       tokenApprovals[_tokenId] = _to;
275       emit Approval(owner, _to, _tokenId);
276     }
277   }
278 
279   /**
280    * @dev Gets the approved address for a token ID, or zero if no address set
281    * @param _tokenId uint256 ID of the token to query the approval of
282    * @return address currently approved for the given token ID
283    */
284   function getApproved(uint256 _tokenId) public view returns (address) {
285     return tokenApprovals[_tokenId];
286   }
287 
288   /**
289    * @dev Sets or unsets the approval of a given operator
290    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
291    * @param _to operator address to set the approval
292    * @param _approved representing the status of the approval to be set
293    */
294   function setApprovalForAll(address _to, bool _approved) public {
295     require(_to != msg.sender);
296     operatorApprovals[msg.sender][_to] = _approved;
297     emit ApprovalForAll(msg.sender, _to, _approved);
298   }
299 
300   /**
301    * @dev Tells whether an operator is approved by a given owner
302    * @param _owner owner address which you want to query the approval of
303    * @param _operator operator address which you want to query the approval of
304    * @return bool whether the given operator is approved by the given owner
305    */
306   function isApprovedForAll(
307     address _owner,
308     address _operator
309   )
310     public
311     view
312     returns (bool)
313   {
314     return operatorApprovals[_owner][_operator];
315   }
316 
317   /**
318    * @dev Transfers the ownership of a given token ID to another address
319    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
320    * @dev Requires the msg sender to be the owner, approved, or operator
321    * @param _from current owner of the token
322    * @param _to address to receive the ownership of the given token ID
323    * @param _tokenId uint256 ID of the token to be transferred
324   */
325   function transferFrom(
326     address _from,
327     address _to,
328     uint256 _tokenId
329   )
330     public
331     canTransfer(_tokenId)
332   {
333     require(_from != address(0));
334     require(_to != address(0));
335 
336     clearApproval(_from, _tokenId);
337     removeTokenFrom(_from, _tokenId);
338     addTokenTo(_to, _tokenId);
339 
340     emit Transfer(_from, _to, _tokenId);
341   }
342 
343   /**
344    * @dev Safely transfers the ownership of a given token ID to another address
345    * @dev If the target address is a contract, it must implement `onERC721Received`,
346    *  which is called upon a safe transfer, and return the magic value
347    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
348    *  the transfer is reverted.
349    * @dev Requires the msg sender to be the owner, approved, or operator
350    * @param _from current owner of the token
351    * @param _to address to receive the ownership of the given token ID
352    * @param _tokenId uint256 ID of the token to be transferred
353   */
354   function safeTransferFrom(
355     address _from,
356     address _to,
357     uint256 _tokenId
358   )
359     public
360     canTransfer(_tokenId)
361   {
362     // solium-disable-next-line arg-overflow
363     safeTransferFrom(_from, _to, _tokenId, "");
364   }
365 
366   /**
367    * @dev Safely transfers the ownership of a given token ID to another address
368    * @dev If the target address is a contract, it must implement `onERC721Received`,
369    *  which is called upon a safe transfer, and return the magic value
370    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
371    *  the transfer is reverted.
372    * @dev Requires the msg sender to be the owner, approved, or operator
373    * @param _from current owner of the token
374    * @param _to address to receive the ownership of the given token ID
375    * @param _tokenId uint256 ID of the token to be transferred
376    * @param _data bytes data to send along with a safe transfer check
377    */
378   function safeTransferFrom(
379     address _from,
380     address _to,
381     uint256 _tokenId,
382     bytes _data
383   )
384     public
385     canTransfer(_tokenId)
386   {
387     transferFrom(_from, _to, _tokenId);
388     // solium-disable-next-line arg-overflow
389     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
390   }
391 
392   /**
393    * @dev Returns whether the given spender can transfer a given token ID
394    * @param _spender address of the spender to query
395    * @param _tokenId uint256 ID of the token to be transferred
396    * @return bool whether the msg.sender is approved for the given token ID,
397    *  is an operator of the owner, or is the owner of the token
398    */
399   function isApprovedOrOwner(
400     address _spender,
401     uint256 _tokenId
402   )
403     internal
404     view
405     returns (bool)
406   {
407     address owner = ownerOf(_tokenId);
408     // Disable solium check because of
409     // https://github.com/duaraghav8/Solium/issues/175
410     // solium-disable-next-line operator-whitespace
411     return (
412       _spender == owner ||
413       getApproved(_tokenId) == _spender ||
414       isApprovedForAll(owner, _spender)
415     );
416   }
417 
418   /**
419    * @dev Internal function to mint a new token
420    * @dev Reverts if the given token ID already exists
421    * @param _to The address that will own the minted token
422    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
423    */
424   function _mint(address _to, uint256 _tokenId) internal {
425     require(_to != address(0));
426     addTokenTo(_to, _tokenId);
427     emit Transfer(address(0), _to, _tokenId);
428   }
429 
430   /**
431    * @dev Internal function to burn a specific token
432    * @dev Reverts if the token does not exist
433    * @param _tokenId uint256 ID of the token being burned by the msg.sender
434    */
435   function _burn(address _owner, uint256 _tokenId) internal {
436     clearApproval(_owner, _tokenId);
437     removeTokenFrom(_owner, _tokenId);
438     emit Transfer(_owner, address(0), _tokenId);
439   }
440 
441   /**
442    * @dev Internal function to clear current approval of a given token ID
443    * @dev Reverts if the given address is not indeed the owner of the token
444    * @param _owner owner of the token
445    * @param _tokenId uint256 ID of the token to be transferred
446    */
447   function clearApproval(address _owner, uint256 _tokenId) internal {
448     require(ownerOf(_tokenId) == _owner);
449     if (tokenApprovals[_tokenId] != address(0)) {
450       tokenApprovals[_tokenId] = address(0);
451       emit Approval(_owner, address(0), _tokenId);
452     }
453   }
454 
455   /**
456    * @dev Internal function to add a token ID to the list of a given address
457    * @param _to address representing the new owner of the given token ID
458    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
459    */
460   function addTokenTo(address _to, uint256 _tokenId) internal {
461     require(tokenOwner[_tokenId] == address(0));
462     tokenOwner[_tokenId] = _to;
463     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
464   }
465 
466   /**
467    * @dev Internal function to remove a token ID from the list of a given address
468    * @param _from address representing the previous owner of the given token ID
469    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
470    */
471   function removeTokenFrom(address _from, uint256 _tokenId) internal {
472     require(ownerOf(_tokenId) == _from);
473     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
474     tokenOwner[_tokenId] = address(0);
475   }
476 
477   /**
478    * @dev Internal function to invoke `onERC721Received` on a target address
479    * @dev The call is not executed if the target address is not a contract
480    * @param _from address representing the previous owner of the given token ID
481    * @param _to target address that will receive the tokens
482    * @param _tokenId uint256 ID of the token to be transferred
483    * @param _data bytes optional data to send along with the call
484    * @return whether the call correctly returned the expected magic value
485    */
486   function checkAndCallSafeTransfer(
487     address _from,
488     address _to,
489     uint256 _tokenId,
490     bytes _data
491   )
492     internal
493     returns (bool)
494   {
495     if (!_to.isContract()) {
496       return true;
497     }
498     bytes4 retval = ERC721Receiver(_to).onERC721Received(
499       _from, _tokenId, _data);
500     return (retval == ERC721_RECEIVED);
501   }
502 }
503 
504 contract ERC721Receiver {
505   /**
506    * @dev Magic value to be returned upon successful reception of an NFT
507    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
508    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
509    */
510   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
511 
512   /**
513    * @notice Handle the receipt of an NFT
514    * @dev The ERC721 smart contract calls this function on the recipient
515    *  after a `safetransfer`. This function MAY throw to revert and reject the
516    *  transfer. This function MUST use 50,000 gas or less. Return of other
517    *  than the magic value MUST result in the transaction being reverted.
518    *  Note: the contract address is always the message sender.
519    * @param _from The sending address
520    * @param _tokenId The NFT identifier which is being transfered
521    * @param _data Additional data with no specified format
522    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
523    */
524   function onERC721Received(
525     address _from,
526     uint256 _tokenId,
527     bytes _data
528   )
529     public
530     returns(bytes4);
531 }
532 
533 contract ERC721Token is ERC721, ERC721BasicToken {
534   // Token name
535   string internal name_;
536 
537   // Token symbol
538   string internal symbol_;
539 
540   // Mapping from owner to list of owned token IDs
541   mapping(address => uint256[]) internal ownedTokens;
542 
543   // Mapping from token ID to index of the owner tokens list
544   mapping(uint256 => uint256) internal ownedTokensIndex;
545 
546   // Array with all token ids, used for enumeration
547   uint256[] internal allTokens;
548 
549   // Mapping from token id to position in the allTokens array
550   mapping(uint256 => uint256) internal allTokensIndex;
551 
552   // Optional mapping for token URIs
553   mapping(uint256 => string) internal tokenURIs;
554 
555   /**
556    * @dev Constructor function
557    */
558   constructor(string _name, string _symbol) public {
559     name_ = _name;
560     symbol_ = _symbol;
561   }
562 
563   /**
564    * @dev Gets the token name
565    * @return string representing the token name
566    */
567   function name() public view returns (string) {
568     return name_;
569   }
570 
571   /**
572    * @dev Gets the token symbol
573    * @return string representing the token symbol
574    */
575   function symbol() public view returns (string) {
576     return symbol_;
577   }
578 
579   /**
580    * @dev Returns an URI for a given token ID
581    * @dev Throws if the token ID does not exist. May return an empty string.
582    * @param _tokenId uint256 ID of the token to query
583    */
584   function tokenURI(uint256 _tokenId) public view returns (string) {
585     require(exists(_tokenId));
586     return tokenURIs[_tokenId];
587   }
588 
589   /**
590    * @dev Gets the token ID at a given index of the tokens list of the requested owner
591    * @param _owner address owning the tokens list to be accessed
592    * @param _index uint256 representing the index to be accessed of the requested tokens list
593    * @return uint256 token ID at the given index of the tokens list owned by the requested address
594    */
595   function tokenOfOwnerByIndex(
596     address _owner,
597     uint256 _index
598   )
599     public
600     view
601     returns (uint256)
602   {
603     require(_index < balanceOf(_owner));
604     return ownedTokens[_owner][_index];
605   }
606 
607   /**
608    * @dev Gets the total amount of tokens stored by the contract
609    * @return uint256 representing the total amount of tokens
610    */
611   function totalSupply() public view returns (uint256) {
612     return allTokens.length;
613   }
614 
615   /**
616    * @dev Gets the token ID at a given index of all the tokens in this contract
617    * @dev Reverts if the index is greater or equal to the total number of tokens
618    * @param _index uint256 representing the index to be accessed of the tokens list
619    * @return uint256 token ID at the given index of the tokens list
620    */
621   function tokenByIndex(uint256 _index) public view returns (uint256) {
622     require(_index < totalSupply());
623     return allTokens[_index];
624   }
625 
626   /**
627    * @dev Internal function to set the token URI for a given token
628    * @dev Reverts if the token ID does not exist
629    * @param _tokenId uint256 ID of the token to set its URI
630    * @param _uri string URI to assign
631    */
632   function _setTokenURI(uint256 _tokenId, string _uri) internal {
633     require(exists(_tokenId));
634     tokenURIs[_tokenId] = _uri;
635   }
636 
637   /**
638    * @dev Internal function to add a token ID to the list of a given address
639    * @param _to address representing the new owner of the given token ID
640    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
641    */
642   function addTokenTo(address _to, uint256 _tokenId) internal {
643     super.addTokenTo(_to, _tokenId);
644     uint256 length = ownedTokens[_to].length;
645     ownedTokens[_to].push(_tokenId);
646     ownedTokensIndex[_tokenId] = length;
647   }
648 
649   /**
650    * @dev Internal function to remove a token ID from the list of a given address
651    * @param _from address representing the previous owner of the given token ID
652    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
653    */
654   function removeTokenFrom(address _from, uint256 _tokenId) internal {
655     super.removeTokenFrom(_from, _tokenId);
656 
657     uint256 tokenIndex = ownedTokensIndex[_tokenId];
658     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
659     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
660 
661     ownedTokens[_from][tokenIndex] = lastToken;
662     ownedTokens[_from][lastTokenIndex] = 0;
663     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
664     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
665     // the lastToken to the first position, and then dropping the element placed in the last position of the list
666 
667     ownedTokens[_from].length--;
668     ownedTokensIndex[_tokenId] = 0;
669     ownedTokensIndex[lastToken] = tokenIndex;
670   }
671 
672   /**
673    * @dev Internal function to mint a new token
674    * @dev Reverts if the given token ID already exists
675    * @param _to address the beneficiary that will own the minted token
676    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
677    */
678   function _mint(address _to, uint256 _tokenId) internal {
679     super._mint(_to, _tokenId);
680 
681     allTokensIndex[_tokenId] = allTokens.length;
682     allTokens.push(_tokenId);
683   }
684 
685   /**
686    * @dev Internal function to burn a specific token
687    * @dev Reverts if the token does not exist
688    * @param _owner owner of the token to burn
689    * @param _tokenId uint256 ID of the token being burned by the msg.sender
690    */
691   function _burn(address _owner, uint256 _tokenId) internal {
692     super._burn(_owner, _tokenId);
693 
694     // Clear metadata (if any)
695     if (bytes(tokenURIs[_tokenId]).length != 0) {
696       delete tokenURIs[_tokenId];
697     }
698 
699     // Reorg all tokens array
700     uint256 tokenIndex = allTokensIndex[_tokenId];
701     uint256 lastTokenIndex = allTokens.length.sub(1);
702     uint256 lastToken = allTokens[lastTokenIndex];
703 
704     allTokens[tokenIndex] = lastToken;
705     allTokens[lastTokenIndex] = 0;
706 
707     allTokens.length--;
708     allTokensIndex[_tokenId] = 0;
709     allTokensIndex[lastToken] = tokenIndex;
710   }
711 
712 }
713 
714 contract MTComicsArtefact  is Ownable, ERC721Token {
715     uint internal incrementId = 0;
716     address public manager;
717 
718     struct ArtefactType {
719         uint id;
720         string name;
721         uint count;
722         bool distributionStarted;
723     }
724 
725     struct Artefact {
726         uint id;
727         uint typeId;
728     }
729 
730     mapping(uint => ArtefactType) public types;
731     mapping(uint => Artefact) public artefacts;
732     mapping(address => uint[]) public artefactReceived;
733 
734     modifier onlyOwnerOrManager() {
735         require(msg.sender == owner || manager == msg.sender);
736         _;
737     }
738 
739     constructor (address _manager) public ERC721Token("MTComicsArtefact Token", "MTCAT") {
740         manager = _manager;
741     }
742 
743     function getArtefact(uint typeId) public {
744         for (uint i = 0; i < artefactReceived[msg.sender].length; i++) {
745             require(artefactReceived[msg.sender][i] != typeId);
746         }
747         require(types[typeId].count > 0 && types[typeId].distributionStarted);
748         artefactReceived[msg.sender].push(typeId);
749         incrementId++;
750         super._mint(msg.sender, incrementId);
751         artefacts[incrementId] = Artefact(incrementId, typeId);
752         types[typeId].count -= 1;
753     }
754 
755     function mint(address to, uint typeId) public onlyOwnerOrManager {
756         incrementId++;
757         super._mint(to, incrementId);
758         artefacts[incrementId] = Artefact(incrementId, typeId);
759     }
760 
761     function burn(uint tokenId) public onlyOwnerOf(tokenId) {
762         super._burn(msg.sender, tokenId);
763         delete artefacts[tokenId];
764     }
765 
766     function setManager(address _manager) public onlyOwner {
767         manager = _manager;
768     }
769 
770     function setType(uint id, string name, uint count) public onlyOwnerOrManager {
771         types[id].id = id;
772         types[id].name = name;
773         types[id].count = count;
774         types[id].distributionStarted = false;
775     }
776 
777     function setDistribution(uint id, bool isDistributionStarted) public onlyOwnerOrManager {
778         types[id].distributionStarted = isDistributionStarted;
779     }
780 }