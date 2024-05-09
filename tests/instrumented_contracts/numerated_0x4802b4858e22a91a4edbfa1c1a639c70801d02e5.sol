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
99 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
100 
101 /**
102  * @title ERC165
103  * @author Matt Condon (@shrugs)
104  * @dev Implements ERC165 using a lookup table.
105  */
106 contract ERC165 is IERC165 {
107 
108   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
109   /**
110    * 0x01ffc9a7 ===
111    *   bytes4(keccak256('supportsInterface(bytes4)'))
112    */
113 
114   /**
115    * @dev a mapping of interface id to whether or not it's supported
116    */
117   mapping(bytes4 => bool) private _supportedInterfaces;
118 
119   /**
120    * @dev A contract implementing SupportsInterfaceWithLookup
121    * implement ERC165 itself
122    */
123   constructor()
124     internal
125   {
126     _registerInterface(_InterfaceId_ERC165);
127   }
128 
129   /**
130    * @dev implement supportsInterface(bytes4) using a lookup table
131    */
132   function supportsInterface(bytes4 interfaceId)
133     external
134     view
135     returns (bool)
136   {
137     return _supportedInterfaces[interfaceId];
138   }
139 
140   /**
141    * @dev internal method for registering an interface
142    */
143   function _registerInterface(bytes4 interfaceId)
144     internal
145   {
146     require(interfaceId != 0xffffffff);
147     _supportedInterfaces[interfaceId] = true;
148   }
149 }
150 
151 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that revert on error
156  */
157 library SafeMath {
158 
159   /**
160   * @dev Multiplies two numbers, reverts on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164     // benefit is lost if 'b' is also tested.
165     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
166     if (a == 0) {
167       return 0;
168     }
169 
170     uint256 c = a * b;
171     require(c / a == b);
172 
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
178   */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     require(b > 0); // Solidity only automatically asserts when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184     return c;
185   }
186 
187   /**
188   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b <= a);
192     uint256 c = a - b;
193 
194     return c;
195   }
196 
197   /**
198   * @dev Adds two numbers, reverts on overflow.
199   */
200   function add(uint256 a, uint256 b) internal pure returns (uint256) {
201     uint256 c = a + b;
202     require(c >= a);
203 
204     return c;
205   }
206 
207   /**
208   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
209   * reverts when dividing by zero.
210   */
211   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212     require(b != 0);
213     return a % b;
214   }
215 }
216 
217 // File: openzeppelin-solidity/contracts/utils/Address.sol
218 
219 /**
220  * Utility library of inline functions on addresses
221  */
222 library Address {
223 
224   /**
225    * Returns whether the target address is a contract
226    * @dev This function will return false if invoked during the constructor of a contract,
227    * as the code is not actually created until after the constructor finishes.
228    * @param account address of the account to check
229    * @return whether the target address is a contract
230    */
231   function isContract(address account) internal view returns (bool) {
232     uint256 size;
233     // XXX Currently there is no better way to check if there is a contract in an address
234     // than to check the size of the code at that address.
235     // See https://ethereum.stackexchange.com/a/14016/36603
236     // for more details about how this works.
237     // TODO Check this again before the Serenity release, because all addresses will be
238     // contracts then.
239     // solium-disable-next-line security/no-inline-assembly
240     assembly { size := extcodesize(account) }
241     return size > 0;
242   }
243 
244 }
245 
246 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
247 
248 /**
249  * @title ERC721 Non-Fungible Token Standard basic interface
250  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
251  */
252 contract IERC721 is IERC165 {
253 
254   event Transfer(
255     address indexed from,
256     address indexed to,
257     uint256 indexed tokenId
258   );
259   event Approval(
260     address indexed owner,
261     address indexed approved,
262     uint256 indexed tokenId
263   );
264   event ApprovalForAll(
265     address indexed owner,
266     address indexed operator,
267     bool approved
268   );
269 
270   function balanceOf(address owner) public view returns (uint256 balance);
271   function ownerOf(uint256 tokenId) public view returns (address owner);
272 
273   function approve(address to, uint256 tokenId) public;
274   function getApproved(uint256 tokenId)
275     public view returns (address operator);
276 
277   function setApprovalForAll(address operator, bool _approved) public;
278   function isApprovedForAll(address owner, address operator)
279     public view returns (bool);
280 
281   function transferFrom(address from, address to, uint256 tokenId) public;
282   function safeTransferFrom(address from, address to, uint256 tokenId)
283     public;
284 
285   function safeTransferFrom(
286     address from,
287     address to,
288     uint256 tokenId,
289     bytes data
290   )
291     public;
292 }
293 
294 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
295 
296 /**
297  * @title ERC721 token receiver interface
298  * @dev Interface for any contract that wants to support safeTransfers
299  * from ERC721 asset contracts.
300  */
301 contract IERC721Receiver {
302   /**
303    * @notice Handle the receipt of an NFT
304    * @dev The ERC721 smart contract calls this function on the recipient
305    * after a `safeTransfer`. This function MUST return the function selector,
306    * otherwise the caller will revert the transaction. The selector to be
307    * returned can be obtained as `this.onERC721Received.selector`. This
308    * function MAY throw to revert and reject the transfer.
309    * Note: the ERC721 contract address is always the message sender.
310    * @param operator The address which called `safeTransferFrom` function
311    * @param from The address which previously owned the token
312    * @param tokenId The NFT identifier which is being transferred
313    * @param data Additional data with no specified format
314    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
315    */
316   function onERC721Received(
317     address operator,
318     address from,
319     uint256 tokenId,
320     bytes data
321   )
322     public
323     returns(bytes4);
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
928 // File: contracts/AtomToken.sol
929 
930 contract AtomToken is ERC721Full, Ownable{
931 
932     /**
933      *  @dev An auto-increasing unique id for each token minted
934      *       this store the id of a new token to be minted
935      *       i.e. the very first one will have an id of 1
936      */
937     uint tokenId = 1;
938 
939     /**
940      * @notice Set the name and the symbol at the time of creation
941      *         decimal will be 0
942      * @param _name - long name, e.g. "Shameless Promo Token"
943      * @param _symbol - short name, e.g. "SPT"
944      */
945     constructor(string _name, string _symbol)
946         public
947         ERC721Full(_name,_symbol)
948     {}
949 
950     /**
951      * @notice Mint a single instance of the token
952      *         only the current contract owner can do that
953      * @param _to Destination address
954      * @param _tokenURI Link to a JSON metadata
955      */
956     function mint(address _to, string _tokenURI)
957         external
958         onlyOwner
959     {
960         // increase id once since it's used just once
961         uint currentId = tokenId++;
962         _mint(_to, currentId);
963         _setTokenURI(currentId, _tokenURI);
964     }
965 
966     /**
967      * @notice Same as mint(), but mints multiple identical tokens at once
968      *         only the current contract owner can do that
969      * @param _to Destination address
970      * @param _tokenURI Link to a JSON metadata
971      * @param number How many tokens should be minted
972      */
973     function bulkMint(address _to, string _tokenURI, uint number)
974         external
975         onlyOwner
976     {
977         // don't increase id yet
978         uint currentId = tokenId;
979         for (uint i = 0; i < number; i++ ) {
980             _mint(_to, currentId);
981             _setTokenURI(currentId, _tokenURI);
982             currentId++;
983         }
984         // update the counter once to save gas
985         tokenId = currentId;
986     }
987 }