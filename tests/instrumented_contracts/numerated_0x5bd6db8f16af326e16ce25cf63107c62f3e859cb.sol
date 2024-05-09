1 pragma solidity ^0.4.24;
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
69 /**
70  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
71  *
72  * Based on code by FirstBlood:
73  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
74  */
75 contract StandardToken is ERC20, SafeMath {
76 
77   /* Actual balances of token holders */
78   mapping(address => uint) balances;
79 
80   /* approve() allowances */
81   mapping (address => mapping (address => uint)) allowed;
82 
83   /**
84    *
85    * Fix for the ERC20 short address attack
86    *
87    * http://vessenes.com/the-erc20-short-address-attack-explained/
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length != size + 4) {
91        revert();
92      }
93      _;
94   }
95 
96   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
97     balances[msg.sender] = safeSub(balances[msg.sender], _value);
98     balances[_to] = safeAdd(balances[_to], _value);
99     emit Transfer(msg.sender, _to, _value);
100 
101     if (isContract(_to)) {
102       ContractReceiver rx = ContractReceiver(_to);
103       rx.tokenFallback(msg.sender, _value);
104     }
105 
106     return true;
107   }
108 
109   // ERC223 fetch contract size (must be nonzero to be a contract)
110   function isContract( address _addr ) view private returns (bool) {
111     uint length;
112     _addr = _addr;
113     assembly { length := extcodesize(_addr) }
114     return (length > 0);
115   }
116 
117   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
118     uint _allowance = allowed[_from][msg.sender];
119 
120     balances[_to] = safeAdd(balances[_to], _value);
121     balances[_from] = safeSub(balances[_from], _value);
122     allowed[_from][msg.sender] = safeSub(_allowance, _value);
123     emit Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   function balanceOf(address _owner) public constant returns (uint balance) {
128     return balances[_owner];
129   }
130 
131   function approve(address _spender, uint _value) public returns (bool success) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
138 
139     allowed[msg.sender][_spender] = _value;
140     emit Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * Atomic increment of approved spending
150    *
151    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    *
153    */
154   function addApproval(address _spender, uint _addedValue)
155   onlyPayloadSize(2 * 32)
156   public returns (bool success) {
157       uint oldValue = allowed[msg.sender][_spender];
158       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
159       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160       return true;
161   }
162 
163   /**
164    * Atomic decrement of approved spending.
165    *
166    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    */
168   function subApproval(address _spender, uint _subtractedValue)
169   onlyPayloadSize(2 * 32)
170   public returns (bool success) {
171 
172       uint oldVal = allowed[msg.sender][_spender];
173 
174       if (_subtractedValue > oldVal) {
175           allowed[msg.sender][_spender] = 0;
176       } else {
177           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
178       }
179       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180       return true;
181   }
182 
183 }
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
196   function burn(uint burnAmount) public {
197     address burner = msg.sender;
198     balances[burner] = safeSub(balances[burner], burnAmount);
199     totalSupply = safeSub(totalSupply, burnAmount);
200     emit Burned(burner, burnAmount);
201   }
202 }
203 
204 /**
205  * Upgrade agent interface inspired by Lunyr.
206  *
207  * Upgrade agent transfers tokens to a new contract.
208  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
209  */
210 contract UpgradeAgent {
211 
212   uint public originalSupply;
213 
214   /** Interface marker */
215   function isUpgradeAgent() public pure returns (bool) {
216     return true;
217   }
218 
219   function upgradeFrom(address _from, uint256 _value) public;
220 
221 }
222 
223 /**
224  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
225  *
226  * First envisioned by Golem and Lunyr projects.
227  */
228 contract UpgradeableToken is StandardToken {
229 
230   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
231   address public upgradeMaster;
232 
233   /** The next contract where the tokens will be migrated. */
234   UpgradeAgent public upgradeAgent;
235 
236   /** How many tokens we have upgraded by now. */
237   uint256 public totalUpgraded;
238 
239   /**
240    * Upgrade states.
241    *
242    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
243    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
244    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
245    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
246    *
247    */
248   enum UpgradeState {
249     Unknown, 
250     NotAllowed, 
251     WaitingForAgent, 
252     ReadyToUpgrade, 
253     Upgrading
254   }
255 
256   /**
257    * Somebody has upgraded some of his tokens.
258    */
259   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
260 
261   /**
262    * New upgrade agent available.
263    */
264   event UpgradeAgentSet(address agent);
265 
266   /**
267    * Do not allow construction without upgrade master set.
268    */
269   constructor(address _upgradeMaster) public {
270     upgradeMaster = _upgradeMaster;
271   }
272 
273   /**
274    * Allow the token holder to upgrade some of their tokens to a new contract.
275    */
276   function upgrade(uint256 value) public {
277 
278       UpgradeState state = getUpgradeState();
279       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
280         // Called in a bad state
281         revert();
282       }
283 
284       // Validate input value.
285       if (value == 0) revert();
286 
287       balances[msg.sender] = safeSub(balances[msg.sender], value);
288 
289       // Take tokens out from circulation
290       totalSupply = safeSub(totalSupply, value);
291       totalUpgraded = safeAdd(totalUpgraded, value);
292 
293       // Upgrade agent reissues the tokens
294       upgradeAgent.upgradeFrom(msg.sender, value);
295       emit Upgrade(msg.sender, upgradeAgent, value);
296   }
297 
298   /**
299    * Set an upgrade agent that handles
300    */
301   function setUpgradeAgent(address agent) external {
302 
303       if(!canUpgrade()) {
304         // The token is not yet in a state that we could think upgrading
305         revert();
306       }
307 
308       if (agent == 0x0) revert();
309       // Only a master can designate the next agent
310       if (msg.sender != upgradeMaster) revert();
311       // Upgrade has already begun for an agent
312       if (getUpgradeState() == UpgradeState.Upgrading) revert();
313 
314       upgradeAgent = UpgradeAgent(agent);
315 
316       // Bad interface
317       if(!upgradeAgent.isUpgradeAgent()) revert();
318       // Make sure that token supplies match in source and target
319       if (upgradeAgent.originalSupply() != totalSupply) revert();
320 
321       emit UpgradeAgentSet(upgradeAgent);
322   }
323 
324   /**
325    * Get the state of the token upgrade.
326    */
327   function getUpgradeState() public constant returns(UpgradeState) {
328     if(!canUpgrade()) return UpgradeState.NotAllowed;
329     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
330     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
331     else return UpgradeState.Upgrading;
332   }
333 
334   /**
335    * Change the upgrade master.
336    *
337    * This allows us to set a new owner for the upgrade mechanism.
338    */
339   function setUpgradeMaster(address master) public {
340       if (master == 0x0) revert();
341       if (msg.sender != upgradeMaster) revert();
342       upgradeMaster = master;
343   }
344 
345   /**
346    * Child contract can enable to provide the condition when the upgrade can begun.
347    */
348   function canUpgrade() public pure returns(bool) {
349      return true;
350   }
351 }
352 
353 contract WLDFiniteToken is BurnableToken, UpgradeableToken {
354 
355   string public name;
356   string public symbol;
357   uint8 public decimals;
358   address public owner;
359 
360   mapping(address => uint) public previligedBalances;
361 
362   modifier onlyOwner() {
363     if(msg.sender != owner) revert();
364     _;
365   }
366 
367   function transferOwnership(address newOwner) onlyOwner public {
368     if (newOwner != address(0)) {
369       owner = newOwner;
370     }
371   }
372 
373   constructor(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) UpgradeableToken(_owner) public {
374     uint calculatedSupply = _totalSupply * 10 ** uint(_decimals);
375     name = _name;
376     symbol = _symbol;
377     totalSupply = calculatedSupply;
378     decimals = _decimals;
379 
380     // Allocate initial balance to the owner
381     balances[_owner] = calculatedSupply;
382 
383     // save the owner
384     owner = _owner;
385   }
386 
387   // privileged transfer
388   function transferPrivileged(address _to, uint _value) onlyOwner public returns (bool success) {
389     balances[msg.sender] = safeSub(balances[msg.sender], _value);
390     balances[_to] = safeAdd(balances[_to], _value);
391     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
392     emit Transfer(msg.sender, _to, _value);
393     return true;
394   }
395 
396   // get priveleged balance
397   function getPrivilegedBalance(address _owner) public constant returns (uint balance) {
398     return previligedBalances[_owner];
399   }
400 
401   // admin only can transfer from the privileged accounts
402   function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner public returns (bool success) {
403     uint availablePrevilegedBalance = previligedBalances[_from];
404 
405     balances[_from] = safeSub(balances[_from], _value);
406     balances[_to] = safeAdd(balances[_to], _value);
407     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
408     emit Transfer(_from, _to, _value);
409     return true;
410   }
411 }