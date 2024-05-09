1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 
72 /**
73  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
74  *
75  * Based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, SafeMath {
79 
80   /* Token supply got increased and a new owner received these tokens */
81   event Minted(address receiver, uint amount);
82 
83   /* Actual balances of token holders */
84   mapping(address => uint) balances;
85 
86   /* approve() allowances */
87   mapping (address => mapping (address => uint)) allowed;
88 
89   /* Interface declaration */
90   function isToken() public constant returns (bool weAre) {
91     return true;
92   }
93 
94   function transfer(address _to, uint _value) returns (bool success) {
95     balances[msg.sender] = safeSub(balances[msg.sender], _value);
96     balances[_to] = safeAdd(balances[_to], _value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
102     uint _allowance = allowed[_from][msg.sender];
103 
104     balances[_to] = safeAdd(balances[_to], _value);
105     balances[_from] = safeSub(balances[_from], _value);
106     allowed[_from][msg.sender] = safeSub(_allowance, _value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115   function approve(address _spender, uint _value) returns (bool success) {
116 
117     // To change the approve amount you first have to reduce the addresses`
118     //  allowance to zero by calling `approve(_spender, 0)` if it is not
119     //  already 0 to mitigate the race condition described here:
120     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
122 
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   function allowance(address _owner, address _spender) constant returns (uint remaining) {
129     return allowed[_owner][_spender];
130   }
131 
132 }
133 
134 
135 
136 contract BurnableToken is StandardToken {
137 
138   address public constant BURN_ADDRESS = 0;
139 
140   /** How many tokens we burned */
141   event Burned(address burner, uint burnedAmount);
142 
143   /**
144    * Burn extra tokens from a balance.
145    *
146    */
147   function burn(uint burnAmount) {
148     address burner = msg.sender;
149     balances[burner] = safeSub(balances[burner], burnAmount);
150     totalSupply = safeSub(totalSupply, burnAmount);
151     Burned(burner, burnAmount);
152   }
153 }
154 
155 
156 
157 
158 
159 
160 
161 /**
162  * Upgrade agent interface inspired by Lunyr.
163  *
164  * Upgrade agent transfers tokens to a new contract.
165  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
166  */
167 contract UpgradeAgent {
168 
169   uint public originalSupply;
170 
171   /** Interface marker */
172   function isUpgradeAgent() public constant returns (bool) {
173     return true;
174   }
175 
176   function upgradeFrom(address _from, uint256 _value) public;
177 
178 }
179 
180 
181 /**
182  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
183  *
184  * First envisioned by Golem and Lunyr projects.
185  */
186 contract UpgradeableToken is StandardToken {
187 
188   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
189   address public upgradeMaster;
190 
191   /** The next contract where the tokens will be migrated. */
192   UpgradeAgent public upgradeAgent;
193 
194   /** How many tokens we have upgraded by now. */
195   uint256 public totalUpgraded;
196 
197   /**
198    * Upgrade states.
199    *
200    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
201    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
202    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
203    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
204    *
205    */
206   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
207 
208   /**
209    * Somebody has upgraded some of his tokens.
210    */
211   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
212 
213   /**
214    * New upgrade agent available.
215    */
216   event UpgradeAgentSet(address agent);
217 
218   /**
219    * Do not allow construction without upgrade master set.
220    */
221   function UpgradeableToken(address _upgradeMaster) {
222     upgradeMaster = _upgradeMaster;
223   }
224 
225   /**
226    * Allow the token holder to upgrade some of their tokens to a new contract.
227    */
228   function upgrade(uint256 value) public {
229 
230       UpgradeState state = getUpgradeState();
231       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
232         // Called in a bad state
233         throw;
234       }
235 
236       // Validate input value.
237       if (value == 0) throw;
238 
239       balances[msg.sender] = safeSub(balances[msg.sender], value);
240 
241       // Take tokens out from circulation
242       totalSupply = safeSub(totalSupply, value);
243       totalUpgraded = safeAdd(totalUpgraded, value);
244 
245       // Upgrade agent reissues the tokens
246       upgradeAgent.upgradeFrom(msg.sender, value);
247       Upgrade(msg.sender, upgradeAgent, value);
248   }
249 
250   /**
251    * Set an upgrade agent that handles
252    */
253   function setUpgradeAgent(address agent) external {
254 
255       if(!canUpgrade()) {
256         // The token is not yet in a state that we could think upgrading
257         throw;
258       }
259 
260       if (agent == 0x0) throw;
261       // Only a master can designate the next agent
262       if (msg.sender != upgradeMaster) throw;
263       // Upgrade has already begun for an agent
264       if (getUpgradeState() == UpgradeState.Upgrading) throw;
265 
266       upgradeAgent = UpgradeAgent(agent);
267 
268       // Bad interface
269       if(!upgradeAgent.isUpgradeAgent()) throw;
270       // Make sure that token supplies match in source and target
271       if (upgradeAgent.originalSupply() != totalSupply) throw;
272 
273       UpgradeAgentSet(upgradeAgent);
274   }
275 
276   /**
277    * Get the state of the token upgrade.
278    */
279   function getUpgradeState() public constant returns(UpgradeState) {
280     if(!canUpgrade()) return UpgradeState.NotAllowed;
281     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
282     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
283     else return UpgradeState.Upgrading;
284   }
285 
286   /**
287    * Change the upgrade master.
288    *
289    * This allows us to set a new owner for the upgrade mechanism.
290    */
291   function setUpgradeMaster(address master) public {
292       if (master == 0x0) throw;
293       if (msg.sender != upgradeMaster) throw;
294       upgradeMaster = master;
295   }
296 
297   /**
298    * Child contract can enable to provide the condition when the upgrade can begun.
299    */
300   function canUpgrade() public constant returns(bool) {
301      return true;
302   }
303 
304 }
305 
306 
307 
308 
309 /*
310  * Ownable
311  *
312  * Base contract with an owner.
313  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
314  */
315 contract Ownable {
316   address public owner;
317 
318   function Ownable() {
319     owner = msg.sender;
320   }
321 
322   modifier onlyOwner() {
323     if (msg.sender != owner) {
324       throw;
325     }
326     _;
327   }
328 
329   function transferOwnership(address newOwner) onlyOwner {
330     if (newOwner != address(0)) {
331       owner = newOwner;
332     }
333   }
334 
335 }
336 
337 
338 
339 
340 /**
341  * Define interface for releasing the token transfer after a successful crowdsale.
342  */
343 contract ReleasableToken is ERC20, Ownable {
344 
345   /* The finalizer contract that allows unlift the transfer limits on this token */
346   address public releaseAgent;
347 
348   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
349   bool public released = false;
350 
351   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
352   mapping (address => bool) public transferAgents;
353 
354   /**
355    * Limit token transfer until the crowdsale is over.
356    *
357    */
358   modifier canTransfer(address _sender) {
359 
360     if(!released) {
361         if(!transferAgents[_sender]) {
362             throw;
363         }
364     }
365 
366     _;
367   }
368 
369   /**
370    * Set the contract that can call release and make the token transferable.
371    *
372    * Design choice. Allow reset the release agent to fix fat finger mistakes.
373    */
374   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
375 
376     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
377     releaseAgent = addr;
378   }
379 
380   /**
381    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
382    */
383   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
384     transferAgents[addr] = state;
385   }
386 
387   /**
388    * One way function to release the tokens to the wild.
389    *
390    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
391    */
392   function releaseTokenTransfer() public onlyReleaseAgent {
393     released = true;
394   }
395 
396   /** The function can be called only before or after the tokens have been releasesd */
397   modifier inReleaseState(bool releaseState) {
398     if(releaseState != released) {
399         throw;
400     }
401     _;
402   }
403 
404   /** The function can be called only by a whitelisted release agent. */
405   modifier onlyReleaseAgent() {
406     if(msg.sender != releaseAgent) {
407         throw;
408     }
409     _;
410   }
411 
412   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
413     // Call StandardToken.transfer()
414    return super.transfer(_to, _value);
415   }
416 
417   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
418     // Call StandardToken.transferForm()
419     return super.transferFrom(_from, _to, _value);
420   }
421 
422 }
423 
424 
425 
426 
427 
428 /**
429  * Safe unsigned safe math.
430  *
431  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
432  *
433  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
434  *
435  * Maintained here until merged to mainline zeppelin-solidity.
436  *
437  */
438 library SafeMathLib {
439 
440   function times(uint a, uint b) returns (uint) {
441     uint c = a * b;
442     assert(a == 0 || c / a == b);
443     return c;
444   }
445 
446   function minus(uint a, uint b) returns (uint) {
447     assert(b <= a);
448     return a - b;
449   }
450 
451   function plus(uint a, uint b) returns (uint) {
452     uint c = a + b;
453     assert(c>=a);
454     return c;
455   }
456 
457   function assert(bool assertion) private {
458     if (!assertion) throw;
459   }
460 }
461 
462 
463 
464 /**
465  * A token that can increase its supply by another contract.
466  *
467  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
468  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
469  *
470  */
471 contract MintableToken is StandardToken, Ownable {
472 
473   using SafeMathLib for uint;
474 
475   bool public mintingFinished = false;
476 
477   /** List of agents that are allowed to create new tokens */
478   mapping (address => bool) public mintAgents;
479 
480   event MintingAgentChanged(address addr, bool state  );
481 
482   /**
483    * Create new tokens and allocate them to an address..
484    *
485    * Only callably by a crowdsale contract (mint agent).
486    */
487   function mint(address receiver, uint amount) onlyMintAgent canMint public {
488     totalSupply = totalSupply.plus(amount);
489     balances[receiver] = balances[receiver].plus(amount);
490 
491     // This will make the mint transaction apper in EtherScan.io
492     // We can remove this after there is a standardized minting event
493     Transfer(0, receiver, amount);
494   }
495 
496   /**
497    * Owner can allow a crowdsale contract to mint new tokens.
498    */
499   function setMintAgent(address addr, bool state) onlyOwner canMint public {
500     mintAgents[addr] = state;
501     MintingAgentChanged(addr, state);
502   }
503 
504   modifier onlyMintAgent() {
505     // Only crowdsale contracts are allowed to mint new tokens
506     if(!mintAgents[msg.sender]) {
507         throw;
508     }
509     _;
510   }
511 
512   /** Make sure we are not done yet. */
513   modifier canMint() {
514     if(mintingFinished) throw;
515     _;
516   }
517 }
518 
519 
520 
521 /**
522  * A crowdsaled token.
523  *
524  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
525  *
526  * - The token transfer() is disabled until the crowdsale is over
527  * - The token contract gives an opt-in upgrade path to a new contract
528  * - The same token can be part of several crowdsales through approve() mechanism
529  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
530  *
531  */
532 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
533 
534   /** Name and symbol were updated. */
535   event UpdatedTokenInformation(string newName, string newSymbol);
536 
537   string public name;
538 
539   string public symbol;
540 
541   uint public decimals;
542 
543   /**
544    * Construct the token.
545    *
546    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
547    *
548    * @param _name Token name
549    * @param _symbol Token symbol - should be all caps
550    * @param _initialSupply How many tokens we start with
551    * @param _decimals Number of decimal places
552    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
553    */
554   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
555     UpgradeableToken(msg.sender) {
556 
557     // Create any address, can be transferred
558     // to team multisig via changeOwner(),
559     // also remember to call setUpgradeMaster()
560     owner = msg.sender;
561 
562     name = _name;
563     symbol = _symbol;
564 
565     totalSupply = _initialSupply;
566 
567     decimals = _decimals;
568 
569     // Create initially all balance on the team multisig
570     balances[owner] = totalSupply;
571 
572     if(totalSupply > 0) {
573       Minted(owner, totalSupply);
574     }
575 
576     // No more new supply allowed after the token creation
577     if(!_mintable) {
578       mintingFinished = true;
579       if(totalSupply == 0) {
580         throw; // Cannot create a token without supply and no minting
581       }
582     }
583   }
584 
585   /**
586    * When token is released to be transferable, enforce no new tokens can be created.
587    */
588   function releaseTokenTransfer() public onlyReleaseAgent {
589     mintingFinished = true;
590     super.releaseTokenTransfer();
591   }
592 
593   /**
594    * Allow upgrade agent functionality kick in only if the crowdsale was success.
595    */
596   function canUpgrade() public constant returns(bool) {
597     return released && super.canUpgrade();
598   }
599 
600   /**
601    * Owner can update token information here.
602    *
603    * It is often useful to conceal the actual token association, until
604    * the token operations, like central issuance or reissuance have been completed.
605    *
606    * This function allows the token owner to rename the token after the operations
607    * have been completed and then point the audience to use the token contract.
608    */
609   function setTokenInformation(string _name, string _symbol) onlyOwner {
610     name = _name;
611     symbol = _symbol;
612 
613     UpdatedTokenInformation(name, symbol);
614   }
615 
616 }
617 
618 
619 /**
620  * A crowdsaled token that you can also burn.
621  *
622  */
623 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
624 
625   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
626     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
627 
628   }
629 }