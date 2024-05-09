1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
44     assert(token.transferFrom(from, to, value));
45   }
46 
47   function safeApprove(ERC20 token, address spender, uint256 value) internal {
48     assert(token.approve(spender, value));
49   }
50 }
51 
52 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
53 
54 /**
55  * @title TokenTimelock
56  * @dev TokenTimelock is a token holder contract that will allow a
57  * beneficiary to extract the tokens after a given release time
58  */
59 contract TokenTimelock {
60   using SafeERC20 for ERC20Basic;
61 
62   // ERC20 basic token contract being held
63   ERC20Basic public token;
64 
65   // beneficiary of tokens after they are released
66   address public beneficiary;
67 
68   // timestamp when token release is enabled
69   uint256 public releaseTime;
70 
71   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
72     require(_releaseTime > now);
73     token = _token;
74     beneficiary = _beneficiary;
75     releaseTime = _releaseTime;
76   }
77 
78   /**
79    * @notice Transfers tokens held by timelock to beneficiary.
80    */
81   function release() public {
82     require(now >= releaseTime);
83 
84     uint256 amount = token.balanceOf(this);
85     require(amount > 0);
86 
87     token.safeTransfer(beneficiary, amount);
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
182 
183 /**
184  * @title TokenVesting
185  * @dev A token holder contract that can release its token balance gradually like a
186  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
187  * owner.
188  */
189 contract TokenVesting is Ownable {
190   using SafeMath for uint256;
191   using SafeERC20 for ERC20Basic;
192 
193   event Released(uint256 amount);
194   event Revoked();
195 
196   // beneficiary of tokens after they are released
197   address public beneficiary;
198 
199   uint256 public cliff;
200   uint256 public start;
201   uint256 public duration;
202 
203   bool public revocable;
204 
205   mapping (address => uint256) public released;
206   mapping (address => bool) public revoked;
207 
208   /**
209    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
210    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
211    * of the balance will have vested.
212    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
213    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
214    * @param _duration duration in seconds of the period in which the tokens will vest
215    * @param _revocable whether the vesting is revocable or not
216    */
217   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
218     require(_beneficiary != address(0));
219     require(_cliff <= _duration);
220 
221     beneficiary = _beneficiary;
222     revocable = _revocable;
223     duration = _duration;
224     cliff = _start.add(_cliff);
225     start = _start;
226   }
227 
228   /**
229    * @notice Transfers vested tokens to beneficiary.
230    * @param token ERC20 token which is being vested
231    */
232   function release(ERC20Basic token) public {
233     uint256 unreleased = releasableAmount(token);
234 
235     require(unreleased > 0);
236 
237     released[token] = released[token].add(unreleased);
238 
239     token.safeTransfer(beneficiary, unreleased);
240 
241     Released(unreleased);
242   }
243 
244   /**
245    * @notice Allows the owner to revoke the vesting. Tokens already vested
246    * remain in the contract, the rest are returned to the owner.
247    * @param token ERC20 token which is being vested
248    */
249   function revoke(ERC20Basic token) public onlyOwner {
250     require(revocable);
251     require(!revoked[token]);
252 
253     uint256 balance = token.balanceOf(this);
254 
255     uint256 unreleased = releasableAmount(token);
256     uint256 refund = balance.sub(unreleased);
257 
258     revoked[token] = true;
259 
260     token.safeTransfer(owner, refund);
261 
262     Revoked();
263   }
264 
265   /**
266    * @dev Calculates the amount that has already vested but hasn't been released yet.
267    * @param token ERC20 token which is being vested
268    */
269   function releasableAmount(ERC20Basic token) public view returns (uint256) {
270     return vestedAmount(token).sub(released[token]);
271   }
272 
273   /**
274    * @dev Calculates the amount that has already vested.
275    * @param token ERC20 token which is being vested
276    */
277   function vestedAmount(ERC20Basic token) public view returns (uint256) {
278     uint256 currentBalance = token.balanceOf(this);
279     uint256 totalBalance = currentBalance.add(released[token]);
280 
281     if (now < cliff) {
282       return 0;
283     } else if (now >= start.add(duration) || revoked[token]) {
284       return totalBalance;
285     } else {
286       return totalBalance.mul(now.sub(start)).div(duration);
287     }
288   }
289 }
290 
291 // File: contracts/distribution/InitialTokenDistribution.sol
292 
293 contract InitialTokenDistribution is Ownable {
294     using SafeMath for uint256;
295 
296     ERC20 public token;
297     mapping (address => uint256) public initiallyDistributed;
298     bool public initialDistributionDone = false;
299 
300     modifier onInitialDistribution() {
301         require(!initialDistributionDone);
302         _;
303     }
304 
305     function InitialTokenDistribution(ERC20 _token) public {
306         token = _token;
307     }
308 
309     /**
310      * @dev override for initial distribution logic
311      */
312     function totalTokensDistributed() public view returns (uint256);
313 
314     /**
315      * @dev call to initialize distribution  ***DO NOT OVERRIDE***
316      */
317     function processInitialDistribution() onInitialDistribution onlyOwner public {
318         initialDistribution();
319         initialDistributionDone = true;
320     }
321 
322     function initialTransfer(address to, uint256 amount) onInitialDistribution public {
323         require(to != address(0));
324         initiallyDistributed[to] = amount;
325         token.transferFrom(msg.sender, to, amount);
326     }
327 
328     /**
329      * @dev override for initial distribution logic
330      */
331     function initialDistribution() internal;
332 }
333 
334 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
335 
336 contract DetailedERC20 is ERC20 {
337   string public name;
338   string public symbol;
339   uint8 public decimals;
340 
341   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
342     name = _name;
343     symbol = _symbol;
344     decimals = _decimals;
345   }
346 }
347 
348 // File: contracts/CurrentInitialDistribution.sol
349 
350 contract CurrentInitialTokenDistribution is InitialTokenDistribution {
351 
352 
353     uint256 public reservedTokensFounders;
354     uint256 public reservedOperationalExpenses;
355     uint256 public reservedIcoCrowdsale;
356 
357     address public foundersWallet;
358     address public operationalExpensesWallet;
359     address public icoCrowdsaleContract;
360 
361     function CurrentInitialTokenDistribution (
362         DetailedERC20 _token,
363         address _foundersWallet,
364         address _operationalExpensesWallet,
365         address _icoCrowdsaleContract
366     ) InitialTokenDistribution(_token) public
367     {
368         foundersWallet = _foundersWallet;
369         operationalExpensesWallet = _operationalExpensesWallet;
370         icoCrowdsaleContract = _icoCrowdsaleContract;
371 
372         uint8 decimals = _token.decimals();
373         reservedTokensFounders = 40e9 * (10 ** uint256(decimals));
374         reservedOperationalExpenses = 10e9 * (10 ** uint256(decimals));
375         reservedIcoCrowdsale = 499e8 * (10 ** uint256(decimals));
376     }
377 
378     function totalTokensDistributed() public view returns (uint256) {
379         return reservedTokensFounders + reservedOperationalExpenses + reservedIcoCrowdsale;
380     }
381 
382     function initialDistribution() internal {
383         initialTransfer(foundersWallet, reservedTokensFounders);
384         initialTransfer(operationalExpensesWallet, reservedOperationalExpenses);
385         initialTransfer(icoCrowdsaleContract, reservedIcoCrowdsale);
386     }
387 }