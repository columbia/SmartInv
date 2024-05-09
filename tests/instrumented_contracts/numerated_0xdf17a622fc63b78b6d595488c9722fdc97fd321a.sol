1 pragma solidity ^0.4.24;
2 
3 // File: contracts/openzeppelin-solidity/introspection/ERC165.sol
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   /**
12    * @notice Query if a contract implements an interface
13    * @param _interfaceId The interface identifier, as specified in ERC-165
14    * @dev Interface identification is specified in ERC-165. This function
15    * uses less than 30,000 gas.
16    */
17   function supportsInterface(bytes4 _interfaceId)
18     external
19     view
20     returns (bool);
21 }
22 
23 // File: contracts/openzeppelin-solidity/token/ERC721/ERC721Basic.sol
24 
25 /**
26  * @title ERC721 Non-Fungible Token Standard basic interface
27  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28  */
29 contract ERC721Basic is ERC165 {
30   event Transfer(
31     address indexed _from,
32     address indexed _to,
33     uint256 indexed _tokenId
34   );
35   event Approval(
36     address indexed _owner,
37     address indexed _approved,
38     uint256 indexed _tokenId
39   );
40   event ApprovalForAll(
41     address indexed _owner,
42     address indexed _operator,
43     bool _approved
44   );
45 
46   function balanceOf(address _owner) public view returns (uint256 _balance);
47   function ownerOf(uint256 _tokenId) public view returns (address _owner);
48   function exists(uint256 _tokenId) public view returns (bool _exists);
49 
50   function approve(address _to, uint256 _tokenId) public;
51   function getApproved(uint256 _tokenId)
52     public view returns (address _operator);
53 
54   function setApprovalForAll(address _operator, bool _approved) public;
55   function isApprovedForAll(address _owner, address _operator)
56     public view returns (bool);
57 
58   function transferFrom(address _from, address _to, uint256 _tokenId) public;
59   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
60     public;
61 
62   function safeTransferFrom(
63     address _from,
64     address _to,
65     uint256 _tokenId,
66     bytes _data
67   )
68     public;
69 }
70 
71 // File: contracts/openzeppelin-solidity/token/ERC721/ERC721.sol
72 
73 /**
74  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
75  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
76  */
77 contract ERC721Enumerable is ERC721Basic {
78   function totalSupply() public view returns (uint256);
79   function tokenOfOwnerByIndex(
80     address _owner,
81     uint256 _index
82   )
83     public
84     view
85     returns (uint256 _tokenId);
86 
87   function tokenByIndex(uint256 _index) public view returns (uint256);
88 }
89 
90 
91 /**
92  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
93  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
94  */
95 contract ERC721Metadata is ERC721Basic {
96   function name() external view returns (string _name);
97   function symbol() external view returns (string _symbol);
98   function tokenURI(uint256 _tokenId) public view returns (string);
99 }
100 
101 
102 /**
103  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
104  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
105  */
106 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
107 }
108 
109 // File: contracts/openzeppelin-solidity/token/ERC721/ERC721Receiver.sol
110 
111 /**
112  * @title ERC721 token receiver interface
113  * @dev Interface for any contract that wants to support safeTransfers
114  * from ERC721 asset contracts.
115  */
116 contract ERC721Receiver {
117   /**
118    * @dev Magic value to be returned upon successful reception of an NFT
119    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
120    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
121    */
122   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
123 
124   /**
125    * @notice Handle the receipt of an NFT
126    * @dev The ERC721 smart contract calls this function on the recipient
127    * after a `safetransfer`. This function MAY throw to revert and reject the
128    * transfer. Return of other than the magic value MUST result in the 
129    * transaction being reverted.
130    * Note: the contract address is always the message sender.
131    * @param _operator The address which called `safeTransferFrom` function
132    * @param _from The address which previously owned the token
133    * @param _tokenId The NFT identifier which is being transfered
134    * @param _data Additional data with no specified format
135    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
136    */
137   function onERC721Received(
138     address _operator,
139     address _from,
140     uint256 _tokenId,
141     bytes _data
142   )
143     public
144     returns(bytes4);
145 }
146 
147 // File: contracts/openzeppelin-solidity/math/SafeMath.sol
148 
149 /**
150  * @title SafeMath
151  * @dev Math operations with safety checks that throw on error
152  */
153 library SafeMath {
154 
155   /**
156   * @dev Multiplies two numbers, throws on overflow.
157   */
158   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
160     // benefit is lost if 'b' is also tested.
161     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
162     if (a == 0) {
163       return 0;
164     }
165 
166     c = a * b;
167     assert(c / a == b);
168     return c;
169   }
170 
171   /**
172   * @dev Integer division of two numbers, truncating the quotient.
173   */
174   function div(uint256 a, uint256 b) internal pure returns (uint256) {
175     // assert(b > 0); // Solidity automatically throws when dividing by 0
176     // uint256 c = a / b;
177     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178     return a / b;
179   }
180 
181   /**
182   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
183   */
184   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185     assert(b <= a);
186     return a - b;
187   }
188 
189   /**
190   * @dev Adds two numbers, throws on overflow.
191   */
192   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
193     c = a + b;
194     assert(c >= a);
195     return c;
196   }
197 }
198 
199 // File: contracts/openzeppelin-solidity/AddressUtils.sol
200 
201 /**
202  * Utility library of inline functions on addresses
203  */
204 library AddressUtils {
205 
206   /**
207    * Returns whether the target address is a contract
208    * @dev This function will return false if invoked during the constructor of a contract,
209    * as the code is not actually created until after the constructor finishes.
210    * @param addr address to check
211    * @return whether the target address is a contract
212    */
213   function isContract(address addr) internal view returns (bool) {
214     uint256 size;
215     // XXX Currently there is no better way to check if there is a contract in an address
216     // than to check the size of the code at that address.
217     // See https://ethereum.stackexchange.com/a/14016/36603
218     // for more details about how this works.
219     // TODO Check this again before the Serenity release, because all addresses will be
220     // contracts then.
221     // solium-disable-next-line security/no-inline-assembly
222     assembly { size := extcodesize(addr) }
223     return size > 0;
224   }
225 
226 }
227 
228 // File: contracts/openzeppelin-solidity/introspection/SupportsInterfaceWithLookup.sol
229 
230 /**
231  * @title SupportsInterfaceWithLookup
232  * @author Matt Condon (@shrugs)
233  * @dev Implements ERC165 using a lookup table.
234  */
235 contract SupportsInterfaceWithLookup is ERC165 {
236   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
237   /**
238    * 0x01ffc9a7 ===
239    *   bytes4(keccak256('supportsInterface(bytes4)'))
240    */
241 
242   /**
243    * @dev a mapping of interface id to whether or not it's supported
244    */
245   mapping(bytes4 => bool) internal supportedInterfaces;
246 
247   /**
248    * @dev A contract implementing SupportsInterfaceWithLookup
249    * implement ERC165 itself
250    */
251   constructor()
252     public
253   {
254     _registerInterface(InterfaceId_ERC165);
255   }
256 
257   /**
258    * @dev implement supportsInterface(bytes4) using a lookup table
259    */
260   function supportsInterface(bytes4 _interfaceId)
261     external
262     view
263     returns (bool)
264   {
265     return supportedInterfaces[_interfaceId];
266   }
267 
268   /**
269    * @dev private method for registering an interface
270    */
271   function _registerInterface(bytes4 _interfaceId)
272     internal
273   {
274     require(_interfaceId != 0xffffffff);
275     supportedInterfaces[_interfaceId] = true;
276   }
277 }
278 
279 // File: contracts/openzeppelin-solidity/token/ERC721/ERC721BasicToken.sol
280 
281 /**
282  * @title ERC721 Non-Fungible Token Standard basic implementation
283  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
284  */
285 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
286 
287   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
288   /*
289    * 0x80ac58cd ===
290    *   bytes4(keccak256('balanceOf(address)')) ^
291    *   bytes4(keccak256('ownerOf(uint256)')) ^
292    *   bytes4(keccak256('approve(address,uint256)')) ^
293    *   bytes4(keccak256('getApproved(uint256)')) ^
294    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
295    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
296    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
297    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
298    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
299    */
300 
301   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
302   /*
303    * 0x4f558e79 ===
304    *   bytes4(keccak256('exists(uint256)'))
305    */
306 
307   using SafeMath for uint256;
308   using AddressUtils for address;
309 
310   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
311   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
312   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
313 
314   // Mapping from token ID to owner
315   mapping (uint256 => address) internal tokenOwner;
316 
317   // Mapping from token ID to approved address
318   mapping (uint256 => address) internal tokenApprovals;
319 
320   // Mapping from owner to number of owned token
321   mapping (address => uint256) internal ownedTokensCount;
322 
323   // Mapping from owner to operator approvals
324   mapping (address => mapping (address => bool)) internal operatorApprovals;
325 
326   /**
327    * @dev Guarantees msg.sender is owner of the given token
328    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
329    */
330   modifier onlyOwnerOf(uint256 _tokenId) {
331     require(ownerOf(_tokenId) == msg.sender);
332     _;
333   }
334 
335   /**
336    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
337    * @param _tokenId uint256 ID of the token to validate
338    */
339   modifier canTransfer(uint256 _tokenId) {
340     require(isApprovedOrOwner(msg.sender, _tokenId));
341     _;
342   }
343 
344   constructor()
345     public
346   {
347     // register the supported interfaces to conform to ERC721 via ERC165
348     _registerInterface(InterfaceId_ERC721);
349     _registerInterface(InterfaceId_ERC721Exists);
350   }
351 
352   /**
353    * @dev Gets the balance of the specified address
354    * @param _owner address to query the balance of
355    * @return uint256 representing the amount owned by the passed address
356    */
357   function balanceOf(address _owner) public view returns (uint256) {
358     require(_owner != address(0));
359     return ownedTokensCount[_owner];
360   }
361 
362   /**
363    * @dev Gets the owner of the specified token ID
364    * @param _tokenId uint256 ID of the token to query the owner of
365    * @return owner address currently marked as the owner of the given token ID
366    */
367   function ownerOf(uint256 _tokenId) public view returns (address) {
368     address owner = tokenOwner[_tokenId];
369     require(owner != address(0));
370     return owner;
371   }
372 
373   /**
374    * @dev Returns whether the specified token exists
375    * @param _tokenId uint256 ID of the token to query the existence of
376    * @return whether the token exists
377    */
378   function exists(uint256 _tokenId) public view returns (bool) {
379     address owner = tokenOwner[_tokenId];
380     return owner != address(0);
381   }
382 
383   /**
384    * @dev Approves another address to transfer the given token ID
385    * The zero address indicates there is no approved address.
386    * There can only be one approved address per token at a given time.
387    * Can only be called by the token owner or an approved operator.
388    * @param _to address to be approved for the given token ID
389    * @param _tokenId uint256 ID of the token to be approved
390    */
391   function approve(address _to, uint256 _tokenId) public {
392     address owner = ownerOf(_tokenId);
393     require(_to != owner);
394     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
395 
396     tokenApprovals[_tokenId] = _to;
397     emit Approval(owner, _to, _tokenId);
398   }
399 
400   /**
401    * @dev Gets the approved address for a token ID, or zero if no address set
402    * @param _tokenId uint256 ID of the token to query the approval of
403    * @return address currently approved for the given token ID
404    */
405   function getApproved(uint256 _tokenId) public view returns (address) {
406     return tokenApprovals[_tokenId];
407   }
408 
409   /**
410    * @dev Sets or unsets the approval of a given operator
411    * An operator is allowed to transfer all tokens of the sender on their behalf
412    * @param _to operator address to set the approval
413    * @param _approved representing the status of the approval to be set
414    */
415   function setApprovalForAll(address _to, bool _approved) public {
416     require(_to != msg.sender);
417     operatorApprovals[msg.sender][_to] = _approved;
418     emit ApprovalForAll(msg.sender, _to, _approved);
419   }
420 
421   /**
422    * @dev Tells whether an operator is approved by a given owner
423    * @param _owner owner address which you want to query the approval of
424    * @param _operator operator address which you want to query the approval of
425    * @return bool whether the given operator is approved by the given owner
426    */
427   function isApprovedForAll(
428     address _owner,
429     address _operator
430   )
431     public
432     view
433     returns (bool)
434   {
435     return operatorApprovals[_owner][_operator];
436   }
437 
438   /**
439    * @dev Transfers the ownership of a given token ID to another address
440    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
441    * Requires the msg sender to be the owner, approved, or operator
442    * @param _from current owner of the token
443    * @param _to address to receive the ownership of the given token ID
444    * @param _tokenId uint256 ID of the token to be transferred
445   */
446   function transferFrom(
447     address _from,
448     address _to,
449     uint256 _tokenId
450   )
451     public
452     canTransfer(_tokenId)
453   {
454     require(_from != address(0));
455     require(_to != address(0));
456 
457     clearApproval(_from, _tokenId);
458     removeTokenFrom(_from, _tokenId);
459     addTokenTo(_to, _tokenId);
460 
461     emit Transfer(_from, _to, _tokenId);
462   }
463 
464   /**
465    * @dev Safely transfers the ownership of a given token ID to another address
466    * If the target address is a contract, it must implement `onERC721Received`,
467    * which is called upon a safe transfer, and return the magic value
468    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
469    * the transfer is reverted.
470    *
471    * Requires the msg sender to be the owner, approved, or operator
472    * @param _from current owner of the token
473    * @param _to address to receive the ownership of the given token ID
474    * @param _tokenId uint256 ID of the token to be transferred
475   */
476   function safeTransferFrom(
477     address _from,
478     address _to,
479     uint256 _tokenId
480   )
481     public
482     canTransfer(_tokenId)
483   {
484     // solium-disable-next-line arg-overflow
485     safeTransferFrom(_from, _to, _tokenId, "");
486   }
487 
488   /**
489    * @dev Safely transfers the ownership of a given token ID to another address
490    * If the target address is a contract, it must implement `onERC721Received`,
491    * which is called upon a safe transfer, and return the magic value
492    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
493    * the transfer is reverted.
494    * Requires the msg sender to be the owner, approved, or operator
495    * @param _from current owner of the token
496    * @param _to address to receive the ownership of the given token ID
497    * @param _tokenId uint256 ID of the token to be transferred
498    * @param _data bytes data to send along with a safe transfer check
499    */
500   function safeTransferFrom(
501     address _from,
502     address _to,
503     uint256 _tokenId,
504     bytes _data
505   )
506     public
507     canTransfer(_tokenId)
508   {
509     transferFrom(_from, _to, _tokenId);
510     // solium-disable-next-line arg-overflow
511     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
512   }
513 
514   /**
515    * @dev Returns whether the given spender can transfer a given token ID
516    * @param _spender address of the spender to query
517    * @param _tokenId uint256 ID of the token to be transferred
518    * @return bool whether the msg.sender is approved for the given token ID,
519    *  is an operator of the owner, or is the owner of the token
520    */
521   function isApprovedOrOwner(
522     address _spender,
523     uint256 _tokenId
524   )
525     internal
526     view
527     returns (bool)
528   {
529     address owner = ownerOf(_tokenId);
530     // Disable solium check because of
531     // https://github.com/duaraghav8/Solium/issues/175
532     // solium-disable-next-line operator-whitespace
533     return (
534       _spender == owner ||
535       getApproved(_tokenId) == _spender ||
536       isApprovedForAll(owner, _spender)
537     );
538   }
539 
540   /**
541    * @dev Internal function to mint a new token
542    * Reverts if the given token ID already exists
543    * @param _to The address that will own the minted token
544    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
545    */
546   function _mint(address _to, uint256 _tokenId) internal {
547     require(_to != address(0));
548     addTokenTo(_to, _tokenId);
549     emit Transfer(address(0), _to, _tokenId);
550   }
551 
552   /**
553    * @dev Internal function to burn a specific token
554    * Reverts if the token does not exist
555    * @param _tokenId uint256 ID of the token being burned by the msg.sender
556    */
557   function _burn(address _owner, uint256 _tokenId) internal {
558     clearApproval(_owner, _tokenId);
559     removeTokenFrom(_owner, _tokenId);
560     emit Transfer(_owner, address(0), _tokenId);
561   }
562 
563   /**
564    * @dev Internal function to clear current approval of a given token ID
565    * Reverts if the given address is not indeed the owner of the token
566    * @param _owner owner of the token
567    * @param _tokenId uint256 ID of the token to be transferred
568    */
569   function clearApproval(address _owner, uint256 _tokenId) internal {
570     require(ownerOf(_tokenId) == _owner);
571     if (tokenApprovals[_tokenId] != address(0)) {
572       tokenApprovals[_tokenId] = address(0);
573     }
574   }
575 
576   /**
577    * @dev Internal function to add a token ID to the list of a given address
578    * @param _to address representing the new owner of the given token ID
579    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
580    */
581   function addTokenTo(address _to, uint256 _tokenId) internal {
582     require(tokenOwner[_tokenId] == address(0));
583     tokenOwner[_tokenId] = _to;
584     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
585   }
586 
587   /**
588    * @dev Internal function to remove a token ID from the list of a given address
589    * @param _from address representing the previous owner of the given token ID
590    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
591    */
592   function removeTokenFrom(address _from, uint256 _tokenId) internal {
593     require(ownerOf(_tokenId) == _from);
594     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
595     tokenOwner[_tokenId] = address(0);
596   }
597 
598   /**
599    * @dev Internal function to invoke `onERC721Received` on a target address
600    * The call is not executed if the target address is not a contract
601    * @param _from address representing the previous owner of the given token ID
602    * @param _to target address that will receive the tokens
603    * @param _tokenId uint256 ID of the token to be transferred
604    * @param _data bytes optional data to send along with the call
605    * @return whether the call correctly returned the expected magic value
606    */
607   function checkAndCallSafeTransfer(
608     address _from,
609     address _to,
610     uint256 _tokenId,
611     bytes _data
612   )
613     internal
614     returns (bool)
615   {
616     if (!_to.isContract()) {
617       return true;
618     }
619     bytes4 retval = ERC721Receiver(_to).onERC721Received(
620       msg.sender, _from, _tokenId, _data);
621     return (retval == ERC721_RECEIVED);
622   }
623 }
624 
625 // File: contracts/openzeppelin-solidity/token/ERC721/ERC721Token.sol
626 
627 /**
628  * @title Full ERC721 Token
629  * This implementation includes all the required and some optional functionality of the ERC721 standard
630  * Moreover, it includes approve all functionality using operator terminology
631  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
632  */
633 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
634 
635   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
636   /**
637    * 0x780e9d63 ===
638    *   bytes4(keccak256('totalSupply()')) ^
639    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
640    *   bytes4(keccak256('tokenByIndex(uint256)'))
641    */
642 
643   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
644   /**
645    * 0x5b5e139f ===
646    *   bytes4(keccak256('name()')) ^
647    *   bytes4(keccak256('symbol()')) ^
648    *   bytes4(keccak256('tokenURI(uint256)'))
649    */
650 
651   // Token name
652   string internal name_;
653 
654   // Token symbol
655   string internal symbol_;
656 
657   // Mapping from owner to list of owned token IDs
658   mapping(address => uint256[]) internal ownedTokens;
659 
660   // Mapping from token ID to index of the owner tokens list
661   mapping(uint256 => uint256) internal ownedTokensIndex;
662 
663   // Array with all token ids, used for enumeration
664   uint256[] internal allTokens;
665 
666   // Mapping from token id to position in the allTokens array
667   mapping(uint256 => uint256) internal allTokensIndex;
668 
669   // Optional mapping for token URIs
670   mapping(uint256 => string) internal tokenURIs;
671 
672   /**
673    * @dev Constructor function
674    */
675   constructor(string _name, string _symbol) public {
676     name_ = _name;
677     symbol_ = _symbol;
678 
679     // register the supported interfaces to conform to ERC721 via ERC165
680     _registerInterface(InterfaceId_ERC721Enumerable);
681     _registerInterface(InterfaceId_ERC721Metadata);
682   }
683 
684   /**
685    * @dev Gets the token name
686    * @return string representing the token name
687    */
688   function name() external view returns (string) {
689     return name_;
690   }
691 
692   /**
693    * @dev Gets the token symbol
694    * @return string representing the token symbol
695    */
696   function symbol() external view returns (string) {
697     return symbol_;
698   }
699 
700   /**
701    * @dev Returns an URI for a given token ID
702    * Throws if the token ID does not exist. May return an empty string.
703    * @param _tokenId uint256 ID of the token to query
704    */
705   function tokenURI(uint256 _tokenId) public view returns (string) {
706     require(exists(_tokenId));
707     return tokenURIs[_tokenId];
708   }
709 
710   /**
711    * @dev Gets the token ID at a given index of the tokens list of the requested owner
712    * @param _owner address owning the tokens list to be accessed
713    * @param _index uint256 representing the index to be accessed of the requested tokens list
714    * @return uint256 token ID at the given index of the tokens list owned by the requested address
715    */
716   function tokenOfOwnerByIndex(
717     address _owner,
718     uint256 _index
719   )
720     public
721     view
722     returns (uint256)
723   {
724     require(_index < balanceOf(_owner));
725     return ownedTokens[_owner][_index];
726   }
727 
728   /**
729    * @dev Gets the total amount of tokens stored by the contract
730    * @return uint256 representing the total amount of tokens
731    */
732   function totalSupply() public view returns (uint256) {
733     return allTokens.length;
734   }
735 
736   /**
737    * @dev Gets the token ID at a given index of all the tokens in this contract
738    * Reverts if the index is greater or equal to the total number of tokens
739    * @param _index uint256 representing the index to be accessed of the tokens list
740    * @return uint256 token ID at the given index of the tokens list
741    */
742   function tokenByIndex(uint256 _index) public view returns (uint256) {
743     require(_index < totalSupply());
744     return allTokens[_index];
745   }
746 
747   /**
748    * @dev Internal function to set the token URI for a given token
749    * Reverts if the token ID does not exist
750    * @param _tokenId uint256 ID of the token to set its URI
751    * @param _uri string URI to assign
752    */
753   function _setTokenURI(uint256 _tokenId, string _uri) internal {
754     require(exists(_tokenId));
755     tokenURIs[_tokenId] = _uri;
756   }
757 
758   /**
759    * @dev Internal function to add a token ID to the list of a given address
760    * @param _to address representing the new owner of the given token ID
761    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
762    */
763   function addTokenTo(address _to, uint256 _tokenId) internal {
764     super.addTokenTo(_to, _tokenId);
765     uint256 length = ownedTokens[_to].length;
766     ownedTokens[_to].push(_tokenId);
767     ownedTokensIndex[_tokenId] = length;
768   }
769 
770   /**
771    * @dev Internal function to remove a token ID from the list of a given address
772    * @param _from address representing the previous owner of the given token ID
773    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
774    */
775   function removeTokenFrom(address _from, uint256 _tokenId) internal {
776     super.removeTokenFrom(_from, _tokenId);
777 
778     uint256 tokenIndex = ownedTokensIndex[_tokenId];
779     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
780     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
781 
782     ownedTokens[_from][tokenIndex] = lastToken;
783     ownedTokens[_from][lastTokenIndex] = 0;
784     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
785     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
786     // the lastToken to the first position, and then dropping the element placed in the last position of the list
787 
788     ownedTokens[_from].length--;
789     ownedTokensIndex[_tokenId] = 0;
790     ownedTokensIndex[lastToken] = tokenIndex;
791   }
792 
793   /**
794    * @dev Internal function to mint a new token
795    * Reverts if the given token ID already exists
796    * @param _to address the beneficiary that will own the minted token
797    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
798    */
799   function _mint(address _to, uint256 _tokenId) internal {
800     super._mint(_to, _tokenId);
801 
802     allTokensIndex[_tokenId] = allTokens.length;
803     allTokens.push(_tokenId);
804   }
805 
806   /**
807    * @dev Internal function to burn a specific token
808    * Reverts if the token does not exist
809    * @param _owner owner of the token to burn
810    * @param _tokenId uint256 ID of the token being burned by the msg.sender
811    */
812   function _burn(address _owner, uint256 _tokenId) internal {
813     super._burn(_owner, _tokenId);
814 
815     // Clear metadata (if any)
816     if (bytes(tokenURIs[_tokenId]).length != 0) {
817       delete tokenURIs[_tokenId];
818     }
819 
820     // Reorg all tokens array
821     uint256 tokenIndex = allTokensIndex[_tokenId];
822     uint256 lastTokenIndex = allTokens.length.sub(1);
823     uint256 lastToken = allTokens[lastTokenIndex];
824 
825     allTokens[tokenIndex] = lastToken;
826     allTokens[lastTokenIndex] = 0;
827 
828     allTokens.length--;
829     allTokensIndex[_tokenId] = 0;
830     allTokensIndex[lastToken] = tokenIndex;
831   }
832 
833 }
834 
835 // File: contracts/openzeppelin-solidity/ownership/Ownable.sol
836 
837 /**
838  * @title Ownable
839  * @dev The Ownable contract has an owner address, and provides basic authorization control
840  * functions, this simplifies the implementation of "user permissions".
841  */
842 contract Ownable {
843   address public owner;
844 
845 
846   event OwnershipRenounced(address indexed previousOwner);
847   event OwnershipTransferred(
848     address indexed previousOwner,
849     address indexed newOwner
850   );
851 
852 
853   /**
854    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
855    * account.
856    */
857   constructor() public {
858     owner = msg.sender;
859   }
860 
861   /**
862    * @dev Throws if called by any account other than the owner.
863    */
864   modifier onlyOwner() {
865     require(msg.sender == owner);
866     _;
867   }
868 
869   /**
870    * @dev Allows the current owner to relinquish control of the contract.
871    * @notice Renouncing to ownership will leave the contract without an owner.
872    * It will not be possible to call the functions with the `onlyOwner`
873    * modifier anymore.
874    */
875   function renounceOwnership() public onlyOwner {
876     emit OwnershipRenounced(owner);
877     owner = address(0);
878   }
879 
880   /**
881    * @dev Allows the current owner to transfer control of the contract to a newOwner.
882    * @param _newOwner The address to transfer ownership to.
883    */
884   function transferOwnership(address _newOwner) public onlyOwner {
885     _transferOwnership(_newOwner);
886   }
887 
888   /**
889    * @dev Transfers control of the contract to a newOwner.
890    * @param _newOwner The address to transfer ownership to.
891    */
892   function _transferOwnership(address _newOwner) internal {
893     require(_newOwner != address(0));
894     emit OwnershipTransferred(owner, _newOwner);
895     owner = _newOwner;
896   }
897 }
898 
899 // File: contracts/ERC721TokenWithData.sol
900 
901 // import "./ERC721SlimTokenArray.sol";
902 
903 
904 
905 // an ERC721 token with additional data storage,
906 contract ERC721TokenWithData is ERC721Token("CryptoAssaultUnit", "CAU"), Ownable {
907 
908   /**
909    * @dev Returns whether the given spender can transfer a given token ID
910    * @param _spender address of the spender to query
911    * @param _tokenId uint256 ID of the token to be transferred
912    * @return bool whether the msg.sender is approved for the given token ID,
913    *  is an operator of the owner, or is the owner of the token
914    */
915 	function isApprovedOrOwner(
916 		address _spender,
917 		uint256 _tokenId
918 	)
919 		internal
920 		view
921 		returns (bool)
922 	{
923 		address owner = ownerOf(_tokenId);
924 		// Disable solium check because of
925 		// https://github.com/duaraghav8/Solium/issues/175
926 		// solium-disable-next-line operator-whitespace
927 		return (
928 			_spender == owner ||
929 			approvedContractAddresses[_spender] ||
930 			getApproved(_tokenId) == _spender ||
931 			isApprovedForAll(owner, _spender)
932 		);
933 	}
934 
935 	mapping (address => bool) internal approvedContractAddresses;
936 	bool approvedContractsFinalized = false;
937 
938 	/**
939 	* @notice Approve a contract address for minting tokens and transferring tokens, when approved by the owner
940 	* @param contractAddress The address that will be approved
941 	*/
942 	function addApprovedContractAddress(address contractAddress) public onlyOwner
943 	{
944 		require(!approvedContractsFinalized);
945 		approvedContractAddresses[contractAddress] = true;
946 	}
947 
948 	/**
949 	* @notice Unapprove a contract address for minting tokens and transferring tokens
950 	* @param contractAddress The address that will be unapproved
951 	*/
952 	function removeApprovedContractAddress(address contractAddress) public onlyOwner
953 	{
954 		require(!approvedContractsFinalized);
955 		approvedContractAddresses[contractAddress] = false;
956 	}
957 
958 	/**
959 	* @notice Finalize the contract so it will be forever impossible to change the approved contracts list
960 	*/
961 	function finalizeApprovedContracts() public onlyOwner {
962 		approvedContractsFinalized = true;
963 	}
964 
965 	mapping(uint256 => mapping(uint256 => uint256)) data;
966 
967 	function getData(uint256 _tokenId, uint256 _index) public view returns (uint256) {
968 		return data[_index][_tokenId];
969 	}
970 
971 	function getData3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3, uint256 _index) public view returns (uint256, uint256, uint256) {
972 		return (
973 			data[_index][_tokenId1],
974 			data[_index][_tokenId2],
975 			data[_index][_tokenId3]
976 		);
977 	}
978 	
979 	function getDataAndOwner3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3, uint256 _index) public view returns (uint256, uint256, uint256, address, address, address) {
980 		return (
981 			data[_index][_tokenId1],
982 			data[_index][_tokenId2],
983 			data[_index][_tokenId3],
984 			ownerOf(_tokenId1),
985 			ownerOf(_tokenId2),
986 			ownerOf(_tokenId3)
987 		);
988 	}
989 	
990 	function _setData(uint256 _tokenId, uint256 _index, uint256 _data) internal {
991 		
992 		data[_index][_tokenId] = _data;
993 	}
994 
995 	function setData(uint256 _tokenId, uint256 _index, uint256 _data) public {
996 		
997 		require(approvedContractAddresses[msg.sender], "not an approved sender");
998 		data[_index][_tokenId] = _data;
999 	}
1000 
1001 	/**
1002 	* @notice Gets the list of tokens owned by a given address
1003 	* @param _owner address to query the tokens of
1004 	* @return uint256[] representing the list of tokens owned by the passed address
1005 	*/
1006 	function tokensOfWithData(address _owner, uint256 _index) public view returns (uint256[], uint256[]) {
1007 		uint256[] memory tokensList = ownedTokens[_owner];
1008 		uint256[] memory dataList = new uint256[](tokensList.length);
1009 		for (uint i=0; i<tokensList.length; i++) {
1010 			dataList[i] = data[_index][tokensList[i]];
1011 		}
1012 		return (tokensList, dataList);
1013 	}
1014 
1015 	// The tokenId of the next minted token. It auto-increments.
1016 	uint256 nextTokenId = 1;
1017 
1018 	function getNextTokenId() public view returns (uint256) {
1019 		return nextTokenId;
1020 	}
1021 
1022 	/**
1023 	* @notice Mint token function
1024 	* @param _to The address that will own the minted token
1025 	*/
1026 	function mintAndSetData(address _to, uint256 _data) public returns (uint256) {
1027 
1028 		require(approvedContractAddresses[msg.sender], "not an approved sender");
1029 
1030 		uint256 tokenId = nextTokenId;
1031 		nextTokenId++;
1032 		_mint(_to, tokenId);
1033 		_setData(tokenId, 0, _data);
1034 
1035 		return tokenId;
1036 	}
1037 
1038 	function burn(uint256 _tokenId) public {
1039 		require(
1040 			approvedContractAddresses[msg.sender] ||
1041 			msg.sender == owner, "burner not approved"
1042 		);
1043 
1044 		_burn(ownerOf(_tokenId), _tokenId);
1045 	}
1046 	
1047 	function burn3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) public {
1048 		require(
1049 			approvedContractAddresses[msg.sender] ||
1050 			msg.sender == owner, "burner not approved"
1051 		);
1052 
1053 		_burn(ownerOf(_tokenId1), _tokenId1);
1054 		_burn(ownerOf(_tokenId2), _tokenId2);
1055 		_burn(ownerOf(_tokenId3), _tokenId3);
1056 	}
1057 }
1058 
1059 // File: contracts/strings/Strings.sol
1060 
1061 library Strings {
1062   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1063   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1064       bytes memory _ba = bytes(_a);
1065       bytes memory _bb = bytes(_b);
1066       bytes memory _bc = bytes(_c);
1067       bytes memory _bd = bytes(_d);
1068       bytes memory _be = bytes(_e);
1069       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1070       bytes memory babcde = bytes(abcde);
1071       uint k = 0;
1072       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1073       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1074       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1075       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1076       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1077       return string(babcde);
1078     }
1079 
1080     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1081         return strConcat(_a, _b, _c, _d, "");
1082     }
1083 
1084     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1085         return strConcat(_a, _b, _c, "", "");
1086     }
1087 
1088     function strConcat(string _a, string _b) internal pure returns (string) {
1089         return strConcat(_a, _b, "", "", "");
1090     }
1091 
1092     function uint2str(uint i) internal pure returns (string) {
1093         if (i == 0) return "0";
1094         uint j = i;
1095         uint len;
1096         while (j != 0){
1097             len++;
1098             j /= 10;
1099         }
1100         bytes memory bstr = new bytes(len);
1101         uint k = len - 1;
1102         while (i != 0){
1103             bstr[k--] = byte(48 + i % 10);
1104             i /= 10;
1105         }
1106         return string(bstr);
1107     }
1108 }
1109 
1110 // File: contracts/Token.sol
1111 
1112 contract Token is ERC721TokenWithData {
1113 
1114 	string metadataUrlPrefix = "https://metadata.cryptoassault.io/unit/";
1115 
1116 	/**
1117 	* @dev Returns an URI for a given token ID
1118 	* Throws if the token ID does not exist. May return an empty string.
1119 	* @param _tokenId uint256 ID of the token to query
1120 	*/
1121 	function tokenURI(uint256 _tokenId) public view returns (string) {
1122 		require(exists(_tokenId));
1123 		return Strings.strConcat(metadataUrlPrefix, Strings.uint2str(_tokenId));
1124 	}
1125 
1126 	function setMetadataUrlPrefix(string _metadataUrlPrefix) public onlyOwner
1127 	{
1128 		metadataUrlPrefix = _metadataUrlPrefix;
1129 	}
1130 }
1131 
1132 // File: contracts/openzeppelin-solidity/lifecycle/Pausable.sol
1133 
1134 /**
1135  * @title Pausable
1136  * @dev Base contract which allows children to implement an emergency stop mechanism.
1137  */
1138 contract Pausable is Ownable {
1139   event Pause();
1140   event Unpause();
1141 
1142   bool public paused = false;
1143 
1144 
1145   /**
1146    * @dev Modifier to make a function callable only when the contract is not paused.
1147    */
1148   modifier whenNotPaused() {
1149     require(!paused);
1150     _;
1151   }
1152 
1153   /**
1154    * @dev Modifier to make a function callable only when the contract is paused.
1155    */
1156   modifier whenPaused() {
1157     require(paused);
1158     _;
1159   }
1160 
1161   /**
1162    * @dev called by the owner to pause, triggers stopped state
1163    */
1164   function pause() onlyOwner whenNotPaused public {
1165     paused = true;
1166     emit Pause();
1167   }
1168 
1169   /**
1170    * @dev called by the owner to unpause, returns to normal state
1171    */
1172   function unpause() onlyOwner whenPaused public {
1173     paused = false;
1174     emit Unpause();
1175   }
1176 }
1177 
1178 // File: contracts/PackSale.sol
1179 
1180 contract PackSale is Pausable {
1181 
1182 	event Sold(address buyer, uint256 sku, uint256 totalPrice);
1183 	event Hatched(address buyer, uint256 amount);
1184 
1185 	uint256 constant PRESALE_START_TIME = 1542484800; //TODO: put in a real time.
1186 	uint256 constant NUM_UNIT_TYPES = 30;
1187 
1188 	Token token;
1189 
1190 	function setTokenContractAddress(address newAddress) onlyOwner public {
1191 		token = Token(newAddress);
1192 	}
1193 	
1194 	struct WaitingToHatch {
1195 		address owner;
1196 		uint16 amount;
1197 		uint16 rarity;
1198 		uint16 sku;
1199 		uint48 purchasedOnBlockNumber;
1200 	}
1201 	mapping (uint256 => WaitingToHatch) waitingToHatch; // This is a LIFO stack.
1202 
1203 	uint64 waitingToHatchNum;
1204 	uint64 hatchNonce = 1;
1205 
1206 	// maps amount to a price.
1207 	mapping(uint256 => uint256) prices;
1208 
1209 	constructor() public {
1210 		prices[1] = 0.017 ether;
1211 		prices[2] = 0.085 ether;
1212 		prices[3] = 0.33 ether;
1213 		prices[4] = 0.587 ether;
1214 		prices[5] = 1.2 ether;
1215 		prices[6] = 2.99 ether;
1216 	}
1217 	
1218 	function withdrawBalance() onlyOwner public {
1219 		owner.transfer(address(this).balance);
1220 	}
1221 
1222 	function setPrice(uint32 sku, uint64 price) public onlyOwner {
1223 		prices[sku] = price;
1224 	}
1225 
1226 	function getPrice(uint32 sku) public view returns (uint256)
1227 	{
1228 		require(now >= PRESALE_START_TIME, "The sale hasn't started yet");
1229 
1230 		uint256 price = prices[sku];
1231 		require (price > 0);
1232 
1233 		// Apply the pre-sale discount
1234 		uint256 intervalsSinceSaleStarted = (now - PRESALE_START_TIME) / (2 days);
1235 		// The discount starts at 30% and goes down 1% every 2 days.
1236 		uint256 pricePercentage = 70 + intervalsSinceSaleStarted;
1237 		if (pricePercentage < 100) {
1238 			price = (price * pricePercentage) / 100;
1239 		}
1240 
1241 		return price;
1242 	}
1243 
1244 	function pushHatch(address to, uint16 amount, uint16 rarity, uint16 sku) private {
1245 
1246 		waitingToHatch[waitingToHatchNum] = WaitingToHatch(to, amount, rarity, sku, uint32(block.number));
1247 		waitingToHatchNum = waitingToHatchNum + 1;
1248 	}
1249 
1250 	function popHatch() private {
1251 
1252 		require(waitingToHatchNum > 0, "trying to popHatch() an empty stack");
1253 		waitingToHatchNum = waitingToHatchNum - 1;
1254 	}
1255 
1256 	function peekHatch() private view returns (WaitingToHatch) {
1257 
1258 		return waitingToHatch[waitingToHatchNum-1];
1259 	}
1260 
1261 	function buy(uint16 sku, address referral) external payable whenNotPaused {
1262 
1263 		uint256 price = getPrice(sku);
1264 		require(msg.value >= price, "Amount paid is too low");
1265 
1266 		// push the purchase onto a FIFO, to be minted in a later transaction.
1267 
1268 		if (sku == 1) {
1269 			pushHatch(msg.sender, 1, 0, sku); // 1 common or better
1270 		} else if (sku == 2) {
1271 			pushHatch(msg.sender, 5, 0, sku); // 5 common or better
1272 		} else if (sku == 3) {
1273 			// 20 common or better
1274 			pushHatch(msg.sender, 10, 0, sku); 
1275 			pushHatch(msg.sender, 10, 0, sku); 
1276 		} else if (sku == 4) {
1277 			pushHatch(msg.sender, 10, 1, sku);  // 10 rare or better
1278 		} else if (sku == 5) {
1279 			pushHatch(msg.sender, 10, 1, sku);  // 10 rare or better
1280 			// 40 common or better
1281 			pushHatch(msg.sender, 10, 0, sku);
1282 			pushHatch(msg.sender, 10, 0, sku);
1283 			pushHatch(msg.sender, 10, 0, sku);
1284 			pushHatch(msg.sender, 10, 0, sku);
1285 		} else if (sku == 6) {
1286 			// 3 epic or better
1287 			pushHatch(msg.sender, 3, 2, sku);
1288 			// 47 rare or better
1289 			pushHatch(msg.sender, 10, 1, sku);
1290 			pushHatch(msg.sender, 10, 1, sku);
1291 			pushHatch(msg.sender, 10, 1, sku);
1292 			pushHatch(msg.sender, 10, 1, sku);
1293 			pushHatch(msg.sender, 7, 1, sku);
1294 		} else {
1295 			require(false, "Invalid sku");
1296 		}
1297 
1298 		// Pay the referral 5%
1299 		if (referral != address(0) && referral != msg.sender) {
1300 			referral.transfer(price / 20);
1301 		}
1302 
1303 		emit Sold(msg.sender, sku, price);
1304 	}
1305 
1306 	function giveFreeUnit(address to, uint16 minRarity) onlyOwner public
1307 	{
1308 		pushHatch(to, 1, minRarity, 0);
1309 	}
1310 
1311 	function getNumMyHatchingUnits() public view returns (uint256) {
1312 		uint256 num = 0;
1313 		for (uint256 i=0; i<waitingToHatchNum; i++) {
1314 			if (waitingToHatch[i].owner == msg.sender) {
1315 				num += waitingToHatch[i].amount;
1316 			}
1317 		}
1318 		return num;
1319 	}
1320 
1321 	function hatchingsNeeded() external view returns (uint256) {
1322 
1323 		return waitingToHatchNum;
1324 	}
1325 	
1326 	function getProjectedBlockHash(uint256 blockNumber) internal view returns (uint256) {
1327 
1328 		uint256 blockToHash = blockNumber;
1329 		uint256 blocksAgo = block.number - blockToHash;
1330 		blockToHash += ((blocksAgo-1) / 256) * 256;
1331 		return uint256(blockhash(blockToHash));
1332 	}
1333 
1334 	function getRandomType(uint16 rand) internal pure returns (uint8)
1335 	{
1336 		return uint8(rand % NUM_UNIT_TYPES);
1337 	}
1338  
1339 	function getRandomRarity(uint32 rand, uint256 minimumRarity) internal pure returns (uint256)
1340 	{
1341 
1342 		uint256 rarityRand;
1343 		if (minimumRarity == 0) {
1344 			rarityRand = rand % 100;
1345 		} else if (minimumRarity == 1) {
1346 			rarityRand = rand % 20 + 80;
1347 		} else if (minimumRarity == 2) {
1348 			rarityRand = rand % 5 + 95;
1349 		} else if (minimumRarity == 3) {
1350 			rarityRand = 99;
1351 		} else {
1352 			require(false, "Invalid minimumRarity");
1353 		}
1354 
1355 		if (rarityRand < 80) return 0;
1356 		if (rarityRand < 95) return 1;
1357 		if (rarityRand < 99) return 2;
1358 		return 3;
1359 	}
1360 
1361 	function hatch() external whenNotPaused {
1362 
1363 		require(waitingToHatchNum > 0, "nothing to hatch");
1364 
1365 		WaitingToHatch memory w = peekHatch();
1366 		
1367 		// can't hatch on the same block. its block hash would be unknown.
1368 		require (w.purchasedOnBlockNumber < block.number, "Can't hatch on the same block.");
1369 
1370 		uint256 rand = getProjectedBlockHash(w.purchasedOnBlockNumber) + hatchNonce;
1371 
1372 		for (uint256 i=0; i<w.amount; i++) {
1373 			rand = uint256(keccak256(abi.encodePacked(rand)));
1374 			uint256 thisRand = rand;
1375 			uint8 unitType = getRandomType(uint16(thisRand));
1376 			thisRand >>= 16;
1377 
1378 			uint256 rarity = getRandomRarity(uint32(thisRand), w.rarity);
1379 			thisRand >>= 32;
1380 
1381 			// TPRDATEDARSKRANDOM__RANDOM__RANDOM__RANDOM__RAND0000000000000000
1382 
1383 			uint256 data = unitType; // 8 bits
1384 
1385 			data <<= 4;
1386 			// data |= 0; // tier 0
1387 
1388 			// birth timestamp
1389 			data <<= 24;
1390 			data |= now / (1 days);
1391 
1392 			data <<= 4;
1393 			data |= rarity;
1394 			data <<= 8;
1395 			data |= w.sku;
1396 			data <<= 208;
1397 			data |= thisRand & 0xffffffffffffffffffffffffffffffffffff0000000000000000;
1398 
1399 			token.mintAndSetData(w.owner, data);
1400 		}
1401 
1402 		popHatch();
1403 
1404 		hatchNonce++;
1405 
1406 		emit Hatched(w.owner, w.amount);
1407 	}
1408 
1409 }