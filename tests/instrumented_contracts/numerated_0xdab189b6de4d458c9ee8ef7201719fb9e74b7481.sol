1 pragma solidity ^0.4.24;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7 
8   /**
9    * Returns whether the target address is a contract
10    * @dev This function will return false if invoked during the constructor of a contract,
11    * as the code is not actually created until after the constructor finishes.
12    * @param account address of the account to check
13    * @return whether the target address is a contract
14    */
15   function isContract(address account) internal view returns (bool) {
16     uint256 size;
17     // XXX Currently there is no better way to check if there is a contract in an address
18     // than to check the size of the code at that address.
19     // See https://ethereum.stackexchange.com/a/14016/36603
20     // for more details about how this works.
21     // TODO Check this again before the Serenity release, because all addresses will be
22     // contracts then.
23     // solium-disable-next-line security/no-inline-assembly
24     assembly { size := extcodesize(account) }
25     return size > 0;
26   }
27 
28 }
29 
30 /**
31  * @title Roles
32  * @dev Library for managing addresses assigned to a Role.
33  */
34 library Roles {
35     struct Role {
36         mapping (address => bool) bearer;
37     }
38 
39     /**
40      * @dev give an account access to this role
41      */
42     function add(Role storage role, address account) internal {
43         require(account != address(0));
44         require(!has(role, account));
45 
46         role.bearer[account] = true;
47     }
48 
49     /**
50      * @dev remove an account's access to this role
51      */
52     function remove(Role storage role, address account) internal {
53         require(account != address(0));
54         require(has(role, account));
55 
56         role.bearer[account] = false;
57     }
58 
59     /**
60      * @dev check if an account has this role
61      * @return bool
62      */
63     function has(Role storage role, address account) internal view returns (bool) {
64         require(account != address(0));
65         return role.bearer[account];
66     }
67 }
68 
69 contract PauserRole {
70     using Roles for Roles.Role;
71 
72     event PauserAdded(address indexed account);
73     event PauserRemoved(address indexed account);
74 
75     Roles.Role private _pausers;
76 
77     constructor () internal {
78         _addPauser(msg.sender);
79     }
80 
81     modifier onlyPauser() {
82         require(isPauser(msg.sender));
83         _;
84     }
85 
86     function isPauser(address account) public view returns (bool) {
87         return _pausers.has(account);
88     }
89 
90     function addPauser(address account) public onlyPauser {
91         _addPauser(account);
92     }
93 
94     function renouncePauser() public {
95         _removePauser(msg.sender);
96     }
97 
98     function _addPauser(address account) internal {
99         _pausers.add(account);
100         emit PauserAdded(account);
101     }
102 
103     function _removePauser(address account) internal {
104         _pausers.remove(account);
105         emit PauserRemoved(account);
106     }
107 }
108 
109 /**
110  * @title Pausable
111  * @dev Base contract which allows children to implement an emergency stop mechanism.
112  */
113 contract Pausable is PauserRole {
114     event Paused(address account);
115     event Unpaused(address account);
116 
117     bool private _paused;
118 
119     constructor () internal {
120         _paused = false;
121     }
122 
123     /**
124      * @return true if the contract is paused, false otherwise.
125      */
126     function paused() public view returns (bool) {
127         return _paused;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when the contract is not paused.
132      */
133     modifier whenNotPaused() {
134         require(!_paused);
135         _;
136     }
137 
138     /**
139      * @dev Modifier to make a function callable only when the contract is paused.
140      */
141     modifier whenPaused() {
142         require(_paused);
143         _;
144     }
145 
146     /**
147      * @dev called by the owner to pause, triggers stopped state
148      */
149     function pause() public onlyPauser whenNotPaused {
150         _paused = true;
151         emit Paused(msg.sender);
152     }
153 
154     /**
155      * @dev called by the owner to unpause, returns to normal state
156      */
157     function unpause() public onlyPauser whenPaused {
158         _paused = false;
159         emit Unpaused(msg.sender);
160     }
161 }
162 /**
163  * @title SafeMath
164  * @dev Math operations with safety checks that revert on error
165  */
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, reverts on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173     // benefit is lost if 'b' is also tested.
174     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
175     if (a == 0) {
176       return 0;
177     }
178 
179     uint256 c = a * b;
180     require(c / a == b);
181 
182     return c;
183   }
184 
185   /**
186   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
187   */
188   function div(uint256 a, uint256 b) internal pure returns (uint256) {
189     require(b > 0); // Solidity only automatically asserts when dividing by 0
190     uint256 c = a / b;
191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193     return c;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     require(b <= a);
201     uint256 c = a - b;
202 
203     return c;
204   }
205 
206   /**
207   * @dev Adds two numbers, reverts on overflow.
208   */
209   function add(uint256 a, uint256 b) internal pure returns (uint256) {
210     uint256 c = a + b;
211     require(c >= a);
212 
213     return c;
214   }
215 
216   /**
217   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
218   * reverts when dividing by zero.
219   */
220   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221     require(b != 0);
222     return a % b;
223   }
224 }
225 
226 
227 /**
228  * @title SafeMath32
229  * @dev SafeMath library implemented for uint32
230  */
231 library SafeMath32 {
232 
233   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
234     if (a == 0) {
235       return 0;
236     }
237     uint32 c = a * b;
238     assert(c / a == b);
239     return c;
240   }
241 
242   function div(uint32 a, uint32 b) internal pure returns (uint32) {
243     // assert(b > 0); // Solidity automatically throws when dividing by 0
244     uint32 c = a / b;
245     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246     return c;
247   }
248 
249   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
250     assert(b <= a);
251     return a - b;
252   }
253 
254   function add(uint32 a, uint32 b) internal pure returns (uint32) {
255     uint32 c = a + b;
256     assert(c >= a);
257     return c;
258   }
259 }
260 /**
261  * @title SafeMath16
262  * @dev SafeMath library implemented for uint16
263  */
264 library SafeMath16 {
265 
266   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
267     if (a == 0) {
268       return 0;
269     }
270     uint16 c = a * b;
271     assert(c / a == b);
272     return c;
273   }
274 
275   function div(uint16 a, uint16 b) internal pure returns (uint16) {
276     // assert(b > 0); // Solidity automatically throws when dividing by 0
277     uint16 c = a / b;
278     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
279     return c;
280   }
281 
282   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
283     assert(b <= a);
284     return a - b;
285   }
286 
287   function add(uint16 a, uint16 b) internal pure returns (uint16) {
288     uint16 c = a + b;
289     assert(c >= a);
290     return c;
291   }
292 }
293 /**
294  * @title IERC165
295  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
296  */
297 interface IERC165 {
298 
299   /**
300    * @notice Query if a contract implements an interface
301    * @param interfaceId The interface identifier, as specified in ERC-165
302    * @dev Interface identification is specified in ERC-165. This function
303    * uses less than 30,000 gas.
304    */
305   function supportsInterface(bytes4 interfaceId)
306     external
307     view
308     returns (bool);
309 }
310 /**
311  * @title ERC165
312  * @author Matt Condon (@shrugs)
313  * @dev Implements ERC165 using a lookup table.
314  */
315 contract ERC165 is IERC165 {
316 
317   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
318   /**
319    * 0x01ffc9a7 ===
320    *   bytes4(keccak256('supportsInterface(bytes4)'))
321    */
322 
323   /**
324    * @dev a mapping of interface id to whether or not it's supported
325    */
326   mapping(bytes4 => bool) private _supportedInterfaces;
327 
328   /**
329    * @dev A contract implementing SupportsInterfaceWithLookup
330    * implement ERC165 itself
331    */
332   constructor()
333     internal
334   {
335     _registerInterface(_InterfaceId_ERC165);
336   }
337 
338   /**
339    * @dev implement supportsInterface(bytes4) using a lookup table
340    */
341   function supportsInterface(bytes4 interfaceId)
342     external
343     view
344     returns (bool)
345   {
346     return _supportedInterfaces[interfaceId];
347   }
348 
349   /**
350    * @dev internal method for registering an interface
351    */
352   function _registerInterface(bytes4 interfaceId)
353     internal
354   {
355     require(interfaceId != 0xffffffff);
356     _supportedInterfaces[interfaceId] = true;
357   }
358 }
359 
360 /**
361  * @title ERC721 Non-Fungible Token Standard basic interface
362  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
363  */
364 contract IERC721 is IERC165 {
365 
366   event Transfer(
367     address indexed from,
368     address indexed to,
369     uint256 indexed tokenId
370   );
371   event Approval(
372     address indexed owner,
373     address indexed approved,
374     uint256 indexed tokenId
375   );
376   event ApprovalForAll(
377     address indexed owner,
378     address indexed operator,
379     bool approved
380   );
381 
382   function balanceOf(address owner) public view returns (uint256 balance);
383   function ownerOf(uint256 tokenId) public view returns (address owner);
384 
385   function approve(address to, uint256 tokenId) public;
386   function getApproved(uint256 tokenId)
387     public view returns (address operator);
388 
389   function setApprovalForAll(address operator, bool _approved) public;
390   function isApprovedForAll(address owner, address operator)
391     public view returns (bool);
392 
393   function transferFrom(address from, address to, uint256 tokenId) public;
394   function safeTransferFrom(address from, address to, uint256 tokenId)
395     public;
396 
397   function safeTransferFrom(
398     address from,
399     address to,
400     uint256 tokenId,
401     bytes data
402   )
403     public;
404 }
405 
406 /**
407  * @title ERC721 token receiver interface
408  * @dev Interface for any contract that wants to support safeTransfers
409  * from ERC721 asset contracts.
410  */
411 contract IERC721Receiver {
412   /**
413    * @notice Handle the receipt of an NFT
414    * @dev The ERC721 smart contract calls this function on the recipient
415    * after a `safeTransfer`. This function MUST return the function selector,
416    * otherwise the caller will revert the transaction. The selector to be
417    * returned can be obtained as `this.onERC721Received.selector`. This
418    * function MAY throw to revert and reject the transfer.
419    * Note: the ERC721 contract address is always the message sender.
420    * @param operator The address which called `safeTransferFrom` function
421    * @param from The address which previously owned the token
422    * @param tokenId The NFT identifier which is being transferred
423    * @param data Additional data with no specified format
424    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
425    */
426   function onERC721Received(
427     address operator,
428     address from,
429     uint256 tokenId,
430     bytes data
431   )
432     public
433     returns(bytes4);
434 }
435 
436 
437 /**
438  * @title ERC721 Non-Fungible Token Standard basic implementation
439  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
440  */
441 contract ERC721 is ERC165, IERC721 {
442 
443   using SafeMath for uint256;
444   using Address for address;
445 
446   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
447   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
448   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
449 
450   // Mapping from token ID to owner
451   mapping (uint256 => address) private _tokenOwner;
452 
453   // Mapping from token ID to approved address
454   mapping (uint256 => address) private _tokenApprovals;
455 
456   // Mapping from owner to number of owned token
457   mapping (address => uint256) private _ownedTokensCount;
458 
459   // Mapping from owner to operator approvals
460   mapping (address => mapping (address => bool)) private _operatorApprovals;
461 
462   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
463   /*
464    * 0x80ac58cd ===
465    *   bytes4(keccak256('balanceOf(address)')) ^
466    *   bytes4(keccak256('ownerOf(uint256)')) ^
467    *   bytes4(keccak256('approve(address,uint256)')) ^
468    *   bytes4(keccak256('getApproved(uint256)')) ^
469    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
470    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
471    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
472    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
473    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
474    */
475 
476   constructor()
477     public
478   {
479     // register the supported interfaces to conform to ERC721 via ERC165
480     _registerInterface(_InterfaceId_ERC721);
481   }
482 
483   /**
484    * @dev Gets the balance of the specified address
485    * @param owner address to query the balance of
486    * @return uint256 representing the amount owned by the passed address
487    */
488   function balanceOf(address owner) public view returns (uint256) {
489     require(owner != address(0));
490     return _ownedTokensCount[owner];
491   }
492 
493   /**
494    * @dev Gets the owner of the specified token ID
495    * @param tokenId uint256 ID of the token to query the owner of
496    * @return owner address currently marked as the owner of the given token ID
497    */
498   function ownerOf(uint256 tokenId) public view returns (address) {
499     address owner = _tokenOwner[tokenId];
500     require(owner != address(0));
501     return owner;
502   }
503 
504   /**
505    * @dev Approves another address to transfer the given token ID
506    * The zero address indicates there is no approved address.
507    * There can only be one approved address per token at a given time.
508    * Can only be called by the token owner or an approved operator.
509    * @param to address to be approved for the given token ID
510    * @param tokenId uint256 ID of the token to be approved
511    */
512   function approve(address to, uint256 tokenId) public {
513     address owner = ownerOf(tokenId);
514     require(to != owner);
515     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
516 
517     _tokenApprovals[tokenId] = to;
518     emit Approval(owner, to, tokenId);
519   }
520 
521   /**
522    * @dev Gets the approved address for a token ID, or zero if no address set
523    * Reverts if the token ID does not exist.
524    * @param tokenId uint256 ID of the token to query the approval of
525    * @return address currently approved for the given token ID
526    */
527   function getApproved(uint256 tokenId) public view returns (address) {
528     require(_exists(tokenId));
529     return _tokenApprovals[tokenId];
530   }
531 
532   /**
533    * @dev Sets or unsets the approval of a given operator
534    * An operator is allowed to transfer all tokens of the sender on their behalf
535    * @param to operator address to set the approval
536    * @param approved representing the status of the approval to be set
537    */
538   function setApprovalForAll(address to, bool approved) public {
539     require(to != msg.sender);
540     _operatorApprovals[msg.sender][to] = approved;
541     emit ApprovalForAll(msg.sender, to, approved);
542   }
543 
544   /**
545    * @dev Tells whether an operator is approved by a given owner
546    * @param owner owner address which you want to query the approval of
547    * @param operator operator address which you want to query the approval of
548    * @return bool whether the given operator is approved by the given owner
549    */
550   function isApprovedForAll(
551     address owner,
552     address operator
553   )
554     public
555     view
556     returns (bool)
557   {
558     return _operatorApprovals[owner][operator];
559   }
560 
561   /**
562    * @dev Transfers the ownership of a given token ID to another address
563    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
564    * Requires the msg sender to be the owner, approved, or operator
565    * @param from current owner of the token
566    * @param to address to receive the ownership of the given token ID
567    * @param tokenId uint256 ID of the token to be transferred
568   */
569   function transferFrom(
570     address from,
571     address to,
572     uint256 tokenId
573   )
574     public
575   {
576     require(_isApprovedOrOwner(msg.sender, tokenId));
577     require(to != address(0));
578 
579     _clearApproval(from, tokenId);
580     _removeTokenFrom(from, tokenId);
581     _addTokenTo(to, tokenId);
582 
583     emit Transfer(from, to, tokenId);
584   }
585 
586   /**
587    * @dev Safely transfers the ownership of a given token ID to another address
588    * If the target address is a contract, it must implement `onERC721Received`,
589    * which is called upon a safe transfer, and return the magic value
590    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
591    * the transfer is reverted.
592    *
593    * Requires the msg sender to be the owner, approved, or operator
594    * @param from current owner of the token
595    * @param to address to receive the ownership of the given token ID
596    * @param tokenId uint256 ID of the token to be transferred
597   */
598   function safeTransferFrom(
599     address from,
600     address to,
601     uint256 tokenId
602   )
603     public
604   {
605     // solium-disable-next-line arg-overflow
606     safeTransferFrom(from, to, tokenId, "");
607   }
608 
609   /**
610    * @dev Safely transfers the ownership of a given token ID to another address
611    * If the target address is a contract, it must implement `onERC721Received`,
612    * which is called upon a safe transfer, and return the magic value
613    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
614    * the transfer is reverted.
615    * Requires the msg sender to be the owner, approved, or operator
616    * @param from current owner of the token
617    * @param to address to receive the ownership of the given token ID
618    * @param tokenId uint256 ID of the token to be transferred
619    * @param _data bytes data to send along with a safe transfer check
620    */
621   function safeTransferFrom(
622     address from,
623     address to,
624     uint256 tokenId,
625     bytes _data
626   )
627     public
628   {
629     transferFrom(from, to, tokenId);
630     // solium-disable-next-line arg-overflow
631     require(_checkOnERC721Received(from, to, tokenId, _data));
632   }
633 
634   /**
635    * @dev Returns whether the specified token exists
636    * @param tokenId uint256 ID of the token to query the existence of
637    * @return whether the token exists
638    */
639   function _exists(uint256 tokenId) internal view returns (bool) {
640     address owner = _tokenOwner[tokenId];
641     return owner != address(0);
642   }
643 
644   /**
645    * @dev Returns whether the given spender can transfer a given token ID
646    * @param spender address of the spender to query
647    * @param tokenId uint256 ID of the token to be transferred
648    * @return bool whether the msg.sender is approved for the given token ID,
649    *  is an operator of the owner, or is the owner of the token
650    */
651   function _isApprovedOrOwner(
652     address spender,
653     uint256 tokenId
654   )
655     internal
656     view
657     returns (bool)
658   {
659     address owner = ownerOf(tokenId);
660     // Disable solium check because of
661     // https://github.com/duaraghav8/Solium/issues/175
662     // solium-disable-next-line operator-whitespace
663     return (
664       spender == owner ||
665       getApproved(tokenId) == spender ||
666       isApprovedForAll(owner, spender)
667     );
668   }
669 
670   /**
671    * @dev Internal function to mint a new token
672    * Reverts if the given token ID already exists
673    * @param to The address that will own the minted token
674    * @param tokenId uint256 ID of the token to be minted by the msg.sender
675    */
676   function _mint(address to, uint256 tokenId) internal {
677     require(to != address(0));
678     _addTokenTo(to, tokenId);
679     emit Transfer(address(0), to, tokenId);
680   }
681 
682   /**
683    * @dev Internal function to burn a specific token
684    * Reverts if the token does not exist
685    * @param tokenId uint256 ID of the token being burned by the msg.sender
686    */
687   function _burn(address owner, uint256 tokenId) internal {
688     _clearApproval(owner, tokenId);
689     _removeTokenFrom(owner, tokenId);
690     emit Transfer(owner, address(0), tokenId);
691   }
692 
693   /**
694    * @dev Internal function to add a token ID to the list of a given address
695    * Note that this function is left internal to make ERC721Enumerable possible, but is not
696    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
697    * @param to address representing the new owner of the given token ID
698    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
699    */
700   function _addTokenTo(address to, uint256 tokenId) internal {
701     require(_tokenOwner[tokenId] == address(0));
702     _tokenOwner[tokenId] = to;
703     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
704   }
705 
706   /**
707    * @dev Internal function to remove a token ID from the list of a given address
708    * Note that this function is left internal to make ERC721Enumerable possible, but is not
709    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
710    * and doesn't clear approvals.
711    * @param from address representing the previous owner of the given token ID
712    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
713    */
714   function _removeTokenFrom(address from, uint256 tokenId) internal {
715     require(ownerOf(tokenId) == from);
716     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
717     _tokenOwner[tokenId] = address(0);
718   }
719 
720   /**
721    * @dev Internal function to invoke `onERC721Received` on a target address
722    * The call is not executed if the target address is not a contract
723    * @param from address representing the previous owner of the given token ID
724    * @param to target address that will receive the tokens
725    * @param tokenId uint256 ID of the token to be transferred
726    * @param _data bytes optional data to send along with the call
727    * @return whether the call correctly returned the expected magic value
728    */
729   function _checkOnERC721Received(
730     address from,
731     address to,
732     uint256 tokenId,
733     bytes _data
734   )
735     internal
736     returns (bool)
737   {
738     if (!to.isContract()) {
739       return true;
740     }
741     bytes4 retval = IERC721Receiver(to).onERC721Received(
742       msg.sender, from, tokenId, _data);
743     return (retval == _ERC721_RECEIVED);
744   }
745 
746   /**
747    * @dev Private function to clear current approval of a given token ID
748    * Reverts if the given address is not indeed the owner of the token
749    * @param owner owner of the token
750    * @param tokenId uint256 ID of the token to be transferred
751    */
752   function _clearApproval(address owner, uint256 tokenId) private {
753     require(ownerOf(tokenId) == owner);
754     if (_tokenApprovals[tokenId] != address(0)) {
755       _tokenApprovals[tokenId] = address(0);
756     }
757   }
758 }
759 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
760 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
761 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
762 interface ERC721Metadata /* is ERC721 */ {
763     /// @notice A descriptive name for a collection of NFTs in this contract
764     function name() external view returns (string _name);
765 
766     /// @notice An abbreviated name for NFTs in this contract
767     function symbol() external view returns (string _symbol);
768 
769     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
770     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
771     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
772     ///  Metadata JSON Schema".
773     function tokenURI(uint256 _tokenId) external view returns (string);
774 }
775 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
776 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
777 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
778 interface ERC721Enumerable /* is ERC721 */ {
779     /// @notice Count NFTs tracked by this contract
780     /// @return A count of valid NFTs tracked by this contract, where each one of
781     ///  them has an assigned and queryable owner not equal to the zero address
782     function totalSupply() external view returns (uint256);
783 
784     /// @notice Enumerate valid NFTs
785     /// @dev Throws if `_index` >= `totalSupply()`.
786     /// @param _index A counter less than `totalSupply()`
787     /// @return The token identifier for the `_index`th NFT,
788     ///  (sort order not specified)
789     function tokenByIndex(uint256 _index) external view returns (uint256);
790 
791     /// @notice Enumerate NFTs assigned to an owner
792     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
793     ///  `_owner` is the zero address, representing invalid NFTs.
794     /// @param _owner An address where we are interested in NFTs owned by them
795     /// @param _index A counter less than `balanceOf(_owner)`
796     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
797     ///   (sort order not specified)
798     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
799 }
800 
801 
802 /**
803  * @title Ownable
804  * @dev The Ownable contract has an owner address, and provides basic authorization control
805  * functions, this simplifies the implementation of "user permissions".
806  */
807 contract Ownable {
808   address private _owner;
809 
810   event OwnershipTransferred(
811     address indexed previousOwner,
812     address indexed newOwner
813   );
814 
815   /**
816    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
817    * account.
818    */
819   constructor() internal {
820     _owner = msg.sender;
821     emit OwnershipTransferred(address(0), _owner);
822   }
823 
824   /**
825    * @return the address of the owner.
826    */
827   function owner() public view returns(address) {
828     return _owner;
829   }
830 
831   /**
832    * @dev Throws if called by any account other than the owner.
833    */
834   modifier onlyOwner() {
835     require(isOwner());
836     _;
837   }
838 
839   /**
840    * @return true if `msg.sender` is the owner of the contract.
841    */
842   function isOwner() public view returns(bool) {
843     return msg.sender == _owner;
844   }
845 
846   /**
847    * @dev Allows the current owner to relinquish control of the contract.
848    * @notice Renouncing to ownership will leave the contract without an owner.
849    * It will not be possible to call the functions with the `onlyOwner`
850    * modifier anymore.
851    */
852   function renounceOwnership() public onlyOwner {
853     emit OwnershipTransferred(_owner, address(0));
854     _owner = address(0);
855   }
856 
857   /**
858    * @dev Allows the current owner to transfer control of the contract to a newOwner.
859    * @param newOwner The address to transfer ownership to.
860    */
861   function transferOwnership(address newOwner) public onlyOwner {
862     _transferOwnership(newOwner);
863   }
864 
865   /**
866    * @dev Transfers control of the contract to a newOwner.
867    * @param newOwner The address to transfer ownership to.
868    */
869   function _transferOwnership(address newOwner) internal {
870     require(newOwner != address(0));
871     emit OwnershipTransferred(_owner, newOwner);
872     _owner = newOwner;
873   }
874 }
875 /// @title 0x415254. Un contrato para creación de piezas de arte
876 /// @author Daniel Fernando Perosio (http://danielperosio.com) e-mail daniel@perosio.com - dperosio@gmail.com
877 /// @notice Esto es Arte!!! Este contrato permite la creación, la mezcla y la transferencia de obras
878 /// @dev Compatible con la implementación de OpenZeppelin de la especificación ERC721 Crypto Coleccionables
879 
880 /************************* 
881  ________________________
882 ||.......................|
883 ||.......................|
884 ||.......................|    
885 ||.......................|  
886 ||.......................|  
887 ||........0x415254.......|  
888 ||......THIS IS ART......|  
889 ||......-----------......|  
890 ||.......................|   
891 ||.......................|  
892 ||.......................|   
893 ||.......................|     
894 ||.......................|     
895 ||_______________________|   
896 
897 *************************/
898 contract ART is Ownable, ERC721, Pausable {
899     string public name = "0x415254";
900     string public symbol = "ART";    
901     
902     using SafeMath for uint256;
903     using SafeMath32 for uint32;
904     using SafeMath16 for uint16;
905     event NewWork(uint workId, string title, uint8 red, uint8 green, uint8 blue, string _characterrand, uint _drawing);   
906     
907     string public code = "s@LQjv*35zl";
908     string public compiler = "Pyth";
909     uint16 public characterQuantity = 60;
910     uint public randNonce = 0;
911 
912 string[] public character = [" ","!","#","$","%","'","(",")","*","+",
913                             ",","-",".","/","6","7","8","9",
914                             ":",";","<","=",">","?","@","A","C","D","F","H","I",
915                             "L","N","O","P","S","T","U","V","X","Y",
916                             "[","]","^","_","`",
917                             "c","l","n","o","p","q","s","v","x","y",
918                             "{","|","}","~"];
919 
920 struct Art {
921       string title;
922       uint8 red;
923       uint8 green;
924       uint8 blue;
925       string characterRand;
926       uint drawing;
927       string series;
928       uint16 mixCount;
929       uint16 electCount;             
930     }
931 
932     Art[] public works;
933 
934     mapping (uint => address) public workToOwner;
935     mapping (address => uint) ownerWorkCount;
936 
937     function setCode(string _newCode, string _newCompiler ) external onlyOwner {
938         code = _newCode;
939         compiler = _newCompiler;
940     }
941 
942     function setCharacter(string _value, uint16 _quantity ) external onlyOwner {
943         character.push(_value); 
944         characterQuantity = _quantity;
945     }
946 
947     function _createWork(string _title, uint8 _red, uint8 _green, uint8 _blue, string _characterRand, uint _drawing, string _series) internal whenNotPaused {
948         uint id = works.push(Art(_title, _red, _green, _blue, _characterRand, _drawing, _series, 0, 0)) - 1;
949         workToOwner[id] = msg.sender;
950         ownerWorkCount[msg.sender] = ownerWorkCount[msg.sender].add(1);
951         emit NewWork(id, _title, _red, _green, _blue, _characterRand, _drawing); 
952     }
953 
954     uint workFee = 0 ether;
955     uint mixWorkFee = 0 ether;
956 
957     function withdraw() external onlyOwner {
958         owner().transfer(address(this).balance);
959     }
960 
961     function setUpFee(uint _feecreate, uint _feemix) external onlyOwner {
962         workFee = _feecreate;
963         mixWorkFee = _feemix;
964     } 
965 
966     function _createString(string _title) internal returns (string) {
967         uint a = uint(keccak256(abi.encodePacked(_title, randNonce))) % characterQuantity;  
968         uint b = uint(keccak256(abi.encodePacked(msg.sender, randNonce))) % characterQuantity;       
969         uint c = uint(keccak256(abi.encodePacked(_title, msg.sender, randNonce))) % characterQuantity;
970         uint d = uint(keccak256(abi.encodePacked(_title, _title, randNonce))) % characterQuantity; 
971         bytes memory characterRanda = bytes(abi.encodePacked(character[a]));
972         bytes memory characterRandb = bytes(abi.encodePacked(character[b]));
973         bytes memory characterRandc = bytes(abi.encodePacked(character[c]));
974         bytes memory characterRandd = bytes(abi.encodePacked(character[d]));
975         string memory characterRand = string (abi.encodePacked("'",characterRanda,"','", characterRandb,"','", characterRandc,"','", characterRandd,"'"));
976         randNonce = randNonce.add(1);
977         return characterRand;
978     } 
979     
980     function createArt( string _title) external payable whenNotPaused {
981         require(msg.value == workFee);    
982         uint8 red = uint8(keccak256(abi.encodePacked(_title, randNonce))) % 255;
983         uint8 green= uint8(keccak256(abi.encodePacked(msg.sender, randNonce))) % 255;
984         uint8 blue = uint8(keccak256(abi.encodePacked(_title, msg.sender, randNonce))) % 255;
985         uint drawing = uint(keccak256(abi.encodePacked(_title)));     
986         string memory characterRand =  _createString(_title);
987         string memory series  = "A";
988         _createWork(_title, red, green, blue, characterRand, drawing, series);
989     }
990 
991     function createCustom(string _title, uint8 _red, uint8 _green, uint8 _blue, string _characterRand ) external onlyOwner { 
992        uint drawing = uint(keccak256(abi.encodePacked(_title)));
993        string memory series  = "B";
994       _createWork(_title, _red, _green, _blue, _characterRand, drawing, series);
995     }
996 
997     modifier onlyOwnerOf(uint _workId) {
998       require(msg.sender == workToOwner[_workId]);
999       _;
1000     }
1001 
1002     function _blendString(string _str, uint _startIndex, uint _endIndex) private pure returns (string) {
1003         bytes memory strBytes = bytes(_str);
1004         bytes memory result = new bytes(_endIndex-_startIndex);
1005         for(uint i = _startIndex; i < _endIndex; i++) {
1006             result[i-_startIndex] = strBytes[i];
1007         }
1008         return string(result);
1009     }
1010 
1011     function _joinString (string _chrctrRands, string   _chrctrRandi) private pure returns (string) {
1012         string memory characterRands = _blendString(_chrctrRands, 0, 8);
1013         string memory characterRandi = _blendString(_chrctrRandi, 0, 7);
1014         string memory result = string (abi.encodePacked(string(characterRands), string(characterRandi)));
1015         return string(result);
1016     }
1017      
1018     function _blendWork(string _title, uint _workId, uint _electRed , uint _electGreen , uint _electBlue, string _electCharacterRand, uint _electDrawing ) internal  onlyOwnerOf(_workId) {
1019         Art storage myWork = works[_workId];
1020         uint8 newRed = uint8(uint(myWork.red + _electRed) / 2);
1021         uint8 newGreen = uint8(uint(myWork.green + _electGreen) / 2);
1022         uint8 newBlue = uint8(uint(myWork.blue + _electBlue) / 2);       
1023         uint newDrawing = uint(myWork.drawing + _electDrawing + randNonce) / 2;
1024         string memory newCharacterRand = _joinString(myWork.characterRand, _electCharacterRand);      
1025         string memory series  = "C";
1026         _createWork(_title, newRed, newGreen, newBlue, newCharacterRand, newDrawing, series);
1027     }
1028 
1029     function blend(string _title, uint _workId, uint _electId) external  payable onlyOwnerOf(_workId) whenNotPaused {
1030         require(msg.value == mixWorkFee);
1031         Art storage myWork = works[_workId];
1032         Art storage electWork = works[_electId];
1033         myWork.mixCount = myWork.mixCount.add(1);
1034         electWork.electCount = electWork.electCount.add(1);
1035         _blendWork(_title, _workId, electWork.red, electWork.green, electWork.blue,  electWork.characterRand, electWork.drawing );
1036     }
1037 
1038     function getWorksByOwner(address _owner) external view returns(uint[]) {
1039         uint[] memory result = new uint[](ownerWorkCount[_owner]);
1040         uint counter = 0;
1041         for (uint i = 0; i < works.length; i++) {
1042           if (workToOwner[i] == _owner) {
1043             result[counter] = i;
1044             counter++;
1045           }
1046         }
1047         return result;
1048     }
1049 
1050     modifier validDestination( address to ) {
1051         require(to != address(0x0));
1052         require(to != address(this) );
1053         _;
1054     }
1055 
1056     /*ERC721*/ 
1057 
1058     mapping (uint => address) workApprovals;
1059 
1060     function balanceOf(address _owner) public view returns (uint256 _balance) {
1061         return ownerWorkCount[_owner];
1062     }
1063 
1064     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
1065         return workToOwner[_tokenId];
1066     }
1067 
1068     function _transfer(address _from, address _to, uint256 _tokenId) private validDestination(_to) {
1069         ownerWorkCount[_to] = ownerWorkCount[_to].add(1);
1070         ownerWorkCount[_from] = ownerWorkCount[_from].sub(1);
1071         workToOwner[_tokenId] = _to;
1072         emit Transfer(_from, _to, _tokenId);
1073     }
1074 
1075     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) validDestination(_to) {
1076         _transfer(msg.sender, _to, _tokenId);
1077     }
1078 
1079     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) validDestination(_to) {
1080         workApprovals[_tokenId] = _to;
1081         emit Approval(msg.sender, _to, _tokenId);
1082     }
1083 
1084     function takeOwnership(uint256 _tokenId) public {
1085         require(workApprovals[_tokenId] == msg.sender);
1086         address  owner = ownerOf(_tokenId);
1087         _transfer(owner, msg.sender, _tokenId);
1088     }
1089 
1090     function totalSupply() public view returns (uint) {
1091         return works.length - 1;
1092     }
1093 }