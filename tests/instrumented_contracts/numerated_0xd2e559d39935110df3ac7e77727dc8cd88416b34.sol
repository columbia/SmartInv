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
89   /**
90    *
91    * Fix for the ERC20 short address attack
92    *
93    * http://vessenes.com/the-erc20-short-address-attack-explained/
94    */
95   modifier onlyPayloadSize(uint size) {
96      if(msg.data.length != size + 4) {
97        throw;
98      }
99      _;
100   }
101 
102   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
103     balances[msg.sender] = safeSub(balances[msg.sender], _value);
104     balances[_to] = safeAdd(balances[_to], _value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
110     uint _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
113     // if (_value > _allowance) throw;
114 
115     balances[_to] = safeAdd(balances[_to], _value);
116     balances[_from] = safeSub(balances[_from], _value);
117     allowed[_from][msg.sender] = safeSub(_allowance, _value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   function balanceOf(address _owner) constant returns (uint balance) {
123     return balances[_owner];
124   }
125 
126   function approve(address _spender, uint _value) returns (bool success) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   function allowance(address _owner, address _spender) constant returns (uint remaining) {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * Atomic increment of approved spending
145    *
146    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    *
148    */
149   function addApproval(address _spender, uint _addedValue)
150   onlyPayloadSize(2 * 32)
151   returns (bool success) {
152       uint oldValue = allowed[msg.sender][_spender];
153       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
154       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155       return true;
156   }
157 
158   /**
159    * Atomic decrement of approved spending.
160    *
161    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    */
163   function subApproval(address _spender, uint _subtractedValue)
164   onlyPayloadSize(2 * 32)
165   returns (bool success) {
166 
167       uint oldVal = allowed[msg.sender][_spender];
168 
169       if (_subtractedValue > oldVal) {
170           allowed[msg.sender][_spender] = 0;
171       } else {
172           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
173       }
174       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175       return true;
176   }
177 
178 }
179 
180 
181 
182 contract BurnableToken is StandardToken {
183 
184   address public constant BURN_ADDRESS = 0;
185 
186   /** How many tokens we burned */
187   event Burned(address burner, uint burnedAmount);
188 
189   /**
190    * Burn extra tokens from a balance.
191    *
192    */
193   function burn(uint burnAmount) {
194     address burner = msg.sender;
195     balances[burner] = safeSub(balances[burner], burnAmount);
196     totalSupply = safeSub(totalSupply, burnAmount);
197     Burned(burner, burnAmount);
198   }
199 }
200 
201 
202 
203 
204 
205 
206 
207 /**
208  * Upgrade agent interface inspired by Lunyr.
209  *
210  * Upgrade agent transfers tokens to a new contract.
211  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
212  */
213 contract UpgradeAgent {
214 
215   uint public originalSupply;
216 
217   /** Interface marker */
218   function isUpgradeAgent() public constant returns (bool) {
219     return true;
220   }
221 
222   function upgradeFrom(address _from, uint256 _value) public;
223 
224 }
225 
226 
227 /**
228  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
229  *
230  * First envisioned by Golem and Lunyr projects.
231  */
232 contract UpgradeableToken is StandardToken {
233 
234   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
235   address public upgradeMaster;
236 
237   /** The next contract where the tokens will be migrated. */
238   UpgradeAgent public upgradeAgent;
239 
240   /** How many tokens we have upgraded by now. */
241   uint256 public totalUpgraded;
242 
243   /**
244    * Upgrade states.
245    *
246    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
247    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
248    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
249    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
250    *
251    */
252   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
253 
254   /**
255    * Somebody has upgraded some of his tokens.
256    */
257   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
258 
259   /**
260    * New upgrade agent available.
261    */
262   event UpgradeAgentSet(address agent);
263 
264   /**
265    * Do not allow construction without upgrade master set.
266    */
267   function UpgradeableToken(address _upgradeMaster) {
268     upgradeMaster = _upgradeMaster;
269   }
270 
271   /**
272    * Allow the token holder to upgrade some of their tokens to a new contract.
273    */
274   function upgrade(uint256 value) public {
275 
276       UpgradeState state = getUpgradeState();
277       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
278         // Called in a bad state
279         throw;
280       }
281 
282       // Validate input value.
283       if (value == 0) throw;
284 
285       balances[msg.sender] = safeSub(balances[msg.sender], value);
286 
287       // Take tokens out from circulation
288       totalSupply = safeSub(totalSupply, value);
289       totalUpgraded = safeAdd(totalUpgraded, value);
290 
291       // Upgrade agent reissues the tokens
292       upgradeAgent.upgradeFrom(msg.sender, value);
293       Upgrade(msg.sender, upgradeAgent, value);
294   }
295 
296   /**
297    * Set an upgrade agent that handles
298    */
299   function setUpgradeAgent(address agent) external {
300 
301       if(!canUpgrade()) {
302         // The token is not yet in a state that we could think upgrading
303         throw;
304       }
305 
306       if (agent == 0x0) throw;
307       // Only a master can designate the next agent
308       if (msg.sender != upgradeMaster) throw;
309       // Upgrade has already begun for an agent
310       if (getUpgradeState() == UpgradeState.Upgrading) throw;
311 
312       upgradeAgent = UpgradeAgent(agent);
313 
314       // Bad interface
315       if(!upgradeAgent.isUpgradeAgent()) throw;
316       // Make sure that token supplies match in source and target
317       if (upgradeAgent.originalSupply() != totalSupply) throw;
318 
319       UpgradeAgentSet(upgradeAgent);
320   }
321 
322   /**
323    * Get the state of the token upgrade.
324    */
325   function getUpgradeState() public constant returns(UpgradeState) {
326     if(!canUpgrade()) return UpgradeState.NotAllowed;
327     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
328     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
329     else return UpgradeState.Upgrading;
330   }
331 
332   /**
333    * Change the upgrade master.
334    *
335    * This allows us to set a new owner for the upgrade mechanism.
336    */
337   function setUpgradeMaster(address master) public {
338       if (master == 0x0) throw;
339       if (msg.sender != upgradeMaster) throw;
340       upgradeMaster = master;
341   }
342 
343   /**
344    * Child contract can enable to provide the condition when the upgrade can begun.
345    */
346   function canUpgrade() public constant returns(bool) {
347      return true;
348   }
349 
350 }
351 
352 
353 
354 
355 /*
356  * Ownable
357  *
358  * Base contract with an owner.
359  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
360  */
361 contract Ownable {
362   address public owner;
363 
364   function Ownable() {
365     owner = msg.sender;
366   }
367 
368   modifier onlyOwner() {
369     if (msg.sender != owner) {
370       throw;
371     }
372     _;
373   }
374 
375   function transferOwnership(address newOwner) onlyOwner {
376     if (newOwner != address(0)) {
377       owner = newOwner;
378     }
379   }
380 
381 }
382 
383 
384 
385 
386 /**
387  * Define interface for releasing the token transfer after a successful crowdsale.
388  */
389 contract ReleasableToken is ERC20, Ownable {
390 
391   /* The finalizer contract that allows unlift the transfer limits on this token */
392   address public releaseAgent;
393 
394   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
395   bool public released = false;
396 
397   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
398   mapping (address => bool) public transferAgents;
399 
400   /**
401    * Limit token transfer until the crowdsale is over.
402    *
403    */
404   modifier canTransfer(address _sender) {
405 
406     if(!released) {
407         if(!transferAgents[_sender]) {
408             throw;
409         }
410     }
411 
412     _;
413   }
414 
415   /**
416    * Set the contract that can call release and make the token transferable.
417    *
418    * Design choice. Allow reset the release agent to fix fat finger mistakes.
419    */
420   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
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
474 /**
475  * Safe unsigned safe math.
476  *
477  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
478  *
479  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
480  *
481  * Maintained here until merged to mainline zeppelin-solidity.
482  *
483  */
484 library SafeMathLib {
485 
486   function times(uint a, uint b) returns (uint) {
487     uint c = a * b;
488     assert(a == 0 || c / a == b);
489     return c;
490   }
491 
492   function minus(uint a, uint b) returns (uint) {
493     assert(b <= a);
494     return a - b;
495   }
496 
497   function plus(uint a, uint b) returns (uint) {
498     uint c = a + b;
499     assert(c>=a);
500     return c;
501   }
502 
503   function assert(bool assertion) private {
504     if (!assertion) throw;
505   }
506 }
507 
508 
509 
510 /**
511  * A token that can increase its supply by another contract.
512  *
513  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
514  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
515  *
516  */
517 contract MintableToken is StandardToken, Ownable {
518 
519   using SafeMathLib for uint;
520 
521   bool public mintingFinished = false;
522 
523   /** List of agents that are allowed to create new tokens */
524   mapping (address => bool) public mintAgents;
525 
526   event MintingAgentChanged(address addr, bool state  );
527 
528   /**
529    * Create new tokens and allocate them to an address..
530    *
531    * Only callably by a crowdsale contract (mint agent).
532    */
533   function mint(address receiver, uint amount) onlyMintAgent canMint public {
534     totalSupply = totalSupply.plus(amount);
535     balances[receiver] = balances[receiver].plus(amount);
536     Transfer(0, receiver, amount);
537   }
538 
539   /**
540    * Owner can allow a crowdsale contract to mint new tokens.
541    */
542   function setMintAgent(address addr, bool state) onlyOwner canMint public {
543     mintAgents[addr] = state;
544     MintingAgentChanged(addr, state);
545   }
546 
547   modifier onlyMintAgent() {
548     // Only crowdsale contracts are allowed to mint new tokens
549     if(!mintAgents[msg.sender]) {
550         throw;
551     }
552     _;
553   }
554 
555   /** Make sure we are not done yet. */
556   modifier canMint() {
557     if(mintingFinished) throw;
558     _;
559   }
560 }
561 
562 
563 
564 
565 /**
566  * A crowdsaled token.
567  *
568  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
569  *
570  * - The token transfer() is disabled until the crowdsale is over
571  * - The token contract gives an opt-in upgrade path to a new contract
572  * - The same token can be part of several crowdsales through approve() mechanism
573  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
574  *
575  */
576 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
577 
578   string public name;
579 
580   string public symbol;
581 
582   uint public decimals;
583 
584   /**
585    * Construct the token.
586    *
587    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
588    *
589    * @param _name Token name
590    * @param _symbol Token symbol - should be all caps
591    * @param _initialSupply How many tokens we start with
592    * @param _decimals Number of decimal places
593    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
594    */
595   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
596     UpgradeableToken(msg.sender) {
597 
598     // Create any address, can be transferred
599     // to team multisig via changeOwner(),
600     // also remember to call setUpgradeMaster()
601     owner = msg.sender;
602 
603     name = _name;
604     symbol = _symbol;
605 
606     totalSupply = _initialSupply;
607 
608     decimals = _decimals;
609 
610     // Create initially all balance on the team multisig
611     balances[owner] = totalSupply;
612 
613     if(totalSupply > 0) {
614       Minted(owner, totalSupply);
615     }
616 
617     // No more new supply allowed after the token creation
618     if(!_mintable) {
619       mintingFinished = true;
620       if(totalSupply == 0) {
621         throw; // Cannot create a token without supply and no minting
622       }
623     }
624   }
625 
626   /**
627    * When token is released to be transferable, enforce no new tokens can be created.
628    */
629   function releaseTokenTransfer() public onlyReleaseAgent {
630     mintingFinished = true;
631     super.releaseTokenTransfer();
632   }
633 
634   /**
635    * Allow upgrade agent functionality kick in only if the crowdsale was success.
636    */
637   function canUpgrade() public constant returns(bool) {
638     return released && super.canUpgrade();
639   }
640 
641 }
642 
643 
644 /**
645  * A crowdsaled token that you can also burn.
646  *
647  */
648 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
649 
650   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
651     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
652 
653   }
654 }