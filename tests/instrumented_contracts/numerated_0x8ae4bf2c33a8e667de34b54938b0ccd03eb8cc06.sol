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
182 
183 
184 /**
185  * Upgrade agent interface inspired by Lunyr.
186  *
187  * Upgrade agent transfers tokens to a new contract.
188  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
189  */
190 contract UpgradeAgent {
191 
192   uint public originalSupply;
193 
194   /** Interface marker */
195   function isUpgradeAgent() public constant returns (bool) {
196     return true;
197   }
198 
199   function upgradeFrom(address _from, uint256 _value) public;
200 
201 }
202 
203 
204 /**
205  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
206  *
207  * First envisioned by Golem and Lunyr projects.
208  */
209 contract UpgradeableToken is StandardToken {
210 
211   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
212   address public upgradeMaster;
213 
214   /** The next contract where the tokens will be migrated. */
215   UpgradeAgent public upgradeAgent;
216 
217   /** How many tokens we have upgraded by now. */
218   uint256 public totalUpgraded;
219 
220   /**
221    * Upgrade states.
222    *
223    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
224    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
225    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
226    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
227    *
228    */
229   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
230 
231   /**
232    * Somebody has upgraded some of his tokens.
233    */
234   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
235 
236   /**
237    * New upgrade agent available.
238    */
239   event UpgradeAgentSet(address agent);
240 
241   /**
242    * Do not allow construction without upgrade master set.
243    */
244   function UpgradeableToken(address _upgradeMaster) {
245     upgradeMaster = _upgradeMaster;
246   }
247 
248   /**
249    * Allow the token holder to upgrade some of their tokens to a new contract.
250    */
251   function upgrade(uint256 value) public {
252 
253       UpgradeState state = getUpgradeState();
254       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
255         // Called in a bad state
256         throw;
257       }
258 
259       // Validate input value.
260       if (value == 0) throw;
261 
262       balances[msg.sender] = safeSub(balances[msg.sender], value);
263 
264       // Take tokens out from circulation
265       totalSupply = safeSub(totalSupply, value);
266       totalUpgraded = safeAdd(totalUpgraded, value);
267 
268       // Upgrade agent reissues the tokens
269       upgradeAgent.upgradeFrom(msg.sender, value);
270       Upgrade(msg.sender, upgradeAgent, value);
271   }
272 
273   /**
274    * Set an upgrade agent that handles
275    */
276   function setUpgradeAgent(address agent) external {
277 
278       if(!canUpgrade()) {
279         // The token is not yet in a state that we could think upgrading
280         throw;
281       }
282 
283       if (agent == 0x0) throw;
284       // Only a master can designate the next agent
285       if (msg.sender != upgradeMaster) throw;
286       // Upgrade has already begun for an agent
287       if (getUpgradeState() == UpgradeState.Upgrading) throw;
288 
289       upgradeAgent = UpgradeAgent(agent);
290 
291       // Bad interface
292       if(!upgradeAgent.isUpgradeAgent()) throw;
293       // Make sure that token supplies match in source and target
294       if (upgradeAgent.originalSupply() != totalSupply) throw;
295 
296       UpgradeAgentSet(upgradeAgent);
297   }
298 
299   /**
300    * Get the state of the token upgrade.
301    */
302   function getUpgradeState() public constant returns(UpgradeState) {
303     if(!canUpgrade()) return UpgradeState.NotAllowed;
304     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
305     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
306     else return UpgradeState.Upgrading;
307   }
308 
309   /**
310    * Change the upgrade master.
311    *
312    * This allows us to set a new owner for the upgrade mechanism.
313    */
314   function setUpgradeMaster(address master) public {
315       if (master == 0x0) throw;
316       if (msg.sender != upgradeMaster) throw;
317       upgradeMaster = master;
318   }
319 
320   /**
321    * Child contract can enable to provide the condition when the upgrade can begun.
322    */
323   function canUpgrade() public constant returns(bool) {
324      return true;
325   }
326 
327 }
328 
329 
330 
331 
332 /*
333  * Ownable
334  *
335  * Base contract with an owner.
336  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
337  */
338 contract Ownable {
339   address public owner;
340 
341   function Ownable() {
342     owner = msg.sender;
343   }
344 
345   modifier onlyOwner() {
346     if (msg.sender != owner) {
347       throw;
348     }
349     _;
350   }
351 
352   function transferOwnership(address newOwner) onlyOwner {
353     if (newOwner != address(0)) {
354       owner = newOwner;
355     }
356   }
357 
358 }
359 
360 
361 
362 
363 /**
364  * Define interface for releasing the token transfer after a successful crowdsale.
365  */
366 contract ReleasableToken is ERC20, Ownable {
367 
368   /* The finalizer contract that allows unlift the transfer limits on this token */
369   address public releaseAgent;
370 
371   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
372   bool public released = false;
373 
374   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
375   mapping (address => bool) public transferAgents;
376 
377   /**
378    * Limit token transfer until the crowdsale is over.
379    *
380    */
381   modifier canTransfer(address _sender) {
382 
383     if(!released) {
384         if(!transferAgents[_sender]) {
385             throw;
386         }
387     }
388 
389     _;
390   }
391 
392   /**
393    * Set the contract that can call release and make the token transferable.
394    *
395    * Design choice. Allow reset the release agent to fix fat finger mistakes.
396    */
397   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
398 
399     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
400     releaseAgent = addr;
401   }
402 
403   /**
404    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
405    */
406   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
407     transferAgents[addr] = state;
408   }
409 
410   /**
411    * One way function to release the tokens to the wild.
412    *
413    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
414    */
415   function releaseTokenTransfer() public onlyReleaseAgent {
416     released = true;
417   }
418 
419   /** The function can be called only before or after the tokens have been releasesd */
420   modifier inReleaseState(bool releaseState) {
421     if(releaseState != released) {
422         throw;
423     }
424     _;
425   }
426 
427   /** The function can be called only by a whitelisted release agent. */
428   modifier onlyReleaseAgent() {
429     if(msg.sender != releaseAgent) {
430         throw;
431     }
432     _;
433   }
434 
435   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
436     // Call StandardToken.transfer()
437    return super.transfer(_to, _value);
438   }
439 
440   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
441     // Call StandardToken.transferForm()
442     return super.transferFrom(_from, _to, _value);
443   }
444 
445 }
446 
447 
448 
449 
450 
451 /**
452  * Safe unsigned safe math.
453  *
454  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
455  *
456  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
457  *
458  * Maintained here until merged to mainline zeppelin-solidity.
459  *
460  */
461 library SafeMathLib {
462 
463   function times(uint a, uint b) returns (uint) {
464     uint c = a * b;
465     assert(a == 0 || c / a == b);
466     return c;
467   }
468 
469   function minus(uint a, uint b) returns (uint) {
470     assert(b <= a);
471     return a - b;
472   }
473 
474   function plus(uint a, uint b) returns (uint) {
475     uint c = a + b;
476     assert(c>=a);
477     return c;
478   }
479 
480   function assert(bool assertion) private {
481     if (!assertion) throw;
482   }
483 }
484 
485 
486 
487 /**
488  * A token that can increase its supply by another contract.
489  *
490  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
491  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
492  *
493  */
494 contract MintableToken is StandardToken, Ownable {
495 
496   using SafeMathLib for uint;
497 
498   bool public mintingFinished = false;
499 
500   /** List of agents that are allowed to create new tokens */
501   mapping (address => bool) public mintAgents;
502 
503   event MintingAgentChanged(address addr, bool state  );
504 
505   /**
506    * Create new tokens and allocate them to an address..
507    *
508    * Only callably by a crowdsale contract (mint agent).
509    */
510   function mint(address receiver, uint amount) onlyMintAgent canMint public {
511     totalSupply = totalSupply.plus(amount);
512     balances[receiver] = balances[receiver].plus(amount);
513 
514     // This will make the mint transaction apper in EtherScan.io
515     // We can remove this after there is a standardized minting event
516     Transfer(0, receiver, amount);
517   }
518 
519   /**
520    * Owner can allow a crowdsale contract to mint new tokens.
521    */
522   function setMintAgent(address addr, bool state) onlyOwner canMint public {
523     mintAgents[addr] = state;
524     MintingAgentChanged(addr, state);
525   }
526 
527   modifier onlyMintAgent() {
528     // Only crowdsale contracts are allowed to mint new tokens
529     if(!mintAgents[msg.sender]) {
530         throw;
531     }
532     _;
533   }
534 
535   /** Make sure we are not done yet. */
536   modifier canMint() {
537     if(mintingFinished) throw;
538     _;
539   }
540 }
541 
542 
543 
544 /**
545  * A crowdsaled token.
546  *
547  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
548  *
549  * - The token transfer() is disabled until the crowdsale is over
550  * - The token contract gives an opt-in upgrade path to a new contract
551  * - The same token can be part of several crowdsales through approve() mechanism
552  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
553  *
554  */
555 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
556 
557   event UpdatedTokenInformation(string newName, string newSymbol);
558 
559   string public name;
560 
561   string public symbol;
562 
563   uint public decimals;
564 
565   /**
566    * Construct the token.
567    *
568    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
569    *
570    * @param _name Token name
571    * @param _symbol Token symbol - should be all caps
572    * @param _initialSupply How many tokens we start with
573    * @param _decimals Number of decimal places
574    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
575    */
576   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
577     UpgradeableToken(msg.sender) {
578 
579     // Create any address, can be transferred
580     // to team multisig via changeOwner(),
581     // also remember to call setUpgradeMaster()
582     owner = msg.sender;
583 
584     name = _name;
585     symbol = _symbol;
586 
587     totalSupply = _initialSupply;
588 
589     decimals = _decimals;
590 
591     // Create initially all balance on the team multisig
592     balances[owner] = totalSupply;
593 
594     if(totalSupply > 0) {
595       Minted(owner, totalSupply);
596     }
597 
598     // No more new supply allowed after the token creation
599     if(!_mintable) {
600       mintingFinished = true;
601       if(totalSupply == 0) {
602         throw; // Cannot create a token without supply and no minting
603       }
604     }
605   }
606 
607   /**
608    * When token is released to be transferable, enforce no new tokens can be created.
609    */
610   function releaseTokenTransfer() public onlyReleaseAgent {
611     mintingFinished = true;
612     super.releaseTokenTransfer();
613   }
614 
615   /**
616    * Allow upgrade agent functionality kick in only if the crowdsale was success.
617    */
618   function canUpgrade() public constant returns(bool) {
619     return released && super.canUpgrade();
620   }
621 
622   /**
623    * Owner can update token information here
624    */
625   function setTokenInformation(string _name, string _symbol) onlyOwner {
626     name = _name;
627     symbol = _symbol;
628 
629     UpdatedTokenInformation(name, symbol);
630   }
631 
632 }