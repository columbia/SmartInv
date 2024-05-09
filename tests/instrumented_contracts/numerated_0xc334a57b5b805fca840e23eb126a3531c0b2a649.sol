1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 /*
19  * ERC20 interface
20  * see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 {
23   uint public totalSupply;
24   function balanceOf(address who) constant returns (uint);
25   function allowance(address owner, address spender) constant returns (uint);
26 
27   function transfer(address to, uint value) returns (bool ok);
28   function transferFrom(address from, address to, uint value) returns (bool ok);
29   function approve(address spender, uint value) returns (bool ok);
30   event Transfer(address indexed from, address indexed to, uint value);
31   event Approval(address indexed owner, address indexed spender, uint value);
32 }
33 
34 
35 
36 /**
37  * Math operations with safety checks
38  */
39 contract SafeMath {
40   function safeMul(uint a, uint b) internal returns (uint) {
41     uint c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function safeDiv(uint a, uint b) internal returns (uint) {
47     assert(b > 0);
48     uint c = a / b;
49     assert(a == b * c + a % b);
50     return c;
51   }
52 
53   function safeSub(uint a, uint b) internal returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function safeAdd(uint a, uint b) internal returns (uint) {
59     uint c = a + b;
60     assert(c>=a && c>=b);
61     return c;
62   }
63 
64   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
65     return a >= b ? a : b;
66   }
67 
68   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a < b ? a : b;
70   }
71 
72   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
73     return a >= b ? a : b;
74   }
75 
76   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a < b ? a : b;
78   }
79 
80   function assert(bool assertion) internal {
81     if (!assertion) {
82       throw;
83     }
84   }
85 }
86 
87 
88 
89 /**
90  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
91  *
92  * Based on code by FirstBlood:
93  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, SafeMath {
96 
97   /* Token supply got increased and a new owner received these tokens */
98   event Minted(address receiver, uint amount);
99 
100   /* Actual balances of token holders */
101   mapping(address => uint) balances;
102 
103   /* approve() allowances */
104   mapping (address => mapping (address => uint)) allowed;
105 
106   /* Interface declaration */
107   function isToken() public constant returns (bool weAre) {
108     return true;
109   }
110 
111   function transfer(address _to, uint _value) returns (bool success) {
112     balances[msg.sender] = safeSub(balances[msg.sender], _value);
113     balances[_to] = safeAdd(balances[_to], _value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
119     uint _allowance = allowed[_from][msg.sender];
120 
121     balances[_to] = safeAdd(balances[_to], _value);
122     balances[_from] = safeSub(balances[_from], _value);
123     allowed[_from][msg.sender] = safeSub(_allowance, _value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   function balanceOf(address _owner) constant returns (uint balance) {
129     return balances[_owner];
130   }
131 
132   function approve(address _spender, uint _value) returns (bool success) {
133 
134     // To change the approve amount you first have to reduce the addresses`
135     //  allowance to zero by calling `approve(_spender, 0)` if it is not
136     //  already 0 to mitigate the race condition described here:
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   function allowance(address _owner, address _spender) constant returns (uint remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 
152 
153 /*
154  * Ownable
155  *
156  * Base contract with an owner.
157  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
158  */
159 contract Ownable {
160   address public owner;
161 
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166   modifier onlyOwner() {
167     if (msg.sender != owner) {
168       throw;
169     }
170     _;
171   }
172 
173   function transferOwnership(address newOwner) onlyOwner {
174     if (newOwner != address(0)) {
175       owner = newOwner;
176     }
177   }
178 
179 }
180 
181 
182 /**
183  * Hold tokens for a group investor of investors until the unlock date.
184  *
185  * After the unlock date the investor can claim their tokens.
186  *
187  * Steps
188  *
189  * - Prepare a spreadsheet for token allocation
190  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
191  * - Call setInvestor for all investors from the owner account using a local script and CSV input
192  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
193  * - Call lock from the owner account
194  * - Wait until the freeze period is over
195  * - After the freeze time is over investors can call claim() from their address to get their tokens
196  *
197  */
198 contract TokenVault is Ownable {
199 
200   /** How many investors we have now */
201   uint public investorCount;
202 
203   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
204   uint public tokensToBeAllocated;
205 
206   /** How many tokens investors have claimed so far */
207   uint public totalClaimed;
208 
209   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
210   uint public tokensAllocatedTotal;
211 
212   /** How much we have allocated to the investors invested */
213   mapping(address => uint) public balances;
214 
215   /** How many tokens investors have claimed */
216   mapping(address => uint) public claimed;
217 
218   /** When our claim freeze is over (UNIX timestamp) */
219   uint public freezeEndsAt;
220 
221   /** When this vault was locked (UNIX timestamp) */
222   uint public lockedAt;
223 
224   /** We can also define our own token, which will override the ICO one ***/
225   StandardToken public token;
226 
227   /** What is our current state.
228    *
229    * Loading: Investor data is being loaded and contract not yet locked
230    * Holding: Holding tokens for investors
231    * Distributing: Freeze time is over, investors can claim their tokens
232    */
233   enum State{Unknown, Loading, Holding, Distributing}
234 
235   /** We allocated tokens for investor */
236   event Allocated(address investor, uint value);
237 
238   /** We distributed tokens to an investor */
239   event Distributed(address investors, uint count);
240 
241   event Locked();
242 
243   /**
244    * Create presale contract where lock up period is given days
245    *
246    * @param _owner Who can load investor data and lock
247    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
248    * @param _token Token contract address we are distributing
249    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
250    *
251    */
252   function TokenVault(address _owner, uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {
253 
254     owner = _owner;
255 
256     // Invalid owenr
257     if(owner == 0) {
258       throw;
259     }
260 
261     token = _token;
262 
263     // Check the address looks like a token contract
264     if(!token.isToken()) {
265       throw;
266     }
267 
268     // Give argument
269     if(_freezeEndsAt == 0) {
270       throw;
271     }
272 
273     // Sanity check on _tokensToBeAllocated
274     if(_tokensToBeAllocated == 0) {
275       throw;
276     }
277 
278     freezeEndsAt = _freezeEndsAt;
279     tokensToBeAllocated = _tokensToBeAllocated;
280   }
281 
282   /// @dev Add a presale participating allocation
283   function setInvestor(address investor, uint amount) public onlyOwner {
284 
285     if(lockedAt > 0) {
286       // Cannot add new investors after the vault is locked
287       throw;
288     }
289 
290     if(amount == 0) throw; // No empty buys
291 
292     // Don't allow reset
293     if(balances[investor] > 0) {
294       throw;
295     }
296 
297     balances[investor] = amount;
298 
299     investorCount++;
300 
301     tokensAllocatedTotal += amount;
302 
303     Allocated(investor, amount);
304   }
305 
306   /// @dev Lock the vault
307   ///      - All balances have been loaded in correctly
308   ///      - Tokens are transferred on this vault correctly
309   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
310   function lock() onlyOwner {
311 
312     if(lockedAt > 0) {
313       throw; // Already locked
314     }
315 
316     // Spreadsheet sum does not match to what we have loaded to the investor data
317     if(tokensAllocatedTotal != tokensToBeAllocated) {
318       throw;
319     }
320 
321     // Do not lock the vault if the given tokens are not on this contract
322     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
323       throw;
324     }
325 
326     lockedAt = now;
327 
328     Locked();
329   }
330 
331   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
332   function recoverFailedLock() onlyOwner {
333     if(lockedAt > 0) {
334       throw;
335     }
336 
337     // Transfer all tokens on this contract back to the owner
338     token.transfer(owner, token.balanceOf(address(this)));
339   }
340 
341   /// @dev Get the current balance of tokens in the vault
342   /// @return uint How many tokens there are currently in vault
343   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
344     return token.balanceOf(address(this));
345   }
346 
347   /// @dev Claim N bought tokens to the investor as the msg sender
348   function claim() {
349 
350     address investor = msg.sender;
351 
352     if(lockedAt == 0) {
353       throw; // We were never locked
354     }
355 
356     if(now < freezeEndsAt) {
357       throw; // Trying to claim early
358     }
359 
360     if(balances[investor] == 0) {
361       // Not our investor
362       throw;
363     }
364 
365     if(claimed[investor] > 0) {
366       throw; // Already claimed
367     }
368 
369     uint amount = balances[investor];
370 
371     claimed[investor] = amount;
372 
373     totalClaimed += amount;
374 
375     token.transfer(investor, amount);
376 
377     Distributed(investor, amount);
378   }
379 
380   /// @dev Resolve the contract umambigious state
381   function getState() public constant returns(State) {
382     if(lockedAt == 0) {
383       return State.Loading;
384     } else if(now > freezeEndsAt) {
385       return State.Distributing;
386     } else {
387       return State.Holding;
388     }
389   }
390 
391 }