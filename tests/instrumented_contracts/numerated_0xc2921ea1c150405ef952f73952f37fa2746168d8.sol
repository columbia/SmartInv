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
73  * Standard ERC20 token
74  *
75  * https://github.com/ethereum/EIPs/issues/20
76  * Based on code by FirstBlood:
77  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract StandardToken is ERC20, SafeMath {
80 
81   mapping(address => uint) balances;
82   mapping (address => mapping (address => uint)) allowed;
83 
84   function transfer(address _to, uint _value) returns (bool success) {
85     balances[msg.sender] = safeSub(balances[msg.sender], _value);
86     balances[_to] = safeAdd(balances[_to], _value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
92     var _allowance = allowed[_from][msg.sender];
93 
94     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
95     // if (_value > _allowance) throw;
96 
97     balances[_to] = safeAdd(balances[_to], _value);
98     balances[_from] = safeSub(balances[_from], _value);
99     allowed[_from][msg.sender] = safeSub(_allowance, _value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108   function approve(address _spender, uint _value) returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) constant returns (uint remaining) {
115     return allowed[_owner][_spender];
116   }
117 
118 }
119 
120 
121 
122 
123 
124 /**
125  * Upgrade agent interface inspired by Lunyr.
126  *
127  * Upgrade agent transfers tokens to a new contract.
128  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
129  */
130 contract UpgradeAgent {
131 
132   uint public originalSupply;
133 
134   /** Interface marker */
135   function isUpgradeAgent() public constant returns (bool) {
136     return true;
137   }
138 
139   function upgradeFrom(address _from, uint256 _value) public;
140 
141 }
142 
143 
144 /**
145  * Safe unsigned safe math.
146  *
147  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
148  *
149  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
150  *
151  * Maintained here until merged to mainline zeppelin-solidity.
152  *
153  */
154 library SafeMathLib {
155 
156   function times(uint a, uint b) returns (uint) {
157     uint c = a * b;
158     assert(a == 0 || c / a == b);
159     return c;
160   }
161 
162   function minus(uint a, uint b) returns (uint) {
163     assert(b <= a);
164     return a - b;
165   }
166 
167   function plus(uint a, uint b) returns (uint) {
168     uint c = a + b;
169     assert(c>=a && c>=b);
170     return c;
171   }
172 
173   function assert(bool assertion) private {
174     if (!assertion) throw;
175   }
176 }
177 
178 
179 /**
180  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
181  *
182  * First envisioned by Golem and Lunyr projects.
183  */
184 contract UpgradeableToken is StandardToken {
185 
186   using SafeMathLib for uint;
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
208   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
209   event UpgradeAgentSet(address agent);
210 
211   /**
212    * Do not allow construction without upgrade master set.
213    */
214   function UpgradeAgentEnabledToken(address _upgradeMaster) {
215     upgradeMaster = _upgradeMaster;
216   }
217 
218   /**
219    * Allow the token holder to upgrade some of their tokens to a new contract.
220    */
221   function upgrade(uint256 value) public {
222 
223       UpgradeState state = getUpgradeState();
224       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
225         // Called in a bad state
226         throw;
227       }
228 
229       // Validate input value.
230       if (value == 0) throw;
231 
232       balances[msg.sender] = balances[msg.sender].minus(value);
233 
234       // Take tokens out from circulation
235       totalSupply = totalSupply.minus(value);
236       totalUpgraded = totalUpgraded.plus(value);
237 
238       // Upgrade agent reissues the tokens
239       upgradeAgent.upgradeFrom(msg.sender, value);
240       Upgrade(msg.sender, upgradeAgent, value);
241   }
242 
243   /**
244    * Set an upgrade agent that handles
245    */
246   function setUpgradeAgent(address agent) external {
247 
248       if(!canUpgrade()) {
249         // The token is not yet in a state that we could think upgrading
250         throw;
251       }
252 
253       if (agent == 0x0) throw;
254       // Only a master can designate the next agent
255       if (msg.sender != upgradeMaster) throw;
256       // Upgrade has already begun for an agent
257       if (getUpgradeState() == UpgradeState.Upgrading) throw;
258 
259       upgradeAgent = UpgradeAgent(agent);
260 
261       // Bad interface
262       if(!upgradeAgent.isUpgradeAgent()) throw;
263 
264       // Make sure that token supplies match in source and target
265       if (upgradeAgent.originalSupply() != totalSupply) throw;
266 
267       UpgradeAgentSet(upgradeAgent);
268   }
269 
270   /**
271    * Get the state of the token upgrade.
272    */
273   function getUpgradeState() public constant returns(UpgradeState) {
274     if(!canUpgrade()) return UpgradeState.NotAllowed;
275     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
276     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
277     else return UpgradeState.Upgrading;
278   }
279 
280   /**
281    * Change the upgrade master.
282    *
283    * This allows us to set a new owner for the upgrade mechanism.
284    */
285   function setUpgradeMaster(address master) external {
286       if (master == 0x0) throw;
287       if (msg.sender != upgradeMaster) throw;
288       upgradeMaster = master;
289   }
290 
291   /**
292    * Child contract can enable to provide the condition when the upgrade can begun.
293    */
294   function canUpgrade() public constant returns(bool) {
295      return true;
296   }
297 
298 }
299 
300 
301 
302 
303 /*
304  * Ownable
305  *
306  * Base contract with an owner.
307  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
308  */
309 contract Ownable {
310   address public owner;
311 
312   function Ownable() {
313     owner = msg.sender;
314   }
315 
316   modifier onlyOwner() {
317     if (msg.sender != owner) {
318       throw;
319     }
320     _;
321   }
322 
323   function transferOwnership(address newOwner) onlyOwner {
324     if (newOwner != address(0)) {
325       owner = newOwner;
326     }
327   }
328 
329 }
330 
331 
332 
333 
334 /*
335 
336 TransferableToken defines the generic interface and the implementation
337 to limit token transferability for different events.
338 
339 It is intended to be used as a base class for other token contracts.
340 
341 Over-writting transferableTokens(address holder, uint64 time) is the way to provide
342 the specific logic for limitting token transferability for a holder over time.
343 
344 TransferableToken has been designed to allow for different limitting factors,
345 this can be achieved by recursively calling super.transferableTokens() until the
346 base class is hit. For example:
347 
348 function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
349   return min256(unlockedTokens, super.transferableTokens(holder, time));
350 }
351 
352 A working example is VestedToken.sol:
353 https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
354 
355 */
356 
357 contract TransferableToken is ERC20 {
358   // Checks whether it can transfer or otherwise throws.
359   modifier canTransfer(address _sender, uint _value) {
360    if (_value > transferableTokens(_sender, uint64(now))) throw;
361    _;
362   }
363 
364   // Checks modifier and allows transfer if tokens are not locked.
365   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool success) {
366    return super.transfer(_to, _value);
367   }
368 
369   // Checks modifier and allows transfer if tokens are not locked.
370   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool success) {
371    return super.transferFrom(_from, _to, _value);
372   }
373 
374   // Default transferable tokens function returns all tokens for a holder (no limit).
375   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
376     return balanceOf(holder);
377   }
378 }
379 
380 
381 
382 
383 /**
384  * Define interface for releasing the token transfer after a successful crowdsale.
385  */
386 contract ReleasableToken is ERC20, Ownable {
387 
388   /* The finalizer contract that allows unlift the transfer limits on this token */
389   address public releaseAgent;
390 
391   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
392   bool public released = false;
393 
394   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
395   mapping (address => bool) public transferAgents;
396 
397   /**
398    * Limit token transfer until the crowdsale is over.
399    *
400    */
401   modifier canTransfer(address _sender) {
402 
403     if(!released) {
404         if(!transferAgents[_sender]) {
405             throw;
406         }
407     }
408 
409     _;
410   }
411 
412   /**
413    * Set the contract that can call release and make the token transferable.
414    */
415   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
416 
417     // Already set
418     if(releaseAgent != 0) {
419       throw;
420     }
421 
422     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
423     releaseAgent = addr;
424   }
425 
426   /**
427    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
428    */
429   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
430     transferAgents[addr] = state;
431   }
432 
433   /**
434    * One way function to release the tokens to the wild.
435    *
436    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
437    */
438   function releaseTokenTransfer() public onlyReleaseAgent {
439     released = true;
440   }
441 
442   /** The function can be called only before or after the tokens have been releasesd */
443   modifier inReleaseState(bool releaseState) {
444     if(releaseState != released) {
445         throw;
446     }
447     _;
448   }
449 
450   /** The function can be called only by a whitelisted release agent. */
451   modifier onlyReleaseAgent() {
452     if(msg.sender != releaseAgent) {
453         throw;
454     }
455     _;
456   }
457 
458   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
459     // Call StandardToken.transfer()
460    return super.transfer(_to, _value);
461   }
462 
463   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
464     // Call StandardToken.transferForm()
465     return super.transferFrom(_from, _to, _value);
466   }
467 
468 }
469 
470 
471 
472 
473 
474 
475 
476 /**
477  * A token that can increase its supply by another contract.
478  *
479  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
480  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
481  *
482  */
483 contract MintableToken is StandardToken, Ownable {
484 
485   using SafeMathLib for uint;
486 
487   bool public mintingFinished = false;
488 
489   /** List of agents that are allowed to create new tokens */
490   mapping (address => bool) public mintAgents;
491 
492   /**
493    * Create new tokens and allocate them to an address..
494    *
495    * Only callably by a crowdsale contract (mint agent).
496    */
497   function mint(address receiver, uint amount) onlyMintAgent canMint public {
498     totalSupply = totalSupply.plus(amount);
499     balances[receiver] = balances[receiver].plus(amount);
500     Transfer(0, receiver, amount);
501   }
502 
503   /**
504    * Owner can allow a crowdsale contract to mint new tokens.
505    */
506   function setMintAgent(address addr, bool state) onlyOwner canMint public {
507     mintAgents[addr] = state;
508   }
509 
510   modifier onlyMintAgent() {
511     // Only crowdsale contracts are allowed to mint new tokens
512     if(!mintAgents[msg.sender]) {
513         throw;
514     }
515     _;
516   }
517 
518   /** Make sure we are not done yet. */
519   modifier canMint() {
520     if(mintingFinished) throw;
521     _;
522   }
523 }
524 
525 
526 
527 
528 /**
529  * A crowdsaled token.
530  *
531  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
532  *
533  * - The token transfer() is disabled until the crowdsale is over
534  * - The token contract gives an opt-in upgrade path to a new contract
535  * - The same token can be part of several crowdsales through approve() mechanism
536  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
537  *
538  */
539 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
540 
541   string public name;
542 
543   string public symbol;
544 
545   /** We don't want to support decimal places as it's not very well handled by different wallets */
546   uint public decimals = 0;
547 
548   /**
549    * Construct the token.
550    *
551    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
552    */
553   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply) {
554 
555     // Create from team multisig
556     owner = msg.sender;
557 
558     // Initially set the upgrade master same as owner
559     upgradeMaster = owner;
560 
561     name = _name;
562     symbol = _symbol;
563 
564     totalSupply = _initialSupply;
565 
566     // Create initially all balance on the team multisig
567     balances[msg.sender] = totalSupply;
568   }
569 
570   /**
571    * When token is released to be transferable, enforce no new tokens can be created.
572    */
573   function releaseTokenTransfer() public onlyReleaseAgent {
574     mintingFinished = true;
575     super.releaseTokenTransfer();
576   }
577 
578   /**
579    * Allow upgrade agent functionality kick in only if the crowdsale was success.
580    */
581   function canUpgrade() public constant returns(bool) {
582     return released;
583   }
584 
585 }