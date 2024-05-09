1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: registry/contracts/Registry.sol
79 
80 contract Registry {
81     struct AttributeData {
82         uint256 value;
83         bytes32 notes;
84         address adminAddr;
85         uint256 timestamp;
86     }
87     
88     address public owner;
89     address public pendingOwner;
90     bool public initialized;
91 
92     // Stores arbitrary attributes for users. An example use case is an ERC20
93     // token that requires its users to go through a KYC/AML check - in this case
94     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
95     // that account can use the token. This mapping stores that value (1, in the
96     // example) as well as which validator last set the value and at what time,
97     // so that e.g. the check can be renewed at appropriate intervals.
98     mapping(address => mapping(bytes32 => AttributeData)) public attributes;
99     // The logic governing who is allowed to set what attributes is abstracted as
100     // this accessManager, so that it may be replaced by the owner as needed
101 
102     bytes32 public constant WRITE_PERMISSION = keccak256("canWriteTo-");
103     bytes32 public constant IS_BLACKLISTED = "isBlacklisted";
104     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
105     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
106     bytes32 public constant HAS_PASSED_KYC_AML = "hasPassedKYC/AML";
107     bytes32 public constant CAN_BURN = "canBurn";
108 
109     event OwnershipTransferred(
110         address indexed previousOwner,
111         address indexed newOwner
112     );
113     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
114     event SetManager(address indexed oldManager, address indexed newManager);
115 
116 
117     function initialize() public {
118         require(!initialized, "already initialized");
119         owner = msg.sender;
120         initialized = true;
121     }
122 
123     function writeAttributeFor(bytes32 _attribute) public pure returns (bytes32) {
124         return keccak256(WRITE_PERMISSION ^ _attribute);
125     }
126 
127     // Allows a write if either a) the writer is that Registry's owner, or
128     // b) the writer is writing to attribute foo and that writer already has
129     // the canWriteTo-foo attribute set (in that same Registry)
130     function confirmWrite(bytes32 _attribute, address _admin) public view returns (bool) {
131         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
132     }
133 
134     // Writes are allowed only if the accessManager approves
135     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
136         require(confirmWrite(_attribute, msg.sender));
137         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
138         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
139     }
140 
141     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
142         require(confirmWrite(_attribute, msg.sender));
143         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
144         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
145     }
146 
147     // Returns true if the uint256 value stored for this attribute is non-zero
148     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
149         return attributes[_who][_attribute].value != 0;
150     }
151 
152     function hasBothAttributes(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
153         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value != 0;
154     }
155 
156     function hasEitherAttribute(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
157         return attributes[_who][_attribute1].value != 0 || attributes[_who][_attribute2].value != 0;
158     }
159 
160     function hasAttribute1ButNotAttribute2(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
161         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value == 0;
162     }
163 
164     function bothHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
165         return attributes[_who1][_attribute].value != 0 && attributes[_who2][_attribute].value != 0;
166     }
167     
168     function eitherHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
169         return attributes[_who1][_attribute].value != 0 || attributes[_who2][_attribute].value != 0;
170     }
171 
172     function haveAttributes(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
173         return attributes[_who1][_attribute1].value != 0 && attributes[_who2][_attribute2].value != 0;
174     }
175 
176     function haveEitherAttribute(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
177         return attributes[_who1][_attribute1].value != 0 || attributes[_who2][_attribute2].value != 0;
178     }
179 
180     function isDepositAddress(address _who) public view returns (bool) {
181         return attributes[address(uint256(_who) >> 20)][IS_DEPOSIT_ADDRESS].value != 0;
182     }
183 
184     function getDepositAddress(address _who) public view returns (address) {
185         return address(attributes[address(uint256(_who) >> 20)][IS_DEPOSIT_ADDRESS].value);
186     }
187 
188     function requireCanTransfer(address _from, address _to) public view returns (address, bool) {
189         require (attributes[_from][IS_BLACKLISTED].value == 0, "blacklisted");
190         uint256 depositAddressValue = attributes[address(uint256(_to) >> 20)][IS_DEPOSIT_ADDRESS].value;
191         if (depositAddressValue != 0) {
192             _to = address(depositAddressValue);
193         }
194         require (attributes[_to][IS_BLACKLISTED].value == 0, "blacklisted");
195         return (_to, attributes[_to][IS_REGISTERED_CONTRACT].value != 0);
196     }
197 
198     function requireCanTransferFrom(address _sender, address _from, address _to) public view returns (address, bool) {
199         require (attributes[_sender][IS_BLACKLISTED].value == 0, "blacklisted");
200         return requireCanTransfer(_from, _to);
201     }
202 
203     function requireCanMint(address _to) public view returns (address, bool) {
204         require (attributes[_to][HAS_PASSED_KYC_AML].value != 0);
205         require (attributes[_to][IS_BLACKLISTED].value == 0, "blacklisted");
206         uint256 depositAddressValue = attributes[address(uint256(_to) >> 20)][IS_DEPOSIT_ADDRESS].value;
207         if (depositAddressValue != 0) {
208             _to = address(depositAddressValue);
209         }
210         return (_to, attributes[_to][IS_REGISTERED_CONTRACT].value != 0);
211     }
212 
213     function requireCanBurn(address _from) public view {
214         require (attributes[_from][CAN_BURN].value != 0);
215         require (attributes[_from][IS_BLACKLISTED].value == 0);
216     }
217 
218     // Returns the exact value of the attribute, as well as its metadata
219     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
220         AttributeData memory data = attributes[_who][_attribute];
221         return (data.value, data.notes, data.adminAddr, data.timestamp);
222     }
223 
224     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
225         return attributes[_who][_attribute].value;
226     }
227 
228     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
229         return attributes[_who][_attribute].adminAddr;
230     }
231 
232     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
233         return attributes[_who][_attribute].timestamp;
234     }
235 
236     function reclaimEther(address _to) external onlyOwner {
237         _to.transfer(address(this).balance);
238     }
239 
240     function reclaimToken(ERC20 token, address _to) external onlyOwner {
241         uint256 balance = token.balanceOf(this);
242         token.transfer(_to, balance);
243     }
244 
245     /**
246     * @dev sets the original `owner` of the contract to the sender
247     * at construction. Must then be reinitialized 
248     */
249     constructor() public {
250         owner = msg.sender;
251         emit OwnershipTransferred(address(0), owner);
252     }
253 
254     /**
255     * @dev Throws if called by any account other than the owner.
256     */
257     modifier onlyOwner() {
258         require(msg.sender == owner, "only Owner");
259         _;
260     }
261 
262     /**
263     * @dev Modifier throws if called by any account other than the pendingOwner.
264     */
265     modifier onlyPendingOwner() {
266         require(msg.sender == pendingOwner);
267         _;
268     }
269 
270     /**
271     * @dev Allows the current owner to set the pendingOwner address.
272     * @param newOwner The address to transfer ownership to.
273     */
274     function transferOwnership(address newOwner) public onlyOwner {
275         pendingOwner = newOwner;
276     }
277 
278     /**
279     * @dev Allows the pendingOwner address to finalize the transfer.
280     */
281     function claimOwnership() public onlyPendingOwner {
282         emit OwnershipTransferred(owner, pendingOwner);
283         owner = pendingOwner;
284         pendingOwner = address(0);
285     }
286 }
287 
288 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
289 
290 /**
291  * @title Ownable
292  * @dev The Ownable contract has an owner address, and provides basic authorization control
293  * functions, this simplifies the implementation of "user permissions".
294  */
295 contract Ownable {
296   address public owner;
297 
298 
299   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   function Ownable() public {
307     owner = msg.sender;
308   }
309 
310   /**
311    * @dev Throws if called by any account other than the owner.
312    */
313   modifier onlyOwner() {
314     require(msg.sender == owner);
315     _;
316   }
317 
318   /**
319    * @dev Allows the current owner to transfer control of the contract to a newOwner.
320    * @param newOwner The address to transfer ownership to.
321    */
322   function transferOwnership(address newOwner) public onlyOwner {
323     require(newOwner != address(0));
324     emit OwnershipTransferred(owner, newOwner);
325     owner = newOwner;
326   }
327 
328 }
329 
330 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
331 
332 /**
333  * @title Claimable
334  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
335  * This allows the new owner to accept the transfer.
336  */
337 contract Claimable is Ownable {
338   address public pendingOwner;
339 
340   /**
341    * @dev Modifier throws if called by any account other than the pendingOwner.
342    */
343   modifier onlyPendingOwner() {
344     require(msg.sender == pendingOwner);
345     _;
346   }
347 
348   /**
349    * @dev Allows the current owner to set the pendingOwner address.
350    * @param newOwner The address to transfer ownership to.
351    */
352   function transferOwnership(address newOwner) onlyOwner public {
353     pendingOwner = newOwner;
354   }
355 
356   /**
357    * @dev Allows the pendingOwner address to finalize the transfer.
358    */
359   function claimOwnership() onlyPendingOwner public {
360     emit OwnershipTransferred(owner, pendingOwner);
361     owner = pendingOwner;
362     pendingOwner = address(0);
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
411 Defines the storage layout of the implementaiton (TrueUSD) contract. Any newly declared 
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
434     string public name = "TrueUSD";
435     string public symbol = "TUSD";
436 
437     uint[] public gasRefundPool;
438     uint256 public redemptionAddressCount;
439 }
440 
441 // File: contracts/HasOwner.sol
442 
443 /**
444  * @title HasOwner
445  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
446  and provides basic authorization control functions. Inherits storage layout of 
447  ProxyStorage.
448  */
449 contract HasOwner is ProxyStorage {
450 
451     event OwnershipTransferred(
452         address indexed previousOwner,
453         address indexed newOwner
454     );
455 
456     /**
457     * @dev sets the original `owner` of the contract to the sender
458     * at construction. Must then be reinitialized 
459     */
460     constructor() public {
461         owner = msg.sender;
462         emit OwnershipTransferred(address(0), owner);
463     }
464 
465     /**
466     * @dev Throws if called by any account other than the owner.
467     */
468     modifier onlyOwner() {
469         require(msg.sender == owner, "only Owner");
470         _;
471     }
472 
473     /**
474     * @dev Modifier throws if called by any account other than the pendingOwner.
475     */
476     modifier onlyPendingOwner() {
477         require(msg.sender == pendingOwner);
478         _;
479     }
480 
481     /**
482     * @dev Allows the current owner to set the pendingOwner address.
483     * @param newOwner The address to transfer ownership to.
484     */
485     function transferOwnership(address newOwner) public onlyOwner {
486         pendingOwner = newOwner;
487     }
488 
489     /**
490     * @dev Allows the pendingOwner address to finalize the transfer.
491     */
492     function claimOwnership() public onlyPendingOwner {
493         emit OwnershipTransferred(owner, pendingOwner);
494         owner = pendingOwner;
495         pendingOwner = address(0);
496     }
497 }
498 
499 // File: contracts/modularERC20/ModularBasicToken.sol
500 
501 // Version of OpenZeppelin's BasicToken whose balances mapping has been replaced
502 // with a separate BalanceSheet contract. remove the need to copy over balances.
503 /**
504  * @title Basic token
505  * @dev Basic version of StandardToken, with no allowances.
506  */
507 contract ModularBasicToken is HasOwner {
508     using SafeMath for uint256;
509 
510     event BalanceSheetSet(address indexed sheet);
511     event Transfer(address indexed from, address indexed to, uint256 value);
512 
513     /**
514     * @dev claim ownership of the balancesheet contract
515     * @param _sheet The address to of the balancesheet to claim.
516     */
517     function setBalanceSheet(address _sheet) public onlyOwner returns (bool) {
518         balances = BalanceSheet(_sheet);
519         balances.claimOwnership();
520         emit BalanceSheetSet(_sheet);
521         return true;
522     }
523 
524     /**
525     * @dev total number of tokens in existence
526     */
527     function totalSupply() public view returns (uint256) {
528         return totalSupply_;
529     }
530 
531     /**
532     * @dev transfer token for a specified address
533     * @param _to The address to transfer to.
534     * @param _value The amount to be transferred.
535     */
536     function transfer(address _to, uint256 _value) public returns (bool) {
537         _transferAllArgs(msg.sender, _to, _value);
538         return true;
539     }
540 
541 
542     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
543         // SafeMath.sub will throw if there is not enough balance.
544         balances.subBalance(_from, _value);
545         balances.addBalance(_to, _value);
546         emit Transfer(_from, _to, _value);
547     }
548     
549 
550     /**
551     * @dev Gets the balance of the specified address.
552     * @param _owner The address to query the the balance of.
553     * @return An uint256 representing the amount owned by the passed address.
554     */
555     function balanceOf(address _owner) public view returns (uint256 balance) {
556         return balances.balanceOf(_owner);
557     }
558 }
559 
560 // File: contracts/modularERC20/ModularStandardToken.sol
561 
562 /**
563  * @title Standard ERC20 token
564  *
565  * @dev Implementation of the basic standard token.
566  * @dev https://github.com/ethereum/EIPs/issues/20
567  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
568  */
569 contract ModularStandardToken is ModularBasicToken {
570     
571     event AllowanceSheetSet(address indexed sheet);
572     event Approval(address indexed owner, address indexed spender, uint256 value);
573     
574     /**
575     * @dev claim ownership of the AllowanceSheet contract
576     * @param _sheet The address to of the AllowanceSheet to claim.
577     */
578     function setAllowanceSheet(address _sheet) public onlyOwner returns(bool) {
579         allowances = AllowanceSheet(_sheet);
580         allowances.claimOwnership();
581         emit AllowanceSheetSet(_sheet);
582         return true;
583     }
584 
585     /**
586      * @dev Transfer tokens from one address to another
587      * @param _from address The address which you want to send tokens from
588      * @param _to address The address which you want to transfer to
589      * @param _value uint256 the amount of tokens to be transferred
590      */
591     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
592         _transferFromAllArgs(_from, _to, _value, msg.sender);
593         return true;
594     }
595 
596     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
597         _transferAllArgs(_from, _to, _value);
598         allowances.subAllowance(_from, _spender, _value);
599     }
600 
601     /**
602      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
603      *
604      * Beware that changing an allowance with this method brings the risk that someone may use both the old
605      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
606      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
607      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
608      * @param _spender The address which will spend the funds.
609      * @param _value The amount of tokens to be spent.
610      */
611     function approve(address _spender, uint256 _value) public returns (bool) {
612         _approveAllArgs(_spender, _value, msg.sender);
613         return true;
614     }
615 
616     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
617         allowances.setAllowance(_tokenHolder, _spender, _value);
618         emit Approval(_tokenHolder, _spender, _value);
619     }
620 
621     /**
622      * @dev Function to check the amount of tokens that an owner allowed to a spender.
623      * @param _owner address The address which owns the funds.
624      * @param _spender address The address which will spend the funds.
625      * @return A uint256 specifying the amount of tokens still available for the spender.
626      */
627     function allowance(address _owner, address _spender) public view returns (uint256) {
628         return allowances.allowanceOf(_owner, _spender);
629     }
630 
631     /**
632      * @dev Increase the amount of tokens that an owner allowed to a spender.
633      *
634      * approve should be called when allowed[_spender] == 0. To increment
635      * allowed value is better to use this function to avoid 2 calls (and wait until
636      * the first transaction is mined)
637      * From MonolithDAO Token.sol
638      * @param _spender The address which will spend the funds.
639      * @param _addedValue The amount of tokens to increase the allowance by.
640      */
641     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
642         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
643         return true;
644     }
645 
646     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
647         allowances.addAllowance(_tokenHolder, _spender, _addedValue);
648         emit Approval(_tokenHolder, _spender, allowances.allowanceOf(_tokenHolder, _spender));
649     }
650 
651     /**
652      * @dev Decrease the amount of tokens that an owner allowed to a spender.
653      *
654      * approve should be called when allowed[_spender] == 0. To decrement
655      * allowed value is better to use this function to avoid 2 calls (and wait until
656      * the first transaction is mined)
657      * From MonolithDAO Token.sol
658      * @param _spender The address which will spend the funds.
659      * @param _subtractedValue The amount of tokens to decrease the allowance by.
660      */
661     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
662         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
663         return true;
664     }
665 
666     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
667         uint256 oldValue = allowances.allowanceOf(_tokenHolder, _spender);
668         if (_subtractedValue > oldValue) {
669             allowances.setAllowance(_tokenHolder, _spender, 0);
670         } else {
671             allowances.subAllowance(_tokenHolder, _spender, _subtractedValue);
672         }
673         emit Approval(_tokenHolder,_spender, allowances.allowanceOf(_tokenHolder, _spender));
674     }
675 }
676 
677 // File: contracts/modularERC20/ModularBurnableToken.sol
678 
679 /**
680  * @title Burnable Token
681  * @dev Token that can be irreversibly burned (destroyed).
682  */
683 contract ModularBurnableToken is ModularStandardToken {
684     event Burn(address indexed burner, uint256 value);
685 
686     /**
687      * @dev Burns a specific amount of tokens.
688      * @param _value The amount of token to be burned.
689      */
690     function burn(uint256 _value) public {
691         _burnAllArgs(msg.sender, _value);
692     }
693 
694     function _burnAllArgs(address _burner, uint256 _value) internal {
695         // no need to require value <= totalSupply, since that would imply the
696         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
697         /* uint burnAmount = _value / (10 **16) * (10 **16); */
698         balances.subBalance(_burner, _value);
699         totalSupply_ = totalSupply_.sub(_value);
700         emit Burn(_burner, _value);
701         emit Transfer(_burner, address(0), _value);
702     }
703 }
704 
705 // File: contracts/modularERC20/ModularMintableToken.sol
706 
707 /**
708  * @title Mintable token
709  * @dev Simple ERC20 Token example, with mintable token creation
710  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
711  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
712  */
713 contract ModularMintableToken is ModularBurnableToken {
714     event Mint(address indexed to, uint256 value);
715 
716     /**
717      * @dev Function to mint tokens
718      * @param _to The address that will receive the minted tokens.
719      * @param _value The amount of tokens to mint.
720      * @return A boolean that indicates if the operation was successful.
721      */
722     function mint(address _to, uint256 _value) public onlyOwner {
723         require(_to != address(0), "to address cannot be zero");
724         totalSupply_ = totalSupply_.add(_value);
725         balances.addBalance(_to, _value);
726         emit Mint(_to, _value);
727         emit Transfer(address(0), _to, _value);
728     }
729 }
730 
731 // File: contracts/BurnableTokenWithBounds.sol
732 
733 /**
734  * @title Burnable Token WithBounds
735  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
736  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
737  */
738 contract BurnableTokenWithBounds is ModularMintableToken {
739 
740     event SetBurnBounds(uint256 newMin, uint256 newMax);
741 
742     function _burnAllArgs(address _burner, uint256 _value) internal {
743         require(_value >= burnMin, "below min burn bound");
744         require(_value <= burnMax, "exceeds max burn bound");
745         super._burnAllArgs(_burner, _value);
746     }
747 
748     //Change the minimum and maximum amount that can be burned at once. Burning
749     //may be disabled by setting both to 0 (this will not be done under normal
750     //operation, but we can't add checks to disallow it without losing a lot of
751     //flexibility since burning could also be as good as disabled
752     //by setting the minimum extremely high, and we don't want to lock
753     //in any particular cap for the minimum)
754     function setBurnBounds(uint256 _min, uint256 _max) public onlyOwner {
755         require(_min <= _max, "min > max");
756         burnMin = _min;
757         burnMax = _max;
758         emit SetBurnBounds(_min, _max);
759     }
760 }
761 
762 // File: contracts/CompliantToken.sol
763 
764 contract CompliantToken is ModularMintableToken {
765     // In order to deposit USD and receive newly minted TrueUSD, or to burn TrueUSD to
766     // redeem it for USD, users must first go through a KYC/AML check (which includes proving they
767     // control their ethereum address using AddressValidation.sol).
768     bytes32 public constant HAS_PASSED_KYC_AML = "hasPassedKYC/AML";
769     // Redeeming ("burning") TrueUSD tokens for USD requires a separate flag since
770     // users must not only be KYC/AML'ed but must also have bank information on file.
771     bytes32 public constant CAN_BURN = "canBurn";
772     // Addresses can also be blacklisted, preventing them from sending or receiving
773     // TrueUSD. This can be used to prevent the use of TrueUSD by bad actors in
774     // accordance with law enforcement. See [TrueCoin Terms of Use](https://www.trusttoken.com/trueusd/terms-of-use)
775     bytes32 public constant IS_BLACKLISTED = "isBlacklisted";
776 
777     event WipeBlacklistedAccount(address indexed account, uint256 balance);
778     event SetRegistry(address indexed registry);
779     
780     /**
781     * @dev Point to the registry that contains all compliance related data
782     @param _registry The address of the registry instance
783     */
784     function setRegistry(Registry _registry) public onlyOwner {
785         registry = _registry;
786         emit SetRegistry(registry);
787     }
788 
789     function _burnAllArgs(address _burner, uint256 _value) internal {
790         registry.requireCanBurn(_burner);
791         super._burnAllArgs(_burner, _value);
792     }
793 
794     // Destroy the tokens owned by a blacklisted account
795     function wipeBlacklistedAccount(address _account) public onlyOwner {
796         require(registry.hasAttribute(_account, IS_BLACKLISTED), "_account is not blacklisted");
797         uint256 oldValue = balanceOf(_account);
798         balances.setBalance(_account, 0);
799         totalSupply_ = totalSupply_.sub(oldValue);
800         emit WipeBlacklistedAccount(_account, oldValue);
801         emit Transfer(_account, address(0), oldValue);
802     }
803 }
804 
805 // File: contracts/DepositToken.sol
806 
807 /** @title Deposit Token
808 Allows users to register their address so that all transfers to deposit addresses
809 of the registered address will be forwarded to the registered address.  
810 For example for address 0x9052BE99C9C8C5545743859e4559A751bDe4c923,
811 its deposit addresses are all addresses between
812 0x9052BE99C9C8C5545743859e4559A75100000 and 0x9052BE99C9C8C5545743859e4559A751fffff
813 Transfers to 0x9052BE99C9C8C5545743859e4559A75100005 will be forwared to 0x9052BE99C9C8C5545743859e4559A751bDe4c923
814  */
815 contract DepositToken is ModularMintableToken {
816     
817     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
818 
819 }
820 
821 // File: contracts/TrueCoinReceiver.sol
822 
823 contract TrueCoinReceiver {
824     function tokenFallback( address from, uint256 value ) external;
825 }
826 
827 // File: contracts/TokenWithHook.sol
828 
829 /** @title Token With Hook
830 If tokens are transferred to a Registered Token Receiver contract, trigger the tokenFallback function in the 
831 Token Receiver contract. Assume all Registered Token Receiver contract implements the TrueCoinReceiver 
832 interface. If the tokenFallback reverts, the entire transaction reverts. 
833  */
834 contract TokenWithHook is ModularMintableToken {
835     
836     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
837 
838 }
839 
840 // File: contracts/CompliantDepositTokenWithHook.sol
841 
842 contract CompliantDepositTokenWithHook is CompliantToken, DepositToken, TokenWithHook {
843 
844     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal {
845         bool hasHook;
846         address originalTo = _to;
847         (_to, hasHook) = registry.requireCanTransferFrom(_sender, _from, _to);
848         allowances.subAllowance(_from, _sender, _value);
849         balances.subBalance(_from, _value);
850         balances.addBalance(_to, _value);
851         emit Transfer(_from, originalTo, _value);
852         if (originalTo != _to) {
853             emit Transfer(originalTo, _to, _value);
854             if (hasHook) {
855                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
856             }
857         } else {
858             if (hasHook) {
859                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
860             }
861         }
862     }
863 
864     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
865         bool hasHook;
866         address originalTo = _to;
867         (_to, hasHook) = registry.requireCanTransfer(_from, _to);
868         balances.subBalance(_from, _value);
869         balances.addBalance(_to, _value);
870         emit Transfer(_from, originalTo, _value);
871         if (originalTo != _to) {
872             emit Transfer(originalTo, _to, _value);
873             if (hasHook) {
874                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
875             }
876         } else {
877             if (hasHook) {
878                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
879             }
880         }
881     }
882 
883     function mint(address _to, uint256 _value) public onlyOwner {
884         require(_to != address(0), "to address cannot be zero");
885         bool hasHook;
886         address originalTo = _to;
887         (_to, hasHook) = registry.requireCanMint(_to);
888         totalSupply_ = totalSupply_.add(_value);
889         emit Mint(originalTo, _value);
890         emit Transfer(address(0), originalTo, _value);
891         if (_to != originalTo) {
892             emit Transfer(originalTo, _to, _value);
893         }
894         balances.addBalance(_to, _value);
895         if (hasHook) {
896             if (_to != originalTo) {
897                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
898             } else {
899                 TrueCoinReceiver(_to).tokenFallback(address(0), _value);
900             }
901         }
902     }
903 }
904 
905 // File: contracts/RedeemableToken.sol
906 
907 /** @title Redeemable Token 
908 Makes transfers to 0x0 alias to Burn
909 Implement Redemption Addresses
910 */
911 contract RedeemableToken is ModularMintableToken {
912 
913     event RedemptionAddress(address indexed addr);
914 
915     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
916         if (_to == address(0)) {
917             revert("_to address is 0x0");
918         } else if (uint(_to) <= redemptionAddressCount) {
919             // Transfers to redemption addresses becomes burn
920             super._transferAllArgs(_from, _to, _value);
921             _burnAllArgs(_to, _value);
922         } else {
923             super._transferAllArgs(_from, _to, _value);
924         }
925     }
926 
927     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal {
928         if (_to == address(0)) {
929             revert("_to address is 0x0");
930         } else if (uint(_to) <= redemptionAddressCount) {
931             // Transfers to redemption addresses becomes burn
932             super._transferFromAllArgs(_from, _to, _value, _sender);
933             _burnAllArgs(_to, _value);
934         } else {
935             super._transferFromAllArgs(_from, _to, _value, _sender);
936         }
937     }
938 
939     function incrementRedemptionAddressCount() external onlyOwner {
940         emit RedemptionAddress(address(redemptionAddressCount));
941         redemptionAddressCount += 1;
942     }
943 }
944 
945 // File: contracts/GasRefundToken.sol
946 
947 /**  
948 @title Gas Refund Token
949 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
950 Each time an non-empty storage slot is set to 0, evm refund 15,000 (19,000 after Constantinople) to the sender
951 of the transaction. 
952 */
953 contract GasRefundToken is ModularMintableToken {
954 
955     function sponsorGas() external {
956         uint256 len = gasRefundPool.length;
957         gasRefundPool.length = len + 9;
958         gasRefundPool[len] = 1;
959         gasRefundPool[len + 1] = 1;
960         gasRefundPool[len + 2] = 1;
961         gasRefundPool[len + 3] = 1;
962         gasRefundPool[len + 4] = 1;
963         gasRefundPool[len + 5] = 1;
964         gasRefundPool[len + 6] = 1;
965         gasRefundPool[len + 7] = 1;
966         gasRefundPool[len + 8] = 1;
967     }  
968 
969     /**  
970     @dev refund up to 45,000 (57,000 after Constantinople) gas for functions with 
971     gasRefund modifier.
972     */
973     modifier gasRefund {
974         uint256 len = gasRefundPool.length;
975         if (len != 0) {
976             gasRefundPool[--len] = 0;
977             gasRefundPool[--len] = 0;
978             gasRefundPool[--len] = 0;
979             gasRefundPool.length = len;
980         }   
981         _;
982     }
983 
984     /**  
985     *@dev Return the remaining sponsored gas slots
986     */
987     function remainingGasRefundPool() public view returns(uint) {
988         return gasRefundPool.length;
989     }
990 
991     function _transferAllArgs(address _from, address _to, uint256 _value) internal gasRefund {
992         super._transferAllArgs(_from, _to, _value);
993     }
994 
995     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal gasRefund {
996         super._transferFromAllArgs(_from, _to, _value, _sender);
997     }
998 
999     function mint(address _to, uint256 _value) public onlyOwner gasRefund {
1000         super.mint(_to, _value);
1001     }
1002 }
1003 
1004 // File: contracts/DelegateERC20.sol
1005 
1006 /** @title DelegateERC20
1007 Accept forwarding delegation calls from the old TrueUSD (V1) contract. This way the all the ERC20
1008 functions in the old contract still works (except Burn). 
1009 */
1010 contract DelegateERC20 is ModularStandardToken {
1011 
1012     address public constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1013     
1014     modifier onlyDelegateFrom() {
1015         require(msg.sender == DELEGATE_FROM);
1016         _;
1017     }
1018 
1019     function delegateTotalSupply() public view returns (uint256) {
1020         return totalSupply();
1021     }
1022 
1023     function delegateBalanceOf(address who) public view returns (uint256) {
1024         return balanceOf(who);
1025     }
1026 
1027     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1028         _transferAllArgs(origSender, to, value);
1029         return true;
1030     }
1031 
1032     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1033         return allowance(owner, spender);
1034     }
1035 
1036     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1037         _transferFromAllArgs(from, to, value, origSender);
1038         return true;
1039     }
1040 
1041     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1042         _approveAllArgs(spender, value, origSender);
1043         return true;
1044     }
1045 
1046     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1047         _increaseApprovalAllArgs(spender, addedValue, origSender);
1048         return true;
1049     }
1050 
1051     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1052         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1053         return true;
1054     }
1055 }
1056 
1057 // File: contracts/TrueUSD.sol
1058 
1059 /** @title TrueUSD
1060 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1061 * inherited - see the documentation on the corresponding contracts.
1062 */
1063 contract TrueUSD is 
1064 ModularMintableToken, 
1065 CompliantDepositTokenWithHook,
1066 BurnableTokenWithBounds, 
1067 RedeemableToken,
1068 DelegateERC20,
1069 GasRefundToken {
1070     using SafeMath for *;
1071 
1072     uint8 public constant DECIMALS = 18;
1073     uint8 public constant ROUNDING = 2;
1074 
1075     event ChangeTokenName(string newName, string newSymbol);
1076 
1077     function decimals() public pure returns (uint8) {
1078         return DECIMALS;
1079     }
1080 
1081     function rounding() public pure returns (uint8) {
1082         return ROUNDING;
1083     }
1084 
1085     function changeTokenName(string _name, string _symbol) external onlyOwner {
1086         name = _name;
1087         symbol = _symbol;
1088         emit ChangeTokenName(_name, _symbol);
1089     }
1090 
1091     /**  
1092     *@dev send all eth balance in the TrueUSD contract to another address
1093     */
1094     function reclaimEther(address _to) external onlyOwner {
1095         _to.transfer(address(this).balance);
1096     }
1097 
1098     /**  
1099     *@dev send all token balance of an arbitary erc20 token
1100     in the TrueUSD contract to another address
1101     */
1102     function reclaimToken(ERC20 token, address _to) external onlyOwner {
1103         uint256 balance = token.balanceOf(this);
1104         token.transfer(_to, balance);
1105     }
1106 
1107     /**  
1108     *@dev allows owner of TrueUSD to gain ownership of any contract that TrueUSD currently owns
1109     */
1110     function reclaimContract(Ownable _ownable) external onlyOwner {
1111         _ownable.transferOwnership(owner);
1112     }
1113 
1114     function _burnAllArgs(address _burner, uint256 _value) internal {
1115         //round down burn amount so that the lowest amount allowed is 1 cent
1116         uint burnAmount = _value.div(10 ** uint256(DECIMALS - ROUNDING)).mul(10 ** uint256(DECIMALS - ROUNDING));
1117         super._burnAllArgs(_burner, burnAmount);
1118     }
1119 }
1120 
1121 // File: contracts/Proxy/Proxy.sol
1122 
1123 /**
1124  * @title Proxy
1125  * @dev Gives the possibility to delegate any call to a foreign implementation.
1126  */
1127 contract Proxy {
1128     
1129     /**
1130     * @dev Tells the address of the implementation where every call will be delegated.
1131     * @return address of the implementation to which it will be delegated
1132     */
1133     function implementation() public view returns (address);
1134 
1135     /**
1136     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1137     * This function will return whatever the implementation call returns
1138     */
1139     function() external payable {
1140         address _impl = implementation();
1141         require(_impl != address(0), "implementation contract not set");
1142         
1143         assembly {
1144             let ptr := mload(0x40)
1145             calldatacopy(ptr, 0, calldatasize)
1146             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1147             let size := returndatasize
1148             returndatacopy(ptr, 0, size)
1149 
1150             switch result
1151             case 0 { revert(ptr, size) }
1152             default { return(ptr, size) }
1153         }
1154     }
1155 }
1156 
1157 // File: contracts/Proxy/UpgradeabilityProxy.sol
1158 
1159 /**
1160  * @title UpgradeabilityProxy
1161  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
1162  */
1163 contract UpgradeabilityProxy is Proxy {
1164     /**
1165     * @dev This event will be emitted every time the implementation gets upgraded
1166     * @param implementation representing the address of the upgraded implementation
1167     */
1168     event Upgraded(address indexed implementation);
1169 
1170     // Storage position of the address of the current implementation
1171     bytes32 private constant implementationPosition = keccak256("trueUSD.proxy.implementation");
1172 
1173     /**
1174     * @dev Tells the address of the current implementation
1175     * @return address of the current implementation
1176     */
1177     function implementation() public view returns (address impl) {
1178         bytes32 position = implementationPosition;
1179         assembly {
1180           impl := sload(position)
1181         }
1182     }
1183 
1184     /**
1185     * @dev Sets the address of the current implementation
1186     * @param newImplementation address representing the new implementation to be set
1187     */
1188     function _setImplementation(address newImplementation) internal {
1189         bytes32 position = implementationPosition;
1190         assembly {
1191           sstore(position, newImplementation)
1192         }
1193     }
1194 
1195     /**
1196     * @dev Upgrades the implementation address
1197     * @param newImplementation representing the address of the new implementation to be set
1198     */
1199     function _upgradeTo(address newImplementation) internal {
1200         address currentImplementation = implementation();
1201         require(currentImplementation != newImplementation);
1202         _setImplementation(newImplementation);
1203         emit Upgraded(newImplementation);
1204     }
1205 }
1206 
1207 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
1208 
1209 /**
1210  * @title OwnedUpgradeabilityProxy
1211  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
1212  */
1213 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
1214     /**
1215     * @dev Event to show ownership has been transferred
1216     * @param previousOwner representing the address of the previous owner
1217     * @param newOwner representing the address of the new owner
1218     */
1219     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222     * @dev Event to show ownership transfer is pending
1223     * @param currentOwner representing the address of the current owner
1224     * @param pendingOwner representing the address of the pending owner
1225     */
1226     event NewPendingOwner(address currentOwner, address pendingOwner);
1227     
1228     // Storage position of the owner and pendingOwner of the contract
1229     bytes32 private constant proxyOwnerPosition = keccak256("trueUSD.proxy.owner");
1230     bytes32 private constant pendingProxyOwnerPosition = keccak256("trueUSD.pending.proxy.owner");
1231 
1232     /**
1233     * @dev the constructor sets the original owner of the contract to the sender account.
1234     */
1235     constructor() public {
1236         _setUpgradeabilityOwner(msg.sender);
1237     }
1238 
1239     /**
1240     * @dev Throws if called by any account other than the owner.
1241     */
1242     modifier onlyProxyOwner() {
1243         require(msg.sender == proxyOwner(), "only Proxy Owner");
1244         _;
1245     }
1246 
1247     /**
1248     * @dev Throws if called by any account other than the pending owner.
1249     */
1250     modifier onlyPendingProxyOwner() {
1251         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
1252         _;
1253     }
1254 
1255     /**
1256     * @dev Tells the address of the owner
1257     * @return the address of the owner
1258     */
1259     function proxyOwner() public view returns (address owner) {
1260         bytes32 position = proxyOwnerPosition;
1261         assembly {
1262             owner := sload(position)
1263         }
1264     }
1265 
1266     /**
1267     * @dev Tells the address of the owner
1268     * @return the address of the owner
1269     */
1270     function pendingProxyOwner() public view returns (address pendingOwner) {
1271         bytes32 position = pendingProxyOwnerPosition;
1272         assembly {
1273             pendingOwner := sload(position)
1274         }
1275     }
1276 
1277     /**
1278     * @dev Sets the address of the owner
1279     */
1280     function _setUpgradeabilityOwner(address newProxyOwner) internal {
1281         bytes32 position = proxyOwnerPosition;
1282         assembly {
1283             sstore(position, newProxyOwner)
1284         }
1285     }
1286 
1287     /**
1288     * @dev Sets the address of the owner
1289     */
1290     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
1291         bytes32 position = pendingProxyOwnerPosition;
1292         assembly {
1293             sstore(position, newPendingProxyOwner)
1294         }
1295     }
1296 
1297     /**
1298     * @dev Allows the current owner to transfer control of the contract to a newOwner.
1299     *changes the pending owner to newOwner. But doesn't actually transfer
1300     * @param newOwner The address to transfer ownership to.
1301     */
1302     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
1303         require(newOwner != address(0));
1304         _setPendingUpgradeabilityOwner(newOwner);
1305         emit NewPendingOwner(proxyOwner(), newOwner);
1306     }
1307 
1308     /**
1309     * @dev Allows the pendingOwner to claim ownership of the proxy
1310     */
1311     function claimProxyOwnership() external onlyPendingProxyOwner {
1312         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
1313         _setUpgradeabilityOwner(pendingProxyOwner());
1314         _setPendingUpgradeabilityOwner(address(0));
1315     }
1316 
1317     /**
1318     * @dev Allows the proxy owner to upgrade the current version of the proxy.
1319     * @param implementation representing the address of the new implementation to be set.
1320     */
1321     function upgradeTo(address implementation) external onlyProxyOwner {
1322         _upgradeTo(implementation);
1323     }
1324 }
1325 
1326 // File: contracts/Admin/TokenController.sol
1327 
1328 /** @title TokenController
1329 @dev This contract allows us to split ownership of the TrueUSD contract
1330 into two addresses. One, called the "owner" address, has unfettered control of the TrueUSD contract -
1331 it can mint new tokens, transfer ownership of the contract, etc. However to make
1332 extra sure that TrueUSD is never compromised, this owner key will not be used in
1333 day-to-day operations, allowing it to be stored at a heightened level of security.
1334 Instead, the owner appoints an various "admin" address. 
1335 There are 3 different types of admin addresses;  MintKey, MintRatifier, and MintPauser. 
1336 MintKey can request and revoke mints one at a time.
1337 MintPausers can pause individual mints or pause all mints.
1338 MintRatifiers can approve and finalize mints with enough approval.
1339 There are three levels of mints: instant mint, ratified mint, and multiSig mint. Each have a different threshold
1340 and deduct from a different pool.
1341 Instant mint has the lowest threshold and finalizes instantly without any ratifiers. Deduct from instant mint pool,
1342 which can be refilled by one ratifier.
1343 Ratify mint has the second lowest threshold and finalizes with one ratifier approval. Deduct from ratify mint pool,
1344 which can be refilled by three ratifiers.
1345 MultiSig mint has the highest threshold and finalizes with three ratifier approvals. Deduct from multiSig mint pool,
1346 which can only be refilled by the owner.
1347 */
1348 
1349 contract TokenController {
1350     using SafeMath for uint256;
1351 
1352     struct MintOperation {
1353         address to;
1354         uint256 value;
1355         uint256 requestedBlock;
1356         uint256 numberOfApproval;
1357         bool paused;
1358         mapping(address => bool) approved; 
1359     }
1360 
1361     address public owner;
1362     address public pendingOwner;
1363 
1364     bool public initialized;
1365 
1366     uint256 public instantMintThreshold;
1367     uint256 public ratifiedMintThreshold;
1368     uint256 public multiSigMintThreshold;
1369 
1370 
1371     uint256 public instantMintLimit; 
1372     uint256 public ratifiedMintLimit; 
1373     uint256 public multiSigMintLimit;
1374 
1375     uint256 public instantMintPool; 
1376     uint256 public ratifiedMintPool; 
1377     uint256 public multiSigMintPool;
1378     address[2] public ratifiedPoolRefillApprovals;
1379 
1380     uint8 constant public RATIFY_MINT_SIGS = 1; //number of approvals needed to finalize a Ratified Mint
1381     uint8 constant public MULTISIG_MINT_SIGS = 3; //number of approvals needed to finalize a MultiSig Mint
1382 
1383     bool public mintPaused;
1384     uint256 public mintReqInvalidBeforeThisBlock; //all mint request before this block are invalid
1385     address public mintKey;
1386     MintOperation[] public mintOperations; //list of a mint requests
1387     
1388     TrueUSD public trueUSD;
1389     Registry public registry;
1390     address public trueUsdFastPause;
1391 
1392     bytes32 constant public IS_MINT_PAUSER = "isTUSDMintPausers";
1393     bytes32 constant public IS_MINT_RATIFIER = "isTUSDMintRatifier";
1394     bytes32 constant public IS_REDEMPTION_ADMIN = "isTUSDRedemptionAdmin";
1395 
1396     address constant public PAUSED_IMPLEMENTATION = address(0xff1ffac73c188914647e19a4662a734a40382f1b);
1397 
1398     modifier onlyFastPauseOrOwner() {
1399         require(msg.sender == trueUsdFastPause || msg.sender == owner, "must be pauser or owner");
1400         _;
1401     }
1402 
1403     modifier onlyMintKeyOrOwner() {
1404         require(msg.sender == mintKey || msg.sender == owner, "must be mintKey or owner");
1405         _;
1406     }
1407 
1408     modifier onlyMintPauserOrOwner() {
1409         require(registry.hasAttribute(msg.sender, IS_MINT_PAUSER) || msg.sender == owner, "must be pauser or owner");
1410         _;
1411     }
1412 
1413     modifier onlyMintRatifierOrOwner() {
1414         require(registry.hasAttribute(msg.sender, IS_MINT_RATIFIER) || msg.sender == owner, "must be ratifier or owner");
1415         _;
1416     }
1417 
1418     modifier onlyOwnerOrRedemptionAdmin() {
1419         require(registry.hasAttribute(msg.sender, IS_REDEMPTION_ADMIN) || msg.sender == owner, "must be Redemption admin or owner");
1420         _;
1421     }
1422 
1423     //mint operations by the mintkey cannot be processed on when mints are paused
1424     modifier mintNotPaused() {
1425         if (msg.sender != owner) {
1426             require(!mintPaused, "minting is paused");
1427         }
1428         _;
1429     }
1430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1431     event NewOwnerPending(address indexed currentOwner, address indexed pendingOwner);
1432     event SetRegistry(address indexed registry);
1433     event TransferChild(address indexed child, address indexed newOwner);
1434     event RequestReclaimContract(address indexed other);
1435     event SetTrueUSD(TrueUSD newContract);
1436     
1437     event RequestMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1438     event FinalizeMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1439     event InstantMint(address indexed to, uint256 indexed value, address indexed mintKey);
1440     
1441     event TransferMintKey(address indexed previousMintKey, address indexed newMintKey);
1442     event MintRatified(uint256 indexed opIndex, address indexed ratifier);
1443     event RevokeMint(uint256 opIndex);
1444     event AllMintsPaused(bool status);
1445     event MintPaused(uint opIndex, bool status);
1446     event MintApproved(address approver, uint opIndex);
1447     event TrueUsdFastPauseSet(address _newFastPause);
1448 
1449     event MintThresholdChanged(uint instant, uint ratified, uint multiSig);
1450     event MintLimitsChanged(uint instant, uint ratified, uint multiSig);
1451     event InstantPoolRefilled();
1452     event RatifyPoolRefilled();
1453     event MultiSigPoolRefilled();
1454 
1455     /*
1456     ========================================
1457     Ownership functions
1458     ========================================
1459     */
1460 
1461     function initialize() external {
1462         require(!initialized, "already initialized");
1463         owner = msg.sender;
1464         initialized = true;
1465     }
1466 
1467     /**
1468     * @dev Throws if called by any account other than the owner.
1469     */
1470     modifier onlyOwner() {
1471         require(msg.sender == owner, "only Owner");
1472         _;
1473     }
1474 
1475     /**
1476     * @dev Modifier throws if called by any account other than the pendingOwner.
1477     */
1478     modifier onlyPendingOwner() {
1479         require(msg.sender == pendingOwner);
1480         _;
1481     }
1482 
1483     /**
1484     * @dev Allows the current owner to set the pendingOwner address.
1485     * @param newOwner The address to transfer ownership to.
1486     */
1487     function transferOwnership(address newOwner) external onlyOwner {
1488         pendingOwner = newOwner;
1489         emit NewOwnerPending(owner, pendingOwner);
1490     }
1491 
1492     /**
1493     * @dev Allows the pendingOwner address to finalize the transfer.
1494     */
1495     function claimOwnership() external onlyPendingOwner {
1496         emit OwnershipTransferred(owner, pendingOwner);
1497         owner = pendingOwner;
1498         pendingOwner = address(0);
1499     }
1500     
1501     /*
1502     ========================================
1503     proxy functions
1504     ========================================
1505     */
1506 
1507     function transferTusdProxyOwnership(address _newOwner) external onlyOwner {
1508         OwnedUpgradeabilityProxy(trueUSD).transferProxyOwnership(_newOwner);
1509     }
1510 
1511     function claimTusdProxyOwnership() external onlyOwner {
1512         OwnedUpgradeabilityProxy(trueUSD).claimProxyOwnership();
1513     }
1514 
1515     function upgradeTusdProxyImplTo(address _implementation) external onlyOwner {
1516         OwnedUpgradeabilityProxy(trueUSD).upgradeTo(_implementation);
1517     }
1518 
1519     /*
1520     ========================================
1521     Minting functions
1522     ========================================
1523     */
1524 
1525     /**
1526      * @dev set the threshold for a mint to be considered an instant mint, ratify mint and multiSig mint
1527      Instant mint requires no approval, ratify mint requires 1 approval and multiSig mint requires 3 approvals
1528      */
1529     function setMintThresholds(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1530         require(_instant < _ratified && _ratified < _multiSig);
1531         instantMintThreshold = _instant;
1532         ratifiedMintThreshold = _ratified;
1533         multiSigMintThreshold = _multiSig;
1534         emit MintThresholdChanged(_instant, _ratified, _multiSig);
1535     }
1536 
1537 
1538     /**
1539      * @dev set the limit of each mint pool. For example can only instant mint up to the instant mint pool limit
1540      before needing to refill
1541      */
1542     function setMintLimits(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1543         require(_instant < _ratified && _ratified < _multiSig);
1544         instantMintLimit = _instant;
1545         ratifiedMintLimit = _ratified;
1546         multiSigMintLimit = _multiSig;
1547         emit MintLimitsChanged(_instant, _ratified, _multiSig);
1548     }
1549 
1550     /**
1551      * @dev Ratifier can refill instant mint pool
1552      */
1553     function refillInstantMintPool() external onlyMintRatifierOrOwner {
1554         ratifiedMintPool = ratifiedMintPool.sub(instantMintLimit.sub(instantMintPool));
1555         instantMintPool = instantMintLimit;
1556         emit InstantPoolRefilled();
1557     }
1558 
1559     /**
1560      * @dev Owner or 3 ratifiers can refill Ratified Mint Pool
1561      */
1562     function refillRatifiedMintPool() external onlyMintRatifierOrOwner {
1563         if (msg.sender != owner) {
1564             address[2] memory refillApprovals = ratifiedPoolRefillApprovals;
1565             require(msg.sender != refillApprovals[0] && msg.sender != refillApprovals[1]);
1566             if (refillApprovals[0] == address(0)) {
1567                 ratifiedPoolRefillApprovals[0] = msg.sender;
1568                 return;
1569             } 
1570             if (refillApprovals[1] == address(0)) {
1571                 ratifiedPoolRefillApprovals[1] = msg.sender;
1572                 return;
1573             } 
1574         }
1575         delete ratifiedPoolRefillApprovals; // clears the whole array
1576         multiSigMintPool = multiSigMintPool.sub(ratifiedMintLimit.sub(ratifiedMintPool));
1577         ratifiedMintPool = ratifiedMintLimit;
1578         emit RatifyPoolRefilled();
1579     }
1580 
1581     /**
1582      * @dev Owner can refill MultiSig Mint Pool
1583      */
1584     function refillMultiSigMintPool() external onlyOwner {
1585         multiSigMintPool = multiSigMintLimit;
1586         emit MultiSigPoolRefilled();
1587     }
1588 
1589     /**
1590      * @dev mintKey initiates a request to mint _value TrueUSD for account _to
1591      * @param _to the address to mint to
1592      * @param _value the amount requested
1593      */
1594     function requestMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1595         MintOperation memory op = MintOperation(_to, _value, block.number, 0, false);
1596         emit RequestMint(_to, _value, mintOperations.length, msg.sender);
1597         mintOperations.push(op);
1598     }
1599 
1600 
1601     /**
1602      * @dev Instant mint without ratification if the amount is less than instantMintThreshold and instantMintPool
1603      * @param _to the address to mint to
1604      * @param _value the amount minted
1605      */
1606     function instantMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1607         require(_value <= instantMintThreshold, "over the instant mint threshold");
1608         require(_value <= instantMintPool, "instant mint pool is dry");
1609         instantMintPool = instantMintPool.sub(_value);
1610         emit InstantMint(_to, _value, msg.sender);
1611         trueUSD.mint(_to, _value);
1612     }
1613 
1614 
1615     /**
1616      * @dev ratifier ratifies a request mint. If the number of ratifiers that signed off is greater than 
1617      the number of approvals required, the request is finalized
1618      * @param _index the index of the requestMint to ratify
1619      * @param _to the address to mint to
1620      * @param _value the amount requested
1621      */
1622     function ratifyMint(uint256 _index, address _to, uint256 _value) external mintNotPaused onlyMintRatifierOrOwner {
1623         MintOperation memory op = mintOperations[_index];
1624         require(op.to == _to, "to address does not match");
1625         require(op.value == _value, "amount does not match");
1626         require(!mintOperations[_index].approved[msg.sender], "already approved");
1627         mintOperations[_index].approved[msg.sender] = true;
1628         mintOperations[_index].numberOfApproval = mintOperations[_index].numberOfApproval.add(1);
1629         emit MintRatified(_index, msg.sender);
1630         if (hasEnoughApproval(mintOperations[_index].numberOfApproval, _value)){
1631             finalizeMint(_index);
1632         }
1633     }
1634 
1635     /**
1636      * @dev finalize a mint request, mint the amount requested to the specified address
1637      @param _index of the request (visible in the RequestMint event accompanying the original request)
1638      */
1639     function finalizeMint(uint256 _index) public mintNotPaused {
1640         MintOperation memory op = mintOperations[_index];
1641         address to = op.to;
1642         uint256 value = op.value;
1643         if (msg.sender != owner) {
1644             require(canFinalize(_index));
1645             _subtractFromMintPool(value);
1646         }
1647         delete mintOperations[_index];
1648         trueUSD.mint(to, value);
1649         emit FinalizeMint(to, value, _index, msg.sender);
1650     }
1651 
1652     /**
1653      * assumption: only invoked when canFinalize
1654      */
1655     function _subtractFromMintPool(uint256 _value) internal {
1656         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1657             ratifiedMintPool = ratifiedMintPool.sub(_value);
1658         } else {
1659             multiSigMintPool = multiSigMintPool.sub(_value);
1660         }
1661     }
1662 
1663     /**
1664      * @dev compute if the number of approvals is enough for a given mint amount
1665      */
1666     function hasEnoughApproval(uint256 _numberOfApproval, uint256 _value) public view returns (bool) {
1667         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1668             if (_numberOfApproval >= RATIFY_MINT_SIGS){
1669                 return true;
1670             }
1671         }
1672         if (_value <= multiSigMintPool && _value <= multiSigMintThreshold) {
1673             if (_numberOfApproval >= MULTISIG_MINT_SIGS){
1674                 return true;
1675             }
1676         }
1677         if (msg.sender == owner) {
1678             return true;
1679         }
1680         return false;
1681     }
1682 
1683     /**
1684      * @dev compute if a mint request meets all the requirements to be finalized
1685      utility function for a front end
1686      */
1687     function canFinalize(uint256 _index) public view returns(bool) {
1688         MintOperation memory op = mintOperations[_index];
1689         require(op.requestedBlock > mintReqInvalidBeforeThisBlock, "this mint is invalid"); //also checks if request still exists
1690         require(!op.paused, "this mint is paused");
1691         require(hasEnoughApproval(op.numberOfApproval, op.value), "not enough approvals");
1692         return true;
1693     }
1694 
1695     /** 
1696     *@dev revoke a mint request, Delete the mintOperation
1697     *@param index of the request (visible in the RequestMint event accompanying the original request)
1698     */
1699     function revokeMint(uint256 _index) external onlyMintKeyOrOwner {
1700         delete mintOperations[_index];
1701         emit RevokeMint(_index);
1702     }
1703 
1704     function mintOperationCount() public view returns (uint256) {
1705         return mintOperations.length;
1706     }
1707 
1708     /*
1709     ========================================
1710     Key management
1711     ========================================
1712     */
1713 
1714     /** 
1715     *@dev Replace the current mintkey with new mintkey 
1716     *@param _newMintKey address of the new mintKey
1717     */
1718     function transferMintKey(address _newMintKey) external onlyOwner {
1719         require(_newMintKey != address(0), "new mint key cannot be 0x0");
1720         emit TransferMintKey(mintKey, _newMintKey);
1721         mintKey = _newMintKey;
1722     }
1723  
1724     /*
1725     ========================================
1726     Mint Pausing
1727     ========================================
1728     */
1729 
1730     /** 
1731     *@dev invalidates all mint request initiated before the current block 
1732     */
1733     function invalidateAllPendingMints() external onlyOwner {
1734         mintReqInvalidBeforeThisBlock = block.number;
1735     }
1736 
1737     /** 
1738     *@dev pause any further mint request and mint finalizations 
1739     */
1740     function pauseMints() external onlyMintPauserOrOwner {
1741         mintPaused = true;
1742         emit AllMintsPaused(true);
1743     }
1744 
1745     /** 
1746     *@dev unpause any further mint request and mint finalizations 
1747     */
1748     function unpauseMints() external onlyOwner {
1749         mintPaused = false;
1750         emit AllMintsPaused(false);
1751     }
1752 
1753     /** 
1754     *@dev pause a specific mint request
1755     *@param  _opIndex the index of the mint request the caller wants to pause
1756     */
1757     function pauseMint(uint _opIndex) external onlyMintPauserOrOwner {
1758         mintOperations[_opIndex].paused = true;
1759         emit MintPaused(_opIndex, true);
1760     }
1761 
1762     /** 
1763     *@dev unpause a specific mint request
1764     *@param  _opIndex the index of the mint request the caller wants to unpause
1765     */
1766     function unpauseMint(uint _opIndex) external onlyOwner {
1767         mintOperations[_opIndex].paused = false;
1768         emit MintPaused(_opIndex, false);
1769     }
1770 
1771     /*
1772     ========================================
1773     set and claim contracts, administrative
1774     ========================================
1775     */
1776 
1777 
1778     /** 
1779     *@dev Increment redemption address count of TrueUSD
1780     */
1781     function incrementRedemptionAddressCount() external onlyOwnerOrRedemptionAdmin {
1782         trueUSD.incrementRedemptionAddressCount();
1783     }
1784 
1785     /** 
1786     *@dev Update this contract's trueUSD pointer to newContract (e.g. if the
1787     contract is upgraded)
1788     */
1789     function setTrueUSD(TrueUSD _newContract) external onlyOwner {
1790         trueUSD = _newContract;
1791         emit SetTrueUSD(_newContract);
1792     }
1793 
1794     /** 
1795     *@dev Update this contract's registry pointer to _registry
1796     */
1797     function setRegistry(Registry _registry) external onlyOwner {
1798         registry = _registry;
1799         emit SetRegistry(registry);
1800     }
1801 
1802     /** 
1803     *@dev update TrueUSD's name and symbol
1804     */
1805     function changeTokenName(string _name, string _symbol) external onlyOwner {
1806         trueUSD.changeTokenName(_name, _symbol);
1807     }
1808 
1809     /** 
1810     *@dev Swap out TrueUSD's permissions registry
1811     *@param _registry new registry for trueUSD
1812     */
1813     function setTusdRegistry(Registry _registry) external onlyOwner {
1814         trueUSD.setRegistry(_registry);
1815     }
1816 
1817     /** 
1818     *@dev Claim ownership of an arbitrary HasOwner contract
1819     */
1820     function issueClaimOwnership(address _other) public onlyOwner {
1821         HasOwner other = HasOwner(_other);
1822         other.claimOwnership();
1823     }
1824 
1825     /** 
1826     *@dev calls setBalanceSheet(address) and setAllowanceSheet(address) on the _proxy contract
1827     @param _proxy the contract that inplments setBalanceSheet and setAllowanceSheet
1828     @param _balanceSheet HasOwner storage contract
1829     @param _allowanceSheet HasOwner storage contract
1830     */
1831     function claimStorageForProxy(
1832         TrueUSD _proxy,
1833         HasOwner _balanceSheet,
1834         HasOwner _allowanceSheet) external onlyOwner {
1835 
1836         //call to claim the storage contract with the new delegate contract
1837         _proxy.setBalanceSheet(_balanceSheet);
1838         _proxy.setAllowanceSheet(_allowanceSheet);
1839     }
1840 
1841     /** 
1842     *@dev Transfer ownership of _child to _newOwner.
1843     Can be used e.g. to upgrade this TokenController contract.
1844     *@param _child contract that tokenController currently Owns 
1845     *@param _newOwner new owner/pending owner of _child
1846     */
1847     function transferChild(HasOwner _child, address _newOwner) external onlyOwner {
1848         _child.transferOwnership(_newOwner);
1849         emit TransferChild(_child, _newOwner);
1850     }
1851 
1852     /** 
1853     *@dev Transfer ownership of a contract from trueUSD to this TokenController.
1854     Can be used e.g. to reclaim balance sheet
1855     in order to transfer it to an upgraded TrueUSD contract.
1856     *@param _other address of the contract to claim ownership of
1857     */
1858     function requestReclaimContract(Ownable _other) public onlyOwner {
1859         trueUSD.reclaimContract(_other);
1860         emit RequestReclaimContract(_other);
1861     }
1862 
1863     /** 
1864     *@dev send all ether in trueUSD address to the owner of tokenController 
1865     */
1866     function requestReclaimEther() external onlyOwner {
1867         trueUSD.reclaimEther(owner);
1868     }
1869 
1870     /** 
1871     *@dev transfer all tokens of a particular type in trueUSD address to the
1872     owner of tokenController 
1873     *@param _token token address of the token to transfer
1874     */
1875     function requestReclaimToken(ERC20 _token) external onlyOwner {
1876         trueUSD.reclaimToken(_token, owner);
1877     }
1878 
1879     /** 
1880     *@dev set new contract to which specified address can send eth to to quickly pause trueUSD
1881     *@param _newFastPause address of the new contract
1882     */
1883     function setTrueUsdFastPause(address _newFastPause) external onlyOwner {
1884         trueUsdFastPause = _newFastPause;
1885         emit TrueUsdFastPauseSet(_newFastPause);
1886     }
1887 
1888     /** 
1889     *@dev pause all pausable actions on TrueUSD, mints/burn/transfer/approve
1890     */
1891     function pauseTrueUSD() external onlyFastPauseOrOwner {
1892         OwnedUpgradeabilityProxy(trueUSD).upgradeTo(PAUSED_IMPLEMENTATION);
1893     }
1894     
1895     /** 
1896     *@dev wipe balance of a blacklisted address
1897     *@param _blacklistedAddress address whose balance will be wiped
1898     */
1899     function wipeBlackListedTrueUSD(address _blacklistedAddress) external onlyOwner {
1900         trueUSD.wipeBlacklistedAccount(_blacklistedAddress);
1901     }
1902 
1903     /** 
1904     *@dev Change the minimum and maximum amounts that TrueUSD users can
1905     burn to newMin and newMax
1906     *@param _min minimum amount user can burn at a time
1907     *@param _max maximum amount user can burn at a time
1908     */
1909     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
1910         trueUSD.setBurnBounds(_min, _max);
1911     }
1912 
1913     /** 
1914     *@dev Owner can send ether balance in contract address
1915     *@param _to address to which the funds will be send to
1916     */
1917     function reclaimEther(address _to) external onlyOwner {
1918         _to.transfer(address(this).balance);
1919     }
1920 
1921     /** 
1922     *@dev Owner can send erc20 token balance in contract address
1923     *@param _token address of the token to send
1924     *@param _to address to which the funds will be send to
1925     */
1926     function reclaimToken(ERC20 _token, address _to) external onlyOwner {
1927         uint256 balance = _token.balanceOf(this);
1928         _token.transfer(_to, balance);
1929     }
1930 }