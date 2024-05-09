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
55 
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
61     event SetManager(address indexed oldManager, address indexed newManager);
62 
63 
64     function initialize() public {
65         require(!initialized, "already initialized");
66         owner = msg.sender;
67         initialized = true;
68     }
69 
70     function writeAttributeFor(bytes32 _attribute) public pure returns (bytes32) {
71         return keccak256(WRITE_PERMISSION ^ _attribute);
72     }
73 
74     // Allows a write if either a) the writer is that Registry's owner, or
75     // b) the writer is writing to attribute foo and that writer already has
76     // the canWriteTo-foo attribute set (in that same Registry)
77     function confirmWrite(bytes32 _attribute, address _admin) public view returns (bool) {
78         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
79     }
80 
81     // Writes are allowed only if the accessManager approves
82     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
83         require(confirmWrite(_attribute, msg.sender));
84         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
85         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
86     }
87 
88     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
89         require(confirmWrite(_attribute, msg.sender));
90         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
91         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
92     }
93 
94     // Returns true if the uint256 value stored for this attribute is non-zero
95     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
96         return attributes[_who][_attribute].value != 0;
97     }
98 
99     function hasBothAttributes(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
100         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value != 0;
101     }
102 
103     function hasEitherAttribute(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
104         return attributes[_who][_attribute1].value != 0 || attributes[_who][_attribute2].value != 0;
105     }
106 
107     function hasAttribute1ButNotAttribute2(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
108         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value == 0;
109     }
110 
111     function bothHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
112         return attributes[_who1][_attribute].value != 0 && attributes[_who2][_attribute].value != 0;
113     }
114     
115     function eitherHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
116         return attributes[_who1][_attribute].value != 0 || attributes[_who2][_attribute].value != 0;
117     }
118 
119     function haveAttributes(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
120         return attributes[_who1][_attribute1].value != 0 && attributes[_who2][_attribute2].value != 0;
121     }
122 
123     function haveEitherAttribute(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
124         return attributes[_who1][_attribute1].value != 0 || attributes[_who2][_attribute2].value != 0;
125     }
126 
127     // Returns the exact value of the attribute, as well as its metadata
128     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
129         AttributeData memory data = attributes[_who][_attribute];
130         return (data.value, data.notes, data.adminAddr, data.timestamp);
131     }
132 
133     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
134         return attributes[_who][_attribute].value;
135     }
136 
137     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
138         return attributes[_who][_attribute].adminAddr;
139     }
140 
141     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
142         return attributes[_who][_attribute].timestamp;
143     }
144 
145     function reclaimEther(address _to) external onlyOwner {
146         _to.transfer(address(this).balance);
147     }
148 
149     function reclaimToken(ERC20 token, address _to) external onlyOwner {
150         uint256 balance = token.balanceOf(this);
151         token.transfer(_to, balance);
152     }
153 
154     /**
155     * @dev sets the original `owner` of the contract to the sender
156     * at construction. Must then be reinitialized 
157     */
158     constructor() public {
159         owner = msg.sender;
160         emit OwnershipTransferred(address(0), owner);
161     }
162 
163     /**
164     * @dev Throws if called by any account other than the owner.
165     */
166     modifier onlyOwner() {
167         require(msg.sender == owner, "only Owner");
168         _;
169     }
170 
171     /**
172     * @dev Modifier throws if called by any account other than the pendingOwner.
173     */
174     modifier onlyPendingOwner() {
175         require(msg.sender == pendingOwner);
176         _;
177     }
178 
179     /**
180     * @dev Allows the current owner to set the pendingOwner address.
181     * @param newOwner The address to transfer ownership to.
182     */
183     function transferOwnership(address newOwner) public onlyOwner {
184         pendingOwner = newOwner;
185     }
186 
187     /**
188     * @dev Allows the pendingOwner address to finalize the transfer.
189     */
190     function claimOwnership() public onlyPendingOwner {
191         emit OwnershipTransferred(owner, pendingOwner);
192         owner = pendingOwner;
193         pendingOwner = address(0);
194     }
195 }
196 
197 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205   address public owner;
206 
207 
208   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210 
211   /**
212    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
213    * account.
214    */
215   function Ownable() public {
216     owner = msg.sender;
217   }
218 
219   /**
220    * @dev Throws if called by any account other than the owner.
221    */
222   modifier onlyOwner() {
223     require(msg.sender == owner);
224     _;
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address newOwner) public onlyOwner {
232     require(newOwner != address(0));
233     emit OwnershipTransferred(owner, newOwner);
234     owner = newOwner;
235   }
236 
237 }
238 
239 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
240 
241 /**
242  * @title Claimable
243  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
244  * This allows the new owner to accept the transfer.
245  */
246 contract Claimable is Ownable {
247   address public pendingOwner;
248 
249   /**
250    * @dev Modifier throws if called by any account other than the pendingOwner.
251    */
252   modifier onlyPendingOwner() {
253     require(msg.sender == pendingOwner);
254     _;
255   }
256 
257   /**
258    * @dev Allows the current owner to set the pendingOwner address.
259    * @param newOwner The address to transfer ownership to.
260    */
261   function transferOwnership(address newOwner) onlyOwner public {
262     pendingOwner = newOwner;
263   }
264 
265   /**
266    * @dev Allows the pendingOwner address to finalize the transfer.
267    */
268   function claimOwnership() onlyPendingOwner public {
269     emit OwnershipTransferred(owner, pendingOwner);
270     owner = pendingOwner;
271     pendingOwner = address(0);
272   }
273 }
274 
275 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
276 
277 /**
278  * @title SafeMath
279  * @dev Math operations with safety checks that throw on error
280  */
281 library SafeMath {
282 
283   /**
284   * @dev Multiplies two numbers, throws on overflow.
285   */
286   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
287     if (a == 0) {
288       return 0;
289     }
290     c = a * b;
291     assert(c / a == b);
292     return c;
293   }
294 
295   /**
296   * @dev Integer division of two numbers, truncating the quotient.
297   */
298   function div(uint256 a, uint256 b) internal pure returns (uint256) {
299     // assert(b > 0); // Solidity automatically throws when dividing by 0
300     // uint256 c = a / b;
301     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302     return a / b;
303   }
304 
305   /**
306   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
307   */
308   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309     assert(b <= a);
310     return a - b;
311   }
312 
313   /**
314   * @dev Adds two numbers, throws on overflow.
315   */
316   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
317     c = a + b;
318     assert(c >= a);
319     return c;
320   }
321 }
322 
323 // File: contracts/modularERC20/BalanceSheet.sol
324 
325 // A wrapper around the balanceOf mapping.
326 contract BalanceSheet is Claimable {
327     using SafeMath for uint256;
328 
329     mapping (address => uint256) public balanceOf;
330 
331     function addBalance(address _addr, uint256 _value) public onlyOwner {
332         balanceOf[_addr] = balanceOf[_addr].add(_value);
333     }
334 
335     function subBalance(address _addr, uint256 _value) public onlyOwner {
336         balanceOf[_addr] = balanceOf[_addr].sub(_value);
337     }
338 
339     function setBalance(address _addr, uint256 _value) public onlyOwner {
340         balanceOf[_addr] = _value;
341     }
342 }
343 
344 // File: contracts/modularERC20/AllowanceSheet.sol
345 
346 // A wrapper around the allowanceOf mapping.
347 contract AllowanceSheet is Claimable {
348     using SafeMath for uint256;
349 
350     mapping (address => mapping (address => uint256)) public allowanceOf;
351 
352     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
353         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
354     }
355 
356     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
357         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
358     }
359 
360     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
361         allowanceOf[_tokenHolder][_spender] = _value;
362     }
363 }
364 
365 // File: contracts/utilities/GlobalPause.sol
366 
367 /*
368 All future trusttoken tokens can reference this contract. 
369 Allow for Admin to pause a set of tokens with one transaction
370 Used to signal which fork is the supported fork for asset-back tokens
371 */
372 contract GlobalPause is Claimable {
373     bool public allTokensPaused = false;
374     string public pauseNotice;
375 
376     function pauseAllTokens(bool _status, string _notice) public onlyOwner {
377         allTokensPaused = _status;
378         pauseNotice = _notice;
379     }
380 
381     function requireNotPaused() public view {
382         require(!allTokensPaused, pauseNotice);
383     }
384 }
385 
386 // File: contracts/ProxyStorage.sol
387 
388 /*
389 Defines the storage layout of the implementaiton (TrueUSD) contract. Any newly declared 
390 state variables in future upgrades should be appened to the bottom. Never remove state variables
391 from this list
392  */
393 contract ProxyStorage {
394     address public owner;
395     address public pendingOwner;
396 
397     bool public initialized;
398     
399     BalanceSheet public balances;
400     AllowanceSheet public allowances;
401 
402     uint256 totalSupply_;
403     
404     bool public paused = false;
405     GlobalPause public globalPause;
406 
407     uint256 public burnMin = 0;
408     uint256 public burnMax = 0;
409 
410     Registry public registry;
411 
412     string public name = "TrueUSD";
413     string public symbol = "TUSD";
414 
415     uint[] public gasRefundPool;
416     uint256 public redemptionAddressCount;
417 }
418 
419 // File: contracts/HasOwner.sol
420 
421 /**
422  * @title HasOwner
423  * @dev The HasOwner contract is a copy of Claimable Contract by Zeppelin. 
424  and provides basic authorization control functions. Inherits storage layout of 
425  ProxyStorage.
426  */
427 contract HasOwner is ProxyStorage {
428 
429     event OwnershipTransferred(
430         address indexed previousOwner,
431         address indexed newOwner
432     );
433 
434     /**
435     * @dev sets the original `owner` of the contract to the sender
436     * at construction. Must then be reinitialized 
437     */
438     constructor() public {
439         owner = msg.sender;
440         emit OwnershipTransferred(address(0), owner);
441     }
442 
443     /**
444     * @dev Throws if called by any account other than the owner.
445     */
446     modifier onlyOwner() {
447         require(msg.sender == owner, "only Owner");
448         _;
449     }
450 
451     /**
452     * @dev Modifier throws if called by any account other than the pendingOwner.
453     */
454     modifier onlyPendingOwner() {
455         require(msg.sender == pendingOwner);
456         _;
457     }
458 
459     /**
460     * @dev Allows the current owner to set the pendingOwner address.
461     * @param newOwner The address to transfer ownership to.
462     */
463     function transferOwnership(address newOwner) public onlyOwner {
464         pendingOwner = newOwner;
465     }
466 
467     /**
468     * @dev Allows the pendingOwner address to finalize the transfer.
469     */
470     function claimOwnership() public onlyPendingOwner {
471         emit OwnershipTransferred(owner, pendingOwner);
472         owner = pendingOwner;
473         pendingOwner = address(0);
474     }
475 }
476 
477 // File: contracts/modularERC20/ModularBasicToken.sol
478 
479 // Version of OpenZeppelin's BasicToken whose balances mapping has been replaced
480 // with a separate BalanceSheet contract. remove the need to copy over balances.
481 /**
482  * @title Basic token
483  * @dev Basic version of StandardToken, with no allowances.
484  */
485 contract ModularBasicToken is HasOwner {
486     using SafeMath for uint256;
487 
488     event BalanceSheetSet(address indexed sheet);
489     event Transfer(address indexed from, address indexed to, uint256 value);
490 
491     /**
492     * @dev claim ownership of the balancesheet contract
493     * @param _sheet The address to of the balancesheet to claim.
494     */
495     function setBalanceSheet(address _sheet) public onlyOwner returns (bool) {
496         balances = BalanceSheet(_sheet);
497         balances.claimOwnership();
498         emit BalanceSheetSet(_sheet);
499         return true;
500     }
501 
502     /**
503     * @dev total number of tokens in existence
504     */
505     function totalSupply() public view returns (uint256) {
506         return totalSupply_;
507     }
508 
509     /**
510     * @dev transfer token for a specified address
511     * @param _to The address to transfer to.
512     * @param _value The amount to be transferred.
513     */
514     function transfer(address _to, uint256 _value) public returns (bool) {
515         _transferAllArgs(msg.sender, _to, _value);
516         return true;
517     }
518 
519 
520     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
521         // SafeMath.sub will throw if there is not enough balance.
522         balances.subBalance(_from, _value);
523         balances.addBalance(_to, _value);
524         emit Transfer(_from, _to, _value);
525     }
526     
527 
528     /**
529     * @dev Gets the balance of the specified address.
530     * @param _owner The address to query the the balance of.
531     * @return An uint256 representing the amount owned by the passed address.
532     */
533     function balanceOf(address _owner) public view returns (uint256 balance) {
534         return balances.balanceOf(_owner);
535     }
536 }
537 
538 // File: contracts/modularERC20/ModularStandardToken.sol
539 
540 /**
541  * @title Standard ERC20 token
542  *
543  * @dev Implementation of the basic standard token.
544  * @dev https://github.com/ethereum/EIPs/issues/20
545  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
546  */
547 contract ModularStandardToken is ModularBasicToken {
548     
549     event AllowanceSheetSet(address indexed sheet);
550     event Approval(address indexed owner, address indexed spender, uint256 value);
551     
552     /**
553     * @dev claim ownership of the AllowanceSheet contract
554     * @param _sheet The address to of the AllowanceSheet to claim.
555     */
556     function setAllowanceSheet(address _sheet) public onlyOwner returns(bool) {
557         allowances = AllowanceSheet(_sheet);
558         allowances.claimOwnership();
559         emit AllowanceSheetSet(_sheet);
560         return true;
561     }
562 
563     /**
564      * @dev Transfer tokens from one address to another
565      * @param _from address The address which you want to send tokens from
566      * @param _to address The address which you want to transfer to
567      * @param _value uint256 the amount of tokens to be transferred
568      */
569     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
570         _transferFromAllArgs(_from, _to, _value, msg.sender);
571         return true;
572     }
573 
574     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
575         require(_value <= allowances.allowanceOf(_from, _spender),"not enough allowance to transfer");
576 
577         _transferAllArgs(_from, _to, _value);
578         allowances.subAllowance(_from, _spender, _value);
579     }
580 
581     /**
582      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
583      *
584      * Beware that changing an allowance with this method brings the risk that someone may use both the old
585      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
586      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
587      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
588      * @param _spender The address which will spend the funds.
589      * @param _value The amount of tokens to be spent.
590      */
591     function approve(address _spender, uint256 _value) public returns (bool) {
592         _approveAllArgs(_spender, _value, msg.sender);
593         return true;
594     }
595 
596     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
597         allowances.setAllowance(_tokenHolder, _spender, _value);
598         emit Approval(_tokenHolder, _spender, _value);
599     }
600 
601     /**
602      * @dev Function to check the amount of tokens that an owner allowed to a spender.
603      * @param _owner address The address which owns the funds.
604      * @param _spender address The address which will spend the funds.
605      * @return A uint256 specifying the amount of tokens still available for the spender.
606      */
607     function allowance(address _owner, address _spender) public view returns (uint256) {
608         return allowances.allowanceOf(_owner, _spender);
609     }
610 
611     /**
612      * @dev Increase the amount of tokens that an owner allowed to a spender.
613      *
614      * approve should be called when allowed[_spender] == 0. To increment
615      * allowed value is better to use this function to avoid 2 calls (and wait until
616      * the first transaction is mined)
617      * From MonolithDAO Token.sol
618      * @param _spender The address which will spend the funds.
619      * @param _addedValue The amount of tokens to increase the allowance by.
620      */
621     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
622         _increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
623         return true;
624     }
625 
626     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
627         allowances.addAllowance(_tokenHolder, _spender, _addedValue);
628         emit Approval(_tokenHolder, _spender, allowances.allowanceOf(_tokenHolder, _spender));
629     }
630 
631     /**
632      * @dev Decrease the amount of tokens that an owner allowed to a spender.
633      *
634      * approve should be called when allowed[_spender] == 0. To decrement
635      * allowed value is better to use this function to avoid 2 calls (and wait until
636      * the first transaction is mined)
637      * From MonolithDAO Token.sol
638      * @param _spender The address which will spend the funds.
639      * @param _subtractedValue The amount of tokens to decrease the allowance by.
640      */
641     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
642         _decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
643         return true;
644     }
645 
646     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
647         uint256 oldValue = allowances.allowanceOf(_tokenHolder, _spender);
648         if (_subtractedValue > oldValue) {
649             allowances.setAllowance(_tokenHolder, _spender, 0);
650         } else {
651             allowances.subAllowance(_tokenHolder, _spender, _subtractedValue);
652         }
653         emit Approval(_tokenHolder,_spender, allowances.allowanceOf(_tokenHolder, _spender));
654     }
655 }
656 
657 // File: contracts/modularERC20/ModularBurnableToken.sol
658 
659 /**
660  * @title Burnable Token
661  * @dev Token that can be irreversibly burned (destroyed).
662  */
663 contract ModularBurnableToken is ModularStandardToken {
664     event Burn(address indexed burner, uint256 value);
665 
666     /**
667      * @dev Burns a specific amount of tokens.
668      * @param _value The amount of token to be burned.
669      */
670     function burn(uint256 _value) public {
671         _burnAllArgs(msg.sender, _value);
672     }
673 
674     function _burnAllArgs(address _burner, uint256 _value) internal {
675         require(_value <= balances.balanceOf(_burner), "not enough balance to burn");
676         // no need to require value <= totalSupply, since that would imply the
677         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
678         /* uint burnAmount = _value / (10 **16) * (10 **16); */
679         balances.subBalance(_burner, _value);
680         totalSupply_ = totalSupply_.sub(_value);
681         emit Burn(_burner, _value);
682         emit Transfer(_burner, address(0), _value);
683     }
684 }
685 
686 // File: contracts/modularERC20/ModularMintableToken.sol
687 
688 /**
689  * @title Mintable token
690  * @dev Simple ERC20 Token example, with mintable token creation
691  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
692  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
693  */
694 contract ModularMintableToken is ModularBurnableToken {
695     event Mint(address indexed to, uint256 value);
696 
697     /**
698      * @dev Function to mint tokens
699      * @param _to The address that will receive the minted tokens.
700      * @param _value The amount of tokens to mint.
701      * @return A boolean that indicates if the operation was successful.
702      */
703     function mint(address _to, uint256 _value) public onlyOwner {
704         require(_to != address(0), "to address cannot be zero");
705         totalSupply_ = totalSupply_.add(_value);
706         balances.addBalance(_to, _value);
707         emit Mint(_to, _value);
708         emit Transfer(address(0), _to, _value);
709     }
710 }
711 
712 // File: contracts/modularERC20/ModularPausableToken.sol
713 
714 /**
715  * @title Pausable token
716  * @dev MintableToken modified with pausable transfers.
717  **/
718 contract ModularPausableToken is ModularMintableToken {
719 
720     event Pause();
721     event Unpause();
722     event GlobalPauseSet(address indexed newGlobalPause);
723 
724     /**
725     * @dev Modifier to make a function callable only when the contract is not paused.
726     */
727     modifier whenNotPaused() {
728         require(!paused, "Token Paused");
729         _;
730     }
731 
732     /**
733     * @dev Modifier to make a function callable only when the contract is paused.
734     */
735     modifier whenPaused() {
736         require(paused, "Token Not Paused");
737         _;
738     }
739 
740     /**
741     * @dev called by the owner to pause, triggers stopped state
742     */
743     function pause() public onlyOwner whenNotPaused {
744         paused = true;
745         emit Pause();
746     }
747 
748     /**
749     * @dev called by the owner to unpause, returns to normal state
750     */
751     function unpause() public onlyOwner whenPaused {
752         paused = false;
753         emit Unpause();
754     }
755 
756 
757     //All erc20 transactions are paused when not on the supported fork
758     modifier onSupportedChain() {
759         globalPause.requireNotPaused();
760         _;
761     }
762 
763     function setGlobalPause(address _newGlobalPause) external onlyOwner {
764         globalPause = GlobalPause(_newGlobalPause);
765         emit GlobalPauseSet(_newGlobalPause);
766     }
767     
768     function _transferAllArgs(address _from, address _to, uint256 _value) internal whenNotPaused onSupportedChain {
769         super._transferAllArgs(_from, _to, _value);
770     }
771 
772     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal whenNotPaused onSupportedChain {
773         super._transferFromAllArgs(_from, _to, _value, _spender);
774     }
775 
776     function _approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal whenNotPaused onSupportedChain {
777         super._approveAllArgs(_spender, _value, _tokenHolder);
778     }
779 
780     function _increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal whenNotPaused onSupportedChain {
781         super._increaseApprovalAllArgs(_spender, _addedValue, _tokenHolder);
782     }
783 
784     function _decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal whenNotPaused onSupportedChain {
785         super._decreaseApprovalAllArgs(_spender, _subtractedValue, _tokenHolder);
786     }
787 
788     function _burnAllArgs(address _burner, uint256 _value) internal whenNotPaused onSupportedChain {
789         super._burnAllArgs(_burner, _value);
790     }
791 }
792 
793 // File: contracts/BurnableTokenWithBounds.sol
794 
795 /**
796  * @title Burnable Token WithBounds
797  * @dev Burning functions as redeeming money from the system. The platform will keep track of who burns coins,
798  * and will send them back the equivalent amount of money (rounded down to the nearest cent).
799  */
800 contract BurnableTokenWithBounds is ModularPausableToken {
801 
802     event SetBurnBounds(uint256 newMin, uint256 newMax);
803 
804     function _burnAllArgs(address _burner, uint256 _value) internal {
805         require(_value >= burnMin, "below min burn bound");
806         require(_value <= burnMax, "exceeds max burn bound");
807         super._burnAllArgs(_burner, _value);
808     }
809 
810     //Change the minimum and maximum amount that can be burned at once. Burning
811     //may be disabled by setting both to 0 (this will not be done under normal
812     //operation, but we can't add checks to disallow it without losing a lot of
813     //flexibility since burning could also be as good as disabled
814     //by setting the minimum extremely high, and we don't want to lock
815     //in any particular cap for the minimum)
816     function setBurnBounds(uint256 _min, uint256 _max) public onlyOwner {
817         require(_min <= _max, "min > max");
818         burnMin = _min;
819         burnMax = _max;
820         emit SetBurnBounds(_min, _max);
821     }
822 }
823 
824 // File: contracts/CompliantToken.sol
825 
826 /**
827  * @title Compliant Token
828  */
829 contract CompliantToken is ModularPausableToken {
830     // In order to deposit USD and receive newly minted TrueUSD, or to burn TrueUSD to
831     // redeem it for USD, users must first go through a KYC/AML check (which includes proving they
832     // control their ethereum address using AddressValidation.sol).
833     bytes32 public constant HAS_PASSED_KYC_AML = "hasPassedKYC/AML";
834     // Redeeming ("burning") TrueUSD tokens for USD requires a separate flag since
835     // users must not only be KYC/AML'ed but must also have bank information on file.
836     bytes32 public constant CAN_BURN = "canBurn";
837     // Addresses can also be blacklisted, preventing them from sending or receiving
838     // TrueUSD. This can be used to prevent the use of TrueUSD by bad actors in
839     // accordance with law enforcement. See [TrueCoin Terms of Use](https://www.trusttoken.com/trueusd/terms-of-use)
840     bytes32 public constant IS_BLACKLISTED = "isBlacklisted";
841 
842     event WipeBlacklistedAccount(address indexed account, uint256 balance);
843     event SetRegistry(address indexed registry);
844     
845     
846     /**
847     * @dev Point to the registry that contains all compliance related data
848     @param _registry The address of the registry instance
849     */
850     function setRegistry(Registry _registry) public onlyOwner {
851         registry = _registry;
852         emit SetRegistry(registry);
853     }
854 
855     function mint(address _to, uint256 _value) public onlyOwner {
856         require(registry.hasAttribute1ButNotAttribute2(_to, HAS_PASSED_KYC_AML, IS_BLACKLISTED), "_to cannot mint");
857         super.mint(_to, _value);
858     }
859 
860     function _burnAllArgs(address _burner, uint256 _value) internal {
861         require(registry.hasAttribute1ButNotAttribute2(_burner, CAN_BURN, IS_BLACKLISTED), "_burner cannot burn");
862         super._burnAllArgs(_burner, _value);
863     }
864 
865     // A blacklisted address can't call transferFrom
866     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
867         require(!registry.hasAttribute(_spender, IS_BLACKLISTED), "_spender is blacklisted");
868         super._transferFromAllArgs(_from, _to, _value, _spender);
869     }
870 
871     // transfer and transferFrom both call this function, so check blacklist here.
872     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
873         require(!registry.eitherHaveAttribute(_from, _to, IS_BLACKLISTED), "blacklisted");
874         super._transferAllArgs(_from, _to, _value);
875     }
876 
877     // Destroy the tokens owned by a blacklisted account
878     function wipeBlacklistedAccount(address _account) public onlyOwner {
879         require(registry.hasAttribute(_account, IS_BLACKLISTED), "_account is not blacklisted");
880         uint256 oldValue = balanceOf(_account);
881         balances.setBalance(_account, 0);
882         totalSupply_ = totalSupply_.sub(oldValue);
883         emit WipeBlacklistedAccount(_account, oldValue);
884         emit Transfer(_account, address(0), oldValue);
885     }
886 }
887 
888 // File: contracts/RedeemableToken.sol
889 
890 /** @title Redeemable Token 
891 Makes transfers to 0x0 alias to Burn
892 Implement Redemption Addresses
893 */
894 contract RedeemableToken is ModularPausableToken {
895 
896     event RedemptionAddress(address indexed addr);
897 
898     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
899         if (_to == address(0)) {
900             revert("_to address is 0x0");
901         } else if (uint(_to) <= redemptionAddressCount) {
902             // Transfers to redemption addresses becomes burn
903             super._transferAllArgs(_from, _to, _value);
904             _burnAllArgs(_to, _value);
905         } else {
906             super._transferAllArgs(_from, _to, _value);
907         }
908     }
909     
910     function incrementRedemptionAddressCount() external onlyOwner {
911         emit RedemptionAddress(address(redemptionAddressCount));
912         redemptionAddressCount += 1;
913     }
914 }
915 
916 // File: contracts/DepositToken.sol
917 
918 /** @title Deposit Token
919 Allows users to register their address so that all transfers to deposit addresses
920 of the registered address will be forwarded to the registered address.  
921 For example for address 0x9052BE99C9C8C5545743859e4559A751bDe4c923,
922 its deposit addresses are all addresses between
923 0x9052BE99C9C8C5545743859e4559A75100000 and 0x9052BE99C9C8C5545743859e4559A751fffff
924 Transfers to 0x9052BE99C9C8C5545743859e4559A75100005 will be forwared to 0x9052BE99C9C8C5545743859e4559A751bDe4c923
925  */
926 contract DepositToken is ModularPausableToken {
927     
928     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
929 
930     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
931         address shiftedAddress = address(uint(_to) >> 20);
932         uint depositAddressValue = registry.getAttributeValue(shiftedAddress, IS_DEPOSIT_ADDRESS);
933         if (depositAddressValue != 0) {
934             super._transferAllArgs(_from, _to, _value);
935             super._transferAllArgs(_to, address(depositAddressValue), _value);
936         } else {
937             super._transferAllArgs(_from, _to, _value);
938         }
939     }
940 
941     function mint(address _to, uint256 _value) public onlyOwner {
942         address shiftedAddress = address(uint(_to) >> 20);
943         uint depositAddressValue = registry.getAttributeValue(shiftedAddress, IS_DEPOSIT_ADDRESS);
944         if (depositAddressValue != 0) {
945             super.mint(_to, _value);
946             super._transferAllArgs(_to, address(depositAddressValue), _value);
947         } else {
948             super.mint(_to, _value);
949         }
950     }
951 }
952 
953 // File: contracts/GasRefundToken.sol
954 
955 /**  
956 @title Gas Refund Token
957 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
958 Each time an non-empty storage slot is set to 0, evm refund 15,000 (19,000 after Constantinople) to the sender
959 of the transaction. 
960 */
961 contract GasRefundToken is ModularPausableToken {
962 
963     function sponsorGas() external {
964         uint256 len = gasRefundPool.length;
965         gasRefundPool.length = len + 9;
966         gasRefundPool[len] = 1;
967         gasRefundPool[len + 1] = 1;
968         gasRefundPool[len + 2] = 1;
969         gasRefundPool[len + 3] = 1;
970         gasRefundPool[len + 4] = 1;
971         gasRefundPool[len + 5] = 1;
972         gasRefundPool[len + 6] = 1;
973         gasRefundPool[len + 7] = 1;
974         gasRefundPool[len + 8] = 1;
975     }  
976 
977     /**  
978     @dev refund up to 45,000 (57,000 after Constantinople) gas for functions with 
979     gasRefund modifier.
980     */
981     modifier gasRefund {
982         uint256 len = gasRefundPool.length;
983         if (len != 0) {
984             gasRefundPool[--len] = 0;
985             gasRefundPool[--len] = 0;
986             gasRefundPool[--len] = 0;
987             gasRefundPool.length = len;
988         }   
989         _;  
990     }
991 
992     /**  
993     *@dev Return the remaining sponsored gas slots
994     */
995     function remainingGasRefundPool() public view returns(uint) {
996         return gasRefundPool.length;
997     }
998 
999     function _transferAllArgs(address _from, address _to, uint256 _value) internal gasRefund {
1000         super._transferAllArgs(_from, _to, _value);
1001     }
1002 
1003     function mint(address _to, uint256 _value) public onlyOwner gasRefund {
1004         super.mint(_to, _value);
1005     }
1006 }
1007 
1008 // File: contracts/TrueCoinReceiver.sol
1009 
1010 contract TrueCoinReceiver {
1011     function tokenFallback( address from, uint256 value ) external;
1012 }
1013 
1014 // File: contracts/TokenWithHook.sol
1015 
1016 /** @title Token With Hook
1017 If tokens are transferred to a Registered Token Receiver contract, trigger the tokenFallback function in the 
1018 Token Receiver contract. Assume all Registered Token Receiver contract implements the TrueCoinReceiver 
1019 interface. If the tokenFallback reverts, the entire transaction reverts. 
1020  */
1021 contract TokenWithHook is ModularPausableToken {
1022     
1023     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
1024 
1025     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
1026         uint length;
1027         assembly { length := extcodesize(_to) }
1028         super._transferAllArgs(_from, _to, _value);
1029         if (length > 0) {
1030             if(registry.hasAttribute(_to, IS_REGISTERED_CONTRACT)) {
1031                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
1032             }
1033         }
1034     }
1035 }
1036 
1037 // File: contracts/DelegateERC20.sol
1038 
1039 /** @title DelegateERC20
1040 Accept forwarding delegation calls from the old TrueUSD (V1) contract. THis way the all the ERC20
1041 functions in the old contract still works (except Burn). 
1042 */
1043 contract DelegateERC20 is ModularStandardToken {
1044 
1045     address public constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1046     
1047     modifier onlyDelegateFrom() {
1048         require(msg.sender == DELEGATE_FROM);
1049         _;
1050     }
1051 
1052     function delegateTotalSupply() public view returns (uint256) {
1053         return totalSupply();
1054     }
1055 
1056     function delegateBalanceOf(address who) public view returns (uint256) {
1057         return balanceOf(who);
1058     }
1059 
1060     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1061         _transferAllArgs(origSender, to, value);
1062         return true;
1063     }
1064 
1065     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1066         return allowance(owner, spender);
1067     }
1068 
1069     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1070         _transferFromAllArgs(from, to, value, origSender);
1071         return true;
1072     }
1073 
1074     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1075         _approveAllArgs(spender, value, origSender);
1076         return true;
1077     }
1078 
1079     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1080         _increaseApprovalAllArgs(spender, addedValue, origSender);
1081         return true;
1082     }
1083 
1084     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1085         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1086         return true;
1087     }
1088 }
1089 
1090 // File: contracts/TrueUSD.sol
1091 
1092 /** @title TrueUSD
1093 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1094 * inherited - see the documentation on the corresponding contracts.
1095 */
1096 contract TrueUSD is 
1097 ModularPausableToken, 
1098 BurnableTokenWithBounds, 
1099 CompliantToken,
1100 RedeemableToken,
1101 TokenWithHook,
1102 DelegateERC20,
1103 DepositToken,
1104 GasRefundToken {
1105     using SafeMath for *;
1106 
1107     uint8 public constant DECIMALS = 18;
1108     uint8 public constant ROUNDING = 2;
1109 
1110     event ChangeTokenName(string newName, string newSymbol);
1111 
1112     /**  
1113     *@dev set the totalSupply of the contract for delegation purposes
1114     Can only be set once.
1115     */
1116     function initialize() public {
1117         require(!initialized, "already initialized");
1118         initialized = true;
1119         owner = msg.sender;
1120         burnMin = 10000 * 10**uint256(DECIMALS);
1121         burnMax = 20000000 * 10**uint256(DECIMALS);
1122         name = "TrueUSD";
1123         symbol = "TUSD";
1124     }
1125 
1126     function setTotalSupply(uint _totalSupply) public onlyOwner {
1127         require(totalSupply_ == 0);
1128         totalSupply_ = _totalSupply;
1129     }
1130 
1131     function changeTokenName(string _name, string _symbol) external onlyOwner {
1132         name = _name;
1133         symbol = _symbol;
1134         emit ChangeTokenName(_name, _symbol);
1135     }
1136 
1137     /**  
1138     *@dev send all eth balance in the TrueUSD contract to another address
1139     */
1140     function reclaimEther(address _to) external onlyOwner {
1141         _to.transfer(address(this).balance);
1142     }
1143 
1144     /**  
1145     *@dev send all token balance of an arbitary erc20 token
1146     in the TrueUSD contract to another address
1147     */
1148     function reclaimToken(ERC20 token, address _to) external onlyOwner {
1149         uint256 balance = token.balanceOf(this);
1150         token.transfer(_to, balance);
1151     }
1152 
1153     /**  
1154     *@dev allows owner of TrueUSD to gain ownership of any contract that TrueUSD currently owns
1155     */
1156     function reclaimContract(Ownable _ownable) external onlyOwner {
1157         _ownable.transferOwnership(owner);
1158     }
1159 
1160     function _burnAllArgs(address _burner, uint256 _value) internal {
1161         //round down burn amount so that the lowest amount allowed is 1 cent
1162         uint burnAmount = _value.div(10 ** uint256(DECIMALS - ROUNDING)).mul(10 ** uint256(DECIMALS - ROUNDING));
1163         super._burnAllArgs(_burner, burnAmount);
1164     }
1165 }