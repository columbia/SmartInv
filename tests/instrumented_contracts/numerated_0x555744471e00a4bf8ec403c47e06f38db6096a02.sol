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
79   /* Token supply got increased and a new owner received these tokens */
80   event Minted(address receiver, uint amount);
81 
82   /* Actual balances of token holders */
83   mapping(address => uint) balances;
84 
85   /* approve() allowances */
86   mapping (address => mapping (address => uint)) allowed;
87 
88   /**
89    *
90    * Fix for the ERC20 short address attack
91    *
92    * http://vessenes.com/the-erc20-short-address-attack-explained/
93    */
94   modifier onlyPayloadSize(uint size) {
95      if(msg.data.length != size + 4) {
96        revert();
97      }
98      _;
99   }
100 
101   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
102     balances[msg.sender] = safeSub(balances[msg.sender], _value);
103     balances[_to] = safeAdd(balances[_to], _value);
104     Transfer(msg.sender, _to, _value);
105 
106     if (isContract(_to)) {
107       ContractReceiver rx = ContractReceiver(_to);
108       rx.tokenFallback(msg.sender, _value);
109     }
110 
111     return true;
112   }
113 
114   // ERC223 fetch contract size (must be nonzero to be a contract)
115   function isContract( address _addr ) view private returns (bool) {
116     uint length;
117     _addr = _addr;
118     assembly { length := extcodesize(_addr) }
119     return (length > 0);
120   }
121 
122   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
123     uint _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
126     // if (_value > _allowance) revert();
127 
128     balances[_to] = safeAdd(balances[_to], _value);
129     balances[_from] = safeSub(balances[_from], _value);
130     allowed[_from][msg.sender] = safeSub(_allowance, _value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   function balanceOf(address _owner) public constant returns (uint balance) {
136     return balances[_owner];
137   }
138 
139   function approve(address _spender, uint _value) public returns (bool success) {
140 
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
146 
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * Atomic increment of approved spending
158    *
159    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    *
161    */
162   function addApproval(address _spender, uint _addedValue)
163   onlyPayloadSize(2 * 32)
164   public returns (bool success) {
165       uint oldValue = allowed[msg.sender][_spender];
166       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
167       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168       return true;
169   }
170 
171   /**
172    * Atomic decrement of approved spending.
173    *
174    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    */
176   function subApproval(address _spender, uint _subtractedValue)
177   onlyPayloadSize(2 * 32)
178   public returns (bool success) {
179 
180       uint oldVal = allowed[msg.sender][_spender];
181 
182       if (_subtractedValue > oldVal) {
183           allowed[msg.sender][_spender] = 0;
184       } else {
185           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
186       }
187       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188       return true;
189   }
190 
191 }
192 
193 
194 
195 contract BurnableToken is StandardToken {
196 
197   address public constant BURN_ADDRESS = 0;
198 
199   /** How many tokens we burned */
200   event Burned(address burner, uint burnedAmount);
201 
202   /**
203    * Burn extra tokens from a balance.
204    *
205    */
206   function burn(uint burnAmount) public {
207     address burner = msg.sender;
208     balances[burner] = safeSub(balances[burner], burnAmount);
209     totalSupply = safeSub(totalSupply, burnAmount);
210     Burned(burner, burnAmount);
211   }
212 }
213 
214 
215 
216 
217 
218 /**
219  * Upgrade agent interface inspired by Lunyr.
220  *
221  * Upgrade agent transfers tokens to a new contract.
222  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
223  */
224 contract UpgradeAgent {
225 
226   uint public originalSupply;
227 
228   /** Interface marker */
229   function isUpgradeAgent() public pure returns (bool) {
230     return true;
231   }
232 
233   function upgradeFrom(address _from, uint256 _value) public;
234 
235 }
236 
237 
238 /**
239  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
240  *
241  * First envisioned by Golem and Lunyr projects.
242  */
243 contract UpgradeableToken is StandardToken {
244 
245   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
246   address public upgradeMaster;
247 
248   /** The next contract where the tokens will be migrated. */
249   UpgradeAgent public upgradeAgent;
250 
251   /** How many tokens we have upgraded by now. */
252   uint256 public totalUpgraded;
253 
254   /**
255    * Upgrade states.
256    *
257    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
258    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
259    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
260    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
261    *
262    */
263   enum UpgradeState {
264     Unknown, 
265     NotAllowed, 
266     WaitingForAgent, 
267     ReadyToUpgrade, 
268     Upgrading
269   }
270 
271   /**
272    * Somebody has upgraded some of his tokens.
273    */
274   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
275 
276   /**
277    * New upgrade agent available.
278    */
279   event UpgradeAgentSet(address agent);
280 
281   /**
282    * Do not allow construction without upgrade master set.
283    */
284   function UpgradeableToken(address _upgradeMaster) public {
285     upgradeMaster = _upgradeMaster;
286   }
287 
288   /**
289    * Allow the token holder to upgrade some of their tokens to a new contract.
290    */
291   function upgrade(uint256 value) public {
292 
293       UpgradeState state = getUpgradeState();
294       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
295         // Called in a bad state
296         revert();
297       }
298 
299       // Validate input value.
300       if (value == 0) revert();
301 
302       balances[msg.sender] = safeSub(balances[msg.sender], value);
303 
304       // Take tokens out from circulation
305       totalSupply = safeSub(totalSupply, value);
306       totalUpgraded = safeAdd(totalUpgraded, value);
307 
308       // Upgrade agent reissues the tokens
309       upgradeAgent.upgradeFrom(msg.sender, value);
310       Upgrade(msg.sender, upgradeAgent, value);
311   }
312 
313   /**
314    * Set an upgrade agent that handles
315    */
316   function setUpgradeAgent(address agent) external {
317 
318       if(!canUpgrade()) {
319         // The token is not yet in a state that we could think upgrading
320         revert();
321       }
322 
323       if (agent == 0x0) revert();
324       // Only a master can designate the next agent
325       if (msg.sender != upgradeMaster) revert();
326       // Upgrade has already begun for an agent
327       if (getUpgradeState() == UpgradeState.Upgrading) revert();
328 
329       upgradeAgent = UpgradeAgent(agent);
330 
331       // Bad interface
332       if(!upgradeAgent.isUpgradeAgent()) revert();
333       // Make sure that token supplies match in source and target
334       if (upgradeAgent.originalSupply() != totalSupply) revert();
335 
336       UpgradeAgentSet(upgradeAgent);
337   }
338 
339   /**
340    * Get the state of the token upgrade.
341    */
342   function getUpgradeState() public constant returns(UpgradeState) {
343     if(!canUpgrade()) return UpgradeState.NotAllowed;
344     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
345     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
346     else return UpgradeState.Upgrading;
347   }
348 
349   /**
350    * Change the upgrade master.
351    *
352    * This allows us to set a new owner for the upgrade mechanism.
353    */
354   function setUpgradeMaster(address master) public {
355       if (master == 0x0) revert();
356       if (msg.sender != upgradeMaster) revert();
357       upgradeMaster = master;
358   }
359 
360   /**
361    * Child contract can enable to provide the condition when the upgrade can begun.
362    */
363   function canUpgrade() public pure returns(bool) {
364      return true;
365   }
366 
367 }
368 
369 
370 contract SQDExtendedToken is BurnableToken, UpgradeableToken {
371 
372   string public name;
373   string public symbol;
374   uint8 public decimals;
375   address public owner;
376 
377   bool public mintingFinished = false;
378 
379   mapping(address => uint) public previligedBalances;
380 
381   /** List of agents that are allowed to create new tokens */
382   mapping(address => bool) public mintAgents;
383   event MintingAgentChanged(address addr, bool state);
384   event MintFinished();
385 
386   modifier onlyOwner() {
387     if(msg.sender != owner) revert();
388     _;
389   }
390 
391   modifier onlyMintAgent() {
392     // Only crowdsale contracts are allowed to mint new tokens
393     if(!mintAgents[msg.sender]) revert();
394     _;
395   }
396 
397   /** Make sure we are not done yet. */
398   modifier canMint() {
399     if(mintingFinished) revert();
400     _;
401   }
402 
403   function transferOwnership(address newOwner) onlyOwner public {
404     if (newOwner != address(0)) {
405       owner = newOwner;
406     }
407   }
408 
409   function SQDExtendedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) UpgradeableToken(_owner) public {
410     uint calculatedSupply = _totalSupply * 10 ** uint(_decimals);
411     name = _name;
412     symbol = _symbol;
413     totalSupply = calculatedSupply;
414     decimals = _decimals;
415 
416     // Allocate initial balance to the owner
417     balances[_owner] = calculatedSupply;
418 
419     // save the owner
420     owner = _owner;
421   }
422 
423   // privileged transfer
424   function transferPrivileged(address _to, uint _value) onlyOwner public returns (bool success) {
425     balances[msg.sender] = safeSub(balances[msg.sender], _value);
426     balances[_to] = safeAdd(balances[_to], _value);
427     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
428     Transfer(msg.sender, _to, _value);
429     return true;
430   }
431 
432   // get priveleged balance
433   function getPrivilegedBalance(address _owner) public constant returns (uint balance) {
434     return previligedBalances[_owner];
435   }
436 
437   // admin only can transfer from the privileged accounts
438   function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner public returns (bool success) {
439     uint availablePrevilegedBalance = previligedBalances[_from];
440 
441     balances[_from] = safeSub(balances[_from], _value);
442     balances[_to] = safeAdd(balances[_to], _value);
443     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
444     Transfer(_from, _to, _value);
445     return true;
446   }
447 
448   /**
449    * Create new tokens and allocate them to an address..
450    *
451    * Only callably by a crowdsale contract (mint agent).
452    */
453   function mint(address receiver, uint amount) onlyMintAgent canMint public {
454     totalSupply = safeAdd(totalSupply, amount);
455     balances[receiver] = safeAdd(balances[receiver], amount);
456 
457     // This will make the mint transaction apper in EtherScan.io
458     // We can remove this after there is a standardized minting event
459     Transfer(0, receiver, amount);
460   }
461 
462   /**
463    * Owner can allow a crowdsale contract to mint new tokens.
464    */
465   function setMintAgent(address addr, bool state) onlyOwner canMint public {
466     mintAgents[addr] = state;
467     MintingAgentChanged(addr, state);
468   }
469 }
470 
471 contract InitialSaleSQD {
472     address public beneficiary;
473     uint public preICOSaleStart;
474     uint public ICOSaleStart;
475     uint public ICOSaleEnd;
476 
477     uint public preICOPrice; // price of 10^-8 SQD in Wei
478     uint public ICOPrice; // price of 10^-8 SQD in Wei
479     
480     uint public amountRaised;
481     uint public incomingTokensTransactions;
482 
483     SQDExtendedToken public tokenReward;
484 
485     event TokenFallback( address indexed from,
486                          uint256 value);
487 
488     modifier onlyOwner() {
489         if(msg.sender != beneficiary) revert();
490         _;
491     }
492 
493     function InitialSaleSQD(
494         uint _preICOStart,
495         uint _ICOStart,
496         uint _ICOEnd,
497         uint _preICOPrice,
498         uint _ICOPrice,
499         SQDExtendedToken addressOfTokenUsedAsReward
500     ) public {
501         beneficiary = msg.sender;
502         preICOSaleStart = _preICOStart;
503         ICOSaleStart = _ICOStart;
504         ICOSaleEnd = _ICOEnd;
505         preICOPrice = _preICOPrice;
506         ICOPrice = _ICOPrice;
507         tokenReward = SQDExtendedToken(addressOfTokenUsedAsReward);
508     }
509 
510     function () payable public {
511         if (now < preICOSaleStart) revert();
512         if (now >= ICOSaleEnd) revert();
513 
514         uint price = preICOPrice;
515         if (now >= ICOSaleStart) {
516             price = ICOPrice;
517         }
518 
519         uint amount = msg.value;
520         if (amount < price) revert();
521 
522         amountRaised += amount;
523 
524         uint payoutPerPrice = 10 ** uint(tokenReward.decimals() - 8);
525         uint units = amount / price;
526         uint tokensToSend = units * payoutPerPrice;
527 
528         tokenReward.transfer(msg.sender, tokensToSend);
529     }
530 
531     function transferOwnership(address newOwner) onlyOwner public {
532         if (newOwner != address(0)) {
533             beneficiary = newOwner;
534         }
535     }
536 
537     function WithdrawETH(uint amount) onlyOwner public {
538         beneficiary.transfer(amount);
539     }
540 
541     function WithdrawAllETH() onlyOwner public {
542         beneficiary.transfer(amountRaised);
543     }
544 
545     function WithdrawTokens(uint amount) onlyOwner public {
546         tokenReward.transfer(beneficiary, amount);
547     }
548 
549     function ChangeCost(uint _preICOPrice, uint _ICOPrice) onlyOwner public {
550         preICOPrice = _preICOPrice;
551         ICOPrice = _ICOPrice;
552     }
553 
554     function ChangePreICOStart(uint _start) onlyOwner public {
555         preICOSaleStart = _start;
556     }
557 
558     function ChangeICOStart(uint _start) onlyOwner public {
559         ICOSaleStart = _start;
560     }
561 
562     function ChangeICOEnd(uint _end) onlyOwner public {
563         ICOSaleEnd = _end;
564     }
565 
566     // ERC223
567     // function in contract 'ContractReceiver'
568     function tokenFallback(address from, uint value) public {
569         incomingTokensTransactions += 1;
570         TokenFallback(from, value);
571     }
572 }