1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32   function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: zeppelin-solidity/contracts/introspection/ERC165.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 /**
49  * @title ERC165
50  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
51  */
52 interface ERC165 {
53 
54   /**
55    * @notice Query if a contract implements an interface
56    * @param _interfaceId The interface identifier, as specified in ERC-165
57    * @dev Interface identification is specified in ERC-165. This function
58    * uses less than 30,000 gas.
59    */
60   function supportsInterface(bytes4 _interfaceId)
61     external
62     view
63     returns (bool);
64 }
65 
66 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
67 
68 pragma solidity ^0.4.24;
69 
70 
71 
72 /**
73  * @title ERC721 Non-Fungible Token Standard basic interface
74  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
75  */
76 contract ERC721Basic is ERC165 {
77   event Transfer(
78     address indexed _from,
79     address indexed _to,
80     uint256 indexed _tokenId
81   );
82   event Approval(
83     address indexed _owner,
84     address indexed _approved,
85     uint256 indexed _tokenId
86   );
87   event ApprovalForAll(
88     address indexed _owner,
89     address indexed _operator,
90     bool _approved
91   );
92 
93   function balanceOf(address _owner) public view returns (uint256 _balance);
94   function ownerOf(uint256 _tokenId) public view returns (address _owner);
95   function exists(uint256 _tokenId) public view returns (bool _exists);
96 
97   function approve(address _to, uint256 _tokenId) public;
98   function getApproved(uint256 _tokenId)
99     public view returns (address _operator);
100 
101   function setApprovalForAll(address _operator, bool _approved) public;
102   function isApprovedForAll(address _owner, address _operator)
103     public view returns (bool);
104 
105   function transferFrom(address _from, address _to, uint256 _tokenId) public;
106   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
107     public;
108 
109   function safeTransferFrom(
110     address _from,
111     address _to,
112     uint256 _tokenId,
113     bytes _data
114   )
115     public;
116 }
117 
118 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
119 
120 pragma solidity ^0.4.24;
121 
122 
123 
124 /**
125  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
126  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
127  */
128 contract ERC721Enumerable is ERC721Basic {
129   function totalSupply() public view returns (uint256);
130   function tokenOfOwnerByIndex(
131     address _owner,
132     uint256 _index
133   )
134     public
135     view
136     returns (uint256 _tokenId);
137 
138   function tokenByIndex(uint256 _index) public view returns (uint256);
139 }
140 
141 
142 /**
143  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
144  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
145  */
146 contract ERC721Metadata is ERC721Basic {
147   function name() external view returns (string _name);
148   function symbol() external view returns (string _symbol);
149   function tokenURI(uint256 _tokenId) public view returns (string);
150 }
151 
152 
153 /**
154  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
155  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
156  */
157 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
158 }
159 
160 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
161 
162 pragma solidity ^0.4.24;
163 
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 contract ERC721Receiver {
171   /**
172    * @dev Magic value to be returned upon successful reception of an NFT
173    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
174    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
175    */
176   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
177 
178   /**
179    * @notice Handle the receipt of an NFT
180    * @dev The ERC721 smart contract calls this function on the recipient
181    * after a `safetransfer`. This function MAY throw to revert and reject the
182    * transfer. Return of other than the magic value MUST result in the 
183    * transaction being reverted.
184    * Note: the contract address is always the message sender.
185    * @param _operator The address which called `safeTransferFrom` function
186    * @param _from The address which previously owned the token
187    * @param _tokenId The NFT identifier which is being transfered
188    * @param _data Additional data with no specified format
189    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
190    */
191   function onERC721Received(
192     address _operator,
193     address _from,
194     uint256 _tokenId,
195     bytes _data
196   )
197     public
198     returns(bytes4);
199 }
200 
201 // File: zeppelin-solidity/contracts/math/SafeMath.sol
202 
203 pragma solidity ^0.4.24;
204 
205 
206 /**
207  * @title SafeMath
208  * @dev Math operations with safety checks that throw on error
209  */
210 library SafeMath {
211 
212   /**
213   * @dev Multiplies two numbers, throws on overflow.
214   */
215   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
216     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
217     // benefit is lost if 'b' is also tested.
218     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
219     if (a == 0) {
220       return 0;
221     }
222 
223     c = a * b;
224     assert(c / a == b);
225     return c;
226   }
227 
228   /**
229   * @dev Integer division of two numbers, truncating the quotient.
230   */
231   function div(uint256 a, uint256 b) internal pure returns (uint256) {
232     // assert(b > 0); // Solidity automatically throws when dividing by 0
233     // uint256 c = a / b;
234     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235     return a / b;
236   }
237 
238   /**
239   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
240   */
241   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242     assert(b <= a);
243     return a - b;
244   }
245 
246   /**
247   * @dev Adds two numbers, throws on overflow.
248   */
249   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
250     c = a + b;
251     assert(c >= a);
252     return c;
253   }
254 }
255 
256 // File: zeppelin-solidity/contracts/AddressUtils.sol
257 
258 pragma solidity ^0.4.24;
259 
260 
261 /**
262  * Utility library of inline functions on addresses
263  */
264 library AddressUtils {
265 
266   /**
267    * Returns whether the target address is a contract
268    * @dev This function will return false if invoked during the constructor of a contract,
269    * as the code is not actually created until after the constructor finishes.
270    * @param addr address to check
271    * @return whether the target address is a contract
272    */
273   function isContract(address addr) internal view returns (bool) {
274     uint256 size;
275     // XXX Currently there is no better way to check if there is a contract in an address
276     // than to check the size of the code at that address.
277     // See https://ethereum.stackexchange.com/a/14016/36603
278     // for more details about how this works.
279     // TODO Check this again before the Serenity release, because all addresses will be
280     // contracts then.
281     // solium-disable-next-line security/no-inline-assembly
282     assembly { size := extcodesize(addr) }
283     return size > 0;
284   }
285 
286 }
287 
288 // File: zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
289 
290 pragma solidity ^0.4.24;
291 
292 
293 
294 /**
295  * @title SupportsInterfaceWithLookup
296  * @author Matt Condon (@shrugs)
297  * @dev Implements ERC165 using a lookup table.
298  */
299 contract SupportsInterfaceWithLookup is ERC165 {
300   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
301   /**
302    * 0x01ffc9a7 ===
303    *   bytes4(keccak256('supportsInterface(bytes4)'))
304    */
305 
306   /**
307    * @dev a mapping of interface id to whether or not it's supported
308    */
309   mapping(bytes4 => bool) internal supportedInterfaces;
310 
311   /**
312    * @dev A contract implementing SupportsInterfaceWithLookup
313    * implement ERC165 itself
314    */
315   constructor()
316     public
317   {
318     _registerInterface(InterfaceId_ERC165);
319   }
320 
321   /**
322    * @dev implement supportsInterface(bytes4) using a lookup table
323    */
324   function supportsInterface(bytes4 _interfaceId)
325     external
326     view
327     returns (bool)
328   {
329     return supportedInterfaces[_interfaceId];
330   }
331 
332   /**
333    * @dev private method for registering an interface
334    */
335   function _registerInterface(bytes4 _interfaceId)
336     internal
337   {
338     require(_interfaceId != 0xffffffff);
339     supportedInterfaces[_interfaceId] = true;
340   }
341 }
342 
343 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
344 
345 pragma solidity ^0.4.24;
346 
347 
348 
349 
350 
351 
352 
353 /**
354  * @title ERC721 Non-Fungible Token Standard basic implementation
355  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
356  */
357 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
358 
359   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
360   /*
361    * 0x80ac58cd ===
362    *   bytes4(keccak256('balanceOf(address)')) ^
363    *   bytes4(keccak256('ownerOf(uint256)')) ^
364    *   bytes4(keccak256('approve(address,uint256)')) ^
365    *   bytes4(keccak256('getApproved(uint256)')) ^
366    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
367    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
368    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
369    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
370    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
371    */
372 
373   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
374   /*
375    * 0x4f558e79 ===
376    *   bytes4(keccak256('exists(uint256)'))
377    */
378 
379   using SafeMath for uint256;
380   using AddressUtils for address;
381 
382   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
383   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
384   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
385 
386   // Mapping from token ID to owner
387   mapping (uint256 => address) internal tokenOwner;
388 
389   // Mapping from token ID to approved address
390   mapping (uint256 => address) internal tokenApprovals;
391 
392   // Mapping from owner to number of owned token
393   mapping (address => uint256) internal ownedTokensCount;
394 
395   // Mapping from owner to operator approvals
396   mapping (address => mapping (address => bool)) internal operatorApprovals;
397 
398   /**
399    * @dev Guarantees msg.sender is owner of the given token
400    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
401    */
402   modifier onlyOwnerOf(uint256 _tokenId) {
403     require(ownerOf(_tokenId) == msg.sender);
404     _;
405   }
406 
407   /**
408    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
409    * @param _tokenId uint256 ID of the token to validate
410    */
411   modifier canTransfer(uint256 _tokenId) {
412     require(isApprovedOrOwner(msg.sender, _tokenId));
413     _;
414   }
415 
416   constructor()
417     public
418   {
419     // register the supported interfaces to conform to ERC721 via ERC165
420     _registerInterface(InterfaceId_ERC721);
421     _registerInterface(InterfaceId_ERC721Exists);
422   }
423 
424   /**
425    * @dev Gets the balance of the specified address
426    * @param _owner address to query the balance of
427    * @return uint256 representing the amount owned by the passed address
428    */
429   function balanceOf(address _owner) public view returns (uint256) {
430     require(_owner != address(0));
431     return ownedTokensCount[_owner];
432   }
433 
434   /**
435    * @dev Gets the owner of the specified token ID
436    * @param _tokenId uint256 ID of the token to query the owner of
437    * @return owner address currently marked as the owner of the given token ID
438    */
439   function ownerOf(uint256 _tokenId) public view returns (address) {
440     address owner = tokenOwner[_tokenId];
441     require(owner != address(0));
442     return owner;
443   }
444 
445   /**
446    * @dev Returns whether the specified token exists
447    * @param _tokenId uint256 ID of the token to query the existence of
448    * @return whether the token exists
449    */
450   function exists(uint256 _tokenId) public view returns (bool) {
451     address owner = tokenOwner[_tokenId];
452     return owner != address(0);
453   }
454 
455   /**
456    * @dev Approves another address to transfer the given token ID
457    * The zero address indicates there is no approved address.
458    * There can only be one approved address per token at a given time.
459    * Can only be called by the token owner or an approved operator.
460    * @param _to address to be approved for the given token ID
461    * @param _tokenId uint256 ID of the token to be approved
462    */
463   function approve(address _to, uint256 _tokenId) public {
464     address owner = ownerOf(_tokenId);
465     require(_to != owner);
466     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
467 
468     tokenApprovals[_tokenId] = _to;
469     emit Approval(owner, _to, _tokenId);
470   }
471 
472   /**
473    * @dev Gets the approved address for a token ID, or zero if no address set
474    * @param _tokenId uint256 ID of the token to query the approval of
475    * @return address currently approved for the given token ID
476    */
477   function getApproved(uint256 _tokenId) public view returns (address) {
478     return tokenApprovals[_tokenId];
479   }
480 
481   /**
482    * @dev Sets or unsets the approval of a given operator
483    * An operator is allowed to transfer all tokens of the sender on their behalf
484    * @param _to operator address to set the approval
485    * @param _approved representing the status of the approval to be set
486    */
487   function setApprovalForAll(address _to, bool _approved) public {
488     require(_to != msg.sender);
489     operatorApprovals[msg.sender][_to] = _approved;
490     emit ApprovalForAll(msg.sender, _to, _approved);
491   }
492 
493   /**
494    * @dev Tells whether an operator is approved by a given owner
495    * @param _owner owner address which you want to query the approval of
496    * @param _operator operator address which you want to query the approval of
497    * @return bool whether the given operator is approved by the given owner
498    */
499   function isApprovedForAll(
500     address _owner,
501     address _operator
502   )
503     public
504     view
505     returns (bool)
506   {
507     return operatorApprovals[_owner][_operator];
508   }
509 
510   /**
511    * @dev Transfers the ownership of a given token ID to another address
512    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
513    * Requires the msg sender to be the owner, approved, or operator
514    * @param _from current owner of the token
515    * @param _to address to receive the ownership of the given token ID
516    * @param _tokenId uint256 ID of the token to be transferred
517   */
518   function transferFrom(
519     address _from,
520     address _to,
521     uint256 _tokenId
522   )
523     public
524     canTransfer(_tokenId)
525   {
526     require(_from != address(0));
527     require(_to != address(0));
528 
529     clearApproval(_from, _tokenId);
530     removeTokenFrom(_from, _tokenId);
531     addTokenTo(_to, _tokenId);
532 
533     emit Transfer(_from, _to, _tokenId);
534   }
535 
536   /**
537    * @dev Safely transfers the ownership of a given token ID to another address
538    * If the target address is a contract, it must implement `onERC721Received`,
539    * which is called upon a safe transfer, and return the magic value
540    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
541    * the transfer is reverted.
542    *
543    * Requires the msg sender to be the owner, approved, or operator
544    * @param _from current owner of the token
545    * @param _to address to receive the ownership of the given token ID
546    * @param _tokenId uint256 ID of the token to be transferred
547   */
548   function safeTransferFrom(
549     address _from,
550     address _to,
551     uint256 _tokenId
552   )
553     public
554     canTransfer(_tokenId)
555   {
556     // solium-disable-next-line arg-overflow
557     safeTransferFrom(_from, _to, _tokenId, "");
558   }
559 
560   /**
561    * @dev Safely transfers the ownership of a given token ID to another address
562    * If the target address is a contract, it must implement `onERC721Received`,
563    * which is called upon a safe transfer, and return the magic value
564    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
565    * the transfer is reverted.
566    * Requires the msg sender to be the owner, approved, or operator
567    * @param _from current owner of the token
568    * @param _to address to receive the ownership of the given token ID
569    * @param _tokenId uint256 ID of the token to be transferred
570    * @param _data bytes data to send along with a safe transfer check
571    */
572   function safeTransferFrom(
573     address _from,
574     address _to,
575     uint256 _tokenId,
576     bytes _data
577   )
578     public
579     canTransfer(_tokenId)
580   {
581     transferFrom(_from, _to, _tokenId);
582     // solium-disable-next-line arg-overflow
583     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
584   }
585 
586   /**
587    * @dev Returns whether the given spender can transfer a given token ID
588    * @param _spender address of the spender to query
589    * @param _tokenId uint256 ID of the token to be transferred
590    * @return bool whether the msg.sender is approved for the given token ID,
591    *  is an operator of the owner, or is the owner of the token
592    */
593   function isApprovedOrOwner(
594     address _spender,
595     uint256 _tokenId
596   )
597     internal
598     view
599     returns (bool)
600   {
601     address owner = ownerOf(_tokenId);
602     // Disable solium check because of
603     // https://github.com/duaraghav8/Solium/issues/175
604     // solium-disable-next-line operator-whitespace
605     return (
606       _spender == owner ||
607       getApproved(_tokenId) == _spender ||
608       isApprovedForAll(owner, _spender)
609     );
610   }
611 
612   /**
613    * @dev Internal function to mint a new token
614    * Reverts if the given token ID already exists
615    * @param _to The address that will own the minted token
616    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
617    */
618   function _mint(address _to, uint256 _tokenId) internal {
619     require(_to != address(0));
620     addTokenTo(_to, _tokenId);
621     emit Transfer(address(0), _to, _tokenId);
622   }
623 
624   /**
625    * @dev Internal function to burn a specific token
626    * Reverts if the token does not exist
627    * @param _tokenId uint256 ID of the token being burned by the msg.sender
628    */
629   function _burn(address _owner, uint256 _tokenId) internal {
630     clearApproval(_owner, _tokenId);
631     removeTokenFrom(_owner, _tokenId);
632     emit Transfer(_owner, address(0), _tokenId);
633   }
634 
635   /**
636    * @dev Internal function to clear current approval of a given token ID
637    * Reverts if the given address is not indeed the owner of the token
638    * @param _owner owner of the token
639    * @param _tokenId uint256 ID of the token to be transferred
640    */
641   function clearApproval(address _owner, uint256 _tokenId) internal {
642     require(ownerOf(_tokenId) == _owner);
643     if (tokenApprovals[_tokenId] != address(0)) {
644       tokenApprovals[_tokenId] = address(0);
645     }
646   }
647 
648   /**
649    * @dev Internal function to add a token ID to the list of a given address
650    * @param _to address representing the new owner of the given token ID
651    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
652    */
653   function addTokenTo(address _to, uint256 _tokenId) internal {
654     require(tokenOwner[_tokenId] == address(0));
655     tokenOwner[_tokenId] = _to;
656     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
657   }
658 
659   /**
660    * @dev Internal function to remove a token ID from the list of a given address
661    * @param _from address representing the previous owner of the given token ID
662    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
663    */
664   function removeTokenFrom(address _from, uint256 _tokenId) internal {
665     require(ownerOf(_tokenId) == _from);
666     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
667     tokenOwner[_tokenId] = address(0);
668   }
669 
670   /**
671    * @dev Internal function to invoke `onERC721Received` on a target address
672    * The call is not executed if the target address is not a contract
673    * @param _from address representing the previous owner of the given token ID
674    * @param _to target address that will receive the tokens
675    * @param _tokenId uint256 ID of the token to be transferred
676    * @param _data bytes optional data to send along with the call
677    * @return whether the call correctly returned the expected magic value
678    */
679   function checkAndCallSafeTransfer(
680     address _from,
681     address _to,
682     uint256 _tokenId,
683     bytes _data
684   )
685     internal
686     returns (bool)
687   {
688     if (!_to.isContract()) {
689       return true;
690     }
691     bytes4 retval = ERC721Receiver(_to).onERC721Received(
692       msg.sender, _from, _tokenId, _data);
693     return (retval == ERC721_RECEIVED);
694   }
695 }
696 
697 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
698 
699 pragma solidity ^0.4.24;
700 
701 
702 
703 
704 
705 /**
706  * @title Full ERC721 Token
707  * This implementation includes all the required and some optional functionality of the ERC721 standard
708  * Moreover, it includes approve all functionality using operator terminology
709  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
710  */
711 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
712 
713   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
714   /**
715    * 0x780e9d63 ===
716    *   bytes4(keccak256('totalSupply()')) ^
717    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
718    *   bytes4(keccak256('tokenByIndex(uint256)'))
719    */
720 
721   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
722   /**
723    * 0x5b5e139f ===
724    *   bytes4(keccak256('name()')) ^
725    *   bytes4(keccak256('symbol()')) ^
726    *   bytes4(keccak256('tokenURI(uint256)'))
727    */
728 
729   // Token name
730   string internal name_;
731 
732   // Token symbol
733   string internal symbol_;
734 
735   // Mapping from owner to list of owned token IDs
736   mapping(address => uint256[]) internal ownedTokens;
737 
738   // Mapping from token ID to index of the owner tokens list
739   mapping(uint256 => uint256) internal ownedTokensIndex;
740 
741   // Array with all token ids, used for enumeration
742   uint256[] internal allTokens;
743 
744   // Mapping from token id to position in the allTokens array
745   mapping(uint256 => uint256) internal allTokensIndex;
746 
747   // Optional mapping for token URIs
748   mapping(uint256 => string) internal tokenURIs;
749 
750   /**
751    * @dev Constructor function
752    */
753   constructor(string _name, string _symbol) public {
754     name_ = _name;
755     symbol_ = _symbol;
756 
757     // register the supported interfaces to conform to ERC721 via ERC165
758     _registerInterface(InterfaceId_ERC721Enumerable);
759     _registerInterface(InterfaceId_ERC721Metadata);
760   }
761 
762   /**
763    * @dev Gets the token name
764    * @return string representing the token name
765    */
766   function name() external view returns (string) {
767     return name_;
768   }
769 
770   /**
771    * @dev Gets the token symbol
772    * @return string representing the token symbol
773    */
774   function symbol() external view returns (string) {
775     return symbol_;
776   }
777 
778   /**
779    * @dev Returns an URI for a given token ID
780    * Throws if the token ID does not exist. May return an empty string.
781    * @param _tokenId uint256 ID of the token to query
782    */
783   function tokenURI(uint256 _tokenId) public view returns (string) {
784     require(exists(_tokenId));
785     return tokenURIs[_tokenId];
786   }
787 
788   /**
789    * @dev Gets the token ID at a given index of the tokens list of the requested owner
790    * @param _owner address owning the tokens list to be accessed
791    * @param _index uint256 representing the index to be accessed of the requested tokens list
792    * @return uint256 token ID at the given index of the tokens list owned by the requested address
793    */
794   function tokenOfOwnerByIndex(
795     address _owner,
796     uint256 _index
797   )
798     public
799     view
800     returns (uint256)
801   {
802     require(_index < balanceOf(_owner));
803     return ownedTokens[_owner][_index];
804   }
805 
806   /**
807    * @dev Gets the total amount of tokens stored by the contract
808    * @return uint256 representing the total amount of tokens
809    */
810   function totalSupply() public view returns (uint256) {
811     return allTokens.length;
812   }
813 
814   /**
815    * @dev Gets the token ID at a given index of all the tokens in this contract
816    * Reverts if the index is greater or equal to the total number of tokens
817    * @param _index uint256 representing the index to be accessed of the tokens list
818    * @return uint256 token ID at the given index of the tokens list
819    */
820   function tokenByIndex(uint256 _index) public view returns (uint256) {
821     require(_index < totalSupply());
822     return allTokens[_index];
823   }
824 
825   /**
826    * @dev Internal function to set the token URI for a given token
827    * Reverts if the token ID does not exist
828    * @param _tokenId uint256 ID of the token to set its URI
829    * @param _uri string URI to assign
830    */
831   function _setTokenURI(uint256 _tokenId, string _uri) internal {
832     require(exists(_tokenId));
833     tokenURIs[_tokenId] = _uri;
834   }
835 
836   /**
837    * @dev Internal function to add a token ID to the list of a given address
838    * @param _to address representing the new owner of the given token ID
839    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
840    */
841   function addTokenTo(address _to, uint256 _tokenId) internal {
842     super.addTokenTo(_to, _tokenId);
843     uint256 length = ownedTokens[_to].length;
844     ownedTokens[_to].push(_tokenId);
845     ownedTokensIndex[_tokenId] = length;
846   }
847 
848   /**
849    * @dev Internal function to remove a token ID from the list of a given address
850    * @param _from address representing the previous owner of the given token ID
851    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
852    */
853   function removeTokenFrom(address _from, uint256 _tokenId) internal {
854     super.removeTokenFrom(_from, _tokenId);
855 
856     uint256 tokenIndex = ownedTokensIndex[_tokenId];
857     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
858     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
859 
860     ownedTokens[_from][tokenIndex] = lastToken;
861     ownedTokens[_from][lastTokenIndex] = 0;
862     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
863     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
864     // the lastToken to the first position, and then dropping the element placed in the last position of the list
865 
866     ownedTokens[_from].length--;
867     ownedTokensIndex[_tokenId] = 0;
868     ownedTokensIndex[lastToken] = tokenIndex;
869   }
870 
871   /**
872    * @dev Internal function to mint a new token
873    * Reverts if the given token ID already exists
874    * @param _to address the beneficiary that will own the minted token
875    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
876    */
877   function _mint(address _to, uint256 _tokenId) internal {
878     super._mint(_to, _tokenId);
879 
880     allTokensIndex[_tokenId] = allTokens.length;
881     allTokens.push(_tokenId);
882   }
883 
884   /**
885    * @dev Internal function to burn a specific token
886    * Reverts if the token does not exist
887    * @param _owner owner of the token to burn
888    * @param _tokenId uint256 ID of the token being burned by the msg.sender
889    */
890   function _burn(address _owner, uint256 _tokenId) internal {
891     super._burn(_owner, _tokenId);
892 
893     // Clear metadata (if any)
894     if (bytes(tokenURIs[_tokenId]).length != 0) {
895       delete tokenURIs[_tokenId];
896     }
897 
898     // Reorg all tokens array
899     uint256 tokenIndex = allTokensIndex[_tokenId];
900     uint256 lastTokenIndex = allTokens.length.sub(1);
901     uint256 lastToken = allTokens[lastTokenIndex];
902 
903     allTokens[tokenIndex] = lastToken;
904     allTokens[lastTokenIndex] = 0;
905 
906     allTokens.length--;
907     allTokensIndex[_tokenId] = 0;
908     allTokensIndex[lastToken] = tokenIndex;
909   }
910 
911 }
912 
913 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
914 
915 pragma solidity ^0.4.24;
916 
917 
918 /**
919  * @title Ownable
920  * @dev The Ownable contract has an owner address, and provides basic authorization control
921  * functions, this simplifies the implementation of "user permissions".
922  */
923 contract Ownable {
924   address public owner;
925 
926 
927   event OwnershipRenounced(address indexed previousOwner);
928   event OwnershipTransferred(
929     address indexed previousOwner,
930     address indexed newOwner
931   );
932 
933 
934   /**
935    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
936    * account.
937    */
938   constructor() public {
939     owner = msg.sender;
940   }
941 
942   /**
943    * @dev Throws if called by any account other than the owner.
944    */
945   modifier onlyOwner() {
946     require(msg.sender == owner);
947     _;
948   }
949 
950   /**
951    * @dev Allows the current owner to relinquish control of the contract.
952    * @notice Renouncing to ownership will leave the contract without an owner.
953    * It will not be possible to call the functions with the `onlyOwner`
954    * modifier anymore.
955    */
956   function renounceOwnership() public onlyOwner {
957     emit OwnershipRenounced(owner);
958     owner = address(0);
959   }
960 
961   /**
962    * @dev Allows the current owner to transfer control of the contract to a newOwner.
963    * @param _newOwner The address to transfer ownership to.
964    */
965   function transferOwnership(address _newOwner) public onlyOwner {
966     _transferOwnership(_newOwner);
967   }
968 
969   /**
970    * @dev Transfers control of the contract to a newOwner.
971    * @param _newOwner The address to transfer ownership to.
972    */
973   function _transferOwnership(address _newOwner) internal {
974     require(_newOwner != address(0));
975     emit OwnershipTransferred(owner, _newOwner);
976     owner = _newOwner;
977   }
978 }
979 
980 // File: contracts/helpers/Admin.sol
981 
982 pragma solidity ^0.4.24;
983 
984 
985 /**
986  * @title Ownable
987  * @dev The Ownable contract has an admin address, and provides basic authorization control
988  * functions, this simplifies the implementation of "user permissions".
989  */
990 contract Admin {
991   mapping (address => bool) public admins;
992 
993 
994   event AdminshipRenounced(address indexed previousAdmin);
995   event AdminshipTransferred(
996     address indexed previousAdmin,
997     address indexed newAdmin
998   );
999 
1000 
1001   /**
1002    * @dev The Ownable constructor sets the original `admin` of the contract to the sender
1003    * account.
1004    */
1005   constructor() public {
1006     admins[msg.sender] = true;
1007   }
1008 
1009   /**
1010    * @dev Throws if called by any account other than the admin.
1011    */
1012   modifier onlyAdmin() {
1013     require(admins[msg.sender]);
1014     _;
1015   }
1016 
1017   function isAdmin(address _admin) public view returns(bool) {
1018     return admins[_admin];
1019   }
1020 
1021   /**
1022    * @dev Allows the current admin to relinquish control of the contract.
1023    * @notice Renouncing to adminship will leave the contract without an admin.
1024    * It will not be possible to call the functions with the `onlyAdmin`
1025    * modifier anymore.
1026    */
1027   function renounceAdminship(address _previousAdmin) public onlyAdmin {
1028     emit AdminshipRenounced(_previousAdmin);
1029     admins[_previousAdmin] = false;
1030   }
1031 
1032   /**
1033    * @dev Allows the current admin to transfer control of the contract to a newAdmin.
1034    * @param _newAdmin The address to transfer adminship to.
1035    */
1036   function transferAdminship(address _newAdmin) public onlyAdmin {
1037     _transferAdminship(_newAdmin);
1038   }
1039 
1040   /**
1041    * @dev Transfers control of the contract to a newAdmin.
1042    * @param _newAdmin The address to transfer adminship to.
1043    */
1044   function _transferAdminship(address _newAdmin) internal {
1045     require(_newAdmin != address(0));
1046     emit AdminshipTransferred(msg.sender, _newAdmin);
1047     admins[_newAdmin] = true;
1048   }
1049 }
1050 
1051 // File: contracts/helpers/strings.sol
1052 
1053 /*
1054  * @title String & slice utility library for Solidity contracts.
1055  * @author Nick Johnson <arachnid@notdot.net>
1056  *
1057  * @dev Functionality in this library is largely implemented using an
1058  *      abstraction called a 'slice'. A slice represents a part of a string -
1059  *      anything from the entire string to a single character, or even no
1060  *      characters at all (a 0-length slice). Since a slice only has to specify
1061  *      an offset and a length, copying and manipulating slices is a lot less
1062  *      expensive than copying and manipulating the strings they reference.
1063  *
1064  *      To further reduce gas costs, most functions on slice that need to return
1065  *      a slice modify the original one instead of allocating a new one; for
1066  *      instance, `s.split(".")` will return the text up to the first '.',
1067  *      modifying s to only contain the remainder of the string after the '.'.
1068  *      In situations where you do not want to modify the original slice, you
1069  *      can make a copy first with `.copy()`, for example:
1070  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1071  *      Solidity has no memory management, it will result in allocating many
1072  *      short-lived slices that are later discarded.
1073  *
1074  *      Functions that return two slices come in two versions: a non-allocating
1075  *      version that takes the second slice as an argument, modifying it in
1076  *      place, and an allocating version that allocates and returns the second
1077  *      slice; see `nextRune` for example.
1078  *
1079  *      Functions that have to copy string data will return strings rather than
1080  *      slices; these can be cast back to slices for further processing if
1081  *      required.
1082  *
1083  *      For convenience, some functions are provided with non-modifying
1084  *      variants that create a new slice and return both; for instance,
1085  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1086  *      corresponding to the left and right parts of the string.
1087  */
1088 
1089 pragma solidity ^0.4.14;
1090 
1091 library strings {
1092     struct slice {
1093         uint _len;
1094         uint _ptr;
1095     }
1096 
1097     function memcpy(uint dest, uint src, uint len) private pure{
1098         // Copy word-length chunks while possible
1099         for(; len >= 32; len -= 32) {
1100             assembly {
1101                 mstore(dest, mload(src))
1102             }
1103             dest += 32;
1104             src += 32;
1105         }
1106 
1107         // Copy remaining bytes
1108         uint mask = 256 ** (32 - len) - 1;
1109         assembly {
1110             let srcpart := and(mload(src), not(mask))
1111             let destpart := and(mload(dest), mask)
1112             mstore(dest, or(destpart, srcpart))
1113         }
1114     }
1115 
1116     /*
1117      * @dev Returns a slice containing the entire string.
1118      * @param self The string to make a slice from.
1119      * @return A newly allocated slice containing the entire string.
1120      */
1121     function toSlice(string self) internal pure returns (slice) {
1122         uint ptr;
1123         assembly {
1124             ptr := add(self, 0x20)
1125         }
1126         return slice(bytes(self).length, ptr);
1127     }
1128 
1129     /*
1130      * @dev Returns the length of a null-terminated bytes32 string.
1131      * @param self The value to find the length of.
1132      * @return The length of the string, from 0 to 32.
1133      */
1134     function len(bytes32 self) internal pure returns (uint) {
1135         uint ret;
1136         if (self == 0)
1137             return 0;
1138         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1139             ret += 16;
1140             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1141         }
1142         if (self & 0xffffffffffffffff == 0) {
1143             ret += 8;
1144             self = bytes32(uint(self) / 0x10000000000000000);
1145         }
1146         if (self & 0xffffffff == 0) {
1147             ret += 4;
1148             self = bytes32(uint(self) / 0x100000000);
1149         }
1150         if (self & 0xffff == 0) {
1151             ret += 2;
1152             self = bytes32(uint(self) / 0x10000);
1153         }
1154         if (self & 0xff == 0) {
1155             ret += 1;
1156         }
1157         return 32 - ret;
1158     }
1159 
1160     /*
1161      * @dev Returns a slice containing the entire bytes32, interpreted as a
1162      *      null-termintaed utf-8 string.
1163      * @param self The bytes32 value to convert to a slice.
1164      * @return A new slice containing the value of the input argument up to the
1165      *         first null.
1166      */
1167     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
1168         // Allocate space for `self` in memory, copy it there, and point ret at it
1169         assembly {
1170             let ptr := mload(0x40)
1171             mstore(0x40, add(ptr, 0x20))
1172             mstore(ptr, self)
1173             mstore(add(ret, 0x20), ptr)
1174         }
1175         ret._len = len(self);
1176     }
1177 
1178     /*
1179      * @dev Returns a new slice containing the same data as the current slice.
1180      * @param self The slice to copy.
1181      * @return A new slice containing the same data as `self`.
1182      */
1183     function copy(slice self) internal pure returns (slice) {
1184         return slice(self._len, self._ptr);
1185     }
1186 
1187     /*
1188      * @dev Copies a slice to a new string.
1189      * @param self The slice to copy.
1190      * @return A newly allocated string containing the slice's text.
1191      */
1192     function toString(slice self) internal pure returns (string) {
1193         var ret = new string(self._len);
1194         uint retptr;
1195         assembly { retptr := add(ret, 32) }
1196 
1197         memcpy(retptr, self._ptr, self._len);
1198         return ret;
1199     }
1200 
1201     /*
1202      * @dev Returns the length in runes of the slice. Note that this operation
1203      *      takes time proportional to the length of the slice; avoid using it
1204      *      in loops, and call `slice.empty()` if you only need to know whether
1205      *      the slice is empty or not.
1206      * @param self The slice to operate on.
1207      * @return The length of the slice in runes.
1208      */
1209     function len(slice self) internal pure returns (uint l) {
1210         // Starting at ptr-31 means the LSB will be the byte we care about
1211         var ptr = self._ptr - 31;
1212         var end = ptr + self._len;
1213         for (l = 0; ptr < end; l++) {
1214             uint8 b;
1215             assembly { b := and(mload(ptr), 0xFF) }
1216             if (b < 0x80) {
1217                 ptr += 1;
1218             } else if(b < 0xE0) {
1219                 ptr += 2;
1220             } else if(b < 0xF0) {
1221                 ptr += 3;
1222             } else if(b < 0xF8) {
1223                 ptr += 4;
1224             } else if(b < 0xFC) {
1225                 ptr += 5;
1226             } else {
1227                 ptr += 6;
1228             }
1229         }
1230     }
1231 
1232     /*
1233      * @dev Returns true if the slice is empty (has a length of 0).
1234      * @param self The slice to operate on.
1235      * @return True if the slice is empty, False otherwise.
1236      */
1237     function empty(slice self) internal pure returns (bool) {
1238         return self._len == 0;
1239     }
1240 
1241     /*
1242      * @dev Returns a positive number if `other` comes lexicographically after
1243      *      `self`, a negative number if it comes before, or zero if the
1244      *      contents of the two slices are equal. Comparison is done per-rune,
1245      *      on unicode codepoints.
1246      * @param self The first slice to compare.
1247      * @param other The second slice to compare.
1248      * @return The result of the comparison.
1249      */
1250     function compare(slice self, slice other) internal pure returns (int) {
1251         uint shortest = self._len;
1252         if (other._len < self._len)
1253             shortest = other._len;
1254 
1255         var selfptr = self._ptr;
1256         var otherptr = other._ptr;
1257         for (uint idx = 0; idx < shortest; idx += 32) {
1258             uint a;
1259             uint b;
1260             assembly {
1261                 a := mload(selfptr)
1262                 b := mload(otherptr)
1263             }
1264             if (a != b) {
1265                 // Mask out irrelevant bytes and check again
1266                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1267                 var diff = (a & mask) - (b & mask);
1268                 if (diff != 0)
1269                     return int(diff);
1270             }
1271             selfptr += 32;
1272             otherptr += 32;
1273         }
1274         return int(self._len) - int(other._len);
1275     }
1276 
1277     /*
1278      * @dev Returns true if the two slices contain the same text.
1279      * @param self The first slice to compare.
1280      * @param self The second slice to compare.
1281      * @return True if the slices are equal, false otherwise.
1282      */
1283     function equals(slice self, slice other) internal pure returns (bool) {
1284         return compare(self, other) == 0;
1285     }
1286 
1287     /*
1288      * @dev Extracts the first rune in the slice into `rune`, advancing the
1289      *      slice to point to the next rune and returning `self`.
1290      * @param self The slice to operate on.
1291      * @param rune The slice that will contain the first rune.
1292      * @return `rune`.
1293      */
1294     function nextRune(slice self, slice rune) internal pure returns (slice) {
1295         rune._ptr = self._ptr;
1296 
1297         if (self._len == 0) {
1298             rune._len = 0;
1299             return rune;
1300         }
1301 
1302         uint len;
1303         uint b;
1304         // Load the first byte of the rune into the LSBs of b
1305         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1306         if (b < 0x80) {
1307             len = 1;
1308         } else if(b < 0xE0) {
1309             len = 2;
1310         } else if(b < 0xF0) {
1311             len = 3;
1312         } else {
1313             len = 4;
1314         }
1315 
1316         // Check for truncated codepoints
1317         if (len > self._len) {
1318             rune._len = self._len;
1319             self._ptr += self._len;
1320             self._len = 0;
1321             return rune;
1322         }
1323 
1324         self._ptr += len;
1325         self._len -= len;
1326         rune._len = len;
1327         return rune;
1328     }
1329 
1330     /*
1331      * @dev Returns the first rune in the slice, advancing the slice to point
1332      *      to the next rune.
1333      * @param self The slice to operate on.
1334      * @return A slice containing only the first rune from `self`.
1335      */
1336     function nextRune(slice self) internal pure returns (slice ret) {
1337         nextRune(self, ret);
1338     }
1339 
1340     /*
1341      * @dev Returns the number of the first codepoint in the slice.
1342      * @param self The slice to operate on.
1343      * @return The number of the first codepoint in the slice.
1344      */
1345     function ord(slice self) internal pure returns (uint ret) {
1346         if (self._len == 0) {
1347             return 0;
1348         }
1349 
1350         uint word;
1351         uint length;
1352         uint divisor = 2 ** 248;
1353 
1354         // Load the rune into the MSBs of b
1355         assembly { word:= mload(mload(add(self, 32))) }
1356         var b = word / divisor;
1357         if (b < 0x80) {
1358             ret = b;
1359             length = 1;
1360         } else if(b < 0xE0) {
1361             ret = b & 0x1F;
1362             length = 2;
1363         } else if(b < 0xF0) {
1364             ret = b & 0x0F;
1365             length = 3;
1366         } else {
1367             ret = b & 0x07;
1368             length = 4;
1369         }
1370 
1371         // Check for truncated codepoints
1372         if (length > self._len) {
1373             return 0;
1374         }
1375 
1376         for (uint i = 1; i < length; i++) {
1377             divisor = divisor / 256;
1378             b = (word / divisor) & 0xFF;
1379             if (b & 0xC0 != 0x80) {
1380                 // Invalid UTF-8 sequence
1381                 return 0;
1382             }
1383             ret = (ret * 64) | (b & 0x3F);
1384         }
1385 
1386         return ret;
1387     }
1388 
1389     /*
1390      * @dev Returns the keccak-256 hash of the slice.
1391      * @param self The slice to hash.
1392      * @return The hash of the slice.
1393      */
1394     function keccak(slice self) internal pure returns (bytes32 ret) {
1395         assembly {
1396             ret := keccak256(mload(add(self, 32)), mload(self))
1397         }
1398     }
1399 
1400     /*
1401      * @dev Returns true if `self` starts with `needle`.
1402      * @param self The slice to operate on.
1403      * @param needle The slice to search for.
1404      * @return True if the slice starts with the provided text, false otherwise.
1405      */
1406     function startsWith(slice self, slice needle) internal pure returns (bool) {
1407         if (self._len < needle._len) {
1408             return false;
1409         }
1410 
1411         if (self._ptr == needle._ptr) {
1412             return true;
1413         }
1414 
1415         bool equal;
1416         assembly {
1417             let length := mload(needle)
1418             let selfptr := mload(add(self, 0x20))
1419             let needleptr := mload(add(needle, 0x20))
1420             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1421         }
1422         return equal;
1423     }
1424 
1425     /*
1426      * @dev If `self` starts with `needle`, `needle` is removed from the
1427      *      beginning of `self`. Otherwise, `self` is unmodified.
1428      * @param self The slice to operate on.
1429      * @param needle The slice to search for.
1430      * @return `self`
1431      */
1432     function beyond(slice self, slice needle) internal pure returns (slice) {
1433         if (self._len < needle._len) {
1434             return self;
1435         }
1436 
1437         bool equal = true;
1438         if (self._ptr != needle._ptr) {
1439             assembly {
1440                 let length := mload(needle)
1441                 let selfptr := mload(add(self, 0x20))
1442                 let needleptr := mload(add(needle, 0x20))
1443                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1444             }
1445         }
1446 
1447         if (equal) {
1448             self._len -= needle._len;
1449             self._ptr += needle._len;
1450         }
1451 
1452         return self;
1453     }
1454 
1455     /*
1456      * @dev Returns true if the slice ends with `needle`.
1457      * @param self The slice to operate on.
1458      * @param needle The slice to search for.
1459      * @return True if the slice starts with the provided text, false otherwise.
1460      */
1461     function endsWith(slice self, slice needle) internal pure returns (bool) {
1462         if (self._len < needle._len) {
1463             return false;
1464         }
1465 
1466         var selfptr = self._ptr + self._len - needle._len;
1467 
1468         if (selfptr == needle._ptr) {
1469             return true;
1470         }
1471 
1472         bool equal;
1473         assembly {
1474             let length := mload(needle)
1475             let needleptr := mload(add(needle, 0x20))
1476             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1477         }
1478 
1479         return equal;
1480     }
1481 
1482     /*
1483      * @dev If `self` ends with `needle`, `needle` is removed from the
1484      *      end of `self`. Otherwise, `self` is unmodified.
1485      * @param self The slice to operate on.
1486      * @param needle The slice to search for.
1487      * @return `self`
1488      */
1489     function until(slice self, slice needle) internal pure returns (slice) {
1490         if (self._len < needle._len) {
1491             return self;
1492         }
1493 
1494         var selfptr = self._ptr + self._len - needle._len;
1495         bool equal = true;
1496         if (selfptr != needle._ptr) {
1497             assembly {
1498                 let length := mload(needle)
1499                 let needleptr := mload(add(needle, 0x20))
1500                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1501             }
1502         }
1503 
1504         if (equal) {
1505             self._len -= needle._len;
1506         }
1507 
1508         return self;
1509     }
1510 
1511     // Returns the memory address of the first byte of the first occurrence of
1512     // `needle` in `self`, or the first byte after `self` if not found.
1513     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1514         uint ptr;
1515         uint idx;
1516 
1517         if (needlelen <= selflen) {
1518             if (needlelen <= 32) {
1519                 // Optimized assembly for 68 gas per byte on short strings
1520                 assembly {
1521                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1522                     let needledata := and(mload(needleptr), mask)
1523                     let end := add(selfptr, sub(selflen, needlelen))
1524                     ptr := selfptr
1525                     loop:
1526                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1527                     ptr := add(ptr, 1)
1528                     jumpi(loop, lt(sub(ptr, 1), end))
1529                     ptr := add(selfptr, selflen)
1530                     exit:
1531                 }
1532                 return ptr;
1533             } else {
1534                 // For long needles, use hashing
1535                 bytes32 hash;
1536                 assembly { hash := sha3(needleptr, needlelen) }
1537                 ptr = selfptr;
1538                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1539                     bytes32 testHash;
1540                     assembly { testHash := sha3(ptr, needlelen) }
1541                     if (hash == testHash)
1542                         return ptr;
1543                     ptr += 1;
1544                 }
1545             }
1546         }
1547         return selfptr + selflen;
1548     }
1549 
1550     // Returns the memory address of the first byte after the last occurrence of
1551     // `needle` in `self`, or the address of `self` if not found.
1552     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1553         uint ptr;
1554 
1555         if (needlelen <= selflen) {
1556             if (needlelen <= 32) {
1557                 // Optimized assembly for 69 gas per byte on short strings
1558                 assembly {
1559                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1560                     let needledata := and(mload(needleptr), mask)
1561                     ptr := add(selfptr, sub(selflen, needlelen))
1562                     loop:
1563                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
1564                     ptr := sub(ptr, 1)
1565                     jumpi(loop, gt(add(ptr, 1), selfptr))
1566                     ptr := selfptr
1567                     jump(exit)
1568                     ret:
1569                     ptr := add(ptr, needlelen)
1570                     exit:
1571                 }
1572                 return ptr;
1573             } else {
1574                 // For long needles, use hashing
1575                 bytes32 hash;
1576                 assembly { hash := sha3(needleptr, needlelen) }
1577                 ptr = selfptr + (selflen - needlelen);
1578                 while (ptr >= selfptr) {
1579                     bytes32 testHash;
1580                     assembly { testHash := sha3(ptr, needlelen) }
1581                     if (hash == testHash)
1582                         return ptr + needlelen;
1583                     ptr -= 1;
1584                 }
1585             }
1586         }
1587         return selfptr;
1588     }
1589 
1590     /*
1591      * @dev Modifies `self` to contain everything from the first occurrence of
1592      *      `needle` to the end of the slice. `self` is set to the empty slice
1593      *      if `needle` is not found.
1594      * @param self The slice to search and modify.
1595      * @param needle The text to search for.
1596      * @return `self`.
1597      */
1598     function find(slice self, slice needle) internal returns (slice) {
1599         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1600         self._len -= ptr - self._ptr;
1601         self._ptr = ptr;
1602         return self;
1603     }
1604 
1605     /*
1606      * @dev Modifies `self` to contain the part of the string from the start of
1607      *      `self` to the end of the first occurrence of `needle`. If `needle`
1608      *      is not found, `self` is set to the empty slice.
1609      * @param self The slice to search and modify.
1610      * @param needle The text to search for.
1611      * @return `self`.
1612      */
1613     function rfind(slice self, slice needle) internal returns (slice) {
1614         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1615         self._len = ptr - self._ptr;
1616         return self;
1617     }
1618 
1619     /*
1620      * @dev Splits the slice, setting `self` to everything after the first
1621      *      occurrence of `needle`, and `token` to everything before it. If
1622      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1623      *      and `token` is set to the entirety of `self`.
1624      * @param self The slice to split.
1625      * @param needle The text to search for in `self`.
1626      * @param token An output parameter to which the first token is written.
1627      * @return `token`.
1628      */
1629     function split(slice self, slice needle, slice token) internal returns (slice) {
1630         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1631         token._ptr = self._ptr;
1632         token._len = ptr - self._ptr;
1633         if (ptr == self._ptr + self._len) {
1634             // Not found
1635             self._len = 0;
1636         } else {
1637             self._len -= token._len + needle._len;
1638             self._ptr = ptr + needle._len;
1639         }
1640         return token;
1641     }
1642 
1643     /*
1644      * @dev Splits the slice, setting `self` to everything after the first
1645      *      occurrence of `needle`, and returning everything before it. If
1646      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1647      *      and the entirety of `self` is returned.
1648      * @param self The slice to split.
1649      * @param needle The text to search for in `self`.
1650      * @return The part of `self` up to the first occurrence of `delim`.
1651      */
1652     function split(slice self, slice needle) internal returns (slice token) {
1653         split(self, needle, token);
1654     }
1655 
1656     /*
1657      * @dev Splits the slice, setting `self` to everything before the last
1658      *      occurrence of `needle`, and `token` to everything after it. If
1659      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1660      *      and `token` is set to the entirety of `self`.
1661      * @param self The slice to split.
1662      * @param needle The text to search for in `self`.
1663      * @param token An output parameter to which the first token is written.
1664      * @return `token`.
1665      */
1666     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
1667         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1668         token._ptr = ptr;
1669         token._len = self._len - (ptr - self._ptr);
1670         if (ptr == self._ptr) {
1671             // Not found
1672             self._len = 0;
1673         } else {
1674             self._len -= token._len + needle._len;
1675         }
1676         return token;
1677     }
1678 
1679     /*
1680      * @dev Splits the slice, setting `self` to everything before the last
1681      *      occurrence of `needle`, and returning everything after it. If
1682      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1683      *      and the entirety of `self` is returned.
1684      * @param self The slice to split.
1685      * @param needle The text to search for in `self`.
1686      * @return The part of `self` after the last occurrence of `delim`.
1687      */
1688     function rsplit(slice self, slice needle) internal returns (slice token) {
1689         rsplit(self, needle, token);
1690     }
1691 
1692     /*
1693      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1694      * @param self The slice to search.
1695      * @param needle The text to search for in `self`.
1696      * @return The number of occurrences of `needle` found in `self`.
1697      */
1698     function count(slice self, slice needle) internal returns (uint cnt) {
1699         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1700         while (ptr <= self._ptr + self._len) {
1701             cnt++;
1702             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1703         }
1704     }
1705 
1706     /*
1707      * @dev Returns True if `self` contains `needle`.
1708      * @param self The slice to search.
1709      * @param needle The text to search for in `self`.
1710      * @return True if `needle` is found in `self`, false otherwise.
1711      */
1712     function contains(slice self, slice needle) internal returns (bool) {
1713         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1714     }
1715 
1716     /*
1717      * @dev Returns a newly allocated string containing the concatenation of
1718      *      `self` and `other`.
1719      * @param self The first slice to concatenate.
1720      * @param other The second slice to concatenate.
1721      * @return The concatenation of the two strings.
1722      */
1723     function concat(slice self, slice other) internal pure returns (string) {
1724         var ret = new string(self._len + other._len);
1725         uint retptr;
1726         assembly { retptr := add(ret, 32) }
1727         memcpy(retptr, self._ptr, self._len);
1728         memcpy(retptr + self._len, other._ptr, other._len);
1729         return ret;
1730     }
1731 
1732     /*
1733      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1734      *      newly allocated string.
1735      * @param self The delimiter to use.
1736      * @param parts A list of slices to join.
1737      * @return A newly allocated string containing all the slices in `parts`,
1738      *         joined with `self`.
1739      */
1740     function join(slice self, slice[] parts) internal pure returns (string) {
1741         if (parts.length == 0)
1742             return "";
1743 
1744         uint length = self._len * (parts.length - 1);
1745         for(uint i = 0; i < parts.length; i++)
1746             length += parts[i]._len;
1747 
1748         var ret = new string(length);
1749         uint retptr;
1750         assembly { retptr := add(ret, 32) }
1751 
1752         for(i = 0; i < parts.length; i++) {
1753             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1754             retptr += parts[i]._len;
1755             if (i < parts.length - 1) {
1756                 memcpy(retptr, self._ptr, self._len);
1757                 retptr += self._len;
1758             }
1759         }
1760 
1761         return ret;
1762     }
1763 }
1764 
1765 // File: contracts/CloversMetadata.sol
1766 
1767 pragma solidity ^0.4.18;
1768 
1769 /**
1770 * CloversMetadata contract is upgradeable and returns metadata about Clovers
1771 */
1772 
1773 
1774 
1775 contract CloversMetadata {
1776     using strings for *;
1777 
1778     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
1779         string memory base = "https://api2.clovers.network/clovers/metadata/0x";
1780         string memory id = uint2hexstr(_tokenId);
1781         string memory suffix = "";
1782         return base.toSlice().concat(id.toSlice()).toSlice().concat(suffix.toSlice());
1783     }
1784     function uint2hexstr(uint i) internal pure returns (string) {
1785         if (i == 0) return "0";
1786         uint j = i;
1787         uint length;
1788         while (j != 0) {
1789             length++;
1790             j = j >> 4;
1791         }
1792         uint mask = 15;
1793         bytes memory bstr = new bytes(length);
1794         uint k = length - 1;
1795         while (i != 0){
1796             uint curr = (i & mask);
1797             bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
1798             i = i >> 4;
1799         }
1800         return string(bstr);
1801     }
1802 }
1803 
1804 // File: contracts/Clovers.sol
1805 
1806 pragma solidity ^0.4.18;
1807 
1808 /**
1809  * Digital Asset Registry for the Non Fungible Token Clover
1810  * with upgradeable contract reference for returning metadata.
1811  */
1812 
1813 
1814 
1815 
1816 
1817 
1818 
1819 contract Clovers is ERC721Token, Admin, Ownable {
1820 
1821     address public cloversMetadata;
1822     uint256 public totalSymmetries;
1823     uint256[5] symmetries; // RotSym, Y0Sym, X0Sym, XYSym, XnYSym
1824     address public cloversController;
1825     address public clubTokenController;
1826 
1827     mapping (uint256 => Clover) public clovers;
1828     struct Clover {
1829         bool keep;
1830         uint256 symmetries;
1831         bytes28[2] cloverMoves;
1832         uint256 blockMinted;
1833         uint256 rewards;
1834     }
1835 
1836     modifier onlyOwnerOrController() {
1837         require(
1838             msg.sender == cloversController ||
1839             owner == msg.sender ||
1840             admins[msg.sender]
1841         );
1842         _;
1843     }
1844 
1845 
1846     /**
1847     * @dev Checks msg.sender can transfer a token, by being owner, approved, operator or cloversController
1848     * @param _tokenId uint256 ID of the token to validate
1849     */
1850     modifier canTransfer(uint256 _tokenId) {
1851         require(isApprovedOrOwner(msg.sender, _tokenId) || msg.sender == cloversController);
1852         _;
1853     }
1854 
1855     constructor(string name, string symbol) public
1856         ERC721Token(name, symbol)
1857     { }
1858 
1859     function () public payable {}
1860 
1861     function implementation() public view returns (address) {
1862         return cloversMetadata;
1863     }
1864 
1865     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
1866         return CloversMetadata(cloversMetadata).tokenURI(_tokenId);
1867     }
1868     function getHash(bytes28[2] moves) public pure returns (bytes32) {
1869         return keccak256(moves);
1870     }
1871     function getKeep(uint256 _tokenId) public view returns (bool) {
1872         return clovers[_tokenId].keep;
1873     }
1874     function getBlockMinted(uint256 _tokenId) public view returns (uint256) {
1875         return clovers[_tokenId].blockMinted;
1876     }
1877     function getCloverMoves(uint256 _tokenId) public view returns (bytes28[2]) {
1878         return clovers[_tokenId].cloverMoves;
1879     }
1880     function getReward(uint256 _tokenId) public view returns (uint256) {
1881         return clovers[_tokenId].rewards;
1882     }
1883     function getSymmetries(uint256 _tokenId) public view returns (uint256) {
1884         return clovers[_tokenId].symmetries;
1885     }
1886     function getAllSymmetries() public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1887         return (
1888             totalSymmetries,
1889             symmetries[0], //RotSym,
1890             symmetries[1], //Y0Sym,
1891             symmetries[2], //X0Sym,
1892             symmetries[3], //XYSym,
1893             symmetries[4] //XnYSym
1894         );
1895     }
1896 
1897 /* ---------------------------------------------------------------------------------------------------------------------- */
1898 
1899     /**
1900     * @dev Moves Eth to a certain address for use in the CloversController
1901     * @param _to The address to receive the Eth.
1902     * @param _amount The amount of Eth to be transferred.
1903     */
1904     function moveEth(address _to, uint256 _amount) public onlyOwnerOrController {
1905         require(_amount <= this.balance);
1906         _to.transfer(_amount);
1907     }
1908     /**
1909     * @dev Moves Token to a certain address for use in the CloversController
1910     * @param _to The address to receive the Token.
1911     * @param _amount The amount of Token to be transferred.
1912     * @param _token The address of the Token to be transferred.
1913     */
1914     function moveToken(address _to, uint256 _amount, address _token) public onlyOwnerOrController returns (bool) {
1915         require(_amount <= ERC20(_token).balanceOf(this));
1916         return ERC20(_token).transfer(_to, _amount);
1917     }
1918     /**
1919     * @dev Approves Tokens to a certain address for use in the CloversController
1920     * @param _to The address to receive the Token approval.
1921     * @param _amount The amount of Token to be approved.
1922     * @param _token The address of the Token to be approved.
1923     */
1924     function approveToken(address _to, uint256 _amount, address _token) public onlyOwnerOrController returns (bool) {
1925         return ERC20(_token).approve(_to, _amount);
1926     }
1927 
1928     /**
1929     * @dev Sets whether the minter will keep the clover
1930     * @param _tokenId The token Id.
1931     * @param value Whether the clover will be kept.
1932     */
1933     function setKeep(uint256 _tokenId, bool value) public onlyOwnerOrController {
1934         clovers[_tokenId].keep = value;
1935     }
1936     function setBlockMinted(uint256 _tokenId, uint256 value) public onlyOwnerOrController {
1937         clovers[_tokenId].blockMinted = value;
1938     }
1939     function setCloverMoves(uint256 _tokenId, bytes28[2] moves) public onlyOwnerOrController {
1940         clovers[_tokenId].cloverMoves = moves;
1941     }
1942     function setReward(uint256 _tokenId, uint256 _amount) public onlyOwnerOrController {
1943         clovers[_tokenId].rewards = _amount;
1944     }
1945     function setSymmetries(uint256 _tokenId, uint256 _symmetries) public onlyOwnerOrController {
1946         clovers[_tokenId].symmetries = _symmetries;
1947     }
1948 
1949     /**
1950     * @dev Sets total tallies of symmetry counts. For use by the controller to correct for invalid Clovers.
1951     * @param _totalSymmetries The total number of Symmetries.
1952     * @param RotSym The total number of RotSym Symmetries.
1953     * @param Y0Sym The total number of Y0Sym Symmetries.
1954     * @param X0Sym The total number of X0Sym Symmetries.
1955     * @param XYSym The total number of XYSym Symmetries.
1956     * @param XnYSym The total number of XnYSym Symmetries.
1957     */
1958     function setAllSymmetries(uint256 _totalSymmetries, uint256 RotSym, uint256 Y0Sym, uint256 X0Sym, uint256 XYSym, uint256 XnYSym) public onlyOwnerOrController {
1959         totalSymmetries = _totalSymmetries;
1960         symmetries[0] = RotSym;
1961         symmetries[1] = Y0Sym;
1962         symmetries[2] = X0Sym;
1963         symmetries[3] = XYSym;
1964         symmetries[4] = XnYSym;
1965     }
1966 
1967     /**
1968     * @dev Deletes data about a Clover.
1969     * @param _tokenId The Id of the clover token to be deleted.
1970     */
1971     function deleteClover(uint256 _tokenId) public onlyOwnerOrController {
1972         delete(clovers[_tokenId]);
1973         unmint(_tokenId);
1974     }
1975     /**
1976     * @dev Updates the CloversController contract address and approves that contract to manage the Clovers owned by the Clovers contract.
1977     * @param _cloversController The address of the new contract.
1978     */
1979     function updateCloversControllerAddress(address _cloversController) public onlyOwner {
1980         require(_cloversController != 0);
1981         cloversController = _cloversController;
1982     }
1983 
1984 
1985 
1986     /**
1987     * @dev Updates the CloversMetadata contract address.
1988     * @param _cloversMetadata The address of the new contract.
1989     */
1990     function updateCloversMetadataAddress(address _cloversMetadata) public onlyOwner {
1991         require(_cloversMetadata != 0);
1992         cloversMetadata = _cloversMetadata;
1993     }
1994 
1995     function updateClubTokenController(address _clubTokenController) public onlyOwner {
1996         require(_clubTokenController != 0);
1997         clubTokenController = _clubTokenController;
1998     }
1999 
2000     /**
2001     * @dev Mints new Clovers.
2002     * @param _to The address of the new clover owner.
2003     * @param _tokenId The Id of the new clover token.
2004     */
2005     function mint (address _to, uint256 _tokenId) public onlyOwnerOrController {
2006         super._mint(_to, _tokenId);
2007         setApprovalForAll(clubTokenController, true);
2008     }
2009 
2010 
2011     function mintMany(address[] _tos, uint256[] _tokenIds, bytes28[2][] memory _movess, uint256[] _symmetries) public onlyAdmin {
2012         require(_tos.length == _tokenIds.length && _tokenIds.length == _movess.length && _movess.length == _symmetries.length);
2013         for (uint256 i = 0; i < _tos.length; i++) {
2014             address _to = _tos[i];
2015             uint256 _tokenId = _tokenIds[i];
2016             bytes28[2] memory _moves = _movess[i];
2017             uint256 _symmetry = _symmetries[i];
2018             setCloverMoves(_tokenId, _moves);
2019             if (_symmetry > 0) {
2020                 setSymmetries(_tokenId, _symmetry);
2021             }
2022             super._mint(_to, _tokenId);
2023             setApprovalForAll(clubTokenController, true);
2024         }
2025     }
2026 
2027     /**
2028     * @dev Unmints Clovers.
2029     * @param _tokenId The Id of the clover token to be destroyed.
2030     */
2031     function unmint (uint256 _tokenId) public onlyOwnerOrController {
2032         super._burn(ownerOf(_tokenId), _tokenId);
2033     }
2034 
2035 
2036 }