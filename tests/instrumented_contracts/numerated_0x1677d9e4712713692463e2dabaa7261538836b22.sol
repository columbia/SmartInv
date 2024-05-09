1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title SafeMath32
52  * @dev SafeMath library implemented for uint32
53  */
54 library SafeMath32 {
55 
56   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
57     if (a == 0) {
58       return 0;
59     }
60     uint32 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   function div(uint32 a, uint32 b) internal pure returns (uint32) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint32 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function add(uint32 a, uint32 b) internal pure returns (uint32) {
78     uint32 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 /**
85  * @title SafeMath16
86  * @dev SafeMath library implemented for uint16
87  */
88 library SafeMath16 {
89 
90   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
91     if (a == 0) {
92       return 0;
93     }
94     uint16 c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   function div(uint16 a, uint16 b) internal pure returns (uint16) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     uint16 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return c;
104   }
105 
106   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   function add(uint16 a, uint16 b) internal pure returns (uint16) {
112     uint16 c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 /**
119  * Utility library of inline functions on addresses
120  */
121 library AddressUtils {
122 
123   /**
124    * Returns whether the target address is a contract
125    * @dev This function will return false if invoked during the constructor of a contract,
126    *  as the code is not actually created until after the constructor finishes.
127    * @param addr address to check
128    * @return whether the target address is a contract
129    */
130   function isContract(address addr) internal view returns (bool) {
131     uint256 size;
132     // XXX Currently there is no better way to check if there is a contract in an address
133     // than to check the size of the code at that address.
134     // See https://ethereum.stackexchange.com/a/14016/36603
135     // for more details about how this works.
136     // TODO Check this again before the Serenity release, because all addresses will be
137     // contracts then.
138     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
139     return size > 0;
140   }
141 
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     emit OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 /**
185  * @title Claimable
186  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
187  * This allows the new owner to accept the transfer.
188  */
189 contract Claimable is Ownable {
190   address public pendingOwner;
191 
192   /**
193    * @dev Modifier throws if called by any account other than the pendingOwner.
194    */
195   modifier onlyPendingOwner() {
196     require(msg.sender == pendingOwner);
197     _;
198   }
199 
200   /**
201    * @dev Allows the current owner to set the pendingOwner address.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function transferOwnership(address newOwner) onlyOwner public {
205     pendingOwner = newOwner;
206   }
207 
208   /**
209    * @dev Allows the pendingOwner address to finalize the transfer.
210    */
211   function claimOwnership() onlyPendingOwner public {
212     emit OwnershipTransferred(owner, pendingOwner);
213     owner = pendingOwner;
214     pendingOwner = address(0);
215   }
216 }
217 
218 
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226 
227   bool public paused = false;
228 
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237 
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused);
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public {
250     paused = true;
251     emit Pause();
252   }
253 
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() onlyOwner whenPaused public {
258     paused = false;
259     emit Unpause();
260   }
261 }
262 
263 
264 
265 /**
266  * @title ERC721 Non-Fungible Token Standard basic interface
267  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
268  */
269 contract ERC721Basic {
270   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
271   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
272   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
273 
274   function balanceOf(address _owner) public view returns (uint256 _balance);
275   function ownerOf(uint256 _tokenId) public view returns (address _owner);
276   function exists(uint256 _tokenId) public view returns (bool _exists);
277 
278   function approve(address _to, uint256 _tokenId) public;
279   function getApproved(uint256 _tokenId) public view returns (address _operator);
280 
281   function setApprovalForAll(address _operator, bool _approved) public;
282   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
283 
284   function transferFrom(address _from, address _to, uint256 _tokenId) public;
285   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
286   function safeTransferFrom(
287     address _from,
288     address _to,
289     uint256 _tokenId,
290     bytes _data
291   )
292     public;
293 }
294 
295 
296 
297 /**
298  * @title ERC721 token receiver interface
299  * @dev Interface for any contract that wants to support safeTransfers
300  *  from ERC721 asset contracts.
301  */
302 contract ERC721Receiver {
303   /**
304    * @dev Magic value to be returned upon successful reception of an NFT
305    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
306    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
307    */
308   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
309 
310   /**
311    * @notice Handle the receipt of an NFT
312    * @dev The ERC721 smart contract calls this function on the recipient
313    *  after a `safetransfer`. This function MAY throw to revert and reject the
314    *  transfer. This function MUST use 50,000 gas or less. Return of other
315    *  than the magic value MUST result in the transaction being reverted.
316    *  Note: the contract address is always the message sender.
317    * @param _from The sending address
318    * @param _tokenId The NFT identifier which is being transfered
319    * @param _data Additional data with no specified format
320    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
321    */
322   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
323 }
324 
325 
326 
327 
328 /**
329  * @title ERC721 Non-Fungible Token Standard basic implementation
330  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
331  */
332 contract ERC721BasicToken is ERC721Basic {
333   using SafeMath for uint256;
334   using AddressUtils for address;
335 
336   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
337   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
338   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
339 
340   // Mapping from token ID to owner
341   mapping (uint256 => address) internal tokenOwner;
342 
343   // Mapping from token ID to approved address
344   mapping (uint256 => address) internal tokenApprovals;
345 
346   // Mapping from owner to number of owned token
347   mapping (address => uint256) internal ownedTokensCount;
348 
349   // Mapping from owner to operator approvals
350   mapping (address => mapping (address => bool)) internal operatorApprovals;
351 
352   /**
353    * @dev Guarantees msg.sender is owner of the given token
354    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
355    */
356   modifier onlyOwnerOf(uint256 _tokenId) {
357     require(ownerOf(_tokenId) == msg.sender);
358     _;
359   }
360 
361   /**
362    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
363    * @param _tokenId uint256 ID of the token to validate
364    */
365   modifier canTransfer(uint256 _tokenId) {
366     require(isApprovedOrOwner(msg.sender, _tokenId));
367     _;
368   }
369 
370   /**
371    * @dev Gets the balance of the specified address
372    * @param _owner address to query the balance of
373    * @return uint256 representing the amount owned by the passed address
374    */
375   function balanceOf(address _owner) public view returns (uint256) {
376     require(_owner != address(0));
377     return ownedTokensCount[_owner];
378   }
379 
380   /**
381    * @dev Gets the owner of the specified token ID
382    * @param _tokenId uint256 ID of the token to query the owner of
383    * @return owner address currently marked as the owner of the given token ID
384    */
385   function ownerOf(uint256 _tokenId) public view returns (address) {
386     address owner = tokenOwner[_tokenId];
387     require(owner != address(0));
388     return owner;
389   }
390 
391   /**
392    * @dev Returns whether the specified token exists
393    * @param _tokenId uint256 ID of the token to query the existance of
394    * @return whether the token exists
395    */
396   function exists(uint256 _tokenId) public view returns (bool) {
397     address owner = tokenOwner[_tokenId];
398     return owner != address(0);
399   }
400 
401   /**
402    * @dev Approves another address to transfer the given token ID
403    * @dev The zero address indicates there is no approved address.
404    * @dev There can only be one approved address per token at a given time.
405    * @dev Can only be called by the token owner or an approved operator.
406    * @param _to address to be approved for the given token ID
407    * @param _tokenId uint256 ID of the token to be approved
408    */
409   function approve(address _to, uint256 _tokenId) public {
410     address owner = ownerOf(_tokenId);
411     require(_to != owner);
412     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
413 
414     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
415       tokenApprovals[_tokenId] = _to;
416       emit Approval(owner, _to, _tokenId);
417     }
418   }
419 
420   /**
421    * @dev Gets the approved address for a token ID, or zero if no address set
422    * @param _tokenId uint256 ID of the token to query the approval of
423    * @return address currently approved for a the given token ID
424    */
425   function getApproved(uint256 _tokenId) public view returns (address) {
426     return tokenApprovals[_tokenId];
427   }
428 
429   /**
430    * @dev Sets or unsets the approval of a given operator
431    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
432    * @param _to operator address to set the approval
433    * @param _approved representing the status of the approval to be set
434    */
435   function setApprovalForAll(address _to, bool _approved) public {
436     require(_to != msg.sender);
437     operatorApprovals[msg.sender][_to] = _approved;
438     emit ApprovalForAll(msg.sender, _to, _approved);
439   }
440 
441   /**
442    * @dev Tells whether an operator is approved by a given owner
443    * @param _owner owner address which you want to query the approval of
444    * @param _operator operator address which you want to query the approval of
445    * @return bool whether the given operator is approved by the given owner
446    */
447   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
448     return operatorApprovals[_owner][_operator];
449   }
450 
451   /**
452    * @dev Transfers the ownership of a given token ID to another address
453    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
454    * @dev Requires the msg sender to be the owner, approved, or operator
455    * @param _from current owner of the token
456    * @param _to address to receive the ownership of the given token ID
457    * @param _tokenId uint256 ID of the token to be transferred
458   */
459   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
460     require(_from != address(0));
461     require(_to != address(0));
462 
463     clearApproval(_from, _tokenId);
464     removeTokenFrom(_from, _tokenId);
465     addTokenTo(_to, _tokenId);
466 
467     emit Transfer(_from, _to, _tokenId);
468   }
469 
470   /**
471    * @dev Safely transfers the ownership of a given token ID to another address
472    * @dev If the target address is a contract, it must implement `onERC721Received`,
473    *  which is called upon a safe transfer, and return the magic value
474    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
475    *  the transfer is reverted.
476    * @dev Requires the msg sender to be the owner, approved, or operator
477    * @param _from current owner of the token
478    * @param _to address to receive the ownership of the given token ID
479    * @param _tokenId uint256 ID of the token to be transferred
480   */
481   function safeTransferFrom(
482     address _from,
483     address _to,
484     uint256 _tokenId
485   )
486     public
487     canTransfer(_tokenId)
488   {
489     // solium-disable-next-line arg-overflow
490     safeTransferFrom(_from, _to, _tokenId, "");
491   }
492 
493   /**
494    * @dev Safely transfers the ownership of a given token ID to another address
495    * @dev If the target address is a contract, it must implement `onERC721Received`,
496    *  which is called upon a safe transfer, and return the magic value
497    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
498    *  the transfer is reverted.
499    * @dev Requires the msg sender to be the owner, approved, or operator
500    * @param _from current owner of the token
501    * @param _to address to receive the ownership of the given token ID
502    * @param _tokenId uint256 ID of the token to be transferred
503    * @param _data bytes data to send along with a safe transfer check
504    */
505   function safeTransferFrom(
506     address _from,
507     address _to,
508     uint256 _tokenId,
509     bytes _data
510   )
511     public
512     canTransfer(_tokenId)
513   {
514     transferFrom(_from, _to, _tokenId);
515     // solium-disable-next-line arg-overflow
516     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
517   }
518 
519   /**
520    * @dev Returns whether the given spender can transfer a given token ID
521    * @param _spender address of the spender to query
522    * @param _tokenId uint256 ID of the token to be transferred
523    * @return bool whether the msg.sender is approved for the given token ID,
524    *  is an operator of the owner, or is the owner of the token
525    */
526   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
527     address owner = ownerOf(_tokenId);
528     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
529   }
530 
531   /**
532    * @dev Internal function to mint a new token
533    * @dev Reverts if the given token ID already exists
534    * @param _to The address that will own the minted token
535    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
536    */
537   function _mint(address _to, uint256 _tokenId) internal {
538     require(_to != address(0));
539     addTokenTo(_to, _tokenId);
540     emit Transfer(address(0), _to, _tokenId);
541   }
542 
543   /**
544    * @dev Internal function to burn a specific token
545    * @dev Reverts if the token does not exist
546    * @param _tokenId uint256 ID of the token being burned by the msg.sender
547    */
548   function _burn(address _owner, uint256 _tokenId) internal {
549     clearApproval(_owner, _tokenId);
550     removeTokenFrom(_owner, _tokenId);
551     emit Transfer(_owner, address(0), _tokenId);
552   }
553 
554   /**
555    * @dev Internal function to clear current approval of a given token ID
556    * @dev Reverts if the given address is not indeed the owner of the token
557    * @param _owner owner of the token
558    * @param _tokenId uint256 ID of the token to be transferred
559    */
560   function clearApproval(address _owner, uint256 _tokenId) internal {
561     require(ownerOf(_tokenId) == _owner);
562     if (tokenApprovals[_tokenId] != address(0)) {
563       tokenApprovals[_tokenId] = address(0);
564       emit Approval(_owner, address(0), _tokenId);
565     }
566   }
567 
568   /**
569    * @dev Internal function to add a token ID to the list of a given address
570    * @param _to address representing the new owner of the given token ID
571    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
572    */
573   function addTokenTo(address _to, uint256 _tokenId) internal {
574     require(tokenOwner[_tokenId] == address(0));
575     tokenOwner[_tokenId] = _to;
576     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
577   }
578 
579   /**
580    * @dev Internal function to remove a token ID from the list of a given address
581    * @param _from address representing the previous owner of the given token ID
582    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
583    */
584   function removeTokenFrom(address _from, uint256 _tokenId) internal {
585     require(ownerOf(_tokenId) == _from);
586     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
587     tokenOwner[_tokenId] = address(0);
588   }
589 
590   /**
591    * @dev Internal function to invoke `onERC721Received` on a target address
592    * @dev The call is not executed if the target address is not a contract
593    * @param _from address representing the previous owner of the given token ID
594    * @param _to target address that will receive the tokens
595    * @param _tokenId uint256 ID of the token to be transferred
596    * @param _data bytes optional data to send along with the call
597    * @return whether the call correctly returned the expected magic value
598    */
599   function checkAndCallSafeTransfer(
600     address _from,
601     address _to,
602     uint256 _tokenId,
603     bytes _data
604   )
605     internal
606     returns (bool)
607   {
608     if (!_to.isContract()) {
609       return true;
610     }
611     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
612     return (retval == ERC721_RECEIVED);
613   }
614 }
615 
616 
617 
618 contract PausableToken is ERC721BasicToken, Pausable {
619 	function approve(address _to, uint256 _tokenId) public whenNotPaused {
620 		super.approve(_to, _tokenId);
621 	}
622 
623 	function setApprovalForAll(address _operator, bool _approved) public whenNotPaused {
624 		super.setApprovalForAll(_operator, _approved);
625 	}
626 
627 	function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
628 		super.transferFrom(_from, _to, _tokenId);
629 	}
630 
631 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
632 		super.safeTransferFrom(_from, _to, _tokenId);
633 	}
634 	
635 	function safeTransferFrom(
636 	    address _from,
637 	    address _to,
638 	    uint256 _tokenId,
639 	    bytes _data
640 	  )
641 	    public whenNotPaused {
642 		super.safeTransferFrom(_from, _to, _tokenId, _data);
643 	}
644 }
645 
646 
647 /**
648  * @title WorldCupFactory
649  * @author Cocos
650  * @dev Declare token struct, and generated all toekn
651  */
652 contract WorldCupFactory is Claimable, PausableToken {
653 
654 	using SafeMath for uint256;
655 
656 	uint public initPrice;
657 
658 	//string[] public initTokenData = [];
659 
660 	// @dev Declare token struct    
661 	struct Country {
662 		// token name
663 		string name;
664 		
665 		// token current price
666 		uint price;
667 	}
668 
669 	Country[] public countries;
670 
671     /// @dev A mapping from countryIDs to an address that has been approved to call
672     ///  transferFrom(). Each Country can only have one approved address for transfer
673     ///  at any time. A zero value means no approval is outstanding.
674 	//mapping (uint => address) internal tokenOwner;
675 
676 	// @dev A mapping from owner address to count of tokens that address owns.
677     //  Used internally inside balanceOf() to resolve ownership count.
678 	//mapping (address => uint) internal ownedTokensCount;
679 
680 	
681 	/// @dev The WorldCupFactory constructor sets the initialized price of One token
682 	function WorldCupFactory(uint _initPrice) public {
683 		initPrice = _initPrice;
684 		paused    = true;
685 	}
686 
687 	function createToken() external onlyOwner {
688 		// Create tokens
689 		uint length = countries.length;
690 		for (uint i = length; i < length + 100; i++) {
691 			if (i >= 836 ) {
692 				break;
693 			}
694 
695 			if (i < 101) {
696 				_createToken("Country");
697 			}else {
698 				_createToken("Player");
699 			}
700 		}
701 	}
702 
703 	/// @dev Create token with _name, internally.
704 	function _createToken(string _name) internal {
705 		uint id = countries.push( Country(_name, initPrice) ) - 1;
706 		tokenOwner[id] = msg.sender;
707 		ownedTokensCount[msg.sender] = ownedTokensCount[msg.sender].add(1);
708 	}
709 
710 }
711 
712 /**
713  * @title Control and manage
714  * @author Cocos
715  * @dev Use for owner setting operating income address, PayerInterface.
716  * 
717  */
718 contract WorldCupControl is WorldCupFactory {
719 	/// @dev Operating income address.
720 	address public cooAddress;
721 
722 
723     function WorldCupControl() public {
724         cooAddress = msg.sender;
725     }
726 
727 	/// @dev Assigns a new address to act as the COO.
728     /// @param _newCOO The address of the new COO.
729     function setCOO(address _newCOO) external onlyOwner {
730         require(_newCOO != address(0));
731         
732         cooAddress = _newCOO;
733     }
734 
735     /// @dev Allows the CFO to capture the balance available to the contract.
736     function withdrawBalance() external onlyOwner {
737         uint balance = address(this).balance;
738         
739         cooAddress.send(balance);
740     }
741 }
742 
743 
744 /**
745  * @title Define 
746  * @author Cocos
747  * @dev Provide some function for web front-end that can be use for convenience.
748  * 
749  */
750 contract WorldCupHelper is WorldCupControl {
751 
752 	/// @dev Return tokenid array
753 	function getTokenByOwner(address _owner) external view returns(uint[]) {
754 	    uint[] memory result = new uint[](ownedTokensCount[_owner]);
755 	    uint counter = 0;
756 
757 	    for (uint i = 0; i < countries.length; i++) {
758 			if (tokenOwner[i] == _owner) {
759 				result[counter] = i;
760 				counter++;
761 			}
762 	    }
763 		return result;
764   	}
765 
766   	/// @dev Return tokens price list. It gets the same order as ids.
767   	function getTokenPriceListByIds(uint[] _ids) external view returns(uint[]) {
768   		uint[] memory result = new uint[](_ids.length);
769   		uint counter = 0;
770 
771   		for (uint i = 0; i < _ids.length; i++) {
772   			Country storage token = countries[_ids[i]];
773   			result[counter] = token.price;
774   			counter++;
775   		}
776   		return result;
777   	}
778 
779 }
780 
781 /// @dev PayerInterface must implement ERC20 standard token.
782 contract PayerInterface {
783 	function totalSupply() public view returns (uint256);
784 	function balanceOf(address who) public view returns (uint256);
785 	function transfer(address to, uint256 value) public returns (bool);
786 
787 	function allowance(address owner, address spender) public view returns (uint256);
788   	function transferFrom(address from, address to, uint256 value) public returns (bool);
789   	function approve(address spender, uint256 value) public returns (bool);
790 }
791 
792 /**
793  * @title AuctionPaused
794  * @dev Base contract which allows children to implement an emergency stop mechanism.
795  */
796 contract AuctionPaused is Ownable {
797   event AuctionPause();
798   event AuctionUnpause();
799 
800   bool public auctionPaused = false;
801 
802 
803   /**
804    * @dev Modifier to make a function callable only when the contract is not auctionPaused.
805    */
806   modifier whenNotAuctionPaused() {
807     require(!auctionPaused);
808     _;
809   }
810 
811   /**
812    * @dev Modifier to make a function callable only when the contract is auctionPaused.
813    */
814   modifier whenAuctionPaused() {
815     require(auctionPaused);
816     _;
817   }
818 
819   /**
820    * @dev called by the owner to pause, triggers stopped state
821    */
822   function auctionPause() onlyOwner whenNotAuctionPaused public {
823     auctionPaused = true;
824     emit AuctionPause();
825   }
826 
827   /**
828    * @dev called by the owner to unpause, returns to normal state
829    */
830   function auctionUnpause() onlyOwner whenAuctionPaused public {
831     auctionPaused = false;
832     emit AuctionUnpause();
833   }
834 }
835 
836 contract WorldCupAuction is WorldCupHelper, AuctionPaused {
837 
838 	using SafeMath for uint256;
839 
840 	event PurchaseToken(address indexed _from, address indexed _to, uint256 _tokenId, uint256 _tokenPrice, uint256 _timestamp, uint256 _purchaseCounter);
841 
842 	/// @dev ERC721 Token upper limit of price, cap.
843 	///  Cap is the upper limit of price. It represented eth's cap if isEthPayable is true 
844 	///  or erc20 token's cap if isEthPayable is false.
845 	///  Note!!! Using 'wei' for eth's cap units. Using minimum units for erc20 token cap units.
846 	uint public cap;
847 
848     uint public finalCap;
849 
850 	/// @dev 1 equal to 0.001
851 	/// erc721 token's price increasing. Each purchase the price increases 5%
852 	uint public increasePermillage = 50;
853 
854 	/// @dev 1 equal to 0.001
855 	/// Exchange fee 2.3%
856 	uint public sysFeePermillage = 23;
857 
858 
859 	/// @dev Contract operating income address.
860 	PayerInterface public payerContract = PayerInterface(address(0));
861 
862     /// @dev If isEthPayable is true, users can only use eth to buy current erc721 token.
863     ///  If isEthPayable is false, that mean's users can only use PayerInterface's token to buy current erc721 token.
864     bool public isEthPayable;
865 
866     uint public purchaseCounter = 0;
867 
868     /// @dev Constructor
869     /// @param _initPrice erc721 token initialized price.
870     /// @param _cap Upper limit of increase price.
871     /// @param _isEthPayable 
872     /// @param _address PayerInterface address, it must be a ERC20 contract.
873     function WorldCupAuction(uint _initPrice, uint _cap, bool _isEthPayable, address _address) public WorldCupFactory(_initPrice) {
874         require( (_isEthPayable == false && _address != address(0)) || _isEthPayable == true && _address == address(0) );
875 
876         cap           = _cap;
877         finalCap      = _cap.add(_cap.mul(25).div(1000));
878         isEthPayable  = _isEthPayable;
879         payerContract = PayerInterface(_address);
880     }
881 
882     function purchaseWithEth(uint _tokenId) external payable whenNotAuctionPaused {
883     	require(isEthPayable == true);
884     	require(msg.sender != tokenOwner[_tokenId]);
885 
886     	/// @dev If `_tokenId` is out of the range of the array,
887         /// this will throw automatically and revert all changes.
888     	Country storage token = countries[_tokenId];
889     	uint nextPrice = _computeNextPrice(token);
890 
891     	require(msg.value >= nextPrice);
892 
893     	uint fee = nextPrice.mul(sysFeePermillage).div(1000);
894     	uint oldOwnerRefund = nextPrice.sub(fee);
895 
896     	address oldOwner = ownerOf(_tokenId);
897 
898     	// Refund eth to the person who owned this erc721 token.
899     	oldOwner.transfer(oldOwnerRefund);
900 
901     	// Transfer fee to the cooAddress.
902     	cooAddress.transfer(fee);
903 
904     	// Transfer eth left go back to the sender.
905     	if ( msg.value.sub(oldOwnerRefund).sub(fee) > 0.0001 ether ) {
906     		msg.sender.transfer( msg.value.sub(oldOwnerRefund).sub(fee) );
907     	}
908 
909     	//Update token price
910     	token.price = nextPrice;
911 
912     	_transfer(oldOwner, msg.sender, _tokenId);
913 
914     	emit PurchaseToken(oldOwner, msg.sender, _tokenId, nextPrice, now, purchaseCounter);
915         purchaseCounter = purchaseCounter.add(1);
916     }
917 
918     function purchaseWithToken(uint _tokenId) external whenNotAuctionPaused {
919     	require(isEthPayable == false);
920     	require(payerContract != address(0));
921     	require(msg.sender != tokenOwner[_tokenId]);
922 
923         Country storage token = countries[_tokenId];
924         uint nextPrice = _computeNextPrice(token);
925 
926         // We need to know how much erc20 token allows our contract to transfer.
927         uint256 aValue = payerContract.allowance(msg.sender, address(this));
928         require(aValue >= nextPrice);
929 
930         uint fee = nextPrice.mul(sysFeePermillage).div(1000);
931         uint oldOwnerRefund = nextPrice.sub(fee);
932 
933         address oldOwner = ownerOf(_tokenId);
934 
935         // Refund erc20 token to the person who owned this erc721 token.
936         require(payerContract.transferFrom(msg.sender, oldOwner, oldOwnerRefund));
937 
938         // Transfer fee to the cooAddress.
939         require(payerContract.transferFrom(msg.sender, cooAddress, fee));
940 
941         // Update token price
942         token.price = nextPrice;
943 
944         _transfer(oldOwner, msg.sender, _tokenId);
945 
946         emit PurchaseToken(oldOwner, msg.sender, _tokenId, nextPrice, now, purchaseCounter);
947         purchaseCounter = purchaseCounter.add(1);
948 
949     }
950 
951     function getTokenNextPrice(uint _tokenId) public view returns(uint) {
952         Country storage token = countries[_tokenId];
953         uint nextPrice = _computeNextPrice(token);
954         return nextPrice;
955     }
956 
957     function _computeNextPrice(Country storage token) private view returns(uint) {
958         if (token.price >= cap) {
959             return finalCap;
960         }
961 
962     	uint price = token.price;
963     	uint addPrice = price.mul(increasePermillage).div(1000);
964 
965 		uint nextPrice = price.add(addPrice);
966 		if (nextPrice > cap) {
967 			nextPrice = cap;
968 		}
969 
970     	return nextPrice;
971     }
972 
973     function _transfer(address _from, address _to, uint256 _tokenId) internal {
974         // Clear approval.
975         if (tokenApprovals[_tokenId] != address(0)) {
976             tokenApprovals[_tokenId] = address(0);
977             emit Approval(_from, address(0), _tokenId);
978         }
979 
980         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
981         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
982         tokenOwner[_tokenId] = _to;
983         emit Transfer(_from, _to, _tokenId);
984     }
985 
986 }
987 
988 
989 contract CryptoWCRC is WorldCupAuction {
990 
991 	string public constant name = "CryptoWCRC";
992     
993     string public constant symbol = "WCRC";
994 
995     function CryptoWCRC(uint _initPrice, uint _cap, bool _isEthPayable, address _address) public WorldCupAuction(_initPrice, _cap, _isEthPayable, _address) {
996 
997     }
998 
999     function totalSupply() public view returns (uint256) {
1000     	return countries.length;
1001     }
1002 
1003 }