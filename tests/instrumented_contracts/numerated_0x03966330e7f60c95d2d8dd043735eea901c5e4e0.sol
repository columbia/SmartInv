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
22 
23 
24 
25 
26 
27 
28 /**
29  * @title ERC721 Non-Fungible Token Standard basic interface
30  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
31  */
32 contract IERC721 is IERC165 {
33 
34   event Transfer(
35     address indexed from,
36     address indexed to,
37     uint256 indexed tokenId
38   );
39   event Approval(
40     address indexed owner,
41     address indexed approved,
42     uint256 indexed tokenId
43   );
44   event ApprovalForAll(
45     address indexed owner,
46     address indexed operator,
47     bool approved
48   );
49 
50   function balanceOf(address owner) public view returns (uint256 balance);
51   function ownerOf(uint256 tokenId) public view returns (address owner);
52 
53   function approve(address to, uint256 tokenId) public;
54   function getApproved(uint256 tokenId)
55     public view returns (address operator);
56 
57   function setApprovalForAll(address operator, bool _approved) public;
58   function isApprovedForAll(address owner, address operator)
59     public view returns (bool);
60 
61   function transferFrom(address from, address to, uint256 tokenId) public;
62   function safeTransferFrom(address from, address to, uint256 tokenId)
63     public;
64 
65   function safeTransferFrom(
66     address from,
67     address to,
68     uint256 tokenId,
69     bytes data
70   )
71     public;
72 }
73 
74 
75 
76 /**
77  * @title ERC721 token receiver interface
78  * @dev Interface for any contract that wants to support safeTransfers
79  * from ERC721 asset contracts.
80  */
81 contract IERC721Receiver {
82   /**
83    * @notice Handle the receipt of an NFT
84    * @dev The ERC721 smart contract calls this function on the recipient
85    * after a `safeTransfer`. This function MUST return the function selector,
86    * otherwise the caller will revert the transaction. The selector to be
87    * returned can be obtained as `this.onERC721Received.selector`. This
88    * function MAY throw to revert and reject the transfer.
89    * Note: the ERC721 contract address is always the message sender.
90    * @param operator The address which called `safeTransferFrom` function
91    * @param from The address which previously owned the token
92    * @param tokenId The NFT identifier which is being transferred
93    * @param data Additional data with no specified format
94    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
95    */
96   function onERC721Received(
97     address operator,
98     address from,
99     uint256 tokenId,
100     bytes data
101   )
102     public
103     returns(bytes4);
104 }
105 
106 
107 
108 
109 /**
110  * Utility library of inline functions on addresses
111  */
112 library Address {
113 
114   /**
115    * Returns whether the target address is a contract
116    * @dev This function will return false if invoked during the constructor of a contract,
117    * as the code is not actually created until after the constructor finishes.
118    * @param account address of the account to check
119    * @return whether the target address is a contract
120    */
121   function isContract(address account) internal view returns (bool) {
122     uint256 size;
123     // XXX Currently there is no better way to check if there is a contract in an address
124     // than to check the size of the code at that address.
125     // See https://ethereum.stackexchange.com/a/14016/36603
126     // for more details about how this works.
127     // TODO Check this again before the Serenity release, because all addresses will be
128     // contracts then.
129     // solium-disable-next-line security/no-inline-assembly
130     assembly { size := extcodesize(account) }
131     return size > 0;
132   }
133 
134 }
135 
136 
137 
138 
139 
140 /**
141  * @title ERC165
142  * @author Matt Condon (@shrugs)
143  * @dev Implements ERC165 using a lookup table.
144  */
145 contract ERC165 is IERC165 {
146 
147   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
148   /**
149    * 0x01ffc9a7 ===
150    *   bytes4(keccak256('supportsInterface(bytes4)'))
151    */
152 
153   /**
154    * @dev a mapping of interface id to whether or not it's supported
155    */
156   mapping(bytes4 => bool) private _supportedInterfaces;
157 
158   /**
159    * @dev A contract implementing SupportsInterfaceWithLookup
160    * implement ERC165 itself
161    */
162   constructor()
163     internal
164   {
165     _registerInterface(_InterfaceId_ERC165);
166   }
167 
168   /**
169    * @dev implement supportsInterface(bytes4) using a lookup table
170    */
171   function supportsInterface(bytes4 interfaceId)
172     external
173     view
174     returns (bool)
175   {
176     return _supportedInterfaces[interfaceId];
177   }
178 
179   /**
180    * @dev internal method for registering an interface
181    */
182   function _registerInterface(bytes4 interfaceId)
183     internal
184   {
185     require(interfaceId != 0xffffffff);
186     _supportedInterfaces[interfaceId] = true;
187   }
188 }
189 
190 
191 /**
192  * @title ERC721 Non-Fungible Token Standard basic implementation
193  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
194  */
195 contract ERC721 is ERC165, IERC721 {
196 
197   using SafeMath for uint256;
198   using Address for address;
199 
200   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
201   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
202   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
203 
204   // Mapping from token ID to owner
205   mapping (uint256 => address) private _tokenOwner;
206 
207   // Mapping from token ID to approved address
208   mapping (uint256 => address) private _tokenApprovals;
209 
210   // Mapping from owner to number of owned token
211   mapping (address => uint256) private _ownedTokensCount;
212 
213   // Mapping from owner to operator approvals
214   mapping (address => mapping (address => bool)) private _operatorApprovals;
215 
216   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
217   /*
218    * 0x80ac58cd ===
219    *   bytes4(keccak256('balanceOf(address)')) ^
220    *   bytes4(keccak256('ownerOf(uint256)')) ^
221    *   bytes4(keccak256('approve(address,uint256)')) ^
222    *   bytes4(keccak256('getApproved(uint256)')) ^
223    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
224    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
225    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
226    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
227    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
228    */
229 
230   constructor()
231     public
232   {
233     // register the supported interfaces to conform to ERC721 via ERC165
234     _registerInterface(_InterfaceId_ERC721);
235   }
236 
237   /**
238    * @dev Gets the balance of the specified address
239    * @param owner address to query the balance of
240    * @return uint256 representing the amount owned by the passed address
241    */
242   function balanceOf(address owner) public view returns (uint256) {
243     require(owner != address(0));
244     return _ownedTokensCount[owner];
245   }
246 
247   /**
248    * @dev Gets the owner of the specified token ID
249    * @param tokenId uint256 ID of the token to query the owner of
250    * @return owner address currently marked as the owner of the given token ID
251    */
252   function ownerOf(uint256 tokenId) public view returns (address) {
253     address owner = _tokenOwner[tokenId];
254     require(owner != address(0));
255     return owner;
256   }
257 
258   /**
259    * @dev Approves another address to transfer the given token ID
260    * The zero address indicates there is no approved address.
261    * There can only be one approved address per token at a given time.
262    * Can only be called by the token owner or an approved operator.
263    * @param to address to be approved for the given token ID
264    * @param tokenId uint256 ID of the token to be approved
265    */
266   function approve(address to, uint256 tokenId) public {
267     address owner = ownerOf(tokenId);
268     require(to != owner);
269     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
270 
271     _tokenApprovals[tokenId] = to;
272     emit Approval(owner, to, tokenId);
273   }
274 
275   /**
276    * @dev Gets the approved address for a token ID, or zero if no address set
277    * Reverts if the token ID does not exist.
278    * @param tokenId uint256 ID of the token to query the approval of
279    * @return address currently approved for the given token ID
280    */
281   function getApproved(uint256 tokenId) public view returns (address) {
282     require(_exists(tokenId));
283     return _tokenApprovals[tokenId];
284   }
285 
286   /**
287    * @dev Sets or unsets the approval of a given operator
288    * An operator is allowed to transfer all tokens of the sender on their behalf
289    * @param to operator address to set the approval
290    * @param approved representing the status of the approval to be set
291    */
292   function setApprovalForAll(address to, bool approved) public {
293     require(to != msg.sender);
294     _operatorApprovals[msg.sender][to] = approved;
295     emit ApprovalForAll(msg.sender, to, approved);
296   }
297 
298   /**
299    * @dev Tells whether an operator is approved by a given owner
300    * @param owner owner address which you want to query the approval of
301    * @param operator operator address which you want to query the approval of
302    * @return bool whether the given operator is approved by the given owner
303    */
304   function isApprovedForAll(
305     address owner,
306     address operator
307   )
308     public
309     view
310     returns (bool)
311   {
312     return _operatorApprovals[owner][operator];
313   }
314 
315   /**
316    * @dev Transfers the ownership of a given token ID to another address
317    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
318    * Requires the msg sender to be the owner, approved, or operator
319    * @param from current owner of the token
320    * @param to address to receive the ownership of the given token ID
321    * @param tokenId uint256 ID of the token to be transferred
322   */
323   function transferFrom(
324     address from,
325     address to,
326     uint256 tokenId
327   )
328     public
329   {
330     require(_isApprovedOrOwner(msg.sender, tokenId));
331     require(to != address(0));
332 
333     _clearApproval(from, tokenId);
334     _removeTokenFrom(from, tokenId);
335     _addTokenTo(to, tokenId);
336 
337     emit Transfer(from, to, tokenId);
338   }
339 
340   /**
341    * @dev Safely transfers the ownership of a given token ID to another address
342    * If the target address is a contract, it must implement `onERC721Received`,
343    * which is called upon a safe transfer, and return the magic value
344    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
345    * the transfer is reverted.
346    *
347    * Requires the msg sender to be the owner, approved, or operator
348    * @param from current owner of the token
349    * @param to address to receive the ownership of the given token ID
350    * @param tokenId uint256 ID of the token to be transferred
351   */
352   function safeTransferFrom(
353     address from,
354     address to,
355     uint256 tokenId
356   )
357     public
358   {
359     // solium-disable-next-line arg-overflow
360     safeTransferFrom(from, to, tokenId, "");
361   }
362 
363   /**
364    * @dev Safely transfers the ownership of a given token ID to another address
365    * If the target address is a contract, it must implement `onERC721Received`,
366    * which is called upon a safe transfer, and return the magic value
367    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
368    * the transfer is reverted.
369    * Requires the msg sender to be the owner, approved, or operator
370    * @param from current owner of the token
371    * @param to address to receive the ownership of the given token ID
372    * @param tokenId uint256 ID of the token to be transferred
373    * @param _data bytes data to send along with a safe transfer check
374    */
375   function safeTransferFrom(
376     address from,
377     address to,
378     uint256 tokenId,
379     bytes _data
380   )
381     public
382   {
383     transferFrom(from, to, tokenId);
384     // solium-disable-next-line arg-overflow
385     require(_checkOnERC721Received(from, to, tokenId, _data));
386   }
387 
388   /**
389    * @dev Returns whether the specified token exists
390    * @param tokenId uint256 ID of the token to query the existence of
391    * @return whether the token exists
392    */
393   function _exists(uint256 tokenId) internal view returns (bool) {
394     address owner = _tokenOwner[tokenId];
395     return owner != address(0);
396   }
397 
398   /**
399    * @dev Returns whether the given spender can transfer a given token ID
400    * @param spender address of the spender to query
401    * @param tokenId uint256 ID of the token to be transferred
402    * @return bool whether the msg.sender is approved for the given token ID,
403    *  is an operator of the owner, or is the owner of the token
404    */
405   function _isApprovedOrOwner(
406     address spender,
407     uint256 tokenId
408   )
409     internal
410     view
411     returns (bool)
412   {
413     address owner = ownerOf(tokenId);
414     // Disable solium check because of
415     // https://github.com/duaraghav8/Solium/issues/175
416     // solium-disable-next-line operator-whitespace
417     return (
418       spender == owner ||
419       getApproved(tokenId) == spender ||
420       isApprovedForAll(owner, spender)
421     );
422   }
423 
424   /**
425    * @dev Internal function to mint a new token
426    * Reverts if the given token ID already exists
427    * @param to The address that will own the minted token
428    * @param tokenId uint256 ID of the token to be minted by the msg.sender
429    */
430   function _mint(address to, uint256 tokenId) internal {
431     require(to != address(0));
432     _addTokenTo(to, tokenId);
433     emit Transfer(address(0), to, tokenId);
434   }
435 
436   /**
437    * @dev Internal function to burn a specific token
438    * Reverts if the token does not exist
439    * @param tokenId uint256 ID of the token being burned by the msg.sender
440    */
441   function _burn(address owner, uint256 tokenId) internal {
442     _clearApproval(owner, tokenId);
443     _removeTokenFrom(owner, tokenId);
444     emit Transfer(owner, address(0), tokenId);
445   }
446 
447   /**
448    * @dev Internal function to add a token ID to the list of a given address
449    * Note that this function is left internal to make ERC721Enumerable possible, but is not
450    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
451    * @param to address representing the new owner of the given token ID
452    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
453    */
454   function _addTokenTo(address to, uint256 tokenId) internal {
455     require(_tokenOwner[tokenId] == address(0));
456     _tokenOwner[tokenId] = to;
457     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
458   }
459 
460   /**
461    * @dev Internal function to remove a token ID from the list of a given address
462    * Note that this function is left internal to make ERC721Enumerable possible, but is not
463    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
464    * and doesn't clear approvals.
465    * @param from address representing the previous owner of the given token ID
466    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
467    */
468   function _removeTokenFrom(address from, uint256 tokenId) internal {
469     require(ownerOf(tokenId) == from);
470     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
471     _tokenOwner[tokenId] = address(0);
472   }
473 
474   /**
475    * @dev Internal function to invoke `onERC721Received` on a target address
476    * The call is not executed if the target address is not a contract
477    * @param from address representing the previous owner of the given token ID
478    * @param to target address that will receive the tokens
479    * @param tokenId uint256 ID of the token to be transferred
480    * @param _data bytes optional data to send along with the call
481    * @return whether the call correctly returned the expected magic value
482    */
483   function _checkOnERC721Received(
484     address from,
485     address to,
486     uint256 tokenId,
487     bytes _data
488   )
489     internal
490     returns (bool)
491   {
492     if (!to.isContract()) {
493       return true;
494     }
495     bytes4 retval = IERC721Receiver(to).onERC721Received(
496       msg.sender, from, tokenId, _data);
497     return (retval == _ERC721_RECEIVED);
498   }
499 
500   /**
501    * @dev Private function to clear current approval of a given token ID
502    * Reverts if the given address is not indeed the owner of the token
503    * @param owner owner of the token
504    * @param tokenId uint256 ID of the token to be transferred
505    */
506   function _clearApproval(address owner, uint256 tokenId) private {
507     require(ownerOf(tokenId) == owner);
508     if (_tokenApprovals[tokenId] != address(0)) {
509       _tokenApprovals[tokenId] = address(0);
510     }
511   }
512 }
513 
514 
515 
516 /**
517  * @title Ownable
518  * @dev The Ownable contract has an owner address, and provides basic authorization control
519  * functions, this simplifies the implementation of "user permissions".
520  */
521 contract Ownable {
522   address private _owner;
523 
524   event OwnershipTransferred(
525     address indexed previousOwner,
526     address indexed newOwner
527   );
528 
529   /**
530    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
531    * account.
532    */
533   constructor() internal {
534     _owner = msg.sender;
535     emit OwnershipTransferred(address(0), _owner);
536   }
537 
538   /**
539    * @return the address of the owner.
540    */
541   function owner() public view returns(address) {
542     return _owner;
543   }
544 
545   /**
546    * @dev Throws if called by any account other than the owner.
547    */
548   modifier onlyOwner() {
549     require(isOwner());
550     _;
551   }
552 
553   /**
554    * @return true if `msg.sender` is the owner of the contract.
555    */
556   function isOwner() public view returns(bool) {
557     return msg.sender == _owner;
558   }
559 
560   /**
561    * @dev Allows the current owner to relinquish control of the contract.
562    * @notice Renouncing to ownership will leave the contract without an owner.
563    * It will not be possible to call the functions with the `onlyOwner`
564    * modifier anymore.
565    */
566   function renounceOwnership() public onlyOwner {
567     emit OwnershipTransferred(_owner, address(0));
568     _owner = address(0);
569   }
570 
571   /**
572    * @dev Allows the current owner to transfer control of the contract to a newOwner.
573    * @param newOwner The address to transfer ownership to.
574    */
575   function transferOwnership(address newOwner) public onlyOwner {
576     _transferOwnership(newOwner);
577   }
578 
579   /**
580    * @dev Transfers control of the contract to a newOwner.
581    * @param newOwner The address to transfer ownership to.
582    */
583   function _transferOwnership(address newOwner) internal {
584     require(newOwner != address(0));
585     emit OwnershipTransferred(_owner, newOwner);
586     _owner = newOwner;
587   }
588 }
589 
590 
591 
592 /**
593  * @title SafeMath
594  * @dev Math operations with safety checks that revert on error
595  */
596 library SafeMath {
597 
598   /**
599   * @dev Multiplies two numbers, reverts on overflow.
600   */
601   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
602     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
603     // benefit is lost if 'b' is also tested.
604     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
605     if (a == 0) {
606       return 0;
607     }
608 
609     uint256 c = a * b;
610     require(c / a == b);
611 
612     return c;
613   }
614 
615   /**
616   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
617   */
618   function div(uint256 a, uint256 b) internal pure returns (uint256) {
619     require(b > 0); // Solidity only automatically asserts when dividing by 0
620     uint256 c = a / b;
621     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
622 
623     return c;
624   }
625 
626   /**
627   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
628   */
629   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
630     require(b <= a);
631     uint256 c = a - b;
632 
633     return c;
634   }
635 
636   /**
637   * @dev Adds two numbers, reverts on overflow.
638   */
639   function add(uint256 a, uint256 b) internal pure returns (uint256) {
640     uint256 c = a + b;
641     require(c >= a);
642 
643     return c;
644   }
645 
646   /**
647   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
648   * reverts when dividing by zero.
649   */
650   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
651     require(b != 0);
652     return a % b;
653   }
654 }
655 
656 
657 
658 contract CryptoHeart is ERC721, Ownable {
659 
660   function mint(address _to, uint256 tokenId) public onlyOwner {
661     _mint(_to, tokenId);
662   }
663 
664 }