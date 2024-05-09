1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 interface IERC20 {
86   function totalSupply() external view returns (uint256);
87 
88   function balanceOf(address who) external view returns (uint256);
89 
90   function allowance(address owner, address spender)
91     external view returns (uint256);
92 
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   function approve(address spender, uint256 value)
96     external returns (bool);
97 
98   function transferFrom(address from, address to, uint256 value)
99     external returns (bool);
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 value
105   );
106 
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
181 
182 /**
183  * @title SafeERC20
184  * @dev Wrappers around ERC20 operations that throw on failure.
185  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
186  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
187  */
188 library SafeERC20 {
189 
190   using SafeMath for uint256;
191 
192   function safeTransfer(
193     IERC20 token,
194     address to,
195     uint256 value
196   )
197     internal
198   {
199     require(token.transfer(to, value));
200   }
201 
202   function safeTransferFrom(
203     IERC20 token,
204     address from,
205     address to,
206     uint256 value
207   )
208     internal
209   {
210     require(token.transferFrom(from, to, value));
211   }
212 
213   function safeApprove(
214     IERC20 token,
215     address spender,
216     uint256 value
217   )
218     internal
219   {
220     // safeApprove should only be called when setting an initial allowance, 
221     // or when resetting it to zero. To increase and decrease it, use 
222     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
223     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
224     require(token.approve(spender, value));
225   }
226 
227   function safeIncreaseAllowance(
228     IERC20 token,
229     address spender,
230     uint256 value
231   )
232     internal
233   {
234     uint256 newAllowance = token.allowance(address(this), spender).add(value);
235     require(token.approve(spender, newAllowance));
236   }
237 
238   function safeDecreaseAllowance(
239     IERC20 token,
240     address spender,
241     uint256 value
242   )
243     internal
244   {
245     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
246     require(token.approve(spender, newAllowance));
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/drafts/TokenVesting.sol
251 
252 /* solium-disable security/no-block-members */
253 
254 pragma solidity ^0.4.24;
255 
256 
257 
258 
259 /**
260  * @title TokenVesting
261  * @dev A token holder contract that can release its token balance gradually like a
262  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
263  * owner.
264  */
265 contract TokenVesting is Ownable {
266   using SafeMath for uint256;
267   using SafeERC20 for IERC20;
268 
269   event TokensReleased(address token, uint256 amount);
270   event TokenVestingRevoked(address token);
271 
272   // beneficiary of tokens after they are released
273   address private _beneficiary;
274 
275   uint256 private _cliff;
276   uint256 private _start;
277   uint256 private _duration;
278 
279   bool private _revocable;
280 
281   mapping (address => uint256) private _released;
282   mapping (address => bool) private _revoked;
283 
284   /**
285    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
286    * beneficiary, gradually in a linear fashion until start + duration. By then all
287    * of the balance will have vested.
288    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
289    * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
290    * @param start the time (as Unix time) at which point vesting starts
291    * @param duration duration in seconds of the period in which the tokens will vest
292    * @param revocable whether the vesting is revocable or not
293    */
294   constructor(
295     address beneficiary,
296     uint256 start,
297     uint256 cliffDuration,
298     uint256 duration,
299     bool revocable
300   )
301     public
302   {
303     require(beneficiary != address(0));
304     require(cliffDuration <= duration);
305     require(duration > 0);
306     require(start.add(duration) > block.timestamp);
307 
308     _beneficiary = beneficiary;
309     _revocable = revocable;
310     _duration = duration;
311     _cliff = start.add(cliffDuration);
312     _start = start;
313   }
314 
315   /**
316    * @return the beneficiary of the tokens.
317    */
318   function beneficiary() public view returns(address) {
319     return _beneficiary;
320   }
321 
322   /**
323    * @return the cliff time of the token vesting.
324    */
325   function cliff() public view returns(uint256) {
326     return _cliff;
327   }
328 
329   /**
330    * @return the start time of the token vesting.
331    */
332   function start() public view returns(uint256) {
333     return _start;
334   }
335 
336   /**
337    * @return the duration of the token vesting.
338    */
339   function duration() public view returns(uint256) {
340     return _duration;
341   }
342 
343   /**
344    * @return true if the vesting is revocable.
345    */
346   function revocable() public view returns(bool) {
347     return _revocable;
348   }
349 
350   /**
351    * @return the amount of the token released.
352    */
353   function released(address token) public view returns(uint256) {
354     return _released[token];
355   }
356 
357   /**
358    * @return true if the token is revoked.
359    */
360   function revoked(address token) public view returns(bool) {
361     return _revoked[token];
362   }
363 
364   /**
365    * @notice Transfers vested tokens to beneficiary.
366    * @param token ERC20 token which is being vested
367    */
368   function release(IERC20 token) public {
369     uint256 unreleased = _releasableAmount(token);
370 
371     require(unreleased > 0);
372 
373     _released[token] = _released[token].add(unreleased);
374 
375     token.safeTransfer(_beneficiary, unreleased);
376 
377     emit TokensReleased(token, unreleased);
378   }
379 
380   /**
381    * @notice Allows the owner to revoke the vesting. Tokens already vested
382    * remain in the contract, the rest are returned to the owner.
383    * @param token ERC20 token which is being vested
384    */
385   function revoke(IERC20 token) public onlyOwner {
386     require(_revocable);
387     require(!_revoked[token]);
388 
389     uint256 balance = token.balanceOf(address(this));
390 
391     uint256 unreleased = _releasableAmount(token);
392     uint256 refund = balance.sub(unreleased);
393 
394     _revoked[token] = true;
395 
396     token.safeTransfer(owner(), refund);
397 
398     emit TokenVestingRevoked(token);
399   }
400 
401   /**
402    * @dev Calculates the amount that has already vested but hasn't been released yet.
403    * @param token ERC20 token which is being vested
404    */
405   function _releasableAmount(IERC20 token) private view returns (uint256) {
406     return _vestedAmount(token).sub(_released[token]);
407   }
408 
409   /**
410    * @dev Calculates the amount that has already vested.
411    * @param token ERC20 token which is being vested
412    */
413   function _vestedAmount(IERC20 token) private view returns (uint256) {
414     uint256 currentBalance = token.balanceOf(this);
415     uint256 totalBalance = currentBalance.add(_released[token]);
416 
417     if (block.timestamp < _cliff) {
418       return 0;
419     } else if (block.timestamp >= _start.add(_duration) || _revoked[token]) {
420       return totalBalance;
421     } else {
422       return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
423     }
424   }
425 }
426 
427 // File: contracts/TokenVestingFactory.sol
428 
429 /**
430  * Factory for TokenVesting contracts.
431  */
432 contract TokenVestingFactory is Ownable {
433     /**
434      * Emitted when a new TokenVested contract is created.
435      */
436     event Created(TokenVesting vesting);
437 
438     /**
439      * Creates a new TokenVesting contract.  Note that only the
440      * contract owner may call this method.
441      *
442      * Based on
443      * https://medium.com/hussy-io/factory-method-pattern-for-token-vesting-smart-contracts-cae2b0361aed
444      *
445      * @param _beneficiary the address that will receive vested tokens.
446      * @param _startTime unix timestamp when contract term starts.
447      * @param _cliffSeconds number of seconds after `_startTime` before
448      * vested tokens can be released.
449      * @param _vestingSeconds number of seconds that it will take for
450      * tokens to vest completely.  Must be greater than `_cliffSeconds`;
451      * see link above for more information.
452      * @param _revocable whether contract owner may revoke the
453      * TokenVesting contract.
454      *
455      * @return TokenVesting contract.  The message sender becomes the
456      * owner of the resulting contract.
457      */
458     function create(
459         address _beneficiary,
460         uint256 _startTime,
461         uint256 _cliffSeconds,
462         uint256 _vestingSeconds,
463         bool _revocable
464     ) onlyOwner public returns (TokenVesting) {
465         TokenVesting vesting = new TokenVesting(
466             _beneficiary,
467             _startTime,
468             _cliffSeconds,
469             _vestingSeconds,
470             _revocable
471         );
472         vesting.transferOwnership(msg.sender);
473         emit Created(vesting);
474         return vesting;
475     }
476 }