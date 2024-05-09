1 pragma solidity ^0.4.23;
2 
3 // File: contracts\utils\Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts\utils\AccessControl.sol
46 
47 contract AccessControl is Ownable{
48     address CFO;
49     //Owner address can set to COO address. it have same effect.
50 
51     modifier onlyCFO{
52         require(msg.sender == CFO);
53         _;
54     }
55 
56     function setCFO(address _newCFO)public onlyOwner {
57         CFO = _newCFO;
58     }
59 
60     //use pausable in the contract that need to pause. save gas and clear confusion.
61 
62 }
63 
64 // File: contracts\utils\AddressUtils.sol
65 
66 /**
67  * Utility library of inline functions on addresses
68  */
69 library AddressUtils {
70 
71   /**
72    * Returns whether the target address is a contract
73    * @dev This function will return false if invoked during the constructor of a contract,
74    *  as the code is not actually created until after the constructor finishes.
75    * @param addr address to check
76    * @return whether the target address is a contract
77    */
78   function isContract(address addr) internal view returns (bool) {
79     uint256 size;
80     // XXX Currently there is no better way to check if there is a contract in an address
81     // than to check the size of the code at that address.
82     // See https://ethereum.stackexchange.com/a/14016/36603
83     // for more details about how this works.
84     // TODO Check this again before the Serenity release, because all addresses will be
85     // contracts then.
86     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
87     return size > 0;
88   }
89 
90 }
91 
92 // File: contracts\utils\TrustedContractControl.sol
93 
94 contract TrustedContractControl is Ownable{
95   using AddressUtils for address;
96 
97   mapping (address => bool) public trustedContractList;
98 
99   modifier onlyTrustedContract(address _contractAddress) {
100     require(trustedContractList[_contractAddress]);
101     _;
102   }
103 
104   event AddTrustedContract(address contractAddress);
105   event RemoveTrustedContract(address contractAddress);
106 
107 
108   function addTrustedContracts(address[] _contractAddress) onlyOwner public {
109     for(uint i=0; i<_contractAddress.length; i++) {
110       require(addTrustedContract(_contractAddress[i]));
111     }
112   }
113 
114 
115   // need to add GirlSummon, GirlRecycle contract into the trusted list.
116   function addTrustedContract(address _contractAddress) onlyOwner public returns (bool){
117     require(!trustedContractList[_contractAddress]);
118     require(_contractAddress.isContract());
119     trustedContractList[_contractAddress] = true;
120     emit AddTrustedContract(_contractAddress);
121     return true;
122   }
123 
124   function removeTrustedContract(address _contractAddress) onlyOwner public {
125     require(trustedContractList[_contractAddress]);
126     trustedContractList[_contractAddress] = false;
127     emit RemoveTrustedContract(_contractAddress);
128   }
129 }
130 
131 // File: contracts\utils\SafeMath.sol
132 
133 /**
134  * @title SafeMath
135  * @dev Math operations with safety checks that throw on error
136  */
137 library SafeMath {
138 
139   /**
140   * @dev Multiplies two numbers, throws on overflow.
141   */
142   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     if (a == 0) {
144       return 0;
145     }
146     c = a * b;
147     assert(c / a == b);
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers, truncating the quotient.
153   */
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     // uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return a / b;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165     assert(b <= a);
166     return a - b;
167   }
168 
169   /**
170   * @dev Adds two numbers, throws on overflow.
171   */
172   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
173     c = a + b;
174     assert(c >= a);
175     return c;
176   }
177 }
178 
179 // File: contracts\utils\Serialize.sol
180 
181 contract Serialize {
182     using SafeMath for uint256;
183     function addAddress(uint _offst, bytes memory _output, address _input) internal pure returns(uint _offset) {
184       assembly {
185         mstore(add(_output, _offst), _input)
186       }
187       return _offst.sub(20);
188     }
189 
190     function addUint(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
191       assembly {
192         mstore(add(_output, _offst), _input)
193       }
194       return _offst.sub(32);
195     }
196 
197     function addUint8(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
198       assembly {
199         mstore(add(_output, _offst), _input)
200       }
201       return _offst.sub(1);
202     }
203 
204     function addUint16(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
205       assembly {
206         mstore(add(_output, _offst), _input)
207       }
208       return _offst.sub(2);
209     }
210 
211     function addUint64(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
212       assembly {
213         mstore(add(_output, _offst), _input)
214       }
215       return _offst.sub(8);
216     }
217 
218     function getAddress(uint _offst, bytes memory _input) internal pure returns (address _output, uint _offset) {
219       assembly {
220         _output := mload(add(_input, _offst))
221       }
222       return (_output, _offst.sub(20));
223     }
224 
225     function getUint(uint _offst, bytes memory _input) internal pure returns (uint _output, uint _offset) {
226       assembly {
227           _output := mload(add(_input, _offst))
228       }
229       return (_output, _offst.sub(32));
230     }
231 
232     function getUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output, uint _offset) {
233       assembly {
234         _output := mload(add(_input, _offst))
235       }
236       return (_output, _offst.sub(1));
237     }
238 
239     function getUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output, uint _offset) {
240       assembly {
241         _output := mload(add(_input, _offst))
242       }
243       return (_output, _offst.sub(2));
244     }
245 
246     function getUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output, uint _offset) {
247       assembly {
248         _output := mload(add(_input, _offst))
249       }
250       return (_output, _offst.sub(8));
251     }
252 }
253 
254 // File: contracts\utils\Pausable.sol
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = false;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused public {
287     paused = true;
288     emit Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public {
295     paused = false;
296     emit Unpause();
297   }
298 }
299 
300 // File: contracts\ERC721\ERC721Basic.sol
301 
302 /**
303  * @title ERC721 Non-Fungible Token Standard basic interface
304  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
305  */
306 contract ERC721Basic {
307   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
308   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
309   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
310 
311   function balanceOf(address _owner) public view returns (uint256 _balance);
312   function ownerOf(uint256 _tokenId) public view returns (address _owner);
313   function exists(uint256 _tokenId) public view returns (bool _exists);
314 
315   function approve(address _to, uint256 _tokenId) public;
316   function getApproved(uint256 _tokenId) public view returns (address _operator);
317 
318   function setApprovalForAll(address _operator, bool _approved) public;
319   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
320 
321   function transferFrom(address _from, address _to, uint256 _tokenId) public;
322   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
323   function safeTransferFrom(
324     address _from,
325     address _to,
326     uint256 _tokenId,
327     bytes _data
328   )
329     public;
330 }
331 
332 // File: contracts\ERC721\ERC721Receiver.sol
333 
334 /**
335  * @title ERC721 token receiver interface
336  * @dev Interface for any contract that wants to support safeTransfers
337  *  from ERC721 asset contracts.
338  */
339 contract ERC721Receiver {
340   /**
341    * @dev Magic value to be returned upon successful reception of an NFT
342    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
343    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
344    */
345   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
346 
347   /**
348    * @notice Handle the receipt of an NFT
349    * @dev The ERC721 smart contract calls this function on the recipient
350    *  after a `safetransfer`. This function MAY throw to revert and reject the
351    *  transfer. This function MUST use 50,000 gas or less. Return of other
352    *  than the magic value MUST result in the transaction being reverted.
353    *  Note: the contract address is always the message sender.
354    * @param _from The sending address
355    * @param _tokenId The NFT identifier which is being transfered
356    * @param _data Additional data with no specified format
357    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
358    */
359   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
360 }
361 
362 // File: contracts\ERC721\ERC721BasicToken.sol
363 
364 /**
365  * @title ERC721 Non-Fungible Token Standard basic implementation
366  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
367  */
368 contract ERC721BasicToken is ERC721Basic, Pausable {
369   using SafeMath for uint256;
370   using AddressUtils for address;
371 
372   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
373   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
374   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
375 
376   // Mapping from token ID to owner
377   mapping (uint256 => address) internal tokenOwner;
378 
379   // Mapping from token ID to approved address
380   mapping (uint256 => address) internal tokenApprovals;
381 
382   // Mapping from owner to number of owned token
383   mapping (address => uint256) internal ownedTokensCount;
384 
385   // Mapping from owner to operator approvals
386   mapping (address => mapping (address => bool)) internal operatorApprovals;
387 
388   /**
389    * @dev Guarantees msg.sender is owner of the given token
390    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
391    */
392   modifier onlyOwnerOf(uint256 _tokenId) {
393     require(ownerOf(_tokenId) == msg.sender);
394     _;
395   }
396 
397   /**
398    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
399    * @param _tokenId uint256 ID of the token to validate
400    */
401   modifier canTransfer(uint256 _tokenId) {
402     require(isApprovedOrOwner(msg.sender, _tokenId));
403     _;
404   }
405 
406   /**
407    * @dev Gets the balance of the specified address
408    * @param _owner address to query the balance of
409    * @return uint256 representing the amount owned by the passed address
410    */
411   function balanceOf(address _owner) public view returns (uint256) {
412     require(_owner != address(0));
413     return ownedTokensCount[_owner];
414   }
415 
416   /**
417    * @dev Gets the owner of the specified token ID
418    * @param _tokenId uint256 ID of the token to query the owner of
419    * @return owner address currently marked as the owner of the given token ID
420    */
421   function ownerOf(uint256 _tokenId) public view returns (address) {
422     address owner = tokenOwner[_tokenId];
423     require(owner != address(0));
424     return owner;
425   }
426 
427   /**
428    * @dev Returns whether the specified token exists
429    * @param _tokenId uint256 ID of the token to query the existance of
430    * @return whether the token exists
431    */
432   function exists(uint256 _tokenId) public view returns (bool) {
433     address owner = tokenOwner[_tokenId];
434     return owner != address(0);
435   }
436 
437   /**
438    * @dev Approves another address to transfer the given token ID
439    * @dev The zero address indicates there is no approved address.
440    * @dev There can only be one approved address per token at a given time.
441    * @dev Can only be called by the token owner or an approved operator.
442    * @param _to address to be approved for the given token ID
443    * @param _tokenId uint256 ID of the token to be approved
444    */
445   function approve(address _to, uint256 _tokenId) public {
446     address owner = ownerOf(_tokenId);
447     require(_to != owner);
448     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
449 
450     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
451       tokenApprovals[_tokenId] = _to;
452       emit Approval(owner, _to, _tokenId);
453     }
454   }
455 
456   /**
457    * @dev Gets the approved address for a token ID, or zero if no address set
458    * @param _tokenId uint256 ID of the token to query the approval of
459    * @return address currently approved for a the given token ID
460    */
461   function getApproved(uint256 _tokenId) public view returns (address) {
462     return tokenApprovals[_tokenId];
463   }
464 
465   /**
466    * @dev Sets or unsets the approval of a given operator
467    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
468    * @param _to operator address to set the approval
469    * @param _approved representing the status of the approval to be set
470    */
471   function setApprovalForAll(address _to, bool _approved) public {
472     require(_to != msg.sender);
473     operatorApprovals[msg.sender][_to] = _approved;
474     emit ApprovalForAll(msg.sender, _to, _approved);
475   }
476 
477   /**
478    * @dev Tells whether an operator is approved by a given owner
479    * @param _owner owner address which you want to query the approval of
480    * @param _operator operator address which you want to query the approval of
481    * @return bool whether the given operator is approved by the given owner
482    */
483   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
484     return operatorApprovals[_owner][_operator];
485   }
486 
487   /**
488    * @dev Transfers the ownership of a given token ID to another address
489    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
490    * @dev Requires the msg sender to be the owner, approved, or operator
491    * @param _from current owner of the token
492    * @param _to address to receive the ownership of the given token ID
493    * @param _tokenId uint256 ID of the token to be transferred
494   */
495   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
496     require(_from != address(0));
497     require(_to != address(0));
498 
499     clearApproval(_from, _tokenId);
500     removeTokenFrom(_from, _tokenId);
501     addTokenTo(_to, _tokenId);
502 
503     emit Transfer(_from, _to, _tokenId);
504   }
505 
506   function transferBatch(address _from, address _to, uint[] _tokenIds) public {
507     require(_from != address(0));
508     require(_to != address(0));
509 
510     for(uint i=0; i<_tokenIds.length; i++) {
511       require(isApprovedOrOwner(msg.sender, _tokenIds[i]));
512       clearApproval(_from,  _tokenIds[i]);
513       removeTokenFrom(_from, _tokenIds[i]);
514       addTokenTo(_to, _tokenIds[i]);
515 
516       emit Transfer(_from, _to, _tokenIds[i]);
517     }
518   }
519 
520   /**
521    * @dev Safely transfers the ownership of a given token ID to another address
522    * @dev If the target address is a contract, it must implement `onERC721Received`,
523    *  which is called upon a safe transfer, and return the magic value
524    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
525    *  the transfer is reverted.
526    * @dev Requires the msg sender to be the owner, approved, or operator
527    * @param _from current owner of the token
528    * @param _to address to receive the ownership of the given token ID
529    * @param _tokenId uint256 ID of the token to be transferred
530   */
531   function safeTransferFrom(
532     address _from,
533     address _to,
534     uint256 _tokenId
535   )
536     public
537     canTransfer(_tokenId)
538   {
539     // solium-disable-next-line arg-overflow
540     safeTransferFrom(_from, _to, _tokenId, "");
541   }
542 
543   /**
544    * @dev Safely transfers the ownership of a given token ID to another address
545    * @dev If the target address is a contract, it must implement `onERC721Received`,
546    *  which is called upon a safe transfer, and return the magic value
547    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
548    *  the transfer is reverted.
549    * @dev Requires the msg sender to be the owner, approved, or operator
550    * @param _from current owner of the token
551    * @param _to address to receive the ownership of the given token ID
552    * @param _tokenId uint256 ID of the token to be transferred
553    * @param _data bytes data to send along with a safe transfer check
554    */
555   function safeTransferFrom(
556     address _from,
557     address _to,
558     uint256 _tokenId,
559     bytes _data
560   )
561     public
562     canTransfer(_tokenId)
563   {
564     transferFrom(_from, _to, _tokenId);
565     // solium-disable-next-line arg-overflow
566     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
567   }
568 
569   /**
570    * @dev Returns whether the given spender can transfer a given token ID
571    * @param _spender address of the spender to query
572    * @param _tokenId uint256 ID of the token to be transferred
573    * @return bool whether the msg.sender is approved for the given token ID,
574    *  is an operator of the owner, or is the owner of the token
575    */
576   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
577     address owner = ownerOf(_tokenId);
578     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
579   }
580 
581   /**
582    * @dev Internal function to mint a new token
583    * @dev Reverts if the given token ID already exists
584    * @param _to The address that will own the minted token
585    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
586    */
587   function _mint(address _to, uint256 _tokenId) internal {
588     require(_to != address(0));
589     addTokenTo(_to, _tokenId);
590     emit Transfer(address(0), _to, _tokenId);
591   }
592 
593   /**
594    * @dev Internal function to burn a specific token
595    * @dev Reverts if the token does not exist
596    * @param _tokenId uint256 ID of the token being burned by the msg.sender
597    */
598   function _burn(address _owner, uint256 _tokenId) internal {
599     clearApproval(_owner, _tokenId);
600     removeTokenFrom(_owner, _tokenId);
601     emit Transfer(_owner, address(0), _tokenId);
602   }
603 
604   /**
605    * @dev Internal function to clear current approval of a given token ID
606    * @dev Reverts if the given address is not indeed the owner of the token
607    * @param _owner owner of the token
608    * @param _tokenId uint256 ID of the token to be transferred
609    */
610   function clearApproval(address _owner, uint256 _tokenId) internal {
611     require(ownerOf(_tokenId) == _owner);
612     if (tokenApprovals[_tokenId] != address(0)) {
613       tokenApprovals[_tokenId] = address(0);
614       emit Approval(_owner, address(0), _tokenId);
615     }
616   }
617 
618   /**
619    * @dev Internal function to add a token ID to the list of a given address
620    * @param _to address representing the new owner of the given token ID
621    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
622    */
623   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
624     require(tokenOwner[_tokenId] == address(0));
625     tokenOwner[_tokenId] = _to;
626     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
627   }
628 
629   /**
630    * @dev Internal function to remove a token ID from the list of a given address
631    * @param _from address representing the previous owner of the given token ID
632    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
633    */
634   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused{
635     require(ownerOf(_tokenId) == _from);
636     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
637     tokenOwner[_tokenId] = address(0);
638   }
639 
640   /**
641    * @dev Internal function to invoke `onERC721Received` on a target address
642    * @dev The call is not executed if the target address is not a contract
643    * @param _from address representing the previous owner of the given token ID
644    * @param _to target address that will receive the tokens
645    * @param _tokenId uint256 ID of the token to be transferred
646    * @param _data bytes optional data to send along with the call
647    * @return whether the call correctly returned the expected magic value
648    */
649   function checkAndCallSafeTransfer(
650     address _from,
651     address _to,
652     uint256 _tokenId,
653     bytes _data
654   )
655     internal
656     returns (bool)
657   {
658     if (!_to.isContract()) {
659       return true;
660     }
661     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
662     return (retval == ERC721_RECEIVED);
663   }
664 }
665 
666 // File: contracts\ERC721\GirlBasicToken.sol
667 
668 // add atomic swap feature in the token contract.
669 contract GirlBasicToken is ERC721BasicToken, Serialize {
670 
671   event CreateGirl(address owner, uint256 tokenID, uint256 genes, uint64 birthTime, uint64 cooldownEndTime, uint16 starLevel);
672   event CoolDown(uint256 tokenId, uint64 cooldownEndTime);
673   event GirlUpgrade(uint256 tokenId, uint64 starLevel);
674 
675   struct Girl{
676     /**
677     少女基因,生成以后不会改变
678     **/
679     uint genes;
680 
681     /*
682     出生时间 少女创建时候的时间戳
683     */
684     uint64 birthTime;
685 
686     /*
687     冷却结束时间
688     */
689     uint64 cooldownEndTime;
690     /*
691     star level
692     */
693     uint16 starLevel;
694   }
695 
696   Girl[] girls;
697 
698 
699   function totalSupply() public view returns (uint256) {
700     return girls.length;
701   }
702 
703   function getGirlGene(uint _index) public view returns (uint) {
704     return girls[_index].genes;
705   }
706 
707   function getGirlBirthTime(uint _index) public view returns (uint64) {
708     return girls[_index].birthTime;
709   }
710 
711   function getGirlCoolDownEndTime(uint _index) public view returns (uint64) {
712     return girls[_index].cooldownEndTime;
713   }
714 
715   function getGirlStarLevel(uint _index) public view returns (uint16) {
716     return girls[_index].starLevel;
717   }
718 
719   function isNotCoolDown(uint _girlId) public view returns(bool) {
720     return uint64(now) > girls[_girlId].cooldownEndTime;
721   }
722 
723   function _createGirl(
724       uint _genes,
725       address _owner,
726       uint16 _starLevel
727   ) internal returns (uint){
728       Girl memory _girl = Girl({
729           genes:_genes,
730           birthTime:uint64(now),
731           cooldownEndTime:0,
732           starLevel:_starLevel
733       });
734       uint256 girlId = girls.push(_girl) - 1;
735       _mint(_owner, girlId);
736       emit CreateGirl(_owner, girlId, _genes, _girl.birthTime, _girl.cooldownEndTime, _girl.starLevel);
737       return girlId;
738   }
739 
740   function _setCoolDownTime(uint _tokenId, uint _coolDownTime) internal {
741     girls[_tokenId].cooldownEndTime = uint64(now.add(_coolDownTime));
742     emit CoolDown(_tokenId, girls[_tokenId].cooldownEndTime);
743   }
744 
745   function _LevelUp(uint _tokenId) internal {
746     require(girls[_tokenId].starLevel < 65535);
747     girls[_tokenId].starLevel = girls[_tokenId].starLevel + 1;
748     emit GirlUpgrade(_tokenId, girls[_tokenId].starLevel);
749   }
750 
751   // ---------------
752   // this is atomic swap for girl to be set cross chain.
753   // ---------------
754   uint8 constant public GIRLBUFFERSIZE = 50;  // buffer size need to serialize girl data; used for cross chain sync
755 
756   struct HashLockContract {
757     address sender;
758     address receiver;
759     uint tokenId;
760     bytes32 hashlock;
761     uint timelock;
762     bytes32 secret;
763     States state;
764     bytes extraData;
765   }
766 
767   enum States {
768     INVALID,
769     OPEN,
770     CLOSED,
771     REFUNDED
772   }
773 
774   mapping (bytes32 => HashLockContract) private contracts;
775 
776   modifier contractExists(bytes32 _contractId) {
777     require(_contractExists(_contractId));
778     _;
779   }
780 
781   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
782     require(contracts[_contractId].hashlock == keccak256(_secret));
783     _;
784   }
785 
786   modifier closable(bytes32 _contractId) {
787     require(contracts[_contractId].state == States.OPEN);
788     require(contracts[_contractId].timelock > now);
789     _;
790   }
791 
792   modifier refundable(bytes32 _contractId) {
793     require(contracts[_contractId].state == States.OPEN);
794     require(contracts[_contractId].timelock <= now);
795     _;
796   }
797 
798   event NewHashLockContract (
799     bytes32 indexed contractId,
800     address indexed sender,
801     address indexed receiver,
802     uint tokenId,
803     bytes32 hashlock,
804     uint timelock,
805     bytes extraData
806   );
807 
808   event SwapClosed(bytes32 indexed contractId);
809   event SwapRefunded(bytes32 indexed contractId);
810 
811   function open (
812     address _receiver,
813     bytes32 _hashlock,
814     uint _duration,
815     uint _tokenId
816   ) public
817     onlyOwnerOf(_tokenId)
818     returns (bytes32 contractId)
819   {
820     uint _timelock = now.add(_duration);
821 
822     // compute girl data;
823     bytes memory _extraData = new bytes(GIRLBUFFERSIZE);
824     uint offset = GIRLBUFFERSIZE;
825 
826     offset = addUint16(offset, _extraData, girls[_tokenId].starLevel);
827     offset = addUint64(offset, _extraData, girls[_tokenId].cooldownEndTime);
828     offset = addUint64(offset, _extraData, girls[_tokenId].birthTime);
829     offset = addUint(offset, _extraData, girls[_tokenId].genes);
830 
831     contractId = keccak256 (
832       msg.sender,
833       _receiver,
834       _tokenId,
835       _hashlock,
836       _timelock,
837       _extraData
838     );
839 
840     // the new contract must not exist
841     require(!_contractExists(contractId));
842 
843     // temporary change the ownership to this contract address.
844     // the ownership will be change to user when close is called.
845     clearApproval(msg.sender, _tokenId);
846     removeTokenFrom(msg.sender, _tokenId);
847     addTokenTo(address(this), _tokenId);
848 
849 
850     contracts[contractId] = HashLockContract(
851       msg.sender,
852       _receiver,
853       _tokenId,
854       _hashlock,
855       _timelock,
856       0x0,
857       States.OPEN,
858       _extraData
859     );
860 
861     emit NewHashLockContract(contractId, msg.sender, _receiver, _tokenId, _hashlock, _timelock, _extraData);
862   }
863 
864   function close(bytes32 _contractId, bytes32 _secret)
865     public
866     contractExists(_contractId)
867     hashlockMatches(_contractId, _secret)
868     closable(_contractId)
869     returns (bool)
870   {
871     HashLockContract storage c = contracts[_contractId];
872     c.secret = _secret;
873     c.state = States.CLOSED;
874 
875     // transfer token ownership from this contract address to receiver.
876     // clearApproval(address(this), c.tokenId);
877     removeTokenFrom(address(this), c.tokenId);
878     addTokenTo(c.receiver, c.tokenId);
879 
880     emit SwapClosed(_contractId);
881     return true;
882   }
883 
884   function refund(bytes32 _contractId)
885     public
886     contractExists(_contractId)
887     refundable(_contractId)
888     returns (bool)
889   {
890     HashLockContract storage c = contracts[_contractId];
891     c.state = States.REFUNDED;
892 
893     // transfer token ownership from this contract address to receiver.
894     // clearApproval(address(this), c.tokenId);
895     removeTokenFrom(address(this), c.tokenId);
896     addTokenTo(c.sender, c.tokenId);
897 
898 
899     emit SwapRefunded(_contractId);
900     return true;
901   }
902 
903   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
904     exists = (contracts[_contractId].sender != address(0));
905   }
906 
907   function checkContract(bytes32 _contractId)
908     public
909     view
910     contractExists(_contractId)
911     returns (
912       address sender,
913       address receiver,
914       uint amount,
915       bytes32 hashlock,
916       uint timelock,
917       bytes32 secret,
918       bytes extraData
919     )
920   {
921     HashLockContract memory c = contracts[_contractId];
922     return (
923       c.sender,
924       c.receiver,
925       c.tokenId,
926       c.hashlock,
927       c.timelock,
928       c.secret,
929       c.extraData
930     );
931   }
932 
933 
934 }
935 
936 // File: contracts\ERC721\GirlOps.sol
937 
938 contract GirlOps is GirlBasicToken, TrustedContractControl {
939 
940   string public name = "Cryptogirl";
941   string public symbol = "CG";
942   
943   function createGirl(uint _genes, address _owner, uint16 _starLevel)
944       onlyTrustedContract(msg.sender) public returns (uint) {
945       require (_starLevel > 0);
946       return _createGirl(_genes, _owner, _starLevel);
947   }
948 
949   function createPromotionGirl(uint[] _genes, address _owner, uint16 _starLevel) onlyOwner public {
950   	require (_starLevel > 0);
951     for (uint i=0; i<_genes.length; i++) {
952       _createGirl(_genes[i], _owner, _starLevel);
953     }
954   }
955 
956   function burnGirl(address _owner, uint _tokenId) onlyTrustedContract(msg.sender) public {
957       _burn(_owner, _tokenId);
958   }
959 
960   function setCoolDownTime(uint _tokenId, uint _coolDownTime)
961       onlyTrustedContract(msg.sender) public {
962       _setCoolDownTime(_tokenId, _coolDownTime);
963   }
964 
965   function levelUp(uint _tokenId)
966       onlyTrustedContract(msg.sender) public {
967       _LevelUp(_tokenId);
968   }
969 
970   function safeTransferFromWithData(
971     address _from,
972     address _to,
973     uint256 _tokenId,
974     bytes _data
975   ) public {
976       safeTransferFrom(_from,_to,_tokenId,_data);
977   }
978 
979 
980 }
981 
982 // File: contracts\equipments\ERC20Basic.sol
983 
984 /**
985  * @title ERC20Basic
986  * @dev Simpler version of ERC20 interface
987  * @dev see https://github.com/ethereum/EIPs/issues/179
988  */
989 contract ERC20Basic {
990   function totalSupply() public view returns (uint256);
991   function balanceOf(address who) public view returns (uint256);
992   function transfer(address to, uint256 value) public returns (bool);
993   event Transfer(address indexed from, address indexed to, uint256 value);
994 }
995 
996 // File: contracts\equipments\BasicToken.sol
997 
998 /**
999  * @title Basic token
1000  * @dev Basic version of StandardToken, with no allowances.
1001  */
1002 contract BasicToken is ERC20Basic {
1003   using SafeMath for uint256;
1004 
1005   mapping(address => uint256) balances;
1006 
1007   uint256 totalSupply_;
1008 
1009   /**
1010   * @dev total number of tokens in existence
1011   */
1012   function totalSupply() public view returns (uint256) {
1013     return totalSupply_;
1014   }
1015 
1016   /**
1017   * @dev transfer token for a specified address
1018   * @param _to The address to transfer to.
1019   * @param _value The amount to be transferred.
1020   */
1021   function transfer(address _to, uint256 _value) public returns (bool) {
1022     require(_to != address(0));
1023     require(_value <= balances[msg.sender]);
1024 
1025     balances[msg.sender] = balances[msg.sender].sub(_value);
1026     balances[_to] = balances[_to].add(_value);
1027     emit Transfer(msg.sender, _to, _value);
1028     return true;
1029   }
1030 
1031   /**
1032   * @dev Gets the balance of the specified address.
1033   * @param _owner The address to query the the balance of.
1034   * @return An uint256 representing the amount owned by the passed address.
1035   */
1036   function balanceOf(address _owner) public view returns (uint256) {
1037     return balances[_owner];
1038   }
1039 
1040 }
1041 
1042 // File: contracts\equipments\ERC20.sol
1043 
1044 /**
1045  * @title ERC20 interface
1046  * @dev see https://github.com/ethereum/EIPs/issues/20
1047  */
1048 contract ERC20 is ERC20Basic {
1049   function allowance(address owner, address spender)
1050     public view returns (uint256);
1051 
1052   function transferFrom(address from, address to, uint256 value)
1053     public returns (bool);
1054 
1055   function approve(address spender, uint256 value) public returns (bool);
1056   event Approval(
1057     address indexed owner,
1058     address indexed spender,
1059     uint256 value
1060   );
1061 }
1062 
1063 // File: contracts\equipments\StandardToken.sol
1064 
1065 /**
1066  * @title Standard ERC20 token
1067  *
1068  * @dev Implementation of the basic standard token.
1069  * @dev https://github.com/ethereum/EIPs/issues/20
1070  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1071  */
1072 contract StandardToken is ERC20, BasicToken {
1073 
1074   mapping (address => mapping (address => uint256)) internal allowed;
1075 
1076 
1077   /**
1078    * @dev Transfer tokens from one address to another
1079    * @param _from address The address which you want to send tokens from
1080    * @param _to address The address which you want to transfer to
1081    * @param _value uint256 the amount of tokens to be transferred
1082    */
1083   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1084     require(_to != address(0));
1085     require(_value <= balances[_from]);
1086     require(_value <= allowed[_from][msg.sender]);
1087 
1088     balances[_from] = balances[_from].sub(_value);
1089     balances[_to] = balances[_to].add(_value);
1090     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1091     emit Transfer(_from, _to, _value);
1092     return true;
1093   }
1094 
1095   /**
1096    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1097    *
1098    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1099    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1100    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1101    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1102    * @param _spender The address which will spend the funds.
1103    * @param _value The amount of tokens to be spent.
1104    */
1105   function approve(address _spender, uint256 _value) public returns (bool) {
1106     allowed[msg.sender][_spender] = _value;
1107     emit Approval(msg.sender, _spender, _value);
1108     return true;
1109   }
1110 
1111   /**
1112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1113    * @param _owner address The address which owns the funds.
1114    * @param _spender address The address which will spend the funds.
1115    * @return A uint256 specifying the amount of tokens still available for the spender.
1116    */
1117   function allowance(address _owner, address _spender) public view returns (uint256) {
1118     return allowed[_owner][_spender];
1119   }
1120 
1121   /**
1122    * @dev Increase the amount of tokens that an owner allowed to a spender.
1123    *
1124    * approve should be called when allowed[_spender] == 0. To increment
1125    * allowed value is better to use this function to avoid 2 calls (and wait until
1126    * the first transaction is mined)
1127    * From MonolithDAO Token.sol
1128    * @param _spender The address which will spend the funds.
1129    * @param _addedValue The amount of tokens to increase the allowance by.
1130    */
1131   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1132     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1133     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1134     return true;
1135   }
1136 
1137   /**
1138    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1139    *
1140    * approve should be called when allowed[_spender] == 0. To decrement
1141    * allowed value is better to use this function to avoid 2 calls (and wait until
1142    * the first transaction is mined)
1143    * From MonolithDAO Token.sol
1144    * @param _spender The address which will spend the funds.
1145    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1146    */
1147   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1148     uint oldValue = allowed[msg.sender][_spender];
1149     if (_subtractedValue > oldValue) {
1150       allowed[msg.sender][_spender] = 0;
1151     } else {
1152       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1153     }
1154     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1155     return true;
1156   }
1157 
1158 }
1159 
1160 // File: contracts\equipments\AtomicSwappableToken.sol
1161 
1162 contract AtomicSwappableToken is StandardToken {
1163   struct HashLockContract {
1164     address sender;
1165     address receiver;
1166     uint amount;
1167     bytes32 hashlock;
1168     uint timelock;
1169     bytes32 secret;
1170     States state;
1171   }
1172 
1173   enum States {
1174     INVALID,
1175     OPEN,
1176     CLOSED,
1177     REFUNDED
1178   }
1179 
1180   mapping (bytes32 => HashLockContract) private contracts;
1181 
1182   modifier futureTimelock(uint _time) {
1183     // only requirement is the timelock time is after the last blocktime (now).
1184     // probably want something a bit further in the future then this.
1185     // but this is still a useful sanity check:
1186     require(_time > now);
1187     _;
1188 }
1189 
1190   modifier contractExists(bytes32 _contractId) {
1191     require(_contractExists(_contractId));
1192     _;
1193   }
1194 
1195   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
1196     require(contracts[_contractId].hashlock == keccak256(_secret));
1197     _;
1198   }
1199 
1200   modifier closable(bytes32 _contractId) {
1201     require(contracts[_contractId].state == States.OPEN);
1202     require(contracts[_contractId].timelock > now);
1203     _;
1204   }
1205 
1206   modifier refundable(bytes32 _contractId) {
1207     require(contracts[_contractId].state == States.OPEN);
1208     require(contracts[_contractId].timelock <= now);
1209     _;
1210   }
1211 
1212   event NewHashLockContract (
1213     bytes32 indexed contractId,
1214     address indexed sender,
1215     address indexed receiver,
1216     uint amount,
1217     bytes32 hashlock,
1218     uint timelock
1219   );
1220 
1221   event SwapClosed(bytes32 indexed contractId);
1222   event SwapRefunded(bytes32 indexed contractId);
1223 
1224 
1225   function open (
1226     address _receiver,
1227     bytes32 _hashlock,
1228     uint _timelock,
1229     uint _amount
1230   ) public
1231     futureTimelock(_timelock)
1232     returns (bytes32 contractId)
1233   {
1234     contractId = keccak256 (
1235       msg.sender,
1236       _receiver,
1237       _amount,
1238       _hashlock,
1239       _timelock
1240     );
1241 
1242     // the new contract must not exist
1243     require(!_contractExists(contractId));
1244 
1245     // transfer token to this contract
1246     require(transfer(address(this), _amount));
1247 
1248     contracts[contractId] = HashLockContract(
1249       msg.sender,
1250       _receiver,
1251       _amount,
1252       _hashlock,
1253       _timelock,
1254       0x0,
1255       States.OPEN
1256     );
1257 
1258     emit NewHashLockContract(contractId, msg.sender, _receiver, _amount, _hashlock, _timelock);
1259   }
1260 
1261   function close(bytes32 _contractId, bytes32 _secret)
1262     public
1263     contractExists(_contractId)
1264     hashlockMatches(_contractId, _secret)
1265     closable(_contractId)
1266     returns (bool)
1267   {
1268     HashLockContract storage c = contracts[_contractId];
1269     c.secret = _secret;
1270     c.state = States.CLOSED;
1271     require(this.transfer(c.receiver, c.amount));
1272     emit SwapClosed(_contractId);
1273     return true;
1274   }
1275 
1276   function refund(bytes32 _contractId)
1277     public
1278     contractExists(_contractId)
1279     refundable(_contractId)
1280     returns (bool)
1281   {
1282     HashLockContract storage c = contracts[_contractId];
1283     c.state = States.REFUNDED;
1284     require(this.transfer(c.sender, c.amount));
1285     emit SwapRefunded(_contractId);
1286     return true;
1287   }
1288 
1289   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
1290     exists = (contracts[_contractId].sender != address(0));
1291   }
1292 
1293   function checkContract(bytes32 _contractId)
1294     public
1295     view
1296     contractExists(_contractId)
1297     returns (
1298       address sender,
1299       address receiver,
1300       uint amount,
1301       bytes32 hashlock,
1302       uint timelock,
1303       bytes32 secret
1304     )
1305   {
1306     HashLockContract memory c = contracts[_contractId];
1307     return (
1308       c.sender,
1309       c.receiver,
1310       c.amount,
1311       c.hashlock,
1312       c.timelock,
1313       c.secret
1314     );
1315   }
1316 
1317 }
1318 
1319 // File: contracts\equipments\TokenReceiver.sol
1320 
1321 contract TokenReceiver {
1322   function receiveApproval(address from, uint amount, address tokenAddress, bytes data) public;
1323 }
1324 
1325 // File: contracts\equipments\BaseEquipment.sol
1326 
1327 contract BaseEquipment is Ownable, AtomicSwappableToken {
1328 
1329   event Mint(address indexed to, uint256 amount);
1330 
1331   //cap==0 means no limits
1332   uint256 public cap;
1333 
1334   /**
1335       properties = [
1336           0, //validationDuration
1337           1, //location
1338           2, //applicableType
1339       ];
1340   **/
1341   uint[] public properties;
1342 
1343 
1344   address public controller;
1345 
1346   modifier onlyController { require(msg.sender == controller); _; }
1347 
1348   function setController(address _newController) public onlyOwner {
1349     controller = _newController;
1350   }
1351 
1352   constructor(uint256 _cap, uint[] _properties) public {
1353     cap = _cap;
1354     properties = _properties;
1355   }
1356 
1357   function setProperty(uint256[] _properties) public onlyOwner {
1358     properties = _properties;
1359   }
1360 
1361 
1362   function _mint(address _to, uint _amount) internal {
1363     require(cap==0 || totalSupply_.add(_amount) <= cap);
1364     totalSupply_ = totalSupply_.add(_amount);
1365     balances[_to] = balances[_to].add(_amount);
1366     emit Transfer(address(0), _to, _amount);
1367   }
1368 
1369 
1370   function mint(address _to, uint256 _amount) onlyController public returns (bool) {
1371     _mint(_to, _amount);
1372     return true;
1373   }
1374 
1375 
1376   function mintFromOwner(address _to, uint256 _amount) onlyOwner public returns (bool) {
1377     _mint(_to, _amount);
1378     return true;
1379   }
1380 
1381 
1382   function approveAndCall(address _spender, uint _amount, bytes _data) public {
1383     if(approve(_spender, _amount)) {
1384       TokenReceiver(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
1385     }
1386   }
1387 
1388 
1389   function checkCap(uint256 _amount) public view returns (bool) {
1390   	return (cap==0 || totalSupply_.add(_amount) <= cap);
1391   }
1392 
1393 
1394 
1395 
1396 }
1397 
1398 // File: contracts\equipments\PrizePool.sol
1399 
1400 contract PrizePool is Ownable {
1401 
1402   event SendPrized(address equipementAddress, address to);
1403 
1404   address[] public magicBoxes;
1405   mapping(address => bool) public magicBoxList;
1406 
1407   address[] public equipments;
1408   GirlOps public girlOps;
1409 
1410   event SendEquipment(address to, address prizeAddress, uint time);
1411   event EquipmentOutOfStock(address eqAddress);
1412 
1413   modifier onlyMagicBox() {
1414     require(magicBoxList[msg.sender]);
1415     _;
1416   }
1417 
1418   constructor(address _girlOpsAddress) public {
1419     girlOps = GirlOps(_girlOpsAddress);
1420   }
1421 
1422   function sendPrize(address _to, uint _index) public onlyMagicBox returns (bool) {
1423     //新确定方案，如果开箱开到某个道具没有了，直接选下一个
1424     //递归调用，全部箱子如果都遍历完了全都脱销，则失败
1425     //现在这样会开出箱子中没有的东西， 按理来讲应该开出箱子的下一个物品。
1426     address prizeAddress = equipments[_index];
1427     BaseEquipment baseEquipment = BaseEquipment(prizeAddress);
1428     if(baseEquipment.checkCap(1 ether)) {
1429       baseEquipment.mint(_to, 1 ether);
1430       emit SendEquipment(_to, prizeAddress, now);
1431       return true;
1432     } else {
1433       emit EquipmentOutOfStock(prizeAddress);
1434       return false;
1435     }
1436   }
1437 
1438   function mintGirl(address to, uint gene) public onlyMagicBox returns (bool) {
1439     girlOps.createGirl(gene, to, 1);
1440     return true;
1441   }
1442 
1443   function setEquipments(address[] _equipments) public onlyOwner {
1444     equipments = _equipments;
1445   }
1446 
1447 
1448   function addMagicBox(address addr) public onlyOwner returns (bool) {
1449     if (!magicBoxList[addr]) {
1450       magicBoxList[addr] = true;
1451       magicBoxes.push(addr);
1452       return true;
1453     } else {
1454       return false;
1455     }
1456   }
1457 
1458   function addMagicBoxes(address[] addrs) public onlyOwner returns (bool) {
1459     for (uint i=0; i<addrs.length; i++) {
1460       require(addMagicBox(addrs[i]));
1461     }
1462     return true;
1463   }
1464 
1465   function removeMagicBox(address addr) public onlyOwner returns (bool) {
1466     require(magicBoxList[addr]);
1467     for (uint i=0; i<magicBoxes.length - 1; i++) {
1468       if (magicBoxes[i] == addr) {
1469         magicBoxes[i] = magicBoxes[magicBoxes.length -1];
1470         break;
1471       }
1472     }
1473     magicBoxes.length -= 1;
1474     magicBoxList[addr] = false;
1475     return true;
1476   }
1477 
1478 }
1479 
1480 // File: contracts\equipments\MagicBox.sol
1481 
1482 contract MagicBox is AccessControl, TokenReceiver {
1483 
1484   uint public keyRequired;
1485   address public keyAddress;
1486   address public prizePoolAddress;
1487   string public name;                //The shoes name: e.g. MB
1488   uint[] public prizeIndex;
1489   uint[] public prizeRange;
1490 
1491   uint public boxPrice;              //price to openbox in wei;
1492   mapping (uint => address) public openNonce;
1493   uint public openNonceId;
1494 
1495   mapping (address => bool) public serverAddressList;
1496 
1497   modifier onlyServer {
1498     require(serverAddressList[msg.sender]);
1499     _;
1500   }
1501 
1502   event AddServerAddress(address contractAddress);
1503   event RemoveServerAddress(address contractAddress);
1504 
1505 
1506   function addServerAddresss(address[] _serverAddress) onlyOwner public {
1507     for(uint i=0; i<_serverAddress.length; i++) {
1508       require(addServerAddress(_serverAddress[i]));
1509     }
1510   }
1511 
1512   function addServerAddress(address _serverAddress) onlyOwner public returns (bool){
1513     serverAddressList[_serverAddress] = true;
1514     emit AddServerAddress(_serverAddress);
1515     return true;
1516   }
1517 
1518   function removeServerAddress(address _serverAddress) onlyOwner public {
1519     require(serverAddressList[_serverAddress]);
1520     serverAddressList[_serverAddress] = false;
1521     emit RemoveServerAddress(_serverAddress);
1522   }
1523 
1524 
1525   event OpenBoxV2(address addr, uint time, uint openNonceId); // server need to monitor this event to trigger openBoxFromServer
1526 
1527 
1528   constructor(string _name, address _prizePoolAddress,  address[] _serverAddress,address _keyAddress, uint _keyRequired, uint _boxPrice) public {
1529     name = _name;
1530     prizePoolAddress = _prizePoolAddress;
1531     keyAddress = _keyAddress;
1532     keyRequired = _keyRequired;
1533     boxPrice = _boxPrice;
1534     openNonceId = 0;
1535     addServerAddresss(_serverAddress);
1536   }
1537 
1538 
1539   function setupPrize(uint[] _prizeIndex, uint[] _prizeRange) public onlyOwner {
1540     prizeIndex = _prizeIndex;
1541     prizeRange = _prizeRange;
1542   }
1543 
1544   function getPrizeIndex(uint random) public view returns (uint) {
1545     uint maxRange = prizeRange[prizeRange.length -1];
1546     uint n = random % maxRange;
1547 
1548     uint start = 0;
1549     uint mid = 0;
1550     uint end = prizeRange.length-1;
1551 
1552     if (prizeRange[0]>n){
1553       return 0;
1554     }
1555     if (prizeRange[end-1]<=n){
1556       return end;
1557     }
1558 
1559     while (start <= end) {
1560       mid = start + (end - start) / 2;
1561       if (prizeRange[mid]<=n && n<prizeRange[mid+1]){
1562           return mid+1;
1563       } else if (prizeRange[mid+1] <= n) {
1564         start = mid+1;
1565       } else {
1566         end = mid;
1567       }
1568     }
1569 
1570     return start;
1571   }
1572 
1573   function _openBox(address _from, uint _random, uint[] _genes) internal returns (bool) {
1574     // uint random_number = uint(block.blockhash(block.number-1)) ^ _random;
1575     // uint index = getPrizeIndex(random_number);
1576 
1577     uint index = getPrizeIndex(_random);
1578     //uint index = 11;
1579     PrizePool pl = PrizePool(prizePoolAddress);
1580     uint count = 0;
1581     while(count < prizeIndex.length) {
1582       if(prizeIndex[index] < 10) { // get a girl // reserve first 10 item to girl gene or further special equipment.
1583         pl.mintGirl(_from, _genes[prizeIndex[index]-1]);
1584         return true;
1585       } else if (pl.sendPrize(_from, prizeIndex[index] - 10)) { // send equipment prize successfully
1586         return true;
1587       } else {
1588         count = count + 1;
1589         index = index + 1;
1590         if(index == prizeIndex.length) index = 0;
1591         continue;
1592       }
1593     }
1594 
1595     // does not get anything.
1596     return false;
1597 
1598   }
1599 
1600 
1601   function setKeyAddress(address _key) public onlyOwner {
1602     keyAddress = _key;
1603   }
1604 
1605 
1606   function openBoxFromServer(address _userAddress, uint _random, uint[] _gene, uint _openNonceId) public onlyServer returns (bool) {
1607 
1608     require (openNonce[_openNonceId]==_userAddress,'Nonce Has been used');
1609     delete openNonce[_openNonceId];
1610     // only server can call this method.
1611     _openBox(_userAddress, _random, _gene);
1612   }
1613 
1614   function openBoxFromServerNoNonce(address _userAddress, uint _random, uint[] _gene) public onlyServer returns (bool) {
1615 
1616     // only server can call this method.
1617     _openBox(_userAddress, _random, _gene);
1618   }
1619 
1620   function addOpenBoxFromServer(address _userAddress) public onlyServer {
1621     openNonceId = openNonceId + 1;
1622     openNonce[openNonceId] = _userAddress;
1623      // server need to monitor this event and trigger openBoxFromServer.
1624     emit OpenBoxV2(_userAddress, now, openNonceId);
1625   }
1626 
1627   //新需求从myether wallet 直接开箱， 需要payble 没有function name, 把逻辑从magickey 移过来
1628   function() public payable {
1629      require(msg.value == boxPrice);  // must pay boxprice
1630      openNonceId = openNonceId + 1;
1631      openNonce[openNonceId] = msg.sender;
1632      // server need to monitor this event and trigger openBoxFromServer.
1633      emit OpenBoxV2(msg.sender, now, openNonceId);
1634   }
1635 
1636 
1637   function receiveApproval(address _from, uint _amount, address _tokenAddress, bytes _data) public {
1638    require(_tokenAddress == keyAddress); // only accept key.
1639    require(_amount == keyRequired); // need to send required amount;
1640    require(StandardToken(_tokenAddress).transferFrom(_from, address(this), _amount));
1641 
1642    openNonceId = openNonceId + 1;
1643    
1644    openNonce[openNonceId] = _from;
1645      // server need to monitor this event and trigger openBoxFromServer.
1646 
1647    // server need to monitor this event and trigger openBoxFromServer.
1648    emit OpenBoxV2(_from, now, openNonceId);
1649 
1650   }
1651 
1652   function withDrawToken(uint _amount) public onlyCFO {
1653     StandardToken(keyAddress).transfer(CFO, _amount);
1654   }
1655 
1656 
1657   function withDrawBalance(uint256 amount) public onlyCFO {
1658     require(address(this).balance >= amount);
1659     if (amount==0){
1660       CFO.transfer(address(this).balance);
1661     } else {
1662       CFO.transfer(amount);
1663     }
1664   }
1665 
1666   function setupBoxPrice(uint256 _boxPrice) public onlyCFO {
1667     boxPrice = _boxPrice;
1668   }
1669 
1670   function setupKeyRequired(uint256 _keyRequired) public onlyCFO {
1671     keyRequired = _keyRequired;
1672   }
1673 
1674 }