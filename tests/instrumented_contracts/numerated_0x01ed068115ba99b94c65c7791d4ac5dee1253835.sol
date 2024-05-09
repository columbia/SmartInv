1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 interfaceId)
16     external
17     view
18     returns (bool);
19 }
20 
21 
22 /**
23  * @title Roles
24  * @dev Library for managing addresses assigned to a Role.
25  */
26 library Roles {
27   struct Role {
28     mapping (address => bool) bearer;
29   }
30 
31   /**
32    * @dev give an account access to this role
33    */
34   function add(Role storage role, address account) internal {
35     require(account != address(0));
36     require(!has(role, account));
37 
38     role.bearer[account] = true;
39   }
40 
41   /**
42    * @dev remove an account's access to this role
43    */
44   function remove(Role storage role, address account) internal {
45     require(account != address(0));
46     require(has(role, account));
47 
48     role.bearer[account] = false;
49   }
50 
51   /**
52    * @dev check if an account has this role
53    * @return bool
54    */
55   function has(Role storage role, address account)
56     internal
57     view
58     returns (bool)
59   {
60     require(account != address(0));
61     return role.bearer[account];
62   }
63 }
64 
65 
66 
67 /**
68  * @title ERC165
69  * @author Matt Condon (@shrugs)
70  * @dev Implements ERC165 using a lookup table.
71  */
72 contract ERC165 is IERC165 {
73 
74   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
75   /**
76    * 0x01ffc9a7 ===
77    *   bytes4(keccak256('supportsInterface(bytes4)'))
78    */
79 
80   /**
81    * @dev a mapping of interface id to whether or not it's supported
82    */
83   mapping(bytes4 => bool) private _supportedInterfaces;
84 
85   /**
86    * @dev A contract implementing SupportsInterfaceWithLookup
87    * implement ERC165 itself
88    */
89   constructor()
90     internal
91   {
92     _registerInterface(_InterfaceId_ERC165);
93   }
94 
95   /**
96    * @dev implement supportsInterface(bytes4) using a lookup table
97    */
98   function supportsInterface(bytes4 interfaceId)
99     external
100     view
101     returns (bool)
102   {
103     return _supportedInterfaces[interfaceId];
104   }
105 
106   /**
107    * @dev internal method for registering an interface
108    */
109   function _registerInterface(bytes4 interfaceId)
110     internal
111   {
112     require(interfaceId != 0xffffffff);
113     _supportedInterfaces[interfaceId] = true;
114   }
115 }
116 
117 
118 contract MinterRole {
119   using Roles for Roles.Role;
120 
121   event MinterAdded(address indexed account);
122   event MinterRemoved(address indexed account);
123 
124   Roles.Role private minters;
125 
126   constructor() internal {
127     _addMinter(msg.sender);
128   }
129 
130   modifier onlyMinter() {
131     require(isMinter(msg.sender));
132     _;
133   }
134 
135   function isMinter(address account) public view returns (bool) {
136     return minters.has(account);
137   }
138 
139   function addMinter(address account) public onlyMinter {
140     _addMinter(account);
141   }
142 
143   function renounceMinter() public {
144     _removeMinter(msg.sender);
145   }
146 
147   function _addMinter(address account) internal {
148     minters.add(account);
149     emit MinterAdded(account);
150   }
151 
152   function _removeMinter(address account) internal {
153     minters.remove(account);
154     emit MinterRemoved(account);
155   }
156 }
157 
158 
159 
160 
161 
162 
163 
164 
165 
166 
167 /**
168  * @title ERC721 Non-Fungible Token Standard basic interface
169  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
170  */
171 contract IERC721 is IERC165 {
172 
173   event Transfer(
174     address indexed from,
175     address indexed to,
176     uint256 indexed tokenId
177   );
178   event Approval(
179     address indexed owner,
180     address indexed approved,
181     uint256 indexed tokenId
182   );
183   event ApprovalForAll(
184     address indexed owner,
185     address indexed operator,
186     bool approved
187   );
188 
189   function balanceOf(address owner) public view returns (uint256 balance);
190   function ownerOf(uint256 tokenId) public view returns (address owner);
191 
192   function approve(address to, uint256 tokenId) public;
193   function getApproved(uint256 tokenId)
194     public view returns (address operator);
195 
196   function setApprovalForAll(address operator, bool _approved) public;
197   function isApprovedForAll(address owner, address operator)
198     public view returns (bool);
199 
200   function transferFrom(address from, address to, uint256 tokenId) public;
201   function safeTransferFrom(address from, address to, uint256 tokenId)
202     public;
203 
204   function safeTransferFrom(
205     address from,
206     address to,
207     uint256 tokenId,
208     bytes data
209   )
210     public;
211 }
212 
213 
214 
215 /**
216  * @title ERC721 token receiver interface
217  * @dev Interface for any contract that wants to support safeTransfers
218  * from ERC721 asset contracts.
219  */
220 contract IERC721Receiver {
221   /**
222    * @notice Handle the receipt of an NFT
223    * @dev The ERC721 smart contract calls this function on the recipient
224    * after a `safeTransfer`. This function MUST return the function selector,
225    * otherwise the caller will revert the transaction. The selector to be
226    * returned can be obtained as `this.onERC721Received.selector`. This
227    * function MAY throw to revert and reject the transfer.
228    * Note: the ERC721 contract address is always the message sender.
229    * @param operator The address which called `safeTransferFrom` function
230    * @param from The address which previously owned the token
231    * @param tokenId The NFT identifier which is being transferred
232    * @param data Additional data with no specified format
233    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
234    */
235   function onERC721Received(
236     address operator,
237     address from,
238     uint256 tokenId,
239     bytes data
240   )
241     public
242     returns(bytes4);
243 }
244 
245 
246 
247 /**
248  * @title SafeMath
249  * @dev Math operations with safety checks that revert on error
250  */
251 library SafeMath {
252 
253   /**
254   * @dev Multiplies two numbers, reverts on overflow.
255   */
256   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258     // benefit is lost if 'b' is also tested.
259     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
260     if (a == 0) {
261       return 0;
262     }
263 
264     uint256 c = a * b;
265     require(c / a == b);
266 
267     return c;
268   }
269 
270   /**
271   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
272   */
273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
274     require(b > 0); // Solidity only automatically asserts when dividing by 0
275     uint256 c = a / b;
276     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277 
278     return c;
279   }
280 
281   /**
282   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
283   */
284   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285     require(b <= a);
286     uint256 c = a - b;
287 
288     return c;
289   }
290 
291   /**
292   * @dev Adds two numbers, reverts on overflow.
293   */
294   function add(uint256 a, uint256 b) internal pure returns (uint256) {
295     uint256 c = a + b;
296     require(c >= a);
297 
298     return c;
299   }
300 
301   /**
302   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
303   * reverts when dividing by zero.
304   */
305   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
306     require(b != 0);
307     return a % b;
308   }
309 }
310 
311 
312 
313 /**
314  * Utility library of inline functions on addresses
315  */
316 library Address {
317 
318   /**
319    * Returns whether the target address is a contract
320    * @dev This function will return false if invoked during the constructor of a contract,
321    * as the code is not actually created until after the constructor finishes.
322    * @param account address of the account to check
323    * @return whether the target address is a contract
324    */
325   function isContract(address account) internal view returns (bool) {
326     uint256 size;
327     // XXX Currently there is no better way to check if there is a contract in an address
328     // than to check the size of the code at that address.
329     // See https://ethereum.stackexchange.com/a/14016/36603
330     // for more details about how this works.
331     // TODO Check this again before the Serenity release, because all addresses will be
332     // contracts then.
333     // solium-disable-next-line security/no-inline-assembly
334     assembly { size := extcodesize(account) }
335     return size > 0;
336   }
337 
338 }
339 
340 
341 
342 /**
343  * @title ERC721 Non-Fungible Token Standard basic implementation
344  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
345  */
346 contract ERC721 is ERC165, IERC721 {
347 
348   using SafeMath for uint256;
349   using Address for address;
350 
351   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
352   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
353   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
354 
355   // Mapping from token ID to owner
356   mapping (uint256 => address) private _tokenOwner;
357 
358   // Mapping from token ID to approved address
359   mapping (uint256 => address) private _tokenApprovals;
360 
361   // Mapping from owner to number of owned token
362   mapping (address => uint256) private _ownedTokensCount;
363 
364   // Mapping from owner to operator approvals
365   mapping (address => mapping (address => bool)) private _operatorApprovals;
366 
367   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
368   /*
369    * 0x80ac58cd ===
370    *   bytes4(keccak256('balanceOf(address)')) ^
371    *   bytes4(keccak256('ownerOf(uint256)')) ^
372    *   bytes4(keccak256('approve(address,uint256)')) ^
373    *   bytes4(keccak256('getApproved(uint256)')) ^
374    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
375    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
376    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
377    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
378    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
379    */
380 
381   constructor()
382     public
383   {
384     // register the supported interfaces to conform to ERC721 via ERC165
385     _registerInterface(_InterfaceId_ERC721);
386   }
387 
388   /**
389    * @dev Gets the balance of the specified address
390    * @param owner address to query the balance of
391    * @return uint256 representing the amount owned by the passed address
392    */
393   function balanceOf(address owner) public view returns (uint256) {
394     require(owner != address(0));
395     return _ownedTokensCount[owner];
396   }
397 
398   /**
399    * @dev Gets the owner of the specified token ID
400    * @param tokenId uint256 ID of the token to query the owner of
401    * @return owner address currently marked as the owner of the given token ID
402    */
403   function ownerOf(uint256 tokenId) public view returns (address) {
404     address owner = _tokenOwner[tokenId];
405     require(owner != address(0));
406     return owner;
407   }
408 
409   /**
410    * @dev Approves another address to transfer the given token ID
411    * The zero address indicates there is no approved address.
412    * There can only be one approved address per token at a given time.
413    * Can only be called by the token owner or an approved operator.
414    * @param to address to be approved for the given token ID
415    * @param tokenId uint256 ID of the token to be approved
416    */
417   function approve(address to, uint256 tokenId) public {
418     address owner = ownerOf(tokenId);
419     require(to != owner);
420     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
421 
422     _tokenApprovals[tokenId] = to;
423     emit Approval(owner, to, tokenId);
424   }
425 
426   /**
427    * @dev Gets the approved address for a token ID, or zero if no address set
428    * Reverts if the token ID does not exist.
429    * @param tokenId uint256 ID of the token to query the approval of
430    * @return address currently approved for the given token ID
431    */
432   function getApproved(uint256 tokenId) public view returns (address) {
433     require(_exists(tokenId));
434     return _tokenApprovals[tokenId];
435   }
436 
437   /**
438    * @dev Sets or unsets the approval of a given operator
439    * An operator is allowed to transfer all tokens of the sender on their behalf
440    * @param to operator address to set the approval
441    * @param approved representing the status of the approval to be set
442    */
443   function setApprovalForAll(address to, bool approved) public {
444     require(to != msg.sender);
445     _operatorApprovals[msg.sender][to] = approved;
446     emit ApprovalForAll(msg.sender, to, approved);
447   }
448 
449   /**
450    * @dev Tells whether an operator is approved by a given owner
451    * @param owner owner address which you want to query the approval of
452    * @param operator operator address which you want to query the approval of
453    * @return bool whether the given operator is approved by the given owner
454    */
455   function isApprovedForAll(
456     address owner,
457     address operator
458   )
459     public
460     view
461     returns (bool)
462   {
463     return _operatorApprovals[owner][operator];
464   }
465 
466   /**
467    * @dev Transfers the ownership of a given token ID to another address
468    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
469    * Requires the msg sender to be the owner, approved, or operator
470    * @param from current owner of the token
471    * @param to address to receive the ownership of the given token ID
472    * @param tokenId uint256 ID of the token to be transferred
473   */
474   function transferFrom(
475     address from,
476     address to,
477     uint256 tokenId
478   )
479     public
480   {
481     require(_isApprovedOrOwner(msg.sender, tokenId));
482     require(to != address(0));
483 
484     _clearApproval(from, tokenId);
485     _removeTokenFrom(from, tokenId);
486     _addTokenTo(to, tokenId);
487 
488     emit Transfer(from, to, tokenId);
489   }
490 
491   /**
492    * @dev Safely transfers the ownership of a given token ID to another address
493    * If the target address is a contract, it must implement `onERC721Received`,
494    * which is called upon a safe transfer, and return the magic value
495    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
496    * the transfer is reverted.
497    *
498    * Requires the msg sender to be the owner, approved, or operator
499    * @param from current owner of the token
500    * @param to address to receive the ownership of the given token ID
501    * @param tokenId uint256 ID of the token to be transferred
502   */
503   function safeTransferFrom(
504     address from,
505     address to,
506     uint256 tokenId
507   )
508     public
509   {
510     // solium-disable-next-line arg-overflow
511     safeTransferFrom(from, to, tokenId, "");
512   }
513 
514   /**
515    * @dev Safely transfers the ownership of a given token ID to another address
516    * If the target address is a contract, it must implement `onERC721Received`,
517    * which is called upon a safe transfer, and return the magic value
518    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
519    * the transfer is reverted.
520    * Requires the msg sender to be the owner, approved, or operator
521    * @param from current owner of the token
522    * @param to address to receive the ownership of the given token ID
523    * @param tokenId uint256 ID of the token to be transferred
524    * @param _data bytes data to send along with a safe transfer check
525    */
526   function safeTransferFrom(
527     address from,
528     address to,
529     uint256 tokenId,
530     bytes _data
531   )
532     public
533   {
534     transferFrom(from, to, tokenId);
535     // solium-disable-next-line arg-overflow
536     require(_checkOnERC721Received(from, to, tokenId, _data));
537   }
538 
539   /**
540    * @dev Returns whether the specified token exists
541    * @param tokenId uint256 ID of the token to query the existence of
542    * @return whether the token exists
543    */
544   function _exists(uint256 tokenId) internal view returns (bool) {
545     address owner = _tokenOwner[tokenId];
546     return owner != address(0);
547   }
548 
549   /**
550    * @dev Returns whether the given spender can transfer a given token ID
551    * @param spender address of the spender to query
552    * @param tokenId uint256 ID of the token to be transferred
553    * @return bool whether the msg.sender is approved for the given token ID,
554    *  is an operator of the owner, or is the owner of the token
555    */
556   function _isApprovedOrOwner(
557     address spender,
558     uint256 tokenId
559   )
560     internal
561     view
562     returns (bool)
563   {
564     address owner = ownerOf(tokenId);
565     // Disable solium check because of
566     // https://github.com/duaraghav8/Solium/issues/175
567     // solium-disable-next-line operator-whitespace
568     return (
569       spender == owner ||
570       getApproved(tokenId) == spender ||
571       isApprovedForAll(owner, spender)
572     );
573   }
574 
575   /**
576    * @dev Internal function to mint a new token
577    * Reverts if the given token ID already exists
578    * @param to The address that will own the minted token
579    * @param tokenId uint256 ID of the token to be minted by the msg.sender
580    */
581   function _mint(address to, uint256 tokenId) internal {
582     require(to != address(0));
583     _addTokenTo(to, tokenId);
584     emit Transfer(address(0), to, tokenId);
585   }
586 
587   /**
588    * @dev Internal function to burn a specific token
589    * Reverts if the token does not exist
590    * @param tokenId uint256 ID of the token being burned by the msg.sender
591    */
592   function _burn(address owner, uint256 tokenId) internal {
593     _clearApproval(owner, tokenId);
594     _removeTokenFrom(owner, tokenId);
595     emit Transfer(owner, address(0), tokenId);
596   }
597 
598   /**
599    * @dev Internal function to add a token ID to the list of a given address
600    * Note that this function is left internal to make ERC721Enumerable possible, but is not
601    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
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
613    * Note that this function is left internal to make ERC721Enumerable possible, but is not
614    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
615    * and doesn't clear approvals.
616    * @param from address representing the previous owner of the given token ID
617    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
618    */
619   function _removeTokenFrom(address from, uint256 tokenId) internal {
620     require(ownerOf(tokenId) == from);
621     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
622     _tokenOwner[tokenId] = address(0);
623   }
624 
625   /**
626    * @dev Internal function to invoke `onERC721Received` on a target address
627    * The call is not executed if the target address is not a contract
628    * @param from address representing the previous owner of the given token ID
629    * @param to target address that will receive the tokens
630    * @param tokenId uint256 ID of the token to be transferred
631    * @param _data bytes optional data to send along with the call
632    * @return whether the call correctly returned the expected magic value
633    */
634   function _checkOnERC721Received(
635     address from,
636     address to,
637     uint256 tokenId,
638     bytes _data
639   )
640     internal
641     returns (bool)
642   {
643     if (!to.isContract()) {
644       return true;
645     }
646     bytes4 retval = IERC721Receiver(to).onERC721Received(
647       msg.sender, from, tokenId, _data);
648     return (retval == _ERC721_RECEIVED);
649   }
650 
651   /**
652    * @dev Private function to clear current approval of a given token ID
653    * Reverts if the given address is not indeed the owner of the token
654    * @param owner owner of the token
655    * @param tokenId uint256 ID of the token to be transferred
656    */
657   function _clearApproval(address owner, uint256 tokenId) private {
658     require(ownerOf(tokenId) == owner);
659     if (_tokenApprovals[tokenId] != address(0)) {
660       _tokenApprovals[tokenId] = address(0);
661     }
662   }
663 }
664 
665 
666 
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
671  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
672  */
673 contract IERC721Metadata is IERC721 {
674   function name() external view returns (string);
675   function symbol() external view returns (string);
676   function tokenURI(uint256 tokenId) external view returns (string);
677 }
678 
679 
680 
681 
682 
683 
684 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
685   // Token name
686   string private _name;
687 
688   // Token symbol
689   string private _symbol;
690 
691   // Optional mapping for token URIs
692   mapping(uint256 => string) private _tokenURIs;
693 
694   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
695   /**
696    * 0x5b5e139f ===
697    *   bytes4(keccak256('name()')) ^
698    *   bytes4(keccak256('symbol()')) ^
699    *   bytes4(keccak256('tokenURI(uint256)'))
700    */
701 
702   /**
703    * @dev Constructor function
704    */
705   constructor(string name, string symbol) public {
706     _name = name;
707     _symbol = symbol;
708 
709     // register the supported interfaces to conform to ERC721 via ERC165
710     _registerInterface(InterfaceId_ERC721Metadata);
711   }
712 
713   /**
714    * @dev Gets the token name
715    * @return string representing the token name
716    */
717   function name() external view returns (string) {
718     return _name;
719   }
720 
721   /**
722    * @dev Gets the token symbol
723    * @return string representing the token symbol
724    */
725   function symbol() external view returns (string) {
726     return _symbol;
727   }
728 
729   /**
730    * @dev Returns an URI for a given token ID
731    * Throws if the token ID does not exist. May return an empty string.
732    * @param tokenId uint256 ID of the token to query
733    */
734   function tokenURI(uint256 tokenId) external view returns (string) {
735     require(_exists(tokenId));
736     return _tokenURIs[tokenId];
737   }
738 
739   /**
740    * @dev Internal function to set the token URI for a given token
741    * Reverts if the token ID does not exist
742    * @param tokenId uint256 ID of the token to set its URI
743    * @param uri string URI to assign
744    */
745   function _setTokenURI(uint256 tokenId, string uri) internal {
746     require(_exists(tokenId));
747     _tokenURIs[tokenId] = uri;
748   }
749 
750   /**
751    * @dev Internal function to burn a specific token
752    * Reverts if the token does not exist
753    * @param owner owner of the token to burn
754    * @param tokenId uint256 ID of the token being burned by the msg.sender
755    */
756   function _burn(address owner, uint256 tokenId) internal {
757     super._burn(owner, tokenId);
758 
759     // Clear metadata (if any)
760     if (bytes(_tokenURIs[tokenId]).length != 0) {
761       delete _tokenURIs[tokenId];
762     }
763   }
764 }
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @title ERC721MetadataMintable
774  * @dev ERC721 minting logic with metadata
775  */
776 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
777   /**
778    * @dev Function to mint tokens
779    * @param to The address that will receive the minted tokens.
780    * @param tokenId The token id to mint.
781    * @param tokenURI The token URI of the minted token.
782    * @return A boolean that indicates if the operation was successful.
783    */
784   function mintWithTokenURI(
785     address to,
786     uint256 tokenId,
787     string tokenURI
788   )
789     public
790     onlyMinter
791     returns (bool)
792   {
793     _mint(to, tokenId);
794     _setTokenURI(tokenId, tokenURI);
795     return true;
796   }
797 }
798 
799 
800 contract TreasureHunt is ERC721Metadata("FOAM Treasure Hunt", "FTH"), ERC721MetadataMintable {
801 
802   constructor () public {
803   }
804 }