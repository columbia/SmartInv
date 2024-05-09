1 pragma solidity ^0.4.21;
2 
3 // File: contracts\ERC721\ERC721Receiver.sol
4 
5 /**
6  * @title ERC721 token receiver interface
7  * @dev Interface for any contract that wants to support safeTransfers
8  *  from ERC721 asset contracts.
9  */
10 contract ERC721Receiver {
11   /**
12    * @dev Magic value to be returned upon successful reception of an NFT
13    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
14    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
15    */
16   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
17 
18   /**
19    * @notice Handle the receipt of an NFT
20    * @dev The ERC721 smart contract calls this function on the recipient
21    *  after a `safetransfer`. This function MAY throw to revert and reject the
22    *  transfer. This function MUST use 50,000 gas or less. Return of other
23    *  than the magic value MUST result in the transaction being reverted.
24    *  Note: the contract address is always the message sender.
25    * @param _from The sending address
26    * @param _tokenId The NFT identifier which is being transfered
27    * @param _data Additional data with no specified format
28    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
29    */
30   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
31 }
32 
33 // File: contracts\utils\SafeMath.sol
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, throws on overflow.
43   */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     if (a == 0) {
46       return 0;
47     }
48     c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return a / b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 // File: contracts\utils\Serialize.sol
82 
83 contract Serialize {
84     using SafeMath for uint256;
85     function addAddress(uint _offst, bytes memory _output, address _input) internal pure returns(uint _offset) {
86       assembly {
87         mstore(add(_output, _offst), _input)
88       }
89       return _offst.sub(20);
90     }
91 
92     function addUint(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
93       assembly {
94         mstore(add(_output, _offst), _input)
95       }
96       return _offst.sub(32);
97     }
98 
99     function addUint8(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
100       assembly {
101         mstore(add(_output, _offst), _input)
102       }
103       return _offst.sub(1);
104     }
105 
106     function addUint16(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
107       assembly {
108         mstore(add(_output, _offst), _input)
109       }
110       return _offst.sub(2);
111     }
112 
113     function addUint64(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
114       assembly {
115         mstore(add(_output, _offst), _input)
116       }
117       return _offst.sub(8);
118     }
119 
120     function getAddress(uint _offst, bytes memory _input) internal pure returns (address _output, uint _offset) {
121       assembly {
122         _output := mload(add(_input, _offst))
123       }
124       return (_output, _offst.sub(20));
125     }
126 
127     function getUint(uint _offst, bytes memory _input) internal pure returns (uint _output, uint _offset) {
128       assembly {
129           _output := mload(add(_input, _offst))
130       }
131       return (_output, _offst.sub(32));
132     }
133 
134     function getUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output, uint _offset) {
135       assembly {
136         _output := mload(add(_input, _offst))
137       }
138       return (_output, _offst.sub(1));
139     }
140 
141     function getUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output, uint _offset) {
142       assembly {
143         _output := mload(add(_input, _offst))
144       }
145       return (_output, _offst.sub(2));
146     }
147 
148     function getUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output, uint _offset) {
149       assembly {
150         _output := mload(add(_input, _offst))
151       }
152       return (_output, _offst.sub(8));
153     }
154 }
155 
156 // File: contracts\utils\AddressUtils.sol
157 
158 /**
159  * Utility library of inline functions on addresses
160  */
161 library AddressUtils {
162 
163   /**
164    * Returns whether the target address is a contract
165    * @dev This function will return false if invoked during the constructor of a contract,
166    *  as the code is not actually created until after the constructor finishes.
167    * @param addr address to check
168    * @return whether the target address is a contract
169    */
170   function isContract(address addr) internal view returns (bool) {
171     uint256 size;
172     // XXX Currently there is no better way to check if there is a contract in an address
173     // than to check the size of the code at that address.
174     // See https://ethereum.stackexchange.com/a/14016/36603
175     // for more details about how this works.
176     // TODO Check this again before the Serenity release, because all addresses will be
177     // contracts then.
178     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
179     return size > 0;
180   }
181 
182 }
183 
184 // File: contracts\utils\Ownable.sol
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194 
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198   /**
199    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200    * account.
201    */
202   function Ownable() public {
203     owner = msg.sender;
204   }
205 
206   /**
207    * @dev Throws if called by any account other than the owner.
208    */
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214   /**
215    * @dev Allows the current owner to transfer control of the contract to a newOwner.
216    * @param newOwner The address to transfer ownership to.
217    */
218   function transferOwnership(address newOwner) public onlyOwner {
219     require(newOwner != address(0));
220     emit OwnershipTransferred(owner, newOwner);
221     owner = newOwner;
222   }
223 
224 }
225 
226 // File: contracts\utils\Pausable.sol
227 
228 /**
229  * @title Pausable
230  * @dev Base contract which allows children to implement an emergency stop mechanism.
231  */
232 contract Pausable is Ownable {
233   event Pause();
234   event Unpause();
235 
236   bool public paused = false;
237 
238 
239   /**
240    * @dev Modifier to make a function callable only when the contract is not paused.
241    */
242   modifier whenNotPaused() {
243     require(!paused);
244     _;
245   }
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is paused.
249    */
250   modifier whenPaused() {
251     require(paused);
252     _;
253   }
254 
255   /**
256    * @dev called by the owner to pause, triggers stopped state
257    */
258   function pause() onlyOwner whenNotPaused public {
259     paused = true;
260     emit Pause();
261   }
262 
263   /**
264    * @dev called by the owner to unpause, returns to normal state
265    */
266   function unpause() onlyOwner whenPaused public {
267     paused = false;
268     emit Unpause();
269   }
270 }
271 
272 // File: contracts\ERC721\ERC721Basic.sol
273 
274 /**
275  * @title ERC721 Non-Fungible Token Standard basic interface
276  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
277  */
278 contract ERC721Basic {
279   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
280   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
281   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
282 
283   function balanceOf(address _owner) public view returns (uint256 _balance);
284   function ownerOf(uint256 _tokenId) public view returns (address _owner);
285   function exists(uint256 _tokenId) public view returns (bool _exists);
286 
287   function approve(address _to, uint256 _tokenId) public;
288   function getApproved(uint256 _tokenId) public view returns (address _operator);
289 
290   function setApprovalForAll(address _operator, bool _approved) public;
291   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
292 
293   function transferFrom(address _from, address _to, uint256 _tokenId) public;
294   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
295   function safeTransferFrom(
296     address _from,
297     address _to,
298     uint256 _tokenId,
299     bytes _data
300   )
301     public;
302 }
303 
304 // File: contracts\ERC721\ERC721BasicToken.sol
305 
306 /**
307  * @title ERC721 Non-Fungible Token Standard basic implementation
308  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
309  */
310 contract ERC721BasicToken is ERC721Basic, Pausable {
311   using SafeMath for uint256;
312   using AddressUtils for address;
313 
314   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
315   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
316   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
317 
318   // Mapping from token ID to owner
319   mapping (uint256 => address) internal tokenOwner;
320 
321   // Mapping from token ID to approved address
322   mapping (uint256 => address) internal tokenApprovals;
323 
324   // Mapping from owner to number of owned token
325   mapping (address => uint256) internal ownedTokensCount;
326 
327   // Mapping from owner to operator approvals
328   mapping (address => mapping (address => bool)) internal operatorApprovals;
329 
330   /**
331    * @dev Guarantees msg.sender is owner of the given token
332    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
333    */
334   modifier onlyOwnerOf(uint256 _tokenId) {
335     require(ownerOf(_tokenId) == msg.sender);
336     _;
337   }
338 
339   /**
340    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
341    * @param _tokenId uint256 ID of the token to validate
342    */
343   modifier canTransfer(uint256 _tokenId) {
344     require(isApprovedOrOwner(msg.sender, _tokenId));
345     _;
346   }
347 
348   /**
349    * @dev Gets the balance of the specified address
350    * @param _owner address to query the balance of
351    * @return uint256 representing the amount owned by the passed address
352    */
353   function balanceOf(address _owner) public view returns (uint256) {
354     require(_owner != address(0));
355     return ownedTokensCount[_owner];
356   }
357 
358   /**
359    * @dev Gets the owner of the specified token ID
360    * @param _tokenId uint256 ID of the token to query the owner of
361    * @return owner address currently marked as the owner of the given token ID
362    */
363   function ownerOf(uint256 _tokenId) public view returns (address) {
364     address owner = tokenOwner[_tokenId];
365     require(owner != address(0));
366     return owner;
367   }
368 
369   /**
370    * @dev Returns whether the specified token exists
371    * @param _tokenId uint256 ID of the token to query the existance of
372    * @return whether the token exists
373    */
374   function exists(uint256 _tokenId) public view returns (bool) {
375     address owner = tokenOwner[_tokenId];
376     return owner != address(0);
377   }
378 
379   /**
380    * @dev Approves another address to transfer the given token ID
381    * @dev The zero address indicates there is no approved address.
382    * @dev There can only be one approved address per token at a given time.
383    * @dev Can only be called by the token owner or an approved operator.
384    * @param _to address to be approved for the given token ID
385    * @param _tokenId uint256 ID of the token to be approved
386    */
387   function approve(address _to, uint256 _tokenId) public {
388     address owner = ownerOf(_tokenId);
389     require(_to != owner);
390     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
391 
392     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
393       tokenApprovals[_tokenId] = _to;
394       emit Approval(owner, _to, _tokenId);
395     }
396   }
397 
398   /**
399    * @dev Gets the approved address for a token ID, or zero if no address set
400    * @param _tokenId uint256 ID of the token to query the approval of
401    * @return address currently approved for a the given token ID
402    */
403   function getApproved(uint256 _tokenId) public view returns (address) {
404     return tokenApprovals[_tokenId];
405   }
406 
407   /**
408    * @dev Sets or unsets the approval of a given operator
409    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
410    * @param _to operator address to set the approval
411    * @param _approved representing the status of the approval to be set
412    */
413   function setApprovalForAll(address _to, bool _approved) public {
414     require(_to != msg.sender);
415     operatorApprovals[msg.sender][_to] = _approved;
416     emit ApprovalForAll(msg.sender, _to, _approved);
417   }
418 
419   /**
420    * @dev Tells whether an operator is approved by a given owner
421    * @param _owner owner address which you want to query the approval of
422    * @param _operator operator address which you want to query the approval of
423    * @return bool whether the given operator is approved by the given owner
424    */
425   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
426     return operatorApprovals[_owner][_operator];
427   }
428 
429   /**
430    * @dev Transfers the ownership of a given token ID to another address
431    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
432    * @dev Requires the msg sender to be the owner, approved, or operator
433    * @param _from current owner of the token
434    * @param _to address to receive the ownership of the given token ID
435    * @param _tokenId uint256 ID of the token to be transferred
436   */
437   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
438     require(_from != address(0));
439     require(_to != address(0));
440 
441     clearApproval(_from, _tokenId);
442     removeTokenFrom(_from, _tokenId);
443     addTokenTo(_to, _tokenId);
444 
445     emit Transfer(_from, _to, _tokenId);
446   }
447 
448   function transferBatch(address _from, address _to, uint[] _tokenIds) public {
449     require(_from != address(0));
450     require(_to != address(0));
451 
452     for(uint i=0; i<_tokenIds.length; i++) {
453       require(isApprovedOrOwner(msg.sender, _tokenIds[i]));
454       clearApproval(_from,  _tokenIds[i]);
455       removeTokenFrom(_from, _tokenIds[i]);
456       addTokenTo(_to, _tokenIds[i]);
457 
458       emit Transfer(_from, _to, _tokenIds[i]);
459     }
460   }
461 
462   /**
463    * @dev Safely transfers the ownership of a given token ID to another address
464    * @dev If the target address is a contract, it must implement `onERC721Received`,
465    *  which is called upon a safe transfer, and return the magic value
466    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
467    *  the transfer is reverted.
468    * @dev Requires the msg sender to be the owner, approved, or operator
469    * @param _from current owner of the token
470    * @param _to address to receive the ownership of the given token ID
471    * @param _tokenId uint256 ID of the token to be transferred
472   */
473   function safeTransferFrom(
474     address _from,
475     address _to,
476     uint256 _tokenId
477   )
478     public
479     canTransfer(_tokenId)
480   {
481     // solium-disable-next-line arg-overflow
482     safeTransferFrom(_from, _to, _tokenId, "");
483   }
484 
485   /**
486    * @dev Safely transfers the ownership of a given token ID to another address
487    * @dev If the target address is a contract, it must implement `onERC721Received`,
488    *  which is called upon a safe transfer, and return the magic value
489    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
490    *  the transfer is reverted.
491    * @dev Requires the msg sender to be the owner, approved, or operator
492    * @param _from current owner of the token
493    * @param _to address to receive the ownership of the given token ID
494    * @param _tokenId uint256 ID of the token to be transferred
495    * @param _data bytes data to send along with a safe transfer check
496    */
497   function safeTransferFrom(
498     address _from,
499     address _to,
500     uint256 _tokenId,
501     bytes _data
502   )
503     public
504     canTransfer(_tokenId)
505   {
506     transferFrom(_from, _to, _tokenId);
507     // solium-disable-next-line arg-overflow
508     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
509   }
510 
511   /**
512    * @dev Returns whether the given spender can transfer a given token ID
513    * @param _spender address of the spender to query
514    * @param _tokenId uint256 ID of the token to be transferred
515    * @return bool whether the msg.sender is approved for the given token ID,
516    *  is an operator of the owner, or is the owner of the token
517    */
518   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
519     address owner = ownerOf(_tokenId);
520     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
521   }
522 
523   /**
524    * @dev Internal function to mint a new token
525    * @dev Reverts if the given token ID already exists
526    * @param _to The address that will own the minted token
527    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
528    */
529   function _mint(address _to, uint256 _tokenId) internal {
530     require(_to != address(0));
531     addTokenTo(_to, _tokenId);
532     emit Transfer(address(0), _to, _tokenId);
533   }
534 
535   /**
536    * @dev Internal function to burn a specific token
537    * @dev Reverts if the token does not exist
538    * @param _tokenId uint256 ID of the token being burned by the msg.sender
539    */
540   function _burn(address _owner, uint256 _tokenId) internal {
541     clearApproval(_owner, _tokenId);
542     removeTokenFrom(_owner, _tokenId);
543     emit Transfer(_owner, address(0), _tokenId);
544   }
545 
546   /**
547    * @dev Internal function to clear current approval of a given token ID
548    * @dev Reverts if the given address is not indeed the owner of the token
549    * @param _owner owner of the token
550    * @param _tokenId uint256 ID of the token to be transferred
551    */
552   function clearApproval(address _owner, uint256 _tokenId) internal {
553     require(ownerOf(_tokenId) == _owner);
554     if (tokenApprovals[_tokenId] != address(0)) {
555       tokenApprovals[_tokenId] = address(0);
556       emit Approval(_owner, address(0), _tokenId);
557     }
558   }
559 
560   /**
561    * @dev Internal function to add a token ID to the list of a given address
562    * @param _to address representing the new owner of the given token ID
563    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
564    */
565   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
566     require(tokenOwner[_tokenId] == address(0));
567     tokenOwner[_tokenId] = _to;
568     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
569   }
570 
571   /**
572    * @dev Internal function to remove a token ID from the list of a given address
573    * @param _from address representing the previous owner of the given token ID
574    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
575    */
576   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused{
577     require(ownerOf(_tokenId) == _from);
578     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
579     tokenOwner[_tokenId] = address(0);
580   }
581 
582   /**
583    * @dev Internal function to invoke `onERC721Received` on a target address
584    * @dev The call is not executed if the target address is not a contract
585    * @param _from address representing the previous owner of the given token ID
586    * @param _to target address that will receive the tokens
587    * @param _tokenId uint256 ID of the token to be transferred
588    * @param _data bytes optional data to send along with the call
589    * @return whether the call correctly returned the expected magic value
590    */
591   function checkAndCallSafeTransfer(
592     address _from,
593     address _to,
594     uint256 _tokenId,
595     bytes _data
596   )
597     internal
598     returns (bool)
599   {
600     if (!_to.isContract()) {
601       return true;
602     }
603     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
604     return (retval == ERC721_RECEIVED);
605   }
606 }
607 
608 // File: contracts\ERC721\GirlBasicToken.sol
609 
610 // add atomic swap feature in the token contract.
611 contract GirlBasicToken is ERC721BasicToken, Serialize {
612 
613   event CreateGirl(address owner, uint256 tokenID, uint256 genes, uint64 birthTime, uint64 cooldownEndTime, uint16 starLevel);
614   event CoolDown(uint256 tokenId, uint64 cooldownEndTime);
615   event GirlUpgrade(uint256 tokenId, uint64 starLevel);
616 
617   struct Girl{
618     /**
619     少女基因,生成以后不会改变
620     **/
621     uint genes;
622 
623     /*
624     出生时间 少女创建时候的时间戳
625     */
626     uint64 birthTime;
627 
628     /*
629     冷却结束时间
630     */
631     uint64 cooldownEndTime;
632     /*
633     star level
634     */
635     uint16 starLevel;
636   }
637 
638   Girl[] girls;
639 
640 
641   function totalSupply() public view returns (uint256) {
642     return girls.length;
643   }
644 
645   function getGirlGene(uint _index) public view returns (uint) {
646     return girls[_index].genes;
647   }
648 
649   function getGirlBirthTime(uint _index) public view returns (uint64) {
650     return girls[_index].birthTime;
651   }
652 
653   function getGirlCoolDownEndTime(uint _index) public view returns (uint64) {
654     return girls[_index].cooldownEndTime;
655   }
656 
657   function getGirlStarLevel(uint _index) public view returns (uint16) {
658     return girls[_index].starLevel;
659   }
660 
661   function isNotCoolDown(uint _girlId) public view returns(bool) {
662     return uint64(now) > girls[_girlId].cooldownEndTime;
663   }
664 
665   function _createGirl(
666       uint _genes,
667       address _owner,
668       uint16 _starLevel
669   ) internal returns (uint){
670       Girl memory _girl = Girl({
671           genes:_genes,
672           birthTime:uint64(now),
673           cooldownEndTime:0,
674           starLevel:_starLevel
675       });
676       uint256 girlId = girls.push(_girl) - 1;
677       _mint(_owner, girlId);
678       emit CreateGirl(_owner, girlId, _genes, _girl.birthTime, _girl.cooldownEndTime, _girl.starLevel);
679       return girlId;
680   }
681 
682   function _setCoolDownTime(uint _tokenId, uint _coolDownTime) internal {
683     girls[_tokenId].cooldownEndTime = uint64(now.add(_coolDownTime));
684     emit CoolDown(_tokenId, girls[_tokenId].cooldownEndTime);
685   }
686 
687   function _LevelUp(uint _tokenId) internal {
688     require(girls[_tokenId].starLevel < 65535);
689     girls[_tokenId].starLevel = girls[_tokenId].starLevel + 1;
690     emit GirlUpgrade(_tokenId, girls[_tokenId].starLevel);
691   }
692 
693   // ---------------
694   // this is atomic swap for girl to be set cross chain.
695   // ---------------
696   uint8 constant public GIRLBUFFERSIZE = 50;  // buffer size need to serialize girl data; used for cross chain sync
697 
698   struct HashLockContract {
699     address sender;
700     address receiver;
701     uint tokenId;
702     bytes32 hashlock;
703     uint timelock;
704     bytes32 secret;
705     States state;
706     bytes extraData;
707   }
708 
709   enum States {
710     INVALID,
711     OPEN,
712     CLOSED,
713     REFUNDED
714   }
715 
716   mapping (bytes32 => HashLockContract) private contracts;
717 
718   modifier contractExists(bytes32 _contractId) {
719     require(_contractExists(_contractId));
720     _;
721   }
722 
723   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
724     require(contracts[_contractId].hashlock == keccak256(_secret));
725     _;
726   }
727 
728   modifier closable(bytes32 _contractId) {
729     require(contracts[_contractId].state == States.OPEN);
730     require(contracts[_contractId].timelock > now);
731     _;
732   }
733 
734   modifier refundable(bytes32 _contractId) {
735     require(contracts[_contractId].state == States.OPEN);
736     require(contracts[_contractId].timelock <= now);
737     _;
738   }
739 
740   event NewHashLockContract (
741     bytes32 indexed contractId,
742     address indexed sender,
743     address indexed receiver,
744     uint tokenId,
745     bytes32 hashlock,
746     uint timelock,
747     bytes extraData
748   );
749 
750   event SwapClosed(bytes32 indexed contractId);
751   event SwapRefunded(bytes32 indexed contractId);
752 
753   function open (
754     address _receiver,
755     bytes32 _hashlock,
756     uint _duration,
757     uint _tokenId
758   ) public
759     onlyOwnerOf(_tokenId)
760     returns (bytes32 contractId)
761   {
762     uint _timelock = now.add(_duration);
763 
764     // compute girl data;
765     bytes memory _extraData = new bytes(GIRLBUFFERSIZE);
766     uint offset = GIRLBUFFERSIZE;
767 
768     offset = addUint16(offset, _extraData, girls[_tokenId].starLevel);
769     offset = addUint64(offset, _extraData, girls[_tokenId].cooldownEndTime);
770     offset = addUint64(offset, _extraData, girls[_tokenId].birthTime);
771     offset = addUint(offset, _extraData, girls[_tokenId].genes);
772 
773     contractId = keccak256 (
774       msg.sender,
775       _receiver,
776       _tokenId,
777       _hashlock,
778       _timelock,
779       _extraData
780     );
781 
782     // the new contract must not exist
783     require(!_contractExists(contractId));
784 
785     // temporary change the ownership to this contract address.
786     // the ownership will be change to user when close is called.
787     clearApproval(msg.sender, _tokenId);
788     removeTokenFrom(msg.sender, _tokenId);
789     addTokenTo(address(this), _tokenId);
790 
791 
792     contracts[contractId] = HashLockContract(
793       msg.sender,
794       _receiver,
795       _tokenId,
796       _hashlock,
797       _timelock,
798       0x0,
799       States.OPEN,
800       _extraData
801     );
802 
803     emit NewHashLockContract(contractId, msg.sender, _receiver, _tokenId, _hashlock, _timelock, _extraData);
804   }
805 
806   function close(bytes32 _contractId, bytes32 _secret)
807     public
808     contractExists(_contractId)
809     hashlockMatches(_contractId, _secret)
810     closable(_contractId)
811     returns (bool)
812   {
813     HashLockContract storage c = contracts[_contractId];
814     c.secret = _secret;
815     c.state = States.CLOSED;
816 
817     // transfer token ownership from this contract address to receiver.
818     // clearApproval(address(this), c.tokenId);
819     removeTokenFrom(address(this), c.tokenId);
820     addTokenTo(c.receiver, c.tokenId);
821 
822     emit SwapClosed(_contractId);
823     return true;
824   }
825 
826   function refund(bytes32 _contractId)
827     public
828     contractExists(_contractId)
829     refundable(_contractId)
830     returns (bool)
831   {
832     HashLockContract storage c = contracts[_contractId];
833     c.state = States.REFUNDED;
834 
835     // transfer token ownership from this contract address to receiver.
836     // clearApproval(address(this), c.tokenId);
837     removeTokenFrom(address(this), c.tokenId);
838     addTokenTo(c.sender, c.tokenId);
839 
840 
841     emit SwapRefunded(_contractId);
842     return true;
843   }
844 
845   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
846     exists = (contracts[_contractId].sender != address(0));
847   }
848 
849   function checkContract(bytes32 _contractId)
850     public
851     view
852     contractExists(_contractId)
853     returns (
854       address sender,
855       address receiver,
856       uint amount,
857       bytes32 hashlock,
858       uint timelock,
859       bytes32 secret,
860       bytes extraData
861     )
862   {
863     HashLockContract memory c = contracts[_contractId];
864     return (
865       c.sender,
866       c.receiver,
867       c.tokenId,
868       c.hashlock,
869       c.timelock,
870       c.secret,
871       c.extraData
872     );
873   }
874 
875 
876 }
877 
878 // File: contracts\utils\AccessControl.sol
879 
880 contract AccessControl is Ownable{
881     address CFO;
882     //Owner address can set to COO address. it have same effect.
883 
884     modifier onlyCFO{
885         require(msg.sender == CFO);
886         _;
887     }
888 
889     function setCFO(address _newCFO)public onlyOwner {
890         CFO = _newCFO;
891     }
892 
893     //use pausable in the contract that need to pause. save gas and clear confusion.
894 
895 }
896 
897 // File: contracts\Auction\ClockAuctionBase.sol
898 
899 /// @title Auction Core
900 /// @dev Contains models, variables, and internal methods for the auction.
901 contract ClockAuctionBase {
902 
903     // Represents an auction on an NFT
904     struct Auction {
905         // Current owner of NFT
906         address seller;
907         // Price (in wei) at beginning of auction
908         uint128 startingPrice;
909         // Price (in wei) at end of auction
910         uint128 endingPrice;
911         // Duration (in seconds) of auction
912         uint64 duration;
913         // Time when auction started
914         // NOTE: 0 if this auction has been concluded
915         uint64 startedAt;
916     }
917 
918     // Reference to contract tracking NFT ownership
919     GirlBasicToken public girlBasicToken;
920 
921     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
922     // Values 0-10,000 map to 0%-100%
923     uint256 public ownerCut;
924 
925     // Map from token ID to their corresponding auction.
926     mapping (uint256 => Auction) tokenIdToAuction;
927 
928     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
929     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
930     event AuctionCancelled(uint256 tokenId);
931 
932     /// @dev DON'T give me your money.
933     function() external {}
934 
935 
936     /// @dev Returns true if the claimant owns the token.
937     /// @param _claimant - Address claiming to own the token.
938     /// @param _tokenId - ID of token whose ownership to verify.
939     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
940         return (girlBasicToken.ownerOf(_tokenId) == _claimant);
941     }
942 
943     /// @dev Escrows the NFT, assigning ownership to this contract.
944     /// Throws if the escrow fails.
945     /// @param _owner - Current owner address of token to escrow.
946     /// @param _tokenId - ID of token whose approval to verify.
947     // function _escrow(address _owner, uint256 _tokenId) internal {
948     //     // it will throw if transfer fails
949     //     nonFungibleContract.transfer(_owner, _tokenId);
950     // }
951 
952     /// @dev Transfers an NFT owned by this contract to another address.
953     /// Returns true if the transfer succeeds.
954     /// @param _receiver - Address to transfer NFT to.
955     /// @param _tokenId - ID of token to transfer.
956     function _transfer(address _receiver, uint256 _tokenId) internal {
957         // it will throw if transfer fails
958         girlBasicToken.safeTransferFrom(address(this), _receiver, _tokenId);
959     }
960 
961     /// @dev Adds an auction to the list of open auctions. Also fires the
962     ///  AuctionCreated event.
963     /// @param _tokenId The ID of the token to be put on auction.
964     /// @param _auction Auction to add.
965     function _addAuction(uint256 _tokenId, Auction _auction) internal {
966         // Require that all auctions have a duration of
967         // at least one minute. (Keeps our math from getting hairy!)
968         require(_auction.duration >= 1 minutes);
969 
970         tokenIdToAuction[_tokenId] = _auction;
971 
972         emit AuctionCreated(
973             uint256(_tokenId),
974             uint256(_auction.startingPrice),
975             uint256(_auction.endingPrice),
976             uint256(_auction.duration)
977         );
978     }
979 
980     /// @dev Cancels an auction unconditionally.
981     function _cancelAuction(uint256 _tokenId, address _seller) internal {
982         _removeAuction(_tokenId);
983         _transfer(_seller, _tokenId);
984         emit AuctionCancelled(_tokenId);
985     }
986 
987     /// @dev Computes the price and transfers winnings.
988     /// Does NOT transfer ownership of token.
989     function _bid(uint256 _tokenId, uint256 _bidAmount)
990         internal
991         returns (uint256)
992     {
993         // Get a reference to the auction struct
994         Auction storage auction = tokenIdToAuction[_tokenId];
995 
996         // Explicitly check that this auction is currently live.
997         // (Because of how Ethereum mappings work, we can't just count
998         // on the lookup above failing. An invalid _tokenId will just
999         // return an auction object that is all zeros.)
1000         require(_isOnAuction(auction));
1001 
1002         // Check that the incoming bid is higher than the current
1003         // price
1004         uint256 price = _currentPrice(auction);
1005         require(_bidAmount >= price);
1006 
1007         // Grab a reference to the seller before the auction struct
1008         // gets deleted.
1009         address seller = auction.seller;
1010 
1011         // The bid is good! Remove the auction before sending the fees
1012         // to the sender so we can't have a reentrancy attack.
1013         _removeAuction(_tokenId);
1014 
1015         // Transfer proceeds to seller (if there are any!)
1016         if (price > 0) {
1017             //  Calculate the auctioneer's cut.
1018             // (NOTE: _computeCut() is guaranteed to return a
1019             //  value <= price, so this subtraction can't go negative.)
1020             uint256 auctioneerCut = _computeCut(price);
1021             uint256 sellerProceeds = price - auctioneerCut;
1022 
1023             // NOTE: Doing a transfer() in the middle of a complex
1024             // method like this is generally discouraged because of
1025             // reentrancy attacks and DoS attacks if the seller is
1026             // a contract with an invalid fallback function. We explicitly
1027             // guard against reentrancy attacks by removing the auction
1028             // before calling transfer(), and the only thing the seller
1029             // can DoS is the sale of their own asset! (And if it's an
1030             // accident, they can call cancelAuction(). )
1031             seller.transfer(sellerProceeds);
1032         }
1033 
1034         // Tell the world!
1035         emit AuctionSuccessful(_tokenId, price, msg.sender);
1036 
1037         return price;
1038     }
1039 
1040     /// @dev Removes an auction from the list of open auctions.
1041     /// @param _tokenId - ID of NFT on auction.
1042     function _removeAuction(uint256 _tokenId) internal {
1043         delete tokenIdToAuction[_tokenId];
1044     }
1045 
1046     /// @dev Returns true if the NFT is on auction.
1047     /// @param _auction - Auction to check.
1048     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1049         return (_auction.startedAt > 0);
1050     }
1051 
1052     /// @dev Returns current price of an NFT on auction. Broken into two
1053     ///  functions (this one, that computes the duration from the auction
1054     ///  structure, and the other that does the price computation) so we
1055     ///  can easily test that the price computation works correctly.
1056     function _currentPrice(Auction storage _auction)
1057         internal
1058         view
1059         returns (uint256)
1060     {
1061         uint256 secondsPassed = 0;
1062 
1063         // A bit of insurance against negative values (or wraparound).
1064         // Probably not necessary (since Ethereum guarnatees that the
1065         // now variable doesn't ever go backwards).
1066         if (now > _auction.startedAt) {
1067             secondsPassed = now - _auction.startedAt;
1068         }
1069 
1070         return _computeCurrentPrice(
1071             _auction.startingPrice,
1072             _auction.endingPrice,
1073             _auction.duration,
1074             secondsPassed
1075         );
1076     }
1077 
1078     /// @dev Computes the current price of an auction. Factored out
1079     ///  from _currentPrice so we can run extensive unit tests.
1080     ///  When testing, make this function public and turn on
1081     ///  `Current price computation` test suite.
1082     function _computeCurrentPrice(
1083         uint256 _startingPrice,
1084         uint256 _endingPrice,
1085         uint256 _duration,
1086         uint256 _secondsPassed
1087     )
1088         internal
1089         pure
1090         returns (uint256)
1091     {
1092         // NOTE: We don't use SafeMath (or similar) in this function because
1093         //  all of our public functions carefully cap the maximum values for
1094         //  time (at 64-bits) and currency (at 128-bits). _duration is
1095         //  also known to be non-zero (see the require() statement in
1096         //  _addAuction())
1097         if (_secondsPassed >= _duration) {
1098             // We've reached the end of the dynamic pricing portion
1099             // of the auction, just return the end price.
1100             return _endingPrice;
1101         } else {
1102             // Starting price can be higher than ending price (and often is!), so
1103             // this delta can be negative.
1104             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1105 
1106             // This multiplication can't overflow, _secondsPassed will easily fit within
1107             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
1108             // will always fit within 256-bits.
1109             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1110 
1111             // currentPriceChange can be negative, but if so, will have a magnitude
1112             // less that _startingPrice. Thus, this result will always end up positive.
1113             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1114 
1115             return uint256(currentPrice);
1116         }
1117     }
1118 
1119     /// @dev Computes owner's cut of a sale.
1120     /// @param _price - Sale price of NFT.
1121     function _computeCut(uint256 _price) internal view returns (uint256) {
1122         // NOTE: We don't use SafeMath (or similar) in this function because
1123         //  all of our entry functions carefully cap the maximum values for
1124         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1125         //  statement in the ClockAuction constructor). The result of this
1126         //  function is always guaranteed to be <= _price.
1127         return _price * ownerCut / 10000;
1128     }
1129 
1130 }
1131 
1132 // File: contracts\Auction\ClockAuction.sol
1133 
1134 /// @title Clock auction for non-fungible tokens.
1135 contract ClockAuction is Pausable, ClockAuctionBase, AccessControl {
1136 
1137     /// @dev Constructor creates a reference to the NFT ownership contract
1138     ///  and verifies the owner cut is in the valid range.
1139     /// @param _nftAddress - address of a deployed contract implementing
1140     ///  the Nonfungible Interface.
1141     /// @param _cut - percent cut the owner takes on each auction, must be
1142     ///  between 0-10,000.
1143     constructor(address _nftAddress, uint256 _cut) public {
1144         require(_cut <= 10000);
1145         ownerCut = _cut;
1146 
1147         GirlBasicToken candidateContract = GirlBasicToken(_nftAddress);
1148         //require(candidateContract.implementsERC721());
1149         girlBasicToken = candidateContract;
1150     }
1151 
1152     function withDrawBalance(uint256 amount) public onlyCFO {
1153       require(address(this).balance >= amount);
1154       CFO.transfer(amount);
1155     }
1156 
1157 
1158     /// @dev Bids on an open auction, completing the auction and transferring
1159     ///  ownership of the NFT if enough Ether is supplied.
1160     /// @param _tokenId - ID of token to bid on.
1161     function bid(uint256 _tokenId)
1162         public
1163         payable
1164         whenNotPaused
1165     {
1166         // _bid will throw if the bid or funds transfer fails
1167         _bid(_tokenId, msg.value);
1168         _transfer(msg.sender, _tokenId);
1169     }
1170 
1171     /// @dev Cancels an auction that hasn't been won yet.
1172     ///  Returns the NFT to original owner.
1173     /// @notice This is a state-modifying function that can
1174     ///  be called while the contract is paused.
1175     /// @param _tokenId - ID of token on auction
1176     function cancelAuction(uint256 _tokenId)
1177         public
1178     {
1179         Auction storage auction = tokenIdToAuction[_tokenId];
1180         require(_isOnAuction(auction));
1181         address seller = auction.seller;
1182         require(msg.sender == seller);
1183         _cancelAuction(_tokenId, seller);
1184     }
1185 
1186     /// @dev Cancels an auction when the contract is paused.
1187     ///  Only the owner may do this, and NFTs are returned to
1188     ///  the seller. This should only be used in emergencies.
1189     /// @param _tokenId - ID of the NFT on auction to cancel.
1190     function cancelAuctionWhenPaused(uint256 _tokenId)
1191         whenPaused
1192         onlyOwner
1193         public
1194     {
1195         Auction storage auction = tokenIdToAuction[_tokenId];
1196         require(_isOnAuction(auction));
1197         _cancelAuction(_tokenId, auction.seller);
1198     }
1199 
1200     /// @dev Returns auction info for an NFT on auction.
1201     /// @param _tokenId - ID of NFT on auction.
1202     function getAuction(uint256 _tokenId)
1203         public
1204         view
1205         returns
1206     (
1207         address seller,
1208         uint256 startingPrice,
1209         uint256 endingPrice,
1210         uint256 duration,
1211         uint256 startedAt
1212     ) {
1213         Auction storage auction = tokenIdToAuction[_tokenId];
1214         require(_isOnAuction(auction));
1215         return (
1216             auction.seller,
1217             auction.startingPrice,
1218             auction.endingPrice,
1219             auction.duration,
1220             auction.startedAt
1221         );
1222     }
1223 
1224     /// @dev Returns the current price of an auction.
1225     /// @param _tokenId - ID of the token price we are checking.
1226     function getCurrentPrice(uint256 _tokenId)
1227         public
1228         view
1229         returns (uint256)
1230     {
1231         Auction storage auction = tokenIdToAuction[_tokenId];
1232         require(_isOnAuction(auction));
1233         return _currentPrice(auction);
1234     }
1235 
1236     function setOwnerCut(uint _cut) public onlyOwner {
1237       ownerCut  = _cut;
1238     }
1239 
1240 }
1241 
1242 // File: contracts\GenesFactory.sol
1243 
1244 contract GenesFactory{
1245     function mixGenes(uint256 gene1, uint gene2) public returns(uint256);
1246     function getPerson(uint256 genes) public pure returns (uint256 person);
1247     function getRace(uint256 genes) public pure returns (uint256);
1248     function getRarity(uint256 genes) public pure returns (uint256);
1249     function getBaseStrengthenPoint(uint256 genesMain,uint256 genesSub) public pure returns (uint256);
1250 
1251     function getCanBorn(uint256 genes) public pure returns (uint256 canBorn,uint256 cooldown);
1252 }
1253 
1254 // File: contracts\GirlOperation\GirlAuction.sol
1255 
1256 contract GirlAuction is Serialize, ERC721Receiver, ClockAuction {
1257 
1258   event GirlAuctionCreated(address sender, uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1259 
1260 
1261   constructor(address _nftAddr, uint256 _cut) public
1262         ClockAuction(_nftAddr, _cut) {}
1263   // example:
1264   // _startingPrice = 5000000000000,
1265   // _endingPrice = 100000000000,
1266   // _duration = 600,
1267   // _data = 0x0000000000000000000000000000000000000000000000000000000000000258000000000000000000000000000000000000000000000000000000e8d4a510000000000000000000000000000000000000000000000000000000048c27395000
1268 
1269   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4) {
1270 
1271     require(msg.sender == address(girlBasicToken));
1272 
1273     uint _startingPrice;
1274     uint _endingPrice;
1275     uint _duration;
1276 
1277     uint offset = 96;
1278     (_startingPrice, offset) = getUint(offset, _data);
1279     (_endingPrice, offset) = getUint(offset, _data);
1280     (_duration, offset) = getUint(offset, _data);
1281 
1282     require(_startingPrice > _endingPrice);
1283     require(girlBasicToken.isNotCoolDown(_tokenId));
1284 
1285 
1286     emit GirlAuctionCreated(_from, _tokenId, _startingPrice, _endingPrice, _duration);
1287 
1288 
1289     require(_startingPrice <= 340282366920938463463374607431768211455);
1290     require(_endingPrice <= 340282366920938463463374607431768211455);
1291     require(_duration <= 18446744073709551615);
1292 
1293     Auction memory auction = Auction(
1294         _from,
1295         uint128(_startingPrice),
1296         uint128(_endingPrice),
1297         uint64(_duration),
1298         uint64(now)
1299     );
1300     _addAuction(_tokenId, auction);
1301 
1302     return ERC721_RECEIVED;
1303   }
1304 
1305 
1306 
1307 
1308 }