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
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances. 
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        throw;
81      }
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of. 
99   * @return An uint representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) constant returns (uint balance) {
102     return balances[_owner];
103   }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant returns (uint);
112   function transferFrom(address from, address to, uint value);
113   function approve(address spender, uint value);
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // if (_value > _allowance) throw;
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint _value) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens than an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint specifing the amount of tokens still avaible for the spender.
170    */
171   function allowance(address _owner, address _spender) constant returns (uint remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 
178 /**
179  * @title LimitedTransferToken
180  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
181  * transferability for different events. It is intended to be used as a base class for other token 
182  * contracts. 
183  * LimitedTransferToken has been designed to allow for different limiting factors,
184  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
185  * hit. For example:
186  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
187  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
188  *     }
189  * A working example is VestedToken.sol:
190  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
191  */
192 
193 contract LimitedTransferToken is ERC20 {
194 
195   /**
196    * @dev Checks whether it can transfer or otherwise throws.
197    */
198   modifier canTransfer(address _sender, uint _value) {
199    if (_value > transferableTokens(_sender, uint64(now))) throw;
200    _;
201   }
202 
203   /**
204    * @dev Checks modifier and allows transfer if tokens are not locked.
205    * @param _to The address that will recieve the tokens.
206    * @param _value The amount of tokens to be transferred.
207    */
208   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
209     super.transfer(_to, _value);
210   }
211 
212   /**
213   * @dev Checks modifier and allows transfer if tokens are not locked.
214   * @param _from The address that will send the tokens.
215   * @param _to The address that will recieve the tokens.
216   * @param _value The amount of tokens to be transferred.
217   */
218   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
219     super.transferFrom(_from, _to, _value);
220   }
221 
222   /**
223    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
224    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
225    * specific logic for limiting token transferability for a holder over time.
226    */
227   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
228     return balanceOf(holder);
229   }
230 }
231 
232 
233 /**
234  * @title Vested token
235  * @dev Tokens that can be vested for a group of addresses.
236  */
237 contract VestedToken is StandardToken, LimitedTransferToken {
238 
239   uint256 MAX_GRANTS_PER_ADDRESS = 20;
240 
241   struct TokenGrant {
242     address granter;     
243     uint256 value;       
244     uint64 cliff;
245     uint64 vesting;
246     uint64 start;        
247     bool revokable;
248     bool burnsOnRevoke;  
249   }
250 
251   mapping (address => TokenGrant[]) public grants;
252 
253   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
254 
255   /**
256    * @dev Grant tokens to a specified address
257    * @param _to address The address which the tokens will be granted to.
258    * @param _value uint256 The amount of tokens to be granted.
259    * @param _start uint64 Time of the beginning of the grant.
260    * @param _cliff uint64 Time of the cliff period.
261    * @param _vesting uint64 The vesting period.
262    */
263   function grantVestedTokens(
264     address _to,
265     uint256 _value,
266     uint64 _start,
267     uint64 _cliff,
268     uint64 _vesting,
269     bool _revokable,
270     bool _burnsOnRevoke
271   ) public {
272 
273     // Check for date inconsistencies that may cause unexpected behavior
274     if (_cliff < _start || _vesting < _cliff) {
275       throw;
276     }
277 
278     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
279 
280     uint count = grants[_to].push(
281                 TokenGrant(
282                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
283                   _value,
284                   _cliff,
285                   _vesting,
286                   _start,
287                   _revokable,
288                   _burnsOnRevoke
289                 )
290               );
291 
292     transfer(_to, _value);
293 
294     NewTokenGrant(msg.sender, _to, _value, count - 1);
295   }
296 
297   /**
298    * @dev Revoke the grant of tokens of a specifed address.
299    * @param _holder The address which will have its tokens revoked.
300    * @param _grantId The id of the token grant.
301    */
302   function revokeTokenGrant(address _holder, uint _grantId) public {
303     TokenGrant grant = grants[_holder][_grantId];
304 
305     if (!grant.revokable) { // Check if grant was revokable
306       throw;
307     }
308 
309     if (grant.granter != msg.sender) { // Only granter can revoke it
310       throw;
311     }
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
333    * @return An uint representing a holder's total amount of transferable tokens.
334    */
335   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
336     uint256 grantIndex = tokenGrantsCount(holder);
337 
338     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
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
351     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
352   }
353 
354   /**
355    * @dev Check the amount of grants that an address has.
356    * @param _holder The holder of the grants.
357    * @return A uint representing the total amount of grants.
358    */
359   function tokenGrantsCount(address _holder) constant returns (uint index) {
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
370    * @return An uint representing the amount of vested tokensof a specif grant.
371   */
372   function calculateVestedTokens(
373     uint256 tokens,
374     uint256 time,
375     uint256 start,
376     uint256 cliff,
377     uint256 vesting) constant returns (uint256)
378     {
379       // Shortcuts for before cliff and after vesting cases.
380       if (time < cliff) return 0;
381       if (time >= vesting) return tokens;
382 
383       // vestedTokens = tokens * (time - start) / (vesting - start)
384       uint256 vestedTokens = SafeMath.div(
385                                     SafeMath.mul(
386                                       tokens,
387                                       SafeMath.sub(time, start)
388                                       ),
389                                     SafeMath.sub(vesting, start)
390                                     );
391 
392       return vestedTokens;
393   }
394 
395   /**
396    * @dev Get all information about a specifc grant.
397    * @param _holder The address which will have its tokens revoked.
398    * @param _grantId The id of the token grant.
399    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
400    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
401    */
402   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
403     TokenGrant grant = grants[_holder][_grantId];
404 
405     granter = grant.granter;
406     value = grant.value;
407     start = grant.start;
408     cliff = grant.cliff;
409     vesting = grant.vesting;
410     revokable = grant.revokable;
411     burnsOnRevoke = grant.burnsOnRevoke;
412 
413     vested = vestedTokens(grant, uint64(now));
414   }
415 
416   /**
417    * @dev Get the amount of vested tokens at a specific time.
418    * @param grant TokenGrant The grant to be checked.
419    * @param time The time to be checked
420    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
421    */
422   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
423     return calculateVestedTokens(
424       grant.value,
425       uint256(time),
426       uint256(grant.start),
427       uint256(grant.cliff),
428       uint256(grant.vesting)
429     );
430   }
431 
432   /**
433    * @dev Calculate the amount of non vested tokens at a specific time.
434    * @param grant TokenGrant The grant to be checked.
435    * @param time uint64 The time to be checked
436    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
437    * passed time frame.
438    */
439   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
440     return grant.value.sub(vestedTokens(grant, time));
441   }
442 
443   /**
444    * @dev Calculate the date when the holder can trasfer all its tokens
445    * @param holder address The address of the holder
446    * @return An uint representing the date of the last transferable tokens.
447    */
448   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
449     date = uint64(now);
450     uint256 grantIndex = grants[holder].length;
451     for (uint256 i = 0; i < grantIndex; i++) {
452       date = SafeMath.max64(grants[holder][i].vesting, date);
453     }
454   }
455 }
456 
457 // vesting: 365 days, 365 days / 4 vesting
458 
459 
460 contract XFM is VestedToken {
461 
462   string public name = "XferMoney";
463   string public symbol = "XFM";
464   uint public decimals = 4;
465  
466   //Special Addresses
467   address public multisigAddress=0x749BD34C771456a8DE28Aa0883b00d11273E2Ede; // Address to which all ether fund receive.
468   address public XferMoneyTeamAddress=0xc179FCbdEef2DA2A61Ed9b1817942d72B0a46c8a; // Address to which team tokens are reserved.
469   address public XferMoneyMarketing=0x9EED63b353Af69cFbDC0e15A1b037429f0780D1c; // Address to which Marketing tokens are reserved.
470   address public ownerAddress; // Address of the contract owner. Can halt the crowdsale.
471 
472   //Crowdsale Time
473   uint public constant publicStartTime=now; // Time in seconds when public Presale starts.
474   uint public constant PRESALE_START_WEEK1=1516406401; // Time in seconds when Presale Weel 1 starts.
475   uint public constant PRESALE_START_WEEK2=1517011201; // Time in seconds when Presale Week 2 starts.
476   uint public constant PRESALE_START_WEEK3=1517616001; // Time in seconds when Presale Week 3 starts.
477   uint public constant CROWDSALE_START=1518652801; // Time in seconds when Public Crowdsale starts.
478   uint public publicEndTime=1522540799; // Time in seconds XFM crowdsale ends
479   
480   // Multiplier for the decimals
481   uint private constant DECIMALS = 10000;
482 
483   //Prices of XFM
484   uint public constant PRICE_CROWDSALE    = 8000*DECIMALS; // XFM Price per one ETH during crowdsale; 
485   uint public constant PRICE_PRESALE_START   = PRICE_CROWDSALE * 140/100; // Price with 40% Bonus XFM
486   uint public constant PRICE_PRESALE_WEEK1   = PRICE_CROWDSALE * 125/100; //  Price with 25% Bonus XFM
487   uint public constant PRICE_PRESALE_WEEK2 = PRICE_CROWDSALE * 118/100; //   Price with 18% Bonus XFM
488   uint public constant PRICE_PRESALE_WEEK3 = PRICE_CROWDSALE * 110/100; //   Price with 10% Bonus XFM
489   
490   //Assigned XFM Tokens 
491   uint256 public constant _initialSupply=  250000000*DECIMALS; // Total tokens assigned initially 
492   uint public constant ALLOC_TEAM =         62500000*DECIMALS; // Token reserved for team
493   uint public constant ALLOC_CROWDSALE =    175000000*DECIMALS; // Allocated for Crowdsale(Phase 1 + Phase 2) 
494   uint public constant ALLOC_MARKETING =    12500000*DECIMALS; // Allocated for Marketing, Bonties 
495   
496   //Running totals
497   uint public etherRaised; // Total Ether raised.
498   uint public XFMSold; // Total XFM sold
499   uint public hardcapInEth=25000* 1 ether;
500   uint256 public totalSupply = _initialSupply;
501   
502   //booleans
503   bool public halted; // halts the crowd sale if true.
504 
505   // MODIFIERS
506   //Is currently in the period after the private start time and before the public start time.
507   modifier is_pre_crowdfund_period() {
508     if (now >= publicStartTime ) throw;
509     _;
510   }
511 
512   //Is currently the crowdfund period
513   modifier is_crowdfund_period() {
514     if (now < publicStartTime) throw;
515     if (isCrowdfundCompleted()) throw;
516     _;
517   }
518 
519   // Is completed
520   modifier is_crowdfund_completed() {
521     if (!isCrowdfundCompleted()) throw;
522     _;
523   }
524   function isCrowdfundCompleted() internal returns (bool) {
525     if (now > publicEndTime && XFMSold >= ALLOC_CROWDSALE) return true; // Crowdsale can also be halted by the owner.
526     return false;
527   }
528 
529   //May only be called by the owner address
530   modifier only_owner() {
531     if (msg.sender != ownerAddress) throw;
532     _;
533   }
534 
535   //May only be called if the crowdfund has not been halted
536   modifier is_not_halted() {
537     if (halted) throw;
538     _;
539   }
540 
541   // EVENTS
542   event Buy(address indexed _recipient, uint _amount);
543 
544   // Initialization contract assigns address of crowdfund contract.
545   function XFM() {
546     ownerAddress = msg.sender;
547     balances[XferMoneyTeamAddress] += ALLOC_TEAM;
548     balances[XferMoneyMarketing] += ALLOC_MARKETING;
549     balances[ownerAddress] += ALLOC_CROWDSALE;
550     }
551 
552   // Transfer amount of tokens from sender account to recipient.
553   // Only callable after the crowd fund is completed
554   function transfer(address _to, uint _value)
555   {
556     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
557    // if (!isCrowdfundCompleted()) throw;
558     super.transfer(_to, _value);
559   }
560 
561   // Transfer amount of tokens from a specified address to a recipient.
562   // Transfer amount of tokens from sender account to recipient.
563   function transferFrom(address _from, address _to, uint _value)
564     is_crowdfund_completed
565   {
566     super.transferFrom(_from, _to, _value);
567   }
568 
569   //constant function returns the current XFM price.
570   function getPriceRate()
571       constant
572       returns (uint o_rate)
573   {
574       uint delta = now;
575       if (delta < PRESALE_START_WEEK1) return PRICE_PRESALE_START;
576       if (delta < PRESALE_START_WEEK2) return PRICE_PRESALE_WEEK1;
577       if (delta < PRESALE_START_WEEK3) return PRICE_PRESALE_WEEK2;
578       if (delta < CROWDSALE_START) return PRICE_PRESALE_WEEK3;
579       return (PRICE_CROWDSALE);
580   }
581 
582   // calculates amount of XFM we get, given the wei and the rates defined per 1 eth
583   function calcAmount(uint _wei, uint _rate) 
584     constant
585     returns (uint) 
586   {
587     return SafeMath.div(SafeMath.mul(_wei, _rate), 1 ether);
588   } 
589   
590   // Returns `amount` in scope as the number of XFM tokens that it will purchase.
591   function processPurchase(uint _rate, uint _remaining)
592     internal
593     returns (uint o_amount)
594   {
595     o_amount = calcAmount(msg.value, _rate);
596 
597     if (o_amount > _remaining) throw;
598     if (!multisigAddress.send(msg.value)) throw;
599 
600     balances[ownerAddress] = balances[ownerAddress].sub(o_amount);
601     balances[msg.sender] = balances[msg.sender].add(o_amount);
602 
603     XFMSold += o_amount;
604     etherRaised += msg.value;
605   }
606 
607   //Default function called by sending Ether to this address with no arguments.
608   //Results in creation of new XFM Tokens if transaction would not exceed hard limit of XFM Token.
609   function() payable is_crowdfund_period    is_not_halted
610   {
611     uint amount = processPurchase(getPriceRate(), SafeMath.sub(ALLOC_CROWDSALE, XFMSold));
612     Buy(msg.sender, amount);
613   }
614 
615   // To be called at the end of crowdfund period
616   // WARNING: transfer(), which is called by grantVestedTokens(), wants a minimum message length
617   function grantVested(address _XferMoneyTeamAddress, address _XferMoneyFundAddress)
618     is_crowdfund_completed
619     only_owner
620     is_not_halted
621   {
622     // Grant tokens pre-allocated for the team
623     grantVestedTokens(
624       _XferMoneyTeamAddress, ALLOC_TEAM,
625       uint64(now), uint64(now) + 91 days , uint64(now) + 365 days, 
626       false, false
627     );
628 
629     // Grant tokens that remain after crowdsale to the XferMoney fund, vested for 2 years
630     grantVestedTokens(
631       _XferMoneyFundAddress, balances[ownerAddress],
632       uint64(now), uint64(now) + 182 days , uint64(now) + 730 days, 
633       false, false
634     );
635   }
636 
637   //May be used by owner of contract to halt crowdsale and no longer except ether.
638   function toggleHalt(bool _halted)
639     only_owner
640   {
641     halted = _halted;
642   }
643 
644   //failsafe drain
645   function drain()
646     only_owner
647   {
648     if (!ownerAddress.send(this.balance)) throw;
649   }
650 }