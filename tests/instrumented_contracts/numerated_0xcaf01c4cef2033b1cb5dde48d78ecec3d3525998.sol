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
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 interface IERC20 {
27   function totalSupply() external view returns (uint256);
28 
29   function balanceOf(address who) external view returns (uint256);
30 
31   function allowance(address owner, address spender)
32     external view returns (uint256);
33 
34   function transfer(address to, uint256 value) external returns (bool);
35 
36   function approve(address spender, uint256 value)
37     external returns (bool);
38 
39   function transferFrom(address from, address to, uint256 value)
40     external returns (bool);
41 
42   event Transfer(
43     address indexed from,
44     address indexed to,
45     uint256 value
46   );
47 
48   event Approval(
49     address indexed owner,
50     address indexed spender,
51     uint256 value
52   );
53 }
54 
55 
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address private _owner;
65 
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() internal {
76     _owner = msg.sender;
77     emit OwnershipTransferred(address(0), _owner);
78   }
79 
80   /**
81    * @return the address of the owner.
82    */
83   function owner() public view returns(address) {
84     return _owner;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(isOwner());
92     _;
93   }
94 
95   /**
96    * @return true if `msg.sender` is the owner of the contract.
97    */
98   function isOwner() public view returns(bool) {
99     return msg.sender == _owner;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipTransferred(_owner, address(0));
110     _owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     _transferOwnership(newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address newOwner) internal {
126     require(newOwner != address(0));
127     emit OwnershipTransferred(_owner, newOwner);
128     _owner = newOwner;
129   }
130 }
131 
132 
133 
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that revert on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, reverts on overflow.
143   */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148     if (a == 0) {
149       return 0;
150     }
151 
152     uint256 c = a * b;
153     require(c / a == b);
154 
155     return c;
156   }
157 
158   /**
159   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
160   */
161   function div(uint256 a, uint256 b) internal pure returns (uint256) {
162     require(b > 0); // Solidity only automatically asserts when dividing by 0
163     uint256 c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166     return c;
167   }
168 
169   /**
170   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
171   */
172   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173     require(b <= a);
174     uint256 c = a - b;
175 
176     return c;
177   }
178 
179   /**
180   * @dev Adds two numbers, reverts on overflow.
181   */
182   function add(uint256 a, uint256 b) internal pure returns (uint256) {
183     uint256 c = a + b;
184     require(c >= a);
185 
186     return c;
187   }
188 
189   /**
190   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
191   * reverts when dividing by zero.
192   */
193   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194     require(b != 0);
195     return a % b;
196   }
197 }
198 
199 
200 
201 
202 
203 
204 
205 
206 
207 
208 /**
209  * @title ERC721 Non-Fungible Token Standard basic interface
210  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
211  */
212 contract IERC721 is IERC165 {
213 
214   event Transfer(
215     address indexed from,
216     address indexed to,
217     uint256 indexed tokenId
218   );
219   event Approval(
220     address indexed owner,
221     address indexed approved,
222     uint256 indexed tokenId
223   );
224   event ApprovalForAll(
225     address indexed owner,
226     address indexed operator,
227     bool approved
228   );
229 
230   function balanceOf(address owner) public view returns (uint256 balance);
231   function ownerOf(uint256 tokenId) public view returns (address owner);
232 
233   function approve(address to, uint256 tokenId) public;
234   function getApproved(uint256 tokenId)
235     public view returns (address operator);
236 
237   function setApprovalForAll(address operator, bool _approved) public;
238   function isApprovedForAll(address owner, address operator)
239     public view returns (bool);
240 
241   function transferFrom(address from, address to, uint256 tokenId) public;
242   function safeTransferFrom(address from, address to, uint256 tokenId)
243     public;
244 
245   function safeTransferFrom(
246     address from,
247     address to,
248     uint256 tokenId,
249     bytes data
250   )
251     public;
252 }
253 
254 
255 
256 /**
257  * @title ERC721 token receiver interface
258  * @dev Interface for any contract that wants to support safeTransfers
259  * from ERC721 asset contracts.
260  */
261 contract IERC721Receiver {
262   /**
263    * @notice Handle the receipt of an NFT
264    * @dev The ERC721 smart contract calls this function on the recipient
265    * after a `safeTransfer`. This function MUST return the function selector,
266    * otherwise the caller will revert the transaction. The selector to be
267    * returned can be obtained as `this.onERC721Received.selector`. This
268    * function MAY throw to revert and reject the transfer.
269    * Note: the ERC721 contract address is always the message sender.
270    * @param operator The address which called `safeTransferFrom` function
271    * @param from The address which previously owned the token
272    * @param tokenId The NFT identifier which is being transferred
273    * @param data Additional data with no specified format
274    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
275    */
276   function onERC721Received(
277     address operator,
278     address from,
279     uint256 tokenId,
280     bytes data
281   )
282     public
283     returns(bytes4);
284 }
285 
286 
287 
288 
289 /**
290  * Utility library of inline functions on addresses
291  */
292 library Address {
293 
294   /**
295    * Returns whether the target address is a contract
296    * @dev This function will return false if invoked during the constructor of a contract,
297    * as the code is not actually created until after the constructor finishes.
298    * @param account address of the account to check
299    * @return whether the target address is a contract
300    */
301   function isContract(address account) internal view returns (bool) {
302     uint256 size;
303     // XXX Currently there is no better way to check if there is a contract in an address
304     // than to check the size of the code at that address.
305     // See https://ethereum.stackexchange.com/a/14016/36603
306     // for more details about how this works.
307     // TODO Check this again before the Serenity release, because all addresses will be
308     // contracts then.
309     // solium-disable-next-line security/no-inline-assembly
310     assembly { size := extcodesize(account) }
311     return size > 0;
312   }
313 
314 }
315 
316 
317 
318 
319 
320 /**
321  * @title ERC165
322  * @author Matt Condon (@shrugs)
323  * @dev Implements ERC165 using a lookup table.
324  */
325 contract ERC165 is IERC165 {
326 
327   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
328   /**
329    * 0x01ffc9a7 ===
330    *   bytes4(keccak256('supportsInterface(bytes4)'))
331    */
332 
333   /**
334    * @dev a mapping of interface id to whether or not it's supported
335    */
336   mapping(bytes4 => bool) private _supportedInterfaces;
337 
338   /**
339    * @dev A contract implementing SupportsInterfaceWithLookup
340    * implement ERC165 itself
341    */
342   constructor()
343     internal
344   {
345     _registerInterface(_InterfaceId_ERC165);
346   }
347 
348   /**
349    * @dev implement supportsInterface(bytes4) using a lookup table
350    */
351   function supportsInterface(bytes4 interfaceId)
352     external
353     view
354     returns (bool)
355   {
356     return _supportedInterfaces[interfaceId];
357   }
358 
359   /**
360    * @dev internal method for registering an interface
361    */
362   function _registerInterface(bytes4 interfaceId)
363     internal
364   {
365     require(interfaceId != 0xffffffff);
366     _supportedInterfaces[interfaceId] = true;
367   }
368 }
369 
370 
371 /**
372  * @title ERC721 Non-Fungible Token Standard basic implementation
373  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
374  */
375 contract ERC721 is ERC165, IERC721 {
376 
377   using SafeMath for uint256;
378   using Address for address;
379 
380   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
381   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
382   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
383 
384   // Mapping from token ID to owner
385   mapping (uint256 => address) private _tokenOwner;
386 
387   // Mapping from token ID to approved address
388   mapping (uint256 => address) private _tokenApprovals;
389 
390   // Mapping from owner to number of owned token
391   mapping (address => uint256) private _ownedTokensCount;
392 
393   // Mapping from owner to operator approvals
394   mapping (address => mapping (address => bool)) private _operatorApprovals;
395 
396   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
397   /*
398    * 0x80ac58cd ===
399    *   bytes4(keccak256('balanceOf(address)')) ^
400    *   bytes4(keccak256('ownerOf(uint256)')) ^
401    *   bytes4(keccak256('approve(address,uint256)')) ^
402    *   bytes4(keccak256('getApproved(uint256)')) ^
403    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
404    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
405    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
406    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
407    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
408    */
409 
410   constructor()
411     public
412   {
413     // register the supported interfaces to conform to ERC721 via ERC165
414     _registerInterface(_InterfaceId_ERC721);
415   }
416 
417   /**
418    * @dev Gets the balance of the specified address
419    * @param owner address to query the balance of
420    * @return uint256 representing the amount owned by the passed address
421    */
422   function balanceOf(address owner) public view returns (uint256) {
423     require(owner != address(0));
424     return _ownedTokensCount[owner];
425   }
426 
427   /**
428    * @dev Gets the owner of the specified token ID
429    * @param tokenId uint256 ID of the token to query the owner of
430    * @return owner address currently marked as the owner of the given token ID
431    */
432   function ownerOf(uint256 tokenId) public view returns (address) {
433     address owner = _tokenOwner[tokenId];
434     require(owner != address(0));
435     return owner;
436   }
437 
438   /**
439    * @dev Approves another address to transfer the given token ID
440    * The zero address indicates there is no approved address.
441    * There can only be one approved address per token at a given time.
442    * Can only be called by the token owner or an approved operator.
443    * @param to address to be approved for the given token ID
444    * @param tokenId uint256 ID of the token to be approved
445    */
446   function approve(address to, uint256 tokenId) public {
447     address owner = ownerOf(tokenId);
448     require(to != owner);
449     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
450 
451     _tokenApprovals[tokenId] = to;
452     emit Approval(owner, to, tokenId);
453   }
454 
455   /**
456    * @dev Gets the approved address for a token ID, or zero if no address set
457    * Reverts if the token ID does not exist.
458    * @param tokenId uint256 ID of the token to query the approval of
459    * @return address currently approved for the given token ID
460    */
461   function getApproved(uint256 tokenId) public view returns (address) {
462     require(_exists(tokenId));
463     return _tokenApprovals[tokenId];
464   }
465 
466   /**
467    * @dev Sets or unsets the approval of a given operator
468    * An operator is allowed to transfer all tokens of the sender on their behalf
469    * @param to operator address to set the approval
470    * @param approved representing the status of the approval to be set
471    */
472   function setApprovalForAll(address to, bool approved) public {
473     require(to != msg.sender);
474     _operatorApprovals[msg.sender][to] = approved;
475     emit ApprovalForAll(msg.sender, to, approved);
476   }
477 
478   /**
479    * @dev Tells whether an operator is approved by a given owner
480    * @param owner owner address which you want to query the approval of
481    * @param operator operator address which you want to query the approval of
482    * @return bool whether the given operator is approved by the given owner
483    */
484   function isApprovedForAll(
485     address owner,
486     address operator
487   )
488     public
489     view
490     returns (bool)
491   {
492     return _operatorApprovals[owner][operator];
493   }
494 
495   /**
496    * @dev Transfers the ownership of a given token ID to another address
497    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
498    * Requires the msg sender to be the owner, approved, or operator
499    * @param from current owner of the token
500    * @param to address to receive the ownership of the given token ID
501    * @param tokenId uint256 ID of the token to be transferred
502   */
503   function transferFrom(
504     address from,
505     address to,
506     uint256 tokenId
507   )
508     public
509   {
510     require(_isApprovedOrOwner(msg.sender, tokenId));
511     require(to != address(0));
512 
513     _clearApproval(from, tokenId);
514     _removeTokenFrom(from, tokenId);
515     _addTokenTo(to, tokenId);
516 
517     emit Transfer(from, to, tokenId);
518   }
519 
520   /**
521    * @dev Safely transfers the ownership of a given token ID to another address
522    * If the target address is a contract, it must implement `onERC721Received`,
523    * which is called upon a safe transfer, and return the magic value
524    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
525    * the transfer is reverted.
526    *
527    * Requires the msg sender to be the owner, approved, or operator
528    * @param from current owner of the token
529    * @param to address to receive the ownership of the given token ID
530    * @param tokenId uint256 ID of the token to be transferred
531   */
532   function safeTransferFrom(
533     address from,
534     address to,
535     uint256 tokenId
536   )
537     public
538   {
539     // solium-disable-next-line arg-overflow
540     safeTransferFrom(from, to, tokenId, "");
541   }
542 
543   /**
544    * @dev Safely transfers the ownership of a given token ID to another address
545    * If the target address is a contract, it must implement `onERC721Received`,
546    * which is called upon a safe transfer, and return the magic value
547    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
548    * the transfer is reverted.
549    * Requires the msg sender to be the owner, approved, or operator
550    * @param from current owner of the token
551    * @param to address to receive the ownership of the given token ID
552    * @param tokenId uint256 ID of the token to be transferred
553    * @param _data bytes data to send along with a safe transfer check
554    */
555   function safeTransferFrom(
556     address from,
557     address to,
558     uint256 tokenId,
559     bytes _data
560   )
561     public
562   {
563     transferFrom(from, to, tokenId);
564     // solium-disable-next-line arg-overflow
565     require(_checkOnERC721Received(from, to, tokenId, _data));
566   }
567 
568   /**
569    * @dev Returns whether the specified token exists
570    * @param tokenId uint256 ID of the token to query the existence of
571    * @return whether the token exists
572    */
573   function _exists(uint256 tokenId) internal view returns (bool) {
574     address owner = _tokenOwner[tokenId];
575     return owner != address(0);
576   }
577 
578   /**
579    * @dev Returns whether the given spender can transfer a given token ID
580    * @param spender address of the spender to query
581    * @param tokenId uint256 ID of the token to be transferred
582    * @return bool whether the msg.sender is approved for the given token ID,
583    *  is an operator of the owner, or is the owner of the token
584    */
585   function _isApprovedOrOwner(
586     address spender,
587     uint256 tokenId
588   )
589     internal
590     view
591     returns (bool)
592   {
593     address owner = ownerOf(tokenId);
594     // Disable solium check because of
595     // https://github.com/duaraghav8/Solium/issues/175
596     // solium-disable-next-line operator-whitespace
597     return (
598       spender == owner ||
599       getApproved(tokenId) == spender ||
600       isApprovedForAll(owner, spender)
601     );
602   }
603 
604   /**
605    * @dev Internal function to mint a new token
606    * Reverts if the given token ID already exists
607    * @param to The address that will own the minted token
608    * @param tokenId uint256 ID of the token to be minted by the msg.sender
609    */
610   function _mint(address to, uint256 tokenId) internal {
611     require(to != address(0));
612     _addTokenTo(to, tokenId);
613     emit Transfer(address(0), to, tokenId);
614   }
615 
616   /**
617    * @dev Internal function to burn a specific token
618    * Reverts if the token does not exist
619    * @param tokenId uint256 ID of the token being burned by the msg.sender
620    */
621   function _burn(address owner, uint256 tokenId) internal {
622     _clearApproval(owner, tokenId);
623     _removeTokenFrom(owner, tokenId);
624     emit Transfer(owner, address(0), tokenId);
625   }
626 
627   /**
628    * @dev Internal function to add a token ID to the list of a given address
629    * Note that this function is left internal to make ERC721Enumerable possible, but is not
630    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
631    * @param to address representing the new owner of the given token ID
632    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
633    */
634   function _addTokenTo(address to, uint256 tokenId) internal {
635     require(_tokenOwner[tokenId] == address(0));
636     _tokenOwner[tokenId] = to;
637     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
638   }
639 
640   /**
641    * @dev Internal function to remove a token ID from the list of a given address
642    * Note that this function is left internal to make ERC721Enumerable possible, but is not
643    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
644    * and doesn't clear approvals.
645    * @param from address representing the previous owner of the given token ID
646    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
647    */
648   function _removeTokenFrom(address from, uint256 tokenId) internal {
649     require(ownerOf(tokenId) == from);
650     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
651     _tokenOwner[tokenId] = address(0);
652   }
653 
654   /**
655    * @dev Internal function to invoke `onERC721Received` on a target address
656    * The call is not executed if the target address is not a contract
657    * @param from address representing the previous owner of the given token ID
658    * @param to target address that will receive the tokens
659    * @param tokenId uint256 ID of the token to be transferred
660    * @param _data bytes optional data to send along with the call
661    * @return whether the call correctly returned the expected magic value
662    */
663   function _checkOnERC721Received(
664     address from,
665     address to,
666     uint256 tokenId,
667     bytes _data
668   )
669     internal
670     returns (bool)
671   {
672     if (!to.isContract()) {
673       return true;
674     }
675     bytes4 retval = IERC721Receiver(to).onERC721Received(
676       msg.sender, from, tokenId, _data);
677     return (retval == _ERC721_RECEIVED);
678   }
679 
680   /**
681    * @dev Private function to clear current approval of a given token ID
682    * Reverts if the given address is not indeed the owner of the token
683    * @param owner owner of the token
684    * @param tokenId uint256 ID of the token to be transferred
685    */
686   function _clearApproval(address owner, uint256 tokenId) private {
687     require(ownerOf(tokenId) == owner);
688     if (_tokenApprovals[tokenId] != address(0)) {
689       _tokenApprovals[tokenId] = address(0);
690     }
691   }
692 }
693 
694 
695 
696 
697 
698 contract CryptoHeart is ERC721, Ownable {
699 
700   function mint(address _to, uint256 tokenId) public onlyOwner {
701     _mint(_to, tokenId);
702   }
703 
704 }
705 
706 
707 
708 contract CryptoCan is Ownable {
709   using SafeMath for uint256;
710 
711   bool public fundraisingMode;
712   CryptoHeart public heartToken;
713   mapping(address => uint256) public supportedTokens;
714   mapping(address => uint256) public totalRaised;
715 
716   event Donation(address token, uint256 amount, uint256 timestamp, uint256 lowestTokenId);
717 
718   constructor(address _heartToken) public {
719     heartToken = CryptoHeart(_heartToken);
720   }
721 
722   /* Administration */
723 
724   function passOwnershipOfToken() public onlyOwner {
725     heartToken.transferOwnership(msg.sender);
726   }
727 
728   function configureTokens(address[] tokenAddresses, uint256[] minimumAmounts) public onlyOwner {
729     require(tokenAddresses.length == minimumAmounts.length, 'WRONG_LENGTH');
730     for (uint i = 0; i < tokenAddresses.length; i++) {
731       supportedTokens[tokenAddresses[i]] = minimumAmounts[i];
732     }
733   }
734 
735   function setFundraisingMode(bool _fundraisingMode) public onlyOwner {
736     fundraisingMode = _fundraisingMode;
737   }
738 
739   modifier requireFundraisingModeOn() {
740     require(fundraisingMode, 'NOT_IN_FUNDRAISING_MODE');
741     _;
742   }
743 
744   /* Public interface */
745 
746   function donateEth() payable public requireFundraisingModeOn {
747     require(supportedTokens[0] <= msg.value, 'TO_LOW_AMOUNT');
748     uint8 multiplyOfMinAmount = uint8(msg.value.div(supportedTokens[address(0)]));
749     owner().transfer(msg.value);
750     uint256 tokenId = _mintReward(msg.sender, multiplyOfMinAmount);
751     _bumpRaised(address(0), msg.value, tokenId);
752   }
753 
754   function donateToken(address _token, uint256 _amount) public requireFundraisingModeOn {
755     require(supportedTokens[_token] <= _amount, 'UNSUPPORTED_TOKEN_OR_TO_LOW_AMOUNT');
756     require(IERC20(_token).transferFrom(msg.sender, owner(), _amount), 'TRANSFER_FAILED');
757     uint8 multiplyOfMinAmount = uint8(_amount.div(supportedTokens[_token]));
758     uint256 tokenId = _mintReward(msg.sender, multiplyOfMinAmount);
759     _bumpRaised(_token, _amount, tokenId);
760   }
761 
762   function getRaisedInToken(address _token) public view returns (uint256) {
763     return totalRaised[_token];
764   }
765 
766   /* Private helpers */
767 
768   function _mintReward(address _to, uint8 multiplyOfMinAmount)
769     internal
770     returns  (uint256 tokenId)
771   {
772     tokenId = SafeMath.div(_random(), multiplyOfMinAmount);
773     heartToken.mint(_to, tokenId);
774   }
775 
776   function _random()
777     private view
778     returns (uint256)
779   {
780     return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
781   }
782 
783   function _bumpRaised(address _token, uint256 _amount, uint256 tokenId) internal {
784     totalRaised[_token] = totalRaised[_token].add(_amount);
785     emit Donation(_token, _amount, block.timestamp, tokenId);
786   }
787 
788 }