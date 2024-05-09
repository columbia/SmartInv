1 pragma solidity ^0.4.21;
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