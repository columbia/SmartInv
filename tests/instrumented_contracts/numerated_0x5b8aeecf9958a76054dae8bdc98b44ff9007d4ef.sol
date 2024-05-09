1 pragma solidity ^0.4.23;
2 
3 // File: contracts\utils\AddressUtils.sol
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library AddressUtils {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    *  as the code is not actually created until after the constructor finishes.
14    * @param addr address to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address addr) internal view returns (bool) {
18     uint256 size;
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603
22     // for more details about how this works.
23     // TODO Check this again before the Serenity release, because all addresses will be
24     // contracts then.
25     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
26     return size > 0;
27   }
28 
29 }
30 
31 // File: contracts\utils\Ownable.sol
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 // File: contracts\utils\TrustedContractControl.sol
74 
75 contract TrustedContractControl is Ownable{
76   using AddressUtils for address;
77 
78   mapping (address => bool) public trustedContractList;
79 
80   modifier onlyTrustedContract(address _contractAddress) {
81     require(trustedContractList[_contractAddress]);
82     _;
83   }
84 
85   event AddTrustedContract(address contractAddress);
86   event RemoveTrustedContract(address contractAddress);
87 
88 
89   function addTrustedContracts(address[] _contractAddress) onlyOwner public {
90     for(uint i=0; i<_contractAddress.length; i++) {
91       require(addTrustedContract(_contractAddress[i]));
92     }
93   }
94 
95 
96   // need to add GirlSummon, GirlRecycle contract into the trusted list.
97   function addTrustedContract(address _contractAddress) onlyOwner public returns (bool){
98     require(!trustedContractList[_contractAddress]);
99     require(_contractAddress.isContract());
100     trustedContractList[_contractAddress] = true;
101     emit AddTrustedContract(_contractAddress);
102     return true;
103   }
104 
105   function removeTrustedContract(address _contractAddress) onlyOwner public {
106     require(trustedContractList[_contractAddress]);
107     trustedContractList[_contractAddress] = false;
108     emit RemoveTrustedContract(_contractAddress);
109   }
110 }
111 
112 // File: contracts\utils\SafeMath.sol
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, throws on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
124     if (a == 0) {
125       return 0;
126     }
127     c = a * b;
128     assert(c / a == b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 a, uint256 b) internal pure returns (uint256) {
136     // assert(b > 0); // Solidity automatically throws when dividing by 0
137     // uint256 c = a / b;
138     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139     return a / b;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
154     c = a + b;
155     assert(c >= a);
156     return c;
157   }
158 }
159 
160 // File: contracts\utils\Serialize.sol
161 
162 contract Serialize {
163     using SafeMath for uint256;
164     function addAddress(uint _offst, bytes memory _output, address _input) internal pure returns(uint _offset) {
165       assembly {
166         mstore(add(_output, _offst), _input)
167       }
168       return _offst.sub(20);
169     }
170 
171     function addUint(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
172       assembly {
173         mstore(add(_output, _offst), _input)
174       }
175       return _offst.sub(32);
176     }
177 
178     function addUint8(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
179       assembly {
180         mstore(add(_output, _offst), _input)
181       }
182       return _offst.sub(1);
183     }
184 
185     function addUint16(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
186       assembly {
187         mstore(add(_output, _offst), _input)
188       }
189       return _offst.sub(2);
190     }
191 
192     function addUint64(uint _offst, bytes memory _output, uint _input) internal pure returns (uint _offset) {
193       assembly {
194         mstore(add(_output, _offst), _input)
195       }
196       return _offst.sub(8);
197     }
198 
199     function getAddress(uint _offst, bytes memory _input) internal pure returns (address _output, uint _offset) {
200       assembly {
201         _output := mload(add(_input, _offst))
202       }
203       return (_output, _offst.sub(20));
204     }
205 
206     function getUint(uint _offst, bytes memory _input) internal pure returns (uint _output, uint _offset) {
207       assembly {
208           _output := mload(add(_input, _offst))
209       }
210       return (_output, _offst.sub(32));
211     }
212 
213     function getUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output, uint _offset) {
214       assembly {
215         _output := mload(add(_input, _offst))
216       }
217       return (_output, _offst.sub(1));
218     }
219 
220     function getUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output, uint _offset) {
221       assembly {
222         _output := mload(add(_input, _offst))
223       }
224       return (_output, _offst.sub(2));
225     }
226 
227     function getUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output, uint _offset) {
228       assembly {
229         _output := mload(add(_input, _offst))
230       }
231       return (_output, _offst.sub(8));
232     }
233 }
234 
235 // File: contracts\utils\Pausable.sol
236 
237 /**
238  * @title Pausable
239  * @dev Base contract which allows children to implement an emergency stop mechanism.
240  */
241 contract Pausable is Ownable {
242   event Pause();
243   event Unpause();
244 
245   bool public paused = false;
246 
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is not paused.
250    */
251   modifier whenNotPaused() {
252     require(!paused);
253     _;
254   }
255 
256   /**
257    * @dev Modifier to make a function callable only when the contract is paused.
258    */
259   modifier whenPaused() {
260     require(paused);
261     _;
262   }
263 
264   /**
265    * @dev called by the owner to pause, triggers stopped state
266    */
267   function pause() onlyOwner whenNotPaused public {
268     paused = true;
269     emit Pause();
270   }
271 
272   /**
273    * @dev called by the owner to unpause, returns to normal state
274    */
275   function unpause() onlyOwner whenPaused public {
276     paused = false;
277     emit Unpause();
278   }
279 }
280 
281 // File: contracts\ERC721\ERC721Basic.sol
282 
283 /**
284  * @title ERC721 Non-Fungible Token Standard basic interface
285  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
286  */
287 contract ERC721Basic {
288   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
289   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
290   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
291 
292   function balanceOf(address _owner) public view returns (uint256 _balance);
293   function ownerOf(uint256 _tokenId) public view returns (address _owner);
294   function exists(uint256 _tokenId) public view returns (bool _exists);
295 
296   function approve(address _to, uint256 _tokenId) public;
297   function getApproved(uint256 _tokenId) public view returns (address _operator);
298 
299   function setApprovalForAll(address _operator, bool _approved) public;
300   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
301 
302   function transferFrom(address _from, address _to, uint256 _tokenId) public;
303   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
304   function safeTransferFrom(
305     address _from,
306     address _to,
307     uint256 _tokenId,
308     bytes _data
309   )
310     public;
311 }
312 
313 // File: contracts\ERC721\ERC721Receiver.sol
314 
315 /**
316  * @title ERC721 token receiver interface
317  * @dev Interface for any contract that wants to support safeTransfers
318  *  from ERC721 asset contracts.
319  */
320 contract ERC721Receiver {
321   /**
322    * @dev Magic value to be returned upon successful reception of an NFT
323    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
324    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
325    */
326   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
327 
328   /**
329    * @notice Handle the receipt of an NFT
330    * @dev The ERC721 smart contract calls this function on the recipient
331    *  after a `safetransfer`. This function MAY throw to revert and reject the
332    *  transfer. This function MUST use 50,000 gas or less. Return of other
333    *  than the magic value MUST result in the transaction being reverted.
334    *  Note: the contract address is always the message sender.
335    * @param _from The sending address
336    * @param _tokenId The NFT identifier which is being transfered
337    * @param _data Additional data with no specified format
338    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
339    */
340   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
341 }
342 
343 // File: contracts\ERC721\ERC721BasicToken.sol
344 
345 /**
346  * @title ERC721 Non-Fungible Token Standard basic implementation
347  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
348  */
349 contract ERC721BasicToken is ERC721Basic, Pausable {
350   using SafeMath for uint256;
351   using AddressUtils for address;
352 
353   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
354   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
355   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
356 
357   // Mapping from token ID to owner
358   mapping (uint256 => address) internal tokenOwner;
359 
360   // Mapping from token ID to approved address
361   mapping (uint256 => address) internal tokenApprovals;
362 
363   // Mapping from owner to number of owned token
364   mapping (address => uint256) internal ownedTokensCount;
365 
366   // Mapping from owner to operator approvals
367   mapping (address => mapping (address => bool)) internal operatorApprovals;
368 
369   /**
370    * @dev Guarantees msg.sender is owner of the given token
371    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
372    */
373   modifier onlyOwnerOf(uint256 _tokenId) {
374     require(ownerOf(_tokenId) == msg.sender);
375     _;
376   }
377 
378   /**
379    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
380    * @param _tokenId uint256 ID of the token to validate
381    */
382   modifier canTransfer(uint256 _tokenId) {
383     require(isApprovedOrOwner(msg.sender, _tokenId));
384     _;
385   }
386 
387   /**
388    * @dev Gets the balance of the specified address
389    * @param _owner address to query the balance of
390    * @return uint256 representing the amount owned by the passed address
391    */
392   function balanceOf(address _owner) public view returns (uint256) {
393     require(_owner != address(0));
394     return ownedTokensCount[_owner];
395   }
396 
397   /**
398    * @dev Gets the owner of the specified token ID
399    * @param _tokenId uint256 ID of the token to query the owner of
400    * @return owner address currently marked as the owner of the given token ID
401    */
402   function ownerOf(uint256 _tokenId) public view returns (address) {
403     address owner = tokenOwner[_tokenId];
404     require(owner != address(0));
405     return owner;
406   }
407 
408   /**
409    * @dev Returns whether the specified token exists
410    * @param _tokenId uint256 ID of the token to query the existance of
411    * @return whether the token exists
412    */
413   function exists(uint256 _tokenId) public view returns (bool) {
414     address owner = tokenOwner[_tokenId];
415     return owner != address(0);
416   }
417 
418   /**
419    * @dev Approves another address to transfer the given token ID
420    * @dev The zero address indicates there is no approved address.
421    * @dev There can only be one approved address per token at a given time.
422    * @dev Can only be called by the token owner or an approved operator.
423    * @param _to address to be approved for the given token ID
424    * @param _tokenId uint256 ID of the token to be approved
425    */
426   function approve(address _to, uint256 _tokenId) public {
427     address owner = ownerOf(_tokenId);
428     require(_to != owner);
429     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
430 
431     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
432       tokenApprovals[_tokenId] = _to;
433       emit Approval(owner, _to, _tokenId);
434     }
435   }
436 
437   /**
438    * @dev Gets the approved address for a token ID, or zero if no address set
439    * @param _tokenId uint256 ID of the token to query the approval of
440    * @return address currently approved for a the given token ID
441    */
442   function getApproved(uint256 _tokenId) public view returns (address) {
443     return tokenApprovals[_tokenId];
444   }
445 
446   /**
447    * @dev Sets or unsets the approval of a given operator
448    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
449    * @param _to operator address to set the approval
450    * @param _approved representing the status of the approval to be set
451    */
452   function setApprovalForAll(address _to, bool _approved) public {
453     require(_to != msg.sender);
454     operatorApprovals[msg.sender][_to] = _approved;
455     emit ApprovalForAll(msg.sender, _to, _approved);
456   }
457 
458   /**
459    * @dev Tells whether an operator is approved by a given owner
460    * @param _owner owner address which you want to query the approval of
461    * @param _operator operator address which you want to query the approval of
462    * @return bool whether the given operator is approved by the given owner
463    */
464   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
465     return operatorApprovals[_owner][_operator];
466   }
467 
468   /**
469    * @dev Transfers the ownership of a given token ID to another address
470    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
471    * @dev Requires the msg sender to be the owner, approved, or operator
472    * @param _from current owner of the token
473    * @param _to address to receive the ownership of the given token ID
474    * @param _tokenId uint256 ID of the token to be transferred
475   */
476   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
477     require(_from != address(0));
478     require(_to != address(0));
479 
480     clearApproval(_from, _tokenId);
481     removeTokenFrom(_from, _tokenId);
482     addTokenTo(_to, _tokenId);
483 
484     emit Transfer(_from, _to, _tokenId);
485   }
486 
487   function transferBatch(address _from, address _to, uint[] _tokenIds) public {
488     require(_from != address(0));
489     require(_to != address(0));
490 
491     for(uint i=0; i<_tokenIds.length; i++) {
492       require(isApprovedOrOwner(msg.sender, _tokenIds[i]));
493       clearApproval(_from,  _tokenIds[i]);
494       removeTokenFrom(_from, _tokenIds[i]);
495       addTokenTo(_to, _tokenIds[i]);
496 
497       emit Transfer(_from, _to, _tokenIds[i]);
498     }
499   }
500 
501   /**
502    * @dev Safely transfers the ownership of a given token ID to another address
503    * @dev If the target address is a contract, it must implement `onERC721Received`,
504    *  which is called upon a safe transfer, and return the magic value
505    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
506    *  the transfer is reverted.
507    * @dev Requires the msg sender to be the owner, approved, or operator
508    * @param _from current owner of the token
509    * @param _to address to receive the ownership of the given token ID
510    * @param _tokenId uint256 ID of the token to be transferred
511   */
512   function safeTransferFrom(
513     address _from,
514     address _to,
515     uint256 _tokenId
516   )
517     public
518     canTransfer(_tokenId)
519   {
520     // solium-disable-next-line arg-overflow
521     safeTransferFrom(_from, _to, _tokenId, "");
522   }
523 
524   /**
525    * @dev Safely transfers the ownership of a given token ID to another address
526    * @dev If the target address is a contract, it must implement `onERC721Received`,
527    *  which is called upon a safe transfer, and return the magic value
528    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
529    *  the transfer is reverted.
530    * @dev Requires the msg sender to be the owner, approved, or operator
531    * @param _from current owner of the token
532    * @param _to address to receive the ownership of the given token ID
533    * @param _tokenId uint256 ID of the token to be transferred
534    * @param _data bytes data to send along with a safe transfer check
535    */
536   function safeTransferFrom(
537     address _from,
538     address _to,
539     uint256 _tokenId,
540     bytes _data
541   )
542     public
543     canTransfer(_tokenId)
544   {
545     transferFrom(_from, _to, _tokenId);
546     // solium-disable-next-line arg-overflow
547     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
548   }
549 
550   /**
551    * @dev Returns whether the given spender can transfer a given token ID
552    * @param _spender address of the spender to query
553    * @param _tokenId uint256 ID of the token to be transferred
554    * @return bool whether the msg.sender is approved for the given token ID,
555    *  is an operator of the owner, or is the owner of the token
556    */
557   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
558     address owner = ownerOf(_tokenId);
559     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
560   }
561 
562   /**
563    * @dev Internal function to mint a new token
564    * @dev Reverts if the given token ID already exists
565    * @param _to The address that will own the minted token
566    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
567    */
568   function _mint(address _to, uint256 _tokenId) internal {
569     require(_to != address(0));
570     addTokenTo(_to, _tokenId);
571     emit Transfer(address(0), _to, _tokenId);
572   }
573 
574   /**
575    * @dev Internal function to burn a specific token
576    * @dev Reverts if the token does not exist
577    * @param _tokenId uint256 ID of the token being burned by the msg.sender
578    */
579   function _burn(address _owner, uint256 _tokenId) internal {
580     clearApproval(_owner, _tokenId);
581     removeTokenFrom(_owner, _tokenId);
582     emit Transfer(_owner, address(0), _tokenId);
583   }
584 
585   /**
586    * @dev Internal function to clear current approval of a given token ID
587    * @dev Reverts if the given address is not indeed the owner of the token
588    * @param _owner owner of the token
589    * @param _tokenId uint256 ID of the token to be transferred
590    */
591   function clearApproval(address _owner, uint256 _tokenId) internal {
592     require(ownerOf(_tokenId) == _owner);
593     if (tokenApprovals[_tokenId] != address(0)) {
594       tokenApprovals[_tokenId] = address(0);
595       emit Approval(_owner, address(0), _tokenId);
596     }
597   }
598 
599   /**
600    * @dev Internal function to add a token ID to the list of a given address
601    * @param _to address representing the new owner of the given token ID
602    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
603    */
604   function addTokenTo(address _to, uint256 _tokenId) internal whenNotPaused {
605     require(tokenOwner[_tokenId] == address(0));
606     tokenOwner[_tokenId] = _to;
607     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
608   }
609 
610   /**
611    * @dev Internal function to remove a token ID from the list of a given address
612    * @param _from address representing the previous owner of the given token ID
613    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
614    */
615   function removeTokenFrom(address _from, uint256 _tokenId) internal whenNotPaused{
616     require(ownerOf(_tokenId) == _from);
617     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
618     tokenOwner[_tokenId] = address(0);
619   }
620 
621   /**
622    * @dev Internal function to invoke `onERC721Received` on a target address
623    * @dev The call is not executed if the target address is not a contract
624    * @param _from address representing the previous owner of the given token ID
625    * @param _to target address that will receive the tokens
626    * @param _tokenId uint256 ID of the token to be transferred
627    * @param _data bytes optional data to send along with the call
628    * @return whether the call correctly returned the expected magic value
629    */
630   function checkAndCallSafeTransfer(
631     address _from,
632     address _to,
633     uint256 _tokenId,
634     bytes _data
635   )
636     internal
637     returns (bool)
638   {
639     if (!_to.isContract()) {
640       return true;
641     }
642     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
643     return (retval == ERC721_RECEIVED);
644   }
645 }
646 
647 // File: contracts\ERC721\GirlBasicToken.sol
648 
649 // add atomic swap feature in the token contract.
650 contract GirlBasicToken is ERC721BasicToken, Serialize {
651 
652   event CreateGirl(address owner, uint256 tokenID, uint256 genes, uint64 birthTime, uint64 cooldownEndTime, uint16 starLevel);
653   event CoolDown(uint256 tokenId, uint64 cooldownEndTime);
654   event GirlUpgrade(uint256 tokenId, uint64 starLevel);
655 
656   struct Girl{
657     /**
658     少女基因,生成以后不会改变
659     **/
660     uint genes;
661 
662     /*
663     出生时间 少女创建时候的时间戳
664     */
665     uint64 birthTime;
666 
667     /*
668     冷却结束时间
669     */
670     uint64 cooldownEndTime;
671     /*
672     star level
673     */
674     uint16 starLevel;
675   }
676 
677   Girl[] girls;
678 
679 
680   function totalSupply() public view returns (uint256) {
681     return girls.length;
682   }
683 
684   function getGirlGene(uint _index) public view returns (uint) {
685     return girls[_index].genes;
686   }
687 
688   function getGirlBirthTime(uint _index) public view returns (uint64) {
689     return girls[_index].birthTime;
690   }
691 
692   function getGirlCoolDownEndTime(uint _index) public view returns (uint64) {
693     return girls[_index].cooldownEndTime;
694   }
695 
696   function getGirlStarLevel(uint _index) public view returns (uint16) {
697     return girls[_index].starLevel;
698   }
699 
700   function isNotCoolDown(uint _girlId) public view returns(bool) {
701     return uint64(now) > girls[_girlId].cooldownEndTime;
702   }
703 
704   function _createGirl(
705       uint _genes,
706       address _owner,
707       uint16 _starLevel
708   ) internal returns (uint){
709       Girl memory _girl = Girl({
710           genes:_genes,
711           birthTime:uint64(now),
712           cooldownEndTime:0,
713           starLevel:_starLevel
714       });
715       uint256 girlId = girls.push(_girl) - 1;
716       _mint(_owner, girlId);
717       emit CreateGirl(_owner, girlId, _genes, _girl.birthTime, _girl.cooldownEndTime, _girl.starLevel);
718       return girlId;
719   }
720 
721   function _setCoolDownTime(uint _tokenId, uint _coolDownTime) internal {
722     girls[_tokenId].cooldownEndTime = uint64(now.add(_coolDownTime));
723     emit CoolDown(_tokenId, girls[_tokenId].cooldownEndTime);
724   }
725 
726   function _LevelUp(uint _tokenId) internal {
727     require(girls[_tokenId].starLevel < 65535);
728     girls[_tokenId].starLevel = girls[_tokenId].starLevel + 1;
729     emit GirlUpgrade(_tokenId, girls[_tokenId].starLevel);
730   }
731 
732   // ---------------
733   // this is atomic swap for girl to be set cross chain.
734   // ---------------
735   uint8 constant public GIRLBUFFERSIZE = 50;  // buffer size need to serialize girl data; used for cross chain sync
736 
737   struct HashLockContract {
738     address sender;
739     address receiver;
740     uint tokenId;
741     bytes32 hashlock;
742     uint timelock;
743     bytes32 secret;
744     States state;
745     bytes extraData;
746   }
747 
748   enum States {
749     INVALID,
750     OPEN,
751     CLOSED,
752     REFUNDED
753   }
754 
755   mapping (bytes32 => HashLockContract) private contracts;
756 
757   modifier contractExists(bytes32 _contractId) {
758     require(_contractExists(_contractId));
759     _;
760   }
761 
762   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
763     require(contracts[_contractId].hashlock == keccak256(_secret));
764     _;
765   }
766 
767   modifier closable(bytes32 _contractId) {
768     require(contracts[_contractId].state == States.OPEN);
769     require(contracts[_contractId].timelock > now);
770     _;
771   }
772 
773   modifier refundable(bytes32 _contractId) {
774     require(contracts[_contractId].state == States.OPEN);
775     require(contracts[_contractId].timelock <= now);
776     _;
777   }
778 
779   event NewHashLockContract (
780     bytes32 indexed contractId,
781     address indexed sender,
782     address indexed receiver,
783     uint tokenId,
784     bytes32 hashlock,
785     uint timelock,
786     bytes extraData
787   );
788 
789   event SwapClosed(bytes32 indexed contractId);
790   event SwapRefunded(bytes32 indexed contractId);
791 
792   function open (
793     address _receiver,
794     bytes32 _hashlock,
795     uint _duration,
796     uint _tokenId
797   ) public
798     onlyOwnerOf(_tokenId)
799     returns (bytes32 contractId)
800   {
801     uint _timelock = now.add(_duration);
802 
803     // compute girl data;
804     bytes memory _extraData = new bytes(GIRLBUFFERSIZE);
805     uint offset = GIRLBUFFERSIZE;
806 
807     offset = addUint16(offset, _extraData, girls[_tokenId].starLevel);
808     offset = addUint64(offset, _extraData, girls[_tokenId].cooldownEndTime);
809     offset = addUint64(offset, _extraData, girls[_tokenId].birthTime);
810     offset = addUint(offset, _extraData, girls[_tokenId].genes);
811 
812     contractId = keccak256 (
813       msg.sender,
814       _receiver,
815       _tokenId,
816       _hashlock,
817       _timelock,
818       _extraData
819     );
820 
821     // the new contract must not exist
822     require(!_contractExists(contractId));
823 
824     // temporary change the ownership to this contract address.
825     // the ownership will be change to user when close is called.
826     clearApproval(msg.sender, _tokenId);
827     removeTokenFrom(msg.sender, _tokenId);
828     addTokenTo(address(this), _tokenId);
829 
830 
831     contracts[contractId] = HashLockContract(
832       msg.sender,
833       _receiver,
834       _tokenId,
835       _hashlock,
836       _timelock,
837       0x0,
838       States.OPEN,
839       _extraData
840     );
841 
842     emit NewHashLockContract(contractId, msg.sender, _receiver, _tokenId, _hashlock, _timelock, _extraData);
843   }
844 
845   function close(bytes32 _contractId, bytes32 _secret)
846     public
847     contractExists(_contractId)
848     hashlockMatches(_contractId, _secret)
849     closable(_contractId)
850     returns (bool)
851   {
852     HashLockContract storage c = contracts[_contractId];
853     c.secret = _secret;
854     c.state = States.CLOSED;
855 
856     // transfer token ownership from this contract address to receiver.
857     // clearApproval(address(this), c.tokenId);
858     removeTokenFrom(address(this), c.tokenId);
859     addTokenTo(c.receiver, c.tokenId);
860 
861     emit SwapClosed(_contractId);
862     return true;
863   }
864 
865   function refund(bytes32 _contractId)
866     public
867     contractExists(_contractId)
868     refundable(_contractId)
869     returns (bool)
870   {
871     HashLockContract storage c = contracts[_contractId];
872     c.state = States.REFUNDED;
873 
874     // transfer token ownership from this contract address to receiver.
875     // clearApproval(address(this), c.tokenId);
876     removeTokenFrom(address(this), c.tokenId);
877     addTokenTo(c.sender, c.tokenId);
878 
879 
880     emit SwapRefunded(_contractId);
881     return true;
882   }
883 
884   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
885     exists = (contracts[_contractId].sender != address(0));
886   }
887 
888   function checkContract(bytes32 _contractId)
889     public
890     view
891     contractExists(_contractId)
892     returns (
893       address sender,
894       address receiver,
895       uint amount,
896       bytes32 hashlock,
897       uint timelock,
898       bytes32 secret,
899       bytes extraData
900     )
901   {
902     HashLockContract memory c = contracts[_contractId];
903     return (
904       c.sender,
905       c.receiver,
906       c.tokenId,
907       c.hashlock,
908       c.timelock,
909       c.secret,
910       c.extraData
911     );
912   }
913 
914 
915 }
916 
917 // File: contracts\ERC721\GirlOps.sol
918 
919 contract GirlOps is GirlBasicToken, TrustedContractControl {
920 
921   string public name = "Cryptogirl";
922   string public symbol = "CG";
923   
924   function createGirl(uint _genes, address _owner, uint16 _starLevel)
925       onlyTrustedContract(msg.sender) public returns (uint) {
926       require (_starLevel > 0);
927       return _createGirl(_genes, _owner, _starLevel);
928   }
929 
930   function createPromotionGirl(uint[] _genes, address _owner, uint16 _starLevel) onlyOwner public {
931   	require (_starLevel > 0);
932     for (uint i=0; i<_genes.length; i++) {
933       _createGirl(_genes[i], _owner, _starLevel);
934     }
935   }
936 
937   function burnGirl(address _owner, uint _tokenId) onlyTrustedContract(msg.sender) public {
938       _burn(_owner, _tokenId);
939   }
940 
941   function setCoolDownTime(uint _tokenId, uint _coolDownTime)
942       onlyTrustedContract(msg.sender) public {
943       _setCoolDownTime(_tokenId, _coolDownTime);
944   }
945 
946   function levelUp(uint _tokenId)
947       onlyTrustedContract(msg.sender) public {
948       _LevelUp(_tokenId);
949   }
950 
951   function safeTransferFromWithData(
952     address _from,
953     address _to,
954     uint256 _tokenId,
955     bytes _data
956   ) public {
957       safeTransferFrom(_from,_to,_tokenId,_data);
958   }
959 
960 
961 }
962 
963 // File: contracts\GenesFactory.sol
964 
965 contract GenesFactory{
966     function mixGenes(uint256 gene1, uint gene2) public returns(uint256);
967     function getPerson(uint256 genes) public pure returns (uint256 person);
968     function getRace(uint256 genes) public pure returns (uint256);
969     function getRarity(uint256 genes) public pure returns (uint256);
970     function getBaseStrengthenPoint(uint256 genesMain,uint256 genesSub) public pure returns (uint256);
971 
972     function getCanBorn(uint256 genes) public pure returns (uint256 canBorn,uint256 cooldown);
973 }
974 
975 // File: contracts\utils\AccessControl.sol
976 
977 contract AccessControl is Ownable{
978     address CFO;
979     //Owner address can set to COO address. it have same effect.
980 
981     modifier onlyCFO{
982         require(msg.sender == CFO);
983         _;
984     }
985 
986     function setCFO(address _newCFO)public onlyOwner {
987         CFO = _newCFO;
988     }
989 
990     //use pausable in the contract that need to pause. save gas and clear confusion.
991 
992 }
993 
994 // File: contracts\utils\ServerControl.sol
995 
996 contract ServerControl is AccessControl{
997 
998     event AddServerAddress(address contractAddress);
999     event RemoveServerAddress(address contractAddress);
1000 
1001     mapping (address => bool) public serverAddressList;
1002 
1003     modifier onlyServer {
1004         require(serverAddressList[msg.sender]);
1005         _;
1006     }
1007 
1008     function addServerAddress(address _serverAddress) onlyOwner public returns (bool){
1009         serverAddressList[_serverAddress] = true;
1010         emit AddServerAddress(_serverAddress);
1011         return true;
1012     }
1013 
1014     function removeServerAddress(address _serverAddress) onlyOwner public {
1015         require(serverAddressList[_serverAddress]);
1016         serverAddressList[_serverAddress] = false;
1017         emit RemoveServerAddress(_serverAddress);
1018     }
1019 }
1020 
1021 // File: contracts\equipments\ERC20Basic.sol
1022 
1023 /**
1024  * @title ERC20Basic
1025  * @dev Simpler version of ERC20 interface
1026  * @dev see https://github.com/ethereum/EIPs/issues/179
1027  */
1028 contract ERC20Basic {
1029   function totalSupply() public view returns (uint256);
1030   function balanceOf(address who) public view returns (uint256);
1031   function transfer(address to, uint256 value) public returns (bool);
1032   event Transfer(address indexed from, address indexed to, uint256 value);
1033 }
1034 
1035 // File: contracts\equipments\BasicToken.sol
1036 
1037 /**
1038  * @title Basic token
1039  * @dev Basic version of StandardToken, with no allowances.
1040  */
1041 contract BasicToken is ERC20Basic {
1042   using SafeMath for uint256;
1043 
1044   mapping(address => uint256) balances;
1045 
1046   uint256 totalSupply_;
1047 
1048   /**
1049   * @dev total number of tokens in existence
1050   */
1051   function totalSupply() public view returns (uint256) {
1052     return totalSupply_;
1053   }
1054 
1055   /**
1056   * @dev transfer token for a specified address
1057   * @param _to The address to transfer to.
1058   * @param _value The amount to be transferred.
1059   */
1060   function transfer(address _to, uint256 _value) public returns (bool) {
1061     require(_to != address(0));
1062     require(_value <= balances[msg.sender]);
1063 
1064     balances[msg.sender] = balances[msg.sender].sub(_value);
1065     balances[_to] = balances[_to].add(_value);
1066     emit Transfer(msg.sender, _to, _value);
1067     return true;
1068   }
1069 
1070   /**
1071   * @dev Gets the balance of the specified address.
1072   * @param _owner The address to query the the balance of.
1073   * @return An uint256 representing the amount owned by the passed address.
1074   */
1075   function balanceOf(address _owner) public view returns (uint256) {
1076     return balances[_owner];
1077   }
1078 
1079 }
1080 
1081 // File: contracts\equipments\ERC20.sol
1082 
1083 /**
1084  * @title ERC20 interface
1085  * @dev see https://github.com/ethereum/EIPs/issues/20
1086  */
1087 contract ERC20 is ERC20Basic {
1088   function allowance(address owner, address spender)
1089     public view returns (uint256);
1090 
1091   function transferFrom(address from, address to, uint256 value)
1092     public returns (bool);
1093 
1094   function approve(address spender, uint256 value) public returns (bool);
1095   event Approval(
1096     address indexed owner,
1097     address indexed spender,
1098     uint256 value
1099   );
1100 }
1101 
1102 // File: contracts\equipments\StandardToken.sol
1103 
1104 /**
1105  * @title Standard ERC20 token
1106  *
1107  * @dev Implementation of the basic standard token.
1108  * @dev https://github.com/ethereum/EIPs/issues/20
1109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1110  */
1111 contract StandardToken is ERC20, BasicToken {
1112 
1113   mapping (address => mapping (address => uint256)) internal allowed;
1114 
1115 
1116   /**
1117    * @dev Transfer tokens from one address to another
1118    * @param _from address The address which you want to send tokens from
1119    * @param _to address The address which you want to transfer to
1120    * @param _value uint256 the amount of tokens to be transferred
1121    */
1122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1123     require(_to != address(0));
1124     require(_value <= balances[_from]);
1125     require(_value <= allowed[_from][msg.sender]);
1126 
1127     balances[_from] = balances[_from].sub(_value);
1128     balances[_to] = balances[_to].add(_value);
1129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1130     emit Transfer(_from, _to, _value);
1131     return true;
1132   }
1133 
1134   /**
1135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1136    *
1137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1141    * @param _spender The address which will spend the funds.
1142    * @param _value The amount of tokens to be spent.
1143    */
1144   function approve(address _spender, uint256 _value) public returns (bool) {
1145     allowed[msg.sender][_spender] = _value;
1146     emit Approval(msg.sender, _spender, _value);
1147     return true;
1148   }
1149 
1150   /**
1151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1152    * @param _owner address The address which owns the funds.
1153    * @param _spender address The address which will spend the funds.
1154    * @return A uint256 specifying the amount of tokens still available for the spender.
1155    */
1156   function allowance(address _owner, address _spender) public view returns (uint256) {
1157     return allowed[_owner][_spender];
1158   }
1159 
1160   /**
1161    * @dev Increase the amount of tokens that an owner allowed to a spender.
1162    *
1163    * approve should be called when allowed[_spender] == 0. To increment
1164    * allowed value is better to use this function to avoid 2 calls (and wait until
1165    * the first transaction is mined)
1166    * From MonolithDAO Token.sol
1167    * @param _spender The address which will spend the funds.
1168    * @param _addedValue The amount of tokens to increase the allowance by.
1169    */
1170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1173     return true;
1174   }
1175 
1176   /**
1177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1178    *
1179    * approve should be called when allowed[_spender] == 0. To decrement
1180    * allowed value is better to use this function to avoid 2 calls (and wait until
1181    * the first transaction is mined)
1182    * From MonolithDAO Token.sol
1183    * @param _spender The address which will spend the funds.
1184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1185    */
1186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1187     uint oldValue = allowed[msg.sender][_spender];
1188     if (_subtractedValue > oldValue) {
1189       allowed[msg.sender][_spender] = 0;
1190     } else {
1191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1192     }
1193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1194     return true;
1195   }
1196 
1197 }
1198 
1199 // File: contracts\equipments\AtomicSwappableToken.sol
1200 
1201 contract AtomicSwappableToken is StandardToken {
1202   struct HashLockContract {
1203     address sender;
1204     address receiver;
1205     uint amount;
1206     bytes32 hashlock;
1207     uint timelock;
1208     bytes32 secret;
1209     States state;
1210   }
1211 
1212   enum States {
1213     INVALID,
1214     OPEN,
1215     CLOSED,
1216     REFUNDED
1217   }
1218 
1219   mapping (bytes32 => HashLockContract) private contracts;
1220 
1221   modifier futureTimelock(uint _time) {
1222     // only requirement is the timelock time is after the last blocktime (now).
1223     // probably want something a bit further in the future then this.
1224     // but this is still a useful sanity check:
1225     require(_time > now);
1226     _;
1227 }
1228 
1229   modifier contractExists(bytes32 _contractId) {
1230     require(_contractExists(_contractId));
1231     _;
1232   }
1233 
1234   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
1235     require(contracts[_contractId].hashlock == keccak256(_secret));
1236     _;
1237   }
1238 
1239   modifier closable(bytes32 _contractId) {
1240     require(contracts[_contractId].state == States.OPEN);
1241     require(contracts[_contractId].timelock > now);
1242     _;
1243   }
1244 
1245   modifier refundable(bytes32 _contractId) {
1246     require(contracts[_contractId].state == States.OPEN);
1247     require(contracts[_contractId].timelock <= now);
1248     _;
1249   }
1250 
1251   event NewHashLockContract (
1252     bytes32 indexed contractId,
1253     address indexed sender,
1254     address indexed receiver,
1255     uint amount,
1256     bytes32 hashlock,
1257     uint timelock
1258   );
1259 
1260   event SwapClosed(bytes32 indexed contractId);
1261   event SwapRefunded(bytes32 indexed contractId);
1262 
1263 
1264   function open (
1265     address _receiver,
1266     bytes32 _hashlock,
1267     uint _timelock,
1268     uint _amount
1269   ) public
1270     futureTimelock(_timelock)
1271     returns (bytes32 contractId)
1272   {
1273     contractId = keccak256 (
1274       msg.sender,
1275       _receiver,
1276       _amount,
1277       _hashlock,
1278       _timelock
1279     );
1280 
1281     // the new contract must not exist
1282     require(!_contractExists(contractId));
1283 
1284     // transfer token to this contract
1285     require(transfer(address(this), _amount));
1286 
1287     contracts[contractId] = HashLockContract(
1288       msg.sender,
1289       _receiver,
1290       _amount,
1291       _hashlock,
1292       _timelock,
1293       0x0,
1294       States.OPEN
1295     );
1296 
1297     emit NewHashLockContract(contractId, msg.sender, _receiver, _amount, _hashlock, _timelock);
1298   }
1299 
1300   function close(bytes32 _contractId, bytes32 _secret)
1301     public
1302     contractExists(_contractId)
1303     hashlockMatches(_contractId, _secret)
1304     closable(_contractId)
1305     returns (bool)
1306   {
1307     HashLockContract storage c = contracts[_contractId];
1308     c.secret = _secret;
1309     c.state = States.CLOSED;
1310     require(this.transfer(c.receiver, c.amount));
1311     emit SwapClosed(_contractId);
1312     return true;
1313   }
1314 
1315   function refund(bytes32 _contractId)
1316     public
1317     contractExists(_contractId)
1318     refundable(_contractId)
1319     returns (bool)
1320   {
1321     HashLockContract storage c = contracts[_contractId];
1322     c.state = States.REFUNDED;
1323     require(this.transfer(c.sender, c.amount));
1324     emit SwapRefunded(_contractId);
1325     return true;
1326   }
1327 
1328   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
1329     exists = (contracts[_contractId].sender != address(0));
1330   }
1331 
1332   function checkContract(bytes32 _contractId)
1333     public
1334     view
1335     contractExists(_contractId)
1336     returns (
1337       address sender,
1338       address receiver,
1339       uint amount,
1340       bytes32 hashlock,
1341       uint timelock,
1342       bytes32 secret
1343     )
1344   {
1345     HashLockContract memory c = contracts[_contractId];
1346     return (
1347       c.sender,
1348       c.receiver,
1349       c.amount,
1350       c.hashlock,
1351       c.timelock,
1352       c.secret
1353     );
1354   }
1355 
1356 }
1357 
1358 // File: contracts\equipments\TokenReceiver.sol
1359 
1360 contract TokenReceiver {
1361   function receiveApproval(address from, uint amount, address tokenAddress, bytes data) public;
1362 }
1363 
1364 // File: contracts\equipments\BaseEquipment.sol
1365 
1366 contract BaseEquipment is Ownable, AtomicSwappableToken {
1367 
1368   event Mint(address indexed to, uint256 amount);
1369 
1370   //cap==0 means no limits
1371   uint256 public cap;
1372 
1373   /**
1374       properties = [
1375           0, //validationDuration
1376           1, //location
1377           2, //applicableType
1378       ];
1379   **/
1380   uint[] public properties;
1381 
1382 
1383   address public controller;
1384 
1385   modifier onlyController { require(msg.sender == controller); _; }
1386 
1387   function setController(address _newController) public onlyOwner {
1388     controller = _newController;
1389   }
1390 
1391   constructor(uint256 _cap, uint[] _properties) public {
1392     cap = _cap;
1393     properties = _properties;
1394   }
1395 
1396   function setProperty(uint256[] _properties) public onlyOwner {
1397     properties = _properties;
1398   }
1399 
1400 
1401   function _mint(address _to, uint _amount) internal {
1402     require(cap==0 || totalSupply_.add(_amount) <= cap);
1403     totalSupply_ = totalSupply_.add(_amount);
1404     balances[_to] = balances[_to].add(_amount);
1405     emit Transfer(address(0), _to, _amount);
1406   }
1407 
1408 
1409   function mint(address _to, uint256 _amount) onlyController public returns (bool) {
1410     _mint(_to, _amount);
1411     return true;
1412   }
1413 
1414 
1415   function mintFromOwner(address _to, uint256 _amount) onlyOwner public returns (bool) {
1416     _mint(_to, _amount);
1417     return true;
1418   }
1419 
1420 
1421   function approveAndCall(address _spender, uint _amount, bytes _data) public {
1422     if(approve(_spender, _amount)) {
1423       TokenReceiver(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
1424     }
1425   }
1426 
1427 
1428   function checkCap(uint256 _amount) public view returns (bool) {
1429   	return (cap==0 || totalSupply_.add(_amount) <= cap);
1430   }
1431 
1432 
1433 
1434 
1435 }
1436 
1437 // File: contracts\equipments\PrizePool.sol
1438 
1439 contract PrizePool is Ownable {
1440 
1441   event SendPrized(address equipementAddress, address to);
1442 
1443   address[] public magicBoxes;
1444   mapping(address => bool) public magicBoxList;
1445 
1446   address[] public equipments;
1447   GirlOps public girlOps;
1448 
1449   event SendEquipment(address to, address prizeAddress, uint time);
1450   event EquipmentOutOfStock(address eqAddress);
1451 
1452   modifier onlyMagicBox() {
1453     require(magicBoxList[msg.sender]);
1454     _;
1455   }
1456 
1457   constructor(address _girlOpsAddress) public {
1458     girlOps = GirlOps(_girlOpsAddress);
1459   }
1460 
1461   function sendPrize(address _to, uint _index) public onlyMagicBox returns (bool) {
1462     //新确定方案，如果开箱开到某个道具没有了，直接选下一个
1463     //递归调用，全部箱子如果都遍历完了全都脱销，则失败
1464     //现在这样会开出箱子中没有的东西， 按理来讲应该开出箱子的下一个物品。
1465     address prizeAddress = equipments[_index];
1466     BaseEquipment baseEquipment = BaseEquipment(prizeAddress);
1467     if(baseEquipment.checkCap(1 ether)) {
1468       baseEquipment.mint(_to, 1 ether);
1469       emit SendEquipment(_to, prizeAddress, now);
1470       return true;
1471     } else {
1472       emit EquipmentOutOfStock(prizeAddress);
1473       return false;
1474     }
1475   }
1476 
1477   function mintGirl(address to, uint gene, uint16 _level) public onlyMagicBox returns (bool) {
1478     girlOps.createGirl(gene, to, _level);
1479     return true;
1480   }
1481 
1482   function setEquipments(address[] _equipments) public onlyOwner {
1483     equipments = _equipments;
1484   }
1485 
1486 
1487   function addMagicBox(address addr) public onlyOwner returns (bool) {
1488     if (!magicBoxList[addr]) {
1489       magicBoxList[addr] = true;
1490       magicBoxes.push(addr);
1491       return true;
1492     } else {
1493       return false;
1494     }
1495   }
1496 
1497   function addMagicBoxes(address[] addrs) public onlyOwner returns (bool) {
1498     for (uint i=0; i<addrs.length; i++) {
1499       require(addMagicBox(addrs[i]));
1500     }
1501     return true;
1502   }
1503 
1504   function removeMagicBox(address addr) public onlyOwner returns (bool) {
1505     require(magicBoxList[addr]);
1506     for (uint i=0; i<magicBoxes.length - 1; i++) {
1507       if (magicBoxes[i] == addr) {
1508         magicBoxes[i] = magicBoxes[magicBoxes.length -1];
1509         break;
1510       }
1511     }
1512     magicBoxes.length -= 1;
1513     magicBoxList[addr] = false;
1514     return true;
1515   }
1516 
1517 }
1518 
1519 // File: contracts\equipments\SRNG.sol
1520 
1521 contract SRNG is Ownable {
1522 
1523     string welcome = "Hi, I know I cannot hide from you ;) Before creating your script to guess out what is your next prize in the box. Wait a minute ! We have a gift for you. We haved created a special crypto girl to this contract, submit your answer at 0x.... the girl is yours. And sadly we will have to create a more complicated puzzle next time. Happy hacking ! lol";
1524 
1525     mapping (address => bool) public whitelist;
1526     uint rand;
1527 
1528     function addBoxToWhitelist(address _box) public;
1529 
1530     function removeFromWhitelist(address _box) public;
1531     
1532     function addManyToWhitelist(address[] _boxes) public;
1533 
1534     function _getRandom() internal returns (uint);
1535 
1536     function getRandomFromBox() public returns (uint);
1537 
1538 }
1539 
1540 // File: contracts\equipments\SRNMagicBox.sol
1541 
1542 contract SRNMagicBox is ServerControl, TokenReceiver {
1543   GirlOps girlOps;
1544   GenesFactory genesFactory;
1545   SRNG SRNGInstance;
1546 
1547   string public name;                //The shoes name: e.g. MB
1548   uint public keyRequired;
1549   address public keyAddress;
1550   address public prizePoolAddress;
1551   uint public boxPrice;              //price to openbox in wei;
1552 
1553   uint[] public prizeIndex;
1554   uint[] public prizeRange;
1555 
1556   uint[] public NCards;
1557   uint[] public RCards;
1558   uint[] public SRCards;
1559   uint[] public SSRCards;
1560 
1561   event SendGirlFail(address _to, uint _type); 
1562 
1563   constructor(string _name, address _girlAddress, address _SRNGAddress, address _genesFactoryAddress, address _prizePoolAddress, address _keyAddress, uint _keyRequired, uint _boxPrice) public {
1564     name = _name;
1565     girlOps = GirlOps(_girlAddress);
1566     SRNGInstance = SRNG(_SRNGAddress);
1567     genesFactory = GenesFactory(_genesFactoryAddress);
1568     prizePoolAddress = _prizePoolAddress;
1569     keyAddress = _keyAddress;
1570     keyRequired = _keyRequired;
1571     boxPrice = _boxPrice;
1572   }
1573 
1574 
1575   function setupPrize(uint[] _prizeIndex, uint[] _prizeRange) public onlyOwner {
1576     prizeIndex = _prizeIndex;
1577     prizeRange = _prizeRange;
1578   }
1579 
1580   function getPrizeIndex(uint random) public view returns (uint) {
1581     uint maxRange = prizeRange[prizeRange.length -1];
1582     uint n = random % maxRange;
1583 
1584     uint start = 0;
1585     uint mid = 0;
1586     uint end = prizeRange.length-1;
1587 
1588     if (prizeRange[0]>n){
1589       return 0;
1590     }
1591     if (prizeRange[end-1]<=n){
1592       return end;
1593     }
1594 
1595     while (start <= end) {
1596       mid = start + (end - start) / 2;
1597       if (prizeRange[mid]<=n && n<prizeRange[mid+1]){
1598           return mid+1;
1599       } else if (prizeRange[mid+1] <= n) {
1600         start = mid+1;
1601       } else {
1602         end = mid;
1603       }
1604     }
1605 
1606     return start;
1607   }
1608 
1609   function _sendGirl(address _to, uint _random, uint[] storage collection) internal returns (bool) {
1610     uint index;
1611     uint length = collection.length;
1612     if(length > 0) {
1613       index = _random % length;
1614       girlOps.createGirl(collection[index], _to, 1);
1615       // remove girl from list;
1616       collection[index] = collection[length -1];
1617       collection.length = length - 1;
1618       return true;
1619     } else {
1620       return false;
1621     }
1622   }
1623   
1624   function _openBox(address _to, uint _random) internal returns (bool) {
1625     uint index = getPrizeIndex(_random);
1626     PrizePool pl = PrizePool(prizePoolAddress);
1627     uint count = 0;
1628     while(count < prizeIndex.length) {
1629       if(prizeIndex[index] == 0) { // get a girl, first 4 item are NCards, SCards, SRCards, SSRCards.
1630         if(_sendGirl(_to, _random, NCards)) { // choose a girl from NCards;
1631           return true;
1632         } else {
1633           emit SendGirlFail(_to, 0);
1634         }
1635       } else if(prizeIndex[index] == 1) {
1636         if(_sendGirl(_to, _random, RCards)){  // choose a girl from RCards;
1637           return true;
1638         } else {
1639           emit SendGirlFail(_to, 1);
1640         }
1641       } else if(prizeIndex[index] == 2) {
1642         if(_sendGirl(_to, _random, SRCards)){  // choose a girl from SRCards;
1643           return true;
1644         } else {
1645           emit SendGirlFail(_to, 2);
1646         }
1647       } else if(prizeIndex[index] == 3) {
1648         if(_sendGirl(_to, _random, SSRCards)) {  // choose a girl from SSRCards;
1649           return true;
1650         } else {
1651           emit SendGirlFail(_to, 3);
1652         }
1653       }  else if (pl.sendPrize(_to, prizeIndex[index] - 10)) { // send equipment prize successfully
1654         return true;
1655       }
1656 
1657       count = count + 1;
1658       index = index + 1;
1659       if(index == prizeIndex.length) index = 0;
1660 
1661     }
1662 
1663     // does not get anything.
1664     return false;
1665   }
1666 
1667   function setKeyAddress(address _key) public onlyOwner {
1668     keyAddress = _key;
1669   }
1670   
1671   function setGirls(uint[] _tokenIds) public onlyOwner {
1672     uint _rarity;
1673     for(uint i=0; i<_tokenIds.length; i++) {
1674       _rarity = genesFactory.getRarity(_tokenIds[i]);
1675       if(_rarity == 0) {
1676         NCards.push(_tokenIds[i]);
1677       } else if(_rarity == 1) {
1678         RCards.push(_tokenIds[i]);
1679       } else if(_rarity == 2) {
1680         SRCards.push(_tokenIds[i]);
1681       } else if(_rarity == 3) {
1682         SSRCards.push(_tokenIds[i]);
1683       } else {
1684         revert();
1685       }
1686     }
1687   }
1688 
1689   function setSRNG(address _SRNGAddress) public onlyOwner {
1690     SRNGInstance = SRNG(_SRNGAddress);
1691   }
1692 
1693   function getNCardsNumber() public view returns (uint) {
1694     return NCards.length;
1695   }
1696 
1697   function getRCardsNumber() public view returns (uint) {
1698     return RCards.length;
1699   }
1700 
1701   function getSRCardsNumber() public view returns (uint) {
1702     return SRCards.length;
1703   }
1704 
1705   function getSSRCardsNumber() public view returns (uint) {
1706     return SSRCards.length;
1707   }
1708 
1709 
1710   //新需求从myether wallet 直接开箱， 需要payble 没有function name, 把逻辑从magickey 移过来
1711   function() public payable {
1712      require(boxPrice > 0, 'this mode is not supported');
1713      require(msg.value == boxPrice);  // must pay boxprice
1714      uint rand = SRNGInstance.getRandomFromBox();
1715      _openBox(msg.sender, rand);
1716   }
1717 
1718 
1719   function receiveApproval(address _from, uint _amount, address _tokenAddress, bytes _data) public {
1720    require(keyRequired > 0, 'this mode is not supported');
1721    require(_tokenAddress == keyAddress); // only accept key.
1722    require(_amount == keyRequired); // need to send required amount;
1723    require(StandardToken(_tokenAddress).transferFrom(_from, address(this), _amount));
1724    uint rand = SRNGInstance.getRandomFromBox();
1725    _openBox(_from, rand);
1726   }
1727 
1728 
1729   function withDrawToken(uint _amount) public onlyCFO {
1730     StandardToken(keyAddress).transfer(CFO, _amount);
1731   }
1732 
1733   function withDrawBalance(uint256 amount) public onlyCFO {
1734     require(address(this).balance >= amount);
1735     if (amount==0){
1736       CFO.transfer(address(this).balance);
1737     } else {
1738       CFO.transfer(amount);
1739     }
1740   }
1741 
1742   function setupBoxPrice(uint256 _boxPrice) public onlyOwner {
1743     boxPrice = _boxPrice;
1744   }
1745 
1746   function setupKeyRequired(uint256 _keyRequired) public onlyOwner {
1747     keyRequired = _keyRequired;
1748   }
1749 
1750   function setPrizePoolAddress(address _prizePoolAddress) public onlyOwner {
1751     prizePoolAddress = _prizePoolAddress;
1752   }
1753 
1754   function setGirlOps(address _girlAddress) public onlyOwner {
1755     girlOps = GirlOps(_girlAddress);
1756   }
1757 
1758   function setGenesFactory(address _genesFactoryAddress) public onlyOwner {
1759     genesFactory = GenesFactory(_genesFactoryAddress);
1760   }
1761 
1762   function setGirlByRarity(uint[] _tokenIds, uint _rarity) public onlyOwner {
1763       for(uint i=0; i<_tokenIds.length; i++) {
1764         if(_rarity == 0) {
1765           NCards.push(_tokenIds[i]);
1766         } else if(_rarity == 1) {
1767           RCards.push(_tokenIds[i]);
1768         } else if(_rarity == 2) {
1769           SRCards.push(_tokenIds[i]);
1770         } else if(_rarity == 3) {
1771           SSRCards.push(_tokenIds[i]);
1772         } else {
1773           revert();
1774         }
1775       }
1776   }
1777 
1778   function canOpen() public view returns (bool) {
1779     if(NCards.length > 0 && RCards.length >0 && SRCards.length >0 && SSRCards.length >0) {
1780       return true;
1781     }else{
1782       return false;
1783     }
1784   }
1785 
1786 }