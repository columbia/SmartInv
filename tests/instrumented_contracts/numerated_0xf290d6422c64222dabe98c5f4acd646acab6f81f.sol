1 pragma solidity ^0.4.24;
2 
3 // File: contracts/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
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
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/zeppelin-solidity/contracts/introspection/ERC165.sol
68 
69 /**
70  * @title ERC165
71  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
72  */
73 interface ERC165 {
74 
75   /**
76    * @notice Query if a contract implements an interface
77    * @param _interfaceId The interface identifier, as specified in ERC-165
78    * @dev Interface identification is specified in ERC-165. This function
79    * uses less than 30,000 gas.
80    */
81   function supportsInterface(bytes4 _interfaceId)
82     external
83     view
84     returns (bool);
85 }
86 
87 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
88 
89 /**
90  * @title ERC721 Non-Fungible Token Standard basic interface
91  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
92  */
93 contract ERC721Basic is ERC165 {
94 
95   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
96   /*
97    * 0x80ac58cd ===
98    *   bytes4(keccak256('balanceOf(address)')) ^
99    *   bytes4(keccak256('ownerOf(uint256)')) ^
100    *   bytes4(keccak256('approve(address,uint256)')) ^
101    *   bytes4(keccak256('getApproved(uint256)')) ^
102    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
103    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
104    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
105    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
106    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
107    */
108 
109   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
110   /*
111    * 0x4f558e79 ===
112    *   bytes4(keccak256('exists(uint256)'))
113    */
114 
115   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
116   /**
117    * 0x780e9d63 ===
118    *   bytes4(keccak256('totalSupply()')) ^
119    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
120    *   bytes4(keccak256('tokenByIndex(uint256)'))
121    */
122 
123   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
124   /**
125    * 0x5b5e139f ===
126    *   bytes4(keccak256('name()')) ^
127    *   bytes4(keccak256('symbol()')) ^
128    *   bytes4(keccak256('tokenURI(uint256)'))
129    */
130 
131   event Transfer(
132     address indexed _from,
133     address indexed _to,
134     uint256 indexed _tokenId
135   );
136   event Approval(
137     address indexed _owner,
138     address indexed _approved,
139     uint256 indexed _tokenId
140   );
141   event ApprovalForAll(
142     address indexed _owner,
143     address indexed _operator,
144     bool _approved
145   );
146 
147   function balanceOf(address _owner) public view returns (uint256 _balance);
148   function ownerOf(uint256 _tokenId) public view returns (address _owner);
149   function exists(uint256 _tokenId) public view returns (bool _exists);
150 
151   function approve(address _to, uint256 _tokenId) public;
152   function getApproved(uint256 _tokenId)
153     public view returns (address _operator);
154 
155   function setApprovalForAll(address _operator, bool _approved) public;
156   function isApprovedForAll(address _owner, address _operator)
157     public view returns (bool);
158 
159   function transferFrom(address _from, address _to, uint256 _tokenId) public;
160   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
161     public;
162 
163   function safeTransferFrom(
164     address _from,
165     address _to,
166     uint256 _tokenId,
167     bytes _data
168   )
169     public;
170 }
171 
172 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721.sol
173 
174 /**
175  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
176  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
177  */
178 contract ERC721Enumerable is ERC721Basic {
179   function totalSupply() public view returns (uint256);
180   function tokenOfOwnerByIndex(
181     address _owner,
182     uint256 _index
183   )
184     public
185     view
186     returns (uint256 _tokenId);
187 
188   function tokenByIndex(uint256 _index) public view returns (uint256);
189 }
190 
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
195  */
196 contract ERC721Metadata is ERC721Basic {
197   function name() external view returns (string _name);
198   function symbol() external view returns (string _symbol);
199   function tokenURI(uint256 _tokenId) public view returns (string);
200 }
201 
202 
203 /**
204  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
205  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
206  */
207 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
208 }
209 
210 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
211 
212 /**
213  * @title ERC721 token receiver interface
214  * @dev Interface for any contract that wants to support safeTransfers
215  * from ERC721 asset contracts.
216  */
217 contract ERC721Receiver {
218   /**
219    * @dev Magic value to be returned upon successful reception of an NFT
220    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
221    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
222    */
223   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
224 
225   /**
226    * @notice Handle the receipt of an NFT
227    * @dev The ERC721 smart contract calls this function on the recipient
228    * after a `safetransfer`. This function MAY throw to revert and reject the
229    * transfer. Return of other than the magic value MUST result in the
230    * transaction being reverted.
231    * Note: the contract address is always the message sender.
232    * @param _operator The address which called `safeTransferFrom` function
233    * @param _from The address which previously owned the token
234    * @param _tokenId The NFT identifier which is being transferred
235    * @param _data Additional data with no specified format
236    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
237    */
238   function onERC721Received(
239     address _operator,
240     address _from,
241     uint256 _tokenId,
242     bytes _data
243   )
244     public
245     returns(bytes4);
246 }
247 
248 // File: contracts/zeppelin-solidity/contracts/math/SafeMath.sol
249 
250 /**
251  * @title SafeMath
252  * @dev Math operations with safety checks that throw on error
253  */
254 library SafeMath {
255 
256   /**
257   * @dev Multiplies two numbers, throws on overflow.
258   */
259   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
260     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
261     // benefit is lost if 'b' is also tested.
262     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
263     if (_a == 0) {
264       return 0;
265     }
266 
267     c = _a * _b;
268     assert(c / _a == _b);
269     return c;
270   }
271 
272   /**
273   * @dev Integer division of two numbers, truncating the quotient.
274   */
275   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
276     // assert(_b > 0); // Solidity automatically throws when dividing by 0
277     // uint256 c = _a / _b;
278     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
279     return _a / _b;
280   }
281 
282   /**
283   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
284   */
285   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
286     assert(_b <= _a);
287     return _a - _b;
288   }
289 
290   /**
291   * @dev Adds two numbers, throws on overflow.
292   */
293   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
294     c = _a + _b;
295     assert(c >= _a);
296     return c;
297   }
298 }
299 
300 // File: contracts/zeppelin-solidity/contracts/AddressUtils.sol
301 
302 /**
303  * Utility library of inline functions on addresses
304  */
305 library AddressUtils {
306 
307   /**
308    * Returns whether the target address is a contract
309    * @dev This function will return false if invoked during the constructor of a contract,
310    * as the code is not actually created until after the constructor finishes.
311    * @param _addr address to check
312    * @return whether the target address is a contract
313    */
314   function isContract(address _addr) internal view returns (bool) {
315     uint256 size;
316     // XXX Currently there is no better way to check if there is a contract in an address
317     // than to check the size of the code at that address.
318     // See https://ethereum.stackexchange.com/a/14016/36603
319     // for more details about how this works.
320     // TODO Check this again before the Serenity release, because all addresses will be
321     // contracts then.
322     // solium-disable-next-line security/no-inline-assembly
323     assembly { size := extcodesize(_addr) }
324     return size > 0;
325   }
326 
327 }
328 
329 // File: contracts/zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
330 
331 /**
332  * @title SupportsInterfaceWithLookup
333  * @author Matt Condon (@shrugs)
334  * @dev Implements ERC165 using a lookup table.
335  */
336 contract SupportsInterfaceWithLookup is ERC165 {
337 
338   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
339   /**
340    * 0x01ffc9a7 ===
341    *   bytes4(keccak256('supportsInterface(bytes4)'))
342    */
343 
344   /**
345    * @dev a mapping of interface id to whether or not it's supported
346    */
347   mapping(bytes4 => bool) internal supportedInterfaces;
348 
349   /**
350    * @dev A contract implementing SupportsInterfaceWithLookup
351    * implement ERC165 itself
352    */
353   constructor()
354     public
355   {
356     _registerInterface(InterfaceId_ERC165);
357   }
358 
359   /**
360    * @dev implement supportsInterface(bytes4) using a lookup table
361    */
362   function supportsInterface(bytes4 _interfaceId)
363     external
364     view
365     returns (bool)
366   {
367     return supportedInterfaces[_interfaceId];
368   }
369 
370   /**
371    * @dev private method for registering an interface
372    */
373   function _registerInterface(bytes4 _interfaceId)
374     internal
375   {
376     require(_interfaceId != 0xffffffff);
377     supportedInterfaces[_interfaceId] = true;
378   }
379 }
380 
381 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
382 
383 /**
384  * @title ERC721 Non-Fungible Token Standard basic implementation
385  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
386  */
387 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
388 
389   using SafeMath for uint256;
390   using AddressUtils for address;
391 
392   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
393   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
394   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
395 
396   // Mapping from token ID to owner
397   mapping (uint256 => address) internal tokenOwner;
398 
399   // Mapping from token ID to approved address
400   mapping (uint256 => address) internal tokenApprovals;
401 
402   // Mapping from owner to number of owned token
403   mapping (address => uint256) internal ownedTokensCount;
404 
405   // Mapping from owner to operator approvals
406   mapping (address => mapping (address => bool)) internal operatorApprovals;
407 
408   constructor()
409     public
410   {
411     // register the supported interfaces to conform to ERC721 via ERC165
412     _registerInterface(InterfaceId_ERC721);
413     _registerInterface(InterfaceId_ERC721Exists);
414   }
415 
416   /**
417    * @dev Gets the balance of the specified address
418    * @param _owner address to query the balance of
419    * @return uint256 representing the amount owned by the passed address
420    */
421   function balanceOf(address _owner) public view returns (uint256) {
422     require(_owner != address(0));
423     return ownedTokensCount[_owner];
424   }
425 
426   /**
427    * @dev Gets the owner of the specified token ID
428    * @param _tokenId uint256 ID of the token to query the owner of
429    * @return owner address currently marked as the owner of the given token ID
430    */
431   function ownerOf(uint256 _tokenId) public view returns (address) {
432     address owner = tokenOwner[_tokenId];
433     require(owner != address(0));
434     return owner;
435   }
436 
437   /**
438    * @dev Returns whether the specified token exists
439    * @param _tokenId uint256 ID of the token to query the existence of
440    * @return whether the token exists
441    */
442   function exists(uint256 _tokenId) public view returns (bool) {
443     address owner = tokenOwner[_tokenId];
444     return owner != address(0);
445   }
446 
447   /**
448    * @dev Approves another address to transfer the given token ID
449    * The zero address indicates there is no approved address.
450    * There can only be one approved address per token at a given time.
451    * Can only be called by the token owner or an approved operator.
452    * @param _to address to be approved for the given token ID
453    * @param _tokenId uint256 ID of the token to be approved
454    */
455   function approve(address _to, uint256 _tokenId) public {
456     address owner = ownerOf(_tokenId);
457     require(_to != owner);
458     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
459 
460     tokenApprovals[_tokenId] = _to;
461     emit Approval(owner, _to, _tokenId);
462   }
463 
464   /**
465    * @dev Gets the approved address for a token ID, or zero if no address set
466    * @param _tokenId uint256 ID of the token to query the approval of
467    * @return address currently approved for the given token ID
468    */
469   function getApproved(uint256 _tokenId) public view returns (address) {
470     return tokenApprovals[_tokenId];
471   }
472 
473   /**
474    * @dev Sets or unsets the approval of a given operator
475    * An operator is allowed to transfer all tokens of the sender on their behalf
476    * @param _to operator address to set the approval
477    * @param _approved representing the status of the approval to be set
478    */
479   function setApprovalForAll(address _to, bool _approved) public {
480     require(_to != msg.sender);
481     operatorApprovals[msg.sender][_to] = _approved;
482     emit ApprovalForAll(msg.sender, _to, _approved);
483   }
484 
485   /**
486    * @dev Tells whether an operator is approved by a given owner
487    * @param _owner owner address which you want to query the approval of
488    * @param _operator operator address which you want to query the approval of
489    * @return bool whether the given operator is approved by the given owner
490    */
491   function isApprovedForAll(
492     address _owner,
493     address _operator
494   )
495     public
496     view
497     returns (bool)
498   {
499     return operatorApprovals[_owner][_operator];
500   }
501 
502   /**
503    * @dev Transfers the ownership of a given token ID to another address
504    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
505    * Requires the msg sender to be the owner, approved, or operator
506    * @param _from current owner of the token
507    * @param _to address to receive the ownership of the given token ID
508    * @param _tokenId uint256 ID of the token to be transferred
509   */
510   function transferFrom(
511     address _from,
512     address _to,
513     uint256 _tokenId
514   )
515     public
516   {
517     require(isApprovedOrOwner(msg.sender, _tokenId));
518     require(_from != address(0));
519     require(_to != address(0));
520 
521     clearApproval(_from, _tokenId);
522     removeTokenFrom(_from, _tokenId);
523     addTokenTo(_to, _tokenId);
524 
525     emit Transfer(_from, _to, _tokenId);
526   }
527 
528   /**
529    * @dev Safely transfers the ownership of a given token ID to another address
530    * If the target address is a contract, it must implement `onERC721Received`,
531    * which is called upon a safe transfer, and return the magic value
532    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
533    * the transfer is reverted.
534    *
535    * Requires the msg sender to be the owner, approved, or operator
536    * @param _from current owner of the token
537    * @param _to address to receive the ownership of the given token ID
538    * @param _tokenId uint256 ID of the token to be transferred
539   */
540   function safeTransferFrom(
541     address _from,
542     address _to,
543     uint256 _tokenId
544   )
545     public
546   {
547     // solium-disable-next-line arg-overflow
548     safeTransferFrom(_from, _to, _tokenId, "");
549   }
550 
551   /**
552    * @dev Safely transfers the ownership of a given token ID to another address
553    * If the target address is a contract, it must implement `onERC721Received`,
554    * which is called upon a safe transfer, and return the magic value
555    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
556    * the transfer is reverted.
557    * Requires the msg sender to be the owner, approved, or operator
558    * @param _from current owner of the token
559    * @param _to address to receive the ownership of the given token ID
560    * @param _tokenId uint256 ID of the token to be transferred
561    * @param _data bytes data to send along with a safe transfer check
562    */
563   function safeTransferFrom(
564     address _from,
565     address _to,
566     uint256 _tokenId,
567     bytes _data
568   )
569     public
570   {
571     transferFrom(_from, _to, _tokenId);
572     // solium-disable-next-line arg-overflow
573     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
574   }
575 
576   /**
577    * @dev Returns whether the given spender can transfer a given token ID
578    * @param _spender address of the spender to query
579    * @param _tokenId uint256 ID of the token to be transferred
580    * @return bool whether the msg.sender is approved for the given token ID,
581    *  is an operator of the owner, or is the owner of the token
582    */
583   function isApprovedOrOwner(
584     address _spender,
585     uint256 _tokenId
586   )
587     internal
588     view
589     returns (bool)
590   {
591     address owner = ownerOf(_tokenId);
592     // Disable solium check because of
593     // https://github.com/duaraghav8/Solium/issues/175
594     // solium-disable-next-line operator-whitespace
595     return (
596       _spender == owner ||
597       getApproved(_tokenId) == _spender ||
598       isApprovedForAll(owner, _spender)
599     );
600   }
601 
602   /**
603    * @dev Internal function to mint a new token
604    * Reverts if the given token ID already exists
605    * @param _to The address that will own the minted token
606    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
607    */
608   function _mint(address _to, uint256 _tokenId) internal {
609     require(_to != address(0));
610     addTokenTo(_to, _tokenId);
611     emit Transfer(address(0), _to, _tokenId);
612   }
613 
614   /**
615    * @dev Internal function to burn a specific token
616    * Reverts if the token does not exist
617    * @param _tokenId uint256 ID of the token being burned by the msg.sender
618    */
619   function _burn(address _owner, uint256 _tokenId) internal {
620     clearApproval(_owner, _tokenId);
621     removeTokenFrom(_owner, _tokenId);
622     emit Transfer(_owner, address(0), _tokenId);
623   }
624 
625   /**
626    * @dev Internal function to clear current approval of a given token ID
627    * Reverts if the given address is not indeed the owner of the token
628    * @param _owner owner of the token
629    * @param _tokenId uint256 ID of the token to be transferred
630    */
631   function clearApproval(address _owner, uint256 _tokenId) internal {
632     require(ownerOf(_tokenId) == _owner);
633     if (tokenApprovals[_tokenId] != address(0)) {
634       tokenApprovals[_tokenId] = address(0);
635     }
636   }
637 
638   /**
639    * @dev Internal function to add a token ID to the list of a given address
640    * @param _to address representing the new owner of the given token ID
641    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
642    */
643   function addTokenTo(address _to, uint256 _tokenId) internal {
644     require(tokenOwner[_tokenId] == address(0));
645     tokenOwner[_tokenId] = _to;
646     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
647   }
648 
649   /**
650    * @dev Internal function to remove a token ID from the list of a given address
651    * @param _from address representing the previous owner of the given token ID
652    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
653    */
654   function removeTokenFrom(address _from, uint256 _tokenId) internal {
655     require(ownerOf(_tokenId) == _from);
656     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
657     tokenOwner[_tokenId] = address(0);
658   }
659 
660   /**
661    * @dev Internal function to invoke `onERC721Received` on a target address
662    * The call is not executed if the target address is not a contract
663    * @param _from address representing the previous owner of the given token ID
664    * @param _to target address that will receive the tokens
665    * @param _tokenId uint256 ID of the token to be transferred
666    * @param _data bytes optional data to send along with the call
667    * @return whether the call correctly returned the expected magic value
668    */
669   function checkAndCallSafeTransfer(
670     address _from,
671     address _to,
672     uint256 _tokenId,
673     bytes _data
674   )
675     internal
676     returns (bool)
677   {
678     if (!_to.isContract()) {
679       return true;
680     }
681     bytes4 retval = ERC721Receiver(_to).onERC721Received(
682       msg.sender, _from, _tokenId, _data);
683     return (retval == ERC721_RECEIVED);
684   }
685 }
686 
687 // File: contracts/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
688 
689 /**
690  * @title Full ERC721 Token
691  * This implementation includes all the required and some optional functionality of the ERC721 standard
692  * Moreover, it includes approve all functionality using operator terminology
693  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
694  */
695 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
696 
697   // Token name
698   string internal name_;
699 
700   // Token symbol
701   string internal symbol_;
702 
703   // Mapping from owner to list of owned token IDs
704   mapping(address => uint256[]) internal ownedTokens;
705 
706   // Mapping from token ID to index of the owner tokens list
707   mapping(uint256 => uint256) internal ownedTokensIndex;
708 
709   // Array with all token ids, used for enumeration
710   uint256[] internal allTokens;
711 
712   // Mapping from token id to position in the allTokens array
713   mapping(uint256 => uint256) internal allTokensIndex;
714 
715   // Optional mapping for token URIs
716   mapping(uint256 => string) internal tokenURIs;
717 
718   /**
719    * @dev Constructor function
720    */
721   constructor(string _name, string _symbol) public {
722     name_ = _name;
723     symbol_ = _symbol;
724 
725     // register the supported interfaces to conform to ERC721 via ERC165
726     _registerInterface(InterfaceId_ERC721Enumerable);
727     _registerInterface(InterfaceId_ERC721Metadata);
728   }
729 
730   /**
731    * @dev Gets the token name
732    * @return string representing the token name
733    */
734   function name() external view returns (string) {
735     return name_;
736   }
737 
738   /**
739    * @dev Gets the token symbol
740    * @return string representing the token symbol
741    */
742   function symbol() external view returns (string) {
743     return symbol_;
744   }
745 
746   /**
747    * @dev Returns an URI for a given token ID
748    * Throws if the token ID does not exist. May return an empty string.
749    * @param _tokenId uint256 ID of the token to query
750    */
751   function tokenURI(uint256 _tokenId) public view returns (string) {
752     require(exists(_tokenId));
753     return tokenURIs[_tokenId];
754   }
755 
756   /**
757    * @dev Gets the token ID at a given index of the tokens list of the requested owner
758    * @param _owner address owning the tokens list to be accessed
759    * @param _index uint256 representing the index to be accessed of the requested tokens list
760    * @return uint256 token ID at the given index of the tokens list owned by the requested address
761    */
762   function tokenOfOwnerByIndex(
763     address _owner,
764     uint256 _index
765   )
766     public
767     view
768     returns (uint256)
769   {
770     require(_index < balanceOf(_owner));
771     return ownedTokens[_owner][_index];
772   }
773 
774   /**
775    * @dev Gets the total amount of tokens stored by the contract
776    * @return uint256 representing the total amount of tokens
777    */
778   function totalSupply() public view returns (uint256) {
779     return allTokens.length;
780   }
781 
782   /**
783    * @dev Gets the token ID at a given index of all the tokens in this contract
784    * Reverts if the index is greater or equal to the total number of tokens
785    * @param _index uint256 representing the index to be accessed of the tokens list
786    * @return uint256 token ID at the given index of the tokens list
787    */
788   function tokenByIndex(uint256 _index) public view returns (uint256) {
789     require(_index < totalSupply());
790     return allTokens[_index];
791   }
792 
793   /**
794    * @dev Internal function to set the token URI for a given token
795    * Reverts if the token ID does not exist
796    * @param _tokenId uint256 ID of the token to set its URI
797    * @param _uri string URI to assign
798    */
799   function _setTokenURI(uint256 _tokenId, string _uri) internal {
800     require(exists(_tokenId));
801     tokenURIs[_tokenId] = _uri;
802   }
803 
804   /**
805    * @dev Internal function to add a token ID to the list of a given address
806    * @param _to address representing the new owner of the given token ID
807    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
808    */
809   function addTokenTo(address _to, uint256 _tokenId) internal {
810     super.addTokenTo(_to, _tokenId);
811     uint256 length = ownedTokens[_to].length;
812     ownedTokens[_to].push(_tokenId);
813     ownedTokensIndex[_tokenId] = length;
814   }
815 
816   /**
817    * @dev Internal function to remove a token ID from the list of a given address
818    * @param _from address representing the previous owner of the given token ID
819    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
820    */
821   function removeTokenFrom(address _from, uint256 _tokenId) internal {
822     super.removeTokenFrom(_from, _tokenId);
823 
824     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
825     // then delete the last slot.
826     uint256 tokenIndex = ownedTokensIndex[_tokenId];
827     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
828     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
829 
830     ownedTokens[_from][tokenIndex] = lastToken;
831     // This also deletes the contents at the last position of the array
832     ownedTokens[_from].length--;
833 
834     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
835     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
836     // the lastToken to the first position, and then dropping the element placed in the last position of the list
837 
838     ownedTokensIndex[_tokenId] = 0;
839     ownedTokensIndex[lastToken] = tokenIndex;
840   }
841 
842   /**
843    * @dev Internal function to mint a new token
844    * Reverts if the given token ID already exists
845    * @param _to address the beneficiary that will own the minted token
846    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
847    */
848   function _mint(address _to, uint256 _tokenId) internal {
849     super._mint(_to, _tokenId);
850 
851     allTokensIndex[_tokenId] = allTokens.length;
852     allTokens.push(_tokenId);
853   }
854 
855   /**
856    * @dev Internal function to burn a specific token
857    * Reverts if the token does not exist
858    * @param _owner owner of the token to burn
859    * @param _tokenId uint256 ID of the token being burned by the msg.sender
860    */
861   function _burn(address _owner, uint256 _tokenId) internal {
862     super._burn(_owner, _tokenId);
863 
864     // Clear metadata (if any)
865     if (bytes(tokenURIs[_tokenId]).length != 0) {
866       delete tokenURIs[_tokenId];
867     }
868 
869     // Reorg all tokens array
870     uint256 tokenIndex = allTokensIndex[_tokenId];
871     uint256 lastTokenIndex = allTokens.length.sub(1);
872     uint256 lastToken = allTokens[lastTokenIndex];
873 
874     allTokens[tokenIndex] = lastToken;
875     allTokens[lastTokenIndex] = 0;
876 
877     allTokens.length--;
878     allTokensIndex[_tokenId] = 0;
879     allTokensIndex[lastToken] = tokenIndex;
880   }
881 
882 }
883 
884 // File: contracts/helpers/strings.sol
885 
886 /*
887  * @title String & slice utility library for Solidity contracts.
888  * @author Nick Johnson <arachnid@notdot.net>
889  *
890  * @dev Functionality in this library is largely implemented using an
891  *      abstraction called a 'slice'. A slice represents a part of a string -
892  *      anything from the entire string to a single character, or even no
893  *      characters at all (a 0-length slice). Since a slice only has to specify
894  *      an offset and a length, copying and manipulating slices is a lot less
895  *      expensive than copying and manipulating the strings they reference.
896  *
897  *      To further reduce gas costs, most functions on slice that need to return
898  *      a slice modify the original one instead of allocating a new one; for
899  *      instance, `s.split(".")` will return the text up to the first '.',
900  *      modifying s to only contain the remainder of the string after the '.'.
901  *      In situations where you do not want to modify the original slice, you
902  *      can make a copy first with `.copy()`, for example:
903  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
904  *      Solidity has no memory management, it will result in allocating many
905  *      short-lived slices that are later discarded.
906  *
907  *      Functions that return two slices come in two versions: a non-allocating
908  *      version that takes the second slice as an argument, modifying it in
909  *      place, and an allocating version that allocates and returns the second
910  *      slice; see `nextRune` for example.
911  *
912  *      Functions that have to copy string data will return strings rather than
913  *      slices; these can be cast back to slices for further processing if
914  *      required.
915  *
916  *      For convenience, some functions are provided with non-modifying
917  *      variants that create a new slice and return both; for instance,
918  *      `s.splitNew('.')` leaves s unmodified, and returns two values
919  *      corresponding to the left and right parts of the string.
920  */
921 
922 pragma solidity ^0.4.14;
923 
924 library strings {
925     struct slice {
926         uint _len;
927         uint _ptr;
928     }
929 
930     function memcpy(uint dest, uint src, uint len) private {
931         // Copy word-length chunks while possible
932         for(; len >= 32; len -= 32) {
933             assembly {
934                 mstore(dest, mload(src))
935             }
936             dest += 32;
937             src += 32;
938         }
939 
940         // Copy remaining bytes
941         uint mask = 256 ** (32 - len) - 1;
942         assembly {
943             let srcpart := and(mload(src), not(mask))
944             let destpart := and(mload(dest), mask)
945             mstore(dest, or(destpart, srcpart))
946         }
947     }
948 
949     /*
950      * @dev Returns a slice containing the entire string.
951      * @param self The string to make a slice from.
952      * @return A newly allocated slice containing the entire string.
953      */
954     function toSlice(string self) internal returns (slice) {
955         uint ptr;
956         assembly {
957             ptr := add(self, 0x20)
958         }
959         return slice(bytes(self).length, ptr);
960     }
961 
962     /*
963      * @dev Returns the length of a null-terminated bytes32 string.
964      * @param self The value to find the length of.
965      * @return The length of the string, from 0 to 32.
966      */
967     function len(bytes32 self) internal returns (uint) {
968         uint ret;
969         if (self == 0)
970             return 0;
971         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
972             ret += 16;
973             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
974         }
975         if (self & 0xffffffffffffffff == 0) {
976             ret += 8;
977             self = bytes32(uint(self) / 0x10000000000000000);
978         }
979         if (self & 0xffffffff == 0) {
980             ret += 4;
981             self = bytes32(uint(self) / 0x100000000);
982         }
983         if (self & 0xffff == 0) {
984             ret += 2;
985             self = bytes32(uint(self) / 0x10000);
986         }
987         if (self & 0xff == 0) {
988             ret += 1;
989         }
990         return 32 - ret;
991     }
992 
993     /*
994      * @dev Returns a slice containing the entire bytes32, interpreted as a
995      *      null-termintaed utf-8 string.
996      * @param self The bytes32 value to convert to a slice.
997      * @return A new slice containing the value of the input argument up to the
998      *         first null.
999      */
1000     function toSliceB32(bytes32 self) internal returns (slice ret) {
1001         // Allocate space for `self` in memory, copy it there, and point ret at it
1002         assembly {
1003             let ptr := mload(0x40)
1004             mstore(0x40, add(ptr, 0x20))
1005             mstore(ptr, self)
1006             mstore(add(ret, 0x20), ptr)
1007         }
1008         ret._len = len(self);
1009     }
1010 
1011     /*
1012      * @dev Returns a new slice containing the same data as the current slice.
1013      * @param self The slice to copy.
1014      * @return A new slice containing the same data as `self`.
1015      */
1016     function copy(slice self) internal returns (slice) {
1017         return slice(self._len, self._ptr);
1018     }
1019 
1020     /*
1021      * @dev Copies a slice to a new string.
1022      * @param self The slice to copy.
1023      * @return A newly allocated string containing the slice's text.
1024      */
1025     function toString(slice self) internal returns (string) {
1026         var ret = new string(self._len);
1027         uint retptr;
1028         assembly { retptr := add(ret, 32) }
1029 
1030         memcpy(retptr, self._ptr, self._len);
1031         return ret;
1032     }
1033 
1034     /*
1035      * @dev Returns the length in runes of the slice. Note that this operation
1036      *      takes time proportional to the length of the slice; avoid using it
1037      *      in loops, and call `slice.empty()` if you only need to know whether
1038      *      the slice is empty or not.
1039      * @param self The slice to operate on.
1040      * @return The length of the slice in runes.
1041      */
1042     function len(slice self) internal returns (uint l) {
1043         // Starting at ptr-31 means the LSB will be the byte we care about
1044         var ptr = self._ptr - 31;
1045         var end = ptr + self._len;
1046         for (l = 0; ptr < end; l++) {
1047             uint8 b;
1048             assembly { b := and(mload(ptr), 0xFF) }
1049             if (b < 0x80) {
1050                 ptr += 1;
1051             } else if(b < 0xE0) {
1052                 ptr += 2;
1053             } else if(b < 0xF0) {
1054                 ptr += 3;
1055             } else if(b < 0xF8) {
1056                 ptr += 4;
1057             } else if(b < 0xFC) {
1058                 ptr += 5;
1059             } else {
1060                 ptr += 6;
1061             }
1062         }
1063     }
1064 
1065     /*
1066      * @dev Returns true if the slice is empty (has a length of 0).
1067      * @param self The slice to operate on.
1068      * @return True if the slice is empty, False otherwise.
1069      */
1070     function empty(slice self) internal returns (bool) {
1071         return self._len == 0;
1072     }
1073 
1074     /*
1075      * @dev Returns a positive number if `other` comes lexicographically after
1076      *      `self`, a negative number if it comes before, or zero if the
1077      *      contents of the two slices are equal. Comparison is done per-rune,
1078      *      on unicode codepoints.
1079      * @param self The first slice to compare.
1080      * @param other The second slice to compare.
1081      * @return The result of the comparison.
1082      */
1083     function compare(slice self, slice other) internal returns (int) {
1084         uint shortest = self._len;
1085         if (other._len < self._len)
1086             shortest = other._len;
1087 
1088         var selfptr = self._ptr;
1089         var otherptr = other._ptr;
1090         for (uint idx = 0; idx < shortest; idx += 32) {
1091             uint a;
1092             uint b;
1093             assembly {
1094                 a := mload(selfptr)
1095                 b := mload(otherptr)
1096             }
1097             if (a != b) {
1098                 // Mask out irrelevant bytes and check again
1099                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1100                 var diff = (a & mask) - (b & mask);
1101                 if (diff != 0)
1102                     return int(diff);
1103             }
1104             selfptr += 32;
1105             otherptr += 32;
1106         }
1107         return int(self._len) - int(other._len);
1108     }
1109 
1110     /*
1111      * @dev Returns true if the two slices contain the same text.
1112      * @param self The first slice to compare.
1113      * @param self The second slice to compare.
1114      * @return True if the slices are equal, false otherwise.
1115      */
1116     function equals(slice self, slice other) internal returns (bool) {
1117         return compare(self, other) == 0;
1118     }
1119 
1120     /*
1121      * @dev Extracts the first rune in the slice into `rune`, advancing the
1122      *      slice to point to the next rune and returning `self`.
1123      * @param self The slice to operate on.
1124      * @param rune The slice that will contain the first rune.
1125      * @return `rune`.
1126      */
1127     function nextRune(slice self, slice rune) internal returns (slice) {
1128         rune._ptr = self._ptr;
1129 
1130         if (self._len == 0) {
1131             rune._len = 0;
1132             return rune;
1133         }
1134 
1135         uint leng;
1136         uint b;
1137         // Load the first byte of the rune into the LSBs of b
1138         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1139         if (b < 0x80) {
1140             leng = 1;
1141         } else if(b < 0xE0) {
1142             leng = 2;
1143         } else if(b < 0xF0) {
1144             leng = 3;
1145         } else {
1146             leng = 4;
1147         }
1148 
1149         // Check for truncated codepoints
1150         if (leng > self._len) {
1151             rune._len = self._len;
1152             self._ptr += self._len;
1153             self._len = 0;
1154             return rune;
1155         }
1156 
1157         self._ptr += leng;
1158         self._len -= leng;
1159         rune._len = leng;
1160         return rune;
1161     }
1162 
1163     /*
1164      * @dev Returns the first rune in the slice, advancing the slice to point
1165      *      to the next rune.
1166      * @param self The slice to operate on.
1167      * @return A slice containing only the first rune from `self`.
1168      */
1169     function nextRune(slice self) internal returns (slice ret) {
1170         nextRune(self, ret);
1171     }
1172 
1173     /*
1174      * @dev Returns the number of the first codepoint in the slice.
1175      * @param self The slice to operate on.
1176      * @return The number of the first codepoint in the slice.
1177      */
1178     function ord(slice self) internal returns (uint ret) {
1179         if (self._len == 0) {
1180             return 0;
1181         }
1182 
1183         uint word;
1184         uint length;
1185         uint divisor = 2 ** 248;
1186 
1187         // Load the rune into the MSBs of b
1188         assembly { word:= mload(mload(add(self, 32))) }
1189         var b = word / divisor;
1190         if (b < 0x80) {
1191             ret = b;
1192             length = 1;
1193         } else if(b < 0xE0) {
1194             ret = b & 0x1F;
1195             length = 2;
1196         } else if(b < 0xF0) {
1197             ret = b & 0x0F;
1198             length = 3;
1199         } else {
1200             ret = b & 0x07;
1201             length = 4;
1202         }
1203 
1204         // Check for truncated codepoints
1205         if (length > self._len) {
1206             return 0;
1207         }
1208 
1209         for (uint i = 1; i < length; i++) {
1210             divisor = divisor / 256;
1211             b = (word / divisor) & 0xFF;
1212             if (b & 0xC0 != 0x80) {
1213                 // Invalid UTF-8 sequence
1214                 return 0;
1215             }
1216             ret = (ret * 64) | (b & 0x3F);
1217         }
1218 
1219         return ret;
1220     }
1221 
1222     /*
1223      * @dev Returns the keccak-256 hash of the slice.
1224      * @param self The slice to hash.
1225      * @return The hash of the slice.
1226      */
1227     function keccak(slice self) internal returns (bytes32 ret) {
1228         assembly {
1229             ret := keccak256(mload(add(self, 32)), mload(self))
1230         }
1231     }
1232 
1233     /*
1234      * @dev Returns true if `self` starts with `needle`.
1235      * @param self The slice to operate on.
1236      * @param needle The slice to search for.
1237      * @return True if the slice starts with the provided text, false otherwise.
1238      */
1239     function startsWith(slice self, slice needle) internal returns (bool) {
1240         if (self._len < needle._len) {
1241             return false;
1242         }
1243 
1244         if (self._ptr == needle._ptr) {
1245             return true;
1246         }
1247 
1248         bool equal;
1249         assembly {
1250             let length := mload(needle)
1251             let selfptr := mload(add(self, 0x20))
1252             let needleptr := mload(add(needle, 0x20))
1253             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1254         }
1255         return equal;
1256     }
1257 
1258     /*
1259      * @dev If `self` starts with `needle`, `needle` is removed from the
1260      *      beginning of `self`. Otherwise, `self` is unmodified.
1261      * @param self The slice to operate on.
1262      * @param needle The slice to search for.
1263      * @return `self`
1264      */
1265     function beyond(slice self, slice needle) internal returns (slice) {
1266         if (self._len < needle._len) {
1267             return self;
1268         }
1269 
1270         bool equal = true;
1271         if (self._ptr != needle._ptr) {
1272             assembly {
1273                 let length := mload(needle)
1274                 let selfptr := mload(add(self, 0x20))
1275                 let needleptr := mload(add(needle, 0x20))
1276                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1277             }
1278         }
1279 
1280         if (equal) {
1281             self._len -= needle._len;
1282             self._ptr += needle._len;
1283         }
1284 
1285         return self;
1286     }
1287 
1288     /*
1289      * @dev Returns true if the slice ends with `needle`.
1290      * @param self The slice to operate on.
1291      * @param needle The slice to search for.
1292      * @return True if the slice starts with the provided text, false otherwise.
1293      */
1294     function endsWith(slice self, slice needle) internal returns (bool) {
1295         if (self._len < needle._len) {
1296             return false;
1297         }
1298 
1299         var selfptr = self._ptr + self._len - needle._len;
1300 
1301         if (selfptr == needle._ptr) {
1302             return true;
1303         }
1304 
1305         bool equal;
1306         assembly {
1307             let length := mload(needle)
1308             let needleptr := mload(add(needle, 0x20))
1309             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1310         }
1311 
1312         return equal;
1313     }
1314 
1315     /*
1316      * @dev If `self` ends with `needle`, `needle` is removed from the
1317      *      end of `self`. Otherwise, `self` is unmodified.
1318      * @param self The slice to operate on.
1319      * @param needle The slice to search for.
1320      * @return `self`
1321      */
1322     function until(slice self, slice needle) internal returns (slice) {
1323         if (self._len < needle._len) {
1324             return self;
1325         }
1326 
1327         var selfptr = self._ptr + self._len - needle._len;
1328         bool equal = true;
1329         if (selfptr != needle._ptr) {
1330             assembly {
1331                 let length := mload(needle)
1332                 let needleptr := mload(add(needle, 0x20))
1333                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1334             }
1335         }
1336 
1337         if (equal) {
1338             self._len -= needle._len;
1339         }
1340 
1341         return self;
1342     }
1343 
1344     // Returns the memory address of the first byte of the first occurrence of
1345     // `needle` in `self`, or the first byte after `self` if not found.
1346     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1347         uint ptr;
1348         uint idx;
1349 
1350         if (needlelen <= selflen) {
1351             if (needlelen <= 32) {
1352                 // Optimized assembly for 68 gas per byte on short strings
1353                 assembly {
1354                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1355                     let needledata := and(mload(needleptr), mask)
1356                     let end := add(selfptr, sub(selflen, needlelen))
1357                     ptr := selfptr
1358                     loop:
1359                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1360                     ptr := add(ptr, 1)
1361                     jumpi(loop, lt(sub(ptr, 1), end))
1362                     ptr := add(selfptr, selflen)
1363                     exit:
1364                 }
1365                 return ptr;
1366             } else {
1367                 // For long needles, use hashing
1368                 bytes32 hash;
1369                 assembly { hash := sha3(needleptr, needlelen) }
1370                 ptr = selfptr;
1371                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1372                     bytes32 testHash;
1373                     assembly { testHash := sha3(ptr, needlelen) }
1374                     if (hash == testHash)
1375                         return ptr;
1376                     ptr += 1;
1377                 }
1378             }
1379         }
1380         return selfptr + selflen;
1381     }
1382 
1383     // Returns the memory address of the first byte after the last occurrence of
1384     // `needle` in `self`, or the address of `self` if not found.
1385     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1386         uint ptr;
1387 
1388         if (needlelen <= selflen) {
1389             if (needlelen <= 32) {
1390                 // Optimized assembly for 69 gas per byte on short strings
1391                 assembly {
1392                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1393                     let needledata := and(mload(needleptr), mask)
1394                     ptr := add(selfptr, sub(selflen, needlelen))
1395                     loop:
1396                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1397                     ptr := sub(ptr, 1)
1398                     jumpi(loop, gt(add(ptr, 1), selfptr))
1399                     ptr := selfptr
1400                     jump(exit)
1401                     ret:
1402                     ptr := add(ptr, needlelen)
1403                     exit:
1404                 }
1405                 return ptr;
1406             } else {
1407                 // For long needles, use hashing
1408                 bytes32 hash;
1409                 assembly { hash := sha3(needleptr, needlelen) }
1410                 ptr = selfptr + (selflen - needlelen);
1411                 while (ptr >= selfptr) {
1412                     bytes32 testHash;
1413                     assembly { testHash := sha3(ptr, needlelen) }
1414                     if (hash == testHash)
1415                         return ptr + needlelen;
1416                     ptr -= 1;
1417                 }
1418             }
1419         }
1420         return selfptr;
1421     }
1422 
1423     /*
1424      * @dev Modifies `self` to contain everything from the first occurrence of
1425      *      `needle` to the end of the slice. `self` is set to the empty slice
1426      *      if `needle` is not found.
1427      * @param self The slice to search and modify.
1428      * @param needle The text to search for.
1429      * @return `self`.
1430      */
1431     function find(slice self, slice needle) internal returns (slice) {
1432         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1433         self._len -= ptr - self._ptr;
1434         self._ptr = ptr;
1435         return self;
1436     }
1437 
1438     /*
1439      * @dev Modifies `self` to contain the part of the string from the start of
1440      *      `self` to the end of the first occurrence of `needle`. If `needle`
1441      *      is not found, `self` is set to the empty slice.
1442      * @param self The slice to search and modify.
1443      * @param needle The text to search for.
1444      * @return `self`.
1445      */
1446     function rfind(slice self, slice needle) internal returns (slice) {
1447         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1448         self._len = ptr - self._ptr;
1449         return self;
1450     }
1451 
1452     /*
1453      * @dev Splits the slice, setting `self` to everything after the first
1454      *      occurrence of `needle`, and `token` to everything before it. If
1455      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1456      *      and `token` is set to the entirety of `self`.
1457      * @param self The slice to split.
1458      * @param needle The text to search for in `self`.
1459      * @param token An output parameter to which the first token is written.
1460      * @return `token`.
1461      */
1462     function split(slice self, slice needle, slice token) internal returns (slice) {
1463         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1464         token._ptr = self._ptr;
1465         token._len = ptr - self._ptr;
1466         if (ptr == self._ptr + self._len) {
1467             // Not found
1468             self._len = 0;
1469         } else {
1470             self._len -= token._len + needle._len;
1471             self._ptr = ptr + needle._len;
1472         }
1473         return token;
1474     }
1475 
1476     /*
1477      * @dev Splits the slice, setting `self` to everything after the first
1478      *      occurrence of `needle`, and returning everything before it. If
1479      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1480      *      and the entirety of `self` is returned.
1481      * @param self The slice to split.
1482      * @param needle The text to search for in `self`.
1483      * @return The part of `self` up to the first occurrence of `delim`.
1484      */
1485     function split(slice self, slice needle) internal returns (slice token) {
1486         split(self, needle, token);
1487     }
1488 
1489     /*
1490      * @dev Splits the slice, setting `self` to everything before the last
1491      *      occurrence of `needle`, and `token` to everything after it. If
1492      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1493      *      and `token` is set to the entirety of `self`.
1494      * @param self The slice to split.
1495      * @param needle The text to search for in `self`.
1496      * @param token An output parameter to which the first token is written.
1497      * @return `token`.
1498      */
1499     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1500         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1501         token._ptr = ptr;
1502         token._len = self._len - (ptr - self._ptr);
1503         if (ptr == self._ptr) {
1504             // Not found
1505             self._len = 0;
1506         } else {
1507             self._len -= token._len + needle._len;
1508         }
1509         return token;
1510     }
1511 
1512     /*
1513      * @dev Splits the slice, setting `self` to everything before the last
1514      *      occurrence of `needle`, and returning everything after it. If
1515      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1516      *      and the entirety of `self` is returned.
1517      * @param self The slice to split.
1518      * @param needle The text to search for in `self`.
1519      * @return The part of `self` after the last occurrence of `delim`.
1520      */
1521     function rsplit(slice self, slice needle) internal returns (slice token) {
1522         rsplit(self, needle, token);
1523     }
1524 
1525     /*
1526      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1527      * @param self The slice to search.
1528      * @param needle The text to search for in `self`.
1529      * @return The number of occurrences of `needle` found in `self`.
1530      */
1531     function count(slice self, slice needle) internal returns (uint cnt) {
1532         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1533         while (ptr <= self._ptr + self._len) {
1534             cnt++;
1535             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1536         }
1537     }
1538 
1539     /*
1540      * @dev Returns True if `self` contains `needle`.
1541      * @param self The slice to search.
1542      * @param needle The text to search for in `self`.
1543      * @return True if `needle` is found in `self`, false otherwise.
1544      */
1545     function contains(slice self, slice needle) internal returns (bool) {
1546         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1547     }
1548 
1549     /*
1550      * @dev Returns a newly allocated string containing the concatenation of
1551      *      `self` and `other`.
1552      * @param self The first slice to concatenate.
1553      * @param other The second slice to concatenate.
1554      * @return The concatenation of the two strings.
1555      */
1556     function concat(slice self, slice other) internal returns (string) {
1557         var ret = new string(self._len + other._len);
1558         uint retptr;
1559         assembly { retptr := add(ret, 32) }
1560         memcpy(retptr, self._ptr, self._len);
1561         memcpy(retptr + self._len, other._ptr, other._len);
1562         return ret;
1563     }
1564 
1565     /*
1566      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1567      *      newly allocated string.
1568      * @param self The delimiter to use.
1569      * @param parts A list of slices to join.
1570      * @return A newly allocated string containing all the slices in `parts`,
1571      *         joined with `self`.
1572      */
1573     function join(slice self, slice[] parts) internal returns (string) {
1574         if (parts.length == 0)
1575             return "";
1576 
1577         uint length = self._len * (parts.length - 1);
1578         for(uint i = 0; i < parts.length; i++)
1579             length += parts[i]._len;
1580 
1581         var ret = new string(length);
1582         uint retptr;
1583         assembly { retptr := add(ret, 32) }
1584 
1585         for(i = 0; i < parts.length; i++) {
1586             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1587             retptr += parts[i]._len;
1588             if (i < parts.length - 1) {
1589                 memcpy(retptr, self._ptr, self._len);
1590                 retptr += self._len;
1591             }
1592         }
1593 
1594         return ret;
1595     }
1596 }
1597 
1598 // File: contracts/Metadata.sol
1599 
1600 /* pragma experimental ABIEncoderV2; */
1601 
1602 /**
1603 * CloversMetadata contract is upgradeable and returns metadata about Clovers
1604 */
1605 
1606 
1607 contract Metadata {
1608     using strings for *;
1609 
1610     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
1611         string memory base = "https://ensnifty.com/metadata?hash=0x";
1612         string memory id = uint2hexstr(_tokenId);
1613         return base.toSlice().concat(id.toSlice());
1614     }
1615     function uint2hexstr(uint i) internal pure returns (string) {
1616         if (i == 0) return "0";
1617         uint j = i;
1618         uint length;
1619         while (j != 0) {
1620             length++;
1621             j = j >> 4;
1622         }
1623         uint mask = 15;
1624         bytes memory bstr = new bytes(length);
1625         uint k = length - 1;
1626         while (i != 0){
1627             uint curr = (i & mask);
1628             bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
1629             i = i >> 4;
1630         }
1631         return string(bstr);
1632     }
1633 }
1634 
1635 // File: contracts/@ensdomains/ens/contracts/Deed.sol
1636 
1637 /**
1638  * @title Deed to hold ether in exchange for ownership of a node
1639  * @dev The deed can be controlled only by the registrar and can only send ether back to the owner.
1640  */
1641 contract Deed {
1642 
1643     address constant burn = 0xdead;
1644 
1645     address public registrar;
1646     address public owner;
1647     address public previousOwner;
1648 
1649     uint public creationDate;
1650     uint public value;
1651 
1652     bool active;
1653 
1654     event OwnerChanged(address newOwner);
1655     event DeedClosed();
1656 
1657     modifier onlyRegistrar {
1658         require(msg.sender == registrar);
1659         _;
1660     }
1661 
1662     modifier onlyActive {
1663         require(active);
1664         _;
1665     }
1666 
1667     function Deed(address _owner) public payable {
1668         owner = _owner;
1669         registrar = msg.sender;
1670         creationDate = now;
1671         active = true;
1672         value = msg.value;
1673     }
1674 
1675     function setOwner(address newOwner) public onlyRegistrar {
1676         require(newOwner != 0);
1677         previousOwner = owner;  // This allows contracts to check who sent them the ownership
1678         owner = newOwner;
1679         OwnerChanged(newOwner);
1680     }
1681 
1682     function setRegistrar(address newRegistrar) public onlyRegistrar {
1683         registrar = newRegistrar;
1684     }
1685 
1686     function setBalance(uint newValue, bool throwOnFailure) public onlyRegistrar onlyActive {
1687         // Check if it has enough balance to set the value
1688         require(value >= newValue);
1689         value = newValue;
1690         // Send the difference to the owner
1691         require(owner.send(this.balance - newValue) || !throwOnFailure);
1692     }
1693 
1694     /**
1695      * @dev Close a deed and refund a specified fraction of the bid value
1696      *
1697      * @param refundRatio The amount*1/1000 to refund
1698      */
1699     function closeDeed(uint refundRatio) public onlyRegistrar onlyActive {
1700         active = false;
1701         require(burn.send(((1000 - refundRatio) * this.balance)/1000));
1702         DeedClosed();
1703         destroyDeed();
1704     }
1705 
1706     /**
1707      * @dev Close a deed and refund a specified fraction of the bid value
1708      */
1709     function destroyDeed() public {
1710         require(!active);
1711 
1712         // Instead of selfdestruct(owner), invoke owner fallback function to allow
1713         // owner to log an event if desired; but owner should also be aware that
1714         // its fallback function can also be invoked by setBalance
1715         if (owner.send(this.balance)) {
1716             selfdestruct(burn);
1717         }
1718     }
1719 }
1720 
1721 // File: contracts/@ensdomains/ens/contracts/ENS.sol
1722 
1723 interface ENS {
1724 
1725     // Logged when the owner of a node assigns a new owner to a subnode.
1726     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
1727 
1728     // Logged when the owner of a node transfers ownership to a new account.
1729     event Transfer(bytes32 indexed node, address owner);
1730 
1731     // Logged when the resolver for a node changes.
1732     event NewResolver(bytes32 indexed node, address resolver);
1733 
1734     // Logged when the TTL of a node changes
1735     event NewTTL(bytes32 indexed node, uint64 ttl);
1736 
1737 
1738     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
1739     function setResolver(bytes32 node, address resolver) public;
1740     function setOwner(bytes32 node, address owner) public;
1741     function setTTL(bytes32 node, uint64 ttl) public;
1742     function owner(bytes32 node) public view returns (address);
1743     function resolver(bytes32 node) public view returns (address);
1744     function ttl(bytes32 node) public view returns (uint64);
1745 
1746 }
1747 
1748 // File: contracts/@ensdomains/ens/contracts/HashRegistrarSimplified.sol
1749 
1750 /*
1751 
1752 Temporary Hash Registrar
1753 ========================
1754 
1755 This is a simplified version of a hash registrar. It is purporsefully limited:
1756 names cannot be six letters or shorter, new auctions will stop after 4 years.
1757 
1758 The plan is to test the basic features and then move to a new contract in at most
1759 2 years, when some sort of renewal mechanism will be enabled.
1760 */
1761 
1762 
1763 
1764 /**
1765  * @title Registrar
1766  * @dev The registrar handles the auction process for each subnode of the node it owns.
1767  */
1768 contract Registrar {
1769     ENS public ens;
1770     bytes32 public rootNode;
1771 
1772     mapping (bytes32 => Entry) _entries;
1773     mapping (address => mapping (bytes32 => Deed)) public sealedBids;
1774     
1775     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
1776 
1777     uint32 constant totalAuctionLength = 5 days;
1778     uint32 constant revealPeriod = 48 hours;
1779     uint32 public constant launchLength = 8 weeks;
1780 
1781     uint constant minPrice = 0.01 ether;
1782     uint public registryStarted;
1783 
1784     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
1785     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
1786     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
1787     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
1788     event HashReleased(bytes32 indexed hash, uint value);
1789     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
1790 
1791     struct Entry {
1792         Deed deed;
1793         uint registrationDate;
1794         uint value;
1795         uint highestBid;
1796     }
1797 
1798     modifier inState(bytes32 _hash, Mode _state) {
1799         require(state(_hash) == _state);
1800         _;
1801     }
1802 
1803     modifier onlyOwner(bytes32 _hash) {
1804         require(state(_hash) == Mode.Owned && msg.sender == _entries[_hash].deed.owner());
1805         _;
1806     }
1807 
1808     modifier registryOpen() {
1809         require(now >= registryStarted && now <= registryStarted + 4 years && ens.owner(rootNode) == address(this));
1810         _;
1811     }
1812 
1813     /**
1814      * @dev Constructs a new Registrar, with the provided address as the owner of the root node.
1815      *
1816      * @param _ens The address of the ENS
1817      * @param _rootNode The hash of the rootnode.
1818      */
1819     function Registrar(ENS _ens, bytes32 _rootNode, uint _startDate) public {
1820         ens = _ens;
1821         rootNode = _rootNode;
1822         registryStarted = _startDate > 0 ? _startDate : now;
1823     }
1824 
1825     /**
1826      * @dev Start an auction for an available hash
1827      *
1828      * @param _hash The hash to start an auction on
1829      */
1830     function startAuction(bytes32 _hash) public registryOpen() {
1831         Mode mode = state(_hash);
1832         if (mode == Mode.Auction) return;
1833         require(mode == Mode.Open);
1834 
1835         Entry storage newAuction = _entries[_hash];
1836         newAuction.registrationDate = now + totalAuctionLength;
1837         newAuction.value = 0;
1838         newAuction.highestBid = 0;
1839         AuctionStarted(_hash, newAuction.registrationDate);
1840     }
1841 
1842     /**
1843      * @dev Start multiple auctions for better anonymity
1844      *
1845      * Anyone can start an auction by sending an array of hashes that they want to bid for.
1846      * Arrays are sent so that someone can open up an auction for X dummy hashes when they
1847      * are only really interested in bidding for one. This will increase the cost for an
1848      * attacker to simply bid blindly on all new auctions. Dummy auctions that are
1849      * open but not bid on are closed after a week.
1850      *
1851      * @param _hashes An array of hashes, at least one of which you presumably want to bid on
1852      */
1853     function startAuctions(bytes32[] _hashes) public {
1854         for (uint i = 0; i < _hashes.length; i ++) {
1855             startAuction(_hashes[i]);
1856         }
1857     }
1858 
1859     /**
1860      * @dev Submit a new sealed bid on a desired hash in a blind auction
1861      *
1862      * Bids are sent by sending a message to the main contract with a hash and an amount. The hash
1863      * contains information about the bid, including the bidded hash, the bid amount, and a random
1864      * salt. Bids are not tied to any one auction until they are revealed. The value of the bid
1865      * itself can be masqueraded by sending more than the value of your actual bid. This is
1866      * followed by a 48h reveal period. Bids revealed after this period will be burned and the ether unrecoverable.
1867      * Since this is an auction, it is expected that most public hashes, like known domains and common dictionary
1868      * words, will have multiple bidders pushing the price up.
1869      *
1870      * @param sealedBid A sealedBid, created by the shaBid function
1871      */
1872     function newBid(bytes32 sealedBid) public payable {
1873         require(address(sealedBids[msg.sender][sealedBid]) == 0x0);
1874         require(msg.value >= minPrice);
1875 
1876         // Creates a new hash contract with the owner
1877         Deed newBid = (new Deed).value(msg.value)(msg.sender);
1878         sealedBids[msg.sender][sealedBid] = newBid;
1879         NewBid(sealedBid, msg.sender, msg.value);
1880     }
1881 
1882     /**
1883      * @dev Start a set of auctions and bid on one of them
1884      *
1885      * This method functions identically to calling `startAuctions` followed by `newBid`,
1886      * but all in one transaction.
1887      *
1888      * @param hashes A list of hashes to start auctions on.
1889      * @param sealedBid A sealed bid for one of the auctions.
1890      */
1891     function startAuctionsAndBid(bytes32[] hashes, bytes32 sealedBid) public payable {
1892         startAuctions(hashes);
1893         newBid(sealedBid);
1894     }
1895 
1896     /**
1897      * @dev Submit the properties of a bid to reveal them
1898      *
1899      * @param _hash The node in the sealedBid
1900      * @param _value The bid amount in the sealedBid
1901      * @param _salt The sale in the sealedBid
1902      */
1903     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) public {
1904         bytes32 seal = shaBid(_hash, msg.sender, _value, _salt);
1905         Deed bid = sealedBids[msg.sender][seal];
1906         require(address(bid) != 0);
1907 
1908         sealedBids[msg.sender][seal] = Deed(0);
1909         Entry storage h = _entries[_hash];
1910         uint value = min(_value, bid.value());
1911         bid.setBalance(value, true);
1912 
1913         var auctionState = state(_hash);
1914         if (auctionState == Mode.Owned) {
1915             // Too late! Bidder loses their bid. Gets 0.5% back.
1916             bid.closeDeed(5);
1917             BidRevealed(_hash, msg.sender, value, 1);
1918         } else if (auctionState != Mode.Reveal) {
1919             // Invalid phase
1920             revert();
1921         } else if (value < minPrice || bid.creationDate() > h.registrationDate - revealPeriod) {
1922             // Bid too low or too late, refund 99.5%
1923             bid.closeDeed(995);
1924             BidRevealed(_hash, msg.sender, value, 0);
1925         } else if (value > h.highestBid) {
1926             // New winner
1927             // Cancel the other bid, refund 99.5%
1928             if (address(h.deed) != 0) {
1929                 Deed previousWinner = h.deed;
1930                 previousWinner.closeDeed(995);
1931             }
1932 
1933             // Set new winner
1934             // Per the rules of a vickery auction, the value becomes the previous highestBid
1935             h.value = h.highestBid;  // will be zero if there's only 1 bidder
1936             h.highestBid = value;
1937             h.deed = bid;
1938             BidRevealed(_hash, msg.sender, value, 2);
1939         } else if (value > h.value) {
1940             // Not winner, but affects second place
1941             h.value = value;
1942             bid.closeDeed(995);
1943             BidRevealed(_hash, msg.sender, value, 3);
1944         } else {
1945             // Bid doesn't affect auction
1946             bid.closeDeed(995);
1947             BidRevealed(_hash, msg.sender, value, 4);
1948         }
1949     }
1950 
1951     /**
1952      * @dev Cancel a bid
1953      *
1954      * @param seal The value returned by the shaBid function
1955      */
1956     function cancelBid(address bidder, bytes32 seal) public {
1957         Deed bid = sealedBids[bidder][seal];
1958         
1959         // If a sole bidder does not `unsealBid` in time, they have a few more days
1960         // where they can call `startAuction` (again) and then `unsealBid` during
1961         // the revealPeriod to get back their bid value.
1962         // For simplicity, they should call `startAuction` within
1963         // 9 days (2 weeks - totalAuctionLength), otherwise their bid will be
1964         // cancellable by anyone.
1965         require(address(bid) != 0 && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
1966 
1967         // Send the canceller 0.5% of the bid, and burn the rest.
1968         bid.setOwner(msg.sender);
1969         bid.closeDeed(5);
1970         sealedBids[bidder][seal] = Deed(0);
1971         BidRevealed(seal, bidder, 0, 5);
1972     }
1973 
1974     /**
1975      * @dev Finalize an auction after the registration date has passed
1976      *
1977      * @param _hash The hash of the name the auction is for
1978      */
1979     function finalizeAuction(bytes32 _hash) public onlyOwner(_hash) {
1980         Entry storage h = _entries[_hash];
1981         
1982         // Handles the case when there's only a single bidder (h.value is zero)
1983         h.value =  max(h.value, minPrice);
1984         h.deed.setBalance(h.value, true);
1985 
1986         trySetSubnodeOwner(_hash, h.deed.owner());
1987         HashRegistered(_hash, h.deed.owner(), h.value, h.registrationDate);
1988     }
1989 
1990     /**
1991      * @dev The owner of a domain may transfer it to someone else at any time.
1992      *
1993      * @param _hash The node to transfer
1994      * @param newOwner The address to transfer ownership to
1995      */
1996     function transfer(bytes32 _hash, address newOwner) public onlyOwner(_hash) {
1997         require(newOwner != 0);
1998 
1999         Entry storage h = _entries[_hash];
2000         h.deed.setOwner(newOwner);
2001         trySetSubnodeOwner(_hash, newOwner);
2002     }
2003 
2004     /**
2005      * @dev After some time, or if we're no longer the registrar, the owner can release
2006      *      the name and get their ether back.
2007      *
2008      * @param _hash The node to release
2009      */
2010     function releaseDeed(bytes32 _hash) public onlyOwner(_hash) {
2011         Entry storage h = _entries[_hash];
2012         Deed deedContract = h.deed;
2013 
2014         require(now >= h.registrationDate + 1 years || ens.owner(rootNode) != address(this));
2015 
2016         h.value = 0;
2017         h.highestBid = 0;
2018         h.deed = Deed(0);
2019 
2020         _tryEraseSingleNode(_hash);
2021         deedContract.closeDeed(1000);
2022         HashReleased(_hash, h.value);        
2023     }
2024 
2025     /**
2026      * @dev Submit a name 6 characters long or less. If it has been registered,
2027      *      the submitter will earn 50% of the deed value. 
2028      * 
2029      * We are purposefully handicapping the simplified registrar as a way 
2030      * to force it into being restructured in a few years.
2031      *
2032      * @param unhashedName An invalid name to search for in the registry.
2033      */
2034     function invalidateName(string unhashedName) public inState(keccak256(unhashedName), Mode.Owned) {
2035         require(strlen(unhashedName) <= 6);
2036         bytes32 hash = keccak256(unhashedName);
2037 
2038         Entry storage h = _entries[hash];
2039 
2040         _tryEraseSingleNode(hash);
2041 
2042         if (address(h.deed) != 0) {
2043             // Reward the discoverer with 50% of the deed
2044             // The previous owner gets 50%
2045             h.value = max(h.value, minPrice);
2046             h.deed.setBalance(h.value/2, false);
2047             h.deed.setOwner(msg.sender);
2048             h.deed.closeDeed(1000);
2049         }
2050 
2051         HashInvalidated(hash, unhashedName, h.value, h.registrationDate);
2052 
2053         h.value = 0;
2054         h.highestBid = 0;
2055         h.deed = Deed(0);
2056     }
2057 
2058     /**
2059      * @dev Allows anyone to delete the owner and resolver records for a (subdomain of) a
2060      *      name that is not currently owned in the registrar. If passing, eg, 'foo.bar.eth',
2061      *      the owner and resolver fields on 'foo.bar.eth' and 'bar.eth' will all be cleared.
2062      *
2063      * @param labels A series of label hashes identifying the name to zero out, rooted at the
2064      *        registrar's root. Must contain at least one element. For instance, to zero 
2065      *        'foo.bar.eth' on a registrar that owns '.eth', pass an array containing
2066      *        [keccak256('foo'), keccak256('bar')].
2067      */
2068     function eraseNode(bytes32[] labels) public {
2069         require(labels.length != 0);
2070         require(state(labels[labels.length - 1]) != Mode.Owned);
2071 
2072         _eraseNodeHierarchy(labels.length - 1, labels, rootNode);
2073     }
2074 
2075     /**
2076      * @dev Transfers the deed to the current registrar, if different from this one.
2077      *
2078      * Used during the upgrade process to a permanent registrar.
2079      *
2080      * @param _hash The name hash to transfer.
2081      */
2082     function transferRegistrars(bytes32 _hash) public onlyOwner(_hash) {
2083         address registrar = ens.owner(rootNode);
2084         require(registrar != address(this));
2085 
2086         // Migrate the deed
2087         Entry storage h = _entries[_hash];
2088         h.deed.setRegistrar(registrar);
2089 
2090         // Call the new registrar to accept the transfer
2091         Registrar(registrar).acceptRegistrarTransfer(_hash, h.deed, h.registrationDate);
2092 
2093         // Zero out the Entry
2094         h.deed = Deed(0);
2095         h.registrationDate = 0;
2096         h.value = 0;
2097         h.highestBid = 0;
2098     }
2099 
2100     /**
2101      * @dev Accepts a transfer from a previous registrar; stubbed out here since there
2102      *      is no previous registrar implementing this interface.
2103      *
2104      * @param hash The sha3 hash of the label to transfer.
2105      * @param deed The Deed object for the name being transferred in.
2106      * @param registrationDate The date at which the name was originally registered.
2107      */
2108     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) public {
2109         hash; deed; registrationDate; // Don't warn about unused variables
2110     }
2111 
2112     // State transitions for names:
2113     //   Open -> Auction (startAuction)
2114     //   Auction -> Reveal
2115     //   Reveal -> Owned
2116     //   Reveal -> Open (if nobody bid)
2117     //   Owned -> Open (releaseDeed or invalidateName)
2118     function state(bytes32 _hash) public view returns (Mode) {
2119         Entry storage entry = _entries[_hash];
2120 
2121         if (!isAllowed(_hash, now)) {
2122             return Mode.NotYetAvailable;
2123         } else if (now < entry.registrationDate) {
2124             if (now < entry.registrationDate - revealPeriod) {
2125                 return Mode.Auction;
2126             } else {
2127                 return Mode.Reveal;
2128             }
2129         } else {
2130             if (entry.highestBid == 0) {
2131                 return Mode.Open;
2132             } else {
2133                 return Mode.Owned;
2134             }
2135         }
2136     }
2137 
2138     function entries(bytes32 _hash) public view returns (Mode, address, uint, uint, uint) {
2139         Entry storage h = _entries[_hash];
2140         return (state(_hash), h.deed, h.registrationDate, h.value, h.highestBid);
2141     }
2142 
2143     /**
2144      * @dev Determines if a name is available for registration yet
2145      *
2146      * Each name will be assigned a random date in which its auction
2147      * can be started, from 0 to 8 weeks
2148      *
2149      * @param _hash The hash to start an auction on
2150      * @param _timestamp The timestamp to query about
2151      */
2152     function isAllowed(bytes32 _hash, uint _timestamp) public view returns (bool allowed) {
2153         return _timestamp > getAllowedTime(_hash);
2154     }
2155 
2156     /**
2157      * @dev Returns available date for hash
2158      *
2159      * The available time from the `registryStarted` for a hash is proportional
2160      * to its numeric value.
2161      *
2162      * @param _hash The hash to start an auction on
2163      */
2164     function getAllowedTime(bytes32 _hash) public view returns (uint) {
2165         return registryStarted + ((launchLength * (uint(_hash) >> 128)) >> 128);
2166         // Right shift operator: a >> b == a / 2**b
2167     }
2168 
2169     /**
2170      * @dev Hash the values required for a secret bid
2171      *
2172      * @param hash The node corresponding to the desired namehash
2173      * @param value The bid amount
2174      * @param salt A random value to ensure secrecy of the bid
2175      * @return The hash of the bid values
2176      */
2177     function shaBid(bytes32 hash, address owner, uint value, bytes32 salt) public pure returns (bytes32) {
2178         return keccak256(hash, owner, value, salt);
2179     }
2180 
2181     function _tryEraseSingleNode(bytes32 label) internal {
2182         if (ens.owner(rootNode) == address(this)) {
2183             ens.setSubnodeOwner(rootNode, label, address(this));
2184             bytes32 node = keccak256(rootNode, label);
2185             ens.setResolver(node, 0);
2186             ens.setOwner(node, 0);
2187         }
2188     }
2189 
2190     function _eraseNodeHierarchy(uint idx, bytes32[] labels, bytes32 node) internal {
2191         // Take ownership of the node
2192         ens.setSubnodeOwner(node, labels[idx], address(this));
2193         node = keccak256(node, labels[idx]);
2194 
2195         // Recurse if there are more labels
2196         if (idx > 0) {
2197             _eraseNodeHierarchy(idx - 1, labels, node);
2198         }
2199 
2200         // Erase the resolver and owner records
2201         ens.setResolver(node, 0);
2202         ens.setOwner(node, 0);
2203     }
2204 
2205     /**
2206      * @dev Assign the owner in ENS, if we're still the registrar
2207      *
2208      * @param _hash hash to change owner
2209      * @param _newOwner new owner to transfer to
2210      */
2211     function trySetSubnodeOwner(bytes32 _hash, address _newOwner) internal {
2212         if (ens.owner(rootNode) == address(this))
2213             ens.setSubnodeOwner(rootNode, _hash, _newOwner);
2214     }
2215 
2216     /**
2217      * @dev Returns the maximum of two unsigned integers
2218      *
2219      * @param a A number to compare
2220      * @param b A number to compare
2221      * @return The maximum of two unsigned integers
2222      */
2223     function max(uint a, uint b) internal pure returns (uint) {
2224         if (a > b)
2225             return a;
2226         else
2227             return b;
2228     }
2229 
2230     /**
2231      * @dev Returns the minimum of two unsigned integers
2232      *
2233      * @param a A number to compare
2234      * @param b A number to compare
2235      * @return The minimum of two unsigned integers
2236      */
2237     function min(uint a, uint b) internal pure returns (uint) {
2238         if (a < b)
2239             return a;
2240         else
2241             return b;
2242     }
2243 
2244     /**
2245      * @dev Returns the length of a given string
2246      *
2247      * @param s The string to measure the length of
2248      * @return The length of the input string
2249      */
2250     function strlen(string s) internal pure returns (uint) {
2251         s; // Don't warn about unused variables
2252         // Starting here means the LSB will be the byte we care about
2253         uint ptr;
2254         uint end;
2255         assembly {
2256             ptr := add(s, 1)
2257             end := add(mload(s), ptr)
2258         }
2259         for (uint len = 0; ptr < end; len++) {
2260             uint8 b;
2261             assembly { b := and(mload(ptr), 0xFF) }
2262             if (b < 0x80) {
2263                 ptr += 1;
2264             } else if (b < 0xE0) {
2265                 ptr += 2;
2266             } else if (b < 0xF0) {
2267                 ptr += 3;
2268             } else if (b < 0xF8) {
2269                 ptr += 4;
2270             } else if (b < 0xFC) {
2271                 ptr += 5;
2272             } else {
2273                 ptr += 6;
2274             }
2275         }
2276         return len;
2277     }
2278 
2279 }
2280 
2281 // File: contracts/ENSNFT.sol
2282 
2283 /* pragma experimental ABIEncoderV2; */
2284 
2285 
2286 
2287 
2288 
2289 
2290 contract ENSNFT is ERC721Token, Ownable {
2291     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
2292     address metadata;
2293     Registrar registrar;
2294     constructor (string _name, string _symbol, Registrar _registrar, Metadata _metadata) public
2295         ERC721Token(_name, _symbol) {
2296         registrar = _registrar;
2297         metadata = _metadata;
2298     }
2299     function getMetadata() public view returns (address) {
2300         return metadata;
2301     }
2302     // this function uses assembly to delegate a call because it returns a string
2303     // of variable length which is not currently allowed without ABIEncoderV2 enabled
2304     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
2305         address _impl = getMetadata();
2306         bytes memory data = msg.data;
2307         assembly {
2308             let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
2309             let size := returndatasize
2310             let ptr := mload(0x40)
2311             returndatacopy(ptr, 0, size)
2312             switch result
2313             case 0 { revert(ptr, size) }
2314             default { return(ptr, size) }
2315         }
2316         // this is how it would be done if returning a variable length were allowed
2317         // return Metadata(metadata).tokenMetadata(_tokenId);
2318     }
2319     function updateMetadata(Metadata _metadata) public onlyOwner {
2320         metadata = _metadata;
2321     }
2322     function mint(bytes32 _hash) public {
2323         address deedAddress;
2324         (, deedAddress, , , ) = registrar.entries(_hash);
2325         Deed deed = Deed(deedAddress);
2326         require(deed.owner() == address(this));
2327         require(deed.previousOwner() == msg.sender);
2328         uint256 tokenId = uint256(_hash); // dont do math on this
2329         _mint(deed.previousOwner(), tokenId);
2330     }
2331     function burn(uint256 tokenId) {
2332         require(ownerOf(tokenId) == msg.sender);
2333         _burn(msg.sender, tokenId);
2334         registrar.transfer(bytes32(tokenId), msg.sender);
2335     }
2336 }