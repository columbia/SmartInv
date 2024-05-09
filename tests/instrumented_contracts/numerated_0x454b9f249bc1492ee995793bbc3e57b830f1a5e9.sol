1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender)
23     public view returns (uint256);
24 
25   function transferFrom(address from, address to, uint256 value)
26     public returns (bool);
27 
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeERC20
39  * @dev Wrappers around ERC20 operations that throw on failure.
40  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
41  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
42  */
43 library SafeERC20 {
44   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
45     require(token.transfer(to, value));
46   }
47 
48   function safeTransferFrom(
49     ERC20 token,
50     address from,
51     address to,
52     uint256 value
53   )
54     internal
55   {
56     require(token.transferFrom(from, to, value));
57   }
58 
59   function safeApprove(ERC20 token, address spender, uint256 value) internal {
60     require(token.approve(spender, value));
61   }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipRenounced(address indexed previousOwner);
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to relinquish control of the contract.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112 
113   /**
114    * @dev Transfers control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function _transferOwnership(address _newOwner) internal {
118     require(_newOwner != address(0));
119     emit OwnershipTransferred(owner, _newOwner);
120     owner = _newOwner;
121   }
122 }
123 
124 
125 /**
126  * @title Contracts that should be able to recover tokens
127  * @author SylTi
128  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
129  * This will prevent any accidental loss of tokens.
130  */
131 contract CanReclaimToken is Ownable {
132   using SafeERC20 for ERC20Basic;
133 
134   /**
135    * @dev Reclaim all ERC20Basic compatible tokens
136    * @param token ERC20Basic The address of the token contract
137    */
138   function reclaimToken(ERC20Basic token) external onlyOwner {
139     uint256 balance = token.balanceOf(this);
140     token.safeTransfer(owner, balance);
141   }
142 
143 }
144 
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151 
152   /**
153   * @dev Multiplies two numbers, throws on overflow.
154   */
155   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
156     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
157     // benefit is lost if 'b' is also tested.
158     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
159     if (a == 0) {
160       return 0;
161     }
162 
163     c = a * b;
164     assert(c / a == b);
165     return c;
166   }
167 
168   /**
169   * @dev Integer division of two numbers, truncating the quotient.
170   */
171   function div(uint256 a, uint256 b) internal pure returns (uint256) {
172     // assert(b > 0); // Solidity automatically throws when dividing by 0
173     // uint256 c = a / b;
174     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175     return a / b;
176   }
177 
178   /**
179   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
180   */
181   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182     assert(b <= a);
183     return a - b;
184   }
185 
186   /**
187   * @dev Adds two numbers, throws on overflow.
188   */
189   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
190     c = a + b;
191     assert(c >= a);
192     return c;
193   }
194 }
195 
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   uint256 totalSupply_;
207 
208   /**
209   * @dev total number of tokens in existence
210   */
211   function totalSupply() public view returns (uint256) {
212     return totalSupply_;
213   }
214 
215   /**
216   * @dev transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223 
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256) {
236     return balances[_owner];
237   }
238 
239 }
240 
241 
242 /**
243  * @title Burnable Token
244  * @dev Token that can be irreversibly burned (destroyed).
245  */
246 contract BurnableToken is BasicToken {
247 
248   event Burn(address indexed burner, uint256 value);
249 
250   /**
251    * @dev Burns a specific amount of tokens.
252    * @param _value The amount of token to be burned.
253    */
254   function burn(uint256 _value) public {
255     _burn(msg.sender, _value);
256   }
257 
258   function _burn(address _who, uint256 _value) internal {
259     require(_value <= balances[_who]);
260     // no need to require value <= totalSupply, since that would imply the
261     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
262 
263     balances[_who] = balances[_who].sub(_value);
264     totalSupply_ = totalSupply_.sub(_value);
265     emit Burn(_who, _value);
266     emit Transfer(_who, address(0), _value);
267   }
268 }
269 
270 
271 /**
272  * @title Standard ERC20 token
273  *
274  * @dev Implementation of the basic standard token.
275  * @dev https://github.com/ethereum/EIPs/issues/20
276  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
277  */
278 contract StandardToken is ERC20, BasicToken {
279 
280   mapping (address => mapping (address => uint256)) internal allowed;
281 
282 
283   /**
284    * @dev Transfer tokens from one address to another
285    * @param _from address The address which you want to send tokens from
286    * @param _to address The address which you want to transfer to
287    * @param _value uint256 the amount of tokens to be transferred
288    */
289   function transferFrom(
290     address _from,
291     address _to,
292     uint256 _value
293   )
294     public
295     returns (bool)
296   {
297     require(_to != address(0));
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300 
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304     emit Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    *
311    * Beware that changing an allowance with this method brings the risk that someone may use both the old
312    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
313    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
314    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
315    * @param _spender The address which will spend the funds.
316    * @param _value The amount of tokens to be spent.
317    */
318   function approve(address _spender, uint256 _value) public returns (bool) {
319     allowed[msg.sender][_spender] = _value;
320     emit Approval(msg.sender, _spender, _value);
321     return true;
322   }
323 
324   /**
325    * @dev Function to check the amount of tokens that an owner allowed to a spender.
326    * @param _owner address The address which owns the funds.
327    * @param _spender address The address which will spend the funds.
328    * @return A uint256 specifying the amount of tokens still available for the spender.
329    */
330   function allowance(
331     address _owner,
332     address _spender
333    )
334     public
335     view
336     returns (uint256)
337   {
338     return allowed[_owner][_spender];
339   }
340 
341   /**
342    * @dev Increase the amount of tokens that an owner allowed to a spender.
343    *
344    * approve should be called when allowed[_spender] == 0. To increment
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _addedValue The amount of tokens to increase the allowance by.
350    */
351   function increaseApproval(
352     address _spender,
353     uint _addedValue
354   )
355     public
356     returns (bool)
357   {
358     allowed[msg.sender][_spender] = (
359       allowed[msg.sender][_spender].add(_addedValue));
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   /**
365    * @dev Decrease the amount of tokens that an owner allowed to a spender.
366    *
367    * approve should be called when allowed[_spender] == 0. To decrement
368    * allowed value is better to use this function to avoid 2 calls (and wait until
369    * the first transaction is mined)
370    * From MonolithDAO Token.sol
371    * @param _spender The address which will spend the funds.
372    * @param _subtractedValue The amount of tokens to decrease the allowance by.
373    */
374   function decreaseApproval(
375     address _spender,
376     uint _subtractedValue
377   )
378     public
379     returns (bool)
380   {
381     uint oldValue = allowed[msg.sender][_spender];
382     if (_subtractedValue > oldValue) {
383       allowed[msg.sender][_spender] = 0;
384     } else {
385       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
386     }
387     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388     return true;
389   }
390 
391 }
392 
393 
394 /**
395  * @title Mintable token
396  * @dev Simple ERC20 Token example, with mintable token creation
397  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
398  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
399  */
400 contract MintableToken is StandardToken, Ownable {
401   event Mint(address indexed to, uint256 amount);
402   event MintFinished();
403 
404   bool public mintingFinished = false;
405 
406 
407   modifier canMint() {
408     require(!mintingFinished);
409     _;
410   }
411 
412   modifier hasMintPermission() {
413     require(msg.sender == owner);
414     _;
415   }
416 
417   /**
418    * @dev Function to mint tokens
419    * @param _to The address that will receive the minted tokens.
420    * @param _amount The amount of tokens to mint.
421    * @return A boolean that indicates if the operation was successful.
422    */
423   function mint(
424     address _to,
425     uint256 _amount
426   )
427     hasMintPermission
428     canMint
429     public
430     returns (bool)
431   {
432     totalSupply_ = totalSupply_.add(_amount);
433     balances[_to] = balances[_to].add(_amount);
434     emit Mint(_to, _amount);
435     emit Transfer(address(0), _to, _amount);
436     return true;
437   }
438 
439   /**
440    * @dev Function to stop minting new tokens.
441    * @return True if the operation was successful.
442    */
443   function finishMinting() onlyOwner canMint public returns (bool) {
444     mintingFinished = true;
445     emit MintFinished();
446     return true;
447   }
448 }
449 
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  */
455 contract Pausable is Ownable {
456   event Pause();
457   event Unpause();
458 
459   bool public paused = false;
460 
461 
462   /**
463    * @dev Modifier to make a function callable only when the contract is not paused.
464    */
465   modifier whenNotPaused() {
466     require(!paused);
467     _;
468   }
469 
470   /**
471    * @dev Modifier to make a function callable only when the contract is paused.
472    */
473   modifier whenPaused() {
474     require(paused);
475     _;
476   }
477 
478   /**
479    * @dev called by the owner to pause, triggers stopped state
480    */
481   function pause() onlyOwner whenNotPaused public {
482     paused = true;
483     emit Pause();
484   }
485 
486   /**
487    * @dev called by the owner to unpause, returns to normal state
488    */
489   function unpause() onlyOwner whenPaused public {
490     paused = false;
491     emit Unpause();
492   }
493 }
494 
495 
496 /**
497  * @title Pausable token
498  * @dev StandardToken modified with pausable transfers.
499  **/
500 contract PausableToken is StandardToken, Pausable {
501 
502   function transfer(
503     address _to,
504     uint256 _value
505   )
506     public
507     whenNotPaused
508     returns (bool)
509   {
510     return super.transfer(_to, _value);
511   }
512 
513   function transferFrom(
514     address _from,
515     address _to,
516     uint256 _value
517   )
518     public
519     whenNotPaused
520     returns (bool)
521   {
522     return super.transferFrom(_from, _to, _value);
523   }
524 
525   function approve(
526     address _spender,
527     uint256 _value
528   )
529     public
530     whenNotPaused
531     returns (bool)
532   {
533     return super.approve(_spender, _value);
534   }
535 
536   function increaseApproval(
537     address _spender,
538     uint _addedValue
539   )
540     public
541     whenNotPaused
542     returns (bool success)
543   {
544     return super.increaseApproval(_spender, _addedValue);
545   }
546 
547   function decreaseApproval(
548     address _spender,
549     uint _subtractedValue
550   )
551     public
552     whenNotPaused
553     returns (bool success)
554   {
555     return super.decreaseApproval(_spender, _subtractedValue);
556   }
557 }
558 
559 
560 pragma solidity^0.4.18;
561 
562 
563 
564 
565   
566 contract AlphaconToken is CanReclaimToken, MintableToken, BurnableToken, PausableToken { 
567   string public name = "Alphacon Token";
568   string public symbol = "ALP";
569   uint8 public decimals = 18; 
570 }
571 
572 
573 /**
574  * @title Contracts that should not own Ether
575  * @author Remco Bloemen <remco@2π.com>
576  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
577  * in the contract, it will allow the owner to reclaim this ether.
578  * @notice Ether can still be sent to this contract by:
579  * calling functions labeled `payable`
580  * `selfdestruct(contract_address)`
581  * mining directly to the contract address
582  */
583 contract HasNoEther is Ownable {
584 
585   /**
586   * @dev Constructor that rejects incoming Ether
587   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
588   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
589   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
590   * we could use assembly to access msg.value.
591   */
592   constructor() public payable {
593     require(msg.value == 0);
594   }
595 
596   /**
597    * @dev Disallows direct send by settings a default function without the `payable` flag.
598    */
599   function() external {
600   }
601 
602   /**
603    * @dev Transfer all Ether held by the contract to the owner.
604    */
605   function reclaimEther() external onlyOwner {
606     owner.transfer(address(this).balance);
607   }
608 }
609 
610 
611 pragma solidity^0.4.24;
612 
613 
614 
615 
616 /**
617   * @title  AlphaconCustomToken
618   * @notice AlphaconCustomToken permits one more token generation after
619   *         token sale finalized. The generated token _amount is limited
620   *         up to 10% of total supply before the generation.
621   */
622 contract AlphaconCustomToken is HasNoEther, CanReclaimToken, AlphaconToken {
623   /* State */
624   bool public tokenGenerated;
625   uint256 public constant TARGET_TOTAL_SUPPLY = 25e27; // 25 Billion ALP
626 
627   /* Event */
628   event MintAfterSale(address _to, uint _preSupply, uint _postSupply);
629 
630   /* External */
631   /**
632     * @notice After crowdsale finalized, mint additional tokens for ESC-LOCK.
633     *         This generation only happens once.
634     */
635   function mintAfterSale() external onlyOwner returns (bool) {
636     require(!tokenGenerated);
637 
638     // valid only after finishMinting is executed
639     require(mintingFinished);
640 
641     // revert if total supply is more than TARGET_TOTAL_SUPPLY
642     uint256 preSupply = totalSupply();
643     require(preSupply < TARGET_TOTAL_SUPPLY);
644     uint256 amount = TARGET_TOTAL_SUPPLY.sub(preSupply);
645 
646     // mint token internally
647     totalSupply_ = TARGET_TOTAL_SUPPLY;
648     balances[owner] = balances[owner].add(amount);
649     emit Transfer(address(0), owner, amount);
650 
651     tokenGenerated = true;
652 
653     emit MintAfterSale(owner, preSupply, totalSupply());
654 
655     return true;
656   }
657 }