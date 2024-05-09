1 pragma solidity ^0.4.13;
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
28   function safeMul(uint a, uint b) internal returns (uint) {
29     uint c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function safeDiv(uint a, uint b) internal returns (uint) {
35     assert(b > 0);
36     uint c = a / b;
37     assert(a == b * c + a % b);
38     return c;
39   }
40 
41   function safeSub(uint a, uint b) internal returns (uint) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function safeAdd(uint a, uint b) internal returns (uint) {
47     uint c = a + b;
48     assert(c>=a && c>=b);
49     return c;
50   }
51 
52   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a >= b ? a : b;
54   }
55 
56   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
57     return a < b ? a : b;
58   }
59 
60   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a >= b ? a : b;
62   }
63 
64   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
65     return a < b ? a : b;
66   }
67 
68   function assert(bool assertion) internal {
69     if (!assertion) {
70       revert();
71     }
72   }
73 }
74 
75 
76 
77 /**
78  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
79  *
80  * Based on code by FirstBlood:
81  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
82  */
83 contract StandardToken is ERC20, SafeMath {
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
108     balances[msg.sender] = safeSub(balances[msg.sender], _value);
109     balances[_to] = safeAdd(balances[_to], _value);
110     Transfer(msg.sender, _to, _value);
111 
112     if (isContract(_to)) {
113       ContractReceiver rx = ContractReceiver(_to);
114       rx.tokenFallback(msg.sender, _value);
115     }
116 
117     return true;
118   }
119 
120   // ERC223 fetch contract size (must be nonzero to be a contract)
121   function isContract( address _addr ) private returns (bool) {
122     uint length;
123     _addr = _addr;
124     assembly { length := extcodesize(_addr) }
125     return (length > 0);
126   }
127 
128   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
129     uint _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
132     // if (_value > _allowance) revert();
133 
134     balances[_to] = safeAdd(balances[_to], _value);
135     balances[_from] = safeSub(balances[_from], _value);
136     allowed[_from][msg.sender] = safeSub(_allowance, _value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   function balanceOf(address _owner) public constant returns (uint balance) {
142     return balances[_owner];
143   }
144 
145   function approve(address _spender, uint _value) public returns (bool success) {
146 
147     // To change the approve amount you first have to reduce the addresses`
148     //  allowance to zero by calling `approve(_spender, 0)` if it is not
149     //  already 0 to mitigate the race condition described here:
150     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
152 
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
159     return allowed[_owner][_spender];
160   }
161 
162   /**
163    * Atomic increment of approved spending
164    *
165    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    *
167    */
168   function addApproval(address _spender, uint _addedValue) public
169   onlyPayloadSize(2 * 32)
170   returns (bool success) {
171       uint oldValue = allowed[msg.sender][_spender];
172       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
173       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174       return true;
175   }
176 
177   /**
178    * Atomic decrement of approved spending.
179    *
180    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    */
182   function subApproval(address _spender, uint _subtractedValue) public
183   onlyPayloadSize(2 * 32)
184   returns (bool success) {
185 
186       uint oldVal = allowed[msg.sender][_spender];
187 
188       if (_subtractedValue > oldVal) {
189           allowed[msg.sender][_spender] = 0;
190       } else {
191           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
192       }
193       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194       return true;
195   }
196 
197 }
198 
199 
200 
201 contract BurnableToken is StandardToken {
202 
203   address public constant BURN_ADDRESS = 0;
204 
205   /** How many tokens we burned */
206   event Burned(address burner, uint burnedAmount);
207 
208   /**
209    * Burn extra tokens from a balance.
210    *
211    */
212   function burn(uint burnAmount) public {
213     address burner = msg.sender;
214     balances[burner] = safeSub(balances[burner], burnAmount);
215     totalSupply = safeSub(totalSupply, burnAmount);
216     Burned(burner, burnAmount);
217   }
218 }
219 
220 
221 
222 
223 
224 /**
225  * Upgrade agent interface inspired by Lunyr.
226  *
227  * Upgrade agent transfers tokens to a new contract.
228  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
229  */
230 contract UpgradeAgent {
231 
232   uint public originalSupply;
233 
234   /** Interface marker */
235   function isUpgradeAgent() public constant returns (bool) {
236     return true;
237   }
238 
239   function upgradeFrom(address _from, uint256 _value) public;
240 
241 }
242 
243 
244 /**
245  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
246  *
247  * First envisioned by Golem and Lunyr projects.
248  */
249 contract UpgradeableToken is StandardToken {
250 
251   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
252   address public upgradeMaster;
253 
254   /** The next contract where the tokens will be migrated. */
255   UpgradeAgent public upgradeAgent;
256 
257   /** How many tokens we have upgraded by now. */
258   uint256 public totalUpgraded;
259 
260   /**
261    * Upgrade states.
262    *
263    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
264    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
265    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
266    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
267    *
268    */
269   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
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
363   function canUpgrade() public constant returns(bool) {
364      return true;
365   }
366 
367 }
368 
369 
370 contract MTRCToken is BurnableToken, UpgradeableToken {
371 
372   string public name;
373   string public symbol;
374   uint public decimals;
375   address public owner;
376 
377   bool public mintingFinished = false;
378 
379   mapping(address => uint) public previligedBalances;
380 
381   /** List of agents that are allowed to create new tokens */
382   mapping(address => bool) public mintAgents;
383   event MintingAgentChanged(address addr, bool state);
384 
385   modifier onlyOwner() {
386     if(msg.sender != owner) revert();
387     _;
388   }
389 
390   modifier onlyMintAgent() {
391     // Only crowdsale contracts are allowed to mint new tokens
392     if(!mintAgents[msg.sender]) revert();
393     _;
394   }
395 
396   /** Make sure we are not done yet. */
397   modifier canMint() {
398     if(mintingFinished) revert();
399     _;
400   }
401 
402   function transferOwnership(address newOwner) public onlyOwner {
403     if (newOwner != address(0)) {
404       owner = newOwner;
405     }
406   }
407 
408   function MTRCToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) public UpgradeableToken(_owner) {
409     name = _name;
410     symbol = _symbol;
411     totalSupply = _totalSupply;
412     decimals = _decimals;
413 
414     // Allocate initial balance to the owner
415     balances[_owner] = _totalSupply;
416 
417     // save the owner
418     owner = _owner;
419   }
420 
421   // privileged transfer
422   function transferPrivileged(address _to, uint _value) public onlyOwner returns (bool success) {
423     balances[msg.sender] = safeSub(balances[msg.sender], _value);
424     balances[_to] = safeAdd(balances[_to], _value);
425     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
426     Transfer(msg.sender, _to, _value);
427     return true;
428   }
429 
430   // get priveleged balance
431   function getPrivilegedBalance(address _owner) public constant returns (uint balance) {
432     return previligedBalances[_owner];
433   }
434 
435   // admin only can transfer from the privileged accounts
436   function transferFromPrivileged(address _from, address _to, uint _value) public onlyOwner returns (bool success) {
437     uint availablePrevilegedBalance = previligedBalances[_from];
438 
439     balances[_from] = safeSub(balances[_from], _value);
440     balances[_to] = safeAdd(balances[_to], _value);
441     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
442     Transfer(_from, _to, _value);
443     return true;
444   }
445 
446   /**
447    * Create new tokens and allocate them to an address..
448    *
449    * Only callably by a crowdsale contract (mint agent).
450    */
451   function mint(address receiver, uint amount) onlyMintAgent canMint public {
452     totalSupply = safeAdd(totalSupply, amount);
453     balances[receiver] = safeAdd(balances[receiver], amount);
454 
455     // This will make the mint transaction apper in EtherScan.io
456     // We can remove this after there is a standardized minting event
457     Transfer(0, receiver, amount);
458   }
459 
460   /**
461    * Owner can allow a crowdsale contract to mint new tokens.
462    */
463   function setMintAgent(address addr, bool state) onlyOwner canMint public {
464     mintAgents[addr] = state;
465     MintingAgentChanged(addr, state);
466   }
467 
468 }