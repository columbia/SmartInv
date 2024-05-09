1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     _owner = msg.sender;
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipRenounced(_owner);
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 /**
80  * @title Destructible
81  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
82  */
83 contract Destructible is Ownable {
84   /**
85    * @dev Transfers the current balance to the owner and terminates the contract.
86    */
87   function destroy() public onlyOwner {
88     selfdestruct(owner());
89   }
90 
91   function destroyAndSend(address _recipient) public onlyOwner {
92     selfdestruct(_recipient);
93   }
94 }
95 
96 /**
97  * @title IERC165
98  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
99  */
100 interface IERC165 {
101 
102   /**
103    * @notice Query if a contract implements an interface
104    * @param interfaceId The interface identifier, as specified in ERC-165
105    * @dev Interface identification is specified in ERC-165. This function
106    * uses less than 30,000 gas.
107    */
108   function supportsInterface(bytes4 interfaceId)
109     external
110     view
111     returns (bool);
112 }
113 
114 /**
115  * @title ERC165
116  * @author Matt Condon (@shrugs)
117  * @dev Implements ERC165 using a lookup table.
118  */
119 contract ERC165 is IERC165 {
120 
121   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
122   /**
123    * 0x01ffc9a7 ===
124    *   bytes4(keccak256('supportsInterface(bytes4)'))
125    */
126 
127   /**
128    * @dev a mapping of interface id to whether or not it's supported
129    */
130   mapping(bytes4 => bool) internal _supportedInterfaces;
131 
132   /**
133    * @dev A contract implementing SupportsInterfaceWithLookup
134    * implement ERC165 itself
135    */
136   constructor()
137     public
138   {
139     _registerInterface(_InterfaceId_ERC165);
140   }
141 
142   /**
143    * @dev implement supportsInterface(bytes4) using a lookup table
144    */
145   function supportsInterface(bytes4 interfaceId)
146     external
147     view
148     returns (bool)
149   {
150     return _supportedInterfaces[interfaceId];
151   }
152 
153   /**
154    * @dev private method for registering an interface
155    */
156   function _registerInterface(bytes4 interfaceId)
157     internal
158   {
159     require(interfaceId != 0xffffffff);
160     _supportedInterfaces[interfaceId] = true;
161   }
162 }
163 
164 /**
165  * @title ERC721 Non-Fungible Token Standard basic interface
166  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
167  */
168 contract IERC721 is IERC165 {
169 
170   event Transfer(
171     address indexed from,
172     address indexed to,
173     uint256 indexed tokenId
174   );
175   event Approval(
176     address indexed owner,
177     address indexed approved,
178     uint256 indexed tokenId
179   );
180   event ApprovalForAll(
181     address indexed owner,
182     address indexed operator,
183     bool approved
184   );
185 
186   function balanceOf(address owner) public view returns (uint256 balance);
187   function ownerOf(uint256 tokenId) public view returns (address owner);
188 
189   function approve(address to, uint256 tokenId) public;
190   function getApproved(uint256 tokenId)
191     public view returns (address operator);
192 
193   function setApprovalForAll(address operator, bool _approved) public;
194   function isApprovedForAll(address owner, address operator)
195     public view returns (bool);
196 
197   function transferFrom(address from, address to, uint256 tokenId) public;
198   function safeTransferFrom(address from, address to, uint256 tokenId)
199     public;
200 
201   function safeTransferFrom(
202     address from,
203     address to,
204     uint256 tokenId,
205     bytes data
206   )
207     public;
208 }
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
212  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
213  */
214 contract IERC721Enumerable is IERC721 {
215   function totalSupply() public view returns (uint256);
216   function tokenOfOwnerByIndex(
217     address owner,
218     uint256 index
219   )
220     public
221     view
222     returns (uint256 tokenId);
223 
224   function tokenByIndex(uint256 index) public view returns (uint256);
225   
226 }
227 
228 /**
229  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
230  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
231  */
232 contract IERC721Metadata is IERC721 {
233   function name() external view returns (string);
234   function symbol() external view returns (string);
235   function tokenURI(uint256 tokenId) public view returns (string);
236 }
237 
238 /**
239  * @title ERC721 token receiver interface
240  * @dev Interface for any contract that wants to support safeTransfers
241  * from ERC721 asset contracts.
242  */
243 contract IERC721Receiver {
244   /**
245    * @notice Handle the receipt of an NFT
246    * @dev The ERC721 smart contract calls this function on the recipient
247    * after a `safeTransfer`. This function MUST return the function selector,
248    * otherwise the caller will revert the transaction. The selector to be
249    * returned can be obtained as `this.onERC721Received.selector`. This
250    * function MAY throw to revert and reject the transfer.
251    * Note: the ERC721 contract address is always the message sender.
252    * @param operator The address which called `safeTransferFrom` function
253    * @param from The address which previously owned the token
254    * @param tokenId The NFT identifier which is being transferred
255    * @param data Additional data with no specified format
256    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
257    */
258   function onERC721Received(
259     address operator,
260     address from,
261     uint256 tokenId,
262     bytes data
263   )
264     public
265     returns(bytes4);
266 }
267 
268 /**
269  * @title SafeMath
270  * @dev Math operations with safety checks that revert on error
271  */
272 library SafeMath {
273 
274   /**
275   * @dev Multiplies two numbers, reverts on overflow.
276   */
277   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
279     // benefit is lost if 'b' is also tested.
280     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
281     if (a == 0) {
282       return 0;
283     }
284 
285     uint256 c = a * b;
286     require(c / a == b);
287 
288     return c;
289   }
290 
291   /**
292   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
293   */
294   function div(uint256 a, uint256 b) internal pure returns (uint256) {
295     require(b > 0); // Solidity only automatically asserts when dividing by 0
296     uint256 c = a / b;
297     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298 
299     return c;
300   }
301 
302   /**
303   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
304   */
305   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306     require(b <= a);
307     uint256 c = a - b;
308 
309     return c;
310   }
311 
312   /**
313   * @dev Adds two numbers, reverts on overflow.
314   */
315   function add(uint256 a, uint256 b) internal pure returns (uint256) {
316     uint256 c = a + b;
317     require(c >= a);
318 
319     return c;
320   }
321 
322   /**
323   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
324   * reverts when dividing by zero.
325   */
326   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327     require(b != 0);
328     return a % b;
329   }
330 }
331 
332 /**
333  * Utility library of inline functions on addresses
334  */
335 library Address {
336 
337   /**
338    * Returns whether the target address is a contract
339    * @dev This function will return false if invoked during the constructor of a contract,
340    * as the code is not actually created until after the constructor finishes.
341    * @param account address of the account to check
342    * @return whether the target address is a contract
343    */
344   function isContract(address account) internal view returns (bool) {
345     uint256 size;
346     // XXX Currently there is no better way to check if there is a contract in an address
347     // than to check the size of the code at that address.
348     // See https://ethereum.stackexchange.com/a/14016/36603
349     // for more details about how this works.
350     // TODO Check this again before the Serenity release, because all addresses will be
351     // contracts then.
352     // solium-disable-next-line security/no-inline-assembly
353     assembly { size := extcodesize(account) }
354     return size > 0;
355   }
356 
357 }
358 
359 /**
360  * @title ERC721 Non-Fungible Token Standard basic implementation
361  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
362  */
363 contract ERC721 is ERC165, IERC721 {
364 
365   using SafeMath for uint256;
366   using Address for address;
367 
368   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
369   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
370   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
371 
372   // Mapping from token ID to owner
373   mapping (uint256 => address) private _tokenOwner;
374 
375   // Mapping from token ID to approved address
376   mapping (uint256 => address) private _tokenApprovals;
377 
378   // Mapping from owner to number of owned token
379   mapping (address => uint256) private _ownedTokensCount;
380 
381   // Mapping from owner to operator approvals
382   mapping (address => mapping (address => bool)) private _operatorApprovals;
383 
384   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
385   /*
386    * 0x80ac58cd ===
387    *   bytes4(keccak256('balanceOf(address)')) ^
388    *   bytes4(keccak256('ownerOf(uint256)')) ^
389    *   bytes4(keccak256('approve(address,uint256)')) ^
390    *   bytes4(keccak256('getApproved(uint256)')) ^
391    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
392    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
393    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
394    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
395    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
396    */
397 
398   constructor()
399     public
400   {
401     // register the supported interfaces to conform to ERC721 via ERC165
402     _registerInterface(_InterfaceId_ERC721);
403   }
404 
405   /**
406    * @dev Gets the balance of the specified address
407    * @param owner address to query the balance of
408    * @return uint256 representing the amount owned by the passed address
409    */
410   function balanceOf(address owner) public view returns (uint256) {
411     require(owner != address(0));
412     return _ownedTokensCount[owner];
413   }
414 
415   /**
416    * @dev Gets the owner of the specified token ID
417    * @param tokenId uint256 ID of the token to query the owner of
418    * @return owner address currently marked as the owner of the given token ID
419    */
420   function ownerOf(uint256 tokenId) public view returns (address) {
421     address owner = _tokenOwner[tokenId];
422     require(owner != address(0));
423     return owner;
424   }
425 
426   /**
427    * @dev Approves another address to transfer the given token ID
428    * The zero address indicates there is no approved address.
429    * There can only be one approved address per token at a given time.
430    * Can only be called by the token owner or an approved operator.
431    * @param to address to be approved for the given token ID
432    * @param tokenId uint256 ID of the token to be approved
433    */
434   function approve(address to, uint256 tokenId) public {
435     address owner = ownerOf(tokenId);
436     require(to != owner);
437     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
438 
439     _tokenApprovals[tokenId] = to;
440     emit Approval(owner, to, tokenId);
441   }
442 
443   /**
444    * @dev Gets the approved address for a token ID, or zero if no address set
445    * Reverts if the token ID does not exist.
446    * @param tokenId uint256 ID of the token to query the approval of
447    * @return address currently approved for the given token ID
448    */
449   function getApproved(uint256 tokenId) public view returns (address) {
450     require(_exists(tokenId));
451     return _tokenApprovals[tokenId];
452   }
453 
454   /**
455    * @dev Sets or unsets the approval of a given operator
456    * An operator is allowed to transfer all tokens of the sender on their behalf
457    * @param to operator address to set the approval
458    * @param approved representing the status of the approval to be set
459    */
460   function setApprovalForAll(address to, bool approved) public {
461     require(to != msg.sender);
462     _operatorApprovals[msg.sender][to] = approved;
463     emit ApprovalForAll(msg.sender, to, approved);
464   }
465 
466   /**
467    * @dev Tells whether an operator is approved by a given owner
468    * @param owner owner address which you want to query the approval of
469    * @param operator operator address which you want to query the approval of
470    * @return bool whether the given operator is approved by the given owner
471    */
472   function isApprovedForAll(
473     address owner,
474     address operator
475   )
476     public
477     view
478     returns (bool)
479   {
480     return _operatorApprovals[owner][operator];
481   }
482 
483   /**
484    * @dev Transfers the ownership of a given token ID to another address
485    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
486    * Requires the msg sender to be the owner, approved, or operator
487    * @param from current owner of the token
488    * @param to address to receive the ownership of the given token ID
489    * @param tokenId uint256 ID of the token to be transferred
490   */
491   function transferFrom(
492     address from,
493     address to,
494     uint256 tokenId
495   )
496     public
497   {
498     require(_isApprovedOrOwner(msg.sender, tokenId));
499     require(to != address(0));
500 
501     _clearApproval(from, tokenId);
502     _removeTokenFrom(from, tokenId);
503     _addTokenTo(to, tokenId);
504 
505     emit Transfer(from, to, tokenId);
506   }
507 
508   /**
509    * @dev Safely transfers the ownership of a given token ID to another address
510    * If the target address is a contract, it must implement `onERC721Received`,
511    * which is called upon a safe transfer, and return the magic value
512    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
513    * the transfer is reverted.
514    *
515    * Requires the msg sender to be the owner, approved, or operator
516    * @param from current owner of the token
517    * @param to address to receive the ownership of the given token ID
518    * @param tokenId uint256 ID of the token to be transferred
519   */
520   function safeTransferFrom(
521     address from,
522     address to,
523     uint256 tokenId
524   )
525     public
526   {
527     // solium-disable-next-line arg-overflow
528     safeTransferFrom(from, to, tokenId, "");
529   }
530 
531   /**
532    * @dev Safely transfers the ownership of a given token ID to another address
533    * If the target address is a contract, it must implement `onERC721Received`,
534    * which is called upon a safe transfer, and return the magic value
535    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
536    * the transfer is reverted.
537    * Requires the msg sender to be the owner, approved, or operator
538    * @param from current owner of the token
539    * @param to address to receive the ownership of the given token ID
540    * @param tokenId uint256 ID of the token to be transferred
541    * @param _data bytes data to send along with a safe transfer check
542    */
543   function safeTransferFrom(
544     address from,
545     address to,
546     uint256 tokenId,
547     bytes _data
548   )
549     public
550   {
551     transferFrom(from, to, tokenId);
552     // solium-disable-next-line arg-overflow
553     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
554   }
555 
556   /**
557    * @dev Returns whether the specified token exists
558    * @param tokenId uint256 ID of the token to query the existence of
559    * @return whether the token exists
560    */
561   function _exists(uint256 tokenId) internal view returns (bool) {
562     address owner = _tokenOwner[tokenId];
563     return owner != address(0);
564   }
565 
566   /**
567    * @dev Returns whether the given spender can transfer a given token ID
568    * @param spender address of the spender to query
569    * @param tokenId uint256 ID of the token to be transferred
570    * @return bool whether the msg.sender is approved for the given token ID,
571    *  is an operator of the owner, or is the owner of the token
572    */
573   function _isApprovedOrOwner(
574     address spender,
575     uint256 tokenId
576   )
577     internal
578     view
579     returns (bool)
580   {
581     address owner = ownerOf(tokenId);
582     // Disable solium check because of
583     // https://github.com/duaraghav8/Solium/issues/175
584     // solium-disable-next-line operator-whitespace
585     return (
586       spender == owner ||
587       getApproved(tokenId) == spender ||
588       isApprovedForAll(owner, spender)
589     );
590   }
591 
592   /**
593    * @dev Internal function to mint a new token
594    * Reverts if the given token ID already exists
595    * @param to The address that will own the minted token
596    * @param tokenId uint256 ID of the token to be minted by the msg.sender
597    */
598   function _mint(address to, uint256 tokenId) internal {
599     require(to != address(0));
600     _addTokenTo(to, tokenId);
601     emit Transfer(address(0), to, tokenId);
602   }
603 
604   /**
605    * @dev Internal function to burn a specific token
606    * Reverts if the token does not exist
607    * @param tokenId uint256 ID of the token being burned by the msg.sender
608    */
609   function _burn(address owner, uint256 tokenId) internal {
610     _clearApproval(owner, tokenId);
611     _removeTokenFrom(owner, tokenId);
612     emit Transfer(owner, address(0), tokenId);
613   }
614 
615   /**
616    * @dev Internal function to clear current approval of a given token ID
617    * Reverts if the given address is not indeed the owner of the token
618    * @param owner owner of the token
619    * @param tokenId uint256 ID of the token to be transferred
620    */
621   function _clearApproval(address owner, uint256 tokenId) internal {
622     require(ownerOf(tokenId) == owner);
623     if (_tokenApprovals[tokenId] != address(0)) {
624       _tokenApprovals[tokenId] = address(0);
625     }
626   }
627 
628   /**
629    * @dev Internal function to add a token ID to the list of a given address
630    * @param to address representing the new owner of the given token ID
631    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
632    */
633   function _addTokenTo(address to, uint256 tokenId) internal {
634     require(_tokenOwner[tokenId] == address(0));
635     _tokenOwner[tokenId] = to;
636     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
637   }
638 
639   /**
640    * @dev Internal function to remove a token ID from the list of a given address
641    * @param from address representing the previous owner of the given token ID
642    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
643    */
644   function _removeTokenFrom(address from, uint256 tokenId) internal {
645     require(ownerOf(tokenId) == from);
646     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
647     _tokenOwner[tokenId] = address(0);
648   }
649 
650   /**
651    * @dev Internal function to invoke `onERC721Received` on a target address
652    * The call is not executed if the target address is not a contract
653    * @param from address representing the previous owner of the given token ID
654    * @param to target address that will receive the tokens
655    * @param tokenId uint256 ID of the token to be transferred
656    * @param _data bytes optional data to send along with the call
657    * @return whether the call correctly returned the expected magic value
658    */
659   function _checkAndCallSafeTransfer(
660     address from,
661     address to,
662     uint256 tokenId,
663     bytes _data
664   )
665     internal
666     returns (bool)
667   {
668     if (!to.isContract()) {
669       return true;
670     }
671     bytes4 retval = IERC721Receiver(to).onERC721Received(
672       msg.sender, from, tokenId, _data);
673     return (retval == _ERC721_RECEIVED);
674   }
675 }
676 
677 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
678   // Mapping from owner to list of owned token IDs
679   mapping(address => uint256[]) private _ownedTokens;
680 
681   // Mapping from token ID to index of the owner tokens list
682   mapping(uint256 => uint256) private _ownedTokensIndex;
683 
684   // Array with all token ids, used for enumeration
685   uint256[] private _allTokens;
686 
687   // Mapping from token id to position in the allTokens array
688   mapping(uint256 => uint256) private _allTokensIndex;
689 
690   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
691   /**
692    * 0x780e9d63 ===
693    *   bytes4(keccak256('totalSupply()')) ^
694    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
695    *   bytes4(keccak256('tokenByIndex(uint256)'))
696    */
697 
698   /**
699    * @dev Constructor function
700    */
701   constructor() public {
702     // register the supported interface to conform to ERC721 via ERC165
703     _registerInterface(_InterfaceId_ERC721Enumerable);
704   }
705 
706   /**
707    * @dev Gets the token ID at a given index of the tokens list of the requested owner
708    * @param owner address owning the tokens list to be accessed
709    * @param index uint256 representing the index to be accessed of the requested tokens list
710    * @return uint256 token ID at the given index of the tokens list owned by the requested address
711    */
712   function tokenOfOwnerByIndex(
713     address owner,
714     uint256 index
715   )
716     public
717     view
718     returns (uint256)
719   {
720     require(index < balanceOf(owner));
721     return _ownedTokens[owner][index];
722   }
723 
724   /**
725    * @dev Gets the total amount of tokens stored by the contract
726    * @return uint256 representing the total amount of tokens
727    */
728   function totalSupply() public view returns (uint256) {
729     return _allTokens.length;
730   }
731 
732   /**
733    * @dev Gets the token ID at a given index of all the tokens in this contract
734    * Reverts if the index is greater or equal to the total number of tokens
735    * @param index uint256 representing the index to be accessed of the tokens list
736    * @return uint256 token ID at the given index of the tokens list
737    */
738   function tokenByIndex(uint256 index) public view returns (uint256) {
739     require(index < totalSupply());
740     return _allTokens[index];
741   }
742 
743   /**
744    * @dev Internal function to add a token ID to the list of a given address
745    * @param to address representing the new owner of the given token ID
746    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
747    */
748   function _addTokenTo(address to, uint256 tokenId) internal {
749     super._addTokenTo(to, tokenId);
750     uint256 length = _ownedTokens[to].length;
751     _ownedTokens[to].push(tokenId);
752     _ownedTokensIndex[tokenId] = length;
753   }
754 
755   /**
756    * @dev Internal function to remove a token ID from the list of a given address
757    * @param from address representing the previous owner of the given token ID
758    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
759    */
760   function _removeTokenFrom(address from, uint256 tokenId) internal {
761     super._removeTokenFrom(from, tokenId);
762 
763     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
764     // then delete the last slot.
765     uint256 tokenIndex = _ownedTokensIndex[tokenId];
766     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
767     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
768 
769     _ownedTokens[from][tokenIndex] = lastToken;
770     // This also deletes the contents at the last position of the array
771     _ownedTokens[from].length--;
772 
773     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
774     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
775     // the lastToken to the first position, and then dropping the element placed in the last position of the list
776 
777     _ownedTokensIndex[tokenId] = 0;
778     _ownedTokensIndex[lastToken] = tokenIndex;
779   }
780 
781   /**
782    * @dev Internal function to mint a new token
783    * Reverts if the given token ID already exists
784    * @param to address the beneficiary that will own the minted token
785    * @param tokenId uint256 ID of the token to be minted by the msg.sender
786    */
787   function _mint(address to, uint256 tokenId) internal {
788     super._mint(to, tokenId);
789 
790     _allTokensIndex[tokenId] = _allTokens.length;
791     _allTokens.push(tokenId);
792   }
793 
794   /**
795    * @dev Internal function to burn a specific token
796    * Reverts if the token does not exist
797    * @param owner owner of the token to burn
798    * @param tokenId uint256 ID of the token being burned by the msg.sender
799    */
800   function _burn(address owner, uint256 tokenId) internal {
801     super._burn(owner, tokenId);
802 
803     // Reorg all tokens array
804     uint256 tokenIndex = _allTokensIndex[tokenId];
805     uint256 lastTokenIndex = _allTokens.length.sub(1);
806     uint256 lastToken = _allTokens[lastTokenIndex];
807 
808     _allTokens[tokenIndex] = lastToken;
809     _allTokens[lastTokenIndex] = 0;
810 
811     _allTokens.length--;
812     _allTokensIndex[tokenId] = 0;
813     _allTokensIndex[lastToken] = tokenIndex;
814   }
815 }
816 
817 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
818   // Token name
819   string internal _name;
820 
821   // Token symbol
822   string internal _symbol;
823 
824   // Optional mapping for token URIs
825   mapping(uint256 => string) private _tokenURIs;
826 
827   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
828   /**
829    * 0x5b5e139f ===
830    *   bytes4(keccak256('name()')) ^
831    *   bytes4(keccak256('symbol()')) ^
832    *   bytes4(keccak256('tokenURI(uint256)'))
833    */
834 
835   /**
836    * @dev Constructor function
837    */
838   constructor(string name, string symbol) public {
839     _name = name;
840     _symbol = symbol;
841 
842     // register the supported interfaces to conform to ERC721 via ERC165
843     _registerInterface(InterfaceId_ERC721Metadata);
844   }
845 
846   /**
847    * @dev Gets the token name
848    * @return string representing the token name
849    */
850   function name() external view returns (string) {
851     return _name;
852   }
853 
854   /**
855    * @dev Gets the token symbol
856    * @return string representing the token symbol
857    */
858   function symbol() external view returns (string) {
859     return _symbol;
860   }
861 
862   /**
863    * @dev Returns an URI for a given token ID
864    * Throws if the token ID does not exist. May return an empty string.
865    * @param tokenId uint256 ID of the token to query
866    */
867   function tokenURI(uint256 tokenId) public view returns (string) {
868     require(_exists(tokenId));
869     return _tokenURIs[tokenId];
870   }
871 
872   /**
873    * @dev Internal function to set the token URI for a given token
874    * Reverts if the token ID does not exist
875    * @param tokenId uint256 ID of the token to set its URI
876    * @param uri string URI to assign
877    */
878   function _setTokenURI(uint256 tokenId, string uri) internal {
879     require(_exists(tokenId));
880     _tokenURIs[tokenId] = uri;
881   }
882 
883   /**
884    * @dev Internal function to burn a specific token
885    * Reverts if the token does not exist
886    * @param owner owner of the token to burn
887    * @param tokenId uint256 ID of the token being burned by the msg.sender
888    */
889   function _burn(address owner, uint256 tokenId) internal {
890     super._burn(owner, tokenId);
891 
892     // Clear metadata (if any)
893     if (bytes(_tokenURIs[tokenId]).length != 0) {
894       delete _tokenURIs[tokenId];
895     }
896   }
897 }
898 
899 /**
900  * @title Full ERC721 Token
901  * This implementation includes all the required and some optional functionality of the ERC721 standard
902  * Moreover, it includes approve all functionality using operator terminology
903  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
904  */
905 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
906   constructor(string name, string symbol) ERC721Metadata(name, symbol)
907     public
908   {
909   }
910 }
911 
912 
913 /*
914  * @title String & slice utility library for Solidity contracts.
915  * @author Nick Johnson <arachnid@notdot.net>
916  *
917  * @dev Functionality in this library is largely implemented using an
918  *      abstraction called a 'slice'. A slice represents a part of a string -
919  *      anything from the entire string to a single character, or even no
920  *      characters at all (a 0-length slice). Since a slice only has to specify
921  *      an offset and a length, copying and manipulating slices is a lot less
922  *      expensive than copying and manipulating the strings they reference.
923  *
924  *      To further reduce gas costs, most functions on slice that need to return
925  *      a slice modify the original one instead of allocating a new one; for
926  *      instance, `s.split(".")` will return the text up to the first '.',
927  *      modifying s to only contain the remainder of the string after the '.'.
928  *      In situations where you do not want to modify the original slice, you
929  *      can make a copy first with `.copy()`, for example:
930  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
931  *      Solidity has no memory management, it will result in allocating many
932  *      short-lived slices that are later discarded.
933  *
934  *      Functions that return two slices come in two versions: a non-allocating
935  *      version that takes the second slice as an argument, modifying it in
936  *      place, and an allocating version that allocates and returns the second
937  *      slice; see `nextRune` for example.
938  *
939  *      Functions that have to copy string data will return strings rather than
940  *      slices; these can be cast back to slices for further processing if
941  *      required.
942  *
943  *      For convenience, some functions are provided with non-modifying
944  *      variants that create a new slice and return both; for instance,
945  *      `s.splitNew('.')` leaves s unmodified, and returns two values
946  *      corresponding to the left and right parts of the string.
947  */
948 
949 library strings {
950     struct slice {
951         uint _len;
952         uint _ptr;
953     }
954 
955     function memcpy(uint dest, uint src, uint len) private pure {
956         // Copy word-length chunks while possible
957         for(; len >= 32; len -= 32) {
958             assembly {
959                 mstore(dest, mload(src))
960             }
961             dest += 32;
962             src += 32;
963         }
964 
965         // Copy remaining bytes
966         uint mask = 256 ** (32 - len) - 1;
967         assembly {
968             let srcpart := and(mload(src), not(mask))
969             let destpart := and(mload(dest), mask)
970             mstore(dest, or(destpart, srcpart))
971         }
972     }
973 
974     /*
975      * @dev Returns a slice containing the entire string.
976      * @param self The string to make a slice from.
977      * @return A newly allocated slice containing the entire string.
978      */
979     function toSlice(string memory self) internal pure returns (slice memory) {
980         uint ptr;
981         assembly {
982             ptr := add(self, 0x20)
983         }
984         return slice(bytes(self).length, ptr);
985     }
986 
987     /*
988      * @dev Returns the length of a null-terminated bytes32 string.
989      * @param self The value to find the length of.
990      * @return The length of the string, from 0 to 32.
991      */
992     function len(bytes32 self) internal pure returns (uint) {
993         uint ret;
994         if (self == 0)
995             return 0;
996         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
997             ret += 16;
998             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
999         }
1000         if (self & 0xffffffffffffffff == 0) {
1001             ret += 8;
1002             self = bytes32(uint(self) / 0x10000000000000000);
1003         }
1004         if (self & 0xffffffff == 0) {
1005             ret += 4;
1006             self = bytes32(uint(self) / 0x100000000);
1007         }
1008         if (self & 0xffff == 0) {
1009             ret += 2;
1010             self = bytes32(uint(self) / 0x10000);
1011         }
1012         if (self & 0xff == 0) {
1013             ret += 1;
1014         }
1015         return 32 - ret;
1016     }
1017 
1018     /*
1019      * @dev Returns a slice containing the entire bytes32, interpreted as a
1020      *      null-terminated utf-8 string.
1021      * @param self The bytes32 value to convert to a slice.
1022      * @return A new slice containing the value of the input argument up to the
1023      *         first null.
1024      */
1025     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1026         // Allocate space for `self` in memory, copy it there, and point ret at it
1027         assembly {
1028             let ptr := mload(0x40)
1029             mstore(0x40, add(ptr, 0x20))
1030             mstore(ptr, self)
1031             mstore(add(ret, 0x20), ptr)
1032         }
1033         ret._len = len(self);
1034     }
1035 
1036     /*
1037      * @dev Returns a new slice containing the same data as the current slice.
1038      * @param self The slice to copy.
1039      * @return A new slice containing the same data as `self`.
1040      */
1041     function copy(slice memory self) internal pure returns (slice memory) {
1042         return slice(self._len, self._ptr);
1043     }
1044 
1045     /*
1046      * @dev Copies a slice to a new string.
1047      * @param self The slice to copy.
1048      * @return A newly allocated string containing the slice's text.
1049      */
1050     function toString(slice memory self) internal pure returns (string memory) {
1051         string memory ret = new string(self._len);
1052         uint retptr;
1053         assembly { retptr := add(ret, 32) }
1054 
1055         memcpy(retptr, self._ptr, self._len);
1056         return ret;
1057     }
1058 
1059     /*
1060      * @dev Returns the length in runes of the slice. Note that this operation
1061      *      takes time proportional to the length of the slice; avoid using it
1062      *      in loops, and call `slice.empty()` if you only need to know whether
1063      *      the slice is empty or not.
1064      * @param self The slice to operate on.
1065      * @return The length of the slice in runes.
1066      */
1067     function len(slice memory self) internal pure returns (uint l) {
1068         // Starting at ptr-31 means the LSB will be the byte we care about
1069         uint ptr = self._ptr - 31;
1070         uint end = ptr + self._len;
1071         for (l = 0; ptr < end; l++) {
1072             uint8 b;
1073             assembly { b := and(mload(ptr), 0xFF) }
1074             if (b < 0x80) {
1075                 ptr += 1;
1076             } else if(b < 0xE0) {
1077                 ptr += 2;
1078             } else if(b < 0xF0) {
1079                 ptr += 3;
1080             } else if(b < 0xF8) {
1081                 ptr += 4;
1082             } else if(b < 0xFC) {
1083                 ptr += 5;
1084             } else {
1085                 ptr += 6;
1086             }
1087         }
1088     }
1089 
1090     /*
1091      * @dev Returns true if the slice is empty (has a length of 0).
1092      * @param self The slice to operate on.
1093      * @return True if the slice is empty, False otherwise.
1094      */
1095     function empty(slice memory self) internal pure returns (bool) {
1096         return self._len == 0;
1097     }
1098 
1099     /*
1100      * @dev Returns a positive number if `other` comes lexicographically after
1101      *      `self`, a negative number if it comes before, or zero if the
1102      *      contents of the two slices are equal. Comparison is done per-rune,
1103      *      on unicode codepoints.
1104      * @param self The first slice to compare.
1105      * @param other The second slice to compare.
1106      * @return The result of the comparison.
1107      */
1108     function compare(slice memory self, slice memory other) internal pure returns (int) {
1109         uint shortest = self._len;
1110         if (other._len < self._len)
1111             shortest = other._len;
1112 
1113         uint selfptr = self._ptr;
1114         uint otherptr = other._ptr;
1115         for (uint idx = 0; idx < shortest; idx += 32) {
1116             uint a;
1117             uint b;
1118             assembly {
1119                 a := mload(selfptr)
1120                 b := mload(otherptr)
1121             }
1122             if (a != b) {
1123                 // Mask out irrelevant bytes and check again
1124                 uint256 mask = uint256(-1); // 0xffff...
1125                 if(shortest < 32) {
1126                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1127                 }
1128                 uint256 diff = (a & mask) - (b & mask);
1129                 if (diff != 0)
1130                     return int(diff);
1131             }
1132             selfptr += 32;
1133             otherptr += 32;
1134         }
1135         return int(self._len) - int(other._len);
1136     }
1137 
1138     /*
1139      * @dev Returns true if the two slices contain the same text.
1140      * @param self The first slice to compare.
1141      * @param self The second slice to compare.
1142      * @return True if the slices are equal, false otherwise.
1143      */
1144     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1145         return compare(self, other) == 0;
1146     }
1147 
1148     /*
1149      * @dev Extracts the first rune in the slice into `rune`, advancing the
1150      *      slice to point to the next rune and returning `self`.
1151      * @param self The slice to operate on.
1152      * @param rune The slice that will contain the first rune.
1153      * @return `rune`.
1154      */
1155     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1156         rune._ptr = self._ptr;
1157 
1158         if (self._len == 0) {
1159             rune._len = 0;
1160             return rune;
1161         }
1162 
1163         uint l;
1164         uint b;
1165         // Load the first byte of the rune into the LSBs of b
1166         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1167         if (b < 0x80) {
1168             l = 1;
1169         } else if(b < 0xE0) {
1170             l = 2;
1171         } else if(b < 0xF0) {
1172             l = 3;
1173         } else {
1174             l = 4;
1175         }
1176 
1177         // Check for truncated codepoints
1178         if (l > self._len) {
1179             rune._len = self._len;
1180             self._ptr += self._len;
1181             self._len = 0;
1182             return rune;
1183         }
1184 
1185         self._ptr += l;
1186         self._len -= l;
1187         rune._len = l;
1188         return rune;
1189     }
1190 
1191     /*
1192      * @dev Returns the first rune in the slice, advancing the slice to point
1193      *      to the next rune.
1194      * @param self The slice to operate on.
1195      * @return A slice containing only the first rune from `self`.
1196      */
1197     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1198         nextRune(self, ret);
1199     }
1200 
1201     /*
1202      * @dev Returns the number of the first codepoint in the slice.
1203      * @param self The slice to operate on.
1204      * @return The number of the first codepoint in the slice.
1205      */
1206     function ord(slice memory self) internal pure returns (uint ret) {
1207         if (self._len == 0) {
1208             return 0;
1209         }
1210 
1211         uint word;
1212         uint length;
1213         uint divisor = 2 ** 248;
1214 
1215         // Load the rune into the MSBs of b
1216         assembly { word:= mload(mload(add(self, 32))) }
1217         uint b = word / divisor;
1218         if (b < 0x80) {
1219             ret = b;
1220             length = 1;
1221         } else if(b < 0xE0) {
1222             ret = b & 0x1F;
1223             length = 2;
1224         } else if(b < 0xF0) {
1225             ret = b & 0x0F;
1226             length = 3;
1227         } else {
1228             ret = b & 0x07;
1229             length = 4;
1230         }
1231 
1232         // Check for truncated codepoints
1233         if (length > self._len) {
1234             return 0;
1235         }
1236 
1237         for (uint i = 1; i < length; i++) {
1238             divisor = divisor / 256;
1239             b = (word / divisor) & 0xFF;
1240             if (b & 0xC0 != 0x80) {
1241                 // Invalid UTF-8 sequence
1242                 return 0;
1243             }
1244             ret = (ret * 64) | (b & 0x3F);
1245         }
1246 
1247         return ret;
1248     }
1249 
1250     /*
1251      * @dev Returns the keccak-256 hash of the slice.
1252      * @param self The slice to hash.
1253      * @return The hash of the slice.
1254      */
1255     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1256         assembly {
1257             ret := keccak256(mload(add(self, 32)), mload(self))
1258         }
1259     }
1260 
1261     /*
1262      * @dev Returns true if `self` starts with `needle`.
1263      * @param self The slice to operate on.
1264      * @param needle The slice to search for.
1265      * @return True if the slice starts with the provided text, false otherwise.
1266      */
1267     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1268         if (self._len < needle._len) {
1269             return false;
1270         }
1271 
1272         if (self._ptr == needle._ptr) {
1273             return true;
1274         }
1275 
1276         bool equal;
1277         assembly {
1278             let length := mload(needle)
1279             let selfptr := mload(add(self, 0x20))
1280             let needleptr := mload(add(needle, 0x20))
1281             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1282         }
1283         return equal;
1284     }
1285 
1286     /*
1287      * @dev If `self` starts with `needle`, `needle` is removed from the
1288      *      beginning of `self`. Otherwise, `self` is unmodified.
1289      * @param self The slice to operate on.
1290      * @param needle The slice to search for.
1291      * @return `self`
1292      */
1293     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1294         if (self._len < needle._len) {
1295             return self;
1296         }
1297 
1298         bool equal = true;
1299         if (self._ptr != needle._ptr) {
1300             assembly {
1301                 let length := mload(needle)
1302                 let selfptr := mload(add(self, 0x20))
1303                 let needleptr := mload(add(needle, 0x20))
1304                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1305             }
1306         }
1307 
1308         if (equal) {
1309             self._len -= needle._len;
1310             self._ptr += needle._len;
1311         }
1312 
1313         return self;
1314     }
1315 
1316     /*
1317      * @dev Returns true if the slice ends with `needle`.
1318      * @param self The slice to operate on.
1319      * @param needle The slice to search for.
1320      * @return True if the slice starts with the provided text, false otherwise.
1321      */
1322     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1323         if (self._len < needle._len) {
1324             return false;
1325         }
1326 
1327         uint selfptr = self._ptr + self._len - needle._len;
1328 
1329         if (selfptr == needle._ptr) {
1330             return true;
1331         }
1332 
1333         bool equal;
1334         assembly {
1335             let length := mload(needle)
1336             let needleptr := mload(add(needle, 0x20))
1337             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1338         }
1339 
1340         return equal;
1341     }
1342 
1343     /*
1344      * @dev If `self` ends with `needle`, `needle` is removed from the
1345      *      end of `self`. Otherwise, `self` is unmodified.
1346      * @param self The slice to operate on.
1347      * @param needle The slice to search for.
1348      * @return `self`
1349      */
1350     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1351         if (self._len < needle._len) {
1352             return self;
1353         }
1354 
1355         uint selfptr = self._ptr + self._len - needle._len;
1356         bool equal = true;
1357         if (selfptr != needle._ptr) {
1358             assembly {
1359                 let length := mload(needle)
1360                 let needleptr := mload(add(needle, 0x20))
1361                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1362             }
1363         }
1364 
1365         if (equal) {
1366             self._len -= needle._len;
1367         }
1368 
1369         return self;
1370     }
1371 
1372     // Returns the memory address of the first byte of the first occurrence of
1373     // `needle` in `self`, or the first byte after `self` if not found.
1374     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1375         uint ptr = selfptr;
1376         uint idx;
1377 
1378         if (needlelen <= selflen) {
1379             if (needlelen <= 32) {
1380                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1381 
1382                 bytes32 needledata;
1383                 assembly { needledata := and(mload(needleptr), mask) }
1384 
1385                 uint end = selfptr + selflen - needlelen;
1386                 bytes32 ptrdata;
1387                 assembly { ptrdata := and(mload(ptr), mask) }
1388 
1389                 while (ptrdata != needledata) {
1390                     if (ptr >= end)
1391                         return selfptr + selflen;
1392                     ptr++;
1393                     assembly { ptrdata := and(mload(ptr), mask) }
1394                 }
1395                 return ptr;
1396             } else {
1397                 // For long needles, use hashing
1398                 bytes32 hash;
1399                 assembly { hash := keccak256(needleptr, needlelen) }
1400 
1401                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1402                     bytes32 testHash;
1403                     assembly { testHash := keccak256(ptr, needlelen) }
1404                     if (hash == testHash)
1405                         return ptr;
1406                     ptr += 1;
1407                 }
1408             }
1409         }
1410         return selfptr + selflen;
1411     }
1412 
1413     // Returns the memory address of the first byte after the last occurrence of
1414     // `needle` in `self`, or the address of `self` if not found.
1415     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1416         uint ptr;
1417 
1418         if (needlelen <= selflen) {
1419             if (needlelen <= 32) {
1420                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1421 
1422                 bytes32 needledata;
1423                 assembly { needledata := and(mload(needleptr), mask) }
1424 
1425                 ptr = selfptr + selflen - needlelen;
1426                 bytes32 ptrdata;
1427                 assembly { ptrdata := and(mload(ptr), mask) }
1428 
1429                 while (ptrdata != needledata) {
1430                     if (ptr <= selfptr)
1431                         return selfptr;
1432                     ptr--;
1433                     assembly { ptrdata := and(mload(ptr), mask) }
1434                 }
1435                 return ptr + needlelen;
1436             } else {
1437                 // For long needles, use hashing
1438                 bytes32 hash;
1439                 assembly { hash := keccak256(needleptr, needlelen) }
1440                 ptr = selfptr + (selflen - needlelen);
1441                 while (ptr >= selfptr) {
1442                     bytes32 testHash;
1443                     assembly { testHash := keccak256(ptr, needlelen) }
1444                     if (hash == testHash)
1445                         return ptr + needlelen;
1446                     ptr -= 1;
1447                 }
1448             }
1449         }
1450         return selfptr;
1451     }
1452 
1453     /*
1454      * @dev Modifies `self` to contain everything from the first occurrence of
1455      *      `needle` to the end of the slice. `self` is set to the empty slice
1456      *      if `needle` is not found.
1457      * @param self The slice to search and modify.
1458      * @param needle The text to search for.
1459      * @return `self`.
1460      */
1461     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1462         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1463         self._len -= ptr - self._ptr;
1464         self._ptr = ptr;
1465         return self;
1466     }
1467 
1468     /*
1469      * @dev Modifies `self` to contain the part of the string from the start of
1470      *      `self` to the end of the first occurrence of `needle`. If `needle`
1471      *      is not found, `self` is set to the empty slice.
1472      * @param self The slice to search and modify.
1473      * @param needle The text to search for.
1474      * @return `self`.
1475      */
1476     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1477         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1478         self._len = ptr - self._ptr;
1479         return self;
1480     }
1481 
1482     /*
1483      * @dev Splits the slice, setting `self` to everything after the first
1484      *      occurrence of `needle`, and `token` to everything before it. If
1485      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1486      *      and `token` is set to the entirety of `self`.
1487      * @param self The slice to split.
1488      * @param needle The text to search for in `self`.
1489      * @param token An output parameter to which the first token is written.
1490      * @return `token`.
1491      */
1492     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1493         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1494         token._ptr = self._ptr;
1495         token._len = ptr - self._ptr;
1496         if (ptr == self._ptr + self._len) {
1497             // Not found
1498             self._len = 0;
1499         } else {
1500             self._len -= token._len + needle._len;
1501             self._ptr = ptr + needle._len;
1502         }
1503         return token;
1504     }
1505 
1506     /*
1507      * @dev Splits the slice, setting `self` to everything after the first
1508      *      occurrence of `needle`, and returning everything before it. If
1509      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1510      *      and the entirety of `self` is returned.
1511      * @param self The slice to split.
1512      * @param needle The text to search for in `self`.
1513      * @return The part of `self` up to the first occurrence of `delim`.
1514      */
1515     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1516         split(self, needle, token);
1517     }
1518 
1519     /*
1520      * @dev Splits the slice, setting `self` to everything before the last
1521      *      occurrence of `needle`, and `token` to everything after it. If
1522      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1523      *      and `token` is set to the entirety of `self`.
1524      * @param self The slice to split.
1525      * @param needle The text to search for in `self`.
1526      * @param token An output parameter to which the first token is written.
1527      * @return `token`.
1528      */
1529     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1530         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1531         token._ptr = ptr;
1532         token._len = self._len - (ptr - self._ptr);
1533         if (ptr == self._ptr) {
1534             // Not found
1535             self._len = 0;
1536         } else {
1537             self._len -= token._len + needle._len;
1538         }
1539         return token;
1540     }
1541 
1542     /*
1543      * @dev Splits the slice, setting `self` to everything before the last
1544      *      occurrence of `needle`, and returning everything after it. If
1545      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1546      *      and the entirety of `self` is returned.
1547      * @param self The slice to split.
1548      * @param needle The text to search for in `self`.
1549      * @return The part of `self` after the last occurrence of `delim`.
1550      */
1551     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1552         rsplit(self, needle, token);
1553     }
1554 
1555     /*
1556      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1557      * @param self The slice to search.
1558      * @param needle The text to search for in `self`.
1559      * @return The number of occurrences of `needle` found in `self`.
1560      */
1561     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1562         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1563         while (ptr <= self._ptr + self._len) {
1564             cnt++;
1565             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1566         }
1567     }
1568 
1569     /*
1570      * @dev Returns True if `self` contains `needle`.
1571      * @param self The slice to search.
1572      * @param needle The text to search for in `self`.
1573      * @return True if `needle` is found in `self`, false otherwise.
1574      */
1575     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1576         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1577     }
1578 
1579     /*
1580      * @dev Returns a newly allocated string containing the concatenation of
1581      *      `self` and `other`.
1582      * @param self The first slice to concatenate.
1583      * @param other The second slice to concatenate.
1584      * @return The concatenation of the two strings.
1585      */
1586     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1587         string memory ret = new string(self._len + other._len);
1588         uint retptr;
1589         assembly { retptr := add(ret, 32) }
1590         memcpy(retptr, self._ptr, self._len);
1591         memcpy(retptr + self._len, other._ptr, other._len);
1592         return ret;
1593     }
1594 
1595     /*
1596      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1597      *      newly allocated string.
1598      * @param self The delimiter to use.
1599      * @param parts A list of slices to join.
1600      * @return A newly allocated string containing all the slices in `parts`,
1601      *         joined with `self`.
1602      */
1603     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1604         if (parts.length == 0)
1605             return "";
1606 
1607         uint length = self._len * (parts.length - 1);
1608         for(uint i = 0; i < parts.length; i++)
1609             length += parts[i]._len;
1610 
1611         string memory ret = new string(length);
1612         uint retptr;
1613         assembly { retptr := add(ret, 32) }
1614 
1615         for(i = 0; i < parts.length; i++) {
1616             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1617             retptr += parts[i]._len;
1618             if (i < parts.length - 1) {
1619                 memcpy(retptr, self._ptr, self._len);
1620                 retptr += self._len;
1621             }
1622         }
1623 
1624         return ret;
1625     }
1626 }
1627 
1628 contract CarFactory is Ownable {
1629     using strings for *;
1630 
1631     uint256 public constant MAX_CARS = 30000 + 150000 + 1000000;
1632     uint256 public mintedCars = 0;
1633     address preOrderAddress;
1634     CarToken token;
1635 
1636     mapping(uint256 => uint256) public tankSizes;
1637     mapping(uint256 => uint) public savedTypes;
1638     mapping(uint256 => bool) public giveawayCar;
1639     
1640     mapping(uint => uint256[]) public availableIds;
1641     mapping(uint => uint256) public idCursor;
1642 
1643     event CarMinted(uint256 _tokenId, string _metadata, uint cType);
1644     event CarSellingBeings();
1645 
1646 
1647 
1648     modifier onlyPreOrder {
1649         require(msg.sender == preOrderAddress, "Not authorized");
1650         _;
1651     }
1652 
1653     modifier isInitialized {
1654         require(preOrderAddress != address(0), "No linked preorder");
1655         require(address(token) != address(0), "No linked token");
1656         _;
1657     }
1658 
1659     function uintToString(uint v) internal pure returns (string) {
1660         uint maxlength = 100;
1661         bytes memory reversed = new bytes(maxlength);
1662         uint i = 0;
1663         while (v != 0) {
1664             uint remainder = v % 10;
1665             v = v / 10;
1666             reversed[i++] = byte(48 + remainder);
1667         }
1668         bytes memory s = new bytes(i); // i + 1 is inefficient
1669         for (uint j = 0; j < i; j++) {
1670             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
1671         }
1672         string memory str = string(s);  // memory isn't implicitly convertible to storage
1673         return str; // this was missing
1674     }
1675 
1676     function mintFor(uint cType, address newOwner) public onlyPreOrder isInitialized returns (uint256) {
1677         require(mintedCars < MAX_CARS, "Factory has minted the max number of cars");
1678         
1679         uint256 _tokenId = nextAvailableId(cType);
1680         require(!token.exists(_tokenId), "Token already exists");
1681 
1682         string memory id = uintToString(_tokenId).toSlice().concat(".json".toSlice());
1683 
1684         uint256 tankSize = tankSizes[_tokenId];
1685         string memory _metadata = "https://vault.warriders.com/".toSlice().concat(id.toSlice());
1686 
1687         token.mint(_tokenId, _metadata, cType, tankSize, newOwner);
1688         mintedCars++;
1689         
1690         return _tokenId;
1691     }
1692 
1693     function giveaway(uint256 _tokenId, uint256 _tankSize, uint cType, bool markCar, address dst) public onlyOwner isInitialized {
1694         require(dst != address(0), "No destination address given");
1695         require(!token.exists(_tokenId), "Token already exists");
1696         require(dst != owner());
1697         require(dst != address(this));
1698         require(_tankSize <= token.maxTankSizes(cType));
1699             
1700         tankSizes[_tokenId] = _tankSize;
1701         savedTypes[_tokenId] = cType;
1702 
1703         string memory id = uintToString(_tokenId).toSlice().concat(".json".toSlice());
1704         string memory _metadata = "https://vault.warriders.com/".toSlice().concat(id.toSlice());
1705 
1706         token.mint(_tokenId, _metadata, cType, _tankSize, dst);
1707         mintedCars++;
1708 
1709         giveawayCar[_tokenId] = markCar;
1710     }
1711 
1712     function setTokenMeta(uint256[] _tokenIds, uint256[] ts, uint[] cTypes) public onlyOwner isInitialized {
1713         for (uint i = 0; i < _tokenIds.length; i++) {
1714             uint256 _tokenId = _tokenIds[i];
1715             uint cType = cTypes[i];
1716             uint256 _tankSize = ts[i];
1717 
1718             require(_tankSize <= token.maxTankSizes(cType));
1719             
1720             tankSizes[_tokenId] = _tankSize;
1721             savedTypes[_tokenId] = cType;
1722             
1723             
1724             availableIds[cTypes[i]].push(_tokenId);
1725         }
1726     }
1727     
1728     function nextAvailableId(uint cType) private returns (uint256) {
1729         uint256 currentCursor = idCursor[cType];
1730         
1731         require(currentCursor < availableIds[cType].length);
1732         
1733         uint256 nextId = availableIds[cType][currentCursor];
1734         idCursor[cType] = currentCursor + 1;
1735         return nextId;
1736     }
1737 
1738     /**
1739     Attach the preOrder that will be receiving tokens being marked for sale by the
1740     sellCar function
1741     */
1742     function attachPreOrder(address dst) public onlyOwner {
1743         require(preOrderAddress == address(0));
1744         require(dst != address(0));
1745 
1746         //Enforce that address is indeed a preorder
1747         PreOrder preOrder = PreOrder(dst);
1748 
1749         preOrderAddress = address(preOrder);
1750     }
1751 
1752     /**
1753     Attach the token being used for things
1754     */
1755     function attachToken(address dst) public onlyOwner {
1756         require(address(token) == address(0));
1757         require(dst != address(0));
1758 
1759         //Enforce that address is indeed a preorder
1760         CarToken ct = CarToken(dst);
1761 
1762         token = ct;
1763     }
1764 }
1765 
1766 contract CarToken is ERC721Full, Ownable {
1767     using strings for *;
1768     
1769     address factory;
1770 
1771     /*
1772     * Car Types:
1773     * 0 - Unknown
1774     * 1 - SUV
1775     * 2 - Truck
1776     * 3 - Hovercraft
1777     * 4 - Tank
1778     * 5 - Lambo
1779     * 6 - Buggy
1780     * 7 - midgrade type 2
1781     * 8 - midgrade type 3
1782     * 9 - Hatchback
1783     * 10 - regular type 2
1784     * 11 - regular type 3
1785     */
1786     uint public constant UNKNOWN_TYPE = 0;
1787     uint public constant SUV_TYPE = 1;
1788     uint public constant TANKER_TYPE = 2;
1789     uint public constant HOVERCRAFT_TYPE = 3;
1790     uint public constant TANK_TYPE = 4;
1791     uint public constant LAMBO_TYPE = 5;
1792     uint public constant DUNE_BUGGY = 6;
1793     uint public constant MIDGRADE_TYPE2 = 7;
1794     uint public constant MIDGRADE_TYPE3 = 8;
1795     uint public constant HATCHBACK = 9;
1796     uint public constant REGULAR_TYPE2 = 10;
1797     uint public constant REGULAR_TYPE3 = 11;
1798     
1799     string public constant METADATA_URL = "https://vault.warriders.com/";
1800     
1801     //Number of premium type cars
1802     uint public PREMIUM_TYPE_COUNT = 5;
1803     //Number of midgrade type cars
1804     uint public MIDGRADE_TYPE_COUNT = 3;
1805     //Number of regular type cars
1806     uint public REGULAR_TYPE_COUNT = 3;
1807 
1808     mapping(uint256 => uint256) public maxBznTankSizeOfPremiumCarWithIndex;
1809     mapping(uint256 => uint256) public maxBznTankSizeOfMidGradeCarWithIndex;
1810     mapping(uint256 => uint256) public maxBznTankSizeOfRegularCarWithIndex;
1811 
1812     /**
1813      * Whether any given car (tokenId) is special
1814      */
1815     mapping(uint256 => bool) public isSpecial;
1816     /**
1817      * The type of any given car (tokenId)
1818      */
1819     mapping(uint256 => uint) public carType;
1820     /**
1821      * The total supply for any given type (int)
1822      */
1823     mapping(uint => uint256) public carTypeTotalSupply;
1824     /**
1825      * The current supply for any given type (int)
1826      */
1827     mapping(uint => uint256) public carTypeSupply;
1828     /**
1829      * Whether any given type (int) is special
1830      */
1831     mapping(uint => bool) public isTypeSpecial;
1832 
1833     /**
1834     * How much BZN any given car (tokenId) can hold
1835     */
1836     mapping(uint256 => uint256) public tankSizes;
1837     
1838     /**
1839      * Given any car type (uint), get the max tank size for that type (uint256)
1840      */
1841     mapping(uint => uint256) public maxTankSizes;
1842     
1843     mapping (uint => uint[]) public premiumTotalSupplyForCar;
1844     mapping (uint => uint[]) public midGradeTotalSupplyForCar;
1845     mapping (uint => uint[]) public regularTotalSupplyForCar;
1846 
1847     modifier onlyFactory {
1848         require(msg.sender == factory, "Not authorized");
1849         _;
1850     }
1851 
1852     constructor(address factoryAddress) public ERC721Full("WarRiders", "WR") {
1853         factory = factoryAddress;
1854 
1855         carTypeTotalSupply[UNKNOWN_TYPE] = 0; //Unknown
1856         carTypeTotalSupply[SUV_TYPE] = 20000; //SUV
1857         carTypeTotalSupply[TANKER_TYPE] = 9000; //Tanker
1858         carTypeTotalSupply[HOVERCRAFT_TYPE] = 600; //Hovercraft
1859         carTypeTotalSupply[TANK_TYPE] = 300; //Tank
1860         carTypeTotalSupply[LAMBO_TYPE] = 100; //Lambo
1861         carTypeTotalSupply[DUNE_BUGGY] = 40000; //migrade type 1
1862         carTypeTotalSupply[MIDGRADE_TYPE2] = 50000; //midgrade type 2
1863         carTypeTotalSupply[MIDGRADE_TYPE3] = 60000; //midgrade type 3
1864         carTypeTotalSupply[HATCHBACK] = 200000; //regular type 1
1865         carTypeTotalSupply[REGULAR_TYPE2] = 300000; //regular type 2
1866         carTypeTotalSupply[REGULAR_TYPE3] = 500000; //regular type 3
1867         
1868         maxTankSizes[SUV_TYPE] = 200; //SUV tank size
1869         maxTankSizes[TANKER_TYPE] = 450; //Tanker tank size
1870         maxTankSizes[HOVERCRAFT_TYPE] = 300; //Hovercraft tank size
1871         maxTankSizes[TANK_TYPE] = 200; //Tank tank size
1872         maxTankSizes[LAMBO_TYPE] = 250; //Lambo tank size
1873         maxTankSizes[DUNE_BUGGY] = 120; //migrade type 1 tank size
1874         maxTankSizes[MIDGRADE_TYPE2] = 110; //midgrade type 2 tank size
1875         maxTankSizes[MIDGRADE_TYPE3] = 100; //midgrade type 3 tank size
1876         maxTankSizes[HATCHBACK] = 90; //regular type 1 tank size
1877         maxTankSizes[REGULAR_TYPE2] = 70; //regular type 2 tank size
1878         maxTankSizes[REGULAR_TYPE3] = 40; //regular type 3 tank size
1879         
1880         maxBznTankSizeOfPremiumCarWithIndex[1] = 200; //SUV tank size
1881         maxBznTankSizeOfPremiumCarWithIndex[2] = 450; //Tanker tank size
1882         maxBznTankSizeOfPremiumCarWithIndex[3] = 300; //Hovercraft tank size
1883         maxBznTankSizeOfPremiumCarWithIndex[4] = 200; //Tank tank size
1884         maxBznTankSizeOfPremiumCarWithIndex[5] = 250; //Lambo tank size
1885         maxBznTankSizeOfMidGradeCarWithIndex[1] = 100; //migrade type 1 tank size
1886         maxBznTankSizeOfMidGradeCarWithIndex[2] = 110; //midgrade type 2 tank size
1887         maxBznTankSizeOfMidGradeCarWithIndex[3] = 120; //midgrade type 3 tank size
1888         maxBznTankSizeOfRegularCarWithIndex[1] = 40; //regular type 1 tank size
1889         maxBznTankSizeOfRegularCarWithIndex[2] = 70; //regular type 2 tank size
1890         maxBznTankSizeOfRegularCarWithIndex[3] = 90; //regular type 3 tank size
1891 
1892         isTypeSpecial[HOVERCRAFT_TYPE] = true;
1893         isTypeSpecial[TANK_TYPE] = true;
1894         isTypeSpecial[LAMBO_TYPE] = true;
1895     }
1896 
1897     function isCarSpecial(uint256 tokenId) public view returns (bool) {
1898         return isSpecial[tokenId];
1899     }
1900 
1901     function getCarType(uint256 tokenId) public view returns (uint) {
1902         return carType[tokenId];
1903     }
1904 
1905     function mint(uint256 _tokenId, string _metadata, uint cType, uint256 tankSize, address newOwner) public onlyFactory {
1906         //Since any invalid car type would have a total supply of 0 
1907         //This require will also enforce that a valid cType is given
1908         require(carTypeSupply[cType] < carTypeTotalSupply[cType], "This type has reached total supply");
1909         
1910         //This will enforce the tank size is less than the max
1911         require(tankSize <= maxTankSizes[cType], "Tank size provided bigger than max for this type");
1912         
1913         if (isPremium(cType)) {
1914             premiumTotalSupplyForCar[cType].push(_tokenId);
1915         } else if (isMidGrade(cType)) {
1916             midGradeTotalSupplyForCar[cType].push(_tokenId);
1917         } else {
1918             regularTotalSupplyForCar[cType].push(_tokenId);
1919         }
1920 
1921         super._mint(newOwner, _tokenId);
1922         super._setTokenURI(_tokenId, _metadata);
1923 
1924         carType[_tokenId] = cType;
1925         isSpecial[_tokenId] = isTypeSpecial[cType];
1926         carTypeSupply[cType] = carTypeSupply[cType] + 1;
1927         tankSizes[_tokenId] = tankSize;
1928     }
1929     
1930     function isPremium(uint cType) public pure returns (bool) {
1931         return cType == SUV_TYPE || cType == TANKER_TYPE || cType == HOVERCRAFT_TYPE || cType == TANK_TYPE || cType == LAMBO_TYPE;
1932     }
1933     
1934     function isMidGrade(uint cType) public pure returns (bool) {
1935         return cType == DUNE_BUGGY || cType == MIDGRADE_TYPE2 || cType == MIDGRADE_TYPE3;
1936     }
1937     
1938     function isRegular(uint cType) public pure returns (bool) {
1939         return cType == HATCHBACK || cType == REGULAR_TYPE2 || cType == REGULAR_TYPE3;
1940     }
1941     
1942     function getTotalSupplyForType(uint cType) public view returns (uint256) {
1943         return carTypeSupply[cType];
1944     }
1945     
1946     function getPremiumCarsForVariant(uint variant) public view returns (uint[]) {
1947         return premiumTotalSupplyForCar[variant];
1948     }
1949     
1950     function getMidgradeCarsForVariant(uint variant) public view returns (uint[]) {
1951         return midGradeTotalSupplyForCar[variant];
1952     }
1953 
1954     function getRegularCarsForVariant(uint variant) public view returns (uint[]) {
1955         return regularTotalSupplyForCar[variant];
1956     }
1957 
1958     function getPremiumCarSupply(uint variant) public view returns (uint) {
1959         return premiumTotalSupplyForCar[variant].length;
1960     }
1961     
1962     function getMidgradeCarSupply(uint variant) public view returns (uint) {
1963         return midGradeTotalSupplyForCar[variant].length;
1964     }
1965 
1966     function getRegularCarSupply(uint variant) public view returns (uint) {
1967         return regularTotalSupplyForCar[variant].length;
1968     }
1969     
1970     function exists(uint256 _tokenId) public view returns (bool) {
1971         return super._exists(_tokenId);
1972     }
1973 }
1974 
1975 contract PreOrder is Destructible {
1976     /**
1977      * The current price for any given type (int)
1978      */
1979     mapping(uint => uint256) public currentTypePrice;
1980 
1981     // Maps Premium car variants to the tokens minted for their description
1982     // INPUT: variant #
1983     // OUTPUT: list of cars
1984     mapping(uint => uint256[]) public premiumCarsBought;
1985     mapping(uint => uint256[]) public midGradeCarsBought;
1986     mapping(uint => uint256[]) public regularCarsBought;
1987     mapping(uint256 => address) public tokenReserve;
1988 
1989     event consumerBulkBuy(uint256[] variants, address reserver, uint category);
1990     event CarBought(uint256 carId, uint256 value, address purchaser, uint category);
1991     event Withdrawal(uint256 amount);
1992 
1993     uint256 public constant COMMISSION_PERCENT = 5;
1994 
1995     //Max number of premium cars
1996     uint256 public constant MAX_PREMIUM = 30000;
1997     //Max number of midgrade cars
1998     uint256 public constant MAX_MIDGRADE = 150000;
1999     //Max number of regular cars
2000     uint256 public constant MAX_REGULAR = 1000000;
2001 
2002     //Max number of premium type cars
2003     uint public PREMIUM_TYPE_COUNT = 5;
2004     //Max number of midgrade type cars
2005     uint public MIDGRADE_TYPE_COUNT = 3;
2006     //Max number of regular type cars
2007     uint public REGULAR_TYPE_COUNT = 3;
2008 
2009     uint private midgrade_offset = 5;
2010     uint private regular_offset = 6;
2011 
2012     uint256 public constant GAS_REQUIREMENT = 250000;
2013 
2014     //Premium type id
2015     uint public constant PREMIUM_CATEGORY = 1;
2016     //Midgrade type id
2017     uint public constant MID_GRADE_CATEGORY = 2;
2018     //Regular type id
2019     uint public constant REGULAR_CATEGORY = 3;
2020     
2021     mapping(address => uint256) internal commissionRate;
2022     
2023     address internal constant OPENSEA = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;
2024 
2025     //The percent increase for any given type
2026     mapping(uint => uint256) internal percentIncrease;
2027     mapping(uint => uint256) internal percentBase;
2028     //uint public constant PERCENT_INCREASE = 101;
2029 
2030     //How many car is in each category currently
2031     uint256 public premiumHold = 30000;
2032     uint256 public midGradeHold = 150000;
2033     uint256 public regularHold = 1000000;
2034 
2035     bool public premiumOpen = false;
2036     bool public midgradeOpen = false;
2037     bool public regularOpen = false;
2038 
2039     //Reference to other contracts
2040     CarToken public token;
2041     //AuctionManager public auctionManager;
2042     CarFactory internal factory;
2043 
2044     address internal escrow;
2045 
2046     modifier premiumIsOpen {
2047         //Ensure we are selling at least 1 car
2048         require(premiumHold > 0, "No more premium cars");
2049         require(premiumOpen, "Premium store not open for sale");
2050         _;
2051     }
2052 
2053     modifier midGradeIsOpen {
2054         //Ensure we are selling at least 1 car
2055         require(midGradeHold > 0, "No more midgrade cars");
2056         require(midgradeOpen, "Midgrade store not open for sale");
2057         _;
2058     }
2059 
2060     modifier regularIsOpen {
2061         //Ensure we are selling at least 1 car
2062         require(regularHold > 0, "No more regular cars");
2063         require(regularOpen, "Regular store not open for sale");
2064         _;
2065     }
2066 
2067     modifier onlyFactory {
2068         //Only factory can use this function
2069         require(msg.sender == address(factory), "Not authorized");
2070         _;
2071     }
2072 
2073     modifier onlyFactoryOrOwner {
2074         //Only factory or owner can use this function
2075         require(msg.sender == address(factory) || msg.sender == owner(), "Not authorized");
2076         _;
2077     }
2078 
2079     function() public payable { }
2080 
2081     constructor(
2082         address tokenAddress,
2083         address tokenFactory,
2084         address e
2085     ) public {
2086         token = CarToken(tokenAddress);
2087 
2088         //auctionManager = new AuctionManager(tokenAddress);
2089 
2090         factory = CarFactory(tokenFactory);
2091 
2092         escrow = e;
2093 
2094         //Set percent increases
2095         percentIncrease[1] = 100008;
2096         percentBase[1] = 100000;
2097         percentIncrease[2] = 100015;
2098         percentBase[2] = 100000;
2099         percentIncrease[3] = 1002;
2100         percentBase[3] = 1000;
2101         percentIncrease[4] = 1004;
2102         percentBase[4] = 1000;
2103         percentIncrease[5] = 102;
2104         percentBase[5] = 100;
2105         
2106         commissionRate[OPENSEA] = 10;
2107     }
2108     
2109     function setCommission(address referral, uint256 percent) public onlyOwner {
2110         require(percent > COMMISSION_PERCENT);
2111         require(percent < 95);
2112         percent = percent - COMMISSION_PERCENT;
2113         
2114         commissionRate[referral] = percent;
2115     }
2116     
2117     function setPercentIncrease(uint256 increase, uint256 base, uint cType) public onlyOwner {
2118         require(increase > base);
2119         
2120         percentIncrease[cType] = increase;
2121         percentBase[cType] = base;
2122     }
2123 
2124     function openShop(uint category) public onlyOwner {
2125         require(category == 1 || category == 2 || category == 3, "Invalid category");
2126 
2127         if (category == PREMIUM_CATEGORY) {
2128             premiumOpen = true;
2129         } else if (category == MID_GRADE_CATEGORY) {
2130             midgradeOpen = true;
2131         } else if (category == REGULAR_CATEGORY) {
2132             regularOpen = true;
2133         }
2134     }
2135 
2136     /**
2137      * Set the starting price for any given type. Can only be set once, and value must be greater than 0
2138      */
2139     function setTypePrice(uint cType, uint256 price) public onlyOwner {
2140         if (currentTypePrice[cType] == 0) {
2141             require(price > 0, "Price already set");
2142             currentTypePrice[cType] = price;
2143         }
2144     }
2145 
2146     /**
2147     Withdraw the amount from the contract's balance. Only the contract owner can execute this function
2148     */
2149     function withdraw(uint256 amount) public onlyOwner {
2150         uint256 balance = address(this).balance;
2151 
2152         require(amount <= balance, "Requested to much");
2153         owner().transfer(amount);
2154 
2155         emit Withdrawal(amount);
2156     }
2157 
2158     function reserveManyTokens(uint[] cTypes, uint category) public payable returns (bool) {
2159         if (category == PREMIUM_CATEGORY) {
2160             require(premiumOpen, "Premium is not open for sale");
2161         } else if (category == MID_GRADE_CATEGORY) {
2162             require(midgradeOpen, "Midgrade is not open for sale");
2163         } else if (category == REGULAR_CATEGORY) {
2164             require(regularOpen, "Regular is not open for sale");
2165         } else {
2166             revert();
2167         }
2168 
2169         address reserver = msg.sender;
2170 
2171         uint256 ether_required = 0;
2172         for (uint i = 0; i < cTypes.length; i++) {
2173             uint cType = cTypes[i];
2174 
2175             uint256 price = priceFor(cType);
2176 
2177             ether_required += (price + GAS_REQUIREMENT);
2178 
2179             currentTypePrice[cType] = price;
2180         }
2181 
2182         require(msg.value >= ether_required);
2183 
2184         uint256 refundable = msg.value - ether_required;
2185 
2186         escrow.transfer(ether_required);
2187 
2188         if (refundable > 0) {
2189             reserver.transfer(refundable);
2190         }
2191 
2192         emit consumerBulkBuy(cTypes, reserver, category);
2193     }
2194 
2195      function buyBulkPremiumCar(address referal, uint[] variants, address new_owner) public payable premiumIsOpen returns (bool) {
2196          uint n = variants.length;
2197          require(n <= 10, "Max bulk buy is 10 cars");
2198 
2199          for (uint i = 0; i < n; i++) {
2200              buyCar(referal, variants[i], false, new_owner, PREMIUM_CATEGORY);
2201          }
2202      }
2203 
2204      function buyBulkMidGradeCar(address referal, uint[] variants, address new_owner) public payable midGradeIsOpen returns (bool) {
2205          uint n = variants.length;
2206          require(n <= 10, "Max bulk buy is 10 cars");
2207 
2208          for (uint i = 0; i < n; i++) {
2209              buyCar(referal, variants[i], false, new_owner, MID_GRADE_CATEGORY);
2210          }
2211      }
2212 
2213      function buyBulkRegularCar(address referal, uint[] variants, address new_owner) public payable regularIsOpen returns (bool) {
2214          uint n = variants.length;
2215          require(n <= 10, "Max bulk buy is 10 cars");
2216 
2217          for (uint i = 0; i < n; i++) {
2218              buyCar(referal, variants[i], false, new_owner, REGULAR_CATEGORY);
2219          }
2220      }
2221 
2222     function buyCar(address referal, uint cType, bool give_refund, address new_owner, uint category) public payable returns (bool) {
2223         require(category == PREMIUM_CATEGORY || category == MID_GRADE_CATEGORY || category == REGULAR_CATEGORY);
2224         if (category == PREMIUM_CATEGORY) {
2225             require(cType == 1 || cType == 2 || cType == 3 || cType == 4 || cType == 5, "Invalid car type");
2226             require(premiumHold > 0, "No more premium cars");
2227             require(premiumOpen, "Premium store not open for sale");
2228         } else if (category == MID_GRADE_CATEGORY) {
2229             require(cType == 6 || cType == 7 || cType == 8, "Invalid car type");
2230             require(midGradeHold > 0, "No more midgrade cars");
2231             require(midgradeOpen, "Midgrade store not open for sale");
2232         } else if (category == REGULAR_CATEGORY) {
2233             require(cType == 9 || cType == 10 || cType == 11, "Invalid car type");
2234             require(regularHold > 0, "No more regular cars");
2235             require(regularOpen, "Regular store not open for sale");
2236         }
2237 
2238         uint256 price = priceFor(cType);
2239         require(price > 0, "Price not yet set");
2240         require(msg.value >= price, "Not enough ether sent");
2241         /*if (tokenReserve[_tokenId] != address(0)) {
2242             require(new_owner == tokenReserve[_tokenId], "You don't have the rights to buy this token");
2243         }*/
2244         currentTypePrice[cType] = price; //Set new type price
2245 
2246         uint256 _tokenId = factory.mintFor(cType, new_owner); //Now mint the token
2247         
2248         if (category == PREMIUM_CATEGORY) {
2249             premiumCarsBought[cType].push(_tokenId);
2250             premiumHold--;
2251         } else if (category == MID_GRADE_CATEGORY) {
2252             midGradeCarsBought[cType - 5].push(_tokenId);
2253             midGradeHold--;
2254         } else if (category == REGULAR_CATEGORY) {
2255             regularCarsBought[cType - 8].push(_tokenId);
2256             regularHold--;
2257         }
2258 
2259         if (give_refund && msg.value > price) {
2260             uint256 change = msg.value - price;
2261 
2262             msg.sender.transfer(change);
2263         }
2264 
2265         if (referal != address(0)) {
2266             require(referal != msg.sender, "The referal cannot be the sender");
2267             require(referal != tx.origin, "The referal cannot be the tranaction origin");
2268             require(referal != new_owner, "The referal cannot be the new owner");
2269 
2270             //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
2271             uint256 totalCommision = COMMISSION_PERCENT + commissionRate[referal];
2272 
2273             uint256 commision = (price * totalCommision) / 100;
2274 
2275             referal.transfer(commision);
2276         }
2277 
2278         emit CarBought(_tokenId, price, new_owner, category);
2279     }
2280 
2281     /**
2282     Get the price for any car with the given _tokenId
2283     */
2284     function priceFor(uint cType) public view returns (uint256) {
2285         uint256 percent = percentIncrease[cType];
2286         uint256 base = percentBase[cType];
2287 
2288         uint256 currentPrice = currentTypePrice[cType];
2289         uint256 nextPrice = (currentPrice * percent);
2290 
2291         //Return the next price, as this is the true price
2292         return nextPrice / base;
2293     }
2294 
2295     function sold(uint256 _tokenId) public view returns (bool) {
2296         return token.exists(_tokenId);
2297     }
2298 }
2299 
2300 contract BatchPreOrder is Destructible {
2301     /**
2302      * The current price for any given type (int)
2303      */
2304     mapping(uint => uint256) public currentTypePrice;
2305 
2306     // Maps Premium car variants to the tokens minted for their description
2307     // INPUT: variant #
2308     // OUTPUT: list of cars
2309     mapping(uint => uint256[]) public premiumCarsBought;
2310     mapping(uint => uint256[]) public midGradeCarsBought;
2311     mapping(uint => uint256[]) public regularCarsBought;
2312     mapping(uint256 => address) public tokenReserve;
2313 
2314     event consumerBulkBuy(uint256[] variants, address reserver, uint category, address referral);
2315     event CarBought(uint256 carId, uint256 value, address purchaser, uint category);
2316     event Withdrawal(uint256 amount);
2317 
2318     uint256 public constant COMMISSION_PERCENT = 5;
2319 
2320     //Max number of premium cars
2321     uint256 public constant MAX_PREMIUM = 30000;
2322     //Max number of midgrade cars
2323     uint256 public constant MAX_MIDGRADE = 150000;
2324     //Max number of regular cars
2325     uint256 public constant MAX_REGULAR = 1000000;
2326 
2327     //Max number of premium type cars
2328     uint public PREMIUM_TYPE_COUNT = 5;
2329     //Max number of midgrade type cars
2330     uint public MIDGRADE_TYPE_COUNT = 3;
2331     //Max number of regular type cars
2332     uint public REGULAR_TYPE_COUNT = 3;
2333 
2334     uint private midgrade_offset = 5;
2335     uint private regular_offset = 6;
2336 
2337     uint256 public constant GAS_REQUIREMENT = 4500000;
2338     uint256 public constant BUFFER = 0.0001 ether;
2339 
2340     //Premium type id
2341     uint public constant PREMIUM_CATEGORY = 1;
2342     //Midgrade type id
2343     uint public constant MID_GRADE_CATEGORY = 2;
2344     //Regular type id
2345     uint public constant REGULAR_CATEGORY = 3;
2346     
2347     mapping(address => uint256) internal commissionRate;
2348     
2349     address internal constant OPENSEA = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;
2350 
2351     //The percent increase for any given type
2352     mapping(uint => uint256) internal percentIncrease;
2353     mapping(uint => uint256) internal percentBase;
2354     //uint public constant PERCENT_INCREASE = 101;
2355 
2356     //How many car is in each category currently
2357     uint256 public premiumHold = 30000;
2358     uint256 public midGradeHold = 150000;
2359     uint256 public regularHold = 1000000;
2360 
2361     bool public premiumOpen = false;
2362     bool public midgradeOpen = false;
2363     bool public regularOpen = false;
2364 
2365     //Reference to other contracts
2366     CarToken public token;
2367     //AuctionManager public auctionManager;
2368     CarFactory internal factory;
2369     
2370     PreOrder internal og;
2371 
2372     address internal escrow;
2373 
2374     modifier premiumIsOpen {
2375         //Ensure we are selling at least 1 car
2376         require(premiumHold > 0, "No more premium cars");
2377         require(premiumOpen, "Premium store not open for sale");
2378         _;
2379     }
2380 
2381     modifier midGradeIsOpen {
2382         //Ensure we are selling at least 1 car
2383         require(midGradeHold > 0, "No more midgrade cars");
2384         require(midgradeOpen, "Midgrade store not open for sale");
2385         _;
2386     }
2387 
2388     modifier regularIsOpen {
2389         //Ensure we are selling at least 1 car
2390         require(regularHold > 0, "No more regular cars");
2391         require(regularOpen, "Regular store not open for sale");
2392         _;
2393     }
2394 
2395     modifier onlyFactory {
2396         //Only factory can use this function
2397         require(msg.sender == address(factory), "Not authorized");
2398         _;
2399     }
2400 
2401     modifier onlyFactoryOrOwner {
2402         //Only factory or owner can use this function
2403         require(msg.sender == address(factory) || msg.sender == owner(), "Not authorized");
2404         _;
2405     }
2406 
2407     function() public payable { }
2408 
2409     constructor(
2410         address tokenAddress,
2411         address tokenFactory,
2412         address e,
2413         address preorder
2414     ) public {
2415         token = CarToken(tokenAddress);
2416 
2417         //auctionManager = new AuctionManager(tokenAddress);
2418 
2419         factory = CarFactory(tokenFactory);
2420 
2421         escrow = e;
2422         
2423         og = PreOrder(preorder);
2424 
2425         //Set percent increases
2426         percentIncrease[1] = 100008;
2427         percentBase[1] = 100000;
2428         percentIncrease[2] = 100015;
2429         percentBase[2] = 100000;
2430         percentIncrease[3] = 1002;
2431         percentBase[3] = 1000;
2432         percentIncrease[4] = 1004;
2433         percentBase[4] = 1000;
2434         percentIncrease[5] = 1012;
2435         percentBase[5] = 1000;
2436         
2437         commissionRate[OPENSEA] = 10;
2438     }
2439     
2440     function setCommission(address referral, uint256 percent) public onlyOwner {
2441         revert(); //NOT IMPLEMENTED 
2442     }
2443     
2444     function setPercentIncrease(uint256 increase, uint256 base, uint cType) public onlyOwner {
2445         require(increase > base);
2446         
2447         percentIncrease[cType] = increase;
2448         percentBase[cType] = base;
2449     }
2450 
2451     function openShop(uint category) public onlyOwner {
2452         require(category == 1 || category == 2 || category == 3, "Invalid category");
2453 
2454         if (category == PREMIUM_CATEGORY) {
2455             premiumOpen = true;
2456         } else if (category == MID_GRADE_CATEGORY) {
2457             midgradeOpen = true;
2458         } else if (category == REGULAR_CATEGORY) {
2459             regularOpen = true;
2460         }
2461     }
2462 
2463     /**
2464      * Set the starting price for any given type. Can only be set once, and value must be greater than 0
2465      */
2466     function setTypePrice(uint cType, uint256 price) public onlyOwner {
2467         revert(); //NOT IMPLEMENTED 
2468     }
2469 
2470     /**
2471     Withdraw the amount from the contract's balance. Only the contract owner can execute this function
2472     */
2473     function withdraw(uint256 amount) public onlyOwner {
2474         uint256 balance = address(this).balance;
2475 
2476         require(amount <= balance, "Requested to much");
2477         owner().transfer(amount);
2478 
2479         emit Withdrawal(amount);
2480     }
2481 
2482     function reserveManyTokens(uint[] cTypes, uint category, address referral) public payable returns (bool) {
2483         if (category == PREMIUM_CATEGORY) {
2484             require(premiumOpen, "Premium is not open for sale");
2485         } else if (category == MID_GRADE_CATEGORY) {
2486             require(midgradeOpen, "Midgrade is not open for sale");
2487         } else if (category == REGULAR_CATEGORY) {
2488             require(regularOpen, "Regular is not open for sale");
2489         } else {
2490             revert();
2491         }
2492 
2493         address reserver = msg.sender;
2494 
2495         uint256 ether_required = 0;
2496         
2497         //Reset all type prices to current price
2498         for (uint c = 1; c <= 11; c++) {
2499             currentTypePrice[c] = og.currentTypePrice(c);
2500         }
2501         
2502         for (uint i = 0; i < cTypes.length; i++) {
2503             uint cType = cTypes[i];
2504 
2505             uint256 price = currentTypePrice[cType];
2506             
2507             uint256 percent = percentIncrease[cType];
2508             uint256 base = percentBase[cType];
2509             
2510             uint256 nextPrice = (price * percent) / base;
2511 
2512             ether_required += (price + (GAS_REQUIREMENT * tx.gasprice) + BUFFER);
2513 
2514             currentTypePrice[cType] = nextPrice;
2515         }
2516 
2517         require(msg.value >= ether_required);
2518 
2519         uint256 refundable = msg.value - ether_required;
2520 
2521         escrow.transfer(ether_required);
2522 
2523         if (refundable > 0) {
2524             reserver.transfer(refundable);
2525         }
2526 
2527         emit consumerBulkBuy(cTypes, reserver, category, referral);
2528     }
2529 
2530      function buyBulkPremiumCar(address referal, uint[] variants, address new_owner) public payable premiumIsOpen returns (bool) {
2531          revert(); //NOT IMPLEMENTED 
2532      }
2533 
2534      function buyBulkMidGradeCar(address referal, uint[] variants, address new_owner) public payable midGradeIsOpen returns (bool) {
2535           revert(); //NOT IMPLEMENTED 
2536      }
2537 
2538      function buyBulkRegularCar(address referal, uint[] variants, address new_owner) public payable regularIsOpen returns (bool) {
2539           revert(); //NOT IMPLEMENTED 
2540      }
2541 
2542     function buyCar(address referal, uint cType, bool give_refund, address new_owner, uint category) public payable returns (bool) {
2543          revert(); //NOT IMPLEMENTED 
2544     }
2545 
2546     /**
2547     Get the price for any car with the given _tokenId
2548     */
2549     function priceFor(uint cType) public view returns (uint256) {
2550          revert(); //NOT IMPLEMENTED 
2551     }
2552 
2553     function sold(uint256 _tokenId) public view returns (bool) {
2554          revert(); //NOT IMPLEMENTED 
2555     }
2556 }