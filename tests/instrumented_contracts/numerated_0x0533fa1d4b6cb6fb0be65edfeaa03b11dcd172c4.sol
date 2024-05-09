1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network 
2 pragma solidity ^0.4.11;
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() {
27     owner = msg.sender;
28   }
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) onlyOwner public {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
47 /**
48  * Math operations with safety checks
49  */
50 contract SafeMath {
51   function safeMul(uint a, uint b) internal returns (uint) {
52     uint c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56   function safeDiv(uint a, uint b) internal returns (uint) {
57     assert(b > 0);
58     uint c = a / b;
59     assert(a == b * c + a % b);
60     return c;
61   }
62   function safeSub(uint a, uint b) internal returns (uint) {
63     assert(b <= a);
64     return a - b;
65   }
66   function safeAdd(uint a, uint b) internal returns (uint) {
67     uint c = a + b;
68     assert(c>=a && c>=b);
69     return c;
70   }
71   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
72     return a >= b ? a : b;
73   }
74   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
75     return a < b ? a : b;
76   }
77   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a >= b ? a : b;
79   }
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 }
84 /**
85  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
86  *
87  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
88  */
89 /**
90  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
91  *
92  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
93  */
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 /**
105  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
106  *
107  * Based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, SafeMath {
111   /* Token supply got increased and a new owner received these tokens */
112   event Minted(address receiver, uint amount);
113   /* Actual balances of token holders */
114   mapping(address => uint) balances;
115   /* approve() allowances */
116   mapping (address => mapping (address => uint)) allowed;
117   /* Interface declaration */
118   function isToken() public constant returns (bool weAre) {
119     return true;
120   }
121   function transfer(address _to, uint _value) returns (bool success) {
122     balances[msg.sender] = safeSub(balances[msg.sender], _value);
123     balances[_to] = safeAdd(balances[_to], _value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
128     uint _allowance = allowed[_from][msg.sender];
129     balances[_to] = safeAdd(balances[_to], _value);
130     balances[_from] = safeSub(balances[_from], _value);
131     allowed[_from][msg.sender] = safeSub(_allowance, _value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135   function balanceOf(address _owner) constant returns (uint balance) {
136     return balances[_owner];
137   }
138   function approve(address _spender, uint _value) returns (bool success) {
139     // To change the approve amount you first have to reduce the addresses`
140     //  allowance to zero by calling `approve(_spender, 0)` if it is not
141     //  already 0 to mitigate the race condition described here:
142     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148   function allowance(address _owner, address _spender) constant returns (uint remaining) {
149     return allowed[_owner][_spender];
150   }
151 }
152 /**
153  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
154  *
155  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
156  */
157 /**
158  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
159  *
160  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
161  */
162 /**
163  * Upgrade agent interface inspired by Lunyr.
164  *
165  * Upgrade agent transfers tokens to a new contract.
166  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
167  */
168 contract UpgradeAgent {
169   uint public originalSupply;
170   /** Interface marker */
171   function isUpgradeAgent() public constant returns (bool) {
172     return true;
173   }
174   function upgradeFrom(address _from, uint256 _value) public;
175 }
176 /**
177  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
178  *
179  * First envisioned by Golem and Lunyr projects.
180  */
181 contract UpgradeableToken is StandardToken {
182   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
183   address public upgradeMaster;
184   /** The next contract where the tokens will be migrated. */
185   UpgradeAgent public upgradeAgent;
186   /** How many tokens we have upgraded by now. */
187   uint256 public totalUpgraded;
188   /**
189    * Upgrade states.
190    *
191    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
192    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
193    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
194    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
195    *
196    */
197   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
198   /**
199    * Somebody has upgraded some of his tokens.
200    */
201   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
202   /**
203    * New upgrade agent available.
204    */
205   event UpgradeAgentSet(address agent);
206   /**
207    * Do not allow construction without upgrade master set.
208    */
209   function UpgradeableToken(address _upgradeMaster) {
210     upgradeMaster = _upgradeMaster;
211   }
212   /**
213    * Allow the token holder to upgrade some of their tokens to a new contract.
214    */
215   function upgrade(uint256 value) public {
216       UpgradeState state = getUpgradeState();
217       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
218         // Called in a bad state
219         throw;
220       }
221       // Validate input value.
222       if (value == 0) throw;
223       balances[msg.sender] = safeSub(balances[msg.sender], value);
224       // Take tokens out from circulation
225       totalSupply = safeSub(totalSupply, value);
226       totalUpgraded = safeAdd(totalUpgraded, value);
227       // Upgrade agent reissues the tokens
228       upgradeAgent.upgradeFrom(msg.sender, value);
229       Upgrade(msg.sender, upgradeAgent, value);
230   }
231   /**
232    * Set an upgrade agent that handles
233    */
234   function setUpgradeAgent(address agent) external {
235       if(!canUpgrade()) {
236         // The token is not yet in a state that we could think upgrading
237         throw;
238       }
239       if (agent == 0x0) throw;
240       // Only a master can designate the next agent
241       if (msg.sender != upgradeMaster) throw;
242       // Upgrade has already begun for an agent
243       if (getUpgradeState() == UpgradeState.Upgrading) throw;
244       upgradeAgent = UpgradeAgent(agent);
245       // Bad interface
246       if(!upgradeAgent.isUpgradeAgent()) throw;
247       // Make sure that token supplies match in source and target
248       if (upgradeAgent.originalSupply() != totalSupply) throw;
249       UpgradeAgentSet(upgradeAgent);
250   }
251   /**
252    * Get the state of the token upgrade.
253    */
254   function getUpgradeState() public constant returns(UpgradeState) {
255     if(!canUpgrade()) return UpgradeState.NotAllowed;
256     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
257     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
258     else return UpgradeState.Upgrading;
259   }
260   /**
261    * Change the upgrade master.
262    *
263    * This allows us to set a new owner for the upgrade mechanism.
264    */
265   function setUpgradeMaster(address master) public {
266       if (master == 0x0) throw;
267       if (msg.sender != upgradeMaster) throw;
268       upgradeMaster = master;
269   }
270   /**
271    * Child contract can enable to provide the condition when the upgrade can begun.
272    */
273   function canUpgrade() public constant returns(bool) {
274      return true;
275   }
276 }
277 /**
278  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
279  *
280  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
281  */
282 /**
283  * Define interface for releasing the token transfer after a successful crowdsale.
284  */
285 contract ReleasableToken is ERC20, Ownable {
286   /* The finalizer contract that allows unlift the transfer limits on this token */
287   address public releaseAgent;
288   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
289   bool public released = false;
290   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
291   mapping (address => bool) public transferAgents;
292   /**
293    * Limit token transfer until the crowdsale is over.
294    *
295    */
296   modifier canTransfer(address _sender) {
297     if(!released) {
298         if(!transferAgents[_sender]) {
299             throw;
300         }
301     }
302     _;
303   }
304   /**
305    * Set the contract that can call release and make the token transferable.
306    *
307    * Design choice. Allow reset the release agent to fix fat finger mistakes.
308    */
309   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
310     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
311     releaseAgent = addr;
312   }
313   /**
314    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
315    */
316   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
317     transferAgents[addr] = state;
318   }
319   /**
320    * One way function to release the tokens to the wild.
321    *
322    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
323    */
324   function releaseTokenTransfer() public onlyReleaseAgent {
325     released = true;
326   }
327   /** The function can be called only before or after the tokens have been releasesd */
328   modifier inReleaseState(bool releaseState) {
329     if(releaseState != released) {
330         throw;
331     }
332     _;
333   }
334   /** The function can be called only by a whitelisted release agent. */
335   modifier onlyReleaseAgent() {
336     if(msg.sender != releaseAgent) {
337         throw;
338     }
339     _;
340   }
341   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
342     // Call StandardToken.transfer()
343    return super.transfer(_to, _value);
344   }
345   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
346     // Call StandardToken.transferForm()
347     return super.transferFrom(_from, _to, _value);
348   }
349 }
350 /**
351  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
352  *
353  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
354  */
355 /**
356  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
357  *
358  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
359  */
360 /**
361  * Safe unsigned safe math.
362  *
363  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
364  *
365  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
366  *
367  * Maintained here until merged to mainline zeppelin-solidity.
368  *
369  */
370 library SafeMathLibExt {
371   function times(uint a, uint b) returns (uint) {
372     uint c = a * b;
373     assert(a == 0 || c / a == b);
374     return c;
375   }
376   function divides(uint a, uint b) returns (uint) {
377     assert(b > 0);
378     uint c = a / b;
379     assert(a == b * c + a % b);
380     return c;
381   }
382   function minus(uint a, uint b) returns (uint) {
383     assert(b <= a);
384     return a - b;
385   }
386   function plus(uint a, uint b) returns (uint) {
387     uint c = a + b;
388     assert(c>=a);
389     return c;
390   }
391 }
392 /**
393  * A token that can increase its supply by another contract.
394  *
395  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
396  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
397  *
398  */
399 contract MintableTokenExt is StandardToken, Ownable {
400   using SafeMathLibExt for uint;
401   bool public mintingFinished = false;
402   /** List of agents that are allowed to create new tokens */
403   mapping (address => bool) public mintAgents;
404   event MintingAgentChanged(address addr, bool state  );
405   struct ReservedTokensData {
406     uint inTokens;
407     uint inPercentage;
408   }
409   mapping (address => ReservedTokensData) public reservedTokensList;
410   address[] public reservedTokensDestinations;
411   uint public reservedTokensDestinationsLen = 0;
412   function setReservedTokensList(address addr, uint inTokens, uint inPercentage) onlyOwner {
413     reservedTokensDestinations.push(addr);
414     reservedTokensDestinationsLen++;
415     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentage:inPercentage});
416   }
417   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
418     return reservedTokensList[addr].inTokens;
419   }
420   function getReservedTokensListValInPercentage(address addr) constant returns (uint inPercentage) {
421     return reservedTokensList[addr].inPercentage;
422   }
423   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentage) onlyOwner {
424     for (uint iterator = 0; iterator < addrs.length; iterator++) {
425       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentage[iterator]);
426     }
427   }
428   /**
429    * Create new tokens and allocate them to an address..
430    *
431    * Only callably by a crowdsale contract (mint agent).
432    */
433   function mint(address receiver, uint amount) onlyMintAgent canMint public {
434     totalSupply = totalSupply.plus(amount);
435     balances[receiver] = balances[receiver].plus(amount);
436     // This will make the mint transaction apper in EtherScan.io
437     // We can remove this after there is a standardized minting event
438     Transfer(0, receiver, amount);
439   }
440   /**
441    * Owner can allow a crowdsale contract to mint new tokens.
442    */
443   function setMintAgent(address addr, bool state) onlyOwner canMint public {
444     mintAgents[addr] = state;
445     MintingAgentChanged(addr, state);
446   }
447   modifier onlyMintAgent() {
448     // Only crowdsale contracts are allowed to mint new tokens
449     if(!mintAgents[msg.sender]) {
450         throw;
451     }
452     _;
453   }
454   /** Make sure we are not done yet. */
455   modifier canMint() {
456     if(mintingFinished) throw;
457     _;
458   }
459 }
460 /**
461  * A crowdsaled token.
462  *
463  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
464  *
465  * - The token transfer() is disabled until the crowdsale is over
466  * - The token contract gives an opt-in upgrade path to a new contract
467  * - The same token can be part of several crowdsales through approve() mechanism
468  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
469  *
470  */
471 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
472   /** Name and symbol were updated. */
473   event UpdatedTokenInformation(string newName, string newSymbol);
474   string public name;
475   string public symbol;
476   uint public decimals;
477   /* Minimum ammount of tokens every buyer can buy. */
478   uint public minCap;
479   /**
480    * Construct the token.
481    *
482    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
483    *
484    * @param _name Token name
485    * @param _symbol Token symbol - should be all caps
486    * @param _initialSupply How many tokens we start with
487    * @param _decimals Number of decimal places
488    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
489    */
490   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
491     UpgradeableToken(msg.sender) {
492     // Create any address, can be transferred
493     // to team multisig via changeOwner(),
494     // also remember to call setUpgradeMaster()
495     owner = msg.sender;
496     name = _name;
497     symbol = _symbol;
498     totalSupply = _initialSupply;
499     decimals = _decimals;
500     minCap = _globalMinCap;
501     // Create initially all balance on the team multisig
502     balances[owner] = totalSupply;
503     if(totalSupply > 0) {
504       Minted(owner, totalSupply);
505     }
506     // No more new supply allowed after the token creation
507     if(!_mintable) {
508       mintingFinished = true;
509       if(totalSupply == 0) {
510         throw; // Cannot create a token without supply and no minting
511       }
512     }
513   }
514   /**
515    * When token is released to be transferable, enforce no new tokens can be created.
516    */
517   function releaseTokenTransfer() public onlyReleaseAgent {
518     mintingFinished = true;
519     super.releaseTokenTransfer();
520   }
521   /**
522    * Allow upgrade agent functionality kick in only if the crowdsale was success.
523    */
524   function canUpgrade() public constant returns(bool) {
525     return released && super.canUpgrade();
526   }
527   /**
528    * Owner can update token information here.
529    *
530    * It is often useful to conceal the actual token association, until
531    * the token operations, like central issuance or reissuance have been completed.
532    *
533    * This function allows the token owner to rename the token after the operations
534    * have been completed and then point the audience to use the token contract.
535    */
536   function setTokenInformation(string _name, string _symbol) onlyOwner {
537     name = _name;
538     symbol = _symbol;
539     UpdatedTokenInformation(name, symbol);
540   }
541 }