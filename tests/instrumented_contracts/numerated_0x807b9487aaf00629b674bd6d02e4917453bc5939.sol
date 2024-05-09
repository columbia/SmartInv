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
334 /**
335  * Define interface for releasing the token transfer after a successful crowdsale.
336  */
337 contract ReleasableToken is ERC20, Ownable {
338 
339   /* The finalizer contract that allows unlift the transfer limits on this token */
340   address public releaseAgent;
341 
342   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
343   bool public released = false;
344 
345   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
346   mapping (address => bool) public transferAgents;
347 
348   /**
349    * Limit token transfer until the crowdsale is over.
350    *
351    */
352   modifier canTransfer(address _sender) {
353 
354     if(!released) {
355         if(!transferAgents[_sender]) {
356             throw;
357         }
358     }
359 
360     _;
361   }
362 
363   /**
364    * Set the contract that can call release and make the token transferable.
365    *
366    * Design choice. Allow reset the release agent to fix fat finger mistakes.
367    */
368   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
369 
370     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
371     releaseAgent = addr;
372   }
373 
374   /**
375    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
376    */
377   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
378     transferAgents[addr] = state;
379   }
380 
381   /**
382    * One way function to release the tokens to the wild.
383    *
384    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
385    */
386   function releaseTokenTransfer() public onlyReleaseAgent {
387     released = true;
388   }
389 
390   /** The function can be called only before or after the tokens have been releasesd */
391   modifier inReleaseState(bool releaseState) {
392     if(releaseState != released) {
393         throw;
394     }
395     _;
396   }
397 
398   /** The function can be called only by a whitelisted release agent. */
399   modifier onlyReleaseAgent() {
400     if(msg.sender != releaseAgent) {
401         throw;
402     }
403     _;
404   }
405 
406   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
407     // Call StandardToken.transfer()
408    return super.transfer(_to, _value);
409   }
410 
411   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
412     // Call StandardToken.transferForm()
413     return super.transferFrom(_from, _to, _value);
414   }
415 
416 }
417 
418 
419 
420 
421 
422 
423 
424 /**
425  * A token that can increase its supply by another contract.
426  *
427  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
428  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
429  *
430  */
431 contract MintableToken is StandardToken, Ownable {
432 
433   using SafeMathLib for uint;
434 
435   bool public mintingFinished = false;
436 
437   /** List of agents that are allowed to create new tokens */
438   mapping (address => bool) public mintAgents;
439 
440   /**
441    * Create new tokens and allocate them to an address..
442    *
443    * Only callably by a crowdsale contract (mint agent).
444    */
445   function mint(address receiver, uint amount) onlyMintAgent canMint public {
446     totalSupply = totalSupply.plus(amount);
447     balances[receiver] = balances[receiver].plus(amount);
448     Transfer(0, receiver, amount);
449   }
450 
451   /**
452    * Owner can allow a crowdsale contract to mint new tokens.
453    */
454   function setMintAgent(address addr, bool state) onlyOwner canMint public {
455     mintAgents[addr] = state;
456   }
457 
458   modifier onlyMintAgent() {
459     // Only crowdsale contracts are allowed to mint new tokens
460     if(!mintAgents[msg.sender]) {
461         throw;
462     }
463     _;
464   }
465 
466   /** Make sure we are not done yet. */
467   modifier canMint() {
468     if(mintingFinished) throw;
469     _;
470   }
471 }
472 
473 
474 
475 
476 /**
477  * A crowdsaled token.
478  *
479  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
480  *
481  * - The token transfer() is disabled until the crowdsale is over
482  * - The token contract gives an opt-in upgrade path to a new contract
483  * - The same token can be part of several crowdsales through approve() mechanism
484  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
485  *
486  */
487 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
488 
489   string public name;
490 
491   string public symbol;
492 
493   uint public decimals;
494 
495   /**
496    * Construct the token.
497    *
498    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
499    */
500   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals) {
501 
502     // Create from team multisig
503     owner = msg.sender;
504 
505     // Initially set the upgrade master same as owner
506     upgradeMaster = owner;
507 
508     name = _name;
509     symbol = _symbol;
510 
511     totalSupply = _initialSupply;
512 
513     decimals = _decimals;
514 
515     // Create initially all balance on the team multisig
516     balances[msg.sender] = totalSupply;
517   }
518 
519   /**
520    * When token is released to be transferable, enforce no new tokens can be created.
521    */
522   function releaseTokenTransfer() public onlyReleaseAgent {
523     mintingFinished = true;
524     super.releaseTokenTransfer();
525   }
526 
527   /**
528    * Allow upgrade agent functionality kick in only if the crowdsale was success.
529    */
530   function canUpgrade() public constant returns(bool) {
531     return released;
532   }
533 
534 }