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
186   /** How many tokens investors have claimed so far */
187   uint public totalClaimed;
188 
189   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
190   uint public tokensAllocatedTotal;
191 
192   /** How much we have allocated to the investors invested */
193   mapping(address => uint) public balances;
194 
195   /** How many tokens investors have claimed */
196   mapping(address => uint) public claimed;
197 
198   /** When our claim freeze is over (UNIX timestamp) */
199   uint public freezeEndsAt;
200 
201   /** When this vault was locked (UNIX timestamp) */
202   uint public lockedAt;
203 
204   /** We can also define our own token, which will override the ICO one ***/
205   StandardToken public token;
206 
207   /** What is our current state.
208    *
209    * Loading: Investor data is being loaded and contract not yet locked
210    * Holding: Holding tokens for investors
211    * Distributing: Freeze time is over, investors can claim their tokens
212    */
213   enum State{Unknown, Loading, Holding, Distributing}
214 
215   /** We allocated tokens for investor */
216   event Allocated(address investor, uint value);
217 
218   /** We distributed tokens to an investor */
219   event Distributed(address investors, uint count);
220 
221   event Locked();
222 
223   /**
224    * Create presale contract where lock up period is given days
225    *
226    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
227    * @param _token Token contract address we are distributing
228    *
229    */
230   function TokenVault(uint _freezeEndsAt, StandardToken _token) {
231 
232     owner = msg.sender;
233 
234     // Invalid owenr
235     if(owner == 0) {
236       throw;
237     }
238 
239     token = _token;
240 
241     // Check the address looks like a token contract
242     if(!token.isToken()) {
243       throw;
244     }
245 
246     // Give argument
247     if(_freezeEndsAt == 0) {
248       throw;
249     }
250 
251     freezeEndsAt = _freezeEndsAt;
252   }
253 
254   /// @dev Add a presale participating allocation
255   function setInvestor(address investor, uint amount) public onlyOwner {
256 
257     if(lockedAt > 0) {
258       // Cannot add new investors after the vault is locked
259       throw;
260     }
261 
262     if(amount == 0) throw; // No empty buys
263 
264     // Don't allow reset
265     if(balances[investor] > 0) {
266       throw;
267     }
268 
269     balances[investor] = amount;
270 
271     investorCount++;
272 
273     tokensAllocatedTotal += amount;
274 
275     Allocated(investor, amount);
276   }
277 
278   /// @dev Lock the vault
279   /// @param tokensToBeAllocated Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.
280   ///      - All balances have been loaded in correctly
281   ///      - Tokens are transferred on this vault correctly
282   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
283   function lock(uint tokensToBeAllocated) onlyOwner {
284 
285     if(lockedAt > 0) {
286       throw; // Already locked
287     }
288 
289     // Spreadsheet sum does not match to what we have loaded to the investor data
290     if(tokensAllocatedTotal != tokensToBeAllocated) {
291       throw;
292     }
293 
294     // Do not lock the vault if the given tokens are not on this contract
295     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
296       throw;
297     }
298 
299     lockedAt = now;
300 
301     Locked();
302   }
303 
304   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
305   function recoverFailedLock() onlyOwner {
306     if(lockedAt > 0) {
307       throw;
308     }
309 
310     // Transfer all tokens on this contract back to the owner
311     token.transfer(owner, token.balanceOf(address(this)));
312   }
313 
314   /// @dev Get the current balance of tokens in the vault
315   /// @return uint How many tokens there are currently in vault
316   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
317     return token.balanceOf(address(this));
318   }
319 
320   /// @dev Claim N bought tokens to the investor as the msg sender
321   function claim() {
322 
323     address investor = msg.sender;
324 
325     if(lockedAt == 0) {
326       throw; // We were never locked
327     }
328 
329     if(now < freezeEndsAt) {
330       throw; // Trying to claim early
331     }
332 
333     if(balances[investor] == 0) {
334       // Not our investor
335       throw;
336     }
337 
338     if(claimed[investor] > 0) {
339       throw; // Already claimed
340     }
341 
342     uint amount = balances[investor];
343 
344     claimed[investor] = amount;
345 
346     totalClaimed += amount;
347 
348     token.transfer(investor, amount);
349 
350     Distributed(investor, amount);
351   }
352 
353   /// @dev Resolve the contract umambigious state
354   function getState() public constant returns(State) {
355     if(lockedAt == 0) {
356       return State.Loading;
357     } else if(now > freezeEndsAt) {
358       return State.Distributing;
359     } else {
360       return State.Holding;
361     }
362   }
363 
364 }