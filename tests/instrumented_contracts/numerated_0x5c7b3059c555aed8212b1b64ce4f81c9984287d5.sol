1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: contracts/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: contracts/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: contracts/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: contracts/ERC721/ERC165.sol
258 
259 /**
260  * @title ERC165
261  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
262  */
263 interface ERC165 {
264 
265   /**
266    * @notice Query if a contract implements an interface
267    * @param _interfaceId The interface identifier, as specified in ERC-165
268    * @dev Interface identification is specified in ERC-165. This function
269    * uses less than 30,000 gas.
270    */
271   function supportsInterface(bytes4 _interfaceId)
272     external
273     view
274     returns (bool);
275 }
276 
277 // File: contracts/ERC721/ERC721Basic.sol
278 
279 /**
280  * @title ERC721 Non-Fungible Token Standard basic interface
281  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
282  */
283 contract ERC721Basic is ERC165 {
284   event Transfer(
285     address indexed _from,
286     address indexed _to,
287     uint256 indexed _tokenId
288   );
289   event Approval(
290     address indexed _owner,
291     address indexed _approved,
292     uint256 indexed _tokenId
293   );
294   event ApprovalForAll(
295     address indexed _owner,
296     address indexed _operator,
297     bool _approved
298   );
299 
300   function balanceOf(address _owner) public view returns (uint256 _balance);
301   function ownerOf(uint256 _tokenId) public view returns (address _owner);
302   function exists(uint256 _tokenId) public view returns (bool _exists);
303 
304   function approve(address _to, uint256 _tokenId) public;
305   function getApproved(uint256 _tokenId)
306     public view returns (address _operator);
307 
308   function setApprovalForAll(address _operator, bool _approved) public;
309   function isApprovedForAll(address _owner, address _operator)
310     public view returns (bool);
311 
312   function transferFrom(address _from, address _to, uint256 _tokenId) public;
313   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
314     public;
315 
316   function safeTransferFrom(
317     address _from,
318     address _to,
319     uint256 _tokenId,
320     bytes _data
321   )
322     public;
323 }
324 
325 // File: contracts/ERC721/ERC721.sol
326 
327 /**
328  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
329  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
330  */
331 contract ERC721Enumerable is ERC721Basic {
332   function totalSupply() public view returns (uint256);
333   function tokenOfOwnerByIndex(
334     address _owner,
335     uint256 _index
336   )
337     public
338     view
339     returns (uint256 _tokenId);
340 
341   function tokenByIndex(uint256 _index) public view returns (uint256);
342 }
343 
344 
345 /**
346  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
347  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
348  */
349 contract ERC721Metadata is ERC721Basic {
350   function name() external view returns (string _name);
351   function symbol() external view returns (string _symbol);
352   function tokenURI(uint256 _tokenId) public view returns (string);
353 }
354 
355 
356 /**
357  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
358  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
359  */
360 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
361 }
362 
363 // File: contracts/ERC721/ERC721Receiver.sol
364 
365 /**
366  * @title ERC721 token receiver interface
367  * @dev Interface for any contract that wants to support safeTransfers
368  * from ERC721 asset contracts.
369  */
370 contract ERC721Receiver {
371   /**
372    * @dev Magic value to be returned upon successful reception of an NFT
373    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
374    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
375    */
376   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
377 
378   /**
379    * @notice Handle the receipt of an NFT
380    * @dev The ERC721 smart contract calls this function on the recipient
381    * after a `safetransfer`. This function MAY throw to revert and reject the
382    * transfer. Return of other than the magic value MUST result in the 
383    * transaction being reverted.
384    * Note: the contract address is always the message sender.
385    * @param _operator The address which called `safeTransferFrom` function
386    * @param _from The address which previously owned the token
387    * @param _tokenId The NFT identifier which is being transfered
388    * @param _data Additional data with no specified format
389    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
390    */
391   function onERC721Received(
392     address _operator,
393     address _from,
394     uint256 _tokenId,
395     bytes _data
396   )
397     public
398     returns(bytes4);
399 }
400 
401 // File: contracts/ERC721/AddressUtils.sol
402 
403 /**
404  * Utility library of inline functions on addresses
405  */
406 library AddressUtils {
407 
408   /**
409    * Returns whether the target address is a contract
410    * @dev This function will return false if invoked during the constructor of a contract,
411    * as the code is not actually created until after the constructor finishes.
412    * @param addr address to check
413    * @return whether the target address is a contract
414    */
415   function isContract(address addr) internal view returns (bool) {
416     uint256 size;
417     // XXX Currently there is no better way to check if there is a contract in an address
418     // than to check the size of the code at that address.
419     // See https://ethereum.stackexchange.com/a/14016/36603
420     // for more details about how this works.
421     // TODO Check this again before the Serenity release, because all addresses will be
422     // contracts then.
423     // solium-disable-next-line security/no-inline-assembly
424     assembly { size := extcodesize(addr) }
425     return size > 0;
426   }
427 
428 }
429 
430 // File: contracts/ERC721/SupportsInterfaceWithLookup.sol
431 
432 /**
433  * @title SupportsInterfaceWithLookup
434  * @author Matt Condon (@shrugs)
435  * @dev Implements ERC165 using a lookup table.
436  */
437 contract SupportsInterfaceWithLookup is ERC165 {
438   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
439   /**
440    * 0x01ffc9a7 ===
441    *   bytes4(keccak256('supportsInterface(bytes4)'))
442    */
443 
444   /**
445    * @dev a mapping of interface id to whether or not it's supported
446    */
447   mapping(bytes4 => bool) internal supportedInterfaces;
448 
449   /**
450    * @dev A contract implementing SupportsInterfaceWithLookup
451    * implement ERC165 itself
452    */
453   constructor()
454     public
455   {
456     _registerInterface(InterfaceId_ERC165);
457   }
458 
459   /**
460    * @dev implement supportsInterface(bytes4) using a lookup table
461    */
462   function supportsInterface(bytes4 _interfaceId)
463     external
464     view
465     returns (bool)
466   {
467     return supportedInterfaces[_interfaceId];
468   }
469 
470   /**
471    * @dev private method for registering an interface
472    */
473   function _registerInterface(bytes4 _interfaceId)
474     internal
475   {
476     require(_interfaceId != 0xffffffff);
477     supportedInterfaces[_interfaceId] = true;
478   }
479 }
480 
481 // File: contracts/ERC721/ERC721BasicToken.sol
482 
483 /**
484  * @title ERC721 Non-Fungible Token Standard basic implementation
485  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
486  */
487 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
488 
489   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
490   /*
491    * 0x80ac58cd ===
492    *   bytes4(keccak256('balanceOf(address)')) ^
493    *   bytes4(keccak256('ownerOf(uint256)')) ^
494    *   bytes4(keccak256('approve(address,uint256)')) ^
495    *   bytes4(keccak256('getApproved(uint256)')) ^
496    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
497    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
498    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
499    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
500    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
501    */
502 
503   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
504   /*
505    * 0x4f558e79 ===
506    *   bytes4(keccak256('exists(uint256)'))
507    */
508 
509   using SafeMath for uint256;
510   using AddressUtils for address;
511 
512   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
513   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
514   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
515 
516   // Mapping from token ID to owner
517   mapping (uint256 => address) internal tokenOwner;
518 
519   // Mapping from token ID to approved address
520   mapping (uint256 => address) internal tokenApprovals;
521 
522   // Mapping from owner to number of owned token
523   mapping (address => uint256) internal ownedTokensCount;
524 
525   // Mapping from owner to operator approvals
526   mapping (address => mapping (address => bool)) internal operatorApprovals;
527 
528   /**
529    * @dev Guarantees msg.sender is owner of the given token
530    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
531    */
532   modifier onlyOwnerOf(uint256 _tokenId) {
533     require(ownerOf(_tokenId) == msg.sender);
534     _;
535   }
536 
537   /**
538    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
539    * @param _tokenId uint256 ID of the token to validate
540    */
541   modifier canTransfer(uint256 _tokenId) {
542     require(isApprovedOrOwner(msg.sender, _tokenId));
543     _;
544   }
545 
546   constructor()
547     public
548   {
549     // register the supported interfaces to conform to ERC721 via ERC165
550     _registerInterface(InterfaceId_ERC721);
551     _registerInterface(InterfaceId_ERC721Exists);
552   }
553 
554   /**
555    * @dev Gets the balance of the specified address
556    * @param _owner address to query the balance of
557    * @return uint256 representing the amount owned by the passed address
558    */
559   function balanceOf(address _owner) public view returns (uint256) {
560     require(_owner != address(0));
561     return ownedTokensCount[_owner];
562   }
563 
564   /**
565    * @dev Gets the owner of the specified token ID
566    * @param _tokenId uint256 ID of the token to query the owner of
567    * @return owner address currently marked as the owner of the given token ID
568    */
569   function ownerOf(uint256 _tokenId) public view returns (address) {
570     address owner = tokenOwner[_tokenId];
571     require(owner != address(0));
572     return owner;
573   }
574 
575   /**
576    * @dev Returns whether the specified token exists
577    * @param _tokenId uint256 ID of the token to query the existence of
578    * @return whether the token exists
579    */
580   function exists(uint256 _tokenId) public view returns (bool) {
581     address owner = tokenOwner[_tokenId];
582     return owner != address(0);
583   }
584 
585   /**
586    * @dev Approves another address to transfer the given token ID
587    * The zero address indicates there is no approved address.
588    * There can only be one approved address per token at a given time.
589    * Can only be called by the token owner or an approved operator.
590    * @param _to address to be approved for the given token ID
591    * @param _tokenId uint256 ID of the token to be approved
592    */
593   function approve(address _to, uint256 _tokenId) public {
594     address owner = ownerOf(_tokenId);
595     require(_to != owner);
596     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
597 
598     tokenApprovals[_tokenId] = _to;
599     emit Approval(owner, _to, _tokenId);
600   }
601 
602   /**
603    * @dev Gets the approved address for a token ID, or zero if no address set
604    * @param _tokenId uint256 ID of the token to query the approval of
605    * @return address currently approved for the given token ID
606    */
607   function getApproved(uint256 _tokenId) public view returns (address) {
608     return tokenApprovals[_tokenId];
609   }
610 
611   /**
612    * @dev Sets or unsets the approval of a given operator
613    * An operator is allowed to transfer all tokens of the sender on their behalf
614    * @param _to operator address to set the approval
615    * @param _approved representing the status of the approval to be set
616    */
617   function setApprovalForAll(address _to, bool _approved) public {
618     require(_to != msg.sender);
619     operatorApprovals[msg.sender][_to] = _approved;
620     emit ApprovalForAll(msg.sender, _to, _approved);
621   }
622 
623   /**
624    * @dev Tells whether an operator is approved by a given owner
625    * @param _owner owner address which you want to query the approval of
626    * @param _operator operator address which you want to query the approval of
627    * @return bool whether the given operator is approved by the given owner
628    */
629   function isApprovedForAll(
630     address _owner,
631     address _operator
632   )
633     public
634     view
635     returns (bool)
636   {
637     return operatorApprovals[_owner][_operator];
638   }
639 
640   /**
641    * @dev Transfers the ownership of a given token ID to another address
642    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
643    * Requires the msg sender to be the owner, approved, or operator
644    * @param _from current owner of the token
645    * @param _to address to receive the ownership of the given token ID
646    * @param _tokenId uint256 ID of the token to be transferred
647   */
648   function transferFrom(
649     address _from,
650     address _to,
651     uint256 _tokenId
652   )
653     public
654     canTransfer(_tokenId)
655   {
656     require(_from != address(0));
657     require(_to != address(0));
658 
659     clearApproval(_from, _tokenId);
660     removeTokenFrom(_from, _tokenId);
661     addTokenTo(_to, _tokenId);
662 
663     emit Transfer(_from, _to, _tokenId);
664   }
665 
666   /**
667    * @dev Safely transfers the ownership of a given token ID to another address
668    * If the target address is a contract, it must implement `onERC721Received`,
669    * which is called upon a safe transfer, and return the magic value
670    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
671    * the transfer is reverted.
672    *
673    * Requires the msg sender to be the owner, approved, or operator
674    * @param _from current owner of the token
675    * @param _to address to receive the ownership of the given token ID
676    * @param _tokenId uint256 ID of the token to be transferred
677   */
678   function safeTransferFrom(
679     address _from,
680     address _to,
681     uint256 _tokenId
682   )
683     public
684     canTransfer(_tokenId)
685   {
686     // solium-disable-next-line arg-overflow
687     safeTransferFrom(_from, _to, _tokenId, "");
688   }
689 
690   /**
691    * @dev Safely transfers the ownership of a given token ID to another address
692    * If the target address is a contract, it must implement `onERC721Received`,
693    * which is called upon a safe transfer, and return the magic value
694    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
695    * the transfer is reverted.
696    * Requires the msg sender to be the owner, approved, or operator
697    * @param _from current owner of the token
698    * @param _to address to receive the ownership of the given token ID
699    * @param _tokenId uint256 ID of the token to be transferred
700    * @param _data bytes data to send along with a safe transfer check
701    */
702   function safeTransferFrom(
703     address _from,
704     address _to,
705     uint256 _tokenId,
706     bytes _data
707   )
708     public
709     canTransfer(_tokenId)
710   {
711     transferFrom(_from, _to, _tokenId);
712     // solium-disable-next-line arg-overflow
713     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
714   }
715 
716   /**
717    * @dev Returns whether the given spender can transfer a given token ID
718    * @param _spender address of the spender to query
719    * @param _tokenId uint256 ID of the token to be transferred
720    * @return bool whether the msg.sender is approved for the given token ID,
721    *  is an operator of the owner, or is the owner of the token
722    */
723   function isApprovedOrOwner(
724     address _spender,
725     uint256 _tokenId
726   )
727     internal
728     view
729     returns (bool)
730   {
731     address owner = ownerOf(_tokenId);
732     // Disable solium check because of
733     // https://github.com/duaraghav8/Solium/issues/175
734     // solium-disable-next-line operator-whitespace
735     return (
736       _spender == owner ||
737       getApproved(_tokenId) == _spender ||
738       isApprovedForAll(owner, _spender)
739     );
740   }
741 
742   /**
743    * @dev Internal function to mint a new token
744    * Reverts if the given token ID already exists
745    * @param _to The address that will own the minted token
746    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
747    */
748   function _mint(address _to, uint256 _tokenId) internal {
749     require(_to != address(0));
750     addTokenTo(_to, _tokenId);
751     emit Transfer(address(0), _to, _tokenId);
752   }
753 
754   /**
755    * @dev Internal function to burn a specific token
756    * Reverts if the token does not exist
757    * @param _tokenId uint256 ID of the token being burned by the msg.sender
758    */
759   function _burn(address _owner, uint256 _tokenId) internal {
760     clearApproval(_owner, _tokenId);
761     removeTokenFrom(_owner, _tokenId);
762     emit Transfer(_owner, address(0), _tokenId);
763   }
764 
765   /**
766    * @dev Internal function to clear current approval of a given token ID
767    * Reverts if the given address is not indeed the owner of the token
768    * @param _owner owner of the token
769    * @param _tokenId uint256 ID of the token to be transferred
770    */
771   function clearApproval(address _owner, uint256 _tokenId) internal {
772     require(ownerOf(_tokenId) == _owner);
773     if (tokenApprovals[_tokenId] != address(0)) {
774       tokenApprovals[_tokenId] = address(0);
775     }
776   }
777 
778   /**
779    * @dev Internal function to add a token ID to the list of a given address
780    * @param _to address representing the new owner of the given token ID
781    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
782    */
783   function addTokenTo(address _to, uint256 _tokenId) internal {
784     require(tokenOwner[_tokenId] == address(0));
785     tokenOwner[_tokenId] = _to;
786     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
787   }
788 
789   /**
790    * @dev Internal function to remove a token ID from the list of a given address
791    * @param _from address representing the previous owner of the given token ID
792    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
793    */
794   function removeTokenFrom(address _from, uint256 _tokenId) internal {
795     require(ownerOf(_tokenId) == _from);
796     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
797     tokenOwner[_tokenId] = address(0);
798   }
799 
800   /**
801    * @dev Internal function to invoke `onERC721Received` on a target address
802    * The call is not executed if the target address is not a contract
803    * @param _from address representing the previous owner of the given token ID
804    * @param _to target address that will receive the tokens
805    * @param _tokenId uint256 ID of the token to be transferred
806    * @param _data bytes optional data to send along with the call
807    * @return whether the call correctly returned the expected magic value
808    */
809   function checkAndCallSafeTransfer(
810     address _from,
811     address _to,
812     uint256 _tokenId,
813     bytes _data
814   )
815     internal
816     returns (bool)
817   {
818     if (!_to.isContract()) {
819       return true;
820     }
821     bytes4 retval = ERC721Receiver(_to).onERC721Received(
822       msg.sender, _from, _tokenId, _data);
823     return (retval == ERC721_RECEIVED);
824   }
825 }
826 
827 // File: contracts/ERC721/ERC721Token.sol
828 
829 /**
830  * @title Full ERC721 Token
831  * This implementation includes all the required and some optional functionality of the ERC721 standard
832  * Moreover, it includes approve all functionality using operator terminology
833  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
834  */
835 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
836 
837   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
838   /**
839    * 0x780e9d63 ===
840    *   bytes4(keccak256('totalSupply()')) ^
841    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
842    *   bytes4(keccak256('tokenByIndex(uint256)'))
843    */
844 
845   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
846   /**
847    * 0x5b5e139f ===
848    *   bytes4(keccak256('name()')) ^
849    *   bytes4(keccak256('symbol()')) ^
850    *   bytes4(keccak256('tokenURI(uint256)'))
851    */
852 
853   // Token name
854   string internal name_;
855 
856   // Token symbol
857   string internal symbol_;
858 
859   // Mapping from owner to list of owned token IDs
860   mapping(address => uint256[]) internal ownedTokens;
861 
862   // Mapping from token ID to index of the owner tokens list
863   mapping(uint256 => uint256) internal ownedTokensIndex;
864 
865   // Array with all token ids, used for enumeration
866   uint256[] internal allTokens;
867 
868   // Mapping from token id to position in the allTokens array
869   mapping(uint256 => uint256) internal allTokensIndex;
870 
871   // Optional mapping for token URIs
872   mapping(uint256 => string) internal tokenURIs;
873 
874   /**
875    * @dev Constructor function
876    */
877   constructor(string _name, string _symbol) public {
878     name_ = _name;
879     symbol_ = _symbol;
880 
881     // register the supported interfaces to conform to ERC721 via ERC165
882     _registerInterface(InterfaceId_ERC721Enumerable);
883     _registerInterface(InterfaceId_ERC721Metadata);
884   }
885 
886   /**
887    * @dev Gets the token name
888    * @return string representing the token name
889    */
890   function name() external view returns (string) {
891     return name_;
892   }
893 
894   /**
895    * @dev Gets the token symbol
896    * @return string representing the token symbol
897    */
898   function symbol() external view returns (string) {
899     return symbol_;
900   }
901 
902   /**
903    * @dev Returns an URI for a given token ID
904    * Throws if the token ID does not exist. May return an empty string.
905    * @param _tokenId uint256 ID of the token to query
906    */
907   function tokenURI(uint256 _tokenId) public view returns (string) {
908     require(exists(_tokenId));
909     return tokenURIs[_tokenId];
910   }
911 
912   /**
913    * @dev Gets the token ID at a given index of the tokens list of the requested owner
914    * @param _owner address owning the tokens list to be accessed
915    * @param _index uint256 representing the index to be accessed of the requested tokens list
916    * @return uint256 token ID at the given index of the tokens list owned by the requested address
917    */
918   function tokenOfOwnerByIndex(
919     address _owner,
920     uint256 _index
921   )
922     public
923     view
924     returns (uint256)
925   {
926     require(_index < balanceOf(_owner));
927     return ownedTokens[_owner][_index];
928   }
929 
930   /**
931    * @dev Gets the total amount of tokens stored by the contract
932    * @return uint256 representing the total amount of tokens
933    */
934   function totalSupply() public view returns (uint256) {
935     return allTokens.length;
936   }
937 
938   /**
939    * @dev Gets the token ID at a given index of all the tokens in this contract
940    * Reverts if the index is greater or equal to the total number of tokens
941    * @param _index uint256 representing the index to be accessed of the tokens list
942    * @return uint256 token ID at the given index of the tokens list
943    */
944   function tokenByIndex(uint256 _index) public view returns (uint256) {
945     require(_index < totalSupply());
946     return allTokens[_index];
947   }
948 
949   /**
950    * @dev Internal function to set the token URI for a given token
951    * Reverts if the token ID does not exist
952    * @param _tokenId uint256 ID of the token to set its URI
953    * @param _uri string URI to assign
954    */
955   function _setTokenURI(uint256 _tokenId, string _uri) internal {
956     require(exists(_tokenId));
957     tokenURIs[_tokenId] = _uri;
958   }
959 
960   /**
961    * @dev Internal function to add a token ID to the list of a given address
962    * @param _to address representing the new owner of the given token ID
963    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
964    */
965   function addTokenTo(address _to, uint256 _tokenId) internal {
966     super.addTokenTo(_to, _tokenId);
967     uint256 length = ownedTokens[_to].length;
968     ownedTokens[_to].push(_tokenId);
969     ownedTokensIndex[_tokenId] = length;
970   }
971 
972   /**
973    * @dev Internal function to remove a token ID from the list of a given address
974    * @param _from address representing the previous owner of the given token ID
975    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
976    */
977   function removeTokenFrom(address _from, uint256 _tokenId) internal {
978     super.removeTokenFrom(_from, _tokenId);
979 
980     uint256 tokenIndex = ownedTokensIndex[_tokenId];
981     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
982     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
983 
984     ownedTokens[_from][tokenIndex] = lastToken;
985     ownedTokens[_from][lastTokenIndex] = 0;
986     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
987     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
988     // the lastToken to the first position, and then dropping the element placed in the last position of the list
989 
990     ownedTokens[_from].length--;
991     ownedTokensIndex[_tokenId] = 0;
992     ownedTokensIndex[lastToken] = tokenIndex;
993   }
994 
995   /**
996    * @dev Internal function to mint a new token
997    * Reverts if the given token ID already exists
998    * @param _to address the beneficiary that will own the minted token
999    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1000    */
1001   function _mint(address _to, uint256 _tokenId) internal {
1002     super._mint(_to, _tokenId);
1003 
1004     allTokensIndex[_tokenId] = allTokens.length;
1005     allTokens.push(_tokenId);
1006   }
1007 
1008   /**
1009    * @dev Internal function to burn a specific token
1010    * Reverts if the token does not exist
1011    * @param _owner owner of the token to burn
1012    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1013    */
1014   function _burn(address _owner, uint256 _tokenId) internal {
1015     super._burn(_owner, _tokenId);
1016 
1017     // Clear metadata (if any)
1018     if (bytes(tokenURIs[_tokenId]).length != 0) {
1019       delete tokenURIs[_tokenId];
1020     }
1021 
1022     // Reorg all tokens array
1023     uint256 tokenIndex = allTokensIndex[_tokenId];
1024     uint256 lastTokenIndex = allTokens.length.sub(1);
1025     uint256 lastToken = allTokens[lastTokenIndex];
1026 
1027     allTokens[tokenIndex] = lastToken;
1028     allTokens[lastTokenIndex] = 0;
1029 
1030     allTokens.length--;
1031     allTokensIndex[_tokenId] = 0;
1032     allTokensIndex[lastToken] = tokenIndex;
1033   }
1034 
1035 }
1036 
1037 // File: contracts/Ownable.sol
1038 
1039 /**
1040  * @title Ownable
1041  * @dev The Ownable contract has an owner address, and provides basic authorization control
1042  * functions, this simplifies the implementation of "user permissions".
1043  */
1044 contract Ownable {
1045   address public owner;
1046 
1047 
1048   event OwnershipRenounced(address indexed previousOwner);
1049   event OwnershipTransferred(
1050     address indexed previousOwner,
1051     address indexed newOwner
1052   );
1053 
1054 
1055   /**
1056    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1057    * account.
1058    */
1059   constructor() public {
1060     owner = msg.sender;
1061   }
1062 
1063   /**
1064    * @dev Throws if called by any account other than the owner.
1065    */
1066   modifier onlyOwner() {
1067     require(msg.sender == owner);
1068     _;
1069   }
1070 
1071   /**
1072    * @dev Allows the current owner to relinquish control of the contract.
1073    * @notice Renouncing to ownership will leave the contract without an owner.
1074    * It will not be possible to call the functions with the `onlyOwner`
1075    * modifier anymore.
1076    */
1077   function renounceOwnership() public onlyOwner {
1078     emit OwnershipRenounced(owner);
1079     owner = address(0);
1080   }
1081 
1082   /**
1083    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1084    * @param _newOwner The address to transfer ownership to.
1085    */
1086   function transferOwnership(address _newOwner) public onlyOwner {
1087     _transferOwnership(_newOwner);
1088   }
1089 
1090   /**
1091    * @dev Transfers control of the contract to a newOwner.
1092    * @param _newOwner The address to transfer ownership to.
1093    */
1094   function _transferOwnership(address _newOwner) internal {
1095     require(_newOwner != address(0));
1096     emit OwnershipTransferred(owner, _newOwner);
1097     owner = _newOwner;
1098   }
1099 }
1100 
1101 // File: contracts/DistributeByTransferFrom.sol
1102 
1103 contract ERC20StdToken is StandardToken {}
1104 
1105 contract ERC721StdToken is ERC721Token {}
1106 
1107 contract DistributeByTransferFrom is Ownable {
1108   address public owner;
1109 
1110   constructor () public {
1111     owner = msg.sender;
1112   }
1113 
1114   modifier onlyOwner {
1115     require(msg.sender == owner);
1116     _;
1117   }
1118   event Pay(uint256 _value, bytes _id);
1119   
1120   /**
1121    * @dev fallback functiom that receives payment in ether and sends
1122    * it to the contract owner
1123   **/
1124   function () payable public {
1125     owner.transfer(msg.value);
1126     emit Pay(msg.value, msg.data);
1127   }
1128   /**
1129    * @dev sends transactions TransferFrom by cycle in token address
1130    * @param _token Address of token which is distributed
1131    * @param _bits Array of transfer params. nth elem - address to, nth+1 elem - value
1132   */
1133   function distributeTokens(address _token, address _from, uint256[] _bits) public onlyOwner returns (bool result) {
1134     require(_bits.length % 2 == 0);
1135     for (uint256 i = 0; i < _bits.length; i+=2) {
1136       address to = address(_bits[i]);
1137       uint256 value = _bits[i+1];
1138       ERC20StdToken(_token).transferFrom(_from, to, value);
1139     }
1140     return true;
1141   }
1142   /** 
1143    * @dev Sends accidentally sent ethereum from contract to owner
1144   */
1145   function withdrawEther() public onlyOwner returns(bool res) {
1146     uint256 ethBalance = address(this).balance;
1147     owner.transfer(ethBalance);
1148     return true;
1149   }
1150   /** 
1151    * @dev Withdraws any accidentally sent ERC20 token from contract to owner
1152    * @param _token Address of token to be withdrawed
1153   */
1154   function withdrawERC20(address _token) public onlyOwner returns(bool res) {
1155     uint256 value = ERC20StdToken(_token).balanceOf(address(this));
1156     ERC20StdToken(_token).transfer(owner, value);
1157     return true;
1158   }
1159   /** 
1160    * @dev Withdraws any accidentally sent ERC721 token from contract to owner
1161    * @param _contract Address of ERC721 token contract
1162    * @param _tokenId Id of non-fungible token to be withdrawed
1163   */
1164   function withdrawERC721(address _contract, uint256 _tokenId) public onlyOwner returns(bool res) {
1165     ERC721StdToken(_contract).safeTransferFrom(address(this), owner, _tokenId);
1166     return true;
1167   }
1168 }