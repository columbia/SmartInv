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
94   /**
95    *
96    * Fix for the ERC20 short address attack
97    *
98    * http://vessenes.com/the-erc20-short-address-attack-explained/
99    */
100   modifier onlyPayloadSize(uint size) {
101      if(msg.data.length < size + 4) {
102        throw;
103      }
104      _;
105   }
106 
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
108     balances[msg.sender] = safeSub(balances[msg.sender], _value);
109     balances[_to] = safeAdd(balances[_to], _value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
115     uint _allowance = allowed[_from][msg.sender];
116 
117     balances[_to] = safeAdd(balances[_to], _value);
118     balances[_from] = safeSub(balances[_from], _value);
119     allowed[_from][msg.sender] = safeSub(_allowance, _value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   function balanceOf(address _owner) constant returns (uint balance) {
125     return balances[_owner];
126   }
127 
128   function approve(address _spender, uint _value) returns (bool success) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     //  allowance to zero by calling `approve(_spender, 0)` if it is not
132     //  already 0 to mitigate the race condition described here:
133     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   function allowance(address _owner, address _spender) constant returns (uint remaining) {
142     return allowed[_owner][_spender];
143   }
144 
145 }
146 
147 
148 
149 
150 
151 /**
152  * Upgrade agent interface inspired by Lunyr.
153  *
154  * Upgrade agent transfers tokens to a new contract.
155  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
156  */
157 contract UpgradeAgent {
158 
159   uint public originalSupply;
160 
161   /** Interface marker */
162   function isUpgradeAgent() public constant returns (bool) {
163     return true;
164   }
165 
166   function upgradeFrom(address _from, uint256 _value) public;
167 
168 }
169 
170 
171 /**
172  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
173  *
174  * First envisioned by Golem and Lunyr projects.
175  */
176 contract UpgradeableToken is StandardToken {
177 
178   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
179   address public upgradeMaster;
180 
181   /** The next contract where the tokens will be migrated. */
182   UpgradeAgent public upgradeAgent;
183 
184   /** How many tokens we have upgraded by now. */
185   uint256 public totalUpgraded;
186 
187   /**
188    * Upgrade states.
189    *
190    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
191    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
192    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
193    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
194    *
195    */
196   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
197 
198   /**
199    * Somebody has upgraded some of his tokens.
200    */
201   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
202 
203   /**
204    * New upgrade agent available.
205    */
206   event UpgradeAgentSet(address agent);
207 
208   /**
209    * Do not allow construction without upgrade master set.
210    */
211   function UpgradeableToken(address _upgradeMaster) {
212     upgradeMaster = _upgradeMaster;
213   }
214 
215   /**
216    * Allow the token holder to upgrade some of their tokens to a new contract.
217    */
218   function upgrade(uint256 value) public {
219 
220       UpgradeState state = getUpgradeState();
221       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
222         // Called in a bad state
223         throw;
224       }
225 
226       // Validate input value.
227       if (value == 0) throw;
228 
229       balances[msg.sender] = safeSub(balances[msg.sender], value);
230 
231       // Take tokens out from circulation
232       totalSupply = safeSub(totalSupply, value);
233       totalUpgraded = safeAdd(totalUpgraded, value);
234 
235       // Upgrade agent reissues the tokens
236       upgradeAgent.upgradeFrom(msg.sender, value);
237       Upgrade(msg.sender, upgradeAgent, value);
238   }
239 
240   /**
241    * Set an upgrade agent that handles
242    */
243   function setUpgradeAgent(address agent) external {
244 
245       if(!canUpgrade()) {
246         // The token is not yet in a state that we could think upgrading
247         throw;
248       }
249 
250       if (agent == 0x0) throw;
251       // Only a master can designate the next agent
252       if (msg.sender != upgradeMaster) throw;
253       // Upgrade has already begun for an agent
254       if (getUpgradeState() == UpgradeState.Upgrading) throw;
255 
256       upgradeAgent = UpgradeAgent(agent);
257 
258       // Bad interface
259       if(!upgradeAgent.isUpgradeAgent()) throw;
260       // Make sure that token supplies match in source and target
261       if (upgradeAgent.originalSupply() != totalSupply) throw;
262 
263       UpgradeAgentSet(upgradeAgent);
264   }
265 
266   /**
267    * Get the state of the token upgrade.
268    */
269   function getUpgradeState() public constant returns(UpgradeState) {
270     if(!canUpgrade()) return UpgradeState.NotAllowed;
271     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
272     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
273     else return UpgradeState.Upgrading;
274   }
275 
276   /**
277    * Change the upgrade master.
278    *
279    * This allows us to set a new owner for the upgrade mechanism.
280    */
281   function setUpgradeMaster(address master) public {
282       if (master == 0x0) throw;
283       if (msg.sender != upgradeMaster) throw;
284       upgradeMaster = master;
285   }
286 
287   /**
288    * Child contract can enable to provide the condition when the upgrade can begun.
289    */
290   function canUpgrade() public constant returns(bool) {
291      return true;
292   }
293 
294 }
295 
296 
297 
298 
299 /*
300  * Ownable
301  *
302  * Base contract with an owner.
303  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
304  */
305 contract Ownable {
306   address public owner;
307 
308   function Ownable() {
309     owner = msg.sender;
310   }
311 
312   modifier onlyOwner() {
313     if (msg.sender != owner) {
314       throw;
315     }
316     _;
317   }
318 
319   function transferOwnership(address newOwner) onlyOwner {
320     if (newOwner != address(0)) {
321       owner = newOwner;
322     }
323   }
324 
325 }
326 
327 
328 
329 
330 /**
331  * Define interface for releasing the token transfer after a successful crowdsale.
332  */
333 contract ReleasableToken is ERC20, Ownable {
334 
335   /* The finalizer contract that allows unlift the transfer limits on this token */
336   address public releaseAgent;
337 
338   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
339   bool public released = false;
340 
341   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
342   mapping (address => bool) public transferAgents;
343 
344   /**
345    * Limit token transfer until the crowdsale is over.
346    *
347    */
348   modifier canTransfer(address _sender) {
349 
350     if(!released) {
351         if(!transferAgents[_sender]) {
352             throw;
353         }
354     }
355 
356     _;
357   }
358 
359   /**
360    * Set the contract that can call release and make the token transferable.
361    *
362    * Design choice. Allow reset the release agent to fix fat finger mistakes.
363    */
364   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
365 
366     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
367     releaseAgent = addr;
368   }
369 
370   /**
371    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
372    */
373   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
374     transferAgents[addr] = state;
375   }
376 
377   /**
378    * One way function to release the tokens to the wild.
379    *
380    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
381    */
382   function releaseTokenTransfer() public onlyReleaseAgent {
383     released = true;
384   }
385 
386   /** The function can be called only before or after the tokens have been releasesd */
387   modifier inReleaseState(bool releaseState) {
388     if(releaseState != released) {
389         throw;
390     }
391     _;
392   }
393 
394   /** The function can be called only by a whitelisted release agent. */
395   modifier onlyReleaseAgent() {
396     if(msg.sender != releaseAgent) {
397         throw;
398     }
399     _;
400   }
401 
402   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
403     // Call StandardToken.transfer()
404    return super.transfer(_to, _value);
405   }
406 
407   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
408     // Call StandardToken.transferForm()
409     return super.transferFrom(_from, _to, _value);
410   }
411 
412 }
413 
414 
415 
416 
417 
418 /**
419  * Safe unsigned safe math.
420  *
421  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
422  *
423  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
424  *
425  * Maintained here until merged to mainline zeppelin-solidity.
426  *
427  */
428 library SafeMathLib {
429 
430   function times(uint a, uint b) returns (uint) {
431     uint c = a * b;
432     assert(a == 0 || c / a == b);
433     return c;
434   }
435 
436   function minus(uint a, uint b) returns (uint) {
437     assert(b <= a);
438     return a - b;
439   }
440 
441   function plus(uint a, uint b) returns (uint) {
442     uint c = a + b;
443     assert(c>=a);
444     return c;
445   }
446 
447   function assert(bool assertion) private {
448     if (!assertion) throw;
449   }
450 }
451 
452 
453 
454 /**
455  * A token that can increase its supply by another contract.
456  *
457  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
458  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
459  *
460  */
461 contract MintableToken is StandardToken, Ownable {
462 
463   using SafeMathLib for uint;
464 
465   bool public mintingFinished = false;
466 
467   /** List of agents that are allowed to create new tokens */
468   mapping (address => bool) public mintAgents;
469 
470   event MintingAgentChanged(address addr, bool state  );
471 
472   /**
473    * Create new tokens and allocate them to an address..
474    *
475    * Only callably by a crowdsale contract (mint agent).
476    */
477   function mint(address receiver, uint amount) onlyMintAgent canMint public {
478     totalSupply = totalSupply.plus(amount);
479     balances[receiver] = balances[receiver].plus(amount);
480 
481     // This will make the mint transaction apper in EtherScan.io
482     // We can remove this after there is a standardized minting event
483     Transfer(0, receiver, amount);
484   }
485 
486   /**
487    * Owner can allow a crowdsale contract to mint new tokens.
488    */
489   function setMintAgent(address addr, bool state) onlyOwner canMint public {
490     mintAgents[addr] = state;
491     MintingAgentChanged(addr, state);
492   }
493 
494   modifier onlyMintAgent() {
495     // Only crowdsale contracts are allowed to mint new tokens
496     if(!mintAgents[msg.sender]) {
497         throw;
498     }
499     _;
500   }
501 
502   /** Make sure we are not done yet. */
503   modifier canMint() {
504     if(mintingFinished) throw;
505     _;
506   }
507 }
508 
509 
510 
511 /**
512  * A crowdsaled token.
513  *
514  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
515  *
516  * - The token transfer() is disabled until the crowdsale is over
517  * - The token contract gives an opt-in upgrade path to a new contract
518  * - The same token can be part of several crowdsales through approve() mechanism
519  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
520  *
521  */
522 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
523 
524   event UpdatedTokenInformation(string newName, string newSymbol);
525 
526   string public name;
527 
528   string public symbol;
529 
530   uint public decimals;
531 
532   /**
533    * Construct the token.
534    *
535    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
536    *
537    * @param _name Token name
538    * @param _symbol Token symbol - should be all caps
539    * @param _initialSupply How many tokens we start with
540    * @param _decimals Number of decimal places
541    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
542    */
543   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
544     UpgradeableToken(msg.sender) {
545 
546     // Create any address, can be transferred
547     // to team multisig via changeOwner(),
548     // also remember to call setUpgradeMaster()
549     owner = msg.sender;
550 
551     name = _name;
552     symbol = _symbol;
553 
554     totalSupply = _initialSupply;
555 
556     decimals = _decimals;
557 
558     // Create initially all balance on the team multisig
559     balances[owner] = totalSupply;
560 
561     if(totalSupply > 0) {
562       Minted(owner, totalSupply);
563     }
564 
565     // No more new supply allowed after the token creation
566     if(!_mintable) {
567       mintingFinished = true;
568       if(totalSupply == 0) {
569         throw; // Cannot create a token without supply and no minting
570       }
571     }
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
586     return released && super.canUpgrade();
587   }
588 
589   /**
590    * Owner can update token information here
591    */
592   function setTokenInformation(string _name, string _symbol) onlyOwner {
593     name = _name;
594     symbol = _symbol;
595 
596     UpdatedTokenInformation(name, symbol);
597   }
598 
599 }