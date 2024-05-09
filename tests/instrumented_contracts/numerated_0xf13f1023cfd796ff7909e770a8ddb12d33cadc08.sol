1 pragma solidity ^0.4.6;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) constant returns (uint);
10   function allowance(address owner, address spender) constant returns (uint);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transferFrom(address from, address to, uint value) returns (bool ok);
14   function approve(address spender, uint value) returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
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
134 /**
135  * Upgrade agent interface inspired by Lunyr.
136  *
137  * Upgrade agent transfers tokens to a new contract.
138  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
139  */
140 contract UpgradeAgent {
141 
142   uint public originalSupply;
143 
144   /** Interface marker */
145   function isUpgradeAgent() public constant returns (bool) {
146     return true;
147   }
148 
149   function upgradeFrom(address _from, uint256 _value) public;
150 
151 }
152 
153 /**
154  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
155  *
156  * First envisioned by Golem and Lunyr projects.
157  */
158 contract UpgradeableToken is StandardToken {
159 
160   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
161   address public upgradeMaster;
162 
163   /** The next contract where the tokens will be migrated. */
164   UpgradeAgent public upgradeAgent;
165 
166   /** How many tokens we have upgraded by now. */
167   uint256 public totalUpgraded;
168 
169   /**
170    * Upgrade states.
171    *
172    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
173    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
174    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
175    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
176    *
177    */
178   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
179 
180   /**
181    * Somebody has upgraded some of his tokens.
182    */
183   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
184 
185   /**
186    * New upgrade agent available.
187    */
188   event UpgradeAgentSet(address agent);
189 
190   /**
191    * Do not allow construction without upgrade master set.
192    */
193   function UpgradeableToken(address _upgradeMaster) {
194     upgradeMaster = _upgradeMaster;
195   }
196 
197   /**
198    * Allow the token holder to upgrade some of their tokens to a new contract.
199    */
200   function upgrade(uint256 value) public {
201 
202       UpgradeState state = getUpgradeState();
203       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
204         // Called in a bad state
205         throw;
206       }
207 
208       // Validate input value.
209       if (value == 0) throw;
210 
211       balances[msg.sender] = safeSub(balances[msg.sender], value);
212 
213       // Take tokens out from circulation
214       totalSupply = safeSub(totalSupply, value);
215       totalUpgraded = safeAdd(totalUpgraded, value);
216 
217       // Upgrade agent reissues the tokens
218       upgradeAgent.upgradeFrom(msg.sender, value);
219       Upgrade(msg.sender, upgradeAgent, value);
220   }
221 
222   /**
223    * Set an upgrade agent that handles
224    */
225   function setUpgradeAgent(address agent) external {
226 
227       if(!canUpgrade()) {
228         // The token is not yet in a state that we could think upgrading
229         throw;
230       }
231 
232       if (agent == 0x0) throw;
233       // Only a master can designate the next agent
234       if (msg.sender != upgradeMaster) throw;
235       // Upgrade has already begun for an agent
236       if (getUpgradeState() == UpgradeState.Upgrading) throw;
237 
238       upgradeAgent = UpgradeAgent(agent);
239 
240       // Bad interface
241       if(!upgradeAgent.isUpgradeAgent()) throw;
242       // Make sure that token supplies match in source and target
243       if (upgradeAgent.originalSupply() != totalSupply) throw;
244 
245       UpgradeAgentSet(upgradeAgent);
246   }
247 
248   /**
249    * Get the state of the token upgrade.
250    */
251   function getUpgradeState() public constant returns(UpgradeState) {
252     if(!canUpgrade()) return UpgradeState.NotAllowed;
253     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
254     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
255     else return UpgradeState.Upgrading;
256   }
257 
258   /**
259    * Change the upgrade master.
260    *
261    * This allows us to set a new owner for the upgrade mechanism.
262    */
263   function setUpgradeMaster(address master) public {
264       if (master == 0x0) throw;
265       if (msg.sender != upgradeMaster) throw;
266       upgradeMaster = master;
267   }
268 
269   /**
270    * Child contract can enable to provide the condition when the upgrade can begun.
271    */
272   function canUpgrade() public constant returns(bool) {
273      return true;
274   }
275 
276 }
277 
278 /*
279  * Ownable
280  *
281  * Base contract with an owner.
282  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
283  */
284 contract Ownable {
285   address public owner;
286 
287   function Ownable() {
288     owner = msg.sender;
289   }
290 
291   modifier onlyOwner() {
292     if (msg.sender != owner) {
293       throw;
294     }
295     _;
296   }
297 
298   function transferOwnership(address newOwner) onlyOwner {
299     if (newOwner != address(0)) {
300       owner = newOwner;
301     }
302   }
303 
304 }
305 
306 /**
307  * Define interface for releasing the token transfer after a successful crowdsale.
308  */
309 contract ReleasableToken is ERC20, Ownable {
310 
311   /* The finalizer contract that allows unlift the transfer limits on this token */
312   address public releaseAgent;
313 
314   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
315   bool public released = false;
316 
317   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
318   mapping (address => bool) public transferAgents;
319 
320   /**
321    * Limit token transfer until the crowdsale is over.
322    *
323    */
324   modifier canTransfer(address _sender) {
325 
326     if(!released) {
327         if(!transferAgents[_sender]) {
328             throw;
329         }
330     }
331 
332     _;
333   }
334 
335   /**
336    * Set the contract that can call release and make the token transferable.
337    *
338    * Design choice. Allow reset the release agent to fix fat finger mistakes.
339    */
340   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
341 
342     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
343     releaseAgent = addr;
344   }
345 
346   /**
347    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
348    */
349   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
350     transferAgents[addr] = state;
351   }
352 
353   /**
354    * One way function to release the tokens to the wild.
355    *
356    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
357    */
358   function releaseTokenTransfer() public onlyReleaseAgent {
359     released = true;
360   }
361 
362   /** The function can be called only before or after the tokens have been releasesd */
363   modifier inReleaseState(bool releaseState) {
364     if(releaseState != released) {
365         throw;
366     }
367     _;
368   }
369 
370   /** The function can be called only by a whitelisted release agent. */
371   modifier onlyReleaseAgent() {
372     if(msg.sender != releaseAgent) {
373         throw;
374     }
375     _;
376   }
377 
378   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
379     // Call StandardToken.transfer()
380    return super.transfer(_to, _value);
381   }
382 
383   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
384     // Call StandardToken.transferForm()
385     return super.transferFrom(_from, _to, _value);
386   }
387 
388 }
389 
390 /**
391  * A token that can increase its supply by another contract.
392  *
393  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
394  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
395  *
396  */
397 contract MintableToken is StandardToken, Ownable {
398 
399 
400   bool public mintingFinished = false;
401 
402   /** List of agents that are allowed to create new tokens */
403   mapping (address => bool) public mintAgents;
404 
405   event MintingAgentChanged(address addr, bool state  );
406 
407   /**
408    * Create new tokens and allocate them to an address..
409    *
410    * Only callably by a crowdsale contract (mint agent).
411    */
412   function mint(address receiver, uint amount) onlyMintAgent canMint public {
413     totalSupply = safeAdd(totalSupply, amount);
414     balances[receiver] = safeAdd(balances[receiver], amount);
415 
416     // This will make the mint transaction appear in EtherScan.io
417     // We can remove this after there is a standardized minting event
418     Transfer(0, receiver, amount);
419   }
420 
421   /**
422    * Owner can allow a crowdsale contract to mint new tokens.
423    */
424   function setMintAgent(address addr, bool state) onlyOwner canMint public {
425     mintAgents[addr] = state;
426     MintingAgentChanged(addr, state);
427   }
428 
429   modifier onlyMintAgent() {
430     // Only crowdsale contracts are allowed to mint new tokens
431     if(!mintAgents[msg.sender]) {
432         throw;
433     }
434     _;
435   }
436 
437   /** Make sure we are not done yet. */
438   modifier canMint() {
439     if(mintingFinished) throw;
440     _;
441   }
442 }
443 
444 /**
445  * A token that can be revoked before then end of the crowdsale.
446  */
447 contract WWAMBountyToken is StandardToken, Ownable {
448 
449   /** List of agents that are allowed to revoke tokens */
450   mapping (address => bool) public bountyAgents;
451   
452   event BountyAgentChanged(address addr, bool state  );
453   
454   /*
455   * Function to revoke tokens in case the terms and conditions of the bounty campaign are violated by an user after tokens were assigned
456   */
457   function revokeTokens(address receiver, uint tokenAmount) onlyBountyAgent {
458       if (balances[receiver] >= tokenAmount) {
459 	    totalSupply = safeSub(totalSupply, tokenAmount);
460 	    balances[receiver] = safeSub(balances[receiver], tokenAmount);
461       }
462   }
463   
464    /**
465    * Owner can allow a crowdsale contract to revoke tokens.
466    */
467   function setBountyAgent(address addr, bool state) onlyOwner public {
468     bountyAgents[addr] = state;
469     BountyAgentChanged(addr, state);
470   }
471   
472   modifier onlyBountyAgent() {
473     // Only crowdsale contracts are allowed to revoke tokens
474     if(!bountyAgents[msg.sender]) {
475         throw;
476     }
477     _;
478   }
479   
480 }
481 
482 
483 
484 /**
485  * A crowdsaled token.
486  *
487  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
488  *
489  * - The token transfer() is disabled until the crowdsale is over
490  * - The token contract gives an opt-in upgrade path to a new contract
491  * - The same token can be part of several crowdsales through approve() mechanism
492  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
493  *
494  */
495 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, WWAMBountyToken {
496 
497   event UpdatedTokenInformation(string newName, string newSymbol);
498 
499   string public name;
500 
501   string public symbol;
502 
503   uint public decimals;
504 
505   /**
506    * Construct the token.
507    *
508    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
509    */
510   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals)
511     UpgradeableToken(msg.sender) {
512 
513     // Create any address, can be transferred
514     // to team multisig via changeOwner(),
515     // also remember to call setUpgradeMaster()
516     owner = msg.sender;
517 
518     name = _name;
519     symbol = _symbol;
520 
521     totalSupply = _initialSupply;
522 
523     decimals = _decimals;
524 
525     // Create initially all balance on the team multisig
526     balances[owner] = totalSupply;
527   }
528 
529   /**
530    * When token is released to be transferable, enforce no new tokens can be created.
531    */
532   function releaseTokenTransfer() public onlyReleaseAgent {
533     mintingFinished = true;
534     super.releaseTokenTransfer();
535   }
536 
537   /**
538    * Allow upgrade agent functionality kick in only if the crowdsale was success.
539    */
540   function canUpgrade() public constant returns(bool) {
541     return released;
542   }
543 
544   /**
545    * Owner can update token information here
546    */
547   function setTokenInformation(string _name, string _symbol) onlyOwner {
548     name = _name;
549     symbol = _symbol;
550 
551     UpdatedTokenInformation(name, symbol);
552   }
553 
554 }