1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address private _owner;
74 
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() internal {
85     _owner = msg.sender;
86     emit OwnershipTransferred(address(0), _owner);
87   }
88 
89   /**
90    * @return the address of the owner.
91    */
92   function owner() public view returns(address) {
93     return _owner;
94   }
95 
96   /**
97    * @dev Throws if called by any account other than the owner.
98    */
99   modifier onlyOwner() {
100     require(isOwner());
101     _;
102   }
103 
104   /**
105    * @return true if `msg.sender` is the owner of the contract.
106    */
107   function isOwner() public view returns(bool) {
108     return msg.sender == _owner;
109   }
110 
111   /**
112    * @dev Allows the current owner to relinquish control of the contract.
113    * @notice Renouncing to ownership will leave the contract without an owner.
114    * It will not be possible to call the functions with the `onlyOwner`
115    * modifier anymore.
116    */
117   function renounceOwnership() public onlyOwner {
118     emit OwnershipTransferred(_owner, address(0));
119     _owner = address(0);
120   }
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) public onlyOwner {
127     _transferOwnership(newOwner);
128   }
129 
130   /**
131    * @dev Transfers control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function _transferOwnership(address newOwner) internal {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(_owner, newOwner);
137     _owner = newOwner;
138   }
139 }
140 
141 /**
142  * @title Roles
143  * @dev Library for managing addresses assigned to a Role.
144  */
145 library Roles {
146   struct Role {
147     mapping (address => bool) bearer;
148   }
149 
150   /**
151    * @dev give an account access to this role
152    */
153   function add(Role storage role, address account) internal {
154     require(account != address(0));
155     require(!has(role, account));
156 
157     role.bearer[account] = true;
158   }
159 
160   /**
161    * @dev remove an account's access to this role
162    */
163   function remove(Role storage role, address account) internal {
164     require(account != address(0));
165     require(has(role, account));
166 
167     role.bearer[account] = false;
168   }
169 
170   /**
171    * @dev check if an account has this role
172    * @return bool
173    */
174   function has(Role storage role, address account)
175     internal
176     view
177     returns (bool)
178   {
179     require(account != address(0));
180     return role.bearer[account];
181   }
182 }
183 
184 contract PauserRole {
185   using Roles for Roles.Role;
186 
187   event PauserAdded(address indexed account);
188   event PauserRemoved(address indexed account);
189 
190   Roles.Role private pausers;
191 
192   constructor() internal {
193     _addPauser(msg.sender);
194   }
195 
196   modifier onlyPauser() {
197     require(isPauser(msg.sender));
198     _;
199   }
200 
201   function isPauser(address account) public view returns (bool) {
202     return pausers.has(account);
203   }
204 
205   function addPauser(address account) public onlyPauser {
206     _addPauser(account);
207   }
208 
209   function renouncePauser() public {
210     _removePauser(msg.sender);
211   }
212 
213   function _addPauser(address account) internal {
214     pausers.add(account);
215     emit PauserAdded(account);
216   }
217 
218   function _removePauser(address account) internal {
219     pausers.remove(account);
220     emit PauserRemoved(account);
221   }
222 }
223 
224 
225 
226 /**
227  * @title Pausable
228  * @dev Base contract which allows children to implement an emergency stop mechanism.
229  */
230 contract Pausable is PauserRole {
231   event Paused(address account);
232   event Unpaused(address account);
233 
234   bool private _paused;
235 
236   constructor() internal {
237     _paused = false;
238   }
239 
240   /**
241    * @return true if the contract is paused, false otherwise.
242    */
243   function paused() public view returns(bool) {
244     return _paused;
245   }
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is not paused.
249    */
250   modifier whenNotPaused() {
251     require(!_paused);
252     _;
253   }
254 
255   /**
256    * @dev Modifier to make a function callable only when the contract is paused.
257    */
258   modifier whenPaused() {
259     require(_paused);
260     _;
261   }
262 
263   /**
264    * @dev called by the owner to pause, triggers stopped state
265    */
266   function pause() public onlyPauser whenNotPaused {
267     _paused = true;
268     emit Paused(msg.sender);
269   }
270 
271   /**
272    * @dev called by the owner to unpause, returns to normal state
273    */
274   function unpause() public onlyPauser whenPaused {
275     _paused = false;
276     emit Unpaused(msg.sender);
277   }
278 }
279 
280 /**
281  * @title IERC165
282  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
283  */
284 interface IERC165 {
285 
286   /**
287    * @notice Query if a contract implements an interface
288    * @param interfaceId The interface identifier, as specified in ERC-165
289    * @dev Interface identification is specified in ERC-165. This function
290    * uses less than 30,000 gas.
291    */
292   function supportsInterface(bytes4 interfaceId)
293     external
294     view
295     returns (bool);
296 }
297 
298 /**
299  * @title ERC165
300  * @author Matt Condon (@shrugs)
301  * @dev Implements ERC165 using a lookup table.
302  */
303 contract ERC165 is IERC165 {
304 
305   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
306   /**
307    * 0x01ffc9a7 ===
308    *   bytes4(keccak256('supportsInterface(bytes4)'))
309    */
310 
311   /**
312    * @dev a mapping of interface id to whether or not it's supported
313    */
314   mapping(bytes4 => bool) private _supportedInterfaces;
315 
316   /**
317    * @dev A contract implementing SupportsInterfaceWithLookup
318    * implement ERC165 itself
319    */
320   constructor()
321     internal
322   {
323     _registerInterface(_InterfaceId_ERC165);
324   }
325 
326   /**
327    * @dev implement supportsInterface(bytes4) using a lookup table
328    */
329   function supportsInterface(bytes4 interfaceId)
330     external
331     view
332     returns (bool)
333   {
334     return _supportedInterfaces[interfaceId];
335   }
336 
337   /**
338    * @dev internal method for registering an interface
339    */
340   function _registerInterface(bytes4 interfaceId)
341     internal
342   {
343     require(interfaceId != 0xffffffff);
344     _supportedInterfaces[interfaceId] = true;
345   }
346 }
347 
348 
349 /**
350  * @title ERC721 Non-Fungible Token Standard basic interface
351  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
352  */
353 contract IERC721 is IERC165 {
354 
355   event Transfer(
356     address indexed from,
357     address indexed to,
358     uint256 indexed tokenId
359   );
360   event Approval(
361     address indexed owner,
362     address indexed approved,
363     uint256 indexed tokenId
364   );
365   event ApprovalForAll(
366     address indexed owner,
367     address indexed operator,
368     bool approved
369   );
370 
371   function balanceOf(address owner) public view returns (uint256 balance);
372   function ownerOf(uint256 tokenId) public view returns (address owner);
373 
374   function approve(address to, uint256 tokenId) public;
375   function getApproved(uint256 tokenId)
376     public view returns (address operator);
377 
378   function setApprovalForAll(address operator, bool _approved) public;
379   function isApprovedForAll(address owner, address operator)
380     public view returns (bool);
381 
382   function transferFrom(address from, address to, uint256 tokenId) public;
383   function safeTransferFrom(address from, address to, uint256 tokenId)
384     public;
385 
386   function safeTransferFrom(
387     address from,
388     address to,
389     uint256 tokenId,
390     bytes data
391   )
392     public;
393 }
394 
395 
396 
397 /**
398  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
399  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
400  */
401 contract IERC721Metadata is IERC721 {
402   function name() external view returns (string);
403   function symbol() external view returns (string);
404   function tokenURI(uint256 tokenId) external view returns (string);
405 }
406 
407 
408 /**
409  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
410  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
411  */
412 contract IERC721Enumerable is IERC721 {
413   function totalSupply() public view returns (uint256);
414   function tokenOfOwnerByIndex(
415     address owner,
416     uint256 index
417   )
418     public
419     view
420     returns (uint256 tokenId);
421 
422   function tokenByIndex(uint256 index) public view returns (uint256);
423 }
424 
425 /**
426  * @title ERC721 token receiver interface
427  * @dev Interface for any contract that wants to support safeTransfers
428  * from ERC721 asset contracts.
429  */
430 contract IERC721Receiver {
431   /**
432    * @notice Handle the receipt of an NFT
433    * @dev The ERC721 smart contract calls this function on the recipient
434    * after a `safeTransfer`. This function MUST return the function selector,
435    * otherwise the caller will revert the transaction. The selector to be
436    * returned can be obtained as `this.onERC721Received.selector`. This
437    * function MAY throw to revert and reject the transfer.
438    * Note: the ERC721 contract address is always the message sender.
439    * @param operator The address which called `safeTransferFrom` function
440    * @param from The address which previously owned the token
441    * @param tokenId The NFT identifier which is being transferred
442    * @param data Additional data with no specified format
443    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
444    */
445   function onERC721Received(
446     address operator,
447     address from,
448     uint256 tokenId,
449     bytes data
450   )
451     public
452     returns(bytes4);
453 }
454 
455 /**
456  * Utility library of inline functions on addresses
457  */
458 library Address {
459 
460   /**
461    * Returns whether the target address is a contract
462    * @dev This function will return false if invoked during the constructor of a contract,
463    * as the code is not actually created until after the constructor finishes.
464    * @param account address of the account to check
465    * @return whether the target address is a contract
466    */
467   function isContract(address account) internal view returns (bool) {
468     uint256 size;
469     // XXX Currently there is no better way to check if there is a contract in an address
470     // than to check the size of the code at that address.
471     // See https://ethereum.stackexchange.com/a/14016/36603
472     // for more details about how this works.
473     // TODO Check this again before the Serenity release, because all addresses will be
474     // contracts then.
475     // solium-disable-next-line security/no-inline-assembly
476     assembly { size := extcodesize(account) }
477     return size > 0;
478   }
479 
480 }
481 
482 
483 /**
484  * @title ERC721 Non-Fungible Token Standard basic implementation
485  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
486  */
487 contract ERC721 is ERC165, IERC721 {
488 
489   using SafeMath for uint256;
490   using Address for address;
491 
492   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
493   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
494   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
495 
496   // Mapping from token ID to owner
497   mapping (uint256 => address) private _tokenOwner;
498 
499   // Mapping from token ID to approved address
500   mapping (uint256 => address) private _tokenApprovals;
501 
502   // Mapping from owner to number of owned token
503   mapping (address => uint256) private _ownedTokensCount;
504 
505   // Mapping from owner to operator approvals
506   mapping (address => mapping (address => bool)) private _operatorApprovals;
507 
508   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
509   /*
510    * 0x80ac58cd ===
511    *   bytes4(keccak256('balanceOf(address)')) ^
512    *   bytes4(keccak256('ownerOf(uint256)')) ^
513    *   bytes4(keccak256('approve(address,uint256)')) ^
514    *   bytes4(keccak256('getApproved(uint256)')) ^
515    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
516    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
517    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
518    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
519    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
520    */
521 
522   constructor()
523     public
524   {
525     // register the supported interfaces to conform to ERC721 via ERC165
526     _registerInterface(_InterfaceId_ERC721);
527   }
528 
529   /**
530    * @dev Gets the balance of the specified address
531    * @param owner address to query the balance of
532    * @return uint256 representing the amount owned by the passed address
533    */
534   function balanceOf(address owner) public view returns (uint256) {
535     require(owner != address(0));
536     return _ownedTokensCount[owner];
537   }
538 
539   /**
540    * @dev Gets the owner of the specified token ID
541    * @param tokenId uint256 ID of the token to query the owner of
542    * @return owner address currently marked as the owner of the given token ID
543    */
544   function ownerOf(uint256 tokenId) public view returns (address) {
545     address owner = _tokenOwner[tokenId];
546     require(owner != address(0));
547     return owner;
548   }
549 
550   /**
551    * @dev Approves another address to transfer the given token ID
552    * The zero address indicates there is no approved address.
553    * There can only be one approved address per token at a given time.
554    * Can only be called by the token owner or an approved operator.
555    * @param to address to be approved for the given token ID
556    * @param tokenId uint256 ID of the token to be approved
557    */
558   function approve(address to, uint256 tokenId) public {
559     address owner = ownerOf(tokenId);
560     require(to != owner);
561     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
562 
563     _tokenApprovals[tokenId] = to;
564     emit Approval(owner, to, tokenId);
565   }
566 
567   /**
568    * @dev Gets the approved address for a token ID, or zero if no address set
569    * Reverts if the token ID does not exist.
570    * @param tokenId uint256 ID of the token to query the approval of
571    * @return address currently approved for the given token ID
572    */
573   function getApproved(uint256 tokenId) public view returns (address) {
574     require(_exists(tokenId));
575     return _tokenApprovals[tokenId];
576   }
577 
578   /**
579    * @dev Sets or unsets the approval of a given operator
580    * An operator is allowed to transfer all tokens of the sender on their behalf
581    * @param to operator address to set the approval
582    * @param approved representing the status of the approval to be set
583    */
584   function setApprovalForAll(address to, bool approved) public {
585     require(to != msg.sender);
586     _operatorApprovals[msg.sender][to] = approved;
587     emit ApprovalForAll(msg.sender, to, approved);
588   }
589 
590   /**
591    * @dev Tells whether an operator is approved by a given owner
592    * @param owner owner address which you want to query the approval of
593    * @param operator operator address which you want to query the approval of
594    * @return bool whether the given operator is approved by the given owner
595    */
596   function isApprovedForAll(
597     address owner,
598     address operator
599   )
600     public
601     view
602     returns (bool)
603   {
604     return _operatorApprovals[owner][operator];
605   }
606 
607   /**
608    * @dev Transfers the ownership of a given token ID to another address
609    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
610    * Requires the msg sender to be the owner, approved, or operator
611    * @param from current owner of the token
612    * @param to address to receive the ownership of the given token ID
613    * @param tokenId uint256 ID of the token to be transferred
614   */
615   function transferFrom(
616     address from,
617     address to,
618     uint256 tokenId
619   )
620     public
621   {
622     require(_isApprovedOrOwner(msg.sender, tokenId));
623     require(to != address(0));
624 
625     _clearApproval(from, tokenId);
626     _removeTokenFrom(from, tokenId);
627     _addTokenTo(to, tokenId);
628 
629     emit Transfer(from, to, tokenId);
630   }
631 
632   /**
633    * @dev Safely transfers the ownership of a given token ID to another address
634    * If the target address is a contract, it must implement `onERC721Received`,
635    * which is called upon a safe transfer, and return the magic value
636    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
637    * the transfer is reverted.
638    *
639    * Requires the msg sender to be the owner, approved, or operator
640    * @param from current owner of the token
641    * @param to address to receive the ownership of the given token ID
642    * @param tokenId uint256 ID of the token to be transferred
643   */
644   function safeTransferFrom(
645     address from,
646     address to,
647     uint256 tokenId
648   )
649     public
650   {
651     // solium-disable-next-line arg-overflow
652     safeTransferFrom(from, to, tokenId, "");
653   }
654 
655   /**
656    * @dev Safely transfers the ownership of a given token ID to another address
657    * If the target address is a contract, it must implement `onERC721Received`,
658    * which is called upon a safe transfer, and return the magic value
659    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
660    * the transfer is reverted.
661    * Requires the msg sender to be the owner, approved, or operator
662    * @param from current owner of the token
663    * @param to address to receive the ownership of the given token ID
664    * @param tokenId uint256 ID of the token to be transferred
665    * @param _data bytes data to send along with a safe transfer check
666    */
667   function safeTransferFrom(
668     address from,
669     address to,
670     uint256 tokenId,
671     bytes _data
672   )
673     public
674   {
675     transferFrom(from, to, tokenId);
676     // solium-disable-next-line arg-overflow
677     require(_checkOnERC721Received(from, to, tokenId, _data));
678   }
679 
680   /**
681    * @dev Returns whether the specified token exists
682    * @param tokenId uint256 ID of the token to query the existence of
683    * @return whether the token exists
684    */
685   function _exists(uint256 tokenId) internal view returns (bool) {
686     address owner = _tokenOwner[tokenId];
687     return owner != address(0);
688   }
689 
690   /**
691    * @dev Returns whether the given spender can transfer a given token ID
692    * @param spender address of the spender to query
693    * @param tokenId uint256 ID of the token to be transferred
694    * @return bool whether the msg.sender is approved for the given token ID,
695    *  is an operator of the owner, or is the owner of the token
696    */
697   function _isApprovedOrOwner(
698     address spender,
699     uint256 tokenId
700   )
701     internal
702     view
703     returns (bool)
704   {
705     address owner = ownerOf(tokenId);
706     // Disable solium check because of
707     // https://github.com/duaraghav8/Solium/issues/175
708     // solium-disable-next-line operator-whitespace
709     return (
710       spender == owner ||
711       getApproved(tokenId) == spender ||
712       isApprovedForAll(owner, spender)
713     );
714   }
715 
716   /**
717    * @dev Internal function to mint a new token
718    * Reverts if the given token ID already exists
719    * @param to The address that will own the minted token
720    * @param tokenId uint256 ID of the token to be minted by the msg.sender
721    */
722   function _mint(address to, uint256 tokenId) internal {
723     require(to != address(0));
724     _addTokenTo(to, tokenId);
725     emit Transfer(address(0), to, tokenId);
726   }
727 
728   /**
729    * @dev Internal function to burn a specific token
730    * Reverts if the token does not exist
731    * @param tokenId uint256 ID of the token being burned by the msg.sender
732    */
733   function _burn(address owner, uint256 tokenId) internal {
734     _clearApproval(owner, tokenId);
735     _removeTokenFrom(owner, tokenId);
736     emit Transfer(owner, address(0), tokenId);
737   }
738 
739   /**
740    * @dev Internal function to add a token ID to the list of a given address
741    * Note that this function is left internal to make ERC721Enumerable possible, but is not
742    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
743    * @param to address representing the new owner of the given token ID
744    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
745    */
746   function _addTokenTo(address to, uint256 tokenId) internal {
747     require(_tokenOwner[tokenId] == address(0));
748     _tokenOwner[tokenId] = to;
749     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
750   }
751 
752   /**
753    * @dev Internal function to remove a token ID from the list of a given address
754    * Note that this function is left internal to make ERC721Enumerable possible, but is not
755    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
756    * and doesn't clear approvals.
757    * @param from address representing the previous owner of the given token ID
758    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
759    */
760   function _removeTokenFrom(address from, uint256 tokenId) internal {
761     require(ownerOf(tokenId) == from);
762     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
763     _tokenOwner[tokenId] = address(0);
764   }
765 
766   /**
767    * @dev Internal function to invoke `onERC721Received` on a target address
768    * The call is not executed if the target address is not a contract
769    * @param from address representing the previous owner of the given token ID
770    * @param to target address that will receive the tokens
771    * @param tokenId uint256 ID of the token to be transferred
772    * @param _data bytes optional data to send along with the call
773    * @return whether the call correctly returned the expected magic value
774    */
775   function _checkOnERC721Received(
776     address from,
777     address to,
778     uint256 tokenId,
779     bytes _data
780   )
781     internal
782     returns (bool)
783   {
784     if (!to.isContract()) {
785       return true;
786     }
787     bytes4 retval = IERC721Receiver(to).onERC721Received(
788       msg.sender, from, tokenId, _data);
789     return (retval == _ERC721_RECEIVED);
790   }
791 
792   /**
793    * @dev Private function to clear current approval of a given token ID
794    * Reverts if the given address is not indeed the owner of the token
795    * @param owner owner of the token
796    * @param tokenId uint256 ID of the token to be transferred
797    */
798   function _clearApproval(address owner, uint256 tokenId) private {
799     require(ownerOf(tokenId) == owner);
800     if (_tokenApprovals[tokenId] != address(0)) {
801       _tokenApprovals[tokenId] = address(0);
802     }
803   }
804 }
805 
806 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
807   // Token name
808   string private _name;
809 
810   // Token symbol
811   string private _symbol;
812 
813   // Optional mapping for token URIs
814   mapping(uint256 => string) private _tokenURIs;
815 
816   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
817   /**
818    * 0x5b5e139f ===
819    *   bytes4(keccak256('name()')) ^
820    *   bytes4(keccak256('symbol()')) ^
821    *   bytes4(keccak256('tokenURI(uint256)'))
822    */
823 
824   /**
825    * @dev Constructor function
826    */
827   constructor(string name, string symbol) public {
828     _name = name;
829     _symbol = symbol;
830 
831     // register the supported interfaces to conform to ERC721 via ERC165
832     _registerInterface(InterfaceId_ERC721Metadata);
833   }
834 
835   /**
836    * @dev Gets the token name
837    * @return string representing the token name
838    */
839   function name() external view returns (string) {
840     return _name;
841   }
842 
843   /**
844    * @dev Gets the token symbol
845    * @return string representing the token symbol
846    */
847   function symbol() external view returns (string) {
848     return _symbol;
849   }
850 
851   /**
852    * @dev Returns an URI for a given token ID
853    * Throws if the token ID does not exist. May return an empty string.
854    * @param tokenId uint256 ID of the token to query
855    */
856   function tokenURI(uint256 tokenId) external view returns (string) {
857     require(_exists(tokenId));
858     return _tokenURIs[tokenId];
859   }
860 
861   /**
862    * @dev Internal function to set the token URI for a given token
863    * Reverts if the token ID does not exist
864    * @param tokenId uint256 ID of the token to set its URI
865    * @param uri string URI to assign
866    */
867   function _setTokenURI(uint256 tokenId, string uri) internal {
868     require(_exists(tokenId));
869     _tokenURIs[tokenId] = uri;
870   }
871 
872   /**
873    * @dev Internal function to burn a specific token
874    * Reverts if the token does not exist
875    * @param owner owner of the token to burn
876    * @param tokenId uint256 ID of the token being burned by the msg.sender
877    */
878   function _burn(address owner, uint256 tokenId) internal {
879     super._burn(owner, tokenId);
880 
881     // Clear metadata (if any)
882     if (bytes(_tokenURIs[tokenId]).length != 0) {
883       delete _tokenURIs[tokenId];
884     }
885   }
886 }
887 
888 
889 
890 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
891   // Mapping from owner to list of owned token IDs
892   mapping(address => uint256[]) private _ownedTokens;
893 
894   // Mapping from token ID to index of the owner tokens list
895   mapping(uint256 => uint256) private _ownedTokensIndex;
896 
897   // Array with all token ids, used for enumeration
898   uint256[] private _allTokens;
899 
900   // Mapping from token id to position in the allTokens array
901   mapping(uint256 => uint256) private _allTokensIndex;
902 
903   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
904   /**
905    * 0x780e9d63 ===
906    *   bytes4(keccak256('totalSupply()')) ^
907    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
908    *   bytes4(keccak256('tokenByIndex(uint256)'))
909    */
910 
911   /**
912    * @dev Constructor function
913    */
914   constructor() public {
915     // register the supported interface to conform to ERC721 via ERC165
916     _registerInterface(_InterfaceId_ERC721Enumerable);
917   }
918 
919   /**
920    * @dev Gets the token ID at a given index of the tokens list of the requested owner
921    * @param owner address owning the tokens list to be accessed
922    * @param index uint256 representing the index to be accessed of the requested tokens list
923    * @return uint256 token ID at the given index of the tokens list owned by the requested address
924    */
925   function tokenOfOwnerByIndex(
926     address owner,
927     uint256 index
928   )
929     public
930     view
931     returns (uint256)
932   {
933     require(index < balanceOf(owner));
934     return _ownedTokens[owner][index];
935   }
936 
937   /**
938    * @dev Gets the total amount of tokens stored by the contract
939    * @return uint256 representing the total amount of tokens
940    */
941   function totalSupply() public view returns (uint256) {
942     return _allTokens.length;
943   }
944 
945   /**
946    * @dev Gets the token ID at a given index of all the tokens in this contract
947    * Reverts if the index is greater or equal to the total number of tokens
948    * @param index uint256 representing the index to be accessed of the tokens list
949    * @return uint256 token ID at the given index of the tokens list
950    */
951   function tokenByIndex(uint256 index) public view returns (uint256) {
952     require(index < totalSupply());
953     return _allTokens[index];
954   }
955 
956   /**
957    * @dev Internal function to add a token ID to the list of a given address
958    * This function is internal due to language limitations, see the note in ERC721.sol.
959    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
960    * @param to address representing the new owner of the given token ID
961    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
962    */
963   function _addTokenTo(address to, uint256 tokenId) internal {
964     super._addTokenTo(to, tokenId);
965     uint256 length = _ownedTokens[to].length;
966     _ownedTokens[to].push(tokenId);
967     _ownedTokensIndex[tokenId] = length;
968   }
969 
970   /**
971    * @dev Internal function to remove a token ID from the list of a given address
972    * This function is internal due to language limitations, see the note in ERC721.sol.
973    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
974    * and doesn't clear approvals.
975    * @param from address representing the previous owner of the given token ID
976    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
977    */
978   function _removeTokenFrom(address from, uint256 tokenId) internal {
979     super._removeTokenFrom(from, tokenId);
980 
981     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
982     // then delete the last slot.
983     uint256 tokenIndex = _ownedTokensIndex[tokenId];
984     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
985     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
986 
987     _ownedTokens[from][tokenIndex] = lastToken;
988     // This also deletes the contents at the last position of the array
989     _ownedTokens[from].length--;
990 
991     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
992     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
993     // the lastToken to the first position, and then dropping the element placed in the last position of the list
994 
995     _ownedTokensIndex[tokenId] = 0;
996     _ownedTokensIndex[lastToken] = tokenIndex;
997   }
998 
999   /**
1000    * @dev Internal function to mint a new token
1001    * Reverts if the given token ID already exists
1002    * @param to address the beneficiary that will own the minted token
1003    * @param tokenId uint256 ID of the token to be minted by the msg.sender
1004    */
1005   function _mint(address to, uint256 tokenId) internal {
1006     super._mint(to, tokenId);
1007 
1008     _allTokensIndex[tokenId] = _allTokens.length;
1009     _allTokens.push(tokenId);
1010   }
1011 
1012   /**
1013    * @dev Internal function to burn a specific token
1014    * Reverts if the token does not exist
1015    * @param owner owner of the token to burn
1016    * @param tokenId uint256 ID of the token being burned by the msg.sender
1017    */
1018   function _burn(address owner, uint256 tokenId) internal {
1019     super._burn(owner, tokenId);
1020 
1021     // Reorg all tokens array
1022     uint256 tokenIndex = _allTokensIndex[tokenId];
1023     uint256 lastTokenIndex = _allTokens.length.sub(1);
1024     uint256 lastToken = _allTokens[lastTokenIndex];
1025 
1026     _allTokens[tokenIndex] = lastToken;
1027     _allTokens[lastTokenIndex] = 0;
1028 
1029     _allTokens.length--;
1030     _allTokensIndex[tokenId] = 0;
1031     _allTokensIndex[lastToken] = tokenIndex;
1032   }
1033 }
1034 
1035 
1036 
1037 contract NFT is ERC721Metadata,
1038   ERC721Enumerable,
1039   Ownable {
1040   
1041   constructor(string name, string symbol) public ERC721Metadata(name, symbol){
1042   }
1043     
1044   function mintWithTokenURI(
1045 		uint256 _id,			    
1046 		string _uri
1047 		) onlyOwner public {
1048     super._mint(owner(), _id);
1049     super._setTokenURI(_id, _uri);
1050   }
1051   
1052 }
1053 
1054 
1055 
1056 contract CryptoxmasEscrow is Pausable, Ownable {
1057   using SafeMath for uint256;
1058   
1059   /* Giveth */
1060   address public givethBridge;
1061   uint64 public givethReceiverId;
1062 
1063   /* NFT */
1064   NFT public nft; 
1065   
1066   // commission to fund paying gas for claim transactions
1067   uint public EPHEMERAL_ADDRESS_FEE = 0.01 ether;
1068   uint public MIN_PRICE = 0.05 ether; // minimum token price
1069   uint public tokensCounter; // minted tokens counter
1070   
1071   /* GIFT */
1072   enum Statuses { Empty, Deposited, Claimed, Cancelled }  
1073   
1074   struct Gift {
1075     address sender;
1076     uint claimEth; // ETH for receiver    
1077     uint256 tokenId;
1078     Statuses status;
1079     string msgHash; // IFPS message hash
1080   }
1081 
1082   // Mappings of transitAddress => Gift Struct
1083   mapping (address => Gift) gifts;
1084 
1085 
1086   /* Token Categories */
1087   enum CategoryId { Common, Special, Rare, Scarce, Limited, Epic, Unique }  
1088   struct TokenCategory {
1089     CategoryId categoryId;
1090     uint minted;  // already minted
1091     uint maxQnty; // maximum amount of tokens to mint
1092     uint price; 
1093   }
1094 
1095   // tokenURI => TokenCategory
1096   mapping(string => TokenCategory) tokenCategories;
1097   
1098   /*
1099    * EVENTS
1100    */
1101   event LogBuy(
1102 	       address indexed transitAddress,
1103 	       address indexed sender,
1104 	       string indexed tokenUri,
1105 	       uint tokenId,
1106 	       uint claimEth,
1107 	       uint nftPrice
1108 	       );
1109 
1110   event LogClaim(
1111 		 address indexed transitAddress,
1112 		 address indexed sender,
1113 		 uint tokenId,
1114 		 address receiver,
1115 		 uint claimEth
1116 		 );  
1117 
1118   event LogCancel(
1119 		  address indexed transitAddress,
1120 		  address indexed sender,
1121 		  uint tokenId
1122 		  );
1123 
1124   event LogAddTokenCategory(
1125 			    string tokenUri,
1126 			    CategoryId categoryId,
1127 			    uint maxQnty,
1128 			    uint price
1129 		  );
1130   
1131 
1132   /**
1133    * @dev Contructor that sets msg.sender as owner in Ownable,
1134    * sets escrow contract params and deploys new NFT contract 
1135    * for minting and selling tokens.
1136    *
1137    * @param _givethBridge address Address of GivethBridge contract
1138    * @param _givethReceiverId uint64 Campaign Id created on Giveth platform.
1139    * @param _name string Name for the NFT 
1140    * @param _symbol string Symbol for the NFT 
1141    */
1142   constructor(address _givethBridge,
1143 	      uint64 _givethReceiverId,
1144 	      string _name,
1145 	      string _symbol) public {
1146     // setup Giveth params
1147     givethBridge = _givethBridge;
1148     givethReceiverId = _givethReceiverId;
1149     
1150     // deploy nft contract
1151     nft = new NFT(_name, _symbol);
1152   }
1153 
1154    /* 
1155    * METHODS 
1156    */
1157   
1158   /**
1159    * @dev Get Token Category for the tokenUri.
1160    *
1161    * @param _tokenUri string token URI of the category
1162    * @return Token Category details (CategoryId, minted, maxQnty, price)
1163    */  
1164   function getTokenCategory(string _tokenUri) public view returns (CategoryId categoryId,
1165 								  uint minted,
1166 								  uint maxQnty,
1167 								  uint price) { 
1168     TokenCategory memory category = tokenCategories[_tokenUri];    
1169     return (category.categoryId,
1170 	    category.minted,
1171 	    category.maxQnty,
1172 	    category.price);
1173   }
1174 
1175   /**
1176    * @dev Add Token Category for the tokenUri.
1177    *
1178    * @param _tokenUri string token URI of the category
1179    * @param _categoryId uint categoryid of the category
1180    * @param _maxQnty uint maximum quantity of tokens allowed to be minted
1181    * @param _price uint price tokens of that category will be sold at  
1182    * @return True if success.
1183    */    
1184   function addTokenCategory(string _tokenUri, CategoryId _categoryId, uint _maxQnty, uint _price)
1185     public onlyOwner returns (bool success) {
1186 
1187     // price should be more than MIN_PRICE
1188     require(_price >= MIN_PRICE);
1189 	    
1190     // can't override existing category
1191     require(tokenCategories[_tokenUri].price == 0);
1192     
1193     tokenCategories[_tokenUri] = TokenCategory(_categoryId,
1194 					       0, // zero tokens minted initially
1195 					       _maxQnty,
1196 					       _price);
1197 
1198     emit LogAddTokenCategory(_tokenUri, _categoryId, _maxQnty, _price);
1199     return true;
1200   }
1201 
1202   /**
1203    * @dev Checks that it's possible to buy gift and mint token with the tokenURI.
1204    *
1205    * @param _tokenUri string token URI of the category
1206    * @param _transitAddress address transit address assigned to gift
1207    * @param _value uint amount of ether, that is send in tx. 
1208    * @return True if success.
1209    */      
1210   function canBuyGift(string _tokenUri, address _transitAddress, uint _value) public view whenNotPaused returns (bool) {
1211     // can not override existing gift
1212     require(gifts[_transitAddress].status == Statuses.Empty);
1213 
1214     // eth covers NFT price
1215     TokenCategory memory category = tokenCategories[_tokenUri];
1216     require(_value >= category.price);
1217 
1218     // tokens of that type not sold out yet
1219     require(category.minted < category.maxQnty);
1220     
1221     return true;
1222   }
1223 
1224   /**
1225    * @dev Buy gift and mint token with _tokenUri, new minted token will be kept in escrow
1226    * until receiver claims it. 
1227    *
1228    * Received ether, splitted in 3 parts:
1229    *   - 0.01 ETH goes to ephemeral account, so it can pay gas fee for claim transaction. 
1230    *   - token price (minus ephemeral account fee) goes to the Giveth Campaign as a donation.  
1231    *   - Eth above token price is kept in the escrow, waiting for receiver to claim. 
1232    *
1233    * @param _tokenUri string token URI of the category
1234    * @param _transitAddress address transit address assigned to gift
1235    * @param _msgHash string IPFS hash, where gift message stored at 
1236    * @return True if success.
1237    */    
1238   function buyGift(string _tokenUri, address _transitAddress, string _msgHash)
1239           payable public whenNotPaused returns (bool) {
1240     
1241     require(canBuyGift(_tokenUri, _transitAddress, msg.value));
1242 
1243     // get token price from the category for that token URI
1244     uint tokenPrice = tokenCategories[_tokenUri].price;
1245 
1246     // ether above token price is for receiver to claim
1247     uint claimEth = msg.value.sub(tokenPrice);
1248 
1249     // mint new token 
1250     uint tokenId = tokensCounter.add(1);
1251     nft.mintWithTokenURI(tokenId, _tokenUri);
1252 
1253     // increment counters
1254     tokenCategories[_tokenUri].minted = tokenCategories[_tokenUri].minted.add(1);
1255     tokensCounter = tokensCounter.add(1);
1256     
1257     // saving gift details
1258     gifts[_transitAddress] = Gift(
1259 				  msg.sender,
1260 				  claimEth,
1261 				  tokenId,
1262 				  Statuses.Deposited,
1263 				  _msgHash
1264 				  );
1265 
1266 
1267     // transfer small fee to ephemeral account to fund claim txs
1268     _transitAddress.transfer(EPHEMERAL_ADDRESS_FEE);
1269 
1270     // send donation to Giveth campaign
1271     uint donation = tokenPrice.sub(EPHEMERAL_ADDRESS_FEE);
1272     if (donation > 0) {
1273       bool donationSuccess = _makeDonation(msg.sender, donation);
1274 
1275       // revert if there was problem with sending ether to GivethBridge
1276       require(donationSuccess == true);
1277     }
1278     
1279     // log buy event
1280     emit LogBuy(
1281 		_transitAddress,
1282 		msg.sender,
1283 		_tokenUri,
1284 		tokenId,
1285 		claimEth,
1286 		tokenPrice);
1287     return true;
1288   }
1289 
1290   /**
1291    * @dev Send donation to Giveth campaign 
1292    * by calling function 'donateAndCreateGiver' of GivethBridge contract.
1293    *
1294    * @param _giver address giver address
1295    * @param _value uint donation amount (in wei)
1296    * @return True if success.
1297    */    
1298   function _makeDonation(address _giver, uint _value) internal returns (bool success) {
1299     bytes memory _data = abi.encodePacked(0x1870c10f, // function signature
1300 					   bytes32(_giver),
1301 					   bytes32(givethReceiverId),
1302 					   bytes32(0),
1303 					   bytes32(0));
1304     // make donation tx
1305     success = givethBridge.call.value(_value)(_data);
1306     return success;
1307   }
1308 
1309   /**
1310    * @dev Get Gift assigned to transit address.
1311    *
1312    * @param _transitAddress address transit address assigned to gift
1313    * @return Gift details
1314    */    
1315   function getGift(address _transitAddress) public view returns (
1316 	     uint256 tokenId,
1317 	     string tokenUri,								 
1318 	     address sender,  // gift buyer
1319 	     uint claimEth,   // eth for receiver
1320 	     uint nftPrice,   // token price 	     
1321 	     Statuses status, // gift status (deposited, claimed, cancelled) 								 	     
1322 	     string msgHash   // IPFS hash, where gift message stored at 
1323     ) {
1324     Gift memory gift = gifts[_transitAddress];
1325     tokenUri =  nft.tokenURI(gift.tokenId);
1326     TokenCategory memory category = tokenCategories[tokenUri];    
1327     return (
1328 	    gift.tokenId,
1329 	    tokenUri,
1330 	    gift.sender,
1331 	    gift.claimEth,
1332 	    category.price,	    
1333 	    gift.status,
1334 	    gift.msgHash
1335 	    );
1336   }
1337   
1338   /**
1339    * @dev Cancel gift and get sent ether back. Only gift buyer can
1340    * cancel.
1341    * 
1342    * @param _transitAddress transit address assigned to gift
1343    * @return True if success.
1344    */
1345   function cancelGift(address _transitAddress) public returns (bool success) {
1346     Gift storage gift = gifts[_transitAddress];
1347 
1348     // is deposited and wasn't claimed or cancelled before
1349     require(gift.status == Statuses.Deposited);
1350     
1351     // only sender can cancel transfer;
1352     require(msg.sender == gift.sender);
1353     
1354     // update status to cancelled
1355     gift.status = Statuses.Cancelled;
1356 
1357     // transfer optional ether to receiver's address
1358     if (gift.claimEth > 0) {
1359       gift.sender.transfer(gift.claimEth);
1360     }
1361 
1362     // send nft to buyer
1363     nft.transferFrom(address(this), msg.sender, gift.tokenId);
1364 
1365     // log cancel event
1366     emit LogCancel(_transitAddress, msg.sender, gift.tokenId);
1367 
1368     return true;
1369   }
1370 
1371   
1372   /**
1373    * @dev Claim gift to receiver's address if it is correctly signed
1374    * with private key for verification public key assigned to gift.
1375    * 
1376    * @param _receiver address Signed address.
1377    * @return True if success.
1378    */
1379   function claimGift(address _receiver) public whenNotPaused returns (bool success) {
1380     // only holder of ephemeral private key can claim gift
1381     address _transitAddress = msg.sender;
1382     
1383     Gift storage gift = gifts[_transitAddress];
1384 
1385     // is deposited and wasn't claimed or cancelled before
1386     require(gift.status == Statuses.Deposited);
1387 
1388     // update gift status to claimed
1389     gift.status = Statuses.Claimed;
1390     
1391     // send nft to receiver
1392     nft.transferFrom(address(this), _receiver, gift.tokenId);
1393     
1394     // transfer ether to receiver's address
1395     if (gift.claimEth > 0) {
1396       _receiver.transfer(gift.claimEth);
1397     }
1398 
1399     // log claim event
1400     emit LogClaim(_transitAddress, gift.sender, gift.tokenId, _receiver, gift.claimEth);
1401     
1402     return true;
1403   }
1404 
1405   // fallback function - do not receive ether by default
1406   function() public payable {
1407     revert();
1408   }
1409 }