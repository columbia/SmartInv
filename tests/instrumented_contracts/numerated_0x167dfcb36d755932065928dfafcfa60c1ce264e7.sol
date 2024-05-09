1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an account access to this role
16    */
17   function add(Role storage role, address account) internal {
18     require(account != address(0));
19     require(!has(role, account));
20 
21     role.bearer[account] = true;
22   }
23 
24   /**
25    * @dev remove an account's access to this role
26    */
27   function remove(Role storage role, address account) internal {
28     require(account != address(0));
29     require(has(role, account));
30 
31     role.bearer[account] = false;
32   }
33 
34   /**
35    * @dev check if an account has this role
36    * @return bool
37    */
38   function has(Role storage role, address account)
39     internal
40     view
41     returns (bool)
42   {
43     require(account != address(0));
44     return role.bearer[account];
45   }
46 }
47 
48 // File: node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
49 
50 contract PauserRole {
51   using Roles for Roles.Role;
52 
53   event PauserAdded(address indexed account);
54   event PauserRemoved(address indexed account);
55 
56   Roles.Role private pausers;
57 
58   constructor() internal {
59     _addPauser(msg.sender);
60   }
61 
62   modifier onlyPauser() {
63     require(isPauser(msg.sender));
64     _;
65   }
66 
67   function isPauser(address account) public view returns (bool) {
68     return pausers.has(account);
69   }
70 
71   function addPauser(address account) public onlyPauser {
72     _addPauser(account);
73   }
74 
75   function renouncePauser() public {
76     _removePauser(msg.sender);
77   }
78 
79   function _addPauser(address account) internal {
80     pausers.add(account);
81     emit PauserAdded(account);
82   }
83 
84   function _removePauser(address account) internal {
85     pausers.remove(account);
86     emit PauserRemoved(account);
87   }
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is PauserRole {
97   event Paused(address account);
98   event Unpaused(address account);
99 
100   bool private _paused;
101 
102   constructor() internal {
103     _paused = false;
104   }
105 
106   /**
107    * @return true if the contract is paused, false otherwise.
108    */
109   function paused() public view returns(bool) {
110     return _paused;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!_paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(_paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyPauser whenNotPaused {
133     _paused = true;
134     emit Paused(msg.sender);
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyPauser whenPaused {
141     _paused = false;
142     emit Unpaused(msg.sender);
143   }
144 }
145 
146 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address private _owner;
155 
156   event OwnershipTransferred(
157     address indexed previousOwner,
158     address indexed newOwner
159   );
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   constructor() internal {
166     _owner = msg.sender;
167     emit OwnershipTransferred(address(0), _owner);
168   }
169 
170   /**
171    * @return the address of the owner.
172    */
173   function owner() public view returns(address) {
174     return _owner;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(isOwner());
182     _;
183   }
184 
185   /**
186    * @return true if `msg.sender` is the owner of the contract.
187    */
188   function isOwner() public view returns(bool) {
189     return msg.sender == _owner;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipTransferred(_owner, address(0));
200     _owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     _transferOwnership(newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address newOwner) internal {
216     require(newOwner != address(0));
217     emit OwnershipTransferred(_owner, newOwner);
218     _owner = newOwner;
219   }
220 }
221 
222 // File: contracts/IGrowHops.sol
223 
224 interface IGrowHops {
225 
226   function addPlanBase(uint256 minimumAmount, uint256 lockTime, uint32 lessToHops) external;
227 
228   function togglePlanBase(bytes32 planBaseId, bool isOpen) external;
229 
230   function growHops(bytes32 planBaseId, uint256 lessAmount) external;
231 
232   function updateHopsAddress(address _address) external;
233 
234   function updatelessAddress(address _address) external;
235 
236   function withdraw(bytes32 planId) external;
237 
238   function checkPlanBase(bytes32 planBaseId)
239     external view returns (uint256, uint256, uint32, bool);
240   
241   function checkPlanBaseIds() external view returns(bytes32[]);
242 
243   function checkPlanIdsByPlanBase(bytes32 planBaseId) external view returns(bytes32[]);
244 
245   function checkPlanIdsByUser(address user) external view returns(bytes32[]);
246 
247   function checkPlan(bytes32 planId)
248     external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool);
249 
250   /* Events */
251 
252   event PlanBaseEvt (
253     bytes32 planBaseId,
254     uint256 minimumAmount,
255     uint256 lockTime,
256     uint32 lessToHops,
257     bool isOpen
258   );
259 
260   event TogglePlanBaseEvt (
261     bytes32 planBaseId,
262     bool isOpen
263   );
264 
265   event PlanEvt (
266     bytes32 planId,
267     bytes32 planBaseId,
268     address plantuser,
269     uint256 lessAmount,
270     uint256 hopsAmount,
271     uint256 lockAt,
272     uint256 releaseAt,
273     bool isWithdrawn
274   );
275 
276   event WithdrawPlanEvt (
277     bytes32 planId,
278     address plantuser,
279     uint256 lessAmount,
280     bool isWithdrawn,
281     uint256 withdrawAt
282   );
283 
284 }
285 
286 // File: contracts/SafeMath.sol
287 
288 /**
289  * @title SafeMath
290  */
291 library SafeMath {
292   /**
293   * @dev Integer division of two numbers, truncating the quotient.
294   */
295   function div(uint256 a, uint256 b) internal pure returns (uint256) {
296     // assert(b > 0); // Solidity automatically throws when dividing by 0
297     // uint256 c = a / b;
298     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299     return a / b;
300   }
301 
302   /**
303   * @dev Multiplies two numbers, throws on overflow.
304   */
305   function mul(uint256 a, uint256 b) 
306       internal 
307       pure 
308       returns (uint256 c) 
309   {
310     if (a == 0) {
311       return 0;
312     }
313     c = a * b;
314     require(c / a == b, "SafeMath mul failed");
315     return c;
316   }
317 
318   /**
319   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
320   */
321   function sub(uint256 a, uint256 b)
322       internal
323       pure
324       returns (uint256) 
325   {
326     require(b <= a, "SafeMath sub failed");
327     return a - b;
328   }
329 
330   /**
331   * @dev Adds two numbers, throws on overflow.
332   */
333   function add(uint256 a, uint256 b)
334       internal
335       pure
336       returns (uint256 c) 
337   {
338     c = a + b;
339     require(c >= a, "SafeMath add failed");
340     return c;
341   }
342   
343   /**
344     * @dev gives square root of given x.
345     */
346   function sqrt(uint256 x)
347       internal
348       pure
349       returns (uint256 y) 
350   {
351     uint256 z = ((add(x,1)) / 2);
352     y = x;
353     while (z < y) 
354     {
355       y = z;
356       z = ((add((x / z),z)) / 2);
357     }
358   }
359   
360   /**
361     * @dev gives square. batchplies x by x
362     */
363   function sq(uint256 x)
364       internal
365       pure
366       returns (uint256)
367   {
368     return (mul(x,x));
369   }
370   
371   /**
372     * @dev x to the power of y 
373     */
374   function pwr(uint256 x, uint256 y)
375       internal 
376       pure 
377       returns (uint256)
378   {
379     if (x==0)
380         return (0);
381     else if (y==0)
382         return (1);
383     else 
384     {
385       uint256 z = x;
386       for (uint256 i=1; i < y; i++)
387         z = mul(z,x);
388       return (z);
389     }
390   }
391 }
392 
393 // File: contracts/GrowHops.sol
394 
395 interface IERC20 {
396   function transfer(address to, uint256 value) external returns (bool);
397   function approve(address spender, uint256 value) external returns (bool);
398   function allowance(address tokenOwner, address spender) external view returns (uint);
399   function transferFrom(address from, address to, uint256 value) external returns (bool);
400   function balanceOf(address who) external view returns (uint256);
401   function mint(address to, uint256 value) external returns (bool);
402 }
403 
404 contract GrowHops is IGrowHops, Ownable, Pausable {
405 
406   using SafeMath for *;
407 
408   address public hopsAddress;
409   address public lessAddress;
410 
411   struct PlanBase {
412     uint256 minimumAmount;
413     uint256 lockTime;
414     uint32 lessToHops;
415     bool isOpen;
416   }
417 
418   struct Plan {
419     bytes32 planBaseId;
420     address plantuser;
421     uint256 lessAmount;
422     uint256 hopsAmount;
423     uint256 lockAt;
424     uint256 releaseAt;
425     bool isWithdrawn;
426   }
427   bytes32[] public planBaseIds;
428 
429   mapping (bytes32 => bytes32[]) planIdsByPlanBase;
430   mapping (bytes32 => PlanBase) planBaseIdToPlanBase;
431   
432   mapping (bytes32 => Plan) planIdToPlan;
433   mapping (address => bytes32[]) userToPlanIds;
434 
435   constructor (address _hopsAddress, address _lessAddress) public {
436     hopsAddress = _hopsAddress;
437     lessAddress = _lessAddress;
438   }
439 
440   function addPlanBase(uint256 minimumAmount, uint256 lockTime, uint32 lessToHops)
441     onlyOwner external {
442     bytes32 planBaseId = keccak256(
443       abi.encodePacked(block.timestamp, minimumAmount, lockTime, lessToHops)
444     );
445 
446     PlanBase memory planBase = PlanBase(
447       minimumAmount,
448       lockTime,
449       lessToHops,
450       true
451     );
452 
453     planBaseIdToPlanBase[planBaseId] = planBase;
454     planBaseIds.push(planBaseId);
455     emit PlanBaseEvt(planBaseId, minimumAmount, lockTime, lessToHops, true);
456   }
457 
458   function togglePlanBase(bytes32 planBaseId, bool isOpen) onlyOwner external {
459 
460     planBaseIdToPlanBase[planBaseId].isOpen = isOpen;
461     emit TogglePlanBaseEvt(planBaseId, isOpen);
462   }
463   
464   function growHops(bytes32 planBaseId, uint256 lessAmount) whenNotPaused external {
465     address sender = msg.sender;
466     require(IERC20(lessAddress).allowance(sender, address(this)) >= lessAmount);
467 
468     PlanBase storage planBase = planBaseIdToPlanBase[planBaseId];
469     require(planBase.isOpen);
470     require(lessAmount >= planBase.minimumAmount);
471     bytes32 planId = keccak256(
472       abi.encodePacked(block.timestamp, sender, planBaseId, lessAmount)
473     );
474     uint256 hopsAmount = lessAmount.mul(planBase.lessToHops);
475 
476     Plan memory plan = Plan(
477       planBaseId,
478       sender,
479       lessAmount,
480       hopsAmount,
481       block.timestamp,
482       block.timestamp.add(planBase.lockTime),
483       false
484     );
485     
486     require(IERC20(lessAddress).transferFrom(sender, address(this), lessAmount));
487     require(IERC20(hopsAddress).mint(sender, hopsAmount));
488 
489     planIdToPlan[planId] = plan;
490     userToPlanIds[sender].push(planId);
491     planIdsByPlanBase[planBaseId].push(planId);
492     emit PlanEvt(planId, planBaseId, sender, lessAmount, hopsAmount, block.timestamp, block.timestamp.add(planBase.lockTime), false);
493   }
494 
495   function updateHopsAddress(address _address) external onlyOwner {
496     hopsAddress = _address;
497   }
498 
499   function updatelessAddress(address _address) external onlyOwner {
500     lessAddress = _address;
501   }
502 
503   function withdraw(bytes32 planId) whenNotPaused external {
504     address sender = msg.sender;
505     Plan storage plan = planIdToPlan[planId];
506     require(!plan.isWithdrawn);
507     require(plan.plantuser == sender);
508     require(block.timestamp >= plan.releaseAt);
509     require(IERC20(lessAddress).transfer(sender, plan.lessAmount));
510 
511     planIdToPlan[planId].isWithdrawn = true;
512     emit WithdrawPlanEvt(planId, sender, plan.lessAmount, true, block.timestamp);
513   }
514 
515   function checkPlanBase(bytes32 planBaseId)
516     external view returns (uint256, uint256, uint32, bool){
517     PlanBase storage planBase = planBaseIdToPlanBase[planBaseId];
518     return (
519       planBase.minimumAmount,
520       planBase.lockTime,
521       planBase.lessToHops,
522       planBase.isOpen
523     );
524   }
525 
526   function checkPlanBaseIds() external view returns(bytes32[]) {
527     return planBaseIds;
528   }
529 
530   function checkPlanIdsByPlanBase(bytes32 planBaseId) external view returns(bytes32[]) {
531     return planIdsByPlanBase[planBaseId];
532   }
533 
534   function checkPlanIdsByUser(address user) external view returns(bytes32[]) {
535     return userToPlanIds[user];
536   }
537 
538   function checkPlan(bytes32 planId)
539     external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool) {
540     Plan storage plan = planIdToPlan[planId];
541     return (
542       plan.planBaseId,
543       plan.plantuser,
544       plan.lessAmount,
545       plan.hopsAmount,
546       plan.lockAt,
547       plan.releaseAt,
548       plan.isWithdrawn
549     );
550   }
551 }