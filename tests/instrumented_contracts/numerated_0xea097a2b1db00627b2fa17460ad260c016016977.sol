1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
46 /**
47  * Math operations with safety checks
48  */
49 contract SafeMath {
50   function safeMul(uint a, uint b) internal returns (uint) {
51     uint c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55   function safeDiv(uint a, uint b) internal returns (uint) {
56     assert(b > 0);
57     uint c = a / b;
58     assert(a == b * c + a % b);
59     return c;
60   }
61   function safeSub(uint a, uint b) internal returns (uint) {
62     assert(b <= a);
63     return a - b;
64   }
65   function safeAdd(uint a, uint b) internal returns (uint) {
66     uint c = a + b;
67     assert(c>=a && c>=b);
68     return c;
69   }
70   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a >= b ? a : b;
72   }
73   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
74     return a < b ? a : b;
75   }
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
80     return a < b ? a : b;
81   }
82 }
83 /**
84  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
85  *
86  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
87  */
88 /**
89  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
90  *
91  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
92  */
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public constant returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 /**
104  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
105  *
106  * Based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, SafeMath {
110   /* Token supply got increased and a new owner received these tokens */
111   event Minted(address receiver, uint amount);
112   /* Actual balances of token holders */
113   mapping(address => uint) balances;
114   /* approve() allowances */
115   mapping (address => mapping (address => uint)) allowed;
116   /* Interface declaration */
117   function isToken() public constant returns (bool weAre) {
118     return true;
119   }
120   function transfer(address _to, uint _value) returns (bool success) {
121     balances[msg.sender] = safeSub(balances[msg.sender], _value);
122     balances[_to] = safeAdd(balances[_to], _value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
127     uint _allowance = allowed[_from][msg.sender];
128     balances[_to] = safeAdd(balances[_to], _value);
129     balances[_from] = safeSub(balances[_from], _value);
130     allowed[_from][msg.sender] = safeSub(_allowance, _value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134   function balanceOf(address _owner) constant returns (uint balance) {
135     return balances[_owner];
136   }
137   function approve(address _spender, uint _value) returns (bool success) {
138     // To change the approve amount you first have to reduce the addresses`
139     //  allowance to zero by calling `approve(_spender, 0)` if it is not
140     //  already 0 to mitigate the race condition described here:
141     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147   function allowance(address _owner, address _spender) constant returns (uint remaining) {
148     return allowed[_owner][_spender];
149   }
150 }
151 /**
152  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
153  *
154  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
155  */
156 /**
157  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
158  *
159  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
160  */
161 /**
162  * Upgrade agent interface inspired by Lunyr.
163  *
164  * Upgrade agent transfers tokens to a new contract.
165  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
166  */
167 contract UpgradeAgent {
168   uint public originalSupply;
169   /** Interface marker */
170   function isUpgradeAgent() public constant returns (bool) {
171     return true;
172   }
173   function upgradeFrom(address _from, uint256 _value) public;
174 }
175 /**
176  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
177  *
178  * First envisioned by Golem and Lunyr projects.
179  */
180 contract UpgradeableToken is StandardToken {
181   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
182   address public upgradeMaster;
183   /** The next contract where the tokens will be migrated. */
184   UpgradeAgent public upgradeAgent;
185   /** How many tokens we have upgraded by now. */
186   uint256 public totalUpgraded;
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
197   /**
198    * Somebody has upgraded some of his tokens.
199    */
200   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
201   /**
202    * New upgrade agent available.
203    */
204   event UpgradeAgentSet(address agent);
205   /**
206    * Do not allow construction without upgrade master set.
207    */
208   function UpgradeableToken(address _upgradeMaster) {
209     upgradeMaster = _upgradeMaster;
210   }
211   /**
212    * Allow the token holder to upgrade some of their tokens to a new contract.
213    */
214   function upgrade(uint256 value) public {
215       UpgradeState state = getUpgradeState();
216       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
217         // Called in a bad state
218         throw;
219       }
220       // Validate input value.
221       if (value == 0) throw;
222       balances[msg.sender] = safeSub(balances[msg.sender], value);
223       // Take tokens out from circulation
224       totalSupply = safeSub(totalSupply, value);
225       totalUpgraded = safeAdd(totalUpgraded, value);
226       // Upgrade agent reissues the tokens
227       upgradeAgent.upgradeFrom(msg.sender, value);
228       Upgrade(msg.sender, upgradeAgent, value);
229   }
230   /**
231    * Set an upgrade agent that handles
232    */
233   function setUpgradeAgent(address agent) external {
234       if(!canUpgrade()) {
235         // The token is not yet in a state that we could think upgrading
236         throw;
237       }
238       if (agent == 0x0) throw;
239       // Only a master can designate the next agent
240       if (msg.sender != upgradeMaster) throw;
241       // Upgrade has already begun for an agent
242       if (getUpgradeState() == UpgradeState.Upgrading) throw;
243       upgradeAgent = UpgradeAgent(agent);
244       // Bad interface
245       if(!upgradeAgent.isUpgradeAgent()) throw;
246       // Make sure that token supplies match in source and target
247       if (upgradeAgent.originalSupply() != totalSupply) throw;
248       UpgradeAgentSet(upgradeAgent);
249   }
250   /**
251    * Get the state of the token upgrade.
252    */
253   function getUpgradeState() public constant returns(UpgradeState) {
254     if(!canUpgrade()) return UpgradeState.NotAllowed;
255     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
256     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
257     else return UpgradeState.Upgrading;
258   }
259   /**
260    * Change the upgrade master.
261    *
262    * This allows us to set a new owner for the upgrade mechanism.
263    */
264   function setUpgradeMaster(address master) public {
265       if (master == 0x0) throw;
266       if (msg.sender != upgradeMaster) throw;
267       upgradeMaster = master;
268   }
269   /**
270    * Child contract can enable to provide the condition when the upgrade can begun.
271    */
272   function canUpgrade() public constant returns(bool) {
273      return true;
274   }
275 }
276 /**
277  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
278  *
279  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
280  */
281 /**
282  * Define interface for releasing the token transfer after a successful crowdsale.
283  */
284 contract ReleasableToken is ERC20, Ownable {
285   /* The finalizer contract that allows unlift the transfer limits on this token */
286   address public releaseAgent;
287   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
288   bool public released = false;
289   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
290   mapping (address => bool) public transferAgents;
291   /**
292    * Limit token transfer until the crowdsale is over.
293    *
294    */
295   modifier canTransfer(address _sender) {
296     if(!released) {
297         if(!transferAgents[_sender]) {
298             throw;
299         }
300     }
301     _;
302   }
303   /**
304    * Set the contract that can call release and make the token transferable.
305    *
306    * Design choice. Allow reset the release agent to fix fat finger mistakes.
307    */
308   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
309     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
310     releaseAgent = addr;
311   }
312   /**
313    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
314    */
315   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
316     transferAgents[addr] = state;
317   }
318   /**
319    * One way function to release the tokens to the wild.
320    *
321    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
322    */
323   function releaseTokenTransfer() public onlyReleaseAgent {
324     released = true;
325   }
326   /** The function can be called only before or after the tokens have been releasesd */
327   modifier inReleaseState(bool releaseState) {
328     if(releaseState != released) {
329         throw;
330     }
331     _;
332   }
333   /** The function can be called only by a whitelisted release agent. */
334   modifier onlyReleaseAgent() {
335     if(msg.sender != releaseAgent) {
336         throw;
337     }
338     _;
339   }
340   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
341     // Call StandardToken.transfer()
342    return super.transfer(_to, _value);
343   }
344   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
345     // Call StandardToken.transferForm()
346     return super.transferFrom(_from, _to, _value);
347   }
348 }
349 /**
350  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
351  *
352  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
353  */
354 /**
355  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
356  *
357  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
358  */
359 /**
360  * Safe unsigned safe math.
361  *
362  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
363  *
364  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
365  *
366  * Maintained here until merged to mainline zeppelin-solidity.
367  *
368  */
369 library SafeMathLibExt {
370   function times(uint a, uint b) returns (uint) {
371     uint c = a * b;
372     assert(a == 0 || c / a == b);
373     return c;
374   }
375   function divides(uint a, uint b) returns (uint) {
376     assert(b > 0);
377     uint c = a / b;
378     assert(a == b * c + a % b);
379     return c;
380   }
381   function minus(uint a, uint b) returns (uint) {
382     assert(b <= a);
383     return a - b;
384   }
385   function plus(uint a, uint b) returns (uint) {
386     uint c = a + b;
387     assert(c>=a);
388     return c;
389   }
390 }
391 /**
392  * A token that can increase its supply by another contract.
393  *
394  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
395  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
396  *
397  */
398 contract MintableTokenExt is StandardToken, Ownable {
399   using SafeMathLibExt for uint;
400   bool public mintingFinished = false;
401   /** List of agents that are allowed to create new tokens */
402   mapping (address => bool) public mintAgents;
403   event MintingAgentChanged(address addr, bool state  );
404   struct ReservedTokensData {
405     uint inTokens;
406     uint inPercentage;
407   }
408   mapping (address => ReservedTokensData) public reservedTokensList;
409   address[] public reservedTokensDestinations;
410   uint public reservedTokensDestinationsLen = 0;
411   function setReservedTokensList(address addr, uint inTokens, uint inPercentage) onlyOwner {
412     reservedTokensDestinations.push(addr);
413     reservedTokensDestinationsLen++;
414     reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentage:inPercentage});
415   }
416   function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
417     return reservedTokensList[addr].inTokens;
418   }
419   function getReservedTokensListValInPercentage(address addr) constant returns (uint inPercentage) {
420     return reservedTokensList[addr].inPercentage;
421   }
422   function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentage) onlyOwner {
423     for (uint iterator = 0; iterator < addrs.length; iterator++) {
424       setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentage[iterator]);
425     }
426   }
427   /**
428    * Create new tokens and allocate them to an address..
429    *
430    * Only callably by a crowdsale contract (mint agent).
431    */
432   function mint(address receiver, uint amount) onlyMintAgent canMint public {
433     totalSupply = totalSupply.plus(amount);
434     balances[receiver] = balances[receiver].plus(amount);
435     // This will make the mint transaction apper in EtherScan.io
436     // We can remove this after there is a standardized minting event
437     Transfer(0, receiver, amount);
438   }
439   /**
440    * Owner can allow a crowdsale contract to mint new tokens.
441    */
442   function setMintAgent(address addr, bool state) onlyOwner canMint public {
443     mintAgents[addr] = state;
444     MintingAgentChanged(addr, state);
445   }
446   modifier onlyMintAgent() {
447     // Only crowdsale contracts are allowed to mint new tokens
448     if(!mintAgents[msg.sender]) {
449         throw;
450     }
451     _;
452   }
453   /** Make sure we are not done yet. */
454   modifier canMint() {
455     if(mintingFinished) throw;
456     _;
457   }
458 }
459 /**
460  * A crowdsaled token.
461  *
462  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
463  *
464  * - The token transfer() is disabled until the crowdsale is over
465  * - The token contract gives an opt-in upgrade path to a new contract
466  * - The same token can be part of several crowdsales through approve() mechanism
467  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
468  *
469  */
470 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
471   /** Name and symbol were updated. */
472   event UpdatedTokenInformation(string newName, string newSymbol);
473   string public name;
474   string public symbol;
475   uint public decimals;
476   /* Minimum ammount of tokens every buyer can buy. */
477   uint public minCap;
478   /**
479    * Construct the token.
480    *
481    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
482    *
483    * @param _name Token name
484    * @param _symbol Token symbol - should be all caps
485    * @param _initialSupply How many tokens we start with
486    * @param _decimals Number of decimal places
487    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
488    */
489   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
490     UpgradeableToken(msg.sender) {
491     // Create any address, can be transferred
492     // to team multisig via changeOwner(),
493     // also remember to call setUpgradeMaster()
494     owner = msg.sender;
495     name = _name;
496     symbol = _symbol;
497     totalSupply = _initialSupply;
498     decimals = _decimals;
499     minCap = _globalMinCap;
500     // Create initially all balance on the team multisig
501     balances[owner] = totalSupply;
502     if(totalSupply > 0) {
503       Minted(owner, totalSupply);
504     }
505     // No more new supply allowed after the token creation
506     if(!_mintable) {
507       mintingFinished = true;
508       if(totalSupply == 0) {
509         throw; // Cannot create a token without supply and no minting
510       }
511     }
512   }
513   /**
514    * When token is released to be transferable, enforce no new tokens can be created.
515    */
516   function releaseTokenTransfer() public onlyReleaseAgent {
517     mintingFinished = true;
518     super.releaseTokenTransfer();
519   }
520   /**
521    * Allow upgrade agent functionality kick in only if the crowdsale was success.
522    */
523   function canUpgrade() public constant returns(bool) {
524     return released && super.canUpgrade();
525   }
526   /**
527    * Owner can update token information here.
528    *
529    * It is often useful to conceal the actual token association, until
530    * the token operations, like central issuance or reissuance have been completed.
531    *
532    * This function allows the token owner to rename the token after the operations
533    * have been completed and then point the audience to use the token contract.
534    */
535   function setTokenInformation(string _name, string _symbol) onlyOwner {
536     name = _name;
537     symbol = _symbol;
538     UpdatedTokenInformation(name, symbol);
539   }
540 }