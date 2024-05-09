1 pragma solidity ^0.4.11;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6   function mul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c >= a);
24     return c;
25   }
26   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a >= b ? a : b;
28   }
29   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a < b ? a : b;
31   }
32   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a >= b ? a : b;
34   }
35   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a < b ? a : b;
37   }
38   function assert(bool assertion) internal {
39     if (!assertion) {
40       revert();
41     }
42   }
43 }
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20Basic {
50   uint public totalSupply;
51   function balanceOf(address who) constant returns (uint);
52   function transfer(address to, uint value);
53   event Transfer(address indexed from, address indexed to, uint value);
54 }
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances. 
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint;
61 
62   mapping(address => uint) balances;
63 
64   /**
65    * @dev Fix for the ERC20 short address attack.
66    */
67   modifier onlyPayloadSize(uint size) {
68      if(msg.data.length < size + 4) {
69        revert();
70      }
71      _;
72   }
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) constant returns (uint);
105   function transferFrom(address from, address to, uint value);
106   function approve(address spender, uint value);
107   event Approval(address indexed owner, address indexed spender, uint value);
108 }
109 
110 
111 
112 
113 /**
114  * @title Standard ERC20 token
115  *
116  * @dev Implemantation of the basic standart token.
117  * @dev https://github.com/ethereum/EIPs/issues/20
118  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  */
120 contract StandardToken is BasicToken, ERC20 {
121 
122   mapping (address => mapping (address => uint)) allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint the amout of tokens to be transfered
130    */
131   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
132     var _allowance = allowed[_from][msg.sender];
133 
134     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
135     // if (_value > _allowance) revert();
136 
137     balances[_to] = balances[_to].add(_value);
138     balances[_from] = balances[_from].sub(_value);
139     allowed[_from][msg.sender] = _allowance.sub(_value);
140     Transfer(_from, _to, _value);
141   }
142 
143   /**
144    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint _value) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens than an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint specifing the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) constant returns (uint remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170 }
171 
172 
173 /**
174  * @title LimitedTransferToken
175  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
176  * transferability for different events. It is intended to be used as a base class for other token 
177  * contracts. 
178  * LimitedTransferToken has been designed to allow for different limiting factors,
179  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
180  * hit. For example:
181  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
182  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
183  *     }
184  * A working example is VestedToken.sol:
185  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
186  */
187 
188 contract LimitedTransferToken is ERC20 {
189 
190   /**
191    * @dev Checks whether it can transfer or otherwise throws.
192    */
193   modifier canTransfer(address _sender, uint _value) {
194    if (_value > transferableTokens(_sender, uint64(now))) revert();
195    _;
196   }
197 
198   /**
199    * @dev Checks modifier and allows transfer if tokens are not locked.
200    * @param _to The address that will recieve the tokens.
201    * @param _value The amount of tokens to be transferred.
202    */
203   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
204     super.transfer(_to, _value);
205   }
206 
207   /**
208   * @dev Checks modifier and allows transfer if tokens are not locked.
209   * @param _from The address that will send the tokens.
210   * @param _to The address that will recieve the tokens.
211   * @param _value The amount of tokens to be transferred.
212   */
213   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
214     super.transferFrom(_from, _to, _value);
215   }
216 
217   /**
218    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
219    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
220    * specific logic for limiting token transferability for a holder over time.
221    */
222   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
223     return balanceOf(holder);
224   }
225 }
226 
227 
228 /**
229  * @title Vested token
230  * @dev Tokens that can be vested for a group of addresses.
231  */
232 contract VestedToken is StandardToken, LimitedTransferToken {
233 
234   uint256 MAX_GRANTS_PER_ADDRESS = 20;
235 
236   struct TokenGrant {
237     address granter;     // 20 bytes
238     uint256 value;       // 32 bytes
239     uint64 cliff;
240     uint64 vesting;
241     uint64 start;        // 3 * 8 = 24 bytes
242     bool revokable;
243     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
244   } // total 78 bytes = 3 sstore per operation (32 per sstore)
245 
246   mapping (address => TokenGrant[]) public grants;
247 
248   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
249 
250   /**
251    * @dev Grant tokens to a specified address
252    * @param _to address The address which the tokens will be granted to.
253    * @param _value uint256 The amount of tokens to be granted.
254    * @param _start uint64 Time of the beginning of the grant.
255    * @param _cliff uint64 Time of the cliff period.
256    * @param _vesting uint64 The vesting period.
257    */
258   function grantVestedTokens(
259     address _to,
260     uint256 _value,
261     uint64 _start,
262     uint64 _cliff,
263     uint64 _vesting,
264     bool _revokable,
265     bool _burnsOnRevoke
266   ) public {
267 
268     // Check for date inconsistencies that may cause unexpected behavior
269     if (_cliff < _start || _vesting < _cliff) {
270       revert();
271     }
272 
273     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) revert();   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
274 
275     uint count = grants[_to].push(
276                 TokenGrant(
277                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
278                   _value,
279                   _cliff,
280                   _vesting,
281                   _start,
282                   _revokable,
283                   _burnsOnRevoke
284                 )
285               );
286 
287     transfer(_to, _value);
288 
289     NewTokenGrant(msg.sender, _to, _value, count - 1);
290   }
291 
292   /**
293    * @dev Revoke the grant of tokens of a specifed address.
294    * @param _holder The address which will have its tokens revoked.
295    * @param _grantId The id of the token grant.
296    */
297   function revokeTokenGrant(address _holder, uint _grantId) public {
298     TokenGrant grant = grants[_holder][_grantId];
299 
300     if (!grant.revokable) { // Check if grant was revokable
301       revert();
302     }
303 
304     if (grant.granter != msg.sender) { // Only granter can revoke it
305       revert();
306     }
307 
308     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
309 
310     uint256 nonVested = nonVestedTokens(grant, uint64(now));
311 
312     // remove grant from array
313     delete grants[_holder][_grantId];
314     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
315     grants[_holder].length -= 1;
316 
317     balances[receiver] = balances[receiver].add(nonVested);
318     balances[_holder] = balances[_holder].sub(nonVested);
319 
320     Transfer(_holder, receiver, nonVested);
321   }
322 
323 
324   /**
325    * @dev Calculate the total amount of transferable tokens of a holder at a given time
326    * @param holder address The address of the holder
327    * @param time uint64 The specific time.
328    * @return An uint representing a holder's total amount of transferable tokens.
329    */
330   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
331     uint256 grantIndex = tokenGrantsCount(holder);
332 
333     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
334 
335     // Iterate through all the grants the holder has, and add all non-vested tokens
336     uint256 nonVested = 0;
337     for (uint256 i = 0; i < grantIndex; i++) {
338       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
339     }
340 
341     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
342     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
343 
344     // Return the minimum of how many vested can transfer and other value
345     // in case there are other limiting transferability factors (default is balanceOf)
346     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
347   }
348 
349   /**
350    * @dev Check the amount of grants that an address has.
351    * @param _holder The holder of the grants.
352    * @return A uint representing the total amount of grants.
353    */
354   function tokenGrantsCount(address _holder) constant returns (uint index) {
355     return grants[_holder].length;
356   }
357 
358   /**
359    * @dev Calculate amount of vested tokens at a specifc time.
360    * @param tokens uint256 The amount of tokens grantted.
361    * @param time uint64 The time to be checked
362    * @param start uint64 A time representing the begining of the grant
363    * @param cliff uint64 The cliff period.
364    * @param vesting uint64 The vesting period.
365    * @return An uint representing the amount of vested tokensof a specif grant.
366    *  transferableTokens
367    *   |                         _/--------   vestedTokens rect
368    *   |                       _/
369    *   |                     _/
370    *   |                   _/
371    *   |                 _/
372    *   |                /
373    *   |              .|
374    *   |            .  |
375    *   |          .    |
376    *   |        .      |
377    *   |      .        |
378    *   |    .          |
379    *   +===+===========+---------+----------> time
380    *      Start       Clift    Vesting
381    */
382   function calculateVestedTokens(
383     uint256 tokens,
384     uint256 time,
385     uint256 start,
386     uint256 cliff,
387     uint256 vesting) constant returns (uint256)
388     {
389       // Shortcuts for before cliff and after vesting cases.
390       if (time < cliff) return 0;
391       if (time >= vesting) return tokens;
392 
393       // Interpolate all vested tokens.
394       // As before cliff the shortcut returns 0, we can use just calculate a value
395       // in the vesting rect (as shown in above's figure)
396 
397       // vestedTokens = tokens * (time - start) / (vesting - start)
398       uint256 vestedTokens = SafeMath.div(
399                                     SafeMath.mul(
400                                       tokens,
401                                       SafeMath.sub(time, start)
402                                       ),
403                                     SafeMath.sub(vesting, start)
404                                     );
405 
406       return vestedTokens;
407   }
408 
409   /**
410    * @dev Get all information about a specifc grant.
411    * @param _holder The address which will have its tokens revoked.
412    * @param _grantId The id of the token grant.
413    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
414    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
415    */
416   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
417     TokenGrant grant = grants[_holder][_grantId];
418 
419     granter = grant.granter;
420     value = grant.value;
421     start = grant.start;
422     cliff = grant.cliff;
423     vesting = grant.vesting;
424     revokable = grant.revokable;
425     burnsOnRevoke = grant.burnsOnRevoke;
426 
427     vested = vestedTokens(grant, uint64(now));
428   }
429 
430   /**
431    * @dev Get the amount of vested tokens at a specific time.
432    * @param grant TokenGrant The grant to be checked.
433    * @param time The time to be checked
434    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
435    */
436   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
437     return calculateVestedTokens(
438       grant.value,
439       uint256(time),
440       uint256(grant.start),
441       uint256(grant.cliff),
442       uint256(grant.vesting)
443     );
444   }
445 
446   /**
447    * @dev Calculate the amount of non vested tokens at a specific time.
448    * @param grant TokenGrant The grant to be checked.
449    * @param time uint64 The time to be checked
450    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
451    * passed time frame.
452    */
453   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
454     return grant.value.sub(vestedTokens(grant, time));
455   }
456 
457   /**
458    * @dev Calculate the date when the holder can trasfer all its tokens
459    * @param holder address The address of the holder
460    * @return An uint representing the date of the last transferable tokens.
461    */
462   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
463     date = uint64(now);
464     uint256 grantIndex = grants[holder].length;
465     for (uint256 i = 0; i < grantIndex; i++) {
466       date = SafeMath.max64(grants[holder][i].vesting, date);
467     }
468   }
469 }
470 
471 // QUESTIONS FOR AUDITORS:
472 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
473 // - Ensure max supply is 98,000,000
474 // - Ensure that even if not totalSupply is sold, tokens would still be transferrable after (we will up to totalSupply by creating WPX tokens)
475 
476 // vesting: 365 days, 365 days / 4 vesting
477 
478 
479 contract WPXToken is VestedToken {
480   //FIELDS
481   string public name = "Test"; //(important input)
482   string public symbol = "TST";    //(important input)
483   uint public decimals = 4;        //(important input)
484 // Multiplier for the decimals
485   uint private constant DECIMALS = 10000;
486   uint public totalSupply = 98000000*DECIMALS; //(important input)
487   //CONSTANTS
488   //Time limits
489   uint public constant STAGE_ONE_TIME_END = 10 minutes; // first day bonus (important input)
490   uint public constant STAGE_TWO_TIME_END = 15 minutes; // first week bonus (important input)
491   uint public constant STAGE_THREE_TIME_END = 30 minutes; //(important input)
492   
493 
494   //Prices of WPX
495   uint public constant PRICE_STANDARD    = 2000*DECIMALS; // WPX received per one ETH; Approximately $0.15 if ETH price $300. MAX_SUPPLY / (valuation / ethPrice)
496   uint public constant PRICE_STAGE_ONE   = PRICE_STANDARD * 150/100;  // 1ETH = 100% Bonus 1.5X or 50% 1ETH = 3000 WPX ~ $0.10(important input)
497   uint public constant PRICE_STAGE_TWO   = PRICE_STANDARD * 125/100; // 1ETH = 25% ICO Bonus           1ETH = 2500 WPX ~ $0.125(important input)
498   uint public constant PRICE_STAGE_THREE = PRICE_STANDARD; 			// Standard Price no bonus         1ETH = 2000 WPX ~ $0.15(important input)
499 
500   //WPX Token Limits 
501   uint public constant ALLOC_TEAM =         10000000*DECIMALS; // team + advisors to main address (important input)
502   uint public constant ALLOC_BOUNTIES =      3000000*DECIMALS; // Reserved Address (important input)
503   uint public constant ALLOC_WINGS =         5000000*DECIMALS; // Reserved Address (important input)
504   uint public constant ALLOC_CROWDSALE =    80000000*DECIMALS; // Crowdsale to Main address (important input)
505   
506   uint public constant PREBUY_PORTION_MAX = 20000000*DECIMALS; // this is redundantly more than what will be pre-sold
507   
508   //ASSIGNED IN INITIALIZATION
509   //Start and end times
510   uint public publicStartTime; // Time in seconds public crowd fund starts.
511   uint public privateStartTime; // Time in seconds - at this time there is no intention to do a private session.
512   uint public publicEndTime; // Time in seconds crowdsale ends
513   uint public hardcapInEth;
514 
515   //Special Addresses
516   address public multisigAddress; // Address to which all ether flows.
517   address public wpxTeamAddress; // Address to which ALLOC_TEAM, ALLOC_BOUNTIES, ALLOC_WINGS is (ultimately) sent to.
518   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
519   address public preBuy1; // Address used by pre-buy
520   address public preBuy2; // Address used by pre-buy
521   address public preBuy3; // Address used by pre-buy
522   uint public preBuyPrice1; // price for pre-buy
523   uint public preBuyPrice2; // price for pre-buy
524   uint public preBuyPrice3; // price for pre-buy
525 
526   //Running totals
527   uint public etherRaised; // Total Ether raised.
528   uint public WPXSold; // Total WPX created
529   uint public prebuyPortionTotal; // Total of Tokens purchased by pre-buy. Not to exceed PREBUY_PORTION_MAX.
530   
531   //booleans
532   bool public halted; // halts the crowd sale if true.
533   
534   // MODIFIERS
535   //Is currently in the period after the private start time and before the public start time.
536   modifier is_pre_crowdfund_period() {
537     if (now >= publicStartTime || now < privateStartTime) revert();
538     _;
539   }
540 
541   //Is currently the crowdfund period
542   modifier is_crowdfund_period() {
543     if (now < publicStartTime) revert();
544     if (isCrowdfundCompleted()) revert();
545     _;
546   }
547 
548   // Is completed
549   modifier is_crowdfund_completed() {
550     if (!isCrowdfundCompleted()) revert();
551     _;
552   }
553   function isCrowdfundCompleted() internal returns (bool) {
554     if (now > publicEndTime || WPXSold+50000*DECIMALS >= ALLOC_CROWDSALE || etherRaised >= hardcapInEth*1000000000000000000) {return true; }
555 	
556     return false;
557   }
558 
559   //May only be called by the owner address
560   modifier only_owner() {
561     if (msg.sender != ownerAddress) revert();
562     _;
563   }
564 
565   //May only be called if the crowdfund has not been halted
566   modifier is_not_halted() {
567     if (halted) revert();
568     _;
569   }
570 
571   // EVENTS
572   event PreBuy(uint _amount);
573   event Buy(address indexed _recipient, uint _amount);
574 
575   // Initialization contract assigns address of crowdfund contract and end time.
576   function WPXToken(
577     address _multisig,
578     address _wpxTeam,
579     uint _publicStartTime,
580     uint _privateStartTime,
581     uint _hardcapInEth,
582     address _prebuy1, uint _preBuyPrice1,
583     address _prebuy2, uint _preBuyPrice2,
584     address _prebuy3, uint _preBuyPrice3
585   ) {
586     ownerAddress = msg.sender;
587     publicStartTime = _publicStartTime;
588     privateStartTime = _privateStartTime;
589     publicEndTime = _publicStartTime + 30 minutes; // (important input)
590     multisigAddress = _multisig;
591     wpxTeamAddress = _wpxTeam;
592 
593     hardcapInEth = _hardcapInEth;
594 
595     preBuy1 = _prebuy1;
596     preBuyPrice1 = _preBuyPrice1;
597     preBuy2 = _prebuy2;
598     preBuyPrice2 = _preBuyPrice2;
599     preBuy3 = _prebuy3;
600     preBuyPrice3 = _preBuyPrice3;
601 
602     balances[wpxTeamAddress] += ALLOC_BOUNTIES;
603     balances[wpxTeamAddress] += ALLOC_WINGS;
604 
605     balances[ownerAddress] += ALLOC_TEAM;
606 
607     balances[ownerAddress] += ALLOC_CROWDSALE;
608   }
609 
610   // Transfer amount of tokens from sender account to recipient.
611   // Only callable after the crowd fund is completed
612   function transfer(address _to, uint _value)
613   {
614     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
615     if (!isCrowdfundCompleted()) revert();
616     super.transfer(_to, _value);
617   }
618 
619   // Transfer amount of tokens from a specified address to a recipient.
620   // Transfer amount of tokens from sender account to recipient.
621   function transferFrom(address _from, address _to, uint _value)
622     is_crowdfund_completed
623   {
624     super.transferFrom(_from, _to, _value);
625   }
626 
627   //constant function returns the current WPX price.
628   function getPriceRate()
629       constant
630       returns (uint o_rate)
631   {
632       uint delta = SafeMath.sub(now, publicStartTime);
633 
634       if (delta > STAGE_TWO_TIME_END) return PRICE_STAGE_THREE;
635       if (delta > STAGE_ONE_TIME_END) return PRICE_STAGE_TWO;
636 
637       return (PRICE_STAGE_ONE);
638   }
639 
640   // calculates wmount of WPX we get, given the wei and the rates we've defined per 1 eth
641   function calcAmount(uint _wei, uint _rate) 
642     constant
643     returns (uint) 
644   {
645     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
646   } 
647   
648   // Given the rate of a purchase and the remaining tokens in this tranche, it
649   // will throw if the sale would take it past the limit of the tranche.
650   // Returns `amount` in scope as the number of WPX tokens that it will purchase.
651   function processPurchase(uint _rate, uint _remaining)
652     internal
653     returns (uint o_amount)
654   {
655     o_amount = calcAmount(msg.value, _rate);
656 
657     if (o_amount > _remaining) revert();
658     if (!multisigAddress.send(msg.value)) revert();
659 
660     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
661     balances[msg.sender] = balances[msg.sender].add(o_amount);
662 
663     WPXSold += o_amount;
664     etherRaised += msg.value;
665   }
666 
667   //Special Function can only be called by pre-buy and only during the pre-crowdsale period.
668   function preBuy()
669     payable
670     is_pre_crowdfund_period
671     is_not_halted
672   {
673     // Pre-buy participants would get the first-day price, as well as a bonus of vested tokens
674     uint priceVested = 0;
675 
676     if (msg.sender == preBuy1) priceVested = preBuyPrice1;
677     if (msg.sender == preBuy2) priceVested = preBuyPrice2;
678     if (msg.sender == preBuy3) priceVested = preBuyPrice3;
679 
680     if (priceVested == 0) revert();
681 
682     uint amount = processPurchase(PRICE_STAGE_ONE + priceVested, SafeMath.sub(PREBUY_PORTION_MAX, prebuyPortionTotal));
683     grantVestedTokens(msg.sender, calcAmount(msg.value, priceVested), 
684       uint64(now), uint64(now) + 91 days, uint64(now) + 365 days, 
685       false, false
686     );
687     prebuyPortionTotal += amount;
688     PreBuy(amount);
689   }
690 
691   //Default function called by sending Ether to this address with no arguments.
692   //Results in creation of new WPX Tokens if transaction would not exceed hard limit of WPX Token.
693   function()
694     payable
695     is_crowdfund_period
696     is_not_halted
697   {
698     uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, WPXSold));
699     Buy(msg.sender, amount);
700   }
701 
702   // To be called at the end of crowdfund period
703   // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length
704   function grantVested(address _wpxTeamAddress, address _wpxFundAddress)
705     is_crowdfund_completed
706     only_owner
707     is_not_halted
708   {
709     // Grant tokens pre-allocated for the team
710     grantVestedTokens(
711       _wpxTeamAddress, ALLOC_TEAM,
712       uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, 
713       false, false
714     );
715 
716     // Grant tokens that remain after crowdsale to the WPX fund, vested for 2 years
717     grantVestedTokens(
718       _wpxFundAddress, balances[ownerAddress],
719       uint64(now), uint64(now) + 182 days , uint64(now) + 730 days, 
720       false, false
721     );
722   }
723 
724   //May be used by owner of contract to halt crowdsale and no longer except ether.
725   function toggleHalt(bool _halted)
726     only_owner
727   {
728     halted = _halted;
729   }
730 
731   //failsafe drain
732   function drain()
733     only_owner
734   {
735     if (!ownerAddress.send(this.balance)) revert();
736   }
737 }