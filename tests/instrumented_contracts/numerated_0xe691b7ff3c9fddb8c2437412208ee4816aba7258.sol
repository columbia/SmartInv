1 pragma solidity ^0.4.13;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 library SafeMath {
59   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
60     uint256 c = a * b;
61     assert(a == 0 || c / a == b);
62     return c;
63   }
64 
65   function div(uint256 a, uint256 b) internal constant returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function add(uint256 a, uint256 b) internal constant returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public constant returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract LegalLazyScheduler is Ownable {
92     uint64 public lastUpdate;
93     uint64 public intervalDuration;
94     bool schedulerEnabled = false;
95     function() internal callback;
96 
97     event LogRegisteredInterval(uint64 date, uint64 duration);
98     event LogProcessedInterval(uint64 date, uint64 intervals);    
99     /**
100     * Triggers the registered callback function for the number of periods passed since last update
101     */
102     modifier intervalTrigger() {
103         uint64 currentTime = uint64(now);
104         uint64 requiredIntervals = (currentTime - lastUpdate) / intervalDuration;
105         if( schedulerEnabled && (requiredIntervals > 0)) {
106             LogProcessedInterval(lastUpdate, requiredIntervals);
107             while (requiredIntervals-- > 0) {
108                 callback();
109             }
110             lastUpdate = currentTime;
111         }
112         _;
113     }
114     
115     function LegalLazyScheduler() {
116         lastUpdate = uint64(now);
117     }
118 
119     function enableScheduler() onlyOwner public {
120         schedulerEnabled = true;
121     }
122 
123     function registerIntervalCall(uint64 _intervalDuration, function() internal _callback) internal {
124         lastUpdate = uint64(now);
125         intervalDuration = _intervalDuration;
126         callback = _callback;
127         LogRegisteredInterval(lastUpdate, intervalDuration);        
128     }
129 }
130 
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public constant returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 contract LimitedTransferToken is ERC20 {
139 
140   /**
141    * @dev Checks whether it can transfer or otherwise throws.
142    */
143   modifier canTransfer(address _sender, uint256 _value) {
144     require(_value <= transferableTokens(_sender, uint64(now)));
145    _;
146   }
147 
148   /**
149    * @dev Checks modifier and allows transfer if tokens are not locked.
150    * @param _to The address that will receive the tokens.
151    * @param _value The amount of tokens to be transferred.
152    */
153   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
154     return super.transfer(_to, _value);
155   }
156 
157   /**
158   * @dev Checks modifier and allows transfer if tokens are not locked.
159   * @param _from The address that will send the tokens.
160   * @param _to The address that will receive the tokens.
161   * @param _value The amount of tokens to be transferred.
162   */
163   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
164     return super.transferFrom(_from, _to, _value);
165   }
166 
167   /**
168    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
169    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
170    * specific logic for limiting token transferability for a holder over time.
171    */
172   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
173     return balanceOf(holder);
174   }
175 }
176 
177 contract BasicToken is ERC20Basic {
178   using SafeMath for uint256;
179 
180   mapping(address => uint256) balances;
181 
182   /**
183   * @dev transfer token for a specified address
184   * @param _to The address to transfer to.
185   * @param _value The amount to be transferred.
186   */
187   function transfer(address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189 
190     // SafeMath.sub will throw if there is not enough balance.
191     balances[msg.sender] = balances[msg.sender].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     Transfer(msg.sender, _to, _value);
194     return true;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param _owner The address to query the the balance of.
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address _owner) public constant returns (uint256 balance) {
203     return balances[_owner];
204   }
205 
206 }
207 
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221 
222     uint256 _allowance = allowed[_from][msg.sender];
223 
224     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
225     // require (_value <= _allowance);
226 
227     balances[_from] = balances[_from].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = _allowance.sub(_value);
230     Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    */
266   function increaseApproval (address _spender, uint _addedValue)
267     returns (bool success) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   function decreaseApproval (address _spender, uint _subtractedValue)
274     returns (bool success) {
275     uint oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue > oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 contract MintableToken is StandardToken, Ownable {
288   event Mint(address indexed to, uint256 amount);
289   event MintFinished();
290 
291   bool public mintingFinished = false;
292 
293 
294   modifier canMint() {
295     require(!mintingFinished);
296     _;
297   }
298 
299   /**
300    * @dev Function to mint tokens
301    * @param _to The address that will receive the minted tokens.
302    * @param _amount The amount of tokens to mint.
303    * @return A boolean that indicates if the operation was successful.
304    */
305   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
306     totalSupply = totalSupply.add(_amount);
307     balances[_to] = balances[_to].add(_amount);
308     Mint(_to, _amount);
309     Transfer(0x0, _to, _amount);
310     return true;
311   }
312 
313   /**
314    * @dev Function to stop minting new tokens.
315    * @return True if the operation was successful.
316    */
317   function finishMinting() onlyOwner public returns (bool) {
318     mintingFinished = true;
319     MintFinished();
320     return true;
321   }
322 }
323 
324 contract VestedToken is StandardToken, LimitedTransferToken, Ownable {
325 
326   uint256 MAX_GRANTS_PER_ADDRESS = 20;
327 
328   struct TokenGrant {
329     address granter;     // 20 bytes
330     uint256 value;       // 32 bytes
331     uint64 cliff;
332     uint64 vesting;
333     uint64 start;        // 3 * 8 = 24 bytes
334     bool revokable;
335     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
336   } // total 78 bytes = 3 sstore per operation (32 per sstore)
337 
338   mapping (address => TokenGrant[]) public grants;
339 
340   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
341 
342   /**
343    * @dev Grant tokens to a specified address
344    * @param _to address The address which the tokens will be granted to.
345    * @param _value uint256 The amount of tokens to be granted.
346    * @param _start uint64 Time of the beginning of the grant.
347    * @param _cliff uint64 Time of the cliff period.
348    * @param _vesting uint64 The vesting period.
349    */
350   function grantVestedTokens(
351     address _to,
352     uint256 _value,
353     uint64 _start,
354     uint64 _cliff,
355     uint64 _vesting,
356     bool _revokable,
357     bool _burnsOnRevoke
358   ) onlyOwner public {
359 
360     // Check for date inconsistencies that may cause unexpected behavior
361     require(_cliff >= _start && _vesting >= _cliff);
362 
363     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
364 
365     uint256 count = grants[_to].push(
366                 TokenGrant(
367                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
368                   _value,
369                   _cliff,
370                   _vesting,
371                   _start,
372                   _revokable,
373                   _burnsOnRevoke
374                 )
375               );
376 
377     transfer(_to, _value);
378 
379     NewTokenGrant(msg.sender, _to, _value, count - 1);
380   }
381 
382   /**
383    * @dev Revoke the grant of tokens of a specifed address.
384    * @param _holder The address which will have its tokens revoked.
385    * @param _grantId The id of the token grant.
386    */
387   function revokeTokenGrant(address _holder, uint256 _grantId) public {
388     TokenGrant storage grant = grants[_holder][_grantId];
389 
390     require(grant.revokable);
391     require(grant.granter == msg.sender); // Only granter can revoke it
392 
393     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
394 
395     uint256 nonVested = nonVestedTokens(grant, uint64(now));
396 
397     // remove grant from array
398     delete grants[_holder][_grantId];
399     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
400     grants[_holder].length -= 1;
401 
402     balances[receiver] = balances[receiver].add(nonVested);
403     balances[_holder] = balances[_holder].sub(nonVested);
404 
405     Transfer(_holder, receiver, nonVested);
406   }
407 
408 
409   /**
410    * @dev Calculate the total amount of transferable tokens of a holder at a given time
411    * @param holder address The address of the holder
412    * @param time uint64 The specific time.
413    * @return An uint256 representing a holder's total amount of transferable tokens.
414    */
415   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
416     uint256 grantIndex = tokenGrantsCount(holder);
417 
418     if (grantIndex == 0) 
419       return super.transferableTokens(holder, time); // shortcut for holder without grants
420 
421     // Iterate through all the grants the holder has, and add all non-vested tokens
422     uint256 nonVested = 0;
423     for (uint256 i = 0; i < grantIndex; i++) {
424       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
425     }
426 
427     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
428     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
429 
430     // Return the minimum of how many vested can transfer and other value
431     // in case there are other limiting transferability factors (default is balanceOf)
432     return Math.min256(vestedTransferable, super.transferableTokens(holder, time));
433   }
434 
435   /**
436    * @dev Check the amount of grants that an address has.
437    * @param _holder The holder of the grants.
438    * @return A uint256 representing the total amount of grants.
439    */
440   function tokenGrantsCount(address _holder) public constant returns (uint256 index) {
441     return grants[_holder].length;
442   }
443 
444   /**
445    * @dev Calculate amount of vested tokens at a specific time
446    * @param tokens uint256 The amount of tokens granted
447    * @param time uint64 The time to be checked
448    * @param start uint64 The time representing the beginning of the grant
449    * @param cliff uint64  The cliff period, the period before nothing can be paid out
450    * @param vesting uint64 The vesting period
451    * @return An uint256 representing the amount of vested tokens of a specific grant
452    *  transferableTokens
453    *   |                         _/--------   vestedTokens rect
454    *   |                       _/
455    *   |                     _/
456    *   |                   _/
457    *   |                 _/
458    *   |                /
459    *   |              .|
460    *   |            .  |
461    *   |          .    |
462    *   |        .      |
463    *   |      .        |
464    *   |    .          |
465    *   +===+===========+---------+----------> time
466    *      Start       Cliff    Vesting
467    */
468   function calculateVestedTokens(
469     uint256 tokens,
470     uint256 time,
471     uint256 start,
472     uint256 cliff,
473     uint256 vesting) public constant returns (uint256)
474     {
475       // Shortcuts for before cliff and after vesting cases.
476       if (time < cliff) return 0;
477       if (time >= vesting) return tokens;
478 
479       // Interpolate all vested tokens.
480       // As before cliff the shortcut returns 0, we can use just calculate a value
481       // in the vesting rect (as shown in above's figure)
482 
483       // vestedTokens = (tokens * (time - start)) / (vesting - start)
484       uint256 vestedTokens = SafeMath.div(
485                                     SafeMath.mul(
486                                       tokens,
487                                       SafeMath.sub(time, start)
488                                       ),
489                                     SafeMath.sub(vesting, start)
490                                     );
491 
492       return vestedTokens;
493   }
494 
495   /**
496    * @dev Get all information about a specific grant.
497    * @param _holder The address which will have its tokens revoked.
498    * @param _grantId The id of the token grant.
499    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
500    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
501    */
502   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
503     TokenGrant storage grant = grants[_holder][_grantId];
504 
505     granter = grant.granter;
506     value = grant.value;
507     start = grant.start;
508     cliff = grant.cliff;
509     vesting = grant.vesting;
510     revokable = grant.revokable;
511     burnsOnRevoke = grant.burnsOnRevoke;
512 
513     vested = vestedTokens(grant, uint64(now));
514   }
515 
516   /**
517    * @dev Get the amount of vested tokens at a specific time.
518    * @param grant TokenGrant The grant to be checked.
519    * @param time The time to be checked
520    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
521    */
522   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
523     return calculateVestedTokens(
524       grant.value,
525       uint256(time),
526       uint256(grant.start),
527       uint256(grant.cliff),
528       uint256(grant.vesting)
529     );
530   }
531 
532   /**
533    * @dev Calculate the amount of non vested tokens at a specific time.
534    * @param grant TokenGrant The grant to be checked.
535    * @param time uint64 The time to be checked
536    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
537    * passed time frame.
538    */
539   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
540     return grant.value.sub(vestedTokens(grant, time));
541   }
542 
543   /**
544    * @dev Calculate the date when the holder can transfer all its tokens
545    * @param holder address The address of the holder
546    * @return An uint256 representing the date of the last transferable tokens.
547    */
548   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
549     date = uint64(now);
550     uint256 grantIndex = grants[holder].length;
551     for (uint256 i = 0; i < grantIndex; i++) {
552       date = Math.max64(grants[holder][i].vesting, date);
553     }
554   }
555 }
556 
557 contract LegalToken is LegalLazyScheduler, MintableToken, VestedToken {
558     /**
559     * The name of the token
560     */
561     bytes32 public name;
562 
563     /**
564     * The symbol used for exchange
565     */
566     bytes32 public symbol;
567 
568     /**
569     * Use to convert to number of tokens.
570     */
571     uint public decimals = 18;
572 
573     /**
574     * The yearly expected inflation rate in base points.
575     */
576     uint32 public inflationCompBPS;
577 
578     /**
579     * The tokens are locked until the end of the TGE.
580     * The contract can release the tokens if TGE successful. If false we are in transfer lock up period.
581     */
582     bool public released = false;
583 
584     /**
585     * Annually new minted tokens will be transferred to this wallet.
586     * Publications will be rewarded with funds (incentives).  
587     */
588     address public rewardWallet;
589 
590     /**
591     * Name and symbol were updated. 
592     */
593     event UpdatedTokenInformation(bytes32 newName, bytes32 newSymbol);
594 
595     /**
596     * @dev Constructor that gives msg.sender all of existing tokens. 
597     */
598     function LegalToken(address _rewardWallet, uint32 _inflationCompBPS, uint32 _inflationCompInterval) onlyOwner public {
599         setTokenInformation("Legal Token", "LGL");
600         totalSupply = 0;        
601         rewardWallet = _rewardWallet;
602         inflationCompBPS = _inflationCompBPS;
603         registerIntervalCall(_inflationCompInterval, mintInflationPeriod);
604     }    
605 
606     /**
607     * This function allows the token owner to rename the token after the operations
608     * have been completed and then point the audience to use the token contract.
609     */
610     function setTokenInformation(bytes32 _name, bytes32 _symbol) onlyOwner public {
611         name = _name;
612         symbol = _symbol;
613         UpdatedTokenInformation(name, symbol);
614     }
615 
616     /**
617     * Mint new tokens for the predefined inflation period and assign them to the reward wallet. 
618     */
619     function mintInflationPeriod() private {
620         uint256 tokensToMint = totalSupply.mul(inflationCompBPS).div(10000);
621         totalSupply = totalSupply.add(tokensToMint);
622         balances[rewardWallet] = balances[rewardWallet].add(tokensToMint);
623         Mint(rewardWallet, tokensToMint);
624         Transfer(0x0, rewardWallet, tokensToMint);
625     }     
626     
627     function setRewardWallet(address _rewardWallet) public onlyOwner {
628         rewardWallet = _rewardWallet;
629     }
630 
631     /**
632     * Limit token transfer until the TGE is over.
633     */
634     modifier tokenReleased(address _sender) {
635         require(released);
636         _;
637     }
638 
639     /**
640     * This will make the tokens transferable
641     */
642     function releaseTokenTransfer() public onlyOwner {
643         released = true;
644     }
645 
646     // error: canTransfer(msg.sender, _value)
647     function transfer(address _to, uint _value) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
648         // Calls StandardToken.transfer()
649         // error: super.transfer(_to, _value);
650         return super.transfer(_to, _value);
651     }
652 
653     function transferFrom(address _from, address _to, uint _value) public tokenReleased(_from) intervalTrigger returns (bool success) {
654         // Calls StandardToken.transferForm()
655         return super.transferFrom(_from, _to, _value);
656     }
657 
658     function approve(address _spender, uint256 _value) public tokenReleased(msg.sender) intervalTrigger returns (bool) {
659         // calls StandardToken.approve(..)
660         return super.approve(_spender, _value);
661     }
662 
663     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
664         // calls StandardToken.allowance(..)
665         return super.allowance(_owner, _spender);
666     }
667 
668     function increaseApproval (address _spender, uint _addedValue) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
669         // calls StandardToken.increaseApproval(..)
670         return super.increaseApproval(_spender, _addedValue);
671     }
672 
673     function decreaseApproval (address _spender, uint _subtractedValue) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
674         // calls StandardToken.decreaseApproval(..)
675         return super.decreaseApproval(_spender, _subtractedValue);
676     }
677 }