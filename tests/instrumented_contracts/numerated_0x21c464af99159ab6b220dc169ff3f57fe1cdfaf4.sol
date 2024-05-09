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
103 
104     event OwnershipTransferred(
105         address indexed previousOwner,
106         address indexed newOwner
107     );
108     event SetAttribute(address indexed who, bytes32 attribute, uint256 value, bytes32 notes, address indexed adminAddr);
109     event SetManager(address indexed oldManager, address indexed newManager);
110 
111 
112     function initialize() public {
113         require(!initialized, "already initialized");
114         owner = msg.sender;
115         initialized = true;
116     }
117 
118     function writeAttributeFor(bytes32 _attribute) public pure returns (bytes32) {
119         return keccak256(WRITE_PERMISSION ^ _attribute);
120     }
121 
122     // Allows a write if either a) the writer is that Registry's owner, or
123     // b) the writer is writing to attribute foo and that writer already has
124     // the canWriteTo-foo attribute set (in that same Registry)
125     function confirmWrite(bytes32 _attribute, address _admin) public view returns (bool) {
126         return (_admin == owner || hasAttribute(_admin, keccak256(WRITE_PERMISSION ^ _attribute)));
127     }
128 
129     // Writes are allowed only if the accessManager approves
130     function setAttribute(address _who, bytes32 _attribute, uint256 _value, bytes32 _notes) public {
131         require(confirmWrite(_attribute, msg.sender));
132         attributes[_who][_attribute] = AttributeData(_value, _notes, msg.sender, block.timestamp);
133         emit SetAttribute(_who, _attribute, _value, _notes, msg.sender);
134     }
135 
136     function setAttributeValue(address _who, bytes32 _attribute, uint256 _value) public {
137         require(confirmWrite(_attribute, msg.sender));
138         attributes[_who][_attribute] = AttributeData(_value, "", msg.sender, block.timestamp);
139         emit SetAttribute(_who, _attribute, _value, "", msg.sender);
140     }
141 
142     // Returns true if the uint256 value stored for this attribute is non-zero
143     function hasAttribute(address _who, bytes32 _attribute) public view returns (bool) {
144         return attributes[_who][_attribute].value != 0;
145     }
146 
147     function hasBothAttributes(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
148         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value != 0;
149     }
150 
151     function hasEitherAttribute(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
152         return attributes[_who][_attribute1].value != 0 || attributes[_who][_attribute2].value != 0;
153     }
154 
155     function hasAttribute1ButNotAttribute2(address _who, bytes32 _attribute1, bytes32 _attribute2) public view returns (bool) {
156         return attributes[_who][_attribute1].value != 0 && attributes[_who][_attribute2].value == 0;
157     }
158 
159     function bothHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
160         return attributes[_who1][_attribute].value != 0 && attributes[_who2][_attribute].value != 0;
161     }
162     
163     function eitherHaveAttribute(address _who1, address _who2, bytes32 _attribute) public view returns (bool) {
164         return attributes[_who1][_attribute].value != 0 || attributes[_who2][_attribute].value != 0;
165     }
166 
167     function haveAttributes(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
168         return attributes[_who1][_attribute1].value != 0 && attributes[_who2][_attribute2].value != 0;
169     }
170 
171     function haveEitherAttribute(address _who1, bytes32 _attribute1, address _who2, bytes32 _attribute2) public view returns (bool) {
172         return attributes[_who1][_attribute1].value != 0 || attributes[_who2][_attribute2].value != 0;
173     }
174 
175     // Returns the exact value of the attribute, as well as its metadata
176     function getAttribute(address _who, bytes32 _attribute) public view returns (uint256, bytes32, address, uint256) {
177         AttributeData memory data = attributes[_who][_attribute];
178         return (data.value, data.notes, data.adminAddr, data.timestamp);
179     }
180 
181     function getAttributeValue(address _who, bytes32 _attribute) public view returns (uint256) {
182         return attributes[_who][_attribute].value;
183     }
184 
185     function getAttributeAdminAddr(address _who, bytes32 _attribute) public view returns (address) {
186         return attributes[_who][_attribute].adminAddr;
187     }
188 
189     function getAttributeTimestamp(address _who, bytes32 _attribute) public view returns (uint256) {
190         return attributes[_who][_attribute].timestamp;
191     }
192 
193     function reclaimEther(address _to) external onlyOwner {
194         _to.transfer(address(this).balance);
195     }
196 
197     function reclaimToken(ERC20 token, address _to) external onlyOwner {
198         uint256 balance = token.balanceOf(this);
199         token.transfer(_to, balance);
200     }
201 
202     /**
203     * @dev sets the original `owner` of the contract to the sender
204     * at construction. Must then be reinitialized 
205     */
206     constructor() public {
207         owner = msg.sender;
208         emit OwnershipTransferred(address(0), owner);
209     }
210 
211     /**
212     * @dev Throws if called by any account other than the owner.
213     */
214     modifier onlyOwner() {
215         require(msg.sender == owner, "only Owner");
216         _;
217     }
218 
219     /**
220     * @dev Modifier throws if called by any account other than the pendingOwner.
221     */
222     modifier onlyPendingOwner() {
223         require(msg.sender == pendingOwner);
224         _;
225     }
226 
227     /**
228     * @dev Allows the current owner to set the pendingOwner address.
229     * @param newOwner The address to transfer ownership to.
230     */
231     function transferOwnership(address newOwner) public onlyOwner {
232         pendingOwner = newOwner;
233     }
234 
235     /**
236     * @dev Allows the pendingOwner address to finalize the transfer.
237     */
238     function claimOwnership() public onlyPendingOwner {
239         emit OwnershipTransferred(owner, pendingOwner);
240         owner = pendingOwner;
241         pendingOwner = address(0);
242     }
243 }
244 
245 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258 
259   /**
260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
261    * account.
262    */
263   function Ownable() public {
264     owner = msg.sender;
265   }
266 
267   /**
268    * @dev Throws if called by any account other than the owner.
269    */
270   modifier onlyOwner() {
271     require(msg.sender == owner);
272     _;
273   }
274 
275   /**
276    * @dev Allows the current owner to transfer control of the contract to a newOwner.
277    * @param newOwner The address to transfer ownership to.
278    */
279   function transferOwnership(address newOwner) public onlyOwner {
280     require(newOwner != address(0));
281     emit OwnershipTransferred(owner, newOwner);
282     owner = newOwner;
283   }
284 
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
288 
289 /**
290  * @title Claimable
291  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
292  * This allows the new owner to accept the transfer.
293  */
294 contract Claimable is Ownable {
295   address public pendingOwner;
296 
297   /**
298    * @dev Modifier throws if called by any account other than the pendingOwner.
299    */
300   modifier onlyPendingOwner() {
301     require(msg.sender == pendingOwner);
302     _;
303   }
304 
305   /**
306    * @dev Allows the current owner to set the pendingOwner address.
307    * @param newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address newOwner) onlyOwner public {
310     pendingOwner = newOwner;
311   }
312 
313   /**
314    * @dev Allows the pendingOwner address to finalize the transfer.
315    */
316   function claimOwnership() onlyPendingOwner public {
317     emit OwnershipTransferred(owner, pendingOwner);
318     owner = pendingOwner;
319     pendingOwner = address(0);
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
900             // transfer to 0x0 becomes burn
901             _burnAllArgs(_from, _value);
902         } else if (uint(_to) <= redemptionAddressCount) {
903             // Trnasfers to redemption addresses becomes burn
904             super._transferAllArgs(_from, _to, _value);
905             _burnAllArgs(_to, _value);
906         } else {
907             super._transferAllArgs(_from, _to, _value);
908         }
909     }
910     
911     // StandardToken's transferFrom doesn't have to check for
912     // _to != 0x0, but we do because we redirect 0x0 transfers to burns, but
913     // we do not redirect transferFrom
914     function _transferFromAllArgs(address _from, address _to, uint256 _value, address _spender) internal {
915         require(_to != address(0), "_to address is 0x0");
916         super._transferFromAllArgs(_from, _to, _value, _spender);
917     }
918 
919     function incrementRedemptionAddressCount() external onlyOwner {
920         emit RedemptionAddress(address(redemptionAddressCount));
921         redemptionAddressCount += 1;
922     }
923 }
924 
925 // File: contracts/DepositToken.sol
926 
927 /** @title Deposit Token
928 Allows users to register their address so that all transfers to deposit addresses
929 of the registered address will be forwarded to the registered address.  
930 For example for address 0x9052BE99C9C8C5545743859e4559A751bDe4c923,
931 its deposit addresses are all addresses between
932 0x9052BE99C9C8C5545743859e4559A75100000 and 0x9052BE99C9C8C5545743859e4559A751fffff
933 Transfers to 0x9052BE99C9C8C5545743859e4559A75100005 will be forwared to 0x9052BE99C9C8C5545743859e4559A751bDe4c923
934  */
935 contract DepositToken is ModularPausableToken {
936     
937     bytes32 public constant IS_DEPOSIT_ADDRESS = "isDepositAddress"; 
938 
939     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
940         address shiftedAddress = address(uint(_to) >> 20);
941         uint depositAddressValue = registry.getAttributeValue(shiftedAddress, IS_DEPOSIT_ADDRESS);
942         if (depositAddressValue != 0) {
943             super._transferAllArgs(_from, _to, _value);
944             super._transferAllArgs(_to, address(depositAddressValue), _value);
945         } else {
946             super._transferAllArgs(_from, _to, _value);
947         }
948     }
949 
950     function mint(address _to, uint256 _value) public onlyOwner {
951         address shiftedAddress = address(uint(_to) >> 20);
952         uint depositAddressValue = registry.getAttributeValue(shiftedAddress, IS_DEPOSIT_ADDRESS);
953         if (depositAddressValue != 0) {
954             super.mint(_to, _value);
955             super._transferAllArgs(_to, address(depositAddressValue), _value);
956         } else {
957             super.mint(_to, _value);
958         }
959     }
960 }
961 
962 // File: contracts/GasRefundToken.sol
963 
964 /**  
965 @title Gas Refund Token
966 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
967 Each time an non-empty storage slot is set to 0, evm refund 15,000 (19,000 after Constantinople) to the sender
968 of the transaction. 
969 */
970 contract GasRefundToken is ModularPausableToken {
971 
972     function sponsorGas() external {
973         uint256 len = gasRefundPool.length;
974         gasRefundPool.length = len + 9;
975         gasRefundPool[len] = 1;
976         gasRefundPool[len + 1] = 1;
977         gasRefundPool[len + 2] = 1;
978         gasRefundPool[len + 3] = 1;
979         gasRefundPool[len + 4] = 1;
980         gasRefundPool[len + 5] = 1;
981         gasRefundPool[len + 6] = 1;
982         gasRefundPool[len + 7] = 1;
983         gasRefundPool[len + 8] = 1;
984     }  
985 
986     /**  
987     @dev refund upto 45,000 (57,000 after Constantinople) gas for functions with 
988     gasRefund modifier.
989     */
990     modifier gasRefund {
991         uint256 len = gasRefundPool.length;
992         if (len != 0) {
993             gasRefundPool[--len] = 0;
994             gasRefundPool[--len] = 0;
995             gasRefundPool[--len] = 0;
996             gasRefundPool.length = len;
997         }   
998         _;  
999     }
1000 
1001     /**  
1002     *@dev Return the remaining sponsored gas slots
1003     */
1004     function remainingGasRefundPool() public view returns(uint) {
1005         return gasRefundPool.length;
1006     }
1007 
1008     function _transferAllArgs(address _from, address _to, uint256 _value) internal gasRefund {
1009         super._transferAllArgs(_from, _to, _value);
1010     }
1011 
1012     function mint(address _to, uint256 _value) public onlyOwner gasRefund {
1013         super.mint(_to, _value);
1014     }
1015 }
1016 
1017 // File: contracts/TrueCoinReceiver.sol
1018 
1019 contract TrueCoinReceiver {
1020     function tokenFallback( address from, uint256 value ) external;
1021 }
1022 
1023 // File: contracts/TokenWithHook.sol
1024 
1025 /** @title Token With Hook
1026 If tokens are transferred to a Registered Token Receiver contract, trigger the tokenFallback function in the 
1027 Token Receiver contract. Assume all Registered Token Receiver contract implements the TrueCoinReceiver 
1028 interface. If the tokenFallback reverts, the entire transaction reverts. 
1029  */
1030 contract TokenWithHook is ModularPausableToken {
1031     
1032     bytes32 public constant IS_REGISTERED_CONTRACT = "isRegisteredContract"; 
1033 
1034     function _transferAllArgs(address _from, address _to, uint256 _value) internal {
1035         uint length;
1036         assembly { length := extcodesize(_to) }
1037         super._transferAllArgs(_from, _to, _value);
1038         if (length > 0) {
1039             if(registry.hasAttribute(_to, IS_REGISTERED_CONTRACT)) {
1040                 TrueCoinReceiver(_to).tokenFallback(_from, _value);
1041             }
1042         }
1043     }
1044 }
1045 
1046 // File: contracts/DelegateERC20.sol
1047 
1048 /** @title DelegateERC20
1049 Accept forwarding delegation calls from the old TrueUSD (V1) contract. THis way the all the ERC20
1050 functions in the old contract still works (except Burn). 
1051 */
1052 contract DelegateERC20 is ModularStandardToken {
1053 
1054     address public constant DELEGATE_FROM = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
1055     
1056     modifier onlyDelegateFrom() {
1057         require(msg.sender == DELEGATE_FROM);
1058         _;
1059     }
1060 
1061     function delegateTotalSupply() public view returns (uint256) {
1062         return totalSupply();
1063     }
1064 
1065     function delegateBalanceOf(address who) public view returns (uint256) {
1066         return balanceOf(who);
1067     }
1068 
1069     function delegateTransfer(address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1070         _transferAllArgs(origSender, to, value);
1071         return true;
1072     }
1073 
1074     function delegateAllowance(address owner, address spender) public view returns (uint256) {
1075         return allowance(owner, spender);
1076     }
1077 
1078     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1079         _transferFromAllArgs(from, to, value, origSender);
1080         return true;
1081     }
1082 
1083     function delegateApprove(address spender, uint256 value, address origSender) public onlyDelegateFrom returns (bool) {
1084         _approveAllArgs(spender, value, origSender);
1085         return true;
1086     }
1087 
1088     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public onlyDelegateFrom returns (bool) {
1089         _increaseApprovalAllArgs(spender, addedValue, origSender);
1090         return true;
1091     }
1092 
1093     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public onlyDelegateFrom returns (bool) {
1094         _decreaseApprovalAllArgs(spender, subtractedValue, origSender);
1095         return true;
1096     }
1097 }
1098 
1099 // File: contracts/TrueUSD.sol
1100 
1101 /** @title TrueUSD
1102 * @dev This is the top-level ERC20 contract, but most of the interesting functionality is
1103 * inherited - see the documentation on the corresponding contracts.
1104 */
1105 contract TrueUSD is 
1106 ModularPausableToken, 
1107 BurnableTokenWithBounds, 
1108 CompliantToken,
1109 RedeemableToken,
1110 TokenWithHook,
1111 DelegateERC20,
1112 DepositToken,
1113 GasRefundToken {
1114     using SafeMath for *;
1115 
1116     uint8 public constant DECIMALS = 18;
1117     uint8 public constant ROUNDING = 2;
1118 
1119     event ChangeTokenName(string newName, string newSymbol);
1120 
1121     /**  
1122     *@dev set the totalSupply of the contract for delegation purposes
1123     Can only be set once.
1124     */
1125     function initialize(uint256 _totalSupply) public {
1126         require(!initialized, "already initialized");
1127         initialized = true;
1128         owner = msg.sender;
1129         totalSupply_ = _totalSupply;
1130         burnMin = 10000 * 10**uint256(DECIMALS);
1131         burnMax = 20000000 * 10**uint256(DECIMALS);
1132         name = "TrueUSD";
1133         symbol = "TUSD";
1134     }
1135 
1136     function changeTokenName(string _name, string _symbol) external onlyOwner {
1137         name = _name;
1138         symbol = _symbol;
1139         emit ChangeTokenName(_name, _symbol);
1140     }
1141 
1142     /**  
1143     *@dev send all eth balance in the TrueUSD contract to another address
1144     */
1145     function reclaimEther(address _to) external onlyOwner {
1146         _to.transfer(address(this).balance);
1147     }
1148 
1149     /**  
1150     *@dev send all token balance of an arbitary erc20 token
1151     in the TrueUSD contract to another address
1152     */
1153     function reclaimToken(ERC20 token, address _to) external onlyOwner {
1154         uint256 balance = token.balanceOf(this);
1155         token.transfer(_to, balance);
1156     }
1157 
1158     /**  
1159     *@dev allows owner of TrueUSD to gain ownership of any contract that TrueUSD currently owns
1160     */
1161     function reclaimContract(Ownable _ownable) external onlyOwner {
1162         _ownable.transferOwnership(owner);
1163     }
1164 
1165     function _burnAllArgs(address _burner, uint256 _value) internal {
1166         //round down burn amount so that the lowest amount allowed is 1 cent
1167         uint burnAmount = _value.div(10 ** uint256(DECIMALS - ROUNDING)).mul(10 ** uint256(DECIMALS - ROUNDING));
1168         super._burnAllArgs(_burner, burnAmount);
1169     }
1170 }
1171 
1172 // File: contracts/Proxy/Proxy.sol
1173 
1174 /**
1175  * @title Proxy
1176  * @dev Gives the possibility to delegate any call to a foreign implementation.
1177  */
1178 contract Proxy {
1179     
1180     /**
1181     * @dev Tells the address of the implementation where every call will be delegated.
1182     * @return address of the implementation to which it will be delegated
1183     */
1184     function implementation() public view returns (address);
1185 
1186     /**
1187     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1188     * This function will return whatever the implementation call returns
1189     */
1190     function() external payable {
1191         address _impl = implementation();
1192         require(_impl != address(0), "implementation contract not set");
1193         
1194         assembly {
1195             let ptr := mload(0x40)
1196             calldatacopy(ptr, 0, calldatasize)
1197             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
1198             let size := returndatasize
1199             returndatacopy(ptr, 0, size)
1200 
1201             switch result
1202             case 0 { revert(ptr, size) }
1203             default { return(ptr, size) }
1204         }
1205     }
1206 }
1207 
1208 // File: contracts/Proxy/UpgradeabilityProxy.sol
1209 
1210 /**
1211  * @title UpgradeabilityProxy
1212  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
1213  */
1214 contract UpgradeabilityProxy is Proxy {
1215     /**
1216     * @dev This event will be emitted every time the implementation gets upgraded
1217     * @param implementation representing the address of the upgraded implementation
1218     */
1219     event Upgraded(address indexed implementation);
1220 
1221     // Storage position of the address of the current implementation
1222     bytes32 private constant implementationPosition = keccak256("trueUSD.proxy.implementation");
1223 
1224     /**
1225     * @dev Tells the address of the current implementation
1226     * @return address of the current implementation
1227     */
1228     function implementation() public view returns (address impl) {
1229         bytes32 position = implementationPosition;
1230         assembly {
1231           impl := sload(position)
1232         }
1233     }
1234 
1235     /**
1236     * @dev Sets the address of the current implementation
1237     * @param newImplementation address representing the new implementation to be set
1238     */
1239     function _setImplementation(address newImplementation) internal {
1240         bytes32 position = implementationPosition;
1241         assembly {
1242           sstore(position, newImplementation)
1243         }
1244     }
1245 
1246     /**
1247     * @dev Upgrades the implementation address
1248     * @param newImplementation representing the address of the new implementation to be set
1249     */
1250     function _upgradeTo(address newImplementation) internal {
1251         address currentImplementation = implementation();
1252         require(currentImplementation != newImplementation);
1253         _setImplementation(newImplementation);
1254         emit Upgraded(newImplementation);
1255     }
1256 }
1257 
1258 // File: contracts/Proxy/OwnedUpgradeabilityProxy.sol
1259 
1260 /**
1261  * @title OwnedUpgradeabilityProxy
1262  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
1263  */
1264 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
1265     /**
1266     * @dev Event to show ownership has been transferred
1267     * @param previousOwner representing the address of the previous owner
1268     * @param newOwner representing the address of the new owner
1269     */
1270     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1271 
1272     /**
1273     * @dev Event to show ownership transfer is pending
1274     * @param currentOwner representing the address of the current owner
1275     * @param pendingOwner representing the address of the pending owner
1276     */
1277     event NewPendingOwner(address currentOwner, address pendingOwner);
1278     
1279     // Storage position of the owner and pendingOwner of the contract
1280     bytes32 private constant proxyOwnerPosition = keccak256("trueUSD.proxy.owner");
1281     bytes32 private constant pendingProxyOwnerPosition = keccak256("trueUSD.pending.proxy.owner");
1282 
1283     /**
1284     * @dev the constructor sets the original owner of the contract to the sender account.
1285     */
1286     constructor() public {
1287         _setUpgradeabilityOwner(msg.sender);
1288     }
1289 
1290     /**
1291     * @dev Throws if called by any account other than the owner.
1292     */
1293     modifier onlyProxyOwner() {
1294         require(msg.sender == proxyOwner(), "only Proxy Owner");
1295         _;
1296     }
1297 
1298     /**
1299     * @dev Throws if called by any account other than the pending owner.
1300     */
1301     modifier onlyPendingProxyOwner() {
1302         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
1303         _;
1304     }
1305 
1306     /**
1307     * @dev Tells the address of the owner
1308     * @return the address of the owner
1309     */
1310     function proxyOwner() public view returns (address owner) {
1311         bytes32 position = proxyOwnerPosition;
1312         assembly {
1313             owner := sload(position)
1314         }
1315     }
1316 
1317     /**
1318     * @dev Tells the address of the owner
1319     * @return the address of the owner
1320     */
1321     function pendingProxyOwner() public view returns (address pendingOwner) {
1322         bytes32 position = pendingProxyOwnerPosition;
1323         assembly {
1324             pendingOwner := sload(position)
1325         }
1326     }
1327 
1328     /**
1329     * @dev Sets the address of the owner
1330     */
1331     function _setUpgradeabilityOwner(address newProxyOwner) internal {
1332         bytes32 position = proxyOwnerPosition;
1333         assembly {
1334             sstore(position, newProxyOwner)
1335         }
1336     }
1337 
1338     /**
1339     * @dev Sets the address of the owner
1340     */
1341     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
1342         bytes32 position = pendingProxyOwnerPosition;
1343         assembly {
1344             sstore(position, newPendingProxyOwner)
1345         }
1346     }
1347 
1348     /**
1349     * @dev Allows the current owner to transfer control of the contract to a newOwner.
1350     *changes the pending owner to newOwner. But doesn't actually transfer
1351     * @param newOwner The address to transfer ownership to.
1352     */
1353     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
1354         require(newOwner != address(0));
1355         _setPendingUpgradeabilityOwner(newOwner);
1356         emit NewPendingOwner(proxyOwner(), newOwner);
1357     }
1358 
1359     /**
1360     * @dev Allows the pendingOwner to claim ownership of the proxy
1361     */
1362     function claimProxyOwnership() external onlyPendingProxyOwner {
1363         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
1364         _setUpgradeabilityOwner(pendingProxyOwner());
1365         _setPendingUpgradeabilityOwner(address(0));
1366     }
1367 
1368     /**
1369     * @dev Allows the proxy owner to upgrade the current version of the proxy.
1370     * @param implementation representing the address of the new implementation to be set.
1371     */
1372     function upgradeTo(address implementation) external onlyProxyOwner {
1373         _upgradeTo(implementation);
1374     }
1375 }
1376 
1377 // File: contracts/Admin/TokenController.sol
1378 
1379 /** @title TokenController
1380 @dev This contract allows us to split ownership of the TrueUSD contract
1381 into two addresses. One, called the "owner" address, has unfettered control of the TrueUSD contract -
1382 it can mint new tokens, transfer ownership of the contract, etc. However to make
1383 extra sure that TrueUSD is never compromised, this owner key will not be used in
1384 day-to-day operations, allowing it to be stored at a heightened level of security.
1385 Instead, the owner appoints an various "admin" address. 
1386 There are 3 different types of admin addresses;  MintKey, MintRatifier, and MintPauser. 
1387 MintKey can request and revoke mints one at a time.
1388 MintPausers can pause individual mints or pause all mints.
1389 MintRatifiers can approve and finalize mints with enough approval.
1390 
1391 There are three levels of mints: instant mint, ratified mint, and multiSig mint. Each have a different threshold
1392 and deduct from a different pool.
1393 Instant mint has the lowest threshold and finalizes instantly without any ratifiers. Deduct from instant mint pool,
1394 which can be refilled by one ratifier.
1395 Ratify mint has the second lowest threshold and finalizes with one ratifier approval. Deduct from ratify mint pool,
1396 which can be refilled by three ratifiers.
1397 MultiSig mint has the highest threshold and finalizes with three ratifier approvals. Deduct from multiSig mint pool,
1398 which can only be refilled by the owner.
1399 */
1400 
1401 contract TokenController {
1402     using SafeMath for uint256;
1403 
1404     struct MintOperation {
1405         address to;
1406         uint256 value;
1407         uint256 requestedBlock;
1408         uint256 numberOfApproval;
1409         bool paused;
1410         mapping(address => bool) approved; 
1411     }
1412 
1413     address public owner;
1414     address public pendingOwner;
1415 
1416     bool public initialized;
1417 
1418     uint256 public instantMintThreshold;
1419     uint256 public ratifiedMintThreshold;
1420     uint256 public multiSigMintThreshold;
1421 
1422 
1423     uint256 public instantMintLimit; 
1424     uint256 public ratifiedMintLimit; 
1425     uint256 public multiSigMintLimit;
1426 
1427     uint256 public instantMintPool; 
1428     uint256 public ratifiedMintPool; 
1429     uint256 public multiSigMintPool;
1430     address[2] public ratifiedPoolRefillApprovals;
1431 
1432     uint8 constant public RATIFY_MINT_SIGS = 1; //number of approvals needed to finalize a Ratified Mint
1433     uint8 constant public MULTISIG_MINT_SIGS = 3; //number of approvals needed to finalize a MultiSig Mint
1434 
1435     bool public mintPaused;
1436     uint256 public mintReqInvalidBeforeThisBlock; //all mint request before this block are invalid
1437     address public mintKey;
1438     MintOperation[] public mintOperations; //list of a mint requests
1439     
1440     TrueUSD public trueUSD;
1441     Registry public registry;
1442     address public trueUsdFastPause;
1443 
1444     bytes32 constant public IS_MINT_PAUSER = "isTUSDMintPausers";
1445     bytes32 constant public IS_MINT_RATIFIER = "isTUSDMintRatifier";
1446     bytes32 constant public IS_REDEMPTION_ADMIN = "isTUSDRedemptionAdmin";
1447 
1448     modifier onlyFastPauseOrOwner() {
1449         require(msg.sender == trueUsdFastPause || msg.sender == owner, "must be pauser or owner");
1450         _;
1451     }
1452 
1453     modifier onlyMintKeyOrOwner() {
1454         require(msg.sender == mintKey || msg.sender == owner, "must be mintKey or owner");
1455         _;
1456     }
1457 
1458     modifier onlyMintPauserOrOwner() {
1459         require(registry.hasAttribute(msg.sender, IS_MINT_PAUSER) || msg.sender == owner, "must be pauser or owner");
1460         _;
1461     }
1462 
1463     modifier onlyMintRatifierOrOwner() {
1464         require(registry.hasAttribute(msg.sender, IS_MINT_RATIFIER) || msg.sender == owner, "must be ratifier or owner");
1465         _;
1466     }
1467 
1468     modifier onlyOwnerOrRedemptionAdmin() {
1469         require(registry.hasAttribute(msg.sender, IS_REDEMPTION_ADMIN) || msg.sender == owner, "must be Redemption admin or owner");
1470         _;
1471     }
1472 
1473     //mint operations by the mintkey cannot be processed on when mints are paused
1474     modifier mintNotPaused() {
1475         if (msg.sender != owner) {
1476             require(!mintPaused, "minting is paused");
1477         }
1478         _;
1479     }
1480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1481     event NewOwnerPending(address indexed currentOwner, address indexed pendingOwner);
1482     event SetRegistry(address indexed registry);
1483     event TransferChild(address indexed child, address indexed newOwner);
1484     event RequestReclaimContract(address indexed other);
1485     event SetTrueUSD(TrueUSD newContract);
1486     event TrueUsdInitialized();
1487     
1488     event RequestMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1489     event FinalizeMint(address indexed to, uint256 indexed value, uint256 opIndex, address mintKey);
1490     event InstantMint(address indexed to, uint256 indexed value, address indexed mintKey);
1491     
1492     event TransferMintKey(address indexed previousMintKey, address indexed newMintKey);
1493     event MintRatified(uint256 indexed opIndex, address indexed ratifier);
1494     event RevokeMint(uint256 opIndex);
1495     event AllMintsPaused(bool status);
1496     event MintPaused(uint opIndex, bool status);
1497     event MintApproved(address approver, uint opIndex);
1498     event TrueUsdFastPauseSet(address _newFastPause);
1499 
1500     event MintThresholdChanged(uint instant, uint ratified, uint multiSig);
1501     event MintLimitsChanged(uint instant, uint ratified, uint multiSig);
1502     event InstantPoolRefilled();
1503     event RatifyPoolRefilled();
1504     event MultiSigPoolRefilled();
1505 
1506     /*
1507     ========================================
1508     Ownership functions
1509     ========================================
1510     */
1511 
1512     function initialize() external {
1513         require(!initialized, "already initialized");
1514         owner = msg.sender;
1515         initialized = true;
1516     }
1517 
1518     /**
1519     * @dev Throws if called by any account other than the owner.
1520     */
1521     modifier onlyOwner() {
1522         require(msg.sender == owner, "only Owner");
1523         _;
1524     }
1525 
1526     /**
1527     * @dev Modifier throws if called by any account other than the pendingOwner.
1528     */
1529     modifier onlyPendingOwner() {
1530         require(msg.sender == pendingOwner);
1531         _;
1532     }
1533 
1534     /**
1535     * @dev Allows the current owner to set the pendingOwner address.
1536     * @param newOwner The address to transfer ownership to.
1537     */
1538     function transferOwnership(address newOwner) external onlyOwner {
1539         pendingOwner = newOwner;
1540         emit NewOwnerPending(owner, pendingOwner);
1541     }
1542 
1543     /**
1544     * @dev Allows the pendingOwner address to finalize the transfer.
1545     */
1546     function claimOwnership() external onlyPendingOwner {
1547         emit OwnershipTransferred(owner, pendingOwner);
1548         owner = pendingOwner;
1549         pendingOwner = address(0);
1550     }
1551     
1552     /*
1553     ========================================
1554     proxy functions
1555     ========================================
1556     */
1557 
1558     function transferTusdProxyOwnership(address _newOwner) external onlyOwner {
1559         OwnedUpgradeabilityProxy(trueUSD).transferProxyOwnership(_newOwner);
1560     }
1561 
1562     function claimTusdProxyOwnership() external onlyOwner {
1563         OwnedUpgradeabilityProxy(trueUSD).claimProxyOwnership();
1564     }
1565 
1566     function upgradeTusdProxyImplTo(address _implementation) external onlyOwner {
1567         OwnedUpgradeabilityProxy(trueUSD).upgradeTo(_implementation);
1568     }
1569 
1570     /*
1571     ========================================
1572     Minting functions
1573     ========================================
1574     */
1575 
1576     /**
1577      * @dev set the threshold for a mint to be considered an instant mint, ratify mint and multiSig mint
1578      Instant mint requires no approval, ratify mint requires 1 approval and multiSig mint requires 3 approvals
1579      */
1580     function setMintThresholds(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1581         require(_instant < _ratified && _ratified < _multiSig);
1582         instantMintThreshold = _instant;
1583         ratifiedMintThreshold = _ratified;
1584         multiSigMintThreshold = _multiSig;
1585         emit MintThresholdChanged(_instant, _ratified, _multiSig);
1586     }
1587 
1588 
1589     /**
1590      * @dev set the limit of each mint pool. For example can only instant mint up to the instant mint pool limit
1591      before needing to refill
1592      */
1593     function setMintLimits(uint256 _instant, uint256 _ratified, uint256 _multiSig) external onlyOwner {
1594         require(_instant < _ratified && _ratified < _multiSig);
1595         instantMintLimit = _instant;
1596         ratifiedMintLimit = _ratified;
1597         multiSigMintLimit = _multiSig;
1598         emit MintLimitsChanged(_instant, _ratified, _multiSig);
1599     }
1600 
1601     /**
1602      * @dev Ratifier can refill instant mint pool
1603      */
1604     function refillInstantMintPool() external onlyMintRatifierOrOwner {
1605         ratifiedMintPool = ratifiedMintPool.sub(instantMintLimit.sub(instantMintPool));
1606         instantMintPool = instantMintLimit;
1607         emit InstantPoolRefilled();
1608     }
1609 
1610     /**
1611      * @dev Owner or 3 ratifiers can refill Ratified Mint Pool
1612      */
1613     function refillRatifiedMintPool() external onlyMintRatifierOrOwner {
1614         if (msg.sender != owner) {
1615             address[2] memory refillApprovals = ratifiedPoolRefillApprovals;
1616             require(msg.sender != refillApprovals[0] && msg.sender != refillApprovals[1]);
1617             if (refillApprovals[0] == address(0)) {
1618                 ratifiedPoolRefillApprovals[0] = msg.sender;
1619                 return;
1620             } 
1621             if (refillApprovals[1] == address(0)) {
1622                 ratifiedPoolRefillApprovals[1] = msg.sender;
1623                 return;
1624             } 
1625         }
1626         delete ratifiedPoolRefillApprovals; // clears the whole array
1627         multiSigMintPool = multiSigMintPool.sub(ratifiedMintLimit.sub(ratifiedMintPool));
1628         ratifiedMintPool = ratifiedMintLimit;
1629         emit RatifyPoolRefilled();
1630     }
1631 
1632     /**
1633      * @dev Owner can refill MultiSig Mint Pool
1634      */
1635     function refillMultiSigMintPool() external onlyOwner {
1636         multiSigMintPool = multiSigMintLimit;
1637         emit MultiSigPoolRefilled();
1638     }
1639 
1640     /**
1641      * @dev mintKey initiates a request to mint _value TrueUSD for account _to
1642      * @param _to the address to mint to
1643      * @param _value the amount requested
1644      */
1645     function requestMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1646         MintOperation memory op = MintOperation(_to, _value, block.number, 0, false);
1647         emit RequestMint(_to, _value, mintOperations.length, msg.sender);
1648         mintOperations.push(op);
1649     }
1650 
1651 
1652     /**
1653      * @dev Instant mint without ratification if the amount is less than instantMintThreshold and instantMintPool
1654      * @param _to the address to mint to
1655      * @param _value the amount minted
1656      */
1657     function instantMint(address _to, uint256 _value) external mintNotPaused onlyMintKeyOrOwner {
1658         require(_value <= instantMintThreshold, "over the instant mint threshold");
1659         require(_value <= instantMintPool, "instant mint pool is dry");
1660         instantMintPool = instantMintPool.sub(_value);
1661         emit InstantMint(_to, _value, msg.sender);
1662         trueUSD.mint(_to, _value);
1663     }
1664 
1665 
1666     /**
1667      * @dev ratifier ratifies a request mint. If the number of ratifiers that signed off is greater than 
1668      the number of approvals required, the request is finalized
1669      * @param _index the index of the requestMint to ratify
1670      * @param _to the address to mint to
1671      * @param _value the amount requested
1672      */
1673     function ratifyMint(uint256 _index, address _to, uint256 _value) external mintNotPaused onlyMintRatifierOrOwner {
1674         MintOperation memory op = mintOperations[_index];
1675         require(op.to == _to, "to address does not match");
1676         require(op.value == _value, "amount does not match");
1677         require(!mintOperations[_index].approved[msg.sender], "already approved");
1678         mintOperations[_index].approved[msg.sender] = true;
1679         mintOperations[_index].numberOfApproval = mintOperations[_index].numberOfApproval.add(1);
1680         emit MintRatified(_index, msg.sender);
1681         if (hasEnoughApproval(mintOperations[_index].numberOfApproval, _value)){
1682             finalizeMint(_index);
1683         }
1684     }
1685 
1686     /**
1687      * @dev finalize a mint request, mint the amount requested to the specified address
1688      @param _index of the request (visible in the RequestMint event accompanying the original request)
1689      */
1690     function finalizeMint(uint256 _index) public mintNotPaused {
1691         MintOperation memory op = mintOperations[_index];
1692         address to = op.to;
1693         uint256 value = op.value;
1694         if (msg.sender != owner) {
1695             require(canFinalize(_index));
1696             _subtractFromMintPool(value);
1697         }
1698         delete mintOperations[_index];
1699         trueUSD.mint(to, value);
1700         emit FinalizeMint(to, value, _index, msg.sender);
1701     }
1702 
1703     /**
1704      * assumption: only invoked when canFinalize
1705      */
1706     function _subtractFromMintPool(uint256 _value) internal {
1707         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1708             ratifiedMintPool = ratifiedMintPool.sub(_value);
1709         } else {
1710             multiSigMintPool = multiSigMintPool.sub(_value);
1711         }
1712     }
1713 
1714     /**
1715      * @dev compute if the number of approvals is enough for a given mint amount
1716      */
1717     function hasEnoughApproval(uint256 _numberOfApproval, uint256 _value) public view returns (bool) {
1718         if (_value <= ratifiedMintPool && _value <= ratifiedMintThreshold) {
1719             if (_numberOfApproval >= RATIFY_MINT_SIGS){
1720                 return true;
1721             }
1722         }
1723         if (_value <= multiSigMintPool && _value <= multiSigMintThreshold) {
1724             if (_numberOfApproval >= MULTISIG_MINT_SIGS){
1725                 return true;
1726             }
1727         }
1728         if (msg.sender == owner) {
1729             return true;
1730         }
1731         return false;
1732     }
1733 
1734     /**
1735      * @dev compute if a mint request meets all the requirements to be finalized
1736      utility function for a front end
1737      */
1738     function canFinalize(uint256 _index) public view returns(bool) {
1739         MintOperation memory op = mintOperations[_index];
1740         require(op.requestedBlock > mintReqInvalidBeforeThisBlock, "this mint is invalid"); //also checks if request still exists
1741         require(!op.paused, "this mint is paused");
1742         require(hasEnoughApproval(op.numberOfApproval, op.value), "not enough approvals");
1743         return true;
1744     }
1745 
1746     /** 
1747     *@dev revoke a mint request, Delete the mintOperation
1748     *@param index of the request (visible in the RequestMint event accompanying the original request)
1749     */
1750     function revokeMint(uint256 _index) external onlyMintKeyOrOwner {
1751         delete mintOperations[_index];
1752         emit RevokeMint(_index);
1753     }
1754 
1755     function mintOperationCount() public view returns (uint256) {
1756         return mintOperations.length;
1757     }
1758 
1759     /*
1760     ========================================
1761     Key management
1762     ========================================
1763     */
1764 
1765     /** 
1766     *@dev Replace the current mintkey with new mintkey 
1767     *@param _newMintKey address of the new mintKey
1768     */
1769     function transferMintKey(address _newMintKey) external onlyOwner {
1770         require(_newMintKey != address(0), "new mint key cannot be 0x0");
1771         emit TransferMintKey(mintKey, _newMintKey);
1772         mintKey = _newMintKey;
1773     }
1774  
1775     /*
1776     ========================================
1777     Mint Pausing
1778     ========================================
1779     */
1780 
1781     /** 
1782     *@dev invalidates all mint request initiated before the current block 
1783     */
1784     function invalidateAllPendingMints() external onlyOwner {
1785         mintReqInvalidBeforeThisBlock = block.number;
1786     }
1787 
1788     /** 
1789     *@dev pause any further mint request and mint finalizations 
1790     */
1791     function pauseMints() external onlyMintPauserOrOwner {
1792         mintPaused = true;
1793         emit AllMintsPaused(true);
1794     }
1795 
1796     /** 
1797     *@dev unpause any further mint request and mint finalizations 
1798     */
1799     function unpauseMints() external onlyOwner {
1800         mintPaused = false;
1801         emit AllMintsPaused(false);
1802     }
1803 
1804     /** 
1805     *@dev pause a specific mint request
1806     *@param  _opIndex the index of the mint request the caller wants to pause
1807     */
1808     function pauseMint(uint _opIndex) external onlyMintPauserOrOwner {
1809         mintOperations[_opIndex].paused = true;
1810         emit MintPaused(_opIndex, true);
1811     }
1812 
1813     /** 
1814     *@dev unpause a specific mint request
1815     *@param  _opIndex the index of the mint request the caller wants to unpause
1816     */
1817     function unpauseMint(uint _opIndex) external onlyOwner {
1818         mintOperations[_opIndex].paused = false;
1819         emit MintPaused(_opIndex, false);
1820     }
1821 
1822     /*
1823     ========================================
1824     set and claim contracts, administrative
1825     ========================================
1826     */
1827 
1828 
1829     /** 
1830     *@dev Increment redemption address count of TrueUSD
1831     */
1832     function incrementRedemptionAddressCount() external onlyOwnerOrRedemptionAdmin {
1833         trueUSD.incrementRedemptionAddressCount();
1834     }
1835 
1836     /** 
1837     *@dev Update this contract's trueUSD pointer to newContract (e.g. if the
1838     contract is upgraded)
1839     */
1840     function setTrueUSD(TrueUSD _newContract) external onlyOwner {
1841         trueUSD = _newContract;
1842         emit SetTrueUSD(_newContract);
1843     }
1844 
1845     function initializeTrueUSD(uint256 _totalSupply) external onlyOwner {
1846         trueUSD.initialize(_totalSupply);
1847         emit TrueUsdInitialized();
1848     }
1849 
1850     /** 
1851     *@dev Update this contract's registry pointer to _registry
1852     */
1853     function setRegistry(Registry _registry) external onlyOwner {
1854         registry = _registry;
1855         emit SetRegistry(registry);
1856     }
1857 
1858     /** 
1859     *@dev update TrueUSD's name and symbol
1860     */
1861     function changeTokenName(string _name, string _symbol) external onlyOwner {
1862         trueUSD.changeTokenName(_name, _symbol);
1863     }
1864 
1865     /** 
1866     *@dev Swap out TrueUSD's permissions registry
1867     *@param _registry new registry for trueUSD
1868     */
1869     function setTusdRegistry(Registry _registry) external onlyOwner {
1870         trueUSD.setRegistry(_registry);
1871     }
1872 
1873     /** 
1874     *@dev Claim ownership of an arbitrary HasOwner contract
1875     */
1876     function issueClaimOwnership(address _other) public onlyOwner {
1877         HasOwner other = HasOwner(_other);
1878         other.claimOwnership();
1879     }
1880 
1881     /** 
1882     *@dev calls setBalanceSheet(address) and setAllowanceSheet(address) on the _proxy contract
1883     @param _proxy the contract that inplments setBalanceSheet and setAllowanceSheet
1884     @param _balanceSheet HasOwner storage contract
1885     @param _allowanceSheet HasOwner storage contract
1886     */
1887     function claimStorageForProxy(
1888         TrueUSD _proxy,
1889         HasOwner _balanceSheet,
1890         HasOwner _allowanceSheet) external onlyOwner {
1891 
1892         //call to claim the storage contract with the new delegate contract
1893         _proxy.setBalanceSheet(_balanceSheet);
1894         _proxy.setAllowanceSheet(_allowanceSheet);
1895     }
1896 
1897     /** 
1898     *@dev Transfer ownership of _child to _newOwner.
1899     Can be used e.g. to upgrade this TokenController contract.
1900     *@param _child contract that tokenController currently Owns 
1901     *@param _newOwner new owner/pending owner of _child
1902     */
1903     function transferChild(HasOwner _child, address _newOwner) external onlyOwner {
1904         _child.transferOwnership(_newOwner);
1905         emit TransferChild(_child, _newOwner);
1906     }
1907 
1908     /** 
1909     *@dev Transfer ownership of a contract from trueUSD to this TokenController.
1910     Can be used e.g. to reclaim balance sheet
1911     in order to transfer it to an upgraded TrueUSD contract.
1912     *@param _other address of the contract to claim ownership of
1913     */
1914     function requestReclaimContract(Ownable _other) public onlyOwner {
1915         trueUSD.reclaimContract(_other);
1916         emit RequestReclaimContract(_other);
1917     }
1918 
1919     /** 
1920     *@dev send all ether in trueUSD address to the owner of tokenController 
1921     */
1922     function requestReclaimEther() external onlyOwner {
1923         trueUSD.reclaimEther(owner);
1924     }
1925 
1926     /** 
1927     *@dev transfer all tokens of a particular type in trueUSD address to the
1928     owner of tokenController 
1929     *@param _token token address of the token to transfer
1930     */
1931     function requestReclaimToken(ERC20 _token) external onlyOwner {
1932         trueUSD.reclaimToken(_token, owner);
1933     }
1934 
1935     /** 
1936     *@dev set new contract to which tokens look to to see if it's on the supported fork
1937     *@param _newGlobalPause address of the new contract
1938     */
1939     function setGlobalPause(address _newGlobalPause) external onlyOwner {
1940         trueUSD.setGlobalPause(_newGlobalPause);
1941     }
1942 
1943     /** 
1944     *@dev set new contract to which specified address can send eth to to quickly pause trueUSD
1945     *@param _newFastPause address of the new contract
1946     */
1947     function setTrueUsdFastPause(address _newFastPause) external onlyOwner {
1948         trueUsdFastPause = _newFastPause;
1949         emit TrueUsdFastPauseSet(_newFastPause);
1950     }
1951 
1952     /** 
1953     *@dev pause all pausable actions on TrueUSD, mints/burn/transfer/approve
1954     */
1955     function pauseTrueUSD() external onlyFastPauseOrOwner {
1956         trueUSD.pause();
1957     }
1958 
1959     /** 
1960     *@dev unpause all pausable actions on TrueUSD, mints/burn/transfer/approve
1961     */
1962     function unpauseTrueUSD() external onlyOwner {
1963         trueUSD.unpause();
1964     }
1965     
1966     /** 
1967     *@dev wipe balance of a blacklisted address
1968     *@param _blacklistedAddress address whose balance will be wiped
1969     */
1970     function wipeBlackListedTrueUSD(address _blacklistedAddress) external onlyOwner {
1971         trueUSD.wipeBlacklistedAccount(_blacklistedAddress);
1972     }
1973 
1974     /** 
1975     *@dev Change the minimum and maximum amounts that TrueUSD users can
1976     burn to newMin and newMax
1977     *@param _min minimum amount user can burn at a time
1978     *@param _max maximum amount user can burn at a time
1979     */
1980     function setBurnBounds(uint256 _min, uint256 _max) external onlyOwner {
1981         trueUSD.setBurnBounds(_min, _max);
1982     }
1983 
1984     /** 
1985     *@dev Owner can send ether balance in contract address
1986     *@param _to address to which the funds will be send to
1987     */
1988     function reclaimEther(address _to) external onlyOwner {
1989         _to.transfer(address(this).balance);
1990     }
1991 
1992     /** 
1993     *@dev Owner can send erc20 token balance in contract address
1994     *@param _token address of the token to send
1995     *@param _to address to which the funds will be send to
1996     */
1997     function reclaimToken(ERC20 _token, address _to) external onlyOwner {
1998         uint256 balance = _token.balanceOf(this);
1999         _token.transfer(_to, balance);
2000     }
2001 }