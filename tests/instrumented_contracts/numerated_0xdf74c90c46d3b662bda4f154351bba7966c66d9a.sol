1 pragma solidity 0.4.23;
2 
3 // File: contracts/ACOTokenCrowdsale.sol
4 
5 interface ACOTokenCrowdsale {
6     function buyTokens(address beneficiary) external payable;
7     function hasEnded() external view returns (bool);
8 }
9 
10 // File: contracts/lib/DS-Math.sol
11 
12 /// math.sol -- mixin for inline numerical wizardry
13 
14 // This program is free software: you can redistribute it and/or modify
15 // it under the terms of the GNU General Public License as published by
16 // the Free Software Foundation, either version 3 of the License, or
17 // (at your option) any later version.
18 
19 // This program is distributed in the hope that it will be useful,
20 // but WITHOUT ANY WARRANTY; without even the implied warranty of
21 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
22 // GNU General Public License for more details.
23 
24 // You should have received a copy of the GNU General Public License
25 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
26 
27 pragma solidity 0.4.23;
28 
29 contract DSMath {
30     function add(uint x, uint y) internal pure returns (uint z) {
31         require((z = x + y) >= x);
32     }
33     function sub(uint x, uint y) internal pure returns (uint z) {
34         require((z = x - y) <= x);
35     }
36     function mul(uint x, uint y) internal pure returns (uint z) {
37         require(y == 0 || (z = x * y) / y == x);
38     }
39 
40     function min(uint x, uint y) internal pure returns (uint z) {
41         return x <= y ? x : y;
42     }
43     // function max(uint x, uint y) internal pure returns (uint z) {
44     //     return x >= y ? x : y;
45     // }
46     // function imin(int x, int y) internal pure returns (int z) {
47     //     return x <= y ? x : y;
48     // }
49     // function imax(int x, int y) internal pure returns (int z) {
50     //     return x >= y ? x : y;
51     // }
52 
53     // uint constant WAD = 10 ** 18;
54     // uint constant RAY = 10 ** 27;
55 
56     // function wmul(uint x, uint y) internal pure returns (uint z) {
57     //     z = add(mul(x, y), WAD / 2) / WAD;
58     // }
59     // function rmul(uint x, uint y) internal pure returns (uint z) {
60     //     z = add(mul(x, y), RAY / 2) / RAY;
61     // }
62     // function wdiv(uint x, uint y) internal pure returns (uint z) {
63     //     z = add(mul(x, WAD), y / 2) / y;
64     // }
65     // function rdiv(uint x, uint y) internal pure returns (uint z) {
66     //     z = add(mul(x, RAY), y / 2) / y;
67     // }
68 
69     // // This famous algorithm is called "exponentiation by squaring"
70     // // and calculates x^n with x as fixed-point and n as regular unsigned.
71     // //
72     // // It's O(log n), instead of O(n) for naive repeated multiplication.
73     // //
74     // // These facts are why it works:
75     // //
76     // //  If n is even, then x^n = (x^2)^(n/2).
77     // //  If n is odd,  then x^n = x * x^(n-1),
78     // //   and applying the equation for even x gives
79     // //    x^n = x * (x^2)^((n-1) / 2).
80     // //
81     // //  Also, EVM division is flooring and
82     // //    floor[(n-1) / 2] = floor[n / 2].
83     // //
84     // function rpow(uint x, uint n) internal pure returns (uint z) {
85     //     z = n % 2 != 0 ? x : RAY;
86 
87     //     for (n /= 2; n != 0; n /= 2) {
88     //         x = rmul(x, x);
89 
90     //         if (n % 2 != 0) {
91     //             z = rmul(z, x);
92     //         }
93     //     }
94     // }
95 }
96 
97 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
98 
99 /**
100  * @title Ownable
101  * @dev The Ownable contract has an owner address, and provides basic authorization control
102  * functions, this simplifies the implementation of "user permissions".
103  */
104 contract Ownable {
105   address public owner;
106 
107 
108   event OwnershipRenounced(address indexed previousOwner);
109   event OwnershipTransferred(
110     address indexed previousOwner,
111     address indexed newOwner
112   );
113 
114 
115   /**
116    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
117    * account.
118    */
119   constructor() public {
120     owner = msg.sender;
121   }
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) public onlyOwner {
136     require(newOwner != address(0));
137     emit OwnershipTransferred(owner, newOwner);
138     owner = newOwner;
139   }
140 
141   /**
142    * @dev Allows the current owner to relinquish control of the contract.
143    */
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipRenounced(owner);
146     owner = address(0);
147   }
148 }
149 
150 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
151 
152 /**
153  * @title Pausable
154  * @dev Base contract which allows children to implement an emergency stop mechanism.
155  */
156 contract Pausable is Ownable {
157   event Pause();
158   event Unpause();
159 
160   bool public paused = false;
161 
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is not paused.
165    */
166   modifier whenNotPaused() {
167     require(!paused);
168     _;
169   }
170 
171   /**
172    * @dev Modifier to make a function callable only when the contract is paused.
173    */
174   modifier whenPaused() {
175     require(paused);
176     _;
177   }
178 
179   /**
180    * @dev called by the owner to pause, triggers stopped state
181    */
182   function pause() onlyOwner whenNotPaused public {
183     paused = true;
184     emit Pause();
185   }
186 
187   /**
188    * @dev called by the owner to unpause, returns to normal state
189    */
190   function unpause() onlyOwner whenPaused public {
191     paused = false;
192     emit Unpause();
193   }
194 }
195 
196 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
197 
198 /**
199  * @title ERC20Basic
200  * @dev Simpler version of ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/179
202  */
203 contract ERC20Basic {
204   function totalSupply() public view returns (uint256);
205   function balanceOf(address who) public view returns (uint256);
206   function transfer(address to, uint256 value) public returns (bool);
207   event Transfer(address indexed from, address indexed to, uint256 value);
208 }
209 
210 // File: openzeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
211 
212 /**
213  * @title TokenDestructible:
214  * @author Remco Bloemen <remco@2π.com>
215  * @dev Base contract that can be destroyed by owner. All funds in contract including
216  * listed tokens will be sent to the owner.
217  */
218 contract TokenDestructible is Ownable {
219 
220   constructor() public payable { }
221 
222   /**
223    * @notice Terminate contract and refund to owner
224    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
225    refund.
226    * @notice The called token contracts could try to re-enter this contract. Only
227    supply token contracts you trust.
228    */
229   function destroy(address[] tokens) onlyOwner public {
230 
231     // Transfer tokens to owner
232     for (uint256 i = 0; i < tokens.length; i++) {
233       ERC20Basic token = ERC20Basic(tokens[i]);
234       uint256 balance = token.balanceOf(this);
235       token.transfer(owner, balance);
236     }
237 
238     // Transfer Eth to owner and terminate contract
239     selfdestruct(owner);
240   }
241 }
242 
243 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
244 
245 /**
246  * @title Claimable
247  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
248  * This allows the new owner to accept the transfer.
249  */
250 contract Claimable is Ownable {
251   address public pendingOwner;
252 
253   /**
254    * @dev Modifier throws if called by any account other than the pendingOwner.
255    */
256   modifier onlyPendingOwner() {
257     require(msg.sender == pendingOwner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to set the pendingOwner address.
263    * @param newOwner The address to transfer ownership to.
264    */
265   function transferOwnership(address newOwner) onlyOwner public {
266     pendingOwner = newOwner;
267   }
268 
269   /**
270    * @dev Allows the pendingOwner address to finalize the transfer.
271    */
272   function claimOwnership() onlyPendingOwner public {
273     emit OwnershipTransferred(owner, pendingOwner);
274     owner = pendingOwner;
275     pendingOwner = address(0);
276   }
277 }
278 
279 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
280 
281 /**
282  * @title ERC20 interface
283  * @dev see https://github.com/ethereum/EIPs/issues/20
284  */
285 contract ERC20 is ERC20Basic {
286   function allowance(address owner, address spender)
287     public view returns (uint256);
288 
289   function transferFrom(address from, address to, uint256 value)
290     public returns (bool);
291 
292   function approve(address spender, uint256 value) public returns (bool);
293   event Approval(
294     address indexed owner,
295     address indexed spender,
296     uint256 value
297   );
298 }
299 
300 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
301 
302 /**
303  * @title SafeERC20
304  * @dev Wrappers around ERC20 operations that throw on failure.
305  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
306  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
307  */
308 library SafeERC20 {
309   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
310     require(token.transfer(to, value));
311   }
312 
313   function safeTransferFrom(
314     ERC20 token,
315     address from,
316     address to,
317     uint256 value
318   )
319     internal
320   {
321     require(token.transferFrom(from, to, value));
322   }
323 
324   function safeApprove(ERC20 token, address spender, uint256 value) internal {
325     require(token.approve(spender, value));
326   }
327 }
328 
329 // File: contracts/TokenBuy.sol
330 
331 /// @title Group-buy contract for Token ICO
332 /// @author Joe Wasson
333 /// @notice Allows for group purchase of the Token ICO. This is done
334 ///   in two phases:
335 ///     a) contributions initiate a purchase on demand.
336 ///     b) tokens are collected when they are unfrozen
337 contract TokenBuy is Pausable, Claimable, TokenDestructible, DSMath {
338     using SafeERC20 for ERC20Basic;
339 
340     /// @notice Token ICO contract
341     ACOTokenCrowdsale public crowdsaleContract;
342 
343     /// @notice Token contract
344     ERC20Basic public tokenContract;
345 
346     /// @notice Map of contributors and their token balances
347     mapping(address => uint) public balances;
348 
349     /// @notice List of contributors to the sale
350     address[] public contributors;
351 
352     /// @notice Total amount contributed to the sale
353     uint public totalContributions;
354 
355     /// @notice Total number of tokens purchased
356     uint public totalTokensPurchased;
357 
358     /// @notice Emitted whenever a contribution is made
359     event Purchase(address indexed sender, uint ethAmount, uint tokensPurchased);
360 
361     /// @notice Emitted whenever tokens are collected fromthe contract
362     event Collection(address indexed recipient, uint amount);
363 
364     /// @notice Time when locked funds in the contract can be retrieved.
365     uint constant unlockTime = 1543622400; // 2018-12-01 00:00:00 GMT
366 
367     /// @notice Guards against executing the function if the sale
368     ///    is not running.
369     modifier whenSaleRunning() {
370         require(!crowdsaleContract.hasEnded());
371         _;
372     }
373 
374     /// @param crowdsale the Crowdsale contract (or a wrapper around it)
375     /// @param token the token contract
376     constructor(ACOTokenCrowdsale crowdsale, ERC20Basic token) public {
377         require(crowdsale != address(0x0));
378         require(token != address(0x0));
379         crowdsaleContract = crowdsale;
380         tokenContract = token;
381     }
382 
383     /// @notice returns the number of contributors in the list of contributors
384     /// @return count of contributors
385     /// @dev As the `collectAll` function is called the contributor array is cleaned up
386     ///     consequently this method only returns the remaining contributor count.
387     function contributorCount() public view returns (uint) {
388         return contributors.length;
389     }
390 
391     /// @dev Dispatches between buying and collecting
392     function() public payable {
393         if (msg.value == 0) {
394             collectFor(msg.sender);
395         } else {
396             buy();
397         }
398     }
399 
400     /// @notice Executes a purchase.
401     function buy() whenNotPaused whenSaleRunning private {
402         address buyer = msg.sender;
403         totalContributions += msg.value;
404         uint tokensPurchased = purchaseTokens();
405         totalTokensPurchased = add(totalTokensPurchased, tokensPurchased);
406 
407         uint previousBalance = balances[buyer];
408         balances[buyer] = add(previousBalance, tokensPurchased);
409 
410         // new contributor
411         if (previousBalance == 0) {
412             contributors.push(buyer);
413         }
414 
415         emit Purchase(buyer, msg.value, tokensPurchased);
416     }
417 
418     function purchaseTokens() private returns (uint tokensPurchased) {
419         address me = address(this);
420         uint previousBalance = tokenContract.balanceOf(me);
421         crowdsaleContract.buyTokens.value(msg.value)(me);
422         uint newBalance = tokenContract.balanceOf(me);
423 
424         require(newBalance > previousBalance); // Fail on underflow or purchase of 0
425         return newBalance - previousBalance;
426     }
427 
428     /// @notice Allows users to collect purchased tokens after the sale.
429     /// @param recipient the address to collect tokens for
430     /// @dev Here we don't transfer zero tokens but this is an arbitrary decision.
431     function collectFor(address recipient) private {
432         uint tokensOwned = balances[recipient];
433         if (tokensOwned == 0) return;
434 
435         delete balances[recipient];
436         tokenContract.safeTransfer(recipient, tokensOwned);
437         emit Collection(recipient, tokensOwned);
438     }
439 
440     /// @notice Collects the balances for members of the purchase
441     /// @param max the maximum number of members to process (for gas purposes)
442     function collectAll(uint8 max) public returns (uint8 collected) {
443         max = uint8(min(max, contributors.length));
444         require(max > 0, "can't collect for zero users");
445 
446         uint index = contributors.length - 1;
447         for(uint offset = 0; offset < max; ++offset) {
448             address recipient = contributors[index - offset];
449 
450             if (balances[recipient] > 0) {
451                 collected++;
452                 collectFor(recipient);
453             }
454         }
455 
456         contributors.length -= offset;
457     }
458 
459     /// @notice Shuts down the contract
460     function destroy(address[] tokens) onlyOwner public {
461         require(now > unlockTime || (contributorCount() == 0 && paused));
462 
463         super.destroy(tokens);
464     }
465 }