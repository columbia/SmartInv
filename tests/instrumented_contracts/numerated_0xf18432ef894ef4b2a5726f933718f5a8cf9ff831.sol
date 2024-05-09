1 pragma solidity ^0.4.22;
2 
3 // zeppelin-solidity: 1.11.0
4 
5 contract ERC223ReceivingContract { 
6 /**
7  * @dev Standard ERC223 function that will handle incoming token transfers.
8  *
9  * @param _from  Token sender address.
10  * @param _value Amount of tokens.
11  * @param _data  Transaction metadata.
12  */
13     function tokenFallback(address _from, uint _value, bytes _data) public;
14 }
15 
16 contract ERC223Interface {
17     function transfer(address to, uint value, bytes data) public returns (bool);
18     event Transfer(address indexed from, address indexed to, uint value, bytes data);
19 }
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipRenounced(address indexed previousOwner);
31   event OwnershipTransferred(
32     address indexed previousOwner,
33     address indexed newOwner
34   );
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    * @notice Renouncing to ownership will leave the contract without an owner.
56    * It will not be possible to call the functions with the `onlyOwner`
57    * modifier anymore.
58    */
59   function renounceOwnership() public onlyOwner {
60     emit OwnershipRenounced(owner);
61     owner = address(0);
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param _newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address _newOwner) public onlyOwner {
69     _transferOwnership(_newOwner);
70   }
71 
72   /**
73    * @dev Transfers control of the contract to a newOwner.
74    * @param _newOwner The address to transfer ownership to.
75    */
76   function _transferOwnership(address _newOwner) internal {
77     require(_newOwner != address(0));
78     emit OwnershipTransferred(owner, _newOwner);
79     owner = _newOwner;
80   }
81 }
82 
83 /**
84  * @title Contracts that should not own Ether
85  * @author Remco Bloemen <remco@2π.com>
86  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
87  * in the contract, it will allow the owner to reclaim this ether.
88  * @notice Ether can still be sent to this contract by:
89  * calling functions labeled `payable`
90  * `selfdestruct(contract_address)`
91  * mining directly to the contract address
92  */
93 contract HasNoEther is Ownable {
94 
95   /**
96   * @dev Constructor that rejects incoming Ether
97   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
98   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
99   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
100   * we could use assembly to access msg.value.
101   */
102   constructor() public payable {
103     require(msg.value == 0);
104   }
105 
106   /**
107    * @dev Disallows direct send by settings a default function without the `payable` flag.
108    */
109   function() external {
110   }
111 
112   /**
113    * @dev Transfer all Ether held by the contract to the owner.
114    */
115   function reclaimEther() external onlyOwner {
116     owner.transfer(address(this).balance);
117   }
118 }
119 
120 /**
121  * @title Claimable
122  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
123  * This allows the new owner to accept the transfer.
124  */
125 contract Claimable is Ownable {
126   address public pendingOwner;
127 
128   /**
129    * @dev Modifier throws if called by any account other than the pendingOwner.
130    */
131   modifier onlyPendingOwner() {
132     require(msg.sender == pendingOwner);
133     _;
134   }
135 
136   /**
137    * @dev Allows the current owner to set the pendingOwner address.
138    * @param newOwner The address to transfer ownership to.
139    */
140   function transferOwnership(address newOwner) onlyOwner public {
141     pendingOwner = newOwner;
142   }
143 
144   /**
145    * @dev Allows the pendingOwner address to finalize the transfer.
146    */
147   function claimOwnership() onlyPendingOwner public {
148     emit OwnershipTransferred(owner, pendingOwner);
149     owner = pendingOwner;
150     pendingOwner = address(0);
151   }
152 }
153 
154 /**
155  * @title Pausable
156  * @dev Base contract which allows children to implement an emergency stop mechanism.
157  */
158 contract Pausable is Ownable {
159   event Pause();
160   event Unpause();
161 
162   bool public paused = false;
163 
164 
165   /**
166    * @dev Modifier to make a function callable only when the contract is not paused.
167    */
168   modifier whenNotPaused() {
169     require(!paused);
170     _;
171   }
172 
173   /**
174    * @dev Modifier to make a function callable only when the contract is paused.
175    */
176   modifier whenPaused() {
177     require(paused);
178     _;
179   }
180 
181   /**
182    * @dev called by the owner to pause, triggers stopped state
183    */
184   function pause() onlyOwner whenNotPaused public {
185     paused = true;
186     emit Pause();
187   }
188 
189   /**
190    * @dev called by the owner to unpause, returns to normal state
191    */
192   function unpause() onlyOwner whenPaused public {
193     paused = false;
194     emit Unpause();
195   }
196 }
197 
198 /**
199  * @title ERC20Basic
200  * @dev Simpler version of ERC20 interface
201  * See https://github.com/ethereum/EIPs/issues/179
202  */
203 contract ERC20Basic {
204   function totalSupply() public view returns (uint256);
205   function balanceOf(address who) public view returns (uint256);
206   function transfer(address to, uint256 value) public returns (bool);
207   event Transfer(address indexed from, address indexed to, uint256 value);
208 }
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 contract ERC20 is ERC20Basic {
215   function allowance(address owner, address spender)
216     public view returns (uint256);
217 
218   function transferFrom(address from, address to, uint256 value)
219     public returns (bool);
220 
221   function approve(address spender, uint256 value) public returns (bool);
222   event Approval(
223     address indexed owner,
224     address indexed spender,
225     uint256 value
226   );
227 }
228 
229 /**
230  * @title SafeERC20
231  * @dev Wrappers around ERC20 operations that throw on failure.
232  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
233  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
234  */
235 library SafeERC20 {
236   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
237     require(token.transfer(to, value));
238   }
239 
240   function safeTransferFrom(
241     ERC20 token,
242     address from,
243     address to,
244     uint256 value
245   )
246     internal
247   {
248     require(token.transferFrom(from, to, value));
249   }
250 
251   function safeApprove(ERC20 token, address spender, uint256 value) internal {
252     require(token.approve(spender, value));
253   }
254 }
255 
256 /**
257  * @title Contracts that should be able to recover tokens
258  * @author SylTi
259  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
260  * This will prevent any accidental loss of tokens.
261  */
262 contract CanReclaimToken is Ownable {
263   using SafeERC20 for ERC20Basic;
264 
265   /**
266    * @dev Reclaim all ERC20Basic compatible tokens
267    * @param token ERC20Basic The address of the token contract
268    */
269   function reclaimToken(ERC20Basic token) external onlyOwner {
270     uint256 balance = token.balanceOf(this);
271     token.safeTransfer(owner, balance);
272   }
273 
274 }
275 
276 /**
277  * @title Contracts that should not own Tokens
278  * @author Remco Bloemen <remco@2π.com>
279  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
280  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
281  * owner to reclaim the tokens.
282  */
283 contract HasNoTokens is CanReclaimToken {
284 
285  /**
286   * @dev Reject all ERC223 compatible tokens
287   * @param from_ address The address that is transferring the tokens
288   * @param value_ uint256 the amount of the specified token
289   * @param data_ Bytes The data passed from the caller.
290   */
291   function tokenFallback(address from_, uint256 value_, bytes data_) external {
292     from_;
293     value_;
294     data_;
295     revert();
296   }
297 
298 }
299 
300 /**
301  * @title Basic token
302  * @dev Basic version of StandardToken, with no allowances.
303  */
304 contract BasicToken is ERC20Basic {
305   using SafeMath for uint256;
306 
307   mapping(address => uint256) balances;
308 
309   uint256 totalSupply_;
310 
311   /**
312   * @dev Total number of tokens in existence
313   */
314   function totalSupply() public view returns (uint256) {
315     return totalSupply_;
316   }
317 
318   /**
319   * @dev Transfer token for a specified address
320   * @param _to The address to transfer to.
321   * @param _value The amount to be transferred.
322   */
323   function transfer(address _to, uint256 _value) public returns (bool) {
324     require(_to != address(0));
325     require(_value <= balances[msg.sender]);
326 
327     balances[msg.sender] = balances[msg.sender].sub(_value);
328     balances[_to] = balances[_to].add(_value);
329     emit Transfer(msg.sender, _to, _value);
330     return true;
331   }
332 
333   /**
334   * @dev Gets the balance of the specified address.
335   * @param _owner The address to query the the balance of.
336   * @return An uint256 representing the amount owned by the passed address.
337   */
338   function balanceOf(address _owner) public view returns (uint256) {
339     return balances[_owner];
340   }
341 
342 }
343 
344 /**
345  * @title Standard ERC20 token
346  *
347  * @dev Implementation of the basic standard token.
348  * https://github.com/ethereum/EIPs/issues/20
349  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
350  */
351 contract StandardToken is ERC20, BasicToken {
352 
353   mapping (address => mapping (address => uint256)) internal allowed;
354 
355 
356   /**
357    * @dev Transfer tokens from one address to another
358    * @param _from address The address which you want to send tokens from
359    * @param _to address The address which you want to transfer to
360    * @param _value uint256 the amount of tokens to be transferred
361    */
362   function transferFrom(
363     address _from,
364     address _to,
365     uint256 _value
366   )
367     public
368     returns (bool)
369   {
370     require(_to != address(0));
371     require(_value <= balances[_from]);
372     require(_value <= allowed[_from][msg.sender]);
373 
374     balances[_from] = balances[_from].sub(_value);
375     balances[_to] = balances[_to].add(_value);
376     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
377     emit Transfer(_from, _to, _value);
378     return true;
379   }
380 
381   /**
382    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
383    * Beware that changing an allowance with this method brings the risk that someone may use both the old
384    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
385    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
386    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387    * @param _spender The address which will spend the funds.
388    * @param _value The amount of tokens to be spent.
389    */
390   function approve(address _spender, uint256 _value) public returns (bool) {
391     allowed[msg.sender][_spender] = _value;
392     emit Approval(msg.sender, _spender, _value);
393     return true;
394   }
395 
396   /**
397    * @dev Function to check the amount of tokens that an owner allowed to a spender.
398    * @param _owner address The address which owns the funds.
399    * @param _spender address The address which will spend the funds.
400    * @return A uint256 specifying the amount of tokens still available for the spender.
401    */
402   function allowance(
403     address _owner,
404     address _spender
405    )
406     public
407     view
408     returns (uint256)
409   {
410     return allowed[_owner][_spender];
411   }
412 
413   /**
414    * @dev Increase the amount of tokens that an owner allowed to a spender.
415    * approve should be called when allowed[_spender] == 0. To increment
416    * allowed value is better to use this function to avoid 2 calls (and wait until
417    * the first transaction is mined)
418    * From MonolithDAO Token.sol
419    * @param _spender The address which will spend the funds.
420    * @param _addedValue The amount of tokens to increase the allowance by.
421    */
422   function increaseApproval(
423     address _spender,
424     uint256 _addedValue
425   )
426     public
427     returns (bool)
428   {
429     allowed[msg.sender][_spender] = (
430       allowed[msg.sender][_spender].add(_addedValue));
431     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
432     return true;
433   }
434 
435   /**
436    * @dev Decrease the amount of tokens that an owner allowed to a spender.
437    * approve should be called when allowed[_spender] == 0. To decrement
438    * allowed value is better to use this function to avoid 2 calls (and wait until
439    * the first transaction is mined)
440    * From MonolithDAO Token.sol
441    * @param _spender The address which will spend the funds.
442    * @param _subtractedValue The amount of tokens to decrease the allowance by.
443    */
444   function decreaseApproval(
445     address _spender,
446     uint256 _subtractedValue
447   )
448     public
449     returns (bool)
450   {
451     uint256 oldValue = allowed[msg.sender][_spender];
452     if (_subtractedValue > oldValue) {
453       allowed[msg.sender][_spender] = 0;
454     } else {
455       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
456     }
457     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
458     return true;
459   }
460 
461 }
462 
463 /**
464  * @title Pausable token
465  * @dev StandardToken modified with pausable transfers.
466  **/
467 contract PausableToken is StandardToken, Pausable {
468 
469   function transfer(
470     address _to,
471     uint256 _value
472   )
473     public
474     whenNotPaused
475     returns (bool)
476   {
477     return super.transfer(_to, _value);
478   }
479 
480   function transferFrom(
481     address _from,
482     address _to,
483     uint256 _value
484   )
485     public
486     whenNotPaused
487     returns (bool)
488   {
489     return super.transferFrom(_from, _to, _value);
490   }
491 
492   function approve(
493     address _spender,
494     uint256 _value
495   )
496     public
497     whenNotPaused
498     returns (bool)
499   {
500     return super.approve(_spender, _value);
501   }
502 
503   function increaseApproval(
504     address _spender,
505     uint _addedValue
506   )
507     public
508     whenNotPaused
509     returns (bool success)
510   {
511     return super.increaseApproval(_spender, _addedValue);
512   }
513 
514   function decreaseApproval(
515     address _spender,
516     uint _subtractedValue
517   )
518     public
519     whenNotPaused
520     returns (bool success)
521   {
522     return super.decreaseApproval(_spender, _subtractedValue);
523   }
524 }
525 
526 /**
527  * @title Mintable token
528  * @dev Simple ERC20 Token example, with mintable token creation
529  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
530  */
531 contract MintableToken is StandardToken, Ownable {
532   event Mint(address indexed to, uint256 amount);
533   event MintFinished();
534 
535   bool public mintingFinished = false;
536 
537 
538   modifier canMint() {
539     require(!mintingFinished);
540     _;
541   }
542 
543   modifier hasMintPermission() {
544     require(msg.sender == owner);
545     _;
546   }
547 
548   /**
549    * @dev Function to mint tokens
550    * @param _to The address that will receive the minted tokens.
551    * @param _amount The amount of tokens to mint.
552    * @return A boolean that indicates if the operation was successful.
553    */
554   function mint(
555     address _to,
556     uint256 _amount
557   )
558     hasMintPermission
559     canMint
560     public
561     returns (bool)
562   {
563     totalSupply_ = totalSupply_.add(_amount);
564     balances[_to] = balances[_to].add(_amount);
565     emit Mint(_to, _amount);
566     emit Transfer(address(0), _to, _amount);
567     return true;
568   }
569 
570   /**
571    * @dev Function to stop minting new tokens.
572    * @return True if the operation was successful.
573    */
574   function finishMinting() onlyOwner canMint public returns (bool) {
575     mintingFinished = true;
576     emit MintFinished();
577     return true;
578   }
579 }
580 
581 /**
582  * @title Capped token
583  * @dev Mintable token with a token cap.
584  */
585 contract CappedToken is MintableToken {
586 
587   uint256 public cap;
588 
589   constructor(uint256 _cap) public {
590     require(_cap > 0);
591     cap = _cap;
592   }
593 
594   /**
595    * @dev Function to mint tokens
596    * @param _to The address that will receive the minted tokens.
597    * @param _amount The amount of tokens to mint.
598    * @return A boolean that indicates if the operation was successful.
599    */
600   function mint(
601     address _to,
602     uint256 _amount
603   )
604     public
605     returns (bool)
606   {
607     require(totalSupply_.add(_amount) <= cap);
608 
609     return super.mint(_to, _amount);
610   }
611 
612 }
613 
614 /**
615  * @title SafeMath
616  * @dev Math operations with safety checks that throw on error
617  */
618 library SafeMath {
619 
620   /**
621   * @dev Multiplies two numbers, throws on overflow.
622   */
623   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
624     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
625     // benefit is lost if 'b' is also tested.
626     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
627     if (a == 0) {
628       return 0;
629     }
630 
631     c = a * b;
632     assert(c / a == b);
633     return c;
634   }
635 
636   /**
637   * @dev Integer division of two numbers, truncating the quotient.
638   */
639   function div(uint256 a, uint256 b) internal pure returns (uint256) {
640     // assert(b > 0); // Solidity automatically throws when dividing by 0
641     // uint256 c = a / b;
642     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
643     return a / b;
644   }
645 
646   /**
647   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
648   */
649   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
650     assert(b <= a);
651     return a - b;
652   }
653 
654   /**
655   * @dev Adds two numbers, throws on overflow.
656   */
657   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
658     c = a + b;
659     assert(c >= a);
660     return c;
661   }
662 }
663 
664 contract bioCryptToken is ERC223Interface, HasNoEther, HasNoTokens, Claimable, PausableToken, CappedToken {
665   string public constant name = "BioCrypt";
666   string public constant symbol = "BIO";
667   uint8 public constant decimals = 8;
668 
669   event Fused();
670 
671   bool public fused = false;
672 
673   /**
674     * @dev Constructor 
675     */
676   constructor() public CappedToken(1) PausableToken() {
677     cap = 1000000000 * (10 ** uint256(decimals)); // hardcoding cap
678   }
679 
680     /**
681      * @dev Transfer the specified amount of tokens to the specified address.
682      *      Invokes the `tokenFallback` function if the recipient is a contract.
683      *      The token transfer fails if the recipient is a contract
684      *      but does not implement the `tokenFallback` function
685      *      or the fallback function to receive funds.
686      *
687      * @param _to    Receiver address.
688      * @param _value Amount of tokens that will be transferred.
689      * @param _data  Transaction metadata.
690      */
691     function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
692         require(_to != address(0));
693         require(_value <= balances[msg.sender]);
694 
695         // SafeMath.sub will throw if there is not enough balance.
696         balances[msg.sender] = balances[msg.sender].sub(_value);
697         balances[_to] = balances[_to].add(_value);
698 
699         uint codeLength;
700 
701         assembly {
702             // Retrieve the size of the code on target address, this needs assembly .
703             codeLength := extcodesize(_to)
704         }
705 
706         if (codeLength > 0) {
707             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
708             receiver.tokenFallback(msg.sender, _value, _data);
709         }
710 
711         emit Transfer(msg.sender, _to, _value);
712         emit Transfer(msg.sender, _to, _value, _data);
713         return true;
714     }
715     
716     /**
717      * @dev Transfer the specified amount of tokens to the specified address.
718      *      This function works the same with the previous one
719      *      but doesn't contain `_data` param.
720      *      Added due to backwards compatibility reasons.
721      *
722      * @param _to    Receiver address.
723      * @param _value Amount of tokens that will be transferred.
724      */
725     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
726         // Standard function transfer similar to ERC20 transfer with no _data .
727         // Added due to backwards compatibility reasons .
728         bytes memory empty;
729         return transfer(_to, _value, empty);
730     }
731 
732   /**
733    * @dev Modifier to make a function callable only when the contract is not fused.
734    */
735   modifier whenNotFused() {
736     require(!fused);
737     _;
738   }
739 
740   /** 
741   * @dev Overriding pause() such that we use the fuse functionality.
742   */
743   function pause() whenNotFused public {
744     return super.pause();
745   }
746 
747   /** 
748   * @dev Function to set the value of the fuse internal variable.  Note that there is 
749   * no "unfuse" functionality, by design.
750   */
751   function fuse() whenNotFused onlyOwner public {
752     fused = true;
753 
754     emit Fused();
755   }
756 }