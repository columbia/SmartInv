1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, February 18, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.18;
6 
7 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 // File: contracts/ReturnVestingRegistry.sol
50 
51 contract ReturnVestingRegistry is Ownable {
52 
53   mapping (address => address) public returnAddress;
54 
55   function record(address from, address to) onlyOwner public {
56     require(from != 0);
57 
58     returnAddress[from] = to;
59   }
60 }
61 
62 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/179
68  */
69 contract ERC20Basic {
70   function totalSupply() public view returns (uint256);
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // File: contracts/TerraformReserve.sol
90 
91 contract TerraformReserve is Ownable {
92 
93   /* Storing a balance for each user */
94   mapping (address => uint256) public lockedBalance;
95 
96   /* Store the total sum locked */
97   uint public totalLocked;
98 
99   /* Reference to the token */
100   ERC20 public manaToken;
101 
102   /* Contract that will assign the LAND and burn/return tokens */
103   address public landClaim;
104 
105   /* Prevent the token from accepting deposits */
106   bool public acceptingDeposits;
107 
108   event LockedBalance(address user, uint mana);
109   event LandClaimContractSet(address target);
110   event LandClaimExecuted(address user, uint value, bytes data);
111   event AcceptingDepositsChanged(bool _acceptingDeposits);
112 
113   function TerraformReserve(address _token) {
114     require(_token != 0);
115     manaToken = ERC20(_token);
116     acceptingDeposits = true;
117   }
118 
119   /**
120    * Lock MANA into the contract.
121    * This contract does not have another way to take the tokens out other than
122    * through the target contract.
123    */
124   function lockMana(address _from, uint256 mana) public {
125     require(acceptingDeposits);
126     require(mana >= 1000 * 1e18);
127     require(manaToken.transferFrom(_from, this, mana));
128 
129     lockedBalance[_from] += mana;
130     totalLocked += mana;
131     LockedBalance(_from, mana);
132   }
133 
134   /**
135    * Allows the owner of the contract to pause acceptingDeposits
136    */
137   function changeContractState(bool _acceptingDeposits) public onlyOwner {
138     acceptingDeposits = _acceptingDeposits;
139     AcceptingDepositsChanged(acceptingDeposits);
140   }
141 
142   /**
143    * Set the contract that can move the staked MANA.
144    * Calls the `approve` function of the ERC20 token with the total amount.
145    */
146   function setTargetContract(address target) public onlyOwner {
147     landClaim = target;
148     manaToken.approve(landClaim, totalLocked);
149     LandClaimContractSet(target);
150   }
151 
152   /**
153    * Prevent payments to the contract
154    */
155   function () public payable {
156     revert();
157   }
158 }
159 
160 // File: zeppelin-solidity/contracts/math/Math.sol
161 
162 /**
163  * @title Math
164  * @dev Assorted math operations
165  */
166 library Math {
167   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
168     return a >= b ? a : b;
169   }
170 
171   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
172     return a < b ? a : b;
173   }
174 
175   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
176     return a >= b ? a : b;
177   }
178 
179   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
180     return a < b ? a : b;
181   }
182 }
183 
184 // File: zeppelin-solidity/contracts/math/SafeMath.sol
185 
186 /**
187  * @title SafeMath
188  * @dev Math operations with safety checks that throw on error
189  */
190 library SafeMath {
191 
192   /**
193   * @dev Multiplies two numbers, throws on overflow.
194   */
195   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196     if (a == 0) {
197       return 0;
198     }
199     uint256 c = a * b;
200     assert(c / a == b);
201     return c;
202   }
203 
204   /**
205   * @dev Integer division of two numbers, truncating the quotient.
206   */
207   function div(uint256 a, uint256 b) internal pure returns (uint256) {
208     // assert(b > 0); // Solidity automatically throws when dividing by 0
209     uint256 c = a / b;
210     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211     return c;
212   }
213 
214   /**
215   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
216   */
217   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218     assert(b <= a);
219     return a - b;
220   }
221 
222   /**
223   * @dev Adds two numbers, throws on overflow.
224   */
225   function add(uint256 a, uint256 b) internal pure returns (uint256) {
226     uint256 c = a + b;
227     assert(c >= a);
228     return c;
229   }
230 }
231 
232 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
233 
234 /**
235  * @title SafeERC20
236  * @dev Wrappers around ERC20 operations that throw on failure.
237  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
238  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
239  */
240 library SafeERC20 {
241   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
242     assert(token.transfer(to, value));
243   }
244 
245   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
246     assert(token.transferFrom(from, to, value));
247   }
248 
249   function safeApprove(ERC20 token, address spender, uint256 value) internal {
250     assert(token.approve(spender, value));
251   }
252 }
253 
254 // File: contracts/TokenVesting.sol
255 
256 /**
257  * @title TokenVesting
258  * @dev A token holder contract that can release its token balance gradually like a
259  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
260  * owner.
261  */
262 contract TokenVesting is Ownable {
263   using SafeMath for uint256;
264   using SafeERC20 for ERC20;
265 
266   event Released(uint256 amount);
267   event Revoked();
268 
269   // beneficiary of tokens after they are released
270   address public beneficiary;
271 
272   uint256 public cliff;
273   uint256 public start;
274   uint256 public duration;
275 
276   bool public revocable;
277   bool public revoked;
278 
279   uint256 public released;
280 
281   ERC20 public token;
282 
283   /**
284    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
285    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
286    * of the balance will have vested.
287    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
288    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
289    * @param _duration duration in seconds of the period in which the tokens will vest
290    * @param _revocable whether the vesting is revocable or not
291    * @param _token address of the ERC20 token contract
292    */
293   function TokenVesting(
294     address _beneficiary,
295     uint256 _start,
296     uint256 _cliff,
297     uint256 _duration,
298     bool    _revocable,
299     address _token
300   ) {
301     require(_beneficiary != 0x0);
302     require(_cliff <= _duration);
303 
304     beneficiary = _beneficiary;
305     start       = _start;
306     cliff       = _start.add(_cliff);
307     duration    = _duration;
308     revocable   = _revocable;
309     token       = ERC20(_token);
310   }
311 
312   /**
313    * @notice Only allow calls from the beneficiary of the vesting contract
314    */
315   modifier onlyBeneficiary() {
316     require(msg.sender == beneficiary);
317     _;
318   }
319 
320   /**
321    * @notice Allow the beneficiary to change its address
322    * @param target the address to transfer the right to
323    */
324   function changeBeneficiary(address target) onlyBeneficiary public {
325     require(target != 0);
326     beneficiary = target;
327   }
328 
329   /**
330    * @notice Transfers vested tokens to beneficiary.
331    */
332   function release() onlyBeneficiary public {
333     require(now >= cliff);
334     _releaseTo(beneficiary);
335   }
336 
337   /**
338    * @notice Transfers vested tokens to a target address.
339    * @param target the address to send the tokens to
340    */
341   function releaseTo(address target) onlyBeneficiary public {
342     require(now >= cliff);
343     _releaseTo(target);
344   }
345 
346   /**
347    * @notice Transfers vested tokens to beneficiary.
348    */
349   function _releaseTo(address target) internal {
350     uint256 unreleased = releasableAmount();
351 
352     released = released.add(unreleased);
353 
354     token.safeTransfer(target, unreleased);
355 
356     Released(released);
357   }
358 
359   /**
360    * @notice Allows the owner to revoke the vesting. Tokens already vested are sent to the beneficiary.
361    */
362   function revoke() onlyOwner public {
363     require(revocable);
364     require(!revoked);
365 
366     // Release all vested tokens
367     _releaseTo(beneficiary);
368 
369     // Send the remainder to the owner
370     token.safeTransfer(owner, token.balanceOf(this));
371 
372     revoked = true;
373 
374     Revoked();
375   }
376 
377 
378   /**
379    * @dev Calculates the amount that has already vested but hasn't been released yet.
380    */
381   function releasableAmount() public constant returns (uint256) {
382     return vestedAmount().sub(released);
383   }
384 
385   /**
386    * @dev Calculates the amount that has already vested.
387    */
388   function vestedAmount() public constant returns (uint256) {
389     uint256 currentBalance = token.balanceOf(this);
390     uint256 totalBalance = currentBalance.add(released);
391 
392     if (now < cliff) {
393       return 0;
394     } else if (now >= start.add(duration) || revoked) {
395       return totalBalance;
396     } else {
397       return totalBalance.mul(now.sub(start)).div(duration);
398     }
399   }
400 
401   /**
402    * @notice Allow withdrawing any token other than the relevant one
403    */
404   function releaseForeignToken(ERC20 _token, uint256 amount) onlyOwner {
405     require(_token != token);
406     _token.transfer(owner, amount);
407   }
408 }
409 
410 // File: contracts/DecentralandVesting.sol
411 
412 contract DecentralandVesting is TokenVesting {
413   using SafeERC20 for ERC20;
414 
415   event LockedMANA(uint256 amount);
416 
417   ReturnVestingRegistry public returnVesting;
418   TerraformReserve public terraformReserve;
419 
420   function DecentralandVesting(
421     address               _beneficiary,
422     uint256               _start,
423     uint256               _cliff,
424     uint256               _duration,
425     bool                  _revocable,
426     ERC20                 _token,
427     ReturnVestingRegistry _returnVesting,
428     TerraformReserve      _terraformReserve
429   )
430     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable, _token)
431   {
432     returnVesting    = ReturnVestingRegistry(_returnVesting);
433     terraformReserve = TerraformReserve(_terraformReserve);
434   }
435 
436   function lockMana(uint256 amount) onlyBeneficiary public {
437     // Require allowance to be enough
438     require(token.allowance(beneficiary, terraformReserve) >= amount);
439 
440     // Check the balance of the vesting contract
441     require(amount <= token.balanceOf(this));
442 
443     // Check the registry of the beneficiary is fixed to return to this contract
444     require(returnVesting.returnAddress(beneficiary) == address(this));
445 
446     // Transfer and lock
447     token.safeTransfer(beneficiary, amount);
448     terraformReserve.lockMana(beneficiary, amount);
449 
450     LockedMANA(amount);
451   }
452 }