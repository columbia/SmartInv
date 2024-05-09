1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * Utility library of inline functions on addresses
55  */
56 library AddressUtils {
57 
58   /**
59    * Returns whether the target address is a contract
60    * @dev This function will return false if invoked during the constructor of a contract,
61    * as the code is not actually created until after the constructor finishes.
62    * @param addr address to check
63    * @return whether the target address is a contract
64    */
65   function isContract(address addr) internal view returns (bool) {
66     uint256 size;
67     // XXX Currently there is no better way to check if there is a contract in an address
68     // than to check the size of the code at that address.
69     // See https://ethereum.stackexchange.com/a/14016/36603
70     // for more details about how this works.
71     // TODO Check this again before the Serenity release, because all addresses will be
72     // contracts then.
73     // solium-disable-next-line security/no-inline-assembly
74     assembly { size := extcodesize(addr) }
75     return size > 0;
76   }
77 
78 }
79 
80 /**
81  * @title ERC165
82  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
83  */
84 interface ERC165 {
85 
86   /**
87    * @notice Query if a contract implements an interface
88    * @param _interfaceId The interface identifier, as specified in ERC-165
89    * @dev Interface identification is specified in ERC-165. This function
90    * uses less than 30,000 gas.
91    */
92   function supportsInterface(bytes4 _interfaceId)
93     external
94     view
95     returns (bool);
96 }
97 
98 
99 /**
100  * @title SupportsInterfaceWithLookup
101  * @author Matt Condon (@shrugs)
102  * @dev Implements ERC165 using a lookup table.
103  */
104 contract SupportsInterfaceWithLookup is ERC165 {
105   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
106   /**
107    * 0x01ffc9a7 ===
108    *   bytes4(keccak256('supportsInterface(bytes4)'))
109    */
110 
111   /**
112    * @dev a mapping of interface id to whether or not it's supported
113    */
114   mapping(bytes4 => bool) internal supportedInterfaces;
115 
116   /**
117    * @dev A contract implementing SupportsInterfaceWithLookup
118    * implement ERC165 itself
119    */
120   constructor()
121     public
122   {
123     _registerInterface(InterfaceId_ERC165);
124   }
125 
126   /**
127    * @dev implement supportsInterface(bytes4) using a lookup table
128    */
129   function supportsInterface(bytes4 _interfaceId)
130     external
131     view
132     returns (bool)
133   {
134     return supportedInterfaces[_interfaceId];
135   }
136 
137   /**
138    * @dev private method for registering an interface
139    */
140   function _registerInterface(bytes4 _interfaceId)
141     internal
142   {
143     require(_interfaceId != 0xffffffff);
144     supportedInterfaces[_interfaceId] = true;
145   }
146 }
147 
148 /**
149  * @title ERC721 token receiver interface
150  * @dev Interface for any contract that wants to support safeTransfers
151  * from ERC721 asset contracts.
152  */
153 contract ERC721Receiver {
154   /**
155    * @dev Magic value to be returned upon successful reception of an NFT
156    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
157    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
158    */
159   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
160 
161   /**
162    * @notice Handle the receipt of an NFT
163    * @dev The ERC721 smart contract calls this function on the recipient
164    * after a `safetransfer`. This function MAY throw to revert and reject the
165    * transfer. Return of other than the magic value MUST result in the 
166    * transaction being reverted.
167    * Note: the contract address is always the message sender.
168    * @param _operator The address which called `safeTransferFrom` function
169    * @param _from The address which previously owned the token
170    * @param _tokenId The NFT identifier which is being transfered
171    * @param _data Additional data with no specified format
172    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
173    */
174   function onERC721Received(
175     address _operator,
176     address _from,
177     uint256 _tokenId,
178     bytes _data
179   )
180     public
181     returns(bytes4);
182 }
183 
184 /**
185  * @title ERC721 Non-Fungible Token Standard basic interface
186  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
187  */
188 contract ERC721Basic is ERC165 {
189   event Transfer(
190     address indexed _from,
191     address indexed _to,
192     uint256 indexed _tokenId
193   );
194   event Approval(
195     address indexed _owner,
196     address indexed _approved,
197     uint256 indexed _tokenId
198   );
199   event ApprovalForAll(
200     address indexed _owner,
201     address indexed _operator,
202     bool _approved
203   );
204 
205   function balanceOf(address _owner) public view returns (uint256 _balance);
206   function ownerOf(uint256 _tokenId) public view returns (address _owner);
207   function exists(uint256 _tokenId) public view returns (bool _exists);
208 
209   function approve(address _to, uint256 _tokenId) public;
210   function getApproved(uint256 _tokenId)
211     public view returns (address _operator);
212 
213   function setApprovalForAll(address _operator, bool _approved) public;
214   function isApprovedForAll(address _owner, address _operator)
215     public view returns (bool);
216 
217   function transferFrom(address _from, address _to, uint256 _tokenId) public;
218   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
219     public;
220 
221   function safeTransferFrom(
222     address _from,
223     address _to,
224     uint256 _tokenId,
225     bytes _data
226   )
227     public;
228 }
229 
230 /**
231  * @title ERC721 Non-Fungible Token Standard basic implementation
232  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
233  */
234 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
235 
236   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
237   /*
238    * 0x80ac58cd ===
239    *   bytes4(keccak256('balanceOf(address)')) ^
240    *   bytes4(keccak256('ownerOf(uint256)')) ^
241    *   bytes4(keccak256('approve(address,uint256)')) ^
242    *   bytes4(keccak256('getApproved(uint256)')) ^
243    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
244    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
245    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
246    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
247    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
248    */
249 
250   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
251   /*
252    * 0x4f558e79 ===
253    *   bytes4(keccak256('exists(uint256)'))
254    */
255 
256   using SafeMath for uint256;
257   using AddressUtils for address;
258 
259   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
260   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
261   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
262 
263   // Mapping from token ID to owner
264   mapping (uint256 => address) internal tokenOwner;
265 
266   // Mapping from token ID to approved address
267   mapping (uint256 => address) internal tokenApprovals;
268 
269   // Mapping from owner to number of owned token
270   mapping (address => uint256) internal ownedTokensCount;
271 
272   // Mapping from owner to operator approvals
273   mapping (address => mapping (address => bool)) internal operatorApprovals;
274 
275   /**
276    * @dev Guarantees msg.sender is owner of the given token
277    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
278    */
279   modifier onlyOwnerOf(uint256 _tokenId) {
280     require(ownerOf(_tokenId) == msg.sender);
281     _;
282   }
283 
284   /**
285    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
286    * @param _tokenId uint256 ID of the token to validate
287    */
288   modifier canTransfer(uint256 _tokenId) {
289     require(isApprovedOrOwner(msg.sender, _tokenId));
290     _;
291   }
292 
293   constructor()
294     public
295   {
296     // register the supported interfaces to conform to ERC721 via ERC165
297     _registerInterface(InterfaceId_ERC721);
298     _registerInterface(InterfaceId_ERC721Exists);
299   }
300 
301   /**
302    * @dev Gets the balance of the specified address
303    * @param _owner address to query the balance of
304    * @return uint256 representing the amount owned by the passed address
305    */
306   function balanceOf(address _owner) public view returns (uint256) {
307     require(_owner != address(0));
308     return ownedTokensCount[_owner];
309   }
310 
311   /**
312    * @dev Gets the owner of the specified token ID
313    * @param _tokenId uint256 ID of the token to query the owner of
314    * @return owner address currently marked as the owner of the given token ID
315    */
316   function ownerOf(uint256 _tokenId) public view returns (address) {
317     address owner = tokenOwner[_tokenId];
318     require(owner != address(0));
319     return owner;
320   }
321 
322   /**
323    * @dev Returns whether the specified token exists
324    * @param _tokenId uint256 ID of the token to query the existence of
325    * @return whether the token exists
326    */
327   function exists(uint256 _tokenId) public view returns (bool) {
328     address owner = tokenOwner[_tokenId];
329     return owner != address(0);
330   }
331 
332   /**
333    * @dev Approves another address to transfer the given token ID
334    * The zero address indicates there is no approved address.
335    * There can only be one approved address per token at a given time.
336    * Can only be called by the token owner or an approved operator.
337    * @param _to address to be approved for the given token ID
338    * @param _tokenId uint256 ID of the token to be approved
339    */
340   function approve(address _to, uint256 _tokenId) public {
341     address owner = ownerOf(_tokenId);
342     require(_to != owner);
343     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
344 
345     tokenApprovals[_tokenId] = _to;
346     emit Approval(owner, _to, _tokenId);
347   }
348 
349   /**
350    * @dev Gets the approved address for a token ID, or zero if no address set
351    * @param _tokenId uint256 ID of the token to query the approval of
352    * @return address currently approved for the given token ID
353    */
354   function getApproved(uint256 _tokenId) public view returns (address) {
355     return tokenApprovals[_tokenId];
356   }
357 
358   /**
359    * @dev Sets or unsets the approval of a given operator
360    * An operator is allowed to transfer all tokens of the sender on their behalf
361    * @param _to operator address to set the approval
362    * @param _approved representing the status of the approval to be set
363    */
364   function setApprovalForAll(address _to, bool _approved) public {
365     require(_to != msg.sender);
366     operatorApprovals[msg.sender][_to] = _approved;
367     emit ApprovalForAll(msg.sender, _to, _approved);
368   }
369 
370   /**
371    * @dev Tells whether an operator is approved by a given owner
372    * @param _owner owner address which you want to query the approval of
373    * @param _operator operator address which you want to query the approval of
374    * @return bool whether the given operator is approved by the given owner
375    */
376   function isApprovedForAll(
377     address _owner,
378     address _operator
379   )
380     public
381     view
382     returns (bool)
383   {
384     return operatorApprovals[_owner][_operator];
385   }
386 
387   /**
388    * @dev Transfers the ownership of a given token ID to another address
389    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
390    * Requires the msg sender to be the owner, approved, or operator
391    * @param _from current owner of the token
392    * @param _to address to receive the ownership of the given token ID
393    * @param _tokenId uint256 ID of the token to be transferred
394   */
395   function transferFrom(
396     address _from,
397     address _to,
398     uint256 _tokenId
399   )
400     public
401     canTransfer(_tokenId)
402   {
403     require(_from != address(0));
404     require(_to != address(0));
405 
406     clearApproval(_from, _tokenId);
407     removeTokenFrom(_from, _tokenId);
408     addTokenTo(_to, _tokenId);
409 
410     emit Transfer(_from, _to, _tokenId);
411   }
412 
413   /**
414    * @dev Safely transfers the ownership of a given token ID to another address
415    * If the target address is a contract, it must implement `onERC721Received`,
416    * which is called upon a safe transfer, and return the magic value
417    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
418    * the transfer is reverted.
419    *
420    * Requires the msg sender to be the owner, approved, or operator
421    * @param _from current owner of the token
422    * @param _to address to receive the ownership of the given token ID
423    * @param _tokenId uint256 ID of the token to be transferred
424   */
425   function safeTransferFrom(
426     address _from,
427     address _to,
428     uint256 _tokenId
429   )
430     public
431     canTransfer(_tokenId)
432   {
433     // solium-disable-next-line arg-overflow
434     safeTransferFrom(_from, _to, _tokenId, "");
435   }
436 
437   /**
438    * @dev Safely transfers the ownership of a given token ID to another address
439    * If the target address is a contract, it must implement `onERC721Received`,
440    * which is called upon a safe transfer, and return the magic value
441    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
442    * the transfer is reverted.
443    * Requires the msg sender to be the owner, approved, or operator
444    * @param _from current owner of the token
445    * @param _to address to receive the ownership of the given token ID
446    * @param _tokenId uint256 ID of the token to be transferred
447    * @param _data bytes data to send along with a safe transfer check
448    */
449   function safeTransferFrom(
450     address _from,
451     address _to,
452     uint256 _tokenId,
453     bytes _data
454   )
455     public
456     canTransfer(_tokenId)
457   {
458     transferFrom(_from, _to, _tokenId);
459     // solium-disable-next-line arg-overflow
460     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
461   }
462 
463   /**
464    * @dev Returns whether the given spender can transfer a given token ID
465    * @param _spender address of the spender to query
466    * @param _tokenId uint256 ID of the token to be transferred
467    * @return bool whether the msg.sender is approved for the given token ID,
468    *  is an operator of the owner, or is the owner of the token
469    */
470   function isApprovedOrOwner(
471     address _spender,
472     uint256 _tokenId
473   )
474     internal
475     view
476     returns (bool)
477   {
478     address owner = ownerOf(_tokenId);
479     // Disable solium check because of
480     // https://github.com/duaraghav8/Solium/issues/175
481     // solium-disable-next-line operator-whitespace
482     return (
483       _spender == owner ||
484       getApproved(_tokenId) == _spender ||
485       isApprovedForAll(owner, _spender)
486     );
487   }
488 
489   /**
490    * @dev Internal function to mint a new token
491    * Reverts if the given token ID already exists
492    * @param _to The address that will own the minted token
493    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
494    */
495   function _mint(address _to, uint256 _tokenId) internal {
496     require(_to != address(0));
497     addTokenTo(_to, _tokenId);
498     emit Transfer(address(0), _to, _tokenId);
499   }
500 
501   /**
502    * @dev Internal function to burn a specific token
503    * Reverts if the token does not exist
504    * @param _tokenId uint256 ID of the token being burned by the msg.sender
505    */
506   function _burn(address _owner, uint256 _tokenId) internal {
507     clearApproval(_owner, _tokenId);
508     removeTokenFrom(_owner, _tokenId);
509     emit Transfer(_owner, address(0), _tokenId);
510   }
511 
512   /**
513    * @dev Internal function to clear current approval of a given token ID
514    * Reverts if the given address is not indeed the owner of the token
515    * @param _owner owner of the token
516    * @param _tokenId uint256 ID of the token to be transferred
517    */
518   function clearApproval(address _owner, uint256 _tokenId) internal {
519     require(ownerOf(_tokenId) == _owner);
520     if (tokenApprovals[_tokenId] != address(0)) {
521       tokenApprovals[_tokenId] = address(0);
522     }
523   }
524 
525   /**
526    * @dev Internal function to add a token ID to the list of a given address
527    * @param _to address representing the new owner of the given token ID
528    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
529    */
530   function addTokenTo(address _to, uint256 _tokenId) internal {
531     require(tokenOwner[_tokenId] == address(0));
532     tokenOwner[_tokenId] = _to;
533     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
534   }
535 
536   /**
537    * @dev Internal function to remove a token ID from the list of a given address
538    * @param _from address representing the previous owner of the given token ID
539    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
540    */
541   function removeTokenFrom(address _from, uint256 _tokenId) internal {
542     require(ownerOf(_tokenId) == _from);
543     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
544     tokenOwner[_tokenId] = address(0);
545   }
546 
547   /**
548    * @dev Internal function to invoke `onERC721Received` on a target address
549    * The call is not executed if the target address is not a contract
550    * @param _from address representing the previous owner of the given token ID
551    * @param _to target address that will receive the tokens
552    * @param _tokenId uint256 ID of the token to be transferred
553    * @param _data bytes optional data to send along with the call
554    * @return whether the call correctly returned the expected magic value
555    */
556   function checkAndCallSafeTransfer(
557     address _from,
558     address _to,
559     uint256 _tokenId,
560     bytes _data
561   )
562     internal
563     returns (bool)
564   {
565     if (!_to.isContract()) {
566       return true;
567     }
568     bytes4 retval = ERC721Receiver(_to).onERC721Received(
569       msg.sender, _from, _tokenId, _data);
570     return (retval == ERC721_RECEIVED);
571   }
572 }
573 
574 
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
578  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
579  */
580 contract ERC721Enumerable is ERC721Basic {
581   function totalSupply() public view returns (uint256);
582   function tokenOfOwnerByIndex(
583     address _owner,
584     uint256 _index
585   )
586     public
587     view
588     returns (uint256 _tokenId);
589 
590   function tokenByIndex(uint256 _index) public view returns (uint256);
591 }
592 
593 
594 /**
595  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
596  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
597  */
598 contract ERC721Metadata is ERC721Basic {
599   function name() external view returns (string _name);
600   function symbol() external view returns (string _symbol);
601   function tokenURI(uint256 _tokenId) public view returns (string);
602 }
603 
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
607  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
608  */
609 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
610 }
611 
612 /**
613  * @title Full ERC721 Token
614  * This implementation includes all the required and some optional functionality of the ERC721 standard
615  * Moreover, it includes approve all functionality using operator terminology
616  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
617  */
618 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
619 
620   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
621   /**
622    * 0x780e9d63 ===
623    *   bytes4(keccak256('totalSupply()')) ^
624    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
625    *   bytes4(keccak256('tokenByIndex(uint256)'))
626    */
627 
628   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
629   /**
630    * 0x5b5e139f ===
631    *   bytes4(keccak256('name()')) ^
632    *   bytes4(keccak256('symbol()')) ^
633    *   bytes4(keccak256('tokenURI(uint256)'))
634    */
635 
636   // Token name
637   string internal name_;
638 
639   // Token symbol
640   string internal symbol_;
641 
642   // Mapping from owner to list of owned token IDs
643   mapping(address => uint256[]) internal ownedTokens;
644 
645   // Mapping from token ID to index of the owner tokens list
646   mapping(uint256 => uint256) internal ownedTokensIndex;
647 
648   // Array with all token ids, used for enumeration
649   uint256[] internal allTokens;
650 
651   // Mapping from token id to position in the allTokens array
652   mapping(uint256 => uint256) internal allTokensIndex;
653 
654   // Optional mapping for token URIs
655   mapping(uint256 => string) internal tokenURIs;
656 
657   /**
658    * @dev Constructor function
659    */
660   constructor(string _name, string _symbol) public {
661     name_ = _name;
662     symbol_ = _symbol;
663 
664     // register the supported interfaces to conform to ERC721 via ERC165
665     _registerInterface(InterfaceId_ERC721Enumerable);
666     _registerInterface(InterfaceId_ERC721Metadata);
667   }
668 
669   /**
670    * @dev Gets the token name
671    * @return string representing the token name
672    */
673   function name() external view returns (string) {
674     return name_;
675   }
676 
677   /**
678    * @dev Gets the token symbol
679    * @return string representing the token symbol
680    */
681   function symbol() external view returns (string) {
682     return symbol_;
683   }
684 
685   /**
686    * @dev Returns an URI for a given token ID
687    * Throws if the token ID does not exist. May return an empty string.
688    * @param _tokenId uint256 ID of the token to query
689    */
690   function tokenURI(uint256 _tokenId) public view returns (string) {
691     require(exists(_tokenId));
692     return tokenURIs[_tokenId];
693   }
694 
695   /**
696    * @dev Gets the token ID at a given index of the tokens list of the requested owner
697    * @param _owner address owning the tokens list to be accessed
698    * @param _index uint256 representing the index to be accessed of the requested tokens list
699    * @return uint256 token ID at the given index of the tokens list owned by the requested address
700    */
701   function tokenOfOwnerByIndex(
702     address _owner,
703     uint256 _index
704   )
705     public
706     view
707     returns (uint256)
708   {
709     require(_index < balanceOf(_owner));
710     return ownedTokens[_owner][_index];
711   }
712 
713   /**
714    * @dev Gets the total amount of tokens stored by the contract
715    * @return uint256 representing the total amount of tokens
716    */
717   function totalSupply() public view returns (uint256) {
718     return allTokens.length;
719   }
720 
721   /**
722    * @dev Gets the token ID at a given index of all the tokens in this contract
723    * Reverts if the index is greater or equal to the total number of tokens
724    * @param _index uint256 representing the index to be accessed of the tokens list
725    * @return uint256 token ID at the given index of the tokens list
726    */
727   function tokenByIndex(uint256 _index) public view returns (uint256) {
728     require(_index < totalSupply());
729     return allTokens[_index];
730   }
731 
732   /**
733    * @dev Internal function to set the token URI for a given token
734    * Reverts if the token ID does not exist
735    * @param _tokenId uint256 ID of the token to set its URI
736    * @param _uri string URI to assign
737    */
738   function _setTokenURI(uint256 _tokenId, string _uri) internal {
739     require(exists(_tokenId));
740     tokenURIs[_tokenId] = _uri;
741   }
742 
743   /**
744    * @dev Internal function to add a token ID to the list of a given address
745    * @param _to address representing the new owner of the given token ID
746    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
747    */
748   function addTokenTo(address _to, uint256 _tokenId) internal {
749     super.addTokenTo(_to, _tokenId);
750     uint256 length = ownedTokens[_to].length;
751     ownedTokens[_to].push(_tokenId);
752     ownedTokensIndex[_tokenId] = length;
753   }
754 
755   /**
756    * @dev Internal function to remove a token ID from the list of a given address
757    * @param _from address representing the previous owner of the given token ID
758    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
759    */
760   function removeTokenFrom(address _from, uint256 _tokenId) internal {
761     super.removeTokenFrom(_from, _tokenId);
762 
763     uint256 tokenIndex = ownedTokensIndex[_tokenId];
764     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
765     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
766 
767     ownedTokens[_from][tokenIndex] = lastToken;
768     ownedTokens[_from][lastTokenIndex] = 0;
769     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
770     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
771     // the lastToken to the first position, and then dropping the element placed in the last position of the list
772 
773     ownedTokens[_from].length--;
774     ownedTokensIndex[_tokenId] = 0;
775     ownedTokensIndex[lastToken] = tokenIndex;
776   }
777 
778   /**
779    * @dev Internal function to mint a new token
780    * Reverts if the given token ID already exists
781    * @param _to address the beneficiary that will own the minted token
782    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
783    */
784   function _mint(address _to, uint256 _tokenId) internal {
785     super._mint(_to, _tokenId);
786 
787     allTokensIndex[_tokenId] = allTokens.length;
788     allTokens.push(_tokenId);
789   }
790 
791   /**
792    * @dev Internal function to burn a specific token
793    * Reverts if the token does not exist
794    * @param _owner owner of the token to burn
795    * @param _tokenId uint256 ID of the token being burned by the msg.sender
796    */
797   function _burn(address _owner, uint256 _tokenId) internal {
798     super._burn(_owner, _tokenId);
799 
800     // Clear metadata (if any)
801     if (bytes(tokenURIs[_tokenId]).length != 0) {
802       delete tokenURIs[_tokenId];
803     }
804 
805     // Reorg all tokens array
806     uint256 tokenIndex = allTokensIndex[_tokenId];
807     uint256 lastTokenIndex = allTokens.length.sub(1);
808     uint256 lastToken = allTokens[lastTokenIndex];
809 
810     allTokens[tokenIndex] = lastToken;
811     allTokens[lastTokenIndex] = 0;
812 
813     allTokens.length--;
814     allTokensIndex[_tokenId] = 0;
815     allTokensIndex[lastToken] = tokenIndex;
816   }
817 
818 }
819 
820 /**
821  * @title Ownable
822  * @dev The Ownable contract has an owner address, and provides basic authorization control
823  * functions, this simplifies the implementation of "user permissions".
824  */
825 contract Ownable {
826   address public owner;
827 
828 
829   event OwnershipRenounced(address indexed previousOwner);
830   event OwnershipTransferred(
831     address indexed previousOwner,
832     address indexed newOwner
833   );
834 
835 
836   /**
837    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
838    * account.
839    */
840   constructor() public {
841     owner = msg.sender;
842   }
843 
844   /**
845    * @dev Throws if called by any account other than the owner.
846    */
847   modifier onlyOwner() {
848     require(msg.sender == owner);
849     _;
850   }
851 
852   /**
853    * @dev Allows the current owner to relinquish control of the contract.
854    * @notice Renouncing to ownership will leave the contract without an owner.
855    * It will not be possible to call the functions with the `onlyOwner`
856    * modifier anymore.
857    */
858   function renounceOwnership() public onlyOwner {
859     emit OwnershipRenounced(owner);
860     owner = address(0);
861   }
862 
863   /**
864    * @dev Allows the current owner to transfer control of the contract to a newOwner.
865    * @param _newOwner The address to transfer ownership to.
866    */
867   function transferOwnership(address _newOwner) public onlyOwner {
868     _transferOwnership(_newOwner);
869   }
870 
871   /**
872    * @dev Transfers control of the contract to a newOwner.
873    * @param _newOwner The address to transfer ownership to.
874    */
875   function _transferOwnership(address _newOwner) internal {
876     require(_newOwner != address(0));
877     emit OwnershipTransferred(owner, _newOwner);
878     owner = _newOwner;
879   }
880 }
881 
882 /**
883  * @title Roles
884  * @author Francisco Giordano (@frangio)
885  * @dev Library for managing addresses assigned to a Role.
886  * See RBAC.sol for example usage.
887  */
888 library Roles {
889   struct Role {
890     mapping (address => bool) bearer;
891   }
892 
893   /**
894    * @dev give an address access to this role
895    */
896   function add(Role storage role, address addr)
897     internal
898   {
899     role.bearer[addr] = true;
900   }
901 
902   /**
903    * @dev remove an address' access to this role
904    */
905   function remove(Role storage role, address addr)
906     internal
907   {
908     role.bearer[addr] = false;
909   }
910 
911   /**
912    * @dev check if an address has this role
913    * // reverts
914    */
915   function check(Role storage role, address addr)
916     view
917     internal
918   {
919     require(has(role, addr));
920   }
921 
922   /**
923    * @dev check if an address has this role
924    * @return bool
925    */
926   function has(Role storage role, address addr)
927     view
928     internal
929     returns (bool)
930   {
931     return role.bearer[addr];
932   }
933 }
934 
935 
936 /**
937  * @title RBAC (Role-Based Access Control)
938  * @author Matt Condon (@Shrugs)
939  * @dev Stores and provides setters and getters for roles and addresses.
940  * Supports unlimited numbers of roles and addresses.
941  * See //contracts/mocks/RBACMock.sol for an example of usage.
942  * This RBAC method uses strings to key roles. It may be beneficial
943  * for you to write your own implementation of this interface using Enums or similar.
944  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
945  * to avoid typos.
946  */
947 contract RBAC {
948   using Roles for Roles.Role;
949 
950   mapping (string => Roles.Role) private roles;
951 
952   event RoleAdded(address indexed operator, string role);
953   event RoleRemoved(address indexed operator, string role);
954 
955   /**
956    * @dev reverts if addr does not have role
957    * @param _operator address
958    * @param _role the name of the role
959    * // reverts
960    */
961   function checkRole(address _operator, string _role)
962     view
963     public
964   {
965     roles[_role].check(_operator);
966   }
967 
968   /**
969    * @dev determine if addr has role
970    * @param _operator address
971    * @param _role the name of the role
972    * @return bool
973    */
974   function hasRole(address _operator, string _role)
975     view
976     public
977     returns (bool)
978   {
979     return roles[_role].has(_operator);
980   }
981 
982   /**
983    * @dev add a role to an address
984    * @param _operator address
985    * @param _role the name of the role
986    */
987   function addRole(address _operator, string _role)
988     internal
989   {
990     roles[_role].add(_operator);
991     emit RoleAdded(_operator, _role);
992   }
993 
994   /**
995    * @dev remove a role from an address
996    * @param _operator address
997    * @param _role the name of the role
998    */
999   function removeRole(address _operator, string _role)
1000     internal
1001   {
1002     roles[_role].remove(_operator);
1003     emit RoleRemoved(_operator, _role);
1004   }
1005 
1006   /**
1007    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1008    * @param _role the name of the role
1009    * // reverts
1010    */
1011   modifier onlyRole(string _role)
1012   {
1013     checkRole(msg.sender, _role);
1014     _;
1015   }
1016 
1017   /**
1018    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1019    * @param _roles the names of the roles to scope access to
1020    * // reverts
1021    *
1022    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1023    *  see: https://github.com/ethereum/solidity/issues/2467
1024    */
1025   // modifier onlyRoles(string[] _roles) {
1026   //     bool hasAnyRole = false;
1027   //     for (uint8 i = 0; i < _roles.length; i++) {
1028   //         if (hasRole(msg.sender, _roles[i])) {
1029   //             hasAnyRole = true;
1030   //             break;
1031   //         }
1032   //     }
1033 
1034   //     require(hasAnyRole);
1035 
1036   //     _;
1037   // }
1038 }
1039 
1040 /**
1041  * @title Whitelist
1042  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1043  * This simplifies the implementation of "user permissions".
1044  */
1045 contract Whitelist is Ownable, RBAC {
1046   string public constant ROLE_WHITELISTED = "whitelist";
1047 
1048   /**
1049    * @dev Throws if operator is not whitelisted.
1050    * @param _operator address
1051    */
1052   modifier onlyIfWhitelisted(address _operator) {
1053     checkRole(_operator, ROLE_WHITELISTED);
1054     _;
1055   }
1056 
1057   /**
1058    * @dev add an address to the whitelist
1059    * @param _operator address
1060    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1061    */
1062   function addAddressToWhitelist(address _operator)
1063     onlyOwner
1064     public
1065   {
1066     addRole(_operator, ROLE_WHITELISTED);
1067   }
1068 
1069   /**
1070    * @dev getter to determine if address is in whitelist
1071    */
1072   function whitelist(address _operator)
1073     public
1074     view
1075     returns (bool)
1076   {
1077     return hasRole(_operator, ROLE_WHITELISTED);
1078   }
1079 
1080   /**
1081    * @dev add addresses to the whitelist
1082    * @param _operators addresses
1083    * @return true if at least one address was added to the whitelist,
1084    * false if all addresses were already in the whitelist
1085    */
1086   function addAddressesToWhitelist(address[] _operators)
1087     onlyOwner
1088     public
1089   {
1090     for (uint256 i = 0; i < _operators.length; i++) {
1091       addAddressToWhitelist(_operators[i]);
1092     }
1093   }
1094 
1095   /**
1096    * @dev remove an address from the whitelist
1097    * @param _operator address
1098    * @return true if the address was removed from the whitelist,
1099    * false if the address wasn't in the whitelist in the first place
1100    */
1101   function removeAddressFromWhitelist(address _operator)
1102     onlyOwner
1103     public
1104   {
1105     removeRole(_operator, ROLE_WHITELISTED);
1106   }
1107 
1108   /**
1109    * @dev remove addresses from the whitelist
1110    * @param _operators addresses
1111    * @return true if at least one address was removed from the whitelist,
1112    * false if all addresses weren't in the whitelist in the first place
1113    */
1114   function removeAddressesFromWhitelist(address[] _operators)
1115     onlyOwner
1116     public
1117   {
1118     for (uint256 i = 0; i < _operators.length; i++) {
1119       removeAddressFromWhitelist(_operators[i]);
1120     }
1121   }
1122 
1123 }
1124 
1125 contract CrabData {
1126   modifier crabDataLength(uint256[] memory _crabData) {
1127     require(_crabData.length == 8);
1128     _;
1129   }
1130 
1131   struct CrabPartData {
1132     uint256 hp;
1133     uint256 dps;
1134     uint256 blockRate;
1135     uint256 resistanceBonus;
1136     uint256 hpBonus;
1137     uint256 dpsBonus;
1138     uint256 blockBonus;
1139     uint256 mutiplierBonus;
1140   }
1141 
1142   function arrayToCrabPartData(
1143     uint256[] _partData
1144   ) 
1145     internal 
1146     pure 
1147     crabDataLength(_partData) 
1148     returns (CrabPartData memory _parsedData) 
1149   {
1150     _parsedData = CrabPartData(
1151       _partData[0],   // hp
1152       _partData[1],   // dps
1153       _partData[2],   // block rate
1154       _partData[3],   // resistance bonus
1155       _partData[4],   // hp bonus
1156       _partData[5],   // dps bonus
1157       _partData[6],   // block bonus
1158       _partData[7]);  // multiplier bonus
1159   }
1160 
1161   function crabPartDataToArray(CrabPartData _crabPartData) internal pure returns (uint256[] memory _resultData) {
1162     _resultData = new uint256[](8);
1163     _resultData[0] = _crabPartData.hp;
1164     _resultData[1] = _crabPartData.dps;
1165     _resultData[2] = _crabPartData.blockRate;
1166     _resultData[3] = _crabPartData.resistanceBonus;
1167     _resultData[4] = _crabPartData.hpBonus;
1168     _resultData[5] = _crabPartData.dpsBonus;
1169     _resultData[6] = _crabPartData.blockBonus;
1170     _resultData[7] = _crabPartData.mutiplierBonus;
1171   }
1172 }
1173 
1174 
1175 contract GeneSurgeon {
1176   //0 - filler, 1 - body, 2 - leg, 3 - left claw, 4 - right claw
1177   uint256[] internal crabPartMultiplier = [0, 10**9, 10**6, 10**3, 1];
1178 
1179   function extractElementsFromGene(uint256 _gene) internal view returns (uint256[] memory _elements) {
1180     _elements = new uint256[](4);
1181     _elements[0] = _gene / crabPartMultiplier[1] / 100 % 10;
1182     _elements[1] = _gene / crabPartMultiplier[2] / 100 % 10;
1183     _elements[2] = _gene / crabPartMultiplier[3] / 100 % 10;
1184     _elements[3] = _gene / crabPartMultiplier[4] / 100 % 10;
1185   }
1186 
1187   function extractPartsFromGene(uint256 _gene) internal view returns (uint256[] memory _parts) {
1188     _parts = new uint256[](4);
1189     _parts[0] = _gene / crabPartMultiplier[1] % 100;
1190     _parts[1] = _gene / crabPartMultiplier[2] % 100;
1191     _parts[2] = _gene / crabPartMultiplier[3] % 100;
1192     _parts[3] = _gene / crabPartMultiplier[4] % 100;
1193   }
1194 }
1195 
1196 contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
1197   event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);
1198   event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1199   event DefaultMetadataURIChanged(string newUri);
1200 
1201   /**
1202    * @dev Pre-generated keys to save gas
1203    * keys are generated with:
1204    * CRAB_BODY       = bytes4(keccak256("crab_body"))       = 0xc398430e
1205    * CRAB_LEG        = bytes4(keccak256("crab_leg"))        = 0x889063b1
1206    * CRAB_LEFT_CLAW  = bytes4(keccak256("crab_left_claw"))  = 0xdb6290a2
1207    * CRAB_RIGHT_CLAW = bytes4(keccak256("crab_right_claw")) = 0x13453f89
1208    */
1209   bytes4 internal constant CRAB_BODY = 0xc398430e;
1210   bytes4 internal constant CRAB_LEG = 0x889063b1;
1211   bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
1212   bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
1213 
1214   /**
1215    * @dev Stores all the crab data
1216    */
1217   mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
1218 
1219   /**
1220    * @dev Mapping from tokenId to its corresponding special skin
1221    * tokenId with default skin will not be stored. 
1222    */
1223   mapping(uint256 => uint256) internal crabSpecialSkins;
1224 
1225   /**
1226    * @dev default MetadataURI
1227    */
1228   string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";
1229 
1230   constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
1231     // constructor
1232     initiateCrabPartData();
1233   }
1234 
1235   /**
1236    * @dev Returns an URI for a given token ID
1237    * Throws if the token ID does not exist.
1238    * Will return the token's metadata URL if it has one, 
1239    * otherwise will just return base on the default metadata URI
1240    * @param _tokenId uint256 ID of the token to query
1241    */
1242   function tokenURI(uint256 _tokenId) public view returns (string) {
1243     require(exists(_tokenId));
1244 
1245     string memory _uri = tokenURIs[_tokenId];
1246 
1247     if(bytes(_uri).length == 0) {
1248       _uri = getMetadataURL(bytes(defaultMetadataURI), _tokenId);
1249     }
1250 
1251     return _uri;
1252   }
1253 
1254   /**
1255    * @dev Returns the data of a specific parts
1256    * @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1257    * @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1258    * @param _setIndex the set index of for the specified part. This will starts from 1.
1259    */
1260   function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
1261     bytes4 _key;
1262     if(_partIndex == 1) {
1263       _key = CRAB_BODY;
1264     } else if(_partIndex == 2) {
1265       _key = CRAB_LEG;
1266     } else if(_partIndex == 3) {
1267       _key = CRAB_LEFT_CLAW;
1268     } else if(_partIndex == 4) {
1269       _key = CRAB_RIGHT_CLAW;
1270     } else {
1271       revert();
1272     }
1273 
1274     CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
1275 
1276     _resultData = crabPartDataToArray(_crabPartData);
1277   }
1278 
1279   /**
1280    * @dev Gift(Transfer) a token to another address. Caller must be token owner
1281    * @param _from current owner of the token
1282    * @param _to address to receive the ownership of the given token ID
1283    * @param _tokenId uint256 ID of the token to be transferred
1284    */
1285   function giftToken(address _from, address _to, uint256 _tokenId) external {
1286     safeTransferFrom(_from, _to, _tokenId);
1287 
1288     emit GiftTransfered(_from, _to, _tokenId);
1289   }
1290 
1291   /**
1292    * @dev External function to mint a new token, for whitelisted address only.
1293    * Reverts if the given token ID already exists
1294    * @param _tokenOwner address the beneficiary that will own the minted token
1295    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1296    * @param _skinId the skin ID to be applied for all the token minted
1297    */
1298   function mintToken(address _tokenOwner, uint256 _tokenId, uint256 _skinId) external onlyIfWhitelisted(msg.sender) {
1299     super._mint(_tokenOwner, _tokenId);
1300 
1301     if(_skinId > 0) {
1302       crabSpecialSkins[_tokenId] = _skinId;
1303     }
1304   }
1305 
1306   /**
1307    * @dev Returns crab data base on the gene provided
1308    * @param _gene the gene info where crab data will be retrieved base on it
1309    * @return 4 uint arrays:
1310    * 1st Array = Body's Data
1311    * 2nd Array = Leg's Data
1312    * 3rd Array = Left Claw's Data
1313    * 4th Array = Right Claw's Data
1314    */
1315   function crabPartDataFromGene(uint256 _gene) external view returns (
1316     uint256[] _bodyData,
1317     uint256[] _legData,
1318     uint256[] _leftClawData,
1319     uint256[] _rightClawData
1320   ) {
1321     uint256[] memory _parts = extractPartsFromGene(_gene);
1322     uint256[] memory _elements = extractElementsFromGene(_gene);
1323 
1324     _bodyData = dataOfPart(1, _elements[0], _parts[0]);
1325     _legData = dataOfPart(2, _elements[1], _parts[1]);
1326     _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
1327     _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
1328   }
1329 
1330   /**
1331    * @dev For developer to add new parts, notice that this is the only method to add crab data
1332    * so that developer can add extra content. there's no other method for developer to modify
1333    * the data. This is to assure token owner actually owns their data.
1334    * @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1335    * @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1336    * @param _partDataArray data of the parts.
1337    */
1338   function setPartData(uint256 _partIndex, uint256 _element, uint256[] _partDataArray) external onlyOwner {
1339     CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
1340 
1341     bytes4 _key;
1342     if(_partIndex == 1) {
1343       _key = CRAB_BODY;
1344     } else if(_partIndex == 2) {
1345       _key = CRAB_LEG;
1346     } else if(_partIndex == 3) {
1347       _key = CRAB_LEFT_CLAW;
1348     } else if(_partIndex == 4) {
1349       _key = CRAB_RIGHT_CLAW;
1350     }
1351 
1352     // if index 1 is empty will fill at index 1
1353     if(crabPartData[_key][_element][1].hp == 0 && crabPartData[_key][_element][1].dps == 0) {
1354       crabPartData[_key][_element][1] = _partData;
1355     } else {
1356       crabPartData[_key][_element].push(_partData);
1357     }
1358 
1359     emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
1360   }
1361 
1362   /**
1363    * @dev Updates the default metadata URI
1364    * @param _defaultUri the new metadata URI
1365    */
1366   function setDefaultMetadataURI(string _defaultUri) external onlyOwner {
1367     defaultMetadataURI = _defaultUri;
1368 
1369     emit DefaultMetadataURIChanged(_defaultUri);
1370   }
1371 
1372   /**
1373    * @dev Updates the metadata URI for existing token
1374    * @param _tokenId the tokenID that metadata URI to be changed
1375    * @param _uri the new metadata URI for the specified token
1376    */
1377   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
1378     _setTokenURI(_tokenId, _uri);
1379   }
1380 
1381   /**
1382    * @dev Returns the special skin of the provided tokenId
1383    * @param _tokenId cryptant crab's tokenId
1384    * @return Special skin belongs to the _tokenId provided. 
1385    * 0 will be returned if no special skin found.
1386    */
1387   function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
1388     return crabSpecialSkins[_tokenId];
1389   }
1390 
1391   /**
1392    * @dev This functions will adjust the length of crabPartData
1393    * so that when adding data the index can start with 1.
1394    * Reason of doing this is because gene cannot have parts with index 0.
1395    */
1396   function initiateCrabPartData() internal {
1397     require(crabPartData[CRAB_BODY][1].length == 0);
1398 
1399     for(uint256 i = 1 ; i <= 5 ; i++) {
1400       crabPartData[CRAB_BODY][i].length = 2;
1401       crabPartData[CRAB_LEG][i].length = 2;
1402       crabPartData[CRAB_LEFT_CLAW][i].length = 2;
1403       crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
1404     }
1405   }
1406 
1407   /**
1408    * @dev Returns whether the given spender can transfer a given token ID
1409    * @param _spender address of the spender to query
1410    * @param _tokenId uint256 ID of the token to be transferred
1411    * @return bool whether the msg.sender is approved for the given token ID,
1412    *  is an operator of the owner, or is the owner of the token, 
1413    *  or has been whitelisted by contract owner
1414    */
1415   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1416     address owner = ownerOf(_tokenId);
1417     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || whitelist(_spender);
1418   }
1419 
1420   /**
1421    * @dev Will merge the uri and tokenId together. 
1422    * @param _uri URI to be merge. This will be the first part of the result URL.
1423    * @param _tokenId tokenID to be merge. This will be the last part of the result URL.
1424    * @return the merged urL
1425    */
1426   function getMetadataURL(bytes _uri, uint256 _tokenId) internal pure returns (string) {
1427     uint256 _tmpTokenId = _tokenId;
1428     uint256 _tokenLength;
1429 
1430     // Getting the length(number of digits) of token ID
1431     do {
1432       _tokenLength++;
1433       _tmpTokenId /= 10;
1434     } while (_tmpTokenId > 0);
1435 
1436     // creating a byte array with the length of URL + token digits
1437     bytes memory _result = new bytes(_uri.length + _tokenLength);
1438 
1439     // cloning the uri bytes into the result bytes
1440     for(uint256 i = 0 ; i < _uri.length ; i ++) {
1441       _result[i] = _uri[i];
1442     }
1443 
1444     // appending the tokenId to the end of the result bytes
1445     uint256 lastIndex = _result.length - 1;
1446     for(_tmpTokenId = _tokenId ; _tmpTokenId > 0 ; _tmpTokenId /= 10) {
1447       _result[lastIndex--] = byte(48 + _tmpTokenId % 10);
1448     }
1449 
1450     return string(_result);
1451   }
1452 }