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
90      if(msg.data.length != size + 4) {
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
103   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
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
137   /**
138    * Atomic increment of approved spending
139    *
140    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    *
142    */
143   function addApproval(address _spender, uint _addedValue)
144   onlyPayloadSize(2 * 32)
145   returns (bool success) {
146       uint oldValue = allowed[msg.sender][_spender];
147       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
148       return true;
149   }
150 
151   /**
152    * Atomic decrement of approved spending.
153    *
154    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    */
156   function subApproval(address _spender, uint _subtractedValue)
157   onlyPayloadSize(2 * 32)
158   returns (bool success) {
159 
160       uint oldVal = allowed[msg.sender][_spender];
161 
162       if (_subtractedValue > oldVal) {
163           allowed[msg.sender][_spender] = 0;
164       } else {
165           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
166       }
167       return true;
168   }
169 
170 }
171 
172 
173 
174 
175 
176 /**
177  * Upgrade agent interface inspired by Lunyr.
178  *
179  * Upgrade agent transfers tokens to a new contract.
180  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
181  */
182 contract UpgradeAgent {
183 
184   uint public originalSupply;
185 
186   /** Interface marker */
187   function isUpgradeAgent() public constant returns (bool) {
188     return true;
189   }
190 
191   function upgradeFrom(address _from, uint256 _value) public;
192 
193 }
194 
195 
196 /**
197  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
198  *
199  * First envisioned by Golem and Lunyr projects.
200  */
201 contract UpgradeableToken is StandardToken {
202 
203   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
204   address public upgradeMaster;
205 
206   /** The next contract where the tokens will be migrated. */
207   UpgradeAgent public upgradeAgent;
208 
209   /** How many tokens we have upgraded by now. */
210   uint256 public totalUpgraded;
211 
212   /**
213    * Upgrade states.
214    *
215    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
216    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
217    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
218    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
219    *
220    */
221   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
222 
223   /**
224    * Somebody has upgraded some of his tokens.
225    */
226   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
227 
228   /**
229    * New upgrade agent available.
230    */
231   event UpgradeAgentSet(address agent);
232 
233   /**
234    * Do not allow construction without upgrade master set.
235    */
236   function UpgradeableToken(address _upgradeMaster) {
237     upgradeMaster = _upgradeMaster;
238   }
239 
240   /**
241    * Allow the token holder to upgrade some of their tokens to a new contract.
242    */
243   function upgrade(uint256 value) public {
244 
245       UpgradeState state = getUpgradeState();
246       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
247         // Called in a bad state
248         throw;
249       }
250 
251       // Validate input value.
252       if (value == 0) throw;
253 
254       balances[msg.sender] = safeSub(balances[msg.sender], value);
255 
256       // Take tokens out from circulation
257       totalSupply = safeSub(totalSupply, value);
258       totalUpgraded = safeAdd(totalUpgraded, value);
259 
260       // Upgrade agent reissues the tokens
261       upgradeAgent.upgradeFrom(msg.sender, value);
262       Upgrade(msg.sender, upgradeAgent, value);
263   }
264 
265   /**
266    * Set an upgrade agent that handles
267    */
268   function setUpgradeAgent(address agent) external {
269 
270       if(!canUpgrade()) {
271         // The token is not yet in a state that we could think upgrading
272         throw;
273       }
274 
275       if (agent == 0x0) throw;
276       // Only a master can designate the next agent
277       if (msg.sender != upgradeMaster) throw;
278       // Upgrade has already begun for an agent
279       if (getUpgradeState() == UpgradeState.Upgrading) throw;
280 
281       upgradeAgent = UpgradeAgent(agent);
282 
283       // Bad interface
284       if(!upgradeAgent.isUpgradeAgent()) throw;
285       // Make sure that token supplies match in source and target
286       if (upgradeAgent.originalSupply() != totalSupply) throw;
287 
288       UpgradeAgentSet(upgradeAgent);
289   }
290 
291   /**
292    * Get the state of the token upgrade.
293    */
294   function getUpgradeState() public constant returns(UpgradeState) {
295     if(!canUpgrade()) return UpgradeState.NotAllowed;
296     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
297     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
298     else return UpgradeState.Upgrading;
299   }
300 
301   /**
302    * Change the upgrade master.
303    *
304    * This allows us to set a new owner for the upgrade mechanism.
305    */
306   function setUpgradeMaster(address master) public {
307       if (master == 0x0) throw;
308       if (msg.sender != upgradeMaster) throw;
309       upgradeMaster = master;
310   }
311 
312   /**
313    * Child contract can enable to provide the condition when the upgrade can begun.
314    */
315   function canUpgrade() public constant returns(bool) {
316      return true;
317   }
318 
319 }
320 
321 
322 
323 
324 /*
325  * Ownable
326  *
327  * Base contract with an owner.
328  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
329  */
330 contract Ownable {
331   address public owner;
332 
333   function Ownable() {
334     owner = msg.sender;
335   }
336 
337   modifier onlyOwner() {
338     if (msg.sender != owner) {
339       throw;
340     }
341     _;
342   }
343 
344   function transferOwnership(address newOwner) onlyOwner {
345     if (newOwner != address(0)) {
346       owner = newOwner;
347     }
348   }
349 
350 }
351 
352 
353 
354 
355 /**
356  * Define interface for releasing the token transfer after a successful crowdsale.
357  */
358 contract ReleasableToken is ERC20, Ownable {
359 
360   /* The finalizer contract that allows unlift the transfer limits on this token */
361   address public releaseAgent;
362 
363   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
364   bool public released = false;
365 
366   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
367   mapping (address => bool) public transferAgents;
368 
369   /**
370    * Limit token transfer until the crowdsale is over.
371    *
372    */
373   modifier canTransfer(address _sender) {
374 
375     if(!released) {
376         if(!transferAgents[_sender]) {
377             throw;
378         }
379     }
380 
381     _;
382   }
383 
384   /**
385    * Set the contract that can call release and make the token transferable.
386    *
387    * Design choice. Allow reset the release agent to fix fat finger mistakes.
388    */
389   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
390 
391     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
392     releaseAgent = addr;
393   }
394 
395   /**
396    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
397    */
398   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
399     transferAgents[addr] = state;
400   }
401 
402   /**
403    * One way function to release the tokens to the wild.
404    *
405    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
406    */
407   function releaseTokenTransfer() public onlyReleaseAgent {
408     released = true;
409   }
410 
411   /** The function can be called only before or after the tokens have been releasesd */
412   modifier inReleaseState(bool releaseState) {
413     if(releaseState != released) {
414         throw;
415     }
416     _;
417   }
418 
419   /** The function can be called only by a whitelisted release agent. */
420   modifier onlyReleaseAgent() {
421     if(msg.sender != releaseAgent) {
422         throw;
423     }
424     _;
425   }
426 
427   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
428     // Call StandardToken.transfer()
429    return super.transfer(_to, _value);
430   }
431 
432   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
433     // Call StandardToken.transferForm()
434     return super.transferFrom(_from, _to, _value);
435   }
436 
437 }
438 
439 
440 
441 
442 
443 /**
444  * Safe unsigned safe math.
445  *
446  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
447  *
448  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
449  *
450  * Maintained here until merged to mainline zeppelin-solidity.
451  *
452  */
453 library SafeMathLib {
454 
455   function times(uint a, uint b) returns (uint) {
456     uint c = a * b;
457     assert(a == 0 || c / a == b);
458     return c;
459   }
460 
461   function minus(uint a, uint b) returns (uint) {
462     assert(b <= a);
463     return a - b;
464   }
465 
466   function plus(uint a, uint b) returns (uint) {
467     uint c = a + b;
468     assert(c>=a && c>=b);
469     return c;
470   }
471 
472   function assert(bool assertion) private {
473     if (!assertion) throw;
474   }
475 }
476 
477 
478 
479 /**
480  * A token that can increase its supply by another contract.
481  *
482  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
483  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
484  *
485  */
486 contract MintableToken is StandardToken, Ownable {
487 
488   using SafeMathLib for uint;
489 
490   bool public mintingFinished = false;
491 
492   /** List of agents that are allowed to create new tokens */
493   mapping (address => bool) public mintAgents;
494 
495   /**
496    * Create new tokens and allocate them to an address..
497    *
498    * Only callably by a crowdsale contract (mint agent).
499    */
500   function mint(address receiver, uint amount) onlyMintAgent canMint public {
501     totalSupply = totalSupply.plus(amount);
502     balances[receiver] = balances[receiver].plus(amount);
503     Transfer(0, receiver, amount);
504   }
505 
506   /**
507    * Owner can allow a crowdsale contract to mint new tokens.
508    */
509   function setMintAgent(address addr, bool state) onlyOwner canMint public {
510     mintAgents[addr] = state;
511   }
512 
513   modifier onlyMintAgent() {
514     // Only crowdsale contracts are allowed to mint new tokens
515     if(!mintAgents[msg.sender]) {
516         throw;
517     }
518     _;
519   }
520 
521   /** Make sure we are not done yet. */
522   modifier canMint() {
523     if(mintingFinished) throw;
524     _;
525   }
526 }
527 
528 
529 
530 
531 /**
532  * A crowdsaled token.
533  *
534  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
535  *
536  * - The token transfer() is disabled until the crowdsale is over
537  * - The token contract gives an opt-in upgrade path to a new contract
538  * - The same token can be part of several crowdsales through approve() mechanism
539  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
540  *
541  */
542 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
543 
544   string public name;
545 
546   string public symbol;
547 
548   uint public decimals;
549 
550   /**
551    * Construct the token.
552    *
553    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
554    */
555   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
556     UpgradeableToken(msg.sender) {
557 
558     // Create any address, can be transferred
559     // to team multisig via changeOwner(),
560     // also remember to call setUpgradeMaster()
561     owner = msg.sender;
562 
563     name = _name;
564     symbol = _symbol;
565 
566     totalSupply = _initialSupply;
567 
568     decimals = _decimals;
569 
570     // Create initially all balance on the team multisig
571     balances[owner] = totalSupply;
572   }
573 
574   /**
575    * When token is released to be transferable, enforce no new tokens can be created.
576    */
577   function releaseTokenTransfer() public onlyReleaseAgent {
578     mintingFinished = true;
579     super.releaseTokenTransfer();
580   }
581 
582   /**
583    * Allow upgrade agent functionality kick in only if the crowdsale was success.
584    */
585   function canUpgrade() public constant returns(bool) {
586     return released;
587   }
588 
589 }