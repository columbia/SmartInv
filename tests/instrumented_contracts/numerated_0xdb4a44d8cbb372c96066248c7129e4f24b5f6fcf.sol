1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114   using SafeMath for uint256;
115 
116   function safeTransfer(
117     IERC20 token,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(
127     IERC20 token,
128     address from,
129     address to,
130     uint256 value
131   )
132     internal
133   {
134     require(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(
138     IERC20 token,
139     address spender,
140     uint256 value
141   )
142     internal
143   {
144     // safeApprove should only be called when setting an initial allowance, 
145     // or when resetting it to zero. To increase and decrease it, use 
146     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148     require(token.approve(spender, value));
149   }
150 
151   function safeIncreaseAllowance(
152     IERC20 token,
153     address spender,
154     uint256 value
155   )
156     internal
157   {
158     uint256 newAllowance = token.allowance(address(this), spender).add(value);
159     require(token.approve(spender, newAllowance));
160   }
161 
162   function safeDecreaseAllowance(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170     require(token.approve(spender, newAllowance));
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address private _owner;
183 
184   event OwnershipTransferred(
185     address indexed previousOwner,
186     address indexed newOwner
187   );
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   constructor() internal {
194     _owner = msg.sender;
195     emit OwnershipTransferred(address(0), _owner);
196   }
197 
198   /**
199    * @return the address of the owner.
200    */
201   function owner() public view returns(address) {
202     return _owner;
203   }
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(isOwner());
210     _;
211   }
212 
213   /**
214    * @return true if `msg.sender` is the owner of the contract.
215    */
216   function isOwner() public view returns(bool) {
217     return msg.sender == _owner;
218   }
219 
220   /**
221    * @dev Allows the current owner to relinquish control of the contract.
222    * @notice Renouncing to ownership will leave the contract without an owner.
223    * It will not be possible to call the functions with the `onlyOwner`
224    * modifier anymore.
225    */
226   function renounceOwnership() public onlyOwner {
227     emit OwnershipTransferred(_owner, address(0));
228     _owner = address(0);
229   }
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     _transferOwnership(newOwner);
237   }
238 
239   /**
240    * @dev Transfers control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function _transferOwnership(address newOwner) internal {
244     require(newOwner != address(0));
245     emit OwnershipTransferred(_owner, newOwner);
246     _owner = newOwner;
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/access/Roles.sol
251 
252 /**
253  * @title Roles
254  * @dev Library for managing addresses assigned to a Role.
255  */
256 library Roles {
257   struct Role {
258     mapping (address => bool) bearer;
259   }
260 
261   /**
262    * @dev give an account access to this role
263    */
264   function add(Role storage role, address account) internal {
265     require(account != address(0));
266     require(!has(role, account));
267 
268     role.bearer[account] = true;
269   }
270 
271   /**
272    * @dev remove an account's access to this role
273    */
274   function remove(Role storage role, address account) internal {
275     require(account != address(0));
276     require(has(role, account));
277 
278     role.bearer[account] = false;
279   }
280 
281   /**
282    * @dev check if an account has this role
283    * @return bool
284    */
285   function has(Role storage role, address account)
286     internal
287     view
288     returns (bool)
289   {
290     require(account != address(0));
291     return role.bearer[account];
292   }
293 }
294 
295 // File: contracts/access/RBACManager.sol
296 
297 contract RBACManager is Ownable {
298   using Roles for Roles.Role;
299 
300   event ManagerAdded(address indexed account);
301   event ManagerRemoved(address indexed account);
302 
303   Roles.Role private managers;
304 
305   modifier onlyOwnerOrManager() {
306     require(
307       msg.sender == owner() || isManager(msg.sender),
308       "unauthorized"
309     );
310     _;
311   }
312 
313   constructor() public {
314     addManager(msg.sender);
315   }
316 
317   function isManager(address account) public view returns (bool) {
318     return managers.has(account);
319   }
320 
321   function addManager(address account) public onlyOwner {
322     managers.add(account);
323     emit ManagerAdded(account);
324   }
325 
326   function removeManager(address account) public onlyOwner {
327     managers.remove(account);
328     emit ManagerRemoved(account);
329   }
330 }
331 
332 // File: contracts/CharityProject.sol
333 
334 contract CharityProject is RBACManager {
335   using SafeMath for uint256;
336   using SafeERC20 for IERC20;
337 
338   modifier canWithdraw() {
339     require(
340       _canWithdrawBeforeEnd || _closingTime == 0 || block.timestamp > _closingTime, // solium-disable-line security/no-block-members
341       "can't withdraw");
342     _;
343   }
344 
345   uint256 private _feeInMillis;
346   uint256 private _withdrawnTokens;
347   uint256 private _withdrawnFees;
348   uint256 private _maxGoal;
349   uint256 private _openingTime;
350   uint256 private _closingTime;
351   address private _wallet;
352   IERC20 private _token;
353   bool private _canWithdrawBeforeEnd;
354 
355   constructor (
356     uint256 feeInMillis,
357     uint256 maxGoal,
358     uint256 openingTime,
359     uint256 closingTime,
360     address wallet,
361     IERC20 token,
362     bool canWithdrawBeforeEnd,
363     address additionalManager
364   ) public {
365     require(wallet != address(0), "wallet can't be zero");
366     require(token != address(0), "token can't be zero");
367     require(
368       closingTime == 0 || closingTime >= openingTime,
369       "wrong value for closingTime"
370     );
371 
372     _feeInMillis = feeInMillis;
373     _maxGoal = maxGoal;
374     _openingTime = openingTime;
375     _closingTime = closingTime;
376     _wallet = wallet;
377     _token = token;
378     _canWithdrawBeforeEnd = canWithdrawBeforeEnd;
379 
380     if (_wallet != owner()) {
381       addManager(_wallet);
382     }
383 
384     // solium-disable-next-line max-len
385     if (additionalManager != address(0) && additionalManager != owner() && additionalManager != _wallet) {
386       addManager(additionalManager);
387     }
388   }
389 
390   // -----------------------------------------
391   // GETTERS
392   // -----------------------------------------
393 
394   function feeInMillis() public view returns(uint256) {
395     return _feeInMillis;
396   }
397 
398   function withdrawnTokens() public view returns(uint256) {
399     return _withdrawnTokens;
400   }
401 
402   function withdrawnFees() public view returns(uint256) {
403     return _withdrawnFees;
404   }
405 
406   function maxGoal() public view returns(uint256) {
407     return _maxGoal;
408   }
409 
410   function openingTime() public view returns(uint256) {
411     return _openingTime;
412   }
413 
414   function closingTime() public view returns(uint256) {
415     return _closingTime;
416   }
417 
418   function wallet() public view returns(address) {
419     return _wallet;
420   }
421 
422   function token() public view returns(IERC20) {
423     return _token;
424   }
425 
426   function canWithdrawBeforeEnd() public view returns(bool) {
427     return _canWithdrawBeforeEnd;
428   }
429 
430   // -----------------------------------------
431   // SETTERS
432   // -----------------------------------------
433 
434   function setMaxGoal(uint256 newMaxGoal) public onlyOwner {
435     _maxGoal = newMaxGoal;
436   }
437 
438   function setTimes(
439     uint256 newOpeningTime,
440     uint256 newClosingTime
441   )
442   public
443   onlyOwner
444   {
445     require(
446       newClosingTime == 0 || newClosingTime >= newOpeningTime,
447       "wrong value for closingTime"
448     );
449 
450     _openingTime = newOpeningTime;
451     _closingTime = newClosingTime;
452   }
453 
454   function setCanWithdrawBeforeEnd(
455     bool newCanWithdrawBeforeEnd
456   )
457   public
458   onlyOwner
459   {
460     _canWithdrawBeforeEnd = newCanWithdrawBeforeEnd;
461   }
462 
463   // -----------------------------------------
464   // CHECKS
465   // -----------------------------------------
466 
467   function totalRaised() public view returns (uint256) {
468     uint256 raised = _token.balanceOf(this);
469     return raised.add(_withdrawnTokens).add(_withdrawnFees);
470   }
471 
472   function totalFee() public view returns (uint256) {
473     return totalRaised().mul(_feeInMillis).div(1000);
474   }
475 
476   function hasStarted() public view returns (bool) {
477     // solium-disable-next-line security/no-block-members
478     return _openingTime == 0 ? true : block.timestamp > _openingTime;
479   }
480 
481   function hasClosed() public view returns (bool) {
482     // solium-disable-next-line security/no-block-members
483     return _closingTime == 0 ? false : block.timestamp > _closingTime;
484   }
485 
486   function maxGoalReached() public view returns (bool) {
487     return totalRaised() >= _maxGoal;
488   }
489 
490   // -----------------------------------------
491   // ACTIONS
492   // -----------------------------------------
493 
494   function withdrawTokens(
495     address to,
496     uint256 value
497   )
498   public
499   onlyOwnerOrManager
500   canWithdraw
501   {
502     uint256 expectedTotalWithdraw = _withdrawnTokens.add(value);
503     require(
504       expectedTotalWithdraw <= totalRaised().sub(totalFee()),
505       "can't withdraw more than available token"
506     );
507     _withdrawnTokens = expectedTotalWithdraw;
508     _token.safeTransfer(to, value);
509   }
510 
511   function withdrawFees(
512     address to,
513     uint256 value
514   )
515   public
516   onlyOwner
517   canWithdraw
518   {
519     uint256 expectedTotalWithdraw = _withdrawnFees.add(value);
520     require(
521       expectedTotalWithdraw <= totalFee(),
522       "can't withdraw more than available fee"
523     );
524     _withdrawnFees = expectedTotalWithdraw;
525     _token.safeTransfer(to, value);
526   }
527 
528   function recoverERC20(
529     address tokenAddress,
530     address receiverAddress,
531     uint256 amount
532   )
533   public
534   onlyOwnerOrManager
535   {
536     require(
537       tokenAddress != address(_token),
538       "to transfer project's funds use withdrawTokens"
539     );
540     IERC20(tokenAddress).safeTransfer(receiverAddress, amount);
541   }
542 }