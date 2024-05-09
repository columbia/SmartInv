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
80   mapping(address => uint) balances;
81   mapping (address => mapping (address => uint)) allowed;
82 
83   /**
84    *
85    * Fix for the ERC20 short address attack
86    *
87    * http://vessenes.com/the-erc20-short-address-attack-explained/
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length < size + 4) {
91        throw;
92      }
93      _;
94   }
95 
96   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
97     balances[msg.sender] = safeSub(balances[msg.sender], _value);
98     balances[_to] = safeAdd(balances[_to], _value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
104     var _allowance = allowed[_from][msg.sender];
105 
106     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
107     // if (_value > _allowance) throw;
108 
109     balances[_to] = safeAdd(balances[_to], _value);
110     balances[_from] = safeSub(balances[_from], _value);
111     allowed[_from][msg.sender] = safeSub(_allowance, _value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   function balanceOf(address _owner) constant returns (uint balance) {
117     return balances[_owner];
118   }
119 
120   function approve(address _spender, uint _value) returns (bool success) {
121 
122     // To change the approve amount you first have to reduce the addresses`
123     //  allowance to zero by calling `approve(_spender, 0)` if it is not
124     //  already 0 to mitigate the race condition described here:
125     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
127 
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   function allowance(address _owner, address _spender) constant returns (uint remaining) {
134     return allowed[_owner][_spender];
135   }
136 
137 }
138 
139 
140 
141 
142 
143 /**
144  * Upgrade agent interface inspired by Lunyr.
145  *
146  * Upgrade agent transfers tokens to a new contract.
147  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
148  */
149 contract UpgradeAgent {
150 
151   uint public originalSupply;
152 
153   /** Interface marker */
154   function isUpgradeAgent() public constant returns (bool) {
155     return true;
156   }
157 
158   function upgradeFrom(address _from, uint256 _value) public;
159 
160 }
161 
162 
163 /**
164  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
165  *
166  * First envisioned by Golem and Lunyr projects.
167  */
168 contract UpgradeableToken is StandardToken {
169 
170   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
171   address public upgradeMaster;
172 
173   /** The next contract where the tokens will be migrated. */
174   UpgradeAgent public upgradeAgent;
175 
176   /** How many tokens we have upgraded by now. */
177   uint256 public totalUpgraded;
178 
179   /**
180    * Upgrade states.
181    *
182    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
183    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
184    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
185    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
186    *
187    */
188   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
189 
190   /**
191    * Somebody has upgraded some of his tokens.
192    */
193   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
194 
195   /**
196    * New upgrade agent available.
197    */
198   event UpgradeAgentSet(address agent);
199 
200   /**
201    * Do not allow construction without upgrade master set.
202    */
203   function UpgradeableToken(address _upgradeMaster) {
204     upgradeMaster = _upgradeMaster;
205   }
206 
207   /**
208    * Allow the token holder to upgrade some of their tokens to a new contract.
209    */
210   function upgrade(uint256 value) public {
211 
212       UpgradeState state = getUpgradeState();
213       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
214         // Called in a bad state
215         throw;
216       }
217 
218       // Validate input value.
219       if (value == 0) throw;
220 
221       balances[msg.sender] = safeSub(balances[msg.sender], value);
222 
223       // Take tokens out from circulation
224       totalSupply = safeSub(totalSupply, value);
225       totalUpgraded = safeAdd(totalUpgraded, value);
226 
227       // Upgrade agent reissues the tokens
228       upgradeAgent.upgradeFrom(msg.sender, value);
229       Upgrade(msg.sender, upgradeAgent, value);
230   }
231 
232   /**
233    * Set an upgrade agent that handles
234    */
235   function setUpgradeAgent(address agent) external {
236 
237       if(!canUpgrade()) {
238         // The token is not yet in a state that we could think upgrading
239         throw;
240       }
241 
242       if (agent == 0x0) throw;
243       // Only a master can designate the next agent
244       if (msg.sender != upgradeMaster) throw;
245       // Upgrade has already begun for an agent
246       if (getUpgradeState() == UpgradeState.Upgrading) throw;
247 
248       upgradeAgent = UpgradeAgent(agent);
249 
250       // Bad interface
251       if(!upgradeAgent.isUpgradeAgent()) throw;
252       // Make sure that token supplies match in source and target
253       if (upgradeAgent.originalSupply() != totalSupply) throw;
254 
255       UpgradeAgentSet(upgradeAgent);
256   }
257 
258   /**
259    * Get the state of the token upgrade.
260    */
261   function getUpgradeState() public constant returns(UpgradeState) {
262     if(!canUpgrade()) return UpgradeState.NotAllowed;
263     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
264     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
265     else return UpgradeState.Upgrading;
266   }
267 
268   /**
269    * Change the upgrade master.
270    *
271    * This allows us to set a new owner for the upgrade mechanism.
272    */
273   function setUpgradeMaster(address master) public {
274       if (master == 0x0) throw;
275       if (msg.sender != upgradeMaster) throw;
276       upgradeMaster = master;
277   }
278 
279   /**
280    * Child contract can enable to provide the condition when the upgrade can begun.
281    */
282   function canUpgrade() public constant returns(bool) {
283      return true;
284   }
285 
286 }
287 
288 
289 
290 
291 /*
292  * Ownable
293  *
294  * Base contract with an owner.
295  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
296  */
297 contract Ownable {
298   address public owner;
299 
300   function Ownable() {
301     owner = msg.sender;
302   }
303 
304   modifier onlyOwner() {
305     if (msg.sender != owner) {
306       throw;
307     }
308     _;
309   }
310 
311   function transferOwnership(address newOwner) onlyOwner {
312     if (newOwner != address(0)) {
313       owner = newOwner;
314     }
315   }
316 
317 }
318 
319 
320 
321 
322 /**
323  * Define interface for releasing the token transfer after a successful crowdsale.
324  */
325 contract ReleasableToken is ERC20, Ownable {
326 
327   /* The finalizer contract that allows unlift the transfer limits on this token */
328   address public releaseAgent;
329 
330   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
331   bool public released = false;
332 
333   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
334   mapping (address => bool) public transferAgents;
335 
336   /**
337    * Limit token transfer until the crowdsale is over.
338    *
339    */
340   modifier canTransfer(address _sender) {
341 
342     if(!released) {
343         if(!transferAgents[_sender]) {
344             throw;
345         }
346     }
347 
348     _;
349   }
350 
351   /**
352    * Set the contract that can call release and make the token transferable.
353    *
354    * Design choice. Allow reset the release agent to fix fat finger mistakes.
355    */
356   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
357 
358     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
359     releaseAgent = addr;
360   }
361 
362   /**
363    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
364    */
365   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
366     transferAgents[addr] = state;
367   }
368 
369   /**
370    * One way function to release the tokens to the wild.
371    *
372    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
373    */
374   function releaseTokenTransfer() public onlyReleaseAgent {
375     released = true;
376   }
377 
378   /** The function can be called only before or after the tokens have been releasesd */
379   modifier inReleaseState(bool releaseState) {
380     if(releaseState != released) {
381         throw;
382     }
383     _;
384   }
385 
386   /** The function can be called only by a whitelisted release agent. */
387   modifier onlyReleaseAgent() {
388     if(msg.sender != releaseAgent) {
389         throw;
390     }
391     _;
392   }
393 
394   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
395     // Call StandardToken.transfer()
396    return super.transfer(_to, _value);
397   }
398 
399   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
400     // Call StandardToken.transferForm()
401     return super.transferFrom(_from, _to, _value);
402   }
403 
404 }
405 
406 
407 
408 
409 
410 /**
411  * Safe unsigned safe math.
412  *
413  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
414  *
415  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
416  *
417  * Maintained here until merged to mainline zeppelin-solidity.
418  *
419  */
420 library SafeMathLib {
421 
422   function times(uint a, uint b) returns (uint) {
423     uint c = a * b;
424     assert(a == 0 || c / a == b);
425     return c;
426   }
427 
428   function minus(uint a, uint b) returns (uint) {
429     assert(b <= a);
430     return a - b;
431   }
432 
433   function plus(uint a, uint b) returns (uint) {
434     uint c = a + b;
435     assert(c>=a && c>=b);
436     return c;
437   }
438 
439   function assert(bool assertion) private {
440     if (!assertion) throw;
441   }
442 }
443 
444 
445 
446 /**
447  * A token that can increase its supply by another contract.
448  *
449  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
450  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
451  *
452  */
453 contract MintableToken is StandardToken, Ownable {
454 
455   using SafeMathLib for uint;
456 
457   bool public mintingFinished = false;
458 
459   /** List of agents that are allowed to create new tokens */
460   mapping (address => bool) public mintAgents;
461 
462   /**
463    * Create new tokens and allocate them to an address..
464    *
465    * Only callably by a crowdsale contract (mint agent).
466    */
467   function mint(address receiver, uint amount) onlyMintAgent canMint public {
468     totalSupply = totalSupply.plus(amount);
469     balances[receiver] = balances[receiver].plus(amount);
470     Transfer(0, receiver, amount);
471   }
472 
473   /**
474    * Owner can allow a crowdsale contract to mint new tokens.
475    */
476   function setMintAgent(address addr, bool state) onlyOwner canMint public {
477     mintAgents[addr] = state;
478   }
479 
480   modifier onlyMintAgent() {
481     // Only crowdsale contracts are allowed to mint new tokens
482     if(!mintAgents[msg.sender]) {
483         throw;
484     }
485     _;
486   }
487 
488   /** Make sure we are not done yet. */
489   modifier canMint() {
490     if(mintingFinished) throw;
491     _;
492   }
493 }
494 
495 
496 
497 
498 /**
499  * A crowdsaled token.
500  *
501  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
502  *
503  * - The token transfer() is disabled until the crowdsale is over
504  * - The token contract gives an opt-in upgrade path to a new contract
505  * - The same token can be part of several crowdsales through approve() mechanism
506  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
507  *
508  */
509 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
510 
511   string public name;
512 
513   string public symbol;
514 
515   uint public decimals;
516 
517   /**
518    * Construct the token.
519    *
520    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
521    */
522   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
523     UpgradeableToken(msg.sender) {
524 
525     // Create any address, can be transferred
526     // to team multisig via changeOwner(),
527     // also remember to call setUpgradeMaster()
528     owner = msg.sender;
529 
530     name = _name;
531     symbol = _symbol;
532 
533     totalSupply = _initialSupply;
534 
535     decimals = _decimals;
536 
537     // Create initially all balance on the team multisig
538     balances[owner] = totalSupply;
539   }
540 
541   /**
542    * When token is released to be transferable, enforce no new tokens can be created.
543    */
544   function releaseTokenTransfer() public onlyReleaseAgent {
545     mintingFinished = true;
546     super.releaseTokenTransfer();
547   }
548 
549   /**
550    * Allow upgrade agent functionality kick in only if the crowdsale was success.
551    */
552   function canUpgrade() public constant returns(bool) {
553     return released;
554   }
555 
556 }