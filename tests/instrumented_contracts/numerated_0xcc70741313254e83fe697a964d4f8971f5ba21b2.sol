1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 
72 /**
73  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
74  *
75  * Based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, SafeMath {
79 
80   mapping(address => uint) balances;
81   mapping (address => mapping (address => uint)) allowed;
82 
83   // Interface marker
84   bool public constant isToken = true;
85 
86   /**
87    *
88    * Fix for the ERC20 short address attack
89    *
90    * http://vessenes.com/the-erc20-short-address-attack-explained/
91    */
92   modifier onlyPayloadSize(uint size) {
93      if(msg.data.length < size + 4) {
94        throw;
95      }
96      _;
97   }
98 
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
100     balances[msg.sender] = safeSub(balances[msg.sender], _value);
101     balances[_to] = safeAdd(balances[_to], _value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
110     // if (_value > _allowance) throw;
111 
112     balances[_to] = safeAdd(balances[_to], _value);
113     balances[_from] = safeSub(balances[_from], _value);
114     allowed[_from][msg.sender] = safeSub(_allowance, _value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123   function approve(address _spender, uint _value) returns (bool success) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   function allowance(address _owner, address _spender) constant returns (uint remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140 }
141 
142 
143 
144 /*
145  * Ownable
146  *
147  * Base contract with an owner.
148  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
149  */
150 contract Ownable {
151   address public owner;
152 
153   function Ownable() {
154     owner = msg.sender;
155   }
156 
157   modifier onlyOwner() {
158     if (msg.sender != owner) {
159       throw;
160     }
161     _;
162   }
163 
164   function transferOwnership(address newOwner) onlyOwner {
165     if (newOwner != address(0)) {
166       owner = newOwner;
167     }
168   }
169 
170 }
171 
172 
173 /**
174  * Hold tokens for a group investor of investors until the unlock date.
175  *
176  * After the unlock date the investor can claim their tokens.
177  *
178  * Steps
179  *
180  * - Prepare a spreadsheet for token allocation
181  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
182  * - Call setInvestor for all investors from the owner account using a local script and CSV input
183  * - Move tokensToBeAllocated in this contract usign StandardToken.transfer()
184  * - Call lock from the owner account
185  * - Wait until the freeze period is over
186  * - After the freeze time is over investors can call claim() from their address to get their tokens
187  *
188  */
189 contract TokenVault is Ownable {
190 
191   /** How many investors we have now */
192   uint public investorCount;
193 
194   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
195   uint public tokensToBeAllocated;
196 
197   /** How many tokens investors have claimed so far */
198   uint public totalClaimed;
199 
200   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
201   uint public tokensAllocatedTotal;
202 
203   /** How much we have allocated to the investors invested */
204   mapping(address => uint) public balances;
205 
206   /** How many tokens investors have claimed */
207   mapping(address => uint) public claimed;
208 
209   /** When our claim freeze is over (UNIX timestamp) */
210   uint public freezeEndsAt;
211 
212   /** When this vault was locked (UNIX timestamp) */
213   uint public lockedAt;
214 
215   /** We can also define our own token, which will override the ICO one ***/
216   StandardToken public token;
217 
218   /** What is our current state.
219    *
220    * Loading: Investor data is being loaded and contract not yet locked
221    * Holding: Holding tokens for investors
222    * Distributing: Freeze time is over, investors can claim their tokens
223    */
224   enum State{Unknown, Loading, Holding, Distributing}
225 
226   /** We allocated tokens for investor */
227   event Allocated(address investor, uint value);
228 
229   /** We distributed tokens to an investor */
230   event Distributed(address investors, uint count);
231 
232   event Locked();
233 
234   /**
235    * Create presale contract where lock up period is given days
236    *
237    * @param _owner Who can load investor data and lock
238    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
239    * @param _token Token contract address we are distributing
240    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
241    *
242    */
243   function TokenVault(address _owner, uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {
244 
245     owner = _owner;
246 
247     // Invalid owenr
248     if(owner == 0) {
249       throw;
250     }
251 
252     token = _token;
253 
254     // Check the address looks like a token contract
255     if(!token.isToken()) {
256       throw;
257     }
258 
259     // Give argument
260     if(_freezeEndsAt == 0) {
261       throw;
262     }
263 
264     freezeEndsAt = _freezeEndsAt;
265     tokensToBeAllocated = _tokensToBeAllocated;
266   }
267 
268   /**
269    * Add a presale participatin allocation.
270    */
271   function setInvestor(address investor, uint amount) public onlyOwner {
272 
273     if(lockedAt > 0) {
274       // Cannot add new investors after the vault is locked
275       throw;
276     }
277 
278     if(amount == 0) throw; // No empty buys
279 
280     // Don't allow reset
281     bool existing = balances[investor] > 0;
282     if(existing) {
283       throw;
284     }
285 
286     balances[investor] = amount;
287 
288     investorCount++;
289 
290     tokensAllocatedTotal += amount;
291 
292     Allocated(investor, amount);
293   }
294 
295   /**
296    * Lock the vault.
297    *
298    *
299    * - All balances have been loaded in correctly
300    * - Tokens are transferred on this vault correctly
301    *
302    * Checks are in place to prevent creating a vault that is locked with incorrect token balances.
303    *
304    */
305   function lock() onlyOwner {
306 
307     if(lockedAt > 0) {
308       throw; // Already locked
309     }
310 
311     // Spreadsheet sum does not match to what we have loaded to the investor data
312     if(tokensAllocatedTotal != tokensToBeAllocated) {
313       throw;
314     }
315 
316     // Do not lock the vault if the given tokens on this contract
317     // Note that we do not check != so that we can top up little bit extra
318     // due to decimal rounding and having issues with it.
319     // This extras will be lost forever when the vault is locked.
320     if(token.balanceOf(address(this)) < tokensAllocatedTotal) {
321       throw;
322     }
323 
324     lockedAt = now;
325 
326     Locked();
327   }
328 
329   /**
330    * In the case locking failed, then allow the owner to reclaim the tokens on the contract.
331    */
332   function recoverFailedLock() onlyOwner {
333     if(lockedAt > 0) {
334       throw;
335     }
336 
337     // Transfer all tokens on this contract back to the owner
338     token.transfer(owner, token.balanceOf(address(this)));
339   }
340 
341   /**
342    * Get the current balance of tokens in the vault.
343    */
344   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
345     return token.balanceOf(address(this));
346   }
347 
348   /**
349    * Claim N bought tokens to the investor as the msg sender.
350    *
351    */
352   function claim() {
353 
354     address investor = msg.sender;
355 
356     if(lockedAt == 0) {
357       throw; // We were never locked
358     }
359 
360     if(now < freezeEndsAt) {
361       throw; // Trying to claim early
362     }
363 
364     if(balances[investor] == 0) {
365       // Not our investor
366       throw;
367     }
368 
369     if(claimed[investor] > 0) {
370       throw; // Already claimed
371     }
372 
373     uint amount = balances[investor];
374 
375     claimed[investor] = amount;
376 
377     totalClaimed += amount;
378 
379     token.transfer(investor, amount);
380 
381     Distributed(investor, amount);
382   }
383 
384   /**
385    * Resolve the contract umambigious state.
386    */
387   function getState() public constant returns(State) {
388     if(lockedAt == 0) {
389       return State.Loading;
390     } else if(now > freezeEndsAt) {
391       return State.Distributing;
392     } else {
393       return State.Holding;
394     }
395   }
396 
397 }