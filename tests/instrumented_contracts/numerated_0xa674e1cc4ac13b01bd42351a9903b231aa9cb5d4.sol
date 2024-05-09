1 pragma solidity ^0.5.0;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  C:\github\privateCode\retroArt\reactWebsite\contracts\RetroArtStemToken.sol
6 // flattened :  Monday, 22-Apr-19 22:14:31 UTC
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    * @notice Renouncing to ownership will leave the contract without an owner.
83    * It will not be possible to call the functions with the `onlyOwner`
84    * modifier anymore.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address _newOwner) public onlyOwner {
96     _transferOwnership(_newOwner);
97   }
98 
99   /**
100    * @dev Transfers control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function _transferOwnership(address _newOwner) internal {
104     require(_newOwner != address(0));
105     emit OwnershipTransferred(owner, _newOwner);
106     owner = _newOwner;
107   }
108 }
109 
110 interface ERC165 {
111 
112   /**
113    * @notice Query if a contract implements an interface
114    * @param _interfaceId The interface identifier, as specified in ERC-165
115    * @dev Interface identification is specified in ERC-165. This function
116    * uses less than 30,000 gas.
117    */
118   function supportsInterface(bytes4 _interfaceId)
119     external
120     view
121     returns (bool);
122 }
123 
124 contract ERC20Basic {
125   function totalSupply() public view returns (uint256);
126   function balanceOf(address _who) public view returns (uint256);
127   function transfer(address _to, uint256 _value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 library AddressUtils {
132 
133   /**
134    * Returns whether the target address is a contract
135    * @dev This function will return false if invoked during the constructor of a contract,
136    * as the code is not actually created until after the constructor finishes.
137    * @param _addr address to check
138    * @return whether the target address is a contract
139    */
140   function isContract(address _addr) internal view returns (bool) {
141     uint256 size;
142     // XXX Currently there is no better way to check if there is a contract in an address
143     // than to check the size of the code at that address.
144     // See https://ethereum.stackexchange.com/a/14016/36603
145     // for more details about how this works.
146     // TODO Check this again before the Serenity release, because all addresses will be
147     // contracts then.
148     // solium-disable-next-line security/no-inline-assembly
149     assembly { size := extcodesize(_addr) }
150     return size > 0;
151   }
152 
153 }
154 
155 contract ERC721Receiver {
156   /**
157    * @dev Magic value to be returned upon successful reception of an NFT
158    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
159    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
160    */
161   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
162 
163   /**
164    * @notice Handle the receipt of an NFT
165    * @dev The ERC721 smart contract calls this function on the recipient
166    * after a `safetransfer`. This function MAY throw to revert and reject the
167    * transfer. Return of other than the magic value MUST result in the
168    * transaction being reverted.
169    * Note: the contract address is always the message sender.
170    * @param _operator The address which called `safeTransferFrom` function
171    * @param _from The address which previously owned the token
172    * @param _tokenId The NFT identifier which is being transferred
173    * @param _data Additional data with no specified format
174    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
175    */
176   function onERC721Received(
177     address _operator,
178     address _from,
179     uint256 _tokenId,
180     bytes memory _data 
181   )
182     public
183     returns(bytes4);
184 }
185 
186 library RecordKeeping {
187     struct priceRecord {
188         uint256 price;
189         address owner;
190         uint256 timestamp;
191 
192     }
193 }
194 contract ERC721Basic is ERC165 {
195 
196   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
197   /*
198    * 0x80ac58cd ===
199    *   bytes4(keccak256('balanceOf(address)')) ^
200    *   bytes4(keccak256('ownerOf(uint256)')) ^
201    *   bytes4(keccak256('approve(address,uint256)')) ^
202    *   bytes4(keccak256('getApproved(uint256)')) ^
203    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
204    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
205    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
206    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
207    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
208    */
209 
210   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
211   /*
212    * 0x4f558e79 ===
213    *   bytes4(keccak256('exists(uint256)'))
214    */
215 
216   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
217   /**
218    * 0x780e9d63 ===
219    *   bytes4(keccak256('totalSupply()')) ^
220    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
221    *   bytes4(keccak256('tokenByIndex(uint256)'))
222    */
223 
224   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
225   /**
226    * 0x5b5e139f ===
227    *   bytes4(keccak256('name()')) ^
228    *   bytes4(keccak256('symbol()')) ^
229    *   bytes4(keccak256('tokenURI(uint256)'))
230    */
231 
232   event Transfer(
233     address indexed _from,
234     address indexed _to,
235     uint256 indexed _tokenId
236   );
237   event Approval(
238     address indexed _owner,
239     address indexed _approved,
240     uint256 indexed _tokenId
241   );
242   event ApprovalForAll(
243     address indexed _owner,
244     address indexed _operator,
245     bool _approved
246   );
247 
248   function balanceOf(address _owner) public view returns (uint256 _balance);
249   function ownerOf(uint256 _tokenId) public view returns (address _owner);
250   function exists(uint256 _tokenId) public view returns (bool _exists);
251 
252   function approve(address _to, uint256 _tokenId) public;
253   function getApproved(uint256 _tokenId)
254     public view returns (address _operator);
255 
256   function setApprovalForAll(address _operator, bool _approved) public;
257   function isApprovedForAll(address _owner, address _operator)
258     public view returns (bool);
259 
260   function transferFrom(address _from, address _to, uint256 _tokenId) public;
261   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
262     public;
263 
264   function safeTransferFrom(
265     address _from,
266     address _to,
267     uint256 _tokenId,
268     bytes memory _data 
269   )
270     public;
271 }
272 
273 contract SupportsInterfaceWithLookup is ERC165 {
274 
275   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
276   /**
277    * 0x01ffc9a7 ===
278    *   bytes4(keccak256('supportsInterface(bytes4)'))
279    */
280 
281   /**
282    * @dev a mapping of interface id to whether or not it's supported
283    */
284   mapping(bytes4 => bool) internal supportedInterfaces;
285 
286   /**
287    * @dev A contract implementing SupportsInterfaceWithLookup
288    * implement ERC165 itself
289    */
290   constructor()
291     public
292   {
293     _registerInterface(InterfaceId_ERC165);
294   }
295 
296   /**
297    * @dev implement supportsInterface(bytes4) using a lookup table
298    */
299   function supportsInterface(bytes4 _interfaceId)
300     external
301     view
302     returns (bool)
303   {
304     return supportedInterfaces[_interfaceId];
305   }
306 
307   /**
308    * @dev private method for registering an interface
309    */
310   function _registerInterface(bytes4 _interfaceId)
311     internal
312   {
313     require(_interfaceId != 0xffffffff);
314     supportedInterfaces[_interfaceId] = true;
315   }
316 }
317 
318 contract Withdrawable  is Ownable {
319     
320     // _changeType is used to indicate the type of the transaction
321     // 0 - normal withdraw 
322     // 1 - deposit from selling asset
323     // 2 - deposit from profit sharing of new token
324     // 3 - deposit from auction
325     // 4 - failed auction refund
326     // 5 - referral commission
327 
328     event BalanceChanged(address indexed _owner, int256 _change,  uint256 _balance, uint8 _changeType);
329   
330     mapping (address => uint256) internal pendingWithdrawals;
331   
332     //total pending amount
333     uint256 internal totalPendingAmount;
334 
335     function _deposit(address addressToDeposit, uint256 amount, uint8 changeType) internal{      
336         if (amount > 0) {
337             _depositWithoutEvent(addressToDeposit, amount);
338             emit BalanceChanged(addressToDeposit, int256(amount), pendingWithdrawals[addressToDeposit], changeType);
339         }
340     }
341 
342     function _depositWithoutEvent(address addressToDeposit, uint256 amount) internal{
343         pendingWithdrawals[addressToDeposit] += amount;
344         totalPendingAmount += amount;       
345     }
346 
347     function getBalance(address addressToCheck) public view returns (uint256){
348         return pendingWithdrawals[addressToCheck];
349     }
350 
351     function withdrawOwnFund(address payable recipient_address) public {
352         require(msg.sender==recipient_address);
353 
354         uint amount = pendingWithdrawals[recipient_address];
355         require(amount > 0);
356         // Remember to zero the pending refund before
357         // sending to prevent re-entrancy attacks
358         pendingWithdrawals[recipient_address] = 0;
359         totalPendingAmount -= amount;
360         recipient_address.transfer(amount);
361         emit BalanceChanged(recipient_address, -1 * int256(amount),  0, 0);
362     }
363 
364     function checkAvailableContractBalance() public view returns (uint256){
365         if (address(this).balance > totalPendingAmount){
366             return address(this).balance - totalPendingAmount;
367         } else{
368             return 0;
369         }
370     }
371     function withdrawContractFund(address payable recipient_address) public onlyOwner  {
372         uint256 amountToWithdraw = checkAvailableContractBalance();
373         if (amountToWithdraw > 0){
374             recipient_address.transfer(amountToWithdraw);
375         }
376     }
377 } 
378 contract ERC20 is ERC20Basic {
379   function allowance(address _owner, address _spender)
380     public view returns (uint256);
381 
382   function transferFrom(address _from, address _to, uint256 _value)
383     public returns (bool);
384 
385   function approve(address _spender, uint256 _value) public returns (bool);
386   event Approval(
387     address indexed owner,
388     address indexed spender,
389     uint256 value
390   );
391 }
392 
393 contract BasicToken is ERC20Basic {
394   using SafeMath for uint256;
395 
396   mapping(address => uint256) internal balances;
397 
398   uint256 internal totalSupply_;
399 
400   /**
401   * @dev Total number of tokens in existence
402   */
403   function totalSupply() public view returns (uint256) {
404     return totalSupply_;
405   }
406 
407   /**
408   * @dev Transfer token for a specified address
409   * @param _to The address to transfer to.
410   * @param _value The amount to be transferred.
411   */
412   function transfer(address _to, uint256 _value) public returns (bool) {
413     require(_value <= balances[msg.sender]);
414     require(_to != address(0));
415 
416     balances[msg.sender] = balances[msg.sender].sub(_value);
417     balances[_to] = balances[_to].add(_value);
418     emit Transfer(msg.sender, _to, _value);
419     return true;
420   }
421 
422   /**
423   * @dev Gets the balance of the specified address.
424   * @param _owner The address to query the the balance of.
425   * @return An uint256 representing the amount owned by the passed address.
426   */
427   function balanceOf(address _owner) public view returns (uint256) {
428     return balances[_owner];
429   }
430 
431 }
432 
433 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
434 
435   using SafeMath for uint256;
436   using AddressUtils for address;
437 
438   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
439   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
440   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
441 
442   // Mapping from token ID to owner
443   mapping (uint256 => address) internal tokenOwner;
444 
445   // Mapping from token ID to approved address
446   mapping (uint256 => address) internal tokenApprovals;
447 
448   // Mapping from owner to number of owned token
449   mapping (address => uint256) internal ownedTokensCount;
450 
451   // Mapping from owner to operator approvals
452   mapping (address => mapping (address => bool)) internal operatorApprovals;
453 
454   constructor()
455     public
456   {
457     // register the supported interfaces to conform to ERC721 via ERC165
458     _registerInterface(InterfaceId_ERC721);
459     _registerInterface(InterfaceId_ERC721Exists);
460   }
461 
462   /**
463    * @dev Gets the balance of the specified address
464    * @param _owner address to query the balance of
465    * @return uint256 representing the amount owned by the passed address
466    */
467   function balanceOf(address _owner) public view returns (uint256) {
468     require(_owner != address(0));
469     return ownedTokensCount[_owner];
470   }
471 
472   /**
473    * @dev Gets the owner of the specified token ID
474    * @param _tokenId uint256 ID of the token to query the owner of
475    * @return owner address currently marked as the owner of the given token ID
476    */
477   function ownerOf(uint256 _tokenId) public view returns (address) {
478     address owner = tokenOwner[_tokenId];
479     require(owner != address(0));
480     return owner;
481   }
482 
483   /**
484    * @dev Returns whether the specified token exists
485    * @param _tokenId uint256 ID of the token to query the existence of
486    * @return whether the token exists
487    */
488   function exists(uint256 _tokenId) public view returns (bool) {
489     address owner = tokenOwner[_tokenId];
490     return owner != address(0);
491   }
492 
493   /**
494    * @dev Approves another address to transfer the given token ID
495    * The zero address indicates there is no approved address.
496    * There can only be one approved address per token at a given time.
497    * Can only be called by the token owner or an approved operator.
498    * @param _to address to be approved for the given token ID
499    * @param _tokenId uint256 ID of the token to be approved
500    */
501   function approve(address _to, uint256 _tokenId) public {
502     address owner = ownerOf(_tokenId);
503     require(_to != owner);
504     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
505 
506     tokenApprovals[_tokenId] = _to;
507     emit Approval(owner, _to, _tokenId);
508   }
509 
510   /**
511    * @dev Gets the approved address for a token ID, or zero if no address set
512    * @param _tokenId uint256 ID of the token to query the approval of
513    * @return address currently approved for the given token ID
514    */
515   function getApproved(uint256 _tokenId) public view returns (address) {
516     return tokenApprovals[_tokenId];
517   }
518 
519   /**
520    * @dev Sets or unsets the approval of a given operator
521    * An operator is allowed to transfer all tokens of the sender on their behalf
522    * @param _to operator address to set the approval
523    * @param _approved representing the status of the approval to be set
524    */
525   function setApprovalForAll(address _to, bool _approved) public {
526     require(_to != msg.sender);
527     operatorApprovals[msg.sender][_to] = _approved;
528     emit ApprovalForAll(msg.sender, _to, _approved);
529   }
530 
531   /**
532    * @dev Tells whether an operator is approved by a given owner
533    * @param _owner owner address which you want to query the approval of
534    * @param _operator operator address which you want to query the approval of
535    * @return bool whether the given operator is approved by the given owner
536    */
537   function isApprovedForAll(
538     address _owner,
539     address _operator
540   )
541     public
542     view
543     returns (bool)
544   {
545     return operatorApprovals[_owner][_operator];
546   }
547 
548   /**
549    * @dev Transfers the ownership of a given token ID to another address
550    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
551    * Requires the msg sender to be the owner, approved, or operator
552    * @param _from current owner of the token
553    * @param _to address to receive the ownership of the given token ID
554    * @param _tokenId uint256 ID of the token to be transferred
555   */
556   function transferFrom(
557     address _from,
558     address _to,
559     uint256 _tokenId
560   )
561     public
562   {
563     require(isApprovedOrOwner(msg.sender, _tokenId));
564     require(_from != address(0));
565     require(_to != address(0));
566 
567     clearApproval(_from, _tokenId);
568     removeTokenFrom(_from, _tokenId);
569     addTokenTo(_to, _tokenId);
570 
571     emit Transfer(_from, _to, _tokenId);
572   }
573 
574   /**
575    * @dev Safely transfers the ownership of a given token ID to another address
576    * If the target address is a contract, it must implement `onERC721Received`,
577    * which is called upon a safe transfer, and return the magic value
578    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
579    * the transfer is reverted.
580    *
581    * Requires the msg sender to be the owner, approved, or operator
582    * @param _from current owner of the token
583    * @param _to address to receive the ownership of the given token ID
584    * @param _tokenId uint256 ID of the token to be transferred
585   */
586   function safeTransferFrom(
587     address _from,
588     address _to,
589     uint256 _tokenId
590   )
591     public
592   {
593     // solium-disable-next-line arg-overflow
594     safeTransferFrom(_from, _to, _tokenId, "");
595   }
596 
597   /**
598    * @dev Safely transfers the ownership of a given token ID to another address
599    * If the target address is a contract, it must implement `onERC721Received`,
600    * which is called upon a safe transfer, and return the magic value
601    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
602    * the transfer is reverted.
603    * Requires the msg sender to be the owner, approved, or operator
604    * @param _from current owner of the token
605    * @param _to address to receive the ownership of the given token ID
606    * @param _tokenId uint256 ID of the token to be transferred
607    * @param _data bytes data to send along with a safe transfer check
608    */
609   function safeTransferFrom(
610     address _from,
611     address _to,
612     uint256 _tokenId,
613     bytes memory _data
614   )
615     public
616   {
617     transferFrom(_from, _to, _tokenId);
618     // solium-disable-next-line arg-overflow
619     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
620   }
621 
622   /**
623    * @dev Returns whether the given spender can transfer a given token ID
624    * @param _spender address of the spender to query
625    * @param _tokenId uint256 ID of the token to be transferred
626    * @return bool whether the msg.sender is approved for the given token ID,
627    *  is an operator of the owner, or is the owner of the token
628    */
629   function isApprovedOrOwner(
630     address _spender,
631     uint256 _tokenId
632   )
633     internal
634     view
635     returns (bool)
636   {
637     address owner = ownerOf(_tokenId);
638     // Disable solium check because of
639     // https://github.com/duaraghav8/Solium/issues/175
640     // solium-disable-next-line operator-whitespace
641     return (
642       _spender == owner ||
643       getApproved(_tokenId) == _spender ||
644       isApprovedForAll(owner, _spender)
645     );
646   }
647 
648   /**
649    * @dev Internal function to mint a new token
650    * Reverts if the given token ID already exists
651    * @param _to The address that will own the minted token
652    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
653    */
654   function _mint(address _to, uint256 _tokenId) internal {
655     require(_to != address(0));
656     addTokenTo(_to, _tokenId);
657     emit Transfer(address(0), _to, _tokenId);
658   }
659 
660   /**
661    * @dev Internal function to burn a specific token
662    * Reverts if the token does not exist
663    * @param _tokenId uint256 ID of the token being burned by the msg.sender
664    */
665   function _burn(address _owner, uint256 _tokenId) internal {
666     clearApproval(_owner, _tokenId);
667     removeTokenFrom(_owner, _tokenId);
668     emit Transfer(_owner, address(0), _tokenId);
669   }
670 
671   /**
672    * @dev Internal function to clear current approval of a given token ID
673    * Reverts if the given address is not indeed the owner of the token
674    * @param _owner owner of the token
675    * @param _tokenId uint256 ID of the token to be transferred
676    */
677   function clearApproval(address _owner, uint256 _tokenId) internal {
678     require(ownerOf(_tokenId) == _owner);
679     if (tokenApprovals[_tokenId] != address(0)) {
680       tokenApprovals[_tokenId] = address(0);
681     }
682   }
683 
684   /**
685    * @dev Internal function to add a token ID to the list of a given address
686    * @param _to address representing the new owner of the given token ID
687    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
688    */
689   function addTokenTo(address _to, uint256 _tokenId) internal {
690     require(tokenOwner[_tokenId] == address(0));
691     tokenOwner[_tokenId] = _to;
692     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
693   }
694 
695   /**
696    * @dev Internal function to remove a token ID from the list of a given address
697    * @param _from address representing the previous owner of the given token ID
698    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
699    */
700   function removeTokenFrom(address _from, uint256 _tokenId) internal {
701     require(ownerOf(_tokenId) == _from);
702     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
703     tokenOwner[_tokenId] = address(0);
704   }
705 
706   /**
707    * @dev Internal function to invoke `onERC721Received` on a target address
708    * The call is not executed if the target address is not a contract
709    * @param _from address representing the previous owner of the given token ID
710    * @param _to target address that will receive the tokens
711    * @param _tokenId uint256 ID of the token to be transferred
712    * @param _data bytes optional data to send along with the call
713    * @return whether the call correctly returned the expected magic value
714    */
715   function checkAndCallSafeTransfer(
716     address _from,
717     address _to,
718     uint256 _tokenId,
719     bytes memory _data
720   )
721     internal
722     returns (bool)
723   {
724     if (!_to.isContract()) {
725       return true;
726     }
727     bytes4 retval = ERC721Receiver(_to).onERC721Received(
728       msg.sender, _from, _tokenId, _data);
729     return (retval == ERC721_RECEIVED);
730   }
731 }
732 
733 contract ERC721Enumerable is ERC721Basic {
734   function totalSupply() public view returns (uint256);
735   function tokenOfOwnerByIndex(
736     address _owner,
737     uint256 _index
738   )
739     public
740     view
741     returns (uint256 _tokenId);
742 
743   function tokenByIndex(uint256 _index) public view returns (uint256);
744 }
745 
746 
747 /**
748  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
749  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
750  */
751 contract ERC721Metadata is ERC721Basic {
752   function name() external view returns (string memory _name);
753   function symbol() external view returns (string memory _symbol);
754   function tokenURI(uint256 _tokenId) public view returns (string memory);
755 }
756 
757 
758 /**
759  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
760  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
761  */
762 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
763 }
764 
765 contract StandardToken is ERC20, BasicToken {
766 
767   mapping (address => mapping (address => uint256)) internal allowed;
768 
769 
770   /**
771    * @dev Transfer tokens from one address to another
772    * @param _from address The address which you want to send tokens from
773    * @param _to address The address which you want to transfer to
774    * @param _value uint256 the amount of tokens to be transferred
775    */
776   function transferFrom(
777     address _from,
778     address _to,
779     uint256 _value
780   )
781     public
782     returns (bool)
783   {
784     require(_value <= balances[_from]);
785     require(_value <= allowed[_from][msg.sender]);
786     require(_to != address(0));
787 
788     balances[_from] = balances[_from].sub(_value);
789     balances[_to] = balances[_to].add(_value);
790     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
791     emit Transfer(_from, _to, _value);
792     return true;
793   }
794 
795   /**
796    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
797    * Beware that changing an allowance with this method brings the risk that someone may use both the old
798    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
799    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
800    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
801    * @param _spender The address which will spend the funds.
802    * @param _value The amount of tokens to be spent.
803    */
804   function approve(address _spender, uint256 _value) public returns (bool) {
805     allowed[msg.sender][_spender] = _value;
806     emit Approval(msg.sender, _spender, _value);
807     return true;
808   }
809 
810   /**
811    * @dev Function to check the amount of tokens that an owner allowed to a spender.
812    * @param _owner address The address which owns the funds.
813    * @param _spender address The address which will spend the funds.
814    * @return A uint256 specifying the amount of tokens still available for the spender.
815    */
816   function allowance(
817     address _owner,
818     address _spender
819    )
820     public
821     view
822     returns (uint256)
823   {
824     return allowed[_owner][_spender];
825   }
826 
827   /**
828    * @dev Increase the amount of tokens that an owner allowed to a spender.
829    * approve should be called when allowed[_spender] == 0. To increment
830    * allowed value is better to use this function to avoid 2 calls (and wait until
831    * the first transaction is mined)
832    * From MonolithDAO Token.sol
833    * @param _spender The address which will spend the funds.
834    * @param _addedValue The amount of tokens to increase the allowance by.
835    */
836   function increaseApproval(
837     address _spender,
838     uint256 _addedValue
839   )
840     public
841     returns (bool)
842   {
843     allowed[msg.sender][_spender] = (
844       allowed[msg.sender][_spender].add(_addedValue));
845     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
846     return true;
847   }
848 
849   /**
850    * @dev Decrease the amount of tokens that an owner allowed to a spender.
851    * approve should be called when allowed[_spender] == 0. To decrement
852    * allowed value is better to use this function to avoid 2 calls (and wait until
853    * the first transaction is mined)
854    * From MonolithDAO Token.sol
855    * @param _spender The address which will spend the funds.
856    * @param _subtractedValue The amount of tokens to decrease the allowance by.
857    */
858   function decreaseApproval(
859     address _spender,
860     uint256 _subtractedValue
861   )
862     public
863     returns (bool)
864   {
865     uint256 oldValue = allowed[msg.sender][_spender];
866     if (_subtractedValue >= oldValue) {
867       allowed[msg.sender][_spender] = 0;
868     } else {
869       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
870     }
871     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
872     return true;
873   }
874 
875 }
876 
877 contract ERC721WithState is ERC721BasicToken {
878     mapping (uint256 => uint8) internal tokenState;
879 
880     event TokenStateSet(uint256 indexed _tokenId,  uint8 _state);
881 
882     function setTokenState(uint256  _tokenId,  uint8 _state) public  {
883         require(isApprovedOrOwner(msg.sender, _tokenId));
884         require(exists(_tokenId)); 
885         tokenState[_tokenId] = _state;      
886         emit TokenStateSet(_tokenId, _state);
887     }
888 
889     function getTokenState(uint256  _tokenId) public view returns (uint8){
890         require(exists(_tokenId));
891         return tokenState[_tokenId];
892     } 
893 
894 
895 }
896 contract BurnableToken is BasicToken {
897 
898   event Burn(address indexed burner, uint256 value);
899 
900   /**
901    * @dev Burns a specific amount of tokens.
902    * @param _value The amount of token to be burned.
903    */
904   function burn(uint256 _value) public {
905     _burn(msg.sender, _value);
906   }
907 
908   function _burn(address _who, uint256 _value) internal {
909     require(_value <= balances[_who]);
910     // no need to require value <= totalSupply, since that would imply the
911     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
912 
913     balances[_who] = balances[_who].sub(_value);
914     totalSupply_ = totalSupply_.sub(_value);
915     emit Burn(_who, _value);
916     emit Transfer(_who, address(0), _value);
917   }
918 }
919 
920 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
921 
922   // Token name
923   string internal name_;
924 
925   // Token symbol
926   string internal symbol_;
927 
928   // Mapping from owner to list of owned token IDs
929   mapping(address => uint256[]) internal ownedTokens;
930 
931   // Mapping from token ID to index of the owner tokens list
932   mapping(uint256 => uint256) internal ownedTokensIndex;
933 
934   // Array with all token ids, used for enumeration
935   uint256[] internal allTokens;
936 
937   // Mapping from token id to position in the allTokens array
938   mapping(uint256 => uint256) internal allTokensIndex;
939 
940   // Optional mapping for token URIs
941   mapping(uint256 => string) internal tokenURIs;
942 
943   /**
944    * @dev Constructor function
945    */
946   constructor(string memory _name, string memory _symbol) public {
947     name_ = _name;
948     symbol_ = _symbol;
949 
950     // register the supported interfaces to conform to ERC721 via ERC165
951     _registerInterface(InterfaceId_ERC721Enumerable);
952     _registerInterface(InterfaceId_ERC721Metadata);
953   }
954 
955   /**
956    * @dev Gets the token name
957    * @return string representing the token name
958    */
959   function name() external view returns (string memory) {
960     return name_;
961   }
962 
963   /**
964    * @dev Gets the token symbol
965    * @return string representing the token symbol
966    */
967   function symbol() external view returns (string memory) {
968     return symbol_;
969   }
970 
971   /**
972    * @dev Returns an URI for a given token ID
973    * Throws if the token ID does not exist. May return an empty string.
974    * @param _tokenId uint256 ID of the token to query
975    */
976   function tokenURI(uint256 _tokenId) public view returns (string memory) {
977     require(exists(_tokenId));
978     return tokenURIs[_tokenId];
979   }
980 
981   /**
982    * @dev Gets the token ID at a given index of the tokens list of the requested owner
983    * @param _owner address owning the tokens list to be accessed
984    * @param _index uint256 representing the index to be accessed of the requested tokens list
985    * @return uint256 token ID at the given index of the tokens list owned by the requested address
986    */
987   function tokenOfOwnerByIndex(
988     address _owner,
989     uint256 _index
990   )
991     public
992     view
993     returns (uint256)
994   {
995     require(_index < balanceOf(_owner));
996     return ownedTokens[_owner][_index];
997   }
998 
999   /**
1000    * @dev Gets the total amount of tokens stored by the contract
1001    * @return uint256 representing the total amount of tokens
1002    */
1003   function totalSupply() public view returns (uint256) {
1004     return allTokens.length;
1005   }
1006 
1007   /**
1008    * @dev Gets the token ID at a given index of all the tokens in this contract
1009    * Reverts if the index is greater or equal to the total number of tokens
1010    * @param _index uint256 representing the index to be accessed of the tokens list
1011    * @return uint256 token ID at the given index of the tokens list
1012    */
1013   function tokenByIndex(uint256 _index) public view returns (uint256) {
1014     require(_index < totalSupply());
1015     return allTokens[_index];
1016   }
1017 
1018   /**
1019    * @dev Internal function to set the token URI for a given token
1020    * Reverts if the token ID does not exist
1021    * @param _tokenId uint256 ID of the token to set its URI
1022    * @param _uri string URI to assign
1023    */
1024   function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
1025     require(exists(_tokenId));
1026     tokenURIs[_tokenId] = _uri;
1027   }
1028 
1029   /**
1030    * @dev Internal function to add a token ID to the list of a given address
1031    * @param _to address representing the new owner of the given token ID
1032    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1033    */
1034   function addTokenTo(address _to, uint256 _tokenId) internal {
1035     super.addTokenTo(_to, _tokenId);
1036     uint256 length = ownedTokens[_to].length;
1037     ownedTokens[_to].push(_tokenId);
1038     ownedTokensIndex[_tokenId] = length;
1039   }
1040 
1041   /**
1042    * @dev Internal function to remove a token ID from the list of a given address
1043    * @param _from address representing the previous owner of the given token ID
1044    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1045    */
1046   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1047     super.removeTokenFrom(_from, _tokenId);
1048 
1049     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1050     // then delete the last slot.
1051     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1052     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1053     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1054 
1055     ownedTokens[_from][tokenIndex] = lastToken;
1056     // This also deletes the contents at the last position of the array
1057     ownedTokens[_from].length--;
1058 
1059     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1060     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1061     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1062 
1063     ownedTokensIndex[_tokenId] = 0;
1064     ownedTokensIndex[lastToken] = tokenIndex;
1065   }
1066 
1067   /**
1068    * @dev Internal function to mint a new token
1069    * Reverts if the given token ID already exists
1070    * @param _to address the beneficiary that will own the minted token
1071    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1072    */
1073   function _mint(address _to, uint256 _tokenId) internal {
1074     super._mint(_to, _tokenId);
1075 
1076     allTokensIndex[_tokenId] = allTokens.length;
1077     allTokens.push(_tokenId);
1078   }
1079 
1080   /**
1081    * @dev Internal function to burn a specific token
1082    * Reverts if the token does not exist
1083    * @param _owner owner of the token to burn
1084    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1085    */
1086   function _burn(address _owner, uint256 _tokenId) internal {
1087     super._burn(_owner, _tokenId);
1088 
1089     // Clear metadata (if any)
1090     if (bytes(tokenURIs[_tokenId]).length != 0) {
1091       delete tokenURIs[_tokenId];
1092     }
1093 
1094     // Reorg all tokens array
1095     uint256 tokenIndex = allTokensIndex[_tokenId];
1096     uint256 lastTokenIndex = allTokens.length.sub(1);
1097     uint256 lastToken = allTokens[lastTokenIndex];
1098 
1099     allTokens[tokenIndex] = lastToken;
1100     allTokens[lastTokenIndex] = 0;
1101 
1102     allTokens.length--;
1103     allTokensIndex[_tokenId] = 0;
1104     allTokensIndex[lastToken] = tokenIndex;
1105   }
1106 
1107 }
1108 
1109 contract MintableToken is StandardToken, Ownable {
1110   event Mint(address indexed to, uint256 amount);
1111   event MintFinished();
1112 
1113   bool public mintingFinished = false;
1114 
1115 
1116   modifier canMint() {
1117     require(!mintingFinished);
1118     _;
1119   }
1120 
1121   modifier hasMintPermission() {
1122     require(msg.sender == owner);
1123     _;
1124   }
1125 
1126   /**
1127    * @dev Function to mint tokens
1128    * @param _to The address that will receive the minted tokens.
1129    * @param _amount The amount of tokens to mint.
1130    * @return A boolean that indicates if the operation was successful.
1131    */
1132   function mint(
1133     address _to,
1134     uint256 _amount
1135   )
1136     public
1137     hasMintPermission
1138     canMint
1139     returns (bool)
1140   {
1141     totalSupply_ = totalSupply_.add(_amount);
1142     balances[_to] = balances[_to].add(_amount);
1143     emit Mint(_to, _amount);
1144     emit Transfer(address(0), _to, _amount);
1145     return true;
1146   }
1147 
1148   /**
1149    * @dev Function to stop minting new tokens.
1150    * @return True if the operation was successful.
1151    */
1152   function finishMinting() public onlyOwner canMint returns (bool) {
1153     mintingFinished = true;
1154     emit MintFinished();
1155     return true;
1156   }
1157 }
1158 
1159 contract StandardBurnableToken is BurnableToken, StandardToken {
1160 
1161   /**
1162    * @dev Burns a specific amount of tokens from the target address and decrements allowance
1163    * @param _from address The address which you want to send tokens from
1164    * @param _value uint256 The amount of token to be burned
1165    */
1166   function burnFrom(address _from, uint256 _value) public {
1167     require(_value <= allowed[_from][msg.sender]);
1168     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1169     // this function needs to emit an event with the updated approval.
1170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1171     _burn(_from, _value);
1172   }
1173 }
1174 
1175 contract RetroArt is ERC721Token, Ownable, Withdrawable, ERC721WithState {
1176     
1177     address public stemTokenContractAddress; 
1178     uint256 public currentPrice;
1179     uint256 constant initiailPrice = 0.03 ether;
1180     //new asset price increase at the rate that determined by the variable below
1181     //it is caculated from the current price + (current price / ( price rate * totalTokens / slowDownRate ))
1182     uint public priceRate = 10;
1183     uint public slowDownRate = 7;
1184     //Commission will be charged if a profit is made
1185     //Commission is the pure profit / profit Commission  
1186     // measured in basis points (1/100 of a percent) 
1187     // Values 0-10,000 map to 0%-100%
1188     uint public profitCommission = 500;
1189 
1190     //the referral percentage of the commission of selling of aset
1191     // measured in basis points (1/100 of a percent) 
1192     // Values 0-10,000 map to 0%-100%
1193     uint public referralCommission = 3000;
1194 
1195     //share will be given to all tokens equally if a new asset is acquired. 
1196     //the amount of total shared value is assetValue/sharePercentage   
1197     // measured in basis points (1/100 of a percent) 
1198     // Values 0-10,000 map to 0%-100%
1199     uint public sharePercentage = 3000;
1200 
1201     //number of shares for acquiring new asset. 
1202     uint public numberOfShares = 10;
1203 
1204     string public uriPrefix ="";
1205 
1206 
1207     // Mapping from owner to list of owned token IDs
1208     mapping (uint256 => string) internal tokenTitles;
1209     mapping (uint256 => RecordKeeping.priceRecord) internal initialPriceRecords;
1210     mapping (uint256 => RecordKeeping.priceRecord) internal lastPriceRecords;
1211     mapping (uint256 => uint256) internal currentTokenPrices;
1212 
1213 
1214     event AssetAcquired(address indexed _owner, uint256 indexed _tokenId, string  _title, uint256 _price);
1215     event TokenPriceSet(uint256 indexed _tokenId,  uint256 _price);
1216     event TokenBrought(address indexed _from, address indexed _to, uint256 indexed _tokenId, uint256 _price);
1217     event PriceRateChanged(uint _priceRate);
1218     event SlowDownRateChanged(uint _slowDownRate);
1219     event ProfitCommissionChanged(uint _profitCommission);
1220     event MintPriceChanged(uint256 _price);
1221     event SharePercentageChanged(uint _sharePercentage);
1222     event NumberOfSharesChanged(uint _numberOfShares);
1223     event ReferralCommissionChanged(uint _referralCommission);
1224     event Burn(address indexed _owner, uint256 _tokenId);
1225 
1226    
1227 
1228     bytes4 private constant InterfaceId_RetroArt = 0x94fb30be;
1229     /*
1230     bytes4(keccak256("buyTokenFrom(address,address,uint256)"))^
1231     bytes4(keccak256("setTokenPrice(uint256,uint256)"))^
1232     bytes4(keccak256("setTokenState(uint256,uint8)"))^
1233     bytes4(keccak256("getTokenState(uint256)"));
1234     */
1235 
1236     address[] internal auctionContractAddresses;
1237  
1238    
1239 
1240     function tokenTitle(uint256 _tokenId) public view returns (string memory) {
1241         require(exists(_tokenId));
1242         return tokenTitles[_tokenId];
1243     }
1244     function lastPriceOf(uint256 _tokenId) public view returns (uint256) {
1245         require(exists(_tokenId));
1246         return  lastPriceRecords[_tokenId].price;
1247     }   
1248 
1249     function lastTransactionTimeOf(uint256 _tokenId) public view returns (uint256) {
1250         require(exists(_tokenId));
1251         return  lastPriceRecords[_tokenId].timestamp;
1252     }
1253 
1254     function firstPriceOf(uint256 _tokenId) public view returns (uint256) {
1255         require(exists(_tokenId));
1256         return  initialPriceRecords[_tokenId].price;
1257     }   
1258     function creatorOf(uint256 _tokenId) public view returns (address) {
1259         require(exists(_tokenId));
1260         return  initialPriceRecords[_tokenId].owner;
1261     }
1262     function firstTransactionTimeOf(uint256 _tokenId) public view returns (uint256) {
1263         require(exists(_tokenId));
1264         return  initialPriceRecords[_tokenId].timestamp;
1265     }
1266     
1267   
1268     //problem with current web3.js that can't return an array of struct
1269     function lastHistoryOf(uint256 _tokenId) internal view returns (RecordKeeping.priceRecord storage) {
1270         require(exists(_tokenId));
1271         return lastPriceRecords[_tokenId];
1272     }
1273 
1274     function firstHistoryOf(uint256 _tokenId) internal view returns (RecordKeeping.priceRecord storage) {
1275         require(exists(_tokenId)); 
1276         return   initialPriceRecords[_tokenId];
1277     }
1278 
1279     function setPriceRate(uint _priceRate) public onlyOwner {
1280         priceRate = _priceRate;
1281         emit PriceRateChanged(priceRate);
1282     }
1283 
1284     function setSlowDownRate(uint _slowDownRate) public onlyOwner {
1285         slowDownRate = _slowDownRate;
1286         emit SlowDownRateChanged(slowDownRate);
1287     }
1288  
1289     function setprofitCommission(uint _profitCommission) public onlyOwner {
1290         require(_profitCommission <= 10000);
1291         profitCommission = _profitCommission;
1292         emit ProfitCommissionChanged(profitCommission);
1293     }
1294 
1295     function setSharePercentage(uint _sharePercentage) public onlyOwner  {
1296         require(_sharePercentage <= 10000);
1297         sharePercentage = _sharePercentage;
1298         emit SharePercentageChanged(sharePercentage);
1299     }
1300 
1301     function setNumberOfShares(uint _numberOfShares) public onlyOwner  {
1302         numberOfShares = _numberOfShares;
1303         emit NumberOfSharesChanged(numberOfShares);
1304     }
1305 
1306     function setReferralCommission(uint _referralCommission) public onlyOwner  {
1307         require(_referralCommission <= 10000);
1308         referralCommission = _referralCommission;
1309         emit ReferralCommissionChanged(referralCommission);
1310     }
1311 
1312     function setUriPrefix(string memory _uri) public onlyOwner  {
1313        uriPrefix = _uri;
1314     }
1315   
1316     //use the token name, symbol as usual
1317     //this contract create another ERC20 as stemToken,
1318     //the constructure takes the stemTokenName and stemTokenSymbol
1319 
1320     constructor(string memory _name, string memory _symbol , address _stemTokenAddress) 
1321         ERC721Token(_name, _symbol) Ownable() public {
1322        
1323         currentPrice = initiailPrice;
1324         stemTokenContractAddress = _stemTokenAddress;
1325         _registerInterface(InterfaceId_RetroArt);
1326     }
1327 
1328     function getAllAssets() public view returns (uint256[] memory){
1329         return allTokens;
1330     }
1331 
1332     function getAllAssetsForSale() public view returns  (uint256[] memory){
1333       
1334         uint arrayLength = allTokens.length;
1335         uint forSaleCount = 0;
1336         for (uint i = 0; i<arrayLength; i++) {
1337             if (currentTokenPrices[allTokens[i]] > 0) {
1338                 forSaleCount++;              
1339             }
1340         }
1341         
1342         uint256[] memory tokensForSale = new uint256[](forSaleCount);
1343 
1344         uint j = 0;
1345         for (uint i = 0; i<arrayLength; i++) {
1346             if (currentTokenPrices[allTokens[i]] > 0) {                
1347                 tokensForSale[j] = allTokens[i];
1348                 j++;
1349             }
1350         }
1351 
1352         return tokensForSale;
1353     }
1354 
1355     function getAssetsForSale(address _owner) public view returns (uint256[] memory) {
1356       
1357         uint arrayLength = allTokens.length;
1358         uint forSaleCount = 0;
1359         for (uint i = 0; i<arrayLength; i++) {
1360             if (currentTokenPrices[allTokens[i]] > 0 && tokenOwner[allTokens[i]] == _owner) {
1361                 forSaleCount++;              
1362             }
1363         }
1364         
1365         uint256[] memory tokensForSale = new uint256[](forSaleCount);
1366 
1367         uint j = 0;
1368         for (uint i = 0; i<arrayLength; i++) {
1369             if (currentTokenPrices[allTokens[i]] > 0 && tokenOwner[allTokens[i]] == _owner) {                
1370                 tokensForSale[j] = allTokens[i];
1371                 j++;
1372             }
1373         }
1374 
1375         return tokensForSale;
1376     }
1377 
1378     function getAssetsByState(uint8 _state) public view returns (uint256[] memory){
1379         
1380         uint arrayLength = allTokens.length;
1381         uint matchCount = 0;
1382         for (uint i = 0; i<arrayLength; i++) {
1383             if (tokenState[allTokens[i]] == _state) {
1384                 matchCount++;              
1385             }
1386         }
1387         
1388         uint256[] memory matchedTokens = new uint256[](matchCount);
1389 
1390         uint j = 0;
1391         for (uint i = 0; i<arrayLength; i++) {
1392             if (tokenState[allTokens[i]] == _state) {                
1393                 matchedTokens[j] = allTokens[i];
1394                 j++;
1395             }
1396         }
1397 
1398         return matchedTokens;
1399     }
1400       
1401 
1402     function acquireAsset(uint256 _tokenId, string memory _title) public payable{
1403         acquireAssetWithReferral(_tokenId, _title, address(0));
1404     }
1405 
1406     function acquireAssetFromStemToken(address _tokenOwner, uint256 _tokenId, string calldata _title) external {     
1407          require(msg.sender == stemTokenContractAddress);
1408         _acquireAsset(_tokenId, _title, _tokenOwner, 0);
1409     }
1410 
1411     function acquireAssetWithReferral(uint256 _tokenId, string memory _title, address referralAddress) public payable{
1412         require(msg.value >= currentPrice);
1413         
1414         uint totalShares = numberOfShares;
1415         if (referralAddress != address(0)) totalShares++;
1416 
1417         uint numberOfTokens = allTokens.length;
1418      
1419         if (numberOfTokens > 0 && sharePercentage > 0) {
1420 
1421             uint256 perShareValue = 0;
1422             uint256 totalShareValue = msg.value * sharePercentage / 10000 ;
1423 
1424             if (totalShares > numberOfTokens) {
1425                                
1426                 if (referralAddress != address(0)) 
1427                     perShareValue = totalShareValue / (numberOfTokens + 1);
1428                 else
1429                     perShareValue = totalShareValue / numberOfTokens;
1430             
1431                 for (uint i = 0; i < numberOfTokens; i++) {
1432                     //turn off events if there are too many tokens in the loop
1433                     if (numberOfTokens > 100) {
1434                         _depositWithoutEvent(tokenOwner[allTokens[i]], perShareValue);
1435                     }else{
1436                         _deposit(tokenOwner[allTokens[i]], perShareValue, 2);
1437                     }
1438                 }
1439                 
1440             }else{
1441                
1442                 if (referralAddress != address(0)) 
1443                     perShareValue = totalShareValue / (totalShares + 1);
1444                 else
1445                     perShareValue = totalShareValue / totalShares;
1446               
1447                 uint[] memory randomArray = random(numberOfShares);
1448 
1449                 for (uint i = 0; i < numberOfShares; i++) {
1450                     uint index = randomArray[i] % numberOfTokens;
1451 
1452                     if (numberOfShares > 100) {
1453                         _depositWithoutEvent(tokenOwner[allTokens[index]], perShareValue);
1454                     }else{
1455                         _deposit(tokenOwner[allTokens[index]], perShareValue, 2);
1456                     }
1457                 }
1458             }
1459                     
1460             if (referralAddress != address(0) && perShareValue > 0) _deposit(referralAddress, perShareValue, 5);
1461 
1462         }
1463 
1464         _acquireAsset(_tokenId, _title, msg.sender, msg.value);
1465      
1466     }
1467 
1468     function _acquireAsset(uint256 _tokenId, string memory _title, address _purchaser, uint256 _value) internal {
1469         
1470         currentPrice = CalculateNextPrice();
1471         _mint(_purchaser, _tokenId);        
1472       
1473         tokenTitles[_tokenId] = _title;
1474        
1475         RecordKeeping.priceRecord memory pr = RecordKeeping.priceRecord(_value, _purchaser, block.timestamp);
1476         initialPriceRecords[_tokenId] = pr;
1477         lastPriceRecords[_tokenId] = pr;     
1478 
1479         emit AssetAcquired(_purchaser,_tokenId, _title, _value);
1480         emit TokenBrought(address(0), _purchaser, _tokenId, _value);
1481         emit MintPriceChanged(currentPrice);
1482     }
1483 
1484     function CalculateNextPrice() public view returns (uint256){      
1485         return currentPrice + currentPrice * slowDownRate / ( priceRate * (allTokens.length + 2));
1486     }
1487 
1488     function tokensOf(address _owner) public view returns (uint256[] memory){
1489         return ownedTokens[_owner];
1490     }
1491 
1492     function _buyTokenFromWithReferral(address _from, address _to, uint256 _tokenId, address referralAddress, address _depositTo) internal {
1493         require(currentTokenPrices[_tokenId] != 0);
1494         require(msg.value >= currentTokenPrices[_tokenId]);
1495         
1496         tokenApprovals[_tokenId] = _to;
1497         safeTransferFrom(_from,_to,_tokenId);
1498 
1499         uint256 valueTransferToOwner = msg.value;
1500         uint256 lastRecordPrice = lastPriceRecords[_tokenId].price;
1501         if (msg.value >  lastRecordPrice){
1502             uint256 profit = msg.value - lastRecordPrice;           
1503             uint256 commission = profit * profitCommission / 10000;
1504             valueTransferToOwner = msg.value - commission;
1505             if (referralAddress != address(0)){
1506                 _deposit(referralAddress, commission * referralCommission / 10000, 5);
1507             }           
1508         }
1509         
1510         if (valueTransferToOwner > 0) _deposit(_depositTo, valueTransferToOwner, 1);
1511         writePriceRecordForAssetSold(_depositTo, msg.sender, _tokenId, msg.value);
1512         
1513     }
1514 
1515     function buyTokenFromWithReferral(address _from, address _to, uint256 _tokenId, address referralAddress) public payable {
1516         _buyTokenFromWithReferral(_from, _to, _tokenId, referralAddress, _from);        
1517     }
1518 
1519     function buyTokenFrom(address _from, address _to, uint256 _tokenId) public payable {
1520         buyTokenFromWithReferral(_from, _to, _tokenId, address(0));        
1521     }   
1522 
1523     function writePriceRecordForAssetSold(address _from, address _to, uint256 _tokenId, uint256 _value) internal {
1524        RecordKeeping.priceRecord memory pr = RecordKeeping.priceRecord(_value, _to, block.timestamp);
1525        lastPriceRecords[_tokenId] = pr;
1526        
1527        tokenApprovals[_tokenId] = address(0);
1528        currentTokenPrices[_tokenId] = 0;
1529        emit TokenBrought(_from, _to, _tokenId, _value);       
1530     }
1531 
1532     function recordAuctionPriceRecord(address _from, address _to, uint256 _tokenId, uint256 _value)
1533        external {
1534 
1535        require(findAuctionContractIndex(msg.sender) >= 0); //make sure the sender is from one of the auction addresses
1536        writePriceRecordForAssetSold(_from, _to, _tokenId, _value);
1537 
1538     }
1539 
1540     function setTokenPrice(uint256 _tokenId, uint256 _newPrice) public  {
1541         require(isApprovedOrOwner(msg.sender, _tokenId));
1542         currentTokenPrices[_tokenId] = _newPrice;
1543         emit TokenPriceSet(_tokenId, _newPrice);
1544     }
1545 
1546     function getTokenPrice(uint256 _tokenId)  public view returns(uint256) {
1547         return currentTokenPrices[_tokenId];
1548     }
1549 
1550     function random(uint num) private view returns (uint[] memory) {
1551         
1552         uint base = uint(keccak256(abi.encodePacked(block.difficulty, now, tokenOwner[allTokens[allTokens.length-1]])));
1553         uint[] memory randomNumbers = new uint[](num);
1554         
1555         for (uint i = 0; i<num; i++) {
1556             randomNumbers[i] = base;
1557             base = base * 2 ** 3;
1558         }
1559         return  randomNumbers;
1560         
1561     }
1562 
1563 
1564     function getAsset(uint256 _tokenId)  external
1565         view
1566         returns
1567     (
1568         string memory title,            
1569         address owner,     
1570         address creator,      
1571         uint256 currentTokenPrice,
1572         uint256 lastPrice,
1573         uint256 initialPrice,
1574         uint256 lastDate,
1575         uint256 createdDate
1576     ) {
1577         require(exists(_tokenId));
1578         RecordKeeping.priceRecord memory lastPriceRecord = lastPriceRecords[_tokenId];
1579         RecordKeeping.priceRecord memory initialPriceRecord = initialPriceRecords[_tokenId];
1580 
1581         return (
1582              
1583             tokenTitles[_tokenId],        
1584             tokenOwner[_tokenId],   
1585             initialPriceRecord.owner,           
1586             currentTokenPrices[_tokenId],      
1587             lastPriceRecord.price,           
1588             initialPriceRecord.price,
1589             lastPriceRecord.timestamp,
1590             initialPriceRecord.timestamp
1591         );
1592     }
1593 
1594     function getAssetUpdatedInfo(uint256 _tokenId) external
1595         view
1596         returns
1597     (         
1598         address owner, 
1599         address approvedAddress,
1600         uint256 currentTokenPrice,
1601         uint256 lastPrice,      
1602         uint256 lastDate
1603       
1604     ) {
1605         require(exists(_tokenId));
1606         RecordKeeping.priceRecord memory lastPriceRecord = lastPriceRecords[_tokenId];
1607      
1608         return (
1609             tokenOwner[_tokenId],   
1610             tokenApprovals[_tokenId],  
1611             currentTokenPrices[_tokenId],      
1612             lastPriceRecord.price,   
1613             lastPriceRecord.timestamp           
1614         );
1615     }
1616 
1617     function getAssetStaticInfo(uint256 _tokenId)  external
1618         view
1619         returns
1620     (
1621         string memory title,            
1622         string memory tokenURI,    
1623         address creator,            
1624         uint256 initialPrice,       
1625         uint256 createdDate
1626     ) {
1627         require(exists(_tokenId));      
1628         RecordKeeping.priceRecord memory initialPriceRecord = initialPriceRecords[_tokenId];
1629 
1630         return (
1631              
1632             tokenTitles[_tokenId],        
1633             tokenURIs[_tokenId],
1634             initialPriceRecord.owner,
1635             initialPriceRecord.price,         
1636             initialPriceRecord.timestamp
1637         );
1638          
1639     }
1640 
1641     function burnExchangeToken(address _tokenOwner, uint256 _tokenId) external  {
1642         require(msg.sender == stemTokenContractAddress);       
1643         _burn(_tokenOwner, _tokenId);       
1644         emit Burn(_tokenOwner, _tokenId);
1645     }
1646 
1647     function findAuctionContractIndex(address _addressToFind) public view returns (int)  {
1648         
1649         for (int i = 0; i < int(auctionContractAddresses.length); i++){
1650             if (auctionContractAddresses[uint256(i)] == _addressToFind){
1651                 return i;
1652             }
1653         }
1654         return -1;
1655     }
1656 
1657     function addAuctionContractAddress(address _auctionContractAddress) public onlyOwner {
1658         require(findAuctionContractIndex(_auctionContractAddress) == -1);
1659         auctionContractAddresses.push(_auctionContractAddress);
1660     }
1661 
1662     function removeAuctionContractAddress(address _auctionContractAddress) public onlyOwner {
1663         int index = findAuctionContractIndex(_auctionContractAddress);
1664         require(index >= 0);        
1665 
1666         for (uint i = uint(index); i < auctionContractAddresses.length-1; i++){
1667             auctionContractAddresses[i] = auctionContractAddresses[i+1];         
1668         }
1669         auctionContractAddresses.length--;
1670     }
1671 
1672     function setStemTokenContractAddress(address _stemTokenContractAddress) public onlyOwner {        
1673         stemTokenContractAddress = _stemTokenContractAddress;
1674     }          
1675    
1676 
1677     function tokenURI(uint256 _tokenId) public view returns (string memory) {
1678         require(exists(_tokenId));   
1679         return string(abi.encodePacked(uriPrefix, uint256ToString(_tokenId)));
1680 
1681     }
1682     // Functions used for generating the URI
1683     function amountOfZeros(uint256 num, uint256 base) public pure returns(uint256){
1684         uint256 result = 0;
1685         num /= base;
1686         while (num > 0){
1687             num /= base;
1688             result += 1;
1689         }
1690         return result;
1691     }
1692 
1693       function uint256ToString(uint256 num) public pure returns(string memory){
1694         if (num == 0){
1695             return "0";
1696         }
1697         uint256 numLen = amountOfZeros(num, 10) + 1;
1698         bytes memory result = new bytes(numLen);
1699         while(num != 0){
1700             numLen -= 1;
1701             result[numLen] = byte(uint8((num - (num / 10 * 10)) + 48));
1702             num /= 10;
1703         }
1704         return string(result);
1705     }
1706 
1707     //  function initialImport(uint256[] memory _tokenIds,
1708     //                         uint256[] memory _lastPrices, address[] memory _owners, uint256[] memory _lastDates,
1709     //                         uint256[] memory _initialPrices, address[] memory _creators, uint256[] memory _initialDates,
1710     //                         string[] memory _titles ) public onlyOwner {
1711     
1712     //     require( _tokenIds.length == _lastPrices.length &&
1713     //             _tokenIds.length == _owners.length &&
1714     //             _tokenIds.length == _lastDates.length &&
1715     //             _tokenIds.length == _initialPrices.length &&
1716     //             _tokenIds.length == _creators.length &&
1717     //             _tokenIds.length == _initialDates.length &&
1718     //             _tokenIds.length == _titles.length 
1719     //             );
1720 
1721     //     for (uint i = 0; i < _tokenIds.length; i++){
1722 
1723     //         allTokensIndex[_tokenIds[i]] = allTokens.length;
1724     //         allTokens.push(_tokenIds[i]);
1725 
1726     //         tokenTitles[_tokenIds[i]] = _titles[i];
1727 
1728     //         addTokenTo(_owners[i],_tokenIds[i]);
1729 
1730     //         RecordKeeping.priceRecord memory prInitial = RecordKeeping.priceRecord(_initialPrices[i], _creators[i], _initialDates[i]);
1731     //         initialPriceRecords[_tokenIds[i]] = prInitial;      
1732 
1733     //         RecordKeeping.priceRecord memory prLast = RecordKeeping.priceRecord(_lastPrices[i], _owners[i], _lastDates[i]);
1734     //         lastPriceRecords[_tokenIds[i]] = prLast;  
1735 
1736                
1737 
1738     //     }
1739     // }
1740 }
1741 
1742 
1743 contract CappedToken is MintableToken {
1744 
1745   uint256 public cap;
1746 
1747   constructor(uint256 _cap) public {
1748     require(_cap > 0);
1749     cap = _cap;
1750   }
1751 
1752   /**
1753    * @dev Function to mint tokens
1754    * @param _to The address that will receive the minted tokens.
1755    * @param _amount The amount of tokens to mint.
1756    * @return A boolean that indicates if the operation was successful.
1757    */
1758   function mint(
1759     address _to,
1760     uint256 _amount
1761   )
1762     public
1763     returns (bool)
1764   {
1765     require(totalSupply_.add(_amount) <= cap);
1766 
1767     return super.mint(_to, _amount);
1768   }
1769 
1770 }
1771 
1772 contract StemToken is CappedToken, StandardBurnableToken {
1773     string public name;
1774     string public symbol;
1775     uint8 public decimals;
1776 
1777     constructor(string memory _name, string memory _symbol, uint256 _cap) CappedToken(_cap)  public {
1778         name = _name;
1779         symbol = _symbol;
1780         decimals = 0;    
1781     }
1782 }
1783 contract RetroArtStemToken is StemToken {    
1784 
1785     address public retroArtAddress;
1786 
1787     constructor(string memory _name, string memory _symbol, uint256 _cap) StemToken(_name, _symbol, _cap )  public {
1788         
1789     }
1790 
1791   
1792     function setRetroArtAddress(address _retroArtAddress) public onlyOwner {        
1793         retroArtAddress = _retroArtAddress;
1794     }
1795 
1796     function sellback(uint256 _tokenId) public {
1797      
1798         RetroArt retroArt = RetroArt(retroArtAddress);
1799         require(retroArt.ownerOf(_tokenId) == msg.sender);
1800         retroArt.burnExchangeToken(msg.sender, _tokenId);
1801         totalSupply_ = totalSupply_.add(1);
1802         balances[msg.sender] = balances[msg.sender].add(1);
1803         emit Mint(msg.sender, 1);
1804         emit Transfer(address(0), msg.sender, 1);
1805     }
1806 
1807     //acquire a new asset using one stem token
1808     //usually _tokenOwner should just be the msg.sender, as the address who pay with the stem token
1809     //however it can be used to pay on behalf of someone else if _tokenOwner is a different address
1810     function acquireAssetForOther(uint256 _tokenId, string memory _title, address _tokenOwner) public {
1811         require(balanceOf(msg.sender) >= 1);           
1812         _burn(msg.sender, uint256(1));
1813         RetroArt retroArt = RetroArt(retroArtAddress);
1814         retroArt.acquireAssetFromStemToken(_tokenOwner, _tokenId, _title);
1815     }
1816 
1817     function acquireAsset(uint256 _tokenId, string memory _title) public {
1818         acquireAssetForOther(_tokenId, _title, msg.sender);
1819     }
1820 
1821 }