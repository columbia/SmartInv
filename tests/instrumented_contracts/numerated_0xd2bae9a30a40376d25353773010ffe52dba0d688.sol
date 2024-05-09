1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
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
56     emit OwnershipTransferred(_owner, address(0));
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
79 // File: node_modules/openzeppelin-solidity/contracts/introspection/IERC165.sol
80 
81 /**
82  * @title IERC165
83  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
84  */
85 interface IERC165 {
86 
87   /**
88    * @notice Query if a contract implements an interface
89    * @param interfaceId The interface identifier, as specified in ERC-165
90    * @dev Interface identification is specified in ERC-165. This function
91    * uses less than 30,000 gas.
92    */
93   function supportsInterface(bytes4 interfaceId)
94     external
95     view
96     returns (bool);
97 }
98 
99 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
100 
101 /**
102  * @title ERC721 Non-Fungible Token Standard basic interface
103  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
104  */
105 contract IERC721 is IERC165 {
106 
107   event Transfer(
108     address indexed from,
109     address indexed to,
110     uint256 indexed tokenId
111   );
112   event Approval(
113     address indexed owner,
114     address indexed approved,
115     uint256 indexed tokenId
116   );
117   event ApprovalForAll(
118     address indexed owner,
119     address indexed operator,
120     bool approved
121   );
122 
123   function balanceOf(address owner) public view returns (uint256 balance);
124   function ownerOf(uint256 tokenId) public view returns (address owner);
125 
126   function approve(address to, uint256 tokenId) public;
127   function getApproved(uint256 tokenId)
128     public view returns (address operator);
129 
130   function setApprovalForAll(address operator, bool _approved) public;
131   function isApprovedForAll(address owner, address operator)
132     public view returns (bool);
133 
134   function transferFrom(address from, address to, uint256 tokenId) public;
135   function safeTransferFrom(address from, address to, uint256 tokenId)
136     public;
137 
138   function safeTransferFrom(
139     address from,
140     address to,
141     uint256 tokenId,
142     bytes data
143   )
144     public;
145 }
146 
147 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
148 
149 /**
150  * @title ERC721 token receiver interface
151  * @dev Interface for any contract that wants to support safeTransfers
152  * from ERC721 asset contracts.
153  */
154 contract IERC721Receiver {
155   /**
156    * @notice Handle the receipt of an NFT
157    * @dev The ERC721 smart contract calls this function on the recipient
158    * after a `safeTransfer`. This function MUST return the function selector,
159    * otherwise the caller will revert the transaction. The selector to be
160    * returned can be obtained as `this.onERC721Received.selector`. This
161    * function MAY throw to revert and reject the transfer.
162    * Note: the ERC721 contract address is always the message sender.
163    * @param operator The address which called `safeTransferFrom` function
164    * @param from The address which previously owned the token
165    * @param tokenId The NFT identifier which is being transferred
166    * @param data Additional data with no specified format
167    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
168    */
169   function onERC721Received(
170     address operator,
171     address from,
172     uint256 tokenId,
173     bytes data
174   )
175     public
176     returns(bytes4);
177 }
178 
179 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
180 
181 /**
182  * @title SafeMath
183  * @dev Math operations with safety checks that revert on error
184  */
185 library SafeMath {
186 
187   /**
188   * @dev Multiplies two numbers, reverts on overflow.
189   */
190   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192     // benefit is lost if 'b' is also tested.
193     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194     if (a == 0) {
195       return 0;
196     }
197 
198     uint256 c = a * b;
199     require(c / a == b);
200 
201     return c;
202   }
203 
204   /**
205   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
206   */
207   function div(uint256 a, uint256 b) internal pure returns (uint256) {
208     require(b > 0); // Solidity only automatically asserts when dividing by 0
209     uint256 c = a / b;
210     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212     return c;
213   }
214 
215   /**
216   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
217   */
218   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219     require(b <= a);
220     uint256 c = a - b;
221 
222     return c;
223   }
224 
225   /**
226   * @dev Adds two numbers, reverts on overflow.
227   */
228   function add(uint256 a, uint256 b) internal pure returns (uint256) {
229     uint256 c = a + b;
230     require(c >= a);
231 
232     return c;
233   }
234 
235   /**
236   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
237   * reverts when dividing by zero.
238   */
239   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240     require(b != 0);
241     return a % b;
242   }
243 }
244 
245 // File: node_modules/openzeppelin-solidity/contracts/utils/Address.sol
246 
247 /**
248  * Utility library of inline functions on addresses
249  */
250 library Address {
251 
252   /**
253    * Returns whether the target address is a contract
254    * @dev This function will return false if invoked during the constructor of a contract,
255    * as the code is not actually created until after the constructor finishes.
256    * @param account address of the account to check
257    * @return whether the target address is a contract
258    */
259   function isContract(address account) internal view returns (bool) {
260     uint256 size;
261     // XXX Currently there is no better way to check if there is a contract in an address
262     // than to check the size of the code at that address.
263     // See https://ethereum.stackexchange.com/a/14016/36603
264     // for more details about how this works.
265     // TODO Check this again before the Serenity release, because all addresses will be
266     // contracts then.
267     // solium-disable-next-line security/no-inline-assembly
268     assembly { size := extcodesize(account) }
269     return size > 0;
270   }
271 
272 }
273 
274 // File: node_modules/openzeppelin-solidity/contracts/introspection/ERC165.sol
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
326 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
327 
328 /**
329  * @title ERC721 Non-Fungible Token Standard basic implementation
330  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
331  */
332 contract ERC721 is ERC165, IERC721 {
333 
334   using SafeMath for uint256;
335   using Address for address;
336 
337   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
338   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
339   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
340 
341   // Mapping from token ID to owner
342   mapping (uint256 => address) private _tokenOwner;
343 
344   // Mapping from token ID to approved address
345   mapping (uint256 => address) private _tokenApprovals;
346 
347   // Mapping from owner to number of owned token
348   mapping (address => uint256) private _ownedTokensCount;
349 
350   // Mapping from owner to operator approvals
351   mapping (address => mapping (address => bool)) private _operatorApprovals;
352 
353   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
354   /*
355    * 0x80ac58cd ===
356    *   bytes4(keccak256('balanceOf(address)')) ^
357    *   bytes4(keccak256('ownerOf(uint256)')) ^
358    *   bytes4(keccak256('approve(address,uint256)')) ^
359    *   bytes4(keccak256('getApproved(uint256)')) ^
360    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
361    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
362    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
363    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
364    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
365    */
366 
367   constructor()
368     public
369   {
370     // register the supported interfaces to conform to ERC721 via ERC165
371     _registerInterface(_InterfaceId_ERC721);
372   }
373 
374   /**
375    * @dev Gets the balance of the specified address
376    * @param owner address to query the balance of
377    * @return uint256 representing the amount owned by the passed address
378    */
379   function balanceOf(address owner) public view returns (uint256) {
380     require(owner != address(0));
381     return _ownedTokensCount[owner];
382   }
383 
384   /**
385    * @dev Gets the owner of the specified token ID
386    * @param tokenId uint256 ID of the token to query the owner of
387    * @return owner address currently marked as the owner of the given token ID
388    */
389   function ownerOf(uint256 tokenId) public view returns (address) {
390     address owner = _tokenOwner[tokenId];
391     require(owner != address(0));
392     return owner;
393   }
394 
395   /**
396    * @dev Approves another address to transfer the given token ID
397    * The zero address indicates there is no approved address.
398    * There can only be one approved address per token at a given time.
399    * Can only be called by the token owner or an approved operator.
400    * @param to address to be approved for the given token ID
401    * @param tokenId uint256 ID of the token to be approved
402    */
403   function approve(address to, uint256 tokenId) public {
404     address owner = ownerOf(tokenId);
405     require(to != owner);
406     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
407 
408     _tokenApprovals[tokenId] = to;
409     emit Approval(owner, to, tokenId);
410   }
411 
412   /**
413    * @dev Gets the approved address for a token ID, or zero if no address set
414    * Reverts if the token ID does not exist.
415    * @param tokenId uint256 ID of the token to query the approval of
416    * @return address currently approved for the given token ID
417    */
418   function getApproved(uint256 tokenId) public view returns (address) {
419     require(_exists(tokenId));
420     return _tokenApprovals[tokenId];
421   }
422 
423   /**
424    * @dev Sets or unsets the approval of a given operator
425    * An operator is allowed to transfer all tokens of the sender on their behalf
426    * @param to operator address to set the approval
427    * @param approved representing the status of the approval to be set
428    */
429   function setApprovalForAll(address to, bool approved) public {
430     require(to != msg.sender);
431     _operatorApprovals[msg.sender][to] = approved;
432     emit ApprovalForAll(msg.sender, to, approved);
433   }
434 
435   /**
436    * @dev Tells whether an operator is approved by a given owner
437    * @param owner owner address which you want to query the approval of
438    * @param operator operator address which you want to query the approval of
439    * @return bool whether the given operator is approved by the given owner
440    */
441   function isApprovedForAll(
442     address owner,
443     address operator
444   )
445     public
446     view
447     returns (bool)
448   {
449     return _operatorApprovals[owner][operator];
450   }
451 
452   /**
453    * @dev Transfers the ownership of a given token ID to another address
454    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
455    * Requires the msg sender to be the owner, approved, or operator
456    * @param from current owner of the token
457    * @param to address to receive the ownership of the given token ID
458    * @param tokenId uint256 ID of the token to be transferred
459   */
460   function transferFrom(
461     address from,
462     address to,
463     uint256 tokenId
464   )
465     public
466   {
467     require(_isApprovedOrOwner(msg.sender, tokenId));
468     require(to != address(0));
469 
470     _clearApproval(from, tokenId);
471     _removeTokenFrom(from, tokenId);
472     _addTokenTo(to, tokenId);
473 
474     emit Transfer(from, to, tokenId);
475   }
476 
477   /**
478    * @dev Safely transfers the ownership of a given token ID to another address
479    * If the target address is a contract, it must implement `onERC721Received`,
480    * which is called upon a safe transfer, and return the magic value
481    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
482    * the transfer is reverted.
483    *
484    * Requires the msg sender to be the owner, approved, or operator
485    * @param from current owner of the token
486    * @param to address to receive the ownership of the given token ID
487    * @param tokenId uint256 ID of the token to be transferred
488   */
489   function safeTransferFrom(
490     address from,
491     address to,
492     uint256 tokenId
493   )
494     public
495   {
496     // solium-disable-next-line arg-overflow
497     safeTransferFrom(from, to, tokenId, "");
498   }
499 
500   /**
501    * @dev Safely transfers the ownership of a given token ID to another address
502    * If the target address is a contract, it must implement `onERC721Received`,
503    * which is called upon a safe transfer, and return the magic value
504    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
505    * the transfer is reverted.
506    * Requires the msg sender to be the owner, approved, or operator
507    * @param from current owner of the token
508    * @param to address to receive the ownership of the given token ID
509    * @param tokenId uint256 ID of the token to be transferred
510    * @param _data bytes data to send along with a safe transfer check
511    */
512   function safeTransferFrom(
513     address from,
514     address to,
515     uint256 tokenId,
516     bytes _data
517   )
518     public
519   {
520     transferFrom(from, to, tokenId);
521     // solium-disable-next-line arg-overflow
522     require(_checkOnERC721Received(from, to, tokenId, _data));
523   }
524 
525   /**
526    * @dev Returns whether the specified token exists
527    * @param tokenId uint256 ID of the token to query the existence of
528    * @return whether the token exists
529    */
530   function _exists(uint256 tokenId) internal view returns (bool) {
531     address owner = _tokenOwner[tokenId];
532     return owner != address(0);
533   }
534 
535   /**
536    * @dev Returns whether the given spender can transfer a given token ID
537    * @param spender address of the spender to query
538    * @param tokenId uint256 ID of the token to be transferred
539    * @return bool whether the msg.sender is approved for the given token ID,
540    *  is an operator of the owner, or is the owner of the token
541    */
542   function _isApprovedOrOwner(
543     address spender,
544     uint256 tokenId
545   )
546     internal
547     view
548     returns (bool)
549   {
550     address owner = ownerOf(tokenId);
551     // Disable solium check because of
552     // https://github.com/duaraghav8/Solium/issues/175
553     // solium-disable-next-line operator-whitespace
554     return (
555       spender == owner ||
556       getApproved(tokenId) == spender ||
557       isApprovedForAll(owner, spender)
558     );
559   }
560 
561   /**
562    * @dev Internal function to mint a new token
563    * Reverts if the given token ID already exists
564    * @param to The address that will own the minted token
565    * @param tokenId uint256 ID of the token to be minted by the msg.sender
566    */
567   function _mint(address to, uint256 tokenId) internal {
568     require(to != address(0));
569     _addTokenTo(to, tokenId);
570     emit Transfer(address(0), to, tokenId);
571   }
572 
573   /**
574    * @dev Internal function to burn a specific token
575    * Reverts if the token does not exist
576    * @param tokenId uint256 ID of the token being burned by the msg.sender
577    */
578   function _burn(address owner, uint256 tokenId) internal {
579     _clearApproval(owner, tokenId);
580     _removeTokenFrom(owner, tokenId);
581     emit Transfer(owner, address(0), tokenId);
582   }
583 
584   /**
585    * @dev Internal function to add a token ID to the list of a given address
586    * Note that this function is left internal to make ERC721Enumerable possible, but is not
587    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
588    * @param to address representing the new owner of the given token ID
589    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
590    */
591   function _addTokenTo(address to, uint256 tokenId) internal {
592     require(_tokenOwner[tokenId] == address(0));
593     _tokenOwner[tokenId] = to;
594     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
595   }
596 
597   /**
598    * @dev Internal function to remove a token ID from the list of a given address
599    * Note that this function is left internal to make ERC721Enumerable possible, but is not
600    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
601    * and doesn't clear approvals.
602    * @param from address representing the previous owner of the given token ID
603    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
604    */
605   function _removeTokenFrom(address from, uint256 tokenId) internal {
606     require(ownerOf(tokenId) == from);
607     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
608     _tokenOwner[tokenId] = address(0);
609   }
610 
611   /**
612    * @dev Internal function to invoke `onERC721Received` on a target address
613    * The call is not executed if the target address is not a contract
614    * @param from address representing the previous owner of the given token ID
615    * @param to target address that will receive the tokens
616    * @param tokenId uint256 ID of the token to be transferred
617    * @param _data bytes optional data to send along with the call
618    * @return whether the call correctly returned the expected magic value
619    */
620   function _checkOnERC721Received(
621     address from,
622     address to,
623     uint256 tokenId,
624     bytes _data
625   )
626     internal
627     returns (bool)
628   {
629     if (!to.isContract()) {
630       return true;
631     }
632     bytes4 retval = IERC721Receiver(to).onERC721Received(
633       msg.sender, from, tokenId, _data);
634     return (retval == _ERC721_RECEIVED);
635   }
636 
637   /**
638    * @dev Private function to clear current approval of a given token ID
639    * Reverts if the given address is not indeed the owner of the token
640    * @param owner owner of the token
641    * @param tokenId uint256 ID of the token to be transferred
642    */
643   function _clearApproval(address owner, uint256 tokenId) private {
644     require(ownerOf(tokenId) == owner);
645     if (_tokenApprovals[tokenId] != address(0)) {
646       _tokenApprovals[tokenId] = address(0);
647     }
648   }
649 }
650 
651 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
652 
653 /**
654  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
655  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
656  */
657 contract IERC721Enumerable is IERC721 {
658   function totalSupply() public view returns (uint256);
659   function tokenOfOwnerByIndex(
660     address owner,
661     uint256 index
662   )
663     public
664     view
665     returns (uint256 tokenId);
666 
667   function tokenByIndex(uint256 index) public view returns (uint256);
668 }
669 
670 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
671 
672 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
673   // Mapping from owner to list of owned token IDs
674   mapping(address => uint256[]) private _ownedTokens;
675 
676   // Mapping from token ID to index of the owner tokens list
677   mapping(uint256 => uint256) private _ownedTokensIndex;
678 
679   // Array with all token ids, used for enumeration
680   uint256[] private _allTokens;
681 
682   // Mapping from token id to position in the allTokens array
683   mapping(uint256 => uint256) private _allTokensIndex;
684 
685   bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
686   /**
687    * 0x780e9d63 ===
688    *   bytes4(keccak256('totalSupply()')) ^
689    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
690    *   bytes4(keccak256('tokenByIndex(uint256)'))
691    */
692 
693   /**
694    * @dev Constructor function
695    */
696   constructor() public {
697     // register the supported interface to conform to ERC721 via ERC165
698     _registerInterface(_InterfaceId_ERC721Enumerable);
699   }
700 
701   /**
702    * @dev Gets the token ID at a given index of the tokens list of the requested owner
703    * @param owner address owning the tokens list to be accessed
704    * @param index uint256 representing the index to be accessed of the requested tokens list
705    * @return uint256 token ID at the given index of the tokens list owned by the requested address
706    */
707   function tokenOfOwnerByIndex(
708     address owner,
709     uint256 index
710   )
711     public
712     view
713     returns (uint256)
714   {
715     require(index < balanceOf(owner));
716     return _ownedTokens[owner][index];
717   }
718 
719   /**
720    * @dev Gets the total amount of tokens stored by the contract
721    * @return uint256 representing the total amount of tokens
722    */
723   function totalSupply() public view returns (uint256) {
724     return _allTokens.length;
725   }
726 
727   /**
728    * @dev Gets the token ID at a given index of all the tokens in this contract
729    * Reverts if the index is greater or equal to the total number of tokens
730    * @param index uint256 representing the index to be accessed of the tokens list
731    * @return uint256 token ID at the given index of the tokens list
732    */
733   function tokenByIndex(uint256 index) public view returns (uint256) {
734     require(index < totalSupply());
735     return _allTokens[index];
736   }
737 
738   /**
739    * @dev Internal function to add a token ID to the list of a given address
740    * This function is internal due to language limitations, see the note in ERC721.sol.
741    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
742    * @param to address representing the new owner of the given token ID
743    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
744    */
745   function _addTokenTo(address to, uint256 tokenId) internal {
746     super._addTokenTo(to, tokenId);
747     uint256 length = _ownedTokens[to].length;
748     _ownedTokens[to].push(tokenId);
749     _ownedTokensIndex[tokenId] = length;
750   }
751 
752   /**
753    * @dev Internal function to remove a token ID from the list of a given address
754    * This function is internal due to language limitations, see the note in ERC721.sol.
755    * It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
756    * and doesn't clear approvals.
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
817 // File: node_modules/openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
818 
819 /**
820  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
821  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
822  */
823 contract IERC721Metadata is IERC721 {
824   function name() external view returns (string);
825   function symbol() external view returns (string);
826   function tokenURI(uint256 tokenId) external view returns (string);
827 }
828 
829 // File: contracts/ERC721Metadata.sol
830 
831 //import "../node_modules/openzeppelin-solidity/contracts/math/Safemath.sol";
832 
833 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
834   using SafeMath for uint256;
835 
836   event LockUpdate(uint256 indexed tokenId, uint256 fromLockedTo, uint256 fromLockId, uint256 toLockedTo, uint256 toLockId, uint256 callId);
837   event StatsUpdate(uint256 indexed tokenId, uint256 fromLevel, uint256 fromWins, uint256 fromLosses, uint256 toLevel, uint256 toWins, uint256 toLosses);
838 
839   // Token name
840   string private _name;
841 
842   // Token symbol
843   string private _symbol;
844 
845   // Optional mapping for token URIs
846   string private _baseURI;
847 
848   string private _description;
849 
850   string private _url;
851 
852   struct Character {
853     uint256 mintedAt;
854     uint256 genes;
855     uint256 lockedTo;
856     uint256 lockId;
857     uint256 level;
858     uint256 wins;
859     uint256 losses;
860   }
861 
862   mapping(uint256 => Character) characters; // tokenId => Character
863 
864 
865   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
866   /**
867    * 0x5b5e139f ===
868    *   bytes4(keccak256('name()')) ^
869    *   bytes4(keccak256('symbol()')) ^
870    *   bytes4(keccak256('tokenURI(uint256)'))
871    */
872 
873   /**
874    * @dev Constructor function
875    */
876   constructor(string name, string symbol, string baseURI, string description, string url) public {
877     _name = name;
878     _symbol = symbol;
879     _baseURI = baseURI;
880     _description = description;
881     _url = url;
882     // register the supported interfaces to conform to ERC721 via ERC165
883     _registerInterface(InterfaceId_ERC721Metadata);
884   }
885 
886   /**
887    * @dev Gets the token name
888    * @return string representing the token name
889    */
890   function name() external view returns (string) {
891     return _name;
892   }
893 
894   /**
895    * @dev Gets the token symbol
896    * @return string representing the token symbol
897    */
898   function symbol() external view returns (string) {
899     return _symbol;
900   }
901 
902   /**
903    * @dev Gets the contract description
904    * @return string representing the contract description
905    */
906   function description() external view returns (string) {
907     return _description;
908   }
909 
910   /**
911  * @dev Gets the project url
912  * @return string representing the project url
913  */
914   function url() external view returns (string) {
915     return _url;
916   }
917 
918   /**
919   * @dev Function to set the token base URI
920   * @param newBaseUri string URI to assign
921   */
922   function _setBaseURI(string newBaseUri) internal {
923     _baseURI = newBaseUri;
924   }
925 
926   /**
927   * @dev Function to set the contract description
928   * @param newDescription string contract description to assign
929   */
930   function _setDescription(string newDescription) internal {
931     _description = newDescription;
932   }
933 
934   /**
935    * @dev Function to set the project url
936    * @param newUrl string project url to assign
937    */
938   function _setURL(string newUrl) internal {
939     _url = newUrl;
940   }
941 
942 
943   /**
944    * @dev Returns an URI for a given token ID
945    * Throws if the token ID does not exist. May return an empty string.
946    * @param tokenId uint256 ID of the token to query
947    */
948   function tokenURI(uint256 tokenId) external view returns (string) {
949     require(_exists(tokenId));
950     return string(abi.encodePacked(_baseURI, uint2str(tokenId)));
951   }
952 
953   function _setMetadata(uint256 tokenId, uint256 genes, uint256 level) internal {
954     require(_exists(tokenId));
955     //    Character storage character = characters[_tokenId];
956     characters[tokenId] = Character({
957       mintedAt : now,
958       genes : genes,
959       lockedTo : 0,
960       lockId : 0,
961       level : level,
962       wins : 0,
963       losses : 0
964       });
965     emit StatsUpdate(tokenId, 0, 0, 0, level, 0, 0);
966 
967   }
968 
969 
970   function _clearMetadata(uint256 tokenId) internal {
971     require(_exists(tokenId));
972     delete characters[tokenId];
973   }
974 
975   /* LOCKS */
976 
977   function isFree(uint tokenId) public view returns (bool) {
978     require(_exists(tokenId));
979     return now > characters[tokenId].lockedTo;
980   }
981 
982 
983   function getLock(uint256 tokenId) external view returns (uint256 lockedTo, uint256 lockId) {
984     require(_exists(tokenId));
985     Character memory c = characters[tokenId];
986     return (c.lockedTo, c.lockId);
987   }
988 
989   function getLevel(uint256 tokenId) external view returns (uint256) {
990     require(_exists(tokenId));
991     return characters[tokenId].level;
992   }
993 
994   function getGenes(uint256 tokenId) external view returns (uint256) {
995     require(_exists(tokenId));
996     return characters[tokenId].genes;
997   }
998 
999   function getRace(uint256 tokenId) external view returns (uint256) {
1000     require(_exists(tokenId));
1001     return characters[tokenId].genes & 0xFFFF;
1002   }
1003 
1004   function getCharacter(uint256 tokenId) external view returns (
1005     uint256 mintedAt,
1006     uint256 genes,
1007     uint256 race,
1008     uint256 lockedTo,
1009     uint256 lockId,
1010     uint256 level,
1011     uint256 wins,
1012     uint256 losses
1013   ) {
1014     require(_exists(tokenId));
1015     Character memory c = characters[tokenId];
1016     return (c.mintedAt, c.genes, c.genes & 0xFFFF, c.lockedTo, c.lockId, c.level, c.wins, c.losses);
1017   }
1018 
1019   function _setLock(uint256 tokenId, uint256 lockedTo, uint256 lockId, uint256 callId) internal returns (bool) {
1020     require(isFree(tokenId));
1021     Character storage c = characters[tokenId];
1022     emit LockUpdate(tokenId, c.lockedTo, c.lockId, lockedTo, lockId, callId);
1023     c.lockedTo = lockedTo;
1024     c.lockId = lockId;
1025     return true;
1026   }
1027 
1028   /* CHARACTER LOGIC */
1029 
1030   function _addWin(uint256 tokenId, uint256 _winsCount, uint256 _levelUp) internal returns (bool) {
1031     require(_exists(tokenId));
1032     Character storage c = characters[tokenId];
1033     uint prevWins = c.wins;
1034     uint prevLevel = c.level;
1035     c.wins = c.wins.add(_winsCount);
1036     c.level = c.level.add(_levelUp);
1037     emit StatsUpdate(tokenId, prevLevel, prevWins, c.losses, c.level, c.wins, c.losses);
1038     return true;
1039   }
1040 
1041   function _addLoss(uint256 tokenId, uint256 _lossesCount, uint256 _levelDown) internal returns (bool) {
1042     require(_exists(tokenId));
1043     Character storage c = characters[tokenId];
1044     uint prevLosses = c.losses;
1045     uint prevLevel = c.level;
1046     c.losses = c.losses.add(_lossesCount);
1047     c.level = c.level > _levelDown ? c.level.sub(_levelDown) : 1;
1048     emit StatsUpdate(tokenId, prevLevel, c.wins, prevLosses, c.level, c.wins, c.losses);
1049     return true;
1050   }
1051 
1052   /**
1053   * @dev Convert uint to string
1054   * @param i The uint to convert
1055   * @return A string representation of uint.
1056   */
1057   function uint2str(uint i) internal pure returns (string) {
1058     if (i == 0) return "0";
1059     uint j = i;
1060     uint len;
1061     while (j != 0) {
1062       len++;
1063       j /= 10;
1064     }
1065     bytes memory bstr = new bytes(len);
1066     uint k = len - 1;
1067     while (i != 0) {
1068       bstr[k--] = byte(48 + i % 10);
1069       i /= 10;
1070     }
1071     return string(bstr);
1072   }
1073 
1074 
1075 }
1076 
1077 // File: lib/HasAgents.sol
1078 
1079 /**
1080  * @title agents
1081  * @dev Library for managing addresses assigned to a agent.
1082  */
1083 library Agents {
1084   using Address for address;
1085 
1086   struct Data {
1087     uint id;
1088     bool exists;
1089     bool allowance;
1090   }
1091 
1092   struct Agent {
1093     mapping(address => Data) data;
1094     mapping(uint => address) list;
1095   }
1096 
1097   /**
1098    * @dev give an account access to this agent
1099    */
1100   function add(Agent storage agent, address account, uint id, bool allowance) internal {
1101     require(!exists(agent, account));
1102 
1103     agent.data[account] = Data({
1104       id : id,
1105       exists : true,
1106       allowance : allowance
1107       });
1108     agent.list[id] = account;
1109   }
1110 
1111   /**
1112    * @dev remove an account's access to this agent
1113    */
1114   function remove(Agent storage agent, address account) internal {
1115     require(exists(agent, account));
1116 
1117     //if it not updated agent - clean list record
1118     if (agent.list[agent.data[account].id] == account) {
1119       delete agent.list[agent.data[account].id];
1120     }
1121     delete agent.data[account];
1122   }
1123 
1124   /**
1125    * @dev check if an account has this agent
1126    * @return bool
1127    */
1128   function exists(Agent storage agent, address account) internal view returns (bool) {
1129     require(account != address(0));
1130     //auto prevent existing of agents with updated address and same id
1131     return agent.data[account].exists && agent.list[agent.data[account].id] == account;
1132   }
1133 
1134   /**
1135   * @dev get agent id of the account
1136   * @return uint
1137   */
1138   function id(Agent storage agent, address account) internal view returns (uint) {
1139     require(exists(agent, account));
1140     return agent.data[account].id;
1141   }
1142 
1143   function byId(Agent storage agent, uint agentId) internal view returns (address) {
1144     address account = agent.list[agentId];
1145     require(account != address(0));
1146     require(agent.data[account].exists && agent.data[account].id == agentId);
1147     return account;
1148   }
1149 
1150   function allowance(Agent storage agent, address account) internal view returns (bool) {
1151     require(exists(agent, account));
1152     return account.isContract() && agent.data[account].allowance;
1153   }
1154 
1155 
1156 }
1157 
1158 contract HasAgents is Ownable {
1159   using Agents for Agents.Agent;
1160 
1161   event AgentAdded(address indexed account);
1162   event AgentRemoved(address indexed account);
1163 
1164   Agents.Agent private agents;
1165 
1166   constructor() internal {
1167     _addAgent(msg.sender, 0, false);
1168   }
1169 
1170   modifier onlyAgent() {
1171     require(isAgent(msg.sender));
1172     _;
1173   }
1174 
1175   function isAgent(address account) public view returns (bool) {
1176     return agents.exists(account);
1177   }
1178 
1179   function addAgent(address account, uint id, bool allowance) public onlyOwner {
1180     _addAgent(account, id, allowance);
1181   }
1182 
1183   function removeAgent(address account) public onlyOwner {
1184     _removeAgent(account);
1185   }
1186 
1187   function renounceAgent() public {
1188     _removeAgent(msg.sender);
1189   }
1190 
1191   function _addAgent(address account, uint id, bool allowance) internal {
1192     agents.add(account, id, allowance);
1193     emit AgentAdded(account);
1194   }
1195 
1196   function _removeAgent(address account) internal {
1197     agents.remove(account);
1198     emit AgentRemoved(account);
1199   }
1200 
1201   function getAgentId(address account) public view returns (uint) {
1202     return agents.id(account);
1203   }
1204 
1205 //  function getCallerAgentId() public view returns (uint) {
1206 //    return agents.id(msg.sender);
1207 //  }
1208 
1209   function getAgentById(uint id) public view returns (address) {
1210     return agents.byId(id);
1211   }
1212 
1213   function isAgentHasAllowance(address account) public view returns (bool) {
1214     return agents.allowance(account);
1215   }
1216 }
1217 
1218 // File: node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
1219 
1220 /**
1221  * @title Helps contracts guard against reentrancy attacks.
1222  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1223  * @dev If you mark a function `nonReentrant`, you should also
1224  * mark it `external`.
1225  */
1226 contract ReentrancyGuard {
1227 
1228   /// @dev counter to allow mutex lock with only one SSTORE operation
1229   uint256 private _guardCounter;
1230 
1231   constructor() internal {
1232     // The counter starts at one to prevent changing it from zero to a non-zero
1233     // value, which is a more expensive operation.
1234     _guardCounter = 1;
1235   }
1236 
1237   /**
1238    * @dev Prevents a contract from calling itself, directly or indirectly.
1239    * Calling a `nonReentrant` function from another `nonReentrant`
1240    * function is not supported. It is possible to prevent this from happening
1241    * by making the `nonReentrant` function external, and make it call a
1242    * `private` function that does the actual work.
1243    */
1244   modifier nonReentrant() {
1245     _guardCounter += 1;
1246     uint256 localCounter = _guardCounter;
1247     _;
1248     require(localCounter == _guardCounter);
1249   }
1250 
1251 }
1252 
1253 // File: lib/HasDepositary.sol
1254 
1255 /**
1256  * @title Contracts that should be able to recover tokens
1257  * @author SylTi
1258  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1259  * This will prevent any accidental loss of tokens.
1260  */
1261 contract HasDepositary is Ownable, ReentrancyGuard  {
1262 
1263   event Depositary(address depositary);
1264 
1265   address private _depositary;
1266 
1267 //  constructor() internal {
1268 //    _depositary = msg.sender;
1269 //  }
1270 
1271   /// @notice The fallback function payable
1272   function() external payable {
1273     require(msg.value > 0);
1274 //    _depositary.transfer(msg.value);
1275   }
1276 
1277   function depositary() external view returns (address) {
1278     return _depositary;
1279   }
1280 
1281   function setDepositary(address newDepositary) external onlyOwner {
1282     require(newDepositary != address(0));
1283     require(_depositary == address(0));
1284     _depositary = newDepositary;
1285     emit Depositary(newDepositary);
1286   }
1287 
1288   function withdraw() external onlyOwner nonReentrant {
1289     uint256 balance = address(this).balance;
1290     require(balance > 0);
1291     if (_depositary == address(0)) {
1292       owner().transfer(balance);
1293     } else {
1294       _depositary.transfer(balance);
1295     }
1296   }
1297 }
1298 
1299 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
1300 
1301 /**
1302  * @title ERC20 interface
1303  * @dev see https://github.com/ethereum/EIPs/issues/20
1304  */
1305 interface IERC20 {
1306   function totalSupply() external view returns (uint256);
1307 
1308   function balanceOf(address who) external view returns (uint256);
1309 
1310   function allowance(address owner, address spender)
1311     external view returns (uint256);
1312 
1313   function transfer(address to, uint256 value) external returns (bool);
1314 
1315   function approve(address spender, uint256 value)
1316     external returns (bool);
1317 
1318   function transferFrom(address from, address to, uint256 value)
1319     external returns (bool);
1320 
1321   event Transfer(
1322     address indexed from,
1323     address indexed to,
1324     uint256 value
1325   );
1326 
1327   event Approval(
1328     address indexed owner,
1329     address indexed spender,
1330     uint256 value
1331   );
1332 }
1333 
1334 // File: lib/CanReclaimToken.sol
1335 
1336 /**
1337  * @title Contracts that should be able to recover tokens
1338  * @author SylTi
1339  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1340  * This will prevent any accidental loss of tokens.
1341  */
1342 contract CanReclaimToken is Ownable {
1343 
1344   /**
1345    * @dev Reclaim all ERC20 compatible tokens
1346    * @param token ERC20 The address of the token contract
1347    */
1348   function reclaimToken(IERC20 token) external onlyOwner {
1349     if (address(token) == address(0)) {
1350       owner().transfer(address(this).balance);
1351       return;
1352     }
1353     uint256 balance = token.balanceOf(this);
1354     token.transfer(owner(), balance);
1355   }
1356 
1357 }
1358 
1359 // File: contracts/Heroes.sol
1360 
1361 interface AgentContract {
1362   function isAllowed(uint _tokenId) external returns (bool);
1363 }
1364 
1365 contract Heroes is Ownable, ERC721, ERC721Enumerable, ERC721Metadata, HasAgents, HasDepositary {
1366 
1367   uint256 private lastId = 1000;
1368 
1369   event Mint(address indexed to, uint256 indexed tokenId);
1370   event Burn(address indexed from, uint256 indexed tokenId);
1371 
1372 
1373   constructor() HasAgents() ERC721Metadata(
1374       "CRYPTO HEROES", //name
1375       "CH ⚔️", //symbol
1376       "https://api.cryptoheroes.app/hero/", //baseURI
1377       "The first blockchain game in the world with famous characters and fights built on real cryptocurrency exchange quotations.", //description
1378       "https://cryptoheroes.app" //url
1379   ) public {}
1380 
1381   /**
1382    * @dev Function to set the token base URI
1383    * @param uri string URI to assign
1384    */
1385   function setBaseURI(string uri) external onlyOwner {
1386     _setBaseURI(uri);
1387   }
1388   function setDescription(string description) external onlyOwner {
1389     _setDescription(description);
1390   }
1391   function setURL(string url) external onlyOwner {
1392     _setURL(url);
1393   }
1394 
1395   /**
1396    * @dev override
1397    */
1398   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1399     return (
1400     super._isApprovedOrOwner(spender, tokenId) ||
1401     //approve tx from agents on behalf user
1402     //agent's functions must have onlyOwnerOf modifier to prevent phishing from 3-d party contracts
1403     (isAgent(spender) && super._isApprovedOrOwner(tx.origin, tokenId)) ||
1404     //just for exceptional cases, no reason to abuse
1405     owner() == spender
1406     );
1407   }
1408 
1409 
1410   /**
1411     * @dev Mints a token to an address
1412     * @param to The address that will receive the minted tokens.
1413     * @param genes token genes
1414     * @param level token level
1415     * @return A new token id.
1416     */
1417   function mint(address to, uint256 genes, uint256 level) public onlyAgent returns (uint) {
1418     lastId = lastId.add(1);
1419     return mint(lastId, to, genes, level);
1420 //    _mint(to, lastId);
1421 //    _setMetadata(lastId, genes, level);
1422 //    emit Mint(to, lastId);
1423 //    return lastId;
1424   }
1425 
1426   /**
1427   * @dev Mints a token with specific id to an address
1428   * @param to The address that will receive the minted tokens.
1429   * @param genes token genes
1430   * @param level token level
1431   * @return A new token id.
1432   */
1433   function mint(uint256 tokenId, address to, uint256 genes, uint256 level) public onlyAgent returns (uint) {
1434     _mint(to, tokenId);
1435     _setMetadata(tokenId, genes, level);
1436     emit Mint(to, tokenId);
1437     return tokenId;
1438   }
1439 
1440 
1441   /**
1442  * @dev Function to burn tokens from sender address
1443  * @param tokenId The token id to burn.
1444  * @return A burned token id.
1445  */
1446   function burn(uint256 tokenId) public returns (uint) {
1447     require(_isApprovedOrOwner(msg.sender, tokenId));
1448     address owner = ownerOf(tokenId);
1449     _clearMetadata(tokenId);
1450     _burn(owner, tokenId);
1451     emit Burn(owner, tokenId);
1452     return tokenId;
1453   }
1454 
1455 
1456   /* CHARACTER LOGIC */
1457 
1458   function addWin(uint256 _tokenId, uint _winsCount, uint _levelUp) external onlyAgent returns (bool){
1459     require(_addWin(_tokenId, _winsCount, _levelUp));
1460     return true;
1461   }
1462 
1463   function addLoss(uint256 _tokenId, uint _lossesCount, uint _levelDown) external onlyAgent returns (bool){
1464     require(_addLoss(_tokenId, _lossesCount, _levelDown));
1465     return true;
1466   }
1467 
1468   /* LOCKS */
1469 
1470   /*
1471    * Принудительно пере-блокируем свободного персонажа c текущего агента на указанный
1472    */
1473   function lock(uint256 _tokenId, uint256 _lockedTo, bool _onlyFreeze) external onlyAgent returns(bool) {
1474     require(_exists(_tokenId));
1475     uint agentId = getAgentId(msg.sender);
1476     Character storage c = characters[_tokenId];
1477     if (c.lockId != 0 && agentId != c.lockId) {
1478       //если текущий агент другой, то вызываем его функция "проверки  персонажа"
1479       address a = getAgentById(c.lockId);
1480       if (isAgentHasAllowance(a)) {
1481         AgentContract ac = AgentContract(a);
1482         require(ac.isAllowed(_tokenId));
1483       }
1484     }
1485     require(_setLock(_tokenId, _lockedTo, _onlyFreeze ? c.lockId : agentId, agentId));
1486     return true;
1487   }
1488 
1489   function unlock(uint256 _tokenId) external onlyAgent returns (bool){
1490     require(_exists(_tokenId));
1491     uint agentId = getAgentId(msg.sender);
1492     //only current owned agent allowed
1493     require(agentId == characters[_tokenId].lockId);
1494     require(_setLock(_tokenId, 0, 0, agentId));
1495     return true;
1496   }
1497 
1498   function isCallerAgentOf(uint _tokenId) public view returns (bool) {
1499     require(_exists(_tokenId));
1500     return isAgent(msg.sender) && getAgentId(msg.sender) == characters[_tokenId].lockId;
1501   }
1502 
1503   /**
1504   * @dev Transfers the ownership of a given token ID from the owner to another address
1505   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1506   * Requires the msg sender to be the owner, approved, or operator
1507   * @param to address to receive the ownership of the given token ID
1508   * @param tokenId uint256 ID of the token to be transferred
1509  */
1510   function transfer(address to, uint256 tokenId) public {
1511     transferFrom(msg.sender, to, tokenId);
1512   }
1513 }