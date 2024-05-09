1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 
281 /**
282  * @title DetailedERC20 token
283  * @dev The decimals are only for visualization purposes.
284  * All the operations are done using the smallest and indivisible token unit,
285  * just as on Ethereum all the operations are done in wei.
286  */
287 contract DetailedERC20 is ERC20 {
288   string public name;
289   string public symbol;
290   uint8 public decimals;
291 
292   constructor(string _name, string _symbol, uint8 _decimals) public {
293     name = _name;
294     symbol = _symbol;
295     decimals = _decimals;
296   }
297 }
298 
299 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
300 
301 pragma solidity ^0.4.24;
302 
303 
304 /**
305  * @title Ownable
306  * @dev The Ownable contract has an owner address, and provides basic authorization control
307  * functions, this simplifies the implementation of "user permissions".
308  */
309 contract Ownable {
310   address public owner;
311 
312 
313   event OwnershipRenounced(address indexed previousOwner);
314   event OwnershipTransferred(
315     address indexed previousOwner,
316     address indexed newOwner
317   );
318 
319 
320   /**
321    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
322    * account.
323    */
324   constructor() public {
325     owner = msg.sender;
326   }
327 
328   /**
329    * @dev Throws if called by any account other than the owner.
330    */
331   modifier onlyOwner() {
332     require(msg.sender == owner);
333     _;
334   }
335 
336   /**
337    * @dev Allows the current owner to relinquish control of the contract.
338    * @notice Renouncing to ownership will leave the contract without an owner.
339    * It will not be possible to call the functions with the `onlyOwner`
340    * modifier anymore.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
367 
368 pragma solidity ^0.4.24;
369 
370 
371 /**
372  * @title ERC165
373  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
374  */
375 interface ERC165 {
376 
377   /**
378    * @notice Query if a contract implements an interface
379    * @param _interfaceId The interface identifier, as specified in ERC-165
380    * @dev Interface identification is specified in ERC-165. This function
381    * uses less than 30,000 gas.
382    */
383   function supportsInterface(bytes4 _interfaceId)
384     external
385     view
386     returns (bool);
387 }
388 
389 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
390 
391 pragma solidity ^0.4.24;
392 
393 
394 
395 /**
396  * @title ERC721 Non-Fungible Token Standard basic interface
397  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
398  */
399 contract ERC721Basic is ERC165 {
400   event Transfer(
401     address indexed _from,
402     address indexed _to,
403     uint256 indexed _tokenId
404   );
405   event Approval(
406     address indexed _owner,
407     address indexed _approved,
408     uint256 indexed _tokenId
409   );
410   event ApprovalForAll(
411     address indexed _owner,
412     address indexed _operator,
413     bool _approved
414   );
415 
416   function balanceOf(address _owner) public view returns (uint256 _balance);
417   function ownerOf(uint256 _tokenId) public view returns (address _owner);
418   function exists(uint256 _tokenId) public view returns (bool _exists);
419 
420   function approve(address _to, uint256 _tokenId) public;
421   function getApproved(uint256 _tokenId)
422     public view returns (address _operator);
423 
424   function setApprovalForAll(address _operator, bool _approved) public;
425   function isApprovedForAll(address _owner, address _operator)
426     public view returns (bool);
427 
428   function transferFrom(address _from, address _to, uint256 _tokenId) public;
429   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
430     public;
431 
432   function safeTransferFrom(
433     address _from,
434     address _to,
435     uint256 _tokenId,
436     bytes _data
437   )
438     public;
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
442 
443 pragma solidity ^0.4.24;
444 
445 
446 
447 /**
448  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
449  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
450  */
451 contract ERC721Enumerable is ERC721Basic {
452   function totalSupply() public view returns (uint256);
453   function tokenOfOwnerByIndex(
454     address _owner,
455     uint256 _index
456   )
457     public
458     view
459     returns (uint256 _tokenId);
460 
461   function tokenByIndex(uint256 _index) public view returns (uint256);
462 }
463 
464 
465 /**
466  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
467  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
468  */
469 contract ERC721Metadata is ERC721Basic {
470   function name() external view returns (string _name);
471   function symbol() external view returns (string _symbol);
472   function tokenURI(uint256 _tokenId) public view returns (string);
473 }
474 
475 
476 /**
477  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
478  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
479  */
480 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
481 }
482 
483 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
484 
485 pragma solidity ^0.4.24;
486 
487 
488 /**
489  * @title ERC721 token receiver interface
490  * @dev Interface for any contract that wants to support safeTransfers
491  * from ERC721 asset contracts.
492  */
493 contract ERC721Receiver {
494   /**
495    * @dev Magic value to be returned upon successful reception of an NFT
496    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
497    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
498    */
499   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
500 
501   /**
502    * @notice Handle the receipt of an NFT
503    * @dev The ERC721 smart contract calls this function on the recipient
504    * after a `safetransfer`. This function MAY throw to revert and reject the
505    * transfer. Return of other than the magic value MUST result in the 
506    * transaction being reverted.
507    * Note: the contract address is always the message sender.
508    * @param _operator The address which called `safeTransferFrom` function
509    * @param _from The address which previously owned the token
510    * @param _tokenId The NFT identifier which is being transfered
511    * @param _data Additional data with no specified format
512    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
513    */
514   function onERC721Received(
515     address _operator,
516     address _from,
517     uint256 _tokenId,
518     bytes _data
519   )
520     public
521     returns(bytes4);
522 }
523 
524 // File: openzeppelin-solidity/contracts/AddressUtils.sol
525 
526 pragma solidity ^0.4.24;
527 
528 
529 /**
530  * Utility library of inline functions on addresses
531  */
532 library AddressUtils {
533 
534   /**
535    * Returns whether the target address is a contract
536    * @dev This function will return false if invoked during the constructor of a contract,
537    * as the code is not actually created until after the constructor finishes.
538    * @param addr address to check
539    * @return whether the target address is a contract
540    */
541   function isContract(address addr) internal view returns (bool) {
542     uint256 size;
543     // XXX Currently there is no better way to check if there is a contract in an address
544     // than to check the size of the code at that address.
545     // See https://ethereum.stackexchange.com/a/14016/36603
546     // for more details about how this works.
547     // TODO Check this again before the Serenity release, because all addresses will be
548     // contracts then.
549     // solium-disable-next-line security/no-inline-assembly
550     assembly { size := extcodesize(addr) }
551     return size > 0;
552   }
553 
554 }
555 
556 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
557 
558 pragma solidity ^0.4.24;
559 
560 
561 
562 /**
563  * @title SupportsInterfaceWithLookup
564  * @author Matt Condon (@shrugs)
565  * @dev Implements ERC165 using a lookup table.
566  */
567 contract SupportsInterfaceWithLookup is ERC165 {
568   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
569   /**
570    * 0x01ffc9a7 ===
571    *   bytes4(keccak256('supportsInterface(bytes4)'))
572    */
573 
574   /**
575    * @dev a mapping of interface id to whether or not it's supported
576    */
577   mapping(bytes4 => bool) internal supportedInterfaces;
578 
579   /**
580    * @dev A contract implementing SupportsInterfaceWithLookup
581    * implement ERC165 itself
582    */
583   constructor()
584     public
585   {
586     _registerInterface(InterfaceId_ERC165);
587   }
588 
589   /**
590    * @dev implement supportsInterface(bytes4) using a lookup table
591    */
592   function supportsInterface(bytes4 _interfaceId)
593     external
594     view
595     returns (bool)
596   {
597     return supportedInterfaces[_interfaceId];
598   }
599 
600   /**
601    * @dev private method for registering an interface
602    */
603   function _registerInterface(bytes4 _interfaceId)
604     internal
605   {
606     require(_interfaceId != 0xffffffff);
607     supportedInterfaces[_interfaceId] = true;
608   }
609 }
610 
611 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
612 
613 pragma solidity ^0.4.24;
614 
615 
616 
617 
618 
619 
620 
621 /**
622  * @title ERC721 Non-Fungible Token Standard basic implementation
623  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
624  */
625 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
626 
627   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
628   /*
629    * 0x80ac58cd ===
630    *   bytes4(keccak256('balanceOf(address)')) ^
631    *   bytes4(keccak256('ownerOf(uint256)')) ^
632    *   bytes4(keccak256('approve(address,uint256)')) ^
633    *   bytes4(keccak256('getApproved(uint256)')) ^
634    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
635    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
636    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
637    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
638    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
639    */
640 
641   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
642   /*
643    * 0x4f558e79 ===
644    *   bytes4(keccak256('exists(uint256)'))
645    */
646 
647   using SafeMath for uint256;
648   using AddressUtils for address;
649 
650   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
651   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
652   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
653 
654   // Mapping from token ID to owner
655   mapping (uint256 => address) internal tokenOwner;
656 
657   // Mapping from token ID to approved address
658   mapping (uint256 => address) internal tokenApprovals;
659 
660   // Mapping from owner to number of owned token
661   mapping (address => uint256) internal ownedTokensCount;
662 
663   // Mapping from owner to operator approvals
664   mapping (address => mapping (address => bool)) internal operatorApprovals;
665 
666   /**
667    * @dev Guarantees msg.sender is owner of the given token
668    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
669    */
670   modifier onlyOwnerOf(uint256 _tokenId) {
671     require(ownerOf(_tokenId) == msg.sender);
672     _;
673   }
674 
675   /**
676    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
677    * @param _tokenId uint256 ID of the token to validate
678    */
679   modifier canTransfer(uint256 _tokenId) {
680     require(isApprovedOrOwner(msg.sender, _tokenId));
681     _;
682   }
683 
684   constructor()
685     public
686   {
687     // register the supported interfaces to conform to ERC721 via ERC165
688     _registerInterface(InterfaceId_ERC721);
689     _registerInterface(InterfaceId_ERC721Exists);
690   }
691 
692   /**
693    * @dev Gets the balance of the specified address
694    * @param _owner address to query the balance of
695    * @return uint256 representing the amount owned by the passed address
696    */
697   function balanceOf(address _owner) public view returns (uint256) {
698     require(_owner != address(0));
699     return ownedTokensCount[_owner];
700   }
701 
702   /**
703    * @dev Gets the owner of the specified token ID
704    * @param _tokenId uint256 ID of the token to query the owner of
705    * @return owner address currently marked as the owner of the given token ID
706    */
707   function ownerOf(uint256 _tokenId) public view returns (address) {
708     address owner = tokenOwner[_tokenId];
709     require(owner != address(0));
710     return owner;
711   }
712 
713   /**
714    * @dev Returns whether the specified token exists
715    * @param _tokenId uint256 ID of the token to query the existence of
716    * @return whether the token exists
717    */
718   function exists(uint256 _tokenId) public view returns (bool) {
719     address owner = tokenOwner[_tokenId];
720     return owner != address(0);
721   }
722 
723   /**
724    * @dev Approves another address to transfer the given token ID
725    * The zero address indicates there is no approved address.
726    * There can only be one approved address per token at a given time.
727    * Can only be called by the token owner or an approved operator.
728    * @param _to address to be approved for the given token ID
729    * @param _tokenId uint256 ID of the token to be approved
730    */
731   function approve(address _to, uint256 _tokenId) public {
732     address owner = ownerOf(_tokenId);
733     require(_to != owner);
734     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
735 
736     tokenApprovals[_tokenId] = _to;
737     emit Approval(owner, _to, _tokenId);
738   }
739 
740   /**
741    * @dev Gets the approved address for a token ID, or zero if no address set
742    * @param _tokenId uint256 ID of the token to query the approval of
743    * @return address currently approved for the given token ID
744    */
745   function getApproved(uint256 _tokenId) public view returns (address) {
746     return tokenApprovals[_tokenId];
747   }
748 
749   /**
750    * @dev Sets or unsets the approval of a given operator
751    * An operator is allowed to transfer all tokens of the sender on their behalf
752    * @param _to operator address to set the approval
753    * @param _approved representing the status of the approval to be set
754    */
755   function setApprovalForAll(address _to, bool _approved) public {
756     require(_to != msg.sender);
757     operatorApprovals[msg.sender][_to] = _approved;
758     emit ApprovalForAll(msg.sender, _to, _approved);
759   }
760 
761   /**
762    * @dev Tells whether an operator is approved by a given owner
763    * @param _owner owner address which you want to query the approval of
764    * @param _operator operator address which you want to query the approval of
765    * @return bool whether the given operator is approved by the given owner
766    */
767   function isApprovedForAll(
768     address _owner,
769     address _operator
770   )
771     public
772     view
773     returns (bool)
774   {
775     return operatorApprovals[_owner][_operator];
776   }
777 
778   /**
779    * @dev Transfers the ownership of a given token ID to another address
780    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
781    * Requires the msg sender to be the owner, approved, or operator
782    * @param _from current owner of the token
783    * @param _to address to receive the ownership of the given token ID
784    * @param _tokenId uint256 ID of the token to be transferred
785   */
786   function transferFrom(
787     address _from,
788     address _to,
789     uint256 _tokenId
790   )
791     public
792     canTransfer(_tokenId)
793   {
794     require(_from != address(0));
795     require(_to != address(0));
796 
797     clearApproval(_from, _tokenId);
798     removeTokenFrom(_from, _tokenId);
799     addTokenTo(_to, _tokenId);
800 
801     emit Transfer(_from, _to, _tokenId);
802   }
803 
804   /**
805    * @dev Safely transfers the ownership of a given token ID to another address
806    * If the target address is a contract, it must implement `onERC721Received`,
807    * which is called upon a safe transfer, and return the magic value
808    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
809    * the transfer is reverted.
810    *
811    * Requires the msg sender to be the owner, approved, or operator
812    * @param _from current owner of the token
813    * @param _to address to receive the ownership of the given token ID
814    * @param _tokenId uint256 ID of the token to be transferred
815   */
816   function safeTransferFrom(
817     address _from,
818     address _to,
819     uint256 _tokenId
820   )
821     public
822     canTransfer(_tokenId)
823   {
824     // solium-disable-next-line arg-overflow
825     safeTransferFrom(_from, _to, _tokenId, "");
826   }
827 
828   /**
829    * @dev Safely transfers the ownership of a given token ID to another address
830    * If the target address is a contract, it must implement `onERC721Received`,
831    * which is called upon a safe transfer, and return the magic value
832    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
833    * the transfer is reverted.
834    * Requires the msg sender to be the owner, approved, or operator
835    * @param _from current owner of the token
836    * @param _to address to receive the ownership of the given token ID
837    * @param _tokenId uint256 ID of the token to be transferred
838    * @param _data bytes data to send along with a safe transfer check
839    */
840   function safeTransferFrom(
841     address _from,
842     address _to,
843     uint256 _tokenId,
844     bytes _data
845   )
846     public
847     canTransfer(_tokenId)
848   {
849     transferFrom(_from, _to, _tokenId);
850     // solium-disable-next-line arg-overflow
851     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
852   }
853 
854   /**
855    * @dev Returns whether the given spender can transfer a given token ID
856    * @param _spender address of the spender to query
857    * @param _tokenId uint256 ID of the token to be transferred
858    * @return bool whether the msg.sender is approved for the given token ID,
859    *  is an operator of the owner, or is the owner of the token
860    */
861   function isApprovedOrOwner(
862     address _spender,
863     uint256 _tokenId
864   )
865     internal
866     view
867     returns (bool)
868   {
869     address owner = ownerOf(_tokenId);
870     // Disable solium check because of
871     // https://github.com/duaraghav8/Solium/issues/175
872     // solium-disable-next-line operator-whitespace
873     return (
874       _spender == owner ||
875       getApproved(_tokenId) == _spender ||
876       isApprovedForAll(owner, _spender)
877     );
878   }
879 
880   /**
881    * @dev Internal function to mint a new token
882    * Reverts if the given token ID already exists
883    * @param _to The address that will own the minted token
884    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
885    */
886   function _mint(address _to, uint256 _tokenId) internal {
887     require(_to != address(0));
888     addTokenTo(_to, _tokenId);
889     emit Transfer(address(0), _to, _tokenId);
890   }
891 
892   /**
893    * @dev Internal function to burn a specific token
894    * Reverts if the token does not exist
895    * @param _tokenId uint256 ID of the token being burned by the msg.sender
896    */
897   function _burn(address _owner, uint256 _tokenId) internal {
898     clearApproval(_owner, _tokenId);
899     removeTokenFrom(_owner, _tokenId);
900     emit Transfer(_owner, address(0), _tokenId);
901   }
902 
903   /**
904    * @dev Internal function to clear current approval of a given token ID
905    * Reverts if the given address is not indeed the owner of the token
906    * @param _owner owner of the token
907    * @param _tokenId uint256 ID of the token to be transferred
908    */
909   function clearApproval(address _owner, uint256 _tokenId) internal {
910     require(ownerOf(_tokenId) == _owner);
911     if (tokenApprovals[_tokenId] != address(0)) {
912       tokenApprovals[_tokenId] = address(0);
913     }
914   }
915 
916   /**
917    * @dev Internal function to add a token ID to the list of a given address
918    * @param _to address representing the new owner of the given token ID
919    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
920    */
921   function addTokenTo(address _to, uint256 _tokenId) internal {
922     require(tokenOwner[_tokenId] == address(0));
923     tokenOwner[_tokenId] = _to;
924     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
925   }
926 
927   /**
928    * @dev Internal function to remove a token ID from the list of a given address
929    * @param _from address representing the previous owner of the given token ID
930    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
931    */
932   function removeTokenFrom(address _from, uint256 _tokenId) internal {
933     require(ownerOf(_tokenId) == _from);
934     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
935     tokenOwner[_tokenId] = address(0);
936   }
937 
938   /**
939    * @dev Internal function to invoke `onERC721Received` on a target address
940    * The call is not executed if the target address is not a contract
941    * @param _from address representing the previous owner of the given token ID
942    * @param _to target address that will receive the tokens
943    * @param _tokenId uint256 ID of the token to be transferred
944    * @param _data bytes optional data to send along with the call
945    * @return whether the call correctly returned the expected magic value
946    */
947   function checkAndCallSafeTransfer(
948     address _from,
949     address _to,
950     uint256 _tokenId,
951     bytes _data
952   )
953     internal
954     returns (bool)
955   {
956     if (!_to.isContract()) {
957       return true;
958     }
959     bytes4 retval = ERC721Receiver(_to).onERC721Received(
960       msg.sender, _from, _tokenId, _data);
961     return (retval == ERC721_RECEIVED);
962   }
963 }
964 
965 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
966 
967 pragma solidity ^0.4.24;
968 
969 
970 
971 
972 
973 /**
974  * @title Full ERC721 Token
975  * This implementation includes all the required and some optional functionality of the ERC721 standard
976  * Moreover, it includes approve all functionality using operator terminology
977  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
978  */
979 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
980 
981   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
982   /**
983    * 0x780e9d63 ===
984    *   bytes4(keccak256('totalSupply()')) ^
985    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
986    *   bytes4(keccak256('tokenByIndex(uint256)'))
987    */
988 
989   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
990   /**
991    * 0x5b5e139f ===
992    *   bytes4(keccak256('name()')) ^
993    *   bytes4(keccak256('symbol()')) ^
994    *   bytes4(keccak256('tokenURI(uint256)'))
995    */
996 
997   // Token name
998   string internal name_;
999 
1000   // Token symbol
1001   string internal symbol_;
1002 
1003   // Mapping from owner to list of owned token IDs
1004   mapping(address => uint256[]) internal ownedTokens;
1005 
1006   // Mapping from token ID to index of the owner tokens list
1007   mapping(uint256 => uint256) internal ownedTokensIndex;
1008 
1009   // Array with all token ids, used for enumeration
1010   uint256[] internal allTokens;
1011 
1012   // Mapping from token id to position in the allTokens array
1013   mapping(uint256 => uint256) internal allTokensIndex;
1014 
1015   // Optional mapping for token URIs
1016   mapping(uint256 => string) internal tokenURIs;
1017 
1018   /**
1019    * @dev Constructor function
1020    */
1021   constructor(string _name, string _symbol) public {
1022     name_ = _name;
1023     symbol_ = _symbol;
1024 
1025     // register the supported interfaces to conform to ERC721 via ERC165
1026     _registerInterface(InterfaceId_ERC721Enumerable);
1027     _registerInterface(InterfaceId_ERC721Metadata);
1028   }
1029 
1030   /**
1031    * @dev Gets the token name
1032    * @return string representing the token name
1033    */
1034   function name() external view returns (string) {
1035     return name_;
1036   }
1037 
1038   /**
1039    * @dev Gets the token symbol
1040    * @return string representing the token symbol
1041    */
1042   function symbol() external view returns (string) {
1043     return symbol_;
1044   }
1045 
1046   /**
1047    * @dev Returns an URI for a given token ID
1048    * Throws if the token ID does not exist. May return an empty string.
1049    * @param _tokenId uint256 ID of the token to query
1050    */
1051   function tokenURI(uint256 _tokenId) public view returns (string) {
1052     require(exists(_tokenId));
1053     return tokenURIs[_tokenId];
1054   }
1055 
1056   /**
1057    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1058    * @param _owner address owning the tokens list to be accessed
1059    * @param _index uint256 representing the index to be accessed of the requested tokens list
1060    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1061    */
1062   function tokenOfOwnerByIndex(
1063     address _owner,
1064     uint256 _index
1065   )
1066     public
1067     view
1068     returns (uint256)
1069   {
1070     require(_index < balanceOf(_owner));
1071     return ownedTokens[_owner][_index];
1072   }
1073 
1074   /**
1075    * @dev Gets the total amount of tokens stored by the contract
1076    * @return uint256 representing the total amount of tokens
1077    */
1078   function totalSupply() public view returns (uint256) {
1079     return allTokens.length;
1080   }
1081 
1082   /**
1083    * @dev Gets the token ID at a given index of all the tokens in this contract
1084    * Reverts if the index is greater or equal to the total number of tokens
1085    * @param _index uint256 representing the index to be accessed of the tokens list
1086    * @return uint256 token ID at the given index of the tokens list
1087    */
1088   function tokenByIndex(uint256 _index) public view returns (uint256) {
1089     require(_index < totalSupply());
1090     return allTokens[_index];
1091   }
1092 
1093   /**
1094    * @dev Internal function to set the token URI for a given token
1095    * Reverts if the token ID does not exist
1096    * @param _tokenId uint256 ID of the token to set its URI
1097    * @param _uri string URI to assign
1098    */
1099   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1100     require(exists(_tokenId));
1101     tokenURIs[_tokenId] = _uri;
1102   }
1103 
1104   /**
1105    * @dev Internal function to add a token ID to the list of a given address
1106    * @param _to address representing the new owner of the given token ID
1107    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1108    */
1109   function addTokenTo(address _to, uint256 _tokenId) internal {
1110     super.addTokenTo(_to, _tokenId);
1111     uint256 length = ownedTokens[_to].length;
1112     ownedTokens[_to].push(_tokenId);
1113     ownedTokensIndex[_tokenId] = length;
1114   }
1115 
1116   /**
1117    * @dev Internal function to remove a token ID from the list of a given address
1118    * @param _from address representing the previous owner of the given token ID
1119    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1120    */
1121   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1122     super.removeTokenFrom(_from, _tokenId);
1123 
1124     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1125     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1126     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1127 
1128     ownedTokens[_from][tokenIndex] = lastToken;
1129     ownedTokens[_from][lastTokenIndex] = 0;
1130     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1131     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1132     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1133 
1134     ownedTokens[_from].length--;
1135     ownedTokensIndex[_tokenId] = 0;
1136     ownedTokensIndex[lastToken] = tokenIndex;
1137   }
1138 
1139   /**
1140    * @dev Internal function to mint a new token
1141    * Reverts if the given token ID already exists
1142    * @param _to address the beneficiary that will own the minted token
1143    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1144    */
1145   function _mint(address _to, uint256 _tokenId) internal {
1146     super._mint(_to, _tokenId);
1147 
1148     allTokensIndex[_tokenId] = allTokens.length;
1149     allTokens.push(_tokenId);
1150   }
1151 
1152   /**
1153    * @dev Internal function to burn a specific token
1154    * Reverts if the token does not exist
1155    * @param _owner owner of the token to burn
1156    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1157    */
1158   function _burn(address _owner, uint256 _tokenId) internal {
1159     super._burn(_owner, _tokenId);
1160 
1161     // Clear metadata (if any)
1162     if (bytes(tokenURIs[_tokenId]).length != 0) {
1163       delete tokenURIs[_tokenId];
1164     }
1165 
1166     // Reorg all tokens array
1167     uint256 tokenIndex = allTokensIndex[_tokenId];
1168     uint256 lastTokenIndex = allTokens.length.sub(1);
1169     uint256 lastToken = allTokens[lastTokenIndex];
1170 
1171     allTokens[tokenIndex] = lastToken;
1172     allTokens[lastTokenIndex] = 0;
1173 
1174     allTokens.length--;
1175     allTokensIndex[_tokenId] = 0;
1176     allTokensIndex[lastToken] = tokenIndex;
1177   }
1178 
1179 }
1180 
1181 // File: contracts/LeasedEmblem.sol
1182 
1183 pragma solidity ^0.4.24;
1184 
1185 
1186 
1187 contract LeasedEmblem is  ERC721Token, Ownable {
1188 
1189 
1190   address internal leaseExchange;
1191 
1192 
1193   struct Metadata {
1194     uint256 amount;
1195     address leasor;
1196     uint256 duration;
1197     uint256 tradeExpiry;
1198     uint256 leaseExpiry;
1199     bool isMining;
1200   }
1201 
1202 
1203   mapping(uint256 => Metadata) public metadata;
1204 
1205 
1206   mapping(address => uint256[]) internal leasedTokens;
1207 
1208 
1209   mapping(uint256 => uint256) internal leasedTokensIndex;
1210 
1211 
1212   mapping (uint256 => address) internal tokenLeasor;
1213 
1214 
1215   mapping (address => uint256) internal leasedTokensCount;
1216 
1217   uint256 highestId = 1;
1218 
1219   uint256 sixMonths       = 15768000;
1220 
1221   constructor (string _name, string _symbol) public ERC721Token(_name, _symbol) {
1222   }
1223 
1224 
1225 
1226   function getNewId() public view returns(uint256) {
1227     return highestId;
1228   }
1229 
1230   function leasorOf(uint256 _tokenId) public view returns (address) {
1231     address owner = tokenLeasor[_tokenId];
1232     require(owner != address(0));
1233     return owner;
1234   }
1235 
1236   function balanceOfLeasor(address _leasor) public view returns (uint256) {
1237     require(_leasor != address(0));
1238     return leasedTokensCount[_leasor];
1239   }
1240 
1241   function tokenOfLeasorByIndex(address _leasor,uint256 _index) public view returns (uint256){
1242     require(_index < balanceOfLeasor(_leasor));
1243     return leasedTokens[_leasor][_index];
1244   }
1245 
1246   function addTokenToLeasor(address _to, uint256 _tokenId) internal {
1247     require(tokenLeasor[_tokenId] == address(0));
1248     tokenLeasor[_tokenId] = _to;
1249     leasedTokensCount[_to] = leasedTokensCount[_to].add(1);
1250     uint256 length = leasedTokens[_to].length;
1251     leasedTokens[_to].push(_tokenId);
1252     leasedTokensIndex[_tokenId] = length;
1253   }
1254 
1255   function removeTokenFromLeasor(address _from, uint256 _tokenId) internal {
1256     require(leasorOf(_tokenId) == _from);
1257     leasedTokensCount[_from] = leasedTokensCount[_from].sub(1);
1258     tokenLeasor[_tokenId] = address(0);
1259 
1260     uint256 tokenIndex = leasedTokensIndex[_tokenId];
1261     uint256 lastTokenIndex = leasedTokens[_from].length.sub(1);
1262     uint256 lastToken = leasedTokens[_from][lastTokenIndex];
1263 
1264     leasedTokens[_from][tokenIndex] = lastToken;
1265     leasedTokens[_from][lastTokenIndex] = 0;
1266     leasedTokens[_from].length--;
1267     leasedTokensIndex[_tokenId] = 0;
1268     leasedTokensIndex[lastToken] = tokenIndex;
1269   }
1270 
1271   function setLeaseExchange(address _leaseExchange) public onlyOwner {
1272     leaseExchange = _leaseExchange;
1273   }
1274 
1275   function totalAmount() external view returns (uint256) {
1276     uint256 amount = 0;
1277     for(uint256 i = 0; i < allTokens.length; i++){
1278       amount += metadata[allTokens[i]].amount;
1279     }
1280     return amount;
1281   }
1282 
1283   function setMetadata(uint256 _tokenId, uint256 amount, address leasor, uint256 duration,uint256 tradeExpiry, uint256 leaseExpiry) internal {
1284     require(exists(_tokenId));
1285     metadata[_tokenId]= Metadata(amount,leasor,duration,tradeExpiry,leaseExpiry,false);
1286   }
1287 
1288   function getMetadata(uint256 _tokenId) public view returns (uint256, address, uint256, uint256,uint256, bool) {
1289     require(exists(_tokenId));
1290     return (
1291       metadata[_tokenId].amount,
1292       metadata[_tokenId].leasor,
1293       metadata[_tokenId].duration,
1294       metadata[_tokenId].tradeExpiry,
1295       metadata[_tokenId].leaseExpiry,
1296       metadata[_tokenId].isMining
1297     );
1298   }
1299 
1300   function getAmountForUser(address owner) external view returns (uint256) {
1301     uint256 amount = 0;
1302     uint256 numTokens = balanceOf(owner);
1303 
1304     for(uint256 i = 0; i < numTokens; i++){
1305       amount += metadata[tokenOfOwnerByIndex(owner,i)].amount;
1306     }
1307     return amount;
1308   }
1309 
1310   function getAmountForUserMining(address owner) external view returns (uint256) {
1311     uint256 amount = 0;
1312     uint256 numTokens = balanceOf(owner);
1313 
1314     for(uint256 i = 0; i < numTokens; i++){
1315       if(metadata[tokenOfOwnerByIndex(owner,i)].isMining) {
1316         amount += metadata[tokenOfOwnerByIndex(owner,i)].amount;
1317       }
1318     }
1319     return amount;
1320   }
1321 
1322   function getAmount(uint256 _tokenId) public view returns (uint256) {
1323     require(exists(_tokenId));
1324     return metadata[_tokenId].amount;
1325   }
1326 
1327   function getTradeExpiry(uint256 _tokenId) public view returns (uint256) {
1328     require(exists(_tokenId));
1329     return metadata[_tokenId].tradeExpiry;
1330   }
1331 
1332   function getDuration(uint256 _tokenId) public view returns (uint256) {
1333     require(exists(_tokenId));
1334     return metadata[_tokenId].duration;
1335   }
1336 
1337   function getIsMining(uint256 _tokenId) public view returns (bool) {
1338     require(exists(_tokenId));
1339     return metadata[_tokenId].isMining;
1340   }
1341 
1342   function startMining(address _owner, uint256 _tokenId) public returns (bool) {
1343     require(msg.sender == leaseExchange);
1344     require(exists(_tokenId));
1345     require(ownerOf(_tokenId) == _owner);
1346     require(now < metadata[_tokenId].tradeExpiry);
1347     require(metadata[_tokenId].isMining == false);
1348     Metadata storage m = metadata[_tokenId];
1349     m.isMining = true;
1350     m.leaseExpiry = now + m.duration;
1351     return true;
1352   }
1353 
1354   function canRetrieveEMB(address _leasor, uint256 _tokenId) public view returns (bool) {
1355     require(exists(_tokenId));
1356     require(metadata[_tokenId].leasor == _leasor);
1357     if(metadata[_tokenId].isMining == false) {
1358       return(now > metadata[_tokenId].leaseExpiry);
1359     }
1360     else {
1361       return(now > metadata[_tokenId].tradeExpiry);
1362     }
1363   }
1364 
1365   function endLease(address _leasee, uint256 _tokenId) public {
1366     require(msg.sender == leaseExchange);
1367     require(exists(_tokenId));
1368     require(ownerOf(_tokenId) == _leasee);
1369     require(now > metadata[_tokenId].leaseExpiry);
1370     removeTokenFromLeasor(metadata[_tokenId].leasor, _tokenId);
1371     _burn(_leasee, _tokenId);
1372   }
1373 
1374   function splitLEMB(uint256 _tokenId, uint256 amount) public {
1375     require(exists(_tokenId));
1376     require(ownerOf(_tokenId) == msg.sender);
1377     require(metadata[_tokenId].isMining == false);
1378     require(now < metadata[_tokenId].tradeExpiry);
1379     require(amount < getAmount(_tokenId));
1380 
1381     uint256 _newTokenId = getNewId();
1382 
1383     Metadata storage m = metadata[_tokenId];
1384     m.amount = m.amount - amount;
1385 
1386     _mint(msg.sender, _newTokenId);
1387     addTokenToLeasor(m.leasor, _newTokenId);
1388     setMetadata(_newTokenId, amount, m.leasor, m.duration,m.tradeExpiry, 0);
1389     highestId = highestId + 1;
1390   }
1391 
1392   function mintUniqueTokenTo(address _to, uint256 amount, address leasor, uint256 duration) public {
1393     require(msg.sender == leaseExchange);
1394     uint256 _tokenId = getNewId();
1395     _mint(_to, _tokenId);
1396     addTokenToLeasor(leasor, _tokenId);
1397     uint256 tradeExpiry = now + sixMonths;
1398     setMetadata(_tokenId, amount, leasor, duration,tradeExpiry, 0);
1399     highestId = highestId + 1;
1400   }
1401 
1402   function _burn(address _owner, uint256 _tokenId) internal {
1403     super._burn(_owner, _tokenId);
1404     delete metadata[_tokenId];
1405   }
1406 
1407   modifier canTransfer(uint256 _tokenId) {
1408     require(isApprovedOrOwner(msg.sender, _tokenId));
1409     require(metadata[_tokenId].isMining == false);
1410     _;
1411   }
1412 
1413 }
1414 
1415 // File: contracts/Emblem.sol
1416 
1417 pragma solidity ^0.4.24;
1418 
1419 
1420 
1421 
1422 
1423 
1424 contract Emblem is DetailedERC20, StandardToken, Ownable {
1425   using SafeMath for uint256;
1426 
1427    mapping (bytes12 => address) public vanityAddresses;
1428    mapping (address => bytes12[]) public ownedVanities;
1429    mapping (address => mapping(bytes12 => uint256)) public ownedVanitiesIndex;
1430    mapping (bytes12 => uint256) allVanitiesIndex;
1431    bytes12[] public allVanities;
1432    mapping (address => mapping (bytes12 => address)) internal allowedVanities;
1433 
1434    mapping (bytes12 => uint256) vanityFees;
1435    mapping (bytes12 => bool) vanityFeeEnabled;
1436 
1437    bool internal useVanityFees = true;
1438    uint256 internal vanityPurchaseCost = 100 * (10 ** 8);
1439 
1440    mapping (address => bool) public frozenAccounts;
1441    bool public completeFreeze = false;
1442 
1443    mapping (address => bool) internal freezable;
1444    mapping (address => bool) internal externalFreezers;
1445 
1446    address leaseExchange;
1447    LeasedEmblem LEMB;
1448 
1449    event TransferVanity(address from, address to, bytes12 vanity);
1450    event ApprovedVanity(address from, address to, bytes12 vanity);
1451    event VanityPurchased(address from, bytes12 vanity);
1452 
1453    constructor(string _name, string _ticker, uint8 _decimal, uint256 _supply, address _wallet, address _lemb) DetailedERC20(_name, _ticker, _decimal) public {
1454      totalSupply_ = _supply;
1455      balances[_wallet] = _supply;
1456      LEMB = LeasedEmblem(_lemb);
1457    }
1458 
1459    function setLeaseExchange(address _leaseExchange) public onlyOwner {
1460      leaseExchange = _leaseExchange;
1461    }
1462 
1463    function setVanityPurchaseCost(uint256 cost) public onlyOwner {
1464      vanityPurchaseCost = cost;
1465    }
1466 
1467    function enableFees(bool enabled) public onlyOwner {
1468      useVanityFees = enabled;
1469    }
1470 
1471    function setLEMB(address _lemb) public onlyOwner {
1472      LEMB = LeasedEmblem(_lemb);
1473    }
1474 
1475    function setVanityFee(bytes12 vanity, uint256 fee) public onlyOwner {
1476      require(fee >= 0);
1477      vanityFees[vanity] = fee;
1478    }
1479 
1480    function getFee(bytes12 vanity) public view returns(uint256) {
1481      return vanityFees[vanity];
1482    }
1483 
1484    function enabledVanityFee(bytes12 vanity) public view returns(bool) {
1485      return vanityFeeEnabled[vanity] && useVanityFees;
1486    }
1487 
1488    function setTicker(string _ticker) public onlyOwner {
1489      symbol = _ticker;
1490    }
1491 
1492    function approveOwner(uint256 _value) public onlyOwner returns (bool) {
1493      allowed[msg.sender][address(this)] = _value;
1494      return true;
1495    }
1496 
1497    function vanityAllowance(address _owner, bytes12 _vanity, address _spender) public view returns (bool) {
1498      return allowedVanities[_owner][_vanity] == _spender;
1499    }
1500 
1501    function getVanityOwner(bytes12 _vanity) public view returns (address) {
1502      return vanityAddresses[_vanity];
1503    }
1504 
1505    function getAllVanities() public view returns (bytes12[]){
1506      return allVanities;
1507    }
1508 
1509    function getMyVanities() public view returns (bytes12[]){
1510      return ownedVanities[msg.sender];
1511    }
1512 
1513    function approveVanity(address _spender, bytes12 _vanity) public returns (bool) {
1514      require(vanityAddresses[_vanity] == msg.sender);
1515      allowedVanities[msg.sender][_vanity] = _spender;
1516 
1517      emit ApprovedVanity(msg.sender, _spender, _vanity);
1518      return true;
1519    }
1520 
1521    function clearVanityApproval(bytes12 _vanity) public returns (bool){
1522      require(vanityAddresses[_vanity] == msg.sender);
1523      delete allowedVanities[msg.sender][_vanity];
1524      return true;
1525    }
1526 
1527    function transferVanity(bytes12 van, address newOwner) public returns (bool) {
1528      require(newOwner != 0x0);
1529      require(vanityAddresses[van] == msg.sender);
1530 
1531      vanityAddresses[van] = newOwner;
1532      ownedVanities[newOwner].push(van);
1533      ownedVanitiesIndex[newOwner][van] = ownedVanities[newOwner].length.sub(1);
1534 
1535      uint256 vanityIndex = ownedVanitiesIndex[msg.sender][van];
1536      uint256 lastVanityIndex = ownedVanities[msg.sender].length.sub(1);
1537      bytes12 lastVanity = ownedVanities[msg.sender][lastVanityIndex];
1538 
1539      ownedVanities[msg.sender][vanityIndex] = lastVanity;
1540      ownedVanities[msg.sender][lastVanityIndex] = "";
1541      ownedVanities[msg.sender].length--;
1542 
1543      ownedVanitiesIndex[msg.sender][van] = 0;
1544      ownedVanitiesIndex[msg.sender][lastVanity] = vanityIndex;
1545 
1546      emit TransferVanity(msg.sender, newOwner,van);
1547 
1548      return true;
1549    }
1550 
1551    function transferVanityFrom(
1552      address _from,
1553      address _to,
1554      bytes12 _vanity
1555    )
1556      public
1557      returns (bool)
1558    {
1559      require(_to != address(0));
1560      require(_from == vanityAddresses[_vanity]);
1561      require(msg.sender == allowedVanities[_from][_vanity]);
1562 
1563      vanityAddresses[_vanity] = _to;
1564      ownedVanities[_to].push(_vanity);
1565      ownedVanitiesIndex[_to][_vanity] = ownedVanities[_to].length.sub(1);
1566 
1567      uint256 vanityIndex = ownedVanitiesIndex[_from][_vanity];
1568      uint256 lastVanityIndex = ownedVanities[_from].length.sub(1);
1569      bytes12 lastVanity = ownedVanities[_from][lastVanityIndex];
1570 
1571      ownedVanities[_from][vanityIndex] = lastVanity;
1572      ownedVanities[_from][lastVanityIndex] = "";
1573      ownedVanities[_from].length--;
1574 
1575      ownedVanitiesIndex[_from][_vanity] = 0;
1576      ownedVanitiesIndex[_from][lastVanity] = vanityIndex;
1577 
1578      emit TransferVanity(msg.sender, _to,_vanity);
1579 
1580      return true;
1581    }
1582 
1583    function purchaseVanity(bytes12 van) public returns (bool) {
1584      require(vanityAddresses[van] == address(0));
1585 
1586      for(uint8 i = 0; i < 12; i++){
1587        require((van[i] >= 48 && van[i] <= 57) || (van[i] >= 65 && van[i] <= 90));
1588      }
1589 
1590      require(canTransfer(msg.sender,vanityPurchaseCost));
1591 
1592      balances[msg.sender] = balances[msg.sender].sub(vanityPurchaseCost);
1593      balances[address(this)] = balances[address(this)].add(vanityPurchaseCost);
1594      emit Transfer(msg.sender, address(this), vanityPurchaseCost);
1595 
1596      vanityAddresses[van] = msg.sender;
1597      ownedVanities[msg.sender].push(van);
1598      ownedVanitiesIndex[msg.sender][van] = ownedVanities[msg.sender].length.sub(1);
1599      allVanities.push(van);
1600      allVanitiesIndex[van] = allVanities.length.sub(1);
1601 
1602      emit VanityPurchased(msg.sender, van);
1603    }
1604 
1605    function freezeTransfers(bool _freeze) public onlyOwner {
1606      completeFreeze = _freeze;
1607    }
1608 
1609    function freezeAccount(address _target, bool _freeze) public onlyOwner {
1610      frozenAccounts[_target] = _freeze;
1611    }
1612 
1613    function canTransfer(address _account,uint256 _value) internal view returns (bool) {
1614       return (!frozenAccounts[_account] && !completeFreeze && (_value + LEMB.getAmountForUserMining(_account) <= balances[_account]));
1615    }
1616 
1617    function transfer(address _to, uint256 _value) public returns (bool){
1618       require(canTransfer(msg.sender,_value));
1619       super.transfer(_to,_value);
1620    }
1621 
1622 
1623    function multiTransfer(bytes32[] _addressesAndAmounts) public {
1624       for (uint i = 0; i < _addressesAndAmounts.length; i++) {
1625           address to = address(_addressesAndAmounts[i] >> 96);
1626           uint amount = uint(uint56(_addressesAndAmounts[i]));
1627           transfer(to, amount);
1628       }
1629    }
1630 
1631    function freezeMe(bool freeze) public {
1632      require(!frozenAccounts[msg.sender]);
1633      freezable[msg.sender] = freeze;
1634    }
1635 
1636    function canFreeze(address _target) public view returns(bool){
1637      return freezable[_target];
1638    }
1639 
1640    function isFrozen(address _target) public view returns(bool) {
1641      return completeFreeze || frozenAccounts[_target];
1642    }
1643 
1644    function externalFreezeAccount(address _target, bool _freeze) public {
1645      require(freezable[_target]);
1646      require(externalFreezers[msg.sender]);
1647      frozenAccounts[_target] = _freeze;
1648    }
1649 
1650    function setExternalFreezer(address _target, bool _canFreeze) public onlyOwner {
1651      externalFreezers[_target] = _canFreeze;
1652    }
1653 
1654 
1655    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
1656       require(!completeFreeze);
1657       if(msg.sender != leaseExchange) require(canTransfer(_from,_value));
1658       super.transferFrom(_from,_to,_value);
1659    }
1660 
1661    function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool) {
1662 
1663 
1664      if(_spender == leaseExchange) {
1665        require(allowed[msg.sender][_spender].sub(_subtractedValue) >= LEMB.getAmountForUserMining(msg.sender));
1666      }
1667      super.decreaseApproval(_spender,_subtractedValue);
1668    }
1669 
1670    function approve(address _spender, uint256 _value) public returns (bool) {
1671 
1672 
1673      if(_spender == leaseExchange){
1674        require(_value >= LEMB.getAmountForUserMining(msg.sender));
1675      }
1676 
1677      allowed[msg.sender][_spender] = _value;
1678      emit Approval(msg.sender, _spender, _value);
1679      return true;
1680    }
1681 
1682 }