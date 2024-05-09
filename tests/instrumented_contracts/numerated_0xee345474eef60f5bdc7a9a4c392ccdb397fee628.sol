1 pragma solidity ^0.4.12;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 /*
49  * ERC20 interface
50  * see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 {
53   uint256 public totalSupply;
54   function balanceOf(address who) constant returns (uint256);
55   function transfer(address to, uint256 value) returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57     
58   function allowance(address owner, address spender) constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) returns (bool);
60   function approve(address spender, uint256 value) returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 /**
65  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
66  *
67  * Based on code by FirstBlood:
68  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
69  */
70 contract StandardToken is ERC20, SafeMath {
71 
72   /* Token supply got increased and a new owner received these tokens */
73   event Minted(address receiver, uint amount);
74 
75   /* Actual balances of token holders */
76   mapping(address => uint) balances;
77 
78   /* approve() allowances */
79   mapping (address => mapping (address => uint)) allowed;
80 
81   /**
82    *
83    * Fix for the ERC20 short address attack
84    *
85    * http://vessenes.com/the-erc20-short-address-attack-explained/
86    */
87   modifier onlyPayloadSize(uint size) {
88      if(msg.data.length != size + 4) {
89        throw;
90      }
91      _;
92   }
93 
94   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
95     balances[msg.sender] = safeSub(balances[msg.sender], _value);
96     balances[_to] = safeAdd(balances[_to], _value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
102     uint _allowance = allowed[_from][msg.sender];
103 
104     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
105     // if (_value > _allowance) throw;
106 
107     balances[_to] = safeAdd(balances[_to], _value);
108     balances[_from] = safeSub(balances[_from], _value);
109     allowed[_from][msg.sender] = safeSub(_allowance, _value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   function balanceOf(address _owner) constant returns (uint balance) {
115     return balances[_owner];
116   }
117 
118   function approve(address _spender, uint _value) returns (bool success) {
119 
120     // To change the approve amount you first have to reduce the addresses`
121     //  allowance to zero by calling `approve(_spender, 0)` if it is not
122     //  already 0 to mitigate the race condition described here:
123     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
125 
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   function allowance(address _owner, address _spender) constant returns (uint remaining) {
132     return allowed[_owner][_spender];
133   }
134 
135   /**
136    * Atomic increment of approved spending
137    *
138    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139    *
140    */
141   function addApproval(address _spender, uint _addedValue)
142   onlyPayloadSize(2 * 32)
143   returns (bool success) {
144       uint oldValue = allowed[msg.sender][_spender];
145       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
146       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147       return true;
148   }
149 
150   /**
151    * Atomic decrement of approved spending.
152    *
153    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    */
155   function subApproval(address _spender, uint _subtractedValue)
156   onlyPayloadSize(2 * 32)
157   returns (bool success) {
158 
159       uint oldVal = allowed[msg.sender][_spender];
160 
161       if (_subtractedValue > oldVal) {
162           allowed[msg.sender][_spender] = 0;
163       } else {
164           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
165       }
166       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167       return true;
168   }
169 
170 }
171 
172 contract BurnableToken is StandardToken {
173 
174   address public constant BURN_ADDRESS = 0;
175 
176   /** How many tokens we burned */
177   event Burned(address burner, uint burnedAmount);
178 
179   /**
180    * Burn extra tokens from a balance.
181    *
182    */
183   function burn(uint burnAmount) {
184     address burner = msg.sender;
185     balances[burner] = safeSub(balances[burner], burnAmount);
186     totalSupply = safeSub(totalSupply, burnAmount);
187     Burned(burner, burnAmount);
188   }
189 }
190 
191 /**
192  * Upgrade agent interface inspired by Lunyr.
193  *
194  * Upgrade agent transfers tokens to a new contract.
195  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
196  */
197 contract UpgradeAgent {
198 
199   uint public originalSupply;
200 
201   /** Interface marker */
202   function isUpgradeAgent() public constant returns (bool) {
203     return true;
204   }
205 
206   function upgradeFrom(address _from, uint256 _value) public;
207 
208 }
209 
210 /**
211  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
212  *
213  * First envisioned by Golem and Lunyr projects.
214  */
215 contract UpgradeableToken is StandardToken {
216 
217   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
218   address public upgradeMaster;
219 
220   /** The next contract where the tokens will be migrated. */
221   UpgradeAgent public upgradeAgent;
222 
223   /** How many tokens we have upgraded by now. */
224   uint256 public totalUpgraded;
225 
226   /**
227    * Upgrade states.
228    *
229    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
230    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
231    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
232    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
233    *
234    */
235   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
236 
237   /**
238    * Somebody has upgraded some of his tokens.
239    */
240   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
241 
242   /**
243    * New upgrade agent available.
244    */
245   event UpgradeAgentSet(address agent);
246 
247   /**
248    * Do not allow construction without upgrade master set.
249    */
250   function UpgradeableToken(address _upgradeMaster) {
251     upgradeMaster = _upgradeMaster;
252   }
253 
254   /**
255    * Allow the token holder to upgrade some of their tokens to a new contract.
256    */
257   function upgrade(uint256 value) public {
258 
259       UpgradeState state = getUpgradeState();
260       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
261         // Called in a bad state
262         throw;
263       }
264 
265       // Validate input value.
266       if (value == 0) throw;
267 
268       balances[msg.sender] = safeSub(balances[msg.sender], value);
269 
270       // Take tokens out from circulation
271       totalSupply = safeSub(totalSupply, value);
272       totalUpgraded = safeAdd(totalUpgraded, value);
273 
274       // Upgrade agent reissues the tokens
275       upgradeAgent.upgradeFrom(msg.sender, value);
276       Upgrade(msg.sender, upgradeAgent, value);
277   }
278 
279   /**
280    * Set an upgrade agent that handles
281    */
282   function setUpgradeAgent(address agent) external {
283 
284       if(!canUpgrade()) {
285         // The token is not yet in a state that we could think upgrading
286         throw;
287       }
288 
289       if (agent == 0x0) throw;
290       // Only a master can designate the next agent
291       if (msg.sender != upgradeMaster) throw;
292       // Upgrade has already begun for an agent
293       if (getUpgradeState() == UpgradeState.Upgrading) throw;
294 
295       upgradeAgent = UpgradeAgent(agent);
296 
297       // Bad interface
298       if(!upgradeAgent.isUpgradeAgent()) throw;
299       // Make sure that token supplies match in source and target
300       if (upgradeAgent.originalSupply() != totalSupply) throw;
301 
302       UpgradeAgentSet(upgradeAgent);
303   }
304 
305   /**
306    * Get the state of the token upgrade.
307    */
308   function getUpgradeState() public constant returns(UpgradeState) {
309     if(!canUpgrade()) return UpgradeState.NotAllowed;
310     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
311     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
312     else return UpgradeState.Upgrading;
313   }
314 
315   /**
316    * Change the upgrade master.
317    *
318    * This allows us to set a new owner for the upgrade mechanism.
319    */
320   function setUpgradeMaster(address master) public {
321       if (master == 0x0) throw;
322       if (msg.sender != upgradeMaster) throw;
323       upgradeMaster = master;
324   }
325 
326   /**
327    * Child contract can enable to provide the condition when the upgrade can begun.
328    */
329   function canUpgrade() public constant returns(bool) {
330      return true;
331   }
332 
333 }
334 
335 contract BioCoin is BurnableToken, UpgradeableToken {
336 
337   string public name;
338   string public symbol;
339   uint public decimals;
340 
341   function BioCoin(address _owner)  UpgradeableToken(_owner) {
342     name = "BioCoin";
343     symbol = "BIOCOIN";
344     totalSupply = 1000000000000000000000000000;
345     decimals = 18;
346 
347     balances[_owner] = totalSupply;
348   }
349 }
350 
351 contract BioCoinPreSale {
352     BioCoin public token;
353     address public beneficiary;
354     address public alfatokenteam;
355     uint public amountRaised;
356     uint public bonus;
357 
358     uint constant public price = 3330000000000000;
359     uint constant public minSaleAmount = 1000000000000000000;
360 
361     function BioCoinPreSale(
362         BioCoin _token,
363         address _beneficiary,
364         address _alfatokenteam,
365         uint _bonus
366     ) {
367         token = BioCoin(_token);
368         beneficiary = _beneficiary;
369         alfatokenteam = _alfatokenteam;
370         bonus = _bonus;
371     }
372 
373     function () payable {
374         uint amount = msg.value;
375         uint tokenAmount = (amount / price) * 1000000000000000000;
376         if (tokenAmount < minSaleAmount) throw;
377         amountRaised += amount;
378         token.transfer(msg.sender, tokenAmount * (100 + bonus) / 100);
379     }
380 
381     function WithdrawETH(uint _amount) {
382         require(msg.sender == alfatokenteam);
383         msg.sender.transfer(_amount);
384     }
385 
386     function WithdrawTokens(uint _amount) {
387         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
388         token.transfer(beneficiary, _amount);
389     }
390 
391     function TransferTokens(address _to, uint _amount) {
392         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
393         token.transfer(_to, _amount);
394     }
395 
396     function ChangeBonus(uint _bonus) {
397         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
398         bonus = _bonus;
399     }
400 }