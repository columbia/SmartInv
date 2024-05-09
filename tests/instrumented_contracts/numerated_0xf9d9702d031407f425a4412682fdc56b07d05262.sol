1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
48 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
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
90 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
91 
92 /**
93  * @title IERC165
94  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
95  */
96 interface IERC165 {
97 
98   /**
99    * @notice Query if a contract implements an interface
100    * @param interfaceId The interface identifier, as specified in ERC-165
101    * @dev Interface identification is specified in ERC-165. This function
102    * uses less than 30,000 gas.
103    */
104   function supportsInterface(bytes4 interfaceId)
105     external
106     view
107     returns (bool);
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
111 
112 /**
113  * @title ERC721 Non-Fungible Token Standard basic interface
114  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
115  */
116 contract IERC721 is IERC165 {
117 
118   event Transfer(
119     address indexed from,
120     address indexed to,
121     uint256 indexed tokenId
122   );
123   event Approval(
124     address indexed owner,
125     address indexed approved,
126     uint256 indexed tokenId
127   );
128   event ApprovalForAll(
129     address indexed owner,
130     address indexed operator,
131     bool approved
132   );
133 
134   function balanceOf(address owner) public view returns (uint256 balance);
135   function ownerOf(uint256 tokenId) public view returns (address owner);
136 
137   function approve(address to, uint256 tokenId) public;
138   function getApproved(uint256 tokenId)
139     public view returns (address operator);
140 
141   function setApprovalForAll(address operator, bool _approved) public;
142   function isApprovedForAll(address owner, address operator)
143     public view returns (bool);
144 
145   function transferFrom(address from, address to, uint256 tokenId) public;
146   function safeTransferFrom(address from, address to, uint256 tokenId)
147     public;
148 
149   function safeTransferFrom(
150     address from,
151     address to,
152     uint256 tokenId,
153     bytes data
154   )
155     public;
156 }
157 
158 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
159 
160 /**
161  * @title ERC721 token receiver interface
162  * @dev Interface for any contract that wants to support safeTransfers
163  * from ERC721 asset contracts.
164  */
165 contract IERC721Receiver {
166   /**
167    * @notice Handle the receipt of an NFT
168    * @dev The ERC721 smart contract calls this function on the recipient
169    * after a `safeTransfer`. This function MUST return the function selector,
170    * otherwise the caller will revert the transaction. The selector to be
171    * returned can be obtained as `this.onERC721Received.selector`. This
172    * function MAY throw to revert and reject the transfer.
173    * Note: the ERC721 contract address is always the message sender.
174    * @param operator The address which called `safeTransferFrom` function
175    * @param from The address which previously owned the token
176    * @param tokenId The NFT identifier which is being transferred
177    * @param data Additional data with no specified format
178    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
179    */
180   function onERC721Received(
181     address operator,
182     address from,
183     uint256 tokenId,
184     bytes data
185   )
186     public
187     returns(bytes4);
188 }
189 
190 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
191 
192 /**
193  * @title SafeMath
194  * @dev Math operations with safety checks that revert on error
195  */
196 library SafeMath {
197 
198   /**
199   * @dev Multiplies two numbers, reverts on overflow.
200   */
201   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203     // benefit is lost if 'b' is also tested.
204     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
205     if (a == 0) {
206       return 0;
207     }
208 
209     uint256 c = a * b;
210     require(c / a == b);
211 
212     return c;
213   }
214 
215   /**
216   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
217   */
218   function div(uint256 a, uint256 b) internal pure returns (uint256) {
219     require(b > 0); // Solidity only automatically asserts when dividing by 0
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223     return c;
224   }
225 
226   /**
227   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
228   */
229   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230     require(b <= a);
231     uint256 c = a - b;
232 
233     return c;
234   }
235 
236   /**
237   * @dev Adds two numbers, reverts on overflow.
238   */
239   function add(uint256 a, uint256 b) internal pure returns (uint256) {
240     uint256 c = a + b;
241     require(c >= a);
242 
243     return c;
244   }
245 
246   /**
247   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
248   * reverts when dividing by zero.
249   */
250   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251     require(b != 0);
252     return a % b;
253   }
254 }
255 
256 // File: openzeppelin-solidity/contracts/utils/Address.sol
257 
258 /**
259  * Utility library of inline functions on addresses
260  */
261 library Address {
262 
263   /**
264    * Returns whether the target address is a contract
265    * @dev This function will return false if invoked during the constructor of a contract,
266    * as the code is not actually created until after the constructor finishes.
267    * @param account address of the account to check
268    * @return whether the target address is a contract
269    */
270   function isContract(address account) internal view returns (bool) {
271     uint256 size;
272     // XXX Currently there is no better way to check if there is a contract in an address
273     // than to check the size of the code at that address.
274     // See https://ethereum.stackexchange.com/a/14016/36603
275     // for more details about how this works.
276     // TODO Check this again before the Serenity release, because all addresses will be
277     // contracts then.
278     // solium-disable-next-line security/no-inline-assembly
279     assembly { size := extcodesize(account) }
280     return size > 0;
281   }
282 
283 }
284 
285 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
286 
287 /**
288  * @title ERC165
289  * @author Matt Condon (@shrugs)
290  * @dev Implements ERC165 using a lookup table.
291  */
292 contract ERC165 is IERC165 {
293 
294   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
295   /**
296    * 0x01ffc9a7 ===
297    *   bytes4(keccak256('supportsInterface(bytes4)'))
298    */
299 
300   /**
301    * @dev a mapping of interface id to whether or not it's supported
302    */
303   mapping(bytes4 => bool) private _supportedInterfaces;
304 
305   /**
306    * @dev A contract implementing SupportsInterfaceWithLookup
307    * implement ERC165 itself
308    */
309   constructor()
310     internal
311   {
312     _registerInterface(_InterfaceId_ERC165);
313   }
314 
315   /**
316    * @dev implement supportsInterface(bytes4) using a lookup table
317    */
318   function supportsInterface(bytes4 interfaceId)
319     external
320     view
321     returns (bool)
322   {
323     return _supportedInterfaces[interfaceId];
324   }
325 
326   /**
327    * @dev internal method for registering an interface
328    */
329   function _registerInterface(bytes4 interfaceId)
330     internal
331   {
332     require(interfaceId != 0xffffffff);
333     _supportedInterfaces[interfaceId] = true;
334   }
335 }
336 
337 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
338 
339 /**
340  * @title ERC721 Non-Fungible Token Standard basic implementation
341  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
342  */
343 contract ERC721 is ERC165, IERC721 {
344 
345   using SafeMath for uint256;
346   using Address for address;
347 
348   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
349   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
350   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
351 
352   // Mapping from token ID to owner
353   mapping (uint256 => address) private _tokenOwner;
354 
355   // Mapping from token ID to approved address
356   mapping (uint256 => address) private _tokenApprovals;
357 
358   // Mapping from owner to number of owned token
359   mapping (address => uint256) private _ownedTokensCount;
360 
361   // Mapping from owner to operator approvals
362   mapping (address => mapping (address => bool)) private _operatorApprovals;
363 
364   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
365   /*
366    * 0x80ac58cd ===
367    *   bytes4(keccak256('balanceOf(address)')) ^
368    *   bytes4(keccak256('ownerOf(uint256)')) ^
369    *   bytes4(keccak256('approve(address,uint256)')) ^
370    *   bytes4(keccak256('getApproved(uint256)')) ^
371    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
372    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
373    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
374    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
375    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
376    */
377 
378   constructor()
379     public
380   {
381     // register the supported interfaces to conform to ERC721 via ERC165
382     _registerInterface(_InterfaceId_ERC721);
383   }
384 
385   /**
386    * @dev Gets the balance of the specified address
387    * @param owner address to query the balance of
388    * @return uint256 representing the amount owned by the passed address
389    */
390   function balanceOf(address owner) public view returns (uint256) {
391     require(owner != address(0));
392     return _ownedTokensCount[owner];
393   }
394 
395   /**
396    * @dev Gets the owner of the specified token ID
397    * @param tokenId uint256 ID of the token to query the owner of
398    * @return owner address currently marked as the owner of the given token ID
399    */
400   function ownerOf(uint256 tokenId) public view returns (address) {
401     address owner = _tokenOwner[tokenId];
402     require(owner != address(0));
403     return owner;
404   }
405 
406   /**
407    * @dev Approves another address to transfer the given token ID
408    * The zero address indicates there is no approved address.
409    * There can only be one approved address per token at a given time.
410    * Can only be called by the token owner or an approved operator.
411    * @param to address to be approved for the given token ID
412    * @param tokenId uint256 ID of the token to be approved
413    */
414   function approve(address to, uint256 tokenId) public {
415     address owner = ownerOf(tokenId);
416     require(to != owner);
417     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
418 
419     _tokenApprovals[tokenId] = to;
420     emit Approval(owner, to, tokenId);
421   }
422 
423   /**
424    * @dev Gets the approved address for a token ID, or zero if no address set
425    * Reverts if the token ID does not exist.
426    * @param tokenId uint256 ID of the token to query the approval of
427    * @return address currently approved for the given token ID
428    */
429   function getApproved(uint256 tokenId) public view returns (address) {
430     require(_exists(tokenId));
431     return _tokenApprovals[tokenId];
432   }
433 
434   /**
435    * @dev Sets or unsets the approval of a given operator
436    * An operator is allowed to transfer all tokens of the sender on their behalf
437    * @param to operator address to set the approval
438    * @param approved representing the status of the approval to be set
439    */
440   function setApprovalForAll(address to, bool approved) public {
441     require(to != msg.sender);
442     _operatorApprovals[msg.sender][to] = approved;
443     emit ApprovalForAll(msg.sender, to, approved);
444   }
445 
446   /**
447    * @dev Tells whether an operator is approved by a given owner
448    * @param owner owner address which you want to query the approval of
449    * @param operator operator address which you want to query the approval of
450    * @return bool whether the given operator is approved by the given owner
451    */
452   function isApprovedForAll(
453     address owner,
454     address operator
455   )
456     public
457     view
458     returns (bool)
459   {
460     return _operatorApprovals[owner][operator];
461   }
462 
463   /**
464    * @dev Transfers the ownership of a given token ID to another address
465    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
466    * Requires the msg sender to be the owner, approved, or operator
467    * @param from current owner of the token
468    * @param to address to receive the ownership of the given token ID
469    * @param tokenId uint256 ID of the token to be transferred
470   */
471   function transferFrom(
472     address from,
473     address to,
474     uint256 tokenId
475   )
476     public
477   {
478     require(_isApprovedOrOwner(msg.sender, tokenId));
479     require(to != address(0));
480 
481     _clearApproval(from, tokenId);
482     _removeTokenFrom(from, tokenId);
483     _addTokenTo(to, tokenId);
484 
485     emit Transfer(from, to, tokenId);
486   }
487 
488   /**
489    * @dev Safely transfers the ownership of a given token ID to another address
490    * If the target address is a contract, it must implement `onERC721Received`,
491    * which is called upon a safe transfer, and return the magic value
492    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
493    * the transfer is reverted.
494    *
495    * Requires the msg sender to be the owner, approved, or operator
496    * @param from current owner of the token
497    * @param to address to receive the ownership of the given token ID
498    * @param tokenId uint256 ID of the token to be transferred
499   */
500   function safeTransferFrom(
501     address from,
502     address to,
503     uint256 tokenId
504   )
505     public
506   {
507     // solium-disable-next-line arg-overflow
508     safeTransferFrom(from, to, tokenId, "");
509   }
510 
511   /**
512    * @dev Safely transfers the ownership of a given token ID to another address
513    * If the target address is a contract, it must implement `onERC721Received`,
514    * which is called upon a safe transfer, and return the magic value
515    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
516    * the transfer is reverted.
517    * Requires the msg sender to be the owner, approved, or operator
518    * @param from current owner of the token
519    * @param to address to receive the ownership of the given token ID
520    * @param tokenId uint256 ID of the token to be transferred
521    * @param _data bytes data to send along with a safe transfer check
522    */
523   function safeTransferFrom(
524     address from,
525     address to,
526     uint256 tokenId,
527     bytes _data
528   )
529     public
530   {
531     transferFrom(from, to, tokenId);
532     // solium-disable-next-line arg-overflow
533     require(_checkOnERC721Received(from, to, tokenId, _data));
534   }
535 
536   /**
537    * @dev Returns whether the specified token exists
538    * @param tokenId uint256 ID of the token to query the existence of
539    * @return whether the token exists
540    */
541   function _exists(uint256 tokenId) internal view returns (bool) {
542     address owner = _tokenOwner[tokenId];
543     return owner != address(0);
544   }
545 
546   /**
547    * @dev Returns whether the given spender can transfer a given token ID
548    * @param spender address of the spender to query
549    * @param tokenId uint256 ID of the token to be transferred
550    * @return bool whether the msg.sender is approved for the given token ID,
551    *  is an operator of the owner, or is the owner of the token
552    */
553   function _isApprovedOrOwner(
554     address spender,
555     uint256 tokenId
556   )
557     internal
558     view
559     returns (bool)
560   {
561     address owner = ownerOf(tokenId);
562     // Disable solium check because of
563     // https://github.com/duaraghav8/Solium/issues/175
564     // solium-disable-next-line operator-whitespace
565     return (
566       spender == owner ||
567       getApproved(tokenId) == spender ||
568       isApprovedForAll(owner, spender)
569     );
570   }
571 
572   /**
573    * @dev Internal function to mint a new token
574    * Reverts if the given token ID already exists
575    * @param to The address that will own the minted token
576    * @param tokenId uint256 ID of the token to be minted by the msg.sender
577    */
578   function _mint(address to, uint256 tokenId) internal {
579     require(to != address(0));
580     _addTokenTo(to, tokenId);
581     emit Transfer(address(0), to, tokenId);
582   }
583 
584   /**
585    * @dev Internal function to burn a specific token
586    * Reverts if the token does not exist
587    * @param tokenId uint256 ID of the token being burned by the msg.sender
588    */
589   function _burn(address owner, uint256 tokenId) internal {
590     _clearApproval(owner, tokenId);
591     _removeTokenFrom(owner, tokenId);
592     emit Transfer(owner, address(0), tokenId);
593   }
594 
595   /**
596    * @dev Internal function to add a token ID to the list of a given address
597    * Note that this function is left internal to make ERC721Enumerable possible, but is not
598    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
599    * @param to address representing the new owner of the given token ID
600    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
601    */
602   function _addTokenTo(address to, uint256 tokenId) internal {
603     require(_tokenOwner[tokenId] == address(0));
604     _tokenOwner[tokenId] = to;
605     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
606   }
607 
608   /**
609    * @dev Internal function to remove a token ID from the list of a given address
610    * Note that this function is left internal to make ERC721Enumerable possible, but is not
611    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
612    * and doesn't clear approvals.
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
631   function _checkOnERC721Received(
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
647 
648   /**
649    * @dev Private function to clear current approval of a given token ID
650    * Reverts if the given address is not indeed the owner of the token
651    * @param owner owner of the token
652    * @param tokenId uint256 ID of the token to be transferred
653    */
654   function _clearApproval(address owner, uint256 tokenId) private {
655     require(ownerOf(tokenId) == owner);
656     if (_tokenApprovals[tokenId] != address(0)) {
657       _tokenApprovals[tokenId] = address(0);
658     }
659   }
660 }
661 
662 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
666  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
667  */
668 contract IERC721Enumerable is IERC721 {
669   function totalSupply() public view returns (uint256);
670   function tokenOfOwnerByIndex(
671     address owner,
672     uint256 index
673   )
674     public
675     view
676     returns (uint256 tokenId);
677 
678   function tokenByIndex(uint256 index) public view returns (uint256);
679 }
680 
681 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
682 
683 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
684   // Mapping from owner to list of owned token IDs
685   mapping(address => uint256[]) private _ownedTokens;
686 
687   // Mapping from token ID to index of the owner tokens list
688   mapping(uint256 => uint256) private _ownedTokensIndex;
689 
690   // Array with all token ids, used for enumeration
691   uint256[] private _allTokens;
692 
693   // Mapping from token id to position in the allTokens array
694   mapping(uint256 => uint256) private _allTokensIndex;
695 
696   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
697   /**
698    * 0x780e9d63 ===
699    *   bytes4(keccak256('totalSupply()')) ^
700    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
701    *   bytes4(keccak256('tokenByIndex(uint256)'))
702    */
703 
704   /**
705    * @dev Constructor function
706    */
707   constructor() public {
708     // register the supported interface to conform to ERC721 via ERC165
709     _registerInterface(_InterfaceId_ERC721Enumerable);
710   }
711 
712   /**
713    * @dev Gets the token ID at a given index of the tokens list of the requested owner
714    * @param owner address owning the tokens list to be accessed
715    * @param index uint256 representing the index to be accessed of the requested tokens list
716    * @return uint256 token ID at the given index of the tokens list owned by the requested address
717    */
718   function tokenOfOwnerByIndex(
719     address owner,
720     uint256 index
721   )
722     public
723     view
724     returns (uint256)
725   {
726     require(index < balanceOf(owner));
727     return _ownedTokens[owner][index];
728   }
729 
730   /**
731    * @dev Gets the total amount of tokens stored by the contract
732    * @return uint256 representing the total amount of tokens
733    */
734   function totalSupply() public view returns (uint256) {
735     return _allTokens.length;
736   }
737 
738   /**
739    * @dev Gets the token ID at a given index of all the tokens in this contract
740    * Reverts if the index is greater or equal to the total number of tokens
741    * @param index uint256 representing the index to be accessed of the tokens list
742    * @return uint256 token ID at the given index of the tokens list
743    */
744   function tokenByIndex(uint256 index) public view returns (uint256) {
745     require(index < totalSupply());
746     return _allTokens[index];
747   }
748 
749   /**
750    * @dev Internal function to add a token ID to the list of a given address
751    * This function is internal due to language limitations, see the note in ERC721.sol.
752    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
753    * @param to address representing the new owner of the given token ID
754    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
755    */
756   function _addTokenTo(address to, uint256 tokenId) internal {
757     super._addTokenTo(to, tokenId);
758     uint256 length = _ownedTokens[to].length;
759     _ownedTokens[to].push(tokenId);
760     _ownedTokensIndex[tokenId] = length;
761   }
762 
763   /**
764    * @dev Internal function to remove a token ID from the list of a given address
765    * This function is internal due to language limitations, see the note in ERC721.sol.
766    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
767    * and doesn't clear approvals.
768    * @param from address representing the previous owner of the given token ID
769    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
770    */
771   function _removeTokenFrom(address from, uint256 tokenId) internal {
772     super._removeTokenFrom(from, tokenId);
773 
774     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
775     // then delete the last slot.
776     uint256 tokenIndex = _ownedTokensIndex[tokenId];
777     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
778     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
779 
780     _ownedTokens[from][tokenIndex] = lastToken;
781     // This also deletes the contents at the last position of the array
782     _ownedTokens[from].length--;
783 
784     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
785     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
786     // the lastToken to the first position, and then dropping the element placed in the last position of the list
787 
788     _ownedTokensIndex[tokenId] = 0;
789     _ownedTokensIndex[lastToken] = tokenIndex;
790   }
791 
792   /**
793    * @dev Internal function to mint a new token
794    * Reverts if the given token ID already exists
795    * @param to address the beneficiary that will own the minted token
796    * @param tokenId uint256 ID of the token to be minted by the msg.sender
797    */
798   function _mint(address to, uint256 tokenId) internal {
799     super._mint(to, tokenId);
800 
801     _allTokensIndex[tokenId] = _allTokens.length;
802     _allTokens.push(tokenId);
803   }
804 
805   /**
806    * @dev Internal function to burn a specific token
807    * Reverts if the token does not exist
808    * @param owner owner of the token to burn
809    * @param tokenId uint256 ID of the token being burned by the msg.sender
810    */
811   function _burn(address owner, uint256 tokenId) internal {
812     super._burn(owner, tokenId);
813 
814     // Reorg all tokens array
815     uint256 tokenIndex = _allTokensIndex[tokenId];
816     uint256 lastTokenIndex = _allTokens.length.sub(1);
817     uint256 lastToken = _allTokens[lastTokenIndex];
818 
819     _allTokens[tokenIndex] = lastToken;
820     _allTokens[lastTokenIndex] = 0;
821 
822     _allTokens.length--;
823     _allTokensIndex[tokenId] = 0;
824     _allTokensIndex[lastToken] = tokenIndex;
825   }
826 }
827 
828 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
829 
830 /**
831  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
832  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
833  */
834 contract IERC721Metadata is IERC721 {
835   function name() external view returns (string);
836   function symbol() external view returns (string);
837   function tokenURI(uint256 tokenId) external view returns (string);
838 }
839 
840 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
841 
842 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
843   // Token name
844   string private _name;
845 
846   // Token symbol
847   string private _symbol;
848 
849   // Optional mapping for token URIs
850   mapping(uint256 => string) private _tokenURIs;
851 
852   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
853   /**
854    * 0x5b5e139f ===
855    *   bytes4(keccak256('name()')) ^
856    *   bytes4(keccak256('symbol()')) ^
857    *   bytes4(keccak256('tokenURI(uint256)'))
858    */
859 
860   /**
861    * @dev Constructor function
862    */
863   constructor(string name, string symbol) public {
864     _name = name;
865     _symbol = symbol;
866 
867     // register the supported interfaces to conform to ERC721 via ERC165
868     _registerInterface(InterfaceId_ERC721Metadata);
869   }
870 
871   /**
872    * @dev Gets the token name
873    * @return string representing the token name
874    */
875   function name() external view returns (string) {
876     return _name;
877   }
878 
879   /**
880    * @dev Gets the token symbol
881    * @return string representing the token symbol
882    */
883   function symbol() external view returns (string) {
884     return _symbol;
885   }
886 
887   /**
888    * @dev Returns an URI for a given token ID
889    * Throws if the token ID does not exist. May return an empty string.
890    * @param tokenId uint256 ID of the token to query
891    */
892   function tokenURI(uint256 tokenId) external view returns (string) {
893     require(_exists(tokenId));
894     return _tokenURIs[tokenId];
895   }
896 
897   /**
898    * @dev Internal function to set the token URI for a given token
899    * Reverts if the token ID does not exist
900    * @param tokenId uint256 ID of the token to set its URI
901    * @param uri string URI to assign
902    */
903   function _setTokenURI(uint256 tokenId, string uri) internal {
904     require(_exists(tokenId));
905     _tokenURIs[tokenId] = uri;
906   }
907 
908   /**
909    * @dev Internal function to burn a specific token
910    * Reverts if the token does not exist
911    * @param owner owner of the token to burn
912    * @param tokenId uint256 ID of the token being burned by the msg.sender
913    */
914   function _burn(address owner, uint256 tokenId) internal {
915     super._burn(owner, tokenId);
916 
917     // Clear metadata (if any)
918     if (bytes(_tokenURIs[tokenId]).length != 0) {
919       delete _tokenURIs[tokenId];
920     }
921   }
922 }
923 
924 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
925 
926 /**
927  * @title Full ERC721 Token
928  * This implementation includes all the required and some optional functionality of the ERC721 standard
929  * Moreover, it includes approve all functionality using operator terminology
930  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
931  */
932 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
933   constructor(string name, string symbol) ERC721Metadata(name, symbol)
934     public
935   {
936   }
937 }
938 
939 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
940 
941 /**
942  * @title ERC20 interface
943  * @dev see https://github.com/ethereum/EIPs/issues/20
944  */
945 interface IERC20 {
946   function totalSupply() external view returns (uint256);
947 
948   function balanceOf(address who) external view returns (uint256);
949 
950   function allowance(address owner, address spender)
951     external view returns (uint256);
952 
953   function transfer(address to, uint256 value) external returns (bool);
954 
955   function approve(address spender, uint256 value)
956     external returns (bool);
957 
958   function transferFrom(address from, address to, uint256 value)
959     external returns (bool);
960 
961   event Transfer(
962     address indexed from,
963     address indexed to,
964     uint256 value
965   );
966 
967   event Approval(
968     address indexed owner,
969     address indexed spender,
970     uint256 value
971   );
972 }
973 
974 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
975 
976 /**
977  * @title Ownable
978  * @dev The Ownable contract has an owner address, and provides basic authorization control
979  * functions, this simplifies the implementation of "user permissions".
980  */
981 contract Ownable {
982   address private _owner;
983 
984   event OwnershipTransferred(
985     address indexed previousOwner,
986     address indexed newOwner
987   );
988 
989   /**
990    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
991    * account.
992    */
993   constructor() internal {
994     _owner = msg.sender;
995     emit OwnershipTransferred(address(0), _owner);
996   }
997 
998   /**
999    * @return the address of the owner.
1000    */
1001   function owner() public view returns(address) {
1002     return _owner;
1003   }
1004 
1005   /**
1006    * @dev Throws if called by any account other than the owner.
1007    */
1008   modifier onlyOwner() {
1009     require(isOwner());
1010     _;
1011   }
1012 
1013   /**
1014    * @return true if `msg.sender` is the owner of the contract.
1015    */
1016   function isOwner() public view returns(bool) {
1017     return msg.sender == _owner;
1018   }
1019 
1020   /**
1021    * @dev Allows the current owner to relinquish control of the contract.
1022    * @notice Renouncing to ownership will leave the contract without an owner.
1023    * It will not be possible to call the functions with the `onlyOwner`
1024    * modifier anymore.
1025    */
1026   function renounceOwnership() public onlyOwner {
1027     emit OwnershipTransferred(_owner, address(0));
1028     _owner = address(0);
1029   }
1030 
1031   /**
1032    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1033    * @param newOwner The address to transfer ownership to.
1034    */
1035   function transferOwnership(address newOwner) public onlyOwner {
1036     _transferOwnership(newOwner);
1037   }
1038 
1039   /**
1040    * @dev Transfers control of the contract to a newOwner.
1041    * @param newOwner The address to transfer ownership to.
1042    */
1043   function _transferOwnership(address newOwner) internal {
1044     require(newOwner != address(0));
1045     emit OwnershipTransferred(_owner, newOwner);
1046     _owner = newOwner;
1047   }
1048 }
1049 
1050 // File: eth-token-recover/contracts/TokenRecover.sol
1051 
1052 /**
1053  * @title TokenRecover
1054  * @author Vittorio Minacori (https://github.com/vittominacori)
1055  * @dev Allow to recover any ERC20 sent into the contract for error
1056  */
1057 contract TokenRecover is Ownable {
1058 
1059   /**
1060    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1061    * @param tokenAddress The token contract address
1062    * @param tokenAmount Number of tokens to be sent
1063    */
1064   function recoverERC20(
1065     address tokenAddress,
1066     uint256 tokenAmount
1067   )
1068     public
1069     onlyOwner
1070   {
1071     IERC20(tokenAddress).transfer(owner(), tokenAmount);
1072   }
1073 }
1074 
1075 // File: solidity-linked-list/contracts/StructuredLinkedList.sol
1076 
1077 contract StructureInterface {
1078   function getValue (uint256 _id) public view returns (uint256);
1079 }
1080 
1081 
1082 /**
1083  * @title StructuredLinkedList
1084  * @author Vittorio Minacori (https://github.com/vittominacori)
1085  * @dev This utility library is inspired by https://github.com/Modular-Network/ethereum-libraries/tree/master/LinkedListLib
1086  *  It has been updated to add additional functionality and be compatible with solidity 0.4.24 coding patterns.
1087  */
1088 library StructuredLinkedList {
1089 
1090   uint256 constant NULL = 0;
1091   uint256 constant HEAD = 0;
1092   bool constant PREV = false;
1093   bool constant NEXT = true;
1094 
1095   struct List {
1096     mapping (uint256 => mapping (bool => uint256)) list;
1097   }
1098 
1099   /**
1100    * @dev Checks if the list exists
1101    * @param self stored linked list from contract
1102    * @return bool true if list exists, false otherwise
1103    */
1104   function listExists(
1105     List storage self
1106   )
1107   internal
1108   view
1109   returns (bool)
1110   {
1111     // if the head nodes previous or next pointers both point to itself, then there are no items in the list
1112     if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
1113       return true;
1114     } else {
1115       return false;
1116     }
1117   }
1118 
1119   /**
1120    * @dev Checks if the node exists
1121    * @param self stored linked list from contract
1122    * @param _node a node to search for
1123    * @return bool true if node exists, false otherwise
1124    */
1125   function nodeExists(
1126     List storage self,
1127     uint256 _node
1128   )
1129   internal
1130   view
1131   returns (bool)
1132   {
1133     if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
1134       if (self.list[HEAD][NEXT] == _node) {
1135         return true;
1136       } else {
1137         return false;
1138       }
1139     } else {
1140       return true;
1141     }
1142   }
1143 
1144   /**
1145    * @dev Returns the number of elements in the list
1146    * @param self stored linked list from contract
1147    * @return uint256
1148    */
1149   function sizeOf(
1150     List storage self
1151   )
1152   internal
1153   view
1154   returns (uint256)
1155   {
1156     bool exists;
1157     uint256 i;
1158     uint256 numElements;
1159     (exists, i) = getAdjacent(self, HEAD, NEXT);
1160     while (i != HEAD) {
1161       (exists, i) = getAdjacent(self, i, NEXT);
1162       numElements++;
1163     }
1164     return numElements;
1165   }
1166 
1167   /**
1168    * @dev Returns the links of a node as a tuple
1169    * @param self stored linked list from contract
1170    * @param _node id of the node to get
1171    * @return bool, uint256, uint256 true if node exists or false otherwise, previous node, next node
1172    */
1173   function getNode(
1174     List storage self,
1175     uint256 _node
1176   )
1177   internal
1178   view
1179   returns (bool, uint256, uint256)
1180   {
1181     if (!nodeExists(self, _node)) {
1182       return (false, 0, 0);
1183     } else {
1184       return (true, self.list[_node][PREV], self.list[_node][NEXT]);
1185     }
1186   }
1187 
1188   /**
1189    * @dev Returns the link of a node `_node` in direction `_direction`.
1190    * @param self stored linked list from contract
1191    * @param _node id of the node to step from
1192    * @param _direction direction to step in
1193    * @return bool, uint256 true if node exists or false otherwise, node in _direction
1194    */
1195   function getAdjacent(
1196     List storage self,
1197     uint256 _node,
1198     bool _direction
1199   )
1200   internal
1201   view
1202   returns (bool, uint256)
1203   {
1204     if (!nodeExists(self, _node)) {
1205       return (false, 0);
1206     } else {
1207       return (true, self.list[_node][_direction]);
1208     }
1209   }
1210 
1211   /**
1212    * @dev Returns the link of a node `_node` in direction `NEXT`.
1213    * @param self stored linked list from contract
1214    * @param _node id of the node to step from
1215    * @return bool, uint256 true if node exists or false otherwise, next node
1216    */
1217   function getNextNode(
1218     List storage self,
1219     uint256 _node
1220   )
1221   internal
1222   view
1223   returns (bool, uint256)
1224   {
1225     return getAdjacent(self, _node, NEXT);
1226   }
1227 
1228   /**
1229    * @dev Returns the link of a node `_node` in direction `PREV`.
1230    * @param self stored linked list from contract
1231    * @param _node id of the node to step from
1232    * @return bool, uint256 true if node exists or false otherwise, previous node
1233    */
1234   function getPreviousNode(
1235     List storage self,
1236     uint256 _node
1237   )
1238   internal
1239   view
1240   returns (bool, uint256)
1241   {
1242     return getAdjacent(self, _node, PREV);
1243   }
1244 
1245   /**
1246    * @dev Can be used before `insert` to build an ordered list.
1247    * @dev Get the node and then `insertBefore` or `insertAfter` basing on your list order.
1248    * @dev If you want to order basing on other than `structure.getValue()` override this function
1249    * @param self stored linked list from contract
1250    * @param _structure the structure instance
1251    * @param _value value to seek
1252    * @return uint256 next node with a value less than _value
1253    */
1254   function getSortedSpot(
1255     List storage self,
1256     address _structure,
1257     uint256 _value
1258   )
1259   internal view returns (uint256)
1260   {
1261     if (sizeOf(self) == 0) {
1262       return 0;
1263     }
1264     bool exists;
1265     uint256 next;
1266     (exists, next) = getAdjacent(self, HEAD, NEXT);
1267     while (
1268       (next != 0) && ((_value < StructureInterface(_structure).getValue(next)) != NEXT)
1269     ) {
1270       next = self.list[next][NEXT];
1271     }
1272     return next;
1273   }
1274 
1275   /**
1276    * @dev Creates a bidirectional link between two nodes on direction `_direction`
1277    * @param self stored linked list from contract
1278    * @param _node first node for linking
1279    * @param _link  node to link to in the _direction
1280    */
1281   function createLink(
1282     List storage self,
1283     uint256 _node,
1284     uint256 _link,
1285     bool _direction
1286   )
1287   internal
1288   {
1289     self.list[_link][!_direction] = _node;
1290     self.list[_node][_direction] = _link;
1291   }
1292 
1293   /**
1294    * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
1295    * @param self stored linked list from contract
1296    * @param _node existing node
1297    * @param _new  new node to insert
1298    * @param _direction direction to insert node in
1299    * @return bool true if success, false otherwise
1300    */
1301   function insert(
1302     List storage self,
1303     uint256 _node,
1304     uint256 _new,
1305     bool _direction
1306   )
1307   internal returns (bool)
1308   {
1309     if (!nodeExists(self, _new) && nodeExists(self, _node)) {
1310       uint256 c = self.list[_node][_direction];
1311       createLink(
1312         self,
1313         _node,
1314         _new,
1315         _direction
1316       );
1317       createLink(
1318         self,
1319         _new,
1320         c,
1321         _direction
1322       );
1323       return true;
1324     } else {
1325       return false;
1326     }
1327   }
1328 
1329   /**
1330    * @dev Insert node `_new` beside existing node `_node` in direction `NEXT`.
1331    * @param self stored linked list from contract
1332    * @param _node existing node
1333    * @param _new  new node to insert
1334    * @return bool true if success, false otherwise
1335    */
1336   function insertAfter(
1337     List storage self,
1338     uint256 _node,
1339     uint256 _new
1340   )
1341   internal
1342   returns (bool)
1343   {
1344     return insert(
1345       self,
1346       _node,
1347       _new,
1348       NEXT
1349     );
1350   }
1351 
1352   /**
1353    * @dev Insert node `_new` beside existing node `_node` in direction `PREV`.
1354    * @param self stored linked list from contract
1355    * @param _node existing node
1356    * @param _new  new node to insert
1357    * @return bool true if success, false otherwise
1358    */
1359   function insertBefore(
1360     List storage self,
1361     uint256 _node,
1362     uint256 _new
1363   )
1364   internal
1365   returns (bool)
1366   {
1367     return insert(
1368       self,
1369       _node,
1370       _new,
1371       PREV
1372     );
1373   }
1374 
1375   /**
1376    * @dev Removes an entry from the linked list
1377    * @param self stored linked list from contract
1378    * @param _node node to remove from the list
1379    * @return uint256 the removed node
1380    */
1381   function remove(
1382     List storage self,
1383     uint256 _node
1384   )
1385   internal
1386   returns (uint256)
1387   {
1388     if ((_node == NULL) || (!nodeExists(self, _node))) {
1389       return 0;
1390     }
1391     createLink(
1392       self,
1393       self.list[_node][PREV],
1394       self.list[_node][NEXT],
1395       NEXT
1396     );
1397     delete self.list[_node][PREV];
1398     delete self.list[_node][NEXT];
1399     return _node;
1400   }
1401 
1402   /**
1403    * @dev Pushes an entry to the head of the linked list
1404    * @param self stored linked list from contract
1405    * @param _node new entry to push to the head
1406    * @param _direction push to the head (NEXT) or tail (PREV)
1407    * @return bool true if success, false otherwise
1408    */
1409   function push(
1410     List storage self,
1411     uint256 _node,
1412     bool _direction
1413   )
1414   internal
1415   returns (bool)
1416   {
1417     return insert(
1418       self,
1419       HEAD,
1420       _node,
1421       _direction
1422     );
1423   }
1424 
1425   /**
1426    * @dev Pops the first entry from the linked list
1427    * @param self stored linked list from contract
1428    * @param _direction pop from the head (NEXT) or the tail (PREV)
1429    * @return uint256 the removed node
1430    */
1431   function pop(
1432     List storage self,
1433     bool _direction
1434   )
1435   internal
1436   returns (uint256)
1437   {
1438     bool exists;
1439     uint256 adj;
1440 
1441     (exists, adj) = getAdjacent(self, HEAD, _direction);
1442 
1443     return remove(self, adj);
1444   }
1445 }
1446 
1447 // File: contracts/WallOfChainToken.sol
1448 
1449 contract WallOfChainToken is ERC721Full, TokenRecover, MinterRole {
1450   using StructuredLinkedList for StructuredLinkedList.List;
1451 
1452   StructuredLinkedList.List list;
1453 
1454   struct WallStructure {
1455     uint256 value;
1456     string firstName;
1457     string lastName;
1458     uint256 pattern;
1459     uint256 icon;
1460   }
1461 
1462   bool public mintingFinished = false;
1463 
1464   uint256 public progressiveId = 0;
1465 
1466   // Mapping from token ID to the structures
1467   mapping(uint256 => WallStructure) structureIndex;
1468 
1469   modifier canGenerate() {
1470     require(
1471       !mintingFinished,
1472       "Minting is finished"
1473     );
1474     _;
1475   }
1476 
1477   constructor(string _name, string _symbol) public
1478   ERC721Full(_name, _symbol)
1479   {}
1480 
1481   /**
1482    * @dev Function to stop minting new tokens.
1483    */
1484   function finishMinting() public onlyOwner canGenerate {
1485     mintingFinished = true;
1486   }
1487 
1488   function newToken(
1489     address _beneficiary,
1490     uint256 _value,
1491     string _firstName,
1492     string _lastName,
1493     uint256 _pattern,
1494     uint256 _icon
1495   )
1496     public
1497     canGenerate
1498     onlyMinter
1499     returns (uint256)
1500   {
1501     uint256 tokenId = progressiveId.add(1);
1502     _mint(_beneficiary, tokenId);
1503     structureIndex[tokenId] = WallStructure(
1504       _value,
1505       _firstName,
1506       _lastName,
1507       _value == 0 ? 0 : _pattern,
1508       _value == 0 ? 0 : _icon
1509     );
1510     progressiveId = tokenId;
1511 
1512     uint256 position = list.getSortedSpot(StructureInterface(this), _value);
1513     list.insertBefore(position, tokenId);
1514 
1515     return tokenId;
1516   }
1517 
1518   function editToken (
1519     uint256 _tokenId,
1520     uint256 _value,
1521     string _firstName,
1522     string _lastName,
1523     uint256 _pattern,
1524     uint256 _icon
1525   )
1526     public
1527     onlyMinter
1528     returns (uint256)
1529   {
1530     require(
1531       _exists(_tokenId),
1532       "Token must exists"
1533     );
1534 
1535     uint256 value = getValue(_tokenId);
1536 
1537     if (_value > 0) {
1538       value = value.add(_value); // add the new value sent
1539 
1540       // reorder the list
1541       list.remove(_tokenId);
1542       uint256 position = list.getSortedSpot(StructureInterface(this), value);
1543       list.insertBefore(position, _tokenId);
1544     }
1545 
1546     structureIndex[_tokenId] = WallStructure(
1547       value,
1548       _firstName,
1549       _lastName,
1550       value == 0 ? 0 : _pattern,
1551       value == 0 ? 0 : _icon
1552     );
1553 
1554     return _tokenId;
1555   }
1556 
1557   function getWall (
1558     uint256 _tokenId
1559   )
1560     public
1561     view
1562     returns (
1563       address tokenOwner,
1564       uint256 value,
1565       string firstName,
1566       string lastName,
1567       uint256 pattern,
1568       uint256 icon
1569     )
1570   {
1571     require(
1572       _exists(_tokenId),
1573       "Token must exists"
1574     );
1575 
1576     WallStructure storage wall = structureIndex[_tokenId];
1577 
1578     tokenOwner = ownerOf(_tokenId);
1579 
1580     value = wall.value;
1581     firstName = wall.firstName;
1582     lastName = wall.lastName;
1583     pattern = wall.pattern;
1584     icon = wall.icon;
1585   }
1586 
1587   function getValue (uint256 _tokenId) public view returns (uint256) {
1588     require(
1589       _exists(_tokenId),
1590       "Token must exists"
1591     );
1592     WallStructure storage wall = structureIndex[_tokenId];
1593     return wall.value;
1594   }
1595 
1596   function getNextNode(uint256 _tokenId) public view returns (bool, uint256) {
1597     return list.getNextNode(_tokenId);
1598   }
1599 
1600   function getPreviousNode(
1601     uint256 _tokenId
1602   )
1603     public
1604     view
1605     returns (bool, uint256)
1606   {
1607     return list.getPreviousNode(_tokenId);
1608   }
1609 
1610   /**
1611    * @dev Only contract owner or token owner can burn
1612    */
1613   function burn(uint256 _tokenId) public {
1614     address tokenOwner = isOwner() ? ownerOf(_tokenId) : msg.sender;
1615     super._burn(tokenOwner, _tokenId);
1616     list.remove(_tokenId);
1617     delete structureIndex[_tokenId];
1618   }
1619 }