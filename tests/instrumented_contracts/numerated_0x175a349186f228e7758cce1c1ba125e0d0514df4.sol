1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   /**
73   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /**
116    @title ERC827 interface, an extension of ERC20 token standard
117 
118    Interface of a ERC827 token, following the ERC20 standard with extra
119    methods to transfer value and data and execute calls in transfers and
120    approvals.
121  */
122 contract ERC827 is ERC20 {
123 
124   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
125   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
126   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
127 
128 }
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) internal allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) public view returns (uint256) {
230     return allowed[_owner][_spender];
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
260     uint oldValue = allowed[msg.sender][_spender];
261     if (_subtractedValue > oldValue) {
262       allowed[msg.sender][_spender] = 0;
263     } else {
264       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265     }
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270 }
271 
272 /**
273    @title ERC827, an extension of ERC20 token standard
274 
275    Implementation the ERC827, following the ERC20 standard with extra
276    methods to transfer value and data and execute calls in transfers and
277    approvals.
278    Uses OpenZeppelin StandardToken.
279  */
280 contract ERC827Token is ERC827, StandardToken {
281 
282   /**
283      @dev Addition to ERC20 token methods. It allows to
284      approve the transfer of value and execute a call with the sent data.
285 
286      Beware that changing an allowance with this method brings the risk that
287      someone may use both the old and the new allowance by unfortunate
288      transaction ordering. One possible solution to mitigate this race condition
289      is to first reduce the spender's allowance to 0 and set the desired value
290      afterwards:
291      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292 
293      @param _spender The address that will spend the funds.
294      @param _value The amount of tokens to be spent.
295      @param _data ABI-encoded contract call to call `_to` address.
296 
297      @return true if the call function was executed successfully
298    */
299   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
300     require(_spender != address(this));
301 
302     super.approve(_spender, _value);
303 
304     require(_spender.call(_data));
305 
306     return true;
307   }
308 
309   /**
310      @dev Addition to ERC20 token methods. Transfer tokens to a specified
311      address and execute a call with the sent data on the same transaction
312 
313      @param _to address The address which you want to transfer to
314      @param _value uint256 the amout of tokens to be transfered
315      @param _data ABI-encoded contract call to call `_to` address.
316 
317      @return true if the call function was executed successfully
318    */
319   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
320     require(_to != address(this));
321 
322     super.transfer(_to, _value);
323 
324     require(_to.call(_data));
325     return true;
326   }
327 
328   /**
329      @dev Addition to ERC20 token methods. Transfer tokens from one address to
330      another and make a contract call on the same transaction
331 
332      @param _from The address which you want to send tokens from
333      @param _to The address which you want to transfer to
334      @param _value The amout of tokens to be transferred
335      @param _data ABI-encoded contract call to call `_to` address.
336 
337      @return true if the call function was executed successfully
338    */
339   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
340     require(_to != address(this));
341 
342     super.transferFrom(_from, _to, _value);
343 
344     require(_to.call(_data));
345     return true;
346   }
347 
348   /**
349    * @dev Addition to StandardToken methods. Increase the amount of tokens that
350    * an owner allowed to a spender and execute a call with the sent data.
351    *
352    * approve should be called when allowed[_spender] == 0. To increment
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _addedValue The amount of tokens to increase the allowance by.
358    * @param _data ABI-encoded contract call to call `_spender` address.
359    */
360   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
361     require(_spender != address(this));
362 
363     super.increaseApproval(_spender, _addedValue);
364 
365     require(_spender.call(_data));
366 
367     return true;
368   }
369 
370   /**
371    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
372    * an owner allowed to a spender and execute a call with the sent data.
373    *
374    * approve should be called when allowed[_spender] == 0. To decrement
375    * allowed value is better to use this function to avoid 2 calls (and wait until
376    * the first transaction is mined)
377    * From MonolithDAO Token.sol
378    * @param _spender The address which will spend the funds.
379    * @param _subtractedValue The amount of tokens to decrease the allowance by.
380    * @param _data ABI-encoded contract call to call `_spender` address.
381    */
382   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
383     require(_spender != address(this));
384 
385     super.decreaseApproval(_spender, _subtractedValue);
386 
387     require(_spender.call(_data));
388 
389     return true;
390   }
391 
392 }
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
399  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
400  */
401 contract MintableToken is StandardToken, Ownable {
402   event Mint(address indexed to, uint256 amount);
403   event MintFinished();
404 
405   bool public mintingFinished = false;
406 
407 
408   modifier canMint() {
409     require(!mintingFinished);
410     _;
411   }
412 
413   /**
414    * @dev Function to mint tokens
415    * @param _to The address that will receive the minted tokens.
416    * @param _amount The amount of tokens to mint.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
420     totalSupply_ = totalSupply_.add(_amount);
421     balances[_to] = balances[_to].add(_amount);
422     Mint(_to, _amount);
423     Transfer(address(0), _to, _amount);
424     return true;
425   }
426 
427   /**
428    * @dev Function to stop minting new tokens.
429    * @return True if the operation was successful.
430    */
431   function finishMinting() onlyOwner canMint public returns (bool) {
432     mintingFinished = true;
433     MintFinished();
434     return true;
435   }
436 }
437 
438 
439 /**
440  * @title Pausable
441  * @dev Base contract which allows children to implement an emergency stop mechanism.
442  */
443 contract Pausable is Ownable {
444   event Pause();
445   event Unpause();
446 
447   bool public paused = false;
448 
449 
450   /**
451    * @dev Modifier to make a function callable only when the contract is not paused.
452    */
453   modifier whenNotPaused() {
454     require(!paused);
455     _;
456   }
457 
458   /**
459    * @dev Modifier to make a function callable only when the contract is paused.
460    */
461   modifier whenPaused() {
462     require(paused);
463     _;
464   }
465 
466   /**
467    * @dev called by the owner to pause, triggers stopped state
468    */
469   function pause() onlyOwner whenNotPaused public {
470     paused = true;
471     Pause();
472   }
473 
474   /**
475    * @dev called by the owner to unpause, returns to normal state
476    */
477   function unpause() onlyOwner whenPaused public {
478     paused = false;
479     Unpause();
480   }
481 }
482 
483 
484 /**
485  * @title Pausable token
486  * @dev StandardToken modified with pausable transfers.
487  **/
488 contract PausableToken is StandardToken, Pausable {
489 
490   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
491     return super.transfer(_to, _value);
492   }
493 
494   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
495     return super.transferFrom(_from, _to, _value);
496   }
497 
498   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
499     return super.approve(_spender, _value);
500   }
501 
502   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
503     return super.increaseApproval(_spender, _addedValue);
504   }
505 
506   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
507     return super.decreaseApproval(_spender, _subtractedValue);
508   }
509 }
510 
511 
512 /**
513    @title Líf, the Winding Tree token
514 
515    Implementation of Líf, the ERC827 token for Winding Tree, an extension of the
516    ERC20 token with extra methods to transfer value and data to execute a call
517    on transfer.
518    Uses OpenZeppelin StandardToken, ERC827Token, MintableToken and PausableToken.
519  */
520 contract LifToken is StandardToken, ERC827Token, MintableToken, PausableToken {
521   // Token Name
522   string public constant NAME = "Líf";
523 
524   // Token Symbol
525   string public constant SYMBOL = "LIF";
526 
527   // Token decimals
528   uint public constant DECIMALS = 18;
529 
530   /**
531    * @dev Burns a specific amount of tokens.
532    *
533    * @param _value The amount of tokens to be burned.
534    */
535   function burn(uint256 _value) public whenNotPaused {
536 
537     require(_value <= balances[msg.sender]);
538 
539     balances[msg.sender] = balances[msg.sender].sub(_value);
540     totalSupply_ = totalSupply_.sub(_value);
541 
542     // a Transfer event to 0x0 can be useful for observers to keep track of
543     // all the Lif by just looking at those events
544     Transfer(msg.sender, address(0), _value);
545   }
546 
547   /**
548    * @dev Burns a specific amount of tokens of an address
549    * This function can be called only by the owner in the minting process
550    *
551    * @param _value The amount of tokens to be burned.
552    */
553   function burn(address burner, uint256 _value) public onlyOwner {
554 
555     require(!mintingFinished);
556 
557     require(_value <= balances[burner]);
558 
559     balances[burner] = balances[burner].sub(_value);
560     totalSupply_ = totalSupply_.sub(_value);
561 
562     // a Transfer event to 0x0 can be useful for observers to keep track of
563     // all the Lif by just looking at those events
564     Transfer(burner, address(0), _value);
565   }
566 }
567 
568 
569 /**
570    @title Vested Payment Schedule for LifToken
571 
572    An ownable vesting schedule for the LifToken, the tokens can only be
573    claimed by the owner. The contract has a start timestamp, a duration
574    of each period in seconds (it can be days, months, years), a total
575    amount of periods and a cliff. The available amount of tokens will
576    be calculated based on the balance of LifTokens of the contract at
577    that time.
578  */
579 
580 contract VestedPayment is Ownable {
581   using SafeMath for uint256;
582 
583   // When the vested schedule starts
584   uint256 public startTimestamp;
585 
586   // How many seconds each period will last
587   uint256 public secondsPerPeriod;
588 
589   // How many periods will have in total
590   uint256 public totalPeriods;
591 
592   // The amount of tokens to be vested in total
593   uint256 public tokens;
594 
595   // How many tokens were claimed
596   uint256 public claimed;
597 
598   // The token contract
599   LifToken public token;
600 
601   // Duration (in periods) of the initial cliff in the vesting schedule
602   uint256 public cliffDuration;
603 
604   /**
605      @dev Constructor.
606 
607      @param _startTimestamp see `startTimestamp`
608      @param _secondsPerPeriod see `secondsPerPeriod`
609      @param _totalPeriods see `totalPeriods
610      @param _cliffDuration see `cliffDuration`
611      @param _tokens see `tokens`
612      @param tokenAddress the address of the token contract
613    */
614   function VestedPayment(
615     uint256 _startTimestamp, uint256 _secondsPerPeriod,
616     uint256 _totalPeriods, uint256 _cliffDuration,
617     uint256 _tokens, address tokenAddress
618   ) {
619     require(_startTimestamp >= block.timestamp);
620     require(_secondsPerPeriod > 0);
621     require(_totalPeriods > 0);
622     require(tokenAddress != address(0));
623     require(_cliffDuration < _totalPeriods);
624     require(_tokens > 0);
625 
626     startTimestamp = _startTimestamp;
627     secondsPerPeriod = _secondsPerPeriod;
628     totalPeriods = _totalPeriods;
629     cliffDuration = _cliffDuration;
630     tokens = _tokens;
631     token = LifToken(tokenAddress);
632   }
633 
634   /**
635      @dev Get how many tokens are available to be claimed
636    */
637   function getAvailableTokens() public view returns (uint256) {
638     uint256 period = block.timestamp.sub(startTimestamp)
639       .div(secondsPerPeriod);
640 
641     if (period < cliffDuration) {
642       return 0;
643     } else if (period >= totalPeriods) {
644       return tokens.sub(claimed);
645     } else {
646       return tokens.mul(period.add(1)).div(totalPeriods).sub(claimed);
647     }
648   }
649 
650   /**
651      @dev Claim the tokens, they can be claimed only by the owner
652      of the contract
653 
654      @param amount how many tokens to be claimed
655    */
656   function claimTokens(uint256 amount) public onlyOwner {
657     assert(getAvailableTokens() >= amount);
658 
659     claimed = claimed.add(amount);
660     token.transfer(owner, amount);
661   }
662 
663 }
664 
665 
666 /**
667    @title Market Validation Mechanism (MVM)
668  */
669 contract LifMarketValidationMechanism is Ownable {
670   using SafeMath for uint256;
671 
672   // The Lif token contract
673   LifToken public lifToken;
674 
675   // The address of the foundation wallet. It can claim part of the eth funds
676   // following an exponential curve until the end of the MVM lifetime (24 or 48
677   // months). After that it can claim 100% of the remaining eth in the MVM.
678   address public foundationAddr;
679 
680   // The amount of wei that the MVM received initially
681   uint256 public initialWei;
682 
683   // Start timestamp since which the MVM begins to accept tokens via sendTokens
684   uint256 public startTimestamp;
685 
686   // Quantity of seconds in every period, usually equivalent to 30 days
687   uint256 public secondsPerPeriod;
688 
689   // Number of periods. It should be 24 or 48 (each period is roughly a month)
690   uint8 public totalPeriods;
691 
692   // The total amount of wei that was claimed by the foundation so far
693   uint256 public totalWeiClaimed = 0;
694 
695   // The price at which the MVM buys tokens at the beginning of its lifetime
696   uint256 public initialBuyPrice = 0;
697 
698   // Amount of tokens that were burned by the MVM
699   uint256 public totalBurnedTokens = 0;
700 
701   // Amount of wei that was reimbursed via sendTokens calls
702   uint256 public totalReimbursedWei = 0;
703 
704   // Total supply of tokens when the MVM was created
705   uint256 public originalTotalSupply;
706 
707   uint256 constant PRICE_FACTOR = 100000;
708 
709   // Has the MVM been funded by calling `fund`? It can be funded only once
710   bool public funded = false;
711 
712   // true when the market MVM is paused
713   bool public paused = false;
714 
715   // total amount of seconds that the MVM was paused
716   uint256 public totalPausedSeconds = 0;
717 
718   // the timestamp where the MVM was paused
719   uint256 public pausedTimestamp;
720 
721   uint256[] public periods;
722 
723   // Events
724   event Pause();
725   event Unpause(uint256 pausedSeconds);
726 
727   event ClaimedWei(uint256 claimedWei);
728   event SentTokens(address indexed sender, uint256 price, uint256 tokens, uint256 returnedWei);
729 
730   modifier whenNotPaused(){
731     assert(!paused);
732     _;
733   }
734 
735   modifier whenPaused(){
736     assert(paused);
737     _;
738   }
739 
740   /**
741      @dev Constructor
742 
743      @param lifAddr the lif token address
744      @param _startTimestamp see `startTimestamp`
745      @param _secondsPerPeriod see `secondsPerPeriod`
746      @param _totalPeriods see `totalPeriods`
747      @param _foundationAddr see `foundationAddr`
748     */
749   function LifMarketValidationMechanism(
750     address lifAddr, uint256 _startTimestamp, uint256 _secondsPerPeriod,
751     uint8 _totalPeriods, address _foundationAddr
752   ) {
753     require(lifAddr != address(0));
754     require(_startTimestamp > block.timestamp);
755     require(_secondsPerPeriod > 0);
756     require(_totalPeriods == 24 || _totalPeriods == 48);
757     require(_foundationAddr != address(0));
758 
759     lifToken = LifToken(lifAddr);
760     startTimestamp = _startTimestamp;
761     secondsPerPeriod = _secondsPerPeriod;
762     totalPeriods = _totalPeriods;
763     foundationAddr = _foundationAddr;
764 
765   }
766 
767   /**
768      @dev Receives the initial funding from the Crowdsale. Calculates the
769      initial buy price as initialWei / totalSupply
770     */
771   function fund() public payable onlyOwner {
772     assert(!funded);
773 
774     originalTotalSupply = lifToken.totalSupply();
775     initialWei = msg.value;
776     initialBuyPrice = initialWei.
777       mul(PRICE_FACTOR).
778       div(originalTotalSupply);
779 
780     funded = true;
781   }
782 
783   /**
784      @dev calculates the exponential distribution curve. It determines how much
785      wei can be distributed back to the foundation every month. It starts with
786      very low amounts ending with higher chunks at the end of the MVM lifetime
787     */
788   function calculateDistributionPeriods() public {
789     assert(totalPeriods == 24 || totalPeriods == 48);
790     assert(periods.length == 0);
791 
792     // Table with the max delta % that can be distributed back to the foundation on
793     // each period. It follows an exponential curve (starts with lower % and ends
794     // with higher %) to keep the funds in the MVM longer. deltas24
795     // is used when MVM lifetime is 24 months, deltas48 when it's 48 months.
796     // The sum is less than 100% because the last % is missing: after the last period
797     // the 100% remaining can be claimed by the foundation. Values multipled by 10^5
798 
799     uint256[24] memory accumDistribution24 = [
800       uint256(0), 18, 117, 351, 767, 1407,
801       2309, 3511, 5047, 6952, 9257, 11995,
802       15196, 18889, 23104, 27870, 33215, 39166,
803       45749, 52992, 60921, 69561, 78938, 89076
804     ];
805 
806     uint256[48] memory accumDistribution48 = [
807       uint256(0), 3, 18, 54, 117, 214, 351, 534,
808       767, 1056, 1406, 1822, 2308, 2869, 3510, 4234,
809       5046, 5950, 6950, 8051, 9256, 10569, 11994, 13535,
810       15195, 16978, 18888, 20929, 23104, 25416, 27870, 30468,
811       33214, 36112, 39165, 42376, 45749, 49286, 52992, 56869,
812       60921, 65150, 69560, 74155, 78937, 83909, 89075, 94438
813     ];
814 
815     for (uint8 i = 0; i < totalPeriods; i++) {
816 
817       if (totalPeriods == 24) {
818         periods.push(accumDistribution24[i]);
819       } else {
820         periods.push(accumDistribution48[i]);
821       }
822 
823     }
824   }
825 
826   /**
827      @dev Returns the current period as a number from 0 to totalPeriods
828 
829      @return the current period as a number from 0 to totalPeriods
830     */
831   function getCurrentPeriodIndex() public view returns(uint256) {
832     assert(block.timestamp >= startTimestamp);
833     return block.timestamp.sub(startTimestamp).
834       sub(totalPausedSeconds).
835       div(secondsPerPeriod);
836   }
837 
838   /**
839      @dev calculates the accumulated distribution percentage as of now,
840      following the exponential distribution curve
841 
842      @return the accumulated distribution percentage, used to calculate things
843      like the maximum amount that can be claimed by the foundation
844     */
845   function getAccumulatedDistributionPercentage() public view returns(uint256 percentage) {
846     uint256 period = getCurrentPeriodIndex();
847 
848     assert(period < totalPeriods);
849 
850     return periods[period];
851   }
852 
853   /**
854      @dev returns the current buy price at which the MVM offers to buy tokens to
855      burn them
856 
857      @return the current buy price (in eth/lif, multiplied by PRICE_FACTOR)
858     */
859   function getBuyPrice() public view returns (uint256 price) {
860     uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
861 
862     return initialBuyPrice.
863       mul(PRICE_FACTOR.sub(accumulatedDistributionPercentage)).
864       div(PRICE_FACTOR);
865   }
866 
867   /**
868      @dev Returns the maximum amount of wei that the foundation can claim. It's
869      a portion of the ETH that was not claimed by token holders
870 
871      @return the maximum wei claimable by the foundation as of now
872     */
873   function getMaxClaimableWeiAmount() public view returns (uint256) {
874     if (isFinished()) {
875       return this.balance;
876     } else {
877       uint256 claimableFromReimbursed = initialBuyPrice.
878         mul(totalBurnedTokens).div(PRICE_FACTOR).
879         sub(totalReimbursedWei);
880       uint256 currentCirculation = lifToken.totalSupply();
881       uint256 accumulatedDistributionPercentage = getAccumulatedDistributionPercentage();
882       uint256 maxClaimable = initialWei.
883         mul(accumulatedDistributionPercentage).div(PRICE_FACTOR).
884         mul(currentCirculation).div(originalTotalSupply).
885         add(claimableFromReimbursed);
886 
887       if (maxClaimable > totalWeiClaimed) {
888         return maxClaimable.sub(totalWeiClaimed);
889       } else {
890         return 0;
891       }
892     }
893   }
894 
895   /**
896      @dev allows to send tokens to the MVM in exchange of Eth at the price
897      determined by getBuyPrice. The tokens are burned
898     */
899   function sendTokens(uint256 tokens) public whenNotPaused {
900     require(tokens > 0);
901 
902     uint256 price = getBuyPrice();
903     uint256 totalWei = tokens.mul(price).div(PRICE_FACTOR);
904 
905     lifToken.transferFrom(msg.sender, address(this), tokens);
906     lifToken.burn(tokens);
907     totalBurnedTokens = totalBurnedTokens.add(tokens);
908 
909     SentTokens(msg.sender, price, tokens, totalWei);
910 
911     totalReimbursedWei = totalReimbursedWei.add(totalWei);
912     msg.sender.transfer(totalWei);
913   }
914 
915   /**
916      @dev Returns whether the MVM end-of-life has been reached. When that
917      happens no more tokens can be sent to the MVM and the foundation can claim
918      100% of the remaining balance in the MVM
919 
920      @return true if the MVM end-of-life has been reached
921     */
922   function isFinished() public view returns (bool finished) {
923     return getCurrentPeriodIndex() >= totalPeriods;
924   }
925 
926   /**
927      @dev Called from the foundation wallet to claim eth back from the MVM.
928      Maximum amount that can be claimed is determined by
929      getMaxClaimableWeiAmount
930     */
931   function claimWei(uint256 weiAmount) public whenNotPaused {
932     require(msg.sender == foundationAddr);
933 
934     uint256 claimable = getMaxClaimableWeiAmount();
935 
936     assert(claimable >= weiAmount);
937 
938     foundationAddr.transfer(weiAmount);
939 
940     totalWeiClaimed = totalWeiClaimed.add(weiAmount);
941 
942     ClaimedWei(weiAmount);
943   }
944 
945   /**
946      @dev Pauses the MVM. No tokens can be sent to the MVM and no eth can be
947      claimed from the MVM while paused. MVM total lifetime is extended by the
948      period it stays paused
949     */
950   function pause() public onlyOwner whenNotPaused {
951     paused = true;
952     pausedTimestamp = block.timestamp;
953 
954     Pause();
955   }
956 
957   /**
958      @dev Unpauses the MVM. See `pause` for more details about pausing
959     */
960   function unpause() public onlyOwner whenPaused {
961     uint256 pausedSeconds = block.timestamp.sub(pausedTimestamp);
962     totalPausedSeconds = totalPausedSeconds.add(pausedSeconds);
963     paused = false;
964 
965     Unpause(pausedSeconds);
966   }
967 
968 }
969 
970 /**
971    @title Crowdsale for the Lif Token Generation Event
972 
973    Implementation of the Lif Token Generation Event (TGE) Crowdsale: A 2 week
974    fixed price, uncapped token sale, with a discounted ratefor contributions
975    ìn the private presale and a Market Validation Mechanism that will receive
976    the funds over the USD 10M soft cap.
977    The crowdsale has a minimum cap of USD 5M which in case of not being reached
978    by purchases made during the 2 week period the token will not start operating
979    and all funds sent during that period will be made available to be claimed by
980    the originating addresses.
981    Funds up to the USD 10M soft cap will be sent to the Winding Tree Foundation
982    wallet at the end of the crowdsale.
983    Funds over that amount will be put in a MarketValidationMechanism (MVM) smart
984    contract that guarantees a price floor for a period of 2 or 4 years, allowing
985    any token holder to burn their tokens in exchange of part of the eth amount
986    sent during the TGE in exchange of those tokens.
987  */
988 contract LifCrowdsale is Ownable, Pausable {
989   using SafeMath for uint256;
990 
991   // The token being sold.
992   LifToken public token;
993 
994   // Beginning of the period where tokens can be purchased at rate `rate1`.
995   uint256 public startTimestamp;
996   // Moment after which the rate to buy tokens goes from `rate1` to `rate2`.
997   uint256 public end1Timestamp;
998   // Marks the end of the Token Generation Event.
999   uint256 public end2Timestamp;
1000 
1001   // Address of the Winding Tree Foundation wallet. Funds up to the soft cap are
1002   // sent to this address. It's also the address to which the MVM distributes
1003   // the funds that are made available month after month. An extra 5% of tokens
1004   // are put in a Vested Payment with this address as beneficiary, acting as a
1005   // long-term reserve for the foundation.
1006   address public foundationWallet;
1007 
1008   // Address of the Winding Tree Founders wallet. An extra 12.8% of tokens
1009   // are put in a Vested Payment with this address as beneficiary, with 1 year
1010   // cliff and 4 years duration.
1011   address public foundersWallet;
1012 
1013   // TGE min cap, in USD. Converted to wei using `weiPerUSDinTGE`.
1014   uint256 public minCapUSD = 5000000;
1015 
1016   // Maximun amount from the TGE that the foundation receives, in USD. Converted
1017   // to wei using `weiPerUSDinTGE`. Funds over this cap go to the MVM.
1018   uint256 public maxFoundationCapUSD = 10000000;
1019 
1020   // Maximum amount from the TGE that makes the MVM to last for 24 months. If
1021   // funds from the TGE exceed this amount, the MVM will last for 24 months.
1022   uint256 public MVM24PeriodsCapUSD = 40000000;
1023 
1024   // Conversion rate from USD to wei to use during the TGE.
1025   uint256 public weiPerUSDinTGE = 0;
1026 
1027   // Seconds before the TGE since when the corresponding USD to
1028   // wei rate cannot be set by the owner anymore.
1029   uint256 public setWeiLockSeconds = 0;
1030 
1031   // Quantity of Lif that is received in exchage of 1 Ether during the first
1032   // week of the 2 weeks TGE
1033   uint256 public rate1;
1034 
1035   // Quantity of Lif that is received in exchage of 1 Ether during the second
1036   // week of the 2 weeks TGE
1037   uint256 public rate2;
1038 
1039   // Amount of wei received in exchange of tokens during the 2 weeks TGE
1040   uint256 public weiRaised;
1041 
1042   // Amount of lif minted and transferred during the TGE
1043   uint256 public tokensSold;
1044 
1045   // Address of the vesting schedule for the foundation created at the
1046   // end of the crowdsale
1047   VestedPayment public foundationVestedPayment;
1048 
1049   // Address of the vesting schedule for founders created at the
1050   // end of the crowdsale
1051   VestedPayment public foundersVestedPayment;
1052 
1053   // Address of the MVM created at the end of the crowdsale
1054   LifMarketValidationMechanism public MVM;
1055 
1056   // Tracks the wei sent per address during the 2 week TGE. This is the amount
1057   // that can be claimed by each address in case the minimum cap is not reached
1058   mapping(address => uint256) public purchases;
1059 
1060   // Has the Crowdsale been finalized by a successful call to `finalize`?
1061   bool public isFinalized = false;
1062 
1063   /**
1064      @dev Event triggered (at most once) on a successful call to `finalize`
1065   **/
1066   event Finalized();
1067 
1068   /**
1069      @dev Event triggered every time a presale purchase is done
1070   **/
1071   event TokenPresalePurchase(address indexed beneficiary, uint256 weiAmount, uint256 rate);
1072 
1073   /**
1074      @dev Event triggered on every purchase during the TGE
1075 
1076      @param purchaser who paid for the tokens
1077      @param beneficiary who got the tokens
1078      @param value amount of wei paid
1079      @param amount amount of tokens purchased
1080    */
1081   event TokenPurchase(
1082     address indexed purchaser,
1083     address indexed beneficiary,
1084     uint256 value,
1085     uint256 amount
1086   );
1087 
1088   /**
1089      @dev Constructor. Creates the token in a paused state
1090 
1091      @param _startTimestamp see `startTimestamp`
1092      @param _end1Timestamp see `end1Timestamp`
1093      @param _end2Timestamp see `end2Timestamp
1094      @param _rate1 see `rate1`
1095      @param _rate2 see `rate2`
1096      @param _foundationWallet see `foundationWallet`
1097    */
1098   function LifCrowdsale(
1099     uint256 _startTimestamp,
1100     uint256 _end1Timestamp,
1101     uint256 _end2Timestamp,
1102     uint256 _rate1,
1103     uint256 _rate2,
1104     uint256 _setWeiLockSeconds,
1105     address _foundationWallet,
1106     address _foundersWallet
1107   ) {
1108 
1109     require(_startTimestamp > block.timestamp);
1110     require(_end1Timestamp > _startTimestamp);
1111     require(_end2Timestamp > _end1Timestamp);
1112     require(_rate1 > 0);
1113     require(_rate2 > 0);
1114     require(_setWeiLockSeconds > 0);
1115     require(_foundationWallet != address(0));
1116     require(_foundersWallet != address(0));
1117 
1118     token = new LifToken();
1119     token.pause();
1120 
1121     startTimestamp = _startTimestamp;
1122     end1Timestamp = _end1Timestamp;
1123     end2Timestamp = _end2Timestamp;
1124     rate1 = _rate1;
1125     rate2 = _rate2;
1126     setWeiLockSeconds = _setWeiLockSeconds;
1127     foundationWallet = _foundationWallet;
1128     foundersWallet = _foundersWallet;
1129   }
1130 
1131   /**
1132      @dev Set the wei per USD rate for the TGE. Has to be called by
1133      the owner up to `setWeiLockSeconds` before `startTimestamp`
1134 
1135      @param _weiPerUSD wei per USD rate valid during the TGE
1136    */
1137   function setWeiPerUSDinTGE(uint256 _weiPerUSD) public onlyOwner {
1138     require(_weiPerUSD > 0);
1139     assert(block.timestamp < startTimestamp.sub(setWeiLockSeconds));
1140 
1141     weiPerUSDinTGE = _weiPerUSD;
1142   }
1143 
1144   /**
1145      @dev Returns the current Lif per Eth rate during the TGE
1146 
1147      @return the current Lif per Eth rate or 0 when not in TGE
1148    */
1149   function getRate() public view returns (uint256) {
1150     if (block.timestamp < startTimestamp)
1151       return 0;
1152     else if (block.timestamp <= end1Timestamp)
1153       return rate1;
1154     else if (block.timestamp <= end2Timestamp)
1155       return rate2;
1156     else
1157       return 0;
1158   }
1159 
1160   /**
1161      @dev Fallback function, payable. Calls `buyTokens`
1162    */
1163   function () payable {
1164     buyTokens(msg.sender);
1165   }
1166 
1167   /**
1168      @dev Allows to get tokens during the TGE. Payable. The value is converted to
1169      Lif using the current rate obtained by calling `getRate()`.
1170 
1171      @param beneficiary Address to which Lif should be sent
1172    */
1173   function buyTokens(address beneficiary) public payable whenNotPaused validPurchase {
1174     require(beneficiary != address(0));
1175     assert(weiPerUSDinTGE > 0);
1176 
1177     uint256 weiAmount = msg.value;
1178 
1179     // get current price (it depends on current block number)
1180     uint256 rate = getRate();
1181 
1182     assert(rate > 0);
1183 
1184     // calculate token amount to be created
1185     uint256 tokens = weiAmount.mul(rate);
1186 
1187     // store wei amount in case of TGE min cap not reached
1188     weiRaised = weiRaised.add(weiAmount);
1189     purchases[beneficiary] = purchases[beneficiary].add(weiAmount);
1190     tokensSold = tokensSold.add(tokens);
1191 
1192     token.mint(beneficiary, tokens);
1193     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1194   }
1195 
1196   /**
1197      @dev Allows to add the address and the amount of wei sent by a contributor
1198      in the private presale. Can only be called by the owner before the beginning
1199      of TGE
1200 
1201      @param beneficiary Address to which Lif will be sent
1202      @param weiSent Amount of wei contributed
1203      @param rate Lif per ether rate at the moment of the contribution
1204    */
1205   function addPrivatePresaleTokens(
1206     address beneficiary, uint256 weiSent, uint256 rate
1207   ) public onlyOwner {
1208     require(block.timestamp < startTimestamp);
1209     require(beneficiary != address(0));
1210     require(weiSent > 0);
1211 
1212     // validate that rate is higher than TGE rate
1213     require(rate > rate1);
1214 
1215     uint256 tokens = weiSent.mul(rate);
1216 
1217     weiRaised = weiRaised.add(weiSent);
1218 
1219     token.mint(beneficiary, tokens);
1220 
1221     TokenPresalePurchase(beneficiary, weiSent, rate);
1222   }
1223 
1224   /**
1225      @dev Internal. Forwards funds to the foundation wallet and in case the soft
1226      cap was exceeded it also creates and funds the Market Validation Mechanism.
1227    */
1228   function forwardFunds() internal {
1229 
1230     // calculate the max amount of wei for the foundation
1231     uint256 foundationBalanceCapWei = maxFoundationCapUSD.mul(weiPerUSDinTGE);
1232 
1233     // If the minimiun cap for the MVM is not reached transfer all funds to foundation
1234     // else if the min cap for the MVM is reached, create it and send the remaining funds.
1235     // We use weiRaised to compare becuase that is the total amount of wei raised in all TGE
1236     // but we have to distribute the balance using `this.balance` because thats the amount
1237     // raised by the crowdsale
1238     if (weiRaised <= foundationBalanceCapWei) {
1239 
1240       foundationWallet.transfer(this.balance);
1241 
1242       mintExtraTokens(uint256(24));
1243 
1244     } else {
1245 
1246       uint256 mmFundBalance = this.balance.sub(foundationBalanceCapWei);
1247 
1248       // check how much preiods we have to use on the MVM
1249       uint8 MVMPeriods = 24;
1250       if (mmFundBalance > MVM24PeriodsCapUSD.mul(weiPerUSDinTGE))
1251         MVMPeriods = 48;
1252 
1253       foundationWallet.transfer(foundationBalanceCapWei);
1254 
1255       MVM = new LifMarketValidationMechanism(
1256         address(token), block.timestamp.add(30 minutes), 10 minutes, MVMPeriods, foundationWallet
1257       );
1258       MVM.calculateDistributionPeriods();
1259 
1260       mintExtraTokens(uint256(MVMPeriods));
1261 
1262       MVM.fund.value(mmFundBalance)();
1263       MVM.transferOwnership(foundationWallet);
1264 
1265     }
1266   }
1267 
1268   /**
1269      @dev Internal. Distribute extra tokens among founders,
1270      team and the foundation long-term reserve. Founders receive
1271      12.8% of tokens in a 4y (1y cliff) vesting schedule.
1272      Foundation long-term reserve receives 5% of tokens in a
1273      vesting schedule with the same duration as the MVM that
1274      starts when the MVM ends. An extra 7.2% is transferred to
1275      the foundation to be distributed among advisors and future hires
1276    */
1277   function mintExtraTokens(uint256 foundationMonthsStart) internal {
1278     // calculate how much tokens will the founders,
1279     // foundation and advisors will receive
1280     uint256 foundersTokens = token.totalSupply().mul(128).div(1000);
1281     uint256 foundationTokens = token.totalSupply().mul(50).div(1000);
1282     uint256 teamTokens = token.totalSupply().mul(72).div(1000);
1283 
1284     // create the vested payment schedule for the founders
1285     foundersVestedPayment = new VestedPayment(
1286       block.timestamp, 10 minutes, 48, 12, foundersTokens, token
1287     );
1288     token.mint(foundersVestedPayment, foundersTokens);
1289     foundersVestedPayment.transferOwnership(foundersWallet);
1290 
1291     // create the vested payment schedule for the foundation
1292     uint256 foundationPaymentStart = foundationMonthsStart.mul(10 minutes)
1293       .add(30 minutes);
1294     foundationVestedPayment = new VestedPayment(
1295       block.timestamp.add(foundationPaymentStart), 10 minutes,
1296       foundationMonthsStart, 0, foundationTokens, token
1297     );
1298     token.mint(foundationVestedPayment, foundationTokens);
1299     foundationVestedPayment.transferOwnership(foundationWallet);
1300 
1301     // transfer the token for advisors and future employees to the foundation
1302     token.mint(foundationWallet, teamTokens);
1303 
1304   }
1305 
1306   /**
1307      @dev Modifier
1308      ok if the transaction can buy tokens on TGE
1309    */
1310   modifier validPurchase() {
1311     bool withinPeriod = now >= startTimestamp && now <= end2Timestamp;
1312     bool nonZeroPurchase = msg.value != 0;
1313     assert(withinPeriod && nonZeroPurchase);
1314     _;
1315   }
1316 
1317   /**
1318      @dev Modifier
1319      ok when block.timestamp is past end2Timestamp
1320   */
1321   modifier hasEnded() {
1322     assert(block.timestamp > end2Timestamp);
1323     _;
1324   }
1325 
1326   /**
1327      @dev Modifier
1328      @return true if minCapUSD has been reached by contributions during the TGE
1329   */
1330   function funded() public view returns (bool) {
1331     assert(weiPerUSDinTGE > 0);
1332     return weiRaised >= minCapUSD.mul(weiPerUSDinTGE);
1333   }
1334 
1335   /**
1336      @dev Allows a TGE contributor to claim their contributed eth in case the
1337      TGE has finished without reaching the minCapUSD
1338    */
1339   function claimEth() public whenNotPaused hasEnded {
1340     require(isFinalized);
1341     require(!funded());
1342 
1343     uint256 toReturn = purchases[msg.sender];
1344     assert(toReturn > 0);
1345 
1346     purchases[msg.sender] = 0;
1347 
1348     msg.sender.transfer(toReturn);
1349   }
1350 
1351   /**
1352      @dev Allows the owner to return an purchase to a contributor
1353    */
1354   function returnPurchase(address contributor)
1355     public hasEnded onlyOwner
1356   {
1357     require(!isFinalized);
1358 
1359     uint256 toReturn = purchases[contributor];
1360     assert(toReturn > 0);
1361 
1362     uint256 tokenBalance = token.balanceOf(contributor);
1363 
1364     // Substract weiRaised and tokens sold
1365     weiRaised = weiRaised.sub(toReturn);
1366     tokensSold = tokensSold.sub(tokenBalance);
1367     token.burn(contributor, tokenBalance);
1368     purchases[contributor] = 0;
1369 
1370     contributor.transfer(toReturn);
1371   }
1372 
1373   /**
1374      @dev Finalizes the crowdsale, taking care of transfer of funds to the
1375      Winding Tree Foundation and creation and funding of the Market Validation
1376      Mechanism in case the soft cap was exceeded. It also unpauses the token to
1377      enable transfers. It can be called only once, after `end2Timestamp`
1378    */
1379   function finalize() public onlyOwner hasEnded {
1380     require(!isFinalized);
1381 
1382     // foward founds and unpause token only if minCap is reached
1383     if (funded()) {
1384 
1385       forwardFunds();
1386 
1387       // finish the minting of the token
1388       token.finishMinting();
1389 
1390       // transfer the ownership of the token to the foundation
1391       token.transferOwnership(owner);
1392 
1393     }
1394 
1395     Finalized();
1396     isFinalized = true;
1397   }
1398 
1399 }