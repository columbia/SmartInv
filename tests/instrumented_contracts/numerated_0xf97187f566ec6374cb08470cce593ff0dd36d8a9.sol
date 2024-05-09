1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: node_modules\openzeppelin-solidity\contracts\introspection\ERC165.sol
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
87 // File: node_modules\openzeppelin-solidity\contracts\introspection\SupportsInterfaceWithLookup.sol
88 
89 /**
90  * @title SupportsInterfaceWithLookup
91  * @author Matt Condon (@shrugs)
92  * @dev Implements ERC165 using a lookup table.
93  */
94 contract SupportsInterfaceWithLookup is ERC165 {
95   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
96   /**
97    * 0x01ffc9a7 ===
98    *   bytes4(keccak256('supportsInterface(bytes4)'))
99    */
100 
101   /**
102    * @dev a mapping of interface id to whether or not it's supported
103    */
104   mapping(bytes4 => bool) internal supportedInterfaces;
105 
106   /**
107    * @dev A contract implementing SupportsInterfaceWithLookup
108    * implement ERC165 itself
109    */
110   constructor()
111     public
112   {
113     _registerInterface(InterfaceId_ERC165);
114   }
115 
116   /**
117    * @dev implement supportsInterface(bytes4) using a lookup table
118    */
119   function supportsInterface(bytes4 _interfaceId)
120     external
121     view
122     returns (bool)
123   {
124     return supportedInterfaces[_interfaceId];
125   }
126 
127   /**
128    * @dev private method for registering an interface
129    */
130   function _registerInterface(bytes4 _interfaceId)
131     internal
132   {
133     require(_interfaceId != 0xffffffff);
134     supportedInterfaces[_interfaceId] = true;
135   }
136 }
137 
138 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
139 
140 /**
141  * @title ERC721 Non-Fungible Token Standard basic interface
142  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
143  */
144 contract ERC721Basic is ERC165 {
145   event Transfer(
146     address indexed _from,
147     address indexed _to,
148     uint256 indexed _tokenId
149   );
150   event Approval(
151     address indexed _owner,
152     address indexed _approved,
153     uint256 indexed _tokenId
154   );
155   event ApprovalForAll(
156     address indexed _owner,
157     address indexed _operator,
158     bool _approved
159   );
160 
161   function balanceOf(address _owner) public view returns (uint256 _balance);
162   function ownerOf(uint256 _tokenId) public view returns (address _owner);
163   function exists(uint256 _tokenId) public view returns (bool _exists);
164 
165   function approve(address _to, uint256 _tokenId) public;
166   function getApproved(uint256 _tokenId)
167     public view returns (address _operator);
168 
169   function setApprovalForAll(address _operator, bool _approved) public;
170   function isApprovedForAll(address _owner, address _operator)
171     public view returns (bool);
172 
173   function transferFrom(address _from, address _to, uint256 _tokenId) public;
174   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
175     public;
176 
177   function safeTransferFrom(
178     address _from,
179     address _to,
180     uint256 _tokenId,
181     bytes _data
182   )
183     public;
184 }
185 
186 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
190  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
191  */
192 contract ERC721Enumerable is ERC721Basic {
193   function totalSupply() public view returns (uint256);
194   function tokenOfOwnerByIndex(
195     address _owner,
196     uint256 _index
197   )
198     public
199     view
200     returns (uint256 _tokenId);
201 
202   function tokenByIndex(uint256 _index) public view returns (uint256);
203 }
204 
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
209  */
210 contract ERC721Metadata is ERC721Basic {
211   function name() external view returns (string _name);
212   function symbol() external view returns (string _symbol);
213   function tokenURI(uint256 _tokenId) public view returns (string);
214 }
215 
216 
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
219  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
220  */
221 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
222 }
223 
224 // File: node_modules\openzeppelin-solidity\contracts\AddressUtils.sol
225 
226 /**
227  * Utility library of inline functions on addresses
228  */
229 library AddressUtils {
230 
231   /**
232    * Returns whether the target address is a contract
233    * @dev This function will return false if invoked during the constructor of a contract,
234    * as the code is not actually created until after the constructor finishes.
235    * @param addr address to check
236    * @return whether the target address is a contract
237    */
238   function isContract(address addr) internal view returns (bool) {
239     uint256 size;
240     // XXX Currently there is no better way to check if there is a contract in an address
241     // than to check the size of the code at that address.
242     // See https://ethereum.stackexchange.com/a/14016/36603
243     // for more details about how this works.
244     // TODO Check this again before the Serenity release, because all addresses will be
245     // contracts then.
246     // solium-disable-next-line security/no-inline-assembly
247     assembly { size := extcodesize(addr) }
248     return size > 0;
249   }
250 
251 }
252 
253 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
254 
255 /**
256  * @title SafeMath
257  * @dev Math operations with safety checks that throw on error
258  */
259 library SafeMath {
260 
261   /**
262   * @dev Multiplies two numbers, throws on overflow.
263   */
264   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
265     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
266     // benefit is lost if 'b' is also tested.
267     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
268     if (a == 0) {
269       return 0;
270     }
271 
272     c = a * b;
273     assert(c / a == b);
274     return c;
275   }
276 
277   /**
278   * @dev Integer division of two numbers, truncating the quotient.
279   */
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     // assert(b > 0); // Solidity automatically throws when dividing by 0
282     // uint256 c = a / b;
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284     return a / b;
285   }
286 
287   /**
288   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
289   */
290   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291     assert(b <= a);
292     return a - b;
293   }
294 
295   /**
296   * @dev Adds two numbers, throws on overflow.
297   */
298   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
299     c = a + b;
300     assert(c >= a);
301     return c;
302   }
303 }
304 
305 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 contract ERC721Receiver {
313   /**
314    * @dev Magic value to be returned upon successful reception of an NFT
315    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
316    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
317    */
318   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
319 
320   /**
321    * @notice Handle the receipt of an NFT
322    * @dev The ERC721 smart contract calls this function on the recipient
323    * after a `safetransfer`. This function MAY throw to revert and reject the
324    * transfer. Return of other than the magic value MUST result in the 
325    * transaction being reverted.
326    * Note: the contract address is always the message sender.
327    * @param _operator The address which called `safeTransferFrom` function
328    * @param _from The address which previously owned the token
329    * @param _tokenId The NFT identifier which is being transfered
330    * @param _data Additional data with no specified format
331    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
332    */
333   function onERC721Received(
334     address _operator,
335     address _from,
336     uint256 _tokenId,
337     bytes _data
338   )
339     public
340     returns(bytes4);
341 }
342 
343 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
344 
345 /**
346  * @title ERC721 Non-Fungible Token Standard basic implementation
347  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
348  */
349 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
350 
351   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
352   /*
353    * 0x80ac58cd ===
354    *   bytes4(keccak256('balanceOf(address)')) ^
355    *   bytes4(keccak256('ownerOf(uint256)')) ^
356    *   bytes4(keccak256('approve(address,uint256)')) ^
357    *   bytes4(keccak256('getApproved(uint256)')) ^
358    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
359    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
360    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
361    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
362    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
363    */
364 
365   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
366   /*
367    * 0x4f558e79 ===
368    *   bytes4(keccak256('exists(uint256)'))
369    */
370 
371   using SafeMath for uint256;
372   using AddressUtils for address;
373 
374   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
375   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
376   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
377 
378   // Mapping from token ID to owner
379   mapping (uint256 => address) internal tokenOwner;
380 
381   // Mapping from token ID to approved address
382   mapping (uint256 => address) internal tokenApprovals;
383 
384   // Mapping from owner to number of owned token
385   mapping (address => uint256) internal ownedTokensCount;
386 
387   // Mapping from owner to operator approvals
388   mapping (address => mapping (address => bool)) internal operatorApprovals;
389 
390   /**
391    * @dev Guarantees msg.sender is owner of the given token
392    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
393    */
394   modifier onlyOwnerOf(uint256 _tokenId) {
395     require(ownerOf(_tokenId) == msg.sender);
396     _;
397   }
398 
399   /**
400    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
401    * @param _tokenId uint256 ID of the token to validate
402    */
403   modifier canTransfer(uint256 _tokenId) {
404     require(isApprovedOrOwner(msg.sender, _tokenId));
405     _;
406   }
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
516     canTransfer(_tokenId)
517   {
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
546     canTransfer(_tokenId)
547   {
548     // solium-disable-next-line arg-overflow
549     safeTransferFrom(_from, _to, _tokenId, "");
550   }
551 
552   /**
553    * @dev Safely transfers the ownership of a given token ID to another address
554    * If the target address is a contract, it must implement `onERC721Received`,
555    * which is called upon a safe transfer, and return the magic value
556    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
557    * the transfer is reverted.
558    * Requires the msg sender to be the owner, approved, or operator
559    * @param _from current owner of the token
560    * @param _to address to receive the ownership of the given token ID
561    * @param _tokenId uint256 ID of the token to be transferred
562    * @param _data bytes data to send along with a safe transfer check
563    */
564   function safeTransferFrom(
565     address _from,
566     address _to,
567     uint256 _tokenId,
568     bytes _data
569   )
570     public
571     canTransfer(_tokenId)
572   {
573     transferFrom(_from, _to, _tokenId);
574     // solium-disable-next-line arg-overflow
575     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
576   }
577 
578   /**
579    * @dev Returns whether the given spender can transfer a given token ID
580    * @param _spender address of the spender to query
581    * @param _tokenId uint256 ID of the token to be transferred
582    * @return bool whether the msg.sender is approved for the given token ID,
583    *  is an operator of the owner, or is the owner of the token
584    */
585   function isApprovedOrOwner(
586     address _spender,
587     uint256 _tokenId
588   )
589     internal
590     view
591     returns (bool)
592   {
593     address owner = ownerOf(_tokenId);
594     // Disable solium check because of
595     // https://github.com/duaraghav8/Solium/issues/175
596     // solium-disable-next-line operator-whitespace
597     return (
598       _spender == owner ||
599       getApproved(_tokenId) == _spender ||
600       isApprovedForAll(owner, _spender)
601     );
602   }
603 
604   /**
605    * @dev Internal function to mint a new token
606    * Reverts if the given token ID already exists
607    * @param _to The address that will own the minted token
608    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
609    */
610   function _mint(address _to, uint256 _tokenId) internal {
611     require(_to != address(0));
612     addTokenTo(_to, _tokenId);
613     emit Transfer(address(0), _to, _tokenId);
614   }
615 
616   /**
617    * @dev Internal function to burn a specific token
618    * Reverts if the token does not exist
619    * @param _tokenId uint256 ID of the token being burned by the msg.sender
620    */
621   function _burn(address _owner, uint256 _tokenId) internal {
622     clearApproval(_owner, _tokenId);
623     removeTokenFrom(_owner, _tokenId);
624     emit Transfer(_owner, address(0), _tokenId);
625   }
626 
627   /**
628    * @dev Internal function to clear current approval of a given token ID
629    * Reverts if the given address is not indeed the owner of the token
630    * @param _owner owner of the token
631    * @param _tokenId uint256 ID of the token to be transferred
632    */
633   function clearApproval(address _owner, uint256 _tokenId) internal {
634     require(ownerOf(_tokenId) == _owner);
635     if (tokenApprovals[_tokenId] != address(0)) {
636       tokenApprovals[_tokenId] = address(0);
637     }
638   }
639 
640   /**
641    * @dev Internal function to add a token ID to the list of a given address
642    * @param _to address representing the new owner of the given token ID
643    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
644    */
645   function addTokenTo(address _to, uint256 _tokenId) internal {
646     require(tokenOwner[_tokenId] == address(0));
647     tokenOwner[_tokenId] = _to;
648     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
649   }
650 
651   /**
652    * @dev Internal function to remove a token ID from the list of a given address
653    * @param _from address representing the previous owner of the given token ID
654    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
655    */
656   function removeTokenFrom(address _from, uint256 _tokenId) internal {
657     require(ownerOf(_tokenId) == _from);
658     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
659     tokenOwner[_tokenId] = address(0);
660   }
661 
662   /**
663    * @dev Internal function to invoke `onERC721Received` on a target address
664    * The call is not executed if the target address is not a contract
665    * @param _from address representing the previous owner of the given token ID
666    * @param _to target address that will receive the tokens
667    * @param _tokenId uint256 ID of the token to be transferred
668    * @param _data bytes optional data to send along with the call
669    * @return whether the call correctly returned the expected magic value
670    */
671   function checkAndCallSafeTransfer(
672     address _from,
673     address _to,
674     uint256 _tokenId,
675     bytes _data
676   )
677     internal
678     returns (bool)
679   {
680     if (!_to.isContract()) {
681       return true;
682     }
683     bytes4 retval = ERC721Receiver(_to).onERC721Received(
684       msg.sender, _from, _tokenId, _data);
685     return (retval == ERC721_RECEIVED);
686   }
687 }
688 
689 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Token.sol
690 
691 /**
692  * @title Full ERC721 Token
693  * This implementation includes all the required and some optional functionality of the ERC721 standard
694  * Moreover, it includes approve all functionality using operator terminology
695  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
696  */
697 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
698 
699   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
700   /**
701    * 0x780e9d63 ===
702    *   bytes4(keccak256('totalSupply()')) ^
703    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
704    *   bytes4(keccak256('tokenByIndex(uint256)'))
705    */
706 
707   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
708   /**
709    * 0x5b5e139f ===
710    *   bytes4(keccak256('name()')) ^
711    *   bytes4(keccak256('symbol()')) ^
712    *   bytes4(keccak256('tokenURI(uint256)'))
713    */
714 
715   // Token name
716   string internal name_;
717 
718   // Token symbol
719   string internal symbol_;
720 
721   // Mapping from owner to list of owned token IDs
722   mapping(address => uint256[]) internal ownedTokens;
723 
724   // Mapping from token ID to index of the owner tokens list
725   mapping(uint256 => uint256) internal ownedTokensIndex;
726 
727   // Array with all token ids, used for enumeration
728   uint256[] internal allTokens;
729 
730   // Mapping from token id to position in the allTokens array
731   mapping(uint256 => uint256) internal allTokensIndex;
732 
733   // Optional mapping for token URIs
734   mapping(uint256 => string) internal tokenURIs;
735 
736   /**
737    * @dev Constructor function
738    */
739   constructor(string _name, string _symbol) public {
740     name_ = _name;
741     symbol_ = _symbol;
742 
743     // register the supported interfaces to conform to ERC721 via ERC165
744     _registerInterface(InterfaceId_ERC721Enumerable);
745     _registerInterface(InterfaceId_ERC721Metadata);
746   }
747 
748   /**
749    * @dev Gets the token name
750    * @return string representing the token name
751    */
752   function name() external view returns (string) {
753     return name_;
754   }
755 
756   /**
757    * @dev Gets the token symbol
758    * @return string representing the token symbol
759    */
760   function symbol() external view returns (string) {
761     return symbol_;
762   }
763 
764   /**
765    * @dev Returns an URI for a given token ID
766    * Throws if the token ID does not exist. May return an empty string.
767    * @param _tokenId uint256 ID of the token to query
768    */
769   function tokenURI(uint256 _tokenId) public view returns (string) {
770     require(exists(_tokenId));
771     return tokenURIs[_tokenId];
772   }
773 
774   /**
775    * @dev Gets the token ID at a given index of the tokens list of the requested owner
776    * @param _owner address owning the tokens list to be accessed
777    * @param _index uint256 representing the index to be accessed of the requested tokens list
778    * @return uint256 token ID at the given index of the tokens list owned by the requested address
779    */
780   function tokenOfOwnerByIndex(
781     address _owner,
782     uint256 _index
783   )
784     public
785     view
786     returns (uint256)
787   {
788     require(_index < balanceOf(_owner));
789     return ownedTokens[_owner][_index];
790   }
791 
792   /**
793    * @dev Gets the total amount of tokens stored by the contract
794    * @return uint256 representing the total amount of tokens
795    */
796   function totalSupply() public view returns (uint256) {
797     return allTokens.length;
798   }
799 
800   /**
801    * @dev Gets the token ID at a given index of all the tokens in this contract
802    * Reverts if the index is greater or equal to the total number of tokens
803    * @param _index uint256 representing the index to be accessed of the tokens list
804    * @return uint256 token ID at the given index of the tokens list
805    */
806   function tokenByIndex(uint256 _index) public view returns (uint256) {
807     require(_index < totalSupply());
808     return allTokens[_index];
809   }
810 
811   /**
812    * @dev Internal function to set the token URI for a given token
813    * Reverts if the token ID does not exist
814    * @param _tokenId uint256 ID of the token to set its URI
815    * @param _uri string URI to assign
816    */
817   function _setTokenURI(uint256 _tokenId, string _uri) internal {
818     require(exists(_tokenId));
819     tokenURIs[_tokenId] = _uri;
820   }
821 
822   /**
823    * @dev Internal function to add a token ID to the list of a given address
824    * @param _to address representing the new owner of the given token ID
825    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
826    */
827   function addTokenTo(address _to, uint256 _tokenId) internal {
828     super.addTokenTo(_to, _tokenId);
829     uint256 length = ownedTokens[_to].length;
830     ownedTokens[_to].push(_tokenId);
831     ownedTokensIndex[_tokenId] = length;
832   }
833 
834   /**
835    * @dev Internal function to remove a token ID from the list of a given address
836    * @param _from address representing the previous owner of the given token ID
837    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
838    */
839   function removeTokenFrom(address _from, uint256 _tokenId) internal {
840     super.removeTokenFrom(_from, _tokenId);
841 
842     uint256 tokenIndex = ownedTokensIndex[_tokenId];
843     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
844     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
845 
846     ownedTokens[_from][tokenIndex] = lastToken;
847     ownedTokens[_from][lastTokenIndex] = 0;
848     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
849     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
850     // the lastToken to the first position, and then dropping the element placed in the last position of the list
851 
852     ownedTokens[_from].length--;
853     ownedTokensIndex[_tokenId] = 0;
854     ownedTokensIndex[lastToken] = tokenIndex;
855   }
856 
857   /**
858    * @dev Internal function to mint a new token
859    * Reverts if the given token ID already exists
860    * @param _to address the beneficiary that will own the minted token
861    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
862    */
863   function _mint(address _to, uint256 _tokenId) internal {
864     super._mint(_to, _tokenId);
865 
866     allTokensIndex[_tokenId] = allTokens.length;
867     allTokens.push(_tokenId);
868   }
869 
870   /**
871    * @dev Internal function to burn a specific token
872    * Reverts if the token does not exist
873    * @param _owner owner of the token to burn
874    * @param _tokenId uint256 ID of the token being burned by the msg.sender
875    */
876   function _burn(address _owner, uint256 _tokenId) internal {
877     super._burn(_owner, _tokenId);
878 
879     // Clear metadata (if any)
880     if (bytes(tokenURIs[_tokenId]).length != 0) {
881       delete tokenURIs[_tokenId];
882     }
883 
884     // Reorg all tokens array
885     uint256 tokenIndex = allTokensIndex[_tokenId];
886     uint256 lastTokenIndex = allTokens.length.sub(1);
887     uint256 lastToken = allTokens[lastTokenIndex];
888 
889     allTokens[tokenIndex] = lastToken;
890     allTokens[lastTokenIndex] = 0;
891 
892     allTokens.length--;
893     allTokensIndex[_tokenId] = 0;
894     allTokensIndex[lastToken] = tokenIndex;
895   }
896 
897 }
898 
899 // File: contracts\BMBYToken.sol
900 
901 contract BMBYToken is ERC721Token("BMBY", "BMBY"), Ownable {
902 
903     struct BMBYTokenInfo {
904         uint64 timestamp;
905         string userId;
906     }
907 
908     BMBYTokenInfo[] public tokens;
909 
910     mapping(uint256 => address) private creators;
911     mapping(uint256 => uint256) private prices;
912 
913     address public ceoAddress;
914     uint64 public creationFee;
915     uint64 public initialTokenValue;
916     string public baseURI;
917 
918     uint public currentOwnerFeePercent;
919     uint public creatorFeePercent;
920 
921     uint256 public priceStep1;
922     uint256 public priceStep2;
923     uint256 public priceStep3;
924     uint256 public priceStep4;
925     uint256 public priceStep5;
926     uint256 public priceStep6;
927     uint256 public priceStep7;
928     uint256 public priceStep8;
929 
930     event TokenCreated(uint256 tokenId, uint64 timestamp, string userId, address creator);
931     event TokenSold(uint256 tokenId, uint256 oldPriceInEther, uint256 newPriceInEther, address prevOwner, address newOwener);
932 
933     // --------------
934 
935 
936     modifier onlyCEO() {
937         require(msg.sender == ceoAddress);
938         _;
939     }
940 
941     constructor() public {
942         ceoAddress = msg.sender;
943         baseURI = "https://bmby.co/api/tokens/";
944 
945         creationFee = 0.03 ether;
946         initialTokenValue = 0.06 ether;
947 
948         priceStep1 = 5.0 ether;
949         priceStep2 = 10.0 ether;
950         priceStep3 = 20.0 ether;
951         priceStep4 = 30.0 ether;
952         priceStep5 = 40.0 ether;
953         priceStep6 = 50.0 ether;
954         priceStep7 = 60.0 ether;
955         priceStep8 = 70.0 ether;
956 
957         currentOwnerFeePercent = 85;
958         creatorFeePercent = 5;
959     }
960 
961 
962     function getNewTokenPrice(uint256 currentTokenPrice) public view returns (uint256){
963 
964         uint newPriceValuePercent;
965 
966         if (currentTokenPrice <= priceStep1) {
967             newPriceValuePercent = 200;
968         } else if (currentTokenPrice <= priceStep2) {
969             newPriceValuePercent = 150;
970         } else if (currentTokenPrice <= priceStep3) {
971             newPriceValuePercent = 135;
972         } else if (currentTokenPrice <= priceStep4) {
973             newPriceValuePercent = 125;
974         } else if (currentTokenPrice <= priceStep5) {
975             newPriceValuePercent = 120;
976         } else if (currentTokenPrice <= priceStep6) {
977             newPriceValuePercent = 117;
978         } else if (currentTokenPrice <= priceStep7) {
979             newPriceValuePercent = 115;
980         } else if (currentTokenPrice <= priceStep8) {
981             newPriceValuePercent = 113;
982         } else {
983             newPriceValuePercent = 110;
984         }
985 
986         return currentTokenPrice.mul(newPriceValuePercent).div(100);
987     }
988 
989     // ------------------------
990     // Critical
991 
992     function mint(string userId) public payable {
993 
994         require(msg.value >= creationFee);
995         address tokenCreator = msg.sender;
996 
997         require(isValidAddress(tokenCreator));
998 
999         uint64 timestamp = uint64(now);
1000 
1001         BMBYTokenInfo memory newToken = BMBYTokenInfo({timestamp : timestamp, userId : userId});
1002 
1003         uint256 tokenId = tokens.push(newToken) - 1;
1004 
1005         require(tokenId == uint256(uint32(tokenId)));
1006 
1007         prices[tokenId] = initialTokenValue;
1008         creators[tokenId] = tokenCreator;
1009 
1010         string memory tokenIdString = toString(tokenId);
1011         string memory tokenUri = concat(baseURI, tokenIdString);
1012 
1013         _mint(tokenCreator, tokenId);
1014         _setTokenURI(tokenId, tokenUri);
1015 
1016         emit TokenCreated(tokenId, timestamp, userId, tokenCreator);
1017     }
1018 
1019     function purchase(uint256 tokenId) public payable {
1020 
1021         address newHolder = msg.sender;
1022         address holder = ownerOf(tokenId);
1023 
1024         require(holder != newHolder);
1025 
1026         uint256 contractPayment = msg.value;
1027 
1028         require(contractPayment > 0);
1029         require(isValidAddress(newHolder));
1030 
1031         uint256 currentTokenPrice = prices[tokenId];
1032 
1033         require(currentTokenPrice > 0);
1034 
1035         require(contractPayment >= currentTokenPrice);
1036 
1037         // -------------------
1038         // New Price
1039 
1040         uint256 newTokenPrice = getNewTokenPrice(currentTokenPrice);
1041         require(newTokenPrice > currentTokenPrice);
1042 
1043         // ------------------------------
1044 
1045         uint256 currentOwnerFee = uint256(currentTokenPrice.mul(currentOwnerFeePercent).div(100));
1046         uint256 creatorFee = uint256(currentTokenPrice.mul(creatorFeePercent).div(100));
1047 
1048         require(contractPayment > currentOwnerFee + creatorFee);
1049 
1050         // ------------------------------
1051 
1052         address creator = creators[tokenId];
1053 
1054         // If the current owner is the contract, the money is already in the balance so there's no need to transfer
1055         if (holder != address(this)) {
1056             // send money to the seller
1057             holder.transfer(currentOwnerFee);
1058         }
1059 
1060         // if the current owner is the creator, we don't give fee at this stage. only if other people purchase you
1061         if (holder != creator) {
1062             // send money to the creator
1063             creator.transfer(creatorFee);
1064         }
1065 
1066         emit Transfer(holder, newHolder, tokenId);
1067         emit TokenSold(tokenId, currentTokenPrice, newTokenPrice, holder, newHolder);
1068 
1069         removeTokenFrom(holder, tokenId);
1070         addTokenTo(newHolder, tokenId);
1071 
1072         prices[tokenId] = newTokenPrice;
1073     }
1074 
1075     function payout(uint256 amount, address destination) public onlyCEO {
1076         require(isValidAddress(destination));
1077         uint balance = address(this).balance;
1078         require(balance >= amount);
1079         destination.transfer(amount);
1080     }
1081 
1082     // ------------------------
1083     // Setters
1084 
1085     function setCEOAddress(address newValue) public onlyCEO {
1086         require(isValidAddress(newValue));
1087         ceoAddress = newValue;
1088     }
1089 
1090     function setCreationFee(uint64 newValue) public onlyCEO {
1091         creationFee = newValue;
1092     }
1093 
1094     function setInitialTokenValue(uint64 newValue) public onlyCEO {
1095         initialTokenValue = newValue;
1096     }
1097 
1098     function setBaseURI(string newValue) public onlyCEO {
1099         baseURI = newValue;
1100     }
1101 
1102     function setCurrentOwnerFeePercent(uint newValue) public onlyCEO {
1103         currentOwnerFeePercent = newValue;
1104     }
1105 
1106     function setCreatorFeePercent(uint newValue) public onlyCEO {
1107         creatorFeePercent = newValue;
1108     }
1109 
1110     function setPriceStep1(uint256 newValue) public onlyCEO {
1111         priceStep1 = newValue;
1112     }
1113 
1114     function setPriceStep2(uint256 newValue) public onlyCEO {
1115         priceStep2 = newValue;
1116     }
1117 
1118     function setPriceStep3(uint256 newValue) public onlyCEO {
1119         priceStep3 = newValue;
1120     }
1121 
1122     function setPriceStep4(uint256 newValue) public onlyCEO {
1123         priceStep4 = newValue;
1124     }
1125 
1126     function setPriceStep5(uint256 newValue) public onlyCEO {
1127         priceStep5 = newValue;
1128     }
1129 
1130     function setPriceStep6(uint256 newValue) public onlyCEO {
1131         priceStep6 = newValue;
1132     }
1133 
1134     function setPriceStep7(uint256 newValue) public onlyCEO {
1135         priceStep7 = newValue;
1136     }
1137 
1138     function setPriceStep8(uint256 newValue) public onlyCEO {
1139         priceStep8 = newValue;
1140     }
1141 
1142     // ------------------------
1143     // Getters
1144 
1145     function getTokenInfo(uint tokenId) public view returns (string userId, uint64 timestamp, address creator, address holder, uint256 price){
1146         BMBYTokenInfo memory tokenInfo = tokens[tokenId];
1147 
1148         userId = tokenInfo.userId;
1149         timestamp = tokenInfo.timestamp;
1150         creator = creators[tokenId];
1151         holder = ownerOf(tokenId);
1152         price = prices[tokenId];
1153     }
1154 
1155     function getTokenCreator(uint256 tokenId) public view returns (address) {
1156         return creators[tokenId];
1157     }
1158 
1159     function getTokenPrice(uint256 tokenId) public view returns (uint256) {
1160         return prices[tokenId];
1161     }
1162 
1163 
1164     // -----------------
1165     // Utilities
1166 
1167     function toString(uint256 v) private pure returns (string) {
1168         if (v == 0) {
1169             return "0";
1170         }
1171         else {
1172             uint maxlength = 100;
1173             bytes memory reversed = new bytes(maxlength);
1174             uint i = 0;
1175             while (v != 0) {
1176                 uint remainder = v % 10;
1177                 v = v / 10;
1178                 reversed[i] = byte(48 + remainder);
1179 
1180                 if (v != 0) {
1181                     i++;
1182                 }
1183             }
1184 
1185             bytes memory s = new bytes(i + 1);
1186             for (uint j = 0; j <= i; j++) {
1187                 s[j] = reversed[i - j];
1188             }
1189             return string(s);
1190 
1191         }
1192     }
1193 
1194     function concat(string _a, string _b) private pure returns (string) {
1195         bytes memory _ba = bytes(_a);
1196         bytes memory _bb = bytes(_b);
1197         string memory abcde = new string(_ba.length + _bb.length);
1198         bytes memory babcde = bytes(abcde);
1199         uint k = 0;
1200         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1201         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1202         return string(babcde);
1203     }
1204 
1205     function isValidAddress(address addr) private pure returns (bool) {
1206         return addr != address(0);
1207     }
1208 
1209 }