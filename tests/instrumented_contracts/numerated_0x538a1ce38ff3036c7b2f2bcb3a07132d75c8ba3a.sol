1 //Have an idea for a studio? Email: admin[at]EtherPornStars.com
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 
40 
41 
42 
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that revert on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, reverts on overflow.
53   */
54   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (_a == 0) {
59       return 0;
60     }
61 
62     uint256 c = _a * _b;
63     require(c / _a == _b);
64 
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
70   */
71   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
72     require(_b > 0); // Solidity only automatically asserts when dividing by 0
73     uint256 c = _a / _b;
74     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
75 
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     require(_b <= _a);
84     uint256 c = _a - _b;
85 
86     return c;
87   }
88 
89   /**
90   * @dev Adds two numbers, reverts on overflow.
91   */
92   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
93     uint256 c = _a + _b;
94     require(c >= _a);
95 
96     return c;
97   }
98 
99   /**
100   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
101   * reverts when dividing by zero.
102   */
103   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b != 0);
105     return a % b;
106   }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20 {
117   using SafeMath for uint256;
118 
119   mapping (address => uint256) balances;
120 
121   mapping (address => mapping (address => uint256)) allowed;
122 
123   uint256 totalSupply_;
124 
125   /**
126   * @dev Total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances[_owner];
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(
148     address _owner,
149     address _spender
150    )
151     public
152     view
153     returns (uint256)
154   {
155     return allowed[_owner][_spender];
156   }
157 
158   /**
159   * @dev Transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_value <= balances[msg.sender]);
165     require(_to != address(0));
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address _from,
196     address _to,
197     uint256 _value
198   )
199     public
200     returns (bool)
201   {
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204     require(_to != address(0));
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint256 _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(
245     address _spender,
246     uint256 _subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     uint256 oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue >= oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Internal function that mints an amount of the token and assigns it to
263    * an account. This encapsulates the modification of balances such that the
264    * proper events are emitted.
265    * @param _account The account that will receive the created tokens.
266    * @param _amount The amount that will be created.
267    */
268   function _mint(address _account, uint256 _amount) internal {
269     require(_account != 0);
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_account] = balances[_account].add(_amount);
272     emit Transfer(address(0), _account, _amount);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account.
278    * @param _account The account whose tokens will be burnt.
279    * @param _amount The amount that will be burnt.
280    */
281   function _burn(address _account, uint256 _amount) internal {
282     require(_account != 0);
283     require(_amount <= balances[_account]);
284 
285     totalSupply_ = totalSupply_.sub(_amount);
286     balances[_account] = balances[_account].sub(_amount);
287     emit Transfer(_account, address(0), _amount);
288   }
289 
290   /**
291    * @dev Internal function that burns an amount of the token of a given
292    * account, deducting from the sender's allowance for said account. Uses the
293    * internal _burn function.
294    * @param _account The account whose tokens will be burnt.
295    * @param _amount The amount that will be burnt.
296    */
297   function _burnFrom(address _account, uint256 _amount) internal {
298     require(_amount <= allowed[_account][msg.sender]);
299 
300     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
301     // this function needs to emit an event with the updated approval.
302     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
303     _burn(_account, _amount);
304   }
305 }
306 
307 /**
308  * @title ERC20 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  *  from ERC20 asset contracts.
311  */
312 
313 /**
314  * @title SafeMath
315  * @dev Math operations with safety checks that revert on error
316  */
317 
318 
319 
320 contract Ownable {
321   address public owner;
322 
323 
324   event OwnershipRenounced(address indexed previousOwner);
325   event OwnershipTransferred(
326     address indexed previousOwner,
327     address indexed newOwner
328   );
329 
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() public {
336     owner = msg.sender;
337   }
338 
339   /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyOwner() {
343     require(msg.sender == owner);
344     _;
345   }
346 }
347 
348 
349 contract StarCoin is Ownable, StandardToken {
350     using SafeMath for uint;
351     address gateway;
352     string public name = "EtherPornStars Coin";
353     string public symbol = "EPS";
354     uint8 public decimals = 18;
355     mapping (uint8 => address) public studioContracts;
356     mapping (address => bool) public isMinter;
357     event Withdrawal(address indexed to, uint256 value);
358     event Burn(address indexed from, uint256 value);
359     modifier onlyMinters {
360       require(msg.sender == owner || isMinter[msg.sender]);
361       _;
362     }
363 
364     constructor () public {
365   }
366   /**
367    * @dev Future sidechain integration for studios.
368    */
369     function setGateway(address _gateway) external onlyOwner {
370         gateway = _gateway;
371     }
372 
373 
374     function _mintTokens(address _user, uint256 _amount) private {
375         require(_user != 0x0);
376         balances[_user] = balances[_user].add(_amount);
377         totalSupply_ = totalSupply_.add(_amount);
378         emit Transfer(address(this), _user, _amount);
379     }
380 
381     function rewardTokens(address _user, uint256 _tokens) external   { 
382         require(msg.sender == owner || isMinter[msg.sender]);
383         _mintTokens(_user, _tokens);
384     }
385     function buyStudioStake(address _user, uint256 _tokens) external   { 
386         require(msg.sender == owner || isMinter[msg.sender]);
387         _burn(_user, _tokens);
388     }
389     function transferFromStudio(
390       address _from,
391       address _to,
392       uint256 _value
393     )
394       external
395       returns (bool)
396     {
397       require(msg.sender == owner || isMinter[msg.sender]);
398       require(_value <= balances[_from]);
399       require(_to != address(0));
400 
401       balances[_from] = balances[_from].sub(_value);
402       balances[_to] = balances[_to].add(_value);
403       emit Transfer(_from, _to, _value);
404       return true;
405   }
406 
407     function() payable public {
408         // Intentionally left empty, for use by studios
409     }
410 
411     function accountAuth(uint256 /*_challenge*/) external {
412         // Does nothing by design
413     }
414 
415     function burn(uint256 _amount) external {
416         require(balances[msg.sender] >= _amount);
417         balances[msg.sender] = balances[msg.sender].sub(_amount);
418         totalSupply_ = totalSupply_.sub(_amount);
419         emit Burn(msg.sender, _amount);
420     }
421 
422     function withdrawBalance(uint _amount) external {
423         require(balances[msg.sender] >= _amount);
424         balances[msg.sender] = balances[msg.sender].sub(_amount);
425         totalSupply_ = totalSupply_.sub(_amount);
426         uint ethexchange = _amount.div(2);
427         msg.sender.transfer(ethexchange);
428     }
429 
430     function setIsMinter(address _address, bool _value) external onlyOwner {
431         isMinter[_address] = _value;
432     }
433 
434     function depositToGateway(uint256 amount) external {
435         transfer(gateway, amount);
436     }
437 }
438 
439 
440 
441 
442 
443 /**
444  * @title ERC165
445  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
446  */
447 interface ERC165 {
448 
449   /**
450    * @notice Query if a contract implements an interface
451    * @param _interfaceId The interface identifier, as specified in ERC-165
452    * @dev Interface identification is specified in ERC-165. This function
453    * uses less than 30,000 gas.
454    */
455   function supportsInterface(bytes4 _interfaceId)
456     external
457     view
458     returns (bool);
459 }
460 
461 contract SupportsInterfaceWithLookup is ERC165 {
462 
463   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
464   /**
465    * 0x01ffc9a7 ===
466    *   bytes4(keccak256('supportsInterface(bytes4)'))
467    */
468 
469   /**
470    * @dev a mapping of interface id to whether or not it's supported
471    */
472   mapping(bytes4 => bool) internal supportedInterfaces;
473 
474   /**
475    * @dev A contract implementing SupportsInterfaceWithLookup
476    * implement ERC165 itself
477    */
478   constructor()
479     public
480   {
481     _registerInterface(InterfaceId_ERC165);
482   }
483 
484   /**
485    * @dev implement supportsInterface(bytes4) using a lookup table
486    */
487   function supportsInterface(bytes4 _interfaceId)
488     external
489     view
490     returns (bool)
491   {
492     return supportedInterfaces[_interfaceId];
493   }
494 
495   /**
496    * @dev private method for registering an interface
497    */
498   function _registerInterface(bytes4 _interfaceId)
499     internal
500   {
501     require(_interfaceId != 0xffffffff);
502     supportedInterfaces[_interfaceId] = true;
503   }
504 }
505 
506 
507 
508 
509 
510 contract StarLogicInterface {
511     function isTransferAllowed(address _from, address _to, uint256 _tokenId) public view returns (bool);
512 }
513 
514 
515 
516 
517 /**
518  * @title ERC721 Non-Fungible Token Standard basic interface
519  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
520  */
521 contract ERC721Basic is ERC165 {
522 
523   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
524   /*
525    * 0x80ac58cd ===
526    *   bytes4(keccak256('balanceOf(address)')) ^
527    *   bytes4(keccak256('ownerOf(uint256)')) ^
528    *   bytes4(keccak256('approve(address,uint256)')) ^
529    *   bytes4(keccak256('getApproved(uint256)')) ^
530    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
531    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
532    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
533    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
534    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
535    */
536 
537   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
538   /**
539    * 0x780e9d63 ===
540    *   bytes4(keccak256('totalSupply()')) ^
541    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
542    *   bytes4(keccak256('tokenByIndex(uint256)'))
543    */
544 
545   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
546   /**
547    * 0x5b5e139f ===
548    *   bytes4(keccak256('name()')) ^
549    *   bytes4(keccak256('symbol()')) ^
550    *   bytes4(keccak256('tokenURI(uint256)'))
551    */
552 
553   event Transfer(
554     address indexed _from,
555     address indexed _to,
556     uint256 indexed _tokenId
557   );
558   event Approval(
559     address indexed _owner,
560     address indexed _approved,
561     uint256 indexed _tokenId
562   );
563   event ApprovalForAll(
564     address indexed _owner,
565     address indexed _operator,
566     bool _approved
567   );
568 
569   function balanceOf(address _owner) public view returns (uint256 _balance);
570   function ownerOf(uint256 _tokenId) public view returns (address _owner);
571 
572   function approve(address _to, uint256 _tokenId) public;
573   function getApproved(uint256 _tokenId)
574     public view returns (address _operator);
575 
576   function setApprovalForAll(address _operator, bool _approved) public;
577   function isApprovedForAll(address _owner, address _operator)
578     public view returns (bool);
579 
580   function transferFrom(address _from, address _to, uint256 _tokenId) public;
581   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
582     public;
583 
584   function safeTransferFrom(
585     address _from,
586     address _to,
587     uint256 _tokenId,
588     bytes _data
589   )
590     public;
591 }
592 
593 
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
597  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
598  */
599 contract ERC721Enumerable is ERC721Basic {
600   function totalSupply() public view returns (uint256);
601   function tokenOfOwnerByIndex(
602     address _owner,
603     uint256 _index
604   )
605     public
606     view
607     returns (uint256 _tokenId);
608 
609   function tokenByIndex(uint256 _index) public view returns (uint256);
610 }
611 
612 
613 /**
614  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
615  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
616  */
617 contract ERC721Metadata is ERC721Basic {
618   function name() external view returns (string _name);
619   function symbol() external view returns (string _symbol);
620   function tokenURI(uint256 _tokenId) public view returns (string);
621 }
622 
623 
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
626  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
627  */
628 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
629 }
630 
631 
632 
633 
634 /**
635  * @title ERC721 token receiver interface
636  * @dev Interface for any contract that wants to support safeTransfers
637  * from ERC721 asset contracts.
638  */
639 contract ERC721Receiver {
640   /**
641    * @dev Magic value to be returned upon successful reception of an NFT
642    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
643    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
644    */
645   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
646 
647   /**
648    * @notice Handle the receipt of an NFT
649    * @dev The ERC721 smart contract calls this function on the recipient
650    * after a `safetransfer`. This function MAY throw to revert and reject the
651    * transfer. Return of other than the magic value MUST result in the
652    * transaction being reverted.
653    * Note: the contract address is always the message sender.
654    * @param _operator The address which called `safeTransferFrom` function
655    * @param _from The address which previously owned the token
656    * @param _tokenId The NFT identifier which is being transferred
657    * @param _data Additional data with no specified format
658    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
659    */
660   function onERC721Received(
661     address _operator,
662     address _from,
663     uint256 _tokenId,
664     bytes _data
665   )
666     public
667     returns(bytes4);
668 }
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * Utility library of inline functions on addresses
680  */
681 library AddressUtils {
682 
683   /**
684    * Returns whether the target address is a contract
685    * @dev This function will return false if invoked during the constructor of a contract,
686    * as the code is not actually created until after the constructor finishes.
687    * @param _account address of the account to check
688    * @return whether the target address is a contract
689    */
690   function isContract(address _account) internal view returns (bool) {
691     uint256 size;
692     // XXX Currently there is no better way to check if there is a contract in an address
693     // than to check the size of the code at that address.
694     // See https://ethereum.stackexchange.com/a/14016/36603
695     // for more details about how this works.
696     // TODO Check this again before the Serenity release, because all addresses will be
697     // contracts then.
698     // solium-disable-next-line security/no-inline-assembly
699     assembly { size := extcodesize(_account) }
700     return size > 0;
701   }
702 
703 }
704 
705 
706 
707 
708 /**
709  * @title ERC721 Non-Fungible Token Standard basic implementation
710  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
711  */
712 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
713 
714   using SafeMath for uint256;
715   using AddressUtils for address;
716 
717   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
718   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
719   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
720 
721   // Mapping from token ID to owner
722   mapping (uint256 => address) internal tokenOwner;
723 
724   // Mapping from token ID to approved address
725   mapping (uint256 => address) internal tokenApprovals;
726 
727   // Mapping from owner to number of owned token
728   mapping (address => uint256) internal ownedTokensCount;
729 
730   // Mapping from owner to operator approvals
731   mapping (address => mapping (address => bool)) internal operatorApprovals;
732 
733   constructor()
734     public
735   {
736     // register the supported interfaces to conform to ERC721 via ERC165
737     _registerInterface(InterfaceId_ERC721);
738   }
739 
740   /**
741    * @dev Gets the balance of the specified address
742    * @param _owner address to query the balance of
743    * @return uint256 representing the amount owned by the passed address
744    */
745   function balanceOf(address _owner) public view returns (uint256) {
746     require(_owner != address(0));
747     return ownedTokensCount[_owner];
748   }
749 
750   /**
751    * @dev Gets the owner of the specified token ID
752    * @param _tokenId uint256 ID of the token to query the owner of
753    * @return owner address currently marked as the owner of the given token ID
754    */
755   function ownerOf(uint256 _tokenId) public view returns (address) {
756     address owner = tokenOwner[_tokenId];
757     require(owner != address(0));
758     return owner;
759   }
760 
761   /**
762    * @dev Approves another address to transfer the given token ID
763    * The zero address indicates there is no approved address.
764    * There can only be one approved address per token at a given time.
765    * Can only be called by the token owner or an approved operator.
766    * @param _to address to be approved for the given token ID
767    * @param _tokenId uint256 ID of the token to be approved
768    */
769   function approve(address _to, uint256 _tokenId) public {
770     address owner = ownerOf(_tokenId);
771     require(_to != owner);
772     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
773 
774     tokenApprovals[_tokenId] = _to;
775     emit Approval(owner, _to, _tokenId);
776   }
777 
778   /**
779    * @dev Gets the approved address for a token ID, or zero if no address set
780    * @param _tokenId uint256 ID of the token to query the approval of
781    * @return address currently approved for the given token ID
782    */
783   function getApproved(uint256 _tokenId) public view returns (address) {
784     return tokenApprovals[_tokenId];
785   }
786 
787   /**
788    * @dev Sets or unsets the approval of a given operator
789    * An operator is allowed to transfer all tokens of the sender on their behalf
790    * @param _to operator address to set the approval
791    * @param _approved representing the status of the approval to be set
792    */
793   function setApprovalForAll(address _to, bool _approved) public {
794     require(_to != msg.sender);
795     operatorApprovals[msg.sender][_to] = _approved;
796     emit ApprovalForAll(msg.sender, _to, _approved);
797   }
798 
799   /**
800    * @dev Tells whether an operator is approved by a given owner
801    * @param _owner owner address which you want to query the approval of
802    * @param _operator operator address which you want to query the approval of
803    * @return bool whether the given operator is approved by the given owner
804    */
805   function isApprovedForAll(
806     address _owner,
807     address _operator
808   )
809     public
810     view
811     returns (bool)
812   {
813     return operatorApprovals[_owner][_operator];
814   }
815 
816   /**
817    * @dev Transfers the ownership of a given token ID to another address
818    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
819    * Requires the msg sender to be the owner, approved, or operator
820    * @param _from current owner of the token
821    * @param _to address to receive the ownership of the given token ID
822    * @param _tokenId uint256 ID of the token to be transferred
823   */
824   function transferFrom(
825     address _from,
826     address _to,
827     uint256 _tokenId
828   )
829     public
830   {
831     require(isApprovedOrOwner(msg.sender, _tokenId));
832     require(_to != address(0));
833 
834     clearApproval(_from, _tokenId);
835     removeTokenFrom(_from, _tokenId);
836     addTokenTo(_to, _tokenId);
837 
838     emit Transfer(_from, _to, _tokenId);
839   }
840 
841   /**
842    * @dev Safely transfers the ownership of a given token ID to another address
843    * If the target address is a contract, it must implement `onERC721Received`,
844    * which is called upon a safe transfer, and return the magic value
845    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
846    * the transfer is reverted.
847    *
848    * Requires the msg sender to be the owner, approved, or operator
849    * @param _from current owner of the token
850    * @param _to address to receive the ownership of the given token ID
851    * @param _tokenId uint256 ID of the token to be transferred
852   */
853   function safeTransferFrom(
854     address _from,
855     address _to,
856     uint256 _tokenId
857   )
858     public
859   {
860     // solium-disable-next-line arg-overflow
861     safeTransferFrom(_from, _to, _tokenId, "");
862   }
863 
864   /**
865    * @dev Safely transfers the ownership of a given token ID to another address
866    * If the target address is a contract, it must implement `onERC721Received`,
867    * which is called upon a safe transfer, and return the magic value
868    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
869    * the transfer is reverted.
870    * Requires the msg sender to be the owner, approved, or operator
871    * @param _from current owner of the token
872    * @param _to address to receive the ownership of the given token ID
873    * @param _tokenId uint256 ID of the token to be transferred
874    * @param _data bytes data to send along with a safe transfer check
875    */
876   function safeTransferFrom(
877     address _from,
878     address _to,
879     uint256 _tokenId,
880     bytes _data
881   )
882     public
883   {
884     transferFrom(_from, _to, _tokenId);
885     // solium-disable-next-line arg-overflow
886     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
887   }
888 
889   /**
890    * @dev Returns whether the specified token exists
891    * @param _tokenId uint256 ID of the token to query the existence of
892    * @return whether the token exists
893    */
894   function _exists(uint256 _tokenId) internal view returns (bool) {
895     address owner = tokenOwner[_tokenId];
896     return owner != address(0);
897   }
898 
899   /**
900    * @dev Returns whether the given spender can transfer a given token ID
901    * @param _spender address of the spender to query
902    * @param _tokenId uint256 ID of the token to be transferred
903    * @return bool whether the msg.sender is approved for the given token ID,
904    *  is an operator of the owner, or is the owner of the token
905    */
906   function isApprovedOrOwner(
907     address _spender,
908     uint256 _tokenId
909   )
910     internal
911     view
912     returns (bool)
913   {
914     address owner = ownerOf(_tokenId);
915     // Disable solium check because of
916     // https://github.com/duaraghav8/Solium/issues/175
917     // solium-disable-next-line operator-whitespace
918     return (
919       _spender == owner ||
920       getApproved(_tokenId) == _spender ||
921       isApprovedForAll(owner, _spender)
922     );
923   }
924 
925   /**
926    * @dev Internal function to mint a new token
927    * Reverts if the given token ID already exists
928    * @param _to The address that will own the minted token
929    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
930    */
931   function _mint(address _to, uint256 _tokenId) internal {
932     require(_to != address(0));
933     addTokenTo(_to, _tokenId);
934     emit Transfer(address(0), _to, _tokenId);
935   }
936 
937   /**
938    * @dev Internal function to burn a specific token
939    * Reverts if the token does not exist
940    * @param _tokenId uint256 ID of the token being burned by the msg.sender
941    */
942   function _burn(address _owner, uint256 _tokenId) internal {
943     clearApproval(_owner, _tokenId);
944     removeTokenFrom(_owner, _tokenId);
945     emit Transfer(_owner, address(0), _tokenId);
946   }
947 
948   /**
949    * @dev Internal function to clear current approval of a given token ID
950    * Reverts if the given address is not indeed the owner of the token
951    * @param _owner owner of the token
952    * @param _tokenId uint256 ID of the token to be transferred
953    */
954   function clearApproval(address _owner, uint256 _tokenId) internal {
955     require(ownerOf(_tokenId) == _owner);
956     if (tokenApprovals[_tokenId] != address(0)) {
957       tokenApprovals[_tokenId] = address(0);
958     }
959   }
960 
961   /**
962    * @dev Internal function to add a token ID to the list of a given address
963    * @param _to address representing the new owner of the given token ID
964    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
965    */
966   function addTokenTo(address _to, uint256 _tokenId) internal {
967     require(tokenOwner[_tokenId] == address(0));
968     tokenOwner[_tokenId] = _to;
969     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
970   }
971 
972   /**
973    * @dev Internal function to remove a token ID from the list of a given address
974    * @param _from address representing the previous owner of the given token ID
975    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
976    */
977   function removeTokenFrom(address _from, uint256 _tokenId) internal {
978     require(ownerOf(_tokenId) == _from);
979     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
980     tokenOwner[_tokenId] = address(0);
981   }
982 
983   /**
984    * @dev Internal function to invoke `onERC721Received` on a target address
985    * The call is not executed if the target address is not a contract
986    * @param _from address representing the previous owner of the given token ID
987    * @param _to target address that will receive the tokens
988    * @param _tokenId uint256 ID of the token to be transferred
989    * @param _data bytes optional data to send along with the call
990    * @return whether the call correctly returned the expected magic value
991    */
992   function checkAndCallSafeTransfer(
993     address _from,
994     address _to,
995     uint256 _tokenId,
996     bytes _data
997   )
998     internal
999     returns (bool)
1000   {
1001     if (!_to.isContract()) {
1002       return true;
1003     }
1004     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1005       msg.sender, _from, _tokenId, _data);
1006     return (retval == ERC721_RECEIVED);
1007   }
1008 }
1009 
1010 
1011 
1012 
1013 
1014 
1015 /**
1016  * @title SupportsInterfaceWithLookup
1017  * @author Matt Condon (@shrugs)
1018  * @dev Implements ERC165 using a lookup table.
1019  */
1020 
1021 
1022 
1023 contract EtherPornStars is Ownable, SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1024 
1025   struct StarData {
1026       uint16 fieldA;
1027       uint16 fieldB;
1028       uint32 fieldC;
1029       uint32 fieldD;
1030       uint32 fieldE;
1031       uint64 fieldF;
1032       uint64 fieldG;
1033   }
1034 
1035   address public logicContractAddress;
1036   address public starCoinAddress;
1037 
1038   // Ether Porn Star data
1039   mapping(uint256 => StarData) public starData;
1040   mapping(uint256 => bool) public starPower;
1041   mapping(uint256 => uint256) public starStudio;
1042   // Active Ether Porn Star
1043   mapping(address => uint256) public activeStar;
1044   // Mapping to studios
1045   mapping(uint8 => address) public studios;
1046   event ActiveStarChanged(address indexed _from, uint256 _tokenId);
1047   // Token name
1048   string internal name_;
1049   // Token symbol
1050   string internal symbol_;
1051   // Genomes
1052   mapping(uint256 => uint256) public genome;
1053   // Mapping from owner to list of owned token IDs
1054   mapping(address => uint256[]) internal ownedTokens;
1055   // Mapping from token ID to index of the owner tokens list
1056   mapping(uint256 => uint256) internal ownedTokensIndex;
1057   // Array with all token ids, used for enumeration
1058   uint256[] internal allTokens;
1059   // Mapping from token id to position in the allTokens array
1060   mapping(uint256 => uint256) internal allTokensIndex;
1061   // Optional mapping for token URIs
1062   mapping(uint256 => string) internal tokenURIs;
1063    // Mapping for multi-level network rewards
1064   mapping (uint256 => uint256) inviter;
1065   // Emitted when a user buys a star
1066   event BoughtStar(address indexed buyer, uint256 _tokenId, uint8 _studioId );
1067   /**
1068    * @dev Constructor function
1069    */
1070   modifier onlyLogicContract {
1071     require(msg.sender == logicContractAddress || msg.sender == owner);
1072     _;
1073   }
1074   constructor(string _name, string _symbol, address _starCoinAddress) public {
1075     name_ = _name;
1076     symbol_ = _symbol;
1077     starCoinAddress = _starCoinAddress;
1078 
1079     // register the supported interfaces to conform to ERC721 via ERC165
1080     _registerInterface(InterfaceId_ERC721Enumerable);
1081     _registerInterface(InterfaceId_ERC721Metadata);
1082   }
1083 
1084   /**
1085    * @dev Gets the token name
1086    * @return string representing the token name
1087    */
1088 
1089 
1090     /**
1091     * @dev Sets the token's interchangeable logic contract
1092     */
1093   function setLogicContract(address _logicContractAddress) external onlyOwner {
1094     logicContractAddress = _logicContractAddress;
1095   }
1096 
1097   function addStudio(uint8 _studioId, address _studioAddress) external onlyOwner {
1098     studios[_studioId] = _studioAddress;
1099 }
1100   function name() external view returns (string) {
1101     return name_;
1102   }
1103 
1104   /**
1105    * @dev Gets the token symbol
1106    * @return string representing the token symbol
1107    */
1108   function symbol() external view returns (string) {
1109     return symbol_;
1110   }
1111 
1112   /**
1113    * @dev Returns an URI for a given token ID
1114    * Throws if the token ID does not exist. May return an empty string.
1115    * @param _tokenId uint256 ID of the token to query
1116    */
1117   function tokenURI(uint256 _tokenId) public view returns (string) {
1118     require(_exists(_tokenId));
1119     return tokenURIs[_tokenId];
1120   }
1121 
1122   /**
1123    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1124    * @param _owner address owning the tokens list to be accessed
1125    * @param _index uint256 representing the index to be accessed of the requested tokens list
1126    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1127    */
1128   function tokenOfOwnerByIndex(
1129     address _owner,
1130     uint256 _index
1131   )
1132     public
1133     view
1134     returns (uint256)
1135   {
1136     require(_index < balanceOf(_owner));
1137     return ownedTokens[_owner][_index];
1138   }
1139 
1140   /**
1141    * @dev Gets the total amount of tokens stored by the contract
1142    * @return uint256 representing the total amount of tokens
1143    */
1144   function totalSupply() public view returns (uint256) {
1145     return allTokens.length;
1146   }
1147 
1148   /**
1149    * @dev Gets the token ID at a given index of all the tokens in this contract
1150    * Reverts if the index is greater or equal to the total number of tokens
1151    * @param _index uint256 representing the index to be accessed of the tokens list
1152    * @return uint256 token ID at the given index of the tokens list
1153    */
1154   function tokenByIndex(uint256 _index) public view returns (uint256) {
1155     require(_index < totalSupply());
1156     return allTokens[_index];
1157   }
1158 
1159   /**
1160    * @dev Internal function to set the token URI for a given token
1161    * Reverts if the token ID does not exist
1162    * @param _tokenId uint256 ID of the token to set its URI
1163    * @param _uri string URI to assign
1164    */
1165   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1166     require(_exists(_tokenId));
1167     tokenURIs[_tokenId] = _uri;
1168   }
1169 
1170   /**
1171    * @dev Internal function to add a token ID to the list of a given address
1172    * @param _to address representing the new owner of the given token ID
1173    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1174    */
1175   function addTokenTo(address _to, uint256 _tokenId) internal {
1176     super.addTokenTo(_to, _tokenId);
1177     uint256 length = ownedTokens[_to].length;
1178     ownedTokens[_to].push(_tokenId);
1179     ownedTokensIndex[_tokenId] = length;
1180 
1181     if (activeStar[_to] == 0) {
1182       activeStar[_to] = _tokenId;
1183       emit ActiveStarChanged(_to, _tokenId);
1184     }
1185   }
1186 
1187   /**
1188    * @dev Internal function to remove a token ID from the list of a given address
1189    * @param _from address representing the previous owner of the given token ID
1190    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1191    */
1192   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1193     super.removeTokenFrom(_from, _tokenId);
1194     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1195     // then delete the last slot.
1196     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1197     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1198     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1199     ownedTokens[_from][tokenIndex] = lastToken;
1200     // This also deletes the contents at the last position of the array
1201     ownedTokens[_from].length--;
1202     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1203     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1204     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1205     ownedTokensIndex[_tokenId] = 0;
1206     ownedTokensIndex[lastToken] = tokenIndex;
1207   }
1208 
1209   /**
1210    * @dev Internal function to mint a new token
1211    * Reverts if the given token ID already exists
1212    * @param _to address the beneficiary that will own the minted token
1213    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1214    */
1215   function _mint(address _to, uint256 _tokenId) internal {
1216     super._mint(_to, _tokenId);
1217     allTokensIndex[_tokenId] = allTokens.length;
1218     allTokens.push(_tokenId);
1219   }
1220 
1221   function mint(address _to, uint256 _tokenId) external onlyLogicContract {
1222     _mint(_to, _tokenId);
1223   }
1224   /**
1225    * @dev Internal function to burn a specific token
1226    * Reverts if the token does not exist
1227    * @param _owner owner of the token to burn
1228    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1229    */
1230   function _burn(address _owner, uint256 _tokenId) internal {
1231     super._burn(_owner, _tokenId);
1232     // Clear metadata (if any)
1233     if (bytes(tokenURIs[_tokenId]).length != 0) {
1234       delete tokenURIs[_tokenId];
1235     }
1236     // Reorg all tokens array
1237     uint256 tokenIndex = allTokensIndex[_tokenId];
1238     uint256 lastTokenIndex = allTokens.length.sub(1);
1239     uint256 lastToken = allTokens[lastTokenIndex];
1240 
1241     allTokens[tokenIndex] = lastToken;
1242     allTokens[lastTokenIndex] = 0;
1243 
1244     allTokens.length--;
1245     allTokensIndex[_tokenId] = 0;
1246     allTokensIndex[lastToken] = tokenIndex;
1247   }
1248 
1249   function burn(address _owner, uint256 _tokenId) external onlyLogicContract {
1250     _burn(_owner, _tokenId);
1251 }
1252 
1253 /**
1254     * @dev Allows setting star data for a star
1255     * @param _tokenId star to set data for
1256     */
1257   function setStarData(
1258       uint256 _tokenId,
1259       uint16 _fieldA,
1260       uint16 _fieldB,
1261       uint32 _fieldC,
1262       uint32 _fieldD,
1263       uint32 _fieldE,
1264       uint64 _fieldF,
1265       uint64 _fieldG
1266   ) external onlyLogicContract {
1267       starData[_tokenId] = StarData(
1268           _fieldA,
1269           _fieldB,
1270           _fieldC,
1271           _fieldD,
1272           _fieldE,
1273           _fieldF,
1274           _fieldG
1275       );
1276   }
1277     /**
1278     * @dev Allow setting star genome
1279     * @param _tokenId token to set data for
1280     * @param _genome genome data to set
1281     */
1282   function setGenome(uint256 _tokenId, uint256 _genome) external onlyLogicContract {
1283     genome[_tokenId] = _genome;
1284   }
1285 
1286   function activeStarGenome(address _owner) public view returns (uint256) {
1287     uint256 tokenId = activeStar[_owner];
1288     if (tokenId == 0) {
1289         return 0;
1290     }
1291     return genome[tokenId];
1292     }
1293 
1294   function setActiveStar(uint256 _tokenId) external {
1295     require(msg.sender == ownerOf(_tokenId));
1296     activeStar[msg.sender] = _tokenId;
1297     emit ActiveStarChanged(msg.sender, _tokenId);
1298     }
1299 
1300   function forceTransfer(address _from, address _to, uint256 _tokenId) external onlyLogicContract {
1301       require(_from != address(0));
1302       require(_to != address(0));
1303       removeTokenFrom(_from, _tokenId);
1304       addTokenTo(_to, _tokenId);
1305       emit Transfer(_from, _to, _tokenId);
1306   }
1307   function transfer(address _to, uint256 _tokenId) external {
1308     require(msg.sender == ownerOf(_tokenId));
1309     require(_to != address(0));
1310     removeTokenFrom(msg.sender, _tokenId);
1311     addTokenTo(_to, _tokenId);
1312     emit Transfer(msg.sender, _to, _tokenId);
1313     }
1314   function addrecruit(uint256 _recId, uint256 _inviterId) private {
1315     inviter[_recId] = _inviterId;
1316 }
1317   function buyStar(uint256 _tokenId, uint8 _studioId, uint256 _inviterId) external payable {
1318       require(msg.value >= 0.1 ether);
1319       _mint(msg.sender, _tokenId);
1320       emit BoughtStar(msg.sender, _tokenId, _studioId);
1321       uint amount = msg.value;
1322       starCoinAddress.transfer(msg.value);
1323       addrecruit(_tokenId, _inviterId);
1324       starStudio[_tokenId] = _studioId;
1325       StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1326       instanceStarCoin.rewardTokens(msg.sender, amount);
1327         if (_inviterId != 0) {
1328           recReward(amount, _inviterId);
1329       }
1330       if(_studioId == 1) {
1331           starPower[_tokenId] = true;
1332       }
1333     }
1334   function recReward(uint amount, uint256 _inviterId) private {
1335     StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1336     uint i=0;
1337     owner = ownerOf(_inviterId);
1338     amount = amount/2;
1339     instanceStarCoin.rewardTokens(owner, amount);
1340     while (i < 4) {
1341       amount = amount/2;
1342       owner = ownerOf(inviter[_inviterId]);
1343       if(owner==address(0)){
1344         break;
1345       }
1346       instanceStarCoin.rewardTokens(owner, amount);
1347       _inviterId = inviter[_inviterId];
1348       i++;
1349     }
1350   }
1351 
1352   function myTokens()
1353     external
1354     view
1355     returns (
1356       uint256[]
1357     )
1358   {
1359     return ownedTokens[msg.sender];
1360   }
1361 }
1362 
1363 contract NextTopPornStar {
1364 
1365     struct VotersArray0 {
1366         uint voters0;
1367 
1368     }
1369 
1370     struct VotersArray1 {
1371         uint voters1;
1372 
1373     }
1374     using SafeMath for uint256;
1375     bool public roundSwitch; //switch so current and next round balances go to different accounts
1376     address public starCoinAddress;
1377     address public epsAddress;
1378     address public owner;
1379     uint256 public votePrice = 100000000000000000; //.1 StarCoin
1380     uint256 public balance0;
1381     uint256 public balance1;
1382     uint public totalStake;
1383     uint[] public owners;
1384     mapping(uint => VotersArray0[]) public idToVotersArray0;
1385     mapping(uint => VotersArray1[]) public idToVotersArray1;
1386     mapping(uint => uint) public ownershipamt;
1387     event CashedOut(address payee);
1388 
1389     constructor(address _starCoinAddress, address _epsAddress) public {
1390         starCoinAddress = _starCoinAddress;
1391         epsAddress = _epsAddress;
1392         owner = msg.sender;
1393         roundSwitch = false;
1394     }
1395 
1396     function vote (uint _pornstar) public {
1397         EtherPornStars instanceEPS = EtherPornStars(epsAddress);
1398         uint activestar = instanceEPS.activeStar(msg.sender);
1399         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1400         if(roundSwitch == false) {
1401             instanceStarCoin.transferFromStudio(msg.sender,this,votePrice);
1402             idToVotersArray0[_pornstar].push(VotersArray0(activestar));
1403             balance0 = balance0 + votePrice;
1404         } else {             
1405             instanceStarCoin.transferFromStudio(msg.sender,this,votePrice);
1406             idToVotersArray1[_pornstar].push(VotersArray1(activestar));
1407             balance1 = balance1 + votePrice;
1408 
1409         }
1410     }
1411 
1412     
1413     function payoutAndReset0(uint winningPerformer) public {
1414         require(msg.sender == owner);
1415         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1416         EtherPornStars instanceEPS = EtherPornStars(epsAddress);
1417         uint ownersfee = balance0/10;
1418         uint total = balance0 - ownersfee;
1419         for (uint i=0; i < idToVotersArray0[winningPerformer].length; i++) {
1420             address payee = instanceEPS.ownerOf(idToVotersArray0[winningPerformer][i].voters0);
1421             uint share = total.div(idToVotersArray0[winningPerformer].length);
1422             instanceStarCoin.transferFromStudio(this, payee, share);
1423         }
1424         for (uint i1=0; i1 < 12; i1++) {
1425             delete idToVotersArray0[i1];
1426         }
1427         delete balance0;
1428         cashout(ownersfee);
1429     }
1430 
1431     function payoutAndReset1(uint winningPerformer) public {
1432         require(msg.sender == owner);
1433         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1434         EtherPornStars instanceEPS = EtherPornStars(epsAddress);
1435         uint ownersfee = balance1/10;
1436         uint total = balance1 - ownersfee;
1437         for (uint i=0; i < idToVotersArray1[winningPerformer].length; i++) {
1438             address payee = instanceEPS.ownerOf(idToVotersArray1[winningPerformer][i].voters1);
1439             uint share = total.div(idToVotersArray1[winningPerformer].length);
1440             instanceStarCoin.transferFromStudio(this, payee, share);
1441         }
1442         for (uint i1=0; i1 < 12; i1++) {
1443             delete idToVotersArray1[i1];
1444         }
1445         delete balance1;
1446         cashout(ownersfee);
1447     }
1448 
1449     
1450     function buyStake(uint256 _tokens) public {
1451         require(_tokens > 90000000000000000);
1452         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1453         EtherPornStars instanceEPS = EtherPornStars(epsAddress);
1454         uint activestar = instanceEPS.activeStar(msg.sender);
1455         owners.push(activestar);
1456         require(ownershipamt[activestar] == 0);
1457         address buyeradd = instanceEPS.ownerOf(activestar);
1458         require (buyeradd == msg.sender);
1459         instanceStarCoin.buyStudioStake(buyeradd, _tokens);
1460         bool starpower = instanceEPS.starPower(activestar);
1461         if(starpower){
1462             ownershipamt[activestar] = _tokens.mul(105)/100;
1463             totalStake = totalStake + _tokens.mul(105)/100;
1464         } else {
1465             ownershipamt[activestar] = _tokens;
1466             totalStake = totalStake + _tokens;
1467         }
1468         
1469     }
1470         
1471     function cashout(uint _ownersfee) public {
1472         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1473         EtherPornStars instanceEPS = EtherPornStars(epsAddress);
1474         for (uint i=0; i<owners.length; i++) {
1475             uint currstake = (ownershipamt[owners[i]]).mul(100);
1476             currstake = currstake/totalStake;
1477             uint amount = _ownersfee.mul(currstake);
1478             amount = amount/100;
1479             address payee = instanceEPS.ownerOf(owners[i]);
1480             instanceStarCoin.transferFromStudio(this, payee, amount);
1481             emit CashedOut(payee);
1482         }
1483     }
1484     function returnVotes0(uint _pornstar)
1485      constant returns(uint256) {
1486         return idToVotersArray0[_pornstar].length;
1487      }
1488      
1489     function returnVotes1(uint _pornstar)
1490      constant returns(uint256) {
1491         return idToVotersArray1[_pornstar].length;
1492      }
1493      
1494     function getThisBalance()
1495      public constant
1496      returns(uint256) {
1497         StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1498         return instanceStarCoin.balanceOf(this);
1499 }
1500     function returnOwners()
1501      public constant
1502      returns(uint256[]) {
1503      return owners;
1504      }
1505 
1506     function changeSwitch(bool _roundSwitch) public {
1507         require(msg.sender == owner);
1508         roundSwitch = _roundSwitch;
1509     }
1510 }