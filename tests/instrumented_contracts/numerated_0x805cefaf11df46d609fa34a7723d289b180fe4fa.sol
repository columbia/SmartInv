1 /**
2  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
6  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
7  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
8  */
9 pragma solidity ^0.4.11;
10 
11 /**
12  * Centrally issued Ethereum token.
13  *
14  * We mix in burnable and upgradeable traits.
15  *
16  * Token supply is created in the token contract creation and allocated to owner.
17  * The owner can then transfer from its supply to crowdsale participants.
18  * The owner, or anybody, can burn any excessive tokens they are holding.
19  *
20  */
21 
22 /**
23  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
24  *
25  *  Code is based on multiple sources:
26  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
27  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
28  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
29  */
30 
31 
32 /**
33  * @title ERC20Basic
34  * @dev Simpler version of ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20Basic {
38   uint256 public totalSupply;
39   function balanceOf(address who) constant returns (uint256);
40   function transfer(address to, uint256 value) returns (bool success);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 
45 /**
46  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
47  *
48  *  Code is based on multiple sources:
49  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
50  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
51  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
52  */
53 
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint256);
61   function transferFrom(address from, address to, uint256 value) returns (bool success);
62   function approve(address spender, uint256 value) returns (bool success);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 /**
68  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
69  *
70  *  Code is based on multiple sources:
71  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
72  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
73  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
74  */
75 
76 contract ErrorHandler {
77     bool public isInTestMode = false;
78     event evRecord(address msg_sender, uint msg_value, string message);
79 
80     function doThrow(string message) internal {
81         evRecord(msg.sender, msg.value, message);
82         if (!isInTestMode) {
83         	throw;
84 		}
85     }
86 }
87 
88 /**
89  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
90  *
91  *  Code is based on multiple sources:
92  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
93  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
94  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
95  */
96 
97 /**
98  * Math operations with safety checks
99  */
100 library SafeMath {
101   function mul(uint256 a, uint256 b) internal returns (uint256) {
102     uint256 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 
125   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
126     return a >= b ? a : b;
127   }
128 
129   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
130     return a < b ? a : b;
131   }
132 
133   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
134     return a >= b ? a : b;
135   }
136 
137   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
138     return a < b ? a : b;
139   }
140 
141 }
142 
143 
144 /**
145  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
146  *
147  *  Code is based on multiple sources:
148  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
149  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
150  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
151  */
152 
153 
154 /**
155  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
156  *
157  * Based on code by FirstBlood:
158  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract NTRYStandardToken is ERC20, ErrorHandler {
161   address public owner;
162 
163   /* NTRY functional is paused if there is any emergency */
164   bool public emergency = false;
165 
166   using SafeMath for uint;
167 
168   /* Actual balances of token holders */
169   mapping(address => uint) balances;
170 
171   /* approve() allowances */
172   mapping (address => mapping (address => uint)) allowed;
173   
174   /* freezeAccount() frozen() */
175   mapping (address => bool) frozenAccount;
176 
177   /* Notify account frozen activity */
178   event FrozenFunds(address target, bool frozen);
179 
180   /* Interface declaration */
181   function isToken() public constant returns (bool weAre) {
182     return true;
183   }
184 
185   /**
186    * @dev Throws if called by any account other than the owner. 
187    */
188   modifier onlyOwner() {
189     if (msg.sender != owner) {
190       doThrow("Only Owner!");
191     }
192     _;
193   }
194 
195   /**
196    * Fix for the ERC20 short address attack
197    *
198    * http://vessenes.com/the-erc20-short-address-attack-explained/
199    */
200   modifier onlyPayloadSize(uint size) {
201      if(msg.data.length < size + 4) {
202        doThrow("Short address attack!");
203      }
204      _;
205   }
206 
207   modifier stopInEmergency {
208     if (emergency){
209         doThrow("Emergency state!");
210     }
211     _;
212   }
213   
214   function transfer(address _to, uint _value) stopInEmergency onlyPayloadSize(2 * 32) returns (bool success) {
215     // Check if frozen //
216     if (frozenAccount[msg.sender]) doThrow("Account freezed!");  
217                   
218     balances[msg.sender] = balances[msg.sender].sub( _value);
219     balances[_to] = balances[_to].add(_value);
220     Transfer(msg.sender, _to, _value);
221     return true;
222   }
223 
224   function transferFrom(address _from, address _to, uint _value) stopInEmergency returns (bool success) {
225     // Check if frozen //
226     if (frozenAccount[_from]) doThrow("Account freezed!");
227 
228     uint _allowance = allowed[_from][msg.sender];
229 
230     balances[_to] = balances[_to].add(_value);
231     balances[_from] = balances[_from].sub(_value);
232     allowed[_from][msg.sender] = _allowance.sub(_value);
233     Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   function balanceOf(address _owner) constant returns (uint balance) {
238     return balances[_owner];
239   }
240 
241   function approve(address _spender, uint _value) stopInEmergency returns (bool success) {
242 
243     // To change the approve amount you first have to reduce the addresses`
244     //  allowance to zero by calling `approve(_spender, 0)` if it is not
245     //  already 0 to mitigate the race condition described here:
246     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) doThrow("Allowance race condition!");
248 
249     allowed[msg.sender][_spender] = _value;
250     Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   function allowance(address _owner, address _spender) constant returns (uint remaining) {
255     return allowed[_owner][_spender];
256   }
257 
258 
259   /**
260   * It is called Circuit Breakers (Pause contract functionality), it stop execution if certain conditions are met, 
261   * and can be useful when new errors are discovered. For example, most actions may be suspended in a contract if a 
262   * bug is discovered, so the most feasible option to stop and updated migration message about launching an updated version of contract. 
263   * @param _stop Switch the circuite breaker on or off
264   */
265   function emergencyStop(bool _stop) onlyOwner {
266       emergency = _stop;
267   }
268 
269   /**
270   * Owner can set any account into freeze state. It is helpful in case if account holder has 
271   * lost his key and he want administrator to freeze account until account key is recovered
272   * @param target The account address
273   * @param freeze The state of account
274   */
275   function freezeAccount(address target, bool freeze) onlyOwner {
276       frozenAccount[target] = freeze;
277       FrozenFunds(target, freeze);
278   }
279 
280   function frozen(address _target) constant returns (bool frozen) {
281     return frozenAccount[_target];
282   }
283 
284   /**
285    * @dev Allows the current owner to transfer control of the contract to a newOwner.
286    * @param newOwner The address to transfer ownership to. 
287    */
288   function transferOwnership(address newOwner) onlyOwner {
289     if (newOwner != address(0)) {
290       balances[newOwner] = balances[owner];
291       balances[owner] = 0;
292       owner = newOwner;
293       Transfer(owner, newOwner,balances[newOwner]);
294     }
295   }
296 
297 }
298 
299 
300 /**
301  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
302  *
303  *  Code is based on multiple sources:
304  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
305  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
306  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
307  */
308 
309 /**
310  * Upgrade agent interface inspired by Lunyr.
311  *
312  * Upgrade agent transfers tokens to a new contract.
313  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
314  */
315 contract UpgradeAgent {
316 
317   uint public originalSupply;
318 
319   /** Interface marker */
320   function isUpgradeAgent() public constant returns (bool) {
321     return true;
322   }
323 
324   function upgradeFrom(address _from, uint256 _value) public;
325 
326 }
327 
328 
329 /**
330  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
331  *
332  *  Code is based on multiple sources:
333  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
334  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
335  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
336  */
337 
338 
339 /**
340  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
341  *
342  * First envisioned by Golem and Lunyr projects.
343  */
344 contract UpgradeableToken is NTRYStandardToken {
345 
346   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
347   address public upgradeMaster;
348 
349   /** The next contract where the tokens will be migrated. */
350   UpgradeAgent public upgradeAgent;
351 
352   /** How many tokens we have upgraded by now. */
353   uint256 public totalUpgraded;
354 
355   /**
356    * Upgrade states.
357    *
358    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
359    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
360    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
361    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
362    *
363    */
364   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
365 
366   /**
367    * Somebody has upgraded some of his tokens.
368    */
369   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
370 
371   /**
372    * New upgrade agent available.
373    */
374   event UpgradeAgentSet(address agent);
375 
376   /**
377    * Do not allow construction without upgrade master set.
378    */
379   function UpgradeableToken(address _upgradeMaster) {
380     upgradeMaster = _upgradeMaster;
381   }
382 
383   /**
384    * Allow the token holder to upgrade some of their tokens to a new contract.
385    */
386   function upgrade(uint256 value) public {
387 
388       UpgradeState state = getUpgradeState();
389       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
390         doThrow("Called in a bad state!");
391       }
392 
393       // Validate input value.
394       if (value == 0) doThrow("Value to upgrade is zero!");
395 
396       balances[msg.sender] = balances[msg.sender].sub(value);
397 
398       // Take tokens out from circulation
399       totalSupply = totalSupply.sub(value);
400       totalUpgraded = totalUpgraded.add(value);
401 
402       // Upgrade agent reissues the tokens
403       upgradeAgent.upgradeFrom(msg.sender, value);
404       Upgrade(msg.sender, upgradeAgent, value);
405   }
406 
407   /**
408    * Set an upgrade agent that handles
409    */
410   function setUpgradeAgent(address agent) external {
411 
412       if(!canUpgrade()) {
413         // The token is not yet in a state that we could think upgrading
414         doThrow("Token state is not feasible for upgrading yet!");
415       }
416 
417       if (agent == 0x0) doThrow("Invalid address!");
418       // Only a master can designate the next agent
419       if (msg.sender != upgradeMaster) doThrow("Only upgrade master!");
420       // Upgrade has already begun for an agent
421       if (getUpgradeState() == UpgradeState.Upgrading) doThrow("Upgrade started already!");
422 
423       upgradeAgent = UpgradeAgent(agent);
424 
425       // Bad interface
426       if(!upgradeAgent.isUpgradeAgent()) doThrow("Bad interface!");
427       // Make sure that token supplies match in source and target
428       if (upgradeAgent.originalSupply() != totalSupply) doThrow("Total supply source is not equall to target!");
429 
430       UpgradeAgentSet(upgradeAgent);
431   }
432 
433   /**
434    * Get the state of the token upgrade.
435    */
436   function getUpgradeState() public constant returns(UpgradeState) {
437     if(!canUpgrade()) return UpgradeState.NotAllowed;
438     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
439     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
440     else return UpgradeState.Upgrading;
441   }
442 
443   /**
444    * Change the upgrade master.
445    *
446    * This allows us to set a new owner for the upgrade mechanism.
447    */
448   function setUpgradeMaster(address master) public {
449       if (master == 0x0) doThrow("Invalid address of upgrade master!");
450       if (msg.sender != upgradeMaster) doThrow("Only upgrade master!");
451       upgradeMaster = master;
452   }
453 
454   /**
455    * Child contract can enable to provide the condition when the upgrade can begun.
456    */
457   function canUpgrade() public constant returns(bool) {
458      return true;
459   }
460 
461 }
462 
463 /**
464  *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
465  *
466  *  Code is based on multiple sources:
467  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
468  *  https://github.com/TokenMarketNet/ico/blob/master/contracts
469  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
470  */
471 
472 
473 contract BurnableToken is NTRYStandardToken {
474 
475   address public constant BURN_ADDRESS = 0;
476 
477   /** How many tokens we burned */
478   event Burned(address burner, uint burnedAmount);
479 
480   /**
481    * Burn extra tokens from a balance.
482    *
483    */
484   function burn(uint burnAmount) {
485     address burner = msg.sender;
486     balances[burner] = balances[burner].sub(burnAmount);
487     totalSupply = totalSupply.sub(burnAmount);
488     Burned(burner, burnAmount);
489   }
490 }
491 
492 
493 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
494 
495   string public name;
496   string public symbol;
497   uint public decimals;
498 
499   function CentrallyIssuedToken() UpgradeableToken(owner) {
500     name = "Notary Platform Token";
501     symbol = "NTRY";
502     decimals = 18;
503     owner = 0x1538EF80213cde339A333Ee420a85c21905b1b2D;
504 
505     totalSupply = 150000000 * 1 ether;
506     
507     // Allocate initial balance to the owner //
508     balances[owner] = 150000000 * 1 ether;
509 
510     // Freeze notary team funds for one year (One month with pre ico already passed)//
511     unlockedAt =  now + 330 * 1 days;
512   }
513 
514   uint256 public constant teamAllocations = 15000000 * 1 ether;
515   uint256 public unlockedAt;
516   mapping (address => uint256) allocations;
517   function allocate() public {
518       allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 2500000 * 1 ether;
519       allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 2500000 * 1 ether;
520       allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 2500000 * 1 ether;
521       allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 2500000 * 1 ether;
522       allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 500000 * 1 ether;
523       allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 500000 * 1 ether;
524       allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 250000 * 1 ether;
525       allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 250000 * 1 ether;
526       allocations[0xF9b1Cfc7fe3B63bEDc594AD20132CB06c18FD5F2] = 250000 * 1 ether;
527       allocations[0xDbb89a87d9f91EA3f0Ab035a67E3A951A05d0130] = 250000 * 1 ether;
528       allocations[0xC1530645E21D27AB4b567Bac348721eE3E244Cbd] = 200000 * 1 ether;
529       allocations[0xcfb44162030e6CBca88e65DffA21911e97ce8533] = 200000 * 1 ether;
530       allocations[0x64f748a5C5e504DbDf61d49282d6202Bc1311c3E] = 200000 * 1 ether;
531       allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 200000 * 1 ether;
532       allocations[0xC9856112DCb8eE449B83604438611EdCf61408AF] = 200000 * 1 ether;
533       allocations[0x689CCfEABD99081D061aE070b1DA5E1f6e4B9fB2] = 2000000 * 1 ether;
534   }
535 
536   function withDraw() public {
537       if(now < unlockedAt){ 
538           doThrow("Allocations are freezed!");
539       }
540       if (allocations[msg.sender] == 0){
541           doThrow("No allocation found!");
542       }
543       balances[owner] -= allocations[msg.sender];
544       balances[msg.sender] += allocations[msg.sender];
545       Transfer(owner, msg.sender, allocations[msg.sender]);
546       allocations[msg.sender] = 0;
547       
548   }
549   
550    function () {
551         //if ether is sent to this address, send it back.
552         throw;
553     }
554   
555 }