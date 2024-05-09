1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/openzeppelin-solidity/contracts/access/Roles.sol
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
19     role.bearer[account] = true;
20   }
21 
22   /**
23    * @dev remove an account's access to this role
24    */
25   function remove(Role storage role, address account) internal {
26     require(account != address(0));
27     role.bearer[account] = false;
28   }
29 
30   /**
31    * @dev check if an account has this role
32    * @return bool
33    */
34   function has(Role storage role, address account)
35     internal
36     view
37     returns (bool)
38   {
39     require(account != address(0));
40     return role.bearer[account];
41   }
42 }
43 
44 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
45 
46 contract MinterRole {
47   using Roles for Roles.Role;
48 
49   event MinterAdded(address indexed account);
50   event MinterRemoved(address indexed account);
51 
52   Roles.Role private minters;
53 
54   constructor() public {
55     minters.add(msg.sender);
56   }
57 
58   modifier onlyMinter() {
59     require(isMinter(msg.sender));
60     _;
61   }
62 
63   function isMinter(address account) public view returns (bool) {
64     return minters.has(account);
65   }
66 
67   function addMinter(address account) public onlyMinter {
68     minters.add(account);
69     emit MinterAdded(account);
70   }
71 
72   function renounceMinter() public {
73     minters.remove(msg.sender);
74   }
75 
76   function _removeMinter(address account) internal {
77     minters.remove(account);
78     emit MinterRemoved(account);
79   }
80 }
81 
82 // File: contracts/lib/openzeppelin-solidity/contracts/introspection/IERC165.sol
83 
84 /**
85  * @title IERC165
86  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
87  */
88 interface IERC165 {
89 
90   /**
91    * @notice Query if a contract implements an interface
92    * @param interfaceId The interface identifier, as specified in ERC-165
93    * @dev Interface identification is specified in ERC-165. This function
94    * uses less than 30,000 gas.
95    */
96   function supportsInterface(bytes4 interfaceId)
97     external
98     view
99     returns (bool);
100 }
101 
102 // File: contracts/lib/openzeppelin-solidity/contracts/introspection/ERC165.sol
103 
104 /**
105  * @title ERC165
106  * @author Matt Condon (@shrugs)
107  * @dev Implements ERC165 using a lookup table.
108  */
109 contract ERC165 is IERC165 {
110 
111   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
112   /**
113    * 0x01ffc9a7 ===
114    *   bytes4(keccak256('supportsInterface(bytes4)'))
115    */
116 
117   /**
118    * @dev a mapping of interface id to whether or not it's supported
119    */
120   mapping(bytes4 => bool) internal _supportedInterfaces;
121 
122   /**
123    * @dev A contract implementing SupportsInterfaceWithLookup
124    * implement ERC165 itself
125    */
126   constructor()
127     public
128   {
129     _registerInterface(_InterfaceId_ERC165);
130   }
131 
132   /**
133    * @dev implement supportsInterface(bytes4) using a lookup table
134    */
135   function supportsInterface(bytes4 interfaceId)
136     external
137     view
138     returns (bool)
139   {
140     return _supportedInterfaces[interfaceId];
141   }
142 
143   /**
144    * @dev private method for registering an interface
145    */
146   function _registerInterface(bytes4 interfaceId)
147     internal
148   {
149     require(interfaceId != 0xffffffff);
150     _supportedInterfaces[interfaceId] = true;
151   }
152 }
153 
154 // File: contracts/lib/openzeppelin-solidity/contracts/math/SafeMath.sol
155 
156 /**
157  * @title SafeMath
158  * @dev Math operations with safety checks that revert on error
159  */
160 library SafeMath {
161 
162   /**
163   * @dev Multiplies two numbers, reverts on overflow.
164   */
165   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167     // benefit is lost if 'b' is also tested.
168     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
169     if (a == 0) {
170       return 0;
171     }
172 
173     uint256 c = a * b;
174     require(c / a == b);
175 
176     return c;
177   }
178 
179   /**
180   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
181   */
182   function div(uint256 a, uint256 b) internal pure returns (uint256) {
183     require(b > 0); // Solidity only automatically asserts when dividing by 0
184     uint256 c = a / b;
185     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187     return c;
188   }
189 
190   /**
191   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194     require(b <= a);
195     uint256 c = a - b;
196 
197     return c;
198   }
199 
200   /**
201   * @dev Adds two numbers, reverts on overflow.
202   */
203   function add(uint256 a, uint256 b) internal pure returns (uint256) {
204     uint256 c = a + b;
205     require(c >= a);
206 
207     return c;
208   }
209 
210   /**
211   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
212   * reverts when dividing by zero.
213   */
214   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215     require(b != 0);
216     return a % b;
217   }
218 }
219 
220 // File: contracts/lib/openzeppelin-solidity/contracts/utils/Address.sol
221 
222 /**
223  * Utility library of inline functions on addresses
224  */
225 library Address {
226 
227   /**
228    * Returns whether the target address is a contract
229    * @dev This function will return false if invoked during the constructor of a contract,
230    * as the code is not actually created until after the constructor finishes.
231    * @param account address of the account to check
232    * @return whether the target address is a contract
233    */
234   function isContract(address account) internal view returns (bool) {
235     uint256 size;
236     // XXX Currently there is no better way to check if there is a contract in an address
237     // than to check the size of the code at that address.
238     // See https://ethereum.stackexchange.com/a/14016/36603
239     // for more details about how this works.
240     // TODO Check this again before the Serenity release, because all addresses will be
241     // contracts then.
242     // solium-disable-next-line security/no-inline-assembly
243     assembly { size := extcodesize(account) }
244     return size > 0;
245   }
246 
247 }
248 
249 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
250 
251 /**
252  * @title ERC721 Non-Fungible Token Standard basic interface
253  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
254  */
255 contract IERC721 is IERC165 {
256 
257   event Transfer(
258     address indexed from,
259     address indexed to,
260     uint256 indexed tokenId
261   );
262   event Approval(
263     address indexed owner,
264     address indexed approved,
265     uint256 indexed tokenId
266   );
267   event ApprovalForAll(
268     address indexed owner,
269     address indexed operator,
270     bool approved
271   );
272 
273   function balanceOf(address owner) public view returns (uint256 balance);
274   function ownerOf(uint256 tokenId) public view returns (address owner);
275 
276   function approve(address to, uint256 tokenId) public;
277   function getApproved(uint256 tokenId)
278     public view returns (address operator);
279 
280   function setApprovalForAll(address operator, bool _approved) public;
281   function isApprovedForAll(address owner, address operator)
282     public view returns (bool);
283 
284   function transferFrom(address from, address to, uint256 tokenId) public;
285   function safeTransferFrom(address from, address to, uint256 tokenId)
286     public;
287 
288   function safeTransferFrom(
289     address from,
290     address to,
291     uint256 tokenId,
292     bytes data
293   )
294     public;
295 }
296 
297 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 contract IERC721Receiver {
305   /**
306    * @notice Handle the receipt of an NFT
307    * @dev The ERC721 smart contract calls this function on the recipient
308    * after a `safeTransfer`. This function MUST return the function selector,
309    * otherwise the caller will revert the transaction. The selector to be
310    * returned can be obtained as `this.onERC721Received.selector`. This
311    * function MAY throw to revert and reject the transfer.
312    * Note: the ERC721 contract address is always the message sender.
313    * @param operator The address which called `safeTransferFrom` function
314    * @param from The address which previously owned the token
315    * @param tokenId The NFT identifier which is being transferred
316    * @param data Additional data with no specified format
317    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
318    */
319   function onERC721Received(
320     address operator,
321     address from,
322     uint256 tokenId,
323     bytes data
324   )
325     public
326     returns(bytes4);
327 }
328 
329 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
330 
331 /**
332  * @title ERC721 Non-Fungible Token Standard basic implementation
333  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
334  */
335 contract ERC721 is ERC165, IERC721 {
336 
337   using SafeMath for uint256;
338   using Address for address;
339 
340   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
341   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
342   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
343 
344   // Mapping from token ID to owner
345   mapping (uint256 => address) private _tokenOwner;
346 
347   // Mapping from token ID to approved address
348   mapping (uint256 => address) private _tokenApprovals;
349 
350   // Mapping from owner to number of owned token
351   mapping (address => uint256) private _ownedTokensCount;
352 
353   // Mapping from owner to operator approvals
354   mapping (address => mapping (address => bool)) private _operatorApprovals;
355 
356   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
357   /*
358    * 0x80ac58cd ===
359    *   bytes4(keccak256('balanceOf(address)')) ^
360    *   bytes4(keccak256('ownerOf(uint256)')) ^
361    *   bytes4(keccak256('approve(address,uint256)')) ^
362    *   bytes4(keccak256('getApproved(uint256)')) ^
363    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
364    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
365    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
366    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
367    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
368    */
369 
370   constructor()
371     public
372   {
373     // register the supported interfaces to conform to ERC721 via ERC165
374     _registerInterface(_InterfaceId_ERC721);
375   }
376 
377   /**
378    * @dev Gets the balance of the specified address
379    * @param owner address to query the balance of
380    * @return uint256 representing the amount owned by the passed address
381    */
382   function balanceOf(address owner) public view returns (uint256) {
383     require(owner != address(0));
384     return _ownedTokensCount[owner];
385   }
386 
387   /**
388    * @dev Gets the owner of the specified token ID
389    * @param tokenId uint256 ID of the token to query the owner of
390    * @return owner address currently marked as the owner of the given token ID
391    */
392   function ownerOf(uint256 tokenId) public view returns (address) {
393     address owner = _tokenOwner[tokenId];
394     require(owner != address(0));
395     return owner;
396   }
397 
398   /**
399    * @dev Approves another address to transfer the given token ID
400    * The zero address indicates there is no approved address.
401    * There can only be one approved address per token at a given time.
402    * Can only be called by the token owner or an approved operator.
403    * @param to address to be approved for the given token ID
404    * @param tokenId uint256 ID of the token to be approved
405    */
406   function approve(address to, uint256 tokenId) public {
407     address owner = ownerOf(tokenId);
408     require(to != owner);
409     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
410 
411     _tokenApprovals[tokenId] = to;
412     emit Approval(owner, to, tokenId);
413   }
414 
415   /**
416    * @dev Gets the approved address for a token ID, or zero if no address set
417    * Reverts if the token ID does not exist.
418    * @param tokenId uint256 ID of the token to query the approval of
419    * @return address currently approved for the given token ID
420    */
421   function getApproved(uint256 tokenId) public view returns (address) {
422     require(_exists(tokenId));
423     return _tokenApprovals[tokenId];
424   }
425 
426   /**
427    * @dev Sets or unsets the approval of a given operator
428    * An operator is allowed to transfer all tokens of the sender on their behalf
429    * @param to operator address to set the approval
430    * @param approved representing the status of the approval to be set
431    */
432   function setApprovalForAll(address to, bool approved) public {
433     require(to != msg.sender);
434     _operatorApprovals[msg.sender][to] = approved;
435     emit ApprovalForAll(msg.sender, to, approved);
436   }
437 
438   /**
439    * @dev Tells whether an operator is approved by a given owner
440    * @param owner owner address which you want to query the approval of
441    * @param operator operator address which you want to query the approval of
442    * @return bool whether the given operator is approved by the given owner
443    */
444   function isApprovedForAll(
445     address owner,
446     address operator
447   )
448     public
449     view
450     returns (bool)
451   {
452     return _operatorApprovals[owner][operator];
453   }
454 
455   /**
456    * @dev Transfers the ownership of a given token ID to another address
457    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
458    * Requires the msg sender to be the owner, approved, or operator
459    * @param from current owner of the token
460    * @param to address to receive the ownership of the given token ID
461    * @param tokenId uint256 ID of the token to be transferred
462   */
463   function transferFrom(
464     address from,
465     address to,
466     uint256 tokenId
467   )
468     public
469   {
470     require(_isApprovedOrOwner(msg.sender, tokenId));
471     require(to != address(0));
472 
473     _clearApproval(from, tokenId);
474     _removeTokenFrom(from, tokenId);
475     _addTokenTo(to, tokenId);
476 
477     emit Transfer(from, to, tokenId);
478   }
479 
480   /**
481    * @dev Safely transfers the ownership of a given token ID to another address
482    * If the target address is a contract, it must implement `onERC721Received`,
483    * which is called upon a safe transfer, and return the magic value
484    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
485    * the transfer is reverted.
486    *
487    * Requires the msg sender to be the owner, approved, or operator
488    * @param from current owner of the token
489    * @param to address to receive the ownership of the given token ID
490    * @param tokenId uint256 ID of the token to be transferred
491   */
492   function safeTransferFrom(
493     address from,
494     address to,
495     uint256 tokenId
496   )
497     public
498   {
499     // solium-disable-next-line arg-overflow
500     safeTransferFrom(from, to, tokenId, "");
501   }
502 
503   /**
504    * @dev Safely transfers the ownership of a given token ID to another address
505    * If the target address is a contract, it must implement `onERC721Received`,
506    * which is called upon a safe transfer, and return the magic value
507    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
508    * the transfer is reverted.
509    * Requires the msg sender to be the owner, approved, or operator
510    * @param from current owner of the token
511    * @param to address to receive the ownership of the given token ID
512    * @param tokenId uint256 ID of the token to be transferred
513    * @param _data bytes data to send along with a safe transfer check
514    */
515   function safeTransferFrom(
516     address from,
517     address to,
518     uint256 tokenId,
519     bytes _data
520   )
521     public
522   {
523     transferFrom(from, to, tokenId);
524     // solium-disable-next-line arg-overflow
525     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
526   }
527 
528   /**
529    * @dev Returns whether the specified token exists
530    * @param tokenId uint256 ID of the token to query the existence of
531    * @return whether the token exists
532    */
533   function _exists(uint256 tokenId) internal view returns (bool) {
534     address owner = _tokenOwner[tokenId];
535     return owner != address(0);
536   }
537 
538   /**
539    * @dev Returns whether the given spender can transfer a given token ID
540    * @param spender address of the spender to query
541    * @param tokenId uint256 ID of the token to be transferred
542    * @return bool whether the msg.sender is approved for the given token ID,
543    *  is an operator of the owner, or is the owner of the token
544    */
545   function _isApprovedOrOwner(
546     address spender,
547     uint256 tokenId
548   )
549     internal
550     view
551     returns (bool)
552   {
553     address owner = ownerOf(tokenId);
554     // Disable solium check because of
555     // https://github.com/duaraghav8/Solium/issues/175
556     // solium-disable-next-line operator-whitespace
557     return (
558       spender == owner ||
559       getApproved(tokenId) == spender ||
560       isApprovedForAll(owner, spender)
561     );
562   }
563 
564   /**
565    * @dev Internal function to mint a new token
566    * Reverts if the given token ID already exists
567    * @param to The address that will own the minted token
568    * @param tokenId uint256 ID of the token to be minted by the msg.sender
569    */
570   function _mint(address to, uint256 tokenId) internal {
571     require(to != address(0));
572     _addTokenTo(to, tokenId);
573     emit Transfer(address(0), to, tokenId);
574   }
575 
576   /**
577    * @dev Internal function to burn a specific token
578    * Reverts if the token does not exist
579    * @param tokenId uint256 ID of the token being burned by the msg.sender
580    */
581   function _burn(address owner, uint256 tokenId) internal {
582     _clearApproval(owner, tokenId);
583     _removeTokenFrom(owner, tokenId);
584     emit Transfer(owner, address(0), tokenId);
585   }
586 
587   /**
588    * @dev Internal function to clear current approval of a given token ID
589    * Reverts if the given address is not indeed the owner of the token
590    * @param owner owner of the token
591    * @param tokenId uint256 ID of the token to be transferred
592    */
593   function _clearApproval(address owner, uint256 tokenId) internal {
594     require(ownerOf(tokenId) == owner);
595     if (_tokenApprovals[tokenId] != address(0)) {
596       _tokenApprovals[tokenId] = address(0);
597     }
598   }
599 
600   /**
601    * @dev Internal function to add a token ID to the list of a given address
602    * @param to address representing the new owner of the given token ID
603    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
604    */
605   function _addTokenTo(address to, uint256 tokenId) internal {
606     require(_tokenOwner[tokenId] == address(0));
607     _tokenOwner[tokenId] = to;
608     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
609   }
610 
611   /**
612    * @dev Internal function to remove a token ID from the list of a given address
613    * @param from address representing the previous owner of the given token ID
614    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
615    */
616   function _removeTokenFrom(address from, uint256 tokenId) internal {
617     require(ownerOf(tokenId) == from);
618     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
619     _tokenOwner[tokenId] = address(0);
620   }
621 
622   /**
623    * @dev Internal function to invoke `onERC721Received` on a target address
624    * The call is not executed if the target address is not a contract
625    * @param from address representing the previous owner of the given token ID
626    * @param to target address that will receive the tokens
627    * @param tokenId uint256 ID of the token to be transferred
628    * @param _data bytes optional data to send along with the call
629    * @return whether the call correctly returned the expected magic value
630    */
631   function _checkAndCallSafeTransfer(
632     address from,
633     address to,
634     uint256 tokenId,
635     bytes _data
636   )
637     internal
638     returns (bool)
639   {
640     if (!to.isContract()) {
641       return true;
642     }
643     bytes4 retval = IERC721Receiver(to).onERC721Received(
644       msg.sender, from, tokenId, _data);
645     return (retval == _ERC721_RECEIVED);
646   }
647 }
648 
649 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
650 
651 /**
652  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
653  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
654  */
655 contract IERC721Enumerable is IERC721 {
656   function totalSupply() public view returns (uint256);
657   function tokenOfOwnerByIndex(
658     address owner,
659     uint256 index
660   )
661     public
662     view
663     returns (uint256 tokenId);
664 
665   function tokenByIndex(uint256 index) public view returns (uint256);
666 }
667 
668 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
669 
670 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
671   // Mapping from owner to list of owned token IDs
672   mapping(address => uint256[]) private _ownedTokens;
673 
674   // Mapping from token ID to index of the owner tokens list
675   mapping(uint256 => uint256) private _ownedTokensIndex;
676 
677   // Array with all token ids, used for enumeration
678   uint256[] private _allTokens;
679 
680   // Mapping from token id to position in the allTokens array
681   mapping(uint256 => uint256) private _allTokensIndex;
682 
683   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
684   /**
685    * 0x780e9d63 ===
686    *   bytes4(keccak256('totalSupply()')) ^
687    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
688    *   bytes4(keccak256('tokenByIndex(uint256)'))
689    */
690 
691   /**
692    * @dev Constructor function
693    */
694   constructor() public {
695     // register the supported interface to conform to ERC721 via ERC165
696     _registerInterface(_InterfaceId_ERC721Enumerable);
697   }
698 
699   /**
700    * @dev Gets the token ID at a given index of the tokens list of the requested owner
701    * @param owner address owning the tokens list to be accessed
702    * @param index uint256 representing the index to be accessed of the requested tokens list
703    * @return uint256 token ID at the given index of the tokens list owned by the requested address
704    */
705   function tokenOfOwnerByIndex(
706     address owner,
707     uint256 index
708   )
709     public
710     view
711     returns (uint256)
712   {
713     require(index < balanceOf(owner));
714     return _ownedTokens[owner][index];
715   }
716 
717   /**
718    * @dev Gets the total amount of tokens stored by the contract
719    * @return uint256 representing the total amount of tokens
720    */
721   function totalSupply() public view returns (uint256) {
722     return _allTokens.length;
723   }
724 
725   /**
726    * @dev Gets the token ID at a given index of all the tokens in this contract
727    * Reverts if the index is greater or equal to the total number of tokens
728    * @param index uint256 representing the index to be accessed of the tokens list
729    * @return uint256 token ID at the given index of the tokens list
730    */
731   function tokenByIndex(uint256 index) public view returns (uint256) {
732     require(index < totalSupply());
733     return _allTokens[index];
734   }
735 
736   /**
737    * @dev Internal function to add a token ID to the list of a given address
738    * @param to address representing the new owner of the given token ID
739    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
740    */
741   function _addTokenTo(address to, uint256 tokenId) internal {
742     super._addTokenTo(to, tokenId);
743     uint256 length = _ownedTokens[to].length;
744     _ownedTokens[to].push(tokenId);
745     _ownedTokensIndex[tokenId] = length;
746   }
747 
748   /**
749    * @dev Internal function to remove a token ID from the list of a given address
750    * @param from address representing the previous owner of the given token ID
751    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
752    */
753   function _removeTokenFrom(address from, uint256 tokenId) internal {
754     super._removeTokenFrom(from, tokenId);
755 
756     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
757     // then delete the last slot.
758     uint256 tokenIndex = _ownedTokensIndex[tokenId];
759     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
760     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
761 
762     _ownedTokens[from][tokenIndex] = lastToken;
763     // This also deletes the contents at the last position of the array
764     _ownedTokens[from].length--;
765 
766     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
767     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
768     // the lastToken to the first position, and then dropping the element placed in the last position of the list
769 
770     _ownedTokensIndex[tokenId] = 0;
771     _ownedTokensIndex[lastToken] = tokenIndex;
772   }
773 
774   /**
775    * @dev Internal function to mint a new token
776    * Reverts if the given token ID already exists
777    * @param to address the beneficiary that will own the minted token
778    * @param tokenId uint256 ID of the token to be minted by the msg.sender
779    */
780   function _mint(address to, uint256 tokenId) internal {
781     super._mint(to, tokenId);
782 
783     _allTokensIndex[tokenId] = _allTokens.length;
784     _allTokens.push(tokenId);
785   }
786 
787   /**
788    * @dev Internal function to burn a specific token
789    * Reverts if the token does not exist
790    * @param owner owner of the token to burn
791    * @param tokenId uint256 ID of the token being burned by the msg.sender
792    */
793   function _burn(address owner, uint256 tokenId) internal {
794     super._burn(owner, tokenId);
795 
796     // Reorg all tokens array
797     uint256 tokenIndex = _allTokensIndex[tokenId];
798     uint256 lastTokenIndex = _allTokens.length.sub(1);
799     uint256 lastToken = _allTokens[lastTokenIndex];
800 
801     _allTokens[tokenIndex] = lastToken;
802     _allTokens[lastTokenIndex] = 0;
803 
804     _allTokens.length--;
805     _allTokensIndex[tokenId] = 0;
806     _allTokensIndex[lastToken] = tokenIndex;
807   }
808 }
809 
810 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
811 
812 /**
813  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
814  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
815  */
816 contract IERC721Metadata is IERC721 {
817   function name() external view returns (string);
818   function symbol() external view returns (string);
819   function tokenURI(uint256 tokenId) public view returns (string);
820 }
821 
822 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
823 
824 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
825   // Token name
826   string internal _name;
827 
828   // Token symbol
829   string internal _symbol;
830 
831   // Optional mapping for token URIs
832   mapping(uint256 => string) private _tokenURIs;
833 
834   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
835   /**
836    * 0x5b5e139f ===
837    *   bytes4(keccak256('name()')) ^
838    *   bytes4(keccak256('symbol()')) ^
839    *   bytes4(keccak256('tokenURI(uint256)'))
840    */
841 
842   /**
843    * @dev Constructor function
844    */
845   constructor(string name, string symbol) public {
846     _name = name;
847     _symbol = symbol;
848 
849     // register the supported interfaces to conform to ERC721 via ERC165
850     _registerInterface(InterfaceId_ERC721Metadata);
851   }
852 
853   /**
854    * @dev Gets the token name
855    * @return string representing the token name
856    */
857   function name() external view returns (string) {
858     return _name;
859   }
860 
861   /**
862    * @dev Gets the token symbol
863    * @return string representing the token symbol
864    */
865   function symbol() external view returns (string) {
866     return _symbol;
867   }
868 
869   /**
870    * @dev Returns an URI for a given token ID
871    * Throws if the token ID does not exist. May return an empty string.
872    * @param tokenId uint256 ID of the token to query
873    */
874   function tokenURI(uint256 tokenId) public view returns (string) {
875     require(_exists(tokenId));
876     return _tokenURIs[tokenId];
877   }
878 
879   /**
880    * @dev Internal function to set the token URI for a given token
881    * Reverts if the token ID does not exist
882    * @param tokenId uint256 ID of the token to set its URI
883    * @param uri string URI to assign
884    */
885   function _setTokenURI(uint256 tokenId, string uri) internal {
886     require(_exists(tokenId));
887     _tokenURIs[tokenId] = uri;
888   }
889 
890   /**
891    * @dev Internal function to burn a specific token
892    * Reverts if the token does not exist
893    * @param owner owner of the token to burn
894    * @param tokenId uint256 ID of the token being burned by the msg.sender
895    */
896   function _burn(address owner, uint256 tokenId) internal {
897     super._burn(owner, tokenId);
898 
899     // Clear metadata (if any)
900     if (bytes(_tokenURIs[tokenId]).length != 0) {
901       delete _tokenURIs[tokenId];
902     }
903   }
904 }
905 
906 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
907 
908 /**
909  * @title Full ERC721 Token
910  * This implementation includes all the required and some optional functionality of the ERC721 standard
911  * Moreover, it includes approve all functionality using operator terminology
912  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
913  */
914 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
915   constructor(string name, string symbol) ERC721Metadata(name, symbol)
916     public
917   {
918   }
919 }
920 
921 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
922 
923 /**
924  * @title ERC721Mintable
925  * @dev ERC721 minting logic
926  */
927 contract ERC721Mintable is ERC721Full, MinterRole {
928   event MintingFinished();
929 
930   bool private _mintingFinished = false;
931 
932   modifier onlyBeforeMintingFinished() {
933     require(!_mintingFinished);
934     _;
935   }
936 
937   /**
938    * @return true if the minting is finished.
939    */
940   function mintingFinished() public view returns(bool) {
941     return _mintingFinished;
942   }
943 
944   /**
945    * @dev Function to mint tokens
946    * @param to The address that will receive the minted tokens.
947    * @param tokenId The token id to mint.
948    * @return A boolean that indicates if the operation was successful.
949    */
950   function mint(
951     address to,
952     uint256 tokenId
953   )
954     public
955     onlyMinter
956     onlyBeforeMintingFinished
957     returns (bool)
958   {
959     _mint(to, tokenId);
960     return true;
961   }
962 
963   function mintWithTokenURI(
964     address to,
965     uint256 tokenId,
966     string tokenURI
967   )
968     public
969     onlyMinter
970     onlyBeforeMintingFinished
971     returns (bool)
972   {
973     mint(to, tokenId);
974     _setTokenURI(tokenId, tokenURI);
975     return true;
976   }
977 
978   /**
979    * @dev Function to stop minting new tokens.
980    * @return True if the operation was successful.
981    */
982   function finishMinting()
983     public
984     onlyMinter
985     onlyBeforeMintingFinished
986     returns (bool)
987   {
988     _mintingFinished = true;
989     emit MintingFinished();
990     return true;
991   }
992 }
993 
994 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
995 
996 contract PauserRole {
997   using Roles for Roles.Role;
998 
999   event PauserAdded(address indexed account);
1000   event PauserRemoved(address indexed account);
1001 
1002   Roles.Role private pausers;
1003 
1004   constructor() public {
1005     pausers.add(msg.sender);
1006   }
1007 
1008   modifier onlyPauser() {
1009     require(isPauser(msg.sender));
1010     _;
1011   }
1012 
1013   function isPauser(address account) public view returns (bool) {
1014     return pausers.has(account);
1015   }
1016 
1017   function addPauser(address account) public onlyPauser {
1018     pausers.add(account);
1019     emit PauserAdded(account);
1020   }
1021 
1022   function renouncePauser() public {
1023     pausers.remove(msg.sender);
1024   }
1025 
1026   function _removePauser(address account) internal {
1027     pausers.remove(account);
1028     emit PauserRemoved(account);
1029   }
1030 }
1031 
1032 // File: contracts/lib/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1033 
1034 /**
1035  * @title Pausable
1036  * @dev Base contract which allows children to implement an emergency stop mechanism.
1037  */
1038 contract Pausable is PauserRole {
1039   event Paused();
1040   event Unpaused();
1041 
1042   bool private _paused = false;
1043 
1044 
1045   /**
1046    * @return true if the contract is paused, false otherwise.
1047    */
1048   function paused() public view returns(bool) {
1049     return _paused;
1050   }
1051 
1052   /**
1053    * @dev Modifier to make a function callable only when the contract is not paused.
1054    */
1055   modifier whenNotPaused() {
1056     require(!_paused);
1057     _;
1058   }
1059 
1060   /**
1061    * @dev Modifier to make a function callable only when the contract is paused.
1062    */
1063   modifier whenPaused() {
1064     require(_paused);
1065     _;
1066   }
1067 
1068   /**
1069    * @dev called by the owner to pause, triggers stopped state
1070    */
1071   function pause() public onlyPauser whenNotPaused {
1072     _paused = true;
1073     emit Paused();
1074   }
1075 
1076   /**
1077    * @dev called by the owner to unpause, returns to normal state
1078    */
1079   function unpause() public onlyPauser whenPaused {
1080     _paused = false;
1081     emit Unpaused();
1082   }
1083 }
1084 
1085 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC721/ERC721Pausable.sol
1086 
1087 /**
1088  * @title ERC721 Non-Fungible Pausable token
1089  * @dev ERC721 modified with pausable transfers.
1090  **/
1091 contract ERC721Pausable is ERC721, Pausable {
1092   function approve(
1093     address to,
1094     uint256 tokenId
1095   )
1096     public
1097     whenNotPaused
1098   {
1099     super.approve(to, tokenId);
1100   }
1101 
1102   function setApprovalForAll(
1103     address to,
1104     bool approved
1105   )
1106     public
1107     whenNotPaused
1108   {
1109     super.setApprovalForAll(to, approved);
1110   }
1111 
1112   function transferFrom(
1113     address from,
1114     address to,
1115     uint256 tokenId
1116   )
1117     public
1118     whenNotPaused
1119   {
1120     super.transferFrom(from, to, tokenId);
1121   }
1122 }
1123 
1124 // File: contracts/HeroAsset.sol
1125 
1126 contract HeroAsset is ERC721Mintable, ERC721Pausable {
1127 
1128     uint16 public constant HERO_TYPE_OFFSET = 10000;
1129 
1130     string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/hero/";
1131     mapping(uint16 => uint16) private heroTypeToSupplyLimit;
1132 
1133     constructor() public ERC721Full("MyCryptoHeroes:Hero", "MCHH") {}
1134 
1135     function setSupplyLimit(uint16 _heroType, uint16 _supplyLimit) external onlyMinter {
1136         require(heroTypeToSupplyLimit[_heroType] == 0 || _supplyLimit < heroTypeToSupplyLimit[_heroType],
1137             "_supplyLimit is bigger");
1138         heroTypeToSupplyLimit[_heroType] = _supplyLimit;
1139     }
1140 
1141     function setTokenURIPrefix(string _tokenURIPrefix) external onlyMinter {
1142         tokenURIPrefix = _tokenURIPrefix;
1143     }
1144 
1145     function getSupplyLimit(uint16 _heroType) public view returns (uint16) {
1146         return heroTypeToSupplyLimit[_heroType];
1147     }
1148 
1149     function mintHeroAsset(address _owner, uint256 _tokenId) public onlyMinter {
1150         uint16 _heroType = uint16(_tokenId / HERO_TYPE_OFFSET);
1151         uint16 _heroTypeIndex = uint16(_tokenId % HERO_TYPE_OFFSET) - 1;
1152         require(_heroTypeIndex < heroTypeToSupplyLimit[_heroType], "supply over");
1153         _mint(_owner, _tokenId);
1154     }
1155 
1156     function tokenURI(uint256 tokenId) public view returns (string) {
1157         bytes32 tokenIdBytes;
1158         if (tokenId == 0) {
1159             tokenIdBytes = "0";
1160         } else {
1161             uint256 value = tokenId;
1162             while (value > 0) {
1163                 tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
1164                 tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
1165                 value /= 10;
1166             }
1167         }
1168 
1169         bytes memory prefixBytes = bytes(tokenURIPrefix);
1170         bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
1171 
1172         uint8 i;
1173         uint8 index = 0;
1174         
1175         for (i = 0; i < prefixBytes.length; i++) {
1176             tokenURIBytes[index] = prefixBytes[i];
1177             index++;
1178         }
1179         
1180         for (i = 0; i < tokenIdBytes.length; i++) {
1181             tokenURIBytes[index] = tokenIdBytes[i];
1182             index++;
1183         }
1184         
1185         return string(tokenURIBytes);
1186     }
1187 
1188 }
1189 
1190 // File: contracts/lib/openzeppelin-solidity/contracts/ownership/Ownable.sol
1191 
1192 /**
1193  * @title Ownable
1194  * @dev The Ownable contract has an owner address, and provides basic authorization control
1195  * functions, this simplifies the implementation of "user permissions".
1196  */
1197 contract Ownable {
1198   address private _owner;
1199 
1200 
1201   event OwnershipRenounced(address indexed previousOwner);
1202   event OwnershipTransferred(
1203     address indexed previousOwner,
1204     address indexed newOwner
1205   );
1206 
1207 
1208   /**
1209    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1210    * account.
1211    */
1212   constructor() public {
1213     _owner = msg.sender;
1214   }
1215 
1216   /**
1217    * @return the address of the owner.
1218    */
1219   function owner() public view returns(address) {
1220     return _owner;
1221   }
1222 
1223   /**
1224    * @dev Throws if called by any account other than the owner.
1225    */
1226   modifier onlyOwner() {
1227     require(isOwner());
1228     _;
1229   }
1230 
1231   /**
1232    * @return true if `msg.sender` is the owner of the contract.
1233    */
1234   function isOwner() public view returns(bool) {
1235     return msg.sender == _owner;
1236   }
1237 
1238   /**
1239    * @dev Allows the current owner to relinquish control of the contract.
1240    * @notice Renouncing to ownership will leave the contract without an owner.
1241    * It will not be possible to call the functions with the `onlyOwner`
1242    * modifier anymore.
1243    */
1244   function renounceOwnership() public onlyOwner {
1245     emit OwnershipRenounced(_owner);
1246     _owner = address(0);
1247   }
1248 
1249   /**
1250    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1251    * @param newOwner The address to transfer ownership to.
1252    */
1253   function transferOwnership(address newOwner) public onlyOwner {
1254     _transferOwnership(newOwner);
1255   }
1256 
1257   /**
1258    * @dev Transfers control of the contract to a newOwner.
1259    * @param newOwner The address to transfer ownership to.
1260    */
1261   function _transferOwnership(address newOwner) internal {
1262     require(newOwner != address(0));
1263     emit OwnershipTransferred(_owner, newOwner);
1264     _owner = newOwner;
1265   }
1266 }
1267 
1268 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
1269 
1270 /**
1271  * @title ERC20 interface
1272  * @dev see https://github.com/ethereum/EIPs/issues/20
1273  */
1274 interface IERC20 {
1275   function totalSupply() external view returns (uint256);
1276 
1277   function balanceOf(address who) external view returns (uint256);
1278 
1279   function allowance(address owner, address spender)
1280     external view returns (uint256);
1281 
1282   function transfer(address to, uint256 value) external returns (bool);
1283 
1284   function approve(address spender, uint256 value)
1285     external returns (bool);
1286 
1287   function transferFrom(address from, address to, uint256 value)
1288     external returns (bool);
1289 
1290   event Transfer(
1291     address indexed from,
1292     address indexed to,
1293     uint256 value
1294   );
1295 
1296   event Approval(
1297     address indexed owner,
1298     address indexed spender,
1299     uint256 value
1300   );
1301 }
1302 
1303 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1304 
1305 /**
1306  * @title Standard ERC20 token
1307  *
1308  * @dev Implementation of the basic standard token.
1309  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
1310  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1311  */
1312 contract ERC20 is IERC20 {
1313   using SafeMath for uint256;
1314 
1315   mapping (address => uint256) private _balances;
1316 
1317   mapping (address => mapping (address => uint256)) private _allowed;
1318 
1319   uint256 private _totalSupply;
1320 
1321   /**
1322   * @dev Total number of tokens in existence
1323   */
1324   function totalSupply() public view returns (uint256) {
1325     return _totalSupply;
1326   }
1327 
1328   /**
1329   * @dev Gets the balance of the specified address.
1330   * @param owner The address to query the the balance of.
1331   * @return An uint256 representing the amount owned by the passed address.
1332   */
1333   function balanceOf(address owner) public view returns (uint256) {
1334     return _balances[owner];
1335   }
1336 
1337   /**
1338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1339    * @param owner address The address which owns the funds.
1340    * @param spender address The address which will spend the funds.
1341    * @return A uint256 specifying the amount of tokens still available for the spender.
1342    */
1343   function allowance(
1344     address owner,
1345     address spender
1346    )
1347     public
1348     view
1349     returns (uint256)
1350   {
1351     return _allowed[owner][spender];
1352   }
1353 
1354   /**
1355   * @dev Transfer token for a specified address
1356   * @param to The address to transfer to.
1357   * @param value The amount to be transferred.
1358   */
1359   function transfer(address to, uint256 value) public returns (bool) {
1360     require(value <= _balances[msg.sender]);
1361     require(to != address(0));
1362 
1363     _balances[msg.sender] = _balances[msg.sender].sub(value);
1364     _balances[to] = _balances[to].add(value);
1365     emit Transfer(msg.sender, to, value);
1366     return true;
1367   }
1368 
1369   /**
1370    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1371    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1372    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1373    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1374    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1375    * @param spender The address which will spend the funds.
1376    * @param value The amount of tokens to be spent.
1377    */
1378   function approve(address spender, uint256 value) public returns (bool) {
1379     require(spender != address(0));
1380 
1381     _allowed[msg.sender][spender] = value;
1382     emit Approval(msg.sender, spender, value);
1383     return true;
1384   }
1385 
1386   /**
1387    * @dev Transfer tokens from one address to another
1388    * @param from address The address which you want to send tokens from
1389    * @param to address The address which you want to transfer to
1390    * @param value uint256 the amount of tokens to be transferred
1391    */
1392   function transferFrom(
1393     address from,
1394     address to,
1395     uint256 value
1396   )
1397     public
1398     returns (bool)
1399   {
1400     require(value <= _balances[from]);
1401     require(value <= _allowed[from][msg.sender]);
1402     require(to != address(0));
1403 
1404     _balances[from] = _balances[from].sub(value);
1405     _balances[to] = _balances[to].add(value);
1406     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1407     emit Transfer(from, to, value);
1408     return true;
1409   }
1410 
1411   /**
1412    * @dev Increase the amount of tokens that an owner allowed to a spender.
1413    * approve should be called when allowed_[_spender] == 0. To increment
1414    * allowed value is better to use this function to avoid 2 calls (and wait until
1415    * the first transaction is mined)
1416    * From MonolithDAO Token.sol
1417    * @param spender The address which will spend the funds.
1418    * @param addedValue The amount of tokens to increase the allowance by.
1419    */
1420   function increaseAllowance(
1421     address spender,
1422     uint256 addedValue
1423   )
1424     public
1425     returns (bool)
1426   {
1427     require(spender != address(0));
1428 
1429     _allowed[msg.sender][spender] = (
1430       _allowed[msg.sender][spender].add(addedValue));
1431     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1432     return true;
1433   }
1434 
1435   /**
1436    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1437    * approve should be called when allowed_[_spender] == 0. To decrement
1438    * allowed value is better to use this function to avoid 2 calls (and wait until
1439    * the first transaction is mined)
1440    * From MonolithDAO Token.sol
1441    * @param spender The address which will spend the funds.
1442    * @param subtractedValue The amount of tokens to decrease the allowance by.
1443    */
1444   function decreaseAllowance(
1445     address spender,
1446     uint256 subtractedValue
1447   )
1448     public
1449     returns (bool)
1450   {
1451     require(spender != address(0));
1452 
1453     _allowed[msg.sender][spender] = (
1454       _allowed[msg.sender][spender].sub(subtractedValue));
1455     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1456     return true;
1457   }
1458 
1459   /**
1460    * @dev Internal function that mints an amount of the token and assigns it to
1461    * an account. This encapsulates the modification of balances such that the
1462    * proper events are emitted.
1463    * @param account The account that will receive the created tokens.
1464    * @param amount The amount that will be created.
1465    */
1466   function _mint(address account, uint256 amount) internal {
1467     require(account != 0);
1468     _totalSupply = _totalSupply.add(amount);
1469     _balances[account] = _balances[account].add(amount);
1470     emit Transfer(address(0), account, amount);
1471   }
1472 
1473   /**
1474    * @dev Internal function that burns an amount of the token of a given
1475    * account.
1476    * @param account The account whose tokens will be burnt.
1477    * @param amount The amount that will be burnt.
1478    */
1479   function _burn(address account, uint256 amount) internal {
1480     require(account != 0);
1481     require(amount <= _balances[account]);
1482 
1483     _totalSupply = _totalSupply.sub(amount);
1484     _balances[account] = _balances[account].sub(amount);
1485     emit Transfer(account, address(0), amount);
1486   }
1487 
1488   /**
1489    * @dev Internal function that burns an amount of the token of a given
1490    * account, deducting from the sender's allowance for said account. Uses the
1491    * internal burn function.
1492    * @param account The account whose tokens will be burnt.
1493    * @param amount The amount that will be burnt.
1494    */
1495   function _burnFrom(address account, uint256 amount) internal {
1496     require(amount <= _allowed[account][msg.sender]);
1497 
1498     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1499     // this function needs to emit an event with the updated approval.
1500     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1501       amount);
1502     _burn(account, amount);
1503   }
1504 }
1505 
1506 // File: contracts/lib/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1507 
1508 /**
1509  * @title Helps contracts guard against reentrancy attacks.
1510  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1511  * @dev If you mark a function `nonReentrant`, you should also
1512  * mark it `external`.
1513  */
1514 contract ReentrancyGuard {
1515 
1516   /// @dev counter to allow mutex lock with only one SSTORE operation
1517   uint256 private _guardCounter = 1;
1518 
1519   /**
1520    * @dev Prevents a contract from calling itself, directly or indirectly.
1521    * If you mark a function `nonReentrant`, you should also
1522    * mark it `external`. Calling one `nonReentrant` function from
1523    * another is not supported. Instead, you can implement a
1524    * `private` function doing the actual work, and an `external`
1525    * wrapper marked as `nonReentrant`.
1526    */
1527   modifier nonReentrant() {
1528     _guardCounter += 1;
1529     uint256 localCounter = _guardCounter;
1530     _;
1531     require(localCounter == _guardCounter);
1532   }
1533 
1534 }
1535 
1536 // File: contracts/HeroPresale.sol
1537 
1538 contract HeroPresale is Ownable, Pausable, ReentrancyGuard {
1539     using SafeMath for uint256;
1540 
1541     struct HeroSale {
1542         uint128 highestPrice;
1543         uint128 previousPrice;
1544         uint128 priceIncreaseTo;
1545         uint64  since;
1546         uint64  until;
1547         uint64  previousSaleAt;
1548         uint16  lowestPriceRate;
1549         uint16  decreaseRate;
1550         uint16  supplyLimit;
1551         uint16  suppliedCounts;
1552         uint8   currency;
1553         bool    exists;
1554     }
1555     
1556     mapping(uint16 => HeroSale) public heroTypeToHeroSales;
1557     mapping(uint16 => uint256[]) public heroTypeIds;
1558     mapping(uint16 => mapping(address => bool)) public hasAirDropHero;
1559 
1560     ERC20 public coin;
1561     HeroAsset public heroAsset;
1562     uint16 constant internal SUPPLY_LIMIT_MAX = 10000;
1563 
1564     event AddSalesEvent(
1565         uint16 indexed heroType,
1566         uint128 startPrice,
1567         uint256 lowestPrice,
1568         uint256 becomeLowestAt
1569     );
1570 
1571     event SoldHeroEvent(
1572         uint16 indexed heroType,
1573         uint256 soldPrice,
1574         uint64  soldAt,
1575         uint256 priceIncreaseTo,
1576         uint256 lowestPrice,
1577         uint256 becomeLowestAt,
1578         address purchasedBy,
1579         address indexed code,
1580         uint8   currency
1581     );
1582 
1583     function setHeroAssetAddress(address _heroAssetAddress) external onlyOwner() {
1584         heroAsset = HeroAsset(_heroAssetAddress);
1585     }
1586 
1587     function setCoinAddress(ERC20 _coinAddress) external onlyOwner() {
1588         coin = _coinAddress;
1589     }
1590 
1591     function withdrawEther() external onlyOwner() {
1592         owner().transfer(address(this).balance);
1593     }
1594 
1595     function withdrawEMONT() external onlyOwner() {
1596         uint256 emontBalance = coin.balanceOf(this);
1597         coin.approve(address(this), emontBalance);
1598         coin.transferFrom(address(this), msg.sender, emontBalance);
1599     }
1600 
1601     function addSales(
1602         uint16 _heroType,
1603         uint128 _startPrice,
1604         uint16 _lowestPriceRate,
1605         uint16 _decreaseRate,
1606         uint64 _since,
1607         uint64 _until,
1608         uint16 _supplyLimit,
1609         uint8  _currency
1610     ) external onlyOwner() {
1611         require(!heroTypeToHeroSales[_heroType].exists, "this heroType is already added sales");
1612         require(0 <= _lowestPriceRate && _lowestPriceRate <= 100, "lowestPriceRate should be between 0 and 100");
1613         require(1 <= _decreaseRate && _decreaseRate <= 100, "decreaseRate should be should be between 1 and 100");
1614         require (_until > _since, "until should be later than since");
1615 
1616         HeroSale memory _herosale = HeroSale({
1617             highestPrice: _startPrice,
1618             previousPrice: _startPrice,
1619             priceIncreaseTo: _startPrice,
1620             since:_since,
1621             until:_until,
1622             previousSaleAt: _since,
1623             lowestPriceRate: _lowestPriceRate,
1624             decreaseRate: _decreaseRate,
1625             supplyLimit:_supplyLimit,
1626             suppliedCounts: 0,
1627             currency: _currency,
1628             exists: true
1629         });
1630 
1631         heroTypeToHeroSales[_heroType] = _herosale;
1632         heroAsset.setSupplyLimit(_heroType, _supplyLimit);
1633 
1634         uint256 _lowestPrice = uint256(_startPrice).mul(_lowestPriceRate).div(100);
1635         uint256 _becomeLowestAt = uint256(86400).mul(uint256(100).sub(_lowestPriceRate)).div(_decreaseRate).add(_since);
1636 
1637         emit AddSalesEvent(
1638             _heroType,
1639             _startPrice,
1640             _lowestPrice,
1641             _becomeLowestAt
1642         );
1643     }
1644 
1645     function purchase(uint16 _heroType, address _code) external whenNotPaused() nonReentrant() payable {
1646     // solium-disable-next-line security/no-block-members
1647         return purchaseImpl(_heroType, uint64(block.timestamp), _code);
1648     }
1649 
1650     function purchaseByEMONT(uint16 _heroType, uint256 _price, address _code) external whenNotPaused() {
1651       // solium-disable-next-line security/no-block-members
1652         return purchaseByEMONTImpl(_heroType, _price, uint64(block.timestamp), _code);
1653     }
1654 
1655     function airDrop(uint16 _heroType) external whenNotPaused() {
1656         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1657         require(airDropHero(_heroType), "currency is not 2 (airdrop)");
1658         require(!hasAirDropHero[_heroType][msg.sender]);
1659         uint64 _at = uint64(block.timestamp);
1660         require(isOnSale(_heroType, _at), "out of sales period");
1661 
1662         createHero(_heroType, msg.sender);
1663         hasAirDropHero[_heroType][msg.sender] = true;
1664         heroSales.suppliedCounts++;
1665         heroSales.previousSaleAt = _at;
1666 
1667         emit SoldHeroEvent(
1668             _heroType,
1669             1,
1670             _at,
1671             1,
1672             1,
1673             1,
1674             msg.sender,
1675             0x0000000000000000000000000000000000000000,
1676             2
1677         );
1678     }
1679 
1680 
1681     function computeCurrentPrice(uint16 _heroType) external view returns (uint8, uint256){
1682         // solium-disable-next-line security/no-block-members
1683         return computeCurrentPriceImpl(_heroType, uint64(block.timestamp));
1684     }
1685 
1686     function canBePurchasedByETH(uint16 _heroType) internal view returns (bool){
1687         return (heroTypeToHeroSales[_heroType].currency == 0);
1688     }
1689 
1690     function canBePurchasedByEMONT(uint16 _heroType) internal view returns (bool){
1691         return (heroTypeToHeroSales[_heroType].currency == 1);
1692     }
1693 
1694     function airDropHero(uint16 _heroType) internal view returns (bool){
1695         return (heroTypeToHeroSales[_heroType].currency == 2);
1696     }
1697 
1698     function isOnSale(uint16 _heroType, uint64 _now) internal view returns (bool){
1699         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1700         require(heroSales.exists, "not exist sales of this heroType");
1701 
1702         if (heroSales.since <= _now && _now <= heroSales.until) {
1703             return true;
1704         } else {
1705             return false;
1706         }
1707     }
1708 
1709     function computeCurrentPriceImpl(uint16 _heroType, uint64 _at) internal view returns (uint8, uint256) {
1710         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1711         require(heroSales.exists, "not exist sales of this heroType");
1712         require(heroSales.previousSaleAt < _at, "current timestamp should be later than previousSaleAt");
1713 
1714         uint256 _lowestPrice = uint256(heroSales.highestPrice).mul(heroSales.lowestPriceRate).div(100);
1715         uint256 _secondsPassed = uint256(_at).sub(heroSales.previousSaleAt);
1716         uint256 _decreasedPrice = uint256(heroSales.priceIncreaseTo).mul(_secondsPassed).mul(heroSales.decreaseRate).div(100).div(86400);
1717         uint256 currentPrice;
1718 
1719         if (uint256(heroSales.priceIncreaseTo).sub(_lowestPrice) > _decreasedPrice){
1720             currentPrice = uint256(heroSales.priceIncreaseTo).sub(_decreasedPrice);
1721         } else {
1722             currentPrice = _lowestPrice;
1723         }
1724 
1725         return (1, currentPrice);
1726     }
1727 
1728     function purchaseImpl(uint16 _heroType, uint64 _at, address code)
1729         internal
1730     {
1731         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1732         require(canBePurchasedByETH(_heroType), "currency is not 0 (eth)");
1733         require(isOnSale(_heroType, _at), "out of sales period");
1734         (,uint256 _price)  = computeCurrentPriceImpl(_heroType, _at);
1735         require(msg.value >= _price, "value is less than the price");
1736 
1737         createHero(_heroType, msg.sender);
1738 
1739         if (msg.value > _price){
1740             msg.sender.transfer(msg.value.sub(_price));
1741         }
1742 
1743         heroSales.previousPrice = uint128(_price);
1744         heroSales.suppliedCounts++;
1745         heroSales.previousSaleAt = _at;
1746 
1747         if (heroSales.previousPrice > heroSales.highestPrice){
1748             heroSales.highestPrice = heroSales.previousPrice;
1749         }
1750 
1751         uint256 _priceIncreaseTo;
1752         uint256 _lowestPrice;
1753         uint256 _becomeLowestAt;
1754 
1755         if(heroSales.supplyLimit > heroSales.suppliedCounts){
1756             _priceIncreaseTo = SafeMath.add(_price, _price.div((uint256(heroSales.supplyLimit).sub(heroSales.suppliedCounts))));
1757             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1758             _lowestPrice = uint256(heroSales.lowestPriceRate).mul(heroSales.highestPrice).div(100);
1759             _becomeLowestAt = uint256(86400).mul(100).mul((_priceIncreaseTo.sub(_lowestPrice))).div(_priceIncreaseTo).div(heroSales.decreaseRate).add(_at);
1760         } else {
1761             _priceIncreaseTo = heroSales.previousPrice;
1762             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1763             _lowestPrice = heroSales.previousPrice;
1764             _becomeLowestAt = _at;
1765         }
1766 
1767         address Invitees;
1768 
1769         if (code == msg.sender){
1770             Invitees = address(0x0);
1771         } else {
1772             Invitees = code;
1773         }
1774 
1775         emit SoldHeroEvent(
1776             _heroType,
1777             _price,
1778             _at,
1779             _priceIncreaseTo,
1780             _lowestPrice,
1781             _becomeLowestAt,
1782             msg.sender,
1783             Invitees,
1784             0
1785         );
1786 
1787     }
1788 
1789     function purchaseByEMONTImpl(uint16 _heroType, uint256 _inputPrice, uint64 _at, address _code)
1790         internal
1791     {
1792         HeroSale storage heroSales = heroTypeToHeroSales[_heroType];
1793         require(canBePurchasedByEMONT(_heroType), "currency is not 1 (EMONT)");
1794         require(isOnSale(_heroType, _at), "out of sales period");
1795         (,uint256 _price)  = computeCurrentPriceImpl(_heroType, _at);
1796         require(_inputPrice > _price, "input price is not more than actual price");
1797 
1798         createHero(_heroType, msg.sender);
1799         coin.transferFrom(msg.sender, address(this), _price);
1800 
1801         heroSales.previousPrice = uint128(_price);
1802         heroSales.suppliedCounts++;
1803         heroSales.previousSaleAt = _at;
1804 
1805         if (heroSales.previousPrice > heroSales.highestPrice){
1806             heroSales.highestPrice = heroSales.previousPrice;
1807         }
1808 
1809         uint256 _priceIncreaseTo;
1810         uint256 _lowestPrice;
1811         uint256 _becomeLowestAt;
1812 
1813         if(heroSales.supplyLimit > heroSales.suppliedCounts){
1814             _priceIncreaseTo = SafeMath.add(_price, _price.div((uint256(heroSales.supplyLimit).sub(heroSales.suppliedCounts))));
1815             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1816             _lowestPrice = uint256(heroSales.lowestPriceRate).mul(heroSales.highestPrice).div(100);
1817             _becomeLowestAt = uint256(86400).mul(100).mul((_priceIncreaseTo.sub(_lowestPrice))).div(_priceIncreaseTo).div(heroSales.decreaseRate).add(_at);
1818         } else {
1819             _priceIncreaseTo = heroSales.previousPrice;
1820             heroSales.priceIncreaseTo = uint128(_priceIncreaseTo);
1821             _lowestPrice = heroSales.previousPrice;
1822             _becomeLowestAt = _at;
1823         }
1824 
1825         address Invitees;
1826 
1827         if (_code == msg.sender){
1828             Invitees = address(0x0);
1829         } else {
1830             Invitees = _code;
1831         }
1832 
1833         emit SoldHeroEvent(
1834             _heroType,
1835             _price,
1836             _at,
1837             _priceIncreaseTo,
1838             _lowestPrice,
1839             _becomeLowestAt,
1840             msg.sender,
1841             Invitees,
1842             1
1843         );
1844 
1845     }
1846 
1847     function createHero(uint16 _heroType, address _owner) internal {
1848         require(heroTypeToHeroSales[_heroType].exists, "not exist sales of this heroType");
1849         require(heroTypeIds[_heroType].length < heroTypeToHeroSales[_heroType].supplyLimit, "Heroes cant be created more than supplyLimit");
1850 
1851         uint256 _heroId = uint256(_heroType).mul(SUPPLY_LIMIT_MAX).add(heroTypeIds[_heroType].length).add(1);
1852         heroTypeIds[_heroType].push(_heroId);
1853         heroAsset.mintHeroAsset(_owner, _heroId);
1854     }
1855 }