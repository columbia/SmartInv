1 pragma solidity ^0.4.13;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 contract BurnableToken is StandardToken {
242 
243   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
244   address public constant BURN_ADDRESS = 0;
245 
246   /** How many tokens we burned */
247   event Burned(address burner, uint burnedAmount);
248 
249   /**
250    * Burn extra tokens from a balance.
251    *
252    */
253   function burn(uint burnAmount) {
254     address burner = msg.sender;
255     balances[burner] = balances[burner].sub(burnAmount);
256     totalSupply_ = totalSupply_.sub(burnAmount);
257     Burned(burner, burnAmount);
258 
259     // Inform the blockchain explores that track the
260     // balances only by a transfer event that the balance in this
261     // address has decreased
262     Transfer(burner, BURN_ADDRESS, burnAmount);
263   }
264 }
265 
266 contract LimitedTransferToken is ERC20 {
267 
268     /**
269      * @dev Checks whether it can transfer or otherwise throws.
270      */
271     modifier canTransferLimitedTransferToken(address _sender, uint256 _value) {
272         require(_value <= transferableTokens(_sender, uint64(now)));
273         _;
274     }
275 
276     /**
277      * @dev Default transferable tokens function returns all tokens for a holder (no limit).
278      * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
279      * specific logic for limiting token transferability for a holder over time.
280      */
281     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
282         return balanceOf(holder);
283     }
284 }
285 
286 contract ReleasableToken is ERC20, Ownable {
287 
288   /* The finalizer contract that allows unlift the transfer limits on this token */
289   address public releaseAgent;
290 
291   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
292   bool public released = false;
293 
294   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
295   mapping (address => bool) public transferAgents;
296 
297   /** The function can be called only before or after the tokens have been releasesd */
298   modifier inReleaseState(bool releaseState) {
299     if(releaseState != released) {
300       revert();
301     }
302     _;
303   }
304 
305   /** The function can be called only by a whitelisted release agent. */
306   modifier onlyReleaseAgent() {
307     if(msg.sender != releaseAgent) {
308       revert();
309     }
310     _;
311   }
312 
313   /**
314    * Limit token transfer until the crowdsale is over.
315    *
316    */
317   modifier canTransferReleasable(address _sender) {
318 
319     if(!released) {
320         if(!transferAgents[_sender]) {
321             revert();
322         }
323     }
324 
325     _;
326   }
327 
328   /**
329    * Set the contract that can call release and make the token transferable.
330    *
331    * Design choice. Allow reset the release agent to fix fat finger mistakes.
332    */
333   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
334     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
335     releaseAgent = addr;
336   }
337 
338   /**
339    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
340    */
341   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
342     transferAgents[addr] = state;
343   }
344 
345   /**
346    * One way function to release the tokens to the wild.
347    *
348    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
349    */
350   function releaseTokenTransfer() public onlyReleaseAgent {
351     released = true;
352   }
353 }
354 
355 contract UpgradeAgent {
356 
357   uint public originalSupply;
358 
359   /** Interface marker */
360   function isUpgradeAgent() public constant returns (bool) {
361     return true;
362   }
363 
364   function upgradeFrom(address _from, uint256 _value) public;
365 }
366 
367 contract UpgradeableToken is StandardToken {
368 
369     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
370     address public upgradeMaster;
371 
372     /** The next contract where the tokens will be migrated. */
373     UpgradeAgent public upgradeAgent;
374 
375     /** How many tokens we have upgraded by now. */
376     uint256 public totalUpgraded;
377 
378     /**
379      * Upgrade states.
380      *
381      * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
382      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
383      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
384      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
385      *
386      */
387     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
388 
389     /**
390      * Somebody has upgraded some of his tokens.
391      */
392     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
393 
394     /**
395      * New upgrade agent available.
396      */
397     event UpgradeAgentSet(address agent);
398 
399     /**
400      * Do not allow construction without upgrade master set.
401      */
402     function UpgradeableToken(address _upgradeMaster) public {
403         upgradeMaster = _upgradeMaster;
404     }
405 
406     /**
407      * Allow the token holder to upgrade some of their tokens to a new contract.
408      */
409     function upgrade(uint256 value) public {
410 
411         UpgradeState state = getUpgradeState();
412         if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
413             // Called in a bad state
414             revert();
415         }
416 
417         // Validate input value.
418         if (value == 0) revert();
419 
420         balances[msg.sender] = balances[msg.sender].sub(value);
421 
422         // Take tokens out from circulation
423         totalSupply_ = totalSupply_.sub(value);
424         totalUpgraded = totalUpgraded.add(value);
425 
426         // Upgrade agent reissues the tokens
427         upgradeAgent.upgradeFrom(msg.sender, value);
428         Upgrade(msg.sender, upgradeAgent, value);
429     }
430 
431     /**
432      * Set an upgrade agent that handles
433      */
434     function setUpgradeAgent(address agent) external {
435         if (!canUpgrade()) {
436             // The token is not yet in a state that we could think upgrading
437             revert();
438         }
439 
440         if (agent == 0x0) revert();
441         // Only a master can designate the next agent
442         if (msg.sender != upgradeMaster) revert();
443         // Upgrade has already begun for an agent
444         if (getUpgradeState() == UpgradeState.Upgrading) revert();
445 
446         upgradeAgent = UpgradeAgent(agent);
447 
448         // Bad interface
449         if (!upgradeAgent.isUpgradeAgent()) revert();
450         // Make sure that token supplies match in source and target
451         if (upgradeAgent.originalSupply() != totalSupply_) revert();
452 
453         UpgradeAgentSet(upgradeAgent);
454     }
455 
456     /**
457      * Get the state of the token upgrade.
458      */
459     function getUpgradeState() public constant returns (UpgradeState) {
460         if (!canUpgrade()) return UpgradeState.NotAllowed;
461         else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
462         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
463         else return UpgradeState.Upgrading;
464     }
465 
466     /**
467      * Change the upgrade master.
468      *
469      * This allows us to set a new owner for the upgrade mechanism.
470      */
471     function setUpgradeMaster(address master) public {
472         if (master == 0x0) revert();
473         if (msg.sender != upgradeMaster) revert();
474         upgradeMaster = master;
475     }
476 
477     /**
478      * Child contract can enable to provide the condition when the upgrade can begun.
479      */
480     function canUpgrade() public constant returns (bool) {
481         return true;
482     }
483 }
484 
485 contract CrowdsaleToken is ReleasableToken, UpgradeableToken {
486 
487   /** Name and symbol were updated. */
488   event UpdatedTokenInformation(string newName, string newSymbol);
489 
490   string public name;
491 
492   string public symbol;
493 
494   uint8 public decimals;
495 
496   /**
497    * Construct the token.
498    *
499    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
500    *
501    * @param _name Token name
502    * @param _symbol Token symbol - should be all caps
503    * @param _initialSupply How many tokens we start with
504    * @param _decimals Number of decimal places
505    */
506   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals)
507     UpgradeableToken(msg.sender) public {
508 
509     // Create any address, can be transferred
510     // to team multisig via changeOwner(),
511     // also remember to call setUpgradeMaster()
512     owner = msg.sender;
513 
514     name = _name;
515     symbol = _symbol;
516 
517     totalSupply_ = _initialSupply;
518 
519     decimals = _decimals;
520 
521     // Create initially all balance on the team multisig
522     balances[owner] = totalSupply_;
523   }
524 
525   /**
526    * When token is released to be transferable, enforce no new tokens can be created.
527    */
528   function releaseTokenTransfer() public onlyReleaseAgent {
529     super.releaseTokenTransfer();
530   }
531 
532   /**
533    * Allow upgrade agent functionality kick in only if the crowdsale was success.
534    */
535   function canUpgrade() public constant returns(bool) {
536     return released && super.canUpgrade();
537   }
538 
539   /**
540    * Owner can update token information here.
541    *
542    * It is often useful to conceal the actual token association, until
543    * the token operations, like central issuance or reissuance have been completed.
544    *
545    * This function allows the token owner to rename the token after the operations
546    * have been completed and then point the audience to use the token contract.
547    */
548   function setTokenInformation(string _name, string _symbol) onlyOwner {
549     name = _name;
550     symbol = _symbol;
551 
552     UpdatedTokenInformation(name, symbol);
553   }
554 
555 }
556 
557 contract VestedToken is StandardToken, LimitedTransferToken {
558 
559     uint256 MAX_GRANTS_PER_ADDRESS = 20;
560 
561     struct TokenGrant {
562         address granter;     // 20 bytes
563         uint256 value;       // 32 bytes
564         uint64 cliff;
565         uint64 vesting;
566         uint64 start;        // 3 * 8 = 24 bytes
567         bool revokable;
568         bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
569     } // total 78 bytes = 3 sstore per operation (32 per sstore)
570 
571     mapping (address => TokenGrant[]) public grants;
572 
573     event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
574 
575     /**
576      * @dev Grant tokens to a specified address
577      * @param _to address The address which the tokens will be granted to.
578      * @param _value uint256 The amount of tokens to be granted.
579      * @param _start uint64 Time of the beginning of the grant.
580      * @param _cliff uint64 Time of the cliff period.
581      * @param _vesting uint64 The vesting period.
582      */
583     function grantVestedTokens(
584         address _to,
585         uint256 _value,
586         uint64 _start,
587         uint64 _cliff,
588         uint64 _vesting,
589         bool _revokable,
590         bool _burnsOnRevoke
591     ) public {
592 
593         // Check for date inconsistencies that may cause unexpected behavior
594         require(_cliff >= _start && _vesting >= _cliff);
595 
596         require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
597 
598         uint256 count = grants[_to].push(
599             TokenGrant(
600                 _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
601                 _value,
602                 _cliff,
603                 _vesting,
604                 _start,
605                 _revokable,
606                 _burnsOnRevoke
607             )
608         );
609 
610         transfer(_to, _value);
611 
612         NewTokenGrant(msg.sender, _to, _value, count - 1);
613     }
614 
615     /**
616      * @dev Revoke the grant of tokens of a specifed address.
617      * @param _holder The address which will have its tokens revoked.
618      * @param _grantId The id of the token grant.
619      */
620     function revokeTokenGrant(address _holder, uint256 _grantId) public {
621         TokenGrant storage grant = grants[_holder][_grantId];
622 
623         require(grant.revokable);
624         require(grant.granter == msg.sender); // Only granter can revoke it
625 
626         address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
627 
628         uint256 nonVested = nonVestedTokens(grant, uint64(now));
629 
630         // remove grant from array
631         delete grants[_holder][_grantId];
632         grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
633         grants[_holder].length -= 1;
634 
635         balances[receiver] = balances[receiver].add(nonVested);
636         balances[_holder] = balances[_holder].sub(nonVested);
637 
638         Transfer(_holder, receiver, nonVested);
639     }
640 
641 
642     /**
643      * @dev Calculate the total amount of transferable tokens of a holder at a given time
644      * @param holder address The address of the holder
645      * @param time uint64 The specific time.
646      * @return An uint256 representing a holder's total amount of transferable tokens.
647      */
648     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
649         uint256 grantIndex = tokenGrantsCount(holder);
650 
651         if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
652 
653         // Iterate through all the grants the holder has, and add all non-vested tokens
654         uint256 nonVested = 0;
655         for (uint256 i = 0; i < grantIndex; i++) {
656             nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
657         }
658 
659         // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
660         uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
661 
662         // Return the minimum of how many vested can transfer and other value
663         // in case there are other limiting transferability factors (default is balanceOf)
664         return Math.min256(vestedTransferable, super.transferableTokens(holder, time));
665     }
666 
667     /**
668      * @dev Check the amount of grants that an address has.
669      * @param _holder The holder of the grants.
670      * @return A uint256 representing the total amount of grants.
671      */
672     function tokenGrantsCount(address _holder) public constant returns (uint256 index) {
673         return grants[_holder].length;
674     }
675 
676     /**
677      * @dev Calculate amount of vested tokens at a specific time
678      * @param tokens uint256 The amount of tokens granted
679      * @param time uint64 The time to be checked
680      * @param start uint64 The time representing the beginning of the grant
681      * @param cliff uint64  The cliff period, the period before nothing can be paid out
682      * @param vesting uint64 The vesting period
683      * @return An uint256 representing the amount of vested tokens of a specific grant
684      *  transferableTokens
685      *   |                         _/--------   vestedTokens rect
686      *   |                       _/
687      *   |                     _/
688      *   |                   _/
689      *   |                 _/
690      *   |                /
691      *   |              .|
692      *   |            .  |
693      *   |          .    |
694      *   |        .      |
695      *   |      .        |
696      *   |    .          |
697      *   +===+===========+---------+----------> time
698      *      Start       Cliff    Vesting
699      */
700     function calculateVestedTokens(
701         uint256 tokens,
702         uint256 time,
703         uint256 start,
704         uint256 cliff,
705         uint256 vesting) public pure returns (uint256)
706     {
707         // Shortcuts for before cliff and after vesting cases.
708         if (time < cliff) return 0;
709         if (time >= vesting) return tokens;
710 
711         // Interpolate all vested tokens.
712         // As before cliff the shortcut returns 0, we can use just calculate a value
713         // in the vesting rect (as shown in above's figure)
714 
715         // vestedTokens = (tokens * (time - start)) / (vesting - start)
716         uint256 vestedTokens = SafeMath.div(
717             SafeMath.mul(
718                 tokens,
719                 SafeMath.sub(time, start)
720             ),
721             SafeMath.sub(vesting, start)
722         );
723 
724         return vestedTokens;
725     }
726 
727     /**
728      * @dev Get all information about a specific grant.
729      * @param _holder The address which will have its tokens revoked.
730      * @param _grantId The id of the token grant.
731      * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
732      * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
733      */
734     function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
735         TokenGrant storage grant = grants[_holder][_grantId];
736 
737         granter = grant.granter;
738         value = grant.value;
739         start = grant.start;
740         cliff = grant.cliff;
741         vesting = grant.vesting;
742         revokable = grant.revokable;
743         burnsOnRevoke = grant.burnsOnRevoke;
744 
745         vested = vestedTokens(grant, uint64(now));
746     }
747 
748     /**
749      * @dev Get the amount of vested tokens at a specific time.
750      * @param grant TokenGrant The grant to be checked.
751      * @param time The time to be checked
752      * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
753      */
754     function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
755         return calculateVestedTokens(
756             grant.value,
757             uint256(time),
758             uint256(grant.start),
759             uint256(grant.cliff),
760             uint256(grant.vesting)
761         );
762     }
763 
764     /**
765      * @dev Calculate the amount of non vested tokens at a specific time.
766      * @param grant TokenGrant The grant to be checked.
767      * @param time uint64 The time to be checked
768      * @return An uint256 representing the amount of non vested tokens of a specific grant on the
769      * passed time frame.
770      */
771     function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
772         return grant.value.sub(vestedTokens(grant, time));
773     }
774 
775     /**
776      * @dev Calculate the date when the holder can transfer all its tokens
777      * @param holder address The address of the holder
778      * @return An uint256 representing the date of the last transferable tokens.
779      */
780     function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
781         date = uint64(now);
782         uint256 grantIndex = grants[holder].length;
783         for (uint256 i = 0; i < grantIndex; i++) {
784             date = Math.max64(grants[holder][i].vesting, date);
785         }
786     }
787 }
788 
789 contract WemarkToken is CrowdsaleToken, BurnableToken, VestedToken {
790 
791     modifier validDestination(address to) {
792         require(to != address(0x0));
793         require(to != address(this));
794         _;
795     }
796 
797 
798     function WemarkToken() CrowdsaleToken('WemarkToken-Test', 'WMK', 135000000 * (10 ** 18), 18) public {
799         /** Initially allow only token creator to transfer tokens */
800         setTransferAgent(msg.sender, true);
801     }
802 
803     /**
804      * @dev Checks modifier and allows transfer if tokens are not locked or not released.
805      * @param _to The address that will receive the tokens.
806      * @param _value The amount of tokens to be transferred.
807      */
808     function transfer(address _to, uint _value)
809         validDestination(_to)
810         canTransferReleasable(msg.sender)
811         canTransferLimitedTransferToken(msg.sender, _value) public returns (bool) {
812         // Call BasicToken.transfer()
813         return super.transfer(_to, _value);
814     }
815 
816     /**
817      * @dev Checks modifier and allows transfer if tokens are not locked or not released.
818      * @param _from The address that will send the tokens.
819      * @param _to The address that will receive the tokens.
820      * @param _value The amount of tokens to be transferred.
821      */
822     function transferFrom(address _from, address _to, uint _value)
823         validDestination(_to)
824         canTransferReleasable(_from)
825         canTransferLimitedTransferToken(_from, _value) public returns (bool) {
826         // Call StandardToken.transferForm()
827         return super.transferFrom(_from, _to, _value);
828     }
829 
830     /**
831      * @dev Prevent accounts that are blocked for transferring their tokens, from calling approve()
832      */
833     function approve(address _spender, uint256 _value) public returns (bool) {
834         // Call StandardToken.transferForm()
835         return super.approve(_spender, _value);
836     }
837 
838     /**
839      * @dev Prevent accounts that are blocked for transferring their tokens, from calling increaseApproval()
840      */
841     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
842         // Call StandardToken.transferForm()
843         return super.increaseApproval(_spender, _addedValue);
844     }
845 
846     /**
847      * @dev Can upgrade token contract only if token is released and super class allows too.
848      */
849     function canUpgrade() public constant returns(bool) {
850         return released && super.canUpgrade();
851     }
852 
853     /**
854      * @dev Calculate the total amount of transferable tokens of a holder for the current moment of calling.
855      * @param holder address The address of the holder
856      * @return An uint256 representing a holder's total amount of transferable tokens.
857      */
858     function transferableTokensNow(address holder) public constant returns (uint) {
859         return transferableTokens(holder, uint64(now));
860     }
861 
862     function () payable {
863         // If ether is sent to this address, send it back
864         revert();
865     }
866 }