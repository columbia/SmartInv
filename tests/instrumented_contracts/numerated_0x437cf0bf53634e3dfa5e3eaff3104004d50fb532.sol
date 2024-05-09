1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances. 
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint;
76 
77   mapping(address => uint) balances;
78 
79   /**
80    * @dev Fix for the ERC20 short address attack.
81    */
82   modifier onlyPayloadSize(uint size) {
83      if(msg.data.length < size + 4) {
84        throw;
85      }
86      _;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of. 
103   * @return An uint representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) constant returns (uint);
120   function transferFrom(address from, address to, uint value);
121   function approve(address spender, uint value);
122   event Approval(address indexed owner, address indexed spender, uint value);
123 }
124 
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implemantation of the basic standart token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is BasicToken, ERC20 {
136 
137   mapping (address => mapping (address => uint)) allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint the amout of tokens to be transfered
145    */
146   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
147     var _allowance = allowed[_from][msg.sender];
148 
149     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150     // if (_value > _allowance) throw;
151 
152     balances[_to] = balances[_to].add(_value);
153     balances[_from] = balances[_from].sub(_value);
154     allowed[_from][msg.sender] = _allowance.sub(_value);
155     Transfer(_from, _to, _value);
156   }
157 
158   /**
159    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint _value) {
164 
165     // To change the approve amount you first have to reduce the addresses`
166     //  allowance to zero by calling `approve(_spender, 0)` if it is not
167     //  already 0 to mitigate the race condition described here:
168     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
170 
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens than an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint specifing the amount of tokens still avaible for the spender.
180    */
181   function allowance(address _owner, address _spender) constant returns (uint remaining) {
182     return allowed[_owner][_spender];
183   }
184 
185 }
186 
187 
188 /**
189  * @title LimitedTransferToken
190  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
191  * transferability for different events. It is intended to be used as a base class for other token 
192  * contracts. 
193  * LimitedTransferToken has been designed to allow for different limiting factors,
194  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
195  * hit. For example:
196  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
197  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
198  *     }
199  * A working example is VestedToken.sol:
200  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
201  */
202 
203 contract LimitedTransferToken is ERC20 {
204 
205   /**
206    * @dev Checks whether it can transfer or otherwise throws.
207    */
208   modifier canTransfer(address _sender, uint _value) {
209    if (_value > transferableTokens(_sender, uint64(now))) throw;
210    _;
211   }
212 
213   /**
214    * @dev Checks modifier and allows transfer if tokens are not locked.
215    * @param _to The address that will recieve the tokens.
216    * @param _value The amount of tokens to be transferred.
217    */
218   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
219     super.transfer(_to, _value);
220   }
221 
222   /**
223   * @dev Checks modifier and allows transfer if tokens are not locked.
224   * @param _from The address that will send the tokens.
225   * @param _to The address that will recieve the tokens.
226   * @param _value The amount of tokens to be transferred.
227   */
228   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
229     super.transferFrom(_from, _to, _value);
230   }
231 
232   /**
233    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
234    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
235    * specific logic for limiting token transferability for a holder over time.
236    */
237   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
238     return balanceOf(holder);
239   }
240 }
241 
242 
243 /**
244  * @title Vested token
245  * @dev Tokens that can be vested for a group of addresses.
246  */
247 contract VestedToken is StandardToken, LimitedTransferToken {
248 
249   uint256 MAX_GRANTS_PER_ADDRESS = 20;
250 
251   struct TokenGrant {
252     address granter;     // 20 bytes
253     uint256 value;       // 32 bytes
254     uint64 cliff;
255     uint64 vesting;
256     uint64 start;        // 3 * 8 = 24 bytes
257     bool revokable;
258     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
259   } // total 78 bytes = 3 sstore per operation (32 per sstore)
260 
261   mapping (address => TokenGrant[]) public grants;
262 
263   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
264 
265   /**
266    * @dev Grant tokens to a specified address
267    * @param _to address The address which the tokens will be granted to.
268    * @param _value uint256 The amount of tokens to be granted.
269    * @param _start uint64 Time of the beginning of the grant.
270    * @param _cliff uint64 Time of the cliff period.
271    * @param _vesting uint64 The vesting period.
272    */
273   function grantVestedTokens(
274     address _to,
275     uint256 _value,
276     uint64 _start,
277     uint64 _cliff,
278     uint64 _vesting,
279     bool _revokable,
280     bool _burnsOnRevoke
281   ) public {
282 
283     // Check for date inconsistencies that may cause unexpected behavior
284     if (_cliff < _start || _vesting < _cliff) {
285       throw;
286     }
287 
288     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
289 
290     uint count = grants[_to].push(
291                 TokenGrant(
292                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
293                   _value,
294                   _cliff,
295                   _vesting,
296                   _start,
297                   _revokable,
298                   _burnsOnRevoke
299                 )
300               );
301 
302     transfer(_to, _value);
303 
304     NewTokenGrant(msg.sender, _to, _value, count - 1);
305   }
306 
307   /**
308    * @dev Revoke the grant of tokens of a specifed address.
309    * @param _holder The address which will have its tokens revoked.
310    * @param _grantId The id of the token grant.
311    */
312   function revokeTokenGrant(address _holder, uint _grantId) public {
313     TokenGrant grant = grants[_holder][_grantId];
314 
315     if (!grant.revokable) { // Check if grant was revokable
316       throw;
317     }
318 
319     if (grant.granter != msg.sender) { // Only granter can revoke it
320       throw;
321     }
322 
323     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
324 
325     uint256 nonVested = nonVestedTokens(grant, uint64(now));
326 
327     // remove grant from array
328     delete grants[_holder][_grantId];
329     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
330     grants[_holder].length -= 1;
331 
332     balances[receiver] = balances[receiver].add(nonVested);
333     balances[_holder] = balances[_holder].sub(nonVested);
334 
335     Transfer(_holder, receiver, nonVested);
336   }
337 
338 
339   /**
340    * @dev Calculate the total amount of transferable tokens of a holder at a given time
341    * @param holder address The address of the holder
342    * @param time uint64 The specific time.
343    * @return An uint representing a holder's total amount of transferable tokens.
344    */
345   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
346     uint256 grantIndex = tokenGrantsCount(holder);
347 
348     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
349 
350     // Iterate through all the grants the holder has, and add all non-vested tokens
351     uint256 nonVested = 0;
352     for (uint256 i = 0; i < grantIndex; i++) {
353       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
354     }
355 
356     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
357     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
358 
359     // Return the minimum of how many vested can transfer and other value
360     // in case there are other limiting transferability factors (default is balanceOf)
361     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
362   }
363 
364   /**
365    * @dev Check the amount of grants that an address has.
366    * @param _holder The holder of the grants.
367    * @return A uint representing the total amount of grants.
368    */
369   function tokenGrantsCount(address _holder) constant returns (uint index) {
370     return grants[_holder].length;
371   }
372 
373   /**
374    * @dev Calculate amount of vested tokens at a specifc time.
375    * @param tokens uint256 The amount of tokens grantted.
376    * @param time uint64 The time to be checked
377    * @param start uint64 A time representing the begining of the grant
378    * @param cliff uint64 The cliff period.
379    * @param vesting uint64 The vesting period.
380    * @return An uint representing the amount of vested tokensof a specif grant.
381    *  transferableTokens
382    *   |                         _/--------   vestedTokens rect
383    *   |                       _/
384    *   |                     _/
385    *   |                   _/
386    *   |                 _/
387    *   |                /
388    *   |              .|
389    *   |            .  |
390    *   |          .    |
391    *   |        .      |
392    *   |      .        |
393    *   |    .          |
394    *   +===+===========+---------+----------> time
395    *      Start       Clift    Vesting
396    */
397   function calculateVestedTokens(
398     uint256 tokens,
399     uint256 time,
400     uint256 start,
401     uint256 cliff,
402     uint256 vesting) constant returns (uint256)
403     {
404       // Shortcuts for before cliff and after vesting cases.
405       if (time < cliff) return 0;
406       if (time >= vesting) return tokens;
407 
408       // Interpolate all vested tokens.
409       // As before cliff the shortcut returns 0, we can use just calculate a value
410       // in the vesting rect (as shown in above's figure)
411 
412       // vestedTokens = tokens * (time - start) / (vesting - start)
413       uint256 vestedTokens = SafeMath.div(
414                                     SafeMath.mul(
415                                       tokens,
416                                       SafeMath.sub(time, start)
417                                       ),
418                                     SafeMath.sub(vesting, start)
419                                     );
420 
421       return vestedTokens;
422   }
423 
424   /**
425    * @dev Get all information about a specifc grant.
426    * @param _holder The address which will have its tokens revoked.
427    * @param _grantId The id of the token grant.
428    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
429    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
430    */
431   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
432     TokenGrant grant = grants[_holder][_grantId];
433 
434     granter = grant.granter;
435     value = grant.value;
436     start = grant.start;
437     cliff = grant.cliff;
438     vesting = grant.vesting;
439     revokable = grant.revokable;
440     burnsOnRevoke = grant.burnsOnRevoke;
441 
442     vested = vestedTokens(grant, uint64(now));
443   }
444 
445   /**
446    * @dev Get the amount of vested tokens at a specific time.
447    * @param grant TokenGrant The grant to be checked.
448    * @param time The time to be checked
449    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
450    */
451   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
452     return calculateVestedTokens(
453       grant.value,
454       uint256(time),
455       uint256(grant.start),
456       uint256(grant.cliff),
457       uint256(grant.vesting)
458     );
459   }
460 
461   /**
462    * @dev Calculate the amount of non vested tokens at a specific time.
463    * @param grant TokenGrant The grant to be checked.
464    * @param time uint64 The time to be checked
465    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
466    * passed time frame.
467    */
468   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
469     return grant.value.sub(vestedTokens(grant, time));
470   }
471 
472   /**
473    * @dev Calculate the date when the holder can trasfer all its tokens
474    * @param holder address The address of the holder
475    * @return An uint representing the date of the last transferable tokens.
476    */
477   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
478     date = uint64(now);
479     uint256 grantIndex = grants[holder].length;
480     for (uint256 i = 0; i < grantIndex; i++) {
481       date = SafeMath.max64(grants[holder][i].vesting, date);
482     }
483   }
484 }
485 
486 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
487 // - Ensure max supply is 150,000,000
488 // - Ensure that even if not totalSupply is sold, tokens would still be transferrable after.
489 
490 // vesting: 365 days, 365 days / 4 vesting
491 
492 
493 contract BTN is VestedToken {
494   //FIELDS
495   string public name = "BETNetwork";
496   string public symbol = "BTN";
497   uint public decimals = 4;
498 
499   uint public constant STAGE_PRESALE_ETHRaised = 3500*1 ether; // Stage 1 Ether 10000
500   uint public constant STAGE_TWO_ETHRaised = 8500*1 ether; //  Stage 2 Ether 10000
501   uint public constant STAGE_THREE_ETHRaised = 14000*1 ether;
502   uint public constant STAGE_FOUR_ETHRaised = 20000*1 ether;
503   
504   // Multiplier for the decimals
505   uint private constant DECIMALS = 10000;
506 
507   //Prices of BTN
508   uint public constant PRICE_STANDARD    = 3128*DECIMALS; // BTN received per one ETH; MAX_SUPPLY / (valuation / ethPrice)
509   uint public constant PRICE_STAGE_PRESALE   = PRICE_STANDARD * 140/100; // 1ETH = 40% more BTN
510   uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 125/100; // 1ETH = 25% more BTN
511   uint public constant PRICE_STAGE_THREE = PRICE_STANDARD * 115/100; // 1ETH = 15% more BTN
512   uint public constant PRICE_STAGE_FOUR = PRICE_STANDARD * 105/100; // 1ETH = 5% more BTN
513   
514   //BTN Token Limits
515   uint public constant ALLOC_TEAM =         22500000*DECIMALS; // team
516   uint public constant ALLOC_RES =         22500000*DECIMALS; // Reserve
517   uint public constant ALLOC_CROWDSALE =    105000000*DECIMALS;
518   
519   //ASSIGNED IN INITIALIZATION
520   //Start and end times
521   uint public publicStartTime; // Time in seconds public crowd sale starts.
522   uint public publicEndTime; // Time in seconds BTN crowdsale ends
523   uint public hardcapInEth=30000* 1 ether;
524 
525   //Special Addresses
526   address public multisigAddress=0x2DD016668BD409B7E1988dFddC08388e448f1E90; // Address to which all ether fund flows.
527   address public BETNetworkTeamAddress=0xdCE5999988a40AF0f9E6b73EAF9D5a1DC01a24E9; // Address to which teams funds transferred.
528   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
529 
530 
531   //Running totals
532   uint public etherRaised; // Total Ether raised.
533   uint public BTNSold; // Total BTN created
534   
535   //booleans
536   bool public halted; // halts the crowd sale if true.
537 
538   // MODIFIERS
539   //Is currently in the period after the private start time and before the public start time.
540   modifier is_pre_crowdfund_period() {
541     if (now >= publicStartTime ) throw;
542     _;
543   }
544 
545   //Is currently the crowdfund period
546   modifier is_crowdfund_period() {
547     if (now < publicStartTime) throw;
548     if (isCrowdfundCompleted()) throw;
549     _;
550   }
551 
552   // Is completed
553   modifier is_crowdfund_completed() {
554     if (!isCrowdfundCompleted()) throw;
555     _;
556   }
557   function isCrowdfundCompleted() internal returns (bool) {
558     if (now > publicEndTime || BTNSold >= ALLOC_CROWDSALE || etherRaised >= hardcapInEth) return true;
559     return false;
560   }
561 
562   //May only be called by the owner address
563   modifier only_owner() {
564     if (msg.sender != ownerAddress) throw;
565     _;
566   }
567 
568   //May only be called if the crowdfund has not been halted
569   modifier is_not_halted() {
570     if (halted) throw;
571     _;
572   }
573 
574   // EVENTS
575   event Buy(address indexed _recipient, uint _amount);
576 
577   // Initialization contract assigns address of crowdfund contract and end time.
578   function BTN() {
579     ownerAddress = msg.sender;
580     publicStartTime = now;
581     publicEndTime = now + 6 weeks;
582     balances[BETNetworkTeamAddress] += ALLOC_TEAM;
583     balances[ownerAddress] += ALLOC_RES;
584     balances[ownerAddress] += ALLOC_CROWDSALE;
585   }
586 
587   // Transfer amount of tokens from sender account to recipient.
588   // Only callable after the crowd fund is completed
589   function transfer(address _to, uint _value)
590   {
591     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
592     if (!isCrowdfundCompleted()) throw;
593     super.transfer(_to, _value);
594   }
595 
596   // Transfer amount of tokens from a specified address to a recipient.
597   // Transfer amount of tokens from sender account to recipient.
598   function transferFrom(address _from, address _to, uint _value)
599     is_crowdfund_completed
600   {
601     super.transferFrom(_from, _to, _value);
602   }
603 
604   //constant function returns the current BTN price.
605   function getPriceRate()
606       constant
607       returns (uint o_rate)
608   {
609       uint delta = etherRaised;
610       if (delta < STAGE_PRESALE_ETHRaised) return PRICE_STAGE_PRESALE;
611       if (delta < STAGE_TWO_ETHRaised) return PRICE_STAGE_TWO;
612       if (delta < STAGE_THREE_ETHRaised) return PRICE_STAGE_THREE;
613        if (delta < STAGE_FOUR_ETHRaised) return PRICE_STAGE_FOUR;
614       return (PRICE_STANDARD);
615   }
616 
617   // calculates wmount of BTN we get, given the wei and the rates we've defined per 1 eth
618   function calcAmount(uint _wei, uint _rate) 
619     constant
620     returns (uint) 
621   {
622     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
623   } 
624   
625   // Given the rate of a purchase and the remaining tokens in this tranche, it
626   // will throw if the sale would take it past the limit of the tranche.
627   // Returns `amount` in scope as the number of BTN tokens that it will purchase.
628   function processPurchase(uint _rate, uint _remaining)
629     internal
630     returns (uint o_amount)
631   {
632     o_amount = calcAmount(msg.value, _rate);
633 
634     if (o_amount > _remaining) throw;
635     if (!multisigAddress.send(msg.value)) throw;
636 
637     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
638     balances[msg.sender] = balances[msg.sender].add(o_amount);
639 
640     BTNSold += o_amount;
641     etherRaised += msg.value;
642   }
643 
644   //Default function called by sending Ether to this address with no arguments.
645   //Results in creation of new BTN Tokens if transaction would not exceed hard limit of ADX Token.
646   function()
647     payable
648     is_crowdfund_period
649     is_not_halted
650   {
651     uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, BTNSold));
652     Buy(msg.sender, amount);
653   }
654 
655   // To be called at the end of crowdfund period
656   // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length
657   function grantVested(address _BETNetworkTeamAddress, address _BETNetworkFundAddress)
658     is_crowdfund_completed
659     only_owner
660     is_not_halted
661   {
662     // Grant tokens pre-allocated for the team
663     grantVestedTokens(
664       _BETNetworkTeamAddress, ALLOC_TEAM,
665       uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, 
666       false, false
667     );
668 
669     // Grant tokens that remain after crowdsale to the BETNetwork fund, vested for 2 years
670     grantVestedTokens(
671       _BETNetworkFundAddress, balances[ownerAddress],
672       uint64(now), uint64(now) + 182 days , uint64(now) + 730 days, 
673       false, false
674     );
675   }
676 
677   //May be used by owner of contract to halt crowdsale and no longer except ether.
678   function toggleHalt(bool _halted)
679     only_owner
680   {
681     halted = _halted;
682   }
683 
684   //failsafe drain
685   function drain()
686     only_owner
687   {
688     if (!ownerAddress.send(this.balance)) throw;
689   }
690 }