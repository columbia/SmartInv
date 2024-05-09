1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 }
41 
42 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
43 
44 /**
45  * @title Contracts that should not own Contracts
46  * @author Remco Bloemen <remco@2π.com>
47  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
48  * of this contract to reclaim ownership of the contracts.
49  */
50 contract HasNoContracts is Ownable{
51     /**
52      * @dev Reclaim ownership of Ownable contracts
53      * @param contractAddr The address of the Ownable to be reclaimed.
54      */
55     function reclaimContract(address contractAddr) external onlyOwner {
56         Ownable contractInst = Ownable(contractAddr);
57         contractInst.transferOwnership(owner);
58     }
59 }
60 
61 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
62 
63 /**
64  * @title Contracts that should not own Ether
65  * @author Remco Bloemen <remco@2π.com>
66  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
67  * in the contract, it will allow the owner to reclaim this Ether.
68  * @notice Ether can still be sent to this contract by:
69  * calling functions labeled `payable`
70  * `selfdestruct(contract_address)`
71  * mining directly to the contract address
72  */
73 contract HasNoEther is Ownable {
74     /**
75     * @dev Constructor that rejects incoming Ether
76     * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
77     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
78     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
79     * we could use assembly to access msg.value.
80     */
81     constructor() public payable {
82         require(msg.value == 0);
83     }
84 
85     /**
86      * @dev Disallows direct send by setting a default function without the `payable` flag.
87      */
88     function() external {
89     }
90 
91     /**
92      * @dev Transfer all Ether held by the contract to the owner.
93      */
94     function reclaimEther() external onlyOwner {
95         owner.transfer(address(this).balance);
96     }
97 }
98 
99 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107     function totalSupply() public view returns (uint256);
108 
109     function balanceOf(address who) public view returns (uint256);
110 
111     function transfer(address to, uint256 value) public returns (bool);
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123     function allowance(address owner, address spender) public view returns (uint256);
124 
125     function transferFrom(address from, address to, uint256 value) public returns (bool);
126 
127     function approve(address spender, uint256 value) public returns (bool);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
133 
134 /**
135  * @title SafeERC20
136  * @dev Wrappers around ERC20 operations that throw on failure.
137  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
138  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
139  */
140 library SafeERC20 {
141     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
142         assert(token.transfer(to, value));
143     }
144 
145     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
146         assert(token.transferFrom(from, to, value));
147     }
148 
149     function safeApprove(ERC20 token, address spender, uint256 value) internal {
150         assert(token.approve(spender, value));
151     }
152 }
153 
154 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
155 
156 /**
157  * @title Contracts that should be able to recover tokens
158  * @author SylTi
159  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
160  * This will prevent any accidental loss of tokens.
161  */
162 contract CanReclaimToken is Ownable {
163     using SafeERC20 for ERC20Basic;
164 
165     /**
166      * @dev Reclaim all ERC20Basic compatible tokens
167      * @param token ERC20Basic The address of the token contract
168      */
169     function reclaimToken(ERC20Basic token) external onlyOwner {
170         uint256 balance = token.balanceOf(this);
171         token.safeTransfer(owner, balance);
172     }
173 }
174 
175 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
176 
177 /**
178  * @title Contracts that should not own Tokens
179  * @author Remco Bloemen <remco@2π.com>
180  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
181  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
182  * owner to reclaim the tokens.
183  */
184 contract HasNoTokens is CanReclaimToken {
185     /**
186      * @dev Reject all ERC223 compatible tokens
187      * @param _from address The address that is transferring the tokens
188      * @param _value uint256 the amount of the specified token
189      * @param _data Bytes The data passed from the caller.
190      */
191     function tokenFallback(address _from, uint256 _value, bytes _data) external pure {
192         _from;
193         _value;
194         _data;
195         revert();
196     }
197 }
198 
199 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
200 
201 /**
202  * @title Base contract for contracts that should not own things.
203  * @author Remco Bloemen <remco@2π.com>
204  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
205  * Owned contracts. See respective base contracts for details.
206  */
207 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
208 }
209 
210 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217     /**
218      * @dev Multiplies two numbers, throws on overflow.
219      */
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         if (a == 0) {
222             return 0;
223         }
224         uint256 c = a * b;
225         assert(c / a == b);
226         return c;
227     }
228 
229     /**
230      * @dev Integer division of two numbers, truncating the quotient.
231      */
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         // assert(b > 0); // Solidity automatically throws when dividing by 0
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236         return c;
237     }
238 
239     /**
240      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         assert(b <= a);
244         return a - b;
245     }
246 
247     /**
248      * @dev Adds two numbers, throws on overflow.
249      */
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         assert(c >= a);
253         return c;
254     }
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
258 
259 /**
260  * @title Claimable
261  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
262  * This allows the new owner to accept the transfer.
263  */
264 contract Claimable is Ownable {
265     address public pendingOwner;
266 
267     /**
268      * @dev Modifier throws if called by any account other than the pendingOwner.
269      */
270     modifier onlyPendingOwner() {
271         require(msg.sender == pendingOwner);
272         _;
273     }
274 
275     /**
276      * @dev Allows the current owner to set the pendingOwner address.
277      * @param newOwner The address to transfer ownership to.
278      */
279     function transferOwnership(address newOwner) onlyOwner public {
280         pendingOwner = newOwner;
281     }
282 
283     /**
284      * @dev Allows the pendingOwner address to finalize the transfer.
285      */
286     function claimOwnership() onlyPendingOwner public {
287         emit OwnershipTransferred(owner, pendingOwner);
288         owner = pendingOwner;
289         pendingOwner = address(0);
290     }
291 }
292 
293 // File: contracts/BalanceSheet.sol
294 
295 // A wrapper around the balanceOf mapping.
296 contract BalanceSheet is Claimable {
297     using SafeMath for uint256;
298 
299     mapping(address => uint256) public balanceOf;
300 
301     function addBalance(address _addr, uint256 _value) public onlyOwner {
302         balanceOf[_addr] = balanceOf[_addr].add(_value);
303     }
304 
305     function subBalance(address _addr, uint256 _value) public onlyOwner {
306         balanceOf[_addr] = balanceOf[_addr].sub(_value);
307     }
308 
309     function setBalance(address _addr, uint256 _value) public onlyOwner {
310         balanceOf[_addr] = _value;
311     }
312 }
313 
314 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
315 
316 /**
317  * @title Basic token
318  * @dev Basic version of StandardToken, with no allowances.
319  */
320 contract BasicToken is ERC20Basic, Claimable {
321     using SafeMath for uint256;
322 
323     BalanceSheet public balances;
324 
325     uint256 totalSupply_;
326 
327     function setBalanceSheet(address sheet) external onlyOwner {
328         balances = BalanceSheet(sheet);
329         balances.claimOwnership();
330     }
331 
332     /**
333     * @dev total number of tokens in existence
334     */
335     function totalSupply() public view returns (uint256) {
336         return totalSupply_;
337     }
338 
339     /**
340     * @dev transfer token for a specified address
341     * @param _to The address to transfer to.
342     * @param _value The amount to be transferred.
343     */
344     function transfer(address _to, uint256 _value) public returns (bool) {
345         transferAllArgsNoAllowance(msg.sender, _to, _value);
346         return true;
347     }
348 
349     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
350         require(_to != address(0));
351         require(_from != address(0));
352         require(_value <= balances.balanceOf(_from));
353 
354         // SafeMath.sub will throw if there is not enough balance.
355         balances.subBalance(_from, _value);
356         balances.addBalance(_to, _value);
357         emit Transfer(_from, _to, _value);
358     }
359 
360     /**
361     * @dev Gets the balance of the specified address.
362     * @param _owner The address to query the the balance of.
363     * @return An uint256 representing the amount owned by the passed address.
364     */
365     function balanceOf(address _owner) public view returns (uint256 balance) {
366         return balances.balanceOf(_owner);
367     }
368 }
369 
370 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
371 
372 /**
373  * @title Burnable Token
374  * @dev Token that can be irreversibly burned (destroyed).
375  */
376 contract BurnableToken is BasicToken{
377     event Burn(address indexed burner, uint256 value);
378 
379     /**
380      * @dev Burns a specific amount of tokens.
381      * @param _value The amount of token to be burned.
382      */
383     function burn(uint256 _value) public {
384         require(_value <= balances.balanceOf(msg.sender));
385         // no need to require value <= totalSupply, since that would imply the
386         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
387 
388         address burner = msg.sender;
389         balances.subBalance(burner, _value);
390         totalSupply_ = totalSupply_.sub(_value);
391         emit Burn(burner, _value);
392         emit Transfer(burner, address(0), _value);
393     }
394 }
395 
396 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
397 
398 /**
399  * @title Pausable
400  * @dev Base contract which allows children to implement an emergency stop mechanism.
401  */
402 contract Pausable is Ownable {
403     event Pause();
404     event Unpause();
405 
406     bool public paused = false;
407 
408     /**
409      * @dev Modifier to make a function callable only when the contract is not paused.
410      */
411     modifier whenNotPaused() {
412         require(!paused);
413         _;
414     }
415 
416     /**
417      * @dev Modifier to make a function callable only when the contract is paused.
418      */
419     modifier whenPaused() {
420         require(paused);
421         _;
422     }
423 
424     /**
425      * @dev called by the owner to pause, triggers stopped state
426      */
427     function pause() onlyOwner whenNotPaused public {
428         paused = true;
429         emit Pause();
430     }
431 
432     /**
433      * @dev called by the owner to unpause, returns to normal state
434      */
435     function unpause() onlyOwner whenPaused public {
436         paused = false;
437         emit Unpause();
438     }
439 }
440 
441 // File: contracts/AllowanceSheet.sol
442 
443 // A wrapper around the allowanceOf mapping.
444 contract AllowanceSheet is Claimable {
445     using SafeMath for uint256;
446 
447     mapping(address => mapping(address => uint256)) public allowanceOf;
448 
449     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
450         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
451     }
452 
453     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
454         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
455     }
456 
457     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
458         allowanceOf[_tokenHolder][_spender] = _value;
459     }
460 }
461 
462 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
463 
464 contract StandardToken is ERC20, BasicToken {
465     AllowanceSheet public allowances;
466 
467     function setAllowanceSheet(address sheet) external onlyOwner {
468         allowances = AllowanceSheet(sheet);
469         allowances.claimOwnership();
470     }
471 
472     /**
473      * @dev Transfer tokens from one address to another
474      * @param _from address The address which you want to send tokens from
475      * @param _to address The address which you want to transfer to
476      * @param _value uint256 the amount of tokens to be transferred
477      */
478     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
479         transferAllArgsYesAllowance(_from, _to, _value, msg.sender);
480         return true;
481     }
482 
483     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
484         require(_value <= allowances.allowanceOf(_from, spender));
485 
486         allowances.subAllowance(_from, spender, _value);
487         transferAllArgsNoAllowance(_from, _to, _value);
488     }
489 
490     /**
491      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
492      *
493      * Beware that changing an allowance with this method brings the risk that someone may use both the old
494      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
495      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
496      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
497      * @param _spender The address which will spend the funds.
498      * @param _value The amount of tokens to be spent.
499      */
500     function approve(address _spender, uint256 _value) public returns (bool) {
501         approveAllArgs(_spender, _value, msg.sender);
502         return true;
503     }
504 
505     function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal {
506         allowances.setAllowance(_tokenHolder, _spender, _value);
507         emit Approval(_tokenHolder, _spender, _value);
508     }
509 
510     /**
511      * @dev Function to check the amount of tokens that an owner allowed to a spender.
512      * @param _owner address The address which owns the funds.
513      * @param _spender address The address which will spend the funds.
514      * @return A uint256 specifying the amount of tokens still available for the spender.
515      */
516     function allowance(address _owner, address _spender) public view returns (uint256) {
517         return allowances.allowanceOf(_owner, _spender);
518     }
519 
520     /**
521      * @dev Increase the amount of tokens that an owner allowed to a spender.
522      *
523      * approve should be called when allowed[_spender] == 0. To increment
524      * allowed value is better to use this function to avoid 2 calls (and wait until
525      * the first transaction is mined)
526      * From MonolithDAO Token.sol
527      * @param _spender The address which will spend the funds.
528      * @param _addedValue The amount of tokens to increase the allowance by.
529      */
530     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
531         increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
532         return true;
533     }
534 
535     function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal {
536         allowances.addAllowance(tokenHolder, _spender, _addedValue);
537         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
538     }
539 
540     /**
541      * @dev Decrease the amount of tokens that an owner allowed to a spender.
542      *
543      * approve should be called when allowed[_spender] == 0. To decrement
544      * allowed value is better to use this function to avoid 2 calls (and wait until
545      * the first transaction is mined)
546      * From MonolithDAO Token.sol
547      * @param _spender The address which will spend the funds.
548      * @param _subtractedValue The amount of tokens to decrease the allowance by.
549      */
550     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
551         decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
552         return true;
553     }
554 
555     function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal {
556         uint oldValue = allowances.allowanceOf(tokenHolder, _spender);
557         if (_subtractedValue > oldValue) {
558             allowances.setAllowance(tokenHolder, _spender, 0);
559         } else {
560             allowances.subAllowance(tokenHolder, _spender, _subtractedValue);
561         }
562         emit Approval(tokenHolder, _spender, allowances.allowanceOf(tokenHolder, _spender));
563     }
564 }
565 
566 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
567 
568 /**
569  * @title Pausable token
570  * @dev StandardToken modified with pausable transfers.
571  **/
572 contract PausableToken is StandardToken, Pausable{
573     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
574         return super.transfer(_to, _value);
575     }
576 
577     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
578         return super.transferFrom(_from, _to, _value);
579     }
580 
581     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
582         return super.approve(_spender, _value);
583     }
584 
585     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
586         return super.increaseApproval(_spender, _addedValue);
587     }
588 
589     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
590         return super.decreaseApproval(_spender, _subtractedValue);
591     }
592 }
593 
594 // File: contracts/AddressList.sol
595 
596 contract AddressList is Claimable {
597     string public name;
598     mapping(address => bool) public onList;
599 
600     constructor(string _name, bool nullValue) public {
601         name = _name;
602         onList[0x0] = nullValue;
603     }
604 
605     event ChangeWhiteList(address indexed to, bool onList);
606 
607     // Set whether _to is on the list or not. Whether 0x0 is on the list
608     // or not cannot be set here - it is set once and for all by the constructor.
609     function changeList(address _to, bool _onList) onlyOwner public {
610         require(_to != 0x0);
611         if (onList[_to] != _onList) {
612             onList[_to] = _onList;
613             emit ChangeWhiteList(_to, _onList);
614         }
615     }
616 }
617 
618 // File: contracts/DelegateERC20.sol
619 
620 contract DelegateERC20 {
621     function delegateTotalSupply() public view returns (uint256);
622 
623     function delegateBalanceOf(address who) public view returns (uint256);
624 
625     function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
626 
627     function delegateAllowance(address owner, address spender) public view returns (uint256);
628 
629     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
630 
631     function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
632 
633     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
634 
635     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
636 }
637 
638 // File: contracts/CanDelegate.sol
639 
640 contract CanDelegate is StandardToken {
641     // If this contract needs to be upgraded, the new contract will be stored
642     // in 'delegate' and any ERC20 calls to this contract will be delegated to that one.
643     DelegateERC20 public delegate;
644 
645     event DelegateToNewContract(address indexed newContract);
646 
647     // Can undelegate by passing in newContract = address(0)
648     function delegateToNewContract(DelegateERC20 newContract) public onlyOwner {
649         delegate = newContract;
650         emit DelegateToNewContract(newContract);
651     }
652 
653     // If a delegate has been designated, all ERC20 calls are forwarded to it
654     function transfer(address to, uint256 value) public returns (bool) {
655         if (delegate == address(0)) {
656             return super.transfer(to, value);
657         } else {
658             return delegate.delegateTransfer(to, value, msg.sender);
659         }
660     }
661 
662     function transferFrom(address from, address to, uint256 value) public returns (bool) {
663         if (delegate == address(0)) {
664             return super.transferFrom(from, to, value);
665         } else {
666             return delegate.delegateTransferFrom(from, to, value, msg.sender);
667         }
668     }
669 
670     function balanceOf(address who) public view returns (uint256) {
671         if (delegate == address(0)) {
672             return super.balanceOf(who);
673         } else {
674             return delegate.delegateBalanceOf(who);
675         }
676     }
677 
678     function approve(address spender, uint256 value) public returns (bool) {
679         if (delegate == address(0)) {
680             return super.approve(spender, value);
681         } else {
682             return delegate.delegateApprove(spender, value, msg.sender);
683         }
684     }
685 
686     function allowance(address _owner, address spender) public view returns (uint256) {
687         if (delegate == address(0)) {
688             return super.allowance(_owner, spender);
689         } else {
690             return delegate.delegateAllowance(_owner, spender);
691         }
692     }
693 
694     function totalSupply() public view returns (uint256) {
695         if (delegate == address(0)) {
696             return super.totalSupply();
697         } else {
698             return delegate.delegateTotalSupply();
699         }
700     }
701 
702     function increaseApproval(address spender, uint addedValue) public returns (bool) {
703         if (delegate == address(0)) {
704             return super.increaseApproval(spender, addedValue);
705         } else {
706             return delegate.delegateIncreaseApproval(spender, addedValue, msg.sender);
707         }
708     }
709 
710     function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
711         if (delegate == address(0)) {
712             return super.decreaseApproval(spender, subtractedValue);
713         } else {
714             return delegate.delegateDecreaseApproval(spender, subtractedValue, msg.sender);
715         }
716     }
717 }
718 
719 // File: contracts/StandardDelegate.sol
720 
721 contract StandardDelegate is StandardToken, DelegateERC20 {
722     address public delegatedFrom;
723 
724     modifier onlySender(address source) {
725         require(msg.sender == source);
726         _;
727     }
728 
729     function setDelegatedFrom(address addr) onlyOwner public {
730         delegatedFrom = addr;
731     }
732 
733     // All delegate ERC20 functions are forwarded to corresponding normal functions
734     function delegateTotalSupply() public view returns (uint256) {
735         return totalSupply();
736     }
737 
738     function delegateBalanceOf(address who) public view returns (uint256) {
739         return balanceOf(who);
740     }
741 
742     function delegateTransfer(address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
743         transferAllArgsNoAllowance(origSender, to, value);
744         return true;
745     }
746 
747     function delegateAllowance(address owner, address spender) public view returns (uint256) {
748         return allowance(owner, spender);
749     }
750 
751     function delegateTransferFrom(address from, address to, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
752         transferAllArgsYesAllowance(from, to, value, origSender);
753         return true;
754     }
755 
756     function delegateApprove(address spender, uint256 value, address origSender) onlySender(delegatedFrom) public returns (bool) {
757         approveAllArgs(spender, value, origSender);
758         return true;
759     }
760 
761     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
762         increaseApprovalAllArgs(spender, addedValue, origSender);
763         return true;
764     }
765 
766     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) onlySender(delegatedFrom) public returns (bool) {
767         decreaseApprovalAllArgs(spender, subtractedValue, origSender);
768         return true;
769     }
770 }
771 
772 // File: contracts/TrueVND.sol
773 
774 contract TrueVND is NoOwner, BurnableToken, CanDelegate, StandardDelegate, PausableToken {
775     string public name = "TrueVND";
776     string public symbol = "TVND";
777     uint8 public constant decimals = 18;
778 
779     AddressList public canReceiveMintWhiteList;
780     AddressList public canBurnWhiteList;
781     AddressList public blackList;
782     AddressList public noFeesList;
783     address public staker;
784 
785     uint256 public burnMin = 1000 * 10 ** uint256(decimals);
786     uint256 public burnMax = 20000000 * 10 ** uint256(decimals);
787 
788     uint80 public transferFeeNumerator = 8;
789     uint80 public transferFeeDenominator = 10000;
790     uint80 public mintFeeNumerator = 0;
791     uint80 public mintFeeDenominator = 10000;
792     uint256 public mintFeeFlat = 0;
793     uint80 public burnFeeNumerator = 0;
794     uint80 public burnFeeDenominator = 10000;
795     uint256 public burnFeeFlat = 0;
796 
797     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
798     event Mint(address indexed to, uint256 amount);
799     event WipedAccount(address indexed account, uint256 balance);
800 
801     constructor() public {
802         totalSupply_ = 0;
803         staker = msg.sender;
804     }
805 
806     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) onlyOwner public {
807         canReceiveMintWhiteList = _canReceiveMintWhiteList;
808         canBurnWhiteList = _canBurnWhiteList;
809         blackList = _blackList;
810         noFeesList = _noFeesList;
811     }
812 
813     function changeName(string _name, string _symbol) onlyOwner public {
814         name = _name;
815         symbol = _symbol;
816     }
817 
818     // Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
819     // and will send them back the equivalent amount of money (rounded down to the nearest cent).
820     function burn(uint256 _value) public {
821         require(canBurnWhiteList.onList(msg.sender));
822         require(_value >= burnMin);
823         require(_value <= burnMax);
824         uint256 fee = payStakingFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat, 0x0);
825         uint256 remaining = _value.sub(fee);
826         super.burn(remaining);
827     }
828 
829     // Create _amount new tokens and transfer them to _to.
830     // Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
831     function mint(address _to, uint256 _amount) onlyOwner public {
832         require(canReceiveMintWhiteList.onList(_to));
833         totalSupply_ = totalSupply_.add(_amount);
834         balances.addBalance(_to, _amount);
835         emit Mint(_to, _amount);
836         emit Transfer(address(0), _to, _amount);
837         payStakingFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat, 0x0);
838     }
839 
840     // Change the minimum and maximum amount that can be burned at once. Burning
841     // may be disabled by setting both to 0 (this will not be done under normal
842     // operation, but we can't add checks to disallow it without losing a lot of
843     // flexibility since burning could also be as good as disabled
844     // by setting the minimum extremely high, and we don't want to lock
845     // in any particular cap for the minimum)
846     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
847         require(newMin <= newMax);
848         burnMin = newMin;
849         burnMax = newMax;
850         emit ChangeBurnBoundsEvent(newMin, newMax);
851     }
852 
853     // A blacklisted address can't call transferFrom
854     function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal {
855         require(!blackList.onList(spender));
856         super.transferAllArgsYesAllowance(_from, _to, _value, spender);
857     }
858 
859     // transfer and transferFrom both ultimately call this function, so we
860     // check blacklist and pay staking fee here.
861     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal {
862         require(!blackList.onList(_from));
863         require(!blackList.onList(_to));
864         super.transferAllArgsNoAllowance(_from, _to, _value);
865         payStakingFee(_to, _value, transferFeeNumerator, transferFeeDenominator, burnFeeFlat, _from);
866     }
867 
868     function wipeBlacklistedAccount(address account) public onlyOwner {
869         require(blackList.onList(account));
870         uint256 oldValue = balanceOf(account);
871         balances.setBalance(account, 0);
872         totalSupply_ = totalSupply_.sub(oldValue);
873         emit WipedAccount(account, oldValue);
874     }
875 
876     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256) {
877         if (noFeesList.onList(payer) || noFeesList.onList(otherParticipant)) {
878             return 0;
879         }
880         uint256 stakingFee = value.mul(numerator).div(denominator).add(flatRate);
881         if (stakingFee > 0) {
882             super.transferAllArgsNoAllowance(payer, staker, stakingFee);
883         }
884         return stakingFee;
885     }
886 
887     function changeStakingFees(uint80 _transferFeeNumerator,
888         uint80 _transferFeeDenominator,
889         uint80 _mintFeeNumerator,
890         uint80 _mintFeeDenominator,
891         uint256 _mintFeeFlat,
892         uint80 _burnFeeNumerator,
893         uint80 _burnFeeDenominator,
894         uint256 _burnFeeFlat) public onlyOwner {
895         require(_transferFeeDenominator != 0);
896         require(_mintFeeDenominator != 0);
897         require(_burnFeeDenominator != 0);
898         transferFeeNumerator = _transferFeeNumerator;
899         transferFeeDenominator = _transferFeeDenominator;
900         mintFeeNumerator = _mintFeeNumerator;
901         mintFeeDenominator = _mintFeeDenominator;
902         mintFeeFlat = _mintFeeFlat;
903         burnFeeNumerator = _burnFeeNumerator;
904         burnFeeDenominator = _burnFeeDenominator;
905         burnFeeFlat = _burnFeeFlat;
906     }
907 
908     function changeStaker(address newStaker) public onlyOwner {
909         require(newStaker != address(0));
910         staker = newStaker;
911     }
912 }