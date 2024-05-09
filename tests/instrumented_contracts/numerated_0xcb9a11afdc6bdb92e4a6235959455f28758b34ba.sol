1 pragma solidity ^0.4.23;
2 
3 // File: contracts/TrueCoinReceiver.sol
4 
5 contract TrueCoinReceiver {
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
55     // Stores arbitrary attributes for users. An example use case is an ERC20
56     // token that requires its users to go through a KYC/AML check - in this case
57     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
58     // that account can use the token. This mapping stores that value (1, in the
59     // example) as well as which validator last set the value and at what time,
60     // so that e.g. the check can be renewed at appropriate intervals.
61     mapping(address => mapping(bytes32 => AttributeData)) attributes;
62     // The logic governing who is allowed to set what attributes is abstracted as
63     // this accessManager, so that it may be replaced by the owner as needed
64     bytes32 constant WRITE_PERMISSION = keccak256("canWriteTo-");
65     mapping(bytes32 => RegistryClone[]) subscribers;
66 
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
72     event SetManager(address indexed oldManager, address indexed newManager);
73     event StartSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
74     event StopSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
75 
76     // Allows a write if either a) the writer is that Registry's owner, or
77     // b) the writer is writing to attribute foo and that writer already has
78     // the canWriteTo-foo attribute set (in that same Registry)
79     function confirmWrite(bytes32 _attribute, address _admin) internal view returns (bool) {
80         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
81     }
82 
83     // Writes are allowed only if the accessManager approves
84     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
85         require(confirmWrite(_attribute, msg.sender));
86         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
87         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
88 
89         RegistryClone[] storage targets = subscribers[_attribute];
90         uint256 index = targets.length;
91         while (index --> 0) {
92             targets[index].syncAttributeValue(_who, _attribute, _value);
93         }
94     }
95 
96     function subscribe(bytes32 _attribute, RegistryClone _syncer) external onlyOwner {
97         subscribers[_attribute].push(_syncer);
98         emit StartSubscription(_attribute, _syncer);
99     }
100 
101     function unsubscribe(bytes32 _attribute, uint256 _index) external onlyOwner {
102         uint256 length = subscribers[_attribute].length;
103         require(_index < length);
104         emit StopSubscription(_attribute, subscribers[_attribute][_index]);
105         subscribers[_attribute][_index] = subscribers[_attribute][length - 1];
106         subscribers[_attribute].length = length - 1;
107     }
108 
109     function subscriberCount(bytes32 _attribute) public view returns (uint256) {
110         return subscribers[_attribute].length;
111     }
112 
113     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
114         require(confirmWrite(_attribute, msg.sender));
115         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
116         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
117         RegistryClone[] storage targets = subscribers[_attribute];
118         uint256 index = targets.length;
119         while (index --> 0) {
120             targets[index].syncAttributeValue(_who, _attribute, _value);
121         }
122     }
123 
124     // Returns true if the uint256 value stored for this attribute is non-zero
125     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
126         return attributes[_who][_attribute].value != 0;
127     }
128 
129 
130     // Returns the exact value of the attribute, as well as its metadata
131     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
132         AttributeData memory data = attributes[_who][_attribute];
133         return (data.value, data.notes, data.adminAddr, data.timestamp);
134     }
135 
136     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
137         return attributes[_who][_attribute].value;
138     }
139 
140     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
141         return attributes[_who][_attribute].adminAddr;
142     }
143 
144     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
145         return attributes[_who][_attribute].timestamp;
146     }
147 
148     function syncAttribute(bytes32 _attribute, uint256 _startIndex, address[] _addresses) external {
149         RegistryClone[] storage targets = subscribers[_attribute];
150         uint256 index = targets.length;
151         while (index --> _startIndex) {
152             RegistryClone target = targets[index];
153             for (uint256 i = _addresses.length; i --> 0; ) {
154                 address who = _addresses[i];
155                 target.syncAttributeValue(who, _attribute, attributes[who][_attribute].value);
156             }
157         }
158     }
159 
160     function reclaimEther(address _to) external onlyOwner {
161         _to.transfer(address(this).balance);
162     }
163 
164     function reclaimToken(ERC20 token, address _to) external onlyOwner {
165         uint256 balance = token.balanceOf(this);
166         token.transfer(_to, balance);
167     }
168 
169    /**
170     * @dev Throws if called by any account other than the owner.
171     */
172     modifier onlyOwner() {
173         require(msg.sender == owner, "only Owner");
174         _;
175     }
176 
177     /**
178     * @dev Modifier throws if called by any account other than the pendingOwner.
179     */
180     modifier onlyPendingOwner() {
181         require(msg.sender == pendingOwner);
182         _;
183     }
184 
185     /**
186     * @dev Allows the current owner to set the pendingOwner address.
187     * @param newOwner The address to transfer ownership to.
188     */
189     function transferOwnership(address newOwner) public onlyOwner {
190         pendingOwner = newOwner;
191     }
192 
193     /**
194     * @dev Allows the pendingOwner address to finalize the transfer.
195     */
196     function claimOwnership() public onlyPendingOwner {
197         emit OwnershipTransferred(owner, pendingOwner);
198         owner = pendingOwner;
199         pendingOwner = address(0);
200     }
201 }
202 
203 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
204 
205 /**
206  * @title Ownable
207  * @dev The Ownable contract has an owner address, and provides basic authorization control
208  * functions, this simplifies the implementation of "user permissions".
209  */
210 contract Ownable {
211   address public owner;
212 
213 
214   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216 
217   /**
218    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
219    * account.
220    */
221   function Ownable() public {
222     owner = msg.sender;
223   }
224 
225   /**
226    * @dev Throws if called by any account other than the owner.
227    */
228   modifier onlyOwner() {
229     require(msg.sender == owner);
230     _;
231   }
232 
233   /**
234    * @dev Allows the current owner to transfer control of the contract to a newOwner.
235    * @param newOwner The address to transfer ownership to.
236    */
237   function transferOwnership(address newOwner) public onlyOwner {
238     require(newOwner != address(0));
239     emit OwnershipTransferred(owner, newOwner);
240     owner = newOwner;
241   }
242 
243 }
244 
245 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
246 
247 /**
248  * @title Claimable
249  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
250  * This allows the new owner to accept the transfer.
251  */
252 contract Claimable is Ownable {
253   address public pendingOwner;
254 
255   /**
256    * @dev Modifier throws if called by any account other than the pendingOwner.
257    */
258   modifier onlyPendingOwner() {
259     require(msg.sender == pendingOwner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to set the pendingOwner address.
265    * @param newOwner The address to transfer ownership to.
266    */
267   function transferOwnership(address newOwner) onlyOwner public {
268     pendingOwner = newOwner;
269   }
270 
271   /**
272    * @dev Allows the pendingOwner address to finalize the transfer.
273    */
274   function claimOwnership() onlyPendingOwner public {
275     emit OwnershipTransferred(owner, pendingOwner);
276     owner = pendingOwner;
277     pendingOwner = address(0);
278   }
279 }
280 
281 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
282 
283 /**
284  * @title SafeMath
285  * @dev Math operations with safety checks that throw on error
286  */
287 library SafeMath {
288 
289   /**
290   * @dev Multiplies two numbers, throws on overflow.
291   */
292   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
293     if (a == 0) {
294       return 0;
295     }
296     c = a * b;
297     assert(c / a == b);
298     return c;
299   }
300 
301   /**
302   * @dev Integer division of two numbers, truncating the quotient.
303   */
304   function div(uint256 a, uint256 b) internal pure returns (uint256) {
305     // assert(b > 0); // Solidity automatically throws when dividing by 0
306     // uint256 c = a / b;
307     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308     return a / b;
309   }
310 
311   /**
312   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
313   */
314   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315     assert(b <= a);
316     return a - b;
317   }
318 
319   /**
320   * @dev Adds two numbers, throws on overflow.
321   */
322   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
323     c = a + b;
324     assert(c >= a);
325     return c;
326   }
327 }
328 
329 // File: contracts/modularERC20/BalanceSheet.sol
330 
331 // A wrapper around the balanceOf mapping.
332 contract BalanceSheet is Claimable {
333     using SafeMath for uint256;
334 
335     mapping (address => uint256) public balanceOf;
336 
337     function addBalance(address _addr, uint256 _value) public onlyOwner {
338         balanceOf[_addr] = balanceOf[_addr].add(_value);
339     }
340 
341     function subBalance(address _addr, uint256 _value) public onlyOwner {
342         balanceOf[_addr] = balanceOf[_addr].sub(_value);
343     }
344 
345     function setBalance(address _addr, uint256 _value) public onlyOwner {
346         balanceOf[_addr] = _value;
347     }
348 }
349 
350 // File: contracts/modularERC20/AllowanceSheet.sol
351 
352 // A wrapper around the allowanceOf mapping.
353 contract AllowanceSheet is Claimable {
354     using SafeMath for uint256;
355 
356     mapping (address => mapping (address => uint256)) public allowanceOf;
357 
358     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
359         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
360     }
361 
362     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
363         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
364     }
365 
366     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
367         allowanceOf[_tokenHolder][_spender] = _value;
368     }
369 }
370 
371 // File: contracts/ProxyStorage.sol
372 
373 /*
374 Defines the storage layout of the token implementaiton contract. Any newly declared
375 state variables in future upgrades should be appened to the bottom. Never remove state variables
376 from this list
377  */
378 contract ProxyStorage {
379     address public owner;
380     address public pendingOwner;
381 
382     bool initialized;
383     
384     BalanceSheet balances_Deprecated;
385     AllowanceSheet allowances_Deprecated;
386 
387     uint256 totalSupply_;
388     
389     bool private paused_Deprecated = false;
390     address private globalPause_Deprecated;
391 
392     uint256 public burnMin = 0;
393     uint256 public burnMax = 0;
394 
395     Registry public registry;
396 
397     string name_Deprecated;
398     string symbol_Deprecated;
399 
400     uint[] gasRefundPool_Deprecated;
401     uint256 private redemptionAddressCount_Deprecated;
402     uint256 public minimumGasPriceForFutureRefunds;
403 
404     mapping (address => uint256) _balanceOf;
405     mapping (address => mapping (address => uint256)) _allowance;
406     mapping (bytes32 => mapping (address => uint256)) attributes;
407 
408 
409     /* Additionally, we have several keccak-based storage locations.
410      * If you add more keccak-based storage mappings, such as mappings, you must document them here.
411      * If the length of the keccak input is the same as an existing mapping, it is possible there could be a preimage collision.
412      * A preimage collision can be used to attack the contract by treating one storage location as another,
413      * which would always be a critical issue.
414      * Carefully examine future keccak-based storage to ensure there can be no preimage collisions.
415      *******************************************************************************************************
416      ** length     input                                                         usage
417      *******************************************************************************************************
418      ** 19         "trueXXX.proxy.owner"                                         Proxy Owner
419      ** 27         "trueXXX.pending.proxy.owner"                                 Pending Proxy Owner
420      ** 28         "trueXXX.proxy.implementation"                                Proxy Implementation
421      ** 32         uint256(11)                                                   gasRefundPool_Deprecated
422      ** 64         uint256(address),uint256(14)                                  balanceOf
423      ** 64         uint256(address),keccak256(uint256(address),uint256(15))      allowance
424      ** 64         uint256(address),keccak256(bytes32,uint256(16))               attributes
425     **/
426 }
427 
428 // File: contracts/HasOwner.sol
429 
430 /**
431  * @title HasOwner
432  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
433  and provides basic authorization control functions. Inherits storage layout of 
434  ProxyStorage.
435  */
436 contract HasOwner is ProxyStorage {
437 
438     event OwnershipTransferred(
439         address indexed previousOwner,
440         address indexed newOwner
441     );
442 
443     /**
444     * @dev sets the original `owner` of the contract to the sender
445     * at construction. Must then be reinitialized 
446     */
447     constructor() public {
448         owner = msg.sender;
449         emit OwnershipTransferred(address(0), owner);
450     }
451 
452     /**
453     * @dev Throws if called by any account other than the owner.
454     */
455     modifier onlyOwner() {
456         require(msg.sender == owner, "only Owner");
457         _;
458     }
459 
460     /**
461     * @dev Modifier throws if called by any account other than the pendingOwner.
462     */
463     modifier onlyPendingOwner() {
464         require(msg.sender == pendingOwner);
465         _;
466     }
467 
468     /**
469     * @dev Allows the current owner to set the pendingOwner address.
470     * @param newOwner The address to transfer ownership to.
471     */
472     function transferOwnership(address newOwner) public onlyOwner {
473         pendingOwner = newOwner;
474     }
475 
476     /**
477     * @dev Allows the pendingOwner address to finalize the transfer.
478     */
479     function claimOwnership() public onlyPendingOwner {
480         emit OwnershipTransferred(owner, pendingOwner);
481         owner = pendingOwner;
482         pendingOwner = address(0);
483     }
484 }
485 
486 // File: contracts/ReclaimerToken.sol
487 
488 contract ReclaimerToken is HasOwner {
489     /**  
490     *@dev send all eth balance in the contract to another address
491     */
492     function reclaimEther(address _to) external onlyOwner {
493         _to.transfer(address(this).balance);
494     }
495 
496     /**  
497     *@dev send all token balance of an arbitary erc20 token
498     in the contract to another address
499     */
500     function reclaimToken(ERC20 token, address _to) external onlyOwner {
501         uint256 balance = token.balanceOf(this);
502         token.transfer(_to, balance);
503     }
504 
505     /**  
506     *@dev allows owner of the contract to gain ownership of any contract that the contract currently owns
507     */
508     function reclaimContract(Ownable _ownable) external onlyOwner {
509         _ownable.transferOwnership(owner);
510     }
511 
512 }
513 
514 // File: contracts/modularERC20/ModularBasicToken.sol
515 
516 // Fork of OpenZeppelin's BasicToken
517 /**
518  * @title Basic token
519  * @dev Basic version of StandardToken, with no allowances.
520  */
521 contract ModularBasicToken is HasOwner {
522     using SafeMath for uint256;
523 
524     event Transfer(address indexed from, address indexed to, uint256 value);
525 
526     /**
527     * @dev total number of tokens in existence
528     */
529     function totalSupply() public view returns (uint256) {
530         return totalSupply_;
531     }
532 
533     function balanceOf(address _who) public view returns (uint256) {
534         return _getBalance(_who);
535     }
536 
537     function _getBalance(address _who) internal view returns (uint256) {
538         return _balanceOf[_who];
539     }
540 
541     function _addBalance(address _who, uint256 _value) internal returns (uint256 priorBalance) {
542         priorBalance = _balanceOf[_who];
543         _balanceOf[_who] = priorBalance.add(_value);
544     }
545 
546     function _subBalance(address _who, uint256 _value) internal returns (uint256 result) {
547         result = _balanceOf[_who].sub(_value);
548         _balanceOf[_who] = result;
549     }
550 
551     function _setBalance(address _who, uint256 _value) internal {
552         _balanceOf[_who] = _value;
553     }
554 }
555 
556 // File: contracts/modularERC20/ModularStandardToken.sol
557 
558 /**
559  * @title Standard ERC20 token
560  *
561  * @dev Implementation of the basic standard token.
562  * @dev https://github.com/ethereum/EIPs/issues/20
563  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
564  */
565 contract ModularStandardToken is ModularBasicToken {
566     using SafeMath for uint256;
567     
568     event Approval(address indexed owner, address indexed spender, uint256 value);
569     
570     /**
571      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
572      *
573      * Beware that changing an allowance with this method brings the risk that someone may use both the old
574      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
575      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
576      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577      * @param _spender The address which will spend the funds.
578      * @param _value The amount of tokens to be spent.
579      */
580     function approve(address _spender, uint256 _value) public returns (bool) {
581         _approveAllArgs(_spender, _value, msg.sender);
582         return true;
583     }
584 
585     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
586         _setAllowance(_tokenHolder, _spender, _value);
587         emit Approval(_tokenHolder, _spender, _value);
588     }
589 
590     /**
591      * @dev Increase the amount of tokens that an owner allowed to a spender.
592      *
593      * approve should be called when allowed[_spender] == 0. To increment
594      * allowed value is better to use this function to avoid 2 calls (and wait until
595      * the first transaction is mined)
596      * From MonolithDAO Token.sol
597      * @param _spender The address which will spend the funds.
598      * @param _addedValue The amount of tokens to increase the allowance by.
599      */
600     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
601         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
602         return true;
603     }
604 
605     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
606         _addAllowance(_tokenHolder, _spender, _addedValue);
607         emit Approval(_tokenHolder, _spender, _getAllowance(_tokenHolder, _spender));
608     }
609 
610     /**
611      * @dev Decrease the amount of tokens that an owner allowed to a spender.
612      *
613      * approve should be called when allowed[_spender] == 0. To decrement
614      * allowed value is better to use this function to avoid 2 calls (and wait until
615      * the first transaction is mined)
616      * From MonolithDAO Token.sol
617      * @param _spender The address which will spend the funds.
618      * @param _subtractedValue The amount of tokens to decrease the allowance by.
619      */
620     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
621         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
622         return true;
623     }
624 
625     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
626         uint256 oldValue = _getAllowance(_tokenHolder, _spender);
627         uint256 newValue;
628         if (_subtractedValue > oldValue) {
629             newValue = 0;
630         } else {
631             newValue = oldValue - _subtractedValue;
632         }
633         _setAllowance(_tokenHolder, _spender, newValue);
634         emit Approval(_tokenHolder,_spender, newValue);
635     }
636 
637     function allowance(address _who, address _spender) public view returns (uint256) {
638         return _getAllowance(_who, _spender);
639     }
640 
641     function _getAllowance(address _who, address _spender) internal view returns (uint256 value) {
642         return _allowance[_who][_spender];
643     }
644 
645     function _addAllowance(address _who, address _spender, uint256 _value) internal {
646         _allowance[_who][_spender] = _allowance[_who][_spender].add(_value);
647     }
648 
649     function _subAllowance(address _who, address _spender, uint256 _value) internal returns (uint256 newAllowance){
650         newAllowance = _allowance[_who][_spender].sub(_value);
651         _allowance[_who][_spender] = newAllowance;
652     }
653 
654     function _setAllowance(address _who, address _spender, uint256 _value) internal {
655         _allowance[_who][_spender] = _value;
656     }
657 }
658 
659 // File: contracts/modularERC20/ModularBurnableToken.sol
660 
661 /**
662  * @title Burnable Token
663  * @dev Token that can be irreversibly burned (destroyed).
664  */
665 contract ModularBurnableToken is ModularStandardToken {
666     event Burn(address indexed burner, uint256 value);
667     event Mint(address indexed to, uint256 value);
668     uint256 constant CENT = 10 ** 16;
669 
670     function burn(uint256 _value) external {
671         _burnAllArgs(msg.sender, _value - _value % CENT);
672     }
673 
674     function _burnAllArgs(address _from, uint256 _value) internal {
675         // no need to require value <= totalSupply, since that would imply the
676         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
677         _subBalance(_from, _value);
678         totalSupply_ = totalSupply_.sub(_value);
679         emit Burn(_from, _value);
680         emit Transfer(_from, address(0), _value);
681     }
682 }
683 
684 // File: contracts/BurnableTokenWithBounds.sol
685 
686 /**
687  * @title Burnable Token WithBounds
688  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
689  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
690  */
691 contract BurnableTokenWithBounds is ModularBurnableToken {
692 
693     event SetBurnBounds(uint256 newMin, uint256 newMax);
694 
695     function _burnAllArgs(address _burner, uint256 _value) internal {
696         require(_value >= burnMin, "below min burn bound");
697         require(_value <= burnMax, "exceeds max burn bound");
698         super._burnAllArgs(_burner, _value);
699     }
700 
701     //Change the minimum and maximum amount that can be burned at once. Burning
702     //may be disabled by setting both to 0 (this will not be done under normal
703     //operation, but we can't add checks to disallow it without losing a lot of
704     //flexibility since burning could also be as good as disabled
705     //by setting the minimum extremely high, and we don't want to lock
706     //in any particular cap for the minimum)
707     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
708         require(_min <= _max, "min > max");
709         burnMin = _min;
710         burnMax = _max;
711         emit SetBurnBounds(_min, _max);
712     }
713 }
714 
715 // File: contracts/GasRefundToken.sol
716 
717 /**  
718 @title Gas Refund Token
719 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
720 Each time an non-empty storage slot is set to 0, evm refund 15,000 to the sender
721 of the transaction.
722 */
723 contract GasRefundToken is ProxyStorage {
724 
725     /**
726       A buffer of "Sheep" runs from 0xffff...fffe down
727       They suicide when you call them, if you are their parent
728     */
729 
730     function sponsorGas2() external {
731         /**
732         Deploy (9 bytes)
733           PC Assembly       Opcodes                                       Stack
734           00 PUSH1(31)      60 1f                                         1f
735           02 DUP1           80                                            1f 1f
736           03 PUSH1(9)       60 09                                         1f 1f 09
737           05 RETURNDATASIZE 3d                                            1f 1f 09 00
738           06 CODECOPY       39                                            1f
739           07 RETURNDATASIZE 3d                                            1f 00
740           08 RETURN         f3
741         Sheep (31 bytes = 3 + 20 + 8)
742           PC Assembly       Opcodes                                       Stack
743           00 RETURNDATASIZE 3d                                            0
744           01 CALLER         33                                            0 caller
745           02 PUSH20(me)     73 memememememememememememememememememememe   0 caller me
746           17 EQ             14                                            0 valid
747           18 PUSH1(1d)      60 1d                                         0 valid 1d
748           1a JUMPI          57                                            0
749           1b DUP1           80                                            0 0
750           1c REVERT         fd
751           1d JUMPDEST       5b                                            0
752           1e SELFDESTRUCT   ff
753         */
754         assembly {
755             mstore(0, or(0x601f8060093d393df33d33730000000000000000000000000000000000000000, address))
756             mstore(32,   0x14601d5780fd5bff000000000000000000000000000000000000000000000000)
757             let sheep := create(0, 0, 0x28)
758             let offset := sload(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
759             let location := sub(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe, offset)
760             sstore(location, sheep)
761             sheep := create(0, 0, 0x28)
762             sstore(sub(location, 1), sheep)
763             sheep := create(0, 0, 0x28)
764             sstore(sub(location, 2), sheep)
765             sstore(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, add(offset, 3))
766         }
767     }
768 
769     /**
770     @dev refund 39,000 gas
771     @dev costs slightly more than 16,100 gas
772     */
773     function gasRefund39() internal {
774         assembly {
775             let offset := sload(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
776             if gt(offset, 0) {
777               let location := sub(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,offset)
778               sstore(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, sub(offset, 1))
779               let sheep := sload(location)
780               pop(call(gas, sheep, 0, 0, 0, 0, 0))
781               sstore(location, 0)
782             }
783         }
784     }
785 
786     function sponsorGas() external {
787         uint256 refundPrice = minimumGasPriceForFutureRefunds;
788         require(refundPrice > 0);
789         assembly {
790             let offset := sload(0xfffff)
791             let result := add(offset, 9)
792             sstore(0xfffff, result)
793             let position := add(offset, 0x100000)
794             sstore(position, refundPrice)
795             position := add(position, 1)
796             sstore(position, refundPrice)
797             position := add(position, 1)
798             sstore(position, refundPrice)
799             position := add(position, 1)
800             sstore(position, refundPrice)
801             position := add(position, 1)
802             sstore(position, refundPrice)
803             position := add(position, 1)
804             sstore(position, refundPrice)
805             position := add(position, 1)
806             sstore(position, refundPrice)
807             position := add(position, 1)
808             sstore(position, refundPrice)
809             position := add(position, 1)
810             sstore(position, refundPrice)
811         }
812     }
813 
814     function minimumGasPriceForRefund() public view returns (uint256 result) {
815         assembly {
816             let offset := sload(0xfffff)
817             let location := add(offset, 0xfffff)
818             result := add(sload(location), 1)
819         }
820     }
821 
822     /**  
823     @dev refund 30,000 gas
824     @dev costs slightly more than 15,400 gas
825     */
826     function gasRefund30() internal {
827         assembly {
828             let offset := sload(0xfffff)
829             if gt(offset, 1) {
830                 let location := add(offset, 0xfffff)
831                 if gt(gasprice,sload(location)) {
832                     sstore(location, 0)
833                     location := sub(location, 1)
834                     sstore(location, 0)
835                     sstore(0xfffff, sub(offset, 2))
836                 }
837             }
838         }
839     }
840 
841     /**  
842     @dev refund 15,000 gas
843     @dev costs slightly more than 10,200 gas
844     */
845     function gasRefund15() internal {
846         assembly {
847             let offset := sload(0xfffff)
848             if gt(offset, 1) {
849                 let location := add(offset, 0xfffff)
850                 if gt(gasprice,sload(location)) {
851                     sstore(location, 0)
852                     sstore(0xfffff, sub(offset, 1))
853                 }
854             }
855         }
856     }
857 
858     /**  
859     *@dev Return the remaining sponsored gas slots
860     */
861     function remainingGasRefundPool() public view returns (uint length) {
862         assembly {
863             length := sload(0xfffff)
864         }
865     }
866 
867     function gasRefundPool(uint256 _index) public view returns (uint256 gasPrice) {
868         assembly {
869             gasPrice := sload(add(0x100000, _index))
870         }
871     }
872 
873     bytes32 constant CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE = "canSetFutureRefundMinGasPrice";
874 
875     function setMinimumGasPriceForFutureRefunds(uint256 _minimumGasPriceForFutureRefunds) public {
876         require(registry.hasAttribute(msg.sender, CAN_SET_FUTURE_REFUND_MIN_GAS_PRICE));
877         minimumGasPriceForFutureRefunds = _minimumGasPriceForFutureRefunds;
878     }
879 }
880 
881 // File: contracts/CompliantDepositTokenWithHook.sol
882 
883 contract CompliantDepositTokenWithHook is ReclaimerToken, RegistryClone, BurnableTokenWithBounds, GasRefundToken {
884 
885     bytes32 constant IS_REGISTERED_CONTRACT = "isRegisteredContract";
886     bytes32 constant IS_DEPOSIT_ADDRESS = "isDepositAddress";
887     uint256 constant REDEMPTION_ADDRESS_COUNT = 0x100000;
888     bytes32 constant IS_BLACKLISTED = "isBlacklisted";
889 
890     function canBurn() internal pure returns (bytes32);
891 
892     /**
893     * @dev transfer token for a specified address
894     * @param _to The address to transfer to.
895     * @param _value The amount to be transferred.
896     */
897     function transfer(address _to, uint256 _value) public returns (bool) {
898         _transferAllArgs(msg.sender, _to, _value);
899         return true;
900     }
901 
902     /**
903      * @dev Transfer tokens from one address to another
904      * @param _from address The address which you want to send tokens from
905      * @param _to address The address which you want to transfer to
906      * @param _value uint256 the amount of tokens to be transferred
907      */
908     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
909         _transferFromAllArgs(_from, _to, _value, msg.sender);
910         return true;
911     }
912 
913     function _burnFromAllowanceAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
914         _requireCanTransferFrom(_spender, _from, _to);
915         _requireOnlyCanBurn(_to);
916         require(_value >= burnMin, "below min burn bound");
917         require(_value <= burnMax, "exceeds max burn bound");
918         if (0 == _subBalance(_from, _value)) {
919             if (0 == _subAllowance(_from, _spender, _value)) {
920                 // no refund
921             } else {
922                 gasRefund15();
923             }
924         } else {
925             if (0 == _subAllowance(_from, _spender, _value)) {
926                 gasRefund15();
927             } else {
928                 gasRefund39();
929             }
930         }
931         emit Transfer(_from, _to, _value);
932         totalSupply_ = totalSupply_.sub(_value);
933         emit Burn(_to, _value);
934         emit Transfer(_to, address(0), _value);
935     }
936 
937     function _burnFromAllArgs(address _from, address _to, uint256 _value) internal {
938         _requireCanTransfer(_from, _to);
939         _requireOnlyCanBurn(_to);
940         require(_value >= burnMin, "below min burn bound");
941         require(_value <= burnMax, "exceeds max burn bound");
942         if (0 == _subBalance(_from, _value)) {
943             gasRefund15();
944         } else {
945             gasRefund30();
946         }
947         emit Transfer(_from, _to, _value);
948         totalSupply_ = totalSupply_.sub(_value);
949         emit Burn(_to, _value);
950         emit Transfer(_to, address(0), _value);
951     }
952 
953     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
954         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
955             _value -= _value % CENT;
956             _burnFromAllowanceAllArgs(_from, _to, _value, _spender);
957         } else {
958             bool hasHook;
959             address originalTo = _to;
960             (_to, hasHook) = _requireCanTransferFrom(_spender, _from, _to);
961             if (0 == _addBalance(_to, _value)) {
962                 if (0 == _subAllowance(_from, _spender, _value)) {
963                     if (0 == _subBalance(_from, _value)) {
964                         // do not refund
965                     } else {
966                         gasRefund30();
967                     }
968                 } else {
969                     if (0 == _subBalance(_from, _value)) {
970                         gasRefund30();
971                     } else {
972                         gasRefund39();
973                     }
974                 }
975             } else {
976                 if (0 == _subAllowance(_from, _spender, _value)) {
977                     if (0 == _subBalance(_from, _value)) {
978                         // do not refund
979                     } else {
980                         gasRefund15();
981                     }
982                 } else {
983                     if (0 == _subBalance(_from, _value)) {
984                         gasRefund15();
985                     } else {
986                         gasRefund39();
987                     }
988                 }
989 
990             }
991             emit Transfer(_from, originalTo, _value);
992             if (originalTo != _to) {
993                 emit Transfer(originalTo, _to, _value);
994                 if (hasHook) {
995                     TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
996                 }
997             } else {
998                 if (hasHook) {
999                     TrueCoinReceiver(_to).tokenFallback(_from, _value);
1000                 }
1001             }
1002         }
1003     }
1004 
1005     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
1006         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
1007             _value -= _value % CENT;
1008             _burnFromAllArgs(_from, _to, _value);
1009         } else {
1010             bool hasHook;
1011             address finalTo;
1012             (finalTo, hasHook) = _requireCanTransfer(_from, _to);
1013             if (0 == _subBalance(_from, _value)) {
1014                 if (0 == _addBalance(finalTo, _value)) {
1015                     gasRefund30();
1016                 } else {
1017                     // do not refund
1018                 }
1019             } else {
1020                 if (0 == _addBalance(finalTo, _value)) {
1021                     gasRefund39();
1022                 } else {
1023                     gasRefund30();
1024                 }
1025             }
1026             emit Transfer(_from, _to, _value);
1027             if (finalTo != _to) {
1028                 emit Transfer(_to, finalTo, _value);
1029                 if (hasHook) {
1030                     TrueCoinReceiver(finalTo).tokenFallback(_to, _value);
1031                 }
1032             } else {
1033                 if (hasHook) {
1034                     TrueCoinReceiver(finalTo).tokenFallback(_from, _value);
1035                 }
1036             }
1037         }
1038     }
1039 
1040     function mint(address _to, uint256 _value) public onlyOwner {
1041         require(_to != address(0), "to address cannot be zero");
1042         bool hasHook;
1043         address originalTo = _to;
1044         (_to, hasHook) = _requireCanMint(_to);
1045         totalSupply_ = totalSupply_.add(_value);
1046         emit Mint(originalTo, _value);
1047         emit Transfer(address(0), originalTo, _value);
1048         if (_to != originalTo) {
1049             emit Transfer(originalTo, _to, _value);
1050         }
1051         _addBalance(_to, _value);
1052         if (hasHook) {
1053             if (_to != originalTo) {
1054                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
1055             } else {
1056                 TrueCoinReceiver(_to).tokenFallback(address(0), _value);
1057             }
1058         }
1059     }
1060 
1061     event WipeBlacklistedAccount(address indexed account, uint256 balance);
1062     event SetRegistry(address indexed registry);
1063 
1064     /**
1065     * @dev Point to the registry that contains all compliance related data
1066     @param _registry The address of the registry instance
1067     */
1068     function setRegistry(Registry _registry) public onlyOwner {
1069         registry = _registry;
1070         emit SetRegistry(registry);
1071     }
1072 
1073     modifier onlyRegistry {
1074       require(msg.sender == address(registry));
1075       _;
1076     }
1077 
1078     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) public onlyRegistry {
1079         attributes[_attribute][_who] = _value;
1080     }
1081 
1082     function _burnAllArgs(address _from, uint256 _value) internal {
1083         _requireCanBurn(_from);
1084         super._burnAllArgs(_from, _value);
1085     }
1086 
1087     // Destroy the tokens owned by a blacklisted account
1088     function wipeBlacklistedAccount(address _account) public onlyOwner {
1089         require(_isBlacklisted(_account), "_account is not blacklisted");
1090         uint256 oldValue = _getBalance(_account);
1091         _setBalance(_account, 0);
1092         totalSupply_ = totalSupply_.sub(oldValue);
1093         emit WipeBlacklistedAccount(_account, oldValue);
1094         emit Transfer(_account, address(0), oldValue);
1095     }
1096 
1097     function _isBlacklisted(address _account) internal view returns (bool blacklisted) {
1098         return attributes[IS_BLACKLISTED][_account] != 0;
1099     }
1100 
1101     function _requireCanTransfer(address _from, address _to) internal view returns (address, bool) {
1102         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1103         if (depositAddressValue != 0) {
1104             _to = address(depositAddressValue);
1105         }
1106         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1107         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1108         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1109     }
1110 
1111     function _requireCanTransferFrom(address _spender, address _from, address _to) internal view returns (address, bool) {
1112         require (attributes[IS_BLACKLISTED][_spender] == 0, "blacklisted");
1113         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1114         if (depositAddressValue != 0) {
1115             _to = address(depositAddressValue);
1116         }
1117         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1118         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1119         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1120     }
1121 
1122     function _requireCanMint(address _to) internal view returns (address, bool) {
1123         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1124         if (depositAddressValue != 0) {
1125             _to = address(depositAddressValue);
1126         }
1127         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1128         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1129     }
1130 
1131     function _requireOnlyCanBurn(address _from) internal view {
1132         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1133     }
1134 
1135     function _requireCanBurn(address _from) internal view {
1136         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1137         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1138     }
1139 
1140     function paused() public pure returns (bool) {
1141         return false;
1142     }
1143 }
1144 
1145 // File: contracts/DelegateERC20.sol
1146 
1147 /** @title DelegateERC20
1148 Accept forwarding delegation calls from the old TrueUSD (V1) contract. This way the all the ERC20
1149 functions in the old contract still works (except Burn). 
1150 */
1151 contract DelegateERC20 is CompliantDepositTokenWithHook {
1152 
1153     address constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1154     
1155     modifier onlyDelegateFrom() {
1156         require(msg.sender == DELEGATE_FROM);
1157         _;
1158     }
1159 
1160     function delegateTotalSupply() public view returns (uint256) {
1161         return totalSupply();
1162     }
1163 
1164     function delegateBalanceOf(address who) public view returns (uint256) {
1165         return _getBalance(who);
1166     }
1167 
1168     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1169         _transferAllArgs(origSender, to, value);
1170         return true;
1171     }
1172 
1173     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1174         return _getAllowance(owner, spender);
1175     }
1176 
1177     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1178         _transferFromAllArgs(from, to, value, origSender);
1179         return true;
1180     }
1181 
1182     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1183         _approveAllArgs(spender, value, origSender);
1184         return true;
1185     }
1186 
1187     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1188         _increaseApprovalAllArgs(spender, addedValue, origSender);
1189         return true;
1190     }
1191 
1192     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1193         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1194         return true;
1195     }
1196 }
1197 
1198 // File: contracts/TrueUSD.sol
1199 
1200 /** @title TrueUSD
1201 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1202 * inherited - see the documentation on the corresponding contracts.
1203 */
1204 contract TrueUSD is 
1205 CompliantDepositTokenWithHook,
1206 DelegateERC20 {
1207     uint8 constant DECIMALS = 18;
1208     uint8 constant ROUNDING = 2;
1209 
1210     function decimals() public pure returns (uint8) {
1211         return DECIMALS;
1212     }
1213 
1214     function rounding() public pure returns (uint8) {
1215         return ROUNDING;
1216     }
1217 
1218     function name() public pure returns (string) {
1219         return "TrueUSD";
1220     }
1221 
1222     function symbol() public pure returns (string) {
1223         return "TUSD";
1224     }
1225 
1226     function canBurn() internal pure returns (bytes32) {
1227         return "canBurn";
1228     }
1229 }