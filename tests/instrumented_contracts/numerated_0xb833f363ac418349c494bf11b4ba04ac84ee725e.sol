1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6  * Math operations with safety checks
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal returns (uint) {
16     // assert(b > 0); // Solidity automatically revert()s when dividing by 0
17     uint c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49 }
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20Basic {
58   uint public totalSupply;
59   function balanceOf(address who) constant returns (uint);
60   function transfer(address to, uint value);
61   event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances. 
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint;
73 
74   mapping(address => uint) balances;
75 
76   /**
77    * @dev Fix for the ERC20 short address attack.
78    */
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length < size + 4) {
81        revert();
82      }
83      _;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of. 
100   * @return An uint representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) constant returns (uint balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint);
117   function transferFrom(address from, address to, uint value);
118   function approve(address spender, uint value);
119   event Approval(address indexed owner, address indexed spender, uint value);
120 }
121 
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implemantation of the basic standart token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is BasicToken, ERC20 {
133 
134   mapping (address => mapping (address => uint)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // if (_value > _allowance) revert();
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153   }
154 
155   /**
156    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint _value) {
161 
162     // To change the approve amount you first have to reduce the addresses`
163     //  allowance to zero by calling `approve(_spender, 0)` if it is not
164     //  already 0 to mitigate the race condition described here:
165     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
167 
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens than an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint specifing the amount of tokens still avaible for the spender.
177    */
178   function allowance(address _owner, address _spender) constant returns (uint remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182 }
183 
184 
185 /**
186  * @title LimitedTransferToken
187  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
188  * transferability for different events. It is intended to be used as a base class for other token 
189  * contracts. 
190  * LimitedTransferToken has been designed to allow for different limiting factors,
191  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
192  * hit. For example:
193  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
194  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
195  *     }
196  * A working example is VestedToken.sol:
197  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
198  */
199 
200 contract LimitedTransferToken is ERC20 {
201 
202   /**
203    * @dev Checks whether it can transfer or otherwise throws.
204    */
205   modifier canTransfer(address _sender, uint _value) {
206    if (_value > transferableTokens(_sender, uint64(now))) revert();
207    _;
208   }
209 
210   /**
211    * @dev Checks modifier and allows transfer if tokens are not locked.
212    * @param _to The address that will recieve the tokens.
213    * @param _value The amount of tokens to be transferred.
214    */
215   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
216     super.transfer(_to, _value);
217   }
218 
219   /**
220   * @dev Checks modifier and allows transfer if tokens are not locked.
221   * @param _from The address that will send the tokens.
222   * @param _to The address that will recieve the tokens.
223   * @param _value The amount of tokens to be transferred.
224   */
225   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
226     super.transferFrom(_from, _to, _value);
227   }
228 
229   /**
230    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
231    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
232    * specific logic for limiting token transferability for a holder over time.
233    */
234   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
235     time;
236     return balanceOf(holder);
237   }
238 }
239 
240 
241 /**
242  * @title Vested token
243  * @dev Tokens that can be vested for a group of addresses.
244  */
245 contract VestedToken is StandardToken, LimitedTransferToken {
246 
247   uint256 MAX_GRANTS_PER_ADDRESS = 20;
248 
249   struct TokenGrant {
250     address granter;     // 20 bytes
251     uint256 value;       // 32 bytes
252     uint64 cliff;
253     uint64 vesting;
254     uint64 start;        // 3 * 8 = 24 bytes
255     bool revokable;
256     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
257   } // total 78 bytes = 3 sstore per operation (32 per sstore)
258 
259   mapping (address => TokenGrant[]) public grants;
260 
261   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
262 
263   /**
264    * @dev Grant tokens to a specified address
265    * @param _to address The address which the tokens will be granted to.
266    * @param _value uint256 The amount of tokens to be granted.
267    * @param _start uint64 Time of the beginning of the grant.
268    * @param _cliff uint64 Time of the cliff period.
269    * @param _vesting uint64 The vesting period.
270    */
271   function grantVestedTokens(
272     address _to,
273     uint256 _value,
274     uint64 _start,
275     uint64 _cliff,
276     uint64 _vesting,
277     bool _revokable,
278     bool _burnsOnRevoke
279   ) public {
280 
281     // Check for date inconsistencies that may cause unexpected behavior
282     if (_cliff < _start || _vesting < _cliff) {
283       revert();
284     }
285 
286     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) revert();   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
287 
288     uint count = grants[_to].push(
289                 TokenGrant(
290                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
291                   _value,
292                   _cliff,
293                   _vesting,
294                   _start,
295                   _revokable,
296                   _burnsOnRevoke
297                 )
298               );
299 
300     transfer(_to, _value);
301 
302     NewTokenGrant(msg.sender, _to, _value, count - 1);
303   }
304 
305   /**
306    * @dev Revoke the grant of tokens of a specifed address.
307    * @param _holder The address which will have its tokens revoked.
308    * @param _grantId The id of the token grant.
309    */
310   function revokeTokenGrant(address _holder, uint _grantId) public {
311     TokenGrant storage grant = grants[_holder][_grantId];
312 
313     if (!grant.revokable) { // Check if grant was revokable
314       revert();
315     }
316 
317     if (grant.granter != msg.sender) { // Only granter can revoke it
318       revert();
319     }
320 
321     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
322 
323     uint256 nonVested = nonVestedTokens(grant, uint64(now));
324 
325     // remove grant from array
326     delete grants[_holder][_grantId];
327     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
328     grants[_holder].length -= 1;
329 
330     balances[receiver] = balances[receiver].add(nonVested);
331     balances[_holder] = balances[_holder].sub(nonVested);
332 
333     Transfer(_holder, receiver, nonVested);
334   }
335 
336 
337   /**
338    * @dev Calculate the total amount of transferable tokens of a holder at a given time
339    * @param holder address The address of the holder
340    * @param time uint64 The specific time.
341    * @return An uint representing a holder's total amount of transferable tokens.
342    */
343   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
344     uint256 grantIndex = tokenGrantsCount(holder);
345 
346     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
347 
348     // Iterate through all the grants the holder has, and add all non-vested tokens
349     uint256 nonVested = 0;
350     for (uint256 i = 0; i < grantIndex; i++) {
351       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
352     }
353 
354     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
355     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
356 
357     // Return the minimum of how many vested can transfer and other value
358     // in case there are other limiting transferability factors (default is balanceOf)
359     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
360   }
361 
362   /**
363    * @dev Check the amount of grants that an address has.
364    * @param _holder The holder of the grants.
365    * @return A uint representing the total amount of grants.
366    */
367   function tokenGrantsCount(address _holder) constant returns (uint index) {
368     return grants[_holder].length;
369   }
370 
371   /**
372    * @dev Calculate amount of vested tokens at a specifc time.
373    * @param tokens uint256 The amount of tokens grantted.
374    * @param time uint64 The time to be checked
375    * @param start uint64 A time representing the begining of the grant
376    * @param cliff uint64 The cliff period.
377    * @param vesting uint64 The vesting period.
378    * @return An uint representing the amount of vested tokensof a specif grant.
379    *  transferableTokens
380    *   |                         _/--------   vestedTokens rect
381    *   |                       _/
382    *   |                     _/
383    *   |                   _/
384    *   |                 _/
385    *   |                /
386    *   |              .|
387    *   |            .  |
388    *   |          .    |
389    *   |        .      |
390    *   |      .        |
391    *   |    .          |
392    *   +===+===========+---------+----------> time
393    *      Start       Clift    Vesting
394    */
395   function calculateVestedTokens(
396     uint256 tokens,
397     uint256 time,
398     uint256 start,
399     uint256 cliff,
400     uint256 vesting) constant returns (uint256)
401     {
402       // Shortcuts for before cliff and after vesting cases.
403       if (time < cliff) return 0;
404       if (time >= vesting) return tokens;
405 
406       // Interpolate all vested tokens.
407       // As before cliff the shortcut returns 0, we can use just calculate a value
408       // in the vesting rect (as shown in above's figure)
409 
410       // vestedTokens = tokens * (time - start) / (vesting - start)
411       uint256 vestedTokens = SafeMath.div(
412                                     SafeMath.mul(
413                                       tokens,
414                                       SafeMath.sub(time, start)
415                                       ),
416                                     SafeMath.sub(vesting, start)
417                                     );
418 
419       return vestedTokens;
420   }
421 
422   /**
423    * @dev Get all information about a specifc grant.
424    * @param _holder The address which will have its tokens revoked.
425    * @param _grantId The id of the token grant.
426    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
427    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
428    */
429   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
430     TokenGrant storage grant = grants[_holder][_grantId];
431 
432     granter = grant.granter;
433     value = grant.value;
434     start = grant.start;
435     cliff = grant.cliff;
436     vesting = grant.vesting;
437     revokable = grant.revokable;
438     burnsOnRevoke = grant.burnsOnRevoke;
439 
440     vested = vestedTokens(grant, uint64(now));
441   }
442 
443   /**
444    * @dev Get the amount of vested tokens at a specific time.
445    * @param grant TokenGrant The grant to be checked.
446    * @param time The time to be checked
447    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
448    */
449   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
450     return calculateVestedTokens(
451       grant.value,
452       uint256(time),
453       uint256(grant.start),
454       uint256(grant.cliff),
455       uint256(grant.vesting)
456     );
457   }
458 
459   /**
460    * @dev Calculate the amount of non vested tokens at a specific time.
461    * @param grant TokenGrant The grant to be checked.
462    * @param time uint64 The time to be checked
463    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
464    * passed time frame.
465    */
466   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
467     return grant.value.sub(vestedTokens(grant, time));
468   }
469 
470   /**
471    * @dev Calculate the date when the holder can trasfer all its tokens
472    * @param holder address The address of the holder
473    * @return An uint representing the date of the last transferable tokens.
474    */
475   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
476     date = uint64(now);
477     uint256 grantIndex = grants[holder].length;
478     for (uint256 i = 0; i < grantIndex; i++) {
479       date = SafeMath.max64(grants[holder][i].vesting, date);
480     }
481   }
482 }
483 
484 // QUESTIONS FOR AUDITORS:
485 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
486 // - Ensure max supply is 100,000,000
487 // - Ensure that even if not totalSupply is sold, tokens would still be transferrable after (we will up to totalSupply by creating DAN-Service tokens)
488 
489 // vesting: 365 days, 365 days / 4 vesting
490 
491 
492 contract DANSToken is VestedToken {
493   //FIELDS
494   string public name = "DAN-Service coin";
495   string public symbol = "DANS";
496   uint public decimals = 4;
497   
498   //CONSTANTS
499   //Time limits
500   uint public constant CROWDSALE_DURATION = 60 days;
501   uint public constant STAGE_ONE_TIME_END = 24 hours; // first day bonus
502   uint public constant STAGE_TWO_TIME_END = 1 weeks; // first week bonus
503   uint public constant STAGE_THREE_TIME_END = CROWDSALE_DURATION;
504   
505   // Multiplier for the decimals
506   uint private constant DECIMALS = 10000;
507 
508   //Prices of DANS
509   uint public constant PRICE_STANDARD    = 900*DECIMALS; // DANS received per one ETH; MAX_SUPPLY / (valuation / ethPrice)
510   uint public constant PRICE_STAGE_ONE   = PRICE_STANDARD * 130/100; // 1ETH = 30% more DANS
511   uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 115/100; // 1ETH = 15% more DANS
512   uint public constant PRICE_STAGE_THREE = PRICE_STANDARD;
513 
514   //DANS Token Limits
515   uint public constant ALLOC_TEAM =         16000000*DECIMALS; // team + advisors
516   uint public constant ALLOC_BOUNTIES =      4000000*DECIMALS;
517   uint public constant ALLOC_CROWDSALE =    80000000*DECIMALS;
518   uint public constant PREBUY_PORTION_MAX = 20000000*DECIMALS; // this is redundantly more than what will be pre-sold
519  
520   // More erc20
521   uint public totalSupply = 100000000*DECIMALS; 
522   
523   //ASSIGNED IN INITIALIZATION
524   //Start and end times
525   uint public publicStartTime; // Time in seconds public crowd fund starts.
526   uint public privateStartTime; // Time in seconds when pre-buy can purchase up to 31250 ETH worth of DANS;
527   uint public publicEndTime; // Time in seconds crowdsale ends
528   uint public hardcapInEth;
529 
530   //Special Addresses
531   address public multisigAddress; // Address to which all ether flows.
532   address public danserviceTeamAddress; // Address to which ALLOC_TEAM, ALLOC_BOUNTIES, ALLOC_WINGS is (ultimately) sent to.
533   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
534   address public preBuy1; // Address used by pre-buy
535   address public preBuy2; // Address used by pre-buy
536   address public preBuy3; // Address used by pre-buy
537   uint public preBuyPrice1; // price for pre-buy
538   uint public preBuyPrice2; // price for pre-buy
539   uint public preBuyPrice3; // price for pre-buy
540 
541   //Running totals
542   uint public etherRaised; // Total Ether raised.
543   uint public DANSSold; // Total DANS created
544   uint public prebuyPortionTotal; // Total of Tokens purchased by pre-buy. Not to exceed PREBUY_PORTION_MAX.
545   
546   //booleans
547   bool public halted; // halts the crowd sale if true.
548 
549   // MODIFIERS
550   //Is currently in the period after the private start time and before the public start time.
551   modifier is_pre_crowdfund_period() {
552     if (now >= publicStartTime || now < privateStartTime) revert();
553     _;
554   }
555 
556   //Is currently the crowdfund period
557   modifier is_crowdfund_period() {
558     if (now < publicStartTime) revert();
559     if (isCrowdfundCompleted()) revert();
560     _;
561   }
562 
563   // Is completed
564   modifier is_crowdfund_completed() {
565     if (!isCrowdfundCompleted()) revert();
566     _;
567   }
568   function isCrowdfundCompleted() internal returns (bool) {
569     if (now > publicEndTime || DANSSold >= ALLOC_CROWDSALE || etherRaised >= hardcapInEth) return true;
570     return false;
571   }
572 
573   //May only be called by the owner address
574   modifier only_owner() {
575     if (msg.sender != ownerAddress) revert();
576     _;
577   }
578 
579   //May only be called if the crowdfund has not been halted
580   modifier is_not_halted() {
581     if (halted) revert();
582     _;
583   }
584 
585   // EVENTS
586   event PreBuy(uint _amount);
587   event Buy(address indexed _recipient, uint _amount);
588 
589   // Initialization contract assigns address of crowdfund contract and end time.
590   function DANSToken (
591     address _multisig,
592     address _danserviceTeam,
593     uint _publicStartTime,
594     uint _privateStartTime,
595     uint _hardcapInEth,
596     address _prebuy1, uint _preBuyPrice1,
597     address _prebuy2, uint _preBuyPrice2,
598     address _prebuy3, uint _preBuyPrice3
599   )
600     public
601   {
602     ownerAddress = msg.sender;
603     publicStartTime = _publicStartTime;
604     privateStartTime = _privateStartTime;
605 	publicEndTime = _publicStartTime + CROWDSALE_DURATION;
606     multisigAddress = _multisig;
607     danserviceTeamAddress = _danserviceTeam;
608 
609     hardcapInEth = _hardcapInEth;
610 
611     preBuy1 = _prebuy1;
612     preBuyPrice1 = _preBuyPrice1;
613     preBuy2 = _prebuy2;
614     preBuyPrice2 = _preBuyPrice2;
615     preBuy3 = _prebuy3;
616     preBuyPrice3 = _preBuyPrice3;
617 
618     balances[danserviceTeamAddress] += ALLOC_BOUNTIES;
619 
620     balances[ownerAddress] += ALLOC_TEAM;
621 
622     balances[ownerAddress] += ALLOC_CROWDSALE;
623   }
624 
625   // Transfer amount of tokens from sender account to recipient.
626   // Only callable after the crowd fund is completed
627   function transfer(address _to, uint _value)
628   {
629     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
630     if (!isCrowdfundCompleted()) revert();
631     super.transfer(_to, _value);
632   }
633 
634   // Transfer amount of tokens from a specified address to a recipient.
635   // Transfer amount of tokens from sender account to recipient.
636   function transferFrom(address _from, address _to, uint _value)
637     is_crowdfund_completed
638   {
639     super.transferFrom(_from, _to, _value);
640   }
641 
642   //constant function returns the current DANS price.
643   function getPriceRate()
644       constant
645       returns (uint o_rate)
646   {
647       uint delta = SafeMath.sub(now, publicStartTime);
648 
649       if (delta > STAGE_TWO_TIME_END) return PRICE_STAGE_THREE;
650       if (delta > STAGE_ONE_TIME_END) return PRICE_STAGE_TWO;
651 
652       return (PRICE_STAGE_ONE);
653   }
654 
655   // calculates wmount of DANS we get, given the wei and the rates we've defined per 1 eth
656   function calcAmount(uint _wei, uint _rate) 
657     constant
658     returns (uint) 
659   {
660     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
661   } 
662   
663   // Given the rate of a purchase and the remaining tokens in this tranche, it
664   // will throw if the sale would take it past the limit of the tranche.
665   // Returns `amount` in scope as the number of DANS tokens that it will purchase.
666   function processPurchase(uint _rate, uint _remaining)
667     internal
668     returns (uint o_amount)
669   {
670     o_amount = calcAmount(msg.value, _rate);
671 
672     if (o_amount > _remaining) revert();
673     if (!multisigAddress.send(msg.value)) revert();
674 
675     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
676     balances[msg.sender] = balances[msg.sender].add(o_amount);
677 
678     DANSSold += o_amount;
679     etherRaised += msg.value;
680   }
681 
682   //Special Function can only be called by pre-buy and only during the pre-crowdsale period.
683   function preBuy()
684     payable
685     is_pre_crowdfund_period
686     is_not_halted
687   {
688     // Pre-buy participants would get the first-day price, as well as a bonus of vested tokens
689     uint priceVested = 0;
690 
691     if (msg.sender == preBuy1) priceVested = preBuyPrice1;
692     if (msg.sender == preBuy2) priceVested = preBuyPrice2;
693     if (msg.sender == preBuy3) priceVested = preBuyPrice3;
694 
695     if (priceVested == 0) revert();
696 
697     uint amount = processPurchase(PRICE_STAGE_ONE + priceVested, SafeMath.sub(PREBUY_PORTION_MAX, prebuyPortionTotal));
698     grantVestedTokens(msg.sender, calcAmount(msg.value, priceVested), 
699       uint64(now), uint64(now) + 91 days, uint64(now) + 365 days, 
700       false, false
701     );
702     prebuyPortionTotal += amount;
703     PreBuy(amount);
704   }
705 
706   //Default function called by sending Ether to this address with no arguments.
707   //Results in creation of new DANS Tokens if transaction would not exceed hard limit of DANS Token.
708   function()
709     payable
710     is_crowdfund_period
711     is_not_halted
712   {
713     uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, DANSSold));
714     Buy(msg.sender, amount);
715   }
716 
717   // To be called at the end of crowdfund period
718   // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length
719   function grantVested(address _danserviceTeamAddress, address _danserviceFundAddress)
720     is_crowdfund_completed
721     only_owner
722     is_not_halted
723   {
724     // Grant tokens pre-allocated for the team
725     grantVestedTokens(
726       _danserviceTeamAddress, ALLOC_TEAM,
727       uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, 
728       false, false
729     );
730 
731     // Grant tokens that remain after crowdsale to the DAN-Service coin fund, vested for 2 years
732     grantVestedTokens(
733       _danserviceFundAddress, balances[ownerAddress],
734       uint64(now), uint64(now) + 182 days , uint64(now) + 730 days, 
735       false, false
736     );
737   }
738 
739   //May be used by owner of contract to halt crowdsale and no longer except ether.
740   function toggleHalt(bool _halted)
741     only_owner
742   {
743     halted = _halted;
744   }
745 
746   //failsafe drain
747   function drain()
748     only_owner
749   {
750     if (!ownerAddress.send(address(this).balance)) revert();
751   }
752 }