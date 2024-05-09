1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner {
39     if (newOwner != address(0)) {
40       owner = newOwner;
41     }
42   }
43 }
44 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
45 /**
46  * Math operations with safety checks
47  */
48 contract SafeMath {
49   function safeMul(uint a, uint b) internal returns (uint) {
50     uint c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54   function safeDiv(uint a, uint b) internal returns (uint) {
55     assert(b > 0);
56     uint c = a / b;
57     assert(a == b * c + a % b);
58     return c;
59   }
60   function safeSub(uint a, uint b) internal returns (uint) {
61     assert(b <= a);
62     return a - b;
63   }
64   function safeAdd(uint a, uint b) internal returns (uint) {
65     uint c = a + b;
66     assert(c>=a && c>=b);
67     return c;
68   }
69   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a >= b ? a : b;
71   }
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
76     return a >= b ? a : b;
77   }
78   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
79     return a < b ? a : b;
80   }
81 }
82 /**
83  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
84  *
85  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
86  */
87 /**
88  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
89  *
90  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
91  */
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) constant returns (uint256);
98   function transferFrom(address from, address to, uint256 value) returns (bool);
99   function approve(address spender, uint256 value) returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 /**
103  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
104  *
105  * Based on code by FirstBlood:
106  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, SafeMath {
109   /* Token supply got increased and a new owner received these tokens */
110   event Minted(address receiver, uint amount);
111   /* Actual balances of token holders */
112   mapping(address => uint) balances;
113   /* approve() allowances */
114   mapping (address => mapping (address => uint)) allowed;
115   /* Interface declaration */
116   function isToken() public constant returns (bool weAre) {
117     return true;
118   }
119   function transfer(address _to, uint _value) returns (bool success) {
120     balances[msg.sender] = safeSub(balances[msg.sender], _value);
121     balances[_to] = safeAdd(balances[_to], _value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
126     uint _allowance = allowed[_from][msg.sender];
127     balances[_to] = safeAdd(balances[_to], _value);
128     balances[_from] = safeSub(balances[_from], _value);
129     allowed[_from][msg.sender] = safeSub(_allowance, _value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133   function balanceOf(address _owner) constant returns (uint balance) {
134     return balances[_owner];
135   }
136   function approve(address _spender, uint _value) returns (bool success) {
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146   function allowance(address _owner, address _spender) constant returns (uint remaining) {
147     return allowed[_owner][_spender];
148   }
149 }
150 /**
151  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
152  *
153  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
154  */
155 /**
156  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
157  *
158  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
159  */
160 /**
161  * Upgrade agent interface inspired by Lunyr.
162  *
163  * Upgrade agent transfers tokens to a new contract.
164  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
165  */
166 contract UpgradeAgent {
167   uint public originalSupply;
168   /** Interface marker */
169   function isUpgradeAgent() public constant returns (bool) {
170     return true;
171   }
172   function upgradeFrom(address _from, uint256 _value) public;
173 }
174 /**
175  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
176  *
177  * First envisioned by Golem and Lunyr projects.
178  */
179 contract UpgradeableToken is StandardToken {
180   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
181   address public upgradeMaster;
182   /** The next contract where the tokens will be migrated. */
183   UpgradeAgent public upgradeAgent;
184   /** How many tokens we have upgraded by now. */
185   uint256 public totalUpgraded;
186   /**
187    * Upgrade states.
188    *
189    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
190    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
191    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
192    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
193    *
194    */
195   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
196   /**
197    * Somebody has upgraded some of his tokens.
198    */
199   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
200   /**
201    * New upgrade agent available.
202    */
203   event UpgradeAgentSet(address agent);
204   /**
205    * Do not allow construction without upgrade master set.
206    */
207   function UpgradeableToken(address _upgradeMaster) {
208     upgradeMaster = _upgradeMaster;
209   }
210   /**
211    * Allow the token holder to upgrade some of their tokens to a new contract.
212    */
213   function upgrade(uint256 value) public {
214       UpgradeState state = getUpgradeState();
215       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
216         // Called in a bad state
217         throw;
218       }
219       // Validate input value.
220       if (value == 0) throw;
221       balances[msg.sender] = safeSub(balances[msg.sender], value);
222       // Take tokens out from circulation
223       totalSupply = safeSub(totalSupply, value);
224       totalUpgraded = safeAdd(totalUpgraded, value);
225       // Upgrade agent reissues the tokens
226       upgradeAgent.upgradeFrom(msg.sender, value);
227       Upgrade(msg.sender, upgradeAgent, value);
228   }
229   /**
230    * Set an upgrade agent that handles
231    */
232   function setUpgradeAgent(address agent) external {
233       if(!canUpgrade()) {
234         // The token is not yet in a state that we could think upgrading
235         throw;
236       }
237       if (agent == 0x0) throw;
238       // Only a master can designate the next agent
239       if (msg.sender != upgradeMaster) throw;
240       // Upgrade has already begun for an agent
241       if (getUpgradeState() == UpgradeState.Upgrading) throw;
242       upgradeAgent = UpgradeAgent(agent);
243       // Bad interface
244       if(!upgradeAgent.isUpgradeAgent()) throw;
245       // Make sure that token supplies match in source and target
246       if (upgradeAgent.originalSupply() != totalSupply) throw;
247       UpgradeAgentSet(upgradeAgent);
248   }
249   /**
250    * Get the state of the token upgrade.
251    */
252   function getUpgradeState() public constant returns(UpgradeState) {
253     if(!canUpgrade()) return UpgradeState.NotAllowed;
254     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
255     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
256     else return UpgradeState.Upgrading;
257   }
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
268   /**
269    * Child contract can enable to provide the condition when the upgrade can begun.
270    */
271   function canUpgrade() public constant returns(bool) {
272      return true;
273   }
274 }
275 /**
276  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
277  *
278  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
279  */
280 /**
281  * Define interface for releasing the token transfer after a successful crowdsale.
282  */
283 contract ReleasableToken is ERC20, Ownable {
284   /* The finalizer contract that allows unlift the transfer limits on this token */
285   address public releaseAgent;
286   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
287   bool public released = false;
288   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
289   mapping (address => bool) public transferAgents;
290   /**
291    * Limit token transfer until the crowdsale is over.
292    *
293    */
294   modifier canTransfer(address _sender) {
295     if(!released) {
296         if(!transferAgents[_sender]) {
297             throw;
298         }
299     }
300     _;
301   }
302   /**
303    * Set the contract that can call release and make the token transferable.
304    *
305    * Design choice. Allow reset the release agent to fix fat finger mistakes.
306    */
307   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
308     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
309     releaseAgent = addr;
310   }
311   /**
312    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
313    */
314   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
315     transferAgents[addr] = state;
316   }
317   /**
318    * One way function to release the tokens to the wild.
319    *
320    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
321    */
322   function releaseTokenTransfer() public onlyReleaseAgent {
323     released = true;
324   }
325   /** The function can be called only before or after the tokens have been releasesd */
326   modifier inReleaseState(bool releaseState) {
327     if(releaseState != released) {
328         throw;
329     }
330     _;
331   }
332   /** The function can be called only by a whitelisted release agent. */
333   modifier onlyReleaseAgent() {
334     if(msg.sender != releaseAgent) {
335         throw;
336     }
337     _;
338   }
339   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
340     // Call StandardToken.transfer()
341    return super.transfer(_to, _value);
342   }
343   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
344     // Call StandardToken.transferForm()
345     return super.transferFrom(_from, _to, _value);
346   }
347 }
348 /**
349  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
350  *
351  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
352  */
353 /**
354  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
355  *
356  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
357  */
358 /**
359  * Safe unsigned safe math.
360  *
361  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
362  *
363  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
364  *
365  * Maintained here until merged to mainline zeppelin-solidity.
366  *
367  */
368 library SafeMathLib {
369   function times(uint a, uint b) returns (uint) {
370     uint c = a * b;
371     assert(a == 0 || c / a == b);
372     return c;
373   }
374   function minus(uint a, uint b) returns (uint) {
375     assert(b <= a);
376     return a - b;
377   }
378   function plus(uint a, uint b) returns (uint) {
379     uint c = a + b;
380     assert(c>=a);
381     return c;
382   }
383 }
384 /**
385  * A token that can increase its supply by another contract.
386  *
387  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
388  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
389  *
390  */
391 contract MintableToken is StandardToken, Ownable {
392   using SafeMathLib for uint;
393   bool public mintingFinished = false;
394   /** List of agents that are allowed to create new tokens */
395   mapping (address => bool) public mintAgents;
396   event MintingAgentChanged(address addr, bool state  );
397   /**
398    * Create new tokens and allocate them to an address..
399    *
400    * Only callably by a crowdsale contract (mint agent).
401    */
402   function mint(address receiver, uint amount) onlyMintAgent canMint public {
403     totalSupply = totalSupply.plus(amount);
404     balances[receiver] = balances[receiver].plus(amount);
405     // This will make the mint transaction apper in EtherScan.io
406     // We can remove this after there is a standardized minting event
407     Transfer(0, receiver, amount);
408   }
409   /**
410    * Owner can allow a crowdsale contract to mint new tokens.
411    */
412   function setMintAgent(address addr, bool state) onlyOwner canMint public {
413     mintAgents[addr] = state;
414     MintingAgentChanged(addr, state);
415   }
416   modifier onlyMintAgent() {
417     // Only crowdsale contracts are allowed to mint new tokens
418     if(!mintAgents[msg.sender]) {
419         throw;
420     }
421     _;
422   }
423   /** Make sure we are not done yet. */
424   modifier canMint() {
425     if(mintingFinished) throw;
426     _;
427   }
428 }
429 /**
430  * A crowdsaled token.
431  *
432  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
433  *
434  * - The token transfer() is disabled until the crowdsale is over
435  * - The token contract gives an opt-in upgrade path to a new contract
436  * - The same token can be part of several crowdsales through approve() mechanism
437  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
438  *
439  */
440 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
441   /** Name and symbol were updated. */
442   event UpdatedTokenInformation(string newName, string newSymbol);
443   string public name;
444   string public symbol;
445   uint public decimals;
446   /**
447    * Construct the token.
448    *
449    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
450    *
451    * @param _name Token name
452    * @param _symbol Token symbol - should be all caps
453    * @param _initialSupply How many tokens we start with
454    * @param _decimals Number of decimal places
455    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
456    */
457   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
458     UpgradeableToken(msg.sender) {
459     // Create any address, can be transferred
460     // to team multisig via changeOwner(),
461     // also remember to call setUpgradeMaster()
462     owner = msg.sender;
463     name = _name;
464     symbol = _symbol;
465     totalSupply = _initialSupply;
466     decimals = _decimals;
467     // Create initially all balance on the team multisig
468     balances[owner] = totalSupply;
469     if(totalSupply > 0) {
470       Minted(owner, totalSupply);
471     }
472     // No more new supply allowed after the token creation
473     if(!_mintable) {
474       mintingFinished = true;
475       if(totalSupply == 0) {
476         throw; // Cannot create a token without supply and no minting
477       }
478     }
479   }
480   /**
481    * When token is released to be transferable, enforce no new tokens can be created.
482    */
483   function releaseTokenTransfer() public onlyReleaseAgent {
484     mintingFinished = true;
485     super.releaseTokenTransfer();
486   }
487   /**
488    * Allow upgrade agent functionality kick in only if the crowdsale was success.
489    */
490   function canUpgrade() public constant returns(bool) {
491     return released && super.canUpgrade();
492   }
493   /**
494    * Owner can update token information here.
495    *
496    * It is often useful to conceal the actual token association, until
497    * the token operations, like central issuance or reissuance have been completed.
498    *
499    * This function allows the token owner to rename the token after the operations
500    * have been completed and then point the audience to use the token contract.
501    */
502   function setTokenInformation(string _name, string _symbol) onlyOwner {
503     name = _name;
504     symbol = _symbol;
505     UpdatedTokenInformation(name, symbol);
506   }
507 }
508 /**
509  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
510  *
511  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
512  */
513 contract BurnableToken is StandardToken {
514   address public constant BURN_ADDRESS = 0;
515   /** How many tokens we burned */
516   event Burned(address burner, uint burnedAmount);
517   /**
518    * Burn extra tokens from a balance.
519    *
520    */
521   function burn(uint burnAmount) {
522     address burner = msg.sender;
523     balances[burner] = safeSub(balances[burner], burnAmount);
524     totalSupply = safeSub(totalSupply, burnAmount);
525     Burned(burner, burnAmount);
526   }
527 }
528 contract GetToken is CrowdsaleToken, BurnableToken {
529     function GetToken() CrowdsaleToken(
530             "Guaranteed Entrance Token", 
531             "GET", 
532             0,  // We don't want to have initial supply
533             18,
534             true // Mintable
535         )
536     {}
537 }