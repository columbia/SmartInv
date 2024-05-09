1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/ReturnVestingRegistry.sol
46 
47 contract ReturnVestingRegistry is Ownable {
48 
49   mapping (address => address) public returnAddress;
50 
51   function record(address from, address to) onlyOwner public {
52     require(from != 0);
53 
54     returnAddress[from] = to;
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
73 
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 contract ERC20 is ERC20Basic {
79   function allowance(address owner, address spender) public view returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: contracts/TerraformReserve.sol
86 
87 contract TerraformReserve is Ownable {
88 
89   /* Storing a balance for each user */
90   mapping (address => uint256) public lockedBalance;
91 
92   /* Store the total sum locked */
93   uint public totalLocked;
94 
95   /* Reference to the token */
96   ERC20 public manaToken;
97 
98   /* Contract that will assign the LAND and burn/return tokens */
99   address public landClaim;
100 
101   /* Prevent the token from accepting deposits */
102   bool public acceptingDeposits;
103 
104   event LockedBalance(address user, uint mana);
105   event LandClaimContractSet(address target);
106   event LandClaimExecuted(address user, uint value, bytes data);
107   event AcceptingDepositsChanged(bool _acceptingDeposits);
108 
109   function TerraformReserve(address _token) {
110     require(_token != 0);
111     manaToken = ERC20(_token);
112     acceptingDeposits = true;
113   }
114 
115   /**
116    * Lock MANA into the contract.
117    * This contract does not have another way to take the tokens out other than
118    * through the target contract.
119    */
120   function lockMana(address _from, uint256 mana) public {
121     require(acceptingDeposits);
122     require(mana >= 1000 * 1e18);
123     require(manaToken.transferFrom(_from, this, mana));
124 
125     lockedBalance[_from] += mana;
126     totalLocked += mana;
127     LockedBalance(_from, mana);
128   }
129 
130   /**
131    * Allows the owner of the contract to pause acceptingDeposits
132    */
133   function changeContractState(bool _acceptingDeposits) public onlyOwner {
134     acceptingDeposits = _acceptingDeposits;
135     AcceptingDepositsChanged(acceptingDeposits);
136   }
137 
138   /**
139    * Set the contract that can move the staked MANA.
140    * Calls the `approve` function of the ERC20 token with the total amount.
141    */
142   function setTargetContract(address target) public onlyOwner {
143     landClaim = target;
144     manaToken.approve(landClaim, totalLocked);
145     LandClaimContractSet(target);
146   }
147 
148   /**
149    * Prevent payments to the contract
150    */
151   function () public payable {
152     revert();
153   }
154 }
155 
156 // File: zeppelin-solidity/contracts/math/Math.sol
157 
158 /**
159  * @title Math
160  * @dev Assorted math operations
161  */
162 library Math {
163   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
164     return a >= b ? a : b;
165   }
166 
167   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
168     return a < b ? a : b;
169   }
170 
171   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
172     return a >= b ? a : b;
173   }
174 
175   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
176     return a < b ? a : b;
177   }
178 }
179 
180 // File: zeppelin-solidity/contracts/math/SafeMath.sol
181 
182 /**
183  * @title SafeMath
184  * @dev Math operations with safety checks that throw on error
185  */
186 library SafeMath {
187 
188   /**
189   * @dev Multiplies two numbers, throws on overflow.
190   */
191   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192     if (a == 0) {
193       return 0;
194     }
195     uint256 c = a * b;
196     assert(c / a == b);
197     return c;
198   }
199 
200   /**
201   * @dev Integer division of two numbers, truncating the quotient.
202   */
203   function div(uint256 a, uint256 b) internal pure returns (uint256) {
204     // assert(b > 0); // Solidity automatically throws when dividing by 0
205     uint256 c = a / b;
206     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207     return c;
208   }
209 
210   /**
211   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
212   */
213   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214     assert(b <= a);
215     return a - b;
216   }
217 
218   /**
219   * @dev Adds two numbers, throws on overflow.
220   */
221   function add(uint256 a, uint256 b) internal pure returns (uint256) {
222     uint256 c = a + b;
223     assert(c >= a);
224     return c;
225   }
226 }
227 
228 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
229 
230 /**
231  * @title SafeERC20
232  * @dev Wrappers around ERC20 operations that throw on failure.
233  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
234  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
235  */
236 library SafeERC20 {
237   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
238     assert(token.transfer(to, value));
239   }
240 
241   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
242     assert(token.transferFrom(from, to, value));
243   }
244 
245   function safeApprove(ERC20 token, address spender, uint256 value) internal {
246     assert(token.approve(spender, value));
247   }
248 }
249 
250 // File: contracts/TokenVesting.sol
251 
252 /**
253  * @title TokenVesting
254  * @dev A token holder contract that can release its token balance gradually like a
255  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
256  * owner.
257  */
258 contract TokenVesting is Ownable {
259   using SafeMath for uint256;
260   using SafeERC20 for ERC20;
261 
262   event Released(uint256 amount);
263   event Revoked();
264 
265   // beneficiary of tokens after they are released
266   address public beneficiary;
267 
268   uint256 public cliff;
269   uint256 public start;
270   uint256 public duration;
271 
272   bool public revocable;
273   bool public revoked;
274 
275   uint256 public released;
276 
277   ERC20 public token;
278 
279   /**
280    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
281    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
282    * of the balance will have vested.
283    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
284    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
285    * @param _duration duration in seconds of the period in which the tokens will vest
286    * @param _revocable whether the vesting is revocable or not
287    * @param _token address of the ERC20 token contract
288    */
289   function TokenVesting(
290     address _beneficiary,
291     uint256 _start,
292     uint256 _cliff,
293     uint256 _duration,
294     bool    _revocable,
295     address _token
296   ) {
297     require(_beneficiary != 0x0);
298     require(_cliff <= _duration);
299 
300     beneficiary = _beneficiary;
301     start       = _start;
302     cliff       = _start.add(_cliff);
303     duration    = _duration;
304     revocable   = _revocable;
305     token       = ERC20(_token);
306   }
307 
308   /**
309    * @notice Only allow calls from the beneficiary of the vesting contract
310    */
311   modifier onlyBeneficiary() {
312     require(msg.sender == beneficiary);
313     _;
314   }
315 
316   /**
317    * @notice Allow the beneficiary to change its address
318    * @param target the address to transfer the right to
319    */
320   function changeBeneficiary(address target) onlyBeneficiary public {
321     require(target != 0);
322     beneficiary = target;
323   }
324 
325   /**
326    * @notice Transfers vested tokens to beneficiary.
327    */
328   function release() onlyBeneficiary public {
329     require(now >= cliff);
330     _releaseTo(beneficiary);
331   }
332 
333   /**
334    * @notice Transfers vested tokens to a target address.
335    * @param target the address to send the tokens to
336    */
337   function releaseTo(address target) onlyBeneficiary public {
338     require(now >= cliff);
339     _releaseTo(target);
340   }
341 
342   /**
343    * @notice Transfers vested tokens to beneficiary.
344    */
345   function _releaseTo(address target) internal {
346     uint256 unreleased = releasableAmount();
347 
348     released = released.add(unreleased);
349 
350     token.safeTransfer(target, unreleased);
351 
352     Released(released);
353   }
354 
355   /**
356    * @notice Allows the owner to revoke the vesting. Tokens already vested are sent to the beneficiary.
357    */
358   function revoke() onlyOwner public {
359     require(revocable);
360     require(!revoked);
361 
362     // Release all vested tokens
363     _releaseTo(beneficiary);
364 
365     // Send the remainder to the owner
366     token.safeTransfer(owner, token.balanceOf(this));
367 
368     revoked = true;
369 
370     Revoked();
371   }
372 
373 
374   /**
375    * @dev Calculates the amount that has already vested but hasn't been released yet.
376    */
377   function releasableAmount() public constant returns (uint256) {
378     return vestedAmount().sub(released);
379   }
380 
381   /**
382    * @dev Calculates the amount that has already vested.
383    */
384   function vestedAmount() public constant returns (uint256) {
385     uint256 currentBalance = token.balanceOf(this);
386     uint256 totalBalance = currentBalance.add(released);
387 
388     if (now < cliff) {
389       return 0;
390     } else if (now >= start.add(duration) || revoked) {
391       return totalBalance;
392     } else {
393       return totalBalance.mul(now.sub(start)).div(duration);
394     }
395   }
396 
397   /**
398    * @notice Allow withdrawing any token other than the relevant one
399    */
400   function releaseForeignToken(ERC20 _token, uint256 amount) onlyOwner {
401     require(_token != token);
402     _token.transfer(owner, amount);
403   }
404 }
405 
406 // File: contracts/DecentralandVesting.sol
407 
408 contract DecentralandVesting is TokenVesting {
409   using SafeERC20 for ERC20;
410 
411   event LockedMANA(uint256 amount);
412 
413   ReturnVestingRegistry public returnVesting;
414   TerraformReserve public terraformReserve;
415 
416   function DecentralandVesting(
417     address               _beneficiary,
418     uint256               _start,
419     uint256               _cliff,
420     uint256               _duration,
421     bool                  _revocable,
422     ERC20                 _token,
423     ReturnVestingRegistry _returnVesting,
424     TerraformReserve      _terraformReserve
425   )
426     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable, _token)
427   {
428     returnVesting    = ReturnVestingRegistry(_returnVesting);
429     terraformReserve = TerraformReserve(_terraformReserve);
430   }
431 
432   function lockMana(uint256 amount) onlyBeneficiary public {
433     // Require allowance to be enough
434     require(token.allowance(beneficiary, terraformReserve) >= amount);
435 
436     // Check the balance of the vesting contract
437     require(amount <= token.balanceOf(this));
438 
439     // Check the registry of the beneficiary is fixed to return to this contract
440     require(returnVesting.returnAddress(beneficiary) == address(this));
441 
442     // Transfer and lock
443     token.safeTransfer(beneficiary, amount);
444     terraformReserve.lockMana(beneficiary, amount);
445 
446     LockedMANA(amount);
447   }
448 }