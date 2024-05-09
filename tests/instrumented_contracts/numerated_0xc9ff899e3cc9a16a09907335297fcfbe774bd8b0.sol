1 pragma solidity ^0.5;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b, 'MATH_ERROR');
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0, 'MATH_ERROR'); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a, 'MATH_ERROR');
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a, 'MATH_ERROR');
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0, 'MATH_ERROR');
64     return a % b;
65   }
66 }
67 
68 /**
69  * Utility library of inline functions on addresses
70  */
71 library Address {
72 
73   /**
74    * Returns whether the target address is a contract
75    * @dev This function will return false if invoked during the constructor of a contract,
76    * as the code is not actually created until after the constructor finishes.
77    * @param account address of the account to check
78    * @return whether the target address is a contract
79    */
80   function isContract(address account) internal view returns (bool) {
81     uint256 size;
82     // XXX Currently there is no better way to check if there is a contract in an address
83     // than to check the size of the code at that address.
84     // See https://ethereum.stackexchange.com/a/14016/36603
85     // for more details about how this works.
86     // TODO Check this again before the Serenity release, because all addresses will be
87     // contracts then.
88     // solium-disable-next-line security/no-inline-assembly
89     assembly { size := extcodesize(account) }
90     return size > 0;
91   }
92 }
93 
94 /**
95  * @title ERC721 token receiver interface
96  * @dev Interface for any contract that wants to support safeTransfers
97  * from ERC721 asset contracts.
98  */
99 contract IERC721Receiver {
100   /**
101    * @notice Handle the receipt of an NFT
102    * @dev The ERC721 smart contract calls this function on the recipient
103    * after a `safeTransfer`. This function MUST return the function selector,
104    * otherwise the caller will revert the transaction. The selector to be
105    * returned can be obtained as `this.onERC721Received.selector`. This
106    * function MAY throw to revert and reject the transfer.
107    * Note: the ERC721 contract address is always the message sender.
108    * @param operator The address which called `safeTransferFrom` function
109    * @param from The address which previously owned the token
110    * @param tokenId The NFT identifier which is being transferred
111    * @param data Additional data with no specified format
112    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
113    */
114   function onERC721Received(
115     address operator,
116     address from,
117     uint256 tokenId,
118     bytes memory data
119   )
120     public
121     returns(bytes4);
122 }
123 
124 /**
125  * @title IERC165
126  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
127  */
128 interface IERC165 {
129 
130   /**
131    * @notice Query if a contract implements an interface
132    * @param interfaceId The interface identifier, as specified in ERC-165
133    * @dev Interface identification is specified in ERC-165. This function
134    * uses less than 30,000 gas.
135    */
136   function supportsInterface(bytes4 interfaceId)
137     external
138     view
139     returns (bool);
140 }
141 
142 
143 /**
144  * @title ERC165
145  * @author Matt Condon (@shrugs)
146  * @dev Implements ERC165 using a lookup table.
147  */
148 contract ERC165 is IERC165 {
149 
150   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
151   /**
152    * 0x01ffc9a7 ===
153    *   bytes4(keccak256('supportsInterface(bytes4)'))
154    */
155 
156   /**
157    * @dev a mapping of interface id to whether or not it's supported
158    */
159   mapping(bytes4 => bool) private _supportedInterfaces;
160 
161   /**
162    * @dev A contract implementing SupportsInterfaceWithLookup
163    * implement ERC165 itself
164    */
165   constructor()
166     internal
167   {
168     _registerInterface(_InterfaceId_ERC165);
169   }
170 
171   /**
172    * @dev implement supportsInterface(bytes4) using a lookup table
173    */
174   function supportsInterface(bytes4 interfaceId)
175     external
176     view
177     returns (bool)
178   {
179     return _supportedInterfaces[interfaceId];
180   }
181 
182   /**
183    * @dev internal method for registering an interface
184    */
185   function _registerInterface(bytes4 interfaceId)
186     internal
187   {
188     require(interfaceId != 0xffffffff, 'INTERFACEID_MUST_NOT_BE_0xFFFFFFFF');
189     _supportedInterfaces[interfaceId] = true;
190   }
191 }
192 
193 /**
194  * @title ERC721 Non-Fungible Token Standard basic interface
195  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
196  */
197 contract IERC721 is IERC165 {
198 
199   event Transfer(
200     address indexed from,
201     address indexed to,
202     uint256 indexed tokenId
203   );
204   event Approval(
205     address indexed owner,
206     address indexed approved,
207     uint256 indexed tokenId
208   );
209   event ApprovalForAll(
210     address indexed owner,
211     address indexed operator,
212     bool approved
213   );
214 
215   function balanceOf(address owner) public view returns (uint256 balance);
216   function ownerOf(uint256 tokenId) public view returns (address owner);
217 
218   function approve(address to, uint256 tokenId) public;
219   function getApproved(uint256 tokenId)
220     public view returns (address operator);
221 
222   function setApprovalForAll(address operator, bool _approved) public;
223   function isApprovedForAll(address owner, address operator)
224     public view returns (bool);
225 
226   function transferFrom(address from, address to, uint256 tokenId) public;
227   function safeTransferFrom(address from, address to, uint256 tokenId)
228     public;
229 
230   function safeTransferFrom(
231     address from,
232     address to,
233     uint256 tokenId,
234     bytes memory data
235   )
236     public;
237 }
238 
239 
240 /**
241  * @title ERC721 Non-Fungible Token Standard basic implementation
242  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
243  */
244 contract ERC721 is ERC165, IERC721 {
245 
246   using SafeMath for uint256;
247   using Address for address;
248 
249   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
250   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
251   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
252 
253   // Mapping from token ID to owner
254   mapping (uint256 => address) private _tokenOwner;
255   
256   // Mapping from token ID to approved address
257   mapping (uint256 => address) private _tokenApprovals;
258 
259   // Mapping from owner to number of owned token
260   mapping (address => uint256) private _ownedTokensCount;
261 
262   // Mapping from owner to operator approvals
263   mapping (address => mapping (address => bool)) private _operatorApprovals;
264 
265   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
266   /*
267    * 0x80ac58cd ===
268    *   bytes4(keccak256('balanceOf(address)')) ^
269    *   bytes4(keccak256('ownerOf(uint256)')) ^
270    *   bytes4(keccak256('approve(address,uint256)')) ^
271    *   bytes4(keccak256('getApproved(uint256)')) ^
272    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
273    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
274    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
275    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
276    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
277    */
278 
279   constructor()
280     public
281   {
282     // register the supported interfaces to conform to ERC721 via ERC165
283     _registerInterface(_InterfaceId_ERC721);
284   }
285 
286   /**
287    * @dev Gets the balance of the specified address
288    * @param owner address to query the balance of
289    * @return uint256 representing the amount owned by the passed address
290    */
291   function balanceOf(address owner) public view returns (uint256) {
292     require(owner != address(0));
293     return _ownedTokensCount[owner];
294   }
295 
296   /**
297    * @dev Gets the owner of the specified token ID
298    * @param tokenId uint256 ID of the token to query the owner of
299    * @return owner address currently marked as the owner of the given token ID
300    */
301   function ownerOf(uint256 tokenId) public view returns (address) {
302     address owner = _tokenOwner[tokenId];
303     require(owner != address(0));
304     return owner;
305   }
306 
307   /**
308    * @dev Approves another address to transfer the given token ID
309    * The zero address indicates there is no approved address.
310    * There can only be one approved address per token at a given time.
311    * Can only be called by the token owner or an approved operator.
312    * @param to address to be approved for the given token ID
313    * @param tokenId uint256 ID of the token to be approved
314    */
315   function approve(address to, uint256 tokenId) public {
316     address owner = ownerOf(tokenId);
317     require(to != owner);
318     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
319 
320     _tokenApprovals[tokenId] = to;
321     emit Approval(owner, to, tokenId);
322   }
323 
324   /**
325    * @dev Gets the approved address for a token ID, or zero if no address set
326    * Reverts if the token ID does not exist.
327    * @param tokenId uint256 ID of the token to query the approval of
328    * @return address currently approved for the given token ID
329    */
330   function getApproved(uint256 tokenId) public view returns (address) {
331     require(_exists(tokenId), 'TOKEN_DOES_NOT_EXISTS');
332     return _tokenApprovals[tokenId];
333   }
334 
335   /**
336    * @dev Sets or unsets the approval of a given operator
337    * An operator is allowed to transfer all tokens of the sender on their behalf
338    * @param to operator address to set the approval
339    * @param approved representing the status of the approval to be set
340    */
341   function setApprovalForAll(address to, bool approved) public {
342     require(to != msg.sender, 'INVALID_TO_ADDRESS');
343     _operatorApprovals[msg.sender][to] = approved;
344     emit ApprovalForAll(msg.sender, to, approved);
345   }
346 
347   /**
348    * @dev Tells whether an operator is approved by a given owner
349    * @param owner owner address which you want to query the approval of
350    * @param operator operator address which you want to query the approval of
351    * @return bool whether the given operator is approved by the given owner
352    */
353   function isApprovedForAll(
354     address owner,
355     address operator
356   )
357     public
358     view
359     returns (bool)
360   {
361     return _operatorApprovals[owner][operator];
362   }
363 
364   /**
365    * @dev Transfers the ownership of a given token ID to another address
366    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
367    * Requires the msg sender to be the owner, approved, or operator
368    * @param from current owner of the token
369    * @param to address to receive the ownership of the given token ID
370    * @param tokenId uint256 ID of the token to be transferred
371   */
372   function transferFrom(
373     address from,
374     address to,
375     uint256 tokenId
376   )
377     public
378   {
379     require(_isApprovedOrOwner(msg.sender, tokenId), 'IS_NOT_APPOVED');
380     require(to != address(0), 'INVALID_TO_ADDRESS');
381 
382     _clearApproval(from, tokenId);
383     _removeTokenFrom(from, tokenId);
384     _addTokenTo(to, tokenId);
385 
386     emit Transfer(from, to, tokenId);
387   }
388 
389   /**
390    * @dev Safely transfers the ownership of a given token ID to another address
391    * If the target address is a contract, it must implement `onERC721Received`,
392    * which is called upon a safe transfer, and return the magic value
393    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
394    * the transfer is reverted.
395    *
396    * Requires the msg sender to be the owner, approved, or operator
397    * @param from current owner of the token
398    * @param to address to receive the ownership of the given token ID
399    * @param tokenId uint256 ID of the token to be transferred
400   */
401   function safeTransferFrom(
402     address from,
403     address to,
404     uint256 tokenId
405   )
406     public
407   {
408     // solium-disable-next-line arg-overflow
409     safeTransferFrom(from, to, tokenId, "");
410   }
411 
412   /**
413    * @dev Safely transfers the ownership of a given token ID to another address
414    * If the target address is a contract, it must implement `onERC721Received`,
415    * which is called upon a safe transfer, and return the magic value
416    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
417    * the transfer is reverted.
418    * Requires the msg sender to be the owner, approved, or operator
419    * @param from current owner of the token
420    * @param to address to receive the ownership of the given token ID
421    * @param tokenId uint256 ID of the token to be transferred
422    * @param _data bytes data to send along with a safe transfer check
423    */
424   function safeTransferFrom(
425     address from,
426     address to,
427     uint256 tokenId,
428     bytes memory _data
429   )
430     public
431   {
432     transferFrom(from, to, tokenId);
433     // solium-disable-next-line arg-overflow
434     require(_checkOnERC721Received(from, to, tokenId, _data), 'TOKEN_IS_NOT_RECIVED');
435   }
436 
437   /**
438    * @dev Returns whether the specified token exists
439    * @param tokenId uint256 ID of the token to query the existence of
440    * @return whether the token exists
441    */
442   function _exists(uint256 tokenId) internal view returns (bool) {
443     address owner = _tokenOwner[tokenId];
444     return owner != address(0);
445   }
446 
447   /**
448    * @dev Returns whether the given spender can transfer a given token ID
449    * @param spender address of the spender to query
450    * @param tokenId uint256 ID of the token to be transferred
451    * @return bool whether the msg.sender is approved for the given token ID,
452    *  is an operator of the owner, or is the owner of the token
453    */
454   function _isApprovedOrOwner(
455     address spender,
456     uint256 tokenId
457   )
458     internal
459     view
460     returns (bool)
461   {
462     address owner = ownerOf(tokenId);
463     // Disable solium check because of
464     // https://github.com/duaraghav8/Solium/issues/175
465     // solium-disable-next-line operator-whitespace
466     return (
467       spender == owner ||
468       getApproved(tokenId) == spender ||
469       isApprovedForAll(owner, spender)
470     );
471   }
472 
473   /**
474    * @dev Internal function to mint a new token
475    * Reverts if the given token ID already exists
476    * @param to The address that will own the minted token
477    * @param tokenId uint256 ID of the token to be minted by the msg.sender
478    */
479   function _mint(address to, uint256 tokenId) internal {
480     require(to != address(0), 'INVALID_TO_ADDRESS');
481     _addTokenTo(to, tokenId);
482     emit Transfer(address(0), to, tokenId);
483   }
484 
485   /**
486    * @dev Internal function to burn a specific token
487    * Reverts if the token does not exist
488    * @param tokenId uint256 ID of the token being burned by the msg.sender
489    */
490   function _burn(address owner, uint256 tokenId) internal {
491     _clearApproval(owner, tokenId);
492     _removeTokenFrom(owner, tokenId);
493     emit Transfer(owner, address(0), tokenId);
494   }
495 
496   /**
497    * @dev Internal function to add a token ID to the list of a given address
498    * Note that this function is left internal to make ERC721Enumerable possible, but is not
499    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
500    * @param to address representing the new owner of the given token ID
501    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
502    */
503   function _addTokenTo(address to, uint256 tokenId) internal {
504     require(_tokenOwner[tokenId] == address(0));
505     _tokenOwner[tokenId] = to;
506     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
507   }
508 
509   /**
510    * @dev Internal function to remove a token ID from the list of a given address
511    * Note that this function is left internal to make ERC721Enumerable possible, but is not
512    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
513    * and doesn't clear approvals.
514    * @param from address representing the previous owner of the given token ID
515    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
516    */
517   function _removeTokenFrom(address from, uint256 tokenId) internal {
518     require(ownerOf(tokenId) == from, 'FROM_IS_NOT_TOKEN_OWNER');
519     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
520     _tokenOwner[tokenId] = address(0);
521   }
522 
523   /**
524    * @dev Internal function to invoke `onERC721Received` on a target address
525    * The call is not executed if the target address is not a contract
526    * @param from address representing the previous owner of the given token ID
527    * @param to target address that will receive the tokens
528    * @param tokenId uint256 ID of the token to be transferred
529    * @param _data bytes optional data to send along with the call
530    * @return whether the call correctly returned the expected magic value
531    */
532   function _checkOnERC721Received(
533     address from,
534     address to,
535     uint256 tokenId,
536     bytes memory _data
537   )
538     internal
539     returns (bool)
540   {
541     if (!to.isContract()) {
542       return true;
543     }
544     bytes4 retval = IERC721Receiver(to).onERC721Received(
545       msg.sender, from, tokenId, _data);
546     return (retval == _ERC721_RECEIVED);
547   }
548 
549   /**
550    * @dev Internal function to clear current approval of a given token ID
551    * Reverts if the given address is not indeed the owner of the token
552    * @param owner owner of the token
553    * @param tokenId uint256 ID of the token to be transferred
554    */
555   function _clearApproval(address owner, uint256 tokenId) internal {
556     require(ownerOf(tokenId) == owner, 'OWNER_IS_NOT_TOKEN_OWNER');
557     if (_tokenApprovals[tokenId] != address(0)) {
558       _tokenApprovals[tokenId] = address(0);
559     }
560   }
561 }
562 
563 
564 /**
565  * @title Ownable
566  * @dev The Ownable contract has an owner address, and provides basic authorization control
567  * functions, this simplifies the implementation of "user permissions".
568  */
569 contract Ownable {
570   address private _owner;
571   mapping(address => bool) private managers;
572 
573   event OwnershipTransferred(
574     address indexed previousOwner,
575     address indexed newOwner
576   );
577 
578   /**
579    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
580    * account.
581    */
582   constructor() internal {
583     _owner = msg.sender;
584     managers[msg.sender] = true;
585     emit OwnershipTransferred(address(0), _owner);
586   }
587 
588   /**
589    * @return the address of the owner.
590    */
591   function owner() public view returns(address) {
592     return _owner;
593   }
594 
595   /**
596    * @dev Throws if called by any account other than the owner.
597    */
598   modifier onlyOwner() {
599     require(isOwner(), 'SENDER_IS_NOT_OWNER');
600     _;
601   }
602 
603   /**
604    * @return true if `msg.sender` is the owner of the contract.
605    */
606   function isOwner() public view returns(bool) {
607     return msg.sender == _owner;
608   }
609   /**
610    * @dev Allows the current owner to relinquish control of the contract.
611    * @notice Renouncing to ownership will leave the contract without an owner.
612    * It will not be possible to call the functions with the `onlyOwner`
613    * modifier anymore.
614    */
615   function renounceOwnership() public onlyOwner {
616     emit OwnershipTransferred(_owner, address(0));
617     _owner = address(0);
618   }
619 
620   /**
621    * @dev Allows the current owner to transfer control of the contract to a newOwner.
622    * @param newOwner The address to transfer ownership to.
623    */
624   function transferOwnership(address newOwner) public onlyOwner {
625     _transferOwnership(newOwner);
626   }
627 
628   /**
629    * @dev Transfers control of the contract to a newOwner.
630    * @param newOwner The address to transfer ownership to.
631    */
632   function _transferOwnership(address newOwner) internal {
633     require(newOwner != address(0),'INVALID_NEW_OWNER');
634     emit OwnershipTransferred(_owner, newOwner);
635     _owner = newOwner;
636   }
637 }
638 
639 
640 contract EightMacrh is ERC721, Ownable {
641     using SafeMath for uint256;
642     
643     string public name;
644     string public symbol;
645     uint8 public decimals = 0;
646     uint public price;
647     uint public maxTotalSupply;
648     uint public totalSupply = 0;
649     uint public lastTokenId = 0;
650     
651     mapping(uint => string) public tokenData;
652     mapping(uint => uint) public tokenCost;
653     
654     constructor(string memory _name, 
655                 string memory _symbol, 
656                 uint _price,
657                 uint _maxTotalSupply) public {
658         name = _name;
659         symbol = _symbol;
660         price = _price;
661         maxTotalSupply = _maxTotalSupply;
662     }
663     
664     function mint(address to, string calldata data) external payable returns(uint) {
665         require(msg.value >= price, 'NOT_ENOUG_MONEY');
666         lastTokenId = lastTokenId.add(1);
667         tokenData[lastTokenId] = data;
668         tokenCost[lastTokenId] = msg.value;
669         totalSupply = totalSupply.add(1);
670         _mint(to, lastTokenId);
671         return lastTokenId;
672     }
673     
674     function upCost(uint tokenId) external payable {
675         require(tokenId <= lastTokenId, 'INVALID_TOKEN_ID');
676         tokenCost[tokenId] = tokenCost[tokenId].add(msg.value);
677     }
678     
679     function getInfo(uint tokenId) external view returns(string memory, uint) {
680         require(tokenId >= lastTokenId, 'TOKEN_DOES_NOT_EXISTS');
681         return (tokenData[tokenId], tokenCost[tokenId]);
682     }
683     
684     function withdraw(uint value, address payable to) onlyOwner external {
685         require(address(this).balance >= value, 'NOT_ENOUG_MONEY');
686         to.transfer(value);
687     }
688 }