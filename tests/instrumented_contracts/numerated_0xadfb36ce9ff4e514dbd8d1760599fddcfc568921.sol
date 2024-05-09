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
145 }
146 
147 
148 
149 /*
150  * Ownable
151  *
152  * Base contract with an owner.
153  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
154  */
155 contract Ownable {
156   address public owner;
157 
158   function Ownable() {
159     owner = msg.sender;
160   }
161 
162   modifier onlyOwner() {
163     if (msg.sender != owner) {
164       throw;
165     }
166     _;
167   }
168 
169   function transferOwnership(address newOwner) onlyOwner {
170     if (newOwner != address(0)) {
171       owner = newOwner;
172     }
173   }
174 
175 }
176 
177 
178 /**
179  * Hold tokens for a group investor of investors until the unlock date.
180  *
181  * After the unlock date the investor can claim their tokens.
182  *
183  * Steps
184  *
185  * - Prepare a spreadsheet for token allocation
186  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
187  * - Call setInvestor for all investors from the owner account using a local script and CSV input
188  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
189  * - Call lock from the owner account
190  * - Wait until the freeze period is over
191  * - After the freeze time is over investors can call claim() from their address to get their tokens
192  *
193  */
194 contract TokenVault is Ownable {
195 
196   /** How many investors we have now */
197   uint public investorCount;
198 
199   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
200   uint public tokensToBeAllocated;
201 
202   /** How many tokens investors have claimed so far */
203   uint public totalClaimed;
204 
205   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
206   uint public tokensAllocatedTotal;
207 
208   /** How much we have allocated to the investors invested */
209   mapping(address => uint) public balances;
210 
211   /** How many tokens investors have claimed */
212   mapping(address => uint) public claimed;
213 
214   /** When our claim freeze is over (UNIX timestamp) */
215   uint public freezeEndsAt;
216 
217   /** When this vault was locked (UNIX timestamp) */
218   uint public lockedAt;
219 
220   /** We can also define our own token, which will override the ICO one ***/
221   StandardToken public token;
222 
223   /** What is our current state.
224    *
225    * Loading: Investor data is being loaded and contract not yet locked
226    * Holding: Holding tokens for investors
227    * Distributing: Freeze time is over, investors can claim their tokens
228    */
229   enum State{Unknown, Loading, Holding, Distributing}
230 
231   /** We allocated tokens for investor */
232   event Allocated(address investor, uint value);
233 
234   /** We distributed tokens to an investor */
235   event Distributed(address investors, uint count);
236 
237   event Locked();
238 
239   /**
240    * Create presale contract where lock up period is given days
241    *
242    * @param _owner Who can load investor data and lock
243    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
244    * @param _token Token contract address we are distributing
245    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
246    *
247    */
248   function TokenVault(address _owner, uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {
249 
250     owner = _owner;
251 
252     // Invalid owenr
253     if(owner == 0) {
254       throw;
255     }
256 
257     token = _token;
258 
259     // Check the address looks like a token contract
260     if(!token.isToken()) {
261       throw;
262     }
263 
264     // Give argument
265     if(_freezeEndsAt == 0) {
266       throw;
267     }
268 
269     // Sanity check on _tokensToBeAllocated
270     if(_tokensToBeAllocated == 0) {
271       throw;
272     }
273 
274     freezeEndsAt = _freezeEndsAt;
275     tokensToBeAllocated = _tokensToBeAllocated;
276   }
277 
278   /// @dev Add a presale participating allocation
279   function setInvestor(address investor, uint amount) public onlyOwner {
280 
281     if(lockedAt > 0) {
282       // Cannot add new investors after the vault is locked
283       throw;
284     }
285 
286     if(amount == 0) throw; // No empty buys
287 
288     // Don't allow reset
289     if(balances[investor] > 0) {
290       throw;
291     }
292 
293     balances[investor] = amount;
294 
295     investorCount++;
296 
297     tokensAllocatedTotal += amount;
298 
299     Allocated(investor, amount);
300   }
301 
302   /// @dev Lock the vault
303   ///      - All balances have been loaded in correctly
304   ///      - Tokens are transferred on this vault correctly
305   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
306   function lock() onlyOwner {
307 
308     if(lockedAt > 0) {
309       throw; // Already locked
310     }
311 
312     // Spreadsheet sum does not match to what we have loaded to the investor data
313     if(tokensAllocatedTotal != tokensToBeAllocated) {
314       throw;
315     }
316 
317     // Do not lock the vault if the given tokens are not on this contract
318     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
319       throw;
320     }
321 
322     lockedAt = now;
323 
324     Locked();
325   }
326 
327   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
328   function recoverFailedLock() onlyOwner {
329     if(lockedAt > 0) {
330       throw;
331     }
332 
333     // Transfer all tokens on this contract back to the owner
334     token.transfer(owner, token.balanceOf(address(this)));
335   }
336 
337   /// @dev Get the current balance of tokens in the vault
338   /// @return uint How many tokens there are currently in vault
339   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
340     return token.balanceOf(address(this));
341   }
342 
343   /// @dev Claim N bought tokens to the investor as the msg sender
344   function claim() {
345 
346     address investor = msg.sender;
347 
348     if(lockedAt == 0) {
349       throw; // We were never locked
350     }
351 
352     if(now < freezeEndsAt) {
353       throw; // Trying to claim early
354     }
355 
356     if(balances[investor] == 0) {
357       // Not our investor
358       throw;
359     }
360 
361     if(claimed[investor] > 0) {
362       throw; // Already claimed
363     }
364 
365     uint amount = balances[investor];
366 
367     claimed[investor] = amount;
368 
369     totalClaimed += amount;
370 
371     token.transfer(investor, amount);
372 
373     Distributed(investor, amount);
374   }
375 
376   /// @dev Resolve the contract umambigious state
377   function getState() public constant returns(State) {
378     if(lockedAt == 0) {
379       return State.Loading;
380     } else if(now > freezeEndsAt) {
381       return State.Distributing;
382     } else {
383       return State.Holding;
384     }
385   }
386 
387 }