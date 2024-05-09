1 // File: contracts/TrueCoinReceiver.sol
2 
3 pragma solidity >=0.4.25 <0.6.0;
4 
5 contract TrueCoinReceiver {
6     function tokenFallback( address from, uint256 value ) external;
7 }
8 
9 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
10 
11 pragma solidity ^0.5.2;
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://eips.ethereum.org/EIPS/eip-20
16  */
17 interface IERC20 {
18     function transfer(address to, uint256 value) external returns (bool);
19 
20     function approve(address spender, uint256 value) external returns (bool);
21 
22     function transferFrom(address from, address to, uint256 value) external returns (bool);
23 
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address who) external view returns (uint256);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
36 
37 pragma solidity ^0.5.2;
38 
39 /**
40  * @title SafeMath
41  * @dev Unsigned math operations with safety checks that revert on error
42  */
43 library SafeMath {
44     /**
45      * @dev Multiplies two unsigned integers, reverts on overflow.
46      */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
63      */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Solidity only automatically asserts when dividing by 0
66         require(b > 0);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Adds two unsigned integers, reverts on overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a);
89 
90         return c;
91     }
92 
93     /**
94      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
95      * reverts when dividing by zero.
96      */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0);
99         return a % b;
100     }
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
104 
105 pragma solidity ^0.5.2;
106 
107 
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://eips.ethereum.org/EIPS/eip-20
114  * Originally based on code by FirstBlood:
115  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  *
117  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
118  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
119  * compliant implementations may not do it.
120  */
121 contract ERC20 is IERC20 {
122     using SafeMath for uint256;
123 
124     mapping (address => uint256) private _balances;
125 
126     mapping (address => mapping (address => uint256)) private _allowed;
127 
128     uint256 private _totalSupply;
129 
130     /**
131      * @dev Total number of tokens in existence
132      */
133     function totalSupply() public view returns (uint256) {
134         return _totalSupply;
135     }
136 
137     /**
138      * @dev Gets the balance of the specified address.
139      * @param owner The address to query the balance of.
140      * @return A uint256 representing the amount owned by the passed address.
141      */
142     function balanceOf(address owner) public view returns (uint256) {
143         return _balances[owner];
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param owner address The address which owns the funds.
149      * @param spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address owner, address spender) public view returns (uint256) {
153         return _allowed[owner][spender];
154     }
155 
156     /**
157      * @dev Transfer token to a specified address
158      * @param to The address to transfer to.
159      * @param value The amount to be transferred.
160      */
161     function transfer(address to, uint256 value) public returns (bool) {
162         _transfer(msg.sender, to, value);
163         return true;
164     }
165 
166     /**
167      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168      * Beware that changing an allowance with this method brings the risk that someone may use both the old
169      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      * @param spender The address which will spend the funds.
173      * @param value The amount of tokens to be spent.
174      */
175     function approve(address spender, uint256 value) public returns (bool) {
176         _approve(msg.sender, spender, value);
177         return true;
178     }
179 
180     /**
181      * @dev Transfer tokens from one address to another.
182      * Note that while this function emits an Approval event, this is not required as per the specification,
183      * and other compliant implementations may not emit the event.
184      * @param from address The address which you want to send tokens from
185      * @param to address The address which you want to transfer to
186      * @param value uint256 the amount of tokens to be transferred
187      */
188     function transferFrom(address from, address to, uint256 value) public returns (bool) {
189         _transfer(from, to, value);
190         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
191         return true;
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
206         return true;
207     }
208 
209     /**
210      * @dev Decrease the amount of tokens that an owner allowed to a spender.
211      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * From MonolithDAO Token.sol
215      * Emits an Approval event.
216      * @param spender The address which will spend the funds.
217      * @param subtractedValue The amount of tokens to decrease the allowance by.
218      */
219     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
220         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
221         return true;
222     }
223 
224     /**
225      * @dev Transfer token for a specified addresses
226      * @param from The address to transfer from.
227      * @param to The address to transfer to.
228      * @param value The amount to be transferred.
229      */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that mints an amount of the token and assigns it to
240      * an account. This encapsulates the modification of balances such that the
241      * proper events are emitted.
242      * @param account The account that will receive the created tokens.
243      * @param value The amount that will be created.
244      */
245     function _mint(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.add(value);
249         _balances[account] = _balances[account].add(value);
250         emit Transfer(address(0), account, value);
251     }
252 
253     /**
254      * @dev Internal function that burns an amount of the token of a given
255      * account.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burn(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.sub(value);
263         _balances[account] = _balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265     }
266 
267     /**
268      * @dev Approve an address to spend another addresses' tokens.
269      * @param owner The address that owns the tokens.
270      * @param spender The address that will spend the tokens.
271      * @param value The number of tokens that can be spent.
272      */
273     function _approve(address owner, address spender, uint256 value) internal {
274         require(spender != address(0));
275         require(owner != address(0));
276 
277         _allowed[owner][spender] = value;
278         emit Approval(owner, spender, value);
279     }
280 
281     /**
282      * @dev Internal function that burns an amount of the token of a given
283      * account, deducting from the sender's allowance for said account. Uses the
284      * internal burn function.
285      * Emits an Approval event (reflecting the reduced allowance).
286      * @param account The account whose tokens will be burnt.
287      * @param value The amount that will be burnt.
288      */
289     function _burnFrom(address account, uint256 value) internal {
290         _burn(account, value);
291         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
292     }
293 }
294 
295 // File: registry/contracts/Registry.sol
296 
297 pragma solidity >=0.4.25 <0.6.0;
298 
299 
300 interface RegistryClone {
301     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) external;
302 }
303 
304 contract Registry {
305     struct AttributeData {
306         uint256 value;
307         bytes32 notes;
308         address adminAddr;
309         uint256 timestamp;
310     }
311     
312     // never remove any storage variables
313     address public owner;
314     address public pendingOwner;
315     bool initialized;
316 
317     // Stores arbitrary attributes for users. An example use case is an ERC20
318     // token that requires its users to go through a KYC/AML check - in this case
319     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
320     // that account can use the token. This mapping stores that value (1, in the
321     // example) as well as which validator last set the value and at what time,
322     // so that e.g. the check can be renewed at appropriate intervals.
323     mapping(address => mapping(bytes32 => AttributeData)) attributes;
324     // The logic governing who is allowed to set what attributes is abstracted as
325     // this accessManager, so that it may be replaced by the owner as needed
326     bytes32 constant WRITE_PERMISSION = keccak256("canWriteTo-");
327     mapping(bytes32 => RegistryClone[]) subscribers;
328 
329     event OwnershipTransferred(
330         address indexed previousOwner,
331         address indexed newOwner
332     );
333     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
334     event SetManager(address indexed oldManager, address indexed newManager);
335     event StartSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
336     event StopSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
337 
338     // Allows a write if either a) the writer is that Registry's owner, or
339     // b) the writer is writing to attribute foo and that writer already has
340     // the canWriteTo-foo attribute set (in that same Registry)
341     function confirmWrite(bytes32 _attribute, address _admin) internal view returns (bool) {
342         bytes32 attr =  WRITE_PERMISSION ^ _attribute;
343         bytes32 kesres = bytes32(keccak256(abi.encodePacked(attr)));
344         return (_admin == owner || hasAttribute(_admin, kesres));
345     }
346 
347     // Writes are allowed only if the accessManager approves
348     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
349         require(confirmWrite(_attribute, msg.sender));
350         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
351         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
352 
353         RegistryClone[] storage targets = subscribers[_attribute];
354         uint256 index = targets.length;
355         while (index --> 0) {
356             targets[index].syncAttributeValue(_who, _attribute, _value);
357         }
358     }
359 
360     function subscribe(bytes32 _attribute, RegistryClone _syncer) external onlyOwner {
361         subscribers[_attribute].push(_syncer);
362         emit StartSubscription(_attribute, _syncer);
363     }
364 
365     function unsubscribe(bytes32 _attribute, uint256 _index) external onlyOwner {
366         uint256 length = subscribers[_attribute].length;
367         require(_index < length);
368         emit StopSubscription(_attribute, subscribers[_attribute][_index]);
369         subscribers[_attribute][_index] = subscribers[_attribute][length - 1];
370         subscribers[_attribute].length = length - 1;
371     }
372 
373     function subscriberCount(bytes32 _attribute) public view returns (uint256) {
374         return subscribers[_attribute].length;
375     }
376 
377     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
378         require(confirmWrite(_attribute, msg.sender));
379         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
380         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
381         RegistryClone[] storage targets = subscribers[_attribute];
382         uint256 index = targets.length;
383         while (index --> 0) {
384             targets[index].syncAttributeValue(_who, _attribute, _value);
385         }
386     }
387 
388     // Returns true if the uint256 value stored for this attribute is non-zero
389     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
390         return attributes[_who][_attribute].value != 0;
391     }
392 
393 
394     // Returns the exact value of the attribute, as well as its metadata
395     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
396         AttributeData memory data = attributes[_who][_attribute];
397         return (data.value, data.notes, data.adminAddr, data.timestamp);
398     }
399 
400     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
401         return attributes[_who][_attribute].value;
402     }
403 
404     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
405         return attributes[_who][_attribute].adminAddr;
406     }
407 
408     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
409         return attributes[_who][_attribute].timestamp;
410     }
411 
412     function syncAttribute(bytes32 _attribute, uint256 _startIndex, address[] calldata _addresses) external {
413         RegistryClone[] storage targets = subscribers[_attribute];
414         uint256 index = targets.length;
415         while (index --> _startIndex) {
416             RegistryClone target = targets[index];
417             for (uint256 i = _addresses.length; i --> 0; ) {
418                 address who = _addresses[i];
419                 target.syncAttributeValue(who, _attribute, attributes[who][_attribute].value);
420             }
421         }
422     }
423 
424     function reclaimEther(address payable _to) external onlyOwner {
425         _to.transfer(address(this).balance);
426     }
427 
428     function reclaimToken(ERC20 token, address _to) external onlyOwner {
429         uint256 balance = token.balanceOf(address(this));
430         token.transfer(_to, balance);
431     }
432 
433    /**
434     * @dev Throws if called by any account other than the owner.
435     */
436     modifier onlyOwner() {
437         require(msg.sender == owner, "only Owner");
438         _;
439     }
440 
441     /**
442     * @dev Modifier throws if called by any account other than the pendingOwner.
443     */
444     modifier onlyPendingOwner() {
445         require(msg.sender == pendingOwner);
446         _;
447     }
448 
449     /**
450     * @dev Allows the current owner to set the pendingOwner address.
451     * @param newOwner The address to transfer ownership to.
452     */
453     function transferOwnership(address newOwner) public onlyOwner {
454         pendingOwner = newOwner;
455     }
456 
457     /**
458     * @dev Allows the pendingOwner address to finalize the transfer.
459     */
460     function claimOwnership() public onlyPendingOwner {
461         emit OwnershipTransferred(owner, pendingOwner);
462         owner = pendingOwner;
463         pendingOwner = address(0);
464     }
465 }
466 
467 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
468 
469 pragma solidity ^0.5.2;
470 
471 /**
472  * @title Ownable
473  * @dev The Ownable contract has an owner address, and provides basic authorization control
474  * functions, this simplifies the implementation of "user permissions".
475  */
476 contract Ownable {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
483      * account.
484      */
485     constructor () internal {
486         _owner = msg.sender;
487         emit OwnershipTransferred(address(0), _owner);
488     }
489 
490     /**
491      * @return the address of the owner.
492      */
493     function owner() public view returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(isOwner());
502         _;
503     }
504 
505     /**
506      * @return true if `msg.sender` is the owner of the contract.
507      */
508     function isOwner() public view returns (bool) {
509         return msg.sender == _owner;
510     }
511 
512     /**
513      * @dev Allows the current owner to relinquish control of the contract.
514      * It will not be possible to call the functions with the `onlyOwner`
515      * modifier anymore.
516      * @notice Renouncing ownership will leave the contract without an owner,
517      * thereby removing any functionality that is only available to the owner.
518      */
519     function renounceOwnership() public onlyOwner {
520         emit OwnershipTransferred(_owner, address(0));
521         _owner = address(0);
522     }
523 
524     /**
525      * @dev Allows the current owner to transfer control of the contract to a newOwner.
526      * @param newOwner The address to transfer ownership to.
527      */
528     function transferOwnership(address newOwner) public onlyOwner {
529         _transferOwnership(newOwner);
530     }
531 
532     /**
533      * @dev Transfers control of the contract to a newOwner.
534      * @param newOwner The address to transfer ownership to.
535      */
536     function _transferOwnership(address newOwner) internal {
537         require(newOwner != address(0));
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542 
543 // File: contracts/Claimable.sol
544 
545 pragma solidity >=0.4.25 <0.6.0;
546 
547 
548 contract Claimable is Ownable {
549   address public pendingOwner;
550 
551   modifier onlyPendingOwner() {
552     if (msg.sender == pendingOwner)
553       _;
554   }
555 
556   function transferOwnership(address newOwner) public onlyOwner {
557     pendingOwner = newOwner;
558   }
559 
560   function claimOwnership() onlyPendingOwner public {
561     _transferOwnership(pendingOwner);
562     pendingOwner = address(0x0);
563   }
564 
565 }
566 
567 // File: contracts/modularERC20/BalanceSheet.sol
568 
569 pragma solidity >=0.4.25 <0.6.0;
570 
571 
572 
573 // A wrapper around the balanceOf mapping.
574 contract BalanceSheet is Claimable {
575     using SafeMath for uint256;
576 
577     mapping (address => uint256) public balanceOf;
578 
579     function addBalance(address _addr, uint256 _value) public onlyOwner {
580         balanceOf[_addr] = balanceOf[_addr].add(_value);
581     }
582 
583     function subBalance(address _addr, uint256 _value) public onlyOwner {
584         balanceOf[_addr] = balanceOf[_addr].sub(_value);
585     }
586 
587     function setBalance(address _addr, uint256 _value) public onlyOwner {
588         balanceOf[_addr] = _value;
589     }
590 }
591 
592 // File: contracts/modularERC20/AllowanceSheet.sol
593 
594 pragma solidity >=0.4.25 <0.6.0;
595 
596 
597 
598 // A wrapper around the allowanceOf mapping.
599 contract AllowanceSheet is Claimable {
600     using SafeMath for uint256;
601 
602     mapping (address => mapping (address => uint256)) public allowanceOf;
603 
604     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
605         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
606     }
607 
608     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
609         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
610     }
611 
612     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
613         allowanceOf[_tokenHolder][_spender] = _value;
614     }
615 }
616 
617 // File: contracts/ProxyStorage.sol
618 
619 pragma solidity >=0.4.25 <0.6.0;
620 
621 
622 
623 
624 /*
625 Defines the storage layout of the token implementaiton contract. Any newly declared
626 state variables in future upgrades should be appened to the bottom. Never remove state variables
627 from this list
628  */
629 contract ProxyStorage {
630     address public owner;
631     address public pendingOwner;
632 
633     bool initialized;
634     
635     BalanceSheet balances_Deprecated;
636     AllowanceSheet allowances_Deprecated;
637 
638     uint256 totalSupply_;
639     
640     bool private paused_Deprecated = false;
641     address private globalPause_Deprecated;
642 
643     uint256 public burnMin = 0;
644     uint256 public burnMax = 0;
645 
646     Registry public registry;
647 
648     string name_Deprecated;
649     string symbol_Deprecated;
650 
651     uint[] gasRefundPool_Deprecated;
652     uint256 private redemptionAddressCount_Deprecated;
653     uint256 public minimumGasPriceForFutureRefunds;
654 
655     mapping (address => uint256) _balanceOf;
656     mapping (address => mapping (address => uint256)) _allowance;
657     mapping (bytes32 => mapping (address => uint256)) attributes;
658 
659 
660     /* Additionally, we have several keccak-based storage locations.
661      * If you add more keccak-based storage mappings, such as mappings, you must document them here.
662      * If the length of the keccak input is the same as an existing mapping, it is possible there could be a preimage collision.
663      * A preimage collision can be used to attack the contract by treating one storage location as another,
664      * which would always be a critical issue.
665      * Carefully examine future keccak-based storage to ensure there can be no preimage collisions.
666      *******************************************************************************************************
667      ** length     input                                                         usage
668      *******************************************************************************************************
669      ** 19         "trueXXX.proxy.owner"                                         Proxy Owner
670      ** 27         "trueXXX.pending.proxy.owner"                                 Pending Proxy Owner
671      ** 28         "trueXXX.proxy.implementation"                                Proxy Implementation
672      ** 32         uint256(11)                                                   gasRefundPool_Deprecated
673      ** 64         uint256(address),uint256(14)                                  balanceOf
674      ** 64         uint256(address),keccak256(uint256(address),uint256(15))      allowance
675      ** 64         uint256(address),keccak256(bytes32,uint256(16))               attributes
676     **/
677 }
678 
679 // File: contracts/HasOwner.sol
680 
681 pragma solidity >=0.4.25 <0.6.0;
682 
683 
684 /**
685  * @title HasOwner
686  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
687  and provides basic authorization control functions. Inherits storage layout of 
688  ProxyStorage.
689  */
690 contract HasOwner is ProxyStorage {
691 
692     event OwnershipTransferred(
693         address indexed previousOwner,
694         address indexed newOwner
695     );
696 
697     /**
698     * @dev sets the original `owner` of the contract to the sender
699     * at construction. Must then be reinitialized 
700     */
701     constructor() public {
702         owner = msg.sender;
703         emit OwnershipTransferred(address(0), owner);
704     }
705 
706     /**
707     * @dev Throws if called by any account other than the owner.
708     */
709     modifier onlyOwner() {
710         require(msg.sender == owner, "only Owner");
711         _;
712     }
713 
714     /**
715     * @dev Modifier throws if called by any account other than the pendingOwner.
716     */
717     modifier onlyPendingOwner() {
718         require(msg.sender == pendingOwner);
719         _;
720     }
721 
722     /**
723     * @dev Allows the current owner to set the pendingOwner address.
724     * @param newOwner The address to transfer ownership to.
725     */
726     function transferOwnership(address newOwner) public onlyOwner {
727         pendingOwner = newOwner;
728     }
729 
730     /**
731     * @dev Allows the pendingOwner address to finalize the transfer.
732     */
733     function claimOwnership() public onlyPendingOwner {
734         emit OwnershipTransferred(owner, pendingOwner);
735         owner = pendingOwner;
736         pendingOwner = address(0);
737     }
738 }
739 
740 // File: contracts/ReclaimerToken.sol
741 
742 pragma solidity >=0.4.25 <0.6.0;
743 
744 
745 contract ReclaimerToken is HasOwner {
746     /**  
747     *@dev send all eth balance in the contract to another address
748     */
749     function reclaimEther(address payable _to) external onlyOwner {
750         _to.transfer(address(this).balance);
751     }
752 
753     /**  
754     *@dev send all token balance of an arbitary erc20 token
755     in the contract to another address
756     */
757     function reclaimToken(ERC20 token, address _to) external onlyOwner {
758         uint256 balance = token.balanceOf(address(this));
759         token.transfer(_to, balance);
760     }
761 
762     /**  
763     *@dev allows owner of the contract to gain ownership of any contract that the contract currently owns
764     */
765     function reclaimContract(Ownable _ownable) external onlyOwner {
766         _ownable.transferOwnership(owner);
767     }
768 
769 }
770 
771 // File: contracts/modularERC20/ModularBasicToken.sol
772 
773 pragma solidity >=0.4.25 <0.6.0;
774 
775 
776 
777 // Fork of OpenZeppelin's BasicToken
778 /**
779  * @title Basic token
780  * @dev Basic version of StandardToken, with no allowances.
781  */
782 contract ModularBasicToken is HasOwner {
783     using SafeMath for uint256;
784 
785     event Transfer(address indexed from, address indexed to, uint256 value);
786 
787     /**
788     * @dev total number of tokens in existence
789     */
790     function totalSupply() public view returns (uint256) {
791         return totalSupply_;
792     }
793 
794     function balanceOf(address _who) public view returns (uint256) {
795         return _getBalance(_who);
796     }
797 
798     function _getBalance(address _who) internal view returns (uint256) {
799         return _balanceOf[_who];
800     }
801 
802     function _addBalance(address _who, uint256 _value) internal returns (uint256 priorBalance) {
803         priorBalance = _balanceOf[_who];
804         _balanceOf[_who] = priorBalance.add(_value);
805     }
806 
807     function _subBalance(address _who, uint256 _value) internal returns (uint256 result) {
808         result = _balanceOf[_who].sub(_value);
809         _balanceOf[_who] = result;
810     }
811 
812     function _setBalance(address _who, uint256 _value) internal {
813         _balanceOf[_who] = _value;
814     }
815 }
816 
817 // File: contracts/modularERC20/ModularStandardToken.sol
818 
819 pragma solidity >=0.4.25 <0.6.0;
820 
821 
822 
823 /**
824  * @title Standard ERC20 token
825  *
826  * @dev Implementation of the basic standard token.
827  * @dev https://github.com/ethereum/EIPs/issues/20
828  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
829  */
830 contract ModularStandardToken is ModularBasicToken {
831     using SafeMath for uint256;
832     
833     event Approval(address indexed owner, address indexed spender, uint256 value);
834     
835     /**
836      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
837      *
838      * Beware that changing an allowance with this method brings the risk that someone may use both the old
839      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
840      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
841      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
842      * @param _spender The address which will spend the funds.
843      * @param _value The amount of tokens to be spent.
844      */
845     function approve(address _spender, uint256 _value) public returns (bool) {
846         _approveAllArgs(_spender, _value, msg.sender);
847         return true;
848     }
849 
850     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
851         _setAllowance(_tokenHolder, _spender, _value);
852         emit Approval(_tokenHolder, _spender, _value);
853     }
854 
855     /**
856      * @dev Increase the amount of tokens that an owner allowed to a spender.
857      *
858      * approve should be called when allowed[_spender] == 0. To increment
859      * allowed value is better to use this function to avoid 2 calls (and wait until
860      * the first transaction is mined)
861      * From MonolithDAO Token.sol
862      * @param _spender The address which will spend the funds.
863      * @param _addedValue The amount of tokens to increase the allowance by.
864      */
865     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
866         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
867         return true;
868     }
869 
870     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
871         _addAllowance(_tokenHolder, _spender, _addedValue);
872         emit Approval(_tokenHolder, _spender, _getAllowance(_tokenHolder, _spender));
873     }
874 
875     /**
876      * @dev Decrease the amount of tokens that an owner allowed to a spender.
877      *
878      * approve should be called when allowed[_spender] == 0. To decrement
879      * allowed value is better to use this function to avoid 2 calls (and wait until
880      * the first transaction is mined)
881      * From MonolithDAO Token.sol
882      * @param _spender The address which will spend the funds.
883      * @param _subtractedValue The amount of tokens to decrease the allowance by.
884      */
885     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
886         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
887         return true;
888     }
889 
890     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
891         uint256 oldValue = _getAllowance(_tokenHolder, _spender);
892         uint256 newValue;
893         if (_subtractedValue > oldValue) {
894             newValue = 0;
895         } else {
896             newValue = oldValue - _subtractedValue;
897         }
898         _setAllowance(_tokenHolder, _spender, newValue);
899         emit Approval(_tokenHolder,_spender, newValue);
900     }
901 
902     function allowance(address _who, address _spender) public view returns (uint256) {
903         return _getAllowance(_who, _spender);
904     }
905 
906     function _getAllowance(address _who, address _spender) internal view returns (uint256 value) {
907         return _allowance[_who][_spender];
908     }
909 
910     function _addAllowance(address _who, address _spender, uint256 _value) internal {
911         _allowance[_who][_spender] = _allowance[_who][_spender].add(_value);
912     }
913 
914     function _subAllowance(address _who, address _spender, uint256 _value) internal returns (uint256 newAllowance){
915         newAllowance = _allowance[_who][_spender].sub(_value);
916         _allowance[_who][_spender] = newAllowance;
917     }
918 
919     function _setAllowance(address _who, address _spender, uint256 _value) internal {
920         _allowance[_who][_spender] = _value;
921     }
922 }
923 
924 // File: contracts/modularERC20/ModularBurnableToken.sol
925 
926 pragma solidity >=0.4.25 <0.6.0;
927 
928 
929 /**
930  * @title Burnable Token
931  * @dev Token that can be irreversibly burned (destroyed).
932  */
933 contract ModularBurnableToken is ModularStandardToken {
934     event Burn(address indexed burner, uint256 value);
935     event Mint(address indexed to, uint256 value);
936     uint256 constant CENT = 10 ** 6;
937 
938     function burn(uint256 _value) external {
939         _burnAllArgs(msg.sender, _value - _value % CENT);
940     }
941 
942     function _burnAllArgs(address _from, uint256 _value) internal {
943         // no need to require value <= totalSupply, since that would imply the
944         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
945         _subBalance(_from, _value);
946         totalSupply_ = totalSupply_.sub(_value);
947         emit Burn(_from, _value);
948         emit Transfer(_from, address(0), _value);
949     }
950 }
951 
952 // File: contracts/BurnableTokenWithBounds.sol
953 
954 pragma solidity >=0.4.25 <0.6.0;
955 
956 
957 /**
958  * @title Burnable Token WithBounds
959  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
960  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
961  */
962 contract BurnableTokenWithBounds is ModularBurnableToken {
963 
964     event SetBurnBounds(uint256 newMin, uint256 newMax);
965 
966     function _burnAllArgs(address _burner, uint256 _value) internal {
967         require(_value >= burnMin, "below min burn bound");
968         require(_value <= burnMax, "exceeds max burn bound");
969         super._burnAllArgs(_burner, _value);
970     }
971 
972     //Change the minimum and maximum amount that can be burned at once. Burning
973     //may be disabled by setting both to 0 (this will not be done under normal
974     //operation, but we can't add checks to disallow it without losing a lot of
975     //flexibility since burning could also be as good as disabled
976     //by setting the minimum extremely high, and we don't want to lock
977     //in any particular cap for the minimum)
978     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
979         require(_min <= _max, "min > max");
980         burnMin = _min;
981         burnMax = _max;
982         emit SetBurnBounds(_min, _max);
983     }
984 }
985 
986 // File: contracts/CompliantDepositTokenWithHook.sol
987 
988 pragma solidity >=0.4.25 <0.6.0;
989 
990 
991 
992 
993 
994 
995 contract CompliantDepositTokenWithHook is ReclaimerToken, RegistryClone, BurnableTokenWithBounds {
996 
997     bytes32 constant IS_REGISTERED_CONTRACT = "isRegisteredContract";
998     bytes32 constant IS_DEPOSIT_ADDRESS = "isDepositAddress";
999     uint256 constant REDEMPTION_ADDRESS_COUNT = 0x100000;
1000     bytes32 constant IS_BLACKLISTED = "isBlacklisted";
1001     uint256 _transferFee = 0;
1002     uint8   _transferFeeMode = 0;
1003 
1004     function canBurn() internal pure returns (bytes32);
1005 
1006     function setTransferFee(uint256 transferFee) public onlyOwner returns(bool){
1007         _transferFee = transferFee;
1008         return true;
1009     }
1010 
1011     function setTransferFeeMode(uint8 transferFeeMode) public onlyOwner returns (bool){
1012         _transferFeeMode = transferFeeMode;
1013         return true;
1014     }
1015 
1016     function transferFee() public view returns (uint256){
1017         return _transferFee;
1018     }
1019 
1020     function transferFeeMode() public view returns (uint8){
1021         return _transferFeeMode;
1022     }
1023 
1024     /**
1025     * @dev calculates fee required for the transfer
1026     * @param amount The address to transfer to.
1027     */
1028     function getTransactionFee(uint256 amount) public view returns (uint256){
1029         return amount.mul(_transferFee).div(8 ** 10);
1030     }
1031 
1032     /**
1033     * @dev transfer token for a specified address
1034     * @param _to The address to transfer to.
1035     * @param _value The amount to be transferred.
1036     */
1037     function transfer(address _to, uint256 _value) public returns (bool) {
1038         uint256 transfer_fee = getTransactionFee(_value);
1039         if(_transferFeeMode == 0 || transfer_fee == 0 ){
1040             _transferAllArgs(msg.sender, _to, _value);
1041         } else if(_transferFeeMode == 1){
1042             _transferAllArgs(msg.sender, owner, transfer_fee);
1043             _transferAllArgs(msg.sender, _to, _value);
1044         } else if(_transferFeeMode == 2){
1045             _transferAllArgs(msg.sender, owner, transfer_fee);
1046             _transferAllArgs(msg.sender, _to, _value.sub(transfer_fee));
1047         }
1048         return true;
1049     }
1050 
1051     /**
1052      * @dev Transfer tokens from one address to another
1053      * @param _from address The address which you want to send tokens from
1054      * @param _to address The address which you want to transfer to
1055      * @param _value uint256 the amount of tokens to be transferred
1056      */
1057     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1058         uint256 transfer_fee = getTransactionFee(_value);
1059         if(_transferFeeMode == 0 || transfer_fee == 0 ){
1060             _transferFromAllArgs(_from, _to, _value, msg.sender);
1061         } else if(_transferFeeMode == 1){
1062             _transferFromAllArgs(_from, owner, transfer_fee, msg.sender);
1063             _transferFromAllArgs(_from, _to, _value, msg.sender);
1064         } else if(_transferFeeMode == 2){
1065             _transferFromAllArgs(_from, owner, transfer_fee, msg.sender);
1066             _transferFromAllArgs(_from, _to, _value.sub(transfer_fee), msg.sender);
1067         }
1068         return true;
1069     }
1070 
1071     function _burnFromAllowanceAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
1072         _requireCanTransferFrom(_spender, _from, _to);
1073         _requireOnlyCanBurn(_to);
1074         require(_value >= burnMin, "below min burn bound");
1075         require(_value <= burnMax, "exceeds max burn bound");
1076         _subBalance(_from, _value);
1077         _subAllowance(_from, _spender, _value); 
1078         emit Transfer(_from, _to, _value);
1079         totalSupply_ = totalSupply_.sub(_value);
1080         emit Burn(_to, _value);
1081         emit Transfer(_to, address(0), _value);
1082     }
1083 
1084     function _burnFromAllArgs(address _from, address _to, uint256 _value) internal {
1085         _requireCanTransfer(_from, _to);
1086         _requireOnlyCanBurn(_to);
1087         require(_value >= burnMin, "below min burn bound");
1088         require(_value <= burnMax, "exceeds max burn bound");
1089         _subBalance(_from, _value);
1090         emit Transfer(_from, _to, _value);
1091         totalSupply_ = totalSupply_.sub(_value);
1092         emit Burn(_to, _value);
1093         emit Transfer(_to, address(0), _value);
1094     }
1095 
1096     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
1097         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
1098             _value -= _value % CENT;
1099             _burnFromAllowanceAllArgs(_from, _to, _value, _spender);
1100         } else {
1101             bool hasHook;
1102             address originalTo = _to;
1103             (_to, hasHook) = _requireCanTransferFrom(_spender, _from, _to);
1104             _addBalance(_to, _value);
1105             _subAllowance(_from, _spender, _value);
1106             _subBalance(_from, _value);
1107             emit Transfer(_from, originalTo, _value);
1108             if (originalTo != _to) {
1109                 emit Transfer(originalTo, _to, _value);
1110                 if (hasHook) {
1111                     TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
1112                 }
1113             } else {
1114                 if (hasHook) {
1115                     TrueCoinReceiver(_to).tokenFallback(_from, _value);
1116                 }
1117             }
1118         }
1119     }
1120 
1121     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
1122         if (uint256(_to) < REDEMPTION_ADDRESS_COUNT) {
1123             _value -= _value % CENT;
1124             _burnFromAllArgs(_from, _to, _value);
1125         } else {
1126             bool hasHook;
1127             address finalTo;
1128             (finalTo, hasHook) = _requireCanTransfer(_from, _to);
1129             _subBalance(_from, _value);
1130             _addBalance(finalTo, _value);
1131             emit Transfer(_from, _to, _value);
1132             if (finalTo != _to) {
1133                 emit Transfer(_to, finalTo, _value);
1134                 if (hasHook) {
1135                     TrueCoinReceiver(finalTo).tokenFallback(_to, _value);
1136                 }
1137             } else {
1138                 if (hasHook) {
1139                     TrueCoinReceiver(finalTo).tokenFallback(_from, _value);
1140                 }
1141             }
1142         }
1143     }
1144 
1145     function mint(address _to, uint256 _value) public onlyOwner {
1146         require(_to != address(0), "to address cannot be zero");
1147         bool hasHook;
1148         address originalTo = _to;
1149         (_to, hasHook) = _requireCanMint(_to);
1150         totalSupply_ = totalSupply_.add(_value);
1151         emit Mint(originalTo, _value);
1152         emit Transfer(address(0), originalTo, _value);
1153         if (_to != originalTo) {
1154             emit Transfer(originalTo, _to, _value);
1155         }
1156         _addBalance(_to, _value);
1157         if (hasHook) {
1158             if (_to != originalTo) {
1159                 TrueCoinReceiver(_to).tokenFallback(originalTo, _value);
1160             } else {
1161                 TrueCoinReceiver(_to).tokenFallback(address(0), _value);
1162             }
1163         }
1164     }
1165 
1166     event WipeBlacklistedAccount(address indexed account, uint256 balance);
1167     event SetRegistry(address indexed registry);
1168 
1169     /**
1170     * @dev Point to the registry that contains all compliance related data
1171     @param _registry The address of the registry instance
1172     */
1173     function setRegistry(Registry _registry) public onlyOwner {
1174         registry = _registry;
1175         emit SetRegistry(address(registry));
1176     }
1177 
1178     modifier onlyRegistry {
1179       require(msg.sender == address(registry));
1180       _;
1181     }
1182 
1183     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) public onlyRegistry {
1184         attributes[_attribute][_who] = _value;
1185     }
1186 
1187     function _burnAllArgs(address _from, uint256 _value) internal {
1188         _requireCanBurn(_from);
1189         super._burnAllArgs(_from, _value);
1190     }
1191 
1192     // Destroy the tokens owned by a blacklisted account
1193     function wipeBlacklistedAccount(address _account) public onlyOwner {
1194         require(_isBlacklisted(_account), "_account is not blacklisted");
1195         uint256 oldValue = _getBalance(_account);
1196         _setBalance(_account, 0);
1197         totalSupply_ = totalSupply_.sub(oldValue);
1198         emit WipeBlacklistedAccount(_account, oldValue);
1199         emit Transfer(_account, address(0), oldValue);
1200     }
1201 
1202     function _isBlacklisted(address _account) internal view returns (bool blacklisted) {
1203         return attributes[IS_BLACKLISTED][_account] != 0;
1204     }
1205 
1206     function _requireCanTransfer(address _from, address _to) internal view returns (address, bool) {
1207         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1208         if (depositAddressValue != 0) {
1209             _to = address(depositAddressValue);
1210         }
1211         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1212         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1213         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1214     }
1215 
1216     function _requireCanTransferFrom(address _spender, address _from, address _to) internal view returns (address, bool) {
1217         require (attributes[IS_BLACKLISTED][_spender] == 0, "blacklisted");
1218         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1219         if (depositAddressValue != 0) {
1220             _to = address(depositAddressValue);
1221         }
1222         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1223         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1224         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1225     }
1226 
1227     function _requireCanMint(address _to) internal view returns (address, bool) {
1228         uint256 depositAddressValue = attributes[IS_DEPOSIT_ADDRESS][address(uint256(_to) >> 20)];
1229         if (depositAddressValue != 0) {
1230             _to = address(depositAddressValue);
1231         }
1232         require (attributes[IS_BLACKLISTED][_to] == 0, "blacklisted");
1233         return (_to, attributes[IS_REGISTERED_CONTRACT][_to] != 0);
1234     }
1235 
1236     function _requireOnlyCanBurn(address _from) internal view {
1237         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1238     }
1239 
1240     function _requireCanBurn(address _from) internal view {
1241         require (attributes[IS_BLACKLISTED][_from] == 0, "blacklisted");
1242         require (attributes[canBurn()][_from] != 0, "cannot burn from this address");
1243     }
1244 
1245     function paused() public pure returns (bool) {
1246         return false;
1247     }
1248 }
1249 
1250 // File: contracts/EURON.sol
1251 
1252 pragma solidity >=0.4.25 <0.6.0;
1253 
1254 //import "./DelegateERC20.sol";
1255 
1256 /** @title EURON
1257 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1258 * inherited - see the documentation on the corresponding contracts.
1259 */
1260 contract EURON is 
1261 CompliantDepositTokenWithHook
1262 //DelegateERC20
1263  {
1264     uint8 constant DECIMALS = 8;
1265     uint8 constant ROUNDING = 2;
1266 
1267     function decimals() public pure returns (uint8) {
1268         return DECIMALS;
1269     }
1270 
1271     function rounding() public pure returns (uint8) {
1272         return ROUNDING;
1273     }
1274 
1275     function name() public pure returns (string memory) {
1276         return "EURON";
1277     }
1278 
1279     function symbol() public pure returns (string memory) {
1280         return "ERN";
1281     }
1282 
1283     function canBurn() internal pure returns (bytes32) {
1284         return "canBurn";
1285     }
1286 
1287 
1288 
1289 }