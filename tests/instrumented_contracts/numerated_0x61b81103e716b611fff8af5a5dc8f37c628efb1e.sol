1 pragma solidity 0.4.25;
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
79 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
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
99 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
147 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
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
179 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
245 // File: openzeppelin-solidity/contracts/utils/Address.sol
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
274 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
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
326 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
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
651 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
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
670 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
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
817 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
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
829 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
830 
831 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
832   // Token name
833   string private _name;
834 
835   // Token symbol
836   string private _symbol;
837 
838   // Optional mapping for token URIs
839   mapping(uint256 => string) private _tokenURIs;
840 
841   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
842   /**
843    * 0x5b5e139f ===
844    *   bytes4(keccak256('name()')) ^
845    *   bytes4(keccak256('symbol()')) ^
846    *   bytes4(keccak256('tokenURI(uint256)'))
847    */
848 
849   /**
850    * @dev Constructor function
851    */
852   constructor(string name, string symbol) public {
853     _name = name;
854     _symbol = symbol;
855 
856     // register the supported interfaces to conform to ERC721 via ERC165
857     _registerInterface(InterfaceId_ERC721Metadata);
858   }
859 
860   /**
861    * @dev Gets the token name
862    * @return string representing the token name
863    */
864   function name() external view returns (string) {
865     return _name;
866   }
867 
868   /**
869    * @dev Gets the token symbol
870    * @return string representing the token symbol
871    */
872   function symbol() external view returns (string) {
873     return _symbol;
874   }
875 
876   /**
877    * @dev Returns an URI for a given token ID
878    * Throws if the token ID does not exist. May return an empty string.
879    * @param tokenId uint256 ID of the token to query
880    */
881   function tokenURI(uint256 tokenId) external view returns (string) {
882     require(_exists(tokenId));
883     return _tokenURIs[tokenId];
884   }
885 
886   /**
887    * @dev Internal function to set the token URI for a given token
888    * Reverts if the token ID does not exist
889    * @param tokenId uint256 ID of the token to set its URI
890    * @param uri string URI to assign
891    */
892   function _setTokenURI(uint256 tokenId, string uri) internal {
893     require(_exists(tokenId));
894     _tokenURIs[tokenId] = uri;
895   }
896 
897   /**
898    * @dev Internal function to burn a specific token
899    * Reverts if the token does not exist
900    * @param owner owner of the token to burn
901    * @param tokenId uint256 ID of the token being burned by the msg.sender
902    */
903   function _burn(address owner, uint256 tokenId) internal {
904     super._burn(owner, tokenId);
905 
906     // Clear metadata (if any)
907     if (bytes(_tokenURIs[tokenId]).length != 0) {
908       delete _tokenURIs[tokenId];
909     }
910   }
911 }
912 
913 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
914 
915 /**
916  * @title Full ERC721 Token
917  * This implementation includes all the required and some optional functionality of the ERC721 standard
918  * Moreover, it includes approve all functionality using operator terminology
919  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
920  */
921 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
922   constructor(string name, string symbol) ERC721Metadata(name, symbol)
923     public
924   {
925   }
926 }
927 
928 // File: contracts/Cybercon.sol
929 
930 contract Cybercon is Ownable, ERC721Full {
931     
932     using SafeMath for uint256;
933     using Address for address;
934     
935     enum ApplicationStatus {Applied, Accepted, Declined}
936     
937     struct Talk {
938         string  speakerName;
939         string  descSpeaker;
940         string  deskTalk;
941         uint256 duration;
942         uint256 deposit;
943         address speakerAddress;
944         uint256 appliedAt;
945         bool    checkedIn;
946         ApplicationStatus status;
947         string  proof;
948     }
949     
950     struct Ticket {
951         uint256 value;
952         address bidderAddress;
953         bool    checkedIn;
954         bool    overbidReturned;
955     }
956     
957     struct CommunityBuilderMessage {
958         string  message;
959         string  link1;
960         string  link2;
961         uint256 donation;
962     }
963     
964     uint256 private auctionStartBlock;
965     uint256 private auctionStartTime;
966     uint256 constant private TALKS_APPLICATION_END = 1544562000;
967     uint256 constant private CHECKIN_START = 1544767200;
968     uint256 constant private CHECKIN_END = 1544788800;
969     uint256 constant private DISTRIBUTION_START = 1544792400;
970     uint256 private auctionEnd = CHECKIN_START;
971     // ------------
972     uint256 constant private INITIAL_PRICE = 3000 finney;
973     uint256 constant private MINIMAL_PRICE = 500 finney;
974     uint256 constant private BID_BLOCK_DECREASE = 30 szabo;
975     uint256 private endPrice = MINIMAL_PRICE;
976     // ------------
977     uint256 private ticketsAmount = 146;
978     uint256 constant private SPEAKERS_SLOTS = 24;
979     uint256 private acceptedSpeakersSlots = 0;
980     uint256 constant private SPEAKERS_START_SHARES = 80;
981     uint256 constant private SPEAKERS_END_SHARES = 20;
982     // ------------
983     uint256 private ticketsFunds = 0;
984     uint256 constant private MINIMAL_SPEAKER_DEPOSIT = 1000 finney;
985     // ------------
986     string constant private CYBERCON_PLACE = "Korpus 8, Minsk, Belarus";
987     
988     mapping(address => bool) private membersBidded;
989     uint256 private amountReturnedBids = 0;
990     bool private overbidsDistributed = false;
991     
992     Talk[] private speakersTalks;
993     Ticket[] private membersTickets;
994     CommunityBuilderMessage[] private communityBuildersBoard;
995     
996     string private talksGrid = "";
997     string private workshopsGrid = "";
998     
999     event TicketBid(
1000         uint256 _id,
1001         address _member,
1002         uint256 _value
1003     );
1004     
1005     event TalkApplication(
1006         string  _name,
1007         address _member,
1008         uint256 _value
1009     );
1010     
1011     constructor() ERC721Full("cyberc0n", "CYBERC0N")
1012         public
1013     {
1014         auctionStartBlock = block.number;
1015         auctionStartTime = block.timestamp;
1016     }
1017     
1018     function() external {}
1019     
1020     modifier beforeApplicationStop() {
1021         require(block.timestamp < TALKS_APPLICATION_END);
1022         _;
1023     }
1024     
1025     modifier beforeEventStart() {
1026         require(block.timestamp < CHECKIN_START);
1027         _;
1028     }
1029     
1030     modifier duringEvent() {
1031         require(block.timestamp >= CHECKIN_START && block.timestamp <= CHECKIN_END);
1032         _;
1033     }
1034     
1035     modifier afterDistributionStart() {
1036         require(block.timestamp > DISTRIBUTION_START);
1037         _;
1038     }
1039 
1040     function buyTicket()
1041         external
1042         beforeEventStart
1043         payable
1044     {
1045         require(msg.value >= getCurrentPrice());
1046         require(membersBidded[msg.sender] == false);
1047         require(ticketsAmount > 0);
1048         
1049         uint256 bidId = totalSupply();
1050         membersTickets.push(Ticket(msg.value, msg.sender, false, false));
1051         super._mint(msg.sender, bidId);
1052         membersBidded[msg.sender] = true;
1053         ticketsFunds = ticketsFunds.add(msg.value);
1054         ticketsAmount = ticketsAmount.sub(1);
1055         
1056         if (ticketsAmount == 0) {
1057             auctionEnd = block.timestamp;
1058             endPrice = msg.value;
1059         }
1060         
1061         emit TicketBid(bidId, msg.sender, msg.value);
1062     }
1063     
1064     function applyForTalk(
1065         string  _speakerName,
1066         string  _descSpeaker,
1067         string  _deskTalk,
1068         uint256 _duration,
1069         string  _proof
1070     )
1071         external
1072         beforeApplicationStop
1073         payable
1074     {
1075         require(_duration >= 900 && _duration <= 3600);
1076         require(msg.value >= MINIMAL_SPEAKER_DEPOSIT);
1077         require(speakersTalks.length < 36);
1078         
1079         Talk memory t = (Talk(
1080         {
1081             speakerName: _speakerName,
1082             descSpeaker: _descSpeaker,
1083             deskTalk:    _deskTalk,
1084             duration:    _duration,
1085             deposit:     msg.value,
1086             speakerAddress: msg.sender,
1087             appliedAt:   block.timestamp,
1088             checkedIn:   false,
1089             status:      ApplicationStatus.Applied,
1090             proof:       _proof
1091         }));
1092         speakersTalks.push(t);
1093         
1094         emit TalkApplication(_speakerName, msg.sender, msg.value);
1095     }
1096 
1097     function sendCommunityBuilderMessage(
1098         uint256 _talkId,
1099         string _message,
1100         string _link1,
1101         string _link2
1102     )
1103         external
1104         beforeEventStart
1105         payable
1106     {
1107         require(speakersTalks[_talkId].speakerAddress == msg.sender);
1108         require(speakersTalks[_talkId].status == ApplicationStatus.Accepted);
1109         require(msg.value > 0);
1110         
1111         CommunityBuilderMessage memory m = (CommunityBuilderMessage(
1112         {
1113             message: _message,
1114             link1:   _link1,
1115             link2:   _link2,
1116             donation: msg.value
1117         }));
1118         communityBuildersBoard.push(m);
1119     }
1120     
1121     function updateTalkDescription(
1122         uint256 _talkId,
1123         string  _descSpeaker,
1124         string  _deskTalk,
1125         string  _proof
1126     )
1127         external
1128         beforeApplicationStop
1129     {
1130         require(msg.sender == speakersTalks[_talkId].speakerAddress);
1131         speakersTalks[_talkId].descSpeaker = _descSpeaker;
1132         speakersTalks[_talkId].deskTalk = _deskTalk;
1133         speakersTalks[_talkId].proof = _proof;
1134     }
1135     
1136     function acceptTalk(uint256 _talkId)
1137         external
1138         onlyOwner
1139         beforeEventStart
1140     {
1141         require(acceptedSpeakersSlots < SPEAKERS_SLOTS); 
1142         require(speakersTalks[_talkId].status == ApplicationStatus.Applied);
1143         acceptedSpeakersSlots = acceptedSpeakersSlots.add(1);
1144         speakersTalks[_talkId].status = ApplicationStatus.Accepted;
1145     }
1146     
1147     function declineTalk(uint256 _talkId)
1148         external
1149         onlyOwner
1150         beforeEventStart
1151     {
1152         speakersTalks[_talkId].status = ApplicationStatus.Declined;
1153         address speakerAddress = speakersTalks[_talkId].speakerAddress;
1154         if (speakerAddress.isContract() == false) {
1155             address(speakerAddress).transfer(speakersTalks[_talkId].deposit);
1156         }
1157     }
1158     
1159     function selfDeclineTalk(uint256 _talkId)
1160         external
1161     {
1162         require(block.timestamp >= TALKS_APPLICATION_END && block.timestamp < CHECKIN_START);
1163         address speakerAddress = speakersTalks[_talkId].speakerAddress;
1164         require(msg.sender == speakerAddress);
1165         require(speakersTalks[_talkId].status == ApplicationStatus.Applied);
1166         speakersTalks[_talkId].status = ApplicationStatus.Declined;
1167         if (speakerAddress.isContract() == false) {
1168             address(speakerAddress).transfer(speakersTalks[_talkId].deposit);
1169         }
1170     }
1171     
1172     function checkinMember(uint256 _id)
1173         external
1174         duringEvent
1175     {
1176         require(membersTickets[_id].bidderAddress == msg.sender);
1177         membersTickets[_id].checkedIn = true;
1178     }
1179     
1180     function checkinSpeaker(uint256 _talkId)
1181         external
1182         onlyOwner
1183         duringEvent
1184     {
1185         require(speakersTalks[_talkId].checkedIn == false);
1186         require(speakersTalks[_talkId].status == ApplicationStatus.Accepted);
1187         
1188         uint256 bidId = totalSupply();
1189         super._mint(msg.sender, bidId);
1190         speakersTalks[_talkId].checkedIn = true;
1191     }
1192     
1193     function distributeOverbids(uint256 _fromBid, uint256 _toBid)
1194         external
1195         onlyOwner
1196         afterDistributionStart
1197     {   
1198         require(_fromBid <= _toBid);
1199         uint256 checkedInSpeakers = 0;
1200         for (uint256 y = 0; y < speakersTalks.length; y++){
1201             if (speakersTalks[y].checkedIn) checkedInSpeakers++;
1202         }
1203         uint256 ticketsForMembersSupply = totalSupply().sub(checkedInSpeakers);
1204         require(_fromBid < ticketsForMembersSupply && _toBid < ticketsForMembersSupply);
1205         for (uint256 i = _fromBid; i <= _toBid; i++) {
1206             require(membersTickets[i].overbidReturned == false);
1207             address bidderAddress = membersTickets[i].bidderAddress;
1208             uint256 overbid = (membersTickets[i].value).sub(endPrice);
1209             if(bidderAddress.isContract() == false) {
1210                 address(bidderAddress).transfer(overbid);
1211             }
1212             membersTickets[i].overbidReturned = true;
1213             amountReturnedBids++;
1214         }
1215         if (amountReturnedBids == ticketsForMembersSupply) {
1216             overbidsDistributed = true;
1217         }
1218     }
1219     
1220     function distributeRewards()
1221         external
1222         onlyOwner
1223         afterDistributionStart
1224     {
1225         require(overbidsDistributed == true);
1226         if (acceptedSpeakersSlots > 0) {
1227             uint256 checkedInSpeakers = 0;
1228             for (uint256 i = 0; i < speakersTalks.length; i++){
1229                 if (speakersTalks[i].checkedIn) checkedInSpeakers++;
1230             }
1231             uint256 valueForTicketsForReward = endPrice.mul(membersTickets.length);
1232             uint256 valueFromTicketsForSpeakers = valueForTicketsForReward.mul(getSpeakersShares()).div(100);
1233             
1234             uint256 valuePerSpeakerFromTickets = valueFromTicketsForSpeakers.div(checkedInSpeakers);
1235             for (uint256 y = 0; y < speakersTalks.length; y++) {
1236                 address speakerAddress = speakersTalks[y].speakerAddress;
1237                 if (speakersTalks[y].checkedIn == true && speakerAddress.isContract() == false) {
1238                     speakerAddress.transfer(valuePerSpeakerFromTickets.add(speakersTalks[y].deposit));
1239                 }
1240             }
1241         }
1242         address(owner()).transfer(address(this).balance);
1243     }
1244     
1245     function setTalksGrid(string _grid)
1246         external
1247         onlyOwner
1248     {
1249         talksGrid = _grid;
1250     }
1251     
1252     function setWorkshopsGrid(string _grid)
1253         external
1254         onlyOwner
1255     {
1256         workshopsGrid = _grid;
1257     }
1258     
1259     function getTalkById(uint256 _id)
1260         external
1261         view
1262         returns(
1263             string,
1264             string,
1265             string,
1266             uint256,
1267             uint256,
1268             address,
1269             uint256,
1270             bool,
1271             ApplicationStatus,
1272             string 
1273         )
1274     {
1275         require(_id < uint256(speakersTalks.length));
1276         Talk memory m = speakersTalks[_id];
1277         return(
1278             m.speakerName,
1279             m.descSpeaker,
1280             m.deskTalk,
1281             m.duration,
1282             m.deposit,
1283             m.speakerAddress,
1284             m.appliedAt,
1285             m.checkedIn,
1286             m.status,
1287             m.proof
1288         );
1289     }
1290     
1291     function getTicket(uint256 _id)
1292         external
1293         view
1294         returns(
1295             uint256,
1296             address,
1297             bool,
1298             bool
1299         )
1300     {
1301         return(
1302             membersTickets[_id].value,
1303             membersTickets[_id].bidderAddress,
1304             membersTickets[_id].checkedIn,
1305             membersTickets[_id].overbidReturned
1306         );
1307     }
1308     
1309     function getAuctionStartBlock()
1310         external
1311         view
1312         returns(uint256)
1313     {
1314         return auctionStartBlock;
1315     }
1316     
1317     function getAuctionStartTime()
1318         external
1319         view
1320         returns(uint256)
1321     {
1322         return auctionStartTime;
1323     }
1324     
1325     function getAuctionEndTime()
1326         external
1327         view
1328         returns(uint256)
1329     {
1330         return auctionEnd;
1331     }
1332     
1333     function getEventStartTime()
1334         external
1335         pure
1336         returns(uint256)
1337     {
1338         return CHECKIN_START;
1339     }
1340     
1341     function getEventEndTime()
1342         external
1343         pure
1344         returns(uint256)
1345     {
1346         return CHECKIN_END;
1347     }
1348     
1349     function getDistributionTime()
1350         external
1351         pure
1352         returns(uint256)
1353     {
1354         return DISTRIBUTION_START;
1355     }
1356     
1357     function getCurrentPrice()
1358         public
1359         view
1360         returns(uint256)
1361     {
1362         uint256 blocksPassed = block.number - auctionStartBlock;
1363         uint256 currentDiscount = blocksPassed.mul(BID_BLOCK_DECREASE);
1364         
1365         if (currentDiscount < (INITIAL_PRICE - MINIMAL_PRICE)) {
1366             return INITIAL_PRICE.sub(currentDiscount);
1367         } else { 
1368             return MINIMAL_PRICE; 
1369         }
1370     }
1371     
1372     function getEndPrice()
1373         external
1374         view
1375         returns(uint256)
1376     {
1377         return endPrice;
1378     }
1379     
1380     function getMinimalPrice()
1381         external
1382         pure
1383         returns(uint256)
1384     {
1385         return MINIMAL_PRICE;
1386     }
1387     
1388     function getMinimalSpeakerDeposit()
1389         external
1390         pure
1391         returns(uint256)
1392     {
1393         return MINIMAL_SPEAKER_DEPOSIT;
1394     }
1395     
1396     function getTicketsAmount()
1397         external
1398         view
1399         returns(uint256)
1400     {
1401         return ticketsAmount;
1402     }
1403     
1404     function getSpeakersSlots()
1405         external
1406         pure
1407         returns(uint256)
1408     {
1409         return SPEAKERS_SLOTS;
1410     }
1411     
1412     function getAvailableSpeaksersSlots()
1413         external
1414         view
1415         returns(uint256)
1416     { 
1417         return SPEAKERS_SLOTS.sub(acceptedSpeakersSlots); 
1418     }
1419     
1420     function getOrganizersShares()
1421         public
1422         view
1423         returns(uint256)
1424     {
1425         uint256 time = auctionEnd;
1426         if (ticketsAmount > 0 && block.timestamp < CHECKIN_START) {
1427             time = block.timestamp;
1428         }
1429         uint256 mul = time.sub(auctionStartTime).mul(100).div(CHECKIN_START.sub(auctionStartTime));
1430         uint256 shares = SPEAKERS_START_SHARES.sub(SPEAKERS_END_SHARES).mul(mul).div(100);
1431         
1432         return SPEAKERS_END_SHARES.add(shares);
1433     }
1434     
1435     function getSpeakersShares()
1436         public
1437         view
1438         returns(uint256)
1439     {
1440         return uint256(100).sub(getOrganizersShares());
1441     }
1442     
1443     function getTicketsFunds()
1444         external
1445         view
1446         returns(uint256)
1447     {
1448         return ticketsFunds;
1449     }
1450     
1451     function getPlace()
1452         external
1453         pure
1454         returns(string)
1455     { 
1456         return CYBERCON_PLACE;
1457     }
1458     
1459     function getTalksGrid()
1460         external
1461         view
1462         returns(string)
1463     {
1464         return talksGrid;
1465     }
1466     
1467     function getWorkshopsGrid()
1468         external
1469         view
1470         returns(string)
1471     {
1472         return workshopsGrid;
1473     }
1474     
1475     function getCommunityBuilderMessage(uint256 _messageID)
1476         external
1477         view
1478         returns(
1479             string,
1480             string,
1481             string,
1482             uint256
1483         )
1484     {
1485         return(
1486             communityBuildersBoard[_messageID].message,
1487             communityBuildersBoard[_messageID].link1,
1488             communityBuildersBoard[_messageID].link2,
1489             communityBuildersBoard[_messageID].donation
1490         );
1491     }
1492     
1493     function getCommunityBuildersBoardSize()
1494         external
1495         view
1496         returns(uint256)
1497     {
1498         return communityBuildersBoard.length;
1499     }
1500     
1501     function getAmountReturnedOverbids()
1502         external
1503         view
1504         returns(uint256)
1505     {
1506         return amountReturnedBids;
1507     }
1508 }