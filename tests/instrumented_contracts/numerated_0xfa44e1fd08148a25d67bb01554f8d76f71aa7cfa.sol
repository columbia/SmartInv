1 pragma solidity ^0.4.25;
2 
3 /**
4  * Digipay Network - The Future of Online Payments
5  * ----------------------------------------------------------------------------
6  */
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  * ----------------------------------------------------------------------------
13  */
14 contract Ownable {
15   address public owner;
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev if the owner calls this function, the function is executed
29    * and otherwise, an exception is thrown.
30    */
31   modifier onlyOwner() {  
32     require(msg.sender == owner);               
33     _;
34   }
35 
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  * ----------------------------------------------------------------------------
52  */
53 library SafeMath {
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76     }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev https://github.com/ethereum/EIPs/issues/179
82  * @dev This ERC describes a simpler version of the ERC20 standard token contract
83  * ----------------------------------------------------------------------------
84  */
85 
86 contract ERC20Basic {
87   
88   // The total token supply
89   function totalSupply() public view returns (uint256);
90 
91   // @notice Get the account balance of another account with address `who`
92   function balanceOf(address who) public view returns (uint256); 
93   
94   // @notice Transfer `value' amount of tokens to address `to`
95   function transfer(address to, uint256 value) public returns (bool);
96 
97   // @notice Triggered when tokens are transferred
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 
100 }
101 
102 /**
103  * @title ERC20 Standard
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * ----------------------------------------------------------------------------
106  */
107 
108 contract ERC20 is ERC20Basic {
109 
110   // @notice Returns the amount which `spender` is still allowed to withdraw from `owner`
111   function allowance(address owner, address spender) public view returns (uint256);
112 
113   // @notice Transfer `value` amount of tokens from address `from` to address `to`
114   // Address `to` can withdraw after it is approved by address `from`
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116 
117   // @notice Allow `spender` to withdraw, multiple times, up to the `value` amount
118   function approve(address spender, uint256 value) public returns (bool);
119 
120   // @notice Triggered whenever approve(address spender, uint256 value) is called
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 
123 }
124 
125 /**
126  * @title BasicToken
127  * @dev Simpler version of StandardToken, with basic functions
128  * ----------------------------------------------------------------------------
129  */
130 
131 contract BasicToken is ERC20Basic {
132 
133   using SafeMath for uint256;
134 
135   // @notice This creates an array with all balances
136   mapping(address => uint256) balances;
137 
138   // @notice Get the token balance of address `_owner`
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     
145     // @notice Prevent transfer to 0x0 address
146     require(_to != address(0));
147 
148     // @notice `Check if the sender has enough` is not needed
149     // because sub(balances[msg.sender], _value) will `throw` if this condition is not met
150     require(balances[msg.sender] >= _value);
151 
152     // @notice `Check for overflows` is not needed
153     // because add(_to, _value) will `throw` if this condition is not met
154     require(balances[_to] + _value >= balances[_to]);
155 
156     // @notice Subtract from the sender
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158 
159     // @notice Add the same to the recipient
160     balances[_to] = balances[_to].add(_value);
161 
162     // @notice Trigger `transfer` event
163     emit Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167 }
168 
169 
170 /**
171  * @title ERC20 Token Standard
172  * @dev Implementation of the Basic token standard
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  * ----------------------------------------------------------------------------
176  */
177 
178 contract StandardToken is ERC20, BasicToken {
179 
180   // @notice Owner of address approves the transfer of an amount to another address
181   mapping (address => mapping (address => uint256)) allowed;
182 
183   // @notice Owner allows `_spender` to transfer or withdraw `_value` tokens from owner to `_spender`
184   // Trigger `approve` event
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193 
194     uint256 _allowance = allowed[_from][msg.sender];
195 
196     // @notice This check is not needed 
197     // because sub(_allowance, _value) will throw if this condition is not met
198     require (_value <= _allowance);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = _allowance.sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   // @notice Returns the amount which `_spender` is still allowed to withdraw from `_owner`
208   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @notice Increase the amount of tokens that an owner allowed to a spender.
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
222     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226   
227   /**
228    * @notice Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 }
247 
248 /**
249  * @title tokensale.digipay.network TokenSaleKYC
250  * @dev Verified addresses can participate in the token sale
251  */
252 contract TokenSaleKYC is Ownable {
253     
254     // @dev This creates an array with all verification statuses of addresses 
255     mapping(address=>bool) public verified;
256 
257     //@dev Trigger `verification status` events
258     event VerificationStatusUpdated(address participant, bool verificationStatus);
259 
260     /**
261      * @dev Updates verification status of an address
262      * @dev Only owner can update
263      * @param participant Address that is submitted by a participant 
264      * @param verificationStatus True or false
265      */
266     function updateVerificationStatus(address participant, bool verificationStatus) public onlyOwner {
267         verified[participant] = verificationStatus;
268         emit VerificationStatusUpdated(participant, verificationStatus);
269     }
270 
271     /**
272      * @dev Updates verification statuses of addresses
273      * @dev Only owner can update
274      * @param participants An array of addresses
275      * @param verificationStatus True or false
276      */
277     function updateVerificationStatuses(address[] participants, bool verificationStatus) public onlyOwner {
278         for (uint i = 0; i < participants.length; i++) {
279             updateVerificationStatus(participants[i], verificationStatus);
280         }
281     }
282 }
283 
284 /**
285  * @title Pausable
286  * @dev Base contract which allows children to implement an emergency stop mechanism.
287  * ----------------------------------------------------------------------------
288  */
289 
290 contract Pausable is Ownable {
291   event Pause();
292   event Unpause();
293 
294   bool public paused = false;
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is not paused.
298    */
299   modifier whenNotPaused() {
300     require(!paused);
301     _;
302   }
303 
304   /**
305    * @dev Modifier to make a function callable only when the contract is paused.
306    */
307   modifier whenPaused() {
308     require(paused);
309     _;
310   }
311 
312   /**
313    * @dev called by the owner to pause, triggers stopped state
314    */
315   function pause() onlyOwner whenNotPaused public {
316     paused = true;
317     emit Pause();
318   }
319 
320   /**
321    * @dev called by the owner to unpause, returns to normal state
322    */
323   function unpause() onlyOwner whenPaused public {
324     paused = false;
325     emit Unpause();
326   }
327 }
328 
329 /**
330  * @title DigiPayToken contract
331  * @dev Allocate tokens to wallets based on our token distribution
332  * @dev Accept contributions only within a time frame
333  * @dev Participants must complete KYC process
334  * @dev There are two stages (Pre-sale and Mainsale)
335  * @dev Require minimum and maximum contributions
336  * @dev Calculate bonuses and rates
337  * @dev Can pause contributions
338  * @dev The token sale stops automatically when the hardcap is reached 
339  * @dev Lock (can not transfer) tokens until the token sale ends
340  * @dev Burn unsold tokens
341  * @dev Update the total supply after burning 
342  * @author digipay.network
343  * ----------------------------------------------------------------------------
344  */
345 contract DigiPayToken is StandardToken, Ownable, TokenSaleKYC, Pausable {
346   using SafeMath for uint256; 
347   string  public name;
348   string  public symbol;
349   uint8   public decimals;
350 
351   uint256 public weiRaised;
352   uint256 public hardCap;
353 
354   address public wallet;
355   address public TEAM_WALLET;
356   address public AIRDROP_WALLET;
357   address public RESERVE_WALLET;
358 
359   uint    internal _totalSupply;
360   uint    internal _teamAmount;
361   uint    internal _airdropAmount;
362   uint    internal _reserveAmount;
363 
364   uint256 internal presaleStartTime;
365   uint256 internal presaleEndTime;
366   uint256 internal mainsaleStartTime;
367   uint256 internal mainsaleEndTime;
368 
369   bool    internal presaleOpen;
370   bool    internal mainsaleOpen;
371   bool    internal Open;
372   bool    public   locked;
373   
374     /**
375      * event for token purchase logging
376      * @param purchaser who paid for the tokens
377      * @param value weis paid for purchase
378      * @param amount amount of tokens purchased
379      */
380     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
381     event Burn(address indexed burner, uint tokens);
382 
383     // @dev The token sale stops automatically when the hardcap is reached
384     modifier onlyWhileOpen {
385         require(now >= presaleStartTime && now <= mainsaleEndTime && Open && weiRaised <= hardCap);
386         _;
387     }
388     
389     // @dev Lock (can not transfer) tokens until the token sale ends
390     // Aidrop wallet and reserve wallet are allowed to transfer 
391     modifier onlyUnlocked() {
392         require(msg.sender == AIRDROP_WALLET || msg.sender == RESERVE_WALLET || msg.sender == owner || !locked);
393         _;
394     }
395 
396     /**
397      * ------------------------------------------------------------------------
398      * Constructor
399      * ------------------------------------------------------------------------
400      */
401     constructor (address _owner, address _wallet, address _team, address _airdrop, address _reserve) public {
402 
403         _setTimes();
404         
405         name = "DigiPay";
406         symbol = "DIP";
407         decimals = 18;
408         hardCap = 20000 ether;
409 
410         owner = _owner;
411         wallet = _wallet;
412         TEAM_WALLET = _team;
413         AIRDROP_WALLET = _airdrop;
414         RESERVE_WALLET = _reserve;
415 
416         // @dev initial total supply
417         _totalSupply = 180000000e18;
418         // @dev Tokens initialy allocated for the team (20%)
419         _teamAmount = 36000000e18;
420         // @dev Tokens initialy allocated for airdrop campaigns (8%)
421         _airdropAmount = 14400000e18;
422         // @dev Tokens initialy allocated for testing the platform (2%)
423         _reserveAmount = 3600000e18;
424 
425         balances[this] = totalSupply();
426         emit Transfer(address(0x0),this, totalSupply());
427         _transfer(TEAM_WALLET, _teamAmount);
428         _transfer(AIRDROP_WALLET, _airdropAmount);
429         _transfer(RESERVE_WALLET, _reserveAmount);
430 
431         Open = true;
432         locked = true;
433         
434     }
435 
436     function updateWallet(address _wallet) public onlyOwner {
437         wallet = _wallet;
438     }
439 
440     function totalSupply() public view returns (uint256) {
441         return _totalSupply;
442     }
443 
444     function _setTimes() internal {   
445         presaleStartTime          = 1541062800; // 01st Nov 2018 09:00:00 GMT
446         presaleEndTime            = 1543481999; // 29th Nov 2018 08:59:59 GMT
447         mainsaleStartTime         = 1545296400; // 20th Dec 2018 09:00:00 GMT
448         mainsaleEndTime           = 1548320399; // 24th Jan 2019 08:59:59 GMT
449     }
450 
451     function unlock() public onlyOwner {
452         locked = false;
453     }
454 
455     function lock() public onlyOwner {
456         locked = true;
457     }
458 
459     /**
460      * @dev override `transfer` function to add onlyUnlocked
461      * @param _to The address to transfer to.
462      * @param _value The amount to be transferred.
463      */
464     function transfer(address _to, uint _value) public onlyUnlocked returns (bool) {
465         return super.transfer(_to, _value);
466     }
467 
468     /**
469      * @dev override `transferFrom` function to add onlyUnlocked
470      * @param _from The address to transfer from.
471      * @param _to The address to transfer to.
472      * @param _value The amount to be transferred.
473      */
474     function transferFrom(address _from, address _to, uint _value) public onlyUnlocked returns (bool) {
475         return super.transferFrom(_from, _to, _value);
476     }
477 
478     // @dev Return `true` if the token sale is live
479     function _checkOpenings() internal {
480         
481         if(now >= presaleStartTime && now <= presaleEndTime) {
482             presaleOpen = true;
483             mainsaleOpen = false;
484         }
485         else if(now >= mainsaleStartTime && now <= mainsaleEndTime) {
486             presaleOpen = false;
487             mainsaleOpen = true;
488         }
489         else {
490             presaleOpen = false;
491             mainsaleOpen = false;
492         }
493     }
494     
495     // @dev Fallback function can be used to buy tokens
496     function () external payable {
497         buyTokens(msg.sender);
498     }
499 
500     function buyTokens(address _beneficiary) internal onlyWhileOpen whenNotPaused {
501     
502         // @dev `msg.value` contains the amount of wei sent in a transaction
503         uint256 weiAmount = msg.value;
504     
505         /** 
506          * @dev Validation of an incoming purchase
507          * @param _beneficiary Address performing the token purchase
508          * @param weiAmount Value in wei involved in the purchase
509          */
510         require(_beneficiary != address(0));
511         require(weiAmount != 0);
512     
513         _checkOpenings();
514 
515         /**
516          * @dev Check verification statuses of addresses
517          * @return True if participants can buy tokens, false otherwise
518          */
519         require(verified[_beneficiary]);
520 
521         require(presaleOpen || mainsaleOpen);
522         
523         if(presaleOpen) {
524             // @dev Presale contributions must be Min 2 ETH and Max 500 ETH
525             require(weiAmount >= 2e18  && weiAmount <= 5e20);
526         }
527         else {
528             // @dev Mainsale contributions must be Min 0.2 ETH and Max 500 ETH
529             require(weiAmount >= 2e17  && weiAmount <= 5e20);
530         }
531         
532         // @dev Calculate token amount to be returned
533         uint256 tokens = _getTokenAmount(weiAmount);
534         
535         // @dev Get more 10% bonus when purchasing more than 10 ETH
536         if(weiAmount >= 10e18) {
537             tokens = tokens.add(weiAmount.mul(500));
538         }
539         
540         // @dev Update funds raised
541         weiRaised = weiRaised.add(weiAmount);
542 
543         _processPurchase(_beneficiary, tokens);
544 
545         // @dev Trigger `token purchase` event
546         emit TokenPurchase(_beneficiary, weiAmount, tokens);
547 
548         _forwardFunds(msg.value);
549     }
550     
551     /**
552      * @dev Return an amount of tokens based on a current token rate
553      * @param _weiAmount Value in wei to be converted into tokens
554      */
555     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
556 
557         uint256 RATE;
558         if(presaleOpen) {
559             RATE = 7500; // @dev 1 ETH = 7500 DIP
560         }
561         
562         if(now >= mainsaleStartTime && now < (mainsaleStartTime + 1 weeks)) {
563             RATE = 6000; // @dev 1 ETH = 6000 DIP
564         }
565         
566         if(now >= (mainsaleStartTime + 1 weeks) && now < (mainsaleStartTime + 2 weeks)) {
567             RATE = 5750; // @dev 1 ETH = 5750 DIP
568         }
569         
570         if(now >= (mainsaleStartTime + 2 weeks) && now < (mainsaleStartTime + 3 weeks)) {
571             RATE = 5500; // @dev 1 ETH = 5500 DIP
572         }
573         
574         if(now >= (mainsaleStartTime + 3 weeks) && now < (mainsaleStartTime + 4 weeks)) {
575             RATE = 5250; // @dev 1 ETH = 5250 DIP
576         }
577         
578         if(now >= (mainsaleStartTime + 4 weeks) && now <= mainsaleEndTime) {
579             RATE = 5000; // @dev 1 ETH = 5000 DIP
580         }
581 
582         return _weiAmount.mul(RATE);
583     }
584     
585     /**
586      * @dev Source of tokens
587      * @param _beneficiary Address performing the token purchase
588      * @param _tokenAmount Number of tokens to be emitted
589      */
590     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
591         _transfer(_beneficiary, _tokenAmount);
592     }
593 
594     /**
595      * @dev Executed when a purchase has been validated and is ready to be executed
596      * @param _beneficiary Address receiving the tokens
597      * @param _tokenAmount Number of tokens to be purchased
598      */
599     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
600         _deliverTokens(_beneficiary, _tokenAmount);
601     }
602     
603     /**
604      * @dev Forward ether to the fund collection wallet
605      * @param _amount Amount of wei to be forwarded
606      */
607     function _forwardFunds(uint256 _amount) internal {
608         wallet.transfer(_amount);
609     }
610     
611     
612     /**
613      * @dev Transfer `tokens` from contract address to address `to`
614      */
615     function _transfer(address to, uint256 tokens) internal returns (bool success) {
616         require(to != 0x0);
617         require(balances[this] >= tokens );
618         require(balances[to] + tokens >= balances[to]);
619         balances[this] = balances[this].sub(tokens);
620         balances[to] = balances[to].add(tokens);
621         emit Transfer(this,to,tokens);
622         return true;
623     }
624     
625     /**
626      * @dev Allow owner to call an emergency stop
627      */
628     function stopTokenSale() public onlyOwner {
629         Open = false;
630     }
631     
632     /**
633      * @dev Allow owner to transfer free tokens from `AIRDROP_WALLET` to multiple wallet addresses
634      */
635     function sendtoMultiWallets(address[] _addresses, uint256[] _values) public onlyOwner {
636         require(_addresses.length == _values.length);
637         for (uint256 i = 0; i < _addresses.length; i++) {
638             // @dev Update balances and trigger `transfer` events
639             balances[AIRDROP_WALLET] = balances[AIRDROP_WALLET].sub(_values[i]*10**uint(decimals));
640             balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]*10**uint(decimals));
641             emit Transfer(AIRDROP_WALLET, _addresses[i], _values[i]*10**uint(decimals));
642         }
643     }
644     
645     /**
646      * @dev Transfer the unsold tokens from contract address
647      * @dev This function can be used only if the token sale does not reach Softcap
648      */
649     function drainRemainingToken(address _to, uint256 _value) public onlyOwner {
650        require(now > mainsaleEndTime);
651        _transfer(_to, _value);
652     }
653     
654     /**
655      * @dev Burn unsold tokens
656      * @param _value The remaining amount to be burned
657      */
658     function burnRemainingToken(uint256 _value) public onlyOwner returns (bool) {
659         balances[this] = balances[this].sub(_value);
660         _totalSupply = _totalSupply.sub(_value);
661         emit Burn(this, _value);
662         emit Transfer(this, address(0x0), _value);
663         return true;
664     }
665 
666 }