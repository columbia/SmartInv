1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * Utility library of inline functions on addresses
51  */
52 library AddressUtils {
53 
54     /**
55     * Returns whether the target address is a contract
56     * @dev This function will return false if invoked during the constructor of a contract,
57     *  as the code is not actually created until after the constructor finishes.
58     * @param addr address to check
59     * @return whether the target address is a contract
60     */
61     function isContract(address addr) internal view returns (bool) {
62         uint256 size;
63         // XXX Currently there is no better way to check if there is a contract in an address
64         // than to check the size of the code at that address.
65         // See https://ethereum.stackexchange.com/a/14016/36603
66         // for more details about how this works.
67         // TODO Check this again before the Serenity release, because all addresses will be
68         // contracts then.
69         // solium-disable-next-line security/no-inline-assembly
70         assembly { size := extcodesize(addr) }
71         return size > 0;
72     }
73 
74 }
75 
76 /* Controls state and access rights for contract functions
77  * @title Operational Control
78  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
79  * Inspired and adapted from contract created by OpenZeppelin
80  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
81  */
82 contract OperationalControl {
83     // Facilitates access & control for the game.
84     // Roles:
85     //  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
86     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
87     //  -otherManagers: Contracts that need access to functions for gameplay
88 
89     /// @dev Emited when contract is upgraded
90     event ContractUpgrade(address newContract);
91 
92     // The addresses of the accounts (or contracts) that can execute actions within each roles.
93     address public managerPrimary;
94     address public managerSecondary;
95     address public bankManager;
96 
97     // Contracts that require access for gameplay
98     mapping(address => uint8) public otherManagers;
99 
100     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
101     bool public paused = false;
102 
103     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
104     bool public error = false;
105 
106     /// @dev Operation modifiers for limiting access
107     modifier onlyManager() {
108         require(msg.sender == managerPrimary || msg.sender == managerSecondary);
109         _;
110     }
111 
112     modifier onlyBanker() {
113         require(msg.sender == bankManager);
114         _;
115     }
116 
117     modifier onlyOtherManagers() {
118         require(otherManagers[msg.sender] == 1);
119         _;
120     }
121 
122 
123     modifier anyOperator() {
124         require(
125             msg.sender == managerPrimary ||
126             msg.sender == managerSecondary ||
127             msg.sender == bankManager ||
128             otherManagers[msg.sender] == 1
129         );
130         _;
131     }
132 
133     /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
134     function setOtherManager(address _newOp, uint8 _state) external onlyManager {
135         require(_newOp != address(0));
136 
137         otherManagers[_newOp] = _state;
138     }
139 
140     /// @dev Assigns a new address to act as the Primary Manager.
141     function setPrimaryManager(address _newGM) external onlyManager {
142         require(_newGM != address(0));
143 
144         managerPrimary = _newGM;
145     }
146 
147     /// @dev Assigns a new address to act as the Secondary Manager.
148     function setSecondaryManager(address _newGM) external onlyManager {
149         require(_newGM != address(0));
150 
151         managerSecondary = _newGM;
152     }
153 
154     /// @dev Assigns a new address to act as the Banker.
155     function setBanker(address _newBK) external onlyManager {
156         require(_newBK != address(0));
157 
158         bankManager = _newBK;
159     }
160 
161     /*** Pausable functionality adapted from OpenZeppelin ***/
162 
163     /// @dev Modifier to allow actions only when the contract IS NOT paused
164     modifier whenNotPaused() {
165         require(!paused);
166         _;
167     }
168 
169     /// @dev Modifier to allow actions only when the contract IS paused
170     modifier whenPaused {
171         require(paused);
172         _;
173     }
174 
175     /// @dev Modifier to allow actions only when the contract has Error
176     modifier whenError {
177         require(error);
178         _;
179     }
180 
181     /// @dev Called by any Operator role to pause the contract.
182     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
183     function pause() external onlyManager whenNotPaused {
184         paused = true;
185     }
186 
187     /// @dev Unpauses the smart contract. Can only be called by the Game Master
188     /// @notice This is public rather than external so it can be called by derived contracts. 
189     function unpause() public onlyManager whenPaused {
190         // can't unpause if contract was upgraded
191         paused = false;
192     }
193 
194     /// @dev Unpauses the smart contract. Can only be called by the Game Master
195     /// @notice This is public rather than external so it can be called by derived contracts. 
196     function hasError() public onlyManager whenPaused {
197         error = true;
198     }
199 
200     /// @dev Unpauses the smart contract. Can only be called by the Game Master
201     /// @notice This is public rather than external so it can be called by derived contracts. 
202     function noError() public onlyManager whenPaused {
203         error = false;
204     }
205 }
206 
207 /**
208  * @title ERC721 Non-Fungible Token Standard basic interface
209  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
210  */
211 contract ERC721Basic {
212     event Transfer(
213         address indexed _from,
214         address indexed _to,
215         uint256 _tokenId
216     );
217     event Approval(
218         address indexed _owner,
219         address indexed _approved,
220         uint256 _tokenId
221     );
222     event ApprovalForAll(
223         address indexed _owner,
224         address indexed _operator,
225         bool _approved
226     );
227 
228     function balanceOf(address _owner) public view returns (uint256 _balance);
229     function ownerOf(uint256 _tokenId) public view returns (address _owner);
230     function exists(uint256 _tokenId) public view returns (bool _exists);
231 
232     function approve(address _to, uint256 _tokenId) public;
233     function getApproved(uint256 _tokenId)
234         public view returns (address _operator);
235 
236     function setApprovalForAll(address _operator, bool _approved) public;
237     function isApprovedForAll(address _owner, address _operator)
238         public view returns (bool);
239 
240     function transferFrom(address _from, address _to, uint256 _tokenId) public;
241     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
242 
243     function safeTransferFrom(
244         address _from,
245         address _to,
246         uint256 _tokenId,
247         bytes _data
248     )
249         public;
250 }
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
254  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
255  */
256 contract ERC721Enumerable is ERC721Basic {
257     function totalSupply() public view returns (uint256);
258     function tokenOfOwnerByIndex(
259         address _owner,
260         uint256 _index
261     )
262         public
263         view
264         returns (uint256 _tokenId);
265 
266     function tokenByIndex(uint256 _index) public view returns (uint256);
267 }
268 
269 /**
270  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
271  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
272  */
273 contract ERC721Metadata is ERC721Basic {
274     function name() public view returns (string _name);
275     function symbol() public view returns (string _symbol);
276     function tokenURI(uint256 _tokenId) public view returns (string);
277 }
278 
279 /**
280  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
281  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
282  */
283 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
284 }
285 
286 /**
287  * @title ERC721 Non-Fungible Token Standard basic implementation
288  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
289  */
290 contract ERC721BasicToken is ERC721Basic {
291     using SafeMath for uint256;
292     using AddressUtils for address;
293 
294     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
295     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
296     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
297 
298     // Mapping from token ID to owner
299     mapping (uint256 => address) internal tokenOwner;
300 
301     // Mapping from token ID to approved address
302     mapping (uint256 => address) internal tokenApprovals;
303 
304     // Mapping from owner to number of owned token
305     mapping (address => uint256) internal ownedTokensCount;
306 
307     // Mapping from owner to operator approvals
308     mapping (address => mapping (address => bool)) internal operatorApprovals;
309 
310     /**
311     * @dev Guarantees msg.sender is owner of the given token
312     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
313     */
314     modifier onlyOwnerOf(uint256 _tokenId) {
315         require(ownerOf(_tokenId) == msg.sender);
316         _;
317     }
318 
319     /**
320     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
321     * @param _tokenId uint256 ID of the token to validate
322     */
323     modifier canTransfer(uint256 _tokenId) {
324         require(isApprovedOrOwner(msg.sender, _tokenId));
325         _;
326     }
327 
328     /**
329     * @dev Gets the balance of the specified address
330     * @param _owner address to query the balance of
331     * @return uint256 representing the amount owned by the passed address
332     */
333     function balanceOf(address _owner) public view returns (uint256) {
334         require(_owner != address(0));
335         return ownedTokensCount[_owner];
336     }
337 
338     /**
339     * @dev Gets the owner of the specified token ID
340     * @param _tokenId uint256 ID of the token to query the owner of
341     * @return owner address currently marked as the owner of the given token ID
342     */
343     function ownerOf(uint256 _tokenId) public view returns (address) {
344         address owner = tokenOwner[_tokenId];
345         require(owner != address(0));
346         return owner;
347     }
348 
349     /**
350     * @dev Returns whether the specified token exists
351     * @param _tokenId uint256 ID of the token to query the existence of
352     * @return whether the token exists
353     */
354     function exists(uint256 _tokenId) public view returns (bool) {
355         address owner = tokenOwner[_tokenId];
356         return owner != address(0);
357     }
358 
359     /**
360     * @dev Approves another address to transfer the given token ID
361     * @dev The zero address indicates there is no approved address.
362     * @dev There can only be one approved address per token at a given time.
363     * @dev Can only be called by the token owner or an approved operator.
364     * @param _to address to be approved for the given token ID
365     * @param _tokenId uint256 ID of the token to be approved
366     */
367     function approve(address _to, uint256 _tokenId) public {
368         address owner = ownerOf(_tokenId);
369         require(_to != owner);
370         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
371 
372         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
373             tokenApprovals[_tokenId] = _to;
374             emit Approval(owner, _to, _tokenId);
375         }
376     }
377 
378     /**
379     * @dev Gets the approved address for a token ID, or zero if no address set
380     * @param _tokenId uint256 ID of the token to query the approval of
381     * @return address currently approved for the given token ID
382     */
383     function getApproved(uint256 _tokenId) public view returns (address) {
384         return tokenApprovals[_tokenId];
385     }
386 
387     /**
388     * @dev Sets or unsets the approval of a given operator
389     * @dev An operator is allowed to transfer all tokens of the sender on their behalf
390     * @param _to operator address to set the approval
391     * @param _approved representing the status of the approval to be set
392     */
393     function setApprovalForAll(address _to, bool _approved) public {
394         require(_to != msg.sender);
395         operatorApprovals[msg.sender][_to] = _approved;
396         emit ApprovalForAll(msg.sender, _to, _approved);
397     }
398 
399     /**
400     * @dev Tells whether an operator is approved by a given owner
401     * @param _owner owner address which you want to query the approval of
402     * @param _operator operator address which you want to query the approval of
403     * @return bool whether the given operator is approved by the given owner
404     */
405     function isApprovedForAll(
406         address _owner,
407         address _operator
408     )
409         public
410         view
411         returns (bool)
412     {
413         return operatorApprovals[_owner][_operator];
414     }
415 
416     /**
417     * @dev Transfers the ownership of a given token ID to another address
418     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
419     * @dev Requires the msg sender to be the owner, approved, or operator
420     * @param _from current owner of the token
421     * @param _to address to receive the ownership of the given token ID
422     * @param _tokenId uint256 ID of the token to be transferred
423     */
424     function transferFrom(
425         address _from,
426         address _to,
427         uint256 _tokenId
428     )
429         public
430         canTransfer(_tokenId)
431     {
432         require(_from != address(0));
433         require(_to != address(0));
434 
435         clearApproval(_from, _tokenId);
436         removeTokenFrom(_from, _tokenId);
437         addTokenTo(_to, _tokenId);
438 
439         emit Transfer(_from, _to, _tokenId);
440     }
441 
442     /**
443     * @dev Safely transfers the ownership of a given token ID to another address
444     * @dev If the target address is a contract, it must implement `onERC721Received`,
445     *  which is called upon a safe transfer, and return the magic value
446     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
447     *  the transfer is reverted.
448     * @dev Requires the msg sender to be the owner, approved, or operator
449     * @param _from current owner of the token
450     * @param _to address to receive the ownership of the given token ID
451     * @param _tokenId uint256 ID of the token to be transferred
452     */
453     function safeTransferFrom(
454         address _from,
455         address _to,
456         uint256 _tokenId
457     )
458         public
459         canTransfer(_tokenId)
460     {
461         // solium-disable-next-line arg-overflow
462         safeTransferFrom(_from, _to, _tokenId, "");
463     }
464 
465     /**
466     * @dev Safely transfers the ownership of a given token ID to another address
467     * @dev If the target address is a contract, it must implement `onERC721Received`,
468     *  which is called upon a safe transfer, and return the magic value
469     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
470     *  the transfer is reverted.
471     * @dev Requires the msg sender to be the owner, approved, or operator
472     * @param _from current owner of the token
473     * @param _to address to receive the ownership of the given token ID
474     * @param _tokenId uint256 ID of the token to be transferred
475     * @param _data bytes data to send along with a safe transfer check
476     */
477     function safeTransferFrom(
478         address _from,
479         address _to,
480         uint256 _tokenId,
481         bytes _data
482     )
483         public
484         canTransfer(_tokenId)
485     {
486         transferFrom(_from, _to, _tokenId);
487         // solium-disable-next-line arg-overflow
488         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
489     }
490 
491     /**
492     * @dev Returns whether the given spender can transfer a given token ID
493     * @param _spender address of the spender to query
494     * @param _tokenId uint256 ID of the token to be transferred
495     * @return bool whether the msg.sender is approved for the given token ID,
496     *  is an operator of the owner, or is the owner of the token
497     */
498     function isApprovedOrOwner(
499         address _spender,
500         uint256 _tokenId
501     )
502         internal
503         view
504         returns (bool)
505     {
506         address owner = ownerOf(_tokenId);
507         // Disable solium check because of
508         // https://github.com/duaraghav8/Solium/issues/175
509         // solium-disable-next-line operator-whitespace
510         return (
511         _spender == owner ||
512         getApproved(_tokenId) == _spender ||
513         isApprovedForAll(owner, _spender)
514         );
515     }
516 
517     /**
518     * @dev Internal function to mint a new token
519     * @dev Reverts if the given token ID already exists
520     * @param _to The address that will own the minted token
521     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
522     */
523     function _mint(address _to, uint256 _tokenId) internal {
524         require(_to != address(0));
525         addTokenTo(_to, _tokenId);
526         emit Transfer(address(0), _to, _tokenId);
527     }
528 
529     /**
530     * @dev Internal function to burn a specific token
531     * @dev Reverts if the token does not exist
532     * @param _tokenId uint256 ID of the token being burned by the msg.sender
533     */
534     function _burn(address _owner, uint256 _tokenId) internal {
535         clearApproval(_owner, _tokenId);
536         removeTokenFrom(_owner, _tokenId);
537         emit Transfer(_owner, address(0), _tokenId);
538     }
539 
540     /**
541     * @dev Internal function to clear current approval of a given token ID
542     * @dev Reverts if the given address is not indeed the owner of the token
543     * @param _owner owner of the token
544     * @param _tokenId uint256 ID of the token to be transferred
545     */
546     function clearApproval(address _owner, uint256 _tokenId) internal {
547         require(ownerOf(_tokenId) == _owner);
548         if (tokenApprovals[_tokenId] != address(0)) {
549             tokenApprovals[_tokenId] = address(0);
550             emit Approval(_owner, address(0), _tokenId);
551         }
552     }
553 
554     /**
555     * @dev Internal function to add a token ID to the list of a given address
556     * @param _to address representing the new owner of the given token ID
557     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
558     */
559     function addTokenTo(address _to, uint256 _tokenId) internal {
560         require(tokenOwner[_tokenId] == address(0));
561         tokenOwner[_tokenId] = _to;
562         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
563     }
564 
565     /**
566     * @dev Internal function to remove a token ID from the list of a given address
567     * @param _from address representing the previous owner of the given token ID
568     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
569     */
570     function removeTokenFrom(address _from, uint256 _tokenId) internal {
571         require(ownerOf(_tokenId) == _from);
572         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
573         tokenOwner[_tokenId] = address(0);
574     }
575 
576     /**
577     * @dev Internal function to invoke `onERC721Received` on a target address
578     * @dev The call is not executed if the target address is not a contract
579     * @param _from address representing the previous owner of the given token ID
580     * @param _to target address that will receive the tokens
581     * @param _tokenId uint256 ID of the token to be transferred
582     * @param _data bytes optional data to send along with the call
583     * @return whether the call correctly returned the expected magic value
584     */
585     function checkAndCallSafeTransfer(
586         address _from,
587         address _to,
588         uint256 _tokenId,
589         bytes _data
590     )
591         internal
592         returns (bool)
593     {
594         if (!_to.isContract()) {
595             return true;
596         }
597         bytes4 retval = ERC721Receiver(_to).onERC721Received(
598         _from, _tokenId, _data);
599         return (retval == ERC721_RECEIVED);
600     }
601 }
602 
603 /**
604  * @title ERC721 token receiver interface
605  * @dev Interface for any contract that wants to support safeTransfers
606  *  from ERC721 asset contracts.
607  */
608 contract ERC721Receiver {
609     /**
610     * @dev Magic value to be returned upon successful reception of an NFT
611     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
612     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
613     */
614     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
615 
616     /**
617     * @notice Handle the receipt of an NFT
618     * @dev The ERC721 smart contract calls this function on the recipient
619     *  after a `safetransfer`. This function MAY throw to revert and reject the
620     *  transfer. This function MUST use 50,000 gas or less. Return of other
621     *  than the magic value MUST result in the transaction being reverted.
622     *  Note: the contract address is always the message sender.
623     * @param _from The sending address
624     * @param _tokenId The NFT identifier which is being transfered
625     * @param _data Additional data with no specified format
626     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
627     */
628     function onERC721Received(
629         address _from,
630         uint256 _tokenId,
631         bytes _data
632     )
633         public
634         returns(bytes4);
635 }
636 contract ERC721Holder is ERC721Receiver {
637     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
638         return ERC721_RECEIVED;
639     }
640 }
641 
642 /**
643  * @title Full ERC721 Token
644  * This implementation includes all the required and some optional functionality of the ERC721 standard
645  * Moreover, it includes approve all functionality using operator terminology
646  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
647  */
648 contract ERC721Token is ERC721, ERC721BasicToken {
649 
650     // Token name
651     string internal name_;
652 
653     // Token symbol
654     string internal symbol_;
655 
656     // Mapping from owner to list of owned token IDs
657     mapping(address => uint256[]) internal ownedTokens;
658 
659     // Mapping from token ID to index of the owner tokens list
660     mapping(uint256 => uint256) internal ownedTokensIndex;
661 
662     // Array with all token ids, used for enumeration
663     uint256[] internal allTokens;
664 
665     // Mapping from token id to position in the allTokens array
666     mapping(uint256 => uint256) internal allTokensIndex;
667 
668     // Base Server Address for Token MetaData URI
669     string internal tokenURIBase;
670 
671     /**
672     * @dev Returns an URI for a given token ID. Only returns the based location, you will have to appending a token ID to this
673     * @dev Throws if the token ID does not exist. May return an empty string.
674     * @param _tokenId uint256 ID of the token to query
675     */
676     function tokenURI(uint256 _tokenId) public view returns (string) {
677         require(exists(_tokenId));
678         return tokenURIBase;
679     }
680 
681     /**
682     * @dev Gets the token ID at a given index of the tokens list of the requested owner
683     * @param _owner address owning the tokens list to be accessed
684     * @param _index uint256 representing the index to be accessed of the requested tokens list
685     * @return uint256 token ID at the given index of the tokens list owned by the requested address
686     */
687     function tokenOfOwnerByIndex(
688         address _owner,
689         uint256 _index
690     )
691         public
692         view
693         returns (uint256)
694     {
695         require(_index < balanceOf(_owner));
696         return ownedTokens[_owner][_index];
697     }
698 
699     /**
700     * @dev Gets the total amount of tokens stored by the contract
701     * @return uint256 representing the total amount of tokens
702     */
703     function totalSupply() public view returns (uint256) {
704         return allTokens.length;
705     }
706 
707     /**
708     * @dev Gets the token ID at a given index of all the tokens in this contract
709     * @dev Reverts if the index is greater or equal to the total number of tokens
710     * @param _index uint256 representing the index to be accessed of the tokens list
711     * @return uint256 token ID at the given index of the tokens list
712     */
713     function tokenByIndex(uint256 _index) public view returns (uint256) {
714         require(_index < totalSupply());
715         return allTokens[_index];
716     }
717 
718 
719     /**
720     * @dev Internal function to set the token URI for a given token
721     * @dev Reverts if the token ID does not exist
722     * @param _uri string URI to assign
723     */
724     function _setTokenURIBase(string _uri) internal {
725         tokenURIBase = _uri;
726     }
727 
728     /**
729     * @dev Internal function to add a token ID to the list of a given address
730     * @param _to address representing the new owner of the given token ID
731     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
732     */
733     function addTokenTo(address _to, uint256 _tokenId) internal {
734         super.addTokenTo(_to, _tokenId);
735         uint256 length = ownedTokens[_to].length;
736         ownedTokens[_to].push(_tokenId);
737         ownedTokensIndex[_tokenId] = length;
738     }
739 
740     /**
741     * @dev Internal function to remove a token ID from the list of a given address
742     * @param _from address representing the previous owner of the given token ID
743     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
744     */
745     function removeTokenFrom(address _from, uint256 _tokenId) internal {
746         super.removeTokenFrom(_from, _tokenId);
747 
748         uint256 tokenIndex = ownedTokensIndex[_tokenId];
749         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
750         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
751 
752         ownedTokens[_from][tokenIndex] = lastToken;
753         ownedTokens[_from][lastTokenIndex] = 0;
754         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
755         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
756         // the lastToken to the first position, and then dropping the element placed in the last position of the list
757 
758         ownedTokens[_from].length--;
759         ownedTokensIndex[_tokenId] = 0;
760         ownedTokensIndex[lastToken] = tokenIndex;
761     }
762 
763     /**
764     * @dev Gets the token name
765     * @return string representing the token name
766     */
767     function name() public view returns (string) {
768         return name_;
769     }
770 
771     /**
772     * @dev Gets the token symbol
773     * @return string representing the token symbol
774     */
775     function symbol() public view returns (string) {
776         return symbol_;
777     }
778 
779     /**
780     * @dev Internal function to mint a new token
781     * @dev Reverts if the given token ID already exists
782     * @param _to address the beneficiary that will own the minted token
783     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
784     */
785     function _mint(address _to, uint256 _tokenId) internal {
786         super._mint(_to, _tokenId);
787 
788         allTokensIndex[_tokenId] = allTokens.length;
789         allTokens.push(_tokenId);
790     }
791 
792     /**
793     * @dev Internal function to burn a specific token
794     * @dev Reverts if the token does not exist
795     * @param _owner owner of the token to burn
796     * @param _tokenId uint256 ID of the token being burned by the msg.sender
797     */
798     function _burn(address _owner, uint256 _tokenId) internal {
799         super._burn(_owner, _tokenId);
800 
801         // Reorg all tokens array
802         uint256 tokenIndex = allTokensIndex[_tokenId];
803         uint256 lastTokenIndex = allTokens.length.sub(1);
804         uint256 lastToken = allTokens[lastTokenIndex];
805 
806         allTokens[tokenIndex] = lastToken;
807         allTokens[lastTokenIndex] = 0;
808 
809         allTokens.length--;
810         allTokensIndex[_tokenId] = 0;
811         allTokensIndex[lastToken] = tokenIndex;
812     }
813 
814     bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
815     /*
816     bytes4(keccak256('supportsInterface(bytes4)'));
817     */
818 
819     bytes4 constant InterfaceSignature_ERC721Enumerable = 0x780e9d63;
820     /*
821     bytes4(keccak256('totalSupply()')) ^
822     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
823     bytes4(keccak256('tokenByIndex(uint256)'));
824     */
825 
826     bytes4 constant InterfaceSignature_ERC721Metadata = 0x5b5e139f;
827     /*
828     bytes4(keccak256('name()')) ^
829     bytes4(keccak256('symbol()')) ^
830     bytes4(keccak256('tokenURI(uint256)'));
831     */
832 
833     bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
834     /*
835     bytes4(keccak256('balanceOf(address)')) ^
836     bytes4(keccak256('ownerOf(uint256)')) ^
837     bytes4(keccak256('approve(address,uint256)')) ^
838     bytes4(keccak256('getApproved(uint256)')) ^
839     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
840     bytes4(keccak256('isApprovedForAll(address,address)')) ^
841     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
842     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
843     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
844     */
845 
846     bytes4 public constant InterfaceSignature_ERC721Optional =- 0x4f558e79;
847     /*
848     bytes4(keccak256('exists(uint256)'));
849     */
850 
851     /**
852     * @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
853     * @dev Returns true for any standardized interfaces implemented by this contract.
854     * @param _interfaceID bytes4 the interface to check for
855     * @return true for any standardized interfaces implemented by this contract.
856     */
857     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
858     {
859         return ((_interfaceID == InterfaceSignature_ERC165)
860         || (_interfaceID == InterfaceSignature_ERC721)
861         || (_interfaceID == InterfaceSignature_ERC721Enumerable)
862         || (_interfaceID == InterfaceSignature_ERC721Metadata));
863     }
864 
865     function implementsERC721() public pure returns (bool) {
866         return true;
867     }
868 
869 }
870 
871 contract CSCNFTFactory is ERC721Token, OperationalControl {
872 
873     /*** EVENTS ***/
874     /// @dev The Created event is fired whenever a new asset comes into existence.
875     event AssetCreated(address owner, uint256 assetId, uint256 assetType, uint256 sequenceId, uint256 creationTime);
876 
877     event DetachRequest(address owner, uint256 assetId, uint256 timestamp);
878 
879     event NFTDetached(address requester, uint256 assetId);
880 
881     event NFTAttached(address requester, uint256 assetId);
882 
883     // Mapping from assetId to uint encoded data for NFT
884     mapping(uint256 => uint256) internal nftDataA;
885     mapping(uint256 => uint128) internal nftDataB;
886 
887     // Mapping from Asset Types to count of that type in exsistance
888     mapping(uint32 => uint64) internal assetTypeTotalCount;
889 
890     mapping(uint32 => uint64) internal assetTypeBurnedCount;
891   
892     // Mapping from index of a Asset Type to get AssetID
893     mapping(uint256 => mapping(uint32 => uint64) ) internal sequenceIDToTypeForID;
894 
895      // Mapping from Asset Type to string name of type
896     mapping(uint256 => string) internal assetTypeName;
897 
898     // Mapping from assetType to creation limit
899     mapping(uint256 => uint32) internal assetTypeCreationLimit;
900 
901     // Indicates if attached system is Active (Transfers will be blocked if attached and active)
902     bool public attachedSystemActive;
903 
904     // Is Asset Burning Active
905     bool public canBurn;
906 
907     // Time LS Oracle has to respond to detach requests
908     uint32 public detachmentTime = 300;
909 
910     /**
911     * @dev Constructor function
912     */
913     constructor() public {
914         require(msg.sender != address(0));
915         paused = true;
916         error = false;
917         canBurn = false;
918         managerPrimary = msg.sender;
919         managerSecondary = msg.sender;
920         bankManager = msg.sender;
921 
922         name_ = "CSCNFTFactory";
923         symbol_ = "CSCNFT";
924     }
925 
926     /**
927     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
928     * @param _tokenId uint256 ID of the token to validate
929     */
930     modifier canTransfer(uint256 _tokenId) {
931         uint256 isAttached = getIsNFTAttached(_tokenId);
932         if(isAttached == 2) {
933             //One-Time Auth for Physical Card Transfers
934             require(msg.sender == managerPrimary ||
935                 msg.sender == managerSecondary ||
936                 msg.sender == bankManager ||
937                 otherManagers[msg.sender] == 1
938             );
939             updateIsAttached(_tokenId, 1);
940         } else if(attachedSystemActive == true && isAttached >= 1) {
941             require(msg.sender == managerPrimary ||
942                 msg.sender == managerSecondary ||
943                 msg.sender == bankManager ||
944                 otherManagers[msg.sender] == 1
945             );
946         }
947         else {
948             require(isApprovedOrOwner(msg.sender, _tokenId));
949         }
950         
951     _;
952     }
953 
954     /** Public Functions */
955 
956     // Returns the AssetID for the Nth assetID for a specific type
957     function getAssetIDForTypeSequenceID(uint256 _seqId, uint256 _type) public view returns (uint256 _assetID) {
958         return sequenceIDToTypeForID[_seqId][uint32(_type)];
959     }
960 
961     function getAssetDetails(uint256 _assetId) public view returns(
962         uint256 assetId,
963         uint256 ownersIndex,
964         uint256 assetTypeSeqId,
965         uint256 assetType,
966         uint256 createdTimestamp,
967         uint256 isAttached,
968         address creator,
969         address owner
970     ) {
971         require(exists(_assetId));
972 
973         uint256 nftData = nftDataA[_assetId];
974         uint256 nftDataBLocal = nftDataB[_assetId];
975 
976         assetId = _assetId;
977         ownersIndex = ownedTokensIndex[_assetId];
978         createdTimestamp = uint256(uint48(nftData>>160));
979         assetType = uint256(uint32(nftData>>208));
980         assetTypeSeqId = uint256(uint64(nftDataBLocal));
981         isAttached = uint256(uint48(nftDataBLocal>>64));
982         creator = address(nftData);
983         owner = ownerOf(_assetId);
984     }
985 
986     function totalSupplyOfType(uint256 _type) public view returns (uint256 _totalOfType) {
987         return assetTypeTotalCount[uint32(_type)] - assetTypeBurnedCount[uint32(_type)];
988     }
989 
990     function totalCreatedOfType(uint256 _type) public view returns (uint256 _totalOfType) {
991         return assetTypeTotalCount[uint32(_type)];
992     }
993 
994     function totalBurnedOfType(uint256 _type) public view returns (uint256 _totalOfType) {
995         return assetTypeBurnedCount[uint32(_type)];
996     }
997 
998     function getAssetRawMeta(uint256 _assetId) public view returns(
999         uint256 dataA,
1000         uint128 dataB
1001     ) {
1002         require(exists(_assetId));
1003 
1004         dataA = nftDataA[_assetId];
1005         dataB = nftDataB[_assetId];
1006     }
1007 
1008     function getAssetIdItemType(uint256 _assetId) public view returns(
1009         uint256 assetType
1010     ) {
1011         require(exists(_assetId));
1012         uint256 dataA = nftDataA[_assetId];
1013         assetType = uint256(uint32(dataA>>208));
1014     }
1015 
1016     function getAssetIdTypeSequenceId(uint256 _assetId) public view returns(
1017         uint256 assetTypeSequenceId
1018     ) {
1019         require(exists(_assetId));
1020         uint256 dataB = nftDataB[_assetId];
1021         assetTypeSequenceId = uint256(uint64(dataB));
1022     }
1023     
1024     function getIsNFTAttached( uint256 _assetId) 
1025     public view returns(
1026         uint256 isAttached
1027     ) {
1028         uint256 nftData = nftDataB[_assetId];
1029         isAttached = uint256(uint48(nftData>>64));
1030     }
1031 
1032     function getAssetIdCreator(uint256 _assetId) public view returns(
1033         address creator
1034     ) {
1035         require(exists(_assetId));
1036         uint256 dataA = nftDataA[_assetId];
1037         creator = address(dataA);
1038     }
1039 
1040     function isAssetIdOwnerOrApproved(address requesterAddress, uint256 _assetId) public view returns(
1041         bool
1042     ) {
1043         return isApprovedOrOwner(requesterAddress, _assetId);
1044     }
1045 
1046     function getAssetIdOwner(uint256 _assetId) public view returns(
1047         address owner
1048     ) {
1049         require(exists(_assetId));
1050 
1051         owner = ownerOf(_assetId);
1052     }
1053 
1054     function getAssetIdOwnerIndex(uint256 _assetId) public view returns(
1055         uint256 ownerIndex
1056     ) {
1057         require(exists(_assetId));
1058         ownerIndex = ownedTokensIndex[_assetId];
1059     }
1060 
1061     /// @param _owner The owner whose ships tokens we are interested in.
1062     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1063     ///  expensive (it walks the entire NFT owners array looking for NFT belonging to owner),
1064     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
1065     ///  not contract-to-contract calls.
1066     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
1067         uint256 tokenCount = balanceOf(_owner);
1068 
1069         if (tokenCount == 0) {
1070             // Return an empty array
1071             return new uint256[](0);
1072         } else {
1073             uint256[] memory result = new uint256[](tokenCount);
1074             uint256 resultIndex = 0;
1075 
1076             // We count on the fact that all Asset have IDs starting at 0 and increasing
1077             // sequentially up to the total count.
1078             uint256 _itemIndex;
1079 
1080             for (_itemIndex = 0; _itemIndex < tokenCount; _itemIndex++) {
1081                 result[resultIndex] = tokenOfOwnerByIndex(_owner,_itemIndex);
1082                 resultIndex++;
1083             }
1084 
1085             return result;
1086         }
1087     }
1088 
1089     // Get the name of the Asset type
1090     function getTypeName (uint32 _type) public returns(string) {
1091         return assetTypeName[_type];
1092     }
1093 
1094 
1095     /**
1096     * @dev Transfers the ownership of a given token ID to another address, modified to prevent transfer if attached and system is active
1097     */
1098     function transferFrom(
1099         address _from,
1100         address _to,
1101         uint256 _tokenId
1102     )
1103         public
1104         canTransfer(_tokenId)
1105     {
1106         require(_from != address(0));
1107         require(_to != address(0));
1108 
1109         clearApproval(_from, _tokenId);
1110         removeTokenFrom(_from, _tokenId);
1111         addTokenTo(_to, _tokenId);
1112 
1113         emit Transfer(_from, _to, _tokenId);
1114     }
1115     
1116 
1117     
1118     function multiBatchTransferFrom(
1119         uint256[] _assetIds, 
1120         address[] _fromB, 
1121         address[] _toB) 
1122         public
1123     {
1124         uint256 _id;
1125         address _to;
1126         address _from;
1127         
1128         for (uint256 i = 0; i < _assetIds.length; ++i) {
1129             _id = _assetIds[i];
1130             _to = _toB[i];
1131             _from = _fromB[i];
1132 
1133             require(isApprovedOrOwner(msg.sender, _id));
1134 
1135             require(_from != address(0));
1136             require(_to != address(0));
1137     
1138             clearApproval(_from, _id);
1139             removeTokenFrom(_from, _id);
1140             addTokenTo(_to, _id);
1141     
1142             emit Transfer(_from, _to, _id);
1143         }
1144         
1145     }
1146     
1147     function batchTransferFrom(uint256[] _assetIds, address _from, address _to) 
1148         public
1149     {
1150         uint256 _id;
1151         
1152         for (uint256 i = 0; i < _assetIds.length; ++i) {
1153             _id = _assetIds[i];
1154 
1155             require(isApprovedOrOwner(msg.sender, _id));
1156 
1157             require(_from != address(0));
1158             require(_to != address(0));
1159     
1160             clearApproval(_from, _id);
1161             removeTokenFrom(_from, _id);
1162             addTokenTo(_to, _id);
1163     
1164             emit Transfer(_from, _to, _id);
1165         }
1166     }
1167     
1168     function multiBatchSafeTransferFrom(
1169         uint256[] _assetIds, 
1170         address[] _fromB, 
1171         address[] _toB
1172         )
1173         public
1174     {
1175         uint256 _id;
1176         address _to;
1177         address _from;
1178         
1179         for (uint256 i = 0; i < _assetIds.length; ++i) {
1180             _id = _assetIds[i];
1181             _to  = _toB[i];
1182             _from  = _fromB[i];
1183 
1184             safeTransferFrom(_from, _to, _id);
1185         }
1186     }
1187 
1188     function batchSafeTransferFrom(
1189         uint256[] _assetIds, 
1190         address _from, 
1191         address _to
1192         )
1193         public
1194     {
1195         uint256 _id;
1196         for (uint256 i = 0; i < _assetIds.length; ++i) {
1197             _id = _assetIds[i];
1198             safeTransferFrom(_from, _to, _id);
1199         }
1200     }
1201 
1202 
1203     function batchApprove(
1204         uint256[] _assetIds, 
1205         address _spender
1206         )
1207         public
1208     {
1209         uint256 _id;
1210         for (uint256 i = 0; i < _assetIds.length; ++i) {
1211             _id = _assetIds[i];
1212             approve(_spender, _id);
1213         }
1214         
1215     }
1216 
1217 
1218     function batchSetApprovalForAll(
1219         address[] _spenders,
1220         bool _approved
1221         )
1222         public
1223     {
1224         address _spender;
1225         for (uint256 i = 0; i < _spenders.length; ++i) {
1226             _spender = _spenders[i];
1227             setApprovalForAll(_spender, _approved);
1228         }
1229     }  
1230     
1231     function requestDetachment(
1232         uint256 _tokenId
1233     )
1234         public
1235     {
1236         //Request can only be made by owner or approved address
1237         require(isApprovedOrOwner(msg.sender, _tokenId));
1238 
1239         uint256 isAttached = getIsNFTAttached(_tokenId);
1240 
1241         require(isAttached >= 1);
1242 
1243         if(attachedSystemActive == true) {
1244             //Checks to see if request was made and if time elapsed
1245             if(isAttached > 1 && block.timestamp - isAttached > detachmentTime) {
1246                 isAttached = 0;
1247             } else if(isAttached > 1) {
1248                 //Fail if time is already set for attachment
1249                 require(isAttached == 1);
1250             } else {
1251                 //Is attached, set detachment time and make request to detach
1252                 emit DetachRequest(msg.sender, _tokenId, block.timestamp);
1253                 isAttached = block.timestamp;
1254             }           
1255         } else {
1256             isAttached = 0;
1257         } 
1258 
1259         if(isAttached == 0) {
1260             emit NFTDetached(msg.sender, _tokenId);
1261         }
1262 
1263         updateIsAttached(_tokenId, isAttached);
1264     }
1265 
1266     function attachAsset(
1267         uint256 _tokenId
1268     )
1269         public
1270         canTransfer(_tokenId)
1271     {
1272         uint256 isAttached = getIsNFTAttached(_tokenId);
1273 
1274         require(isAttached == 0);
1275         isAttached = 1;
1276 
1277         updateIsAttached(_tokenId, isAttached);
1278 
1279         emit NFTAttached(msg.sender, _tokenId);
1280     }
1281 
1282     function batchAttachAssets(uint256[] _ids) public {
1283         for(uint i = 0; i < _ids.length; i++) {
1284             attachAsset(_ids[i]);
1285         }
1286     }
1287 
1288     function batchDetachAssets(uint256[] _ids) public {
1289         for(uint i = 0; i < _ids.length; i++) {
1290             requestDetachment(_ids[i]);
1291         }
1292     }
1293 
1294     function requestDetachmentOnPause (uint256 _tokenId) public 
1295     whenPaused {
1296         //Request can only be made by owner or approved address
1297         require(isApprovedOrOwner(msg.sender, _tokenId));
1298 
1299         updateIsAttached(_tokenId, 0);
1300     }
1301 
1302     function batchBurnAssets(uint256[] _assetIDs) public {
1303         uint256 _id;
1304         for(uint i = 0; i < _assetIDs.length; i++) {
1305             _id = _assetIDs[i];
1306             burnAsset(_id);
1307         }
1308     }
1309 
1310     function burnAsset(uint256 _assetID) public {
1311         // Is Burn Enabled
1312         require(canBurn == true);
1313 
1314         // Deny Action if Attached
1315         require(getIsNFTAttached(_assetID) == 0);
1316 
1317         require(isApprovedOrOwner(msg.sender, _assetID) == true);
1318         
1319         //Updates Type Total Count
1320         uint256 _assetType = getAssetIdItemType(_assetID);
1321         assetTypeBurnedCount[uint32(_assetType)] += 1;
1322         
1323         _burn(msg.sender, _assetID);
1324     }
1325 
1326 
1327     /** Dev Functions */
1328 
1329     function setTokenURIBase (string _tokenURI) public onlyManager {
1330         _setTokenURIBase(_tokenURI);
1331     }
1332 
1333     function setPermanentLimitForType (uint32 _type, uint256 _limit) public onlyManager {
1334         //Only allows Limit to be set once
1335         require(assetTypeCreationLimit[_type] == 0);
1336 
1337         assetTypeCreationLimit[_type] = uint32(_limit);
1338     }
1339 
1340     function setTypeName (uint32 _type, string _name) public anyOperator {
1341         assetTypeName[_type] = _name;
1342     }
1343 
1344     // Minting Function
1345     function batchSpawnAsset(address _to, uint256[] _assetTypes, uint256[] _assetIds, uint256 _isAttached) public anyOperator {
1346         uint256 _id;
1347         uint256 _assetType;
1348         for(uint i = 0; i < _assetIds.length; i++) {
1349             _id = _assetIds[i];
1350             _assetType = _assetTypes[i];
1351             _createAsset(_to, _assetType, _id, _isAttached, address(0));
1352         }
1353     }
1354 
1355     function batchSpawnAsset(address[] _toB, uint256[] _assetTypes, uint256[] _assetIds, uint256 _isAttached) public anyOperator {
1356         address _to;
1357         uint256 _id;
1358         uint256 _assetType;
1359         for(uint i = 0; i < _assetIds.length; i++) {
1360             _to = _toB[i];
1361             _id = _assetIds[i];
1362             _assetType = _assetTypes[i];
1363             _createAsset(_to, _assetType, _id, _isAttached, address(0));
1364         }
1365     }
1366 
1367     function batchSpawnAssetWithCreator(address[] _toB, uint256[] _assetTypes, uint256[] _assetIds, uint256[] _isAttacheds, address[] _creators) public anyOperator {
1368         address _to;
1369         address _creator;
1370         uint256 _id;
1371         uint256 _assetType;
1372         uint256 _isAttached;
1373         for(uint i = 0; i < _assetIds.length; i++) {
1374             _to = _toB[i];
1375             _id = _assetIds[i];
1376             _assetType = _assetTypes[i];
1377             _creator = _creators[i];
1378             _isAttached = _isAttacheds[i];
1379             _createAsset(_to, _assetType, _id, _isAttached, _creator);
1380         }
1381     }
1382 
1383     function spawnAsset(address _to, uint256 _assetType, uint256 _assetID, uint256 _isAttached) public anyOperator {
1384         _createAsset(_to, _assetType, _assetID, _isAttached, address(0));
1385     }
1386 
1387     function spawnAssetWithCreator(address _to, uint256 _assetType, uint256 _assetID, uint256 _isAttached, address _creator) public anyOperator {
1388         _createAsset(_to, _assetType, _assetID, _isAttached, _creator);
1389     }
1390 
1391     /// @dev Remove all Ether from the contract, shouldn't have any but just incase.
1392     function withdrawBalance() public onlyBanker {
1393         // We are using this boolean method to make sure that even if one fails it will still work
1394         bankManager.transfer(address(this).balance);
1395     }
1396 
1397     // Burn Functions
1398 
1399     function setCanBurn(bool _state) public onlyManager {
1400         canBurn = _state;
1401     }
1402 
1403     function burnAssetOperator(uint256 _assetID) public anyOperator {
1404         
1405         require(getIsNFTAttached(_assetID) > 0);
1406 
1407         //Updates Type Total Count
1408         uint256 _assetType = getAssetIdItemType(_assetID);
1409         assetTypeBurnedCount[uint32(_assetType)] += 1;
1410         
1411         _burn(ownerOf(_assetID), _assetID);
1412     }
1413 
1414     function toggleAttachedEnforement (bool _state) public onlyManager {
1415         attachedSystemActive = _state;
1416     }
1417 
1418     function setDetachmentTime (uint256 _time) public onlyManager {
1419         //Detactment Time can not be set greater than 2 weeks.
1420         require(_time <= 1209600);
1421         detachmentTime = uint32(_time);
1422     }
1423 
1424     function setNFTDetached(uint256 _assetID) public anyOperator {
1425         require(getIsNFTAttached(_assetID) > 0);
1426 
1427         updateIsAttached(_assetID, 0);
1428         emit NFTDetached(msg.sender, _assetID);
1429     }
1430 
1431     function setBatchDetachCollectibles(uint256[] _assetIds) public anyOperator {
1432         uint256 _id;
1433         for(uint i = 0; i < _assetIds.length; i++) {
1434             _id = _assetIds[i];
1435             setNFTDetached(_id);
1436         }
1437     }
1438 
1439 
1440 
1441     /** Internal Functions */
1442 
1443     // @dev For creating NFT Collectible
1444     function _createAsset(address _to, uint256 _assetType, uint256 _assetID, uint256 _attachState, address _creator) internal returns(uint256) {
1445         
1446         uint256 _sequenceId = uint256(assetTypeTotalCount[uint32(_assetType)]) + 1;
1447 
1448         //Will not allow creation if over limit
1449         require(assetTypeCreationLimit[uint32(_assetType)] == 0 || assetTypeCreationLimit[uint32(_assetType)] > _sequenceId);
1450         
1451         // These requires are not strictly necessary, our calling code should make
1452         // sure that these conditions are never broken.
1453         require(_sequenceId == uint256(uint64(_sequenceId)));
1454 
1455         //Creates NFT
1456         _mint(_to, _assetID);
1457 
1458         uint256 nftData = uint256(_creator); // 160 bit address of creator
1459         nftData |= now<<160; // 48 bit creation timestamp
1460         nftData |= _assetType<<208; // 32 bit item type 
1461 
1462         uint256 nftDataContinued = uint256(_sequenceId); // 64 bit sequence id of item
1463         nftDataContinued |= _attachState<<64; // 48 bit state and/or timestamp for detachment
1464 
1465         nftDataA[_assetID] = nftData;
1466         nftDataB[_assetID] = uint128(nftDataContinued);
1467 
1468         assetTypeTotalCount[uint32(_assetType)] += 1;
1469         sequenceIDToTypeForID[_sequenceId][uint32(_assetType)] = uint64(_assetID);
1470 
1471         // emit Created event
1472         emit AssetCreated(_to, _assetID, _assetType, _sequenceId, now);
1473 
1474         return _assetID;
1475     }
1476 
1477     function updateIsAttached(uint256 _assetID, uint256 _isAttached) 
1478     internal
1479     {
1480         uint256 nftData = nftDataB[_assetID];
1481 
1482         uint256 assetTypeSeqId = uint256(uint64(nftData));
1483 
1484         uint256 nftDataContinued = uint256(assetTypeSeqId); // 64 bit sequence id of item
1485         nftDataContinued |= _isAttached<<64; // 48 bit state and/or timestamp for detachment
1486 
1487         nftDataB[_assetID] = uint128(nftDataContinued);
1488     }
1489 
1490 
1491 
1492 }