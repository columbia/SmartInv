1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an account access to this role
16    */
17   function add(Role storage role, address account) internal {
18     require(account != address(0));
19     require(!has(role, account));
20 
21     role.bearer[account] = true;
22   }
23 
24   /**
25    * @dev remove an account's access to this role
26    */
27   function remove(Role storage role, address account) internal {
28     require(account != address(0));
29     require(has(role, account));
30 
31     role.bearer[account] = false;
32   }
33 
34   /**
35    * @dev check if an account has this role
36    * @return bool
37    */
38   function has(Role storage role, address account)
39     internal
40     view
41     returns (bool)
42   {
43     require(account != address(0));
44     return role.bearer[account];
45   }
46 }
47 
48 // File: node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
49 
50 contract MinterRole {
51   using Roles for Roles.Role;
52 
53   event MinterAdded(address indexed account);
54   event MinterRemoved(address indexed account);
55 
56   Roles.Role private minters;
57 
58   constructor() internal {
59     _addMinter(msg.sender);
60   }
61 
62   modifier onlyMinter() {
63     require(isMinter(msg.sender));
64     _;
65   }
66 
67   function isMinter(address account) public view returns (bool) {
68     return minters.has(account);
69   }
70 
71   function addMinter(address account) public onlyMinter {
72     _addMinter(account);
73   }
74 
75   function renounceMinter() public {
76     _removeMinter(msg.sender);
77   }
78 
79   function _addMinter(address account) internal {
80     minters.add(account);
81     emit MinterAdded(account);
82   }
83 
84   function _removeMinter(address account) internal {
85     minters.remove(account);
86     emit MinterRemoved(account);
87   }
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address private _owner;
99 
100   event OwnershipTransferred(
101     address indexed previousOwner,
102     address indexed newOwner
103   );
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   constructor() internal {
110     _owner = msg.sender;
111     emit OwnershipTransferred(address(0), _owner);
112   }
113 
114   /**
115    * @return the address of the owner.
116    */
117   function owner() public view returns(address) {
118     return _owner;
119   }
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(isOwner());
126     _;
127   }
128 
129   /**
130    * @return true if `msg.sender` is the owner of the contract.
131    */
132   function isOwner() public view returns(bool) {
133     return msg.sender == _owner;
134   }
135 
136   /**
137    * @dev Allows the current owner to relinquish control of the contract.
138    * @notice Renouncing to ownership will leave the contract without an owner.
139    * It will not be possible to call the functions with the `onlyOwner`
140    * modifier anymore.
141    */
142   function renounceOwnership() public onlyOwner {
143     emit OwnershipTransferred(_owner, address(0));
144     _owner = address(0);
145   }
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) public onlyOwner {
152     _transferOwnership(newOwner);
153   }
154 
155   /**
156    * @dev Transfers control of the contract to a newOwner.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function _transferOwnership(address newOwner) internal {
160     require(newOwner != address(0));
161     emit OwnershipTransferred(_owner, newOwner);
162     _owner = newOwner;
163   }
164 }
165 
166 // File: node_modules/openzeppelin-solidity/contracts/introspection/IERC165.sol
167 
168 /**
169  * @title IERC165
170  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
171  */
172 interface IERC165 {
173 
174   /**
175    * @notice Query if a contract implements an interface
176    * @param interfaceId The interface identifier, as specified in ERC-165
177    * @dev Interface identification is specified in ERC-165. This function
178    * uses less than 30,000 gas.
179    */
180   function supportsInterface(bytes4 interfaceId)
181     external
182     view
183     returns (bool);
184 }
185 
186 // File: node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
187 
188 /**
189  * @title ERC165
190  * @author Matt Condon (@shrugs)
191  * @dev Implements ERC165 using a lookup table.
192  */
193 contract ERC165 is IERC165 {
194 
195   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
196   /**
197    * 0x01ffc9a7 ===
198    *   bytes4(keccak256('supportsInterface(bytes4)'))
199    */
200 
201   /**
202    * @dev a mapping of interface id to whether or not it's supported
203    */
204   mapping(bytes4 => bool) private _supportedInterfaces;
205 
206   /**
207    * @dev A contract implementing SupportsInterfaceWithLookup
208    * implement ERC165 itself
209    */
210   constructor()
211     internal
212   {
213     _registerInterface(_InterfaceId_ERC165);
214   }
215 
216   /**
217    * @dev implement supportsInterface(bytes4) using a lookup table
218    */
219   function supportsInterface(bytes4 interfaceId)
220     external
221     view
222     returns (bool)
223   {
224     return _supportedInterfaces[interfaceId];
225   }
226 
227   /**
228    * @dev internal method for registering an interface
229    */
230   function _registerInterface(bytes4 interfaceId)
231     internal
232   {
233     require(interfaceId != 0xffffffff);
234     _supportedInterfaces[interfaceId] = true;
235   }
236 }
237 
238 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
239 
240 /**
241  * @title SafeMath
242  * @dev Math operations with safety checks that revert on error
243  */
244 library SafeMath {
245 
246   /**
247   * @dev Multiplies two numbers, reverts on overflow.
248   */
249   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251     // benefit is lost if 'b' is also tested.
252     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
253     if (a == 0) {
254       return 0;
255     }
256 
257     uint256 c = a * b;
258     require(c / a == b);
259 
260     return c;
261   }
262 
263   /**
264   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
265   */
266   function div(uint256 a, uint256 b) internal pure returns (uint256) {
267     require(b > 0); // Solidity only automatically asserts when dividing by 0
268     uint256 c = a / b;
269     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
270 
271     return c;
272   }
273 
274   /**
275   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
276   */
277   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278     require(b <= a);
279     uint256 c = a - b;
280 
281     return c;
282   }
283 
284   /**
285   * @dev Adds two numbers, reverts on overflow.
286   */
287   function add(uint256 a, uint256 b) internal pure returns (uint256) {
288     uint256 c = a + b;
289     require(c >= a);
290 
291     return c;
292   }
293 
294   /**
295   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
296   * reverts when dividing by zero.
297   */
298   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299     require(b != 0);
300     return a % b;
301   }
302 }
303 
304 // File: node_modules/openzeppelin-solidity/contracts/utils/Address.sol
305 
306 /**
307  * Utility library of inline functions on addresses
308  */
309 library Address {
310 
311   /**
312    * Returns whether the target address is a contract
313    * @dev This function will return false if invoked during the constructor of a contract,
314    * as the code is not actually created until after the constructor finishes.
315    * @param account address of the account to check
316    * @return whether the target address is a contract
317    */
318   function isContract(address account) internal view returns (bool) {
319     uint256 size;
320     // XXX Currently there is no better way to check if there is a contract in an address
321     // than to check the size of the code at that address.
322     // See https://ethereum.stackexchange.com/a/14016/36603
323     // for more details about how this works.
324     // TODO Check this again before the Serenity release, because all addresses will be
325     // contracts then.
326     // solium-disable-next-line security/no-inline-assembly
327     assembly { size := extcodesize(account) }
328     return size > 0;
329   }
330 
331 }
332 
333 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
334 
335 /**
336  * @title ERC721 Non-Fungible Token Standard basic interface
337  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
338  */
339 contract IERC721 is IERC165 {
340 
341   event Transfer(
342     address indexed from,
343     address indexed to,
344     uint256 indexed tokenId
345   );
346   event Approval(
347     address indexed owner,
348     address indexed approved,
349     uint256 indexed tokenId
350   );
351   event ApprovalForAll(
352     address indexed owner,
353     address indexed operator,
354     bool approved
355   );
356 
357   function balanceOf(address owner) public view returns (uint256 balance);
358   function ownerOf(uint256 tokenId) public view returns (address owner);
359 
360   function approve(address to, uint256 tokenId) public;
361   function getApproved(uint256 tokenId)
362     public view returns (address operator);
363 
364   function setApprovalForAll(address operator, bool _approved) public;
365   function isApprovedForAll(address owner, address operator)
366     public view returns (bool);
367 
368   function transferFrom(address from, address to, uint256 tokenId) public;
369   function safeTransferFrom(address from, address to, uint256 tokenId)
370     public;
371 
372   function safeTransferFrom(
373     address from,
374     address to,
375     uint256 tokenId,
376     bytes data
377   )
378     public;
379 }
380 
381 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
382 
383 /**
384  * @title ERC721 token receiver interface
385  * @dev Interface for any contract that wants to support safeTransfers
386  * from ERC721 asset contracts.
387  */
388 contract IERC721Receiver {
389   /**
390    * @notice Handle the receipt of an NFT
391    * @dev The ERC721 smart contract calls this function on the recipient
392    * after a `safeTransfer`. This function MUST return the function selector,
393    * otherwise the caller will revert the transaction. The selector to be
394    * returned can be obtained as `this.onERC721Received.selector`. This
395    * function MAY throw to revert and reject the transfer.
396    * Note: the ERC721 contract address is always the message sender.
397    * @param operator The address which called `safeTransferFrom` function
398    * @param from The address which previously owned the token
399    * @param tokenId The NFT identifier which is being transferred
400    * @param data Additional data with no specified format
401    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
402    */
403   function onERC721Received(
404     address operator,
405     address from,
406     uint256 tokenId,
407     bytes data
408   )
409     public
410     returns(bytes4);
411 }
412 
413 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
414 
415 /**
416  * @title ERC721 Non-Fungible Token Standard basic implementation
417  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
418  */
419 contract ERC721 is ERC165, IERC721 {
420 
421   using SafeMath for uint256;
422   using Address for address;
423 
424   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
425   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
426   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
427 
428   // Mapping from token ID to owner
429   mapping (uint256 => address) private _tokenOwner;
430 
431   // Mapping from token ID to approved address
432   mapping (uint256 => address) private _tokenApprovals;
433 
434   // Mapping from owner to number of owned token
435   mapping (address => uint256) private _ownedTokensCount;
436 
437   // Mapping from owner to operator approvals
438   mapping (address => mapping (address => bool)) private _operatorApprovals;
439 
440   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
441   /*
442    * 0x80ac58cd ===
443    *   bytes4(keccak256('balanceOf(address)')) ^
444    *   bytes4(keccak256('ownerOf(uint256)')) ^
445    *   bytes4(keccak256('approve(address,uint256)')) ^
446    *   bytes4(keccak256('getApproved(uint256)')) ^
447    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
448    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
449    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
450    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
451    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
452    */
453 
454   constructor()
455     public
456   {
457     // register the supported interfaces to conform to ERC721 via ERC165
458     _registerInterface(_InterfaceId_ERC721);
459   }
460 
461   /**
462    * @dev Gets the balance of the specified address
463    * @param owner address to query the balance of
464    * @return uint256 representing the amount owned by the passed address
465    */
466   function balanceOf(address owner) public view returns (uint256) {
467     require(owner != address(0));
468     return _ownedTokensCount[owner];
469   }
470 
471   /**
472    * @dev Gets the owner of the specified token ID
473    * @param tokenId uint256 ID of the token to query the owner of
474    * @return owner address currently marked as the owner of the given token ID
475    */
476   function ownerOf(uint256 tokenId) public view returns (address) {
477     address owner = _tokenOwner[tokenId];
478     require(owner != address(0));
479     return owner;
480   }
481 
482   /**
483    * @dev Approves another address to transfer the given token ID
484    * The zero address indicates there is no approved address.
485    * There can only be one approved address per token at a given time.
486    * Can only be called by the token owner or an approved operator.
487    * @param to address to be approved for the given token ID
488    * @param tokenId uint256 ID of the token to be approved
489    */
490   function approve(address to, uint256 tokenId) public {
491     address owner = ownerOf(tokenId);
492     require(to != owner);
493     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
494 
495     _tokenApprovals[tokenId] = to;
496     emit Approval(owner, to, tokenId);
497   }
498 
499   /**
500    * @dev Gets the approved address for a token ID, or zero if no address set
501    * Reverts if the token ID does not exist.
502    * @param tokenId uint256 ID of the token to query the approval of
503    * @return address currently approved for the given token ID
504    */
505   function getApproved(uint256 tokenId) public view returns (address) {
506     require(_exists(tokenId));
507     return _tokenApprovals[tokenId];
508   }
509 
510   /**
511    * @dev Sets or unsets the approval of a given operator
512    * An operator is allowed to transfer all tokens of the sender on their behalf
513    * @param to operator address to set the approval
514    * @param approved representing the status of the approval to be set
515    */
516   function setApprovalForAll(address to, bool approved) public {
517     require(to != msg.sender);
518     _operatorApprovals[msg.sender][to] = approved;
519     emit ApprovalForAll(msg.sender, to, approved);
520   }
521 
522   /**
523    * @dev Tells whether an operator is approved by a given owner
524    * @param owner owner address which you want to query the approval of
525    * @param operator operator address which you want to query the approval of
526    * @return bool whether the given operator is approved by the given owner
527    */
528   function isApprovedForAll(
529     address owner,
530     address operator
531   )
532     public
533     view
534     returns (bool)
535   {
536     return _operatorApprovals[owner][operator];
537   }
538 
539   /**
540    * @dev Transfers the ownership of a given token ID to another address
541    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
542    * Requires the msg sender to be the owner, approved, or operator
543    * @param from current owner of the token
544    * @param to address to receive the ownership of the given token ID
545    * @param tokenId uint256 ID of the token to be transferred
546   */
547   function transferFrom(
548     address from,
549     address to,
550     uint256 tokenId
551   )
552     public
553   {
554     require(_isApprovedOrOwner(msg.sender, tokenId));
555     require(to != address(0));
556 
557     _clearApproval(from, tokenId);
558     _removeTokenFrom(from, tokenId);
559     _addTokenTo(to, tokenId);
560 
561     emit Transfer(from, to, tokenId);
562   }
563 
564   /**
565    * @dev Safely transfers the ownership of a given token ID to another address
566    * If the target address is a contract, it must implement `onERC721Received`,
567    * which is called upon a safe transfer, and return the magic value
568    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
569    * the transfer is reverted.
570    *
571    * Requires the msg sender to be the owner, approved, or operator
572    * @param from current owner of the token
573    * @param to address to receive the ownership of the given token ID
574    * @param tokenId uint256 ID of the token to be transferred
575   */
576   function safeTransferFrom(
577     address from,
578     address to,
579     uint256 tokenId
580   )
581     public
582   {
583     // solium-disable-next-line arg-overflow
584     safeTransferFrom(from, to, tokenId, "");
585   }
586 
587   /**
588    * @dev Safely transfers the ownership of a given token ID to another address
589    * If the target address is a contract, it must implement `onERC721Received`,
590    * which is called upon a safe transfer, and return the magic value
591    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
592    * the transfer is reverted.
593    * Requires the msg sender to be the owner, approved, or operator
594    * @param from current owner of the token
595    * @param to address to receive the ownership of the given token ID
596    * @param tokenId uint256 ID of the token to be transferred
597    * @param _data bytes data to send along with a safe transfer check
598    */
599   function safeTransferFrom(
600     address from,
601     address to,
602     uint256 tokenId,
603     bytes _data
604   )
605     public
606   {
607     transferFrom(from, to, tokenId);
608     // solium-disable-next-line arg-overflow
609     require(_checkOnERC721Received(from, to, tokenId, _data));
610   }
611 
612   /**
613    * @dev Returns whether the specified token exists
614    * @param tokenId uint256 ID of the token to query the existence of
615    * @return whether the token exists
616    */
617   function _exists(uint256 tokenId) internal view returns (bool) {
618     address owner = _tokenOwner[tokenId];
619     return owner != address(0);
620   }
621 
622   /**
623    * @dev Returns whether the given spender can transfer a given token ID
624    * @param spender address of the spender to query
625    * @param tokenId uint256 ID of the token to be transferred
626    * @return bool whether the msg.sender is approved for the given token ID,
627    *  is an operator of the owner, or is the owner of the token
628    */
629   function _isApprovedOrOwner(
630     address spender,
631     uint256 tokenId
632   )
633     internal
634     view
635     returns (bool)
636   {
637     address owner = ownerOf(tokenId);
638     // Disable solium check because of
639     // https://github.com/duaraghav8/Solium/issues/175
640     // solium-disable-next-line operator-whitespace
641     return (
642       spender == owner ||
643       getApproved(tokenId) == spender ||
644       isApprovedForAll(owner, spender)
645     );
646   }
647 
648   /**
649    * @dev Internal function to mint a new token
650    * Reverts if the given token ID already exists
651    * @param to The address that will own the minted token
652    * @param tokenId uint256 ID of the token to be minted by the msg.sender
653    */
654   function _mint(address to, uint256 tokenId) internal {
655     require(to != address(0));
656     _addTokenTo(to, tokenId);
657     emit Transfer(address(0), to, tokenId);
658   }
659 
660   /**
661    * @dev Internal function to burn a specific token
662    * Reverts if the token does not exist
663    * @param tokenId uint256 ID of the token being burned by the msg.sender
664    */
665   function _burn(address owner, uint256 tokenId) internal {
666     _clearApproval(owner, tokenId);
667     _removeTokenFrom(owner, tokenId);
668     emit Transfer(owner, address(0), tokenId);
669   }
670 
671   /**
672    * @dev Internal function to add a token ID to the list of a given address
673    * Note that this function is left internal to make ERC721Enumerable possible, but is not
674    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
675    * @param to address representing the new owner of the given token ID
676    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
677    */
678   function _addTokenTo(address to, uint256 tokenId) internal {
679     require(_tokenOwner[tokenId] == address(0));
680     _tokenOwner[tokenId] = to;
681     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
682   }
683 
684   /**
685    * @dev Internal function to remove a token ID from the list of a given address
686    * Note that this function is left internal to make ERC721Enumerable possible, but is not
687    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
688    * and doesn't clear approvals.
689    * @param from address representing the previous owner of the given token ID
690    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
691    */
692   function _removeTokenFrom(address from, uint256 tokenId) internal {
693     require(ownerOf(tokenId) == from);
694     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
695     _tokenOwner[tokenId] = address(0);
696   }
697 
698   /**
699    * @dev Internal function to invoke `onERC721Received` on a target address
700    * The call is not executed if the target address is not a contract
701    * @param from address representing the previous owner of the given token ID
702    * @param to target address that will receive the tokens
703    * @param tokenId uint256 ID of the token to be transferred
704    * @param _data bytes optional data to send along with the call
705    * @return whether the call correctly returned the expected magic value
706    */
707   function _checkOnERC721Received(
708     address from,
709     address to,
710     uint256 tokenId,
711     bytes _data
712   )
713     internal
714     returns (bool)
715   {
716     if (!to.isContract()) {
717       return true;
718     }
719     bytes4 retval = IERC721Receiver(to).onERC721Received(
720       msg.sender, from, tokenId, _data);
721     return (retval == _ERC721_RECEIVED);
722   }
723 
724   /**
725    * @dev Private function to clear current approval of a given token ID
726    * Reverts if the given address is not indeed the owner of the token
727    * @param owner owner of the token
728    * @param tokenId uint256 ID of the token to be transferred
729    */
730   function _clearApproval(address owner, uint256 tokenId) private {
731     require(ownerOf(tokenId) == owner);
732     if (_tokenApprovals[tokenId] != address(0)) {
733       _tokenApprovals[tokenId] = address(0);
734     }
735   }
736 }
737 
738 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol
739 
740 contract ERC721Burnable is ERC721 {
741   function burn(uint256 tokenId)
742     public
743   {
744     require(_isApprovedOrOwner(msg.sender, tokenId));
745     _burn(ownerOf(tokenId), tokenId);
746   }
747 }
748 
749 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
750 
751 /**
752  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
753  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
754  */
755 contract IERC721Enumerable is IERC721 {
756   function totalSupply() public view returns (uint256);
757   function tokenOfOwnerByIndex(
758     address owner,
759     uint256 index
760   )
761     public
762     view
763     returns (uint256 tokenId);
764 
765   function tokenByIndex(uint256 index) public view returns (uint256);
766 }
767 
768 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
769 
770 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
771   // Mapping from owner to list of owned token IDs
772   mapping(address => uint256[]) private _ownedTokens;
773 
774   // Mapping from token ID to index of the owner tokens list
775   mapping(uint256 => uint256) private _ownedTokensIndex;
776 
777   // Array with all token ids, used for enumeration
778   uint256[] private _allTokens;
779 
780   // Mapping from token id to position in the allTokens array
781   mapping(uint256 => uint256) private _allTokensIndex;
782 
783   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
784   /**
785    * 0x780e9d63 ===
786    *   bytes4(keccak256('totalSupply()')) ^
787    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
788    *   bytes4(keccak256('tokenByIndex(uint256)'))
789    */
790 
791   /**
792    * @dev Constructor function
793    */
794   constructor() public {
795     // register the supported interface to conform to ERC721 via ERC165
796     _registerInterface(_InterfaceId_ERC721Enumerable);
797   }
798 
799   /**
800    * @dev Gets the token ID at a given index of the tokens list of the requested owner
801    * @param owner address owning the tokens list to be accessed
802    * @param index uint256 representing the index to be accessed of the requested tokens list
803    * @return uint256 token ID at the given index of the tokens list owned by the requested address
804    */
805   function tokenOfOwnerByIndex(
806     address owner,
807     uint256 index
808   )
809     public
810     view
811     returns (uint256)
812   {
813     require(index < balanceOf(owner));
814     return _ownedTokens[owner][index];
815   }
816 
817   /**
818    * @dev Gets the total amount of tokens stored by the contract
819    * @return uint256 representing the total amount of tokens
820    */
821   function totalSupply() public view returns (uint256) {
822     return _allTokens.length;
823   }
824 
825   /**
826    * @dev Gets the token ID at a given index of all the tokens in this contract
827    * Reverts if the index is greater or equal to the total number of tokens
828    * @param index uint256 representing the index to be accessed of the tokens list
829    * @return uint256 token ID at the given index of the tokens list
830    */
831   function tokenByIndex(uint256 index) public view returns (uint256) {
832     require(index < totalSupply());
833     return _allTokens[index];
834   }
835 
836   /**
837    * @dev Internal function to add a token ID to the list of a given address
838    * This function is internal due to language limitations, see the note in ERC721.sol.
839    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
840    * @param to address representing the new owner of the given token ID
841    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
842    */
843   function _addTokenTo(address to, uint256 tokenId) internal {
844     super._addTokenTo(to, tokenId);
845     uint256 length = _ownedTokens[to].length;
846     _ownedTokens[to].push(tokenId);
847     _ownedTokensIndex[tokenId] = length;
848   }
849 
850   /**
851    * @dev Internal function to remove a token ID from the list of a given address
852    * This function is internal due to language limitations, see the note in ERC721.sol.
853    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
854    * and doesn't clear approvals.
855    * @param from address representing the previous owner of the given token ID
856    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
857    */
858   function _removeTokenFrom(address from, uint256 tokenId) internal {
859     super._removeTokenFrom(from, tokenId);
860 
861     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
862     // then delete the last slot.
863     uint256 tokenIndex = _ownedTokensIndex[tokenId];
864     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
865     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
866 
867     _ownedTokens[from][tokenIndex] = lastToken;
868     // This also deletes the contents at the last position of the array
869     _ownedTokens[from].length--;
870 
871     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
872     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
873     // the lastToken to the first position, and then dropping the element placed in the last position of the list
874 
875     _ownedTokensIndex[tokenId] = 0;
876     _ownedTokensIndex[lastToken] = tokenIndex;
877   }
878 
879   /**
880    * @dev Internal function to mint a new token
881    * Reverts if the given token ID already exists
882    * @param to address the beneficiary that will own the minted token
883    * @param tokenId uint256 ID of the token to be minted by the msg.sender
884    */
885   function _mint(address to, uint256 tokenId) internal {
886     super._mint(to, tokenId);
887 
888     _allTokensIndex[tokenId] = _allTokens.length;
889     _allTokens.push(tokenId);
890   }
891 
892   /**
893    * @dev Internal function to burn a specific token
894    * Reverts if the token does not exist
895    * @param owner owner of the token to burn
896    * @param tokenId uint256 ID of the token being burned by the msg.sender
897    */
898   function _burn(address owner, uint256 tokenId) internal {
899     super._burn(owner, tokenId);
900 
901     // Reorg all tokens array
902     uint256 tokenIndex = _allTokensIndex[tokenId];
903     uint256 lastTokenIndex = _allTokens.length.sub(1);
904     uint256 lastToken = _allTokens[lastTokenIndex];
905 
906     _allTokens[tokenIndex] = lastToken;
907     _allTokens[lastTokenIndex] = 0;
908 
909     _allTokens.length--;
910     _allTokensIndex[tokenId] = 0;
911     _allTokensIndex[lastToken] = tokenIndex;
912   }
913 }
914 
915 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
919  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
920  */
921 contract IERC721Metadata is IERC721 {
922   function name() external view returns (string);
923   function symbol() external view returns (string);
924   function tokenURI(uint256 tokenId) external view returns (string);
925 }
926 
927 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
928 
929 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
930   // Token name
931   string private _name;
932 
933   // Token symbol
934   string private _symbol;
935 
936   // Optional mapping for token URIs
937   mapping(uint256 => string) private _tokenURIs;
938 
939   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
940   /**
941    * 0x5b5e139f ===
942    *   bytes4(keccak256('name()')) ^
943    *   bytes4(keccak256('symbol()')) ^
944    *   bytes4(keccak256('tokenURI(uint256)'))
945    */
946 
947   /**
948    * @dev Constructor function
949    */
950   constructor(string name, string symbol) public {
951     _name = name;
952     _symbol = symbol;
953 
954     // register the supported interfaces to conform to ERC721 via ERC165
955     _registerInterface(InterfaceId_ERC721Metadata);
956   }
957 
958   /**
959    * @dev Gets the token name
960    * @return string representing the token name
961    */
962   function name() external view returns (string) {
963     return _name;
964   }
965 
966   /**
967    * @dev Gets the token symbol
968    * @return string representing the token symbol
969    */
970   function symbol() external view returns (string) {
971     return _symbol;
972   }
973 
974   /**
975    * @dev Returns an URI for a given token ID
976    * Throws if the token ID does not exist. May return an empty string.
977    * @param tokenId uint256 ID of the token to query
978    */
979   function tokenURI(uint256 tokenId) external view returns (string) {
980     require(_exists(tokenId));
981     return _tokenURIs[tokenId];
982   }
983 
984   /**
985    * @dev Internal function to set the token URI for a given token
986    * Reverts if the token ID does not exist
987    * @param tokenId uint256 ID of the token to set its URI
988    * @param uri string URI to assign
989    */
990   function _setTokenURI(uint256 tokenId, string uri) internal {
991     require(_exists(tokenId));
992     _tokenURIs[tokenId] = uri;
993   }
994 
995   /**
996    * @dev Internal function to burn a specific token
997    * Reverts if the token does not exist
998    * @param owner owner of the token to burn
999    * @param tokenId uint256 ID of the token being burned by the msg.sender
1000    */
1001   function _burn(address owner, uint256 tokenId) internal {
1002     super._burn(owner, tokenId);
1003 
1004     // Clear metadata (if any)
1005     if (bytes(_tokenURIs[tokenId]).length != 0) {
1006       delete _tokenURIs[tokenId];
1007     }
1008   }
1009 }
1010 
1011 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
1012 
1013 /**
1014  * @title Full ERC721 Token
1015  * This implementation includes all the required and some optional functionality of the ERC721 standard
1016  * Moreover, it includes approve all functionality using operator terminology
1017  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1018  */
1019 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1020   constructor(string name, string symbol) ERC721Metadata(name, symbol)
1021     public
1022   {
1023   }
1024 }
1025 
1026 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
1027 
1028 /**
1029  * @title ERC721Mintable
1030  * @dev ERC721 minting logic
1031  */
1032 contract ERC721Mintable is ERC721, MinterRole {
1033   /**
1034    * @dev Function to mint tokens
1035    * @param to The address that will receive the minted tokens.
1036    * @param tokenId The token id to mint.
1037    * @return A boolean that indicates if the operation was successful.
1038    */
1039   function mint(
1040     address to,
1041     uint256 tokenId
1042   )
1043     public
1044     onlyMinter
1045     returns (bool)
1046   {
1047     _mint(to, tokenId);
1048     return true;
1049   }
1050 }
1051 
1052 // File: contracts/strings.sol
1053 
1054 library Strings {
1055   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1056   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1057       bytes memory _ba = bytes(_a);
1058       bytes memory _bb = bytes(_b);
1059       bytes memory _bc = bytes(_c);
1060       bytes memory _bd = bytes(_d);
1061       bytes memory _be = bytes(_e);
1062       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1063       bytes memory babcde = bytes(abcde);
1064       uint k = 0;
1065       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1066       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1067       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1068       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1069       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1070       return string(babcde);
1071     }
1072 
1073     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1074         return strConcat(_a, _b, _c, _d, "");
1075     }
1076 
1077     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1078         return strConcat(_a, _b, _c, "", "");
1079     }
1080 
1081     function strConcat(string _a, string _b) internal pure returns (string) {
1082         return strConcat(_a, _b, "", "", "");
1083     }
1084 
1085     function uint2str(uint i) internal pure returns (string) {
1086         if (i == 0) return "0";
1087         uint j = i;
1088         uint len;
1089         while (j != 0){
1090             len++;
1091             j /= 10;
1092         }
1093         bytes memory bstr = new bytes(len);
1094         uint k = len - 1;
1095         while (i != 0){
1096             bstr[k--] = byte(48 + i % 10);
1097             i /= 10;
1098         }
1099         return string(bstr);
1100     }
1101 }
1102 
1103 // File: contracts/BountyNFT.sol
1104 
1105 contract MinterRoleMock is MinterRole, Ownable {
1106   function removeMinter(address account) public onlyOwner{
1107     _removeMinter(account);
1108   }
1109 
1110   function onlyMinterMock() public view onlyMinter {
1111   }
1112 
1113   // Causes a compilation error if super._removeMinter is not internal
1114   function _removeMinter(address account) internal {
1115     super._removeMinter(account);
1116   }
1117 }
1118 
1119 contract Puzzle is ERC721Full, ERC721Mintable, MinterRoleMock, ERC721Burnable {
1120   address proxyRegistryAddress;
1121   string _baseTokenURI = "https://game.lordless.com/api/puzzle/";
1122   uint256 public nextId = 0x0;
1123   constructor(address _proxyRegistryAddress) ERC721Full("LORDLESS:Puzzle", "Puzzle") public {
1124     proxyRegistryAddress = _proxyRegistryAddress;
1125   }
1126 
1127   /**
1128    * @dev Returns an URI for a given token ID
1129    */
1130   
1131   function tokenURI(uint256 _tokenId) external view returns (string) {
1132     return Strings.strConcat(
1133         baseTokenURI(),
1134         Strings.uint2str(_tokenId)
1135     );
1136   }
1137   
1138   function baseTokenURI() public view returns (string) {
1139     return _baseTokenURI;
1140   }
1141 
1142   function setBaseTokenURI(string baseTokenURI) external onlyOwner {
1143     _baseTokenURI = baseTokenURI;
1144   }
1145   
1146   function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
1147     _mint(to, tokenId);
1148     nextId++;
1149     return true;
1150   }
1151 
1152   function mintTo(address _to) external onlyMinter returns (bool, uint256) {
1153     uint256 newTokenId = _getNextTokenId();
1154     return (mint(_to, newTokenId), newTokenId);
1155   }
1156 
1157   function _getNextTokenId() private view returns (uint256) {
1158     return nextId;
1159   }
1160   /**
1161    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1162    */
1163   function isApprovedForAll(
1164     address owner,
1165     address operator
1166   )
1167     public
1168     view
1169     returns (bool)
1170   {
1171     // Whitelist OpenSea proxy contract for easy trading.
1172     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1173     if (proxyRegistry.proxies(owner) == operator) {
1174       return true;
1175     }
1176 
1177     return super.isApprovedForAll(owner, operator);
1178   }
1179 }
1180 
1181 contract OwnableDelegateProxy { }
1182 
1183 contract ProxyRegistry {
1184   mapping(address => OwnableDelegateProxy) public proxies;
1185 }