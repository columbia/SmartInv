1 pragma solidity ^0.4.23;
2 
3 // File: contracts/SGDCTokenReceiver.sol
4 
5 contract SGDCTokenReceiver {
6     function tokenFallback( address from, uint256 value ) external;
7 }
8 
9 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 // File: registry/contracts/Registry.sol
37 
38 interface RegistryClone {
39     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) external;
40 }
41 
42 contract Registry {
43     struct AttributeData {
44         uint256 value;
45         bytes32 notes;
46         address adminAddr;
47         uint256 timestamp;
48     }
49     
50     // never remove any storage variables
51     address public owner;
52     address public pendingOwner;
53     bool initialized;
54 
55     /**
56     * @dev sets the original `owner` of the contract to the sender
57     * at construction. Must then be reinitialized
58     */
59     constructor() public {
60         owner = msg.sender;
61         emit OwnershipTransferred(address(0), owner);
62     }
63 
64     function initialize() public {
65         require(!initialized, "already initialized");
66         owner = msg.sender;
67         initialized = true;
68     }
69     
70     // Stores arbitrary attributes for users. An example use case is an ERC20
71     // token that requires its users to go through a KYC/AML check - in this case
72     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
73     // that account can use the token. This mapping stores that value (1, in the
74     // example) as well as which validator last set the value and at what time,
75     // so that e.g. the check can be renewed at appropriate intervals.
76     mapping(address => mapping(bytes32 => AttributeData)) attributes;
77     // The logic governing who is allowed to set what attributes is abstracted as
78     // this accessManager, so that it may be replaced by the owner as needed
79     bytes32 constant WRITE_PERMISSION = keccak256("canWriteTo-");
80     mapping(bytes32 => RegistryClone[]) subscribers;
81 
82     event OwnershipTransferred(
83         address indexed previousOwner,
84         address indexed newOwner
85     );
86     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
87     event SetManager(address indexed oldManager, address indexed newManager);
88     event StartSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
89     event StopSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
90 
91     // Allows a write if either a) the writer is that Registry's owner, or
92     // b) the writer is writing to attribute foo and that writer already has
93     // the canWriteTo-foo attribute set (in that same Registry)
94     function confirmWrite(bytes32 _attribute, address _admin) internal view returns (bool) {
95         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
96     }
97 
98     // Writes are allowed only if the accessManager approves
99     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
100         require(confirmWrite(_attribute, msg.sender));
101         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
102         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
103 
104         RegistryClone[] storage targets = subscribers[_attribute];
105         uint256 index = targets.length;
106         while (index --> 0) {
107             targets[index].syncAttributeValue(_who, _attribute, _value);
108         }
109     }
110 
111     function subscribe(bytes32 _attribute, RegistryClone _syncer) external onlyOwner {
112         subscribers[_attribute].push(_syncer);
113         emit StartSubscription(_attribute, _syncer);
114     }
115 
116     function unsubscribe(bytes32 _attribute, uint256 _index) external onlyOwner {
117         uint256 length = subscribers[_attribute].length;
118         require(_index < length);
119         emit StopSubscription(_attribute, subscribers[_attribute][_index]);
120         subscribers[_attribute][_index] = subscribers[_attribute][length - 1];
121         subscribers[_attribute].length = length - 1;
122     }
123 
124     function subscriberCount(bytes32 _attribute) public view returns (uint256) {
125         return subscribers[_attribute].length;
126     }
127 
128     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
129         require(confirmWrite(_attribute, msg.sender));
130         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
131         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
132         RegistryClone[] storage targets = subscribers[_attribute];
133         uint256 index = targets.length;
134         while (index --> 0) {
135             targets[index].syncAttributeValue(_who, _attribute, _value);
136         }
137     }
138 
139     // Returns true if the uint256 value stored for this attribute is non-zero
140     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
141         return attributes[_who][_attribute].value != 0;
142     }
143 
144 
145     // Returns the exact value of the attribute, as well as its metadata
146     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
147         AttributeData memory data = attributes[_who][_attribute];
148         return (data.value, data.notes, data.adminAddr, data.timestamp);
149     }
150 
151     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
152         return attributes[_who][_attribute].value;
153     }
154 
155     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
156         return attributes[_who][_attribute].adminAddr;
157     }
158 
159     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
160         return attributes[_who][_attribute].timestamp;
161     }
162 
163     function syncAttribute(bytes32 _attribute, uint256 _startIndex, address[] _addresses) external {
164         RegistryClone[] storage targets = subscribers[_attribute];
165         uint256 index = targets.length;
166         while (index --> _startIndex) {
167             RegistryClone target = targets[index];
168             for (uint256 i = _addresses.length; i --> 0; ) {
169                 address who = _addresses[i];
170                 target.syncAttributeValue(who, _attribute, attributes[who][_attribute].value);
171             }
172         }
173     }
174 
175     function reclaimEther(address _to) external onlyOwner {
176         _to.transfer(address(this).balance);
177     }
178 
179     function reclaimToken(ERC20 token, address _to) external onlyOwner {
180         uint256 balance = token.balanceOf(this);
181         token.transfer(_to, balance);
182     }
183 
184    /**
185     * @dev Throws if called by any account other than the owner.
186     */
187     modifier onlyOwner() {
188         require(msg.sender == owner, "only Owner");
189         _;
190     }
191 
192     /**
193     * @dev Modifier throws if called by any account other than the pendingOwner.
194     */
195     modifier onlyPendingOwner() {
196         require(msg.sender == pendingOwner);
197         _;
198     }
199 
200     /**
201     * @dev Allows the current owner to set the pendingOwner address.
202     * @param newOwner The address to transfer ownership to.
203     */
204     function transferOwnership(address newOwner) public onlyOwner {
205         pendingOwner = newOwner;
206     }
207 
208     /**
209     * @dev Allows the pendingOwner address to finalize the transfer.
210     */
211     function claimOwnership() public onlyPendingOwner {
212         emit OwnershipTransferred(owner, pendingOwner);
213         owner = pendingOwner;
214         pendingOwner = address(0);
215     }
216 }
217 
218 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
219 
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226   address public owner;
227 
228 
229   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   function Ownable() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to transfer control of the contract to a newOwner.
250    * @param newOwner The address to transfer ownership to.
251    */
252   function transferOwnership(address newOwner) public onlyOwner {
253     require(newOwner != address(0));
254     emit OwnershipTransferred(owner, newOwner);
255     owner = newOwner;
256   }
257 
258 }
259 
260 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
261 
262 /**
263  * @title Claimable
264  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
265  * This allows the new owner to accept the transfer.
266  */
267 contract Claimable is Ownable {
268   address public pendingOwner;
269 
270   /**
271    * @dev Modifier throws if called by any account other than the pendingOwner.
272    */
273   modifier onlyPendingOwner() {
274     require(msg.sender == pendingOwner);
275     _;
276   }
277 
278   /**
279    * @dev Allows the current owner to set the pendingOwner address.
280    * @param newOwner The address to transfer ownership to.
281    */
282   function transferOwnership(address newOwner) onlyOwner public {
283     pendingOwner = newOwner;
284   }
285 
286   /**
287    * @dev Allows the pendingOwner address to finalize the transfer.
288    */
289   function claimOwnership() onlyPendingOwner public {
290     emit OwnershipTransferred(owner, pendingOwner);
291     owner = pendingOwner;
292     pendingOwner = address(0);
293   }
294 }
295 
296 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
297 
298 /**
299  * @title SafeMath
300  * @dev Math operations with safety checks that throw on error
301  */
302 library SafeMath {
303 
304   /**
305   * @dev Multiplies two numbers, throws on overflow.
306   */
307   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
308     if (a == 0) {
309       return 0;
310     }
311     c = a * b;
312     assert(c / a == b);
313     return c;
314   }
315 
316   /**
317   * @dev Integer division of two numbers, truncating the quotient.
318   */
319   function div(uint256 a, uint256 b) internal pure returns (uint256) {
320     // assert(b > 0); // Solidity automatically throws when dividing by 0
321     // uint256 c = a / b;
322     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
323     return a / b;
324   }
325 
326   /**
327   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
328   */
329   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
330     assert(b <= a);
331     return a - b;
332   }
333 
334   /**
335   * @dev Adds two numbers, throws on overflow.
336   */
337   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
338     c = a + b;
339     assert(c >= a);
340     return c;
341   }
342 }
343 
344 // File: contracts/modularERC20/BalanceSheet.sol
345 
346 // A wrapper around the balanceOf mapping.
347 contract BalanceSheet is Claimable {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) public balanceOf;
351 
352     function addBalance(address _addr, uint256 _value) public onlyOwner {
353         balanceOf[_addr] = balanceOf[_addr].add(_value);
354     }
355 
356     function subBalance(address _addr, uint256 _value) public onlyOwner {
357         balanceOf[_addr] = balanceOf[_addr].sub(_value);
358     }
359 
360     function setBalance(address _addr, uint256 _value) public onlyOwner {
361         balanceOf[_addr] = _value;
362     }
363 }
364 
365 // File: contracts/modularERC20/AllowanceSheet.sol
366 
367 // A wrapper around the allowanceOf mapping.
368 contract AllowanceSheet is Claimable {
369     using SafeMath for uint256;
370 
371     mapping (address => mapping (address => uint256)) public allowanceOf;
372 
373     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
374         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
375     }
376 
377     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
378         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
379     }
380 
381     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
382         allowanceOf[_tokenHolder][_spender] = _value;
383     }
384 }
385 
386 // File: contracts/ProxyStorage.sol
387 
388 /*
389 Defines the storage layout of the token implementaiton contract. Any newly declared
390 state variables in future upgrades should be appened to the bottom. Never remove state variables
391 from this list
392  */
393 contract ProxyStorage {
394     address public owner;
395     address public pendingOwner;
396 
397     bool initialized;
398     
399     BalanceSheet balances_Deprecated;
400     AllowanceSheet allowances_Deprecated;
401 
402     uint256 totalSupply_;
403     
404     bool private paused_Deprecated = false;
405     address private globalPause_Deprecated;
406 
407     uint256 public burnMin = 0;
408     uint256 public burnMax = 0;
409 
410     Registry public registry;
411 
412     string name_Deprecated;
413     string symbol_Deprecated;
414 
415     uint[] gasRefundPool_Deprecated;
416     uint256 private redemptionAddressCount_Deprecated;
417     uint256 public minimumGasPriceForFutureRefunds;
418 
419     mapping (address => uint256) _balanceOf;
420     mapping (address => mapping (address => uint256)) _allowance;
421     mapping (bytes32 => mapping (address => uint256)) attributes;
422 }
423 
424 // File: contracts/HasOwner.sol
425 
426 /**
427  * @title HasOwner
428  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
429  and provides basic authorization control functions. Inherits storage layout of 
430  ProxyStorage.
431  */
432 contract HasOwner is ProxyStorage {
433 
434     event OwnershipTransferred(
435         address indexed previousOwner,
436         address indexed newOwner
437     );
438 
439     /**
440     * @dev sets the original `owner` of the contract to the sender
441     * at construction. Must then be reinitialized 
442     */
443     constructor() public {
444         owner = msg.sender;
445         emit OwnershipTransferred(address(0), owner);
446     }
447 
448     /**
449     * @dev Throws if called by any account other than the owner.
450     */
451     modifier onlyOwner() {
452         require(msg.sender == owner, "only Owner");
453         _;
454     }
455 
456     /**
457     * @dev Modifier throws if called by any account other than the pendingOwner.
458     */
459     modifier onlyPendingOwner() {
460         require(msg.sender == pendingOwner);
461         _;
462     }
463 
464     /**
465     * @dev Allows the current owner to set the pendingOwner address.
466     * @param newOwner The address to transfer ownership to.
467     */
468     function transferOwnership(address newOwner) public onlyOwner {
469         pendingOwner = newOwner;
470     }
471 
472     /**
473     * @dev Allows the pendingOwner address to finalize the transfer.
474     */
475     function claimOwnership() public onlyPendingOwner {
476         emit OwnershipTransferred(owner, pendingOwner);
477         owner = pendingOwner;
478         pendingOwner = address(0);
479     }
480 }
481 
482 // File: contracts/ReclaimerToken.sol
483 
484 contract ReclaimerToken is HasOwner {
485     /**  
486     *@dev send all eth balance in the contract to another address
487     */
488     function reclaimEther(address _to) external onlyOwner {
489         _to.transfer(address(this).balance);
490     }
491 
492     /**  
493     *@dev send all token balance of an arbitary erc20 token
494     in the contract to another address
495     */
496     function reclaimToken(ERC20 token, address _to) external onlyOwner {
497         uint256 balance = token.balanceOf(this);
498         token.transfer(_to, balance);
499     }
500 
501     /**  
502     *@dev allows owner of the contract to gain ownership of any contract that the contract currently owns
503     */
504     function reclaimContract(Ownable _ownable) external onlyOwner {
505         _ownable.transferOwnership(owner);
506     }
507 
508 }
509 
510 // File: contracts/modularERC20/ModularBasicToken.sol
511 
512 // Fork of OpenZeppelin's BasicToken
513 /**
514  * @title Basic token
515  * @dev Basic version of StandardToken, with no allowances.
516  */
517 contract ModularBasicToken is HasOwner {
518     using SafeMath for uint256;
519 
520     event Transfer(address indexed from, address indexed to, uint256 value);
521 
522     /**
523     * @dev total number of tokens in existence
524     */
525     function totalSupply() public view returns (uint256) {
526         return totalSupply_;
527     }
528 
529     function balanceOf(address _who) public view returns (uint256) {
530         return _getBalance(_who);
531     }
532 
533     function _getBalance(address _who) internal view returns (uint256) {
534         return _balanceOf[_who];
535     }
536 
537     function _addBalance(address _who, uint256 _value) internal returns (uint256 priorBalance) {
538         priorBalance = _balanceOf[_who];
539         _balanceOf[_who] = priorBalance.add(_value);
540     }
541 
542     function _subBalance(address _who, uint256 _value) internal returns (uint256 result) {
543         result = _balanceOf[_who].sub(_value);
544         _balanceOf[_who] = result;
545     }
546 
547     function _setBalance(address _who, uint256 _value) internal {
548         _balanceOf[_who] = _value;
549     }
550 }
551 
552 // File: contracts/modularERC20/ModularStandardToken.sol
553 
554 /**
555  * @title Standard ERC20 token
556  *
557  * @dev Implementation of the basic standard token.
558  * @dev https://github.com/ethereum/EIPs/issues/20
559  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
560  */
561 contract ModularStandardToken is ModularBasicToken {
562     using SafeMath for uint256;
563     
564     event Approval(address indexed owner, address indexed spender, uint256 value);
565     
566     /**
567      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
568      *
569      * Beware that changing an allowance with this method brings the risk that someone may use both the old
570      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
571      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
572      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573      * @param _spender The address which will spend the funds.
574      * @param _value The amount of tokens to be spent.
575      */
576     function approve(address _spender, uint256 _value) public returns (bool) {
577         _approveAllArgs(_spender, _value, msg.sender);
578         return true;
579     }
580 
581     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
582         _setAllowance(_tokenHolder, _spender, _value);
583         emit Approval(_tokenHolder, _spender, _value);
584     }
585 
586     /**
587      * @dev Increase the amount of tokens that an owner allowed to a spender.
588      *
589      * approve should be called when allowed[_spender] == 0. To increment
590      * allowed value is better to use this function to avoid 2 calls (and wait until
591      * the first transaction is mined)
592      * From MonolithDAO Token.sol
593      * @param _spender The address which will spend the funds.
594      * @param _addedValue The amount of tokens to increase the allowance by.
595      */
596     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
597         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
598         return true;
599     }
600 
601     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
602         _addAllowance(_tokenHolder, _spender, _addedValue);
603         emit Approval(_tokenHolder, _spender, _getAllowance(_tokenHolder, _spender));
604     }
605 
606     /**
607      * @dev Decrease the amount of tokens that an owner allowed to a spender.
608      *
609      * approve should be called when allowed[_spender] == 0. To decrement
610      * allowed value is better to use this function to avoid 2 calls (and wait until
611      * the first transaction is mined)
612      * From MonolithDAO Token.sol
613      * @param _spender The address which will spend the funds.
614      * @param _subtractedValue The amount of tokens to decrease the allowance by.
615      */
616     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
617         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
618         return true;
619     }
620 
621     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
622         uint256 oldValue = _getAllowance(_tokenHolder, _spender);
623         uint256 newValue;
624         if (_subtractedValue > oldValue) {
625             newValue = 0;
626         } else {
627             newValue = oldValue - _subtractedValue;
628         }
629         _setAllowance(_tokenHolder, _spender, newValue);
630         emit Approval(_tokenHolder,_spender, newValue);
631     }
632 
633     function allowance(address _who, address _spender) public view returns (uint256) {
634         return _getAllowance(_who, _spender);
635     }
636 
637     function _getAllowance(address _who, address _spender) internal view returns (uint256 value) {
638         return _allowance[_who][_spender];
639     }
640 
641     function _addAllowance(address _who, address _spender, uint256 _value) internal {
642         _allowance[_who][_spender] = _allowance[_who][_spender].add(_value);
643     }
644 
645     function _subAllowance(address _who, address _spender, uint256 _value) internal returns (uint256 newAllowance){
646         newAllowance = _allowance[_who][_spender].sub(_value);
647         _allowance[_who][_spender] = newAllowance;
648     }
649 
650     function _setAllowance(address _who, address _spender, uint256 _value) internal {
651         _allowance[_who][_spender] = _value;
652     }
653 }
654 
655 // File: contracts/modularERC20/ModularBurnableToken.sol
656 
657 /**
658  * @title Burnable Token
659  * @dev Token that can be irreversibly burned (destroyed).
660  */
661 contract ModularBurnableToken is ModularStandardToken {
662     event Burn(address indexed burner, uint256 value);
663     event Mint(address indexed to, uint256 value);
664     uint256 constant CENT = 10 ** 16;
665 
666     function burn(uint256 _value) external {
667         _burnAllArgs(msg.sender, _value - _value % CENT);
668     }
669 
670     function _burnAllArgs(address _from, uint256 _value) internal {
671         // no need to require value <= totalSupply, since that would imply the
672         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
673         _subBalance(_from, _value);
674         totalSupply_ = totalSupply_.sub(_value);
675         emit Burn(_from, _value);
676         emit Transfer(_from, address(0), _value);
677     }
678 }
679 
680 // File: contracts/BurnableTokenWithBounds.sol
681 
682 /**
683  * @title Burnable Token WithBounds
684  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
685  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
686  */
687 contract BurnableTokenWithBounds is ModularBurnableToken {
688 
689     event SetBurnBounds(uint256 newMin, uint256 newMax);
690 
691     function _burnAllArgs(address _burner, uint256 _value) internal {
692         require(_value >= burnMin, "below min burn bound");
693         require(_value <= burnMax, "exceeds max burn bound");
694         super._burnAllArgs(_burner, _value);
695     }
696 
697     //Change the minimum and maximum amount that can be burned at once. Burning
698     //may be disabled by setting both to 0 (this will not be done under normal
699     //operation, but we can't add checks to disallow it without losing a lot of
700     //flexibility since burning could also be as good as disabled
701     //by setting the minimum extremely high, and we don't want to lock
702     //in any particular cap for the minimum)
703     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
704         require(_min <= _max, "min > max");
705         burnMin = _min;
706         burnMax = _max;
707         emit SetBurnBounds(_min, _max);
708     }
709 }
710 
711 // File: contracts/GasRefundToken.sol
712 
713 /**  
714 @title Gas Refund Token
715 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
716 Each time an non-empty storage slot is set to 0, evm refund 15,000 to the sender
717 of the transaction.
718 */
719 contract GasRefundToken is ProxyStorage {
720 
721     /**
722       A buffer of "Sheep" runs from 0xffff...fffe down
723       They suicide when you call them, if you are their parent
724     */
725 
726     function sponsorGas2() external {
727         /**
728         Deploy (9 bytes)
729           PC Assembly       Opcodes                                       Stack
730           00 PUSH1(27)      60 1b                                         1b
731           02 DUP1           80                                            1b 1b
732           03 PUSH1(9)       60 09                                         1b 1b 09
733           05 RETURNDATASIZE 3d                                            1b 1b 09 00
734           06 CODECOPY       39                                            1b
735           07 RETURNDATASIZE 3d                                            1b 00
736           08 RETURN         f3
737         Sheep (27 bytes = 3 + 20 + 4)
738           PC Assembly       Opcodes                                       Stack
739           00 RETURNDATASIZE 3d                                            00
740           01 CALLER         33                                            00 caller
741           02 PUSH20(me)     73 memememememememememememememememememememe   00 caller me
742           17 XOR            18                                            00 invalid
743           18 PC             58                                            00 invalid 18
744           19 JUMPI          57                                            00
745           1a SELFDESTRUCT   ff
746         */
747         assembly {
748             mstore(0, or(0x601b8060093d393df33d33730000000000000000000000000000000000000000, address))
749             mstore(32,   0x185857ff00000000000000000000000000000000000000000000000000000000)
750             let offset := sload(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
751             let location := sub(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe, offset)
752             sstore(location, create(0, 0, 0x24))
753             location := sub(location, 1)
754             sstore(location, create(0, 0, 0x24))
755             location := sub(location, 1)
756             sstore(location, create(0, 0, 0x24))
757             sstore(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, add(offset, 3))
758         }
759     }
760 
761     /**
762     @dev refund 39,000 gas
763     @dev costs slightly more than 16,100 gas
764     */
765     function gasRefund39() internal {
766         assembly {
767             let offset := sload(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
768             if gt(offset, 0) {
769               let location := sub(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,offset)
770               sstore(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, sub(offset, 1))
771               let sheep := sload(location)
772               pop(call(gas, sheep, 0, 0, 0, 0, 0))
773               sstore(location, 0)
774             }
775         }
776     }
777 
778     function sponsorGas() external {
779         uint256 refundPrice = minimumGasPriceForFutureRefunds;
780         require(refundPrice > 0);
781         assembly {
782             let offset := sload(0xfffff)
783             let result := add(offset, 9)
784             sstore(0xfffff, result)
785             let position := add(offset, 0x100000)
786             sstore(position, refundPrice)
787             position := add(position, 1)
788             sstore(position, refundPrice)
789             position := add(position, 1)
790             sstore(position, refundPrice)
791             position := add(position, 1)
792             sstore(position, refundPrice)
793             position := add(position, 1)
794             sstore(position, refundPrice)
795             position := add(position, 1)
796             sstore(position, refundPrice)
797             position := add(position, 1)
798             sstore(position, refundPrice)
799             position := add(position, 1)
800             sstore(position, refundPrice)
801             position := add(position, 1)
802             sstore(position, refundPrice)
803         }
804     }
805 
806     function minimumGasPriceForRefund() public view returns (uint256 result) {
807         assembly {
808             let offset := sload(0xfffff)
809             let location := add(offset, 0xfffff)
810             result := add(sload(location), 1)
811         }
812     }
813 
814     /**  
815     @dev refund 30,000 gas
816     @dev costs slightly more than 15,400 gas
817     */
818     function gasRefund30() internal {
819         assembly {
820             let offset := sload(0xfffff)
821             if gt(offset, 1) {
822                 let location := add(offset, 0xfffff)
823                 if gt(gasprice,sload(location)) {
824                     sstore(location, 0)
825                     location := sub(location, 1)
826                     sstore(location, 0)
827                     sstore(0xfffff, sub(offset, 2))
828                 }
829             }
830         }
831     }
832 
833     /**  
834     @dev refund 15,000 gas
835     @dev costs slightly more than 10,200 gas
836     */
837     function gasRefund15() internal {
838         assembly {
839             let offset := sload(0xfffff)
840             if gt(offset, 1) {
841                 let location := add(offset, 0xfffff)
842                 if gt(gasprice,sload(location)) {
843                     sstore(location, 0)
844                     sstore(0xfffff, sub(offset, 1))
845                 }
846             }
847         }
848     }
849 
850     /**  
851     *@dev Return the remaining sponsored gas slots
852     */
853     function remainingGasRefundPool() public view returns (uint length) {
854         assembly {
855             length := sload(0xfffff)
856         }
857     }
858 
859     function gasRefundPool(uint256 _index) public view returns (uint256 gasPrice) {
860         assembly {
861             gasPrice := sload(add(0x100000, _index))
862         }
863     }
864 
865     bytes32 constant CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE = "canSetFutureRefundMinGasPrice";
866 
867     function setMinimumGasPriceForFutureRefunds(uint256 _minimumGasPriceForFutureRefunds) public {
868         require(registry.hasAttribute(msg.sender, CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE));
869         minimumGasPriceForFutureRefunds = _minimumGasPriceForFutureRefunds;
870     }
871 }
872 
873 // File: contracts/CompliantDepositTokenWithHook.sol
874 
875 contract CompliantDepositTokenWithHook is ReclaimerToken, RegistryClone, BurnableTokenWithBounds, GasRefundToken {
876 
877     bytes32 constant IS_REGISTERED_CONTRACT = "isRegisteredContract";
878     bytes32 constant IS_DEPOSIT_ADDRESS = "isDepositAddress";
879     uint256 constant REDEMPTION_ADDRESS_COUNT = 0x100000;
880     bytes32 constant IS_BLACKLISTED = "isBlacklisted";
881 
882     function canBurn() internal pure returns (bytes32);
883 
884     /**
885     * @dev transfer token for a specified address
886     * @param _to The address to transfer to.
887     * @param _value The amount to be transferred.
888     */
889     function transfer(address _to, uint256 _value) public returns (bool) {
890         _transferAllArgs(msg.sender, _to, _value);
891         return true;
892     }
893 
894     /**
895      * @dev Transfer tokens from one address to another
896      * @param _from address The address which you want to send tokens from
897      * @param _to address The address which you want to transfer to
898      * @param _value uint256 the amount of tokens to be transferred
899      */
900     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
901         _transferFromAllArgs(_from, _to, _value, msg.sender);
902         return true;
903     }
904 
905     function _burnFromAllowanceAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
906         _requireCanTransferFrom(_spender, _from, _to);
907         _requireOnlyCanBurn(_to);
908         require(_value >= burnMin, "below min burn bound");
909         require(_value <= burnMax, "exceeds max burn bound");
910         if (0 == _subBalance(_from, _value)) {
911             if (0 == _subAllowance(_from, _spender, _value)) {
912                 // no refund
913             } else {
914                 gasRefund15();
915             }
916         } else {
917             if (0 == _subAllowance(_from, _spender, _value)) {
918                 gasRefund15();
919             } else {
920                 gasRefund39();
921             }
922         }
923         emit Transfer(_from, _to, _value);
924         totalSupply_ = totalSupply_.sub(_value);
925         emit Burn(_to, _value);
926         emit Transfer(_to, address(0), _value);
927     }
928 
929     function _burnFromAllArgs(address _from, address _to, uint256 _value) internal {
930         _requireCanTransfer(_from, _to);
931         _requireOnlyCanBurn(_to);
932         require(_value >= burnMin, "below min burn bound");
933         require(_value <= burnMax, "exceeds max burn bound");
934         if (0 == _subBalance(_from, _value)) {
935             gasRefund15();
936         } else {
937             gasRefund30();
938         }
939         emit Transfer(_from, _to, _value);
940         totalSupply_ = totalSupply_.sub(_value);
941         emit Burn(_to, _value);
942         emit Transfer(_to, address(0), _value);
943     }
944 
945     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
946         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
947             _value -= _value % CENT;
948             _burnFromAllowanceAllArgs(_from, _to, _value, _spender);
949         } else {
950             bool hasHook;
951             address originalTo = _to;
952             (_to, hasHook) = _requireCanTransferFrom(_spender, _from, _to);
953             if (0 == _addBalance(_to, _value)) {
954                 if (0 == _subAllowance(_from, _spender, _value)) {
955                     if (0 == _subBalance(_from, _value)) {
956                         // do not refund
957                     } else {
958                         gasRefund30();
959                     }
960                 } else {
961                     if (0 == _subBalance(_from, _value)) {
962                         gasRefund30();
963                     } else {
964                         gasRefund39();
965                     }
966                 }
967             } else {
968                 if (0 == _subAllowance(_from, _spender, _value)) {
969                     if (0 == _subBalance(_from, _value)) {
970                         // do not refund
971                     } else {
972                         gasRefund15();
973                     }
974                 } else {
975                     if (0 == _subBalance(_from, _value)) {
976                         gasRefund15();
977                     } else {
978                         gasRefund39();
979                     }
980                 }
981 
982             }
983             emit Transfer(_from, originalTo, _value);
984             if (originalTo != _to) {
985                 emit Transfer(originalTo, _to, _value);
986                 if (hasHook) {
987                     SGDCTokenReceiver(_to).tokenFallback(originalTo, _value);
988                 }
989             } else {
990                 if (hasHook) {
991                     SGDCTokenReceiver(_to).tokenFallback(_from, _value);
992                 }
993             }
994         }
995     }
996 
997     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
998         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
999             _value -= _value % CENT;
1000             _burnFromAllArgs(_from, _to, _value);
1001         } else {
1002             bool hasHook;
1003             address finalTo;
1004             (finalTo, hasHook) = _requireCanTransfer(_from, _to);
1005             if (0 == _subBalance(_from, _value)) {
1006                 if (0 == _addBalance(finalTo, _value)) {
1007                     gasRefund30();
1008                 } else {
1009                     // do not refund
1010                 }
1011             } else {
1012                 if (0 == _addBalance(finalTo, _value)) {
1013                     gasRefund39();
1014                 } else {
1015                     gasRefund30();
1016                 }
1017             }
1018             emit Transfer(_from, _to, _value);
1019             if (finalTo != _to) {
1020                 emit Transfer(_to, finalTo, _value);
1021                 if (hasHook) {
1022                     SGDCTokenReceiver(finalTo).tokenFallback(_to, _value);
1023                 }
1024             } else {
1025                 if (hasHook) {
1026                     SGDCTokenReceiver(finalTo).tokenFallback(_from, _value);
1027                 }
1028             }
1029         }
1030     }
1031 
1032     function mint(address _to, uint256 _value) public onlyOwner {
1033         require(_to != address(0), "to address cannot be zero");
1034         bool hasHook;
1035         address originalTo = _to;
1036         (_to, hasHook) = _requireCanMint(_to);
1037         totalSupply_ = totalSupply_.add(_value);
1038         emit Mint(originalTo, _value);
1039         emit Transfer(address(0), originalTo, _value);
1040         if (_to != originalTo) {
1041             emit Transfer(originalTo, _to, _value);
1042         }
1043         _addBalance(_to, _value);
1044         if (hasHook) {
1045             if (_to != originalTo) {
1046                 SGDCTokenReceiver(_to).tokenFallback(originalTo, _value);
1047             } else {
1048                 SGDCTokenReceiver(_to).tokenFallback(address(0), _value);
1049             }
1050         }
1051     }
1052 
1053     event WipeBlacklistedAccount(address indexed account, uint256 balance);
1054     event SetRegistry(address indexed registry);
1055 
1056     /**
1057     * @dev Point to the registry that contains all compliance related data
1058     @param _registry The address of the registry instance
1059     */
1060     function setRegistry(Registry _registry) public onlyOwner {
1061         registry = _registry;
1062         emit SetRegistry(registry);
1063     }
1064 
1065     modifier onlyRegistry {
1066       require(msg.sender == address(registry));
1067       _;
1068     }
1069 
1070     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) public onlyRegistry {
1071         attributes[_attribute][_who] = _value;
1072     }
1073 
1074     function _burnAllArgs(address _from, uint256 _value) internal {
1075         _requireCanBurn(_from);
1076         super._burnAllArgs(_from, _value);
1077     }
1078 
1079     // Destroy the tokens owned by a blacklisted account
1080     function wipeBlacklistedAccount(address _account) public onlyOwner {
1081         require(_isBlacklisted(_account), "_account is not blacklisted");
1082         uint256 oldValue = _getBalance(_account);
1083         _setBalance(_account, 0);
1084         totalSupply_ = totalSupply_.sub(oldValue);
1085         emit WipeBlacklistedAccount(_account, oldValue);
1086         emit Transfer(_account, address(0), oldValue);
1087     }
1088 
1089     function _isBlacklisted(address _account) internal view returns (bool blacklisted) {
1090         return attributes[IS_BLACKLISTED][_account] != 0;
1091     }
1092 
1093     function _requireCanTransfer(address _from, address _to) internal view returns (address, bool) {
1094         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1095         if (depositAddressValue != 0) {
1096             _to = address(depositAddressValue);
1097         }
1098         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1099         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1100         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1101     }
1102 
1103     function _requireCanTransferFrom(address _spender, address _from, address _to) internal view returns (address, bool) {
1104         require (attributes[IS_BLACKLISTED][_spender] == 0, "blacklisted");
1105         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1106         if (depositAddressValue != 0) {
1107             _to = address(depositAddressValue);
1108         }
1109         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1110         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1111         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1112     }
1113 
1114     function _requireCanMint(address _to) internal view returns (address, bool) {
1115         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1116         if (depositAddressValue != 0) {
1117             _to = address(depositAddressValue);
1118         }
1119         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1120         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1121     }
1122 
1123     function _requireOnlyCanBurn(address _from) internal view {
1124         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1125     }
1126 
1127     function _requireCanBurn(address _from) internal view {
1128         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1129         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1130     }
1131 
1132     function paused() public pure returns (bool) {
1133         return false;
1134     }
1135 }
1136 
1137 // File: contracts/DelegateERC20.sol
1138 
1139 /** @title DelegateERC20
1140 Accept forwarding delegation calls from the old TrueUSD (V1) contract. This way the all the ERC20
1141 functions in the old contract still works (except Burn). 
1142 */
1143 contract DelegateERC20 is CompliantDepositTokenWithHook {
1144 
1145     address constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1146     
1147     modifier onlyDelegateFrom() {
1148         require(msg.sender == DELEGATE_FROM);
1149         _;
1150     }
1151 
1152     function delegateTotalSupply() public view returns (uint256) {
1153         return totalSupply();
1154     }
1155 
1156     function delegateBalanceOf(address who) public view returns (uint256) {
1157         return _getBalance(who);
1158     }
1159 
1160     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1161         _transferAllArgs(origSender, to, value);
1162         return true;
1163     }
1164 
1165     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1166         return _getAllowance(owner, spender);
1167     }
1168 
1169     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1170         _transferFromAllArgs(from, to, value, origSender);
1171         return true;
1172     }
1173 
1174     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1175         _approveAllArgs(spender, value, origSender);
1176         return true;
1177     }
1178 
1179     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1180         _increaseApprovalAllArgs(spender, addedValue, origSender);
1181         return true;
1182     }
1183 
1184     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1185         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1186         return true;
1187     }
1188 }
1189 
1190 // File: contracts/SGDC.sol
1191 
1192 /** @title SGDC
1193 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1194 * inherited - see the documentation on the corresponding contracts.
1195 */
1196 contract SGDC is CompliantDepositTokenWithHook {
1197     uint8 constant DECIMALS = 18;
1198     uint8 constant ROUNDING = 2;
1199     
1200     constructor(address initialAccount, uint256 initialBalance) public {
1201         _setBalance(initialAccount, initialBalance * (10 ** uint256(DECIMALS)));
1202         totalSupply_ = initialBalance * (10 ** uint256(DECIMALS));
1203         emit Transfer(address(0x0), initialAccount, totalSupply_);
1204         initialize();
1205     }
1206 
1207     function initialize() public {
1208         require(!initialized, "already initialized");
1209         initialized = true;
1210         owner = msg.sender;
1211         burnMin = 10000 * 10**uint256(DECIMALS);
1212         burnMax = 20000000 * 10**uint256(DECIMALS);
1213     }
1214 
1215     function decimals() public pure returns (uint8) {
1216         return DECIMALS;
1217     }
1218 
1219     function rounding() public pure returns (uint8) {
1220         return ROUNDING;
1221     }
1222 
1223     function name() public pure returns (string) {
1224         return "SGDC";
1225     }
1226 
1227     function symbol() public pure returns (string) {
1228         return "SGDC";
1229     }
1230 
1231     function canBurn() internal pure returns (bytes32) {
1232         return "canBurn";
1233     }
1234 }