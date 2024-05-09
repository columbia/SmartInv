1 pragma solidity ^0.4.24;
2 
3 // File: ..\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: ..\openzeppelin-solidity\contracts\introspection\ERC165.sol
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
87 // File: ..\openzeppelin-solidity\contracts\introspection\SupportsInterfaceWithLookup.sol
88 
89 /**
90  * @title SupportsInterfaceWithLookup
91  * @author Matt Condon (@shrugs)
92  * @dev Implements ERC165 using a lookup table.
93  */
94 contract SupportsInterfaceWithLookup is ERC165 {
95 
96   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
97   /**
98    * 0x01ffc9a7 ===
99    *   bytes4(keccak256('supportsInterface(bytes4)'))
100    */
101 
102   /**
103    * @dev a mapping of interface id to whether or not it's supported
104    */
105   mapping(bytes4 => bool) internal supportedInterfaces;
106 
107   /**
108    * @dev A contract implementing SupportsInterfaceWithLookup
109    * implement ERC165 itself
110    */
111   constructor()
112     public
113   {
114     _registerInterface(InterfaceId_ERC165);
115   }
116 
117   /**
118    * @dev implement supportsInterface(bytes4) using a lookup table
119    */
120   function supportsInterface(bytes4 _interfaceId)
121     external
122     view
123     returns (bool)
124   {
125     return supportedInterfaces[_interfaceId];
126   }
127 
128   /**
129    * @dev private method for registering an interface
130    */
131   function _registerInterface(bytes4 _interfaceId)
132     internal
133   {
134     require(_interfaceId != 0xffffffff);
135     supportedInterfaces[_interfaceId] = true;
136   }
137 }
138 
139 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
140 
141 /**
142  * @title ERC721 Non-Fungible Token Standard basic interface
143  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
144  */
145 contract ERC721Basic is ERC165 {
146 
147   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
148   /*
149    * 0x80ac58cd ===
150    *   bytes4(keccak256('balanceOf(address)')) ^
151    *   bytes4(keccak256('ownerOf(uint256)')) ^
152    *   bytes4(keccak256('approve(address,uint256)')) ^
153    *   bytes4(keccak256('getApproved(uint256)')) ^
154    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
155    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
156    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
157    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
158    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
159    */
160 
161   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
162   /**
163    * 0x780e9d63 ===
164    *   bytes4(keccak256('totalSupply()')) ^
165    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
166    *   bytes4(keccak256('tokenByIndex(uint256)'))
167    */
168 
169   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
170   /**
171    * 0x5b5e139f ===
172    *   bytes4(keccak256('name()')) ^
173    *   bytes4(keccak256('symbol()')) ^
174    *   bytes4(keccak256('tokenURI(uint256)'))
175    */
176 
177   event Transfer(
178     address indexed _from,
179     address indexed _to,
180     uint256 indexed _tokenId
181   );
182   event Approval(
183     address indexed _owner,
184     address indexed _approved,
185     uint256 indexed _tokenId
186   );
187   event ApprovalForAll(
188     address indexed _owner,
189     address indexed _operator,
190     bool _approved
191   );
192 
193   function balanceOf(address _owner) public view returns (uint256 _balance);
194   function ownerOf(uint256 _tokenId) public view returns (address _owner);
195 
196   function approve(address _to, uint256 _tokenId) public;
197   function getApproved(uint256 _tokenId)
198     public view returns (address _operator);
199 
200   function setApprovalForAll(address _operator, bool _approved) public;
201   function isApprovedForAll(address _owner, address _operator)
202     public view returns (bool);
203 
204   function transferFrom(address _from, address _to, uint256 _tokenId) public;
205   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
206     public;
207 
208   function safeTransferFrom(
209     address _from,
210     address _to,
211     uint256 _tokenId,
212     bytes _data
213   )
214     public;
215 }
216 
217 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
221  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
222  */
223 contract ERC721Enumerable is ERC721Basic {
224   function totalSupply() public view returns (uint256);
225   function tokenOfOwnerByIndex(
226     address _owner,
227     uint256 _index
228   )
229     public
230     view
231     returns (uint256 _tokenId);
232 
233   function tokenByIndex(uint256 _index) public view returns (uint256);
234 }
235 
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
239  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
240  */
241 contract ERC721Metadata is ERC721Basic {
242   function name() external view returns (string _name);
243   function symbol() external view returns (string _symbol);
244   function tokenURI(uint256 _tokenId) public view returns (string);
245 }
246 
247 
248 /**
249  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
250  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
251  */
252 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
253 }
254 
255 // File: ..\openzeppelin-solidity\contracts\AddressUtils.sol
256 
257 /**
258  * Utility library of inline functions on addresses
259  */
260 library AddressUtils {
261 
262   /**
263    * Returns whether the target address is a contract
264    * @dev This function will return false if invoked during the constructor of a contract,
265    * as the code is not actually created until after the constructor finishes.
266    * @param _account address of the account to check
267    * @return whether the target address is a contract
268    */
269   function isContract(address _account) internal view returns (bool) {
270     uint256 size;
271     // XXX Currently there is no better way to check if there is a contract in an address
272     // than to check the size of the code at that address.
273     // See https://ethereum.stackexchange.com/a/14016/36603
274     // for more details about how this works.
275     // TODO Check this again before the Serenity release, because all addresses will be
276     // contracts then.
277     // solium-disable-next-line security/no-inline-assembly
278     assembly { size := extcodesize(_account) }
279     return size > 0;
280   }
281 
282 }
283 
284 // File: ..\openzeppelin-solidity\contracts\math\SafeMath.sol
285 
286 /**
287  * @title SafeMath
288  * @dev Math operations with safety checks that revert on error
289  */
290 library SafeMath {
291 
292   /**
293   * @dev Multiplies two numbers, reverts on overflow.
294   */
295   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
296     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
297     // benefit is lost if 'b' is also tested.
298     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
299     if (_a == 0) {
300       return 0;
301     }
302 
303     uint256 c = _a * _b;
304     require(c / _a == _b);
305 
306     return c;
307   }
308 
309   /**
310   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
311   */
312   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
313     require(_b > 0); // Solidity only automatically asserts when dividing by 0
314     uint256 c = _a / _b;
315     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
316 
317     return c;
318   }
319 
320   /**
321   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
322   */
323   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
324     require(_b <= _a);
325     uint256 c = _a - _b;
326 
327     return c;
328   }
329 
330   /**
331   * @dev Adds two numbers, reverts on overflow.
332   */
333   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
334     uint256 c = _a + _b;
335     require(c >= _a);
336 
337     return c;
338   }
339 
340   /**
341   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
342   * reverts when dividing by zero.
343   */
344   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345     require(b != 0);
346     return a % b;
347   }
348 }
349 
350 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 contract ERC721Receiver {
358   /**
359    * @dev Magic value to be returned upon successful reception of an NFT
360    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
361    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
362    */
363   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
364 
365   /**
366    * @notice Handle the receipt of an NFT
367    * @dev The ERC721 smart contract calls this function on the recipient
368    * after a `safetransfer`. This function MAY throw to revert and reject the
369    * transfer. Return of other than the magic value MUST result in the
370    * transaction being reverted.
371    * Note: the contract address is always the message sender.
372    * @param _operator The address which called `safeTransferFrom` function
373    * @param _from The address which previously owned the token
374    * @param _tokenId The NFT identifier which is being transferred
375    * @param _data Additional data with no specified format
376    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
377    */
378   function onERC721Received(
379     address _operator,
380     address _from,
381     uint256 _tokenId,
382     bytes _data
383   )
384     public
385     returns(bytes4);
386 }
387 
388 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
389 
390 /**
391  * @title ERC721 Non-Fungible Token Standard basic implementation
392  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
393  */
394 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
395 
396   using SafeMath for uint256;
397   using AddressUtils for address;
398 
399   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
400   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
401   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
402 
403   // Mapping from token ID to owner
404   mapping (uint256 => address) internal tokenOwner;
405 
406   // Mapping from token ID to approved address
407   mapping (uint256 => address) internal tokenApprovals;
408 
409   // Mapping from owner to number of owned token
410   mapping (address => uint256) internal ownedTokensCount;
411 
412   // Mapping from owner to operator approvals
413   mapping (address => mapping (address => bool)) internal operatorApprovals;
414 
415   constructor()
416     public
417   {
418     // register the supported interfaces to conform to ERC721 via ERC165
419     _registerInterface(InterfaceId_ERC721);
420   }
421 
422   /**
423    * @dev Gets the balance of the specified address
424    * @param _owner address to query the balance of
425    * @return uint256 representing the amount owned by the passed address
426    */
427   function balanceOf(address _owner) public view returns (uint256) {
428     require(_owner != address(0));
429     return ownedTokensCount[_owner];
430   }
431 
432   /**
433    * @dev Gets the owner of the specified token ID
434    * @param _tokenId uint256 ID of the token to query the owner of
435    * @return owner address currently marked as the owner of the given token ID
436    */
437   function ownerOf(uint256 _tokenId) public view returns (address) {
438     address owner = tokenOwner[_tokenId];
439     require(owner != address(0));
440     return owner;
441   }
442 
443   /**
444    * @dev Approves another address to transfer the given token ID
445    * The zero address indicates there is no approved address.
446    * There can only be one approved address per token at a given time.
447    * Can only be called by the token owner or an approved operator.
448    * @param _to address to be approved for the given token ID
449    * @param _tokenId uint256 ID of the token to be approved
450    */
451   function approve(address _to, uint256 _tokenId) public {
452     address owner = ownerOf(_tokenId);
453     require(_to != owner);
454     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
455 
456     tokenApprovals[_tokenId] = _to;
457     emit Approval(owner, _to, _tokenId);
458   }
459 
460   /**
461    * @dev Gets the approved address for a token ID, or zero if no address set
462    * @param _tokenId uint256 ID of the token to query the approval of
463    * @return address currently approved for the given token ID
464    */
465   function getApproved(uint256 _tokenId) public view returns (address) {
466     return tokenApprovals[_tokenId];
467   }
468 
469   /**
470    * @dev Sets or unsets the approval of a given operator
471    * An operator is allowed to transfer all tokens of the sender on their behalf
472    * @param _to operator address to set the approval
473    * @param _approved representing the status of the approval to be set
474    */
475   function setApprovalForAll(address _to, bool _approved) public {
476     require(_to != msg.sender);
477     operatorApprovals[msg.sender][_to] = _approved;
478     emit ApprovalForAll(msg.sender, _to, _approved);
479   }
480 
481   /**
482    * @dev Tells whether an operator is approved by a given owner
483    * @param _owner owner address which you want to query the approval of
484    * @param _operator operator address which you want to query the approval of
485    * @return bool whether the given operator is approved by the given owner
486    */
487   function isApprovedForAll(
488     address _owner,
489     address _operator
490   )
491     public
492     view
493     returns (bool)
494   {
495     return operatorApprovals[_owner][_operator];
496   }
497 
498   /**
499    * @dev Transfers the ownership of a given token ID to another address
500    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
501    * Requires the msg sender to be the owner, approved, or operator
502    * @param _from current owner of the token
503    * @param _to address to receive the ownership of the given token ID
504    * @param _tokenId uint256 ID of the token to be transferred
505   */
506   function transferFrom(
507     address _from,
508     address _to,
509     uint256 _tokenId
510   )
511     public
512   {
513     require(isApprovedOrOwner(msg.sender, _tokenId));
514     require(_to != address(0));
515 
516     clearApproval(_from, _tokenId);
517     removeTokenFrom(_from, _tokenId);
518     addTokenTo(_to, _tokenId);
519 
520     emit Transfer(_from, _to, _tokenId);
521   }
522 
523   /**
524    * @dev Safely transfers the ownership of a given token ID to another address
525    * If the target address is a contract, it must implement `onERC721Received`,
526    * which is called upon a safe transfer, and return the magic value
527    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
528    * the transfer is reverted.
529    *
530    * Requires the msg sender to be the owner, approved, or operator
531    * @param _from current owner of the token
532    * @param _to address to receive the ownership of the given token ID
533    * @param _tokenId uint256 ID of the token to be transferred
534   */
535   function safeTransferFrom(
536     address _from,
537     address _to,
538     uint256 _tokenId
539   )
540     public
541   {
542     // solium-disable-next-line arg-overflow
543     safeTransferFrom(_from, _to, _tokenId, "");
544   }
545 
546   /**
547    * @dev Safely transfers the ownership of a given token ID to another address
548    * If the target address is a contract, it must implement `onERC721Received`,
549    * which is called upon a safe transfer, and return the magic value
550    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
551    * the transfer is reverted.
552    * Requires the msg sender to be the owner, approved, or operator
553    * @param _from current owner of the token
554    * @param _to address to receive the ownership of the given token ID
555    * @param _tokenId uint256 ID of the token to be transferred
556    * @param _data bytes data to send along with a safe transfer check
557    */
558   function safeTransferFrom(
559     address _from,
560     address _to,
561     uint256 _tokenId,
562     bytes _data
563   )
564     public
565   {
566     transferFrom(_from, _to, _tokenId);
567     // solium-disable-next-line arg-overflow
568     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
569   }
570 
571   /**
572    * @dev Returns whether the specified token exists
573    * @param _tokenId uint256 ID of the token to query the existence of
574    * @return whether the token exists
575    */
576   function _exists(uint256 _tokenId) internal view returns (bool) {
577     address owner = tokenOwner[_tokenId];
578     return owner != address(0);
579   }
580 
581   /**
582    * @dev Returns whether the given spender can transfer a given token ID
583    * @param _spender address of the spender to query
584    * @param _tokenId uint256 ID of the token to be transferred
585    * @return bool whether the msg.sender is approved for the given token ID,
586    *  is an operator of the owner, or is the owner of the token
587    */
588   function isApprovedOrOwner(
589     address _spender,
590     uint256 _tokenId
591   )
592     internal
593     view
594     returns (bool)
595   {
596     address owner = ownerOf(_tokenId);
597     // Disable solium check because of
598     // https://github.com/duaraghav8/Solium/issues/175
599     // solium-disable-next-line operator-whitespace
600     return (
601       _spender == owner ||
602       getApproved(_tokenId) == _spender ||
603       isApprovedForAll(owner, _spender)
604     );
605   }
606 
607   /**
608    * @dev Internal function to mint a new token
609    * Reverts if the given token ID already exists
610    * @param _to The address that will own the minted token
611    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
612    */
613   function _mint(address _to, uint256 _tokenId) internal {
614     require(_to != address(0));
615     addTokenTo(_to, _tokenId);
616     emit Transfer(address(0), _to, _tokenId);
617   }
618 
619   /**
620    * @dev Internal function to burn a specific token
621    * Reverts if the token does not exist
622    * @param _tokenId uint256 ID of the token being burned by the msg.sender
623    */
624   function _burn(address _owner, uint256 _tokenId) internal {
625     clearApproval(_owner, _tokenId);
626     removeTokenFrom(_owner, _tokenId);
627     emit Transfer(_owner, address(0), _tokenId);
628   }
629 
630   /**
631    * @dev Internal function to clear current approval of a given token ID
632    * Reverts if the given address is not indeed the owner of the token
633    * @param _owner owner of the token
634    * @param _tokenId uint256 ID of the token to be transferred
635    */
636   function clearApproval(address _owner, uint256 _tokenId) internal {
637     require(ownerOf(_tokenId) == _owner);
638     if (tokenApprovals[_tokenId] != address(0)) {
639       tokenApprovals[_tokenId] = address(0);
640     }
641   }
642 
643   /**
644    * @dev Internal function to add a token ID to the list of a given address
645    * @param _to address representing the new owner of the given token ID
646    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
647    */
648   function addTokenTo(address _to, uint256 _tokenId) internal {
649     require(tokenOwner[_tokenId] == address(0));
650     tokenOwner[_tokenId] = _to;
651     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
652   }
653 
654   /**
655    * @dev Internal function to remove a token ID from the list of a given address
656    * @param _from address representing the previous owner of the given token ID
657    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
658    */
659   function removeTokenFrom(address _from, uint256 _tokenId) internal {
660     require(ownerOf(_tokenId) == _from);
661     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
662     tokenOwner[_tokenId] = address(0);
663   }
664 
665   /**
666    * @dev Internal function to invoke `onERC721Received` on a target address
667    * The call is not executed if the target address is not a contract
668    * @param _from address representing the previous owner of the given token ID
669    * @param _to target address that will receive the tokens
670    * @param _tokenId uint256 ID of the token to be transferred
671    * @param _data bytes optional data to send along with the call
672    * @return whether the call correctly returned the expected magic value
673    */
674   function checkAndCallSafeTransfer(
675     address _from,
676     address _to,
677     uint256 _tokenId,
678     bytes _data
679   )
680     internal
681     returns (bool)
682   {
683     if (!_to.isContract()) {
684       return true;
685     }
686     bytes4 retval = ERC721Receiver(_to).onERC721Received(
687       msg.sender, _from, _tokenId, _data);
688     return (retval == ERC721_RECEIVED);
689   }
690 }
691 
692 // File: ..\openzeppelin-solidity\contracts\token\ERC721\ERC721Token.sol
693 
694 /**
695  * @title Full ERC721 Token
696  * This implementation includes all the required and some optional functionality of the ERC721 standard
697  * Moreover, it includes approve all functionality using operator terminology
698  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
699  */
700 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
701 
702   // Token name
703   string internal name_;
704 
705   // Token symbol
706   string internal symbol_;
707 
708   // Mapping from owner to list of owned token IDs
709   mapping(address => uint256[]) internal ownedTokens;
710 
711   // Mapping from token ID to index of the owner tokens list
712   mapping(uint256 => uint256) internal ownedTokensIndex;
713 
714   // Array with all token ids, used for enumeration
715   uint256[] internal allTokens;
716 
717   // Mapping from token id to position in the allTokens array
718   mapping(uint256 => uint256) internal allTokensIndex;
719 
720   // Optional mapping for token URIs
721   mapping(uint256 => string) internal tokenURIs;
722 
723   /**
724    * @dev Constructor function
725    */
726   constructor(string _name, string _symbol) public {
727     name_ = _name;
728     symbol_ = _symbol;
729 
730     // register the supported interfaces to conform to ERC721 via ERC165
731     _registerInterface(InterfaceId_ERC721Enumerable);
732     _registerInterface(InterfaceId_ERC721Metadata);
733   }
734 
735   /**
736    * @dev Gets the token name
737    * @return string representing the token name
738    */
739   function name() external view returns (string) {
740     return name_;
741   }
742 
743   /**
744    * @dev Gets the token symbol
745    * @return string representing the token symbol
746    */
747   function symbol() external view returns (string) {
748     return symbol_;
749   }
750 
751   /**
752    * @dev Returns an URI for a given token ID
753    * Throws if the token ID does not exist. May return an empty string.
754    * @param _tokenId uint256 ID of the token to query
755    */
756   function tokenURI(uint256 _tokenId) public view returns (string) {
757     require(_exists(_tokenId));
758     return tokenURIs[_tokenId];
759   }
760 
761   /**
762    * @dev Gets the token ID at a given index of the tokens list of the requested owner
763    * @param _owner address owning the tokens list to be accessed
764    * @param _index uint256 representing the index to be accessed of the requested tokens list
765    * @return uint256 token ID at the given index of the tokens list owned by the requested address
766    */
767   function tokenOfOwnerByIndex(
768     address _owner,
769     uint256 _index
770   )
771     public
772     view
773     returns (uint256)
774   {
775     require(_index < balanceOf(_owner));
776     return ownedTokens[_owner][_index];
777   }
778 
779   /**
780    * @dev Gets the total amount of tokens stored by the contract
781    * @return uint256 representing the total amount of tokens
782    */
783   function totalSupply() public view returns (uint256) {
784     return allTokens.length;
785   }
786 
787   /**
788    * @dev Gets the token ID at a given index of all the tokens in this contract
789    * Reverts if the index is greater or equal to the total number of tokens
790    * @param _index uint256 representing the index to be accessed of the tokens list
791    * @return uint256 token ID at the given index of the tokens list
792    */
793   function tokenByIndex(uint256 _index) public view returns (uint256) {
794     require(_index < totalSupply());
795     return allTokens[_index];
796   }
797 
798   /**
799    * @dev Internal function to set the token URI for a given token
800    * Reverts if the token ID does not exist
801    * @param _tokenId uint256 ID of the token to set its URI
802    * @param _uri string URI to assign
803    */
804   function _setTokenURI(uint256 _tokenId, string _uri) internal {
805     require(_exists(_tokenId));
806     tokenURIs[_tokenId] = _uri;
807   }
808 
809   /**
810    * @dev Internal function to add a token ID to the list of a given address
811    * @param _to address representing the new owner of the given token ID
812    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
813    */
814   function addTokenTo(address _to, uint256 _tokenId) internal {
815     super.addTokenTo(_to, _tokenId);
816     uint256 length = ownedTokens[_to].length;
817     ownedTokens[_to].push(_tokenId);
818     ownedTokensIndex[_tokenId] = length;
819   }
820 
821   /**
822    * @dev Internal function to remove a token ID from the list of a given address
823    * @param _from address representing the previous owner of the given token ID
824    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
825    */
826   function removeTokenFrom(address _from, uint256 _tokenId) internal {
827     super.removeTokenFrom(_from, _tokenId);
828 
829     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
830     // then delete the last slot.
831     uint256 tokenIndex = ownedTokensIndex[_tokenId];
832     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
833     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
834 
835     ownedTokens[_from][tokenIndex] = lastToken;
836     // This also deletes the contents at the last position of the array
837     ownedTokens[_from].length--;
838 
839     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
840     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
841     // the lastToken to the first position, and then dropping the element placed in the last position of the list
842 
843     ownedTokensIndex[_tokenId] = 0;
844     ownedTokensIndex[lastToken] = tokenIndex;
845   }
846 
847   /**
848    * @dev Internal function to mint a new token
849    * Reverts if the given token ID already exists
850    * @param _to address the beneficiary that will own the minted token
851    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
852    */
853   function _mint(address _to, uint256 _tokenId) internal {
854     super._mint(_to, _tokenId);
855 
856     allTokensIndex[_tokenId] = allTokens.length;
857     allTokens.push(_tokenId);
858   }
859 
860   /**
861    * @dev Internal function to burn a specific token
862    * Reverts if the token does not exist
863    * @param _owner owner of the token to burn
864    * @param _tokenId uint256 ID of the token being burned by the msg.sender
865    */
866   function _burn(address _owner, uint256 _tokenId) internal {
867     super._burn(_owner, _tokenId);
868 
869     // Clear metadata (if any)
870     if (bytes(tokenURIs[_tokenId]).length != 0) {
871       delete tokenURIs[_tokenId];
872     }
873 
874     // Reorg all tokens array
875     uint256 tokenIndex = allTokensIndex[_tokenId];
876     uint256 lastTokenIndex = allTokens.length.sub(1);
877     uint256 lastToken = allTokens[lastTokenIndex];
878 
879     allTokens[tokenIndex] = lastToken;
880     allTokens[lastTokenIndex] = 0;
881 
882     allTokens.length--;
883     allTokensIndex[_tokenId] = 0;
884     allTokensIndex[lastToken] = tokenIndex;
885   }
886 
887 }
888 
889 // File: contracts\RoyalStables.sol
890 
891 /**
892     @title RoyalStables Holding HRSY token
893 */
894 contract RoyalStables is Ownable,ERC721Token {
895     /**
896         @dev Structure to hold Horsey collectible information
897         @dev should be as small as possible but since its already greater than 256
898         @dev lets keep it <= 512
899     */
900     struct Horsey {
901         address race;       /// @dev Stores the original race address this horsey was claimed from
902         bytes32 dna;        /// @dev Stores the horsey dna
903         uint8 feedingCounter;   /// @dev Boils down to how many times has this horsey been fed
904         uint8 tier;         /// @dev Used internaly to assess chances of a rare trait developing while feeding
905     }
906 
907     /// @dev Maps all token ids to a unique Horsey
908     mapping(uint256 => Horsey) public horseys;
909 
910     /// @dev Maps addresses to the amount of carrots they own
911     mapping(address => uint32) public carrot_credits;
912 
913     /// @dev Maps a horsey token id to the horsey name
914     mapping(uint256 => string) public names;
915 
916     /// @dev Master is the current Horsey contract using this library
917     address public master;
918 
919     /**
920         @dev Contracts constructor
921     */
922     constructor() public
923     Ownable()
924     ERC721Token("HORSEY","HRSY") {
925     }
926 
927     /**
928         @dev Allows to change the address of the current Horsey contract
929         @param newMaster Address of the current Horsey contract
930     */
931     function changeMaster(address newMaster) public
932     validAddress(newMaster)
933     onlyOwner() {
934         master = newMaster;
935     }
936 
937     /**
938         @dev Gets the complete list of token ids which belongs to an address
939         @param eth_address The address you want to lookup owned tokens from
940         @return List of all owned by eth_address tokenIds
941     */
942     function getOwnedTokens(address eth_address) public view returns (uint256[]) {
943         return ownedTokens[eth_address];
944     }
945 
946     /**
947         @dev Stores a horsey name
948         @param tokenId Horsey token id
949         @param newName New horsey name
950     */
951     function storeName(uint256 tokenId, string newName) public
952     onlyMaster() {
953         require(_exists(tokenId),"token not found");
954         names[tokenId] = newName;
955     }
956 
957     /**
958         @dev Stores carrot credits on the clients account
959         @param client Client we need to update the balance of
960         @param amount Amount of carrots to store
961     */
962     function storeCarrotsCredit(address client, uint32 amount) public
963     onlyMaster()
964     validAddress(client) {
965         carrot_credits[client] = amount;
966     }
967 
968     function storeHorsey(address client, uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public
969     onlyMaster()
970     validAddress(client) {
971         //_mint checks if the token exists before minting already, so we dont have to here
972         _mint(client,tokenId);
973         modifyHorsey(tokenId,race,dna,feedingCounter,tier);
974     }
975 
976     function modifyHorsey(uint256 tokenId, address race, bytes32 dna, uint8 feedingCounter, uint8 tier) public
977     onlyMaster() {
978         Horsey storage hrsy = horseys[tokenId];
979         hrsy.race = race;
980         hrsy.dna = dna;
981         hrsy.feedingCounter = feedingCounter;
982         hrsy.tier = tier;
983     }
984 
985     function modifyHorseyDna(uint256 tokenId, bytes32 dna) public
986     onlyMaster() {
987         horseys[tokenId].dna = dna;
988     }
989 
990     function modifyHorseyFeedingCounter(uint256 tokenId, uint8 feedingCounter) public
991     onlyMaster() {
992         horseys[tokenId].feedingCounter = feedingCounter;
993     }
994 
995     function modifyHorseyTier(uint256 tokenId, uint8 tier) public
996     onlyMaster() {
997         horseys[tokenId].tier = tier;
998     }
999 
1000     function unstoreHorsey(uint256 tokenId) public
1001     onlyMaster()
1002     {
1003         require(_exists(tokenId),"token not found");
1004         _burn(ownerOf(tokenId),tokenId);
1005         delete horseys[tokenId];
1006         delete names[tokenId];
1007     }
1008 
1009     /// @dev requires the address to be non null
1010     modifier validAddress(address addr) {
1011         require(addr != address(0),"Address must be non zero");
1012         _;
1013     }
1014 
1015      /// @dev requires the caller to be the master
1016     modifier onlyMaster() {
1017         require(master == msg.sender,"Address must be non zero");
1018         _;
1019     }
1020 }