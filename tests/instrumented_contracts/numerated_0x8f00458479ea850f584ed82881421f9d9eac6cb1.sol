1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title Math
37  * @dev Assorted math operations
38  */
39 
40 library Math {
41   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56 }
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant returns (uint256);
67   function transfer(address to, uint256 value) returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances. 
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) returns (bool) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of. 
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) constant returns (uint256);
115   function transferFrom(address from, address to, uint256 value) returns (bool);
116   function approve(address spender, uint256 value) returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amout of tokens to be transfered
140    */
141   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
142     var _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // require (_value <= _allowance);
146 
147     balances[_to] = balances[_to].add(_value);
148     balances[_from] = balances[_from].sub(_value);
149     allowed[_from][msg.sender] = _allowance.sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) returns (bool) {
160 
161     // To change the approve amount you first have to reduce the addresses`
162     //  allowance to zero by calling `approve(_spender, 0)` if it is not
163     //  already 0 to mitigate the race condition described here:
164     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
166 
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifing the amount of tokens still avaible for the spender.
177    */
178   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
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
205   modifier canTransfer(address _sender, uint256 _value) {
206    require(_value <= transferableTokens(_sender, uint64(now)));
207    _;
208   }
209 
210   /**
211    * @dev Checks modifier and allows transfer if tokens are not locked.
212    * @param _to The address that will recieve the tokens.
213    * @param _value The amount of tokens to be transferred.
214    */
215   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
216     return super.transfer(_to, _value);
217   }
218 
219   /**
220   * @dev Checks modifier and allows transfer if tokens are not locked.
221   * @param _from The address that will send the tokens.
222   * @param _to The address that will recieve the tokens.
223   * @param _value The amount of tokens to be transferred.
224   */
225   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
226     return super.transferFrom(_from, _to, _value);
227   }
228 
229   /**
230    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
231    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
232    * specific logic for limiting token transferability for a holder over time.
233    */
234   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
235     return balanceOf(holder);
236   }
237 }
238 
239 
240 /**
241  * @title Vested token
242  * @dev Tokens that can be vested for a group of addresses.
243  */
244 contract VestedToken is StandardToken, LimitedTransferToken {
245 
246   uint256 MAX_GRANTS_PER_ADDRESS = 20;
247 
248   struct TokenGrant {
249     address granter;     // 20 bytes
250     uint256 value;       // 32 bytes
251     uint64 cliff;
252     uint64 vesting;
253     uint64 start;        // 3 * 8 = 24 bytes
254     bool revokable;
255     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
256   } // total 78 bytes = 3 sstore per operation (32 per sstore)
257 
258   mapping (address => TokenGrant[]) public grants;
259 
260   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
261 
262   /**
263    * @dev Grant tokens to a specified address
264    * @param _to address The address which the tokens will be granted to.
265    * @param _value uint256 The amount of tokens to be granted.
266    * @param _start uint64 Time of the beginning of the grant.
267    * @param _cliff uint64 Time of the cliff period.
268    * @param _vesting uint64 The vesting period.
269    */
270   function grantVestedTokens(
271     address _to,
272     uint256 _value,
273     uint64 _start,
274     uint64 _cliff,
275     uint64 _vesting,
276     bool _revokable,
277     bool _burnsOnRevoke
278   ) public {
279 
280     // Check for date inconsistencies that may cause unexpected behavior
281     require(_cliff >= _start && _vesting >= _cliff);
282 
283     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
284 
285     uint256 count = grants[_to].push(
286                 TokenGrant(
287                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
288                   _value,
289                   _cliff,
290                   _vesting,
291                   _start,
292                   _revokable,
293                   _burnsOnRevoke
294                 )
295               );
296 
297     transfer(_to, _value);
298 
299     NewTokenGrant(msg.sender, _to, _value, count - 1);
300   }
301 
302   /**
303    * @dev Revoke the grant of tokens of a specifed address.
304    * @param _holder The address which will have its tokens revoked.
305    * @param _grantId The id of the token grant.
306    */
307   function revokeTokenGrant(address _holder, uint256 _grantId) public {
308     TokenGrant grant = grants[_holder][_grantId];
309 
310     require(grant.revokable);
311     require(grant.granter == msg.sender); // Only granter can revoke it
312 
313     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
314 
315     uint256 nonVested = nonVestedTokens(grant, uint64(now));
316 
317     // remove grant from array
318     delete grants[_holder][_grantId];
319     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
320     grants[_holder].length -= 1;
321 
322     balances[receiver] = balances[receiver].add(nonVested);
323     balances[_holder] = balances[_holder].sub(nonVested);
324 
325     Transfer(_holder, receiver, nonVested);
326   }
327 
328 
329   /**
330    * @dev Calculate the total amount of transferable tokens of a holder at a given time
331    * @param holder address The address of the holder
332    * @param time uint64 The specific time.
333    * @return An uint256 representing a holder's total amount of transferable tokens.
334    */
335   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
336     uint256 grantIndex = tokenGrantsCount(holder);
337 
338     if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
339 
340     // Iterate through all the grants the holder has, and add all non-vested tokens
341     uint256 nonVested = 0;
342     for (uint256 i = 0; i < grantIndex; i++) {
343       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
344     }
345 
346     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
347     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
348 
349     // Return the minimum of how many vested can transfer and other value
350     // in case there are other limiting transferability factors (default is balanceOf)
351     return Math.min256(vestedTransferable, super.transferableTokens(holder, time));
352   }
353 
354   /**
355    * @dev Check the amount of grants that an address has.
356    * @param _holder The holder of the grants.
357    * @return A uint256 representing the total amount of grants.
358    */
359   function tokenGrantsCount(address _holder) constant returns (uint256 index) {
360     return grants[_holder].length;
361   }
362 
363   /**
364    * @dev Calculate amount of vested tokens at a specifc time.
365    * @param tokens uint256 The amount of tokens grantted.
366    * @param time uint64 The time to be checked
367    * @param start uint64 A time representing the begining of the grant
368    * @param cliff uint64 The cliff period.
369    * @param vesting uint64 The vesting period.
370    * @return An uint256 representing the amount of vested tokensof a specif grant.
371    *  transferableTokens
372    *   |                         _/--------   vestedTokens rect
373    *   |                       _/
374    *   |                     _/
375    *   |                   _/
376    *   |                 _/
377    *   |                /
378    *   |              .|
379    *   |            .  |
380    *   |          .    |
381    *   |        .      |
382    *   |      .        |
383    *   |    .          |
384    *   +===+===========+---------+----------> time
385    *      Start       Clift    Vesting
386    */
387   function calculateVestedTokens(
388     uint256 tokens,
389     uint256 time,
390     uint256 start,
391     uint256 cliff,
392     uint256 vesting) constant returns (uint256)
393     {
394       // Shortcuts for before cliff and after vesting cases.
395       if (time < cliff) return 0;
396       if (time >= vesting) return tokens;
397 
398       // Interpolate all vested tokens.
399       // As before cliff the shortcut returns 0, we can use just calculate a value
400       // in the vesting rect (as shown in above's figure)
401 
402       // vestedTokens = tokens * (time - start) / (vesting - start)
403       uint256 vestedTokens = SafeMath.div(
404                                     SafeMath.mul(
405                                       tokens,
406                                       SafeMath.sub(time, start)
407                                       ),
408                                     SafeMath.sub(vesting, start)
409                                     );
410 
411       return vestedTokens;
412   }
413 
414   /**
415    * @dev Get all information about a specifc grant.
416    * @param _holder The address which will have its tokens revoked.
417    * @param _grantId The id of the token grant.
418    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
419    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
420    */
421   function tokenGrant(address _holder, uint256 _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
422     TokenGrant grant = grants[_holder][_grantId];
423 
424     granter = grant.granter;
425     value = grant.value;
426     start = grant.start;
427     cliff = grant.cliff;
428     vesting = grant.vesting;
429     revokable = grant.revokable;
430     burnsOnRevoke = grant.burnsOnRevoke;
431 
432     vested = vestedTokens(grant, uint64(now));
433   }
434 
435   /**
436    * @dev Get the amount of vested tokens at a specific time.
437    * @param grant TokenGrant The grant to be checked.
438    * @param time The time to be checked
439    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
440    */
441   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
442     return calculateVestedTokens(
443       grant.value,
444       uint256(time),
445       uint256(grant.start),
446       uint256(grant.cliff),
447       uint256(grant.vesting)
448     );
449   }
450 
451   /**
452    * @dev Calculate the amount of non vested tokens at a specific time.
453    * @param grant TokenGrant The grant to be checked.
454    * @param time uint64 The time to be checked
455    * @return An uint256 representing the amount of non vested tokens of a specifc grant on the
456    * passed time frame.
457    */
458   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
459     return grant.value.sub(vestedTokens(grant, time));
460   }
461 
462   /**
463    * @dev Calculate the date when the holder can trasfer all its tokens
464    * @param holder address The address of the holder
465    * @return An uint256 representing the date of the last transferable tokens.
466    */
467   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
468     date = uint64(now);
469     uint256 grantIndex = grants[holder].length;
470     for (uint256 i = 0; i < grantIndex; i++) {
471       date = Math.max64(grants[holder][i].vesting, date);
472     }
473   }
474 }
475 
476 
477 contract EGLToken is VestedToken {
478   //FIELDS
479   string public name = "eGold";
480   string public symbol = "EGL";
481   uint public decimals = 4;
482   
483   //CONSTANTS
484   // Time limits
485   uint public constant STAGE_ONE_TIME_END = 24 hours; // first day bonus
486   uint public constant STAGE_TWO_TIME_END = 1 weeks; // first week bonus
487   uint public constant STAGE_THREE_TIME_END = 28 days; // around one month
488   
489   // Multiplier for the decimals
490   uint private constant MULTIPLIER = 10000;
491 
492   //Prices of EGL
493   uint public constant PRICE_STANDARD    =  888 *MULTIPLIER; // EGL received per one ETH; MAX_SUPPLY / (valuation / ethPrice)
494   uint public constant PRICE_PREBUY      = 1066 *MULTIPLIER; // 1ETH = 20% more EGL 
495   uint public constant PRICE_STAGE_ONE   = 1021 *MULTIPLIER; // 1ETH = 15% more EGL
496   uint public constant PRICE_STAGE_TWO   =  976 *MULTIPLIER; // 1ETH = 10% more EGL
497   uint public constant PRICE_STAGE_THREE =  888 *MULTIPLIER;
498 
499   // EGL Token Limits
500   uint public constant ALLOC_TEAM =          4444444 *MULTIPLIER; // team + advisors + everything else
501   uint public constant ALLOC_CROWDSALE =    (4444444-266666) *MULTIPLIER;
502   uint public constant ALLOC_SC = 	          266666 *MULTIPLIER;
503   
504   uint public constant ALLOC_MAX_PRE =        888888 *MULTIPLIER;
505   
506   // More ERC20
507   uint public totalSupply =                  8888888 *MULTIPLIER; 
508   
509   // ASSIGNED IN INITIALIZATION
510   // Start and end times
511   uint public publicStartTime; // Time in seconds public crowd fund starts.
512   uint public publicEndTime; // Time in seconds crowdsale ends
513   uint public hardcapInWei;
514 
515   //Special Addresses
516   address public multisigAddress; // Address to which all ether flows.
517   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
518 
519   // Running totals
520   uint public weiRaised; // Total Ether raised.
521   uint public EGLSold; // Total EGL sold. Not to exceed ALLOC_CROWDSALE
522   uint public prebuyPortionTotal; // Total of Tokens purchased by pre-buy. Not to exceed ALLOC_MAX_PRE.
523   
524   // booleans
525   bool public halted; // halts the crowd sale if true.
526 
527   // Is completed
528   function isCrowdfundCompleted()
529     internal
530     returns (bool) 
531   {
532     if (
533       now > publicEndTime
534       || EGLSold >= ALLOC_CROWDSALE
535       || weiRaised >= hardcapInWei
536     ) return true;
537 
538     return false;
539   }
540 
541   // MODIFIERS
542 
543   //May only be called by the owner address
544   modifier only_owner() {
545     require(msg.sender == ownerAddress);
546     _;
547   }
548 
549   //May only be called if the crowdfund has not been halted
550   modifier is_not_halted() {
551     require(!halted);
552     _;
553   }
554 
555   // EVENTS
556   event Buy(address indexed _recipient, uint _amount);
557 
558   // Initialization contract assigns address of crowdfund contract and end time.
559   function EGLToken(
560     address _multisig,
561     uint _publicStartTime,
562     uint _hardcapInWei
563   ) {
564     ownerAddress = msg.sender;
565     publicStartTime = _publicStartTime;
566     publicEndTime = _publicStartTime + 28 days;
567     multisigAddress = _multisig;
568 
569     hardcapInWei = _hardcapInWei;
570     
571     balances[0x8c6a58B551F38d4D51C0db7bb8b7ad29f7488702] += ALLOC_SC;
572 
573     // will be transferred to the team address when it's vested
574     balances[ownerAddress] += ALLOC_TEAM;
575 
576     balances[ownerAddress] += ALLOC_CROWDSALE;
577   }
578 
579   // Transfer amount of tokens from sender account to recipient.
580   // Only callable after the crowd fund is completed
581   function transfer(address _to, uint _value)
582     returns (bool)
583   {
584     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
585     require(isCrowdfundCompleted());
586     return super.transfer(_to, _value);
587   }
588 
589   // Transfer amount of tokens from a specified address to a recipient.
590   function transferFrom(address _from, address _to, uint _value)
591     returns (bool)
592   {
593     require(isCrowdfundCompleted());
594     return super.transferFrom(_from, _to, _value);
595   }
596 
597   // function returns the current EGL price.
598   function getPriceRate()
599       constant
600       returns (uint o_rate)
601   {
602       uint delta = SafeMath.sub(now, publicStartTime);
603 
604       if (delta > STAGE_TWO_TIME_END) return PRICE_STAGE_THREE;
605       if (delta > STAGE_ONE_TIME_END) return PRICE_STAGE_TWO;
606 
607       return (PRICE_STAGE_ONE);
608   }
609 
610   // calculates wmount of EGL we get, given the wei and the rates we've defined per 1 eth
611   function calcAmount(uint _wei, uint _rate) 
612     constant
613     returns (uint) 
614   {
615     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
616   } 
617   
618   // Given the rate of a purchase and the remaining tokens in this tranche, it
619   // will throw if the sale would take it past the limit of the tranche.
620   // Returns `amount` in scope as the number of EGL tokens that it will purchase.
621   function processPurchase(uint _rate, uint _remaining)
622     internal
623     returns (uint o_amount)
624   {
625     o_amount = calcAmount(msg.value, _rate);
626 
627     require(o_amount <= _remaining);
628     require(multisigAddress.send(msg.value));
629 
630     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
631     balances[msg.sender] = balances[msg.sender].add(o_amount);
632 
633     EGLSold += o_amount;
634     weiRaised += msg.value;
635   }
636 
637   // Default function called by sending Ether to this address with no arguments.
638   // Results in creation of new EGL Tokens if transaction would not exceed hard limit of EGL Token.
639   function()
640     payable
641     is_not_halted
642   {
643     require(!isCrowdfundCompleted());
644 
645     uint amount;
646 
647     if (now < publicStartTime) {
648       // pre-sale
649       amount = processPurchase(PRICE_PREBUY, SafeMath.sub(ALLOC_MAX_PRE, prebuyPortionTotal));
650       prebuyPortionTotal += amount;
651     } else {
652       amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, EGLSold));
653     }
654     
655     Buy(msg.sender, amount);
656   }
657 
658   // May be used by owner of contract to halt crowdsale and no longer except ether.
659   function toggleHalt(bool _halted)
660     only_owner
661   {
662     halted = _halted;
663   }
664 
665   // failsafe drain
666   function drain()
667     only_owner
668   {
669     require(ownerAddress.send(this.balance));
670   }
671 
672   // public constant 
673   function getStatus() 
674     constant
675     public
676     returns (string)
677   {
678     if (EGLSold >= ALLOC_CROWDSALE) return "tokensSoldOut";
679     if (weiRaised >= hardcapInWei) return "hardcapReached";
680     
681     if (now < publicStartTime) {
682       // presale
683       if (prebuyPortionTotal >= ALLOC_MAX_PRE) return "presaleSoldOut";
684       return "presale";
685     } else if (now < publicEndTime) {
686       // public sale
687       return "public";
688     } else {
689       return "saleOver";
690     }
691   }
692 }