1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
39 
40 /**
41  * @title SafeERC20
42  * @dev Wrappers around ERC20 operations that throw on failure.
43  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
44  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
45  */
46 library SafeERC20 {
47   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
48     require(token.transfer(to, value));
49   }
50 
51   function safeTransferFrom(
52     ERC20 token,
53     address from,
54     address to,
55     uint256 value
56   )
57     internal
58   {
59     require(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     require(token.approve(spender, value));
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
68 
69 /**
70  * @title TokenTimelock
71  * @dev TokenTimelock is a token holder contract that will allow a
72  * beneficiary to extract the tokens after a given release time
73  */
74 contract TokenTimelock {
75   using SafeERC20 for ERC20Basic;
76 
77   // ERC20 basic token contract being held
78   ERC20Basic public token;
79 
80   // beneficiary of tokens after they are released
81   address public beneficiary;
82 
83   // timestamp when token release is enabled
84   uint256 public releaseTime;
85 
86   constructor(
87     ERC20Basic _token,
88     address _beneficiary,
89     uint256 _releaseTime
90   )
91     public
92   {
93     // solium-disable-next-line security/no-block-members
94     require(_releaseTime > block.timestamp);
95     token = _token;
96     beneficiary = _beneficiary;
97     releaseTime = _releaseTime;
98   }
99 
100   /**
101    * @notice Transfers tokens held by timelock to beneficiary.
102    */
103   function release() public {
104     // solium-disable-next-line security/no-block-members
105     require(block.timestamp >= releaseTime);
106 
107     uint256 amount = token.balanceOf(this);
108     require(amount > 0);
109 
110     token.safeTransfer(beneficiary, amount);
111   }
112 }
113 
114 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, throws on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     c = a * b;
134     assert(c / a == b);
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers, truncating the quotient.
140   */
141   function div(uint256 a, uint256 b) internal pure returns (uint256) {
142     // assert(b > 0); // Solidity automatically throws when dividing by 0
143     // uint256 c = a / b;
144     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145     return a / b;
146   }
147 
148   /**
149   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     assert(b <= a);
153     return a - b;
154   }
155 
156   /**
157   * @dev Adds two numbers, throws on overflow.
158   */
159   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
160     c = a + b;
161     assert(c >= a);
162     return c;
163   }
164 }
165 
166 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174   address public owner;
175 
176 
177   event OwnershipRenounced(address indexed previousOwner);
178   event OwnershipTransferred(
179     address indexed previousOwner,
180     address indexed newOwner
181   );
182 
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   constructor() public {
189     owner = msg.sender;
190   }
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200   /**
201    * @dev Allows the current owner to relinquish control of the contract.
202    */
203   function renounceOwnership() public onlyOwner {
204     emit OwnershipRenounced(owner);
205     owner = address(0);
206   }
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param _newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address _newOwner) public onlyOwner {
213     _transferOwnership(_newOwner);
214   }
215 
216   /**
217    * @dev Transfers control of the contract to a newOwner.
218    * @param _newOwner The address to transfer ownership to.
219    */
220   function _transferOwnership(address _newOwner) internal {
221     require(_newOwner != address(0));
222     emit OwnershipTransferred(owner, _newOwner);
223     owner = _newOwner;
224   }
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
228 
229 /* solium-disable security/no-block-members */
230 
231 pragma solidity ^0.4.23;
232 
233 
234 
235 
236 
237 
238 /**
239  * @title TokenVesting
240  * @dev A token holder contract that can release its token balance gradually like a
241  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
242  * owner.
243  */
244 contract TokenVesting is Ownable {
245   using SafeMath for uint256;
246   using SafeERC20 for ERC20Basic;
247 
248   event Released(uint256 amount);
249   event Revoked();
250 
251   // beneficiary of tokens after they are released
252   address public beneficiary;
253 
254   uint256 public cliff;
255   uint256 public start;
256   uint256 public duration;
257 
258   bool public revocable;
259 
260   mapping (address => uint256) public released;
261   mapping (address => bool) public revoked;
262 
263   /**
264    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
265    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
266    * of the balance will have vested.
267    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
268    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
269    * @param _start the time (as Unix time) at which point vesting starts 
270    * @param _duration duration in seconds of the period in which the tokens will vest
271    * @param _revocable whether the vesting is revocable or not
272    */
273   constructor(
274     address _beneficiary,
275     uint256 _start,
276     uint256 _cliff,
277     uint256 _duration,
278     bool _revocable
279   )
280     public
281   {
282     require(_beneficiary != address(0));
283     require(_cliff <= _duration);
284 
285     beneficiary = _beneficiary;
286     revocable = _revocable;
287     duration = _duration;
288     cliff = _start.add(_cliff);
289     start = _start;
290   }
291 
292   /**
293    * @notice Transfers vested tokens to beneficiary.
294    * @param token ERC20 token which is being vested
295    */
296   function release(ERC20Basic token) public {
297     uint256 unreleased = releasableAmount(token);
298 
299     require(unreleased > 0);
300 
301     released[token] = released[token].add(unreleased);
302 
303     token.safeTransfer(beneficiary, unreleased);
304 
305     emit Released(unreleased);
306   }
307 
308   /**
309    * @notice Allows the owner to revoke the vesting. Tokens already vested
310    * remain in the contract, the rest are returned to the owner.
311    * @param token ERC20 token which is being vested
312    */
313   function revoke(ERC20Basic token) public onlyOwner {
314     require(revocable);
315     require(!revoked[token]);
316 
317     uint256 balance = token.balanceOf(this);
318 
319     uint256 unreleased = releasableAmount(token);
320     uint256 refund = balance.sub(unreleased);
321 
322     revoked[token] = true;
323 
324     token.safeTransfer(owner, refund);
325 
326     emit Revoked();
327   }
328 
329   /**
330    * @dev Calculates the amount that has already vested but hasn't been released yet.
331    * @param token ERC20 token which is being vested
332    */
333   function releasableAmount(ERC20Basic token) public view returns (uint256) {
334     return vestedAmount(token).sub(released[token]);
335   }
336 
337   /**
338    * @dev Calculates the amount that has already vested.
339    * @param token ERC20 token which is being vested
340    */
341   function vestedAmount(ERC20Basic token) public view returns (uint256) {
342     uint256 currentBalance = token.balanceOf(this);
343     uint256 totalBalance = currentBalance.add(released[token]);
344 
345     if (block.timestamp < cliff) {
346       return 0;
347     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
348       return totalBalance;
349     } else {
350       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
351     }
352   }
353 }
354 
355 // File: contracts/distribution/InitialTokenDistribution.sol
356 
357 contract InitialTokenDistribution is Ownable {
358     using SafeMath for uint256;
359 
360     ERC20 public token;
361     mapping (address => TokenVesting) public vested;
362     mapping (address => TokenTimelock) public timelocked;
363     mapping (address => uint256) public initiallyDistributed;
364     bool public initialDistributionDone = false;
365 
366     modifier onInitialDistribution() {
367         require(!initialDistributionDone);
368         _;
369     }
370 
371     constructor(ERC20 _token) public {
372         token = _token;
373     }
374 
375     /**
376      * @dev override for initial distribution logic
377      */
378     function initialDistribution() internal;
379 
380     /**
381      * @dev override for initial distribution logic
382      */
383     function totalTokensDistributed() public view returns (uint256);
384 
385     /**
386      * @dev call to initialize distribution  ***DO NOT OVERRIDE***
387      */
388     function processInitialDistribution() onInitialDistribution onlyOwner public {
389         initialDistribution();
390         initialDistributionDone = true;
391     }
392 
393     function initialTransfer(address to, uint256 amount) onInitialDistribution public {
394         require(to != address(0));
395         initiallyDistributed[to] = amount;
396         token.transferFrom(msg.sender, to, amount);
397     }
398 
399     function vest(address to, uint256 amount, uint256 releaseStart, uint256 cliff, uint256 duration) onInitialDistribution public {
400         require(to != address(0));
401         vested[to] = new TokenVesting(to, releaseStart, cliff, duration, false);
402         token.transferFrom(msg.sender, vested[to], amount);
403     }
404 
405     function lock(address to, uint256 amount, uint256 releaseTime) onInitialDistribution public {
406         require(to != address(0));
407         timelocked[to] = new TokenTimelock(token, to, releaseTime);
408         token.transferFrom(msg.sender, address(timelocked[to]), amount);
409     }
410 }
411 
412 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
413 
414 /**
415  * @title DetailedERC20 token
416  * @dev The decimals are only for visualization purposes.
417  * All the operations are done using the smallest and indivisible token unit,
418  * just as on Ethereum all the operations are done in wei.
419  */
420 contract DetailedERC20 is ERC20 {
421   string public name;
422   string public symbol;
423   uint8 public decimals;
424 
425   constructor(string _name, string _symbol, uint8 _decimals) public {
426     name = _name;
427     symbol = _symbol;
428     decimals = _decimals;
429   }
430 }
431 
432 // File: contracts/BlockFollowInitialTokenDistribution.sol
433 
434 contract BlockFollowInitialTokenDistribution is InitialTokenDistribution {
435 
436 
437     uint256 public reservedTokensFunctionality;
438     uint256 public reservedTokensTeam;
439 
440     address functionalityWallet;
441     address teamWallet;
442 
443     constructor(
444         DetailedERC20 _token,
445         address _functionalityWallet,
446         address _teamWallet
447     )
448     public
449     InitialTokenDistribution(_token)
450     {
451         functionalityWallet = _functionalityWallet;
452         teamWallet = _teamWallet;
453 
454         uint8 decimals = _token.decimals();
455         reservedTokensFunctionality = 80e6 * (10 ** uint256(decimals));
456         reservedTokensTeam = 10e6 * (10 ** uint256(decimals));
457     }
458 
459     function initialDistribution() internal {
460         initialTransfer(functionalityWallet, reservedTokensFunctionality);
461         initialTransfer(teamWallet, reservedTokensTeam);
462     }
463 
464     function totalTokensDistributed() public view returns (uint256) {
465         return reservedTokensFunctionality + reservedTokensTeam;
466     }
467 }