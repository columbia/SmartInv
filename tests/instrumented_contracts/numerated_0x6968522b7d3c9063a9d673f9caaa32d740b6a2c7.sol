1 pragma solidity ^0.4.24;
2 
3 // File: contracts\zeppelin\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts\zeppelin\contracts\ownership\Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner public {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() onlyPendingOwner public {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: contracts\ClaimableEx.sol
104 
105 /**
106  * @title Claimable Ex
107  * @dev Extension for the Claimable contract, where the ownership transfer can be canceled.
108  */
109 contract ClaimableEx is Claimable {
110     /*
111      * @dev Cancels the ownership transfer.
112      */
113     function cancelOwnershipTransfer() onlyOwner public {
114         pendingOwner = owner;
115     }
116 }
117 
118 // File: contracts\zeppelin\contracts\ownership\Contactable.sol
119 
120 /**
121  * @title Contactable token
122  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
123  * contact information.
124  */
125 contract Contactable is Ownable {
126 
127   string public contactInformation;
128 
129   /**
130     * @dev Allows the owner to set a string with their contact information.
131     * @param info The contact information to attach to the contract.
132     */
133   function setContactInformation(string info) onlyOwner public {
134     contactInformation = info;
135   }
136 }
137 
138 // File: contracts\zeppelin\contracts\ownership\HasNoEther.sol
139 
140 /**
141  * @title Contracts that should not own Ether
142  * @author Remco Bloemen <remco@2π.com>
143  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
144  * in the contract, it will allow the owner to reclaim this ether.
145  * @notice Ether can still be sent to this contract by:
146  * calling functions labeled `payable`
147  * `selfdestruct(contract_address)`
148  * mining directly to the contract address
149  */
150 contract HasNoEther is Ownable {
151 
152   /**
153   * @dev Constructor that rejects incoming Ether
154   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
155   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
156   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
157   * we could use assembly to access msg.value.
158   */
159   constructor() public payable {
160     require(msg.value == 0);
161   }
162 
163   /**
164    * @dev Disallows direct send by settings a default function without the `payable` flag.
165    */
166   function() external {
167   }
168 
169   /**
170    * @dev Transfer all Ether held by the contract to the owner.
171    */
172   function reclaimEther() external onlyOwner {
173     owner.transfer(address(this).balance);
174   }
175 }
176 
177 // File: contracts\zeppelin\contracts\token\ERC20\ERC20Basic.sol
178 
179 /**
180  * @title ERC20Basic
181  * @dev Simpler version of ERC20 interface
182  * See https://github.com/ethereum/EIPs/issues/179
183  */
184 contract ERC20Basic {
185   function totalSupply() public view returns (uint256);
186   function balanceOf(address who) public view returns (uint256);
187   function transfer(address to, uint256 value) public returns (bool);
188   event Transfer(address indexed from, address indexed to, uint256 value);
189 }
190 
191 // File: contracts\zeppelin\contracts\token\ERC20\ERC20.sol
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198   function allowance(address owner, address spender)
199     public view returns (uint256);
200 
201   function transferFrom(address from, address to, uint256 value)
202     public returns (bool);
203 
204   function approve(address spender, uint256 value) public returns (bool);
205   event Approval(
206     address indexed owner,
207     address indexed spender,
208     uint256 value
209   );
210 }
211 
212 // File: contracts\zeppelin\contracts\token\ERC20\SafeERC20.sol
213 
214 /**
215  * @title SafeERC20
216  * @dev Wrappers around ERC20 operations that throw on failure.
217  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
218  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
219  */
220 library SafeERC20 {
221   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
222     require(token.transfer(to, value));
223   }
224 
225   function safeTransferFrom(
226     ERC20 token,
227     address from,
228     address to,
229     uint256 value
230   )
231     internal
232   {
233     require(token.transferFrom(from, to, value));
234   }
235 
236   function safeApprove(ERC20 token, address spender, uint256 value) internal {
237     require(token.approve(spender, value));
238   }
239 }
240 
241 // File: contracts\zeppelin\contracts\ownership\CanReclaimToken.sol
242 
243 /**
244  * @title Contracts that should be able to recover tokens
245  * @author SylTi
246  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
247  * This will prevent any accidental loss of tokens.
248  */
249 contract CanReclaimToken is Ownable {
250   using SafeERC20 for ERC20Basic;
251 
252   /**
253    * @dev Reclaim all ERC20Basic compatible tokens
254    * @param token ERC20Basic The address of the token contract
255    */
256   function reclaimToken(ERC20Basic token) external onlyOwner {
257     uint256 balance = token.balanceOf(this);
258     token.safeTransfer(owner, balance);
259   }
260 
261 }
262 
263 // File: contracts\zeppelin\contracts\ownership\HasNoTokens.sol
264 
265 /**
266  * @title Contracts that should not own Tokens
267  * @author Remco Bloemen <remco@2π.com>
268  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
269  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
270  * owner to reclaim the tokens.
271  */
272 contract HasNoTokens is CanReclaimToken {
273 
274  /**
275   * @dev Reject all ERC223 compatible tokens
276   * @param from_ address The address that is transferring the tokens
277   * @param value_ uint256 the amount of the specified token
278   * @param data_ Bytes The data passed from the caller.
279   */
280   function tokenFallback(address from_, uint256 value_, bytes data_) external {
281     from_;
282     value_;
283     data_;
284     revert();
285   }
286 
287 }
288 
289 // File: contracts\zeppelin\contracts\math\SafeMath.sol
290 
291 /**
292  * @title SafeMath
293  * @dev Math operations with safety checks that throw on error
294  */
295 library SafeMath {
296 
297   /**
298   * @dev Multiplies two numbers, throws on overflow.
299   */
300   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
301     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
302     // benefit is lost if 'b' is also tested.
303     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
304     if (a == 0) {
305       return 0;
306     }
307 
308     c = a * b;
309     assert(c / a == b);
310     return c;
311   }
312 
313   /**
314   * @dev Integer division of two numbers, truncating the quotient.
315   */
316   function div(uint256 a, uint256 b) internal pure returns (uint256) {
317     // assert(b > 0); // Solidity automatically throws when dividing by 0
318     // uint256 c = a / b;
319     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320     return a / b;
321   }
322 
323   /**
324   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
325   */
326   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
327     assert(b <= a);
328     return a - b;
329   }
330 
331   /**
332   * @dev Adds two numbers, throws on overflow.
333   */
334   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
335     c = a + b;
336     assert(c >= a);
337     return c;
338   }
339 }
340 
341 // File: contracts\zeppelin\contracts\token\ERC20\BasicToken.sol
342 
343 /**
344  * @title Basic token
345  * @dev Basic version of StandardToken, with no allowances.
346  */
347 contract BasicToken is ERC20Basic {
348   using SafeMath for uint256;
349 
350   mapping(address => uint256) balances;
351 
352   uint256 totalSupply_;
353 
354   /**
355   * @dev Total number of tokens in existence
356   */
357   function totalSupply() public view returns (uint256) {
358     return totalSupply_;
359   }
360 
361   /**
362   * @dev Transfer token for a specified address
363   * @param _to The address to transfer to.
364   * @param _value The amount to be transferred.
365   */
366   function transfer(address _to, uint256 _value) public returns (bool) {
367     require(_to != address(0));
368     require(_value <= balances[msg.sender]);
369 
370     balances[msg.sender] = balances[msg.sender].sub(_value);
371     balances[_to] = balances[_to].add(_value);
372     emit Transfer(msg.sender, _to, _value);
373     return true;
374   }
375 
376   /**
377   * @dev Gets the balance of the specified address.
378   * @param _owner The address to query the the balance of.
379   * @return An uint256 representing the amount owned by the passed address.
380   */
381   function balanceOf(address _owner) public view returns (uint256) {
382     return balances[_owner];
383   }
384 
385 }
386 
387 // File: contracts\zeppelin\contracts\token\ERC20\StandardToken.sol
388 
389 /**
390  * @title Standard ERC20 token
391  *
392  * @dev Implementation of the basic standard token.
393  * https://github.com/ethereum/EIPs/issues/20
394  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
395  */
396 contract StandardToken is ERC20, BasicToken {
397 
398   mapping (address => mapping (address => uint256)) internal allowed;
399 
400 
401   /**
402    * @dev Transfer tokens from one address to another
403    * @param _from address The address which you want to send tokens from
404    * @param _to address The address which you want to transfer to
405    * @param _value uint256 the amount of tokens to be transferred
406    */
407   function transferFrom(
408     address _from,
409     address _to,
410     uint256 _value
411   )
412     public
413     returns (bool)
414   {
415     require(_to != address(0));
416     require(_value <= balances[_from]);
417     require(_value <= allowed[_from][msg.sender]);
418 
419     balances[_from] = balances[_from].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
422     emit Transfer(_from, _to, _value);
423     return true;
424   }
425 
426   /**
427    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
428    * Beware that changing an allowance with this method brings the risk that someone may use both the old
429    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
430    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
431    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
432    * @param _spender The address which will spend the funds.
433    * @param _value The amount of tokens to be spent.
434    */
435   function approve(address _spender, uint256 _value) public returns (bool) {
436     allowed[msg.sender][_spender] = _value;
437     emit Approval(msg.sender, _spender, _value);
438     return true;
439   }
440 
441   /**
442    * @dev Function to check the amount of tokens that an owner allowed to a spender.
443    * @param _owner address The address which owns the funds.
444    * @param _spender address The address which will spend the funds.
445    * @return A uint256 specifying the amount of tokens still available for the spender.
446    */
447   function allowance(
448     address _owner,
449     address _spender
450    )
451     public
452     view
453     returns (uint256)
454   {
455     return allowed[_owner][_spender];
456   }
457 
458   /**
459    * @dev Increase the amount of tokens that an owner allowed to a spender.
460    * approve should be called when allowed[_spender] == 0. To increment
461    * allowed value is better to use this function to avoid 2 calls (and wait until
462    * the first transaction is mined)
463    * From MonolithDAO Token.sol
464    * @param _spender The address which will spend the funds.
465    * @param _addedValue The amount of tokens to increase the allowance by.
466    */
467   function increaseApproval(
468     address _spender,
469     uint256 _addedValue
470   )
471     public
472     returns (bool)
473   {
474     allowed[msg.sender][_spender] = (
475       allowed[msg.sender][_spender].add(_addedValue));
476     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477     return true;
478   }
479 
480   /**
481    * @dev Decrease the amount of tokens that an owner allowed to a spender.
482    * approve should be called when allowed[_spender] == 0. To decrement
483    * allowed value is better to use this function to avoid 2 calls (and wait until
484    * the first transaction is mined)
485    * From MonolithDAO Token.sol
486    * @param _spender The address which will spend the funds.
487    * @param _subtractedValue The amount of tokens to decrease the allowance by.
488    */
489   function decreaseApproval(
490     address _spender,
491     uint256 _subtractedValue
492   )
493     public
494     returns (bool)
495   {
496     uint256 oldValue = allowed[msg.sender][_spender];
497     if (_subtractedValue > oldValue) {
498       allowed[msg.sender][_spender] = 0;
499     } else {
500       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
501     }
502     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
503     return true;
504   }
505 
506 }
507 
508 // File: contracts\zeppelin\contracts\token\ERC20\MintableToken.sol
509 
510 /**
511  * @title Mintable token
512  * @dev Simple ERC20 Token example, with mintable token creation
513  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
514  */
515 contract MintableToken is StandardToken, Ownable {
516   event Mint(address indexed to, uint256 amount);
517   event MintFinished();
518 
519   bool public mintingFinished = false;
520 
521 
522   modifier canMint() {
523     require(!mintingFinished);
524     _;
525   }
526 
527   modifier hasMintPermission() {
528     require(msg.sender == owner);
529     _;
530   }
531 
532   /**
533    * @dev Function to mint tokens
534    * @param _to The address that will receive the minted tokens.
535    * @param _amount The amount of tokens to mint.
536    * @return A boolean that indicates if the operation was successful.
537    */
538   function mint(
539     address _to,
540     uint256 _amount
541   )
542     hasMintPermission
543     canMint
544     public
545     returns (bool)
546   {
547     totalSupply_ = totalSupply_.add(_amount);
548     balances[_to] = balances[_to].add(_amount);
549     emit Mint(_to, _amount);
550     emit Transfer(address(0), _to, _amount);
551     return true;
552   }
553 
554   /**
555    * @dev Function to stop minting new tokens.
556    * @return True if the operation was successful.
557    */
558   function finishMinting() onlyOwner canMint public returns (bool) {
559     mintingFinished = true;
560     emit MintFinished();
561     return true;
562   }
563 }
564 
565 // File: contracts\zeppelin\contracts\lifecycle\Pausable.sol
566 
567 /**
568  * @title Pausable
569  * @dev Base contract which allows children to implement an emergency stop mechanism.
570  */
571 contract Pausable is Ownable {
572   event Pause();
573   event Unpause();
574 
575   bool public paused = false;
576 
577 
578   /**
579    * @dev Modifier to make a function callable only when the contract is not paused.
580    */
581   modifier whenNotPaused() {
582     require(!paused);
583     _;
584   }
585 
586   /**
587    * @dev Modifier to make a function callable only when the contract is paused.
588    */
589   modifier whenPaused() {
590     require(paused);
591     _;
592   }
593 
594   /**
595    * @dev called by the owner to pause, triggers stopped state
596    */
597   function pause() onlyOwner whenNotPaused public {
598     paused = true;
599     emit Pause();
600   }
601 
602   /**
603    * @dev called by the owner to unpause, returns to normal state
604    */
605   function unpause() onlyOwner whenPaused public {
606     paused = false;
607     emit Unpause();
608   }
609 }
610 
611 // File: contracts\zeppelin\contracts\token\ERC20\PausableToken.sol
612 
613 /**
614  * @title Pausable token
615  * @dev StandardToken modified with pausable transfers.
616  **/
617 contract PausableToken is StandardToken, Pausable {
618 
619   function transfer(
620     address _to,
621     uint256 _value
622   )
623     public
624     whenNotPaused
625     returns (bool)
626   {
627     return super.transfer(_to, _value);
628   }
629 
630   function transferFrom(
631     address _from,
632     address _to,
633     uint256 _value
634   )
635     public
636     whenNotPaused
637     returns (bool)
638   {
639     return super.transferFrom(_from, _to, _value);
640   }
641 
642   function approve(
643     address _spender,
644     uint256 _value
645   )
646     public
647     whenNotPaused
648     returns (bool)
649   {
650     return super.approve(_spender, _value);
651   }
652 
653   function increaseApproval(
654     address _spender,
655     uint _addedValue
656   )
657     public
658     whenNotPaused
659     returns (bool success)
660   {
661     return super.increaseApproval(_spender, _addedValue);
662   }
663 
664   function decreaseApproval(
665     address _spender,
666     uint _subtractedValue
667   )
668     public
669     whenNotPaused
670     returns (bool success)
671   {
672     return super.decreaseApproval(_spender, _subtractedValue);
673   }
674 }
675 
676 // File: contracts\RAXToken.sol
677 
678 /**
679  * @title  AXX token.
680  * @dev AXX is a ERC20 token that:
681  *  - caps total number at 10 billion tokens.
682  *  - can pause and unpause token transfer (and authorization) actions.
683  *  - mints new tokens when purchased (rather than transferring tokens pre-granted to a holding account).
684  *  - token holders can be distributed profit from asset manager.
685  *  - attempts to reject ERC20 token transfers to itself and allows token transfer out.
686  *  - attempts to reject ether sent and allows any ether held to be transferred out.
687  *  - allows the new owner to accept the ownership transfer, the owner can cancel the transfer if needed.
688  **/
689 contract AXXToken is Contactable, HasNoTokens, HasNoEther, ClaimableEx, MintableToken, PausableToken {
690     string public constant name = "AXXToken";
691     string public constant symbol = "AXX";
692 
693     uint8 public constant decimals = 18;
694     uint256 public constant ONE_TOKENS = (10 ** uint256(decimals));
695     uint256 public constant BILLION_TOKENS = (10**9) * ONE_TOKENS;
696     uint256 public constant TOTAL_TOKENS = 10 * BILLION_TOKENS;
697 
698     function AXXToken()
699     Contactable()
700     HasNoTokens()
701     HasNoEther()
702     ClaimableEx()
703     MintableToken()
704     PausableToken()
705     {
706         contactInformation = 'https://token.axx.io/';
707     }
708 
709     /**
710      * @dev Mints tokens to a beneficiary address. Capped by TOTAL_TOKENS.
711      * @param _to Who got the tokens.
712      * @param _amount Amount of tokens.
713      */
714     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
715         require(totalSupply_.add(_amount) <= TOTAL_TOKENS);
716         return super.mint(_to, _amount);
717     }
718 
719     /**
720      * @dev Allows the current owner to transfer control of the contract to a new owner.
721      * @param _newOwner The address to transfer ownership to.
722      */
723     function transferOwnership(address _newOwner) onlyOwner public {
724         // do not allow self ownership
725         require(_newOwner != address(this));
726         super.transferOwnership(_newOwner);
727     }
728 }