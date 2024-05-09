1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://eips.ethereum.org/EIPS/eip-20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: registry/contracts/Registry.sol
288 
289 pragma solidity >=0.4.25 <0.6.0;
290 
291 
292 interface RegistryClone {
293     function syncAttributeValue(address _who, bytes32 _attribute, uint256 _value) external;
294 }
295 
296 contract Registry {
297     struct AttributeData {
298         uint256 value;
299         bytes32 notes;
300         address adminAddr;
301         uint256 timestamp;
302     }
303     
304     // never remove any storage variables
305     address public owner;
306     address public pendingOwner;
307     bool initialized;
308 
309     // Stores arbitrary attributes for users. An example use case is an ERC20
310     // token that requires its users to go through a KYC/AML check - in this case
311     // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
312     // that account can use the token. This mapping stores that value (1, in the
313     // example) as well as which validator last set the value and at what time,
314     // so that e.g. the check can be renewed at appropriate intervals.
315     mapping(address => mapping(bytes32 => AttributeData)) attributes;
316     // The logic governing who is allowed to set what attributes is abstracted as
317     // this accessManager, so that it may be replaced by the owner as needed
318     bytes32 constant WRITE_PERMISSION = keccak256("canWriteTo-");
319     mapping(bytes32 => RegistryClone[]) subscribers;
320 
321     event OwnershipTransferred(
322         address indexed previousOwner,
323         address indexed newOwner
324     );
325     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
326     event SetManager(address indexed oldManager, address indexed newManager);
327     event StartSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
328     event StopSubscription(bytes32 indexed attribute, RegistryClone indexed subscriber);
329 
330     // Allows a write if either a) the writer is that Registry's owner, or
331     // b) the writer is writing to attribute foo and that writer already has
332     // the canWriteTo-foo attribute set (in that same Registry)
333     function confirmWrite(bytes32 _attribute, address _admin) internal view returns (bool) {
334         bytes32 attr =  WRITE_PERMISSION ^ _attribute;
335         bytes32 kesres = bytes32(keccak256(abi.encodePacked(attr)));
336         return (_admin == owner || hasAttribute(_admin, kesres));
337     }
338 
339     // Writes are allowed only if the accessManager approves
340     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
341         require(confirmWrite(_attribute, msg.sender));
342         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
343         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
344 
345         RegistryClone[] storage targets = subscribers[_attribute];
346         uint256 index = targets.length;
347         while (index --> 0) {
348             targets[index].syncAttributeValue(_who, _attribute, _value);
349         }
350     }
351 
352     function subscribe(bytes32 _attribute, RegistryClone _syncer) external onlyOwner {
353         subscribers[_attribute].push(_syncer);
354         emit StartSubscription(_attribute, _syncer);
355     }
356 
357     function unsubscribe(bytes32 _attribute, uint256 _index) external onlyOwner {
358         uint256 length = subscribers[_attribute].length;
359         require(_index < length);
360         emit StopSubscription(_attribute, subscribers[_attribute][_index]);
361         subscribers[_attribute][_index] = subscribers[_attribute][length - 1];
362         subscribers[_attribute].length = length - 1;
363     }
364 
365     function subscriberCount(bytes32 _attribute) public view returns (uint256) {
366         return subscribers[_attribute].length;
367     }
368 
369     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
370         require(confirmWrite(_attribute, msg.sender));
371         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
372         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
373         RegistryClone[] storage targets = subscribers[_attribute];
374         uint256 index = targets.length;
375         while (index --> 0) {
376             targets[index].syncAttributeValue(_who, _attribute, _value);
377         }
378     }
379 
380     // Returns true if the uint256 value stored for this attribute is non-zero
381     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
382         return attributes[_who][_attribute].value != 0;
383     }
384 
385 
386     // Returns the exact value of the attribute, as well as its metadata
387     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
388         AttributeData memory data = attributes[_who][_attribute];
389         return (data.value, data.notes, data.adminAddr, data.timestamp);
390     }
391 
392     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
393         return attributes[_who][_attribute].value;
394     }
395 
396     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
397         return attributes[_who][_attribute].adminAddr;
398     }
399 
400     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
401         return attributes[_who][_attribute].timestamp;
402     }
403 
404     function syncAttribute(bytes32 _attribute, uint256 _startIndex, address[] calldata _addresses) external {
405         RegistryClone[] storage targets = subscribers[_attribute];
406         uint256 index = targets.length;
407         while (index --> _startIndex) {
408             RegistryClone target = targets[index];
409             for (uint256 i = _addresses.length; i --> 0; ) {
410                 address who = _addresses[i];
411                 target.syncAttributeValue(who, _attribute, attributes[who][_attribute].value);
412             }
413         }
414     }
415 
416     function reclaimEther(address payable _to) external onlyOwner {
417         _to.transfer(address(this).balance);
418     }
419 
420     function reclaimToken(ERC20 token, address _to) external onlyOwner {
421         uint256 balance = token.balanceOf(address(this));
422         token.transfer(_to, balance);
423     }
424 
425    /**
426     * @dev Throws if called by any account other than the owner.
427     */
428     modifier onlyOwner() {
429         require(msg.sender == owner, "only Owner");
430         _;
431     }
432 
433     /**
434     * @dev Modifier throws if called by any account other than the pendingOwner.
435     */
436     modifier onlyPendingOwner() {
437         require(msg.sender == pendingOwner);
438         _;
439     }
440 
441     /**
442     * @dev Allows the current owner to set the pendingOwner address.
443     * @param newOwner The address to transfer ownership to.
444     */
445     function transferOwnership(address newOwner) public onlyOwner {
446         pendingOwner = newOwner;
447     }
448 
449     /**
450     * @dev Allows the pendingOwner address to finalize the transfer.
451     */
452     function claimOwnership() public onlyPendingOwner {
453         emit OwnershipTransferred(owner, pendingOwner);
454         owner = pendingOwner;
455         pendingOwner = address(0);
456     }
457 }
458 
459 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
460 
461 pragma solidity ^0.5.2;
462 
463 /**
464  * @title Ownable
465  * @dev The Ownable contract has an owner address, and provides basic authorization control
466  * functions, this simplifies the implementation of "user permissions".
467  */
468 contract Ownable {
469     address private _owner;
470 
471     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
472 
473     /**
474      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
475      * account.
476      */
477     constructor () internal {
478         _owner = msg.sender;
479         emit OwnershipTransferred(address(0), _owner);
480     }
481 
482     /**
483      * @return the address of the owner.
484      */
485     function owner() public view returns (address) {
486         return _owner;
487     }
488 
489     /**
490      * @dev Throws if called by any account other than the owner.
491      */
492     modifier onlyOwner() {
493         require(isOwner());
494         _;
495     }
496 
497     /**
498      * @return true if `msg.sender` is the owner of the contract.
499      */
500     function isOwner() public view returns (bool) {
501         return msg.sender == _owner;
502     }
503 
504     /**
505      * @dev Allows the current owner to relinquish control of the contract.
506      * It will not be possible to call the functions with the `onlyOwner`
507      * modifier anymore.
508      * @notice Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public onlyOwner {
512         emit OwnershipTransferred(_owner, address(0));
513         _owner = address(0);
514     }
515 
516     /**
517      * @dev Allows the current owner to transfer control of the contract to a newOwner.
518      * @param newOwner The address to transfer ownership to.
519      */
520     function transferOwnership(address newOwner) public onlyOwner {
521         _transferOwnership(newOwner);
522     }
523 
524     /**
525      * @dev Transfers control of the contract to a newOwner.
526      * @param newOwner The address to transfer ownership to.
527      */
528     function _transferOwnership(address newOwner) internal {
529         require(newOwner != address(0));
530         emit OwnershipTransferred(_owner, newOwner);
531         _owner = newOwner;
532     }
533 }
534 
535 // File: contracts/Claimable.sol
536 
537 pragma solidity >=0.4.25 <0.6.0;
538 
539 
540 contract Claimable is Ownable {
541   address public pendingOwner;
542 
543   modifier onlyPendingOwner() {
544     if (msg.sender == pendingOwner)
545       _;
546   }
547 
548   function transferOwnership(address newOwner) public onlyOwner {
549     pendingOwner = newOwner;
550   }
551 
552   function claimOwnership() onlyPendingOwner public {
553     _transferOwnership(pendingOwner);
554     pendingOwner = address(0x0);
555   }
556 
557 }
558 
559 // File: contracts/modularERC20/BalanceSheet.sol
560 
561 pragma solidity >=0.4.25 <0.6.0;
562 
563 
564 
565 // A wrapper around the balanceOf mapping.
566 contract BalanceSheet is Claimable {
567     using SafeMath for uint256;
568 
569     mapping (address => uint256) public balanceOf;
570 
571     function addBalance(address _addr, uint256 _value) public onlyOwner {
572         balanceOf[_addr] = balanceOf[_addr].add(_value);
573     }
574 
575     function subBalance(address _addr, uint256 _value) public onlyOwner {
576         balanceOf[_addr] = balanceOf[_addr].sub(_value);
577     }
578 
579     function setBalance(address _addr, uint256 _value) public onlyOwner {
580         balanceOf[_addr] = _value;
581     }
582 }
583 
584 // File: contracts/modularERC20/AllowanceSheet.sol
585 
586 pragma solidity >=0.4.25 <0.6.0;
587 
588 
589 
590 // A wrapper around the allowanceOf mapping.
591 contract AllowanceSheet is Claimable {
592     using SafeMath for uint256;
593 
594     mapping (address => mapping (address => uint256)) public allowanceOf;
595 
596     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
597         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
598     }
599 
600     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
601         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
602     }
603 
604     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
605         allowanceOf[_tokenHolder][_spender] = _value;
606     }
607 }
608 
609 // File: contracts/ProxyStorage.sol
610 
611 pragma solidity >=0.4.25 <0.6.0;
612 
613 
614 
615 
616 /*
617 Defines the storage layout of the token implementaiton contract. Any newly declared
618 state variables in future upgrades should be appened to the bottom. Never remove state variables
619 from this list
620  */
621 contract ProxyStorage {
622     address public owner;
623     address public pendingOwner;
624 
625     bool initialized;
626     
627     BalanceSheet balances_Deprecated;
628     AllowanceSheet allowances_Deprecated;
629 
630     uint256 totalSupply_;
631     
632     bool private paused_Deprecated = false;
633     address private globalPause_Deprecated;
634 
635     uint256 public burnMin = 0;
636     uint256 public burnMax = 0;
637 
638     Registry public registry;
639 
640     string name_Deprecated;
641     string symbol_Deprecated;
642 
643     uint[] gasRefundPool_Deprecated;
644     uint256 private redemptionAddressCount_Deprecated;
645     uint256 public minimumGasPriceForFutureRefunds;
646 
647     mapping (address => uint256) _balanceOf;
648     mapping (address => mapping (address => uint256)) _allowance;
649     mapping (bytes32 => mapping (address => uint256)) attributes;
650 
651 
652     /* Additionally, we have several keccak-based storage locations.
653      * If you add more keccak-based storage mappings, such as mappings, you must document them here.
654      * If the length of the keccak input is the same as an existing mapping, it is possible there could be a preimage collision.
655      * A preimage collision can be used to attack the contract by treating one storage location as another,
656      * which would always be a critical issue.
657      * Carefully examine future keccak-based storage to ensure there can be no preimage collisions.
658      *******************************************************************************************************
659      ** length     input                                                         usage
660      *******************************************************************************************************
661      ** 19         "trueXXX.proxy.owner"                                         Proxy Owner
662      ** 27         "trueXXX.pending.proxy.owner"                                 Pending Proxy Owner
663      ** 28         "trueXXX.proxy.implementation"                                Proxy Implementation
664      ** 32         uint256(11)                                                   gasRefundPool_Deprecated
665      ** 64         uint256(address),uint256(14)                                  balanceOf
666      ** 64         uint256(address),keccak256(uint256(address),uint256(15))      allowance
667      ** 64         uint256(address),keccak256(bytes32,uint256(16))               attributes
668     **/
669 }
670 
671 // File: contracts/HasOwner.sol
672 
673 pragma solidity >=0.4.25 <0.6.0;
674 
675 
676 /**
677  * @title HasOwner
678  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
679  and provides basic authorization control functions. Inherits storage layout of 
680  ProxyStorage.
681  */
682 contract HasOwner is ProxyStorage {
683 
684     event OwnershipTransferred(
685         address indexed previousOwner,
686         address indexed newOwner
687     );
688 
689     /**
690     * @dev sets the original `owner` of the contract to the sender
691     * at construction. Must then be reinitialized 
692     */
693     constructor() public {
694         owner = msg.sender;
695         emit OwnershipTransferred(address(0), owner);
696     }
697 
698     /**
699     * @dev Throws if called by any account other than the owner.
700     */
701     modifier onlyOwner() {
702         require(msg.sender == owner, "only Owner");
703         _;
704     }
705 
706     /**
707     * @dev Modifier throws if called by any account other than the pendingOwner.
708     */
709     modifier onlyPendingOwner() {
710         require(msg.sender == pendingOwner);
711         _;
712     }
713 
714     /**
715     * @dev Allows the current owner to set the pendingOwner address.
716     * @param newOwner The address to transfer ownership to.
717     */
718     function transferOwnership(address newOwner) public onlyOwner {
719         pendingOwner = newOwner;
720     }
721 
722     /**
723     * @dev Allows the pendingOwner address to finalize the transfer.
724     */
725     function claimOwnership() public onlyPendingOwner {
726         emit OwnershipTransferred(owner, pendingOwner);
727         owner = pendingOwner;
728         pendingOwner = address(0);
729     }
730 }
731 
732 // File: contracts/TrueCoinReceiver.sol
733 
734 pragma solidity >=0.4.25 <0.6.0;
735 
736 contract TrueCoinReceiver {
737     function tokenFallback( address from, uint256 value ) external;
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
1250 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
1251 
1252 pragma solidity >=0.4.25 <0.6.0;
1253 
1254 /**
1255  * @title OwnedUpgradeabilityProxy
1256  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
1257  */
1258 contract OwnedUpgradeabilityProxy {
1259     /**
1260     * @dev Event to show ownership has been transferred
1261     * @param previousOwner representing the address of the previous owner
1262     * @param newOwner representing the address of the new owner
1263     */
1264     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1265 
1266     /**
1267     * @dev Event to show ownership transfer is pending
1268     * @param currentOwner representing the address of the current owner
1269     * @param pendingOwner representing the address of the pending owner
1270     */
1271     event NewPendingOwner(address currentOwner, address pendingOwner);
1272     
1273     // Storage position of the owner and pendingOwner of the contract
1274     bytes32 private constant proxyOwnerPosition = 0x6004f6b6eb3de57beb988d207d67d1fd96d97f56565b653b6e80b856d7c1a35f;//keccak256("EURON.proxy.owner");
1275     bytes32 private constant pendingProxyOwnerPosition = 0x76a33b3ea4443d67022b6c5254816af27c5cfd5c856e0422ce98ad937f4d709d;//keccak256("EURON.pending.proxy.owner");
1276 
1277     /**
1278     * @dev the constructor sets the original owner of the contract to the sender account.
1279     */
1280     constructor() public {
1281         _setUpgradeabilityOwner(msg.sender);
1282     }
1283 
1284     /**
1285     * @dev Throws if called by any account other than the owner.
1286     */
1287     modifier onlyProxyOwner() {
1288         require(msg.sender == proxyOwner(), "only Proxy Owner");
1289         _;
1290     }
1291 
1292     /**
1293     * @dev Throws if called by any account other than the pending owner.
1294     */
1295     modifier onlyPendingProxyOwner() {
1296         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
1297         _;
1298     }
1299 
1300     /**
1301     * @dev Tells the address of the owner
1302     * @return the address of the owner
1303     */
1304     function proxyOwner() public view returns (address owner) {
1305         bytes32 position = proxyOwnerPosition;
1306         assembly {
1307             owner := sload(position)
1308         }
1309     }
1310 
1311     /**
1312     * @dev Tells the address of the owner
1313     * @return the address of the owner
1314     */
1315     function pendingProxyOwner() public view returns (address pendingOwner) {
1316         bytes32 position = pendingProxyOwnerPosition;
1317         assembly {
1318             pendingOwner := sload(position)
1319         }
1320     }
1321 
1322     /**
1323     * @dev Sets the address of the owner
1324     */
1325     function _setUpgradeabilityOwner(address newProxyOwner) internal {
1326         bytes32 position = proxyOwnerPosition;
1327         assembly {
1328             sstore(position, newProxyOwner)
1329         }
1330     }
1331 
1332     /**
1333     * @dev Sets the address of the owner
1334     */
1335     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
1336         bytes32 position = pendingProxyOwnerPosition;
1337         assembly {
1338             sstore(position, newPendingProxyOwner)
1339         }
1340     }
1341 
1342     /**
1343     * @dev Allows the current owner to transfer control of the contract to a newOwner.
1344     *changes the pending owner to newOwner. But doesn't actually transfer
1345     * @param newOwner The address to transfer ownership to.
1346     */
1347     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
1348         require(newOwner != address(0));
1349         _setPendingUpgradeabilityOwner(newOwner);
1350         emit NewPendingOwner(proxyOwner(), newOwner);
1351     }
1352 
1353     /**
1354     * @dev Allows the pendingOwner to claim ownership of the proxy
1355     */
1356     function claimProxyOwnership() external onlyPendingProxyOwner {
1357         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
1358         _setUpgradeabilityOwner(pendingProxyOwner());
1359         _setPendingUpgradeabilityOwner(address(0));
1360     }
1361 
1362     /**
1363     * @dev Allows the proxy owner to upgrade the current version of the proxy.
1364     * @param implementation representing the address of the new implementation to be set.
1365     */
1366     function upgradeTo(address implementation) external onlyProxyOwner {
1367         address currentImplementation;
1368         bytes32 position = implementationPosition;
1369         assembly {
1370             currentImplementation := sload(position)
1371         }
1372         require(currentImplementation != implementation);
1373         assembly {
1374           sstore(position, implementation)
1375         }
1376         emit Upgraded(implementation);
1377     }
1378     /**
1379     * @dev This event will be emitted every time the implementation gets upgraded
1380     * @param implementation representing the address of the upgraded implementation
1381     */
1382     event Upgraded(address indexed implementation);
1383 
1384     // Storage position of the address of the current implementation
1385     bytes32 private constant implementationPosition = 0x84b64b507833ba7e4ea61b69390489bd134000b6d1333e6a1617aac294fa83f7; //keccak256("EURON.proxy.implementation");
1386 
1387     function implementation() public view returns (address impl) {
1388         bytes32 position = implementationPosition;
1389         assembly {
1390             impl := sload(position)
1391         }
1392     }
1393 
1394     /**
1395     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1396     * This function will return whatever the implementation call returns
1397     */
1398     function() external payable {
1399         bytes32 position = implementationPosition;
1400         
1401         assembly {
1402             let ptr := mload(0x40)
1403             calldatacopy(ptr, returndatasize, calldatasize)
1404             let result := delegatecall(gas, sload(position), ptr, calldatasize, returndatasize, returndatasize)
1405             returndatacopy(ptr, 0, returndatasize)
1406 
1407             switch result
1408             case 0 { revert(ptr, returndatasize) }
1409             default { return(ptr, returndatasize) }
1410         }
1411     }
1412 }
1413 
1414 // File: contracts/Admin/TokenController.sol
1415 
1416 pragma solidity >=0.4.25 <0.6.0;
1417 
1418 
1419 
1420 
1421 
1422 
1423 /** @title TokenController
1424 @dev This contract allows us to split ownership of the EURON contract
1425 into two addresses. One, called the "owner" address, has unfettered control of the EURON contract -
1426 it can mint new tokens, transfer ownership of the contract, etc. However to make
1427 extra sure that EURON is never compromised, this owner key will not be used in
1428 day-to-day operations, allowing it to be stored at a heightened level of security.
1429 Instead, the owner appoints an various "admin" address. 
1430 There are 3 different types of admin addresses;  MintKey, MintRatifier, and MintPauser. 
1431 MintKey can request and revoke mints one at a time.
1432 MintPausers can pause individual mints or pause all mints.
1433 MintRatifiers can approve and finalize mints with enough approval.
1434 
1435 There are three levels of mints: instant mint, ratified mint, and multiSig mint. Each have a different threshold
1436 and deduct from a different pool.
1437 Instant mint has the lowest threshold and finalizes instantly without any ratifiers. Deduct from instant mint pool,
1438 which can be refilled by one ratifier.
1439 Ratify mint has the second lowest threshold and finalizes with one ratifier approval. Deduct from ratify mint pool,
1440 which can be refilled by three ratifiers.
1441 MultiSig mint has the highest threshold and finalizes with three ratifier approvals. Deduct from multiSig mint pool,
1442 which can only be refilled by the owner.
1443 */
1444 
1445 contract TokenController {
1446     using SafeMath for uint256;
1447 
1448     struct MintOperation {
1449         address to;
1450         uint256 value;
1451         uint256 requestedBlock;
1452         uint256 numberOfApproval;
1453         bool paused;
1454         mapping(address => bool) approved; 
1455     }
1456 
1457     address public owner;
1458     address public pendingOwner;
1459 
1460     bool public initialized;
1461 
1462     uint256 public instantMintThreshold;
1463     uint256 public ratifiedMintThreshold;
1464     uint256 public multiSigMintThreshold;
1465 
1466 
1467     uint256 public instantMintLimit; 
1468     uint256 public ratifiedMintLimit; 
1469     uint256 public multiSigMintLimit;
1470 
1471     uint256 public instantMintPool; 
1472     uint256 public ratifiedMintPool; 
1473     uint256 public multiSigMintPool;
1474     address[2] public ratifiedPoolRefillApprovals;
1475 
1476     uint8 constant public RATIFY_MINT_SIGS = 1; //number of approvals needed to finalize a Ratified Mint
1477     uint8 constant public MULTISIG_MINT_SIGS = 3; //number of approvals needed to finalize a MultiSig Mint
1478 
1479     bool public mintPaused;
1480     uint256 public mintReqInvalidBeforeThisBlock; //all mint request before this block are invalid
1481     address public mintKey;
1482     MintOperation[] public mintOperations; //list of a mint requests
1483     
1484     CompliantDepositTokenWithHook public token;
1485     OwnedUpgradeabilityProxy public token_proxy;
1486     Registry public registry;
1487     address public fastPause;
1488 
1489     bytes32 constant public IS_MINT_PAUSER = "isURONMintPausers";
1490     bytes32 constant public IS_MINT_RATIFIER = "isURONMintRatifier";
1491     bytes32 constant public IS_REDEMPTION_ADMIN = "isURONRedemptionAdmin";
1492 
1493     address constant public PAUSED_IMPLEMENTATION = 0xfA2350552ba1593E7D3Abd284C4d55ae26aAEa20; // ***To be changed the paused version of EURON in Production
1494 
1495     
1496 
1497     modifier onlyFastPauseOrOwner() {
1498         require(msg.sender == fastPause || msg.sender == owner, "must be pauser or owner");
1499         _;
1500     }
1501 
1502     modifier onlyMintKeyOrOwner() {
1503         require(msg.sender == mintKey || msg.sender == owner, "must be mintKey or owner");
1504         _;
1505     }
1506 
1507     modifier onlyMintPauserOrOwner() {
1508         require(registry.hasAttribute(msg.sender, IS_MINT_PAUSER) || msg.sender == owner, "must be pauser or owner");
1509         _;
1510     }
1511 
1512     modifier onlyMintRatifierOrOwner() {
1513         require(registry.hasAttribute(msg.sender, IS_MINT_RATIFIER) || msg.sender == owner, "must be ratifier or owner");
1514         _;
1515     }
1516 
1517     modifier onlyOwnerOrRedemptionAdmin() {
1518         require(registry.hasAttribute(msg.sender, IS_REDEMPTION_ADMIN) || msg.sender == owner, "must be Redemption admin or owner");
1519         _;
1520     }
1521 
1522     //mint operations by the mintkey cannot be processed on when mints are paused
1523     modifier mintNotPaused() {
1524         if (msg.sender != owner) {
1525             require(!mintPaused, "minting is paused");
1526         }
1527         _;
1528     }
1529     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1530     event NewOwnerPending(address indexed currentOwner, address indexed pendingOwner);
1531     event SetRegistry(address indexed registry);
1532     event TransferChild(address indexed child, address indexed newOwner);
1533     event RequestReclaimContract(address indexed other);
1534     event SetToken(CompliantDepositTokenWithHook newContract);
1535     
1536     event RequestMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1537     event FinalizeMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1538     event InstantMint(address indexed to, uint256 indexed value, address indexed mintKey);
1539     
1540     event TransferMintKey(address indexed previousMintKey, address indexed newMintKey);
1541     event MintRatified(uint256 indexed opIndex, address indexed ratifier);
1542     event RevokeMint(uint256 opIndex);
1543     event AllMintsPaused(bool status);
1544     event MintPaused(uint opIndex, bool status);
1545     event MintApproved(address approver, uint opIndex);
1546     event FastPauseSet(address _newFastPause);
1547 
1548     event MintThresholdChanged(uint instant, uint ratified, uint multiSig);
1549     event MintLimitsChanged(uint instant, uint ratified, uint multiSig);
1550     event InstantPoolRefilled();
1551     event RatifyPoolRefilled();
1552     event MultiSigPoolRefilled();
1553 
1554     /*
1555     ========================================
1556     Ownership functions
1557     ========================================
1558     */
1559 
1560     function initialize() external {
1561         require(!initialized, "already initialized");
1562         owner = msg.sender;
1563         initialized = true;
1564     }
1565 
1566     /**
1567     * @dev Throws if called by any account other than the owner.
1568     */
1569     modifier onlyOwner() {
1570         require(msg.sender == owner, "only controller Owner");
1571         _;
1572     }
1573 
1574     /**
1575     * @dev Modifier throws if called by any account other than the pendingOwner.
1576     */
1577     modifier onlyPendingOwner() {
1578         require(msg.sender == pendingOwner);
1579         _;
1580     }
1581 
1582     /**
1583     * @dev Allows the current owner to set the pendingOwner address.
1584     * @param newOwner The address to transfer ownership to.
1585     */
1586     function transferOwnership(address newOwner) external onlyOwner {
1587         pendingOwner = newOwner;
1588         emit NewOwnerPending(owner, pendingOwner);
1589     }
1590 
1591     /**
1592     * @dev Allows the pendingOwner address to finalize the transfer.
1593     */
1594     function claimOwnership() external onlyPendingOwner {
1595         emit OwnershipTransferred(owner, pendingOwner);
1596         owner = pendingOwner;
1597         pendingOwner = address(0);
1598     }
1599     
1600     /*
1601     ========================================
1602     proxy functions
1603     ========================================
1604     */
1605 
1606     function transferEURONProxyOwnership(address _newOwner) external onlyOwner {
1607         OwnedUpgradeabilityProxy(token_proxy).transferProxyOwnership(_newOwner);
1608     }
1609 
1610     function claimEURONProxyOwnership() external onlyOwner {
1611         OwnedUpgradeabilityProxy(token_proxy).claimProxyOwnership();
1612     }
1613 
1614     function upgradeEURONProxyImplTo(address _implementation) external onlyOwner {
1615         OwnedUpgradeabilityProxy(token_proxy).upgradeTo(_implementation);
1616     }
1617 
1618     /*
1619     ========================================
1620     Minting functions
1621     ========================================
1622     */
1623 
1624     /**
1625      * @dev set the threshold for a mint to be considered an instant mint, ratify mint and multiSig mint
1626      Instant mint requires no approval, ratify mint requires 1 approval and multiSig mint requires 3 approvals
1627      */
1628     function setMintThresholds(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1629         require(_instant <= _ratified && _ratified <= _multiSig);
1630         instantMintThreshold = _instant;
1631         ratifiedMintThreshold = _ratified;
1632         multiSigMintThreshold = _multiSig;
1633         emit MintThresholdChanged(_instant, _ratified, _multiSig);
1634     }
1635 
1636 
1637     /**
1638      * @dev set the limit of each mint pool. For example can only instant mint up to the instant mint pool limit
1639      before needing to refill
1640      */
1641     function setMintLimits(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1642         require(_instant <= _ratified && _ratified <= _multiSig);
1643         instantMintLimit = _instant;
1644         if (instantMintPool > instantMintLimit) {
1645             instantMintPool = instantMintLimit;
1646         }
1647         ratifiedMintLimit = _ratified;
1648         if (ratifiedMintPool > ratifiedMintLimit) {
1649             ratifiedMintPool = ratifiedMintLimit;
1650         }
1651         multiSigMintLimit = _multiSig;
1652         if (multiSigMintPool > multiSigMintLimit) {
1653             multiSigMintPool = multiSigMintLimit;
1654         }
1655         emit MintLimitsChanged(_instant, _ratified, _multiSig);
1656     }
1657 
1658     /**
1659      * @dev Ratifier can refill instant mint pool
1660      */
1661     function refillInstantMintPool() external onlyMintRatifierOrOwner {
1662         ratifiedMintPool = ratifiedMintPool.sub(instantMintLimit.sub(instantMintPool));
1663         instantMintPool = instantMintLimit;
1664         emit InstantPoolRefilled();
1665     }
1666 
1667     /**
1668      * @dev Owner or 3 ratifiers can refill Ratified Mint Pool
1669      */
1670     function refillRatifiedMintPool() external onlyMintRatifierOrOwner {
1671         if (msg.sender != owner) {
1672             address[2] memory refillApprovals = ratifiedPoolRefillApprovals;
1673             require(msg.sender != refillApprovals[0] && msg.sender != refillApprovals[1]);
1674             if (refillApprovals[0] == address(0)) {
1675                 ratifiedPoolRefillApprovals[0] = msg.sender;
1676                 return;
1677             } 
1678             if (refillApprovals[1] == address(0)) {
1679                 ratifiedPoolRefillApprovals[1] = msg.sender;
1680                 return;
1681             } 
1682         }
1683         delete ratifiedPoolRefillApprovals; // clears the whole array
1684         multiSigMintPool = multiSigMintPool.sub(ratifiedMintLimit.sub(ratifiedMintPool));
1685         ratifiedMintPool = ratifiedMintLimit;
1686         emit RatifyPoolRefilled();
1687     }
1688 
1689     /**
1690      * @dev Owner can refill MultiSig Mint Pool
1691      */
1692     function refillMultiSigMintPool() external onlyOwner {
1693         multiSigMintPool = multiSigMintLimit;
1694         emit MultiSigPoolRefilled();
1695     }
1696 
1697     /**
1698      * @dev mintKey initiates a request to mint _value for account _to
1699      * @param _to the address to mint to
1700      * @param _value the amount requested
1701      */
1702     function requestMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1703         MintOperation memory op = MintOperation(_to, _value, block.number, 0, false);
1704         emit RequestMint(_to, _value, mintOperations.length, msg.sender);
1705         mintOperations.push(op);
1706     }
1707 
1708 
1709     /**
1710      * @dev Instant mint without ratification if the amount is less than instantMintThreshold and instantMintPool
1711      * @param _to the address to mint to
1712      * @param _value the amount minted
1713      */
1714     function instantMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1715         require(_value <= instantMintThreshold, "over the instant mint threshold");
1716         require(_value <= instantMintPool, "instant mint pool is dry");
1717         instantMintPool = instantMintPool.sub(_value);
1718         emit InstantMint(_to, _value, msg.sender);
1719         token.mint(_to, _value);
1720     }
1721 
1722 
1723     /**
1724      * @dev ratifier ratifies a request mint. If the number of ratifiers that signed off is greater than 
1725      the number of approvals required, the request is finalized
1726      * @param _index the index of the requestMint to ratify
1727      * @param _to the address to mint to
1728      * @param _value the amount requested
1729      */
1730     function ratifyMint(uint256 _index, address _to, uint256 _value) external mintNotPaused onlyMintRatifierOrOwner {
1731         MintOperation memory op = mintOperations[_index];
1732         require(op.to == _to, "to address does not match");
1733         require(op.value == _value, "amount does not match");
1734         require(!mintOperations[_index].approved[msg.sender], "already approved");
1735         mintOperations[_index].approved[msg.sender] = true;
1736         mintOperations[_index].numberOfApproval = mintOperations[_index].numberOfApproval.add(1);
1737         emit MintRatified(_index, msg.sender);
1738         if (hasEnoughApproval(mintOperations[_index].numberOfApproval, _value)){
1739             finalizeMint(_index);
1740         }
1741     }
1742 
1743     /**
1744      * @dev finalize a mint request, mint the amount requested to the specified address
1745      @param _index of the request (visible in the RequestMint event accompanying the original request)
1746      */
1747     function finalizeMint(uint256 _index) public mintNotPaused {
1748         MintOperation memory op = mintOperations[_index];
1749         address to = op.to;
1750         uint256 value = op.value;
1751         if (msg.sender != owner) {
1752             require(canFinalize(_index));
1753             _subtractFromMintPool(value);
1754         }
1755         delete mintOperations[_index];
1756         token.mint(to, value);
1757         emit FinalizeMint(to, value, _index, msg.sender);
1758     }
1759 
1760     /**
1761      * assumption: only invoked when canFinalize
1762      */
1763     function _subtractFromMintPool(uint256 _value) internal {
1764         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1765             ratifiedMintPool = ratifiedMintPool.sub(_value);
1766         } else {
1767             multiSigMintPool = multiSigMintPool.sub(_value);
1768         }
1769     }
1770 
1771     /**
1772      * @dev compute if the number of approvals is enough for a given mint amount
1773      */
1774     function hasEnoughApproval(uint256 _numberOfApproval, uint256 _value) public view returns (bool) {
1775         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1776             if (_numberOfApproval >= RATIFY_MINT_SIGS){
1777                 return true;
1778             }
1779         }
1780         if (_value <= multiSigMintPool && _value <= multiSigMintThreshold) {
1781             if (_numberOfApproval >= MULTISIG_MINT_SIGS){
1782                 return true;
1783             }
1784         }
1785         if (msg.sender == owner) {
1786             return true;
1787         }
1788         return false;
1789     }
1790 
1791     /**
1792      * @dev compute if a mint request meets all the requirements to be finalized
1793      utility function for a front end
1794      */
1795     function canFinalize(uint256 _index) public view returns(bool) {
1796         MintOperation memory op = mintOperations[_index];
1797         require(op.requestedBlock > mintReqInvalidBeforeThisBlock, "this mint is invalid"); //also checks if request still exists
1798         require(!op.paused, "this mint is paused");
1799         require(hasEnoughApproval(op.numberOfApproval, op.value), "not enough approvals");
1800         return true;
1801     }
1802 
1803     /** 
1804     *@dev revoke a mint request, Delete the mintOperation
1805     *@param index of the request (visible in the RequestMint event accompanying the original request)
1806     */
1807     function revokeMint(uint256 _index) external onlyMintKeyOrOwner {
1808         delete mintOperations[_index];
1809         emit RevokeMint(_index);
1810     }
1811 
1812     function mintOperationCount() public view returns (uint256) {
1813         return mintOperations.length;
1814     }
1815 
1816     /*
1817     ========================================
1818     Key management
1819     ========================================
1820     */
1821 
1822     /** 
1823     *@dev Replace the current mintkey with new mintkey 
1824     *@param _newMintKey address of the new mintKey
1825     */
1826     function transferMintKey(address _newMintKey) external onlyOwner {
1827         require(_newMintKey != address(0), "new mint key cannot be 0x0");
1828         emit TransferMintKey(mintKey, _newMintKey);
1829         mintKey = _newMintKey;
1830     }
1831  
1832     /*
1833     ========================================
1834     Mint Pausing
1835     ========================================
1836     */
1837 
1838     /** 
1839     *@dev invalidates all mint request initiated before the current block 
1840     */
1841     function invalidateAllPendingMints() external onlyOwner {
1842         mintReqInvalidBeforeThisBlock = block.number;
1843     }
1844 
1845     /** 
1846     *@dev pause any further mint request and mint finalizations 
1847     */
1848     function pauseMints() external onlyMintPauserOrOwner {
1849         mintPaused = true;
1850         emit AllMintsPaused(true);
1851     }
1852 
1853     /** 
1854     *@dev unpause any further mint request and mint finalizations 
1855     */
1856     function unpauseMints() external onlyOwner {
1857         mintPaused = false;
1858         emit AllMintsPaused(false);
1859     }
1860 
1861     /** 
1862     *@dev pause a specific mint request
1863     *@param  _opIndex the index of the mint request the caller wants to pause
1864     */
1865     function pauseMint(uint _opIndex) external onlyMintPauserOrOwner {
1866         mintOperations[_opIndex].paused = true;
1867         emit MintPaused(_opIndex, true);
1868     }
1869 
1870     /** 
1871     *@dev unpause a specific mint request
1872     *@param  _opIndex the index of the mint request the caller wants to unpause
1873     */
1874     function unpauseMint(uint _opIndex) external onlyOwner {
1875         mintOperations[_opIndex].paused = false;
1876         emit MintPaused(_opIndex, false);
1877     }
1878 
1879     /*
1880     ========================================
1881     set and claim contracts, administrative
1882     ========================================
1883     */
1884 
1885     /** 
1886     *@dev Set Transfer Fee
1887     */
1888 
1889     function setTransferFee(uint256 transferFee) external onlyOwner {
1890         token.setTransferFee(transferFee);
1891     }
1892 
1893     /** 
1894     *@dev Update this contract's token pointer to newContract (e.g. if the
1895     contract is upgraded)
1896     */
1897     function setToken(address _newContract) external onlyOwner {
1898         token = CompliantDepositTokenWithHook(_newContract);
1899         token_proxy = OwnedUpgradeabilityProxy(uint160(_newContract));
1900         emit SetToken(token);
1901     }
1902 
1903     /** 
1904     *@dev Update this contract's registry pointer to _registry
1905     */
1906     function setRegistry(Registry _registry) external onlyOwner {
1907         registry = _registry;
1908         emit SetRegistry( address(registry));
1909     }
1910 
1911     /** 
1912     *@dev Swap out token's permissions registry
1913     *@param _registry new registry for token
1914     */
1915     function setTokenRegistry(Registry _registry) external onlyOwner {
1916         token.setRegistry(_registry);
1917     }
1918 
1919     /** 
1920     *@dev Claim ownership of an arbitrary HasOwner contract
1921     */
1922     function issueClaimOwnership(address _other) public onlyOwner {
1923         HasOwner other = HasOwner(_other);
1924         other.claimOwnership();
1925     }
1926 
1927     /** 
1928     *@dev Transfer ownership of _child to _newOwner.
1929     Can be used e.g. to upgrade this TokenController contract.
1930     *@param _child contract that tokenController currently Owns 
1931     *@param _newOwner new owner/pending owner of _child
1932     */
1933     function transferChild(HasOwner _child, address _newOwner) external onlyOwner {
1934         _child.transferOwnership(_newOwner);
1935         emit TransferChild(address(_child), _newOwner);
1936     }
1937 
1938     /** 
1939     *@dev Transfer ownership of a contract from token to this TokenController.
1940     Can be used e.g. to reclaim balance sheet
1941     in order to transfer it to an upgraded EURON contract.
1942     *@param _other address of the contract to claim ownership of
1943     */
1944     function requestReclaimContract(Ownable _other) public onlyOwner {
1945         token.reclaimContract(_other);
1946         emit RequestReclaimContract( address(_other));
1947     }
1948 
1949     /** 
1950     *@dev send all ether in token address to the owner of tokenController 
1951     */
1952     function requestReclaimEther() external onlyOwner {
1953         address payable owners_address = address( uint160(owner));
1954         token.reclaimEther(owners_address);
1955     }
1956 
1957     /** 
1958     *@dev transfer all tokens of a particular type in token address to the
1959     owner of tokenController 
1960     *@param _token token address of the token to transfer
1961     */
1962     function requestReclaimToken(ERC20 _token) external onlyOwner {
1963         token.reclaimToken(_token, owner);
1964     }
1965 
1966     /** 
1967     *@dev set new contract to which specified address can send eth to to quickly pause token
1968     *@param _newFastPause address of the new contract
1969     */
1970     function setFastPause(address _newFastPause) external onlyOwner {
1971         fastPause = _newFastPause;
1972         emit FastPauseSet(_newFastPause);
1973     }
1974 
1975     /** 
1976     *@dev pause all pausable actions on EURON, mints/burn/transfer/approve
1977     */
1978     function pauseToken() external onlyFastPauseOrOwner {
1979         OwnedUpgradeabilityProxy(token_proxy).upgradeTo(PAUSED_IMPLEMENTATION);
1980     }
1981     
1982     /** 
1983     *@dev wipe balance of a blacklisted address
1984     *@param _blacklistedAddress address whose balance will be wiped
1985     */
1986     function wipeBlackListedEURON(address _blacklistedAddress) external onlyOwner {
1987         token.wipeBlacklistedAccount(_blacklistedAddress);
1988     }
1989 
1990     /** 
1991     *@dev Change the minimum and maximum amounts that EURON users can
1992     burn to newMin and newMax
1993     *@param _min minimum amount user can burn at a time
1994     *@param _max maximum amount user can burn at a time
1995     */
1996     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
1997         token.setBurnBounds(_min, _max);
1998     }
1999 
2000     /** 
2001     *@dev Owner can send ether balance in contract address
2002     *@param _to address to which the funds will be send to
2003     */
2004     function reclaimEther(address payable _to) external onlyOwner {
2005         _to.transfer(address(this).balance);
2006     }
2007 
2008     /** 
2009     *@dev Owner can send erc20 token balance in contract address
2010     *@param _token address of the token to send
2011     *@param _to address to which the funds will be send to
2012     */
2013     function reclaimToken(ERC20 _token, address _to) external onlyOwner {
2014         uint256 balance = _token.balanceOf(address(this));
2015         _token.transfer(_to, balance);
2016     }
2017 }