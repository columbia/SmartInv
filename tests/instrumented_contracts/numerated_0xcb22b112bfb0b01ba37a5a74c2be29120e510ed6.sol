1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function allowance(address owner, address spender) constant returns (uint);
12 
13   function transfer(address to, uint value) returns (bool ok);
14   function transferFrom(address from, address to, uint value) returns (bool ok);
15   function approve(address spender, uint value) returns (bool ok);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 
21 
22 /**
23  * Math operations with safety checks
24  */
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 
74 
75 /**
76  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
77  *
78  * Based on code by FirstBlood:
79  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
80  */
81 contract StandardToken is ERC20, SafeMath {
82 
83   /* Token supply got increased and a new owner received these tokens */
84   event Minted(address receiver, uint amount);
85 
86   /* Actual balances of token holders */
87   mapping(address => uint) balances;
88 
89   /* approve() allowances */
90   mapping (address => mapping (address => uint)) allowed;
91 
92   /**
93    *
94    * Fix for the ERC20 short address attack
95    *
96    * http://vessenes.com/the-erc20-short-address-attack-explained/
97    */
98   modifier onlyPayloadSize(uint size) {
99      if(msg.data.length != size + 4) {
100        throw;
101      }
102      _;
103   }
104 
105   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
106     balances[msg.sender] = safeSub(balances[msg.sender], _value);
107     balances[_to] = safeAdd(balances[_to], _value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
113     uint _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
116     // if (_value > _allowance) throw;
117 
118     balances[_to] = safeAdd(balances[_to], _value);
119     balances[_from] = safeSub(balances[_from], _value);
120     allowed[_from][msg.sender] = safeSub(_allowance, _value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   function balanceOf(address _owner) constant returns (uint balance) {
126     return balances[_owner];
127   }
128 
129   function approve(address _spender, uint _value) returns (bool success) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) constant returns (uint remaining) {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * Atomic increment of approved spending
148    *
149    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    *
151    */
152   function addApproval(address _spender, uint _addedValue)
153   onlyPayloadSize(2 * 32)
154   returns (bool success) {
155       uint oldValue = allowed[msg.sender][_spender];
156       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
157       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158       return true;
159   }
160 
161   /**
162    * Atomic decrement of approved spending.
163    *
164    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    */
166   function subApproval(address _spender, uint _subtractedValue)
167   onlyPayloadSize(2 * 32)
168   returns (bool success) {
169 
170       uint oldVal = allowed[msg.sender][_spender];
171 
172       if (_subtractedValue > oldVal) {
173           allowed[msg.sender][_spender] = 0;
174       } else {
175           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
176       }
177       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178       return true;
179   }
180 
181 }
182 
183 
184 
185 contract BurnableToken is StandardToken {
186 
187   address public constant BURN_ADDRESS = 0;
188 
189   /** How many tokens we burned */
190   event Burned(address burner, uint burnedAmount);
191 
192   /**
193    * Burn extra tokens from a balance.
194    *
195    */
196   function burn(uint burnAmount) {
197     address burner = msg.sender;
198     balances[burner] = safeSub(balances[burner], burnAmount);
199     totalSupply = safeSub(totalSupply, burnAmount);
200     Burned(burner, burnAmount);
201   }
202 }
203 
204 
205 
206 
207 
208 /**
209  * Upgrade agent interface inspired by Lunyr.
210  *
211  * Upgrade agent transfers tokens to a new contract.
212  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
213  */
214 contract UpgradeAgent {
215 
216   uint public originalSupply;
217 
218   /** Interface marker */
219   function isUpgradeAgent() public constant returns (bool) {
220     return true;
221   }
222 
223   function upgradeFrom(address _from, uint256 _value) public;
224 
225 }
226 
227 
228 /**
229  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
230  *
231  * First envisioned by Golem and Lunyr projects.
232  */
233 contract UpgradeableToken is StandardToken {
234 
235   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
236   address public upgradeMaster;
237 
238   /** The next contract where the tokens will be migrated. */
239   UpgradeAgent public upgradeAgent;
240 
241   /** How many tokens we have upgraded by now. */
242   uint256 public totalUpgraded;
243 
244   /**
245    * Upgrade states.
246    *
247    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
248    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
249    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
250    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
251    *
252    */
253   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
254 
255   /**
256    * Somebody has upgraded some of his tokens.
257    */
258   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
259 
260   /**
261    * New upgrade agent available.
262    */
263   event UpgradeAgentSet(address agent);
264 
265   /**
266    * Do not allow construction without upgrade master set.
267    */
268   function UpgradeableToken(address _upgradeMaster) {
269     upgradeMaster = _upgradeMaster;
270   }
271 
272   /**
273    * Allow the token holder to upgrade some of their tokens to a new contract.
274    */
275   function upgrade(uint256 value) public {
276 
277       UpgradeState state = getUpgradeState();
278       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
279         // Called in a bad state
280         throw;
281       }
282 
283       // Validate input value.
284       if (value == 0) throw;
285 
286       balances[msg.sender] = safeSub(balances[msg.sender], value);
287 
288       // Take tokens out from circulation
289       totalSupply = safeSub(totalSupply, value);
290       totalUpgraded = safeAdd(totalUpgraded, value);
291 
292       // Upgrade agent reissues the tokens
293       upgradeAgent.upgradeFrom(msg.sender, value);
294       Upgrade(msg.sender, upgradeAgent, value);
295   }
296 
297   /**
298    * Set an upgrade agent that handles
299    */
300   function setUpgradeAgent(address agent) external {
301 
302       if(!canUpgrade()) {
303         // The token is not yet in a state that we could think upgrading
304         throw;
305       }
306 
307       if (agent == 0x0) throw;
308       // Only a master can designate the next agent
309       if (msg.sender != upgradeMaster) throw;
310       // Upgrade has already begun for an agent
311       if (getUpgradeState() == UpgradeState.Upgrading) throw;
312 
313       upgradeAgent = UpgradeAgent(agent);
314 
315       // Bad interface
316       if(!upgradeAgent.isUpgradeAgent()) throw;
317       // Make sure that token supplies match in source and target
318       if (upgradeAgent.originalSupply() != totalSupply) throw;
319 
320       UpgradeAgentSet(upgradeAgent);
321   }
322 
323   /**
324    * Get the state of the token upgrade.
325    */
326   function getUpgradeState() public constant returns(UpgradeState) {
327     if(!canUpgrade()) return UpgradeState.NotAllowed;
328     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
329     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
330     else return UpgradeState.Upgrading;
331   }
332 
333   /**
334    * Change the upgrade master.
335    *
336    * This allows us to set a new owner for the upgrade mechanism.
337    */
338   function setUpgradeMaster(address master) public {
339       if (master == 0x0) throw;
340       if (msg.sender != upgradeMaster) throw;
341       upgradeMaster = master;
342   }
343 
344   /**
345    * Child contract can enable to provide the condition when the upgrade can begun.
346    */
347   function canUpgrade() public constant returns(bool) {
348      return true;
349   }
350 
351 }
352 
353 
354 contract BCOToken is BurnableToken, UpgradeableToken {
355 
356   string public name;
357   string public symbol;
358   uint public decimals;
359   address public owner;
360 
361   bool public mintingFinished = false;
362 
363   mapping(address => uint) public previligedBalances;
364 
365   /** List of agents that are allowed to create new tokens */
366   mapping(address => bool) public mintAgents;
367   event MintingAgentChanged(address addr, bool state);
368 
369   modifier onlyOwner() {
370     if(msg.sender != owner) throw;
371     _;
372   }
373 
374   modifier onlyMintAgent() {
375     // Only crowdsale contracts are allowed to mint new tokens
376     if(!mintAgents[msg.sender]) throw;
377     _;
378   }
379 
380   /** Make sure we are not done yet. */
381   modifier canMint() {
382     if(mintingFinished) throw;
383     _;
384   }
385 
386   function transferOwnership(address newOwner) onlyOwner {
387     if (newOwner != address(0)) {
388       owner = newOwner;
389     }
390   }
391 
392   function BCOToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
393     name = _name;
394     symbol = _symbol;
395     totalSupply = _totalSupply;
396     decimals = _decimals;
397 
398     // Allocate initial balance to the owner
399     balances[_owner] = _totalSupply;
400 
401     // save the owner
402     owner = _owner;
403   }
404 
405   // privileged transfer
406   function transferPrivileged(address _to, uint _value) onlyPayloadSize(2 * 32) onlyOwner returns (bool success) {
407     balances[msg.sender] = safeSub(balances[msg.sender], _value);
408     balances[_to] = safeAdd(balances[_to], _value);
409     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
410     Transfer(msg.sender, _to, _value);
411     return true;
412   }
413 
414   // get priveleged balance
415   function getPrivilegedBalance(address _owner) constant returns (uint balance) {
416     return previligedBalances[_owner];
417   }
418 
419   // admin only can transfer from the privileged accounts
420   function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner returns (bool success) {
421     uint availablePrevilegedBalance = previligedBalances[_from];
422 
423     balances[_from] = safeSub(balances[_from], _value);
424     balances[_to] = safeAdd(balances[_to], _value);
425     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
426     Transfer(_from, _to, _value);
427     return true;
428   }
429 
430   /**
431    * Create new tokens and allocate them to an address..
432    *
433    * Only callably by a crowdsale contract (mint agent).
434    */
435   function mint(address receiver, uint amount) onlyMintAgent canMint public {
436     totalSupply = safeAdd(totalSupply, amount);
437     balances[receiver] = safeAdd(balances[receiver], amount);
438 
439     // This will make the mint transaction apper in EtherScan.io
440     // We can remove this after there is a standardized minting event
441     Transfer(0, receiver, amount);
442   }
443 
444   /**
445    * Owner can allow a crowdsale contract to mint new tokens.
446    */
447   function setMintAgent(address addr, bool state) onlyOwner canMint public {
448     mintAgents[addr] = state;
449     MintingAgentChanged(addr, state);
450   }
451 
452 }
453 
454 contract PreSaleBCO {
455     address public beneficiary;
456     uint public startline;
457     uint public deadline;
458     uint public price;
459     uint public amountRaised;
460 
461     mapping(address => uint) public actualGotETH;
462     BCOToken public tokenReward;
463 
464     modifier onlyOwner() {
465         if(msg.sender != beneficiary) throw;
466         _;
467     }
468 
469     modifier whenCrowdsaleIsFinished() {
470         if(now < deadline) throw;
471         _;
472     }
473 
474     modifier whenRefundAvailable() {
475         if(tokenReward.balanceOf(address(this)) <= 0) throw;
476         _;
477     }
478 
479     function PreSaleBCO(
480         uint start,
481         uint end,
482         uint costOfEachToken,
483         BCOToken addressOfTokenUsedAsReward
484     ) {
485         beneficiary = msg.sender;
486         startline = start;
487         deadline = end;
488         price = costOfEachToken;
489         tokenReward = BCOToken(addressOfTokenUsedAsReward);
490     }
491 
492     function () payable {
493         if (now <= startline) throw;
494         if (now >= deadline) throw;
495 
496         uint amount = msg.value;
497         if (amount < price) throw;
498 
499         amountRaised += amount;
500 
501         uint tokensToSend = amount / price;
502 
503         actualGotETH[msg.sender] += amount;
504 
505         tokenReward.transfer(msg.sender, tokensToSend);
506     }
507 
508     function transferOwnership(address newOwner) onlyOwner {
509         if (newOwner != address(0)) {
510             beneficiary = newOwner;
511         }
512     }
513 
514     function Refund() whenRefundAvailable whenCrowdsaleIsFinished {
515         msg.sender.transfer(actualGotETH[msg.sender]);
516     }
517 
518     function WithdrawAllETH() onlyOwner {
519         amountRaised = 0;
520         beneficiary.transfer(amountRaised);
521     }
522 
523     function WithdrawTokens(uint amount) onlyOwner {
524         tokenReward.transfer(beneficiary, amount);
525     }
526 
527     function ChangeCost(uint costOfEachToken) onlyOwner {
528         price = costOfEachToken;
529     }
530 
531     function ChangeStart(uint start) onlyOwner {
532         startline = start;
533     }
534 
535     function ChangeEnd(uint end) onlyOwner {
536         deadline = end;
537     }
538 }