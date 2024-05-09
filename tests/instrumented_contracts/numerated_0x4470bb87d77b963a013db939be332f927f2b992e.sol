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
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
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
49   function assert(bool assertion) internal {
50     if (!assertion) {
51       throw;
52     }
53   }
54 }
55 
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20Basic {
63   uint public totalSupply;
64   function balanceOf(address who) constant returns (uint);
65   function transfer(address to, uint value);
66   event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances. 
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint;
78 
79   mapping(address => uint) balances;
80 
81   /**
82    * @dev Fix for the ERC20 short address attack.
83    */
84   modifier onlyPayloadSize(uint size) {
85      if(msg.data.length < size + 4) {
86        throw;
87      }
88      _;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of. 
105   * @return An uint representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) constant returns (uint balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) constant returns (uint);
122   function transferFrom(address from, address to, uint value);
123   function approve(address spender, uint value);
124   event Approval(address indexed owner, address indexed spender, uint value);
125 }
126 
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implemantation of the basic standart token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is BasicToken, ERC20 {
138 
139   mapping (address => mapping (address => uint)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // if (_value > _allowance) throw;
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint _value) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens than an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint specifing the amount of tokens still avaible for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint remaining) {
184     return allowed[_owner][_spender];
185   }
186 
187 }
188 
189 
190 /**
191  * @title LimitedTransferToken
192  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
193  * transferability for different events. It is intended to be used as a base class for other token 
194  * contracts. 
195  * LimitedTransferToken has been designed to allow for different limiting factors,
196  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
197  * hit. For example:
198  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
199  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
200  *     }
201  * A working example is VestedToken.sol:
202  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
203  */
204 
205 contract LimitedTransferToken is ERC20 {
206 
207   /**
208    * @dev Checks whether it can transfer or otherwise throws.
209    */
210   modifier canTransfer(address _sender, uint _value) {
211    if (_value > transferableTokens(_sender, uint64(now))) throw;
212    _;
213   }
214 
215   /**
216    * @dev Checks modifier and allows transfer if tokens are not locked.
217    * @param _to The address that will recieve the tokens.
218    * @param _value The amount of tokens to be transferred.
219    */
220   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
221     super.transfer(_to, _value);
222   }
223 
224   /**
225   * @dev Checks modifier and allows transfer if tokens are not locked.
226   * @param _from The address that will send the tokens.
227   * @param _to The address that will recieve the tokens.
228   * @param _value The amount of tokens to be transferred.
229   */
230   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
231     super.transferFrom(_from, _to, _value);
232   }
233 
234   /**
235    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
236    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
237    * specific logic for limiting token transferability for a holder over time.
238    */
239   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
240     return balanceOf(holder);
241   }
242 }
243 
244 
245 /**
246  * @title Vested token
247  * @dev Tokens that can be vested for a group of addresses.
248  */
249 contract VestedToken is StandardToken, LimitedTransferToken {
250 
251   uint256 MAX_GRANTS_PER_ADDRESS = 20;
252 
253   struct TokenGrant {
254     address granter;     // 20 bytes
255     uint256 value;       // 32 bytes
256     uint64 cliff;
257     uint64 vesting;
258     uint64 start;        // 3 * 8 = 24 bytes
259     bool revokable;
260     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
261   } // total 78 bytes = 3 sstore per operation (32 per sstore)
262 
263   mapping (address => TokenGrant[]) public grants;
264 
265   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
266 
267   /**
268    * @dev Grant tokens to a specified address
269    * @param _to address The address which the tokens will be granted to.
270    * @param _value uint256 The amount of tokens to be granted.
271    * @param _start uint64 Time of the beginning of the grant.
272    * @param _cliff uint64 Time of the cliff period.
273    * @param _vesting uint64 The vesting period.
274    */
275   function grantVestedTokens(
276     address _to,
277     uint256 _value,
278     uint64 _start,
279     uint64 _cliff,
280     uint64 _vesting,
281     bool _revokable,
282     bool _burnsOnRevoke
283   ) public {
284 
285     // Check for date inconsistencies that may cause unexpected behavior
286     if (_cliff < _start || _vesting < _cliff) {
287       throw;
288     }
289 
290     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
291 
292     uint count = grants[_to].push(
293                 TokenGrant(
294                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
295                   _value,
296                   _cliff,
297                   _vesting,
298                   _start,
299                   _revokable,
300                   _burnsOnRevoke
301                 )
302               );
303 
304     transfer(_to, _value);
305 
306     NewTokenGrant(msg.sender, _to, _value, count - 1);
307   }
308 
309   /**
310    * @dev Revoke the grant of tokens of a specifed address.
311    * @param _holder The address which will have its tokens revoked.
312    * @param _grantId The id of the token grant.
313    */
314   function revokeTokenGrant(address _holder, uint _grantId) public {
315     TokenGrant grant = grants[_holder][_grantId];
316 
317     if (!grant.revokable) { // Check if grant was revokable
318       throw;
319     }
320 
321     if (grant.granter != msg.sender) { // Only granter can revoke it
322       throw;
323     }
324 
325     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
326 
327     uint256 nonVested = nonVestedTokens(grant, uint64(now));
328 
329     // remove grant from array
330     delete grants[_holder][_grantId];
331     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
332     grants[_holder].length -= 1;
333 
334     balances[receiver] = balances[receiver].add(nonVested);
335     balances[_holder] = balances[_holder].sub(nonVested);
336 
337     Transfer(_holder, receiver, nonVested);
338   }
339 
340 
341   /**
342    * @dev Calculate the total amount of transferable tokens of a holder at a given time
343    * @param holder address The address of the holder
344    * @param time uint64 The specific time.
345    * @return An uint representing a holder's total amount of transferable tokens.
346    */
347   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
348     uint256 grantIndex = tokenGrantsCount(holder);
349 
350     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
351 
352     // Iterate through all the grants the holder has, and add all non-vested tokens
353     uint256 nonVested = 0;
354     for (uint256 i = 0; i < grantIndex; i++) {
355       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
356     }
357 
358     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
359     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
360 
361     // Return the minimum of how many vested can transfer and other value
362     // in case there are other limiting transferability factors (default is balanceOf)
363     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
364   }
365 
366   /**
367    * @dev Check the amount of grants that an address has.
368    * @param _holder The holder of the grants.
369    * @return A uint representing the total amount of grants.
370    */
371   function tokenGrantsCount(address _holder) constant returns (uint index) {
372     return grants[_holder].length;
373   }
374 
375   /**
376    * @dev Calculate amount of vested tokens at a specifc time.
377    * @param tokens uint256 The amount of tokens grantted.
378    * @param time uint64 The time to be checked
379    * @param start uint64 A time representing the begining of the grant
380    * @param cliff uint64 The cliff period.
381    * @param vesting uint64 The vesting period.
382    * @return An uint representing the amount of vested tokensof a specif grant.
383    *  transferableTokens
384    *   |                         _/--------   vestedTokens rect
385    *   |                       _/
386    *   |                     _/
387    *   |                   _/
388    *   |                 _/
389    *   |                /
390    *   |              .|
391    *   |            .  |
392    *   |          .    |
393    *   |        .      |
394    *   |      .        |
395    *   |    .          |
396    *   +===+===========+---------+----------> time
397    *      Start       Clift    Vesting
398    */
399   function calculateVestedTokens(
400     uint256 tokens,
401     uint256 time,
402     uint256 start,
403     uint256 cliff,
404     uint256 vesting) constant returns (uint256)
405     {
406       // Shortcuts for before cliff and after vesting cases.
407       if (time < cliff) return 0;
408       if (time >= vesting) return tokens;
409 
410       // Interpolate all vested tokens.
411       // As before cliff the shortcut returns 0, we can use just calculate a value
412       // in the vesting rect (as shown in above's figure)
413 
414       // vestedTokens = tokens * (time - start) / (vesting - start)
415       uint256 vestedTokens = SafeMath.div(
416                                     SafeMath.mul(
417                                       tokens,
418                                       SafeMath.sub(time, start)
419                                       ),
420                                     SafeMath.sub(vesting, start)
421                                     );
422 
423       return vestedTokens;
424   }
425 
426   /**
427    * @dev Get all information about a specifc grant.
428    * @param _holder The address which will have its tokens revoked.
429    * @param _grantId The id of the token grant.
430    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
431    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
432    */
433   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
434     TokenGrant grant = grants[_holder][_grantId];
435 
436     granter = grant.granter;
437     value = grant.value;
438     start = grant.start;
439     cliff = grant.cliff;
440     vesting = grant.vesting;
441     revokable = grant.revokable;
442     burnsOnRevoke = grant.burnsOnRevoke;
443 
444     vested = vestedTokens(grant, uint64(now));
445   }
446 
447   /**
448    * @dev Get the amount of vested tokens at a specific time.
449    * @param grant TokenGrant The grant to be checked.
450    * @param time The time to be checked
451    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
452    */
453   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
454     return calculateVestedTokens(
455       grant.value,
456       uint256(time),
457       uint256(grant.start),
458       uint256(grant.cliff),
459       uint256(grant.vesting)
460     );
461   }
462 
463   /**
464    * @dev Calculate the amount of non vested tokens at a specific time.
465    * @param grant TokenGrant The grant to be checked.
466    * @param time uint64 The time to be checked
467    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
468    * passed time frame.
469    */
470   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
471     return grant.value.sub(vestedTokens(grant, time));
472   }
473 
474   /**
475    * @dev Calculate the date when the holder can trasfer all its tokens
476    * @param holder address The address of the holder
477    * @return An uint representing the date of the last transferable tokens.
478    */
479   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
480     date = uint64(now);
481     uint256 grantIndex = grants[holder].length;
482     for (uint256 i = 0; i < grantIndex; i++) {
483       date = SafeMath.max64(grants[holder][i].vesting, date);
484     }
485   }
486 }
487 
488 // QUESTIONS FOR AUDITORS:
489 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
490 // - Ensure max supply is 100,000,000
491 // - Ensure that even if not totalSupply is sold, tokens would still be transferrable after (we will up to totalSupply by creating adEx tokens)
492 
493 // vesting: 365 days, 365 days / 4 vesting
494 
495 
496 contract ADXToken is VestedToken {
497   //FIELDS
498   string public name = "AdEx";
499   string public symbol = "ADX";
500   uint public decimals = 4;
501 
502   //CONSTANTS
503   //Time limits
504   uint public constant STAGE_ONE_TIME_END = 24 hours; // first day bonus
505   uint public constant STAGE_TWO_TIME_END = 1 weeks; // first week bonus
506   uint public constant STAGE_THREE_TIME_END = 4 weeks;
507   
508   // Multiplier for the decimals
509   uint private constant DECIMALS = 10000;
510 
511   //Prices of ADX
512   uint public constant PRICE_STANDARD    = 900*DECIMALS; // ADX received per one ETH; MAX_SUPPLY / (valuation / ethPrice)
513   uint public constant PRICE_STAGE_ONE   = PRICE_STANDARD * 130/100; // 1ETH = 30% more ADX
514   uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 115/100; // 1ETH = 15% more ADX
515   uint public constant PRICE_STAGE_THREE = PRICE_STANDARD;
516 
517   //ADX Token Limits
518   uint public constant ALLOC_TEAM =         16000000*DECIMALS; // team + advisors
519   uint public constant ALLOC_BOUNTIES =      2000000*DECIMALS;
520   uint public constant ALLOC_WINGS =         2000000*DECIMALS;
521   uint public constant ALLOC_CROWDSALE =    80000000*DECIMALS;
522   uint public constant PREBUY_PORTION_MAX = 20000000*DECIMALS; // this is redundantly more than what will be pre-sold
523   
524   //ASSIGNED IN INITIALIZATION
525   //Start and end times
526   uint public publicStartTime; // Time in seconds public crowd fund starts.
527   uint public privateStartTime; // Time in seconds when pre-buy can purchase up to 31250 ETH worth of ADX;
528   uint public publicEndTime; // Time in seconds crowdsale ends
529   uint public hardcapInEth;
530 
531   //Special Addresses
532   address public multisigAddress; // Address to which all ether flows.
533   address public adexTeamAddress; // Address to which ALLOC_TEAM, ALLOC_BOUNTIES, ALLOC_WINGS is (ultimately) sent to.
534   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
535   address public preBuy1; // Address used by pre-buy
536   address public preBuy2; // Address used by pre-buy
537   address public preBuy3; // Address used by pre-buy
538   uint public preBuyPrice1; // price for pre-buy
539   uint public preBuyPrice2; // price for pre-buy
540   uint public preBuyPrice3; // price for pre-buy
541 
542   //Running totals
543   uint public etherRaised; // Total Ether raised.
544   uint public ADXSold; // Total ADX created
545   uint public prebuyPortionTotal; // Total of Tokens purchased by pre-buy. Not to exceed PREBUY_PORTION_MAX.
546   
547   //booleans
548   bool public halted; // halts the crowd sale if true.
549 
550   // MODIFIERS
551   //Is currently in the period after the private start time and before the public start time.
552   modifier is_pre_crowdfund_period() {
553     if (now >= publicStartTime || now < privateStartTime) throw;
554     _;
555   }
556 
557   //Is currently the crowdfund period
558   modifier is_crowdfund_period() {
559     if (now < publicStartTime) throw;
560     if (isCrowdfundCompleted()) throw;
561     _;
562   }
563 
564   // Is completed
565   modifier is_crowdfund_completed() {
566     if (!isCrowdfundCompleted()) throw;
567     _;
568   }
569   function isCrowdfundCompleted() internal returns (bool) {
570     if (now > publicEndTime || ADXSold >= ALLOC_CROWDSALE || etherRaised >= hardcapInEth) return true;
571     return false;
572   }
573 
574   //May only be called by the owner address
575   modifier only_owner() {
576     if (msg.sender != ownerAddress) throw;
577     _;
578   }
579 
580   //May only be called if the crowdfund has not been halted
581   modifier is_not_halted() {
582     if (halted) throw;
583     _;
584   }
585 
586   // EVENTS
587   event PreBuy(uint _amount);
588   event Buy(address indexed _recipient, uint _amount);
589 
590   // Initialization contract assigns address of crowdfund contract and end time.
591   function ADXToken(
592     address _multisig,
593     address _adexTeam,
594     uint _publicStartTime,
595     uint _privateStartTime,
596     uint _hardcapInEth,
597     address _prebuy1, uint _preBuyPrice1,
598     address _prebuy2, uint _preBuyPrice2,
599     address _prebuy3, uint _preBuyPrice3
600   ) {
601     ownerAddress = msg.sender;
602     publicStartTime = _publicStartTime;
603     privateStartTime = _privateStartTime;
604     publicEndTime = _publicStartTime + 4 weeks;
605     multisigAddress = _multisig;
606     adexTeamAddress = _adexTeam;
607 
608     hardcapInEth = _hardcapInEth;
609 
610     preBuy1 = _prebuy1;
611     preBuyPrice1 = _preBuyPrice1;
612     preBuy2 = _prebuy2;
613     preBuyPrice2 = _preBuyPrice2;
614     preBuy3 = _prebuy3;
615     preBuyPrice3 = _preBuyPrice3;
616 
617     balances[adexTeamAddress] += ALLOC_BOUNTIES;
618     balances[adexTeamAddress] += ALLOC_WINGS;
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
630     if (!isCrowdfundCompleted()) throw;
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
642   //constant function returns the current ADX price.
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
655   // calculates wmount of ADX we get, given the wei and the rates we've defined per 1 eth
656   function calcAmount(uint _wei, uint _rate) 
657     constant
658     returns (uint) 
659   {
660     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
661   } 
662   
663   // Given the rate of a purchase and the remaining tokens in this tranche, it
664   // will throw if the sale would take it past the limit of the tranche.
665   // Returns `amount` in scope as the number of ADX tokens that it will purchase.
666   function processPurchase(uint _rate, uint _remaining)
667     internal
668     returns (uint o_amount)
669   {
670     o_amount = calcAmount(msg.value, _rate);
671 
672     if (o_amount > _remaining) throw;
673     if (!multisigAddress.send(msg.value)) throw;
674 
675     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
676     balances[msg.sender] = balances[msg.sender].add(o_amount);
677 
678     ADXSold += o_amount;
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
695     if (priceVested == 0) throw;
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
707   //Results in creation of new ADX Tokens if transaction would not exceed hard limit of ADX Token.
708   function()
709     payable
710     is_crowdfund_period
711     is_not_halted
712   {
713     uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, ADXSold));
714     Buy(msg.sender, amount);
715   }
716 
717   // To be called at the end of crowdfund period
718   // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length
719   function grantVested(address _adexTeamAddress, address _adexFundAddress)
720     is_crowdfund_completed
721     only_owner
722     is_not_halted
723   {
724     // Grant tokens pre-allocated for the team
725     grantVestedTokens(
726       _adexTeamAddress, ALLOC_TEAM,
727       uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, 
728       false, false
729     );
730 
731     // Grant tokens that remain after crowdsale to the AdEx fund, vested for 2 years
732     grantVestedTokens(
733       _adexFundAddress, balances[ownerAddress],
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
750     if (!ownerAddress.send(this.balance)) throw;
751   }
752 }