1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: registry/contracts/Registry.sol
31 
32 contract Registry {
33     struct AttributeData {
34         uint256 value;
35         bytes32 notes;
36         address adminAddr;
37         uint256 timestamp;
38     }
39     
40     address public owner;
41     address public pendingOwner;
42     bool public initialized;
43 
44     // Stores arbitrary attributes for users. An example use case is an ERC20
45     // token that requires its users to go through a KYC/AML check - in this case
46     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
47     // that account can use the token. This mapping stores that value (1, in the
48     // example) as well as which validator last set the value and at what time,
49     // so that e.g. the check can be renewed at appropriate intervals.
50     mapping(address => mapping(bytes32 => AttributeData)) public attributes;
51     // The logic governing who is allowed to set what attributes is abstracted as
52     // this accessManager, so that it may be replaced by the owner as needed
53 
54     bytes32 public constant WRITE_PERMISSION = keccak256("canWriteTo-");
55     bytes32 public constant IS_BLACKLISTED = "isBlacklisted";
56     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
57     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
58     bytes32 public constant HAS_PASSED_KYC_AML = "hasPassedKYC/AML";
59     bytes32 public constant CAN_BURN = "canBurn";
60 
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
66     event SetManager(address indexed oldManager, address indexed newManager);
67 
68 
69     function initialize() public {
70         require(!initialized, "already initialized");
71         owner = msg.sender;
72         initialized = true;
73     }
74 
75     function writeAttributeFor(bytes32 _attribute) public pure returns (bytes32) {
76         return keccak256(WRITE_PERMISSION ^ _attribute);
77     }
78 
79     // Allows a write if either a) the writer is that Registry's owner, or
80     // b) the writer is writing to attribute foo and that writer already has
81     // the canWriteTo-foo attribute set (in that same Registry)
82     function confirmWrite(bytes32 _attribute, address _admin) public view returns (bool) {
83         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
84     }
85 
86     // Writes are allowed only if the accessManager approves
87     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
88         require(confirmWrite(_attribute, msg.sender));
89         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
90         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
91     }
92 
93     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
94         require(confirmWrite(_attribute, msg.sender));
95         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
96         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
97     }
98 
99     // Returns true if the uint256 value stored for this attribute is non-zero
100     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
101         return attributes[_who][_attribute].value != 0;
102     }
103 
104     function hasBothAttributes(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
105         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value != 0;
106     }
107 
108     function hasEitherAttribute(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
109         return attributes[_who][_attribute1].value != 0 || attributes[_who][_attribute2].value != 0;
110     }
111 
112     function hasAttribute1ButNotAttribute2(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
113         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value == 0;
114     }
115 
116     function bothHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
117         return attributes[_who1][_attribute].value != 0 && attributes[_who2][_attribute].value != 0;
118     }
119     
120     function eitherHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
121         return attributes[_who1][_attribute].value != 0 || attributes[_who2][_attribute].value != 0;
122     }
123 
124     function haveAttributes(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
125         return attributes[_who1][_attribute1].value != 0 && attributes[_who2][_attribute2].value != 0;
126     }
127 
128     function haveEitherAttribute(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
129         return attributes[_who1][_attribute1].value != 0 || attributes[_who2][_attribute2].value != 0;
130     }
131 
132     function isDepositAddress(address _who) public view returns (bool) {
133         return attributes[address(uint256(_who) >> 20)][IS_DEPOSIT_ADDRESS].value != 0;
134     }
135 
136     function getDepositAddress(address _who) public view returns (address) {
137         return address(attributes[address(uint256(_who) >> 20)][IS_DEPOSIT_ADDRESS].value);
138     }
139 
140     function requireCanTransfer(address _from, address _to) public view returns (address, bool) {
141         require (attributes[_from][IS_BLACKLISTED].value == 0, "blacklisted");
142         uint256 depositAddressValue = attributes[address(uint256(_to) >> 20)][IS_DEPOSIT_ADDRESS].value;
143         if (depositAddressValue != 0) {
144             _to = address(depositAddressValue);
145         }
146         require (attributes[_to][IS_BLACKLISTED].value == 0, "blacklisted");
147         return (_to, attributes[_to][IS_REGISTERED_CONTRACT].value != 0);
148     }
149 
150     function requireCanTransferFrom(address _sender, address _from, address _to) public view returns (address, bool) {
151         require (attributes[_sender][IS_BLACKLISTED].value == 0, "blacklisted");
152         return requireCanTransfer(_from, _to);
153     }
154 
155     function requireCanMint(address _to) public view returns (address, bool) {
156         require (attributes[_to][HAS_PASSED_KYC_AML].value != 0);
157         require (attributes[_to][IS_BLACKLISTED].value == 0, "blacklisted");
158         uint256 depositAddressValue = attributes[address(uint256(_to) >> 20)][IS_DEPOSIT_ADDRESS].value;
159         if (depositAddressValue != 0) {
160             _to = address(depositAddressValue);
161         }
162         return (_to, attributes[_to][IS_REGISTERED_CONTRACT].value != 0);
163     }
164 
165     function requireCanBurn(address _from) public view {
166         require (attributes[_from][CAN_BURN].value != 0);
167         require (attributes[_from][IS_BLACKLISTED].value == 0);
168     }
169 
170     // Returns the exact value of the attribute, as well as its metadata
171     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
172         AttributeData memory data = attributes[_who][_attribute];
173         return (data.value, data.notes, data.adminAddr, data.timestamp);
174     }
175 
176     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
177         return attributes[_who][_attribute].value;
178     }
179 
180     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
181         return attributes[_who][_attribute].adminAddr;
182     }
183 
184     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
185         return attributes[_who][_attribute].timestamp;
186     }
187 
188     function reclaimEther(address _to) external onlyOwner {
189         _to.transfer(address(this).balance);
190     }
191 
192     function reclaimToken(ERC20 token, address _to) external onlyOwner {
193         uint256 balance = token.balanceOf(this);
194         token.transfer(_to, balance);
195     }
196 
197     /**
198     * @dev sets the original `owner` of the contract to the sender
199     * at construction. Must then be reinitialized 
200     */
201     constructor() public {
202         owner = msg.sender;
203         emit OwnershipTransferred(address(0), owner);
204     }
205 
206     /**
207     * @dev Throws if called by any account other than the owner.
208     */
209     modifier onlyOwner() {
210         require(msg.sender == owner, "only Owner");
211         _;
212     }
213 
214     /**
215     * @dev Modifier throws if called by any account other than the pendingOwner.
216     */
217     modifier onlyPendingOwner() {
218         require(msg.sender == pendingOwner);
219         _;
220     }
221 
222     /**
223     * @dev Allows the current owner to set the pendingOwner address.
224     * @param newOwner The address to transfer ownership to.
225     */
226     function transferOwnership(address newOwner) public onlyOwner {
227         pendingOwner = newOwner;
228     }
229 
230     /**
231     * @dev Allows the pendingOwner address to finalize the transfer.
232     */
233     function claimOwnership() public onlyPendingOwner {
234         emit OwnershipTransferred(owner, pendingOwner);
235         owner = pendingOwner;
236         pendingOwner = address(0);
237     }
238 }
239 
240 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
241 
242 /**
243  * @title Ownable
244  * @dev The Ownable contract has an owner address, and provides basic authorization control
245  * functions, this simplifies the implementation of "user permissions".
246  */
247 contract Ownable {
248   address public owner;
249 
250 
251   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253 
254   /**
255    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256    * account.
257    */
258   function Ownable() public {
259     owner = msg.sender;
260   }
261 
262   /**
263    * @dev Throws if called by any account other than the owner.
264    */
265   modifier onlyOwner() {
266     require(msg.sender == owner);
267     _;
268   }
269 
270   /**
271    * @dev Allows the current owner to transfer control of the contract to a newOwner.
272    * @param newOwner The address to transfer ownership to.
273    */
274   function transferOwnership(address newOwner) public onlyOwner {
275     require(newOwner != address(0));
276     emit OwnershipTransferred(owner, newOwner);
277     owner = newOwner;
278   }
279 
280 }
281 
282 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
283 
284 /**
285  * @title Claimable
286  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
287  * This allows the new owner to accept the transfer.
288  */
289 contract Claimable is Ownable {
290   address public pendingOwner;
291 
292   /**
293    * @dev Modifier throws if called by any account other than the pendingOwner.
294    */
295   modifier onlyPendingOwner() {
296     require(msg.sender == pendingOwner);
297     _;
298   }
299 
300   /**
301    * @dev Allows the current owner to set the pendingOwner address.
302    * @param newOwner The address to transfer ownership to.
303    */
304   function transferOwnership(address newOwner) onlyOwner public {
305     pendingOwner = newOwner;
306   }
307 
308   /**
309    * @dev Allows the pendingOwner address to finalize the transfer.
310    */
311   function claimOwnership() onlyPendingOwner public {
312     emit OwnershipTransferred(owner, pendingOwner);
313     owner = pendingOwner;
314     pendingOwner = address(0);
315   }
316 }
317 
318 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
319 
320 /**
321  * @title SafeMath
322  * @dev Math operations with safety checks that throw on error
323  */
324 library SafeMath {
325 
326   /**
327   * @dev Multiplies two numbers, throws on overflow.
328   */
329   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
330     if (a == 0) {
331       return 0;
332     }
333     c = a * b;
334     assert(c / a == b);
335     return c;
336   }
337 
338   /**
339   * @dev Integer division of two numbers, truncating the quotient.
340   */
341   function div(uint256 a, uint256 b) internal pure returns (uint256) {
342     // assert(b > 0); // Solidity automatically throws when dividing by 0
343     // uint256 c = a / b;
344     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
345     return a / b;
346   }
347 
348   /**
349   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
350   */
351   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
352     assert(b <= a);
353     return a - b;
354   }
355 
356   /**
357   * @dev Adds two numbers, throws on overflow.
358   */
359   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
360     c = a + b;
361     assert(c >= a);
362     return c;
363   }
364 }
365 
366 // File: contracts/modularERC20/BalanceSheet.sol
367 
368 // A wrapper around the balanceOf mapping.
369 contract BalanceSheet is Claimable {
370     using SafeMath for uint256;
371 
372     mapping (address => uint256) public balanceOf;
373 
374     function addBalance(address _addr, uint256 _value) public onlyOwner {
375         balanceOf[_addr] = balanceOf[_addr].add(_value);
376     }
377 
378     function subBalance(address _addr, uint256 _value) public onlyOwner {
379         balanceOf[_addr] = balanceOf[_addr].sub(_value);
380     }
381 
382     function setBalance(address _addr, uint256 _value) public onlyOwner {
383         balanceOf[_addr] = _value;
384     }
385 }
386 
387 // File: contracts/modularERC20/AllowanceSheet.sol
388 
389 // A wrapper around the allowanceOf mapping.
390 contract AllowanceSheet is Claimable {
391     using SafeMath for uint256;
392 
393     mapping (address => mapping (address => uint256)) public allowanceOf;
394 
395     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
396         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
397     }
398 
399     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
400         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
401     }
402 
403     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
404         allowanceOf[_tokenHolder][_spender] = _value;
405     }
406 }
407 
408 // File: contracts/ProxyStorage.sol
409 
410 /*
411 Defines the storage layout of the implementaiton (UniversalUSD) contract. Any newly declared 
412 state variables in future upgrades should be appened to the bottom. Never remove state variables
413 from this list
414  */
415 contract ProxyStorage {
416     address public owner;
417     address public pendingOwner;
418 
419     bool public initialized;
420     
421     BalanceSheet public balances;
422     AllowanceSheet public allowances;
423 
424     uint256 totalSupply_;
425     
426     bool private paused_Deprecated = false;
427     address private globalPause_Deprecated;
428 
429     uint256 public burnMin = 0;
430     uint256 public burnMax = 0;
431 
432     Registry public registry;
433 
434     string public name = "UniversalUSD";
435     string public symbol = "UUSD";
436 
437     uint[] public gasRefundPool;
438     uint256 private redemptionAddressCount_Deprecated;
439     uint256 public minimumGasPriceForFutureRefunds;
440 }
441 
442 // File: contracts/HasOwner.sol
443 
444 /**
445  * @title HasOwner
446  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
447  and provides basic authorization control functions. Inherits storage layout of 
448  ProxyStorage.
449  */
450 contract HasOwner is ProxyStorage {
451 
452     event OwnershipTransferred(
453         address indexed previousOwner,
454         address indexed newOwner
455     );
456 
457     /**
458     * @dev sets the original `owner` of the contract to the sender
459     * at construction. Must then be reinitialized 
460     */
461     constructor() public {
462         owner = msg.sender;
463         emit OwnershipTransferred(address(0), owner);
464     }
465 
466     /**
467     * @dev Throws if called by any account other than the owner.
468     */
469     modifier onlyOwner() {
470         require(msg.sender == owner, "only Owner");
471         _;
472     }
473 
474     /**
475     * @dev Modifier throws if called by any account other than the pendingOwner.
476     */
477     modifier onlyPendingOwner() {
478         require(msg.sender == pendingOwner);
479         _;
480     }
481 
482     /**
483     * @dev Allows the current owner to set the pendingOwner address.
484     * @param newOwner The address to transfer ownership to.
485     */
486     function transferOwnership(address newOwner) public onlyOwner {
487         pendingOwner = newOwner;
488     }
489 
490     /**
491     * @dev Allows the pendingOwner address to finalize the transfer.
492     */
493     function claimOwnership() public onlyPendingOwner {
494         emit OwnershipTransferred(owner, pendingOwner);
495         owner = pendingOwner;
496         pendingOwner = address(0);
497     }
498 }
499 
500 // File: contracts/modularERC20/ModularBasicToken.sol
501 
502 // Version of OpenZeppelin's BasicToken whose balances mapping has been replaced
503 // with a separate BalanceSheet contract. remove the need to copy over balances.
504 /**
505  * @title Basic token
506  * @dev Basic version of StandardToken, with no allowances.
507  */
508 contract ModularBasicToken is HasOwner {
509     using SafeMath for uint256;
510 
511     event BalanceSheetSet(address indexed sheet);
512     event Transfer(address indexed from, address indexed to, uint256 value);
513 
514     /**
515     * @dev claim ownership of the balancesheet contract
516     * @param _sheet The address to of the balancesheet to claim.
517     */
518     function setBalanceSheet(address _sheet) public onlyOwner returns (bool) {
519         balances = BalanceSheet(_sheet);
520         balances.claimOwnership();
521         emit BalanceSheetSet(_sheet);
522         return true;
523     }
524 
525     /**
526     * @dev total number of tokens in existence
527     */
528     function totalSupply() public view returns (uint256) {
529         return totalSupply_;
530     }
531 
532     /**
533     * @dev transfer token for a specified address
534     * @param _to The address to transfer to.
535     * @param _value The amount to be transferred.
536     */
537     function transfer(address _to, uint256 _value) public returns (bool) {
538         _transferAllArgs(msg.sender, _to, _value);
539         return true;
540     }
541 
542 
543     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
544         // SafeMath.sub will throw if there is not enough balance.
545         balances.subBalance(_from, _value);
546         balances.addBalance(_to, _value);
547         emit Transfer(_from, _to, _value);
548     }
549     
550 
551     /**
552     * @dev Gets the balance of the specified address.
553     * @param _owner The address to query the the balance of.
554     * @return An uint256 representing the amount owned by the passed address.
555     */
556     function balanceOf(address _owner) public view returns (uint256 balance) {
557         return balances.balanceOf(_owner);
558     }
559 }
560 
561 // File: contracts/modularERC20/ModularStandardToken.sol
562 
563 /**
564  * @title Standard ERC20 token
565  *
566  * @dev Implementation of the basic standard token.
567  * @dev https://github.com/ethereum/EIPs/issues/20
568  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
569  */
570 contract ModularStandardToken is ModularBasicToken {
571     
572     event AllowanceSheetSet(address indexed sheet);
573     event Approval(address indexed owner, address indexed spender, uint256 value);
574     
575     /**
576     * @dev claim ownership of the AllowanceSheet contract
577     * @param _sheet The address to of the AllowanceSheet to claim.
578     */
579     function setAllowanceSheet(address _sheet) public onlyOwner returns(bool) {
580         allowances = AllowanceSheet(_sheet);
581         allowances.claimOwnership();
582         emit AllowanceSheetSet(_sheet);
583         return true;
584     }
585 
586     /**
587      * @dev Transfer tokens from one address to another
588      * @param _from address The address which you want to send tokens from
589      * @param _to address The address which you want to transfer to
590      * @param _value uint256 the amount of tokens to be transferred
591      */
592     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
593         _transferFromAllArgs(_from, _to, _value, msg.sender);
594         return true;
595     }
596 
597     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
598         _transferAllArgs(_from, _to, _value);
599         allowances.subAllowance(_from, _spender, _value);
600     }
601 
602     /**
603      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
604      *
605      * Beware that changing an allowance with this method brings the risk that someone may use both the old
606      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
607      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
608      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
609      * @param _spender The address which will spend the funds.
610      * @param _value The amount of tokens to be spent.
611      */
612     function approve(address _spender, uint256 _value) public returns (bool) {
613         _approveAllArgs(_spender, _value, msg.sender);
614         return true;
615     }
616 
617     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
618         allowances.setAllowance(_tokenHolder, _spender, _value);
619         emit Approval(_tokenHolder, _spender, _value);
620     }
621 
622     /**
623      * @dev Function to check the amount of tokens that an owner allowed to a spender.
624      * @param _owner address The address which owns the funds.
625      * @param _spender address The address which will spend the funds.
626      * @return A uint256 specifying the amount of tokens still available for the spender.
627      */
628     function allowance(address _owner, address _spender) public view returns (uint256) {
629         return allowances.allowanceOf(_owner, _spender);
630     }
631 
632     /**
633      * @dev Increase the amount of tokens that an owner allowed to a spender.
634      *
635      * approve should be called when allowed[_spender] == 0. To increment
636      * allowed value is better to use this function to avoid 2 calls (and wait until
637      * the first transaction is mined)
638      * From MonolithDAO Token.sol
639      * @param _spender The address which will spend the funds.
640      * @param _addedValue The amount of tokens to increase the allowance by.
641      */
642     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
643         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
644         return true;
645     }
646 
647     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
648         allowances.addAllowance(_tokenHolder, _spender, _addedValue);
649         emit Approval(_tokenHolder, _spender, allowances.allowanceOf(_tokenHolder, _spender));
650     }
651 
652     /**
653      * @dev Decrease the amount of tokens that an owner allowed to a spender.
654      *
655      * approve should be called when allowed[_spender] == 0. To decrement
656      * allowed value is better to use this function to avoid 2 calls (and wait until
657      * the first transaction is mined)
658      * From MonolithDAO Token.sol
659      * @param _spender The address which will spend the funds.
660      * @param _subtractedValue The amount of tokens to decrease the allowance by.
661      */
662     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
663         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
664         return true;
665     }
666 
667     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
668         uint256 oldValue = allowances.allowanceOf(_tokenHolder, _spender);
669         if (_subtractedValue > oldValue) {
670             allowances.setAllowance(_tokenHolder, _spender, 0);
671         } else {
672             allowances.subAllowance(_tokenHolder, _spender, _subtractedValue);
673         }
674         emit Approval(_tokenHolder,_spender, allowances.allowanceOf(_tokenHolder, _spender));
675     }
676 }
677 
678 // File: contracts/modularERC20/ModularBurnableToken.sol
679 
680 /**
681  * @title Burnable Token
682  * @dev Token that can be irreversibly burned (destroyed).
683  */
684 contract ModularBurnableToken is ModularStandardToken {
685     event Burn(address indexed burner, uint256 value);
686 
687     /**
688      * @dev Burns a specific amount of tokens.
689      * @param _value The amount of token to be burned.
690      */
691     function burn(uint256 _value) public {
692         _burnAllArgs(msg.sender, _value);
693     }
694 
695     function _burnAllArgs(address _burner, uint256 _value) internal {
696         // no need to require value <= totalSupply, since that would imply the
697         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
698         /* uint burnAmount = _value / (10 **16) * (10 **16); */
699         balances.subBalance(_burner, _value);
700         totalSupply_ = totalSupply_.sub(_value);
701         emit Burn(_burner, _value);
702         emit Transfer(_burner, address(0), _value);
703     }
704 }
705 
706 // File: contracts/modularERC20/ModularMintableToken.sol
707 
708 /**
709  * @title Mintable token
710  * @dev Simple ERC20 Token example, with mintable token creation
711  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
712  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
713  */
714 contract ModularMintableToken is ModularBurnableToken {
715     event Mint(address indexed to, uint256 value);
716 
717     /**
718      * @dev Function to mint tokens
719      * @param _to The address that will receive the minted tokens.
720      * @param _value The amount of tokens to mint.
721      * @return A boolean that indicates if the operation was successful.
722      */
723     function mint(address _to, uint256 _value) public onlyOwner {
724         require(_to != address(0), "to address cannot be zero");
725         totalSupply_ = totalSupply_.add(_value);
726         balances.addBalance(_to, _value);
727         emit Mint(_to, _value);
728         emit Transfer(address(0), _to, _value);
729     }
730 }
731 
732 // File: contracts/BurnableTokenWithBounds.sol
733 
734 /**
735  * @title Burnable Token WithBounds
736  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
737  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
738  */
739 contract BurnableTokenWithBounds is ModularMintableToken {
740 
741     event SetBurnBounds(uint256 newMin, uint256 newMax);
742 
743     function _burnAllArgs(address _burner, uint256 _value) internal {
744         require(_value >= burnMin, "below min burn bound");
745         require(_value <= burnMax, "exceeds max burn bound");
746         super._burnAllArgs(_burner, _value);
747     }
748 
749     //Change the minimum and maximum amount that can be burned at once. Burning
750     //may be disabled by setting both to 0 (this will not be done under normal
751     //operation, but we can't add checks to disallow it without losing a lot of
752     //flexibility since burning could also be as good as disabled
753     //by setting the minimum extremely high, and we don't want to lock
754     //in any particular cap for the minimum)
755     function setBurnBounds(uint256 _min, uint256 _max) public onlyOwner {
756         require(_min <= _max, "min > max");
757         burnMin = _min;
758         burnMax = _max;
759         emit SetBurnBounds(_min, _max);
760     }
761 }
762 
763 // File: contracts/CompliantToken.sol
764 
765 contract CompliantToken is ModularMintableToken {
766     // In order to deposit USD and receive newly minted UniversalUSD, or to burn UniversalUSD to
767     // redeem it for USD, users must first go through a KYC/AML check (which includes proving they
768     // control their ethereum address using AddressValidation.sol).
769     bytes32 public constant HAS_PASSED_KYC_AML = "hasPassedKYC/AML";
770     // Redeeming ("burning") UniversalUSD tokens for USD requires a separate flag since
771     // users must not only be KYC/AML'ed but must also have bank information on file.
772     bytes32 public constant CAN_BURN = "canBurn";
773     // Addresses can also be blacklisted, preventing them from sending or receiving
774     // UniversalUSD. This can be used to prevent the use of UniversalUSD by bad actors in
775     // accordance with law enforcement. See [TrueCoin Terms of Use](https://www.trusttoken.com/UniversalUSD/terms-of-use)
776     bytes32 public constant IS_BLACKLISTED = "isBlacklisted";
777 
778     event WipeBlacklistedAccount(address indexed account, uint256 balance);
779     event SetRegistry(address indexed registry);
780     
781     /**
782     * @dev Point to the registry that contains all compliance related data
783     @param _registry The address of the registry instance
784     */
785     function setRegistry(Registry _registry) public onlyOwner {
786         registry = _registry;
787         emit SetRegistry(registry);
788     }
789 
790     function _burnAllArgs(address _burner, uint256 _value) internal {
791         registry.requireCanBurn(_burner);
792         super._burnAllArgs(_burner, _value);
793     }
794 
795     // Destroy the tokens owned by a blacklisted account
796     function wipeBlacklistedAccount(address _account) public onlyOwner {
797         require(registry.hasAttribute(_account, IS_BLACKLISTED), "_account is not blacklisted");
798         uint256 oldValue = balanceOf(_account);
799         balances.setBalance(_account, 0);
800         totalSupply_ = totalSupply_.sub(oldValue);
801         emit WipeBlacklistedAccount(_account, oldValue);
802         emit Transfer(_account, address(0), oldValue);
803     }
804 }
805 
806 // File: contracts/DepositToken.sol
807 
808 /** @title Deposit Token
809 Allows users to register their address so that all transfers to deposit addresses
810 of the registered address will be forwarded to the registered address.  
811 For example for address 0x9052BE99C9C8C5545743859e4559A751bDe4c923,
812 its deposit addresses are all addresses between
813 0x9052BE99C9C8C5545743859e4559A75100000 and 0x9052BE99C9C8C5545743859e4559A751fffff
814 Transfers to 0x9052BE99C9C8C5545743859e4559A75100005 will be forwared to 0x9052BE99C9C8C5545743859e4559A751bDe4c923
815  */
816 contract DepositToken is ModularMintableToken {
817     
818     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
819 
820 }
821 
822 // File: contracts/TrueCoinReceiver.sol
823 
824 contract TrueCoinReceiver {
825     function tokenFallback( address from, uint256 value ) external;
826 }
827 
828 // File: contracts/TokenWithHook.sol
829 
830 /** @title Token With Hook
831 If tokens are transferred to a Registered Token Receiver contract, trigger the tokenFallback function in the 
832 Token Receiver contract. Assume all Registered Token Receiver contract implements the TrueCoinReceiver 
833 interface. If the tokenFallback reverts, the entire transaction reverts. 
834  */
835 contract TokenWithHook is ModularMintableToken {
836     
837     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
838 
839 }
840 
841 // File: contracts/CompliantDepositTokenWithHook.sol
842 
843 contract CompliantDepositTokenWithHook is CompliantToken, DepositToken, TokenWithHook {
844 
845     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal {
846         bool hasHook;
847         address originalTo = _to;
848         (_to, hasHook) = registry.requireCanTransferFrom(_sender, _from, _to);
849         allowances.subAllowance(_from, _sender, _value);
850         balances.subBalance(_from, _value);
851         balances.addBalance(_to, _value);
852         emit Transfer(_from, originalTo, _value);
853         if (originalTo != _to) {
854             emit Transfer(originalTo, _to, _value);
855             if (hasHook) {
856                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
857             }
858         } else {
859             if (hasHook) {
860                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
861             }
862         }
863     }
864 
865     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
866         bool hasHook;
867         address originalTo = _to;
868         (_to, hasHook) = registry.requireCanTransfer(_from, _to);
869         balances.subBalance(_from, _value);
870         balances.addBalance(_to, _value);
871         emit Transfer(_from, originalTo, _value);
872         if (originalTo != _to) {
873             emit Transfer(originalTo, _to, _value);
874             if (hasHook) {
875                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
876             }
877         } else {
878             if (hasHook) {
879                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
880             }
881         }
882     }
883 
884     function mint(address _to, uint256 _value) public onlyOwner {
885         require(_to != address(0), "to address cannot be zero");
886         bool hasHook;
887         address originalTo = _to;
888         (_to, hasHook) = registry.requireCanMint(_to);
889         totalSupply_ = totalSupply_.add(_value);
890         emit Mint(originalTo, _value);
891         emit Transfer(address(0), originalTo, _value);
892         if (_to != originalTo) {
893             emit Transfer(originalTo, _to, _value);
894         }
895         balances.addBalance(_to, _value);
896         if (hasHook) {
897             if (_to != originalTo) {
898                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
899             } else {
900                 TrueCoinReceiver(_to).tokenFallback(address(0), _value);
901             }
902         }
903     }
904 }
905 
906 // File: contracts/RedeemableToken.sol
907 
908 /** @title Redeemable Token 
909 Makes transfers to 0x0 alias to Burn
910 Implement Redemption Addresses
911 */
912 contract RedeemableToken is ModularMintableToken {
913 
914     event RedemptionAddress(address indexed addr);
915 
916     uint256 public constant REDEMPTION_ADDRESS_COUNT = 0x100000;
917 
918     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
919         if (_to == address(0)) {
920             revert("_to address is 0x0");
921         } else if (uint(_to) < REDEMPTION_ADDRESS_COUNT) {
922             // Transfers to redemption addresses becomes burn
923             super._transferAllArgs(_from, _to, _value);
924             _burnAllArgs(_to, _value);
925         } else {
926             super._transferAllArgs(_from, _to, _value);
927         }
928     }
929 
930     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal {
931         if (_to == address(0)) {
932             revert("_to address is 0x0");
933         } else if (uint(_to) < REDEMPTION_ADDRESS_COUNT) {
934             // Transfers to redemption addresses becomes burn
935             super._transferFromAllArgs(_from, _to, _value, _sender);
936             _burnAllArgs(_to, _value);
937         } else {
938             super._transferFromAllArgs(_from, _to, _value, _sender);
939         }
940     }
941 }
942 
943 // File: contracts/GasRefundToken.sol
944 
945 /**  
946 @title Gas Refund Token
947 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
948 Each time an non-empty storage slot is set to 0, evm refund 15,000 (19,000 after Constantinople) to the sender
949 of the transaction. 
950 */
951 contract GasRefundToken is ModularMintableToken {
952 
953     function sponsorGas() external {
954         uint256 len = gasRefundPool.length;
955         uint256 refundPrice = minimumGasPriceForFutureRefunds;
956         require(refundPrice > 0);
957         gasRefundPool.length = len + 9;
958         gasRefundPool[len] = refundPrice;
959         gasRefundPool[len + 1] = refundPrice;
960         gasRefundPool[len + 2] = refundPrice;
961         gasRefundPool[len + 3] = refundPrice;
962         gasRefundPool[len + 4] = refundPrice;
963         gasRefundPool[len + 5] = refundPrice;
964         gasRefundPool[len + 6] = refundPrice;
965         gasRefundPool[len + 7] = refundPrice;
966         gasRefundPool[len + 8] = refundPrice;
967     }
968 
969     function minimumGasPriceForRefund() public view returns (uint256) {
970         uint256 len = gasRefundPool.length;
971         if (len > 0) {
972           return gasRefundPool[len - 1] + 1;
973         }
974         return uint256(-1);
975     }
976 
977     /**  
978     @dev refund 45,000 gas for functions with gasRefund modifier.
979     */
980     modifier gasRefund {
981         uint256 len = gasRefundPool.length;
982         if (len > 2 && tx.gasprice > gasRefundPool[len-1]) {
983             gasRefundPool.length = len - 3;
984         }
985         _;
986     }
987 
988     /**  
989     *@dev Return the remaining sponsored gas slots
990     */
991     function remainingGasRefundPool() public view returns (uint) {
992         return gasRefundPool.length;
993     }
994 
995     function remainingSponsoredTransactions() public view returns (uint) {
996         return gasRefundPool.length / 3;
997     }
998 
999     function _transferAllArgs(address _from, address _to, uint256 _value) internal gasRefund {
1000         super._transferAllArgs(_from, _to, _value);
1001     }
1002 
1003     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal gasRefund {
1004         super._transferFromAllArgs(_from, _to, _value, _sender);
1005     }
1006 
1007     function mint(address _to, uint256 _value) public onlyOwner gasRefund {
1008         super.mint(_to, _value);
1009     }
1010 
1011     bytes32 public constant CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE = "canSetFutureRefundMinGasPrice";
1012 
1013     function setMinimumGasPriceForFutureRefunds(uint256 _minimumGasPriceForFutureRefunds) public {
1014         require(registry.hasAttribute(msg.sender, CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE));
1015         minimumGasPriceForFutureRefunds = _minimumGasPriceForFutureRefunds;
1016     }
1017 }
1018 
1019 // File: contracts/DelegateERC20.sol
1020 
1021 /** @title DelegateERC20
1022 Accept forwarding delegation calls from the old UniversalUSD (V1) contract. This way the all the ERC20
1023 functions in the old contract still works (except Burn). 
1024 */
1025 contract DelegateERC20 is ModularStandardToken {
1026 
1027     address public constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1028     
1029     modifier onlyDelegateFrom() {
1030         require(msg.sender == DELEGATE_FROM);
1031         _;
1032     }
1033 
1034     function delegateTotalSupply() public view returns (uint256) {
1035         return totalSupply();
1036     }
1037 
1038     function delegateBalanceOf(address who) public view returns (uint256) {
1039         return balanceOf(who);
1040     }
1041 
1042     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1043         _transferAllArgs(origSender, to, value);
1044         return true;
1045     }
1046 
1047     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1048         return allowance(owner, spender);
1049     }
1050 
1051     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1052         _transferFromAllArgs(from, to, value, origSender);
1053         return true;
1054     }
1055 
1056     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1057         _approveAllArgs(spender, value, origSender);
1058         return true;
1059     }
1060 
1061     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1062         _increaseApprovalAllArgs(spender, addedValue, origSender);
1063         return true;
1064     }
1065 
1066     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1067         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1068         return true;
1069     }
1070 }
1071 
1072 // File: contracts/UniversalUSD.sol
1073 
1074 /** @title UniversalUSD
1075 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1076 * inherited - see the documentation on the corresponding contracts.
1077 */
1078 contract UniversalUSD is 
1079 ModularMintableToken, 
1080 CompliantDepositTokenWithHook,
1081 BurnableTokenWithBounds, 
1082 RedeemableToken,
1083 DelegateERC20,
1084 GasRefundToken {
1085     using SafeMath for *;
1086 
1087     uint8 public constant DECIMALS = 18;
1088     uint8 public constant ROUNDING = 2;
1089 
1090     event ChangeTokenName(string newName, string newSymbol);
1091 
1092     function decimals() public pure returns (uint8) {
1093         return DECIMALS;
1094     }
1095 
1096     function rounding() public pure returns (uint8) {
1097         return ROUNDING;
1098     }
1099 
1100     function changeTokenName(string _name, string _symbol) external onlyOwner {
1101         name = _name;
1102         symbol = _symbol;
1103         emit ChangeTokenName(_name, _symbol);
1104     }
1105 
1106     /**  
1107     *@dev send all eth balance in the UniversalUSD contract to another address
1108     */
1109     function reclaimEther(address _to) external onlyOwner {
1110         _to.transfer(address(this).balance);
1111     }
1112 
1113     /**  
1114     *@dev send all token balance of an arbitary erc20 token
1115     in the UniversalUSD contract to another address
1116     */
1117     function reclaimToken(ERC20 token, address _to) external onlyOwner {
1118         uint256 balance = token.balanceOf(this);
1119         token.transfer(_to, balance);
1120     }
1121 
1122     function paused() public pure returns (bool) {
1123         return false;
1124     }
1125 
1126     /**  
1127     *@dev allows owner of UniversalUSD to gain ownership of any contract that UniversalUSD currently owns
1128     */
1129     function reclaimContract(Ownable _ownable) external onlyOwner {
1130         _ownable.transferOwnership(owner);
1131     }
1132 
1133     function _burnAllArgs(address _burner, uint256 _value) internal {
1134         //round down burn amount so that the lowest amount allowed is 1 cent
1135         uint burnAmount = _value.div(10 ** uint256(DECIMALS - ROUNDING)).mul(10 ** uint256(DECIMALS - ROUNDING));
1136         super._burnAllArgs(_burner, burnAmount);
1137     }
1138 }