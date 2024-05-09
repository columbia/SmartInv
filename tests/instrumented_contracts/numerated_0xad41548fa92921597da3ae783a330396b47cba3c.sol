1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   uint256 public totalSupply;
133   function balanceOf(address who) public constant returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 
139 
140 
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public constant returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 
155 
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166 
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175 
176     // SafeMath.sub will throw if there is not enough balance.
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public constant returns (uint256 balance) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 
195 
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218 
219     uint256 _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    */
263   function increaseApproval (address _spender, uint _addedValue)
264     returns (bool success) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   function decreaseApproval (address _spender, uint _subtractedValue)
271     returns (bool success) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 
285 
286 /**
287  * @title Burnable Token
288  * @dev Token that can be irreversibly burned (destroyed).
289  */
290 contract BurnableToken is StandardToken {
291 
292     event Burn(address indexed burner, uint256 value);
293 
294     /**
295      * @dev Burns a specific amount of tokens.
296      * @param _value The amount of token to be burned.
297      */
298     function burn(uint256 _value) public {
299         require(_value > 0);
300 
301         address burner = msg.sender;
302         balances[burner] = balances[burner].sub(_value);
303         totalSupply = totalSupply.sub(_value);
304         Burn(burner, _value);
305     }
306 }
307 
308 // Quantstamp Technologies Inc. (info@quantstamp.com)
309 
310 
311 
312 /**
313  * The Quantstamp token (QSP) has a fixed supply and restricts the ability
314  * to transfer tokens until the owner has called the enableTransfer()
315  * function.
316  *
317  * The owner can associate the token with a token sale contract. In that
318  * case, the token balance is moved to the token sale contract, which
319  * in turn can transfer its tokens to contributors to the sale.
320  */
321 contract QuantstampToken is StandardToken, BurnableToken, Ownable {
322 
323     // Constants
324     string  public constant name = "Quantstamp Token";
325     string  public constant symbol = "QSP";
326     uint8   public constant decimals = 18;
327     uint256 public constant INITIAL_SUPPLY      = 1000000000 * (10 ** uint256(decimals));
328     uint256 public constant CROWDSALE_ALLOWANCE =  650000000 * (10 ** uint256(decimals));
329     uint256 public constant ADMIN_ALLOWANCE     =  350000000 * (10 ** uint256(decimals));
330 
331     // Properties
332     uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
333     uint256 public adminAllowance;          // the number of tokens available for the administrator
334     address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
335     address public adminAddr;               // the address of the token admin account
336     bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
337 
338     // Modifiers
339     modifier onlyWhenTransferEnabled() {
340         if (!transferEnabled) {
341             require(msg.sender == adminAddr || msg.sender == crowdSaleAddr);
342         }
343         _;
344     }
345 
346     /**
347      * The listed addresses are not valid recipients of tokens.
348      *
349      * 0x0           - the zero address is not valid
350      * this          - the contract itself should not receive tokens
351      * owner         - the owner has all the initial tokens, but cannot receive any back
352      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
353      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
354      */
355     modifier validDestination(address _to) {
356         require(_to != address(0x0));
357         require(_to != address(this));
358         require(_to != owner);
359         require(_to != address(adminAddr));
360         require(_to != address(crowdSaleAddr));
361         _;
362     }
363 
364     /**
365      * Constructor - instantiates token supply and allocates balanace of
366      * to the owner (msg.sender).
367      */
368     function QuantstampToken(address _admin) {
369         // the owner is a custodian of tokens that can
370         // give an allowance of tokens for crowdsales
371         // or to the admin, but cannot itself transfer
372         // tokens; hence, this requirement
373         require(msg.sender != _admin);
374 
375         totalSupply = INITIAL_SUPPLY;
376         crowdSaleAllowance = CROWDSALE_ALLOWANCE;
377         adminAllowance = ADMIN_ALLOWANCE;
378 
379         // mint all tokens
380         balances[msg.sender] = totalSupply;
381         Transfer(address(0x0), msg.sender, totalSupply);
382 
383         adminAddr = _admin;
384         approve(adminAddr, adminAllowance);
385     }
386 
387     /**
388      * Associates this token with a current crowdsale, giving the crowdsale
389      * an allowance of tokens from the crowdsale supply. This gives the
390      * crowdsale the ability to call transferFrom to transfer tokens to
391      * whomever has purchased them.
392      *
393      * Note that if _amountForSale is 0, then it is assumed that the full
394      * remaining crowdsale supply is made available to the crowdsale.
395      *
396      * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
397      * @param _amountForSale The supply of tokens provided to the crowdsale
398      */
399     function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
400         require(!transferEnabled);
401         require(_amountForSale <= crowdSaleAllowance);
402 
403         // if 0, then full available crowdsale supply is assumed
404         uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;
405 
406         // Clear allowance of old, and set allowance of new
407         approve(crowdSaleAddr, 0);
408         approve(_crowdSaleAddr, amount);
409 
410         crowdSaleAddr = _crowdSaleAddr;
411     }
412 
413     /**
414      * Enables the ability of anyone to transfer their tokens. This can
415      * only be called by the token owner. Once enabled, it is not
416      * possible to disable transfers.
417      */
418     function enableTransfer() external onlyOwner {
419         transferEnabled = true;
420         approve(crowdSaleAddr, 0);
421         approve(adminAddr, 0);
422         crowdSaleAllowance = 0;
423         adminAllowance = 0;
424     }
425 
426     /**
427      * Overrides ERC20 transfer function with modifier that prevents the
428      * ability to transfer tokens until after transfers have been enabled.
429      */
430     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
431         return super.transfer(_to, _value);
432     }
433 
434     /**
435      * Overrides ERC20 transferFrom function with modifier that prevents the
436      * ability to transfer tokens until after transfers have been enabled.
437      */
438     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
439         bool result = super.transferFrom(_from, _to, _value);
440         if (result) {
441             if (msg.sender == crowdSaleAddr)
442                 crowdSaleAllowance = crowdSaleAllowance.sub(_value);
443             if (msg.sender == adminAddr)
444                 adminAllowance = adminAllowance.sub(_value);
445         }
446         return result;
447     }
448 
449     /**
450      * Overrides the burn function so that it cannot be called until after
451      * transfers have been enabled.
452      *
453      * @param _value    The amount of tokens to burn in mini-QSP
454      */
455     function burn(uint256 _value) public {
456         require(transferEnabled || msg.sender == owner);
457         require(balances[msg.sender] >= _value);
458         super.burn(_value);
459         Transfer(msg.sender, address(0x0), _value);
460     }
461 }
462 
463 // Quantstamp Technologies Inc. (info@quantstamp.com)
464 
465 
466 
467 /**
468  * The QuantstampSale smart contract is used for selling QuantstampToken
469  * tokens (QSP). It does so by converting ETH received into a quantity of
470  * tokens that are transferred to the contributor via the ERC20-compatible
471  * transferFrom() function.
472  */
473 contract QuantstampMainSale is Pausable {
474 
475     using SafeMath for uint256;
476 
477     uint public constant RATE = 5000;       // constant for converting ETH to QSP
478     uint public constant GAS_LIMIT_IN_WEI = 50000000000 wei;
479 
480     bool public fundingCapReached = false;  // funding cap has been reached
481     bool public saleClosed = false;         // crowdsale is closed or not
482     bool private rentrancy_lock = false;    // prevent certain functions from recursize calls
483 
484     uint public fundingCap;                 // upper bound on amount that can be raised (in wei)
485     uint256 public cap;                     // individual cap during initial period of sale
486 
487     uint public minContribution;            // lower bound on amount a contributor can send (in wei)
488     uint public amountRaised;               // amount raised so far (in wei)
489     uint public refundAmount;               // amount that has been refunded so far
490 
491     uint public startTime;                  // UNIX timestamp for start of sale
492     uint public deadline;                   // UNIX timestamp for end (deadline) of sale
493     uint public capTime;                    // Initial time period when the cap restriction is on
494 
495     address public beneficiary;             // The beneficiary is the future recipient of the funds
496 
497     QuantstampToken public tokenReward;     // The token being sold
498 
499     mapping(address => uint256) public balanceOf;   // tracks the amount of wei contributed by address during all sales
500     mapping(address => uint256) public mainsaleBalanceOf; // tracks the amount of wei contributed by address during mainsale
501 
502     mapping(address => bool) public registry;       // Registry of wallet addresses from whitelist
503 
504     // Events
505     event CapReached(address _beneficiary, uint _amountRaised);
506     event FundTransfer(address _backer, uint _amount, bool _isContribution);
507     event RegistrationStatusChanged(address target, bool isRegistered);
508 
509     // Modifiers
510     modifier beforeDeadline()   { require (currentTime() < deadline); _; }
511     modifier afterDeadline()    { require (currentTime() >= deadline); _; }
512     modifier afterStartTime()   { require (currentTime() >= startTime); _; }
513     modifier saleNotClosed()    { require (!saleClosed); _; }
514 
515     modifier nonReentrant() {
516         require(!rentrancy_lock);
517         rentrancy_lock = true;
518         _;
519         rentrancy_lock = false;
520     }
521 
522     /**
523      * Constructor for a crowdsale of QuantstampToken tokens.
524      *
525      * @param ifSuccessfulSendTo            the beneficiary of the fund
526      * @param fundingCapInEthers            the cap (maximum) size of the fund
527      * @param minimumContributionInWei      minimum contribution (in wei)
528      * @param start                         the start time (UNIX timestamp)
529      * @param durationInMinutes             the duration of the crowdsale in minutes
530      * @param initialCap                    initial individual cap
531      * @param capDurationInMinutes          duration of initial individual cap
532      * @param addressOfTokenUsedAsReward    address of the token being sold
533      */
534     function QuantstampMainSale(
535         address ifSuccessfulSendTo,
536         uint fundingCapInEthers,
537         uint minimumContributionInWei,
538         uint start,
539         uint durationInMinutes,
540         uint initialCap,
541         uint capDurationInMinutes,
542         address addressOfTokenUsedAsReward
543     ) {
544         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
545         require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
546         require(durationInMinutes > 0);
547         beneficiary = ifSuccessfulSendTo;
548         fundingCap = fundingCapInEthers * 1 ether;
549         minContribution = minimumContributionInWei;
550         startTime = start;
551         deadline = start + (durationInMinutes * 1 minutes);
552         capTime = start + (capDurationInMinutes * 1 minutes);
553         cap = initialCap * 1 ether;
554         tokenReward = QuantstampToken(addressOfTokenUsedAsReward);
555     }
556 
557 
558     function () payable {
559         buy();
560     }
561 
562 
563     function buy()
564         payable
565         public
566         whenNotPaused
567         beforeDeadline
568         afterStartTime
569         saleNotClosed
570         nonReentrant
571     {
572         uint amount = msg.value;
573         require(amount >= minContribution);
574 
575         // ensure that the user adheres to whitelist restrictions
576         require(registry[msg.sender]);
577 
578         amountRaised = amountRaised.add(amount);
579 
580         //require(amountRaised <= fundingCap);
581         // if we overflow the fundingCap, transfer the overflow amount
582         if(amountRaised > fundingCap){
583             uint overflow = amountRaised.sub(fundingCap);
584             amount = amount.sub(overflow);
585             amountRaised = fundingCap;
586             // transfer overflow back to the user
587             msg.sender.transfer(overflow);
588         }
589 
590 
591         // Update the sender's balance of wei contributed and the total amount raised
592         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
593 
594         // Update the sender's cap balance
595         mainsaleBalanceOf[msg.sender] = mainsaleBalanceOf[msg.sender].add(amount);
596 
597 
598         if (currentTime() <= capTime) {
599             require(tx.gasprice <= GAS_LIMIT_IN_WEI);
600             require(mainsaleBalanceOf[msg.sender] <= cap);
601 
602         }
603 
604         // Transfer the tokens from the crowdsale supply to the sender
605         if (!tokenReward.transferFrom(tokenReward.owner(), msg.sender, amount.mul(RATE))) {
606             revert();
607         }
608 
609         FundTransfer(msg.sender, amount, true);
610         updateFundingCap();
611     }
612 
613     function setCap(uint _cap) public onlyOwner {
614         cap = _cap;
615     }
616 
617     /**
618      * @dev Sets registration status of an address for participation.
619      *
620      * @param contributor Address that will be registered/deregistered.
621      */
622     function registerUser(address contributor)
623         public
624         onlyOwner
625     {
626         require(contributor != address(0));
627         registry[contributor] = true;
628         RegistrationStatusChanged(contributor, true);
629     }
630 
631      /**
632      * @dev Remove registration status of an address for participation.
633      *
634      * NOTE: if the user made initial contributions to the crowdsale,
635      *       this will not return the previously allotted tokens.
636      *
637      * @param contributor Address to be unregistered.
638      */
639     function deactivate(address contributor)
640         public
641         onlyOwner
642     {
643         require(registry[contributor]);
644         registry[contributor] = false;
645         RegistrationStatusChanged(contributor, false);
646     }
647 
648     /**
649      * @dev Sets registration statuses of addresses for participation.
650      * @param contributors Addresses that will be registered/deregistered.
651      */
652     function registerUsers(address[] contributors)
653         external
654         onlyOwner
655     {
656         for (uint i = 0; i < contributors.length; i++) {
657             registerUser(contributors[i]);
658         }
659     }
660 
661     /**
662      * The owner can terminate the crowdsale at any time.
663      */
664     function terminate() external onlyOwner {
665         saleClosed = true;
666     }
667 
668     /**
669      * The owner can allocate the specified amount of tokens from the
670      * crowdsale allowance to the recipient (_to).
671      *
672      * NOTE: be extremely careful to get the amounts correct, which
673      * are in units of wei and mini-QSP. Every digit counts.
674      *
675      * @param _to            the recipient of the tokens
676      * @param amountWei     the amount contributed in wei
677      * @param amountMiniQsp the amount of tokens transferred in mini-QSP
678      */
679     function allocateTokens(address _to, uint amountWei, uint amountMiniQsp) public
680             onlyOwner nonReentrant
681     {
682         amountRaised = amountRaised.add(amountWei);
683         require(amountRaised <= fundingCap);
684 
685         balanceOf[_to] = balanceOf[_to].add(amountWei);
686 
687         if (!tokenReward.transferFrom(tokenReward.owner(), _to, amountMiniQsp)) {
688             revert();
689         }
690 
691         FundTransfer(_to, amountWei, true);
692         updateFundingCap();
693     }
694 
695 
696     /**
697      * The owner can call this function to withdraw the funds that
698      * have been sent to this contract. The funds will be sent to
699      * the beneficiary specified when the crowdsale was created.
700      */
701     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
702         uint balanceToSend = this.balance;
703         beneficiary.transfer(balanceToSend);
704         FundTransfer(beneficiary, balanceToSend, false);
705     }
706 
707     /**
708      * Checks if the funding cap has been reached. If it has, then
709      * the CapReached event is triggered.
710      */
711     function updateFundingCap() internal {
712         assert (amountRaised <= fundingCap);
713         if (amountRaised == fundingCap) {
714             // Check if the funding cap has been reached
715             fundingCapReached = true;
716             saleClosed = true;
717             CapReached(beneficiary, amountRaised);
718         }
719     }
720 
721     /**
722      * Returns the current time.
723      * Useful to abstract calls to "now" for tests.
724     */
725     function currentTime() constant returns (uint _currentTime) {
726         return now;
727     }
728 
729     function setDeadline(uint timestamp) public onlyOwner {
730         deadline = timestamp;
731     }
732 }