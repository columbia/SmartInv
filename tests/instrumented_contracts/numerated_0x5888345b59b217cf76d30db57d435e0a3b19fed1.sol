1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     _owner = msg.sender;
27   }
28 
29   /**
30    * @return the address of the owner.
31    */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45    * @return true if `msg.sender` is the owner of the contract.
46    */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(_owner);
59     _owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
82 
83 /**
84  * @title IERC165
85  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
86  */
87 interface IERC165 {
88 
89   /**
90    * @notice Query if a contract implements an interface
91    * @param interfaceId The interface identifier, as specified in ERC-165
92    * @dev Interface identification is specified in ERC-165. This function
93    * uses less than 30,000 gas.
94    */
95   function supportsInterface(bytes4 interfaceId)
96     external
97     view
98     returns (bool);
99 }
100 
101 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
102 
103 /**
104  * @title ERC721 Non-Fungible Token Standard basic interface
105  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
106  */
107 contract IERC721 is IERC165 {
108 
109   event Transfer(
110     address indexed from,
111     address indexed to,
112     uint256 indexed tokenId
113   );
114   event Approval(
115     address indexed owner,
116     address indexed approved,
117     uint256 indexed tokenId
118   );
119   event ApprovalForAll(
120     address indexed owner,
121     address indexed operator,
122     bool approved
123   );
124 
125   function balanceOf(address owner) public view returns (uint256 balance);
126   function ownerOf(uint256 tokenId) public view returns (address owner);
127 
128   function approve(address to, uint256 tokenId) public;
129   function getApproved(uint256 tokenId)
130     public view returns (address operator);
131 
132   function setApprovalForAll(address operator, bool _approved) public;
133   function isApprovedForAll(address owner, address operator)
134     public view returns (bool);
135 
136   function transferFrom(address from, address to, uint256 tokenId) public;
137   function safeTransferFrom(address from, address to, uint256 tokenId)
138     public;
139 
140   function safeTransferFrom(
141     address from,
142     address to,
143     uint256 tokenId,
144     bytes data
145   )
146     public;
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
150 
151 /**
152  * @title ERC721 token receiver interface
153  * @dev Interface for any contract that wants to support safeTransfers
154  * from ERC721 asset contracts.
155  */
156 contract IERC721Receiver {
157   /**
158    * @notice Handle the receipt of an NFT
159    * @dev The ERC721 smart contract calls this function on the recipient
160    * after a `safeTransfer`. This function MUST return the function selector,
161    * otherwise the caller will revert the transaction. The selector to be
162    * returned can be obtained as `this.onERC721Received.selector`. This
163    * function MAY throw to revert and reject the transfer.
164    * Note: the ERC721 contract address is always the message sender.
165    * @param operator The address which called `safeTransferFrom` function
166    * @param from The address which previously owned the token
167    * @param tokenId The NFT identifier which is being transferred
168    * @param data Additional data with no specified format
169    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
170    */
171   function onERC721Received(
172     address operator,
173     address from,
174     uint256 tokenId,
175     bytes data
176   )
177     public
178     returns(bytes4);
179 }
180 
181 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
182 
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that revert on error
186  */
187 library SafeMath {
188 
189   /**
190   * @dev Multiplies two numbers, reverts on overflow.
191   */
192   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194     // benefit is lost if 'b' is also tested.
195     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
196     if (a == 0) {
197       return 0;
198     }
199 
200     uint256 c = a * b;
201     require(c / a == b);
202 
203     return c;
204   }
205 
206   /**
207   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
208   */
209   function div(uint256 a, uint256 b) internal pure returns (uint256) {
210     require(b > 0); // Solidity only automatically asserts when dividing by 0
211     uint256 c = a / b;
212     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214     return c;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221     require(b <= a);
222     uint256 c = a - b;
223 
224     return c;
225   }
226 
227   /**
228   * @dev Adds two numbers, reverts on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256) {
231     uint256 c = a + b;
232     require(c >= a);
233 
234     return c;
235   }
236 
237   /**
238   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
239   * reverts when dividing by zero.
240   */
241   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242     require(b != 0);
243     return a % b;
244   }
245 }
246 
247 // File: openzeppelin-solidity/contracts/utils/Address.sol
248 
249 /**
250  * Utility library of inline functions on addresses
251  */
252 library Address {
253 
254   /**
255    * Returns whether the target address is a contract
256    * @dev This function will return false if invoked during the constructor of a contract,
257    * as the code is not actually created until after the constructor finishes.
258    * @param account address of the account to check
259    * @return whether the target address is a contract
260    */
261   function isContract(address account) internal view returns (bool) {
262     uint256 size;
263     // XXX Currently there is no better way to check if there is a contract in an address
264     // than to check the size of the code at that address.
265     // See https://ethereum.stackexchange.com/a/14016/36603
266     // for more details about how this works.
267     // TODO Check this again before the Serenity release, because all addresses will be
268     // contracts then.
269     // solium-disable-next-line security/no-inline-assembly
270     assembly { size := extcodesize(account) }
271     return size > 0;
272   }
273 
274 }
275 
276 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
277 
278 /**
279  * @title ERC165
280  * @author Matt Condon (@shrugs)
281  * @dev Implements ERC165 using a lookup table.
282  */
283 contract ERC165 is IERC165 {
284 
285   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
286   /**
287    * 0x01ffc9a7 ===
288    *   bytes4(keccak256('supportsInterface(bytes4)'))
289    */
290 
291   /**
292    * @dev a mapping of interface id to whether or not it's supported
293    */
294   mapping(bytes4 => bool) internal _supportedInterfaces;
295 
296   /**
297    * @dev A contract implementing SupportsInterfaceWithLookup
298    * implement ERC165 itself
299    */
300   constructor()
301     public
302   {
303     _registerInterface(_InterfaceId_ERC165);
304   }
305 
306   /**
307    * @dev implement supportsInterface(bytes4) using a lookup table
308    */
309   function supportsInterface(bytes4 interfaceId)
310     external
311     view
312     returns (bool)
313   {
314     return _supportedInterfaces[interfaceId];
315   }
316 
317   /**
318    * @dev private method for registering an interface
319    */
320   function _registerInterface(bytes4 interfaceId)
321     internal
322   {
323     require(interfaceId != 0xffffffff);
324     _supportedInterfaces[interfaceId] = true;
325   }
326 }
327 
328 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
329 
330 /**
331  * @title ERC721 Non-Fungible Token Standard basic implementation
332  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
333  */
334 contract ERC721 is ERC165, IERC721 {
335 
336   using SafeMath for uint256;
337   using Address for address;
338 
339   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
340   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
341   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
342 
343   // Mapping from token ID to owner
344   mapping (uint256 => address) private _tokenOwner;
345 
346   // Mapping from token ID to approved address
347   mapping (uint256 => address) private _tokenApprovals;
348 
349   // Mapping from owner to number of owned token
350   mapping (address => uint256) private _ownedTokensCount;
351 
352   // Mapping from owner to operator approvals
353   mapping (address => mapping (address => bool)) private _operatorApprovals;
354 
355   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
356   /*
357    * 0x80ac58cd ===
358    *   bytes4(keccak256('balanceOf(address)')) ^
359    *   bytes4(keccak256('ownerOf(uint256)')) ^
360    *   bytes4(keccak256('approve(address,uint256)')) ^
361    *   bytes4(keccak256('getApproved(uint256)')) ^
362    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
363    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
364    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
365    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
366    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
367    */
368 
369   constructor()
370     public
371   {
372     // register the supported interfaces to conform to ERC721 via ERC165
373     _registerInterface(_InterfaceId_ERC721);
374   }
375 
376   /**
377    * @dev Gets the balance of the specified address
378    * @param owner address to query the balance of
379    * @return uint256 representing the amount owned by the passed address
380    */
381   function balanceOf(address owner) public view returns (uint256) {
382     require(owner != address(0));
383     return _ownedTokensCount[owner];
384   }
385 
386   /**
387    * @dev Gets the owner of the specified token ID
388    * @param tokenId uint256 ID of the token to query the owner of
389    * @return owner address currently marked as the owner of the given token ID
390    */
391   function ownerOf(uint256 tokenId) public view returns (address) {
392     address owner = _tokenOwner[tokenId];
393     require(owner != address(0));
394     return owner;
395   }
396 
397   /**
398    * @dev Approves another address to transfer the given token ID
399    * The zero address indicates there is no approved address.
400    * There can only be one approved address per token at a given time.
401    * Can only be called by the token owner or an approved operator.
402    * @param to address to be approved for the given token ID
403    * @param tokenId uint256 ID of the token to be approved
404    */
405   function approve(address to, uint256 tokenId) public {
406     address owner = ownerOf(tokenId);
407     require(to != owner);
408     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
409 
410     _tokenApprovals[tokenId] = to;
411     emit Approval(owner, to, tokenId);
412   }
413 
414   /**
415    * @dev Gets the approved address for a token ID, or zero if no address set
416    * Reverts if the token ID does not exist.
417    * @param tokenId uint256 ID of the token to query the approval of
418    * @return address currently approved for the given token ID
419    */
420   function getApproved(uint256 tokenId) public view returns (address) {
421     require(_exists(tokenId));
422     return _tokenApprovals[tokenId];
423   }
424 
425   /**
426    * @dev Sets or unsets the approval of a given operator
427    * An operator is allowed to transfer all tokens of the sender on their behalf
428    * @param to operator address to set the approval
429    * @param approved representing the status of the approval to be set
430    */
431   function setApprovalForAll(address to, bool approved) public {
432     require(to != msg.sender);
433     _operatorApprovals[msg.sender][to] = approved;
434     emit ApprovalForAll(msg.sender, to, approved);
435   }
436 
437   /**
438    * @dev Tells whether an operator is approved by a given owner
439    * @param owner owner address which you want to query the approval of
440    * @param operator operator address which you want to query the approval of
441    * @return bool whether the given operator is approved by the given owner
442    */
443   function isApprovedForAll(
444     address owner,
445     address operator
446   )
447     public
448     view
449     returns (bool)
450   {
451     return _operatorApprovals[owner][operator];
452   }
453 
454   /**
455    * @dev Transfers the ownership of a given token ID to another address
456    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
457    * Requires the msg sender to be the owner, approved, or operator
458    * @param from current owner of the token
459    * @param to address to receive the ownership of the given token ID
460    * @param tokenId uint256 ID of the token to be transferred
461   */
462   function transferFrom(
463     address from,
464     address to,
465     uint256 tokenId
466   )
467     public
468   {
469     require(_isApprovedOrOwner(msg.sender, tokenId));
470     require(to != address(0));
471 
472     _clearApproval(from, tokenId);
473     _removeTokenFrom(from, tokenId);
474     _addTokenTo(to, tokenId);
475 
476     emit Transfer(from, to, tokenId);
477   }
478 
479   /**
480    * @dev Safely transfers the ownership of a given token ID to another address
481    * If the target address is a contract, it must implement `onERC721Received`,
482    * which is called upon a safe transfer, and return the magic value
483    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
484    * the transfer is reverted.
485    *
486    * Requires the msg sender to be the owner, approved, or operator
487    * @param from current owner of the token
488    * @param to address to receive the ownership of the given token ID
489    * @param tokenId uint256 ID of the token to be transferred
490   */
491   function safeTransferFrom(
492     address from,
493     address to,
494     uint256 tokenId
495   )
496     public
497   {
498     // solium-disable-next-line arg-overflow
499     safeTransferFrom(from, to, tokenId, "");
500   }
501 
502   /**
503    * @dev Safely transfers the ownership of a given token ID to another address
504    * If the target address is a contract, it must implement `onERC721Received`,
505    * which is called upon a safe transfer, and return the magic value
506    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
507    * the transfer is reverted.
508    * Requires the msg sender to be the owner, approved, or operator
509    * @param from current owner of the token
510    * @param to address to receive the ownership of the given token ID
511    * @param tokenId uint256 ID of the token to be transferred
512    * @param _data bytes data to send along with a safe transfer check
513    */
514   function safeTransferFrom(
515     address from,
516     address to,
517     uint256 tokenId,
518     bytes _data
519   )
520     public
521   {
522     transferFrom(from, to, tokenId);
523     // solium-disable-next-line arg-overflow
524     require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
525   }
526 
527   /**
528    * @dev Returns whether the specified token exists
529    * @param tokenId uint256 ID of the token to query the existence of
530    * @return whether the token exists
531    */
532   function _exists(uint256 tokenId) internal view returns (bool) {
533     address owner = _tokenOwner[tokenId];
534     return owner != address(0);
535   }
536 
537   /**
538    * @dev Returns whether the given spender can transfer a given token ID
539    * @param spender address of the spender to query
540    * @param tokenId uint256 ID of the token to be transferred
541    * @return bool whether the msg.sender is approved for the given token ID,
542    *  is an operator of the owner, or is the owner of the token
543    */
544   function _isApprovedOrOwner(
545     address spender,
546     uint256 tokenId
547   )
548     internal
549     view
550     returns (bool)
551   {
552     address owner = ownerOf(tokenId);
553     // Disable solium check because of
554     // https://github.com/duaraghav8/Solium/issues/175
555     // solium-disable-next-line operator-whitespace
556     return (
557       spender == owner ||
558       getApproved(tokenId) == spender ||
559       isApprovedForAll(owner, spender)
560     );
561   }
562 
563   /**
564    * @dev Internal function to mint a new token
565    * Reverts if the given token ID already exists
566    * @param to The address that will own the minted token
567    * @param tokenId uint256 ID of the token to be minted by the msg.sender
568    */
569   function _mint(address to, uint256 tokenId) internal {
570     require(to != address(0));
571     _addTokenTo(to, tokenId);
572     emit Transfer(address(0), to, tokenId);
573   }
574 
575   /**
576    * @dev Internal function to burn a specific token
577    * Reverts if the token does not exist
578    * @param tokenId uint256 ID of the token being burned by the msg.sender
579    */
580   function _burn(address owner, uint256 tokenId) internal {
581     _clearApproval(owner, tokenId);
582     _removeTokenFrom(owner, tokenId);
583     emit Transfer(owner, address(0), tokenId);
584   }
585 
586   /**
587    * @dev Internal function to clear current approval of a given token ID
588    * Reverts if the given address is not indeed the owner of the token
589    * @param owner owner of the token
590    * @param tokenId uint256 ID of the token to be transferred
591    */
592   function _clearApproval(address owner, uint256 tokenId) internal {
593     require(ownerOf(tokenId) == owner);
594     if (_tokenApprovals[tokenId] != address(0)) {
595       _tokenApprovals[tokenId] = address(0);
596     }
597   }
598 
599   /**
600    * @dev Internal function to add a token ID to the list of a given address
601    * @param to address representing the new owner of the given token ID
602    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
603    */
604   function _addTokenTo(address to, uint256 tokenId) internal {
605     require(_tokenOwner[tokenId] == address(0));
606     _tokenOwner[tokenId] = to;
607     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
608   }
609 
610   /**
611    * @dev Internal function to remove a token ID from the list of a given address
612    * @param from address representing the previous owner of the given token ID
613    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
614    */
615   function _removeTokenFrom(address from, uint256 tokenId) internal {
616     require(ownerOf(tokenId) == from);
617     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
618     _tokenOwner[tokenId] = address(0);
619   }
620 
621   /**
622    * @dev Internal function to invoke `onERC721Received` on a target address
623    * The call is not executed if the target address is not a contract
624    * @param from address representing the previous owner of the given token ID
625    * @param to target address that will receive the tokens
626    * @param tokenId uint256 ID of the token to be transferred
627    * @param _data bytes optional data to send along with the call
628    * @return whether the call correctly returned the expected magic value
629    */
630   function _checkAndCallSafeTransfer(
631     address from,
632     address to,
633     uint256 tokenId,
634     bytes _data
635   )
636     internal
637     returns (bool)
638   {
639     if (!to.isContract()) {
640       return true;
641     }
642     bytes4 retval = IERC721Receiver(to).onERC721Received(
643       msg.sender, from, tokenId, _data);
644     return (retval == _ERC721_RECEIVED);
645   }
646 }
647 
648 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
652  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
653  */
654 contract IERC721Metadata is IERC721 {
655   function name() external view returns (string);
656   function symbol() external view returns (string);
657   function tokenURI(uint256 tokenId) public view returns (string);
658 }
659 
660 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
661 
662 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
663   // Token name
664   string internal _name;
665 
666   // Token symbol
667   string internal _symbol;
668 
669   // Optional mapping for token URIs
670   mapping(uint256 => string) private _tokenURIs;
671 
672   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
673   /**
674    * 0x5b5e139f ===
675    *   bytes4(keccak256('name()')) ^
676    *   bytes4(keccak256('symbol()')) ^
677    *   bytes4(keccak256('tokenURI(uint256)'))
678    */
679 
680   /**
681    * @dev Constructor function
682    */
683   constructor(string name, string symbol) public {
684     _name = name;
685     _symbol = symbol;
686 
687     // register the supported interfaces to conform to ERC721 via ERC165
688     _registerInterface(InterfaceId_ERC721Metadata);
689   }
690 
691   /**
692    * @dev Gets the token name
693    * @return string representing the token name
694    */
695   function name() external view returns (string) {
696     return _name;
697   }
698 
699   /**
700    * @dev Gets the token symbol
701    * @return string representing the token symbol
702    */
703   function symbol() external view returns (string) {
704     return _symbol;
705   }
706 
707   /**
708    * @dev Returns an URI for a given token ID
709    * Throws if the token ID does not exist. May return an empty string.
710    * @param tokenId uint256 ID of the token to query
711    */
712   function tokenURI(uint256 tokenId) public view returns (string) {
713     require(_exists(tokenId));
714     return _tokenURIs[tokenId];
715   }
716 
717   /**
718    * @dev Internal function to set the token URI for a given token
719    * Reverts if the token ID does not exist
720    * @param tokenId uint256 ID of the token to set its URI
721    * @param uri string URI to assign
722    */
723   function _setTokenURI(uint256 tokenId, string uri) internal {
724     require(_exists(tokenId));
725     _tokenURIs[tokenId] = uri;
726   }
727 
728   /**
729    * @dev Internal function to burn a specific token
730    * Reverts if the token does not exist
731    * @param owner owner of the token to burn
732    * @param tokenId uint256 ID of the token being burned by the msg.sender
733    */
734   function _burn(address owner, uint256 tokenId) internal {
735     super._burn(owner, tokenId);
736 
737     // Clear metadata (if any)
738     if (bytes(_tokenURIs[tokenId]).length != 0) {
739       delete _tokenURIs[tokenId];
740     }
741   }
742 }
743 
744 // File: contracts/Ijin.sol
745 
746 contract Ijin is Ownable, ERC721, ERC721Metadata {
747     // Ijin struct
748     struct IjinData {
749         uint8 id;
750         uint32 exp;
751         uint8 limitBreakCount;
752         uint48 compressedStatus;
753         uint64 installTimestamp;
754         uint24 accessCount;
755         uint24 trainerId;
756         bool hasDoll;
757     }
758 
759     IjinData[] private ijins;
760 
761     constructor() public ERC721Metadata("HL-Report:Ijin", "IJIN") {
762         ijins.push(IjinData(0, 0, 0, 0, 0, 0, 0, false));
763     }
764 
765     function totalSupply() public view returns(uint) {
766         return ijins.length - 1;
767     }
768 
769     function getOwnedTokenIds(address owner) external view returns(uint[]) {
770         uint balance = balanceOf(owner);
771 
772         uint current = 0;
773         uint[] memory ownedTokenIds = new uint[](balance);
774         for (uint i = 1; i < ijins.length || current < balance; ++i) {
775             if (ownerOf(i) == owner) {
776                 ownedTokenIds[current] = i;
777                 ++current;
778             }
779         }
780 
781         return ownedTokenIds;
782     }
783 
784     function getIjinData(uint tokenId)
785         public
786         view
787         returns (
788             uint8 id,
789             uint32 exp,
790             uint8 limitBreakCount,
791             uint16 ap,
792             uint16 hp,
793             uint16 kp,
794             uint64 installTimestamp,
795             uint24 accessCount,
796             bool hasDoll,
797             uint24 trainerId
798         )
799     {
800         require(0 < tokenId && tokenId < ijins.length);
801         IjinData memory ijin = ijins[tokenId];
802         id = ijin.id;
803         exp = ijin.exp;
804         limitBreakCount = ijin.limitBreakCount;
805         uint48 compressedStatus = ijin.compressedStatus;
806         ap = uint16(compressedStatus >> 32);
807         hp = uint16(compressedStatus >> 16);
808         kp = uint16(compressedStatus);
809         installTimestamp = ijin.installTimestamp;
810         accessCount = ijin.accessCount;
811         hasDoll = ijin.hasDoll;
812         trainerId = ijin.trainerId;
813     }
814 
815     function mintIjin(
816         uint8 id,
817         uint32 exp,
818         uint8 limitBreakCount,
819         uint16 ap,
820         uint16 hp,
821         uint16 kp,
822         uint64 installTimestamp,
823         uint24 accessCount,
824         bool hasDoll,
825         uint24 trainerId,
826         address owner
827     )
828         public
829         onlyOwner
830     {
831         uint48 compressedStatus = (uint48(ap) << 32) | (uint48(hp) << 16) | kp;
832         IjinData memory newIjin =
833             IjinData(
834                 id,
835                 exp,
836                 limitBreakCount,
837                 compressedStatus,
838                 installTimestamp,
839                 accessCount,
840                 trainerId,
841                 hasDoll
842             );
843         uint tokenId = ijins.push(newIjin) - 1;
844         super._mint(owner, tokenId);
845         super._setTokenURI(tokenId, "");
846     }
847 
848     function mintManyIjins(
849         uint8[] ids,
850         uint32[] exps,
851         uint8[] limitBreakCounts,
852         uint16[] aps,
853         uint16[] hps,
854         uint16[] kps,
855         uint64[] installTimestamps,
856         uint24[] accessCounts,
857         bool[] hasDolls,
858         uint24 trainerId,
859         address owner
860     )
861         public
862         onlyOwner
863     {
864         for (uint i = 0; i < ids.length; ++i) {
865             mintIjin(
866                 ids[i],
867                 exps[i],
868                 limitBreakCounts[i],
869                 aps[i],
870                 hps[i],
871                 kps[i],
872                 installTimestamps[i],
873                 accessCounts[i],
874                 hasDolls[i],
875                 trainerId,
876                 owner
877             );
878         }
879     }
880 }