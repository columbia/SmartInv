1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
111 
112 /**
113  * @title ERC721 Non-Fungible Token Standard basic interface
114  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
115  */
116 contract ERC721Basic {
117   event Transfer(
118     address indexed _from,
119     address indexed _to,
120     uint256 _tokenId
121   );
122   event Approval(
123     address indexed _owner,
124     address indexed _approved,
125     uint256 _tokenId
126   );
127   event ApprovalForAll(
128     address indexed _owner,
129     address indexed _operator,
130     bool _approved
131   );
132 
133   function balanceOf(address _owner) public view returns (uint256 _balance);
134   function ownerOf(uint256 _tokenId) public view returns (address _owner);
135   function exists(uint256 _tokenId) public view returns (bool _exists);
136 
137   function approve(address _to, uint256 _tokenId) public;
138   function getApproved(uint256 _tokenId)
139     public view returns (address _operator);
140 
141   function setApprovalForAll(address _operator, bool _approved) public;
142   function isApprovedForAll(address _owner, address _operator)
143     public view returns (bool);
144 
145   function transferFrom(address _from, address _to, uint256 _tokenId) public;
146   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
147     public;
148 
149   function safeTransferFrom(
150     address _from,
151     address _to,
152     uint256 _tokenId,
153     bytes _data
154   )
155     public;
156 }
157 
158 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
159 
160 /**
161  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
162  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
163  */
164 contract ERC721Enumerable is ERC721Basic {
165   function totalSupply() public view returns (uint256);
166   function tokenOfOwnerByIndex(
167     address _owner,
168     uint256 _index
169   )
170     public
171     view
172     returns (uint256 _tokenId);
173 
174   function tokenByIndex(uint256 _index) public view returns (uint256);
175 }
176 
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
180  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
181  */
182 contract ERC721Metadata is ERC721Basic {
183   function name() public view returns (string _name);
184   function symbol() public view returns (string _symbol);
185   function tokenURI(uint256 _tokenId) public view returns (string);
186 }
187 
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
191  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
192  */
193 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
194 }
195 
196 // File: openzeppelin-solidity/contracts/AddressUtils.sol
197 
198 /**
199  * Utility library of inline functions on addresses
200  */
201 library AddressUtils {
202 
203   /**
204    * Returns whether the target address is a contract
205    * @dev This function will return false if invoked during the constructor of a contract,
206    *  as the code is not actually created until after the constructor finishes.
207    * @param addr address to check
208    * @return whether the target address is a contract
209    */
210   function isContract(address addr) internal view returns (bool) {
211     uint256 size;
212     // XXX Currently there is no better way to check if there is a contract in an address
213     // than to check the size of the code at that address.
214     // See https://ethereum.stackexchange.com/a/14016/36603
215     // for more details about how this works.
216     // TODO Check this again before the Serenity release, because all addresses will be
217     // contracts then.
218     // solium-disable-next-line security/no-inline-assembly
219     assembly { size := extcodesize(addr) }
220     return size > 0;
221   }
222 
223 }
224 
225 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
226 
227 /**
228  * @title SafeMath
229  * @dev Math operations with safety checks that throw on error
230  */
231 library SafeMath {
232 
233   /**
234   * @dev Multiplies two numbers, throws on overflow.
235   */
236   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
237     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
238     // benefit is lost if 'b' is also tested.
239     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
240     if (a == 0) {
241       return 0;
242     }
243 
244     c = a * b;
245     assert(c / a == b);
246     return c;
247   }
248 
249   /**
250   * @dev Integer division of two numbers, truncating the quotient.
251   */
252   function div(uint256 a, uint256 b) internal pure returns (uint256) {
253     // assert(b > 0); // Solidity automatically throws when dividing by 0
254     // uint256 c = a / b;
255     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256     return a / b;
257   }
258 
259   /**
260   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
261   */
262   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263     assert(b <= a);
264     return a - b;
265   }
266 
267   /**
268   * @dev Adds two numbers, throws on overflow.
269   */
270   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
271     c = a + b;
272     assert(c >= a);
273     return c;
274   }
275 }
276 
277 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
278 
279 /**
280  * @title ERC721 token receiver interface
281  * @dev Interface for any contract that wants to support safeTransfers
282  *  from ERC721 asset contracts.
283  */
284 contract ERC721Receiver {
285   /**
286    * @dev Magic value to be returned upon successful reception of an NFT
287    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
288    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
289    */
290   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
291 
292   /**
293    * @notice Handle the receipt of an NFT
294    * @dev The ERC721 smart contract calls this function on the recipient
295    *  after a `safetransfer`. This function MAY throw to revert and reject the
296    *  transfer. This function MUST use 50,000 gas or less. Return of other
297    *  than the magic value MUST result in the transaction being reverted.
298    *  Note: the contract address is always the message sender.
299    * @param _from The sending address
300    * @param _tokenId The NFT identifier which is being transfered
301    * @param _data Additional data with no specified format
302    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
303    */
304   function onERC721Received(
305     address _from,
306     uint256 _tokenId,
307     bytes _data
308   )
309     public
310     returns(bytes4);
311 }
312 
313 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
314 
315 /**
316  * @title ERC721 Non-Fungible Token Standard basic implementation
317  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
318  */
319 contract ERC721BasicToken is ERC721Basic {
320   using SafeMath for uint256;
321   using AddressUtils for address;
322 
323   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
324   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
325   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
326 
327   // Mapping from token ID to owner
328   mapping (uint256 => address) internal tokenOwner;
329 
330   // Mapping from token ID to approved address
331   mapping (uint256 => address) internal tokenApprovals;
332 
333   // Mapping from owner to number of owned token
334   mapping (address => uint256) internal ownedTokensCount;
335 
336   // Mapping from owner to operator approvals
337   mapping (address => mapping (address => bool)) internal operatorApprovals;
338 
339   /**
340    * @dev Guarantees msg.sender is owner of the given token
341    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
342    */
343   modifier onlyOwnerOf(uint256 _tokenId) {
344     require(ownerOf(_tokenId) == msg.sender);
345     _;
346   }
347 
348   /**
349    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
350    * @param _tokenId uint256 ID of the token to validate
351    */
352   modifier canTransfer(uint256 _tokenId) {
353     require(isApprovedOrOwner(msg.sender, _tokenId));
354     _;
355   }
356 
357   /**
358    * @dev Gets the balance of the specified address
359    * @param _owner address to query the balance of
360    * @return uint256 representing the amount owned by the passed address
361    */
362   function balanceOf(address _owner) public view returns (uint256) {
363     require(_owner != address(0));
364     return ownedTokensCount[_owner];
365   }
366 
367   /**
368    * @dev Gets the owner of the specified token ID
369    * @param _tokenId uint256 ID of the token to query the owner of
370    * @return owner address currently marked as the owner of the given token ID
371    */
372   function ownerOf(uint256 _tokenId) public view returns (address) {
373     address owner = tokenOwner[_tokenId];
374     require(owner != address(0));
375     return owner;
376   }
377 
378   /**
379    * @dev Returns whether the specified token exists
380    * @param _tokenId uint256 ID of the token to query the existence of
381    * @return whether the token exists
382    */
383   function exists(uint256 _tokenId) public view returns (bool) {
384     address owner = tokenOwner[_tokenId];
385     return owner != address(0);
386   }
387 
388   /**
389    * @dev Approves another address to transfer the given token ID
390    * @dev The zero address indicates there is no approved address.
391    * @dev There can only be one approved address per token at a given time.
392    * @dev Can only be called by the token owner or an approved operator.
393    * @param _to address to be approved for the given token ID
394    * @param _tokenId uint256 ID of the token to be approved
395    */
396   function approve(address _to, uint256 _tokenId) public {
397     address owner = ownerOf(_tokenId);
398     require(_to != owner);
399     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
400 
401     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
402       tokenApprovals[_tokenId] = _to;
403       emit Approval(owner, _to, _tokenId);
404     }
405   }
406 
407   /**
408    * @dev Gets the approved address for a token ID, or zero if no address set
409    * @param _tokenId uint256 ID of the token to query the approval of
410    * @return address currently approved for the given token ID
411    */
412   function getApproved(uint256 _tokenId) public view returns (address) {
413     return tokenApprovals[_tokenId];
414   }
415 
416   /**
417    * @dev Sets or unsets the approval of a given operator
418    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
419    * @param _to operator address to set the approval
420    * @param _approved representing the status of the approval to be set
421    */
422   function setApprovalForAll(address _to, bool _approved) public {
423     require(_to != msg.sender);
424     operatorApprovals[msg.sender][_to] = _approved;
425     emit ApprovalForAll(msg.sender, _to, _approved);
426   }
427 
428   /**
429    * @dev Tells whether an operator is approved by a given owner
430    * @param _owner owner address which you want to query the approval of
431    * @param _operator operator address which you want to query the approval of
432    * @return bool whether the given operator is approved by the given owner
433    */
434   function isApprovedForAll(
435     address _owner,
436     address _operator
437   )
438     public
439     view
440     returns (bool)
441   {
442     return operatorApprovals[_owner][_operator];
443   }
444 
445   /**
446    * @dev Transfers the ownership of a given token ID to another address
447    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
448    * @dev Requires the msg sender to be the owner, approved, or operator
449    * @param _from current owner of the token
450    * @param _to address to receive the ownership of the given token ID
451    * @param _tokenId uint256 ID of the token to be transferred
452   */
453   function transferFrom(
454     address _from,
455     address _to,
456     uint256 _tokenId
457   )
458     public
459     canTransfer(_tokenId)
460   {
461     require(_from != address(0));
462     require(_to != address(0));
463 
464     clearApproval(_from, _tokenId);
465     removeTokenFrom(_from, _tokenId);
466     addTokenTo(_to, _tokenId);
467 
468     emit Transfer(_from, _to, _tokenId);
469   }
470 
471   /**
472    * @dev Safely transfers the ownership of a given token ID to another address
473    * @dev If the target address is a contract, it must implement `onERC721Received`,
474    *  which is called upon a safe transfer, and return the magic value
475    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
476    *  the transfer is reverted.
477    * @dev Requires the msg sender to be the owner, approved, or operator
478    * @param _from current owner of the token
479    * @param _to address to receive the ownership of the given token ID
480    * @param _tokenId uint256 ID of the token to be transferred
481   */
482   function safeTransferFrom(
483     address _from,
484     address _to,
485     uint256 _tokenId
486   )
487     public
488     canTransfer(_tokenId)
489   {
490     // solium-disable-next-line arg-overflow
491     safeTransferFrom(_from, _to, _tokenId, "");
492   }
493 
494   /**
495    * @dev Safely transfers the ownership of a given token ID to another address
496    * @dev If the target address is a contract, it must implement `onERC721Received`,
497    *  which is called upon a safe transfer, and return the magic value
498    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
499    *  the transfer is reverted.
500    * @dev Requires the msg sender to be the owner, approved, or operator
501    * @param _from current owner of the token
502    * @param _to address to receive the ownership of the given token ID
503    * @param _tokenId uint256 ID of the token to be transferred
504    * @param _data bytes data to send along with a safe transfer check
505    */
506   function safeTransferFrom(
507     address _from,
508     address _to,
509     uint256 _tokenId,
510     bytes _data
511   )
512     public
513     canTransfer(_tokenId)
514   {
515     transferFrom(_from, _to, _tokenId);
516     // solium-disable-next-line arg-overflow
517     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
518   }
519 
520   /**
521    * @dev Returns whether the given spender can transfer a given token ID
522    * @param _spender address of the spender to query
523    * @param _tokenId uint256 ID of the token to be transferred
524    * @return bool whether the msg.sender is approved for the given token ID,
525    *  is an operator of the owner, or is the owner of the token
526    */
527   function isApprovedOrOwner(
528     address _spender,
529     uint256 _tokenId
530   )
531     internal
532     view
533     returns (bool)
534   {
535     address owner = ownerOf(_tokenId);
536     // Disable solium check because of
537     // https://github.com/duaraghav8/Solium/issues/175
538     // solium-disable-next-line operator-whitespace
539     return (
540       _spender == owner ||
541       getApproved(_tokenId) == _spender ||
542       isApprovedForAll(owner, _spender)
543     );
544   }
545 
546   /**
547    * @dev Internal function to mint a new token
548    * @dev Reverts if the given token ID already exists
549    * @param _to The address that will own the minted token
550    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
551    */
552   function _mint(address _to, uint256 _tokenId) internal {
553     require(_to != address(0));
554     addTokenTo(_to, _tokenId);
555     emit Transfer(address(0), _to, _tokenId);
556   }
557 
558   /**
559    * @dev Internal function to burn a specific token
560    * @dev Reverts if the token does not exist
561    * @param _tokenId uint256 ID of the token being burned by the msg.sender
562    */
563   function _burn(address _owner, uint256 _tokenId) internal {
564     clearApproval(_owner, _tokenId);
565     removeTokenFrom(_owner, _tokenId);
566     emit Transfer(_owner, address(0), _tokenId);
567   }
568 
569   /**
570    * @dev Internal function to clear current approval of a given token ID
571    * @dev Reverts if the given address is not indeed the owner of the token
572    * @param _owner owner of the token
573    * @param _tokenId uint256 ID of the token to be transferred
574    */
575   function clearApproval(address _owner, uint256 _tokenId) internal {
576     require(ownerOf(_tokenId) == _owner);
577     if (tokenApprovals[_tokenId] != address(0)) {
578       tokenApprovals[_tokenId] = address(0);
579       emit Approval(_owner, address(0), _tokenId);
580     }
581   }
582 
583   /**
584    * @dev Internal function to add a token ID to the list of a given address
585    * @param _to address representing the new owner of the given token ID
586    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
587    */
588   function addTokenTo(address _to, uint256 _tokenId) internal {
589     require(tokenOwner[_tokenId] == address(0));
590     tokenOwner[_tokenId] = _to;
591     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
592   }
593 
594   /**
595    * @dev Internal function to remove a token ID from the list of a given address
596    * @param _from address representing the previous owner of the given token ID
597    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
598    */
599   function removeTokenFrom(address _from, uint256 _tokenId) internal {
600     require(ownerOf(_tokenId) == _from);
601     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
602     tokenOwner[_tokenId] = address(0);
603   }
604 
605   /**
606    * @dev Internal function to invoke `onERC721Received` on a target address
607    * @dev The call is not executed if the target address is not a contract
608    * @param _from address representing the previous owner of the given token ID
609    * @param _to target address that will receive the tokens
610    * @param _tokenId uint256 ID of the token to be transferred
611    * @param _data bytes optional data to send along with the call
612    * @return whether the call correctly returned the expected magic value
613    */
614   function checkAndCallSafeTransfer(
615     address _from,
616     address _to,
617     uint256 _tokenId,
618     bytes _data
619   )
620     internal
621     returns (bool)
622   {
623     if (!_to.isContract()) {
624       return true;
625     }
626     bytes4 retval = ERC721Receiver(_to).onERC721Received(
627       _from, _tokenId, _data);
628     return (retval == ERC721_RECEIVED);
629   }
630 }
631 
632 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
633 
634 /**
635  * @title Full ERC721 Token
636  * This implementation includes all the required and some optional functionality of the ERC721 standard
637  * Moreover, it includes approve all functionality using operator terminology
638  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
639  */
640 contract ERC721Token is ERC721, ERC721BasicToken {
641   // Token name
642   string internal name_;
643 
644   // Token symbol
645   string internal symbol_;
646 
647   // Mapping from owner to list of owned token IDs
648   mapping(address => uint256[]) internal ownedTokens;
649 
650   // Mapping from token ID to index of the owner tokens list
651   mapping(uint256 => uint256) internal ownedTokensIndex;
652 
653   // Array with all token ids, used for enumeration
654   uint256[] internal allTokens;
655 
656   // Mapping from token id to position in the allTokens array
657   mapping(uint256 => uint256) internal allTokensIndex;
658 
659   // Optional mapping for token URIs
660   mapping(uint256 => string) internal tokenURIs;
661 
662   /**
663    * @dev Constructor function
664    */
665   constructor(string _name, string _symbol) public {
666     name_ = _name;
667     symbol_ = _symbol;
668   }
669 
670   /**
671    * @dev Gets the token name
672    * @return string representing the token name
673    */
674   function name() public view returns (string) {
675     return name_;
676   }
677 
678   /**
679    * @dev Gets the token symbol
680    * @return string representing the token symbol
681    */
682   function symbol() public view returns (string) {
683     return symbol_;
684   }
685 
686   /**
687    * @dev Returns an URI for a given token ID
688    * @dev Throws if the token ID does not exist. May return an empty string.
689    * @param _tokenId uint256 ID of the token to query
690    */
691   function tokenURI(uint256 _tokenId) public view returns (string) {
692     require(exists(_tokenId));
693     return tokenURIs[_tokenId];
694   }
695 
696   /**
697    * @dev Gets the token ID at a given index of the tokens list of the requested owner
698    * @param _owner address owning the tokens list to be accessed
699    * @param _index uint256 representing the index to be accessed of the requested tokens list
700    * @return uint256 token ID at the given index of the tokens list owned by the requested address
701    */
702   function tokenOfOwnerByIndex(
703     address _owner,
704     uint256 _index
705   )
706     public
707     view
708     returns (uint256)
709   {
710     require(_index < balanceOf(_owner));
711     return ownedTokens[_owner][_index];
712   }
713 
714   /**
715    * @dev Gets the total amount of tokens stored by the contract
716    * @return uint256 representing the total amount of tokens
717    */
718   function totalSupply() public view returns (uint256) {
719     return allTokens.length;
720   }
721 
722   /**
723    * @dev Gets the token ID at a given index of all the tokens in this contract
724    * @dev Reverts if the index is greater or equal to the total number of tokens
725    * @param _index uint256 representing the index to be accessed of the tokens list
726    * @return uint256 token ID at the given index of the tokens list
727    */
728   function tokenByIndex(uint256 _index) public view returns (uint256) {
729     require(_index < totalSupply());
730     return allTokens[_index];
731   }
732 
733   /**
734    * @dev Internal function to set the token URI for a given token
735    * @dev Reverts if the token ID does not exist
736    * @param _tokenId uint256 ID of the token to set its URI
737    * @param _uri string URI to assign
738    */
739   function _setTokenURI(uint256 _tokenId, string _uri) internal {
740     require(exists(_tokenId));
741     tokenURIs[_tokenId] = _uri;
742   }
743 
744   /**
745    * @dev Internal function to add a token ID to the list of a given address
746    * @param _to address representing the new owner of the given token ID
747    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
748    */
749   function addTokenTo(address _to, uint256 _tokenId) internal {
750     super.addTokenTo(_to, _tokenId);
751     uint256 length = ownedTokens[_to].length;
752     ownedTokens[_to].push(_tokenId);
753     ownedTokensIndex[_tokenId] = length;
754   }
755 
756   /**
757    * @dev Internal function to remove a token ID from the list of a given address
758    * @param _from address representing the previous owner of the given token ID
759    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
760    */
761   function removeTokenFrom(address _from, uint256 _tokenId) internal {
762     super.removeTokenFrom(_from, _tokenId);
763 
764     uint256 tokenIndex = ownedTokensIndex[_tokenId];
765     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
766     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
767 
768     ownedTokens[_from][tokenIndex] = lastToken;
769     ownedTokens[_from][lastTokenIndex] = 0;
770     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
771     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
772     // the lastToken to the first position, and then dropping the element placed in the last position of the list
773 
774     ownedTokens[_from].length--;
775     ownedTokensIndex[_tokenId] = 0;
776     ownedTokensIndex[lastToken] = tokenIndex;
777   }
778 
779   /**
780    * @dev Internal function to mint a new token
781    * @dev Reverts if the given token ID already exists
782    * @param _to address the beneficiary that will own the minted token
783    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
784    */
785   function _mint(address _to, uint256 _tokenId) internal {
786     super._mint(_to, _tokenId);
787 
788     allTokensIndex[_tokenId] = allTokens.length;
789     allTokens.push(_tokenId);
790   }
791 
792   /**
793    * @dev Internal function to burn a specific token
794    * @dev Reverts if the token does not exist
795    * @param _owner owner of the token to burn
796    * @param _tokenId uint256 ID of the token being burned by the msg.sender
797    */
798   function _burn(address _owner, uint256 _tokenId) internal {
799     super._burn(_owner, _tokenId);
800 
801     // Clear metadata (if any)
802     if (bytes(tokenURIs[_tokenId]).length != 0) {
803       delete tokenURIs[_tokenId];
804     }
805 
806     // Reorg all tokens array
807     uint256 tokenIndex = allTokensIndex[_tokenId];
808     uint256 lastTokenIndex = allTokens.length.sub(1);
809     uint256 lastToken = allTokens[lastTokenIndex];
810 
811     allTokens[tokenIndex] = lastToken;
812     allTokens[lastTokenIndex] = 0;
813 
814     allTokens.length--;
815     allTokensIndex[_tokenId] = 0;
816     allTokensIndex[lastToken] = tokenIndex;
817   }
818 
819 }
820 
821 // File: contracts/Invite.sol
822 
823 contract DecentralandInvite is ERC721Token, Ownable, Pausable {
824   mapping (address => uint256) public balance;
825   mapping (uint256 => bytes) public metadata;
826 
827   event Invited(address who, address target, uint256 id, bytes note);
828   event UpdateInvites(address who, uint256 amount);
829   event URIUpdated(uint256 id, string newUri);
830 
831   constructor() public ERC721Token("Decentraland Invite", "DCLI") {}
832 
833   function allow(address target, uint256 amount) public onlyOwner {
834     balance[target] = amount;
835     emit UpdateInvites(target, amount);
836   }
837 
838   function invite(address target, bytes note) public {
839     require(balance[msg.sender] > 0);
840     balance[msg.sender] -= 1;
841     uint256 id = totalSupply();
842     _mint(target, id);
843     metadata[id] = note;
844     emit Invited(msg.sender, target, id, note);
845   }
846 
847   function revoke(address target) onlyOwner public {
848     require(ownedTokensCount[target] > 0);
849 
850     uint256 addressTokensCount = ownedTokensCount[target];
851 
852     // Collect token IDs to burn
853     uint256[] memory burnTokenIds = new uint256[](addressTokensCount);
854     for (uint256 i = 0; i < addressTokensCount; i++) {
855       burnTokenIds[i] = tokenOfOwnerByIndex(target, i);
856     }
857 
858     // Burn all tokens held by the target address
859     for (i = 0; i < addressTokensCount; i++) {
860       _burn(target, burnTokenIds[i]);
861     }
862   }
863 
864   function setTokenURI(uint256 id, string uri) public {
865     require(msg.sender == ownerOf(id));
866     _setTokenURI(id, uri);
867     emit URIUpdated(id, uri);
868   }
869 
870   function transferFrom(address _from, address _to, uint256 _tokenId) whenNotPaused public {
871     super.transferFrom(_from, _to, _tokenId);
872   }
873 
874   function safeTransferFrom(address _from, address _to, uint256 _tokenId) whenNotPaused public {
875     super.safeTransferFrom(_from, _to, _tokenId);
876   }
877 
878   function safeTransferFrom(
879     address _from,
880     address _to,
881     uint256 _tokenId,
882     bytes _data
883   ) whenNotPaused public {
884     super.safeTransferFrom(_from, _to, _tokenId, _data);
885   }
886 }