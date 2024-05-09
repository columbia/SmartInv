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
77 /**
78  * @title IERC165
79  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
80  */
81 interface IERC165 {
82 
83   /**
84    * @notice Query if a contract implements an interface
85    * @param interfaceId The interface identifier, as specified in ERC-165
86    * @dev Interface identification is specified in ERC-165. This function
87    * uses less than 30,000 gas.
88    */
89   function supportsInterface(bytes4 interfaceId)
90     external
91     view
92     returns (bool);
93 }
94 
95 /**
96  * @title ERC721 Non-Fungible Token Standard basic interface
97  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
98  */
99 contract IERC721 is IERC165 {
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 indexed tokenId
105   );
106   event Approval(
107     address indexed owner,
108     address indexed approved,
109     uint256 indexed tokenId
110   );
111   event ApprovalForAll(
112     address indexed owner,
113     address indexed operator,
114     bool approved
115   );
116 
117   function balanceOf(address owner) public view returns (uint256 balance);
118   function ownerOf(uint256 tokenId) public view returns (address owner);
119 
120   function approve(address to, uint256 tokenId) public;
121   function getApproved(uint256 tokenId)
122     public view returns (address operator);
123 
124   function setApprovalForAll(address operator, bool _approved) public;
125   function isApprovedForAll(address owner, address operator)
126     public view returns (bool);
127 
128   function transferFrom(address from, address to, uint256 tokenId) public;
129   function safeTransferFrom(address from, address to, uint256 tokenId)
130     public;
131 
132   function safeTransferFrom(
133     address from,
134     address to,
135     uint256 tokenId,
136     bytes data
137   )
138     public;
139 }
140 
141 /**
142  * @title ERC721 token receiver interface
143  * @dev Interface for any contract that wants to support safeTransfers
144  * from ERC721 asset contracts.
145  */
146 contract IERC721Receiver {
147   /**
148    * @notice Handle the receipt of an NFT
149    * @dev The ERC721 smart contract calls this function on the recipient
150    * after a `safeTransfer`. This function MUST return the function selector,
151    * otherwise the caller will revert the transaction. The selector to be
152    * returned can be obtained as `this.onERC721Received.selector`. This
153    * function MAY throw to revert and reject the transfer.
154    * Note: the ERC721 contract address is always the message sender.
155    * @param operator The address which called `safeTransferFrom` function
156    * @param from The address which previously owned the token
157    * @param tokenId The NFT identifier which is being transferred
158    * @param data Additional data with no specified format
159    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
160    */
161   function onERC721Received(
162     address operator,
163     address from,
164     uint256 tokenId,
165     bytes data
166   )
167     public
168     returns(bytes4);
169 }
170 
171 /**
172  * @title SafeMath
173  * @dev Math operations with safety checks that revert on error
174  */
175 library SafeMath {
176 
177   /**
178   * @dev Multiplies two numbers, reverts on overflow.
179   */
180   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182     // benefit is lost if 'b' is also tested.
183     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
184     if (a == 0) {
185       return 0;
186     }
187 
188     uint256 c = a * b;
189     require(c / a == b);
190 
191     return c;
192   }
193 
194   /**
195   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
196   */
197   function div(uint256 a, uint256 b) internal pure returns (uint256) {
198     require(b > 0); // Solidity only automatically asserts when dividing by 0
199     uint256 c = a / b;
200     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202     return c;
203   }
204 
205   /**
206   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
207   */
208   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209     require(b <= a);
210     uint256 c = a - b;
211 
212     return c;
213   }
214 
215   /**
216   * @dev Adds two numbers, reverts on overflow.
217   */
218   function add(uint256 a, uint256 b) internal pure returns (uint256) {
219     uint256 c = a + b;
220     require(c >= a);
221 
222     return c;
223   }
224 
225   /**
226   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
227   * reverts when dividing by zero.
228   */
229   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230     require(b != 0);
231     return a % b;
232   }
233 }
234 
235 /**
236  * Utility library of inline functions on addresses
237  */
238 library Address {
239 
240   /**
241    * Returns whether the target address is a contract
242    * @dev This function will return false if invoked during the constructor of a contract,
243    * as the code is not actually created until after the constructor finishes.
244    * @param account address of the account to check
245    * @return whether the target address is a contract
246    */
247   function isContract(address account) internal view returns (bool) {
248     uint256 size;
249     // XXX Currently there is no better way to check if there is a contract in an address
250     // than to check the size of the code at that address.
251     // See https://ethereum.stackexchange.com/a/14016/36603
252     // for more details about how this works.
253     // TODO Check this again before the Serenity release, because all addresses will be
254     // contracts then.
255     // solium-disable-next-line security/no-inline-assembly
256     assembly { size := extcodesize(account) }
257     return size > 0;
258   }
259 
260 }
261 
262 /**
263  * @title ERC165
264  * @author Matt Condon (@shrugs)
265  * @dev Implements ERC165 using a lookup table.
266  */
267 contract ERC165 is IERC165 {
268 
269   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
270   /**
271    * 0x01ffc9a7 ===
272    *   bytes4(keccak256('supportsInterface(bytes4)'))
273    */
274 
275   /**
276    * @dev a mapping of interface id to whether or not it's supported
277    */
278   mapping(bytes4 => bool) private _supportedInterfaces;
279 
280   /**
281    * @dev A contract implementing SupportsInterfaceWithLookup
282    * implement ERC165 itself
283    */
284   constructor()
285     internal
286   {
287     _registerInterface(_InterfaceId_ERC165);
288   }
289 
290   /**
291    * @dev implement supportsInterface(bytes4) using a lookup table
292    */
293   function supportsInterface(bytes4 interfaceId)
294     external
295     view
296     returns (bool)
297   {
298     return _supportedInterfaces[interfaceId];
299   }
300 
301   /**
302    * @dev internal method for registering an interface
303    */
304   function _registerInterface(bytes4 interfaceId)
305     internal
306   {
307     require(interfaceId != 0xffffffff);
308     _supportedInterfaces[interfaceId] = true;
309   }
310 }
311 
312 /**
313  * @title ERC721 Non-Fungible Token Standard basic implementation
314  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
315  */
316 contract ERC721 is ERC165, IERC721 {
317 
318   using SafeMath for uint256;
319   using Address for address;
320 
321   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
322   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
323   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
324 
325   // Mapping from token ID to owner
326   mapping (uint256 => address) private _tokenOwner;
327 
328   // Mapping from token ID to approved address
329   mapping (uint256 => address) private _tokenApprovals;
330 
331   // Mapping from owner to number of owned token
332   mapping (address => uint256) private _ownedTokensCount;
333 
334   // Mapping from owner to operator approvals
335   mapping (address => mapping (address => bool)) private _operatorApprovals;
336 
337   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
338   /*
339    * 0x80ac58cd ===
340    *   bytes4(keccak256('balanceOf(address)')) ^
341    *   bytes4(keccak256('ownerOf(uint256)')) ^
342    *   bytes4(keccak256('approve(address,uint256)')) ^
343    *   bytes4(keccak256('getApproved(uint256)')) ^
344    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
345    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
346    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
347    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
348    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
349    */
350 
351   constructor()
352     public
353   {
354     // register the supported interfaces to conform to ERC721 via ERC165
355     _registerInterface(_InterfaceId_ERC721);
356   }
357 
358   /**
359    * @dev Gets the balance of the specified address
360    * @param owner address to query the balance of
361    * @return uint256 representing the amount owned by the passed address
362    */
363   function balanceOf(address owner) public view returns (uint256) {
364     require(owner != address(0));
365     return _ownedTokensCount[owner];
366   }
367 
368   /**
369    * @dev Gets the owner of the specified token ID
370    * @param tokenId uint256 ID of the token to query the owner of
371    * @return owner address currently marked as the owner of the given token ID
372    */
373   function ownerOf(uint256 tokenId) public view returns (address) {
374     address owner = _tokenOwner[tokenId];
375     require(owner != address(0));
376     return owner;
377   }
378 
379   /**
380    * @dev Approves another address to transfer the given token ID
381    * The zero address indicates there is no approved address.
382    * There can only be one approved address per token at a given time.
383    * Can only be called by the token owner or an approved operator.
384    * @param to address to be approved for the given token ID
385    * @param tokenId uint256 ID of the token to be approved
386    */
387   function approve(address to, uint256 tokenId) public {
388     address owner = ownerOf(tokenId);
389     require(to != owner);
390     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
391 
392     _tokenApprovals[tokenId] = to;
393     emit Approval(owner, to, tokenId);
394   }
395 
396   /**
397    * @dev Gets the approved address for a token ID, or zero if no address set
398    * Reverts if the token ID does not exist.
399    * @param tokenId uint256 ID of the token to query the approval of
400    * @return address currently approved for the given token ID
401    */
402   function getApproved(uint256 tokenId) public view returns (address) {
403     require(_exists(tokenId));
404     return _tokenApprovals[tokenId];
405   }
406 
407   /**
408    * @dev Sets or unsets the approval of a given operator
409    * An operator is allowed to transfer all tokens of the sender on their behalf
410    * @param to operator address to set the approval
411    * @param approved representing the status of the approval to be set
412    */
413   function setApprovalForAll(address to, bool approved) public {
414     require(to != msg.sender);
415     _operatorApprovals[msg.sender][to] = approved;
416     emit ApprovalForAll(msg.sender, to, approved);
417   }
418 
419   /**
420    * @dev Tells whether an operator is approved by a given owner
421    * @param owner owner address which you want to query the approval of
422    * @param operator operator address which you want to query the approval of
423    * @return bool whether the given operator is approved by the given owner
424    */
425   function isApprovedForAll(
426     address owner,
427     address operator
428   )
429     public
430     view
431     returns (bool)
432   {
433     return _operatorApprovals[owner][operator];
434   }
435 
436   /**
437    * @dev Transfers the ownership of a given token ID to another address
438    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
439    * Requires the msg sender to be the owner, approved, or operator
440    * @param from current owner of the token
441    * @param to address to receive the ownership of the given token ID
442    * @param tokenId uint256 ID of the token to be transferred
443   */
444   function transferFrom(
445     address from,
446     address to,
447     uint256 tokenId
448   )
449     public
450   {
451     require(_isApprovedOrOwner(msg.sender, tokenId));
452     require(to != address(0));
453 
454     _clearApproval(from, tokenId);
455     _removeTokenFrom(from, tokenId);
456     _addTokenTo(to, tokenId);
457 
458     emit Transfer(from, to, tokenId);
459   }
460 
461   /**
462    * @dev Safely transfers the ownership of a given token ID to another address
463    * If the target address is a contract, it must implement `onERC721Received`,
464    * which is called upon a safe transfer, and return the magic value
465    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
466    * the transfer is reverted.
467    *
468    * Requires the msg sender to be the owner, approved, or operator
469    * @param from current owner of the token
470    * @param to address to receive the ownership of the given token ID
471    * @param tokenId uint256 ID of the token to be transferred
472   */
473   function safeTransferFrom(
474     address from,
475     address to,
476     uint256 tokenId
477   )
478     public
479   {
480     // solium-disable-next-line arg-overflow
481     safeTransferFrom(from, to, tokenId, "");
482   }
483 
484   /**
485    * @dev Safely transfers the ownership of a given token ID to another address
486    * If the target address is a contract, it must implement `onERC721Received`,
487    * which is called upon a safe transfer, and return the magic value
488    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
489    * the transfer is reverted.
490    * Requires the msg sender to be the owner, approved, or operator
491    * @param from current owner of the token
492    * @param to address to receive the ownership of the given token ID
493    * @param tokenId uint256 ID of the token to be transferred
494    * @param _data bytes data to send along with a safe transfer check
495    */
496   function safeTransferFrom(
497     address from,
498     address to,
499     uint256 tokenId,
500     bytes _data
501   )
502     public
503   {
504     transferFrom(from, to, tokenId);
505     // solium-disable-next-line arg-overflow
506     require(_checkOnERC721Received(from, to, tokenId, _data));
507   }
508 
509   /**
510    * @dev Returns whether the specified token exists
511    * @param tokenId uint256 ID of the token to query the existence of
512    * @return whether the token exists
513    */
514   function _exists(uint256 tokenId) internal view returns (bool) {
515     address owner = _tokenOwner[tokenId];
516     return owner != address(0);
517   }
518 
519   /**
520    * @dev Returns whether the given spender can transfer a given token ID
521    * @param spender address of the spender to query
522    * @param tokenId uint256 ID of the token to be transferred
523    * @return bool whether the msg.sender is approved for the given token ID,
524    *  is an operator of the owner, or is the owner of the token
525    */
526   function _isApprovedOrOwner(
527     address spender,
528     uint256 tokenId
529   )
530     internal
531     view
532     returns (bool)
533   {
534     address owner = ownerOf(tokenId);
535     // Disable solium check because of
536     // https://github.com/duaraghav8/Solium/issues/175
537     // solium-disable-next-line operator-whitespace
538     return (
539       spender == owner ||
540       getApproved(tokenId) == spender ||
541       isApprovedForAll(owner, spender)
542     );
543   }
544 
545   /**
546    * @dev Internal function to mint a new token
547    * Reverts if the given token ID already exists
548    * @param to The address that will own the minted token
549    * @param tokenId uint256 ID of the token to be minted by the msg.sender
550    */
551   function _mint(address to, uint256 tokenId) internal {
552     require(to != address(0));
553     _addTokenTo(to, tokenId);
554     emit Transfer(address(0), to, tokenId);
555   }
556 
557   /**
558    * @dev Internal function to burn a specific token
559    * Reverts if the token does not exist
560    * @param tokenId uint256 ID of the token being burned by the msg.sender
561    */
562   function _burn(address owner, uint256 tokenId) internal {
563     _clearApproval(owner, tokenId);
564     _removeTokenFrom(owner, tokenId);
565     emit Transfer(owner, address(0), tokenId);
566   }
567 
568   /**
569    * @dev Internal function to add a token ID to the list of a given address
570    * Note that this function is left internal to make ERC721Enumerable possible, but is not
571    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
572    * @param to address representing the new owner of the given token ID
573    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
574    */
575   function _addTokenTo(address to, uint256 tokenId) internal {
576     require(_tokenOwner[tokenId] == address(0));
577     _tokenOwner[tokenId] = to;
578     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
579   }
580 
581   /**
582    * @dev Internal function to remove a token ID from the list of a given address
583    * Note that this function is left internal to make ERC721Enumerable possible, but is not
584    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
585    * and doesn't clear approvals.
586    * @param from address representing the previous owner of the given token ID
587    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
588    */
589   function _removeTokenFrom(address from, uint256 tokenId) internal {
590     require(ownerOf(tokenId) == from);
591     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
592     _tokenOwner[tokenId] = address(0);
593   }
594 
595   /**
596    * @dev Internal function to invoke `onERC721Received` on a target address
597    * The call is not executed if the target address is not a contract
598    * @param from address representing the previous owner of the given token ID
599    * @param to target address that will receive the tokens
600    * @param tokenId uint256 ID of the token to be transferred
601    * @param _data bytes optional data to send along with the call
602    * @return whether the call correctly returned the expected magic value
603    */
604   function _checkOnERC721Received(
605     address from,
606     address to,
607     uint256 tokenId,
608     bytes _data
609   )
610     internal
611     returns (bool)
612   {
613     if (!to.isContract()) {
614       return true;
615     }
616     bytes4 retval = IERC721Receiver(to).onERC721Received(
617       msg.sender, from, tokenId, _data);
618     return (retval == _ERC721_RECEIVED);
619   }
620 
621   /**
622    * @dev Private function to clear current approval of a given token ID
623    * Reverts if the given address is not indeed the owner of the token
624    * @param owner owner of the token
625    * @param tokenId uint256 ID of the token to be transferred
626    */
627   function _clearApproval(address owner, uint256 tokenId) private {
628     require(ownerOf(tokenId) == owner);
629     if (_tokenApprovals[tokenId] != address(0)) {
630       _tokenApprovals[tokenId] = address(0);
631     }
632   }
633 }
634 
635 /**
636  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
637  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
638  */
639 contract IERC721Enumerable is IERC721 {
640   function totalSupply() public view returns (uint256);
641   function tokenOfOwnerByIndex(
642     address owner,
643     uint256 index
644   )
645     public
646     view
647     returns (uint256 tokenId);
648 
649   function tokenByIndex(uint256 index) public view returns (uint256);
650 }
651 
652 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
653   // Mapping from owner to list of owned token IDs
654   mapping(address => uint256[]) private _ownedTokens;
655 
656   // Mapping from token ID to index of the owner tokens list
657   mapping(uint256 => uint256) private _ownedTokensIndex;
658 
659   // Array with all token ids, used for enumeration
660   uint256[] private _allTokens;
661 
662   // Mapping from token id to position in the allTokens array
663   mapping(uint256 => uint256) private _allTokensIndex;
664 
665   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
666   /**
667    * 0x780e9d63 ===
668    *   bytes4(keccak256('totalSupply()')) ^
669    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
670    *   bytes4(keccak256('tokenByIndex(uint256)'))
671    */
672 
673   /**
674    * @dev Constructor function
675    */
676   constructor() public {
677     // register the supported interface to conform to ERC721 via ERC165
678     _registerInterface(_InterfaceId_ERC721Enumerable);
679   }
680 
681   /**
682    * @dev Gets the token ID at a given index of the tokens list of the requested owner
683    * @param owner address owning the tokens list to be accessed
684    * @param index uint256 representing the index to be accessed of the requested tokens list
685    * @return uint256 token ID at the given index of the tokens list owned by the requested address
686    */
687   function tokenOfOwnerByIndex(
688     address owner,
689     uint256 index
690   )
691     public
692     view
693     returns (uint256)
694   {
695     require(index < balanceOf(owner));
696     return _ownedTokens[owner][index];
697   }
698 
699   /**
700    * @dev Gets the total amount of tokens stored by the contract
701    * @return uint256 representing the total amount of tokens
702    */
703   function totalSupply() public view returns (uint256) {
704     return _allTokens.length;
705   }
706 
707   /**
708    * @dev Gets the token ID at a given index of all the tokens in this contract
709    * Reverts if the index is greater or equal to the total number of tokens
710    * @param index uint256 representing the index to be accessed of the tokens list
711    * @return uint256 token ID at the given index of the tokens list
712    */
713   function tokenByIndex(uint256 index) public view returns (uint256) {
714     require(index < totalSupply());
715     return _allTokens[index];
716   }
717 
718   /**
719    * @dev Internal function to add a token ID to the list of a given address
720    * This function is internal due to language limitations, see the note in ERC721.sol.
721    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
722    * @param to address representing the new owner of the given token ID
723    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
724    */
725   function _addTokenTo(address to, uint256 tokenId) internal {
726     super._addTokenTo(to, tokenId);
727     uint256 length = _ownedTokens[to].length;
728     _ownedTokens[to].push(tokenId);
729     _ownedTokensIndex[tokenId] = length;
730   }
731 
732   /**
733    * @dev Internal function to remove a token ID from the list of a given address
734    * This function is internal due to language limitations, see the note in ERC721.sol.
735    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
736    * and doesn't clear approvals.
737    * @param from address representing the previous owner of the given token ID
738    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
739    */
740   function _removeTokenFrom(address from, uint256 tokenId) internal {
741     super._removeTokenFrom(from, tokenId);
742 
743     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
744     // then delete the last slot.
745     uint256 tokenIndex = _ownedTokensIndex[tokenId];
746     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
747     uint256 lastToken = _ownedTokens[from][lastTokenIndex];
748 
749     _ownedTokens[from][tokenIndex] = lastToken;
750     // This also deletes the contents at the last position of the array
751     _ownedTokens[from].length--;
752 
753     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
754     // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
755     // the lastToken to the first position, and then dropping the element placed in the last position of the list
756 
757     _ownedTokensIndex[tokenId] = 0;
758     _ownedTokensIndex[lastToken] = tokenIndex;
759   }
760 
761   /**
762    * @dev Internal function to mint a new token
763    * Reverts if the given token ID already exists
764    * @param to address the beneficiary that will own the minted token
765    * @param tokenId uint256 ID of the token to be minted by the msg.sender
766    */
767   function _mint(address to, uint256 tokenId) internal {
768     super._mint(to, tokenId);
769 
770     _allTokensIndex[tokenId] = _allTokens.length;
771     _allTokens.push(tokenId);
772   }
773 
774   /**
775    * @dev Internal function to burn a specific token
776    * Reverts if the token does not exist
777    * @param owner owner of the token to burn
778    * @param tokenId uint256 ID of the token being burned by the msg.sender
779    */
780   function _burn(address owner, uint256 tokenId) internal {
781     super._burn(owner, tokenId);
782 
783     // Reorg all tokens array
784     uint256 tokenIndex = _allTokensIndex[tokenId];
785     uint256 lastTokenIndex = _allTokens.length.sub(1);
786     uint256 lastToken = _allTokens[lastTokenIndex];
787 
788     _allTokens[tokenIndex] = lastToken;
789     _allTokens[lastTokenIndex] = 0;
790 
791     _allTokens.length--;
792     _allTokensIndex[tokenId] = 0;
793     _allTokensIndex[lastToken] = tokenIndex;
794   }
795 }
796 
797 /**
798  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
799  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
800  */
801 contract IERC721Metadata is IERC721 {
802   function name() external view returns (string);
803   function symbol() external view returns (string);
804   function tokenURI(uint256 tokenId) external view returns (string);
805 }
806 
807 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
808   // Token name
809   string private _name;
810 
811   // Token symbol
812   string private _symbol;
813 
814   // Optional mapping for token URIs
815   mapping(uint256 => string) private _tokenURIs;
816 
817   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
818   /**
819    * 0x5b5e139f ===
820    *   bytes4(keccak256('name()')) ^
821    *   bytes4(keccak256('symbol()')) ^
822    *   bytes4(keccak256('tokenURI(uint256)'))
823    */
824 
825   /**
826    * @dev Constructor function
827    */
828   constructor(string name, string symbol) public {
829     _name = name;
830     _symbol = symbol;
831 
832     // register the supported interfaces to conform to ERC721 via ERC165
833     _registerInterface(InterfaceId_ERC721Metadata);
834   }
835 
836   /**
837    * @dev Gets the token name
838    * @return string representing the token name
839    */
840   function name() external view returns (string) {
841     return _name;
842   }
843 
844   /**
845    * @dev Gets the token symbol
846    * @return string representing the token symbol
847    */
848   function symbol() external view returns (string) {
849     return _symbol;
850   }
851 
852   /**
853    * @dev Returns an URI for a given token ID
854    * Throws if the token ID does not exist. May return an empty string.
855    * @param tokenId uint256 ID of the token to query
856    */
857   function tokenURI(uint256 tokenId) external view returns (string) {
858     require(_exists(tokenId));
859     return _tokenURIs[tokenId];
860   }
861 
862   /**
863    * @dev Internal function to set the token URI for a given token
864    * Reverts if the token ID does not exist
865    * @param tokenId uint256 ID of the token to set its URI
866    * @param uri string URI to assign
867    */
868   function _setTokenURI(uint256 tokenId, string uri) internal {
869     require(_exists(tokenId));
870     _tokenURIs[tokenId] = uri;
871   }
872 
873   /**
874    * @dev Internal function to burn a specific token
875    * Reverts if the token does not exist
876    * @param owner owner of the token to burn
877    * @param tokenId uint256 ID of the token being burned by the msg.sender
878    */
879   function _burn(address owner, uint256 tokenId) internal {
880     super._burn(owner, tokenId);
881 
882     // Clear metadata (if any)
883     if (bytes(_tokenURIs[tokenId]).length != 0) {
884       delete _tokenURIs[tokenId];
885     }
886   }
887 }
888 
889 /**
890  * @title Full ERC721 Token
891  * This implementation includes all the required and some optional functionality of the ERC721 standard
892  * Moreover, it includes approve all functionality using operator terminology
893  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
894  */
895 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
896   constructor(string name, string symbol) ERC721Metadata(name, symbol)
897     public
898   {
899   }
900 }
901 
902 contract CryptoMotors is Ownable, ERC721Full {
903     string public name = "CryptoMotors";
904     string public symbol = "CM";
905     
906     event CryptoMotorCreated(address receiver, uint cryptoMotorId, string uri);
907     event CryptoMotorTransferred(address from, address to, uint cryptoMotorId, string uri);
908     event CryptoMotorUriChanged(uint cryptoMotorId, string uri);
909     event CryptoMotorDnaChanged(uint cryptoMotorId, string dna);
910     // Structs
911 
912     struct CryptoMotor {
913         string dna;
914         uint32 level;
915         uint32 readyTime;
916         uint32 winCount;
917         uint32 lossCount;
918         address designerWallet;
919     }
920 
921     CryptoMotor[] public cryptoMotors;
922 
923     constructor() ERC721Full(name, symbol) public { }
924 
925     // Methods
926     function create(address owner, string _uri, string _dna, address _designerWallet) public onlyOwner returns (uint) {
927         uint id = cryptoMotors.push(CryptoMotor(_dna, 1, uint32(now + 1 days), 0, 0, _designerWallet)) - 1;
928         _mint(owner, id);
929         _setTokenURI(id, _uri);
930         emit CryptoMotorCreated(owner, id, _uri);
931         return id;
932     }
933 
934     function setTokenURI(uint256 _cryptoMotorId, string _uri) public onlyOwner {
935         _setTokenURI(_cryptoMotorId, _uri);
936         emit CryptoMotorUriChanged(_cryptoMotorId, _uri);
937     }
938     
939     function setCryptoMotorDna(uint _cryptoMotorId, string _dna) public onlyOwner {
940         CryptoMotor storage cm = cryptoMotors[_cryptoMotorId];
941         cm.dna = _dna;
942         emit CryptoMotorDnaChanged(_cryptoMotorId, _dna);
943     }
944 
945     function getDesignerWallet(uint256 _cryptoMotorId) public view returns (address) {
946         return cryptoMotors[_cryptoMotorId].designerWallet;
947     }
948 
949     function setApprovalsForAll(address[] _addresses, bool approved) public {
950         for(uint i; i < _addresses.length; i++) {
951             setApprovalForAll(_addresses[i], approved);
952         }
953     }
954 
955     function setAttributes(uint256 _cryptoMotorId, uint32 _level, uint32 _readyTime, uint32 _winCount, uint32 _lossCount) public onlyOwner {
956         CryptoMotor storage cm = cryptoMotors[_cryptoMotorId];
957         cm.level = _level;
958         cm.readyTime = _readyTime;
959         cm.winCount = _winCount;
960         cm.lossCount = _lossCount;
961     }
962 
963     function withdraw() external onlyOwner {
964         msg.sender.transfer(address(this).balance);
965     }
966 }