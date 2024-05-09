1 pragma solidity ^0.4.23;
2 
3 // File: contracts\utils\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts\utils\Serialize.sol
52 
53 contract Serialize {
54     using SafeMath for uint256;
55     function addAddress(uint _offst, bytes memory _output, address _input) internal pure returns(uint _offset) {
56       assembly {
57         mstore(add(_output, _offst), _input)
58       }
59       return _offst.sub(20);
60     }
61 
62     function addUint(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
63       assembly {
64         mstore(add(_output, _offst), _input)
65       }
66       return _offst.sub(32);
67     }
68 
69     function addUint8(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
70       assembly {
71         mstore(add(_output, _offst), _input)
72       }
73       return _offst.sub(1);
74     }
75 
76     function addUint16(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
77       assembly {
78         mstore(add(_output, _offst), _input)
79       }
80       return _offst.sub(2);
81     }
82 
83     function addUint64(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
84       assembly {
85         mstore(add(_output, _offst), _input)
86       }
87       return _offst.sub(8);
88     }
89 
90     function getAddress(uint _offst, bytes memory _input) internal pure returns (address _output, uint _offset) {
91       assembly {
92         _output := mload(add(_input, _offst))
93       }
94       return (_output, _offst.sub(20));
95     }
96 
97     function getUint(uint _offst, bytes memory _input) internal pure returns (uint _output, uint _offset) {
98       assembly {
99           _output := mload(add(_input, _offst))
100       }
101       return (_output, _offst.sub(32));
102     }
103 
104     function getUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output, uint _offset) {
105       assembly {
106         _output := mload(add(_input, _offst))
107       }
108       return (_output, _offst.sub(1));
109     }
110 
111     function getUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output, uint _offset) {
112       assembly {
113         _output := mload(add(_input, _offst))
114       }
115       return (_output, _offst.sub(2));
116     }
117 
118     function getUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output, uint _offset) {
119       assembly {
120         _output := mload(add(_input, _offst))
121       }
122       return (_output, _offst.sub(8));
123     }
124 }
125 
126 // File: contracts\utils\AddressUtils.sol
127 
128 /**
129  * Utility library of inline functions on addresses
130  */
131 library AddressUtils {
132 
133   /**
134    * Returns whether the target address is a contract
135    * @dev This function will return false if invoked during the constructor of a contract,
136    *  as the code is not actually created until after the constructor finishes.
137    * @param addr address to check
138    * @return whether the target address is a contract
139    */
140   function isContract(address addr) internal view returns (bool) {
141     uint256 size;
142     // XXX Currently there is no better way to check if there is a contract in an address
143     // than to check the size of the code at that address.
144     // See https://ethereum.stackexchange.com/a/14016/36603
145     // for more details about how this works.
146     // TODO Check this again before the Serenity release, because all addresses will be
147     // contracts then.
148     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
149     return size > 0;
150   }
151 
152 }
153 
154 // File: contracts\utils\Ownable.sol
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167 
168   /**
169    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170    * account.
171    */
172   function Ownable() public {
173     owner = msg.sender;
174   }
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184   /**
185    * @dev Allows the current owner to transfer control of the contract to a newOwner.
186    * @param newOwner The address to transfer ownership to.
187    */
188   function transferOwnership(address newOwner) public onlyOwner {
189     require(newOwner != address(0));
190     emit OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 
194 }
195 
196 // File: contracts\utils\Pausable.sol
197 
198 /**
199  * @title Pausable
200  * @dev Base contract which allows children to implement an emergency stop mechanism.
201  */
202 contract Pausable is Ownable {
203   event Pause();
204   event Unpause();
205 
206   bool public paused = false;
207 
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is not paused.
211    */
212   modifier whenNotPaused() {
213     require(!paused);
214     _;
215   }
216 
217   /**
218    * @dev Modifier to make a function callable only when the contract is paused.
219    */
220   modifier whenPaused() {
221     require(paused);
222     _;
223   }
224 
225   /**
226    * @dev called by the owner to pause, triggers stopped state
227    */
228   function pause() onlyOwner whenNotPaused public {
229     paused = true;
230     emit Pause();
231   }
232 
233   /**
234    * @dev called by the owner to unpause, returns to normal state
235    */
236   function unpause() onlyOwner whenPaused public {
237     paused = false;
238     emit Unpause();
239   }
240 }
241 
242 // File: contracts\ERC721\ERC721Basic.sol
243 
244 /**
245  * @title ERC721 Non-Fungible Token Standard basic interface
246  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
247  */
248 contract ERC721Basic {
249   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
250   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
251   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
252 
253   function balanceOf(address _owner) public view returns (uint256 _balance);
254   function ownerOf(uint256 _tokenId) public view returns (address _owner);
255   function exists(uint256 _tokenId) public view returns (bool _exists);
256 
257   function approve(address _to, uint256 _tokenId) public;
258   function getApproved(uint256 _tokenId) public view returns (address _operator);
259 
260   function setApprovalForAll(address _operator, bool _approved) public;
261   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
262 
263   function transferFrom(address _from, address _to, uint256 _tokenId) public;
264   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
265   function safeTransferFrom(
266     address _from,
267     address _to,
268     uint256 _tokenId,
269     bytes _data
270   )
271     public;
272 }
273 
274 // File: contracts\ERC721\ERC721Receiver.sol
275 
276 /**
277  * @title ERC721 token receiver interface
278  * @dev Interface for any contract that wants to support safeTransfers
279  *  from ERC721 asset contracts.
280  */
281 contract ERC721Receiver {
282   /**
283    * @dev Magic value to be returned upon successful reception of an NFT
284    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
285    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
286    */
287   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
288 
289   /**
290    * @notice Handle the receipt of an NFT
291    * @dev The ERC721 smart contract calls this function on the recipient
292    *  after a `safetransfer`. This function MAY throw to revert and reject the
293    *  transfer. This function MUST use 50,000 gas or less. Return of other
294    *  than the magic value MUST result in the transaction being reverted.
295    *  Note: the contract address is always the message sender.
296    * @param _from The sending address
297    * @param _tokenId The NFT identifier which is being transfered
298    * @param _data Additional data with no specified format
299    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
300    */
301   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
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
878 // File: contracts\GenesFactory.sol
879 
880 contract GenesFactory{
881     function mixGenes(uint256 gene1, uint gene2) public returns(uint256);
882     function getPerson(uint256 genes) public pure returns (uint256 person);
883     function getRace(uint256 genes) public pure returns (uint256);
884     function getRarity(uint256 genes) public pure returns (uint256);
885     function getBaseStrengthenPoint(uint256 genesMain,uint256 genesSub) public pure returns (uint256);
886 
887     function getCanBorn(uint256 genes) public pure returns (uint256 canBorn,uint256 cooldown);
888 }
889 
890 // File: contracts\equipments\ERC20Basic.sol
891 
892 /**
893  * @title ERC20Basic
894  * @dev Simpler version of ERC20 interface
895  * @dev see https://github.com/ethereum/EIPs/issues/179
896  */
897 contract ERC20Basic {
898   function totalSupply() public view returns (uint256);
899   function balanceOf(address who) public view returns (uint256);
900   function transfer(address to, uint256 value) public returns (bool);
901   event Transfer(address indexed from, address indexed to, uint256 value);
902 }
903 
904 // File: contracts\equipments\BasicToken.sol
905 
906 /**
907  * @title Basic token
908  * @dev Basic version of StandardToken, with no allowances.
909  */
910 contract BasicToken is ERC20Basic {
911   using SafeMath for uint256;
912 
913   mapping(address => uint256) balances;
914 
915   uint256 totalSupply_;
916 
917   /**
918   * @dev total number of tokens in existence
919   */
920   function totalSupply() public view returns (uint256) {
921     return totalSupply_;
922   }
923 
924   /**
925   * @dev transfer token for a specified address
926   * @param _to The address to transfer to.
927   * @param _value The amount to be transferred.
928   */
929   function transfer(address _to, uint256 _value) public returns (bool) {
930     require(_to != address(0));
931     require(_value <= balances[msg.sender]);
932 
933     balances[msg.sender] = balances[msg.sender].sub(_value);
934     balances[_to] = balances[_to].add(_value);
935     emit Transfer(msg.sender, _to, _value);
936     return true;
937   }
938 
939   /**
940   * @dev Gets the balance of the specified address.
941   * @param _owner The address to query the the balance of.
942   * @return An uint256 representing the amount owned by the passed address.
943   */
944   function balanceOf(address _owner) public view returns (uint256) {
945     return balances[_owner];
946   }
947 
948 }
949 
950 // File: contracts\equipments\ERC20.sol
951 
952 /**
953  * @title ERC20 interface
954  * @dev see https://github.com/ethereum/EIPs/issues/20
955  */
956 contract ERC20 is ERC20Basic {
957   function allowance(address owner, address spender)
958     public view returns (uint256);
959 
960   function transferFrom(address from, address to, uint256 value)
961     public returns (bool);
962 
963   function approve(address spender, uint256 value) public returns (bool);
964   event Approval(
965     address indexed owner,
966     address indexed spender,
967     uint256 value
968   );
969 }
970 
971 // File: contracts\equipments\StandardToken.sol
972 
973 /**
974  * @title Standard ERC20 token
975  *
976  * @dev Implementation of the basic standard token.
977  * @dev https://github.com/ethereum/EIPs/issues/20
978  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
979  */
980 contract StandardToken is ERC20, BasicToken {
981 
982   mapping (address => mapping (address => uint256)) internal allowed;
983 
984 
985   /**
986    * @dev Transfer tokens from one address to another
987    * @param _from address The address which you want to send tokens from
988    * @param _to address The address which you want to transfer to
989    * @param _value uint256 the amount of tokens to be transferred
990    */
991   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
992     require(_to != address(0));
993     require(_value <= balances[_from]);
994     require(_value <= allowed[_from][msg.sender]);
995 
996     balances[_from] = balances[_from].sub(_value);
997     balances[_to] = balances[_to].add(_value);
998     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
999     emit Transfer(_from, _to, _value);
1000     return true;
1001   }
1002 
1003   /**
1004    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1005    *
1006    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1007    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1008    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1009    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1010    * @param _spender The address which will spend the funds.
1011    * @param _value The amount of tokens to be spent.
1012    */
1013   function approve(address _spender, uint256 _value) public returns (bool) {
1014     allowed[msg.sender][_spender] = _value;
1015     emit Approval(msg.sender, _spender, _value);
1016     return true;
1017   }
1018 
1019   /**
1020    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1021    * @param _owner address The address which owns the funds.
1022    * @param _spender address The address which will spend the funds.
1023    * @return A uint256 specifying the amount of tokens still available for the spender.
1024    */
1025   function allowance(address _owner, address _spender) public view returns (uint256) {
1026     return allowed[_owner][_spender];
1027   }
1028 
1029   /**
1030    * @dev Increase the amount of tokens that an owner allowed to a spender.
1031    *
1032    * approve should be called when allowed[_spender] == 0. To increment
1033    * allowed value is better to use this function to avoid 2 calls (and wait until
1034    * the first transaction is mined)
1035    * From MonolithDAO Token.sol
1036    * @param _spender The address which will spend the funds.
1037    * @param _addedValue The amount of tokens to increase the allowance by.
1038    */
1039   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1040     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1041     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1042     return true;
1043   }
1044 
1045   /**
1046    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1047    *
1048    * approve should be called when allowed[_spender] == 0. To decrement
1049    * allowed value is better to use this function to avoid 2 calls (and wait until
1050    * the first transaction is mined)
1051    * From MonolithDAO Token.sol
1052    * @param _spender The address which will spend the funds.
1053    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1054    */
1055   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1056     uint oldValue = allowed[msg.sender][_spender];
1057     if (_subtractedValue > oldValue) {
1058       allowed[msg.sender][_spender] = 0;
1059     } else {
1060       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1061     }
1062     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1063     return true;
1064   }
1065 
1066 }
1067 
1068 // File: contracts\equipments\AtomicSwappableToken.sol
1069 
1070 contract AtomicSwappableToken is StandardToken {
1071   struct HashLockContract {
1072     address sender;
1073     address receiver;
1074     uint amount;
1075     bytes32 hashlock;
1076     uint timelock;
1077     bytes32 secret;
1078     States state;
1079   }
1080 
1081   enum States {
1082     INVALID,
1083     OPEN,
1084     CLOSED,
1085     REFUNDED
1086   }
1087 
1088   mapping (bytes32 => HashLockContract) private contracts;
1089 
1090   modifier futureTimelock(uint _time) {
1091     // only requirement is the timelock time is after the last blocktime (now).
1092     // probably want something a bit further in the future then this.
1093     // but this is still a useful sanity check:
1094     require(_time > now);
1095     _;
1096 }
1097 
1098   modifier contractExists(bytes32 _contractId) {
1099     require(_contractExists(_contractId));
1100     _;
1101   }
1102 
1103   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
1104     require(contracts[_contractId].hashlock == keccak256(_secret));
1105     _;
1106   }
1107 
1108   modifier closable(bytes32 _contractId) {
1109     require(contracts[_contractId].state == States.OPEN);
1110     require(contracts[_contractId].timelock > now);
1111     _;
1112   }
1113 
1114   modifier refundable(bytes32 _contractId) {
1115     require(contracts[_contractId].state == States.OPEN);
1116     require(contracts[_contractId].timelock <= now);
1117     _;
1118   }
1119 
1120   event NewHashLockContract (
1121     bytes32 indexed contractId,
1122     address indexed sender,
1123     address indexed receiver,
1124     uint amount,
1125     bytes32 hashlock,
1126     uint timelock
1127   );
1128 
1129   event SwapClosed(bytes32 indexed contractId);
1130   event SwapRefunded(bytes32 indexed contractId);
1131 
1132 
1133   function open (
1134     address _receiver,
1135     bytes32 _hashlock,
1136     uint _timelock,
1137     uint _amount
1138   ) public
1139     futureTimelock(_timelock)
1140     returns (bytes32 contractId)
1141   {
1142     contractId = keccak256 (
1143       msg.sender,
1144       _receiver,
1145       _amount,
1146       _hashlock,
1147       _timelock
1148     );
1149 
1150     // the new contract must not exist
1151     require(!_contractExists(contractId));
1152 
1153     // transfer token to this contract
1154     require(transfer(address(this), _amount));
1155 
1156     contracts[contractId] = HashLockContract(
1157       msg.sender,
1158       _receiver,
1159       _amount,
1160       _hashlock,
1161       _timelock,
1162       0x0,
1163       States.OPEN
1164     );
1165 
1166     emit NewHashLockContract(contractId, msg.sender, _receiver, _amount, _hashlock, _timelock);
1167   }
1168 
1169   function close(bytes32 _contractId, bytes32 _secret)
1170     public
1171     contractExists(_contractId)
1172     hashlockMatches(_contractId, _secret)
1173     closable(_contractId)
1174     returns (bool)
1175   {
1176     HashLockContract storage c = contracts[_contractId];
1177     c.secret = _secret;
1178     c.state = States.CLOSED;
1179     require(this.transfer(c.receiver, c.amount));
1180     emit SwapClosed(_contractId);
1181     return true;
1182   }
1183 
1184   function refund(bytes32 _contractId)
1185     public
1186     contractExists(_contractId)
1187     refundable(_contractId)
1188     returns (bool)
1189   {
1190     HashLockContract storage c = contracts[_contractId];
1191     c.state = States.REFUNDED;
1192     require(this.transfer(c.sender, c.amount));
1193     emit SwapRefunded(_contractId);
1194     return true;
1195   }
1196 
1197   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
1198     exists = (contracts[_contractId].sender != address(0));
1199   }
1200 
1201   function checkContract(bytes32 _contractId)
1202     public
1203     view
1204     contractExists(_contractId)
1205     returns (
1206       address sender,
1207       address receiver,
1208       uint amount,
1209       bytes32 hashlock,
1210       uint timelock,
1211       bytes32 secret
1212     )
1213   {
1214     HashLockContract memory c = contracts[_contractId];
1215     return (
1216       c.sender,
1217       c.receiver,
1218       c.amount,
1219       c.hashlock,
1220       c.timelock,
1221       c.secret
1222     );
1223   }
1224 
1225 }
1226 
1227 // File: contracts\equipments\TokenReceiver.sol
1228 
1229 contract TokenReceiver {
1230   function receiveApproval(address from, uint amount, address tokenAddress, bytes data) public;
1231 }
1232 
1233 // File: contracts\equipments\BaseEquipment.sol
1234 
1235 contract BaseEquipment is Ownable, AtomicSwappableToken {
1236 
1237   event Mint(address indexed to, uint256 amount);
1238 
1239   //cap==0 means no limits
1240   uint256 public cap;
1241 
1242   /**
1243       properties = [
1244           0, //validationDuration
1245           1, //location
1246           2, //applicableType
1247       ];
1248   **/
1249   uint[] public properties;
1250 
1251 
1252   address public controller;
1253 
1254   modifier onlyController { require(msg.sender == controller); _; }
1255 
1256   function setController(address _newController) public onlyOwner {
1257     controller = _newController;
1258   }
1259 
1260   constructor(uint256 _cap, uint[] _properties) public {
1261     cap = _cap;
1262     properties = _properties;
1263   }
1264 
1265   function setProperty(uint256[] _properties) public onlyOwner {
1266     properties = _properties;
1267   }
1268 
1269 
1270   function _mint(address _to, uint _amount) internal {
1271     require(cap==0 || totalSupply_.add(_amount) <= cap);
1272     totalSupply_ = totalSupply_.add(_amount);
1273     balances[_to] = balances[_to].add(_amount);
1274     emit Transfer(address(0), _to, _amount);
1275   }
1276 
1277 
1278   function mint(address _to, uint256 _amount) onlyController public returns (bool) {
1279     _mint(_to, _amount);
1280     return true;
1281   }
1282 
1283 
1284   function mintFromOwner(address _to, uint256 _amount) onlyOwner public returns (bool) {
1285     _mint(_to, _amount);
1286     return true;
1287   }
1288 
1289 
1290   function approveAndCall(address _spender, uint _amount, bytes _data) public {
1291     if(approve(_spender, _amount)) {
1292       TokenReceiver(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
1293     }
1294   }
1295 
1296 
1297   function checkCap(uint256 _amount) public view returns (bool) {
1298   	return (cap==0 || totalSupply_.add(_amount) <= cap);
1299   }
1300 
1301 
1302 
1303 
1304 }
1305 
1306 // File: contracts\AvatarEquipments.sol
1307 
1308 contract AvatarEquipments is Pausable{
1309 
1310     event SetEquipment(address user, uint256 girlId, address tokenAddress, uint256 amount, uint validationDuration);
1311 
1312     struct Equipment {
1313         address BackgroundAddress;
1314         uint BackgroundAmount;
1315         uint64 BackgroundEndTime;
1316 
1317         address photoFrameAddress;
1318         uint photoFrameAmount;
1319         uint64 photoFrameEndTime;
1320 
1321         address armsAddress;
1322         uint armsAmount;
1323         uint64 armsEndTime;
1324 
1325         address petAddress;
1326         uint petAmount;
1327         uint64 petEndTime;
1328     }
1329     GirlBasicToken girlBasicToken;
1330     GenesFactory genesFactory;
1331   /// @dev A mapping from girl IDs to their current equipment.
1332     mapping (uint256 => Equipment) public GirlIndexToEquipment;
1333 
1334     mapping (address => bool) public equipmentToStatus;
1335 
1336     constructor(address _girlBasicToken, address _GenesFactory) public{
1337         require(_girlBasicToken != address(0x0));
1338         girlBasicToken = GirlBasicToken(_girlBasicToken);
1339         genesFactory = GenesFactory(_GenesFactory);
1340     }
1341 
1342 /* if the list goes to hundreds of equipment this transaction may out of gas.
1343     function managerEquipment(address[] addressList, bool[] statusList) public onlyOwner {
1344         require(addressList.length == statusList.length);
1345         require(addressList.length > 0);
1346         for (uint i = 0; i < addressList.length; i ++) {
1347             equipmentToStatus[addressList[i]] = statusList[i];
1348         }
1349     }
1350 */
1351 
1352     function addTokenToWhitelist(address _eq) public onlyOwner {
1353       equipmentToStatus[_eq] = true;
1354     }
1355 
1356 
1357     function removeFromWhitelist(address _eq) public onlyOwner {
1358       equipmentToStatus[_eq] = false;
1359     }
1360 
1361     function addManyToWhitelist(address[] _eqs) public onlyOwner {
1362       for(uint i=0; i<_eqs.length; i++) {
1363         equipmentToStatus[_eqs[i]] = true;
1364       }
1365     }
1366 
1367     // 新需求： 永久道具(validDuration=18446744073709551615)可拆卸  (18446744073709551615 is max of uint64 )
1368     function withdrawEquipment(uint _girlId, address _equipmentAddress) public {
1369        BaseEquipment baseEquipment = BaseEquipment(_equipmentAddress);
1370        uint _validationDuration = baseEquipment.properties(0);
1371        require(_validationDuration == 18446744073709551615); // the token must have infinite duration. validation duration 0 indicate infinite duration
1372        Equipment storage equipment = GirlIndexToEquipment[_girlId];
1373        uint location = baseEquipment.properties(1);
1374        address owner = girlBasicToken.ownerOf(_girlId);
1375        uint amount;
1376        if (location == 1 && equipment.BackgroundAddress == _equipmentAddress) {
1377           amount = equipment.BackgroundAmount;
1378           
1379           equipment.BackgroundAddress = address(0); 
1380           equipment.BackgroundAmount = 0; 
1381           equipment.BackgroundEndTime = 0;          
1382        } else if (location == 2 && equipment.photoFrameAddress == _equipmentAddress) {
1383           amount = equipment.photoFrameAmount;
1384           
1385           equipment.photoFrameAddress = address(0); 
1386           equipment.photoFrameAmount= 0; 
1387           equipment.photoFrameEndTime = 0;
1388        } else if (location == 3 && equipment.armsAddress == _equipmentAddress) {
1389           amount = equipment.armsAmount;
1390           
1391           equipment.armsAddress = address(0); 
1392           equipment.armsAmount = 0; 
1393           equipment.armsEndTime = 0; 
1394        } else if (location == 4 && equipment.petAddress == _equipmentAddress) {
1395           amount = equipment.petAmount;
1396           
1397           equipment.petAddress = address(0); 
1398           equipment.petAmount = 0; 
1399           equipment.petEndTime = 0; 
1400        } else {
1401           revert();
1402        }
1403        require(amount > 0);
1404        baseEquipment.transfer(owner, amount);
1405     }
1406 
1407     function setEquipment(address _sender, uint _girlId, uint _amount, address _equipmentAddress, uint256[] _properties) whenNotPaused public {
1408         require(isValid(_sender, _girlId , _amount, _equipmentAddress));
1409         Equipment storage equipment = GirlIndexToEquipment[_girlId];
1410 
1411         require(_properties.length >= 3);
1412         uint _validationDuration = _properties[0];
1413         uint _location = _properties[1];
1414         uint _applicableType = _properties[2];
1415 
1416         if(_applicableType < 16){
1417           uint genes = girlBasicToken.getGirlGene(_girlId);
1418           uint race = genesFactory.getRace(genes);
1419           require(race == uint256(_applicableType));
1420         }
1421 
1422         uint _count = _amount / (1 ether);
1423 
1424         if (_location == 1) {
1425             if(_validationDuration == 18446744073709551615) { // 根据永久道具需求更改
1426               equipment.BackgroundEndTime = 18446744073709551615;
1427             } else if((equipment.BackgroundAddress == _equipmentAddress) && equipment.BackgroundEndTime > now ) {
1428                 equipment.BackgroundEndTime  += uint64(_count * _validationDuration);
1429             } else {
1430                 equipment.BackgroundEndTime = uint64(now + (_count * _validationDuration));
1431             }
1432             equipment.BackgroundAddress = _equipmentAddress;
1433             equipment.BackgroundAmount = _amount;
1434         } else if (_location == 2){
1435             if(_validationDuration == 18446744073709551615) {
1436               equipment.photoFrameEndTime = 18446744073709551615;
1437             } else if((equipment.photoFrameAddress == _equipmentAddress) && equipment.photoFrameEndTime > now ) {
1438                 equipment.photoFrameEndTime  += uint64(_count * _validationDuration);
1439             } else {
1440                 equipment.photoFrameEndTime = uint64(now + (_count * _validationDuration));
1441             }
1442             equipment.photoFrameAddress = _equipmentAddress;
1443             equipment.photoFrameAmount = _amount;
1444         } else if (_location == 3) {
1445             if(_validationDuration == 18446744073709551615) {
1446               equipment.armsEndTime = 18446744073709551615;
1447             } else if((equipment.armsAddress == _equipmentAddress) && equipment.armsEndTime > now ) {
1448               equipment.armsEndTime  += uint64(_count * _validationDuration);
1449             } else {
1450               equipment.armsEndTime = uint64(now + (_count * _validationDuration));
1451             }
1452             equipment.armsAddress = _equipmentAddress;
1453             equipment.armsAmount = _count;
1454         } else if (_location == 4) {
1455             if(_validationDuration == 18446744073709551615) {
1456               equipment.petEndTime = 18446744073709551615;
1457             } else if((equipment.petAddress == _equipmentAddress) && equipment.petEndTime > now ) {
1458               equipment.petEndTime  += uint64(_count * _validationDuration);
1459             } else {
1460               equipment.petEndTime = uint64(now + (_count * _validationDuration));
1461             }
1462             equipment.petAddress = _equipmentAddress;
1463             equipment.petAmount = _amount;
1464         } else{
1465             revert();
1466         }
1467         emit SetEquipment(_sender, _girlId, _equipmentAddress, _amount, _validationDuration);
1468     }
1469 
1470     function isValid (address _from, uint _GirlId, uint _amount, address _tokenContract) public returns (bool) {
1471         BaseEquipment baseEquipment = BaseEquipment(_tokenContract);
1472         require(equipmentToStatus[_tokenContract]);
1473         // must send at least 1 token
1474         require(_amount >= 1 ether);
1475         require(_amount % 1 ether == 0); // basic unit is 1 token;
1476         require(girlBasicToken.ownerOf(_GirlId) == _from || owner == _from); // must from girl owner or the owner of contract. 
1477         require(baseEquipment.transferFrom(_from, this, _amount));
1478         return true;
1479     }
1480 
1481     function getGirlEquipmentStatus(uint256 _girlId) public view returns(
1482         address BackgroundAddress,
1483         uint BackgroundAmount,
1484         uint BackgroundEndTime,
1485 
1486         address photoFrameAddress,
1487         uint photoFrameAmount,
1488         uint photoFrameEndTime,
1489 
1490         address armsAddress,
1491         uint armsAmount,
1492         uint armsEndTime,
1493 
1494         address petAddress,
1495         uint petAmount,
1496         uint petEndTime
1497   ){
1498         Equipment storage equipment = GirlIndexToEquipment[_girlId];
1499         if (equipment.BackgroundEndTime >= now) {
1500             BackgroundAddress = equipment.BackgroundAddress;
1501             BackgroundAmount = equipment.BackgroundAmount;
1502             BackgroundEndTime = equipment.BackgroundEndTime;
1503         }
1504 
1505         if (equipment.photoFrameEndTime >= now) {
1506             photoFrameAddress = equipment.photoFrameAddress;
1507             photoFrameAmount = equipment.photoFrameAmount;
1508             photoFrameEndTime = equipment.photoFrameEndTime;
1509         }
1510 
1511         if (equipment.armsEndTime >= now) {
1512             armsAddress = equipment.armsAddress;
1513             armsAmount = equipment.armsAmount;
1514             armsEndTime = equipment.armsEndTime;
1515         }
1516 
1517         if (equipment.petEndTime >= now) {
1518             petAddress = equipment.petAddress;
1519             petAmount = equipment.petAmount;
1520             petEndTime = equipment.petEndTime;
1521         }
1522     }
1523 }
1524 
1525 // File: contracts\equipments\EquipmentToken.sol
1526 
1527 contract EquipmentToken is BaseEquipment {
1528     string public name;                //The shoes name: e.g. shining shoes
1529     string public symbol;              //The shoes symbol: e.g. SS
1530     uint8 public decimals;           //Number of decimals of the smallest unit
1531 
1532 
1533     constructor (
1534         string _name,
1535         string _symbol,
1536         uint256 _cap,
1537         uint[] _properties
1538     ) public BaseEquipment(_cap, _properties) {
1539 
1540         name = _name;
1541         symbol = _symbol;
1542         decimals = 18;  // set as default
1543     }
1544 
1545     function setEquipment(address _target, uint _GirlId, uint256 _amount) public returns (bool success) {
1546         AvatarEquipments eq = AvatarEquipments(_target);
1547         if (approve(_target, _amount)) {
1548             eq.setEquipment(msg.sender, _GirlId, _amount, this, properties);
1549             return true;
1550         }
1551     }
1552 }