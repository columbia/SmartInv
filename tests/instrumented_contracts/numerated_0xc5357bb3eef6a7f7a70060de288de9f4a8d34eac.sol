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
80   /* Token supply got increased and a new owner received these tokens */
81   event Minted(address receiver, uint amount);
82 
83   /* Actual balances of token holders */
84   mapping(address => uint) balances;
85 
86   /* approve() allowances */
87   mapping (address => mapping (address => uint)) allowed;
88 
89   /* Interface declaration */
90   function isToken() public constant returns (bool weAre) {
91     return true;
92   }
93 
94   /**
95    *
96    * Fix for the ERC20 short address attack
97    *
98    * http://vessenes.com/the-erc20-short-address-attack-explained/
99    */
100   modifier onlyPayloadSize(uint size) {
101      if(msg.data.length < size + 4) {
102        throw;
103      }
104      _;
105   }
106 
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
108     balances[msg.sender] = safeSub(balances[msg.sender], _value);
109     balances[_to] = safeAdd(balances[_to], _value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
115     uint _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
118     // if (_value > _allowance) throw;
119 
120     balances[_to] = safeAdd(balances[_to], _value);
121     balances[_from] = safeSub(balances[_from], _value);
122     allowed[_from][msg.sender] = safeSub(_allowance, _value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   function balanceOf(address _owner) constant returns (uint balance) {
128     return balances[_owner];
129   }
130 
131   function approve(address _spender, uint _value) returns (bool success) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
138 
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   function allowance(address _owner, address _spender) constant returns (uint remaining) {
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
155   returns (bool success) {
156       uint oldValue = allowed[msg.sender][_spender];
157       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
158       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159       return true;
160   }
161 
162   /**
163    * Atomic decrement of approved spending.
164    *
165    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    */
167   function subApproval(address _spender, uint _subtractedValue)
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
185 /*
186  * Ownable
187  *
188  * Base contract with an owner.
189  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
190  */
191 contract Ownable {
192   address public owner;
193 
194   function Ownable() {
195     owner = msg.sender;
196   }
197 
198   modifier onlyOwner() {
199     if (msg.sender != owner) {
200       throw;
201     }
202     _;
203   }
204 
205   function transferOwnership(address newOwner) onlyOwner {
206     if (newOwner != address(0)) {
207       owner = newOwner;
208     }
209   }
210 
211 }
212 
213 
214 /**
215  * Hold tokens for a group investor of investors until the unlock date.
216  *
217  * After the unlock date the investor can claim their tokens.
218  *
219  * Steps
220  *
221  * - Prepare a spreadsheet for token allocation
222  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
223  * - Call setInvestor for all investors from the owner account using a local script and CSV input
224  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
225  * - Call lock from the owner account
226  * - Wait until the freeze period is over
227  * - After the freeze time is over investors can call claim() from their address to get their tokens
228  *
229  */
230 contract TokenVault is Ownable {
231 
232   /** How many investors we have now */
233   uint public investorCount;
234 
235   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
236   uint public tokensToBeAllocated;
237 
238   /** How many tokens investors have claimed so far */
239   uint public totalClaimed;
240 
241   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
242   uint public tokensAllocatedTotal;
243 
244   /** How much we have allocated to the investors invested */
245   mapping(address => uint) public balances;
246 
247   /** How many tokens investors have claimed */
248   mapping(address => uint) public claimed;
249 
250   /** When our claim freeze is over (UNIX timestamp) */
251   uint public freezeEndsAt;
252 
253   /** When this vault was locked (UNIX timestamp) */
254   uint public lockedAt;
255 
256   /** We can also define our own token, which will override the ICO one ***/
257   StandardToken public token;
258 
259   /** What is our current state.
260    *
261    * Loading: Investor data is being loaded and contract not yet locked
262    * Holding: Holding tokens for investors
263    * Distributing: Freeze time is over, investors can claim their tokens
264    */
265   enum State{Unknown, Loading, Holding, Distributing}
266 
267   /** We allocated tokens for investor */
268   event Allocated(address investor, uint value);
269 
270   /** We distributed tokens to an investor */
271   event Distributed(address investors, uint count);
272 
273   event Locked();
274 
275   /**
276    * Create presale contract where lock up period is given days
277    *
278    * @param _owner Who can load investor data and lock
279    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
280    * @param _token Token contract address we are distributing
281    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
282    *
283    */
284   function TokenVault(address _owner, uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {
285 
286     owner = _owner;
287 
288     // Invalid owenr
289     if(owner == 0) {
290       throw;
291     }
292 
293     token = _token;
294 
295     // Check the address looks like a token contract
296     if(!token.isToken()) {
297       throw;
298     }
299 
300     // Give argument
301     if(_freezeEndsAt == 0) {
302       throw;
303     }
304 
305     // Sanity check on _tokensToBeAllocated
306     if(_tokensToBeAllocated == 0) {
307       throw;
308     }
309 
310     freezeEndsAt = _freezeEndsAt;
311     tokensToBeAllocated = _tokensToBeAllocated;
312   }
313 
314   /// @dev Add a presale participating allocation
315   function setInvestor(address investor, uint amount) public onlyOwner {
316 
317     if(lockedAt > 0) {
318       // Cannot add new investors after the vault is locked
319       throw;
320     }
321 
322     if(amount == 0) throw; // No empty buys
323 
324     // Don't allow reset
325     if(balances[investor] > 0) {
326       throw;
327     }
328 
329     balances[investor] = amount;
330 
331     investorCount++;
332 
333     tokensAllocatedTotal += amount;
334 
335     Allocated(investor, amount);
336   }
337 
338   /// @dev Lock the vault
339   ///      - All balances have been loaded in correctly
340   ///      - Tokens are transferred on this vault correctly
341   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
342   function lock() onlyOwner {
343 
344     if(lockedAt > 0) {
345       throw; // Already locked
346     }
347 
348     // Spreadsheet sum does not match to what we have loaded to the investor data
349     if(tokensAllocatedTotal != tokensToBeAllocated) {
350       throw;
351     }
352 
353     // Do not lock the vault if the given tokens are not on this contract
354     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
355       throw;
356     }
357 
358     lockedAt = now;
359 
360     Locked();
361   }
362 
363   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
364   function recoverFailedLock() onlyOwner {
365     if(lockedAt > 0) {
366       throw;
367     }
368 
369     // Transfer all tokens on this contract back to the owner
370     token.transfer(owner, token.balanceOf(address(this)));
371   }
372 
373   /// @dev Get the current balance of tokens in the vault
374   /// @return uint How many tokens there are currently in vault
375   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
376     return token.balanceOf(address(this));
377   }
378 
379   /// @dev Claim N bought tokens to the investor as the msg sender
380   function claim() {
381 
382     address investor = msg.sender;
383 
384     if(lockedAt == 0) {
385       throw; // We were never locked
386     }
387 
388     if(now < freezeEndsAt) {
389       throw; // Trying to claim early
390     }
391 
392     if(balances[investor] == 0) {
393       // Not our investor
394       throw;
395     }
396 
397     if(claimed[investor] > 0) {
398       throw; // Already claimed
399     }
400 
401     uint amount = balances[investor];
402 
403     claimed[investor] = amount;
404 
405     totalClaimed += amount;
406 
407     token.transfer(investor, amount);
408 
409     Distributed(investor, amount);
410   }
411 
412   /// @dev Resolve the contract umambigious state
413   function getState() public constant returns(State) {
414     if(lockedAt == 0) {
415       return State.Loading;
416     } else if(now > freezeEndsAt) {
417       return State.Distributing;
418     } else {
419       return State.Holding;
420     }
421   }
422 
423 }