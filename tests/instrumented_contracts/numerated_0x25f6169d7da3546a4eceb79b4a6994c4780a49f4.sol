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
169 }
170 
171 contract BurnableToken is StandardToken {
172 
173   address public constant BURN_ADDRESS = 0;
174 
175   /** How many tokens we burned */
176   event Burned(address burner, uint burnedAmount);
177 
178   /**
179    * Burn extra tokens from a balance.
180    *
181    */
182   function burn(uint burnAmount) {
183     address burner = msg.sender;
184     balances[burner] = safeSub(balances[burner], burnAmount);
185     totalSupply = safeSub(totalSupply, burnAmount);
186     Burned(burner, burnAmount);
187   }
188 }
189 
190 /**
191  * Upgrade agent interface inspired by Lunyr.
192  *
193  * Upgrade agent transfers tokens to a new contract.
194  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
195  */
196 contract UpgradeAgent {
197 
198   uint public originalSupply;
199 
200   /** Interface marker */
201   function isUpgradeAgent() public constant returns (bool) {
202     return true;
203   }
204 
205   function upgradeFrom(address _from, uint256 _value) public;
206 
207 }
208 
209 /**
210  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
211  *
212  * First envisioned by Golem and Lunyr projects.
213  */
214 contract UpgradeableToken is StandardToken {
215 
216   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
217   address public upgradeMaster;
218 
219   /** The next contract where the tokens will be migrated. */
220   UpgradeAgent public upgradeAgent;
221 
222   /** How many tokens we have upgraded by now. */
223   uint256 public totalUpgraded;
224 
225   /**
226    * Upgrade states.
227    *
228    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
229    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
230    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
231    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
232    *
233    */
234   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
235 
236   /**
237    * Somebody has upgraded some of his tokens.
238    */
239   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
240 
241   /**
242    * New upgrade agent available.
243    */
244   event UpgradeAgentSet(address agent);
245 
246   /**
247    * Do not allow construction without upgrade master set.
248    */
249   function UpgradeableToken(address _upgradeMaster) {
250     upgradeMaster = _upgradeMaster;
251   }
252 
253   /**
254    * Allow the token holder to upgrade some of their tokens to a new contract.
255    */
256   function upgrade(uint256 value) public {
257 
258       UpgradeState state = getUpgradeState();
259       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
260         // Called in a bad state
261         throw;
262       }
263 
264       // Validate input value.
265       if (value == 0) throw;
266 
267       balances[msg.sender] = safeSub(balances[msg.sender], value);
268 
269       // Take tokens out from circulation
270       totalSupply = safeSub(totalSupply, value);
271       totalUpgraded = safeAdd(totalUpgraded, value);
272 
273       // Upgrade agent reissues the tokens
274       upgradeAgent.upgradeFrom(msg.sender, value);
275       Upgrade(msg.sender, upgradeAgent, value);
276   }
277 
278   /**
279    * Set an upgrade agent that handles
280    */
281   function setUpgradeAgent(address agent) external {
282 
283       if(!canUpgrade()) {
284         // The token is not yet in a state that we could think upgrading
285         throw;
286       }
287 
288       if (agent == 0x0) throw;
289       // Only a master can designate the next agent
290       if (msg.sender != upgradeMaster) throw;
291       // Upgrade has already begun for an agent
292       if (getUpgradeState() == UpgradeState.Upgrading) throw;
293 
294       upgradeAgent = UpgradeAgent(agent);
295 
296       // Bad interface
297       if(!upgradeAgent.isUpgradeAgent()) throw;
298       // Make sure that token supplies match in source and target
299       if (upgradeAgent.originalSupply() != totalSupply) throw;
300 
301       UpgradeAgentSet(upgradeAgent);
302   }
303 
304   /**
305    * Get the state of the token upgrade.
306    */
307   function getUpgradeState() public constant returns(UpgradeState) {
308     if(!canUpgrade()) return UpgradeState.NotAllowed;
309     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
310     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
311     else return UpgradeState.Upgrading;
312   }
313 
314   /**
315    * Change the upgrade master.
316    *
317    * This allows us to set a new owner for the upgrade mechanism.
318    */
319   function setUpgradeMaster(address master) public {
320       if (master == 0x0) throw;
321       if (msg.sender != upgradeMaster) throw;
322       upgradeMaster = master;
323   }
324 
325   /**
326    * Child contract can enable to provide the condition when the upgrade can begun.
327    */
328   function canUpgrade() public constant returns(bool) {
329      return true;
330   }
331 
332 }
333 
334 contract Aeternis is BurnableToken, UpgradeableToken {
335 
336   string public name;
337   string public symbol;
338   uint public decimals;
339 
340   function Aeternis(address _owner)  UpgradeableToken(_owner) {
341     name = "Aeternis";
342     symbol = "AET";
343     totalSupply = 1000000000000000000000000000;
344     decimals = 18;
345 
346     balances[_owner] = totalSupply;
347   }
348 }
349 
350 contract AeternisPreSale {
351     Aeternis public token;
352     address public beneficiary;
353     address public alfatokenteam;
354     
355     uint public amountRaised;
356     
357     uint public bonus;
358     uint public price;    
359     
360     uint constant public minSaleAmount = 1000000000000000000;
361 
362     function AeternisPreSale(
363         Aeternis _token,
364         address _beneficiary,
365         address _alfatokenteam
366     ) {
367         token = Aeternis(_token);
368         beneficiary = _beneficiary;
369         alfatokenteam = _alfatokenteam;
370         bonus = 60;
371         price = 300;
372     }
373 
374     function () payable {
375         uint amount = msg.value;
376         uint tokenAmount = amount * price;
377         if (tokenAmount < minSaleAmount) throw;
378         amountRaised += amount;
379         token.transfer(msg.sender, tokenAmount * (100 + bonus) / 100);
380     }
381 
382     function TransferETH(address _to, uint _amount) {
383         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
384         _to.transfer(_amount);
385     }
386 
387     function TransferTokens(address _to, uint _amount) {
388         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
389         token.transfer(_to, _amount);
390     }
391 
392     function ChangeBonus(uint _bonus) {
393         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
394         bonus = _bonus;
395     }
396     
397     function ChangePrice(uint _price) {
398         require(msg.sender == beneficiary || msg.sender == alfatokenteam);
399         price = _price;
400     }
401 }