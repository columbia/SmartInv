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
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title Destructible
117  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
118  */
119 contract Destructible is Ownable {
120 
121   constructor() public payable { }
122 
123   /**
124    * @dev Transfers the current balance to the owner and terminates the contract.
125    */
126   function destroy() onlyOwner public {
127     selfdestruct(owner);
128   }
129 
130   function destroyAndSend(address _recipient) onlyOwner public {
131     selfdestruct(_recipient);
132   }
133 }
134 
135 /**
136  * @title Pausable
137  * @dev Base contract which allows children to implement an emergency stop mechanism.
138  */
139 contract Pausable is Ownable {
140   event Pause();
141   event Unpause();
142 
143   bool public paused = false;
144 
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is not paused.
148    */
149   modifier whenNotPaused() {
150     require(!paused);
151     _;
152   }
153 
154   /**
155    * @dev Modifier to make a function callable only when the contract is paused.
156    */
157   modifier whenPaused() {
158     require(paused);
159     _;
160   }
161 
162   /**
163    * @dev called by the owner to pause, triggers stopped state
164    */
165   function pause() onlyOwner whenNotPaused public {
166     paused = true;
167     emit Pause();
168   }
169 
170   /**
171    * @dev called by the owner to unpause, returns to normal state
172    */
173   function unpause() onlyOwner whenPaused public {
174     paused = false;
175     emit Unpause();
176   }
177 }
178 
179 contract Operatable is Ownable {
180 
181     address public operator;
182 
183     event LogOperatorChanged(address indexed from, address indexed to);
184 
185     modifier isValidOperator(address _operator) {
186         require(_operator != address(0));
187         _;
188     }
189 
190     modifier onlyOperator() {
191         require(msg.sender == operator);
192         _;
193     }
194 
195     constructor(address _owner, address _operator) public isValidOperator(_operator) {
196         require(_owner != address(0));
197         
198         owner = _owner;
199         operator = _operator;
200     }
201 
202     function setOperator(address _operator) public onlyOwner isValidOperator(_operator) {
203         emit LogOperatorChanged(operator, _operator);
204         operator = _operator;
205     }
206 }
207 
208 /**
209  * @title ERC165
210  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
211  */
212 interface ERC165 {
213 
214   /**
215    * @notice Query if a contract implements an interface
216    * @param _interfaceId The interface identifier, as specified in ERC-165
217    * @dev Interface identification is specified in ERC-165. This function
218    * uses less than 30,000 gas.
219    */
220   function supportsInterface(bytes4 _interfaceId)
221     external
222     view
223     returns (bool);
224 }
225 
226 /**
227  * @title ERC721 Non-Fungible Token Standard basic interface
228  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
229  */
230 contract ERC721Basic is ERC165 {
231   event Transfer(
232     address indexed _from,
233     address indexed _to,
234     uint256 indexed _tokenId
235   );
236   event Approval(
237     address indexed _owner,
238     address indexed _approved,
239     uint256 indexed _tokenId
240   );
241   event ApprovalForAll(
242     address indexed _owner,
243     address indexed _operator,
244     bool _approved
245   );
246 
247   function balanceOf(address _owner) public view returns (uint256 _balance);
248   function ownerOf(uint256 _tokenId) public view returns (address _owner);
249   function exists(uint256 _tokenId) public view returns (bool _exists);
250 
251   function approve(address _to, uint256 _tokenId) public;
252   function getApproved(uint256 _tokenId)
253     public view returns (address _operator);
254 
255   function setApprovalForAll(address _operator, bool _approved) public;
256   function isApprovedForAll(address _owner, address _operator)
257     public view returns (bool);
258 
259   function transferFrom(address _from, address _to, uint256 _tokenId) public;
260   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
261     public;
262 
263   function safeTransferFrom(
264     address _from,
265     address _to,
266     uint256 _tokenId,
267     bytes _data
268   )
269     public;
270 }
271 
272 /**
273  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
274  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
275  */
276 contract ERC721Enumerable is ERC721Basic {
277   function totalSupply() public view returns (uint256);
278   function tokenOfOwnerByIndex(
279     address _owner,
280     uint256 _index
281   )
282     public
283     view
284     returns (uint256 _tokenId);
285 
286   function tokenByIndex(uint256 _index) public view returns (uint256);
287 }
288 
289 
290 /**
291  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
292  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
293  */
294 contract ERC721Metadata is ERC721Basic {
295   function name() external view returns (string _name);
296   function symbol() external view returns (string _symbol);
297   function tokenURI(uint256 _tokenId) public view returns (string);
298 }
299 
300 
301 /**
302  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
303  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
304  */
305 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
306 }
307 
308 /**
309  * @title ERC721 token receiver interface
310  * @dev Interface for any contract that wants to support safeTransfers
311  * from ERC721 asset contracts.
312  */
313 contract ERC721Receiver {
314   /**
315    * @dev Magic value to be returned upon successful reception of an NFT
316    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
317    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
318    */
319   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
320 
321   /**
322    * @notice Handle the receipt of an NFT
323    * @dev The ERC721 smart contract calls this function on the recipient
324    * after a `safetransfer`. This function MAY throw to revert and reject the
325    * transfer. Return of other than the magic value MUST result in the 
326    * transaction being reverted.
327    * Note: the contract address is always the message sender.
328    * @param _operator The address which called `safeTransferFrom` function
329    * @param _from The address which previously owned the token
330    * @param _tokenId The NFT identifier which is being transfered
331    * @param _data Additional data with no specified format
332    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
333    */
334   function onERC721Received(
335     address _operator,
336     address _from,
337     uint256 _tokenId,
338     bytes _data
339   )
340     public
341     returns(bytes4);
342 }
343 
344 /**
345  * Utility library of inline functions on addresses
346  */
347 library AddressUtils {
348 
349   /**
350    * Returns whether the target address is a contract
351    * @dev This function will return false if invoked during the constructor of a contract,
352    * as the code is not actually created until after the constructor finishes.
353    * @param addr address to check
354    * @return whether the target address is a contract
355    */
356   function isContract(address addr) internal view returns (bool) {
357     uint256 size;
358     // XXX Currently there is no better way to check if there is a contract in an address
359     // than to check the size of the code at that address.
360     // See https://ethereum.stackexchange.com/a/14016/36603
361     // for more details about how this works.
362     // TODO Check this again before the Serenity release, because all addresses will be
363     // contracts then.
364     // solium-disable-next-line security/no-inline-assembly
365     assembly { size := extcodesize(addr) }
366     return size > 0;
367   }
368 
369 }
370 
371 /**
372  * @title SupportsInterfaceWithLookup
373  * @author Matt Condon (@shrugs)
374  * @dev Implements ERC165 using a lookup table.
375  */
376 contract SupportsInterfaceWithLookup is ERC165 {
377   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
378   /**
379    * 0x01ffc9a7 ===
380    *   bytes4(keccak256('supportsInterface(bytes4)'))
381    */
382 
383   /**
384    * @dev a mapping of interface id to whether or not it's supported
385    */
386   mapping(bytes4 => bool) internal supportedInterfaces;
387 
388   /**
389    * @dev A contract implementing SupportsInterfaceWithLookup
390    * implement ERC165 itself
391    */
392   constructor()
393     public
394   {
395     _registerInterface(InterfaceId_ERC165);
396   }
397 
398   /**
399    * @dev implement supportsInterface(bytes4) using a lookup table
400    */
401   function supportsInterface(bytes4 _interfaceId)
402     external
403     view
404     returns (bool)
405   {
406     return supportedInterfaces[_interfaceId];
407   }
408 
409   /**
410    * @dev private method for registering an interface
411    */
412   function _registerInterface(bytes4 _interfaceId)
413     internal
414   {
415     require(_interfaceId != 0xffffffff);
416     supportedInterfaces[_interfaceId] = true;
417   }
418 }
419 
420 /**
421  * @title ERC721 Non-Fungible Token Standard basic implementation
422  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
423  */
424 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
425 
426   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
427   /*
428    * 0x80ac58cd ===
429    *   bytes4(keccak256('balanceOf(address)')) ^
430    *   bytes4(keccak256('ownerOf(uint256)')) ^
431    *   bytes4(keccak256('approve(address,uint256)')) ^
432    *   bytes4(keccak256('getApproved(uint256)')) ^
433    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
434    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
435    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
436    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
437    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
438    */
439 
440   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
441   /*
442    * 0x4f558e79 ===
443    *   bytes4(keccak256('exists(uint256)'))
444    */
445 
446   using SafeMath for uint256;
447   using AddressUtils for address;
448 
449   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
450   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
451   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
452 
453   // Mapping from token ID to owner
454   mapping (uint256 => address) internal tokenOwner;
455 
456   // Mapping from token ID to approved address
457   mapping (uint256 => address) internal tokenApprovals;
458 
459   // Mapping from owner to number of owned token
460   mapping (address => uint256) internal ownedTokensCount;
461 
462   // Mapping from owner to operator approvals
463   mapping (address => mapping (address => bool)) internal operatorApprovals;
464 
465   /**
466    * @dev Guarantees msg.sender is owner of the given token
467    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
468    */
469   modifier onlyOwnerOf(uint256 _tokenId) {
470     require(ownerOf(_tokenId) == msg.sender);
471     _;
472   }
473 
474   /**
475    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
476    * @param _tokenId uint256 ID of the token to validate
477    */
478   modifier canTransfer(uint256 _tokenId) {
479     require(isApprovedOrOwner(msg.sender, _tokenId));
480     _;
481   }
482 
483   constructor()
484     public
485   {
486     // register the supported interfaces to conform to ERC721 via ERC165
487     _registerInterface(InterfaceId_ERC721);
488     _registerInterface(InterfaceId_ERC721Exists);
489   }
490 
491   /**
492    * @dev Gets the balance of the specified address
493    * @param _owner address to query the balance of
494    * @return uint256 representing the amount owned by the passed address
495    */
496   function balanceOf(address _owner) public view returns (uint256) {
497     require(_owner != address(0));
498     return ownedTokensCount[_owner];
499   }
500 
501   /**
502    * @dev Gets the owner of the specified token ID
503    * @param _tokenId uint256 ID of the token to query the owner of
504    * @return owner address currently marked as the owner of the given token ID
505    */
506   function ownerOf(uint256 _tokenId) public view returns (address) {
507     address owner = tokenOwner[_tokenId];
508     require(owner != address(0));
509     return owner;
510   }
511 
512   /**
513    * @dev Returns whether the specified token exists
514    * @param _tokenId uint256 ID of the token to query the existence of
515    * @return whether the token exists
516    */
517   function exists(uint256 _tokenId) public view returns (bool) {
518     address owner = tokenOwner[_tokenId];
519     return owner != address(0);
520   }
521 
522   /**
523    * @dev Approves another address to transfer the given token ID
524    * The zero address indicates there is no approved address.
525    * There can only be one approved address per token at a given time.
526    * Can only be called by the token owner or an approved operator.
527    * @param _to address to be approved for the given token ID
528    * @param _tokenId uint256 ID of the token to be approved
529    */
530   function approve(address _to, uint256 _tokenId) public {
531     address owner = ownerOf(_tokenId);
532     require(_to != owner);
533     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
534 
535     tokenApprovals[_tokenId] = _to;
536     emit Approval(owner, _to, _tokenId);
537   }
538 
539   /**
540    * @dev Gets the approved address for a token ID, or zero if no address set
541    * @param _tokenId uint256 ID of the token to query the approval of
542    * @return address currently approved for the given token ID
543    */
544   function getApproved(uint256 _tokenId) public view returns (address) {
545     return tokenApprovals[_tokenId];
546   }
547 
548   /**
549    * @dev Sets or unsets the approval of a given operator
550    * An operator is allowed to transfer all tokens of the sender on their behalf
551    * @param _to operator address to set the approval
552    * @param _approved representing the status of the approval to be set
553    */
554   function setApprovalForAll(address _to, bool _approved) public {
555     require(_to != msg.sender);
556     operatorApprovals[msg.sender][_to] = _approved;
557     emit ApprovalForAll(msg.sender, _to, _approved);
558   }
559 
560   /**
561    * @dev Tells whether an operator is approved by a given owner
562    * @param _owner owner address which you want to query the approval of
563    * @param _operator operator address which you want to query the approval of
564    * @return bool whether the given operator is approved by the given owner
565    */
566   function isApprovedForAll(
567     address _owner,
568     address _operator
569   )
570     public
571     view
572     returns (bool)
573   {
574     return operatorApprovals[_owner][_operator];
575   }
576 
577   /**
578    * @dev Transfers the ownership of a given token ID to another address
579    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
580    * Requires the msg sender to be the owner, approved, or operator
581    * @param _from current owner of the token
582    * @param _to address to receive the ownership of the given token ID
583    * @param _tokenId uint256 ID of the token to be transferred
584   */
585   function transferFrom(
586     address _from,
587     address _to,
588     uint256 _tokenId
589   )
590     public
591     canTransfer(_tokenId)
592   {
593     require(_from != address(0));
594     require(_to != address(0));
595 
596     clearApproval(_from, _tokenId);
597     removeTokenFrom(_from, _tokenId);
598     addTokenTo(_to, _tokenId);
599 
600     emit Transfer(_from, _to, _tokenId);
601   }
602 
603   /**
604    * @dev Safely transfers the ownership of a given token ID to another address
605    * If the target address is a contract, it must implement `onERC721Received`,
606    * which is called upon a safe transfer, and return the magic value
607    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
608    * the transfer is reverted.
609    *
610    * Requires the msg sender to be the owner, approved, or operator
611    * @param _from current owner of the token
612    * @param _to address to receive the ownership of the given token ID
613    * @param _tokenId uint256 ID of the token to be transferred
614   */
615   function safeTransferFrom(
616     address _from,
617     address _to,
618     uint256 _tokenId
619   )
620     public
621     canTransfer(_tokenId)
622   {
623     // solium-disable-next-line arg-overflow
624     safeTransferFrom(_from, _to, _tokenId, "");
625   }
626 
627   /**
628    * @dev Safely transfers the ownership of a given token ID to another address
629    * If the target address is a contract, it must implement `onERC721Received`,
630    * which is called upon a safe transfer, and return the magic value
631    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
632    * the transfer is reverted.
633    * Requires the msg sender to be the owner, approved, or operator
634    * @param _from current owner of the token
635    * @param _to address to receive the ownership of the given token ID
636    * @param _tokenId uint256 ID of the token to be transferred
637    * @param _data bytes data to send along with a safe transfer check
638    */
639   function safeTransferFrom(
640     address _from,
641     address _to,
642     uint256 _tokenId,
643     bytes _data
644   )
645     public
646     canTransfer(_tokenId)
647   {
648     transferFrom(_from, _to, _tokenId);
649     // solium-disable-next-line arg-overflow
650     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
651   }
652 
653   /**
654    * @dev Returns whether the given spender can transfer a given token ID
655    * @param _spender address of the spender to query
656    * @param _tokenId uint256 ID of the token to be transferred
657    * @return bool whether the msg.sender is approved for the given token ID,
658    *  is an operator of the owner, or is the owner of the token
659    */
660   function isApprovedOrOwner(
661     address _spender,
662     uint256 _tokenId
663   )
664     internal
665     view
666     returns (bool)
667   {
668     address owner = ownerOf(_tokenId);
669     // Disable solium check because of
670     // https://github.com/duaraghav8/Solium/issues/175
671     // solium-disable-next-line operator-whitespace
672     return (
673       _spender == owner ||
674       getApproved(_tokenId) == _spender ||
675       isApprovedForAll(owner, _spender)
676     );
677   }
678 
679   /**
680    * @dev Internal function to mint a new token
681    * Reverts if the given token ID already exists
682    * @param _to The address that will own the minted token
683    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
684    */
685   function _mint(address _to, uint256 _tokenId) internal {
686     require(_to != address(0));
687     addTokenTo(_to, _tokenId);
688     emit Transfer(address(0), _to, _tokenId);
689   }
690 
691   /**
692    * @dev Internal function to burn a specific token
693    * Reverts if the token does not exist
694    * @param _tokenId uint256 ID of the token being burned by the msg.sender
695    */
696   function _burn(address _owner, uint256 _tokenId) internal {
697     clearApproval(_owner, _tokenId);
698     removeTokenFrom(_owner, _tokenId);
699     emit Transfer(_owner, address(0), _tokenId);
700   }
701 
702   /**
703    * @dev Internal function to clear current approval of a given token ID
704    * Reverts if the given address is not indeed the owner of the token
705    * @param _owner owner of the token
706    * @param _tokenId uint256 ID of the token to be transferred
707    */
708   function clearApproval(address _owner, uint256 _tokenId) internal {
709     require(ownerOf(_tokenId) == _owner);
710     if (tokenApprovals[_tokenId] != address(0)) {
711       tokenApprovals[_tokenId] = address(0);
712     }
713   }
714 
715   /**
716    * @dev Internal function to add a token ID to the list of a given address
717    * @param _to address representing the new owner of the given token ID
718    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
719    */
720   function addTokenTo(address _to, uint256 _tokenId) internal {
721     require(tokenOwner[_tokenId] == address(0));
722     tokenOwner[_tokenId] = _to;
723     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
724   }
725 
726   /**
727    * @dev Internal function to remove a token ID from the list of a given address
728    * @param _from address representing the previous owner of the given token ID
729    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
730    */
731   function removeTokenFrom(address _from, uint256 _tokenId) internal {
732     require(ownerOf(_tokenId) == _from);
733     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
734     tokenOwner[_tokenId] = address(0);
735   }
736 
737   /**
738    * @dev Internal function to invoke `onERC721Received` on a target address
739    * The call is not executed if the target address is not a contract
740    * @param _from address representing the previous owner of the given token ID
741    * @param _to target address that will receive the tokens
742    * @param _tokenId uint256 ID of the token to be transferred
743    * @param _data bytes optional data to send along with the call
744    * @return whether the call correctly returned the expected magic value
745    */
746   function checkAndCallSafeTransfer(
747     address _from,
748     address _to,
749     uint256 _tokenId,
750     bytes _data
751   )
752     internal
753     returns (bool)
754   {
755     if (!_to.isContract()) {
756       return true;
757     }
758     bytes4 retval = ERC721Receiver(_to).onERC721Received(
759       msg.sender, _from, _tokenId, _data);
760     return (retval == ERC721_RECEIVED);
761   }
762 }
763 
764 /**
765  * @title Full ERC721 Token
766  * This implementation includes all the required and some optional functionality of the ERC721 standard
767  * Moreover, it includes approve all functionality using operator terminology
768  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
769  */
770 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
771 
772   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
773   /**
774    * 0x780e9d63 ===
775    *   bytes4(keccak256('totalSupply()')) ^
776    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
777    *   bytes4(keccak256('tokenByIndex(uint256)'))
778    */
779 
780   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
781   /**
782    * 0x5b5e139f ===
783    *   bytes4(keccak256('name()')) ^
784    *   bytes4(keccak256('symbol()')) ^
785    *   bytes4(keccak256('tokenURI(uint256)'))
786    */
787 
788   // Token name
789   string internal name_;
790 
791   // Token symbol
792   string internal symbol_;
793 
794   // Mapping from owner to list of owned token IDs
795   mapping(address => uint256[]) internal ownedTokens;
796 
797   // Mapping from token ID to index of the owner tokens list
798   mapping(uint256 => uint256) internal ownedTokensIndex;
799 
800   // Array with all token ids, used for enumeration
801   uint256[] internal allTokens;
802 
803   // Mapping from token id to position in the allTokens array
804   mapping(uint256 => uint256) internal allTokensIndex;
805 
806   // Optional mapping for token URIs
807   mapping(uint256 => string) internal tokenURIs;
808 
809   /**
810    * @dev Constructor function
811    */
812   constructor(string _name, string _symbol) public {
813     name_ = _name;
814     symbol_ = _symbol;
815 
816     // register the supported interfaces to conform to ERC721 via ERC165
817     _registerInterface(InterfaceId_ERC721Enumerable);
818     _registerInterface(InterfaceId_ERC721Metadata);
819   }
820 
821   /**
822    * @dev Gets the token name
823    * @return string representing the token name
824    */
825   function name() external view returns (string) {
826     return name_;
827   }
828 
829   /**
830    * @dev Gets the token symbol
831    * @return string representing the token symbol
832    */
833   function symbol() external view returns (string) {
834     return symbol_;
835   }
836 
837   /**
838    * @dev Returns an URI for a given token ID
839    * Throws if the token ID does not exist. May return an empty string.
840    * @param _tokenId uint256 ID of the token to query
841    */
842   function tokenURI(uint256 _tokenId) public view returns (string) {
843     require(exists(_tokenId));
844     return tokenURIs[_tokenId];
845   }
846 
847   /**
848    * @dev Gets the token ID at a given index of the tokens list of the requested owner
849    * @param _owner address owning the tokens list to be accessed
850    * @param _index uint256 representing the index to be accessed of the requested tokens list
851    * @return uint256 token ID at the given index of the tokens list owned by the requested address
852    */
853   function tokenOfOwnerByIndex(
854     address _owner,
855     uint256 _index
856   )
857     public
858     view
859     returns (uint256)
860   {
861     require(_index < balanceOf(_owner));
862     return ownedTokens[_owner][_index];
863   }
864 
865   /**
866    * @dev Gets the total amount of tokens stored by the contract
867    * @return uint256 representing the total amount of tokens
868    */
869   function totalSupply() public view returns (uint256) {
870     return allTokens.length;
871   }
872 
873   /**
874    * @dev Gets the token ID at a given index of all the tokens in this contract
875    * Reverts if the index is greater or equal to the total number of tokens
876    * @param _index uint256 representing the index to be accessed of the tokens list
877    * @return uint256 token ID at the given index of the tokens list
878    */
879   function tokenByIndex(uint256 _index) public view returns (uint256) {
880     require(_index < totalSupply());
881     return allTokens[_index];
882   }
883 
884   /**
885    * @dev Internal function to set the token URI for a given token
886    * Reverts if the token ID does not exist
887    * @param _tokenId uint256 ID of the token to set its URI
888    * @param _uri string URI to assign
889    */
890   function _setTokenURI(uint256 _tokenId, string _uri) internal {
891     require(exists(_tokenId));
892     tokenURIs[_tokenId] = _uri;
893   }
894 
895   /**
896    * @dev Internal function to add a token ID to the list of a given address
897    * @param _to address representing the new owner of the given token ID
898    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
899    */
900   function addTokenTo(address _to, uint256 _tokenId) internal {
901     super.addTokenTo(_to, _tokenId);
902     uint256 length = ownedTokens[_to].length;
903     ownedTokens[_to].push(_tokenId);
904     ownedTokensIndex[_tokenId] = length;
905   }
906 
907   /**
908    * @dev Internal function to remove a token ID from the list of a given address
909    * @param _from address representing the previous owner of the given token ID
910    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
911    */
912   function removeTokenFrom(address _from, uint256 _tokenId) internal {
913     super.removeTokenFrom(_from, _tokenId);
914 
915     uint256 tokenIndex = ownedTokensIndex[_tokenId];
916     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
917     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
918 
919     ownedTokens[_from][tokenIndex] = lastToken;
920     ownedTokens[_from][lastTokenIndex] = 0;
921     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
922     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
923     // the lastToken to the first position, and then dropping the element placed in the last position of the list
924 
925     ownedTokens[_from].length--;
926     ownedTokensIndex[_tokenId] = 0;
927     ownedTokensIndex[lastToken] = tokenIndex;
928   }
929 
930   /**
931    * @dev Internal function to mint a new token
932    * Reverts if the given token ID already exists
933    * @param _to address the beneficiary that will own the minted token
934    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
935    */
936   function _mint(address _to, uint256 _tokenId) internal {
937     super._mint(_to, _tokenId);
938 
939     allTokensIndex[_tokenId] = allTokens.length;
940     allTokens.push(_tokenId);
941   }
942 
943   /**
944    * @dev Internal function to burn a specific token
945    * Reverts if the token does not exist
946    * @param _owner owner of the token to burn
947    * @param _tokenId uint256 ID of the token being burned by the msg.sender
948    */
949   function _burn(address _owner, uint256 _tokenId) internal {
950     super._burn(_owner, _tokenId);
951 
952     // Clear metadata (if any)
953     if (bytes(tokenURIs[_tokenId]).length != 0) {
954       delete tokenURIs[_tokenId];
955     }
956 
957     // Reorg all tokens array
958     uint256 tokenIndex = allTokensIndex[_tokenId];
959     uint256 lastTokenIndex = allTokens.length.sub(1);
960     uint256 lastToken = allTokens[lastTokenIndex];
961 
962     allTokens[tokenIndex] = lastToken;
963     allTokens[lastTokenIndex] = 0;
964 
965     allTokens.length--;
966     allTokensIndex[_tokenId] = 0;
967     allTokensIndex[lastToken] = tokenIndex;
968   }
969 
970 }
971 
972 contract CryptoTakeoversNFT is ERC721Token("CryptoTakeoversNFT",""), Operatable {
973     
974     event LogGameOperatorChanged(address indexed from, address indexed to);
975 
976     address public gameOperator;
977 
978     modifier onlyGameOperator() {
979         assert(gameOperator != address(0));
980         require(msg.sender == gameOperator);
981         _;
982     }
983 
984     constructor (address _owner, address _operator) Operatable(_owner, _operator) public {
985     }
986 
987     function mint(uint256 _tokenId, string _tokenURI) public onlyGameOperator {
988         super._mint(operator, _tokenId);
989         super._setTokenURI(_tokenId, _tokenURI);
990     }
991 
992     function hostileTakeover(address _to, uint256 _tokenId) public onlyGameOperator {
993         address tokenOwner = super.ownerOf(_tokenId);
994         operatorApprovals[tokenOwner][gameOperator] = true;
995         super.safeTransferFrom(tokenOwner, _to, _tokenId);
996     }
997 
998     function setGameOperator(address _gameOperator) public onlyOperator {
999         emit LogGameOperatorChanged(gameOperator, _gameOperator);
1000         gameOperator = _gameOperator;
1001     }
1002 
1003     function burn(uint256 _tokenId) public onlyGameOperator {
1004         super._burn(operator, _tokenId);
1005     }
1006 }
1007 
1008 /**
1009  * @title ERC20Basic
1010  * @dev Simpler version of ERC20 interface
1011  * See https://github.com/ethereum/EIPs/issues/179
1012  */
1013 contract ERC20Basic {
1014   function totalSupply() public view returns (uint256);
1015   function balanceOf(address who) public view returns (uint256);
1016   function transfer(address to, uint256 value) public returns (bool);
1017   event Transfer(address indexed from, address indexed to, uint256 value);
1018 }
1019 
1020 /**
1021  * @title Basic token
1022  * @dev Basic version of StandardToken, with no allowances.
1023  */
1024 contract BasicToken is ERC20Basic {
1025   using SafeMath for uint256;
1026 
1027   mapping(address => uint256) balances;
1028 
1029   uint256 totalSupply_;
1030 
1031   /**
1032   * @dev Total number of tokens in existence
1033   */
1034   function totalSupply() public view returns (uint256) {
1035     return totalSupply_;
1036   }
1037 
1038   /**
1039   * @dev Transfer token for a specified address
1040   * @param _to The address to transfer to.
1041   * @param _value The amount to be transferred.
1042   */
1043   function transfer(address _to, uint256 _value) public returns (bool) {
1044     require(_to != address(0));
1045     require(_value <= balances[msg.sender]);
1046 
1047     balances[msg.sender] = balances[msg.sender].sub(_value);
1048     balances[_to] = balances[_to].add(_value);
1049     emit Transfer(msg.sender, _to, _value);
1050     return true;
1051   }
1052 
1053   /**
1054   * @dev Gets the balance of the specified address.
1055   * @param _owner The address to query the the balance of.
1056   * @return An uint256 representing the amount owned by the passed address.
1057   */
1058   function balanceOf(address _owner) public view returns (uint256) {
1059     return balances[_owner];
1060   }
1061 
1062 }
1063 
1064 /**
1065  * @title ERC20 interface
1066  * @dev see https://github.com/ethereum/EIPs/issues/20
1067  */
1068 contract ERC20 is ERC20Basic {
1069   function allowance(address owner, address spender)
1070     public view returns (uint256);
1071 
1072   function transferFrom(address from, address to, uint256 value)
1073     public returns (bool);
1074 
1075   function approve(address spender, uint256 value) public returns (bool);
1076   event Approval(
1077     address indexed owner,
1078     address indexed spender,
1079     uint256 value
1080   );
1081 }
1082 
1083 /**
1084  * @title Standard ERC20 token
1085  *
1086  * @dev Implementation of the basic standard token.
1087  * https://github.com/ethereum/EIPs/issues/20
1088  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1089  */
1090 contract StandardToken is ERC20, BasicToken {
1091 
1092   mapping (address => mapping (address => uint256)) internal allowed;
1093 
1094 
1095   /**
1096    * @dev Transfer tokens from one address to another
1097    * @param _from address The address which you want to send tokens from
1098    * @param _to address The address which you want to transfer to
1099    * @param _value uint256 the amount of tokens to be transferred
1100    */
1101   function transferFrom(
1102     address _from,
1103     address _to,
1104     uint256 _value
1105   )
1106     public
1107     returns (bool)
1108   {
1109     require(_to != address(0));
1110     require(_value <= balances[_from]);
1111     require(_value <= allowed[_from][msg.sender]);
1112 
1113     balances[_from] = balances[_from].sub(_value);
1114     balances[_to] = balances[_to].add(_value);
1115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1116     emit Transfer(_from, _to, _value);
1117     return true;
1118   }
1119 
1120   /**
1121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1122    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1123    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1124    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1125    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1126    * @param _spender The address which will spend the funds.
1127    * @param _value The amount of tokens to be spent.
1128    */
1129   function approve(address _spender, uint256 _value) public returns (bool) {
1130     allowed[msg.sender][_spender] = _value;
1131     emit Approval(msg.sender, _spender, _value);
1132     return true;
1133   }
1134 
1135   /**
1136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1137    * @param _owner address The address which owns the funds.
1138    * @param _spender address The address which will spend the funds.
1139    * @return A uint256 specifying the amount of tokens still available for the spender.
1140    */
1141   function allowance(
1142     address _owner,
1143     address _spender
1144    )
1145     public
1146     view
1147     returns (uint256)
1148   {
1149     return allowed[_owner][_spender];
1150   }
1151 
1152   /**
1153    * @dev Increase the amount of tokens that an owner allowed to a spender.
1154    * approve should be called when allowed[_spender] == 0. To increment
1155    * allowed value is better to use this function to avoid 2 calls (and wait until
1156    * the first transaction is mined)
1157    * From MonolithDAO Token.sol
1158    * @param _spender The address which will spend the funds.
1159    * @param _addedValue The amount of tokens to increase the allowance by.
1160    */
1161   function increaseApproval(
1162     address _spender,
1163     uint256 _addedValue
1164   )
1165     public
1166     returns (bool)
1167   {
1168     allowed[msg.sender][_spender] = (
1169       allowed[msg.sender][_spender].add(_addedValue));
1170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1171     return true;
1172   }
1173 
1174   /**
1175    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1176    * approve should be called when allowed[_spender] == 0. To decrement
1177    * allowed value is better to use this function to avoid 2 calls (and wait until
1178    * the first transaction is mined)
1179    * From MonolithDAO Token.sol
1180    * @param _spender The address which will spend the funds.
1181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1182    */
1183   function decreaseApproval(
1184     address _spender,
1185     uint256 _subtractedValue
1186   )
1187     public
1188     returns (bool)
1189   {
1190     uint256 oldValue = allowed[msg.sender][_spender];
1191     if (_subtractedValue > oldValue) {
1192       allowed[msg.sender][_spender] = 0;
1193     } else {
1194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1195     }
1196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1197     return true;
1198   }
1199 
1200 }
1201 
1202 /**
1203  * @title Mintable token
1204  * @dev Simple ERC20 Token example, with mintable token creation
1205  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1206  */
1207 contract MintableToken is StandardToken, Ownable {
1208   event Mint(address indexed to, uint256 amount);
1209   event MintFinished();
1210 
1211   bool public mintingFinished = false;
1212 
1213 
1214   modifier canMint() {
1215     require(!mintingFinished);
1216     _;
1217   }
1218 
1219   modifier hasMintPermission() {
1220     require(msg.sender == owner);
1221     _;
1222   }
1223 
1224   /**
1225    * @dev Function to mint tokens
1226    * @param _to The address that will receive the minted tokens.
1227    * @param _amount The amount of tokens to mint.
1228    * @return A boolean that indicates if the operation was successful.
1229    */
1230   function mint(
1231     address _to,
1232     uint256 _amount
1233   )
1234     hasMintPermission
1235     canMint
1236     public
1237     returns (bool)
1238   {
1239     totalSupply_ = totalSupply_.add(_amount);
1240     balances[_to] = balances[_to].add(_amount);
1241     emit Mint(_to, _amount);
1242     emit Transfer(address(0), _to, _amount);
1243     return true;
1244   }
1245 
1246   /**
1247    * @dev Function to stop minting new tokens.
1248    * @return True if the operation was successful.
1249    */
1250   function finishMinting() onlyOwner canMint public returns (bool) {
1251     mintingFinished = true;
1252     emit MintFinished();
1253     return true;
1254   }
1255 }
1256 
1257 /// @title CryptoTakeovers In-Game Token.
1258 /// @dev The token used in the game to participate in NFT airdrop raffles.
1259 /// @author Ido Amram <ido@cryptotakeovers.com>, Elad Mallel <elad@cryptotakeovers.com>
1260 contract CryptoTakeoversToken is MintableToken, Operatable {
1261 
1262     /*
1263      * Events
1264      */
1265 
1266     event LogGameOperatorChanged(address indexed from, address indexed to);
1267     event LogShouldBlockPublicTradeSet(bool value, address indexed owner);
1268 
1269     /*
1270      * Storage
1271      */
1272 
1273     bool public shouldBlockPublicTrade;
1274     address public gameOperator;
1275 
1276     /*
1277      * Modifiers
1278      */
1279 
1280     modifier hasMintPermission() {
1281         require(msg.sender == operator || (gameOperator != address(0) && msg.sender == gameOperator));
1282         _;
1283     }
1284 
1285     modifier hasTradePermission(address _from) {
1286         require(_from == operator || !shouldBlockPublicTrade);
1287         _;
1288     }
1289 
1290     /*
1291      * Public (unauthorized) functions
1292      */
1293 
1294     /// @dev CryptoTakeoversToken constructor.
1295     /// @param _owner the address of the owner to set for this contract
1296     /// @param _operator the address ofh the operator to set for this contract
1297     constructor (address _owner, address _operator) Operatable(_owner, _operator) public {
1298         shouldBlockPublicTrade = true;
1299     }
1300 
1301     /*
1302      * Operator (authorized) functions
1303      */
1304 
1305     /// @dev Allows an authorized set of accounts to transfer tokens.
1306     /// @param _to the account to transfer tokens to
1307     /// @param _value the amount of tokens to transfer
1308     /// @return true if the transfer succeeded, and false otherwise
1309     function transfer(address _to, uint256 _value) public hasTradePermission(msg.sender) returns (bool) {
1310         return super.transfer(_to, _value);
1311     }
1312 
1313     /// @dev Allows an authorized set of accounts to transfer tokens.
1314     /// @param _from the account from which to transfer tokens
1315     /// @param _to the account to transfer tokens to
1316     /// @param _value the amount of tokens to transfer
1317     /// @return true if the transfer succeeded, and false otherwise
1318     function transferFrom(address _from, address _to, uint256 _value) public hasTradePermission(_from) returns (bool) {
1319         return super.transferFrom(_from, _to, _value);
1320     }
1321 
1322     /// @dev Allows the operator to set the address of the game operator, which should be the pre-sale contract or the game contract.
1323     /// @param _gameOperator the address of the game operator
1324     function setGameOperator(address _gameOperator) public onlyOperator {
1325         require(_gameOperator != address(0));
1326 
1327         emit LogGameOperatorChanged(gameOperator, _gameOperator);
1328 
1329         gameOperator = _gameOperator;
1330     }
1331 
1332     /*
1333      * Owner (authorized) functions
1334      */
1335 
1336     /// @dev Allows the owner to enable or restrict open trade of tokens.
1337     /// @param _shouldBlockPublicTrade true if trade should be restricted, and false to open trade
1338     function setShouldBlockPublicTrade(bool _shouldBlockPublicTrade) public onlyOwner {
1339         shouldBlockPublicTrade = _shouldBlockPublicTrade;
1340 
1341         emit LogShouldBlockPublicTradeSet(_shouldBlockPublicTrade, owner);
1342     }
1343 }
1344 
1345 /// @title CryptoTakeovers PreSale.
1346 /// @dev Manages the sale of in-game assets (cities and countries) and tokens.
1347 /// @author Ido Amram <ido@cryptotakeovers.com>, Elad Mallel <elad@cryptotakeovers.com>
1348 contract CryptoTakeoversPresale is Destructible, Pausable, Operatable {
1349 
1350     /*
1351      * Events
1352      */
1353 
1354     event LogNFTBought(uint256 indexed tokenId, address indexed buyer, uint256 value);
1355     event LogTokensBought(address indexed buyer, uint256 amount, uint256 value);
1356     event LogNFTGifted(address indexed to, uint256 indexed tokenId, uint256 price, address indexed operator);
1357     event LogTokensGifted(address indexed to, uint256 amount, address indexed operator);
1358     event LogNFTBurned(uint256 indexed tokenId, address indexed operator);
1359     event LogTokenPricesSet(
1360         uint256[] previousThresholds, 
1361         uint256[] previousPrices, 
1362         uint256[] newThresholds, 
1363         uint256[] newPrices, 
1364         address indexed operator);
1365     event LogNFTMintedNotForSale(uint256 indexed tokenId, address indexed operator);
1366     event LogNFTMintedForSale(uint256 indexed tokenId, uint256 tokenPrice, address indexed operator);
1367     event LogNFTSetNotForSale(uint256 indexed tokenId, address indexed operator);
1368     event LogNFTSetForSale(uint256 indexed tokenId, uint256 tokenPrice, address indexed operator);
1369     event LogDiscountSet(uint256 indexed tokenId, uint256 discountPrice, address indexed operator);
1370     event LogDiscountUpdated(uint256 indexed tokenId, uint256 discountPrice, address indexed operator);
1371     event LogDiscountRemoved(uint256 indexed tokenId, address indexed operator);
1372     event LogDiscountsReset(uint256 count, address indexed operator);
1373     event LogStartAndEndTimeSet(uint256 startTime, uint256 endTime, address indexed operator);
1374     event LogStartTimeSet(uint256 startTime, address indexed operator);
1375     event LogEndTimeSet(uint256 endTime, address indexed operator);
1376     event LogTokensContractSet(address indexed previousAddress, address indexed newAddress, address indexed owner);
1377     event LogItemsContractSet(address indexed previousAddress, address indexed newAddress, address indexed owner);
1378     event LogWithdrawToChanged(address indexed previousAddress, address indexed newAddress, address indexed owner);
1379     event LogWithdraw(address indexed withdrawTo, uint256 value, address indexed owner);
1380 
1381     /*
1382      * Storage
1383      */
1384 
1385     using SafeMath for uint256;
1386 
1387     CryptoTakeoversNFT public items;
1388     CryptoTakeoversToken public tokens;
1389 
1390     uint256 public startTime;
1391     uint256 public endTime;
1392     address public withdrawTo;
1393     
1394     mapping (uint256 => uint256) tokenPrices;
1395     uint256[] public itemsForSale;
1396     mapping (uint256 => uint256) itemsForSaleIndex;
1397     mapping (uint256 => uint256) discountedItemPrices;
1398     uint256[] public discountedItems;
1399     mapping (uint256 => uint256) discountedItemsIndex;
1400 
1401     uint256[] public tokenDiscountThresholds;
1402     uint256[] public tokenDiscountedPrices;
1403 
1404     /*
1405      * Modifiers
1406      */
1407 
1408     modifier onlyDuringPresale() {
1409         require(startTime != 0 && endTime != 0);
1410         require(now >= startTime);
1411         require(now <= endTime);
1412         _;
1413     }
1414 
1415     /*
1416      * Public (unauthorized) functions
1417      */
1418 
1419     /// @dev CryptoTakeoversPresale constructor.
1420     /// @param _owner the account with owner permissions
1421     /// @param _operator the admin of the pre-sale, who can start and stop the sale, and mint items for sale
1422     /// @param _cryptoTakeoversNFTAddress the address of the ERC721 game tokens, representing cities and countries
1423     /// @param _cryptoTakeoversTokenAddress the address of the in-game fungible tokens, which grant their owners
1424     /// the chance to win NFT assets in airdrops the team will perform periodically
1425     constructor (
1426         address _owner,
1427         address _operator, 
1428         address _cryptoTakeoversNFTAddress, 
1429         address _cryptoTakeoversTokenAddress
1430     ) 
1431         Operatable(_owner, _operator) 
1432         public 
1433     {
1434         items = CryptoTakeoversNFT(_cryptoTakeoversNFTAddress);
1435         tokens = CryptoTakeoversToken(_cryptoTakeoversTokenAddress);
1436         withdrawTo = owner;
1437     }
1438 
1439     /// @dev Allows anyone to buy an asset during the pre-sale.
1440     /// @param _tokenId the ID of the asset to buy
1441     function buyNFT(uint256 _tokenId) public payable onlyDuringPresale whenNotPaused {
1442         require(msg.value == _getItemPrice(_tokenId), "value sent must equal the price");
1443     
1444         _setItemNotForSale(_tokenId);
1445 
1446         items.hostileTakeover(msg.sender, _tokenId);
1447 
1448         emit LogNFTBought(_tokenId, msg.sender, msg.value);
1449     }
1450 
1451     /// @dev Allows anyone to buy tokens during the pre-sale.
1452     /// @param _amount the amount of tokens to buy
1453     function buyTokens(uint256 _amount) public payable onlyDuringPresale whenNotPaused {
1454         require(tokenDiscountedPrices.length > 0, "prices should be set before selling tokens");
1455         uint256 priceToUse = tokenDiscountedPrices[0];
1456         for (uint256 index = 1; index < tokenDiscountedPrices.length; index++) {
1457             if (_amount >= tokenDiscountThresholds[index]) {
1458                 priceToUse = tokenDiscountedPrices[index];
1459             }
1460         }
1461         require(msg.value == _amount.mul(priceToUse), "we only accept exact payment");
1462 
1463         tokens.mint(msg.sender, _amount);
1464 
1465         emit LogTokensBought(msg.sender, _amount, msg.value);
1466     }
1467 
1468     /// @dev Returns the details of a CryptoTakeovers asset.
1469     /// @param _tokenId the ID of the asset
1470     /// @return tokenId the ID of the asset
1471     /// @return owner the address of the asset's owner
1472     /// @return tokenURI the URI of the asset's metadata
1473     /// @return price the asset
1474     /// @return forSale a bool indicating if the asset is up for sale or not
1475     function getItem(uint256 _tokenId) external view 
1476         returns(uint256 tokenId, address owner, string tokenURI, uint256 price, uint256 discountedPrice, bool forSale, bool discounted) {
1477         tokenId = _tokenId;
1478         owner = items.ownerOf(_tokenId);
1479         tokenURI = items.tokenURI(_tokenId);
1480         price = tokenPrices[_tokenId];
1481         discountedPrice = discountedItemPrices[_tokenId];
1482         forSale = isTokenForSale(_tokenId);
1483         discounted = _isTokenDiscounted(_tokenId);
1484     }
1485 
1486     /// @dev Returns the details of up to 20 assets in one call. Acts as a performance optimization for getItem.
1487     /// @param _fromIndex the index of the first asset to return (inclusive)
1488     /// @param _toIndex the index of the last asset to return (exclusive. use the array's length value to get the last asset)
1489     /// @return ids the IDs of  the requested assets
1490     /// @return owners the addresses of the owners of the requested assets
1491     /// @return prices the prices of the requested assets
1492     function getItemsForSale(uint256 _fromIndex, uint256 _toIndex) public view 
1493         returns(uint256[20] ids, address[20] owners, uint256[20] prices, uint256[20] discountedPrices) {
1494         require(_toIndex <= itemsForSale.length);
1495         require(_fromIndex < _toIndex);
1496         require(_toIndex.sub(_fromIndex) <= ids.length);
1497 
1498         uint256 resultIndex = 0;
1499         for (uint256 index = _fromIndex; index < _toIndex; index++) {
1500             uint256 tokenId = itemsForSale[index];
1501             ids[resultIndex] = tokenId;
1502             owners[resultIndex] = items.ownerOf(tokenId);
1503             prices[resultIndex] = tokenPrices[tokenId];
1504             discountedPrices[resultIndex] = discountedItemPrices[tokenId];
1505             resultIndex = resultIndex.add(1);
1506         }
1507     }
1508 
1509     /// @dev Returns the details of up to 20 items that have been set with a discounted price.
1510     /// @param _fromIndex the index of the first item to get (inclusive)
1511     /// @param _toIndex the index of the last item to get (exclusive)
1512     /// @return ids the IDs of the requested items
1513     /// @return owners the owners of the requested items
1514     /// @return prices the prices of the requested items
1515     /// @return discountedPrices the discounted prices of the requested items
1516     function getDiscountedItemsForSale(uint256 _fromIndex, uint256 _toIndex) public view 
1517         returns(uint256[20] ids, address[20] owners, uint256[20] prices, uint256[20] discountedPrices) {
1518         require(_toIndex <= discountedItems.length, "toIndex out of bounds");
1519         require(_fromIndex < _toIndex, "fromIndex must be less than toIndex");
1520         require(_toIndex.sub(_fromIndex) <= ids.length, "requested range cannot exceed 20 items");
1521         
1522         uint256 resultIndex = 0;
1523         for (uint256 index = _fromIndex; index < _toIndex; index++) {
1524             uint256 tokenId = discountedItems[index];
1525             ids[resultIndex] = tokenId;
1526             owners[resultIndex] = items.ownerOf(tokenId);
1527             prices[resultIndex] = tokenPrices[tokenId];
1528             discountedPrices[resultIndex] = discountedItemPrices[tokenId];
1529             resultIndex = resultIndex.add(1);
1530         }
1531     }
1532 
1533     /// @dev Returns whether a specific asset is for sale.
1534     /// @param _tokenId the ID of the asset
1535     /// @return true if the asset is for sale, and false otherwise
1536     function isTokenForSale(uint256 _tokenId) internal view returns(bool) {
1537         return tokenPrices[_tokenId] != 0;
1538     }
1539 
1540     /// @dev Returns the total number of assets for sale.
1541     /// @return the total number of assets for sale
1542     function totalItemsForSale() public view returns(uint256) {
1543         return itemsForSale.length;
1544     }
1545 
1546     /// @dev Returns the number of assets for the provided account.
1547     /// @return the number of assets owner owns
1548     function NFTBalanceOf(address _owner) public view returns (uint256) {
1549         return items.balanceOf(_owner);
1550     }
1551 
1552     /// @dev Returns up to 20 IDs of assets for the provided account.
1553     /// @return an array of tokenIDs
1554     function tokenOfOwnerByRange(address _owner, uint256 _fromIndex, uint256 _toIndex) public view returns(uint256[20] ids) {
1555         require(_toIndex <= items.balanceOf(_owner));
1556         require(_fromIndex < _toIndex);
1557         require(_toIndex.sub(_fromIndex) <= ids.length);
1558 
1559         uint256 resultIndex = 0;
1560         for (uint256 index = _fromIndex; index < _toIndex; index++) {
1561             ids[resultIndex] = items.tokenOfOwnerByIndex(_owner, index);
1562             resultIndex = resultIndex.add(1);
1563         }
1564     }
1565 
1566     /// @dev Returns the token balance of the provided account.
1567     /// @return the number of tokens owner owns
1568     function tokenBalanceOf(address _owner) public view returns (uint256) {
1569         return tokens.balanceOf(_owner);
1570     }
1571 
1572     /// @dev Returns the total number of assets with a discounted price.
1573     /// @return the number of items set with a discounted price
1574     function totalDiscountedItemsForSale() public view returns (uint256) {
1575         return discountedItems.length;
1576     }
1577 
1578     /*
1579      * Operator (authorized) functions
1580      */
1581 
1582     /// @dev Allows the operator to give assets without payment. Will be used to perform asset airdrops.
1583     /// Only works on items that have not been sold yet.
1584     /// @param _to the address to give the asset to
1585     /// @param _tokenId the ID of the asset to give
1586     /// @param _tokenPrice the price of the gifted token
1587     function giftNFT(address _to, uint256 _tokenId, uint256 _tokenPrice) public onlyOperator {
1588         require(_to != address(0));
1589         require(items.ownerOf(_tokenId) == operator);
1590         require(_tokenPrice > 0, "must provide the token price to log");
1591 
1592         if (isTokenForSale(_tokenId)) {
1593             _setItemNotForSale(_tokenId);
1594         }
1595 
1596         items.hostileTakeover(_to, _tokenId);
1597 
1598         emit LogNFTGifted(_to, _tokenId, _tokenPrice, operator);
1599     }
1600 
1601     /// @dev Allows the operator to give tokens without payment. Will be used to perform token airdrops.
1602     /// @param _to the address to give tokens to (cannot be 0x0)
1603     /// @param _amount the amount of tokens to mint and give
1604     function giftTokens(address _to, uint256 _amount) public onlyOperator {
1605         require(_to != address(0));
1606         require(_amount > 0);
1607         
1608         tokens.mint(_to, _amount);
1609 
1610         emit LogTokensGifted(_to, _amount, operator);
1611     }
1612 
1613     /// @dev Allows the operator to burn an item in case of any errors in setting up the items for sale.
1614     /// It uses items.burn which makes sure it only works for items we haven't sold yet (i.e. only works
1615     /// for items owned by the operator).
1616     /// @param _tokenId the ID of the asset to burn
1617     function burnNFT(uint256 _tokenId) public onlyOperator {
1618         if (isTokenForSale(_tokenId)) {
1619             _setItemNotForSale(_tokenId);
1620         }
1621         
1622         items.burn(_tokenId);
1623 
1624         emit LogNFTBurned(_tokenId, operator);
1625     }
1626 
1627     /// @dev Allows the operator to set the discounted prices of tokens per threshold of purchased amount.
1628     /// @param _tokenDiscountThresholds an array of token quantity thresholds. Cannot contain more than 10 items
1629     /// @param _tokenDiscountedPrices an array of token prices to match each quantity threshold. Cannot contain more than 10 items
1630     function setTokenPrices(uint256[] _tokenDiscountThresholds, uint256[] _tokenDiscountedPrices) public onlyOperator {
1631         require(_tokenDiscountThresholds.length <= 10, "inputs length must be under 10 options");
1632         require(_tokenDiscountThresholds.length == _tokenDiscountedPrices.length, "input arrays must have the same length");
1633 
1634         emit LogTokenPricesSet(tokenDiscountThresholds, tokenDiscountedPrices, _tokenDiscountThresholds, _tokenDiscountedPrices, operator);
1635 
1636         tokenDiscountThresholds = _tokenDiscountThresholds;
1637         tokenDiscountedPrices = _tokenDiscountedPrices;
1638     }
1639 
1640     /// @dev Returns the discount thresholds and prices that match those thresholds in two arrays.
1641     /// @return discountThresholds an array of discount thresholds
1642     /// @return discountedPrices an array of token prices per threshold
1643     function getTokenPrices() public view returns(uint256[10] discountThresholds, uint256[10] discountedPrices) {
1644         for (uint256 index = 0; index < tokenDiscountThresholds.length; index++) {
1645             discountThresholds[index] = tokenDiscountThresholds[index];
1646             discountedPrices[index] = tokenDiscountedPrices[index];
1647         }
1648     }
1649 
1650     /// @dev Allows the operator to create an asset but not put it up for sale yet.
1651     /// @param _tokenId the ID of the asset to mint
1652     /// @param _tokenURI the URI of the asset's metadata
1653     function mintNFTNotForSale(uint256 _tokenId, string _tokenURI) public onlyOperator {
1654         items.mint(_tokenId, _tokenURI);
1655 
1656         emit LogNFTMintedNotForSale(_tokenId, operator);
1657     }
1658 
1659     /// @dev A bulk optimization for mintNFTNotForSale
1660     /// @param _tokenIds the IDs of the tokens to mint
1661     /// @param _tokenURIParts parts of the base URI, e.g. ["https://", "host.com", "/path"]
1662     function mintNFTsNotForSale(uint256[] _tokenIds, bytes32[] _tokenURIParts) public onlyOperator {
1663         require(_tokenURIParts.length > 0, "need at least one string to build URIs");
1664 
1665         for (uint256 index = 0; index < _tokenIds.length; index++) {
1666             uint256 tokenId = _tokenIds[index];
1667             string memory tokenURI = _generateTokenURI(_tokenURIParts, tokenId);
1668 
1669             mintNFTNotForSale(tokenId, tokenURI);
1670         }
1671     }
1672 
1673     /// @dev Allows the operator to create an asset and immediately put it up for sale.
1674     /// @param _tokenId the ID of the asset to mint
1675     /// @param _tokenURI the URI of the asset's metadata
1676     /// @param _tokenPrice the price of the asset
1677     function mintNFTForSale(uint256 _tokenId, string _tokenURI, uint256 _tokenPrice) public onlyOperator {
1678         tokenPrices[_tokenId] = _tokenPrice;
1679         itemsForSaleIndex[_tokenId] = itemsForSale.push(_tokenId).sub(1);
1680         items.mint(_tokenId, _tokenURI);
1681 
1682         emit LogNFTMintedForSale(_tokenId, _tokenPrice, operator);
1683     }
1684 
1685     /// @dev A bulk optimization for mintNFTForSale
1686     /// @param _tokenIds the IDs for the tokens to mint
1687     /// @param _tokenURIParts parts of the base URI, e.g. ["https://", "host.com", "/path"]
1688     /// @param _tokenPrices the prices of the tokens to mint
1689     function mintNFTsForSale(uint256[] _tokenIds, bytes32[] _tokenURIParts, uint256[] _tokenPrices) public onlyOperator {
1690         require(_tokenIds.length == _tokenPrices.length, "ids and prices must have the same length");
1691         require(_tokenURIParts.length > 0, "must have URI parts to build URIs");
1692 
1693         for (uint256 index = 0; index < _tokenIds.length; index++) {
1694             uint256 tokenId = _tokenIds[index];
1695             uint256 tokenPrice = _tokenPrices[index];
1696             string memory tokenURI = _generateTokenURI(_tokenURIParts, tokenId);
1697 
1698             mintNFTForSale(tokenId, tokenURI, tokenPrice);
1699         }
1700     }
1701 
1702     /// @dev Allows the operator to take an asset that's not up for sale and put it up for sale.
1703     /// @param _tokenId the ID of the asset
1704     /// @param _tokenPrice the price of the asset
1705     function setItemForSale(uint256 _tokenId, uint256 _tokenPrice) public onlyOperator {
1706         require(items.exists(_tokenId));
1707         require(!isTokenForSale(_tokenId));
1708         require(items.ownerOf(_tokenId) == operator, "cannot set item for sale after it has been sold");
1709 
1710         tokenPrices[_tokenId] = _tokenPrice;
1711         itemsForSaleIndex[_tokenId] = itemsForSale.push(_tokenId).sub(1);
1712         
1713         emit LogNFTSetForSale(_tokenId, _tokenPrice, operator);
1714     }
1715 
1716     /// @dev A bulk optimization for setItemForSale.
1717     /// @param _tokenIds an array of IDs of assets to update
1718     /// @param _tokenPrices an array of prices to set
1719     function setItemsForSale(uint256[] _tokenIds, uint256[] _tokenPrices) public onlyOperator {
1720         require(_tokenIds.length == _tokenPrices.length);
1721         for (uint256 index = 0; index < _tokenIds.length; index++) {
1722             setItemForSale(_tokenIds[index], _tokenPrices[index]);
1723         }
1724     }
1725 
1726     /// @dev Allows the operator to take down an item for sale.
1727     /// @param _tokenId the ID of the asset to take down
1728     function setItemNotForSale(uint256 _tokenId) public onlyOperator {
1729         _setItemNotForSale(_tokenId);
1730 
1731         emit LogNFTSetNotForSale(_tokenId, operator);
1732     }
1733 
1734     /// @dev A bulk optimization for setItemNotForSale.
1735     /// @param _tokenIds an array of IDs of assets to update
1736     function setItemsNotForSale(uint256[] _tokenIds) public onlyOperator {
1737         for (uint256 index = 0; index < _tokenIds.length; index++) {
1738             setItemNotForSale(_tokenIds[index]);
1739         }
1740     }
1741 
1742     /// @dev Allows the operator to update an asset's price.
1743     /// @param _tokenId the ID of the asset
1744     /// @param _tokenPrice the new price to set
1745     function updateItemPrice(uint256 _tokenId, uint256 _tokenPrice) public onlyOperator {
1746         require(items.exists(_tokenId));
1747         require(items.ownerOf(_tokenId) == operator);
1748         require(isTokenForSale(_tokenId));
1749         tokenPrices[_tokenId] = _tokenPrice;
1750     }
1751 
1752     /// @dev A bulk optimization for updateItemPrice
1753     /// @param _tokenIds the IDs of tokens to update
1754     /// @param _tokenPrices the new prices to set
1755     function updateItemsPrices(uint256[] _tokenIds, uint256[] _tokenPrices) public onlyOperator {
1756         require(_tokenIds.length == _tokenPrices.length, "input arrays must have the same length");
1757         for (uint256 index = 0; index < _tokenIds.length; index++) {
1758             updateItemPrice(_tokenIds[index], _tokenPrices[index]);
1759         }
1760     }
1761 
1762     /// @dev Allows the operator to set discount prices for specific items.
1763     /// @param _tokenIds the IDs of items to set a discount price for
1764     /// @param _discountPrices the discount prices to set
1765     function setDiscounts(uint256[] _tokenIds, uint256[] _discountPrices) public onlyOperator {
1766         require(_tokenIds.length == _discountPrices.length, "input arrays must have the same length");
1767 
1768         for (uint256 index = 0; index < _tokenIds.length; index++) {
1769             _setDiscount(_tokenIds[index], _discountPrices[index]);    
1770         }
1771     }
1772 
1773     /// @dev Allows the operator to remove the discount from specific items.
1774     /// @param _tokenIds the IDs of the items to remove the discount from
1775     function removeDiscounts(uint256[] _tokenIds) public onlyOperator {
1776         for (uint256 index = 0; index < _tokenIds.length; index++) {
1777             _removeDiscount(_tokenIds[index]);            
1778         }
1779     }
1780 
1781     /// @dev Allows the operator to update discount prices.
1782     /// @param _tokenIds the IDs of the items to update
1783     /// @param _discountPrices the new discount prices to set 
1784     function updateDiscounts(uint256[] _tokenIds, uint256[] _discountPrices) public onlyOperator {
1785         require(_tokenIds.length == _discountPrices.length, "arrays must be same-length");
1786 
1787         for (uint256 index = 0; index < _tokenIds.length; index++) {
1788             _updateDiscount(_tokenIds[index], _discountPrices[index]);
1789         }
1790     }
1791 
1792     /// @dev Allows the operator to reset all discounted items at once.
1793     function resetDiscounts() public onlyOperator {
1794         emit LogDiscountsReset(discountedItems.length, operator);
1795 
1796         for (uint256 index = 0; index < discountedItems.length; index++) {
1797             uint256 tokenId = discountedItems[index];
1798             discountedItemPrices[tokenId] = 0;
1799             discountedItemsIndex[tokenId] = 0;            
1800         }
1801         discountedItems.length = 0;
1802     }
1803 
1804     /// @dev An atomic txn optimization for calling resetDiscounts and then setDiscounts, so we don't have to experience
1805     /// any moment of not having any items under discount.
1806     /// @param _tokenIds the IDs of the new items to discount
1807     /// @param _discountPrices the discounted prices of the new items to discount
1808     function resetOldAndSetNewDiscounts(uint256[] _tokenIds, uint256[] _discountPrices) public onlyOperator {
1809         resetDiscounts();
1810         setDiscounts(_tokenIds, _discountPrices);
1811     }
1812 
1813     /// @dev Allows the operator to set the start and end time of the sale. 
1814     /// Before startTime and after endTime no one should be able to buy items from this contract.
1815     /// @param _startTime the time the pre-sale should start
1816     /// @param _endTime the time the pre-sale should end
1817     function setStartAndEndTime(uint256 _startTime, uint256 _endTime) public onlyOperator {
1818         require(_startTime >= now);
1819         require(_startTime < _endTime);
1820 
1821         startTime = _startTime;
1822         endTime = _endTime;
1823 
1824         emit LogStartAndEndTimeSet(_startTime, _endTime, operator);
1825     }
1826 
1827     function setStartTime(uint256 _startTime) public onlyOperator {
1828         require(_startTime > 0);
1829 
1830         startTime = _startTime;
1831 
1832         emit LogStartTimeSet(_startTime, operator);
1833     }
1834 
1835     function setEndTime(uint256 _endTime) public onlyOperator {
1836         require(_endTime > 0);
1837 
1838         endTime = _endTime;
1839 
1840         emit LogEndTimeSet(_endTime, operator);
1841     }
1842 
1843     /// @dev Allows the operator to withdraw funds from the sale to the address defined by the owner.
1844     function withdraw() public onlyOperator {
1845         require(withdrawTo != address(0));
1846         uint256 balance = address(this).balance;
1847         require(address(this).balance > 0);
1848 
1849         withdrawTo.transfer(balance);
1850 
1851         emit LogWithdraw(withdrawTo, balance, owner);
1852     }
1853 
1854     /*
1855      * Owner (authorized) functions
1856      */
1857 
1858     /// @dev Allows the owner to change the contract representing the tokens. Reserved for emergency bugs only.
1859     /// Because this is a big deal we hope to avoid ever using it, the operator cannot run it, but only the
1860     /// owner.
1861     /// @param _cryptoTakeoversTokenAddress the address of the new contract to use
1862     function setTokensContract(address _cryptoTakeoversTokenAddress) public onlyOwner {
1863         emit LogTokensContractSet(tokens, _cryptoTakeoversTokenAddress, owner);
1864 
1865         tokens = CryptoTakeoversToken(_cryptoTakeoversTokenAddress);
1866     }
1867 
1868     /// @dev Allows the owner to change the contract representing the assets. Reserved for emergency bugs only.
1869     /// Because this is a big deal we hope to avoid ever using it, the operator cannot run it, but only the
1870     /// owner.
1871     /// @param _cryptoTakeoversNFTAddress the address of the new contract to use
1872     function setItemsContract(address _cryptoTakeoversNFTAddress) public onlyOwner {
1873         emit LogItemsContractSet(items, _cryptoTakeoversNFTAddress, owner);
1874 
1875         items = CryptoTakeoversNFT(_cryptoTakeoversNFTAddress);
1876     }
1877 
1878     /// @dev Allows the owner to change the address to which the operator can withdraw this contract's
1879     /// ETH balance.
1880     /// @param _withdrawTo the address future withdraws will go to
1881     function setWithdrawTo(address _withdrawTo) public onlyOwner {
1882         require(_withdrawTo != address(0));
1883 
1884         emit LogWithdrawToChanged(withdrawTo, _withdrawTo, owner);
1885 
1886         withdrawTo = _withdrawTo;
1887     }
1888 
1889     /*
1890      * Internal functions
1891      */
1892 
1893     /// @dev Marks an asset as not for sale.
1894     /// @param _tokenId the ID of the item to take down from the sale
1895     function _setItemNotForSale(uint256 _tokenId) internal {
1896         require(items.exists(_tokenId));
1897         require(isTokenForSale(_tokenId));
1898 
1899         if (_isTokenDiscounted(_tokenId)) {
1900             _removeDiscount(_tokenId);
1901         }
1902 
1903         tokenPrices[_tokenId] = 0;
1904 
1905         uint256 currentTokenIndex = itemsForSaleIndex[_tokenId];
1906         uint256 lastTokenIndex = itemsForSale.length.sub(1);
1907         uint256 lastTokenId = itemsForSale[lastTokenIndex];
1908 
1909         itemsForSale[currentTokenIndex] = lastTokenId;
1910         itemsForSale[lastTokenIndex] = 0;
1911         itemsForSale.length = itemsForSale.length.sub(1);
1912 
1913         itemsForSaleIndex[_tokenId] = 0;
1914         itemsForSaleIndex[lastTokenId] = currentTokenIndex;
1915     }
1916 
1917     function _appendUintToString(string inStr, uint vInput) internal pure returns (string str) {
1918         uint v = vInput;
1919         uint maxlength = 100;
1920         bytes memory reversed = new bytes(maxlength);
1921         uint i = 0;
1922         while (v != 0) {
1923             uint remainder = v % 10;
1924             v = v / 10;
1925             reversed[i++] = byte(48 + remainder);
1926         }
1927         bytes memory inStrb = bytes(inStr);
1928         bytes memory s = new bytes(inStrb.length + i);
1929         uint j;
1930         for (j = 0; j < inStrb.length; j++) {
1931             s[j] = inStrb[j];
1932         }
1933         for (j = 0; j < i; j++) {
1934             s[j + inStrb.length] = reversed[i - 1 - j];
1935         }
1936         str = string(s);
1937     }
1938 
1939     function _bytes32ArrayToString(bytes32[] data) internal pure returns (string) {
1940         bytes memory bytesString = new bytes(data.length * 32);
1941         uint urlLength;
1942         for (uint256 i = 0; i < data.length; i++) {
1943             for (uint256 j = 0; j < 32; j++) {
1944                 byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j)));
1945                 if (char != 0) {
1946                     bytesString[urlLength] = char;
1947                     urlLength += 1;
1948                 }
1949             }
1950         }
1951         bytes memory bytesStringTrimmed = new bytes(urlLength);
1952         for (i = 0; i < urlLength; i++) {
1953             bytesStringTrimmed[i] = bytesString[i];
1954         }
1955         return string(bytesStringTrimmed);
1956     }
1957 
1958     function _generateTokenURI(bytes32[] _tokenURIParts, uint256 _tokenId) internal pure returns(string tokenURI) {
1959         string memory baseUrl = _bytes32ArrayToString(_tokenURIParts);
1960         tokenURI = _appendUintToString(baseUrl, _tokenId);
1961     }
1962 
1963     function _setDiscount(uint256 _tokenId, uint256 _discountPrice) internal {
1964         require(items.exists(_tokenId), "does not make sense to set a discount for an item that does not exist");
1965         require(items.ownerOf(_tokenId) == operator, "we only change items still owned by us");
1966         require(isTokenForSale(_tokenId), "does not make sense to set a discount for an item not for sale");
1967         require(!_isTokenDiscounted(_tokenId), "cannot discount the same item twice");
1968         require(_discountPrice > 0 && _discountPrice < tokenPrices[_tokenId], "discount price must be positive and less than full price");
1969 
1970         discountedItemPrices[_tokenId] = _discountPrice;
1971         discountedItemsIndex[_tokenId] = discountedItems.push(_tokenId).sub(1);
1972 
1973         emit LogDiscountSet(_tokenId, _discountPrice, operator);
1974     }
1975 
1976     function _updateDiscount(uint256 _tokenId, uint256 _discountPrice) internal {
1977         require(items.exists(_tokenId), "item must exist");
1978         require(items.ownerOf(_tokenId) == operator, "we must own the item");
1979         require(_isTokenDiscounted(_tokenId), "must be discounted");
1980         require(_discountPrice > 0 && _discountPrice < tokenPrices[_tokenId], "discount price must be positive and less than full price");
1981 
1982         discountedItemPrices[_tokenId] = _discountPrice;
1983 
1984         emit LogDiscountUpdated(_tokenId, _discountPrice, operator);
1985     }
1986 
1987     function _getItemPrice(uint256 _tokenId) internal view returns(uint256) {
1988         if (_isTokenDiscounted(_tokenId)) {
1989             return discountedItemPrices[_tokenId];
1990         }
1991         return tokenPrices[_tokenId];
1992     }
1993 
1994     function _isTokenDiscounted(uint256 _tokenId) internal view returns(bool) {
1995         return discountedItemPrices[_tokenId] != 0;
1996     }
1997 
1998     function _removeDiscount(uint256 _tokenId) internal {
1999         require(items.exists(_tokenId), "item must exist");
2000         require(_isTokenDiscounted(_tokenId), "item must be discounted");
2001 
2002         discountedItemPrices[_tokenId] = 0;
2003 
2004         uint256 currentTokenIndex = discountedItemsIndex[_tokenId];
2005         uint256 lastTokenIndex = discountedItems.length.sub(1);
2006         uint256 lastTokenId = discountedItems[lastTokenIndex];
2007 
2008         discountedItems[currentTokenIndex] = lastTokenId;
2009         discountedItems[lastTokenIndex] = 0;
2010         discountedItems.length = discountedItems.length.sub(1);
2011 
2012         discountedItemsIndex[_tokenId] = 0;
2013         discountedItemsIndex[lastTokenId] = currentTokenIndex;
2014 
2015         emit LogDiscountRemoved(_tokenId, operator);
2016     }
2017 }