1 pragma solidity ^0.4.13;
2 
3 contract Receiver {
4   function tokenFallback(address from, uint value, bytes data);
5 }
6 
7 /*
8  * ERC20 interface
9  * see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   uint public totalSupply;
13   function balanceOf(address who) public constant returns (uint);
14   function allowance(address owner, address spender) public constant returns (uint);
15 
16   function transfer(address to, uint value) public returns (bool ok);
17   function transferFrom(address from, address to, uint value) public returns (bool ok);
18   function approve(address spender, uint value) public returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 }
22 
23 /**
24  * Math operations with safety checks
25  */
26 contract SafeMath {
27   function safeMul(uint a, uint b) internal returns (uint) {
28     uint c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function safeDiv(uint a, uint b) internal returns (uint) {
34     assert(b > 0);
35     uint c = a / b;
36     assert(a == b * c + a % b);
37     return c;
38   }
39 
40   function safeSub(uint a, uint b) internal returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint a, uint b) internal returns (uint) {
46     uint c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a >= b ? a : b;
53   }
54 
55   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a < b ? a : b;
57   }
58 
59   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a >= b ? a : b;
61   }
62 
63   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a < b ? a : b;
65   }
66 
67   function assert(bool assertion) internal {
68     if (!assertion) {
69       revert();
70     }
71   }
72 }
73 
74 
75 
76 /**
77  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
78  *
79  * Based on code by FirstBlood:
80  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
81  */
82 contract StandardToken is ERC20, SafeMath {
83   event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);
84 
85   /* Token supply got increased and a new owner received these tokens */
86   event Minted(address receiver, uint amount);
87 
88   /* Actual balances of token holders */
89   mapping(address => uint) balances;
90 
91   /* approve() allowances */
92   mapping (address => mapping (address => uint)) allowed;
93 
94   /**
95    *
96    * Fix for the ERC20 short address attack
97    *
98    * http://vessenes.com/the-erc20-short-address-attack-explained/
99    */
100   modifier onlyPayloadSize(uint size) {
101      if(msg.data.length != size + 4) {
102        revert();
103      }
104      _;
105   }
106 
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
108       bytes memory _empty;
109 
110       return transfer(_to, _value, _empty);
111   }
112 
113   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
114     balances[msg.sender] = safeSub(balances[msg.sender], _value);
115     balances[_to] = safeAdd(balances[_to], _value);
116     Transfer(msg.sender, _to, _value, _data);
117     Transfer(msg.sender, _to, _value);
118 
119     if (isContract(_to)) {
120       Receiver(_to).tokenFallback(msg.sender, _value, _data);
121     }
122 
123     return true;
124   }
125 
126   // ERC223 fetch contract size (must be nonzero to be a contract)
127   function isContract( address _addr ) private returns (bool) {
128     uint length;
129     _addr = _addr;
130     assembly { length := extcodesize(_addr) }
131     return (length > 0);
132   }
133 
134   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
135     uint _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
138     // if (_value > _allowance) revert();
139 
140     balances[_to] = safeAdd(balances[_to], _value);
141     balances[_from] = safeSub(balances[_from], _value);
142     allowed[_from][msg.sender] = safeSub(_allowance, _value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   function balanceOf(address _owner) public constant returns (uint balance) {
148     return balances[_owner];
149   }
150 
151   function approve(address _spender, uint _value) public returns (bool success) {
152 
153     // To change the approve amount you first have to reduce the addresses`
154     //  allowance to zero by calling `approve(_spender, 0)` if it is not
155     //  already 0 to mitigate the race condition described here:
156     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
158 
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168   /**
169    * Atomic increment of approved spending
170    *
171    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    *
173    */
174   function addApproval(address _spender, uint _addedValue) public
175   onlyPayloadSize(2 * 32)
176   returns (bool success) {
177       uint oldValue = allowed[msg.sender][_spender];
178       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
179       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180       return true;
181   }
182 
183   /**
184    * Atomic decrement of approved spending.
185    *
186    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    */
188   function subApproval(address _spender, uint _subtractedValue) public
189   onlyPayloadSize(2 * 32)
190   returns (bool success) {
191 
192       uint oldVal = allowed[msg.sender][_spender];
193 
194       if (_subtractedValue > oldVal) {
195           allowed[msg.sender][_spender] = 0;
196       } else {
197           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
198       }
199       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200       return true;
201   }
202 
203 }
204 
205 
206 
207 contract BurnableToken is StandardToken {
208 
209   address public constant BURN_ADDRESS = 0;
210 
211   /** How many tokens we burned */
212   event Burned(address burner, uint burnedAmount);
213 
214   /**
215    * Burn extra tokens from a balance.
216    *
217    */
218   function burn(uint burnAmount) public {
219     address burner = msg.sender;
220     balances[burner] = safeSub(balances[burner], burnAmount);
221     totalSupply = safeSub(totalSupply, burnAmount);
222     Burned(burner, burnAmount);
223   }
224 }
225 
226 
227 
228 
229 
230 /**
231  * Upgrade agent interface inspired by Lunyr.
232  *
233  * Upgrade agent transfers tokens to a new contract.
234  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
235  */
236 contract UpgradeAgent {
237 
238   uint public originalSupply;
239 
240   /** Interface marker */
241   function isUpgradeAgent() public constant returns (bool) {
242     return true;
243   }
244 
245   function upgradeFrom(address _from, uint256 _value) public;
246 
247 }
248 
249 
250 /**
251  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
252  *
253  * First envisioned by Golem and Lunyr projects.
254  */
255 contract UpgradeableToken is StandardToken {
256 
257   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
258   address public upgradeMaster;
259 
260   /** The next contract where the tokens will be migrated. */
261   UpgradeAgent public upgradeAgent;
262 
263   /** How many tokens we have upgraded by now. */
264   uint256 public totalUpgraded;
265 
266   /**
267    * Upgrade states.
268    *
269    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
270    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
271    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
272    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
273    *
274    */
275   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
276 
277   /**
278    * Somebody has upgraded some of his tokens.
279    */
280   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
281 
282   /**
283    * New upgrade agent available.
284    */
285   event UpgradeAgentSet(address agent);
286 
287   /**
288    * Do not allow construction without upgrade master set.
289    */
290   function UpgradeableToken(address _upgradeMaster) public {
291     upgradeMaster = _upgradeMaster;
292   }
293 
294   /**
295    * Allow the token holder to upgrade some of their tokens to a new contract.
296    */
297   function upgrade(uint256 value) public {
298 
299       UpgradeState state = getUpgradeState();
300       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
301         // Called in a bad state
302         revert();
303       }
304 
305       // Validate input value.
306       if (value == 0) revert();
307 
308       balances[msg.sender] = safeSub(balances[msg.sender], value);
309 
310       // Take tokens out from circulation
311       totalSupply = safeSub(totalSupply, value);
312       totalUpgraded = safeAdd(totalUpgraded, value);
313 
314       // Upgrade agent reissues the tokens
315       upgradeAgent.upgradeFrom(msg.sender, value);
316       Upgrade(msg.sender, upgradeAgent, value);
317   }
318 
319   /**
320    * Set an upgrade agent that handles
321    */
322   function setUpgradeAgent(address agent) external {
323 
324       if(!canUpgrade()) {
325         // The token is not yet in a state that we could think upgrading
326         revert();
327       }
328 
329       if (agent == 0x0) revert();
330       // Only a master can designate the next agent
331       if (msg.sender != upgradeMaster) revert();
332       // Upgrade has already begun for an agent
333       if (getUpgradeState() == UpgradeState.Upgrading) revert();
334 
335       upgradeAgent = UpgradeAgent(agent);
336 
337       // Bad interface
338       if(!upgradeAgent.isUpgradeAgent()) revert();
339       // Make sure that token supplies match in source and target
340       if (upgradeAgent.originalSupply() != totalSupply) revert();
341 
342       UpgradeAgentSet(upgradeAgent);
343   }
344 
345   /**
346    * Get the state of the token upgrade.
347    */
348   function getUpgradeState() public constant returns(UpgradeState) {
349     if(!canUpgrade()) return UpgradeState.NotAllowed;
350     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
351     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
352     else return UpgradeState.Upgrading;
353   }
354 
355   /**
356    * Change the upgrade master.
357    *
358    * This allows us to set a new owner for the upgrade mechanism.
359    */
360   function setUpgradeMaster(address master) public {
361       if (master == 0x0) revert();
362       if (msg.sender != upgradeMaster) revert();
363       upgradeMaster = master;
364   }
365 
366   /**
367    * Child contract can enable to provide the condition when the upgrade can begun.
368    */
369   function canUpgrade() public constant returns(bool) {
370      return true;
371   }
372 
373 }
374 
375 
376 contract GGToken is BurnableToken, UpgradeableToken {
377 
378   string public name;
379   string public symbol;
380   uint public decimals;
381   address public owner;
382 
383   bool public mintingFinished = false;
384 
385   mapping(address => uint) public previligedBalances;
386 
387   /** List of agents that are allowed to create new tokens */
388   mapping(address => bool) public mintAgents;
389   event MintingAgentChanged(address addr, bool state);
390 
391   modifier onlyOwner() {
392     if(msg.sender != owner) revert();
393     _;
394   }
395 
396   modifier onlyMintAgent() {
397     // Only crowdsale contracts are allowed to mint new tokens
398     if(!mintAgents[msg.sender]) revert();
399     _;
400   }
401 
402   /** Make sure we are not done yet. */
403   modifier canMint() {
404     if(mintingFinished) revert();
405     _;
406   }
407 
408   modifier onlyNotSame(address _from, address _to) {
409     if(_from == _to) revert();
410     _;
411   }
412 
413   function transferOwnership(address newOwner) public onlyOwner {
414     if (newOwner != address(0)) {
415       owner = newOwner;
416     }
417   }
418 
419   function GGToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) public UpgradeableToken(_owner) {
420     name = _name;
421     symbol = _symbol;
422     decimals = _decimals;
423     totalSupply = _totalSupply * 10 ** uint(decimals);
424 
425     // Allocate initial balance to the owner
426     balances[_owner] = totalSupply;
427 
428     // save the owner
429     owner = _owner;
430   }
431 
432   function mintingFinish() public onlyOwner {
433     mintingFinished = true;
434   }
435 
436   // privileged transfer
437   function transferPrivileged(address _to, uint _value) public onlyOwner returns (bool success) {
438     balances[msg.sender] = safeSub(balances[msg.sender], _value);
439     balances[_to] = safeAdd(balances[_to], _value);
440     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
441     Transfer(msg.sender, _to, _value);
442     return true;
443   }
444 
445   // get priveleged balance
446   function getPrivilegedBalance(address _owner) public constant returns (uint balance) {
447     return previligedBalances[_owner];
448   }
449 
450   // admin only can transfer from the privileged accounts
451   function transferFromPrivileged(address _from, address _to, uint _value) public onlyOwner onlyNotSame(_from, _to) returns (bool success) {
452     uint availablePrevilegedBalance = previligedBalances[_from];
453 
454     balances[_from] = safeSub(balances[_from], _value);
455     balances[_to] = safeAdd(balances[_to], _value);
456     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
457     Transfer(_from, _to, _value);
458     return true;
459   }
460 
461   /**
462    * Create new tokens and allocate them to an address..
463    *
464    * Only callably by a crowdsale contract (mint agent).
465    */
466   function mint(address receiver, uint amount) onlyMintAgent canMint public {
467     amount *= 10 ** uint(decimals);
468     totalSupply = safeAdd(totalSupply, amount);
469     balances[receiver] = safeAdd(balances[receiver], amount);
470 
471     // This will make the mint transaction apper in EtherScan.io
472     // We can remove this after there is a standardized minting event
473     Transfer(0, receiver, amount);
474   }
475 
476   /**
477    * Owner can allow a crowdsale contract to mint new tokens.
478    */
479   function setMintAgent(address addr, bool state) onlyOwner canMint public {
480     mintAgents[addr] = state;
481     MintingAgentChanged(addr, state);
482   }
483 
484 }
485 
486 contract GGTVestingForPrivateInvestor {
487     address public investorAddress;
488     uint public deadline;
489 
490     GGToken public tokenReward;
491 
492     event TokenFallback( address indexed from,
493                          uint256 value,
494                          bytes data);
495 
496     modifier onlyInvestor() {
497         if(msg.sender != investorAddress) revert();
498         _;
499     }
500 
501     modifier onlyWhenItsAllowed() {
502         if(now < deadline) revert();
503         _;
504     }
505 
506     function GGTVestingForPrivateInvestor(
507         address investor,
508         GGToken addressOfTokenUsedAsReward,
509         uint end
510     ) {
511         investorAddress = investor;
512         tokenReward = GGToken(addressOfTokenUsedAsReward);
513         deadline = end;
514     }
515 
516     function TransferMyGGTokens() onlyInvestor onlyWhenItsAllowed {
517       tokenReward.transfer(msg.sender, tokenReward.balanceOf(this));
518     }
519 
520     function GetInvestorAddress() returns (address) {
521       return investorAddress;
522     }
523 
524     function GetDeadline() returns (uint) {
525       return deadline;
526     }
527 
528     // ERC223
529     // function in contract 'ContractReceiver'
530     function tokenFallback(address from, uint value, bytes data) {
531         TokenFallback(from, value, data);
532     }
533 }