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
73  * Standard ERC20 token with Short Hand Attack protection.
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
84   /**
85    *
86    * Fix for the ERC20 short address attack
87    *
88    * http://vessenes.com/the-erc20-short-address-attack-explained/
89    */
90   modifier onlyPayloadSize(uint size) {
91      if(msg.data.length < size + 4) {
92        throw;
93      }
94      _;
95   }
96 
97   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
98     balances[msg.sender] = safeSub(balances[msg.sender], _value);
99     balances[_to] = safeAdd(balances[_to], _value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
105     var _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
108     // if (_value > _allowance) throw;
109 
110     balances[_to] = safeAdd(balances[_to], _value);
111     balances[_from] = safeSub(balances[_from], _value);
112     allowed[_from][msg.sender] = safeSub(_allowance, _value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   function balanceOf(address _owner) constant returns (uint balance) {
118     return balances[_owner];
119   }
120 
121   function approve(address _spender, uint _value) returns (bool success) {
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   function allowance(address _owner, address _spender) constant returns (uint remaining) {
128     return allowed[_owner][_spender];
129   }
130 
131 }
132 
133 
134 
135 
136 
137 /**
138  * Upgrade agent interface inspired by Lunyr.
139  *
140  * Upgrade agent transfers tokens to a new contract.
141  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
142  */
143 contract UpgradeAgent {
144 
145   uint public originalSupply;
146 
147   /** Interface marker */
148   function isUpgradeAgent() public constant returns (bool) {
149     return true;
150   }
151 
152   function upgradeFrom(address _from, uint256 _value) public;
153 
154 }
155 
156 
157 /**
158  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
159  *
160  * First envisioned by Golem and Lunyr projects.
161  */
162 contract UpgradeableToken is StandardToken {
163 
164   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
165   address public upgradeMaster;
166 
167   /** The next contract where the tokens will be migrated. */
168   UpgradeAgent public upgradeAgent;
169 
170   /** How many tokens we have upgraded by now. */
171   uint256 public totalUpgraded;
172 
173   /**
174    * Upgrade states.
175    *
176    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
177    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
178    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
179    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
180    *
181    */
182   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
183 
184   /**
185    * Somebody has upgraded some of his tokens.
186    */
187   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
188 
189   /**
190    * New upgrade agent available.
191    */
192   event UpgradeAgentSet(address agent);
193 
194   /**
195    * Do not allow construction without upgrade master set.
196    */
197   function UpgradeableToken(address _upgradeMaster) {
198     upgradeMaster = _upgradeMaster;
199   }
200 
201   /**
202    * Allow the token holder to upgrade some of their tokens to a new contract.
203    */
204   function upgrade(uint256 value) public {
205 
206       UpgradeState state = getUpgradeState();
207       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
208         // Called in a bad state
209         throw;
210       }
211 
212       // Validate input value.
213       if (value == 0) throw;
214 
215       balances[msg.sender] = safeSub(balances[msg.sender], value);
216 
217       // Take tokens out from circulation
218       totalSupply = safeSub(totalSupply, value);
219       totalUpgraded = safeAdd(totalUpgraded, value);
220 
221       // Upgrade agent reissues the tokens
222       upgradeAgent.upgradeFrom(msg.sender, value);
223       Upgrade(msg.sender, upgradeAgent, value);
224   }
225 
226   /**
227    * Set an upgrade agent that handles
228    */
229   function setUpgradeAgent(address agent) external {
230 
231       if(!canUpgrade()) {
232         // The token is not yet in a state that we could think upgrading
233         throw;
234       }
235 
236       if (agent == 0x0) throw;
237       // Only a master can designate the next agent
238       if (msg.sender != upgradeMaster) throw;
239       // Upgrade has already begun for an agent
240       if (getUpgradeState() == UpgradeState.Upgrading) throw;
241 
242       upgradeAgent = UpgradeAgent(agent);
243 
244       // Bad interface
245       if(!upgradeAgent.isUpgradeAgent()) throw;
246       // Make sure that token supplies match in source and target
247       if (upgradeAgent.originalSupply() != totalSupply) throw;
248 
249       UpgradeAgentSet(upgradeAgent);
250   }
251 
252   /**
253    * Get the state of the token upgrade.
254    */
255   function getUpgradeState() public constant returns(UpgradeState) {
256     if(!canUpgrade()) return UpgradeState.NotAllowed;
257     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
258     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
259     else return UpgradeState.Upgrading;
260   }
261 
262   /**
263    * Change the upgrade master.
264    *
265    * This allows us to set a new owner for the upgrade mechanism.
266    */
267   function setUpgradeMaster(address master) public {
268       if (master == 0x0) throw;
269       if (msg.sender != upgradeMaster) throw;
270       upgradeMaster = master;
271   }
272 
273   /**
274    * Child contract can enable to provide the condition when the upgrade can begun.
275    */
276   function canUpgrade() public constant returns(bool) {
277      return true;
278   }
279 
280 }
281 
282 
283 
284 
285 /*
286  * Ownable
287  *
288  * Base contract with an owner.
289  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
290  */
291 contract Ownable {
292   address public owner;
293 
294   function Ownable() {
295     owner = msg.sender;
296   }
297 
298   modifier onlyOwner() {
299     if (msg.sender != owner) {
300       throw;
301     }
302     _;
303   }
304 
305   function transferOwnership(address newOwner) onlyOwner {
306     if (newOwner != address(0)) {
307       owner = newOwner;
308     }
309   }
310 
311 }
312 
313 
314 
315 
316 /**
317  * Define interface for releasing the token transfer after a successful crowdsale.
318  */
319 contract ReleasableToken is ERC20, Ownable {
320 
321   /* The finalizer contract that allows unlift the transfer limits on this token */
322   address public releaseAgent;
323 
324   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
325   bool public released = false;
326 
327   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
328   mapping (address => bool) public transferAgents;
329 
330   /**
331    * Limit token transfer until the crowdsale is over.
332    *
333    */
334   modifier canTransfer(address _sender) {
335 
336     if(!released) {
337         if(!transferAgents[_sender]) {
338             throw;
339         }
340     }
341 
342     _;
343   }
344 
345   /**
346    * Set the contract that can call release and make the token transferable.
347    *
348    * Design choice. Allow reset the release agent to fix fat finger mistakes.
349    */
350   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
351 
352     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
353     releaseAgent = addr;
354   }
355 
356   /**
357    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
358    */
359   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
360     transferAgents[addr] = state;
361   }
362 
363   /**
364    * One way function to release the tokens to the wild.
365    *
366    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
367    */
368   function releaseTokenTransfer() public onlyReleaseAgent {
369     released = true;
370   }
371 
372   /** The function can be called only before or after the tokens have been releasesd */
373   modifier inReleaseState(bool releaseState) {
374     if(releaseState != released) {
375         throw;
376     }
377     _;
378   }
379 
380   /** The function can be called only by a whitelisted release agent. */
381   modifier onlyReleaseAgent() {
382     if(msg.sender != releaseAgent) {
383         throw;
384     }
385     _;
386   }
387 
388   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
389     // Call StandardToken.transfer()
390    return super.transfer(_to, _value);
391   }
392 
393   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
394     // Call StandardToken.transferForm()
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398 }
399 
400 
401 
402 
403 
404 /**
405  * Safe unsigned safe math.
406  *
407  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
408  *
409  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
410  *
411  * Maintained here until merged to mainline zeppelin-solidity.
412  *
413  */
414 library SafeMathLib {
415 
416   function times(uint a, uint b) returns (uint) {
417     uint c = a * b;
418     assert(a == 0 || c / a == b);
419     return c;
420   }
421 
422   function minus(uint a, uint b) returns (uint) {
423     assert(b <= a);
424     return a - b;
425   }
426 
427   function plus(uint a, uint b) returns (uint) {
428     uint c = a + b;
429     assert(c>=a && c>=b);
430     return c;
431   }
432 
433   function assert(bool assertion) private {
434     if (!assertion) throw;
435   }
436 }
437 
438 
439 
440 /**
441  * A token that can increase its supply by another contract.
442  *
443  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
444  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
445  *
446  */
447 contract MintableToken is StandardToken, Ownable {
448 
449   using SafeMathLib for uint;
450 
451   bool public mintingFinished = false;
452 
453   /** List of agents that are allowed to create new tokens */
454   mapping (address => bool) public mintAgents;
455 
456   /**
457    * Create new tokens and allocate them to an address..
458    *
459    * Only callably by a crowdsale contract (mint agent).
460    */
461   function mint(address receiver, uint amount) onlyMintAgent canMint public {
462     totalSupply = totalSupply.plus(amount);
463     balances[receiver] = balances[receiver].plus(amount);
464     Transfer(0, receiver, amount);
465   }
466 
467   /**
468    * Owner can allow a crowdsale contract to mint new tokens.
469    */
470   function setMintAgent(address addr, bool state) onlyOwner canMint public {
471     mintAgents[addr] = state;
472   }
473 
474   modifier onlyMintAgent() {
475     // Only crowdsale contracts are allowed to mint new tokens
476     if(!mintAgents[msg.sender]) {
477         throw;
478     }
479     _;
480   }
481 
482   /** Make sure we are not done yet. */
483   modifier canMint() {
484     if(mintingFinished) throw;
485     _;
486   }
487 }
488 
489 
490 
491 
492 /**
493  * A crowdsaled token.
494  *
495  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
496  *
497  * - The token transfer() is disabled until the crowdsale is over
498  * - The token contract gives an opt-in upgrade path to a new contract
499  * - The same token can be part of several crowdsales through approve() mechanism
500  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
501  *
502  */
503 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
504 
505   string public name;
506 
507   string public symbol;
508 
509   uint public decimals;
510 
511   /**
512    * Construct the token.
513    *
514    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
515    */
516   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
517     UpgradeableToken(msg.sender) {
518 
519     // Create any address, can be transferred
520     // to team multisig via changeOwner(),
521     // also remember to call setUpgradeMaster()
522     owner = msg.sender;
523 
524     name = _name;
525     symbol = _symbol;
526 
527     totalSupply = _initialSupply;
528 
529     decimals = _decimals;
530 
531     // Create initially all balance on the team multisig
532     balances[owner] = totalSupply;
533   }
534 
535   /**
536    * When token is released to be transferable, enforce no new tokens can be created.
537    */
538   function releaseTokenTransfer() public onlyReleaseAgent {
539     mintingFinished = true;
540     super.releaseTokenTransfer();
541   }
542 
543   /**
544    * Allow upgrade agent functionality kick in only if the crowdsale was success.
545    */
546   function canUpgrade() public constant returns(bool) {
547     return released;
548   }
549 
550 }