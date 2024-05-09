1 pragma solidity ^0.4.18;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) public constant returns (uint);
10   function allowance(address owner, address spender) public constant returns (uint);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transferFrom(address from, address to, uint value) public returns (bool ok);
14   function approve(address spender, uint value) public returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 // ERC223
20 contract ContractReceiver {
21   function tokenFallback(address from, uint value) public;
22 }
23 
24 /**
25  * Math operations with safety checks
26  */
27 contract SafeMath {
28   function safeMul(uint a, uint b) internal pure returns (uint) {
29     uint c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function safeDiv(uint a, uint b) internal pure returns (uint) {
35     assert(b > 0);
36     uint c = a / b;
37     assert(a == b * c + a % b);
38     return c;
39   }
40 
41   function safeSub(uint a, uint b) internal pure returns (uint) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function safeAdd(uint a, uint b) internal pure returns (uint) {
47     uint c = a + b;
48     assert(c>=a && c>=b);
49     return c;
50   }
51 
52   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
53     return a >= b ? a : b;
54   }
55 
56   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
57     return a < b ? a : b;
58   }
59 
60   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
61     return a >= b ? a : b;
62   }
63 
64   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
65     return a < b ? a : b;
66   }
67 }
68 
69 
70 
71 /**
72  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
73  *
74  * Based on code by FirstBlood:
75  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  */
77 contract StandardToken is ERC20, SafeMath {
78 
79   /* Actual balances of token holders */
80   mapping(address => uint) balances;
81 
82   /* approve() allowances */
83   mapping (address => mapping (address => uint)) allowed;
84 
85   /**
86    *
87    * Fix for the ERC20 short address attack
88    *
89    * http://vessenes.com/the-erc20-short-address-attack-explained/
90    */
91   modifier onlyPayloadSize(uint size) {
92      if(msg.data.length != size + 4) {
93        revert();
94      }
95      _;
96   }
97 
98   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
99     balances[msg.sender] = safeSub(balances[msg.sender], _value);
100     balances[_to] = safeAdd(balances[_to], _value);
101     Transfer(msg.sender, _to, _value);
102 
103     if (isContract(_to)) {
104       ContractReceiver rx = ContractReceiver(_to);
105       rx.tokenFallback(msg.sender, _value);
106     }
107 
108     return true;
109   }
110 
111   // ERC223 fetch contract size (must be nonzero to be a contract)
112   function isContract( address _addr ) view private returns (bool) {
113     uint length;
114     _addr = _addr;
115     assembly { length := extcodesize(_addr) }
116     return (length > 0);
117   }
118 
119   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
120     uint _allowance = allowed[_from][msg.sender];
121 
122     balances[_to] = safeAdd(balances[_to], _value);
123     balances[_from] = safeSub(balances[_from], _value);
124     allowed[_from][msg.sender] = safeSub(_allowance, _value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function balanceOf(address _owner) public constant returns (uint balance) {
130     return balances[_owner];
131   }
132 
133   function approve(address _spender, uint _value) public returns (bool success) {
134 
135     // To change the approve amount you first have to reduce the addresses`
136     //  allowance to zero by calling `approve(_spender, 0)` if it is not
137     //  already 0 to mitigate the race condition described here:
138     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
140 
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * Atomic increment of approved spending
152    *
153    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    *
155    */
156   function addApproval(address _spender, uint _addedValue)
157   onlyPayloadSize(2 * 32)
158   public returns (bool success) {
159       uint oldValue = allowed[msg.sender][_spender];
160       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
161       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162       return true;
163   }
164 
165   /**
166    * Atomic decrement of approved spending.
167    *
168    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    */
170   function subApproval(address _spender, uint _subtractedValue)
171   onlyPayloadSize(2 * 32)
172   public returns (bool success) {
173 
174       uint oldVal = allowed[msg.sender][_spender];
175 
176       if (_subtractedValue > oldVal) {
177           allowed[msg.sender][_spender] = 0;
178       } else {
179           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
180       }
181       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182       return true;
183   }
184 
185 }
186 
187 
188 
189 contract BurnableToken is StandardToken {
190 
191   address public constant BURN_ADDRESS = 0;
192 
193   /** How many tokens we burned */
194   event Burned(address burner, uint burnedAmount);
195 
196   /**
197    * Burn extra tokens from a balance.
198    *
199    */
200   function burn(uint burnAmount) public {
201     address burner = msg.sender;
202     balances[burner] = safeSub(balances[burner], burnAmount);
203     totalSupply = safeSub(totalSupply, burnAmount);
204     Burned(burner, burnAmount);
205   }
206 }
207 
208 
209 
210 
211 
212 /**
213  * Upgrade agent interface inspired by Lunyr.
214  *
215  * Upgrade agent transfers tokens to a new contract.
216  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
217  */
218 contract UpgradeAgent {
219 
220   uint public originalSupply;
221 
222   /** Interface marker */
223   function isUpgradeAgent() public pure returns (bool) {
224     return true;
225   }
226 
227   function upgradeFrom(address _from, uint256 _value) public;
228 
229 }
230 
231 
232 /**
233  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
234  *
235  * First envisioned by Golem and Lunyr projects.
236  */
237 contract UpgradeableToken is StandardToken {
238 
239   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
240   address public upgradeMaster;
241 
242   /** The next contract where the tokens will be migrated. */
243   UpgradeAgent public upgradeAgent;
244 
245   /** How many tokens we have upgraded by now. */
246   uint256 public totalUpgraded;
247 
248   /**
249    * Upgrade states.
250    *
251    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
252    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
253    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
254    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
255    *
256    */
257   enum UpgradeState {
258     Unknown, 
259     NotAllowed, 
260     WaitingForAgent, 
261     ReadyToUpgrade, 
262     Upgrading
263   }
264 
265   /**
266    * Somebody has upgraded some of his tokens.
267    */
268   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
269 
270   /**
271    * New upgrade agent available.
272    */
273   event UpgradeAgentSet(address agent);
274 
275   /**
276    * Do not allow construction without upgrade master set.
277    */
278   function UpgradeableToken(address _upgradeMaster) public {
279     upgradeMaster = _upgradeMaster;
280   }
281 
282   /**
283    * Allow the token holder to upgrade some of their tokens to a new contract.
284    */
285   function upgrade(uint256 value) public {
286 
287       UpgradeState state = getUpgradeState();
288       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
289         // Called in a bad state
290         revert();
291       }
292 
293       // Validate input value.
294       if (value == 0) revert();
295 
296       balances[msg.sender] = safeSub(balances[msg.sender], value);
297 
298       // Take tokens out from circulation
299       totalSupply = safeSub(totalSupply, value);
300       totalUpgraded = safeAdd(totalUpgraded, value);
301 
302       // Upgrade agent reissues the tokens
303       upgradeAgent.upgradeFrom(msg.sender, value);
304       Upgrade(msg.sender, upgradeAgent, value);
305   }
306 
307   /**
308    * Set an upgrade agent that handles
309    */
310   function setUpgradeAgent(address agent) external {
311 
312       if(!canUpgrade()) {
313         // The token is not yet in a state that we could think upgrading
314         revert();
315       }
316 
317       if (agent == 0x0) revert();
318       // Only a master can designate the next agent
319       if (msg.sender != upgradeMaster) revert();
320       // Upgrade has already begun for an agent
321       if (getUpgradeState() == UpgradeState.Upgrading) revert();
322 
323       upgradeAgent = UpgradeAgent(agent);
324 
325       // Bad interface
326       if(!upgradeAgent.isUpgradeAgent()) revert();
327       // Make sure that token supplies match in source and target
328       if (upgradeAgent.originalSupply() != totalSupply) revert();
329 
330       UpgradeAgentSet(upgradeAgent);
331   }
332 
333   /**
334    * Get the state of the token upgrade.
335    */
336   function getUpgradeState() public constant returns(UpgradeState) {
337     if(!canUpgrade()) return UpgradeState.NotAllowed;
338     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
339     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
340     else return UpgradeState.Upgrading;
341   }
342 
343   /**
344    * Change the upgrade master.
345    *
346    * This allows us to set a new owner for the upgrade mechanism.
347    */
348   function setUpgradeMaster(address master) public {
349       if (master == 0x0) revert();
350       if (msg.sender != upgradeMaster) revert();
351       upgradeMaster = master;
352   }
353 
354   /**
355    * Child contract can enable to provide the condition when the upgrade can begun.
356    */
357   function canUpgrade() public pure returns(bool) {
358      return true;
359   }
360 
361 }
362 
363 
364 contract SQDFiniteToken is BurnableToken, UpgradeableToken {
365 
366   string public name;
367   string public symbol;
368   uint8 public decimals;
369   address public owner;
370 
371   mapping(address => uint) public previligedBalances;
372 
373   modifier onlyOwner() {
374     if(msg.sender != owner) revert();
375     _;
376   }
377 
378   function transferOwnership(address newOwner) onlyOwner public {
379     if (newOwner != address(0)) {
380       owner = newOwner;
381     }
382   }
383 
384   function SQDFiniteToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) UpgradeableToken(_owner) public {
385     uint calculatedSupply = _totalSupply * 10 ** uint(_decimals);
386     name = _name;
387     symbol = _symbol;
388     totalSupply = calculatedSupply;
389     decimals = _decimals;
390 
391     // Allocate initial balance to the owner
392     balances[_owner] = calculatedSupply;
393 
394     // save the owner
395     owner = _owner;
396   }
397 
398   // privileged transfer
399   function transferPrivileged(address _to, uint _value) onlyOwner public returns (bool success) {
400     balances[msg.sender] = safeSub(balances[msg.sender], _value);
401     balances[_to] = safeAdd(balances[_to], _value);
402     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
403     Transfer(msg.sender, _to, _value);
404     return true;
405   }
406 
407   // get priveleged balance
408   function getPrivilegedBalance(address _owner) public constant returns (uint balance) {
409     return previligedBalances[_owner];
410   }
411 
412   // admin only can transfer from the privileged accounts
413   function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner public returns (bool success) {
414     uint availablePrevilegedBalance = previligedBalances[_from];
415 
416     balances[_from] = safeSub(balances[_from], _value);
417     balances[_to] = safeAdd(balances[_to], _value);
418     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
419     Transfer(_from, _to, _value);
420     return true;
421   }
422 }
423 
424 contract InitialSaleSQD {
425     address public beneficiary;
426     uint public preICOSaleStart;
427     uint public ICOSaleStart;
428     uint public ICOSaleEnd;
429 
430     uint public preICOPrice; // price of 10^-8 SQD in Wei
431     uint public ICOPrice; // price of 10^-8 SQD in Wei
432     
433     uint public amountRaised;
434     uint public incomingTokensTransactions;
435 
436     SQDFiniteToken public tokenReward;
437 
438     event TokenFallback( address indexed from,
439                          uint256 value);
440 
441     modifier onlyOwner() {
442         if(msg.sender != beneficiary) revert();
443         _;
444     }
445 
446     function InitialSaleSQD(
447         uint _preICOStart,
448         uint _ICOStart,
449         uint _ICOEnd,
450         uint _preICOPrice,
451         uint _ICOPrice,
452         SQDFiniteToken addressOfTokenUsedAsReward
453     ) public {
454         beneficiary = msg.sender;
455         preICOSaleStart = _preICOStart;
456         ICOSaleStart = _ICOStart;
457         ICOSaleEnd = _ICOEnd;
458         preICOPrice = _preICOPrice;
459         ICOPrice = _ICOPrice;
460         tokenReward = SQDFiniteToken(addressOfTokenUsedAsReward);
461     }
462 
463     function () payable public {
464         if (now < preICOSaleStart) revert();
465         if (now >= ICOSaleEnd) revert();
466 
467         uint price = preICOPrice;
468         if (now >= ICOSaleStart) {
469             price = ICOPrice;
470         }
471 
472         uint amount = msg.value;
473         if (amount < price) revert();
474 
475         amountRaised += amount;
476 
477         uint payoutPerPrice = 10 ** uint(tokenReward.decimals() - 8);
478         uint units = amount / price;
479         uint tokensToSend = units * payoutPerPrice;
480 
481         tokenReward.transfer(msg.sender, tokensToSend);
482     }
483 
484     function transferOwnership(address newOwner) onlyOwner public {
485         if (newOwner != address(0)) {
486             beneficiary = newOwner;
487         }
488     }
489 
490     function WithdrawETH(uint amount) onlyOwner public {
491         beneficiary.transfer(amount);
492     }
493 
494     function WithdrawAllETH() onlyOwner public {
495         beneficiary.transfer(amountRaised);
496     }
497 
498     function WithdrawTokens(uint amount) onlyOwner public {
499         tokenReward.transfer(beneficiary, amount);
500     }
501 
502     function ChangeCost(uint _preICOPrice, uint _ICOPrice) onlyOwner public {
503         preICOPrice = _preICOPrice;
504         ICOPrice = _ICOPrice;
505     }
506 
507     function ChangePreICOStart(uint _start) onlyOwner public {
508         preICOSaleStart = _start;
509     }
510 
511     function ChangeICOStart(uint _start) onlyOwner public {
512         ICOSaleStart = _start;
513     }
514 
515     function ChangeICOEnd(uint _end) onlyOwner public {
516         ICOSaleEnd = _end;
517     }
518 
519     // ERC223
520     // function in contract 'ContractReceiver'
521     function tokenFallback(address from, uint value) public {
522         incomingTokensTransactions += 1;
523         TokenFallback(from, value);
524     }
525 }