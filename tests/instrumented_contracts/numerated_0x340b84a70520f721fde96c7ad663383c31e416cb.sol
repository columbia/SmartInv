1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 }
88 
89 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
90 
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97     address public pendingOwner;
98 
99     /**
100      * @dev Modifier throws if called by any account other than the pendingOwner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to set the pendingOwner address.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) onlyOwner public {
112         pendingOwner = newOwner;
113     }
114 
115     /**
116      * @dev Allows the pendingOwner address to finalize the transfer.
117      */
118     function claimOwnership() onlyPendingOwner public {
119         emit OwnershipTransferred(owner, pendingOwner);
120         owner = pendingOwner;
121         pendingOwner = address(0);
122     }
123 }
124 
125 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
126 
127 /**
128  * @title Contracts that should not own Ether
129  * @author Remco Bloemen <remco@2π.com>
130  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
131  * in the contract, it will allow the owner to reclaim this Ether.
132  * @notice Ether can still be sent to this contract by:
133  * calling functions labeled `payable`
134  * `selfdestruct(contract_address)`
135  * mining directly to the contract address
136  */
137 contract HasNoEther is Ownable {
138     /**
139     * @dev Constructor that rejects incoming Ether
140     * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
141     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
142     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
143     * we could use assembly to access msg.value.
144     */
145     constructor() public payable {
146         require(msg.value == 0);
147     }
148 
149     /**
150      * @dev Disallows direct send by setting a default function without the `payable` flag.
151      */
152     function() external {
153     }
154 
155     /**
156      * @dev Transfer all Ether held by the contract to the owner.
157      */
158     function reclaimEther() external onlyOwner {
159         owner.transfer(address(this).balance);
160     }
161 }
162 
163 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
164 
165 /**
166  * @title ERC20Basic
167  * @dev Simpler version of ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/179
169  */
170 contract ERC20Basic {
171     function totalSupply() public view returns (uint256);
172 
173     function balanceOf(address who) public view returns (uint256);
174 
175     function transfer(address to, uint256 value) public returns (bool);
176 
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187     function allowance(address owner, address spender) public view returns (uint256);
188 
189     function transferFrom(address from, address to, uint256 value) public returns (bool);
190 
191     function approve(address spender, uint256 value) public returns (bool);
192 
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
197 
198 /**
199  * @title SafeERC20
200  * @dev Wrappers around ERC20 operations that throw on failure.
201  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
202  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
203  */
204 library SafeERC20 {
205     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
206         assert(token.transfer(to, value));
207     }
208 
209     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
210         assert(token.transferFrom(from, to, value));
211     }
212 
213     function safeApprove(ERC20 token, address spender, uint256 value) internal {
214         assert(token.approve(spender, value));
215     }
216 }
217 
218 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
219 
220 /**
221  * @title Contracts that should be able to recover tokens
222  * @author SylTi
223  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
224  * This will prevent any accidental loss of tokens.
225  */
226 contract CanReclaimToken is Ownable {
227     using SafeERC20 for ERC20Basic;
228 
229     /**
230      * @dev Reclaim all ERC20Basic compatible tokens
231      * @param token ERC20Basic The address of the token contract
232      */
233     function reclaimToken(ERC20Basic token) external onlyOwner {
234         uint256 balance = token.balanceOf(this);
235         token.safeTransfer(owner, balance);
236     }
237 }
238 
239 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
240 
241 /**
242  * @title Contracts that should not own Tokens
243  * @author Remco Bloemen <remco@2π.com>
244  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
245  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
246  * owner to reclaim the tokens.
247  */
248 contract HasNoTokens is CanReclaimToken {
249     /**
250      * @dev Reject all ERC223 compatible tokens
251      * @param _from address The address that is transferring the tokens
252      * @param _value uint256 the amount of the specified token
253      * @param _data Bytes The data passed from the caller.
254      */
255     function tokenFallback(address _from, uint256 _value, bytes _data) external pure {
256         _from;
257         _value;
258         _data;
259         revert();
260     }
261 }
262 
263 // File: contracts/AddressList.sol
264 
265 contract AddressList is Claimable {
266     string public name;
267     mapping(address => bool) public onList;
268 
269     constructor(string _name, bool nullValue) public {
270         name = _name;
271         onList[0x0] = nullValue;
272     }
273 
274     event ChangeWhiteList(address indexed to, bool onList);
275 
276     // Set whether _to is on the list or not. Whether 0x0 is on the list
277     // or not cannot be set here - it is set once and for all by the constructor.
278     function changeList(address _to, bool _onList) onlyOwner public {
279         require(_to != 0x0);
280         if (onList[_to] != _onList) {
281             onList[_to] = _onList;
282             emit ChangeWhiteList(_to, _onList);
283         }
284     }
285 }
286 
287 // File: contracts/NamableAddressList.sol
288 
289 contract NamableAddressList is AddressList {
290     constructor(string _name, bool nullValue)
291     AddressList(_name, nullValue) public {}
292 
293     function changeName(string _name) onlyOwner public {
294         name = _name;
295     }
296 }
297 
298 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
299 
300 /**
301  * @title Contracts that should not own Contracts
302  * @author Remco Bloemen <remco@2π.com>
303  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
304  * of this contract to reclaim ownership of the contracts.
305  */
306 contract HasNoContracts is Ownable{
307     /**
308      * @dev Reclaim ownership of Ownable contracts
309      * @param contractAddr The address of the Ownable to be reclaimed.
310      */
311     function reclaimContract(address contractAddr) external onlyOwner {
312         Ownable contractInst = Ownable(contractAddr);
313         contractInst.transferOwnership(owner);
314     }
315 }
316 
317 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
318 
319 /**
320  * @title Base contract for contracts that should not own things.
321  * @author Remco Bloemen <remco@2π.com>
322  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
323  * Owned contracts. See respective base contracts for details.
324  */
325 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
326 }
327 
328 // File: contracts/BalanceSheet.sol
329 
330 // A wrapper around the balanceOf mapping.
331 contract BalanceSheet is Claimable {
332     using SafeMath for uint256;
333 
334     mapping(address => uint256) public balanceOf;
335 
336     function addBalance(address _addr, uint256 _value) public onlyOwner {
337         balanceOf[_addr] = balanceOf[_addr].add(_value);
338     }
339 
340     function subBalance(address _addr, uint256 _value) public onlyOwner {
341         balanceOf[_addr] = balanceOf[_addr].sub(_value);
342     }
343 
344     function setBalance(address _addr, uint256 _value) public onlyOwner {
345         balanceOf[_addr] = _value;
346     }
347 }
348 
349 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
350 
351 /**
352  * @title Basic token
353  * @dev Basic version of StandardToken, with no allowances.
354  */
355 contract BasicToken is ERC20Basic, Claimable {
356     using SafeMath for uint256;
357 
358     BalanceSheet public balances;
359 
360     uint256 totalSupply_;
361 
362     function setBalanceSheet(address sheet) external onlyOwner {
363         balances = BalanceSheet(sheet);
364         balances.claimOwnership();
365     }
366 
367     /**
368     * @dev total number of tokens in existence
369     */
370     function totalSupply() public view returns (uint256) {
371         return totalSupply_;
372     }
373 
374     /**
375     * @dev transfer token for a specified address
376     * @param _to The address to transfer to.
377     * @param _value The amount to be transferred.
378     */
379     function transfer(address _to, uint256 _value) public returns (bool) {
380         transferAllArgsNoAllowance(msg.sender, _to, _value);
381         return true;
382     }
383 
384     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
385         require(_to != address(0));
386         require(_from != address(0));
387         require(_value <= balances.balanceOf(_from));
388 
389         // SafeMath.sub will throw if there is not enough balance.
390         balances.subBalance(_from, _value);
391         balances.addBalance(_to, _value);
392         emit Transfer(_from, _to, _value);
393     }
394 
395     /**
396     * @dev Gets the balance of the specified address.
397     * @param _owner The address to query the the balance of.
398     * @return An uint256 representing the amount owned by the passed address.
399     */
400     function balanceOf(address _owner) public view returns (uint256 balance) {
401         return balances.balanceOf(_owner);
402     }
403 }
404 
405 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
406 
407 /**
408  * @title Burnable Token
409  * @dev Token that can be irreversibly burned (destroyed).
410  */
411 contract BurnableToken is BasicToken{
412     event Burn(address indexed burner, uint256 value);
413 
414     /**
415      * @dev Burns a specific amount of tokens.
416      * @param _value The amount of token to be burned.
417      */
418     function burn(uint256 _value) public {
419         require(_value <= balances.balanceOf(msg.sender));
420         // no need to require value <= totalSupply, since that would imply the
421         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
422 
423         address burner = msg.sender;
424         balances.subBalance(burner, _value);
425         totalSupply_ = totalSupply_.sub(_value);
426         emit Burn(burner, _value);
427         emit Transfer(burner, address(0), _value);
428     }
429 }
430 
431 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
432 
433 /**
434  * @title Pausable
435  * @dev Base contract which allows children to implement an emergency stop mechanism.
436  */
437 contract Pausable is Ownable {
438     event Pause();
439     event Unpause();
440 
441     bool public paused = false;
442 
443     /**
444      * @dev Modifier to make a function callable only when the contract is not paused.
445      */
446     modifier whenNotPaused() {
447         require(!paused);
448         _;
449     }
450 
451     /**
452      * @dev Modifier to make a function callable only when the contract is paused.
453      */
454     modifier whenPaused() {
455         require(paused);
456         _;
457     }
458 
459     /**
460      * @dev called by the owner to pause, triggers stopped state
461      */
462     function pause() onlyOwner whenNotPaused public {
463         paused = true;
464         emit Pause();
465     }
466 
467     /**
468      * @dev called by the owner to unpause, returns to normal state
469      */
470     function unpause() onlyOwner whenPaused public {
471         paused = false;
472         emit Unpause();
473     }
474 }
475 
476 // File: contracts/AllowanceSheet.sol
477 
478 // A wrapper around the allowanceOf mapping.
479 contract AllowanceSheet is Claimable {
480     using SafeMath for uint256;
481 
482     mapping(address => mapping(address => uint256)) public allowanceOf;
483 
484     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
485         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
486     }
487 
488     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
489         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
490     }
491 
492     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
493         allowanceOf[_tokenHolder][_spender] = _value;
494     }
495 }
496 
497 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
498 
499 contract StandardToken is ERC20, BasicToken {
500     AllowanceSheet public allowances;
501 
502     function setAllowanceSheet(address sheet) external onlyOwner {
503         allowances = AllowanceSheet(sheet);
504         allowances.claimOwnership();
505     }
506 
507     /**
508      * @dev Transfer tokens from one address to another
509      * @param _from address The address which you want to send tokens from
510      * @param _to address The address which you want to transfer to
511      * @param _value uint256 the amount of tokens to be transferred
512      */
513     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
514         transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
515         return true;
516     }
517 
518     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
519         require(_value <= allowances.allowanceOf(_from, spender));
520 
521         allowances.subAllowance(_from, spender, _value);
522         transferAllArgsNoAllowance(_from, _to, _value);
523     }
524 
525     /**
526      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
527      *
528      * Beware that changing an allowance with this method brings the risk that someone may use both the old
529      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
530      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
531      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
532      * @param _spender The address which will spend the funds.
533      * @param _value The amount of tokens to be spent.
534      */
535     function approve(address _spender, uint256 _value) public returns (bool) {
536         approveAllArgs(_spender, _value, msg.sender);
537         return true;
538     }
539 
540     function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
541         allowances.setAllowance(_tokenHolder, _spender, _value);
542         emit Approval(_tokenHolder, _spender, _value);
543     }
544 
545     /**
546      * @dev Function to check the amount of tokens that an owner allowed to a spender.
547      * @param _owner address The address which owns the funds.
548      * @param _spender address The address which will spend the funds.
549      * @return A uint256 specifying the amount of tokens still available for the spender.
550      */
551     function allowance(address _owner, address _spender) public view returns (uint256) {
552         return allowances.allowanceOf(_owner, _spender);
553     }
554 
555     /**
556      * @dev Increase the amount of tokens that an owner allowed to a spender.
557      *
558      * approve should be called when allowed[_spender] == 0. To increment
559      * allowed value is better to use this function to avoid 2 calls (and wait until
560      * the first transaction is mined)
561      * From MonolithDAO Token.sol
562      * @param _spender The address which will spend the funds.
563      * @param _addedValue The amount of tokens to increase the allowance by.
564      */
565     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
566         increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
567         return true;
568     }
569 
570     function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
571         allowances.addAllowance(tokenHolder, _spender, _addedValue);
572         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
573     }
574 
575     /**
576      * @dev Decrease the amount of tokens that an owner allowed to a spender.
577      *
578      * approve should be called when allowed[_spender] == 0. To decrement
579      * allowed value is better to use this function to avoid 2 calls (and wait until
580      * the first transaction is mined)
581      * From MonolithDAO Token.sol
582      * @param _spender The address which will spend the funds.
583      * @param _subtractedValue The amount of tokens to decrease the allowance by.
584      */
585     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
586         decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
587         return true;
588     }
589 
590     function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
591         uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
592         if (_subtractedValue > oldValue) {
593             allowances.setAllowance(tokenHolder, _spender, 0);
594         } else {
595             allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
596         }
597         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
598     }
599 }
600 
601 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
602 
603 /**
604  * @title Pausable token
605  * @dev StandardToken modified with pausable transfers.
606  **/
607 contract PausableToken is StandardToken, Pausable{
608     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
609         return super.transfer(_to, _value);
610     }
611 
612     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
613         return super.transferFrom(_from, _to, _value);
614     }
615 
616     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
617         return super.approve(_spender, _value);
618     }
619 
620     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
621         return super.increaseApproval(_spender, _addedValue);
622     }
623 
624     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
625         return super.decreaseApproval(_spender, _subtractedValue);
626     }
627 }
628 
629 // File: contracts/DelegateERC20.sol
630 
631 contract DelegateERC20 {
632     function delegateTotalSupply() public view returns (uint256);
633 
634     function delegateBalanceOf(address who) public view returns (uint256);
635 
636     function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
637 
638     function delegateAllowance(address owner, address spender) public view returns (uint256);
639 
640     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
641 
642     function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
643 
644     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
645 
646     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
647 }
648 
649 // File: contracts/CanDelegate.sol
650 
651 contract CanDelegate is StandardToken {
652     // If this contract needs to be upgraded, the new contract will be stored
653     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
654     DelegateERC20 public delegate;
655 
656     event DelegateToNewContract(address indexed newContract);
657 
658     // Can undelegate by passing in newContract = address(0)
659     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
660         delegate = newContract;
661         emit DelegateToNewContract(newContract);
662     }
663 
664     // If a delegate has been designated, all ERC20 calls are forwarded to it
665     function transfer(address to, uint256 value) public returns (bool) {
666         if (delegate == address(0)) {
667             return super.transfer(to, value);
668         } else {
669             return delegate.delegateTransfer(to, value, msg.sender);
670         }
671     }
672 
673     function transferFrom(address from, address to, uint256 value) public returns (bool) {
674         if (delegate == address(0)) {
675             return super.transferFrom(from, to, value);
676         } else {
677             return delegate.delegateTransferFrom(from, to, value, msg.sender);
678         }
679     }
680 
681     function balanceOf(address who) public view returns (uint256) {
682         if (delegate == address(0)) {
683             return super.balanceOf(who);
684         } else {
685             return delegate.delegateBalanceOf(who);
686         }
687     }
688 
689     function approve(address spender, uint256 value) public returns (bool) {
690         if (delegate == address(0)) {
691             return super.approve(spender, value);
692         } else {
693             return delegate.delegateApprove(spender, value, msg.sender);
694         }
695     }
696 
697     function allowance(address _owner, address spender) public view returns (uint256) {
698         if (delegate == address(0)) {
699             return super.allowance(_owner, spender);
700         } else {
701             return delegate.delegateAllowance(_owner, spender);
702         }
703     }
704 
705     function totalSupply() public view returns (uint256) {
706         if (delegate == address(0)) {
707             return super.totalSupply();
708         } else {
709             return delegate.delegateTotalSupply();
710         }
711     }
712 
713     function increaseApproval(address spender, uint addedValue) public returns (bool) {
714         if (delegate == address(0)) {
715             return super.increaseApproval(spender, addedValue);
716         } else {
717             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
718         }
719     }
720 
721     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
722         if (delegate == address(0)) {
723             return super.decreaseApproval(spender, subtractedValue);
724         } else {
725             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
726         }
727     }
728 }
729 
730 // File: contracts/StandardDelegate.sol
731 
732 contract StandardDelegate is StandardToken, DelegateERC20 {
733     address public delegatedFrom;
734 
735     modifier onlySender(address source) {
736         require(msg.sender == source);
737         _;
738     }
739 
740     function setDelegatedFrom(address addr) onlyOwner public {
741         delegatedFrom = addr;
742     }
743 
744     // All delegate ERC20 functions are forwarded to corresponding normal functions
745     function delegateTotalSupply() public view returns (uint256) {
746         return totalSupply();
747     }
748 
749     function delegateBalanceOf(address who) public view returns (uint256) {
750         return balanceOf(who);
751     }
752 
753     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
754         transferAllArgsNoAllowance(origSender, to, value);
755         return true;
756     }
757 
758     function delegateAllowance(address owner, address spender) public view returns (uint256) {
759         return allowance(owner, spender);
760     }
761 
762     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
763         transferAllArgsYesAllowance(from, to, value, origSender);
764         return true;
765     }
766 
767     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
768         approveAllArgs(spender, value, origSender);
769         return true;
770     }
771 
772     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
773         increaseApprovalAllArgs(spender, addedValue, origSender);
774         return true;
775     }
776 
777     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
778         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
779         return true;
780     }
781 }
782 
783 // File: contracts/TrueVND.sol
784 
785 contract TrueVND is NoOwner, BurnableToken, CanDelegate, StandardDelegate, PausableToken {
786     string public name = "TrueVND";
787     string public symbol = "TVND";
788     uint8 public constant decimals = 18;
789 
790     AddressList public canReceiveMintWhiteList;
791     AddressList public canBurnWhiteList;
792     AddressList public blackList;
793     AddressList public noFeesList;
794     address public staker;
795 
796     uint256 public burnMin = 1000 * 10 ** uint256(decimals);
797     uint256 public burnMax = 20000000 * 10 ** uint256(decimals);
798 
799     uint80 public transferFeeNumerator = 8;
800     uint80 public transferFeeDenominator = 10000;
801     uint80 public mintFeeNumerator = 0;
802     uint80 public mintFeeDenominator = 10000;
803     uint256 public mintFeeFlat = 0;
804     uint80 public burnFeeNumerator = 0;
805     uint80 public burnFeeDenominator = 10000;
806     uint256 public burnFeeFlat = 0;
807 
808     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
809     event Mint(address indexed to, uint256 amount);
810     event WipedAccount(address indexed account, uint256 balance);
811 
812     constructor() public {
813         totalSupply_ = 0;
814         staker = msg.sender;
815     }
816 
817     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
818         canReceiveMintWhiteList = _canReceiveMintWhiteList;
819         canBurnWhiteList = _canBurnWhiteList;
820         blackList = _blackList;
821         noFeesList = _noFeesList;
822     }
823 
824     function changeName(string _name, string _symbol) onlyOwner public {
825         name = _name;
826         symbol = _symbol;
827     }
828 
829     // Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
830     // and will send them back the equivalent amount of money (rounded down to the nearest cent).
831     function burn(uint256 _value) public {
832         require(canBurnWhiteList.onList(msg.sender));
833         require(_value >= burnMin);
834         require(_value <= burnMax);
835         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
836         uint256 remaining = _value.sub(fee);
837         super.burn(remaining);
838     }
839 
840     // Create _amount new tokens and transfer them to _to.
841     // Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
842     function mint(address _to, uint256 _amount) onlyOwner public {
843         require(canReceiveMintWhiteList.onList(_to));
844         totalSupply_ = totalSupply_.add(_amount);
845         balances.addBalance(_to, _amount);
846         emit Mint(_to, _amount);
847         emit Transfer(address(0), _to, _amount);
848         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
849     }
850 
851     // Change the minimum and maximum amount that can be burned at once. Burning
852     // may be disabled by setting both to 0 (this will not be done under normal
853     // operation, but we can't add checks to disallow it without losing a lot of
854     // flexibility since burning could also be as good as disabled
855     // by setting the minimum extremely high, and we don't want to lock
856     // in any particular cap for the minimum)
857     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
858         require(newMin <= newMax);
859         burnMin = newMin;
860         burnMax = newMax;
861         emit ChangeBurnBoundsEvent(newMin, newMax);
862     }
863 
864     // A blacklisted address can't call transferFrom
865     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
866         require(!blackList.onList(spender));
867         super.transferAllArgsYesAllowance(_from, _to, _value, spender);
868     }
869 
870     // transfer and transferFrom both ultimately call this function, so we
871     // check blacklist and pay staking fee here.
872     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
873         require(!blackList.onList(_from));
874         require(!blackList.onList(_to));
875         super.transferAllArgsNoAllowance(_from, _to, _value);
876         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, burnFeeFlat, _from);
877     }
878 
879     function wipeBlacklistedAccount(address account) public onlyOwner {
880         require(blackList.onList(account));
881         uint256 oldValue = balanceOf(account);
882         balances.setBalance(account, 0);
883         totalSupply_ = totalSupply_.sub(oldValue);
884         emit WipedAccount(account, oldValue);
885     }
886 
887     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
888         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
889             return 0;
890         }
891         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
892         if (stakingFee > 0) {
893             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
894         }
895         return stakingFee;
896     }
897 
898     function changeStakingFees(uint80 _transferFeeNumerator,
899         uint80 _transferFeeDenominator,
900         uint80 _mintFeeNumerator,
901         uint80 _mintFeeDenominator,
902         uint256 _mintFeeFlat,
903         uint80 _burnFeeNumerator,
904         uint80 _burnFeeDenominator,
905         uint256 _burnFeeFlat) public onlyOwner {
906         require(_transferFeeDenominator != 0);
907         require(_mintFeeDenominator != 0);
908         require(_burnFeeDenominator != 0);
909         transferFeeNumerator = _transferFeeNumerator;
910         transferFeeDenominator = _transferFeeDenominator;
911         mintFeeNumerator = _mintFeeNumerator;
912         mintFeeDenominator = _mintFeeDenominator;
913         mintFeeFlat = _mintFeeFlat;
914         burnFeeNumerator = _burnFeeNumerator;
915         burnFeeDenominator = _burnFeeDenominator;
916         burnFeeFlat = _burnFeeFlat;
917     }
918 
919     function changeStaker(address newStaker) public onlyOwner {
920         require(newStaker != address(0));
921         staker = newStaker;
922     }
923 }
924 
925 // File: contracts/TimeLockedController.sol
926 
927 // The TimeLockedController contract is intended to be the initial Owner of the TrueVND
928 // contract and TrueVND's AddressLists. It splits ownership into two accounts: an "admin" account and an
929 // "owner" account. The admin of TimeLockedController can initiate minting TrueVND.
930 // However, these transactions must be stored for ~1 day's worth of blocks first before they can be forwarded to the
931 // TrueVND contract. In the event that the admin account is compromised, this setup allows the owner of TimeLockedController
932 // (which can be stored extremely securely since it is never used in normal operation) to replace the admin.
933 // Once a day has passed, requests can be finalized by the admin.
934 // Requests initiated by an admin that has since been deposed cannot be finalized.
935 // The admin is also able to update TrueVND's AddressLists (without a day's delay).
936 // The owner can mint without the day's delay, and also change other aspects of TrueVND like the staking fees.
937 contract TimeLockedController is HasNoEther, HasNoTokens, Claimable {
938     using SafeMath for uint256;
939 
940     uint public constant blocksDelay = 24 * 60 * 60 / 15; // 5760 blocks
941 
942     struct MintOperation {
943         address to;
944         uint256 amount;
945         address admin;
946         uint deferBlock;
947     }
948 
949     address public admin;
950     TrueVND public trueVND;
951     MintOperation[] public mintOperations;
952 
953     modifier onlyAdminOrOwner() {
954         require(msg.sender == admin || msg.sender == owner);
955         _;
956     }
957 
958     event MintOperationEvent(address indexed _to, uint256 amount, uint deferBlock, uint opIndex);
959     event TransferChildEvent(address indexed _child, address indexed _newOwner);
960     event ReclaimEvent(address indexed other);
961     event ChangeBurnBoundsEvent(uint newMin, uint newMax);
962     event WipedAccount(address indexed account);
963     event ChangeStakingFeesEvent(uint80 _transferFeeNumerator,
964         uint80 _transferFeeDenominator,
965         uint80 _mintFeeNumerator,
966         uint80 _mintFeeDenominator,
967         uint256 _mintFeeFlat,
968         uint80 _burnFeeNumerator,
969         uint80 _burnFeeDenominator,
970         uint256 _burnFeeFlat);
971     event ChangeStakerEvent(address newStaker);
972     event DelegateEvent(DelegateERC20 delegate);
973     event SetDelegatedFromEvent(address source);
974     event ChangeTrueVNDEvent(TrueVND newContract);
975     event ChangeNameEvent(string name, string symbol);
976     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
977 
978     // admin initiates a request to mint _amount TrueVND for account _to
979     function requestMint(address _to, uint256 _amount) public onlyAdminOrOwner {
980         uint deferBlock = block.number;
981         if (msg.sender != owner) {
982             deferBlock = deferBlock.add(blocksDelay);
983         }
984         MintOperation memory op = MintOperation(_to, _amount, admin, deferBlock);
985         emit MintOperationEvent(_to, _amount, deferBlock, mintOperations.length);
986         mintOperations.push(op);
987     }
988 
989     // after a day, admin finalizes mint request by providing the
990     // index of the request (visible in the MintOperationEvent accompanying the original request)
991     function finalizeMint(uint index) public onlyAdminOrOwner {
992         MintOperation memory op = mintOperations[index];
993         require(op.admin == admin);
994         //checks that the requester's adminship has not been revoked
995         require(op.deferBlock <= block.number);
996         //checks that enough time has elapsed
997         address to = op.to;
998         uint256 amount = op.amount;
999         delete mintOperations[index];
1000         trueVND.mint(to, amount);
1001     }
1002 
1003     // Transfer ownership of _child to _newOwner
1004     // Can be used e.g. to upgrade this TimeLockedController contract.
1005     function transferChild(Ownable _child, address _newOwner) public onlyOwner {
1006         emit TransferChildEvent(_child, _newOwner);
1007         _child.transferOwnership(_newOwner);
1008     }
1009 
1010     // Transfer ownership of a contract from trueVND
1011     // to this TimeLockedController. Can be used e.g. to reclaim balance sheet
1012     // in order to transfer it to an upgraded TrueVND contract.
1013     function requestReclaim(Ownable other) public onlyOwner {
1014         emit ReclaimEvent(other);
1015         trueVND.reclaimContract(other);
1016     }
1017 
1018     // Change the minimum and maximum amounts that TrueVND users can
1019     // burn to newMin and newMax
1020     function changeBurnBounds(uint newMin, uint newMax) public onlyOwner {
1021         emit ChangeBurnBoundsEvent(newMin, newMax);
1022         trueVND.changeBurnBounds(newMin, newMax);
1023     }
1024 
1025     function wipeBlacklistedAccount(address account) public onlyOwner {
1026         emit WipedAccount(account);
1027         trueVND.wipeBlacklistedAccount(account);
1028     }
1029 
1030     // Change the transaction fees charged on transfer/mint/burn
1031     function changeStakingFees(uint80 _transferFeeNumerator,
1032         uint80 _transferFeeDenominator,
1033         uint80 _mintFeeNumerator,
1034         uint80 _mintFeeDenominator,
1035         uint256 _mintFeeFlat,
1036         uint80 _burnFeeNumerator,
1037         uint80 _burnFeeDenominator,
1038         uint256 _burnFeeFlat) public onlyOwner {
1039         emit ChangeStakingFeesEvent(_transferFeeNumerator,
1040             _transferFeeDenominator,
1041             _mintFeeNumerator,
1042             _mintFeeDenominator,
1043             _mintFeeFlat,
1044             _burnFeeNumerator,
1045             _burnFeeDenominator,
1046             _burnFeeFlat);
1047         trueVND.changeStakingFees(_transferFeeNumerator,
1048             _transferFeeDenominator,
1049             _mintFeeNumerator,
1050             _mintFeeDenominator,
1051             _mintFeeFlat,
1052             _burnFeeNumerator,
1053             _burnFeeDenominator,
1054             _burnFeeFlat);
1055     }
1056 
1057     // Change the recipient of staking fees to newStaker
1058     function changeStaker(address newStaker) public onlyOwner {
1059         emit ChangeStakerEvent(newStaker);
1060         trueVND.changeStaker(newStaker);
1061     }
1062 
1063     // Future ERC20 calls to trueVND be delegated to _delegate
1064     function delegateToNewContract(DelegateERC20 delegate) public onlyOwner {
1065         emit DelegateEvent(delegate);
1066         trueVND.delegateToNewContract(delegate);
1067     }
1068 
1069     // Incoming delegate* calls from _source will be accepted by trueVND
1070     function setDelegatedFrom(address _source) public onlyOwner {
1071         emit SetDelegatedFromEvent(_source);
1072         trueVND.setDelegatedFrom(_source);
1073     }
1074 
1075     // Update this contract's trueVND pointer to newContract (e.g. if the
1076     // contract is upgraded)
1077     function setTrueVND(TrueVND newContract) public onlyOwner {
1078         emit ChangeTrueVNDEvent(newContract);
1079         trueVND = newContract;
1080     }
1081 
1082     // change trueVND's name and symbol
1083     function changeName(string name, string symbol) public onlyOwner {
1084         emit ChangeNameEvent(name, symbol);
1085         trueVND.changeName(name, symbol);
1086     }
1087 
1088     // Replace the current admin with newAdmin
1089     function transferAdminship(address newAdmin) public onlyOwner {
1090         emit AdminshipTransferred(admin, newAdmin);
1091         admin = newAdmin;
1092     }
1093 
1094     // Swap out TrueVND's address lists
1095     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
1096         trueVND.setLists(_canReceiveMintWhiteList, _canBurnWhiteList, _blackList, _noFeesList);
1097     }
1098 
1099     // Update a whitelist/blacklist
1100     function updateList(address list, address entry, bool flag) public onlyAdminOrOwner {
1101         AddressList(list).changeList(entry, flag);
1102     }
1103 
1104     // Rename a whitelist/blacklist
1105     function renameList(address list, string name) public onlyAdminOrOwner {
1106         NamableAddressList(list).changeName(name);
1107     }
1108 
1109     // Claim ownership of an arbitrary Claimable contract
1110     function issueClaimOwnership(address _other) public onlyAdminOrOwner {
1111         Claimable other = Claimable(_other);
1112         other.claimOwnership();
1113     }
1114 }