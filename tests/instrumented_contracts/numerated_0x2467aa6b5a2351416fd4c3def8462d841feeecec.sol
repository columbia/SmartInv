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
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 contract ERC20Basic {
125   uint256 public totalSupply;
126   function balanceOf(address who) public constant returns (uint256);
127   function transfer(address to, uint256 value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) balances;
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public constant returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) public constant returns (uint256);
164   function transferFrom(address from, address to, uint256 value) public returns (bool);
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 contract LimitedTransferToken is ERC20 {
170 
171   /**
172    * @dev Checks whether it can transfer or otherwise throws.
173    */
174   modifier canTransfer(address _sender, uint256 _value) {
175    require(_value <= transferableTokens(_sender, uint64(now)));
176    _;
177   }
178 
179   /**
180    * @dev Checks modifier and allows transfer if tokens are not locked.
181    * @param _to The address that will receive the tokens.
182    * @param _value The amount of tokens to be transferred.
183    */
184   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
185     return super.transfer(_to, _value);
186   }
187 
188   /**
189   * @dev Checks modifier and allows transfer if tokens are not locked.
190   * @param _from The address that will send the tokens.
191   * @param _to The address that will receive the tokens.
192   * @param _value The amount of tokens to be transferred.
193   */
194   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
195     return super.transferFrom(_from, _to, _value);
196   }
197 
198   /**
199    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
200    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
201    * specific logic for limiting token transferability for a holder over time.
202    */
203   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
204     return balanceOf(holder);
205   }
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
287 contract BurnableToken is StandardToken {
288 
289     event Burn(address indexed burner, uint256 value);
290 
291     /**
292      * @dev Burns a specific amount of tokens.
293      * @param _value The amount of token to be burned.
294      */
295     function burn(uint256 _value) public {
296         require(_value > 0);
297 
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         totalSupply = totalSupply.sub(_value);
301         Burn(burner, _value);
302     }
303 }
304 
305 contract MintableToken is StandardToken, Ownable {
306   event Mint(address indexed to, uint256 amount);
307   event MintFinished();
308 
309   bool public mintingFinished = false;
310 
311 
312   modifier canMint() {
313     require(!mintingFinished);
314     _;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     totalSupply = totalSupply.add(_amount);
325     balances[_to] = balances[_to].add(_amount);
326     Mint(_to, _amount);
327     Transfer(0x0, _to, _amount);
328     return true;
329   }
330 
331   /**
332    * @dev Function to stop minting new tokens.
333    * @return True if the operation was successful.
334    */
335   function finishMinting() onlyOwner public returns (bool) {
336     mintingFinished = true;
337     MintFinished();
338     return true;
339   }
340 }
341 
342 contract PausableToken is StandardToken, Pausable {
343 
344   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
345     return super.transfer(_to, _value);
346   }
347 
348   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
353     return super.approve(_spender, _value);
354   }
355 
356   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
357     return super.increaseApproval(_spender, _addedValue);
358   }
359 
360   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
361     return super.decreaseApproval(_spender, _subtractedValue);
362   }
363 }
364 
365 contract VestedToken is StandardToken, LimitedTransferToken {
366 
367   uint256 MAX_GRANTS_PER_ADDRESS = 20;
368 
369   struct TokenGrant {
370     address granter;     // 20 bytes
371     uint256 value;       // 32 bytes
372     uint64 cliff;
373     uint64 vesting;
374     uint64 start;        // 3 * 8 = 24 bytes
375     bool revokable;
376     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
377   } // total 78 bytes = 3 sstore per operation (32 per sstore)
378 
379   mapping (address => TokenGrant[]) public grants;
380 
381   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
382 
383   /**
384    * @dev Grant tokens to a specified address
385    * @param _to address The address which the tokens will be granted to.
386    * @param _value uint256 The amount of tokens to be granted.
387    * @param _start uint64 Time of the beginning of the grant.
388    * @param _cliff uint64 Time of the cliff period.
389    * @param _vesting uint64 The vesting period.
390    */
391   function grantVestedTokens(
392     address _to,
393     uint256 _value,
394     uint64 _start,
395     uint64 _cliff,
396     uint64 _vesting,
397     bool _revokable,
398     bool _burnsOnRevoke
399   ) public {
400 
401     // Check for date inconsistencies that may cause unexpected behavior
402     require(_cliff >= _start && _vesting >= _cliff);
403 
404     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
405 
406     uint256 count = grants[_to].push(
407                 TokenGrant(
408                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
409                   _value,
410                   _cliff,
411                   _vesting,
412                   _start,
413                   _revokable,
414                   _burnsOnRevoke
415                 )
416               );
417 
418     transfer(_to, _value);
419 
420     NewTokenGrant(msg.sender, _to, _value, count - 1);
421   }
422 
423   /**
424    * @dev Revoke the grant of tokens of a specifed address.
425    * @param _holder The address which will have its tokens revoked.
426    * @param _grantId The id of the token grant.
427    */
428   function revokeTokenGrant(address _holder, uint256 _grantId) public {
429     TokenGrant storage grant = grants[_holder][_grantId];
430 
431     require(grant.revokable);
432     require(grant.granter == msg.sender); // Only granter can revoke it
433 
434     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
435 
436     uint256 nonVested = nonVestedTokens(grant, uint64(now));
437 
438     // remove grant from array
439     delete grants[_holder][_grantId];
440     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
441     grants[_holder].length -= 1;
442 
443     balances[receiver] = balances[receiver].add(nonVested);
444     balances[_holder] = balances[_holder].sub(nonVested);
445 
446     Transfer(_holder, receiver, nonVested);
447   }
448 
449 
450   /**
451    * @dev Calculate the total amount of transferable tokens of a holder at a given time
452    * @param holder address The address of the holder
453    * @param time uint64 The specific time.
454    * @return An uint256 representing a holder's total amount of transferable tokens.
455    */
456   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
457     uint256 grantIndex = tokenGrantsCount(holder);
458 
459     if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
460 
461     // Iterate through all the grants the holder has, and add all non-vested tokens
462     uint256 nonVested = 0;
463     for (uint256 i = 0; i < grantIndex; i++) {
464       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
465     }
466 
467     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
468     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
469 
470     // Return the minimum of how many vested can transfer and other value
471     // in case there are other limiting transferability factors (default is balanceOf)
472     return Math.min256(vestedTransferable, super.transferableTokens(holder, time));
473   }
474 
475   /**
476    * @dev Check the amount of grants that an address has.
477    * @param _holder The holder of the grants.
478    * @return A uint256 representing the total amount of grants.
479    */
480   function tokenGrantsCount(address _holder) public constant returns (uint256 index) {
481     return grants[_holder].length;
482   }
483 
484   /**
485    * @dev Calculate amount of vested tokens at a specific time
486    * @param tokens uint256 The amount of tokens granted
487    * @param time uint64 The time to be checked
488    * @param start uint64 The time representing the beginning of the grant
489    * @param cliff uint64  The cliff period, the period before nothing can be paid out
490    * @param vesting uint64 The vesting period
491    * @return An uint256 representing the amount of vested tokens of a specific grant
492    *  transferableTokens
493    *   |                         _/--------   vestedTokens rect
494    *   |                       _/
495    *   |                     _/
496    *   |                   _/
497    *   |                 _/
498    *   |                /
499    *   |              .|
500    *   |            .  |
501    *   |          .    |
502    *   |        .      |
503    *   |      .        |
504    *   |    .          |
505    *   +===+===========+---------+----------> time
506    *      Start       Cliff    Vesting
507    */
508   function calculateVestedTokens(
509     uint256 tokens,
510     uint256 time,
511     uint256 start,
512     uint256 cliff,
513     uint256 vesting) public constant returns (uint256)
514     {
515       // Shortcuts for before cliff and after vesting cases.
516       if (time < cliff) return 0;
517       if (time >= vesting) return tokens;
518 
519       // Interpolate all vested tokens.
520       // As before cliff the shortcut returns 0, we can use just calculate a value
521       // in the vesting rect (as shown in above's figure)
522 
523       // vestedTokens = (tokens * (time - start)) / (vesting - start)
524       uint256 vestedTokens = SafeMath.div(
525                                     SafeMath.mul(
526                                       tokens,
527                                       SafeMath.sub(time, start)
528                                       ),
529                                     SafeMath.sub(vesting, start)
530                                     );
531 
532       return vestedTokens;
533   }
534 
535   /**
536    * @dev Get all information about a specific grant.
537    * @param _holder The address which will have its tokens revoked.
538    * @param _grantId The id of the token grant.
539    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
540    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
541    */
542   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
543     TokenGrant storage grant = grants[_holder][_grantId];
544 
545     granter = grant.granter;
546     value = grant.value;
547     start = grant.start;
548     cliff = grant.cliff;
549     vesting = grant.vesting;
550     revokable = grant.revokable;
551     burnsOnRevoke = grant.burnsOnRevoke;
552 
553     vested = vestedTokens(grant, uint64(now));
554   }
555 
556   /**
557    * @dev Get the amount of vested tokens at a specific time.
558    * @param grant TokenGrant The grant to be checked.
559    * @param time The time to be checked
560    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
561    */
562   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
563     return calculateVestedTokens(
564       grant.value,
565       uint256(time),
566       uint256(grant.start),
567       uint256(grant.cliff),
568       uint256(grant.vesting)
569     );
570   }
571 
572   /**
573    * @dev Calculate the amount of non vested tokens at a specific time.
574    * @param grant TokenGrant The grant to be checked.
575    * @param time uint64 The time to be checked
576    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
577    * passed time frame.
578    */
579   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
580     return grant.value.sub(vestedTokens(grant, time));
581   }
582 
583   /**
584    * @dev Calculate the date when the holder can transfer all its tokens
585    * @param holder address The address of the holder
586    * @return An uint256 representing the date of the last transferable tokens.
587    */
588   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
589     date = uint64(now);
590     uint256 grantIndex = grants[holder].length;
591     for (uint256 i = 0; i < grantIndex; i++) {
592       date = Math.max64(grants[holder][i].vesting, date);
593     }
594   }
595 }
596 
597 contract MigrationAgentInterface {
598   function migrateFrom(address _from, uint256 _value);
599   function setSourceToken(address _qbxSourceToken);
600   function updateSupply();
601   function qbxSourceToken() returns (address);
602 }
603 
604 contract QiibeeToken is BurnableToken, PausableToken, VestedToken, MintableToken {
605     using SafeMath for uint256;
606 
607     string public constant symbol = "QBX";
608     string public constant name = "qiibeeToken";
609     uint8 public constant decimals = 18;
610 
611     // migration vars
612     uint256 public totalMigrated;
613     uint256 public newTokens; // amount of tokens minted after migrationAgent has been set
614     uint256 public burntTokens; // amount of tokens burnt after migrationAgent has been set
615     address public migrationAgent;
616     address public migrationMaster;
617 
618     event Migrate(address indexed _from, address indexed _to, uint256 _value);
619     event NewVestedToken(address indexed from, address indexed to, uint256 value, uint256 grantId);
620 
621     modifier onlyMigrationMaster {
622         require(msg.sender == migrationMaster);
623         _;
624     }
625 
626     /*
627      * Constructor.
628      */
629     function QiibeeToken(address _migrationMaster) {
630       require(_migrationMaster != address(0));
631       migrationMaster = _migrationMaster;
632     }
633 
634     /**
635       @dev Similar to grantVestedTokens but minting tokens instead of transferring.
636     */
637     function mintVestedTokens (
638       address _to,
639       uint256 _value,
640       uint64 _start,
641       uint64 _cliff,
642       uint64 _vesting,
643       bool _revokable,
644       bool _burnsOnRevoke,
645       address _wallet
646     ) onlyOwner public returns (bool) {
647       // Check for date inconsistencies that may cause unexpected behavior
648       require(_cliff >= _start && _vesting >= _cliff);
649 
650       require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
651 
652       uint256 count = grants[_to].push(
653                   TokenGrant(
654                     _revokable ? _wallet : 0, // avoid storing an extra 20 bytes when it is non-revokable
655                     _value,
656                     _cliff,
657                     _vesting,
658                     _start,
659                     _revokable,
660                     _burnsOnRevoke
661                   )
662                 );
663 
664       NewVestedToken(msg.sender, _to, _value, count - 1);
665       return mint(_to, _value); //mint tokens
666     }
667 
668     /**
669       @dev Overrides VestedToken#grantVestedTokens(). Only owner can call it.
670     */
671     function grantVestedTokens (
672       address _to,
673       uint256 _value,
674       uint64 _start,
675       uint64 _cliff,
676       uint64 _vesting,
677       bool _revokable,
678       bool _burnsOnRevoke
679     ) onlyOwner public {
680       super.grantVestedTokens(_to, _value, _start, _cliff, _vesting, _revokable, _burnsOnRevoke);
681     }
682 
683     /**
684       @dev Set address of migration agent contract and enable migration process.
685       @param _agent The address of the MigrationAgent contract
686      */
687     function setMigrationAgent(address _agent) public onlyMigrationMaster {
688       require(MigrationAgentInterface(_agent).qbxSourceToken() == address(this));
689       require(migrationAgent == address(0));
690       require(_agent != address(0));
691       migrationAgent = _agent;
692     }
693 
694     /**
695       @dev Migrates the tokens to the target token through the MigrationAgent.
696       @param _value The amount of tokens (in atto) to be migrated.
697      */
698     function migrate(uint256 _value) public whenNotPaused {
699       require(migrationAgent != address(0));
700       require(_value != 0);
701       require(_value <= balances[msg.sender]);
702       require(_value <= transferableTokens(msg.sender, uint64(now)));
703       balances[msg.sender] = balances[msg.sender].sub(_value);
704       totalSupply = totalSupply.sub(_value);
705       totalMigrated = totalMigrated.add(_value);
706       MigrationAgentInterface(migrationAgent).migrateFrom(msg.sender, _value);
707       Migrate(msg.sender, migrationAgent, _value);
708     }
709 
710     /**
711      * @dev Overrides mint() function so as to keep track of the tokens minted after the
712      * migrationAgent has been set. This is to ensure that the migration agent has always the
713      * totalTokens variable up to date. This prevents the failure of the safetyInvariantCheck().
714      * @param _to The address that will receive the minted tokens.
715      * @param _amount The amount of tokens to mint.
716      * @return A boolean that indicates if the operation was successful.
717      */
718     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
719       bool mint = super.mint(_to, _amount);
720       if (mint && migrationAgent != address(0)) {
721         newTokens = newTokens.add(_amount);
722       }
723       return mint;
724     }
725 
726 
727     /*
728      * @dev Changes the migration master.
729      * @param _master The address of the migration master.
730      */
731     function setMigrationMaster(address _master) public onlyMigrationMaster {
732       require(_master != address(0));
733       migrationMaster = _master;
734     }
735 
736     /*
737      * @dev Resets newTokens to zero. Can only be called by the migrationAgent
738      */
739     function resetNewTokens() {
740       require(msg.sender == migrationAgent);
741       newTokens = 0;
742     }
743 
744     /*
745      * @dev Resets burntTokens to zero. Can only be called by the migrationAgent
746      */
747     function resetBurntTokens() {
748       require(msg.sender == migrationAgent);
749       burntTokens = 0;
750     }
751 
752     /*
753      * @dev Burns a specific amount of tokens.
754      * @param _value The amount of tokens to be burnt.
755      */
756     function burn(uint256 _value) whenNotPaused onlyOwner public {
757       super.burn(_value);
758       if (migrationAgent != address(0)) {
759         burntTokens = burntTokens.add(_value);
760       }
761     }
762 }