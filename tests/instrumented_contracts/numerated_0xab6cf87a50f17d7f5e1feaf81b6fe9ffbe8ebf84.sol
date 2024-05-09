1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value);
23   function approve(address spender, uint256 value);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * Math operations with safety checks
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 
55   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
68     return a < b ? a : b;
69   }
70 
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances. 
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   /**
83    * @dev Fix for the ERC20 short address attack.
84    */
85   modifier onlyPayloadSize(uint256 size) {
86      if(msg.data.length < size + 4) {
87        throw;
88      }
89      _;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of. 
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) constant returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implemantation of the basic standart token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is BasicToken, ERC20 {
122 
123   mapping (address => mapping (address => uint256)) allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amout of tokens to be transfered
131    */
132   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
133     var _allowance = allowed[_from][msg.sender];
134 
135     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136     // if (_value > _allowance) throw;
137 
138     balances[_to] = balances[_to].add(_value);
139     balances[_from] = balances[_from].sub(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     Transfer(_from, _to, _value);
142   }
143 
144   /**
145    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) {
150 
151     // To change the approve amount you first have to reduce the addresses`
152     //  allowance to zero by calling `approve(_spender, 0)` if it is not
153     //  already 0 to mitigate the race condition described here:
154     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
156 
157     allowed[msg.sender][_spender] = _value;
158     Approval(msg.sender, _spender, _value);
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifing the amount of tokens still avaible for the spender.
166    */
167   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control 
176  * functions, this simplifies the implementation of "user permissions". 
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   /** 
183    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Ownable() {
187     owner = msg.sender;
188   }
189 
190 
191   /**
192    * @dev Throws if called by any account other than the owner. 
193    */
194   modifier onlyOwner() {
195     if (msg.sender != owner) {
196       throw;
197     }
198     _;
199   }
200 
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to. 
205    */
206   function transferOwnership(address newOwner) onlyOwner {
207     if (newOwner != address(0)) {
208       owner = newOwner;
209     }
210   }
211 
212 }
213 
214 /** 
215  * @title Contracts that should not own Tokens
216  * @author Remco Bloemen <remco@2π.com>
217  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
218  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
219  * owner to reclaim the tokens.
220  */
221 contract HasNoTokens is Ownable {
222 
223  /** 
224   * @dev Reject all ERC23 compatible tokens
225   * @param from_ address The address that is transferring the tokens
226   * @param value_ uint256 the amount of the specified token
227   * @param data_ Bytes The data passed from the caller.
228   */
229   function tokenFallback(address from_, uint256 value_, bytes data_) external {
230     throw;
231   }
232 
233   /**
234    * @dev Reclaim all ERC20Basic compatible tokens
235    * @param tokenAddr address The address of the token contract
236    */
237   function reclaimToken(address tokenAddr) external onlyOwner {
238     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
239     uint256 balance = tokenInst.balanceOf(this);
240     tokenInst.transfer(owner, balance);
241   }
242 }
243 
244 /** 
245  * @title Contracts that should not own Contracts
246  * @author Remco Bloemen <remco@2π.com>
247  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
248  * of this contract to reclaim ownership of the contracts.
249  */
250 contract HasNoContracts is Ownable {
251 
252   /**
253    * @dev Reclaim ownership of Ownable contracts
254    * @param contractAddr The address of the Ownable to be reclaimed.
255    */
256   function reclaimContract(address contractAddr) external onlyOwner {
257     Ownable contractInst = Ownable(contractAddr);
258     contractInst.transferOwnership(owner);
259   }
260 }
261 
262 /**
263  * MRV token, distributed by crowdsale. Token and crowdsale functionality are unified in a single
264  * contract, to make clear and restrict the conditions under which tokens can be created or destroyed.
265  * Derived from OpenZeppelin CrowdsaleToken template.
266  *
267  * Key Crowdsale Facts:
268  * 
269  * * MRV tokens will be sold at a rate of 5,000 per ETH.
270  *
271  * * All MRV token sales are final. No refunds can be issued by the contract.
272  *
273  * * Unless adjusted later by the crowdsale operator, up to 100 million tokens will be available.
274  *
275  * * An additional 5,000 tokens are reserved. 
276  *
277  * * Participate in the crowdsale by sending ETH to this contract, when the crowdsale is open.
278  *
279  * * Sending more ETH than required to purchase all the remaining tokens will fail.
280  *
281  * * Timers can be set to allow anyone to open/close the crowdsale at the proper time. The crowdsale
282  *   operator reserves the right to set, unset, and reset these timers at any time, for any reason,
283  *   and without notice.
284  *
285  * * The operator of the crowdsale has the ability to manually open it and close it, and reserves
286  *   the right to do so at any time, for any reason, and without notice.
287  *
288  * * The crowdsale cannot be reopened, and no tokens can be created, after the crowdsale closes.
289  *
290  * * The crowdsale operator reserves the right to adjust the decimal places of the MRV token at
291  *   any time after the crowdsale closes, for any reason, and without notice. MRV tokens are
292  *   initially divisible to 18 decimal places.
293  *
294  * * The crowdsale operator reserves the right to not open or close the crowdsale, not set the
295  *   open or close timer, and generally refrain from doing things that the contract would otherwise
296  *   authorize them to do.
297  *
298  * * The crowdsale operator reserves the right to claim and keep any ETH or tokens that end up in
299  *   the contract's account. During normal crowdsale operation, ETH is not stored in the contract's
300  *   account, and is instead sent directly to the beneficiary.
301  */
302 contract MRVToken is StandardToken, Ownable, HasNoTokens, HasNoContracts {
303 
304     // Token Parameters
305 
306     // From StandardToken we inherit balances and totalSupply.
307     
308     // What is the full name of the token?
309     string public constant name = "Macroverse Token";
310     // What is its suggested symbol?
311     string public constant symbol = "MRV";
312     // How many of the low base-10 digits are to the right of the decimal point?
313     // Note that this is not constant! After the crowdsale, the contract owner can
314     // adjust the decimal places, allowing for 10-to-1 splits and merges.
315     uint8 public decimals;
316     
317     // Crowdsale Parameters
318     
319     // Where will funds collected during the crowdsale be sent?
320     address beneficiary;
321     // How many MRV can be sold in the crowdsale?
322     uint public maxCrowdsaleSupplyInWholeTokens;
323     // How many whole tokens are reserved for the beneficiary?
324     uint public constant wholeTokensReserved = 5000;
325     // How many tokens per ETH during the crowdsale?
326     uint public constant wholeTokensPerEth = 5000;
327     
328     // Set to true when the crowdsale starts
329     // Internal flag. Use isCrowdsaleActive instead().
330     bool crowdsaleStarted;
331     // Set to true when the crowdsale ends
332     // Internal flag. Use isCrowdsaleActive instead().
333     bool crowdsaleEnded;
334     // We can also set some timers to open and close the crowdsale. 0 = timer is not set.
335     // After this time, the crowdsale will open with a call to checkOpenTimer().
336     uint public openTimer = 0;
337     // After this time, no contributions will be accepted, and the crowdsale will close with a call to checkCloseTimer().
338     uint public closeTimer = 0;
339     
340     ////////////
341     // Constructor
342     ////////////
343     
344     /**
345     * Deploy a new MRVToken contract, paying crowdsale proceeds to the given address,
346     * and awarding reserved tokens to the other given address.
347     */
348     function MRVToken(address sendProceedsTo, address sendTokensTo) {
349         // Proceeds of the crowdsale go here.
350         beneficiary = sendProceedsTo;
351         
352         // Start with 18 decimals, same as ETH
353         decimals = 18;
354         
355         // Initially, the reserved tokens belong to the given address.
356         totalSupply = wholeTokensReserved * 10 ** 18;
357         balances[sendTokensTo] = totalSupply;
358         
359         // Initially the crowdsale has not yet started or ended.
360         crowdsaleStarted = false;
361         crowdsaleEnded = false;
362         // Default to a max supply of 100 million tokens available.
363         maxCrowdsaleSupplyInWholeTokens = 100000000;
364     }
365     
366     ////////////
367     // Fallback function
368     ////////////
369     
370     /**
371     * This is the MAIN CROWDSALE ENTRY POINT. You participate in the crowdsale by 
372     * sending ETH to this contract. That calls this function, which credits tokens
373     * to the address or contract that sent the ETH.
374     *
375     * Since MRV tokens are sold at a rate of more than one per ether, and since
376     * they, like ETH, have 18 decimal places (at the time of sale), any fractional
377     * amount of ETH should be handled safely.
378     *
379     * Note that all orders are fill-or-kill. If you send in more ether than there are
380     * tokens remaining to be bought, your transaction will be rolled back and you will
381     * get no tokens and waste your gas.
382     */
383     function() payable onlyDuringCrowdsale {
384         createTokens(msg.sender);
385     }
386     
387     ////////////
388     // Events
389     ////////////
390     
391     // Fired when the crowdsale is recorded as started.
392     event CrowdsaleOpen(uint time);
393     // Fired when someone contributes to the crowdsale and buys MRV
394     event TokenPurchase(uint time, uint etherAmount, address from);
395     // Fired when the crowdsale is recorded as ended.
396     event CrowdsaleClose(uint time);
397     // Fired when the decimal point moves
398     event DecimalChange(uint8 newDecimals);
399     
400     ////////////
401     // Modifiers (encoding important crowdsale logic)
402     ////////////
403     
404     /**
405      * Only allow some actions before the crowdsale closes, whether it's open or not.
406      */
407     modifier onlyBeforeClosed {
408         checkCloseTimer();
409         if (crowdsaleEnded) throw;
410         _;
411     }
412     
413     /**
414      * Only allow some actions after the crowdsale is over.
415      * Will set the crowdsale closed if it should be.
416      */
417     modifier onlyAfterClosed {
418         checkCloseTimer();
419         if (!crowdsaleEnded) throw;
420         _;
421     }
422     
423     /**
424      * Only allow some actions before the crowdsale starts.
425      */
426     modifier onlyBeforeOpened {
427         checkOpenTimer();
428         if (crowdsaleStarted) throw;
429         _;
430     }
431     
432     /**
433      * Only allow some actions while the crowdsale is active.
434      * Will set the crowdsale open if it should be.
435      */
436     modifier onlyDuringCrowdsale {
437         checkOpenTimer();
438         checkCloseTimer();
439         if (crowdsaleEnded) throw;
440         if (!crowdsaleStarted) throw;
441         _;
442     }
443 
444     ////////////
445     // Status and utility functions
446     ////////////
447     
448     /**
449      * Determine if the crowdsale should open by timer.
450      */
451     function openTimerElapsed() constant returns (bool) {
452         return (openTimer != 0 && now > openTimer);
453     }
454     
455     /**
456      * Determine if the crowdsale should close by timer.
457      */
458     function closeTimerElapsed() constant returns (bool) {
459         return (closeTimer != 0 && now > closeTimer);
460     }
461     
462     /**
463      * If the open timer has elapsed, start the crowdsale.
464      * Can be called by people, but also gets called when people try to contribute.
465      */
466     function checkOpenTimer() {
467         if (openTimerElapsed()) {
468             crowdsaleStarted = true;
469             openTimer = 0;
470             CrowdsaleOpen(now);
471         }
472     }
473     
474     /**
475      * If the close timer has elapsed, stop the crowdsale.
476      */
477     function checkCloseTimer() {
478         if (closeTimerElapsed()) {
479             crowdsaleEnded = true;
480             closeTimer = 0;
481             CrowdsaleClose(now);
482         }
483     }
484     
485     /**
486      * Determine if the crowdsale is currently happening.
487      */
488     function isCrowdsaleActive() constant returns (bool) {
489         // The crowdsale is happening if it is open or due to open, and it isn't closed or due to close.
490         return ((crowdsaleStarted || openTimerElapsed()) && !(crowdsaleEnded || closeTimerElapsed()));
491     }
492     
493     ////////////
494     // Before the crowdsale: configuration
495     ////////////
496     
497     /**
498      * Before the crowdsale opens, the max token count can be configured.
499      */
500     function setMaxSupply(uint newMaxInWholeTokens) onlyOwner onlyBeforeOpened {
501         maxCrowdsaleSupplyInWholeTokens = newMaxInWholeTokens;
502     }
503     
504     /**
505      * Allow the owner to start the crowdsale manually.
506      */
507     function openCrowdsale() onlyOwner onlyBeforeOpened {
508         crowdsaleStarted = true;
509         openTimer = 0;
510         CrowdsaleOpen(now);
511     }
512     
513     /**
514      * Let the owner start the timer for the crowdsale start. Without further owner intervention,
515      * anyone will be able to open the crowdsale when the timer expires.
516      * Further calls will re-set the timer to count from the time the transaction is processed.
517      * The timer can be re-set after it has tripped, unless someone has already opened the crowdsale.
518      */
519     function setCrowdsaleOpenTimerFor(uint minutesFromNow) onlyOwner onlyBeforeOpened {
520         openTimer = now + minutesFromNow * 1 minutes;
521     }
522     
523     /**
524      * Let the owner stop the crowdsale open timer, as long as the crowdsale has not yet opened.
525      */
526     function clearCrowdsaleOpenTimer() onlyOwner onlyBeforeOpened {
527         openTimer = 0;
528     }
529     
530     /**
531      * Let the owner start the timer for the crowdsale end. Counts from when the function is called,
532      * *not* from the start of the crowdsale.
533      * It is possible, but a bad idea, to set this before the open timer.
534      */
535     function setCrowdsaleCloseTimerFor(uint minutesFromNow) onlyOwner onlyBeforeClosed {
536         closeTimer = now + minutesFromNow * 1 minutes;
537     }
538     
539     /**
540      * Let the owner stop the crowdsale close timer, as long as it has not yet expired.
541      */
542     function clearCrowdsaleCloseTimer() onlyOwner onlyBeforeClosed {
543         closeTimer = 0;
544     }
545     
546     
547     ////////////
548     // During the crowdsale
549     ////////////
550     
551     /**
552      * Create tokens for the given address, in response to a payment.
553      * Cannot be called by outside callers; use the fallback function, which will create tokens for whoever pays it.
554      */
555     function createTokens(address recipient) internal onlyDuringCrowdsale {
556         if (msg.value == 0) {
557             throw;
558         }
559 
560         uint tokens = msg.value.mul(wholeTokensPerEth); // Exploits the fact that we have 18 decimals, like ETH.
561         
562         var newTotalSupply = totalSupply.add(tokens);
563         
564         if (newTotalSupply > (wholeTokensReserved + maxCrowdsaleSupplyInWholeTokens) * 10 ** 18) {
565             // This would be too many tokens issued.
566             // Don't mess around with partial order fills.
567             throw;
568         }
569         
570         // Otherwise, we can fill the order entirely, so make the tokens and put them in the specified account.
571         totalSupply = newTotalSupply;
572         balances[recipient] = balances[recipient].add(tokens);
573         
574         // Announce the purchase
575         TokenPurchase(now, msg.value, recipient);
576 
577         // Lastly (after all state changes), send the money to the crowdsale beneficiary.
578         // This allows the crowdsale contract itself not to hold any ETH.
579         // It also means that ALL SALES ARE FINAL!
580         if (!beneficiary.send(msg.value)) {
581             throw;
582         }
583     }
584     
585     /**
586      * Allow the owner to end the crowdsale manually.
587      */
588     function closeCrowdsale() onlyOwner onlyDuringCrowdsale {
589         crowdsaleEnded = true;
590         closeTimer = 0;
591         CrowdsaleClose(now);
592     }  
593     
594     ////////////
595     // After the crowdsale: token maintainance
596     ////////////
597     
598     /**
599      * When the crowdsale is finished, the contract owner may adjust the decimal places for display purposes.
600      * This should work like a 10-to-1 split or reverse-split.
601      * The point of this mechanism is to keep the individual MRV tokens from getting inconveniently valuable or cheap.
602      * However, it relies on the contract owner taking the time to update the decimal place value.
603      * Note that this changes the decimals IMMEDIATELY with NO NOTICE to users.
604      */
605     function setDecimals(uint8 newDecimals) onlyOwner onlyAfterClosed {
606         decimals = newDecimals;
607         // Announce the change
608         DecimalChange(decimals);
609     }
610     
611     /**
612      * If Ether somehow manages to get into this contract, provide a way to get it out again.
613      * During normal crowdsale operation, ETH is immediately forwarded to the beneficiary.
614      */
615     function reclaimEther() external onlyOwner {
616         // Send the ETH. Make sure it worked.
617         assert(owner.send(this.balance));
618     }
619 
620 }