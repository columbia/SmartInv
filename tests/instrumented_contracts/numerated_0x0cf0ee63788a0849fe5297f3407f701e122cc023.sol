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
134 
135 
136 
137 
138 /**
139  * Upgrade agent interface inspired by Lunyr.
140  *
141  * Upgrade agent transfers tokens to a new contract.
142  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
143  */
144 contract UpgradeAgent {
145 
146   uint public originalSupply;
147 
148   /** Interface marker */
149   function isUpgradeAgent() public constant returns (bool) {
150     return true;
151   }
152 
153   function upgradeFrom(address _from, uint256 _value) public;
154 
155 }
156 
157 
158 /**
159  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
160  *
161  * First envisioned by Golem and Lunyr projects.
162  */
163 contract UpgradeableToken is StandardToken {
164 
165   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
166   address public upgradeMaster;
167 
168   /** The next contract where the tokens will be migrated. */
169   UpgradeAgent public upgradeAgent;
170 
171   /** How many tokens we have upgraded by now. */
172   uint256 public totalUpgraded;
173 
174   /**
175    * Upgrade states.
176    *
177    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
178    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
179    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
180    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
181    *
182    */
183   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
184 
185   /**
186    * Somebody has upgraded some of his tokens.
187    */
188   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
189 
190   /**
191    * New upgrade agent available.
192    */
193   event UpgradeAgentSet(address agent);
194 
195   /**
196    * Do not allow construction without upgrade master set.
197    */
198   function UpgradeableToken(address _upgradeMaster) {
199     upgradeMaster = _upgradeMaster;
200   }
201 
202   /**
203    * Allow the token holder to upgrade some of their tokens to a new contract.
204    */
205   function upgrade(uint256 value) public {
206 
207       UpgradeState state = getUpgradeState();
208       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
209         // Called in a bad state
210         throw;
211       }
212 
213       // Validate input value.
214       if (value == 0) throw;
215 
216       balances[msg.sender] = safeSub(balances[msg.sender], value);
217 
218       // Take tokens out from circulation
219       totalSupply = safeSub(totalSupply, value);
220       totalUpgraded = safeAdd(totalUpgraded, value);
221 
222       // Upgrade agent reissues the tokens
223       upgradeAgent.upgradeFrom(msg.sender, value);
224       Upgrade(msg.sender, upgradeAgent, value);
225   }
226 
227   /**
228    * Set an upgrade agent that handles
229    */
230   function setUpgradeAgent(address agent) external {
231 
232       if(!canUpgrade()) {
233         // The token is not yet in a state that we could think upgrading
234         throw;
235       }
236 
237       if (agent == 0x0) throw;
238       // Only a master can designate the next agent
239       if (msg.sender != upgradeMaster) throw;
240       // Upgrade has already begun for an agent
241       if (getUpgradeState() == UpgradeState.Upgrading) throw;
242 
243       upgradeAgent = UpgradeAgent(agent);
244 
245       // Bad interface
246       if(!upgradeAgent.isUpgradeAgent()) throw;
247       // Make sure that token supplies match in source and target
248       if (upgradeAgent.originalSupply() != totalSupply) throw;
249 
250       UpgradeAgentSet(upgradeAgent);
251   }
252 
253   /**
254    * Get the state of the token upgrade.
255    */
256   function getUpgradeState() public constant returns(UpgradeState) {
257     if(!canUpgrade()) return UpgradeState.NotAllowed;
258     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
259     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
260     else return UpgradeState.Upgrading;
261   }
262 
263   /**
264    * Change the upgrade master.
265    *
266    * This allows us to set a new owner for the upgrade mechanism.
267    */
268   function setUpgradeMaster(address master) public {
269       if (master == 0x0) throw;
270       if (msg.sender != upgradeMaster) throw;
271       upgradeMaster = master;
272   }
273 
274   /**
275    * Child contract can enable to provide the condition when the upgrade can begun.
276    */
277   function canUpgrade() public constant returns(bool) {
278      return true;
279   }
280 
281 }
282 
283 
284 
285 
286 /*
287  * Ownable
288  *
289  * Base contract with an owner.
290  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
291  */
292 contract Ownable {
293   address public owner;
294 
295   function Ownable() {
296     owner = msg.sender;
297   }
298 
299   modifier onlyOwner() {
300     if (msg.sender != owner) {
301       throw;
302     }
303     _;
304   }
305 
306   function transferOwnership(address newOwner) onlyOwner {
307     if (newOwner != address(0)) {
308       owner = newOwner;
309     }
310   }
311 
312 }
313 
314 
315 
316 
317 /**
318  * Define interface for releasing the token transfer after a successful crowdsale.
319  */
320 contract ReleasableToken is ERC20, Ownable {
321 
322   /* The finalizer contract that allows unlift the transfer limits on this token */
323   address public releaseAgent;
324 
325   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
326   bool public released = false;
327 
328   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
329   mapping (address => bool) public transferAgents;
330 
331   /**
332    * Limit token transfer until the crowdsale is over.
333    *
334    */
335   modifier canTransfer(address _sender) {
336 
337     if(!released) {
338         if(!transferAgents[_sender]) {
339             throw;
340         }
341     }
342 
343     _;
344   }
345 
346   /**
347    * Set the contract that can call release and make the token transferable.
348    *
349    * Design choice. Allow reset the release agent to fix fat finger mistakes.
350    */
351   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
352 
353     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
354     releaseAgent = addr;
355   }
356 
357   /**
358    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
359    */
360   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
361     transferAgents[addr] = state;
362   }
363 
364   /**
365    * One way function to release the tokens to the wild.
366    *
367    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
368    */
369   function releaseTokenTransfer() public onlyReleaseAgent {
370     released = true;
371   }
372 
373   /** The function can be called only before or after the tokens have been releasesd */
374   modifier inReleaseState(bool releaseState) {
375     if(releaseState != released) {
376         throw;
377     }
378     _;
379   }
380 
381   /** The function can be called only by a whitelisted release agent. */
382   modifier onlyReleaseAgent() {
383     if(msg.sender != releaseAgent) {
384         throw;
385     }
386     _;
387   }
388 
389   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
390     // Call StandardToken.transfer()
391    return super.transfer(_to, _value);
392   }
393 
394   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
395     // Call StandardToken.transferForm()
396     return super.transferFrom(_from, _to, _value);
397   }
398 
399 }
400 
401 
402 
403 
404 
405 /**
406  * Safe unsigned safe math.
407  *
408  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
409  *
410  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
411  *
412  * Maintained here until merged to mainline zeppelin-solidity.
413  *
414  */
415 library SafeMathLib {
416 
417   function times(uint a, uint b) returns (uint) {
418     uint c = a * b;
419     assert(a == 0 || c / a == b);
420     return c;
421   }
422 
423   function minus(uint a, uint b) returns (uint) {
424     assert(b <= a);
425     return a - b;
426   }
427 
428   function plus(uint a, uint b) returns (uint) {
429     uint c = a + b;
430     assert(c>=a);
431     return c;
432   }
433 
434   function assert(bool assertion) private {
435     if (!assertion) throw;
436   }
437 }
438 
439 
440 
441 /**
442  * A token that can increase its supply by another contract.
443  *
444  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
445  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
446  *
447  */
448 contract MintableToken is StandardToken, Ownable {
449 
450   using SafeMathLib for uint;
451 
452   bool public mintingFinished = false;
453 
454   /** List of agents that are allowed to create new tokens */
455   mapping (address => bool) public mintAgents;
456 
457   event MintingAgentChanged(address addr, bool state  );
458 
459   /**
460    * Create new tokens and allocate them to an address..
461    *
462    * Only callably by a crowdsale contract (mint agent).
463    */
464   function mint(address receiver, uint amount) onlyMintAgent canMint public {
465     totalSupply = totalSupply.plus(amount);
466     balances[receiver] = balances[receiver].plus(amount);
467 
468     // This will make the mint transaction apper in EtherScan.io
469     // We can remove this after there is a standardized minting event
470     Transfer(0, receiver, amount);
471   }
472 
473   /**
474    * Owner can allow a crowdsale contract to mint new tokens.
475    */
476   function setMintAgent(address addr, bool state) onlyOwner canMint public {
477     mintAgents[addr] = state;
478     MintingAgentChanged(addr, state);
479   }
480 
481   modifier onlyMintAgent() {
482     // Only crowdsale contracts are allowed to mint new tokens
483     if(!mintAgents[msg.sender]) {
484         throw;
485     }
486     _;
487   }
488 
489   /** Make sure we are not done yet. */
490   modifier canMint() {
491     if(mintingFinished) throw;
492     _;
493   }
494 }
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
511   /** Name and symbol were updated. */
512   event UpdatedTokenInformation(string newName, string newSymbol);
513 
514   string public name;
515 
516   string public symbol;
517 
518   uint public decimals;
519 
520   /**
521    * Construct the token.
522    *
523    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
524    *
525    * @param _name Token name
526    * @param _symbol Token symbol - should be all caps
527    * @param _initialSupply How many tokens we start with
528    * @param _decimals Number of decimal places
529    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
530    */
531   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
532     UpgradeableToken(msg.sender) {
533 
534     // Create any address, can be transferred
535     // to team multisig via changeOwner(),
536     // also remember to call setUpgradeMaster()
537     owner = msg.sender;
538 
539     name = _name;
540     symbol = _symbol;
541 
542     totalSupply = _initialSupply;
543 
544     decimals = _decimals;
545 
546     // Create initially all balance on the team multisig
547     balances[owner] = totalSupply;
548 
549     if(totalSupply > 0) {
550       Minted(owner, totalSupply);
551     }
552 
553     // No more new supply allowed after the token creation
554     if(!_mintable) {
555       mintingFinished = true;
556       if(totalSupply == 0) {
557         throw; // Cannot create a token without supply and no minting
558       }
559     }
560   }
561 
562   /**
563    * When token is released to be transferable, enforce no new tokens can be created.
564    */
565   function releaseTokenTransfer() public onlyReleaseAgent {
566     mintingFinished = true;
567     super.releaseTokenTransfer();
568   }
569 
570   /**
571    * Allow upgrade agent functionality kick in only if the crowdsale was success.
572    */
573   function canUpgrade() public constant returns(bool) {
574     return released && super.canUpgrade();
575   }
576 
577   /**
578    * Owner can update token information here.
579    *
580    * It is often useful to conceal the actual token association, until
581    * the token operations, like central issuance or reissuance have been completed.
582    *
583    * This function allows the token owner to rename the token after the operations
584    * have been completed and then point the audience to use the token contract.
585    */
586   function setTokenInformation(string _name, string _symbol) onlyOwner {
587     name = _name;
588     symbol = _symbol;
589 
590     UpdatedTokenInformation(name, symbol);
591   }
592 
593 }