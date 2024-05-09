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
145  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
146  *
147  * First envisioned by Golem and Lunyr projects.
148  */
149 contract UpgradeableToken is StandardToken {
150 
151   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
152   address public upgradeMaster;
153 
154   /** The next contract where the tokens will be migrated. */
155   UpgradeAgent public upgradeAgent;
156 
157   /** How many tokens we have upgraded by now. */
158   uint256 public totalUpgraded;
159 
160   /**
161    * Upgrade states.
162    *
163    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
164    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
165    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
166    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
167    *
168    */
169   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
170 
171   /**
172    * Somebody has upgraded some of his tokens.
173    */
174   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
175 
176   /**
177    * New upgrade agent available.
178    */
179   event UpgradeAgentSet(address agent);
180 
181   /**
182    * Do not allow construction without upgrade master set.
183    */
184   function UpgradeableToken(address _upgradeMaster) {
185     upgradeMaster = _upgradeMaster;
186   }
187 
188   /**
189    * Allow the token holder to upgrade some of their tokens to a new contract.
190    */
191   function upgrade(uint256 value) public {
192 
193       UpgradeState state = getUpgradeState();
194       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
195         // Called in a bad state
196         throw;
197       }
198 
199       // Validate input value.
200       if (value == 0) throw;
201 
202       balances[msg.sender] = safeSub(balances[msg.sender], value);
203 
204       // Take tokens out from circulation
205       totalSupply = safeSub(totalSupply, value);
206       totalUpgraded = safeAdd(totalUpgraded, value);
207 
208       // Upgrade agent reissues the tokens
209       upgradeAgent.upgradeFrom(msg.sender, value);
210       Upgrade(msg.sender, upgradeAgent, value);
211   }
212 
213   /**
214    * Set an upgrade agent that handles
215    */
216   function setUpgradeAgent(address agent) external {
217 
218       if(!canUpgrade()) {
219         // The token is not yet in a state that we could think upgrading
220         throw;
221       }
222 
223       if (agent == 0x0) throw;
224       // Only a master can designate the next agent
225       if (msg.sender != upgradeMaster) throw;
226       // Upgrade has already begun for an agent
227       if (getUpgradeState() == UpgradeState.Upgrading) throw;
228 
229       upgradeAgent = UpgradeAgent(agent);
230 
231       // Bad interface
232       if(!upgradeAgent.isUpgradeAgent()) throw;
233       // Make sure that token supplies match in source and target
234       if (upgradeAgent.originalSupply() != totalSupply) throw;
235 
236       UpgradeAgentSet(upgradeAgent);
237   }
238 
239   /**
240    * Get the state of the token upgrade.
241    */
242   function getUpgradeState() public constant returns(UpgradeState) {
243     if(!canUpgrade()) return UpgradeState.NotAllowed;
244     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
245     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
246     else return UpgradeState.Upgrading;
247   }
248 
249   /**
250    * Change the upgrade master.
251    *
252    * This allows us to set a new owner for the upgrade mechanism.
253    */
254   function setUpgradeMaster(address master) public {
255       if (master == 0x0) throw;
256       if (msg.sender != upgradeMaster) throw;
257       upgradeMaster = master;
258   }
259 
260   /**
261    * Child contract can enable to provide the condition when the upgrade can begun.
262    */
263   function canUpgrade() public constant returns(bool) {
264      return true;
265   }
266 
267 }
268 
269 
270 
271 
272 /*
273  * Ownable
274  *
275  * Base contract with an owner.
276  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
277  */
278 contract Ownable {
279   address public owner;
280 
281   function Ownable() {
282     owner = msg.sender;
283   }
284 
285   modifier onlyOwner() {
286     if (msg.sender != owner) {
287       throw;
288     }
289     _;
290   }
291 
292   function transferOwnership(address newOwner) onlyOwner {
293     if (newOwner != address(0)) {
294       owner = newOwner;
295     }
296   }
297 
298 }
299 
300 
301 
302 
303 /**
304  * Define interface for releasing the token transfer after a successful crowdsale.
305  */
306 contract ReleasableToken is ERC20, Ownable {
307 
308   /* The finalizer contract that allows unlift the transfer limits on this token */
309   address public releaseAgent;
310 
311   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
312   bool public released = false;
313 
314   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
315   mapping (address => bool) public transferAgents;
316 
317   /**
318    * Limit token transfer until the crowdsale is over.
319    *
320    */
321   modifier canTransfer(address _sender) {
322 
323     if(!released) {
324         if(!transferAgents[_sender]) {
325             throw;
326         }
327     }
328 
329     _;
330   }
331 
332   /**
333    * Set the contract that can call release and make the token transferable.
334    *
335    * Design choice. Allow reset the release agent to fix fat finger mistakes.
336    */
337   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
338 
339     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
340     releaseAgent = addr;
341   }
342 
343   /**
344    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
345    */
346   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
347     transferAgents[addr] = state;
348   }
349 
350   /**
351    * One way function to release the tokens to the wild.
352    *
353    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
354    */
355   function releaseTokenTransfer() public onlyReleaseAgent {
356     released = true;
357   }
358 
359   /** The function can be called only before or after the tokens have been releasesd */
360   modifier inReleaseState(bool releaseState) {
361     if(releaseState != released) {
362         throw;
363     }
364     _;
365   }
366 
367   /** The function can be called only by a whitelisted release agent. */
368   modifier onlyReleaseAgent() {
369     if(msg.sender != releaseAgent) {
370         throw;
371     }
372     _;
373   }
374 
375   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
376     // Call StandardToken.transfer()
377    return super.transfer(_to, _value);
378   }
379 
380   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
381     // Call StandardToken.transferForm()
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385 }
386 
387 
388 
389 
390 
391 /**
392  * Safe unsigned safe math.
393  *
394  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
395  *
396  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
397  *
398  * Maintained here until merged to mainline zeppelin-solidity.
399  *
400  */
401 library SafeMathLib {
402 
403   function times(uint a, uint b) returns (uint) {
404     uint c = a * b;
405     assert(a == 0 || c / a == b);
406     return c;
407   }
408 
409   function minus(uint a, uint b) returns (uint) {
410     assert(b <= a);
411     return a - b;
412   }
413 
414   function plus(uint a, uint b) returns (uint) {
415     uint c = a + b;
416     assert(c>=a && c>=b);
417     return c;
418   }
419 
420   function assert(bool assertion) private {
421     if (!assertion) throw;
422   }
423 }
424 
425 
426 
427 /**
428  * A token that can increase its supply by another contract.
429  *
430  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
431  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
432  *
433  */
434 contract MintableToken is StandardToken, Ownable {
435 
436   using SafeMathLib for uint;
437 
438   bool public mintingFinished = false;
439 
440   /** List of agents that are allowed to create new tokens */
441   mapping (address => bool) public mintAgents;
442 
443   /**
444    * Create new tokens and allocate them to an address..
445    *
446    * Only callably by a crowdsale contract (mint agent).
447    */
448   function mint(address receiver, uint amount) onlyMintAgent canMint public {
449     totalSupply = totalSupply.plus(amount);
450     balances[receiver] = balances[receiver].plus(amount);
451     Transfer(0, receiver, amount);
452   }
453 
454   /**
455    * Owner can allow a crowdsale contract to mint new tokens.
456    */
457   function setMintAgent(address addr, bool state) onlyOwner canMint public {
458     mintAgents[addr] = state;
459   }
460 
461   modifier onlyMintAgent() {
462     // Only crowdsale contracts are allowed to mint new tokens
463     if(!mintAgents[msg.sender]) {
464         throw;
465     }
466     _;
467   }
468 
469   /** Make sure we are not done yet. */
470   modifier canMint() {
471     if(mintingFinished) throw;
472     _;
473   }
474 }
475 
476 
477 
478 
479 /**
480  * A crowdsaled token.
481  *
482  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
483  *
484  * - The token transfer() is disabled until the crowdsale is over
485  * - The token contract gives an opt-in upgrade path to a new contract
486  * - The same token can be part of several crowdsales through approve() mechanism
487  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
488  *
489  */
490 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
491 
492   string public name;
493 
494   string public symbol;
495 
496   uint public decimals;
497 
498   /**
499    * Construct the token.
500    *
501    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
502    */
503   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
504     UpgradeableToken(msg.sender) {
505 
506     // Create any address, can be transferred
507     // to team multisig via changeOwner(),
508     // also remember to call setUpgradeMaster()
509     owner = msg.sender;
510 
511     name = _name;
512     symbol = _symbol;
513 
514     totalSupply = _initialSupply;
515 
516     decimals = _decimals;
517 
518     // Create initially all balance on the team multisig
519     balances[owner] = totalSupply;
520   }
521 
522   /**
523    * When token is released to be transferable, enforce no new tokens can be created.
524    */
525   function releaseTokenTransfer() public onlyReleaseAgent {
526     mintingFinished = true;
527     super.releaseTokenTransfer();
528   }
529 
530   /**
531    * Allow upgrade agent functionality kick in only if the crowdsale was success.
532    */
533   function canUpgrade() public constant returns(bool) {
534     return released;
535   }
536 
537 }