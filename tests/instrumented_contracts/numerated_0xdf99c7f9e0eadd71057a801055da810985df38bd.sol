1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 
8 contract Math {
9   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner {
59     require(newOwner != address(0));
60     owner = newOwner;
61   }
62 
63 }
64 
65 
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   uint256 public totalSupply;
74   function balanceOf(address who) constant returns (uint256);
75   function transfer(address to, uint256 value) returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 contract SafeMath {
85   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
86     uint256 c = a * b;
87     assert(a == 0 || c / a == b);
88     return c;
89   }
90 
91   function div(uint256 a, uint256 b) internal constant returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   function add(uint256 a, uint256 b) internal constant returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 
109   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
110     return a >= b ? a : b;
111   }
112 
113   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
114     return a < b ? a : b;
115   }
116 
117   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
118     return a >= b ? a : b;
119   }
120 
121   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
122     return a < b ? a : b;
123   }
124 }
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is SafeMath, ERC20Basic {
133 
134   mapping(address => uint256) balances;
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint _value) returns (bool){
142     balances[msg.sender] = sub(balances[msg.sender],_value);
143     balances[_to] = add(balances[_to],_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) constant returns (uint balance) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164   function allowance(address owner, address spender) constant returns (uint256);
165   function transferFrom(address from, address to, uint256 value) returns (bool);
166   function approve(address spender, uint256 value) returns (bool);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amout of tokens to be transfered
186    */
187   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
188     var _allowance = allowed[_from][msg.sender];
189 
190     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191     // require (_value <= _allowance);
192 
193     balances[_to] = add(balances[_to],_value);
194     balances[_from] = sub(balances[_from],_value);
195     allowed[_from][msg.sender] = sub(_allowance,_value);
196     Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) returns (bool) {
206 
207     // To change the approve amount you first have to reduce the addresses`
208     //  allowance to zero by calling `approve(_spender, 0)` if it is not
209     //  already 0 to mitigate the race condition described here:
210     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
212 
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifing the amount of tokens still available for the spender.
223    */
224   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
225     return allowed[_owner][_spender];
226   }
227 
228 }
229 
230 
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will recieve the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
258     totalSupply = add(totalSupply,_amount);
259     balances[_to] = add(balances[_to],_amount);
260     Mint(_to, _amount);
261     return true;
262   }
263 
264   /**
265    * @dev Function to stop minting new tokens.
266    * @return True if the operation was successful.
267    */
268   function finishMinting() onlyOwner returns (bool) {
269     mintingFinished = true;
270     MintFinished();
271     return true;
272   }
273 }
274 
275 
276 
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev modifier to allow actions only when the contract IS paused
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev modifier to allow actions only when the contract IS NOT paused
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyOwner whenNotPaused {
309     paused = true;
310     Pause();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() onlyOwner whenPaused {
317     paused = false;
318     Unpause();
319   }
320 }
321 
322 
323 /**
324  * Pausable token
325  *
326  * Simple ERC20 Token example, with pausable token creation
327  **/
328 
329 contract PausableToken is StandardToken, Pausable {
330 
331   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
332     return super.transfer(_to, _value);
333   }
334 
335   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
336     return super.transferFrom(_from, _to, _value);
337   }
338 }
339 
340 /**
341  * @title LimitedTransferToken
342  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
343  * transferability for different events. It is intended to be used as a base class for other token
344  * contracts.
345  * LimitedTransferToken has been designed to allow for different limiting factors,
346  * this can be achieved by recursively calling super.transferableTokens() until the base class is
347  * hit. For example:
348  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
349  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
350  *     }
351  * A working example is VestedToken.sol:
352  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
353  */
354 
355 contract LimitedTransferToken is ERC20 {
356 
357   /**
358    * @dev Checks whether it can transfer or otherwise throws.
359    */
360   modifier canTransfer(address _sender, uint256 _value) {
361    require(_value <= transferableTokens(_sender, uint64(now)));
362    _;
363   }
364 
365   /**
366    * @dev Checks modifier and allows transfer if tokens are not locked.
367    * @param _to The address that will recieve the tokens.
368    * @param _value The amount of tokens to be transferred.
369    */
370   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
371     return super.transfer(_to, _value);
372   }
373 
374   /**
375   * @dev Checks modifier and allows transfer if tokens are not locked.
376   * @param _from The address that will send the tokens.
377   * @param _to The address that will recieve the tokens.
378   * @param _value The amount of tokens to be transferred.
379   */
380   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
381     return super.transferFrom(_from, _to, _value);
382   }
383 
384   /**
385    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
386    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
387    * specific logic for limiting token transferability for a holder over time.
388    */
389   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
390     return balanceOf(holder);
391   }
392 }
393 
394 /**
395  * @title Vested token
396  * @dev Tokens that can be vested for a group of addresses.
397  */
398 contract VestedToken is Math, StandardToken, LimitedTransferToken {
399 
400   uint256 MAX_GRANTS_PER_ADDRESS = 20;
401 
402   struct TokenGrant {
403     address granter;     // 20 bytes
404     uint256 value;       // 32 bytes
405     uint64 cliff;
406     uint64 vesting;
407     uint64 start;        // 3 * 8 = 24 bytes
408     bool revokable;
409     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
410   } // total 78 bytes = 3 sstore per operation (32 per sstore)
411 
412   mapping (address => TokenGrant[]) public grants;
413 
414   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
415 
416   /**
417    * @dev Grant tokens to a specified address
418    * @param _to address The address which the tokens will be granted to.
419    * @param _value uint256 The amount of tokens to be granted.
420    * @param _start uint64 Time of the beginning of the grant.
421    * @param _cliff uint64 Time of the cliff period.
422    * @param _vesting uint64 The vesting period.
423    */
424   function grantVestedTokens(
425     address _to,
426     uint256 _value,
427     uint64 _start,
428     uint64 _cliff,
429     uint64 _vesting,
430     bool _revokable,
431     bool _burnsOnRevoke
432   ) public {
433 
434     // Check for date inconsistencies that may cause unexpected behavior
435     require(_cliff >= _start && _vesting >= _cliff);
436 
437     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
438 
439     uint256 count = grants[_to].push(
440                 TokenGrant(
441                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
442                   _value,
443                   _cliff,
444                   _vesting,
445                   _start,
446                   _revokable,
447                   _burnsOnRevoke
448                 )
449               );
450 
451     transfer(_to, _value);
452 
453     NewTokenGrant(msg.sender, _to, _value, count - 1);
454   }
455 
456   /**
457    * @dev Revoke the grant of tokens of a specifed address.
458    * @param _holder The address which will have its tokens revoked.
459    * @param _grantId The id of the token grant.
460    */
461   function revokeTokenGrant(address _holder, uint256 _grantId) public {
462     TokenGrant storage grant = grants[_holder][_grantId];
463 
464     require(grant.revokable);
465     require(grant.granter == msg.sender); // Only granter can revoke it
466 
467     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
468 
469     uint256 nonVested = nonVestedTokens(grant, uint64(now));
470 
471     // remove grant from array
472     delete grants[_holder][_grantId];
473     grants[_holder][_grantId] = grants[_holder][sub(grants[_holder].length,1)];
474     grants[_holder].length -= 1;
475 
476     balances[receiver] = add(balances[receiver],nonVested);
477     balances[_holder] = sub(balances[_holder],nonVested);
478 
479     Transfer(_holder, receiver, nonVested);
480   }
481 
482 
483   /**
484    * @dev Calculate the total amount of transferable tokens of a holder at a given time
485    * @param holder address The address of the holder
486    * @param time uint64 The specific time.
487    * @return An uint256 representing a holder's total amount of transferable tokens.
488    */
489   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
490     uint256 grantIndex = tokenGrantsCount(holder);
491 
492     if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
493 
494     // Iterate through all the grants the holder has, and add all non-vested tokens
495     uint256 nonVested = 0;
496     for (uint256 i = 0; i < grantIndex; i++) {
497       nonVested = add(nonVested, nonVestedTokens(grants[holder][i], time));
498     }
499 
500     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
501     uint256 vestedTransferable = sub(balanceOf(holder), nonVested);
502 
503     // Return the minimum of how many vested can transfer and other value
504     // in case there are other limiting transferability factors (default is balanceOf)
505     return min256(vestedTransferable, super.transferableTokens(holder, time));
506   }
507 
508   /**
509    * @dev Check the amount of grants that an address has.
510    * @param _holder The holder of the grants.
511    * @return A uint256 representing the total amount of grants.
512    */
513   function tokenGrantsCount(address _holder) constant returns (uint256 index) {
514     return grants[_holder].length;
515   }
516 
517   /**
518    * @dev Calculate amount of vested tokens at a specifc time.
519    * @param tokens uint256 The amount of tokens grantted.
520    * @param time uint64 The time to be checked
521    * @param start uint64 A time representing the begining of the grant
522    * @param cliff uint64 The cliff period.
523    * @param vesting uint64 The vesting period.
524    * @return An uint256 representing the amount of vested tokensof a specif grant.
525    *  transferableTokens
526    *   |                         _/--------   vestedTokens rect
527    *   |                       _/
528    *   |                     _/
529    *   |                   _/
530    *   |                 _/
531    *   |                /
532    *   |              .|
533    *   |            .  |
534    *   |          .    |
535    *   |        .      |
536    *   |      .        |
537    *   |    .          |
538    *   +===+===========+---------+----------> time
539    *      Start       Clift    Vesting
540    */
541   function calculateVestedTokens(
542     uint256 tokens,
543     uint256 time,
544     uint256 start,
545     uint256 cliff,
546     uint256 vesting) constant returns (uint256)
547     {
548       // Shortcuts for before cliff and after vesting cases.
549       if (time < cliff) return 0;
550       if (time >= vesting) return tokens;
551 
552       // Interpolate all vested tokens.
553       // As before cliff the shortcut returns 0, we can use just calculate a value
554       // in the vesting rect (as shown in above's figure)
555 
556       // vestedTokens = tokens * (time - start) / (vesting - start)
557       uint256 vestedTokens = div(
558                                     mul(
559                                       tokens,
560                                       sub(time, start)
561                                       ),
562                                     sub(vesting, start)
563                                     );
564 
565       return vestedTokens;
566   }
567 
568   /**
569    * @dev Get all information about a specifc grant.
570    * @param _holder The address which will have its tokens revoked.
571    * @param _grantId The id of the token grant.
572    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
573    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
574    */
575   function tokenGrant(address _holder, uint256 _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
576     TokenGrant storage grant = grants[_holder][_grantId];
577 
578     granter = grant.granter;
579     value = grant.value;
580     start = grant.start;
581     cliff = grant.cliff;
582     vesting = grant.vesting;
583     revokable = grant.revokable;
584     burnsOnRevoke = grant.burnsOnRevoke;
585 
586     vested = vestedTokens(grant, uint64(now));
587   }
588 
589   /**
590    * @dev Get the amount of vested tokens at a specific time.
591    * @param grant TokenGrant The grant to be checked.
592    * @param time The time to be checked
593    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
594    */
595   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
596     return calculateVestedTokens(
597       grant.value,
598       uint256(time),
599       uint256(grant.start),
600       uint256(grant.cliff),
601       uint256(grant.vesting)
602     );
603   }
604 
605   /**
606    * @dev Calculate the amount of non vested tokens at a specific time.
607    * @param grant TokenGrant The grant to be checked.
608    * @param time uint64 The time to be checked
609    * @return An uint256 representing the amount of non vested tokens of a specifc grant on the
610    * passed time frame.
611    */
612   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
613     return sub(grant.value,vestedTokens(grant, time));
614   }
615 
616   /**
617    * @dev Calculate the date when the holder can trasfer all its tokens
618    * @param holder address The address of the holder
619    * @return An uint256 representing the date of the last transferable tokens.
620    */
621   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
622     date = uint64(now);
623     uint256 grantIndex = grants[holder].length;
624     for (uint256 i = 0; i < grantIndex; i++) {
625       date = max64(grants[holder][i].vesting, date);
626     }
627   }
628 }
629 
630 /**
631  * @title Burnable Token
632  * @dev Token that can be irreversibly burned (destroyed).
633  */
634 
635 contract BurnableToken is SafeMath, StandardToken {
636 
637 
638     event Burn(address indexed burner, uint indexed value);
639 
640     /**
641      * @dev Burns a specific amount of tokens.
642      * @param _value The amount of token to be burned.
643      */
644     function burn(uint _value)
645         public
646     {
647         require(_value > 0);
648 
649         address burner = msg.sender;
650         balances[burner] = sub(balances[burner], _value);
651         totalSupply = sub(totalSupply, _value);
652         Burn(burner, _value);
653     }
654 }
655 
656 
657 /**
658  * @title PLC
659  * @dev PLC is ERC20 token contract, inheriting MintableToken, PausableToken,
660  * VestedToken, BurnableToken contract from open zeppelin.
661  */
662 contract PLC is MintableToken, PausableToken, VestedToken, BurnableToken {
663   string public name = "PlusCoin";
664   string public symbol = "PLC";
665   uint256 public decimals = 18;
666 }