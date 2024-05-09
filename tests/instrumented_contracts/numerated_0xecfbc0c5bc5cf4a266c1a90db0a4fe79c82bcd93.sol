1 pragma solidity ^0.4.11;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) constant returns (uint);
10   function allowance(address owner, address spender) constant returns (uint);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transferFrom(address from, address to, uint value) returns (bool ok);
14   function approve(address spender, uint value) returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 
65   function assert(bool assertion) internal {
66     if (!assertion) {
67       throw;
68     }
69   }
70 }
71 
72 
73 
74 /**
75  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
76  *
77  * Based on code by FirstBlood:
78  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, SafeMath {
81 
82   /* Token supply got increased and a new owner received these tokens */
83   event Minted(address receiver, uint amount);
84 
85   /* Actual balances of token holders */
86   mapping(address => uint) balances;
87 
88   /* approve() allowances */
89   mapping (address => mapping (address => uint)) allowed;
90 
91   /**
92    *
93    * Fix for the ERC20 short address attack
94    *
95    * http://vessenes.com/the-erc20-short-address-attack-explained/
96    */
97   modifier onlyPayloadSize(uint size) {
98      if(msg.data.length != size + 4) {
99        throw;
100      }
101      _;
102   }
103 
104   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
105     balances[msg.sender] = safeSub(balances[msg.sender], _value);
106     balances[_to] = safeAdd(balances[_to], _value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
112     uint _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
115     // if (_value > _allowance) throw;
116 
117     balances[_to] = safeAdd(balances[_to], _value);
118     balances[_from] = safeSub(balances[_from], _value);
119     allowed[_from][msg.sender] = safeSub(_allowance, _value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   function balanceOf(address _owner) constant returns (uint balance) {
125     return balances[_owner];
126   }
127 
128   function approve(address _spender, uint _value) returns (bool success) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     //  allowance to zero by calling `approve(_spender, 0)` if it is not
132     //  already 0 to mitigate the race condition described here:
133     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   function allowance(address _owner, address _spender) constant returns (uint remaining) {
142     return allowed[_owner][_spender];
143   }
144 
145   /**
146    * Atomic increment of approved spending
147    *
148    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    *
150    */
151   function addApproval(address _spender, uint _addedValue)
152   onlyPayloadSize(2 * 32)
153   returns (bool success) {
154       uint oldValue = allowed[msg.sender][_spender];
155       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
156       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157       return true;
158   }
159 
160   /**
161    * Atomic decrement of approved spending.
162    *
163    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    */
165   function subApproval(address _spender, uint _subtractedValue)
166   onlyPayloadSize(2 * 32)
167   returns (bool success) {
168 
169       uint oldVal = allowed[msg.sender][_spender];
170 
171       if (_subtractedValue > oldVal) {
172           allowed[msg.sender][_spender] = 0;
173       } else {
174           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
175       }
176       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177       return true;
178   }
179 
180 }
181 
182 
183 
184 contract BurnableToken is StandardToken {
185 
186   address public constant BURN_ADDRESS = 0;
187 
188   /** How many tokens we burned */
189   event Burned(address burner, uint burnedAmount);
190 
191   /**
192    * Burn extra tokens from a balance.
193    *
194    */
195   function burn(uint burnAmount) {
196     address burner = msg.sender;
197     balances[burner] = safeSub(balances[burner], burnAmount);
198     totalSupply = safeSub(totalSupply, burnAmount);
199     Burned(burner, burnAmount);
200   }
201 }
202 
203 
204 
205 
206 
207 /**
208  * Upgrade agent interface inspired by Lunyr.
209  *
210  * Upgrade agent transfers tokens to a new contract.
211  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
212  */
213 contract UpgradeAgent {
214 
215   uint public originalSupply;
216 
217   /** Interface marker */
218   function isUpgradeAgent() public constant returns (bool) {
219     return true;
220   }
221 
222   function upgradeFrom(address _from, uint256 _value) public;
223 
224 }
225 
226 
227 /**
228  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
229  *
230  * First envisioned by Golem and Lunyr projects.
231  */
232 contract UpgradeableToken is StandardToken {
233 
234   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
235   address public upgradeMaster;
236 
237   /** The next contract where the tokens will be migrated. */
238   UpgradeAgent public upgradeAgent;
239 
240   /** How many tokens we have upgraded by now. */
241   uint256 public totalUpgraded;
242 
243   /**
244    * Upgrade states.
245    *
246    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
247    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
248    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
249    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
250    *
251    */
252   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
253 
254   /**
255    * Somebody has upgraded some of his tokens.
256    */
257   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
258 
259   /**
260    * New upgrade agent available.
261    */
262   event UpgradeAgentSet(address agent);
263 
264   /**
265    * Do not allow construction without upgrade master set.
266    */
267   function UpgradeableToken(address _upgradeMaster) {
268     upgradeMaster = _upgradeMaster;
269   }
270 
271   /**
272    * Allow the token holder to upgrade some of their tokens to a new contract.
273    */
274   function upgrade(uint256 value) public {
275 
276       UpgradeState state = getUpgradeState();
277       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
278         // Called in a bad state
279         throw;
280       }
281 
282       // Validate input value.
283       if (value == 0) throw;
284 
285       balances[msg.sender] = safeSub(balances[msg.sender], value);
286 
287       // Take tokens out from circulation
288       totalSupply = safeSub(totalSupply, value);
289       totalUpgraded = safeAdd(totalUpgraded, value);
290 
291       // Upgrade agent reissues the tokens
292       upgradeAgent.upgradeFrom(msg.sender, value);
293       Upgrade(msg.sender, upgradeAgent, value);
294   }
295 
296   /**
297    * Set an upgrade agent that handles
298    */
299   function setUpgradeAgent(address agent) external {
300 
301       if(!canUpgrade()) {
302         // The token is not yet in a state that we could think upgrading
303         throw;
304       }
305 
306       if (agent == 0x0) throw;
307       // Only a master can designate the next agent
308       if (msg.sender != upgradeMaster) throw;
309       // Upgrade has already begun for an agent
310       if (getUpgradeState() == UpgradeState.Upgrading) throw;
311 
312       upgradeAgent = UpgradeAgent(agent);
313 
314       // Bad interface
315       if(!upgradeAgent.isUpgradeAgent()) throw;
316       // Make sure that token supplies match in source and target
317       if (upgradeAgent.originalSupply() != totalSupply) throw;
318 
319       UpgradeAgentSet(upgradeAgent);
320   }
321 
322   /**
323    * Get the state of the token upgrade.
324    */
325   function getUpgradeState() public constant returns(UpgradeState) {
326     if(!canUpgrade()) return UpgradeState.NotAllowed;
327     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
328     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
329     else return UpgradeState.Upgrading;
330   }
331 
332   /**
333    * Change the upgrade master.
334    *
335    * This allows us to set a new owner for the upgrade mechanism.
336    */
337   function setUpgradeMaster(address master) public {
338       if (master == 0x0) throw;
339       if (msg.sender != upgradeMaster) throw;
340       upgradeMaster = master;
341   }
342 
343   /**
344    * Child contract can enable to provide the condition when the upgrade can begun.
345    */
346   function canUpgrade() public constant returns(bool) {
347      return true;
348   }
349 
350 }
351 
352 
353 contract HYIPToken is BurnableToken, UpgradeableToken {
354 
355   string public name;
356   string public symbol;
357   uint public decimals;
358   address public owner;
359 
360   /** List of agents that are allowed to create new tokens */
361   mapping (address => bool) public mintAgents;
362 
363   event MintingAgentChanged(address addr, bool state);
364 
365   /**
366    * Create new tokens and allocate them to an address..
367    *
368    * Only callably by a crowdsale contract (mint agent).
369    */
370   function mint(address receiver, uint amount) onlyMintAgent public {
371     totalSupply = totalSupply + amount;
372     balances[receiver] = balances[receiver] + amount;
373 
374     // This will make the mint transaction apper in EtherScan.io
375     // We can remove this after there is a standardized minting event
376     Transfer(0, receiver, amount);
377   }
378 
379   /**
380    * Owner can allow a crowdsale contract to mint new tokens.
381    */
382   function setMintAgent(address addr, bool state) onlyOwner public {
383     mintAgents[addr] = state;
384     MintingAgentChanged(addr, state);
385   }
386 
387   modifier onlyMintAgent() {
388     // Only crowdsale contracts are allowed to mint new tokens
389     if(!mintAgents[msg.sender]) {
390         throw;
391     }
392     _;
393   }
394 
395   modifier onlyOwner() {
396     if (msg.sender != owner) {
397       throw;
398     }
399     _;
400   }
401 
402   function HYIPToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) UpgradeableToken(_owner) {
403     name = _name;
404     symbol = _symbol;
405     totalSupply = _totalSupply;
406     decimals = _decimals;
407 
408     // Allocate initial balance to the owner
409     balances[_owner] = _totalSupply;
410     owner = _owner;
411   }
412 }
413 
414 
415 //
416 
417 
418 contract HYIPCrowdsale1 {
419     address public beneficiary;
420     uint public amountRaised;
421     uint public deadline;
422     uint public price;
423     HYIPToken public tokenReward;
424     bool crowdsaleClosed = false;
425 
426     /* data structure to hold information about campaign contributors */
427 
428     /*  at initialization, setup the owner */
429     function HYIPCrowdsale1(
430         address ifSuccessfulSendTo,
431         uint deadlineTimestamp,
432         uint etherCostOfEachToken,
433         HYIPToken addressOfTokenUsedAsReward
434     ) {
435         beneficiary = ifSuccessfulSendTo;
436         deadline = deadlineTimestamp;
437         price = etherCostOfEachToken;
438         tokenReward = HYIPToken(addressOfTokenUsedAsReward);
439     }
440 
441     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
442     function () payable {
443         if (now >= deadline) throw;
444         uint amount = msg.value;
445         amountRaised += amount;
446         tokenReward.mint(msg.sender, amount / price);
447     }
448 
449     function safeWithdrawal() onlyOwner {
450         beneficiary.transfer(amountRaised);
451     }
452 
453     modifier onlyOwner() {
454         if (msg.sender != beneficiary) {
455             throw;
456         }
457         _;
458     }
459 }