1 pragma solidity ^0.4.24;
2 
3 //Have an idea for a studio? Email: admin[at]EtherPornStars.com
4 
5 
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   function totalSupply() public view returns (uint256);
13 
14   function balanceOf(address _who) public view returns (uint256);
15 
16   function allowance(address _owner, address _spender)
17     public view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) public returns (bool);
20 
21   function approve(address _spender, uint256 _value)
22     public returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 
42 
43 
44 
45 
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that revert on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, reverts on overflow.
55   */
56   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58     // benefit is lost if 'b' is also tested.
59     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60     if (_a == 0) {
61       return 0;
62     }
63 
64     uint256 c = _a * _b;
65     require(c / _a == _b);
66 
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
72   */
73   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     require(_b > 0); // Solidity only automatically asserts when dividing by 0
75     uint256 c = _a / _b;
76     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
77 
78     return c;
79   }
80 
81   /**
82   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
83   */
84   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
85     require(_b <= _a);
86     uint256 c = _a - _b;
87 
88     return c;
89   }
90 
91   /**
92   * @dev Adds two numbers, reverts on overflow.
93   */
94   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     uint256 c = _a + _b;
96     require(c >= _a);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
103   * reverts when dividing by zero.
104   */
105   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106     require(b != 0);
107     return a % b;
108   }
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
116  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20 {
119   using SafeMath for uint256;
120 
121   mapping (address => uint256) balances;
122 
123   mapping (address => mapping (address => uint256)) allowed;
124 
125   uint256 totalSupply_;
126 
127   /**
128   * @dev Total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256) {
140     return balances[_owner];
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(
150     address _owner,
151     address _spender
152    )
153     public
154     view
155     returns (uint256)
156   {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161   * @dev Transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_value <= balances[msg.sender]);
167     require(_to != address(0));
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
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
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(
197     address _from,
198     address _to,
199     uint256 _value
200   )
201     public
202     returns (bool)
203   {
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206     require(_to != address(0));
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     emit Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint256 _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint256 _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue >= oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Internal function that mints an amount of the token and assigns it to
265    * an account. This encapsulates the modification of balances such that the
266    * proper events are emitted.
267    * @param _account The account that will receive the created tokens.
268    * @param _amount The amount that will be created.
269    */
270   function _mint(address _account, uint256 _amount) internal {
271     require(_account != 0);
272     totalSupply_ = totalSupply_.add(_amount);
273     balances[_account] = balances[_account].add(_amount);
274     emit Transfer(address(0), _account, _amount);
275   }
276 
277   /**
278    * @dev Internal function that burns an amount of the token of a given
279    * account.
280    * @param _account The account whose tokens will be burnt.
281    * @param _amount The amount that will be burnt.
282    */
283   function _burn(address _account, uint256 _amount) internal {
284     require(_account != 0);
285     require(_amount <= balances[_account]);
286 
287     totalSupply_ = totalSupply_.sub(_amount);
288     balances[_account] = balances[_account].sub(_amount);
289     emit Transfer(_account, address(0), _amount);
290   }
291 
292   /**
293    * @dev Internal function that burns an amount of the token of a given
294    * account, deducting from the sender's allowance for said account. Uses the
295    * internal _burn function.
296    * @param _account The account whose tokens will be burnt.
297    * @param _amount The amount that will be burnt.
298    */
299   function _burnFrom(address _account, uint256 _amount) internal {
300     require(_amount <= allowed[_account][msg.sender]);
301 
302     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
303     // this function needs to emit an event with the updated approval.
304     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
305     _burn(_account, _amount);
306   }
307 }
308 
309 /**
310  * @title ERC20 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  *  from ERC20 asset contracts.
313  */
314 
315 /**
316  * @title SafeMath
317  * @dev Math operations with safety checks that revert on error
318  */
319 
320 
321 
322 contract Ownable {
323   address public owner;
324 
325 
326   event OwnershipRenounced(address indexed previousOwner);
327   event OwnershipTransferred(
328     address indexed previousOwner,
329     address indexed newOwner
330   );
331 
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() public {
338     owner = msg.sender;
339   }
340 
341   /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyOwner() {
345     require(msg.sender == owner);
346     _;
347   }
348 }
349 
350 
351 contract StarCoin is Ownable, StandardToken {
352     using SafeMath for uint;
353     address gateway;
354     string public name = "EtherPornStars Coin";
355     string public symbol = "EPS";
356     uint8 public decimals = 18;
357     mapping (uint8 => address) public studioContracts;
358     mapping (address => bool) public isMinter;
359     event Withdrawal(address indexed to, uint256 value);
360     event Burn(address indexed from, uint256 value);
361     modifier onlyMinters {
362       require(msg.sender == owner || isMinter[msg.sender]);
363       _;
364     }
365 
366     constructor () public {
367   }
368   /**
369    * @dev Future sidechain integration for studios.
370    */
371     function setGateway(address _gateway) external onlyOwner {
372         gateway = _gateway;
373     }
374 
375 
376     function _mintTokens(address _user, uint256 _amount) private {
377         require(_user != 0x0);
378         balances[_user] = balances[_user].add(_amount);
379         totalSupply_ = totalSupply_.add(_amount);
380         emit Transfer(address(this), _user, _amount);
381     }
382 
383     function rewardTokens(address _user, uint256 _tokens) external   { 
384         require(msg.sender == owner || isMinter[msg.sender]);
385         _mintTokens(_user, _tokens);
386     }
387     function buyStudioStake(address _user, uint256 _tokens) external   { 
388         require(msg.sender == owner || isMinter[msg.sender]);
389         _burn(_user, _tokens);
390     }
391     function transferFromStudio(
392       address _from,
393       address _to,
394       uint256 _value
395     )
396       external
397       returns (bool)
398     {
399       require(msg.sender == owner || isMinter[msg.sender]);
400       require(_value <= balances[_from]);
401       require(_to != address(0));
402 
403       balances[_from] = balances[_from].sub(_value);
404       balances[_to] = balances[_to].add(_value);
405       emit Transfer(_from, _to, _value);
406       return true;
407   }
408 
409     function() payable public {
410         // Intentionally left empty, for use by studios
411     }
412 
413     function accountAuth(uint256 /*_challenge*/) external {
414         // Does nothing by design
415     }
416 
417     function burn(uint256 _amount) external {
418         require(balances[msg.sender] >= _amount);
419         balances[msg.sender] = balances[msg.sender].sub(_amount);
420         totalSupply_ = totalSupply_.sub(_amount);
421         emit Burn(msg.sender, _amount);
422     }
423 
424     function withdrawBalance(uint _amount) external {
425         require(balances[msg.sender] >= _amount);
426         balances[msg.sender] = balances[msg.sender].sub(_amount);
427         totalSupply_ = totalSupply_.sub(_amount);
428         uint ethexchange = _amount.div(2);
429         msg.sender.transfer(ethexchange);
430     }
431 
432     function setIsMinter(address _address, bool _value) external onlyOwner {
433         isMinter[_address] = _value;
434     }
435 
436     function depositToGateway(uint256 amount) external {
437         transfer(gateway, amount);
438     }
439 }
440 
441 /**
442  * @title ERC165
443  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
444  */
445 interface ERC165 {
446 
447   /**
448    * @notice Query if a contract implements an interface
449    * @param _interfaceId The interface identifier, as specified in ERC-165
450    * @dev Interface identification is specified in ERC-165. This function
451    * uses less than 30,000 gas.
452    */
453   function supportsInterface(bytes4 _interfaceId)
454     external
455     view
456     returns (bool);
457 }
458 
459 contract SupportsInterfaceWithLookup is ERC165 {
460 
461   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
462   /**
463    * 0x01ffc9a7 ===
464    *   bytes4(keccak256('supportsInterface(bytes4)'))
465    */
466 
467   /**
468    * @dev a mapping of interface id to whether or not it's supported
469    */
470   mapping(bytes4 => bool) internal supportedInterfaces;
471 
472   /**
473    * @dev A contract implementing SupportsInterfaceWithLookup
474    * implement ERC165 itself
475    */
476   constructor()
477     public
478   {
479     _registerInterface(InterfaceId_ERC165);
480   }
481 
482   /**
483    * @dev implement supportsInterface(bytes4) using a lookup table
484    */
485   function supportsInterface(bytes4 _interfaceId)
486     external
487     view
488     returns (bool)
489   {
490     return supportedInterfaces[_interfaceId];
491   }
492 
493   /**
494    * @dev private method for registering an interface
495    */
496   function _registerInterface(bytes4 _interfaceId)
497     internal
498   {
499     require(_interfaceId != 0xffffffff);
500     supportedInterfaces[_interfaceId] = true;
501   }
502 }
503 
504 
505 
506 
507 
508 contract StarLogicInterface {
509     function isTransferAllowed(address _from, address _to, uint256 _tokenId) public view returns (bool);
510 }
511 
512 
513 
514 
515 /**
516  * @title ERC721 Non-Fungible Token Standard basic interface
517  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
518  */
519 contract ERC721Basic is ERC165 {
520 
521   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
522   /*
523    * 0x80ac58cd ===
524    *   bytes4(keccak256('balanceOf(address)')) ^
525    *   bytes4(keccak256('ownerOf(uint256)')) ^
526    *   bytes4(keccak256('approve(address,uint256)')) ^
527    *   bytes4(keccak256('getApproved(uint256)')) ^
528    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
529    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
530    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
531    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
532    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
533    */
534 
535   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
536   /**
537    * 0x780e9d63 ===
538    *   bytes4(keccak256('totalSupply()')) ^
539    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
540    *   bytes4(keccak256('tokenByIndex(uint256)'))
541    */
542 
543   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
544   /**
545    * 0x5b5e139f ===
546    *   bytes4(keccak256('name()')) ^
547    *   bytes4(keccak256('symbol()')) ^
548    *   bytes4(keccak256('tokenURI(uint256)'))
549    */
550 
551   event Transfer(
552     address indexed _from,
553     address indexed _to,
554     uint256 indexed _tokenId
555   );
556   event Approval(
557     address indexed _owner,
558     address indexed _approved,
559     uint256 indexed _tokenId
560   );
561   event ApprovalForAll(
562     address indexed _owner,
563     address indexed _operator,
564     bool _approved
565   );
566 
567   function balanceOf(address _owner) public view returns (uint256 _balance);
568   function ownerOf(uint256 _tokenId) public view returns (address _owner);
569 
570   function approve(address _to, uint256 _tokenId) public;
571   function getApproved(uint256 _tokenId)
572     public view returns (address _operator);
573 
574   function setApprovalForAll(address _operator, bool _approved) public;
575   function isApprovedForAll(address _owner, address _operator)
576     public view returns (bool);
577 
578   function transferFrom(address _from, address _to, uint256 _tokenId) public;
579   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
580     public;
581 
582   function safeTransferFrom(
583     address _from,
584     address _to,
585     uint256 _tokenId,
586     bytes _data
587   )
588     public;
589 }
590 
591 
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
595  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
596  */
597 contract ERC721Enumerable is ERC721Basic {
598   function totalSupply() public view returns (uint256);
599   function tokenOfOwnerByIndex(
600     address _owner,
601     uint256 _index
602   )
603     public
604     view
605     returns (uint256 _tokenId);
606 
607   function tokenByIndex(uint256 _index) public view returns (uint256);
608 }
609 
610 
611 /**
612  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
613  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
614  */
615 contract ERC721Metadata is ERC721Basic {
616   function name() external view returns (string _name);
617   function symbol() external view returns (string _symbol);
618   function tokenURI(uint256 _tokenId) public view returns (string);
619 }
620 
621 
622 /**
623  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
624  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
625  */
626 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
627 }
628 
629 
630 
631 
632 /**
633  * @title ERC721 token receiver interface
634  * @dev Interface for any contract that wants to support safeTransfers
635  * from ERC721 asset contracts.
636  */
637 contract ERC721Receiver {
638   /**
639    * @dev Magic value to be returned upon successful reception of an NFT
640    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
641    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
642    */
643   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
644 
645   /**
646    * @notice Handle the receipt of an NFT
647    * @dev The ERC721 smart contract calls this function on the recipient
648    * after a `safetransfer`. This function MAY throw to revert and reject the
649    * transfer. Return of other than the magic value MUST result in the
650    * transaction being reverted.
651    * Note: the contract address is always the message sender.
652    * @param _operator The address which called `safeTransferFrom` function
653    * @param _from The address which previously owned the token
654    * @param _tokenId The NFT identifier which is being transferred
655    * @param _data Additional data with no specified format
656    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
657    */
658   function onERC721Received(
659     address _operator,
660     address _from,
661     uint256 _tokenId,
662     bytes _data
663   )
664     public
665     returns(bytes4);
666 }
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 /**
677  * Utility library of inline functions on addresses
678  */
679 library AddressUtils {
680 
681   /**
682    * Returns whether the target address is a contract
683    * @dev This function will return false if invoked during the constructor of a contract,
684    * as the code is not actually created until after the constructor finishes.
685    * @param _account address of the account to check
686    * @return whether the target address is a contract
687    */
688   function isContract(address _account) internal view returns (bool) {
689     uint256 size;
690     // XXX Currently there is no better way to check if there is a contract in an address
691     // than to check the size of the code at that address.
692     // See https://ethereum.stackexchange.com/a/14016/36603
693     // for more details about how this works.
694     // TODO Check this again before the Serenity release, because all addresses will be
695     // contracts then.
696     // solium-disable-next-line security/no-inline-assembly
697     assembly { size := extcodesize(_account) }
698     return size > 0;
699   }
700 
701 }
702 
703 
704 
705 
706 /**
707  * @title ERC721 Non-Fungible Token Standard basic implementation
708  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
709  */
710 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
711 
712   using SafeMath for uint256;
713   using AddressUtils for address;
714 
715   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
716   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
717   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
718 
719   // Mapping from token ID to owner
720   mapping (uint256 => address) internal tokenOwner;
721 
722   // Mapping from token ID to approved address
723   mapping (uint256 => address) internal tokenApprovals;
724 
725   // Mapping from owner to number of owned token
726   mapping (address => uint256) internal ownedTokensCount;
727 
728   // Mapping from owner to operator approvals
729   mapping (address => mapping (address => bool)) internal operatorApprovals;
730 
731   constructor()
732     public
733   {
734     // register the supported interfaces to conform to ERC721 via ERC165
735     _registerInterface(InterfaceId_ERC721);
736   }
737 
738   /**
739    * @dev Gets the balance of the specified address
740    * @param _owner address to query the balance of
741    * @return uint256 representing the amount owned by the passed address
742    */
743   function balanceOf(address _owner) public view returns (uint256) {
744     require(_owner != address(0));
745     return ownedTokensCount[_owner];
746   }
747 
748   /**
749    * @dev Gets the owner of the specified token ID
750    * @param _tokenId uint256 ID of the token to query the owner of
751    * @return owner address currently marked as the owner of the given token ID
752    */
753   function ownerOf(uint256 _tokenId) public view returns (address) {
754     address owner = tokenOwner[_tokenId];
755     require(owner != address(0));
756     return owner;
757   }
758 
759   /**
760    * @dev Approves another address to transfer the given token ID
761    * The zero address indicates there is no approved address.
762    * There can only be one approved address per token at a given time.
763    * Can only be called by the token owner or an approved operator.
764    * @param _to address to be approved for the given token ID
765    * @param _tokenId uint256 ID of the token to be approved
766    */
767   function approve(address _to, uint256 _tokenId) public {
768     address owner = ownerOf(_tokenId);
769     require(_to != owner);
770     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
771 
772     tokenApprovals[_tokenId] = _to;
773     emit Approval(owner, _to, _tokenId);
774   }
775 
776   /**
777    * @dev Gets the approved address for a token ID, or zero if no address set
778    * @param _tokenId uint256 ID of the token to query the approval of
779    * @return address currently approved for the given token ID
780    */
781   function getApproved(uint256 _tokenId) public view returns (address) {
782     return tokenApprovals[_tokenId];
783   }
784 
785   /**
786    * @dev Sets or unsets the approval of a given operator
787    * An operator is allowed to transfer all tokens of the sender on their behalf
788    * @param _to operator address to set the approval
789    * @param _approved representing the status of the approval to be set
790    */
791   function setApprovalForAll(address _to, bool _approved) public {
792     require(_to != msg.sender);
793     operatorApprovals[msg.sender][_to] = _approved;
794     emit ApprovalForAll(msg.sender, _to, _approved);
795   }
796 
797   /**
798    * @dev Tells whether an operator is approved by a given owner
799    * @param _owner owner address which you want to query the approval of
800    * @param _operator operator address which you want to query the approval of
801    * @return bool whether the given operator is approved by the given owner
802    */
803   function isApprovedForAll(
804     address _owner,
805     address _operator
806   )
807     public
808     view
809     returns (bool)
810   {
811     return operatorApprovals[_owner][_operator];
812   }
813 
814   /**
815    * @dev Transfers the ownership of a given token ID to another address
816    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
817    * Requires the msg sender to be the owner, approved, or operator
818    * @param _from current owner of the token
819    * @param _to address to receive the ownership of the given token ID
820    * @param _tokenId uint256 ID of the token to be transferred
821   */
822   function transferFrom(
823     address _from,
824     address _to,
825     uint256 _tokenId
826   )
827     public
828   {
829     require(isApprovedOrOwner(msg.sender, _tokenId));
830     require(_to != address(0));
831 
832     clearApproval(_from, _tokenId);
833     removeTokenFrom(_from, _tokenId);
834     addTokenTo(_to, _tokenId);
835 
836     emit Transfer(_from, _to, _tokenId);
837   }
838 
839   /**
840    * @dev Safely transfers the ownership of a given token ID to another address
841    * If the target address is a contract, it must implement `onERC721Received`,
842    * which is called upon a safe transfer, and return the magic value
843    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
844    * the transfer is reverted.
845    *
846    * Requires the msg sender to be the owner, approved, or operator
847    * @param _from current owner of the token
848    * @param _to address to receive the ownership of the given token ID
849    * @param _tokenId uint256 ID of the token to be transferred
850   */
851   function safeTransferFrom(
852     address _from,
853     address _to,
854     uint256 _tokenId
855   )
856     public
857   {
858     // solium-disable-next-line arg-overflow
859     safeTransferFrom(_from, _to, _tokenId, "");
860   }
861 
862   /**
863    * @dev Safely transfers the ownership of a given token ID to another address
864    * If the target address is a contract, it must implement `onERC721Received`,
865    * which is called upon a safe transfer, and return the magic value
866    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
867    * the transfer is reverted.
868    * Requires the msg sender to be the owner, approved, or operator
869    * @param _from current owner of the token
870    * @param _to address to receive the ownership of the given token ID
871    * @param _tokenId uint256 ID of the token to be transferred
872    * @param _data bytes data to send along with a safe transfer check
873    */
874   function safeTransferFrom(
875     address _from,
876     address _to,
877     uint256 _tokenId,
878     bytes _data
879   )
880     public
881   {
882     transferFrom(_from, _to, _tokenId);
883     // solium-disable-next-line arg-overflow
884     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
885   }
886 
887   /**
888    * @dev Returns whether the specified token exists
889    * @param _tokenId uint256 ID of the token to query the existence of
890    * @return whether the token exists
891    */
892   function _exists(uint256 _tokenId) internal view returns (bool) {
893     address owner = tokenOwner[_tokenId];
894     return owner != address(0);
895   }
896 
897   /**
898    * @dev Returns whether the given spender can transfer a given token ID
899    * @param _spender address of the spender to query
900    * @param _tokenId uint256 ID of the token to be transferred
901    * @return bool whether the msg.sender is approved for the given token ID,
902    *  is an operator of the owner, or is the owner of the token
903    */
904   function isApprovedOrOwner(
905     address _spender,
906     uint256 _tokenId
907   )
908     internal
909     view
910     returns (bool)
911   {
912     address owner = ownerOf(_tokenId);
913     // Disable solium check because of
914     // https://github.com/duaraghav8/Solium/issues/175
915     // solium-disable-next-line operator-whitespace
916     return (
917       _spender == owner ||
918       getApproved(_tokenId) == _spender ||
919       isApprovedForAll(owner, _spender)
920     );
921   }
922 
923   /**
924    * @dev Internal function to mint a new token
925    * Reverts if the given token ID already exists
926    * @param _to The address that will own the minted token
927    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
928    */
929   function _mint(address _to, uint256 _tokenId) internal {
930     require(_to != address(0));
931     addTokenTo(_to, _tokenId);
932     emit Transfer(address(0), _to, _tokenId);
933   }
934 
935   /**
936    * @dev Internal function to burn a specific token
937    * Reverts if the token does not exist
938    * @param _tokenId uint256 ID of the token being burned by the msg.sender
939    */
940   function _burn(address _owner, uint256 _tokenId) internal {
941     clearApproval(_owner, _tokenId);
942     removeTokenFrom(_owner, _tokenId);
943     emit Transfer(_owner, address(0), _tokenId);
944   }
945 
946   /**
947    * @dev Internal function to clear current approval of a given token ID
948    * Reverts if the given address is not indeed the owner of the token
949    * @param _owner owner of the token
950    * @param _tokenId uint256 ID of the token to be transferred
951    */
952   function clearApproval(address _owner, uint256 _tokenId) internal {
953     require(ownerOf(_tokenId) == _owner);
954     if (tokenApprovals[_tokenId] != address(0)) {
955       tokenApprovals[_tokenId] = address(0);
956     }
957   }
958 
959   /**
960    * @dev Internal function to add a token ID to the list of a given address
961    * @param _to address representing the new owner of the given token ID
962    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
963    */
964   function addTokenTo(address _to, uint256 _tokenId) internal {
965     require(tokenOwner[_tokenId] == address(0));
966     tokenOwner[_tokenId] = _to;
967     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
968   }
969 
970   /**
971    * @dev Internal function to remove a token ID from the list of a given address
972    * @param _from address representing the previous owner of the given token ID
973    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
974    */
975   function removeTokenFrom(address _from, uint256 _tokenId) internal {
976     require(ownerOf(_tokenId) == _from);
977     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
978     tokenOwner[_tokenId] = address(0);
979   }
980 
981   /**
982    * @dev Internal function to invoke `onERC721Received` on a target address
983    * The call is not executed if the target address is not a contract
984    * @param _from address representing the previous owner of the given token ID
985    * @param _to target address that will receive the tokens
986    * @param _tokenId uint256 ID of the token to be transferred
987    * @param _data bytes optional data to send along with the call
988    * @return whether the call correctly returned the expected magic value
989    */
990   function checkAndCallSafeTransfer(
991     address _from,
992     address _to,
993     uint256 _tokenId,
994     bytes _data
995   )
996     internal
997     returns (bool)
998   {
999     if (!_to.isContract()) {
1000       return true;
1001     }
1002     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1003       msg.sender, _from, _tokenId, _data);
1004     return (retval == ERC721_RECEIVED);
1005   }
1006 }
1007 
1008 
1009 
1010 
1011 
1012 
1013 /**
1014  * @title SupportsInterfaceWithLookup
1015  * @author Matt Condon (@shrugs)
1016  * @dev Implements ERC165 using a lookup table.
1017  */
1018 
1019 
1020 
1021 contract EtherPornStars is Ownable, SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1022 
1023   struct StarData {
1024       uint16 fieldA;
1025       uint16 fieldB;
1026       uint32 fieldC;
1027       uint32 fieldD;
1028       uint32 fieldE;
1029       uint64 fieldF;
1030       uint64 fieldG;
1031   }
1032 
1033   address public logicContractAddress;
1034   address public starCoinAddress;
1035 
1036   // Ether Porn Star data
1037   mapping(uint256 => StarData) public starData;
1038   mapping(uint256 => bool) public starPower;
1039   mapping(uint256 => uint256) public starStudio;
1040   // Active Ether Porn Star
1041   mapping(address => uint256) public activeStar;
1042   // Mapping to studios
1043   mapping(uint8 => address) public studios;
1044   event ActiveStarChanged(address indexed _from, uint256 _tokenId);
1045   // Token name
1046   string internal name_;
1047   // Token symbol
1048   string internal symbol_;
1049   // Genomes
1050   mapping(uint256 => uint256) public genome;
1051   // Mapping from owner to list of owned token IDs
1052   mapping(address => uint256[]) internal ownedTokens;
1053   // Mapping from token ID to index of the owner tokens list
1054   mapping(uint256 => uint256) internal ownedTokensIndex;
1055   // Array with all token ids, used for enumeration
1056   uint256[] internal allTokens;
1057   // Mapping from token id to position in the allTokens array
1058   mapping(uint256 => uint256) internal allTokensIndex;
1059   // Optional mapping for token URIs
1060   mapping(uint256 => string) internal tokenURIs;
1061    // Mapping for multi-level network rewards
1062   mapping (uint256 => uint256) inviter;
1063   // Emitted when a user buys a star
1064   event BoughtStar(address indexed buyer, uint256 _tokenId, uint8 _studioId );
1065   /**
1066    * @dev Constructor function
1067    */
1068   modifier onlyLogicContract {
1069     require(msg.sender == logicContractAddress || msg.sender == owner);
1070     _;
1071   }
1072   constructor(string _name, string _symbol, address _starCoinAddress) public {
1073     name_ = _name;
1074     symbol_ = _symbol;
1075     starCoinAddress = _starCoinAddress;
1076 
1077     // register the supported interfaces to conform to ERC721 via ERC165
1078     _registerInterface(InterfaceId_ERC721Enumerable);
1079     _registerInterface(InterfaceId_ERC721Metadata);
1080   }
1081 
1082   /**
1083    * @dev Gets the token name
1084    * @return string representing the token name
1085    */
1086 
1087 
1088     /**
1089     * @dev Sets the token's interchangeable logic contract
1090     */
1091   function setLogicContract(address _logicContractAddress) external onlyOwner {
1092     logicContractAddress = _logicContractAddress;
1093   }
1094 
1095   function addStudio(uint8 _studioId, address _studioAddress) external onlyOwner {
1096     studios[_studioId] = _studioAddress;
1097 }
1098   function name() external view returns (string) {
1099     return name_;
1100   }
1101 
1102   /**
1103    * @dev Gets the token symbol
1104    * @return string representing the token symbol
1105    */
1106   function symbol() external view returns (string) {
1107     return symbol_;
1108   }
1109 
1110   /**
1111    * @dev Returns an URI for a given token ID
1112    * Throws if the token ID does not exist. May return an empty string.
1113    * @param _tokenId uint256 ID of the token to query
1114    */
1115   function tokenURI(uint256 _tokenId) public view returns (string) {
1116     require(_exists(_tokenId));
1117     return tokenURIs[_tokenId];
1118   }
1119 
1120   /**
1121    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1122    * @param _owner address owning the tokens list to be accessed
1123    * @param _index uint256 representing the index to be accessed of the requested tokens list
1124    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1125    */
1126   function tokenOfOwnerByIndex(
1127     address _owner,
1128     uint256 _index
1129   )
1130     public
1131     view
1132     returns (uint256)
1133   {
1134     require(_index < balanceOf(_owner));
1135     return ownedTokens[_owner][_index];
1136   }
1137 
1138   /**
1139    * @dev Gets the total amount of tokens stored by the contract
1140    * @return uint256 representing the total amount of tokens
1141    */
1142   function totalSupply() public view returns (uint256) {
1143     return allTokens.length;
1144   }
1145 
1146   /**
1147    * @dev Gets the token ID at a given index of all the tokens in this contract
1148    * Reverts if the index is greater or equal to the total number of tokens
1149    * @param _index uint256 representing the index to be accessed of the tokens list
1150    * @return uint256 token ID at the given index of the tokens list
1151    */
1152   function tokenByIndex(uint256 _index) public view returns (uint256) {
1153     require(_index < totalSupply());
1154     return allTokens[_index];
1155   }
1156 
1157   /**
1158    * @dev Internal function to set the token URI for a given token
1159    * Reverts if the token ID does not exist
1160    * @param _tokenId uint256 ID of the token to set its URI
1161    * @param _uri string URI to assign
1162    */
1163   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1164     require(_exists(_tokenId));
1165     tokenURIs[_tokenId] = _uri;
1166   }
1167 
1168   /**
1169    * @dev Internal function to add a token ID to the list of a given address
1170    * @param _to address representing the new owner of the given token ID
1171    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1172    */
1173   function addTokenTo(address _to, uint256 _tokenId) internal {
1174     super.addTokenTo(_to, _tokenId);
1175     uint256 length = ownedTokens[_to].length;
1176     ownedTokens[_to].push(_tokenId);
1177     ownedTokensIndex[_tokenId] = length;
1178 
1179     if (activeStar[_to] == 0) {
1180       activeStar[_to] = _tokenId;
1181       emit ActiveStarChanged(_to, _tokenId);
1182     }
1183   }
1184 
1185   /**
1186    * @dev Internal function to remove a token ID from the list of a given address
1187    * @param _from address representing the previous owner of the given token ID
1188    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1189    */
1190   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1191     super.removeTokenFrom(_from, _tokenId);
1192     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1193     // then delete the last slot.
1194     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1195     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1196     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1197     ownedTokens[_from][tokenIndex] = lastToken;
1198     // This also deletes the contents at the last position of the array
1199     ownedTokens[_from].length--;
1200     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1201     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1202     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1203     ownedTokensIndex[_tokenId] = 0;
1204     ownedTokensIndex[lastToken] = tokenIndex;
1205   }
1206 
1207   /**
1208    * @dev Internal function to mint a new token
1209    * Reverts if the given token ID already exists
1210    * @param _to address the beneficiary that will own the minted token
1211    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1212    */
1213   function _mint(address _to, uint256 _tokenId) internal {
1214     super._mint(_to, _tokenId);
1215     allTokensIndex[_tokenId] = allTokens.length;
1216     allTokens.push(_tokenId);
1217   }
1218 
1219   function mint(address _to, uint256 _tokenId) external onlyLogicContract {
1220     _mint(_to, _tokenId);
1221   }
1222   /**
1223    * @dev Internal function to burn a specific token
1224    * Reverts if the token does not exist
1225    * @param _owner owner of the token to burn
1226    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1227    */
1228   function _burn(address _owner, uint256 _tokenId) internal {
1229     super._burn(_owner, _tokenId);
1230     // Clear metadata (if any)
1231     if (bytes(tokenURIs[_tokenId]).length != 0) {
1232       delete tokenURIs[_tokenId];
1233     }
1234     // Reorg all tokens array
1235     uint256 tokenIndex = allTokensIndex[_tokenId];
1236     uint256 lastTokenIndex = allTokens.length.sub(1);
1237     uint256 lastToken = allTokens[lastTokenIndex];
1238 
1239     allTokens[tokenIndex] = lastToken;
1240     allTokens[lastTokenIndex] = 0;
1241 
1242     allTokens.length--;
1243     allTokensIndex[_tokenId] = 0;
1244     allTokensIndex[lastToken] = tokenIndex;
1245   }
1246 
1247   function burn(address _owner, uint256 _tokenId) external onlyLogicContract {
1248     _burn(_owner, _tokenId);
1249 }
1250 
1251 /**
1252     * @dev Allows setting star data for a star
1253     * @param _tokenId star to set data for
1254     */
1255   function setStarData(
1256       uint256 _tokenId,
1257       uint16 _fieldA,
1258       uint16 _fieldB,
1259       uint32 _fieldC,
1260       uint32 _fieldD,
1261       uint32 _fieldE,
1262       uint64 _fieldF,
1263       uint64 _fieldG
1264   ) external onlyLogicContract {
1265       starData[_tokenId] = StarData(
1266           _fieldA,
1267           _fieldB,
1268           _fieldC,
1269           _fieldD,
1270           _fieldE,
1271           _fieldF,
1272           _fieldG
1273       );
1274   }
1275     /**
1276     * @dev Allow setting star genome
1277     * @param _tokenId token to set data for
1278     * @param _genome genome data to set
1279     */
1280   function setGenome(uint256 _tokenId, uint256 _genome) external onlyLogicContract {
1281     genome[_tokenId] = _genome;
1282   }
1283 
1284   function activeStarGenome(address _owner) public view returns (uint256) {
1285     uint256 tokenId = activeStar[_owner];
1286     if (tokenId == 0) {
1287         return 0;
1288     }
1289     return genome[tokenId];
1290     }
1291 
1292   function setActiveStar(uint256 _tokenId) external {
1293     require(msg.sender == ownerOf(_tokenId));
1294     activeStar[msg.sender] = _tokenId;
1295     emit ActiveStarChanged(msg.sender, _tokenId);
1296     }
1297 
1298   function forceTransfer(address _from, address _to, uint256 _tokenId) external onlyLogicContract {
1299       require(_from != address(0));
1300       require(_to != address(0));
1301       removeTokenFrom(_from, _tokenId);
1302       addTokenTo(_to, _tokenId);
1303       emit Transfer(_from, _to, _tokenId);
1304   }
1305   function transfer(address _to, uint256 _tokenId) external {
1306     require(msg.sender == ownerOf(_tokenId));
1307     require(_to != address(0));
1308     removeTokenFrom(msg.sender, _tokenId);
1309     addTokenTo(_to, _tokenId);
1310     emit Transfer(msg.sender, _to, _tokenId);
1311     }
1312   function addrecruit(uint256 _recId, uint256 _inviterId) private {
1313     inviter[_recId] = _inviterId;
1314 }
1315   function buyStar(uint256 _tokenId, uint8 _studioId, uint256 _inviterId) external payable {
1316       require(msg.value >= 0.1 ether);
1317       _mint(msg.sender, _tokenId);
1318       emit BoughtStar(msg.sender, _tokenId, _studioId);
1319       uint amount = msg.value;
1320       starCoinAddress.transfer(msg.value);
1321       addrecruit(_tokenId, _inviterId);
1322       starStudio[_tokenId] = _studioId;
1323       StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1324       instanceStarCoin.rewardTokens(msg.sender, amount);
1325         if (_inviterId != 0) {
1326           recReward(amount, _inviterId);
1327       }
1328       if(_studioId == 1) {
1329           starPower[_tokenId] = true;
1330       }
1331     }
1332   function recReward(uint amount, uint256 _inviterId) private {
1333     StarCoin instanceStarCoin = StarCoin(starCoinAddress);
1334     uint i=0;
1335     owner = ownerOf(_inviterId);
1336     amount = amount/2;
1337     instanceStarCoin.rewardTokens(owner, amount);
1338     while (i < 4) {
1339       amount = amount/2;
1340       owner = ownerOf(inviter[_inviterId]);
1341       if(owner==address(0)){
1342         break;
1343       }
1344       instanceStarCoin.rewardTokens(owner, amount);
1345       _inviterId = inviter[_inviterId];
1346       i++;
1347     }
1348   }
1349 
1350   function myTokens()
1351     external
1352     view
1353     returns (
1354       uint256[]
1355     )
1356   {
1357     return ownedTokens[msg.sender];
1358   }
1359 }