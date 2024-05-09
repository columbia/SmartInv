1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26   uint256 public totalSupply;
27   function balanceOf(address who) constant returns (uint256);
28   function transfer(address to, uint256 value) returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
46 
47 
48 
49 /**
50  * Math operations with safety checks
51  */
52 contract SafeMath {
53   function safeMul(uint a, uint b) internal returns (uint) {
54     uint c = a * b;
55     assert(a == 0 || c / a == b);
56     return c;
57   }
58 
59   function safeDiv(uint a, uint b) internal returns (uint) {
60     assert(b > 0);
61     uint c = a / b;
62     assert(a == b * c + a % b);
63     return c;
64   }
65 
66   function safeSub(uint a, uint b) internal returns (uint) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function safeAdd(uint a, uint b) internal returns (uint) {
72     uint c = a + b;
73     assert(c>=a && c>=b);
74     return c;
75   }
76 
77   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
78     return a >= b ? a : b;
79   }
80 
81   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
82     return a < b ? a : b;
83   }
84 
85   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
86     return a >= b ? a : b;
87   }
88 
89   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
90     return a < b ? a : b;
91   }
92 
93 }
94 
95 
96 
97 /**
98  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
99  *
100  * Based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, SafeMath {
104 
105   /* Token supply got increased and a new owner received these tokens */
106   event Minted(address receiver, uint amount);
107 
108   /* Actual balances of token holders */
109   mapping(address => uint) balances;
110 
111   /* approve() allowances */
112   mapping (address => mapping (address => uint)) allowed;
113 
114   /* Interface declaration */
115   function isToken() public constant returns (bool weAre) {
116     return true;
117   }
118 
119   function transfer(address _to, uint _value) returns (bool success) {
120     balances[msg.sender] = safeSub(balances[msg.sender], _value);
121     balances[_to] = safeAdd(balances[_to], _value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
127     uint _allowance = allowed[_from][msg.sender];
128 
129     balances[_to] = safeAdd(balances[_to], _value);
130     balances[_from] = safeSub(balances[_from], _value);
131     allowed[_from][msg.sender] = safeSub(_allowance, _value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   function balanceOf(address _owner) constant returns (uint balance) {
137     return balances[_owner];
138   }
139 
140   function approve(address _spender, uint _value) returns (bool success) {
141 
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender, 0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
147 
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   function allowance(address _owner, address _spender) constant returns (uint remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 /**
160  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
161  *
162  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
163  */
164 
165 
166 
167 
168 /**
169  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
170  *
171  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
172  */
173 
174 
175 /**
176  * Upgrade agent interface inspired by Lunyr.
177  *
178  * Upgrade agent transfers tokens to a new contract.
179  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
180  */
181 contract UpgradeAgent {
182 
183   uint public originalSupply;
184 
185   /** Interface marker */
186   function isUpgradeAgent() public constant returns (bool) {
187     return true;
188   }
189 
190   function upgradeFrom(address _from, uint256 _value) public;
191 
192 }
193 
194 
195 /**
196  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
197  *
198  * First envisioned by Golem and Lunyr projects.
199  */
200 contract UpgradeableToken is StandardToken {
201 
202   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
203   address public upgradeMaster;
204 
205   /** The next contract where the tokens will be migrated. */
206   UpgradeAgent public upgradeAgent;
207 
208   /** How many tokens we have upgraded by now. */
209   uint256 public totalUpgraded;
210 
211   /**
212    * Upgrade states.
213    *
214    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
215    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
216    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
217    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
218    *
219    */
220   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
221 
222   /**
223    * Somebody has upgraded some of his tokens.
224    */
225   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
226 
227   /**
228    * New upgrade agent available.
229    */
230   event UpgradeAgentSet(address agent);
231 
232   /**
233    * Do not allow construction without upgrade master set.
234    */
235   function UpgradeableToken(address _upgradeMaster) {
236     upgradeMaster = _upgradeMaster;
237   }
238 
239   /**
240    * Allow the token holder to upgrade some of their tokens to a new contract.
241    */
242   function upgrade(uint256 value) public {
243 
244       UpgradeState state = getUpgradeState();
245       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
246         // Called in a bad state
247         throw;
248       }
249 
250       // Validate input value.
251       if (value == 0) throw;
252 
253       balances[msg.sender] = safeSub(balances[msg.sender], value);
254 
255       // Take tokens out from circulation
256       totalSupply = safeSub(totalSupply, value);
257       totalUpgraded = safeAdd(totalUpgraded, value);
258 
259       // Upgrade agent reissues the tokens
260       upgradeAgent.upgradeFrom(msg.sender, value);
261       Upgrade(msg.sender, upgradeAgent, value);
262   }
263 
264   /**
265    * Set an upgrade agent that handles
266    */
267   function setUpgradeAgent(address agent) external {
268 
269       if(!canUpgrade()) {
270         // The token is not yet in a state that we could think upgrading
271         throw;
272       }
273 
274       if (agent == 0x0) throw;
275       // Only a master can designate the next agent
276       if (msg.sender != upgradeMaster) throw;
277       // Upgrade has already begun for an agent
278       if (getUpgradeState() == UpgradeState.Upgrading) throw;
279 
280       upgradeAgent = UpgradeAgent(agent);
281 
282       // Bad interface
283       if(!upgradeAgent.isUpgradeAgent()) throw;
284       // Make sure that token supplies match in source and target
285       if (upgradeAgent.originalSupply() != totalSupply) throw;
286 
287       UpgradeAgentSet(upgradeAgent);
288   }
289 
290   /**
291    * Get the state of the token upgrade.
292    */
293   function getUpgradeState() public constant returns(UpgradeState) {
294     if(!canUpgrade()) return UpgradeState.NotAllowed;
295     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
296     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
297     else return UpgradeState.Upgrading;
298   }
299 
300   /**
301    * Change the upgrade master.
302    *
303    * This allows us to set a new owner for the upgrade mechanism.
304    */
305   function setUpgradeMaster(address master) public {
306       if (master == 0x0) throw;
307       if (msg.sender != upgradeMaster) throw;
308       upgradeMaster = master;
309   }
310 
311   /**
312    * Child contract can enable to provide the condition when the upgrade can begun.
313    */
314   function canUpgrade() public constant returns(bool) {
315      return true;
316   }
317 
318 }
319 
320 /**
321  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
322  *
323  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
324  */
325 
326 
327 
328 
329 /**
330  * @title Ownable
331  * @dev The Ownable contract has an owner address, and provides basic authorization control
332  * functions, this simplifies the implementation of "user permissions".
333  */
334 contract Ownable {
335   address public owner;
336 
337 
338   /**
339    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
340    * account.
341    */
342   function Ownable() {
343     owner = msg.sender;
344   }
345 
346 
347   /**
348    * @dev Throws if called by any account other than the owner.
349    */
350   modifier onlyOwner() {
351     require(msg.sender == owner);
352     _;
353   }
354 
355 
356   /**
357    * @dev Allows the current owner to transfer control of the contract to a newOwner.
358    * @param newOwner The address to transfer ownership to.
359    */
360   function transferOwnership(address newOwner) onlyOwner {
361     require(newOwner != address(0));      
362     owner = newOwner;
363   }
364 
365 }
366 
367 
368 
369 
370 /**
371  * Define interface for releasing the token transfer after a successful crowdsale.
372  */
373 contract ReleasableToken is ERC20, Ownable {
374 
375   /* The finalizer contract that allows unlift the transfer limits on this token */
376   address public releaseAgent;
377 
378   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
379   bool public released = false;
380 
381   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
382   mapping (address => bool) public transferAgents;
383 
384   /**
385    * Limit token transfer until the crowdsale is over.
386    *
387    */
388   modifier canTransfer(address _sender) {
389 
390     if(!released) {
391         if(!transferAgents[_sender]) {
392             throw;
393         }
394     }
395 
396     _;
397   }
398 
399   /**
400    * Set the contract that can call release and make the token transferable.
401    *
402    * Design choice. Allow reset the release agent to fix fat finger mistakes.
403    */
404   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
405 
406     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
407     releaseAgent = addr;
408   }
409 
410   /**
411    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
412    */
413   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
414     transferAgents[addr] = state;
415   }
416 
417   /**
418    * One way function to release the tokens to the wild.
419    *
420    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
421    */
422   function releaseTokenTransfer() public onlyReleaseAgent {
423     released = true;
424   }
425 
426   /** The function can be called only before or after the tokens have been releasesd */
427   modifier inReleaseState(bool releaseState) {
428     if(releaseState != released) {
429         throw;
430     }
431     _;
432   }
433 
434   /** The function can be called only by a whitelisted release agent. */
435   modifier onlyReleaseAgent() {
436     if(msg.sender != releaseAgent) {
437         throw;
438     }
439     _;
440   }
441 
442   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
443     // Call StandardToken.transfer()
444    return super.transfer(_to, _value);
445   }
446 
447   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
448     // Call StandardToken.transferForm()
449     return super.transferFrom(_from, _to, _value);
450   }
451 
452 }
453 
454 /**
455  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
456  *
457  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
458  */
459 
460 
461 
462 
463 /**
464  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
465  *
466  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
467  */
468 
469 
470 /**
471  * Safe unsigned safe math.
472  *
473  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
474  *
475  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
476  *
477  * Maintained here until merged to mainline zeppelin-solidity.
478  *
479  */
480 library SafeMathLib {
481 
482   function times(uint a, uint b) returns (uint) {
483     uint c = a * b;
484     assert(a == 0 || c / a == b);
485     return c;
486   }
487 
488   function minus(uint a, uint b) returns (uint) {
489     assert(b <= a);
490     return a - b;
491   }
492 
493   function plus(uint a, uint b) returns (uint) {
494     uint c = a + b;
495     assert(c>=a);
496     return c;
497   }
498 
499 }
500 
501 
502 
503 /**
504  * A token that can increase its supply by another contract.
505  *
506  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
507  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
508  *
509  */
510 contract MintableToken is StandardToken, Ownable {
511 
512   using SafeMathLib for uint;
513 
514   bool public mintingFinished = false;
515 
516   /** List of agents that are allowed to create new tokens */
517   mapping (address => bool) public mintAgents;
518 
519   event MintingAgentChanged(address addr, bool state  );
520 
521   /**
522    * Create new tokens and allocate them to an address..
523    *
524    * Only callably by a crowdsale contract (mint agent).
525    */
526   function mint(address receiver, uint amount) onlyMintAgent canMint public {
527     totalSupply = totalSupply.plus(amount);
528     balances[receiver] = balances[receiver].plus(amount);
529 
530     // This will make the mint transaction apper in EtherScan.io
531     // We can remove this after there is a standardized minting event
532     Transfer(0, receiver, amount);
533   }
534 
535   /**
536    * Owner can allow a crowdsale contract to mint new tokens.
537    */
538   function setMintAgent(address addr, bool state) onlyOwner canMint public {
539     mintAgents[addr] = state;
540     MintingAgentChanged(addr, state);
541   }
542 
543   modifier onlyMintAgent() {
544     // Only crowdsale contracts are allowed to mint new tokens
545     if(!mintAgents[msg.sender]) {
546         throw;
547     }
548     _;
549   }
550 
551   /** Make sure we are not done yet. */
552   modifier canMint() {
553     if(mintingFinished) throw;
554     _;
555   }
556 }
557 
558 
559 
560 /**
561  * A crowdsaled token.
562  *
563  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
564  *
565  * - The token transfer() is disabled until the crowdsale is over
566  * - The token contract gives an opt-in upgrade path to a new contract
567  * - The same token can be part of several crowdsales through approve() mechanism
568  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
569  *
570  */
571 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
572 
573   /** Name and symbol were updated. */
574   event UpdatedTokenInformation(string newName, string newSymbol);
575 
576   string public name;
577 
578   string public symbol;
579 
580   uint public decimals;
581 
582   /**
583    * Construct the token.
584    *
585    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
586    *
587    * @param _name Token name
588    * @param _symbol Token symbol - should be all caps
589    * @param _initialSupply How many tokens we start with
590    * @param _decimals Number of decimal places
591    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
592    */
593   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
594     UpgradeableToken(msg.sender) {
595 
596     // Create any address, can be transferred
597     // to team multisig via changeOwner(),
598     // also remember to call setUpgradeMaster()
599     owner = msg.sender;
600 
601     name = _name;
602     symbol = _symbol;
603 
604     totalSupply = _initialSupply;
605 
606     decimals = _decimals;
607 
608     // Create initially all balance on the team multisig
609     balances[owner] = totalSupply;
610 
611     if(totalSupply > 0) {
612       Minted(owner, totalSupply);
613     }
614 
615     // No more new supply allowed after the token creation
616     if(!_mintable) {
617       mintingFinished = true;
618       if(totalSupply == 0) {
619         throw; // Cannot create a token without supply and no minting
620       }
621     }
622   }
623 
624   /**
625    * When token is released to be transferable, enforce no new tokens can be created.
626    */
627   function releaseTokenTransfer() public onlyReleaseAgent {
628     mintingFinished = true;
629     super.releaseTokenTransfer();
630   }
631 
632   /**
633    * Allow upgrade agent functionality kick in only if the crowdsale was success.
634    */
635   function canUpgrade() public constant returns(bool) {
636     return released && super.canUpgrade();
637   }
638 
639   /**
640    * Owner can update token information here.
641    *
642    * It is often useful to conceal the actual token association, until
643    * the token operations, like central issuance or reissuance have been completed.
644    *
645    * This function allows the token owner to rename the token after the operations
646    * have been completed and then point the audience to use the token contract.
647    */
648   function setTokenInformation(string _name, string _symbol) onlyOwner {
649     name = _name;
650     symbol = _symbol;
651 
652     UpdatedTokenInformation(name, symbol);
653   }
654 
655 }