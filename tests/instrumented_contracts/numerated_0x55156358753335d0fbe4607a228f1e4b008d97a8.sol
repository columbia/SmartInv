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
94   function transfer(address _to, uint _value) returns (bool success) {
95     balances[msg.sender] = safeSub(balances[msg.sender], _value);
96     balances[_to] = safeAdd(balances[_to], _value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
102     uint _allowance = allowed[_from][msg.sender];
103 
104     balances[_to] = safeAdd(balances[_to], _value);
105     balances[_from] = safeSub(balances[_from], _value);
106     allowed[_from][msg.sender] = safeSub(_allowance, _value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115   function approve(address _spender, uint _value) returns (bool success) {
116 
117     // To change the approve amount you first have to reduce the addresses`
118     //  allowance to zero by calling `approve(_spender, 0)` if it is not
119     //  already 0 to mitigate the race condition described here:
120     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
122 
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   function allowance(address _owner, address _spender) constant returns (uint remaining) {
129     return allowed[_owner][_spender];
130   }
131 
132 }
133 
134 
135 
136 /*
137  * Ownable
138  *
139  * Base contract with an owner.
140  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
141  */
142 contract Ownable {
143   address public owner;
144 
145   function Ownable() {
146     owner = msg.sender;
147   }
148 
149   modifier onlyOwner() {
150     if (msg.sender != owner) {
151       throw;
152     }
153     _;
154   }
155 
156   function transferOwnership(address newOwner) onlyOwner {
157     if (newOwner != address(0)) {
158       owner = newOwner;
159     }
160   }
161 
162 }
163 
164 
165 /**
166  * Hold tokens for a group investor of investors until the unlock date.
167  *
168  * After the unlock date the investor can claim their tokens.
169  *
170  * Steps
171  *
172  * - Prepare a spreadsheet for token allocation
173  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
174  * - Call setInvestor for all investors from the owner account using a local script and CSV input
175  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
176  * - Call lock from the owner account
177  * - Wait until the freeze period is over
178  * - After the freeze time is over investors can call claim() from their address to get their tokens
179  *
180  */
181 contract TokenVault is Ownable {
182 
183   /** How many investors we have now */
184   uint public investorCount;
185 
186   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
187   uint public tokensToBeAllocated;
188 
189   /** How many tokens investors have claimed so far */
190   uint public totalClaimed;
191 
192   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
193   uint public tokensAllocatedTotal;
194 
195   /** How much we have allocated to the investors invested */
196   mapping(address => uint) public balances;
197 
198   /** How many tokens investors have claimed */
199   mapping(address => uint) public claimed;
200 
201   /** When our claim freeze is over (UNIX timestamp) */
202   uint public freezeEndsAt;
203 
204   /** When this vault was locked (UNIX timestamp) */
205   uint public lockedAt;
206 
207   /** We can also define our own token, which will override the ICO one ***/
208   StandardToken public token;
209 
210   /** What is our current state.
211    *
212    * Loading: Investor data is being loaded and contract not yet locked
213    * Holding: Holding tokens for investors
214    * Distributing: Freeze time is over, investors can claim their tokens
215    */
216   enum State{Unknown, Loading, Holding, Distributing}
217 
218   /** We allocated tokens for investor */
219   event Allocated(address investor, uint value);
220 
221   /** We distributed tokens to an investor */
222   event Distributed(address investors, uint count);
223 
224   event Locked();
225 
226   /**
227    * Create presale contract where lock up period is given days
228    *
229    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
230    * @param _token Token contract address we are distributing
231    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
232    *
233    */
234   function TokenVault(uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {
235 
236     owner = msg.sender;
237 
238     // Invalid owenr
239     if(owner == 0) {
240       throw;
241     }
242 
243     token = _token;
244 
245     // Check the address looks like a token contract
246     if(!token.isToken()) {
247       throw;
248     }
249 
250     // Give argument
251     if(_freezeEndsAt == 0) {
252       throw;
253     }
254 
255     // Sanity check on _tokensToBeAllocated
256     if(_tokensToBeAllocated == 0) {
257       throw;
258     }
259 
260     freezeEndsAt = _freezeEndsAt;
261     tokensToBeAllocated = _tokensToBeAllocated;
262   }
263 
264   /// @dev Add a presale participating allocation
265   function setInvestor(address investor, uint amount) public onlyOwner {
266 
267     if(lockedAt > 0) {
268       // Cannot add new investors after the vault is locked
269       throw;
270     }
271 
272     if(amount == 0) throw; // No empty buys
273 
274     // Don't allow reset
275     if(balances[investor] > 0) {
276       throw;
277     }
278 
279     balances[investor] = amount;
280 
281     investorCount++;
282 
283     tokensAllocatedTotal += amount;
284 
285     Allocated(investor, amount);
286   }
287 
288   /// @dev Lock the vault
289   ///      - All balances have been loaded in correctly
290   ///      - Tokens are transferred on this vault correctly
291   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
292   function lock() onlyOwner {
293 
294     if(lockedAt > 0) {
295       throw; // Already locked
296     }
297 
298     // Spreadsheet sum does not match to what we have loaded to the investor data
299     if(tokensAllocatedTotal != tokensToBeAllocated) {
300       throw;
301     }
302 
303     // Do not lock the vault if the given tokens are not on this contract
304     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
305       throw;
306     }
307 
308     lockedAt = now;
309 
310     Locked();
311   }
312 
313   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
314   function recoverFailedLock() onlyOwner {
315     if(lockedAt > 0) {
316       throw;
317     }
318 
319     // Transfer all tokens on this contract back to the owner
320     token.transfer(owner, token.balanceOf(address(this)));
321   }
322 
323   /// @dev Get the current balance of tokens in the vault
324   /// @return uint How many tokens there are currently in vault
325   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
326     return token.balanceOf(address(this));
327   }
328 
329   /// @dev Claim N bought tokens to the investor as the msg sender
330   function claim() {
331 
332     address investor = msg.sender;
333 
334     if(lockedAt == 0) {
335       throw; // We were never locked
336     }
337 
338     if(now < freezeEndsAt) {
339       throw; // Trying to claim early
340     }
341 
342     if(balances[investor] == 0) {
343       // Not our investor
344       throw;
345     }
346 
347     if(claimed[investor] > 0) {
348       throw; // Already claimed
349     }
350 
351     uint amount = balances[investor];
352 
353     claimed[investor] = amount;
354 
355     totalClaimed += amount;
356 
357     token.transfer(investor, amount);
358 
359     Distributed(investor, amount);
360   }
361 
362   /// @dev Resolve the contract umambigious state
363   function getState() public constant returns(State) {
364     if(lockedAt == 0) {
365       return State.Loading;
366     } else if(now > freezeEndsAt) {
367       return State.Distributing;
368     } else {
369       return State.Holding;
370     }
371   }
372 
373 }