1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 pragma solidity ^0.4.24;
78 
79 /**
80  * @title IERC165
81  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
82  */
83 interface IERC165 {
84 
85   /**
86    * @notice Query if a contract implements an interface
87    * @param interfaceId The interface identifier, as specified in ERC-165
88    * @dev Interface identification is specified in ERC-165. This function
89    * uses less than 30,000 gas.
90    */
91   function supportsInterface(bytes4 interfaceId)
92     external
93     view
94     returns (bool);
95 }
96 
97 pragma solidity ^0.4.24;
98 
99 
100 /**
101  * @title ERC721 Non-Fungible Token Standard basic interface
102  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
103  */
104 contract IERC721 is IERC165 {
105 
106   event Transfer(
107     address indexed from,
108     address indexed to,
109     uint256 indexed tokenId
110   );
111   event Approval(
112     address indexed owner,
113     address indexed approved,
114     uint256 indexed tokenId
115   );
116   event ApprovalForAll(
117     address indexed owner,
118     address indexed operator,
119     bool approved
120   );
121 
122   function balanceOf(address owner) public view returns (uint256 balance);
123   function ownerOf(uint256 tokenId) public view returns (address owner);
124 
125   function approve(address to, uint256 tokenId) public;
126   function getApproved(uint256 tokenId)
127     public view returns (address operator);
128 
129   function setApprovalForAll(address operator, bool _approved) public;
130   function isApprovedForAll(address owner, address operator)
131     public view returns (bool);
132 
133   function transferFrom(address from, address to, uint256 tokenId) public;
134   function safeTransferFrom(address from, address to, uint256 tokenId)
135     public;
136 
137   function safeTransferFrom(
138     address from,
139     address to,
140     uint256 tokenId,
141     bytes data
142   )
143     public;
144 }
145 
146 pragma solidity ^0.4.24;
147 
148 /**
149  * @title ERC721 token receiver interface
150  * @dev Interface for any contract that wants to support safeTransfers
151  * from ERC721 asset contracts.
152  */
153 contract IERC721Receiver {
154   /**
155    * @notice Handle the receipt of an NFT
156    * @dev The ERC721 smart contract calls this function on the recipient
157    * after a `safeTransfer`. This function MUST return the function selector,
158    * otherwise the caller will revert the transaction. The selector to be
159    * returned can be obtained as `this.onERC721Received.selector`. This
160    * function MAY throw to revert and reject the transfer.
161    * Note: the ERC721 contract address is always the message sender.
162    * @param operator The address which called `safeTransferFrom` function
163    * @param from The address which previously owned the token
164    * @param tokenId The NFT identifier which is being transferred
165    * @param data Additional data with no specified format
166    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
167    */
168   function onERC721Received(
169     address operator,
170     address from,
171     uint256 tokenId,
172     bytes data
173   )
174     public
175     returns(bytes4);
176 }
177 
178 pragma solidity ^0.4.24;
179 
180 /**
181  * @title SafeMath
182  * @dev Math operations with safety checks that revert on error
183  */
184 library SafeMath {
185 
186   /**
187   * @dev Multiplies two numbers, reverts on overflow.
188   */
189   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191     // benefit is lost if 'b' is also tested.
192     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
193     if (a == 0) {
194       return 0;
195     }
196 
197     uint256 c = a * b;
198     require(c / a == b);
199 
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     require(b > 0); // Solidity only automatically asserts when dividing by 0
208     uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211     return c;
212   }
213 
214   /**
215   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
216   */
217   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218     require(b <= a);
219     uint256 c = a - b;
220 
221     return c;
222   }
223 
224   /**
225   * @dev Adds two numbers, reverts on overflow.
226   */
227   function add(uint256 a, uint256 b) internal pure returns (uint256) {
228     uint256 c = a + b;
229     require(c >= a);
230 
231     return c;
232   }
233 
234   /**
235   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
236   * reverts when dividing by zero.
237   */
238   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239     require(b != 0);
240     return a % b;
241   }
242 }
243 
244 pragma solidity ^0.4.24;
245 
246 /**
247  * Utility library of inline functions on addresses
248  */
249 library Address {
250 
251   /**
252    * Returns whether the target address is a contract
253    * @dev This function will return false if invoked during the constructor of a contract,
254    * as the code is not actually created until after the constructor finishes.
255    * @param account address of the account to check
256    * @return whether the target address is a contract
257    */
258   function isContract(address account) internal view returns (bool) {
259     uint256 size;
260     // XXX Currently there is no better way to check if there is a contract in an address
261     // than to check the size of the code at that address.
262     // See https://ethereum.stackexchange.com/a/14016/36603
263     // for more details about how this works.
264     // TODO Check this again before the Serenity release, because all addresses will be
265     // contracts then.
266     // solium-disable-next-line security/no-inline-assembly
267     assembly { size := extcodesize(account) }
268     return size > 0;
269   }
270 
271 }
272 
273 pragma solidity ^0.4.24;
274 
275 
276 /**
277  * @title ERC165
278  * @author Matt Condon (@shrugs)
279  * @dev Implements ERC165 using a lookup table.
280  */
281 contract ERC165 is IERC165 {
282 
283   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
284   /**
285    * 0x01ffc9a7 ===
286    *   bytes4(keccak256('supportsInterface(bytes4)'))
287    */
288 
289   /**
290    * @dev a mapping of interface id to whether or not it's supported
291    */
292   mapping(bytes4 => bool) private _supportedInterfaces;
293 
294   /**
295    * @dev A contract implementing SupportsInterfaceWithLookup
296    * implement ERC165 itself
297    */
298   constructor()
299     internal
300   {
301     _registerInterface(_InterfaceId_ERC165);
302   }
303 
304   /**
305    * @dev implement supportsInterface(bytes4) using a lookup table
306    */
307   function supportsInterface(bytes4 interfaceId)
308     external
309     view
310     returns (bool)
311   {
312     return _supportedInterfaces[interfaceId];
313   }
314 
315   /**
316    * @dev internal method for registering an interface
317    */
318   function _registerInterface(bytes4 interfaceId)
319     internal
320   {
321     require(interfaceId != 0xffffffff);
322     _supportedInterfaces[interfaceId] = true;
323   }
324 }
325 
326 pragma solidity ^0.4.24;
327 
328 
329 
330 
331 
332 
333 /**
334  * @title ERC721 Non-Fungible Token Standard basic implementation
335  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
336  */
337 contract ERC721 is ERC165, IERC721 {
338 
339   using SafeMath for uint256;
340   using Address for address;
341 
342   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
343   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
344   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
345 
346   // Mapping from token ID to owner
347   mapping (uint256 => address) private _tokenOwner;
348 
349   // Mapping from token ID to approved address
350   mapping (uint256 => address) private _tokenApprovals;
351 
352   // Mapping from owner to number of owned token
353   mapping (address => uint256) private _ownedTokensCount;
354 
355   // Mapping from owner to operator approvals
356   mapping (address => mapping (address => bool)) private _operatorApprovals;
357 
358   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
359   /*
360    * 0x80ac58cd ===
361    *   bytes4(keccak256('balanceOf(address)')) ^
362    *   bytes4(keccak256('ownerOf(uint256)')) ^
363    *   bytes4(keccak256('approve(address,uint256)')) ^
364    *   bytes4(keccak256('getApproved(uint256)')) ^
365    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
366    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
367    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
368    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
369    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
370    */
371 
372   constructor()
373     public
374   {
375     // register the supported interfaces to conform to ERC721 via ERC165
376     _registerInterface(_InterfaceId_ERC721);
377   }
378 
379   /**
380    * @dev Gets the balance of the specified address
381    * @param owner address to query the balance of
382    * @return uint256 representing the amount owned by the passed address
383    */
384   function balanceOf(address owner) public view returns (uint256) {
385     require(owner != address(0));
386     return _ownedTokensCount[owner];
387   }
388 
389   /**
390    * @dev Gets the owner of the specified token ID
391    * @param tokenId uint256 ID of the token to query the owner of
392    * @return owner address currently marked as the owner of the given token ID
393    */
394   function ownerOf(uint256 tokenId) public view returns (address) {
395     address owner = _tokenOwner[tokenId];
396     require(owner != address(0));
397     return owner;
398   }
399 
400   /**
401    * @dev Approves another address to transfer the given token ID
402    * The zero address indicates there is no approved address.
403    * There can only be one approved address per token at a given time.
404    * Can only be called by the token owner or an approved operator.
405    * @param to address to be approved for the given token ID
406    * @param tokenId uint256 ID of the token to be approved
407    */
408   function approve(address to, uint256 tokenId) public {
409     address owner = ownerOf(tokenId);
410     require(to != owner);
411     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
412 
413     _tokenApprovals[tokenId] = to;
414     emit Approval(owner, to, tokenId);
415   }
416 
417   /**
418    * @dev Gets the approved address for a token ID, or zero if no address set
419    * Reverts if the token ID does not exist.
420    * @param tokenId uint256 ID of the token to query the approval of
421    * @return address currently approved for the given token ID
422    */
423   function getApproved(uint256 tokenId) public view returns (address) {
424     require(_exists(tokenId));
425     return _tokenApprovals[tokenId];
426   }
427 
428   /**
429    * @dev Sets or unsets the approval of a given operator
430    * An operator is allowed to transfer all tokens of the sender on their behalf
431    * @param to operator address to set the approval
432    * @param approved representing the status of the approval to be set
433    */
434   function setApprovalForAll(address to, bool approved) public {
435     require(to != msg.sender);
436     _operatorApprovals[msg.sender][to] = approved;
437     emit ApprovalForAll(msg.sender, to, approved);
438   }
439 
440   /**
441    * @dev Tells whether an operator is approved by a given owner
442    * @param owner owner address which you want to query the approval of
443    * @param operator operator address which you want to query the approval of
444    * @return bool whether the given operator is approved by the given owner
445    */
446   function isApprovedForAll(
447     address owner,
448     address operator
449   )
450     public
451     view
452     returns (bool)
453   {
454     return _operatorApprovals[owner][operator];
455   }
456 
457   /**
458    * @dev Transfers the ownership of a given token ID to another address
459    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
460    * Requires the msg sender to be the owner, approved, or operator
461    * @param from current owner of the token
462    * @param to address to receive the ownership of the given token ID
463    * @param tokenId uint256 ID of the token to be transferred
464   */
465   function transferFrom(
466     address from,
467     address to,
468     uint256 tokenId
469   )
470     public
471   {
472     require(_isApprovedOrOwner(msg.sender, tokenId));
473     require(to != address(0));
474 
475     _clearApproval(from, tokenId);
476     _removeTokenFrom(from, tokenId);
477     _addTokenTo(to, tokenId);
478 
479     emit Transfer(from, to, tokenId);
480   }
481 
482   /**
483    * @dev Safely transfers the ownership of a given token ID to another address
484    * If the target address is a contract, it must implement `onERC721Received`,
485    * which is called upon a safe transfer, and return the magic value
486    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
487    * the transfer is reverted.
488    *
489    * Requires the msg sender to be the owner, approved, or operator
490    * @param from current owner of the token
491    * @param to address to receive the ownership of the given token ID
492    * @param tokenId uint256 ID of the token to be transferred
493   */
494   function safeTransferFrom(
495     address from,
496     address to,
497     uint256 tokenId
498   )
499     public
500   {
501     // solium-disable-next-line arg-overflow
502     safeTransferFrom(from, to, tokenId, "");
503   }
504 
505   /**
506    * @dev Safely transfers the ownership of a given token ID to another address
507    * If the target address is a contract, it must implement `onERC721Received`,
508    * which is called upon a safe transfer, and return the magic value
509    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
510    * the transfer is reverted.
511    * Requires the msg sender to be the owner, approved, or operator
512    * @param from current owner of the token
513    * @param to address to receive the ownership of the given token ID
514    * @param tokenId uint256 ID of the token to be transferred
515    * @param _data bytes data to send along with a safe transfer check
516    */
517   function safeTransferFrom(
518     address from,
519     address to,
520     uint256 tokenId,
521     bytes _data
522   )
523     public
524   {
525     transferFrom(from, to, tokenId);
526     // solium-disable-next-line arg-overflow
527     require(_checkOnERC721Received(from, to, tokenId, _data));
528   }
529 
530   /**
531    * @dev Returns whether the specified token exists
532    * @param tokenId uint256 ID of the token to query the existence of
533    * @return whether the token exists
534    */
535   function _exists(uint256 tokenId) internal view returns (bool) {
536     address owner = _tokenOwner[tokenId];
537     return owner != address(0);
538   }
539 
540   /**
541    * @dev Returns whether the given spender can transfer a given token ID
542    * @param spender address of the spender to query
543    * @param tokenId uint256 ID of the token to be transferred
544    * @return bool whether the msg.sender is approved for the given token ID,
545    *  is an operator of the owner, or is the owner of the token
546    */
547   function _isApprovedOrOwner(
548     address spender,
549     uint256 tokenId
550   )
551     internal
552     view
553     returns (bool)
554   {
555     address owner = ownerOf(tokenId);
556     // Disable solium check because of
557     // https://github.com/duaraghav8/Solium/issues/175
558     // solium-disable-next-line operator-whitespace
559     return (
560       spender == owner ||
561       getApproved(tokenId) == spender ||
562       isApprovedForAll(owner, spender)
563     );
564   }
565 
566   /**
567    * @dev Internal function to mint a new token
568    * Reverts if the given token ID already exists
569    * @param to The address that will own the minted token
570    * @param tokenId uint256 ID of the token to be minted by the msg.sender
571    */
572   function _mint(address to, uint256 tokenId) internal {
573     require(to != address(0));
574     _addTokenTo(to, tokenId);
575     emit Transfer(address(0), to, tokenId);
576   }
577 
578   /**
579    * @dev Internal function to burn a specific token
580    * Reverts if the token does not exist
581    * @param tokenId uint256 ID of the token being burned by the msg.sender
582    */
583   function _burn(address owner, uint256 tokenId) internal {
584     _clearApproval(owner, tokenId);
585     _removeTokenFrom(owner, tokenId);
586     emit Transfer(owner, address(0), tokenId);
587   }
588 
589   /**
590    * @dev Internal function to add a token ID to the list of a given address
591    * Note that this function is left internal to make ERC721Enumerable possible, but is not
592    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
593    * @param to address representing the new owner of the given token ID
594    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
595    */
596   function _addTokenTo(address to, uint256 tokenId) internal {
597     require(_tokenOwner[tokenId] == address(0));
598     _tokenOwner[tokenId] = to;
599     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
600   }
601 
602   /**
603    * @dev Internal function to remove a token ID from the list of a given address
604    * Note that this function is left internal to make ERC721Enumerable possible, but is not
605    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
606    * and doesn't clear approvals.
607    * @param from address representing the previous owner of the given token ID
608    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
609    */
610   function _removeTokenFrom(address from, uint256 tokenId) internal {
611     require(ownerOf(tokenId) == from);
612     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
613     _tokenOwner[tokenId] = address(0);
614   }
615 
616   /**
617    * @dev Internal function to invoke `onERC721Received` on a target address
618    * The call is not executed if the target address is not a contract
619    * @param from address representing the previous owner of the given token ID
620    * @param to target address that will receive the tokens
621    * @param tokenId uint256 ID of the token to be transferred
622    * @param _data bytes optional data to send along with the call
623    * @return whether the call correctly returned the expected magic value
624    */
625   function _checkOnERC721Received(
626     address from,
627     address to,
628     uint256 tokenId,
629     bytes _data
630   )
631     internal
632     returns (bool)
633   {
634     if (!to.isContract()) {
635       return true;
636     }
637     bytes4 retval = IERC721Receiver(to).onERC721Received(
638       msg.sender, from, tokenId, _data);
639     return (retval == _ERC721_RECEIVED);
640   }
641 
642   /**
643    * @dev Private function to clear current approval of a given token ID
644    * Reverts if the given address is not indeed the owner of the token
645    * @param owner owner of the token
646    * @param tokenId uint256 ID of the token to be transferred
647    */
648   function _clearApproval(address owner, uint256 tokenId) private {
649     require(ownerOf(tokenId) == owner);
650     if (_tokenApprovals[tokenId] != address(0)) {
651       _tokenApprovals[tokenId] = address(0);
652     }
653   }
654 }
655 
656 pragma solidity ^0.4.24;
657 
658 
659 /**
660  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
661  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
662  */
663 contract IERC721Enumerable is IERC721 {
664   function totalSupply() public view returns (uint256);
665   function tokenOfOwnerByIndex(
666     address owner,
667     uint256 index
668   )
669     public
670     view
671     returns (uint256 tokenId);
672 
673   function tokenByIndex(uint256 index) public view returns (uint256);
674 }
675 
676 pragma solidity ^0.4.24;
677 
678 
679 
680 
681 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
682   // Mapping from owner to list of owned token IDs
683   mapping(address => uint256[]) private _ownedTokens;
684 
685   // Mapping from token ID to index of the owner tokens list
686   mapping(uint256 => uint256) private _ownedTokensIndex;
687 
688   // Array with all token ids, used for enumeration
689   uint256[] private _allTokens;
690 
691   // Mapping from token id to position in the allTokens array
692   mapping(uint256 => uint256) private _allTokensIndex;
693 
694   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
695   /**
696    * 0x780e9d63 ===
697    *   bytes4(keccak256('totalSupply()')) ^
698    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
699    *   bytes4(keccak256('tokenByIndex(uint256)'))
700    */
701 
702   /**
703    * @dev Constructor function
704    */
705   constructor() public {
706     // register the supported interface to conform to ERC721 via ERC165
707     _registerInterface(_InterfaceId_ERC721Enumerable);
708   }
709 
710   /**
711    * @dev Gets the token ID at a given index of the tokens list of the requested owner
712    * @param owner address owning the tokens list to be accessed
713    * @param index uint256 representing the index to be accessed of the requested tokens list
714    * @return uint256 token ID at the given index of the tokens list owned by the requested address
715    */
716   function tokenOfOwnerByIndex(
717     address owner,
718     uint256 index
719   )
720     public
721     view
722     returns (uint256)
723   {
724     require(index < balanceOf(owner));
725     return _ownedTokens[owner][index];
726   }
727 
728   /**
729    * @dev Gets the total amount of tokens stored by the contract
730    * @return uint256 representing the total amount of tokens
731    */
732   function totalSupply() public view returns (uint256) {
733     return _allTokens.length;
734   }
735 
736   /**
737    * @dev Gets the token ID at a given index of all the tokens in this contract
738    * Reverts if the index is greater or equal to the total number of tokens
739    * @param index uint256 representing the index to be accessed of the tokens list
740    * @return uint256 token ID at the given index of the tokens list
741    */
742   function tokenByIndex(uint256 index) public view returns (uint256) {
743     require(index < totalSupply());
744     return _allTokens[index];
745   }
746 
747   /**
748    * @dev Internal function to add a token ID to the list of a given address
749    * This function is internal due to language limitations, see the note in ERC721.sol.
750    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
751    * @param to address representing the new owner of the given token ID
752    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
753    */
754   function _addTokenTo(address to, uint256 tokenId) internal {
755     super._addTokenTo(to, tokenId);
756     uint256 length = _ownedTokens[to].length;
757     _ownedTokens[to].push(tokenId);
758     _ownedTokensIndex[tokenId] = length;
759   }
760 
761   /**
762    * @dev Internal function to remove a token ID from the list of a given address
763    * This function is internal due to language limitations, see the note in ERC721.sol.
764    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
765    * and doesn't clear approvals.
766    * @param from address representing the previous owner of the given token ID
767    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
768    */
769   function _removeTokenFrom(address from, uint256 tokenId) internal {
770     super._removeTokenFrom(from, tokenId);
771 
772     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
773     // then delete the last slot.
774     uint256 tokenIndex = _ownedTokensIndex[tokenId];
775     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
776     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
777 
778     _ownedTokens[from][tokenIndex] = lastToken;
779     // This also deletes the contents at the last position of the array
780     _ownedTokens[from].length--;
781 
782     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
783     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
784     // the lastToken to the first position, and then dropping the element placed in the last position of the list
785 
786     _ownedTokensIndex[tokenId] = 0;
787     _ownedTokensIndex[lastToken] = tokenIndex;
788   }
789 
790   /**
791    * @dev Internal function to mint a new token
792    * Reverts if the given token ID already exists
793    * @param to address the beneficiary that will own the minted token
794    * @param tokenId uint256 ID of the token to be minted by the msg.sender
795    */
796   function _mint(address to, uint256 tokenId) internal {
797     super._mint(to, tokenId);
798 
799     _allTokensIndex[tokenId] = _allTokens.length;
800     _allTokens.push(tokenId);
801   }
802 
803   /**
804    * @dev Internal function to burn a specific token
805    * Reverts if the token does not exist
806    * @param owner owner of the token to burn
807    * @param tokenId uint256 ID of the token being burned by the msg.sender
808    */
809   function _burn(address owner, uint256 tokenId) internal {
810     super._burn(owner, tokenId);
811 
812     // Reorg all tokens array
813     uint256 tokenIndex = _allTokensIndex[tokenId];
814     uint256 lastTokenIndex = _allTokens.length.sub(1);
815     uint256 lastToken = _allTokens[lastTokenIndex];
816 
817     _allTokens[tokenIndex] = lastToken;
818     _allTokens[lastTokenIndex] = 0;
819 
820     _allTokens.length--;
821     _allTokensIndex[tokenId] = 0;
822     _allTokensIndex[lastToken] = tokenIndex;
823   }
824 }
825 
826 pragma solidity ^0.4.24;
827 
828 
829 /**
830  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
831  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
832  */
833 contract IERC721Metadata is IERC721 {
834   function name() external view returns (string);
835   function symbol() external view returns (string);
836   function tokenURI(uint256 tokenId) external view returns (string);
837 }
838 
839 pragma solidity ^0.4.24;
840 
841 
842 
843 
844 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
845   // Token name
846   string private _name;
847 
848   // Token symbol
849   string private _symbol;
850 
851   // Optional mapping for token URIs
852   mapping(uint256 => string) private _tokenURIs;
853 
854   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
855   /**
856    * 0x5b5e139f ===
857    *   bytes4(keccak256('name()')) ^
858    *   bytes4(keccak256('symbol()')) ^
859    *   bytes4(keccak256('tokenURI(uint256)'))
860    */
861 
862   /**
863    * @dev Constructor function
864    */
865   constructor(string name, string symbol) public {
866     _name = name;
867     _symbol = symbol;
868 
869     // register the supported interfaces to conform to ERC721 via ERC165
870     _registerInterface(InterfaceId_ERC721Metadata);
871   }
872 
873   /**
874    * @dev Gets the token name
875    * @return string representing the token name
876    */
877   function name() external view returns (string) {
878     return _name;
879   }
880 
881   /**
882    * @dev Gets the token symbol
883    * @return string representing the token symbol
884    */
885   function symbol() external view returns (string) {
886     return _symbol;
887   }
888 
889   /**
890    * @dev Returns an URI for a given token ID
891    * Throws if the token ID does not exist. May return an empty string.
892    * @param tokenId uint256 ID of the token to query
893    */
894   function tokenURI(uint256 tokenId) external view returns (string) {
895     require(_exists(tokenId));
896     return _tokenURIs[tokenId];
897   }
898 
899   /**
900    * @dev Internal function to set the token URI for a given token
901    * Reverts if the token ID does not exist
902    * @param tokenId uint256 ID of the token to set its URI
903    * @param uri string URI to assign
904    */
905   function _setTokenURI(uint256 tokenId, string uri) internal {
906     require(_exists(tokenId));
907     _tokenURIs[tokenId] = uri;
908   }
909 
910   /**
911    * @dev Internal function to burn a specific token
912    * Reverts if the token does not exist
913    * @param owner owner of the token to burn
914    * @param tokenId uint256 ID of the token being burned by the msg.sender
915    */
916   function _burn(address owner, uint256 tokenId) internal {
917     super._burn(owner, tokenId);
918 
919     // Clear metadata (if any)
920     if (bytes(_tokenURIs[tokenId]).length != 0) {
921       delete _tokenURIs[tokenId];
922     }
923   }
924 }
925 
926 pragma solidity ^0.4.24;
927 
928 
929 
930 
931 /**
932  * @title Full ERC721 Token
933  * This implementation includes all the required and some optional functionality of the ERC721 standard
934  * Moreover, it includes approve all functionality using operator terminology
935  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
936  */
937 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
938   constructor(string name, string symbol) ERC721Metadata(name, symbol)
939     public
940   {
941   }
942 }
943 
944 pragma solidity ^0.4.24;
945 
946 
947 
948 contract CryptoMotors is Ownable, ERC721Full {
949     string public name = "CryptoMotors";
950     string public symbol = "CM";
951     
952     event CryptoMotorCreated(address receiver, uint cryptoMotorId, string uri);
953     event CryptoMotorTransferred(address from, address to, uint cryptoMotorId, string uri);
954     event CryptoMotorUriChanged(uint cryptoMotorId, string uri);
955     event CryptoMotorDnaChanged(uint cryptoMotorId, string dna);
956     // Structs
957 
958     struct CryptoMotor {
959         string dna;
960         uint32 level;
961         uint32 readyTime;
962         uint32 winCount;
963         uint32 lossCount;
964         address designerWallet;
965     }
966 
967     CryptoMotor[] public cryptoMotors;
968 
969     constructor() ERC721Full(name, symbol) public { }
970 
971     // Management methods
972     function create(address owner, string _uri, string _dna, address _designerWallet) public onlyOwner returns (uint) {
973         uint id = cryptoMotors.push(CryptoMotor(_dna, 1, uint32(now + 1 days), 0, 0, _designerWallet)) - 1;
974         _mint(owner, id);
975         _setTokenURI(id, _uri);
976         emit CryptoMotorCreated(owner, id, _uri);
977         return id;
978     }
979 
980     function setTokenURI(uint256 _cryptoMotorId, string _uri) public onlyOwner {
981         _setTokenURI(_cryptoMotorId, _uri);
982         emit CryptoMotorUriChanged(_cryptoMotorId, _uri);
983     }
984     
985     function setCryptoMotorDna(uint _cryptoMotorId, string _dna) public onlyOwner {
986         CryptoMotor storage cm = cryptoMotors[_cryptoMotorId];
987         cm.dna = _dna;
988         emit CryptoMotorDnaChanged(_cryptoMotorId, _dna);
989     }
990 
991     function setAttributes(uint256 _cryptoMotorId, uint32 _level, uint32 _readyTime, uint32 _winCount, uint32 _lossCount) public onlyOwner {
992         CryptoMotor storage cm = cryptoMotors[_cryptoMotorId];
993         cm.level = _level;
994         cm.readyTime = _readyTime;
995         cm.winCount = _winCount;
996         cm.lossCount = _lossCount;
997     }
998 
999     function withdraw() external onlyOwner {
1000         msg.sender.transfer(address(this).balance);
1001     }
1002 
1003     // User methods
1004     function getDesignerWallet(uint256 _cryptoMotorId) public view returns (address) {
1005         return cryptoMotors[_cryptoMotorId].designerWallet;
1006     }
1007 
1008     function setApprovalsForAll(address[] _addresses, bool approved) public {
1009         for(uint i; i < _addresses.length; i++) {
1010             setApprovalForAll(_addresses[i], approved);
1011         }
1012     }
1013 
1014 }
1015 
1016 pragma solidity ^0.4.24;
1017 
1018 
1019 
1020 contract CryptoMotorsMarketV1 is Ownable {
1021     
1022     CryptoMotors token;
1023 
1024     event CryptoMotorForSale(uint cryptoMotorId, uint startPrice, uint endPrice, uint duration, address seller);
1025     event CryptoMotorSold(uint cryptoMotorId, uint priceSold, address seller, address buyer);
1026     event CryptoMotorSaleCancelled(uint cryptoMotorId, address seller);
1027     event CryptoMotorSaleFinished(uint cryptoMotorId, address seller);
1028     event CryptoMotorGift(uint cryptoMotorId, address from, address to);
1029     
1030     // Note: It is known that there are roughly 15 seconds between every block generation in Ethereum
1031     uint8 SECONDS_PER_BLOCK = 15;
1032 
1033     uint16 public ownerCutPercentage;
1034     uint16 public designerCutPercentage;
1035     
1036     mapping (uint => Sale) cryptoMotorToSale;
1037 
1038     struct Sale {
1039         address seller;
1040         uint cryptoMotorId;
1041         uint startPrice;
1042         uint endPrice;
1043         uint startBlock;
1044         uint endBlock;
1045         uint duration;
1046         bool exists;
1047     }
1048 
1049     constructor(address _cryptoMotorsToken) public { 
1050         token = CryptoMotors(_cryptoMotorsToken);
1051     }
1052 
1053     // Modifiers
1054 
1055     modifier cryptoMotorForSale(uint _cryptoMotorId) {
1056         require(cryptoMotorToSale[_cryptoMotorId].exists == true, "The car is not for auction");
1057         _;
1058     }
1059 
1060     modifier cryptoMotorNotForSale(uint _cryptoMotorId) {
1061         require(cryptoMotorToSale[_cryptoMotorId].exists == false, "The car is on auction");
1062         _;
1063     }
1064 
1065     function setOwnerCut(uint16 _ownerCutPercentage) public onlyOwner {
1066         ownerCutPercentage = _ownerCutPercentage;
1067     }
1068 
1069     function setDesignerCut(uint16 _designerCutPercentage) public onlyOwner {
1070         designerCutPercentage = _designerCutPercentage;
1071     }
1072 
1073     function sendGift(uint _cryptoMotorId, address _account) public cryptoMotorNotForSale(_cryptoMotorId) {
1074         require(token.isApprovedForAll(msg.sender, address(this)), "This contract needs approval from the owner to operate with his cars");
1075         require(token.ownerOf(_cryptoMotorId) == msg.sender, "Only the owner can send the car as a gift");
1076         token.safeTransferFrom(msg.sender, _account, _cryptoMotorId);
1077         emit CryptoMotorGift(_cryptoMotorId, msg.sender, _account);
1078     }
1079 
1080     // Auction management methods
1081     function createSale(uint _cryptoMotorId, uint _startPrice, uint _endPrice, uint _duration) public cryptoMotorNotForSale(_cryptoMotorId) {
1082         require(token.isApprovedForAll(msg.sender, address(this)), "This contract needs approval from the owner to operate with his cars");
1083         require(token.ownerOf(_cryptoMotorId) == msg.sender, "Only the owner can create an auction for the car");
1084 
1085         if (_startPrice > _endPrice) {
1086             require(_endPrice >= 10000000000000, "Minimum end price must be above 10000000000000 wei");
1087         } else {
1088             require(_startPrice >= 10000000000000, "Minimum start price must be above 10000000000000 wei");
1089         }
1090 
1091         if (_duration != 0 || _startPrice != _endPrice) {
1092             require(_duration >= 86400 && _duration <= 7776000, "Auction duration must be between 1 and 90 days");
1093         }
1094 
1095         Sale storage sale = cryptoMotorToSale[_cryptoMotorId];
1096         sale.seller = msg.sender;
1097         sale.cryptoMotorId = _cryptoMotorId;
1098         sale.startPrice = _startPrice;
1099         sale.endPrice = _endPrice;
1100         sale.startBlock = block.number;
1101         sale.endBlock = block.number + (_duration / SECONDS_PER_BLOCK);
1102         sale.duration = _duration;
1103         sale.exists = true;
1104 
1105         emit CryptoMotorForSale(_cryptoMotorId, _startPrice, _endPrice, _duration, msg.sender);
1106     }
1107 
1108     function buy(uint _cryptoMotorId) public payable cryptoMotorForSale(_cryptoMotorId) {
1109         Sale storage sale = cryptoMotorToSale[_cryptoMotorId];
1110         
1111         require(msg.sender != sale.seller, "Cant bid on your own sale");
1112 
1113         if (sale.duration != 0) {
1114             require(block.number > sale.startBlock && block.number < sale.endBlock, "Sale has finished already");
1115         }
1116 
1117         uint256 price = _currentPrice(sale);
1118         address seller = sale.seller;
1119 
1120         require(msg.value >= price, "Ether sent is not enough for the current price");
1121         
1122         uint256 sellerCut = msg.value;
1123 
1124         delete cryptoMotorToSale[_cryptoMotorId];
1125 
1126         if (sale.startPrice == sale.endPrice && msg.value > price) {
1127             uint refund = msg.value - price;
1128             sellerCut = price;
1129             msg.sender.transfer(refund);
1130         }
1131 
1132         if (seller == owner()) {
1133             address designerWallet = token.getDesignerWallet(_cryptoMotorId);
1134             uint256 designerCut = sellerCut * designerCutPercentage / 10000;
1135             designerWallet.transfer(designerCut);
1136         } else {
1137             uint256 ownerCut = sellerCut * ownerCutPercentage / 10000;
1138             sellerCut = sellerCut - ownerCut;
1139             seller.transfer(sellerCut);
1140         }
1141 
1142         token.safeTransferFrom(seller, msg.sender, _cryptoMotorId);
1143         
1144         emit CryptoMotorSold(_cryptoMotorId, msg.value, seller, msg.sender);
1145     }
1146 
1147     function _currentPrice(Sale storage _sale) internal view returns (uint256) {
1148         if (_sale.startPrice == _sale.endPrice) {
1149             return _sale.startPrice;
1150         }
1151 
1152         uint256 secondsPassed = 0;
1153 
1154         if (block.number > _sale.startBlock) {
1155             secondsPassed = (block.number - _sale.startBlock) * SECONDS_PER_BLOCK;
1156         }
1157 
1158         int256 priceChange = (int256(_sale.endPrice) - int256(_sale.startPrice)) * int256(secondsPassed) / int256(_sale.duration);
1159         
1160         return uint256(int256(_sale.startPrice) + priceChange);
1161     }
1162 
1163     function getCurrentPrice(uint _cryptoMotorId) public cryptoMotorForSale(_cryptoMotorId) view returns (uint256) {
1164         return _currentPrice(cryptoMotorToSale[_cryptoMotorId]);
1165     }
1166 
1167     function finishSale(uint _cryptoMotorId) public cryptoMotorForSale(_cryptoMotorId) {
1168         require(token.ownerOf(_cryptoMotorId) == msg.sender, "Only the owner can finish the sale");
1169         Sale memory sale = cryptoMotorToSale[_cryptoMotorId];
1170         require(block.number > sale.endBlock, "Sale has not finished yet");
1171         delete cryptoMotorToSale[_cryptoMotorId];
1172         emit CryptoMotorSaleFinished(_cryptoMotorId, msg.sender);
1173     }
1174 
1175     function cancelSale(uint _cryptoMotorId) public cryptoMotorForSale(_cryptoMotorId) {
1176         require(token.ownerOf(_cryptoMotorId) == msg.sender, "Only the owner can cancel the sale");
1177         Sale memory sale = cryptoMotorToSale[_cryptoMotorId];
1178         require(block.number > sale.startBlock && block.number < sale.endBlock, "Sale has finished already");
1179         delete cryptoMotorToSale[_cryptoMotorId];
1180         emit CryptoMotorSaleCancelled(_cryptoMotorId, msg.sender);
1181     }
1182 
1183     function withdraw() external onlyOwner {
1184         msg.sender.transfer(address(this).balance);
1185     }
1186 
1187     // ONLY FOR TESTING PURPOSES
1188     function _changeStartBlock(uint _cryptoMotorId, uint _startBlock) public onlyOwner {
1189         Sale storage sale = cryptoMotorToSale[_cryptoMotorId];
1190         sale.startBlock = _startBlock;
1191     }
1192     
1193     function _changeEndBlock(uint _cryptoMotorId, uint _endBlock) public onlyOwner {
1194         Sale storage sale = cryptoMotorToSale[_cryptoMotorId];
1195         sale.endBlock = _endBlock;
1196     }
1197     // ONLY FOR TESTING PURPOSES
1198 }