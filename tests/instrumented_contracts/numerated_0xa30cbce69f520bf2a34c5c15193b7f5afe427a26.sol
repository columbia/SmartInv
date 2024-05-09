1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/openzeppelin-solidity/contracts/access/Roles.sol
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
19     role.bearer[account] = true;
20   }
21 
22   /**
23    * @dev remove an account's access to this role
24    */
25   function remove(Role storage role, address account) internal {
26     require(account != address(0));
27     role.bearer[account] = false;
28   }
29 
30   /**
31    * @dev check if an account has this role
32    * @return bool
33    */
34   function has(Role storage role, address account)
35     internal
36     view
37     returns (bool)
38   {
39     require(account != address(0));
40     return role.bearer[account];
41   }
42 }
43 
44 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 contract PauserRole {
47   using Roles for Roles.Role;
48 
49   event PauserAdded(address indexed account);
50   event PauserRemoved(address indexed account);
51 
52   Roles.Role private pausers;
53 
54   constructor() public {
55     pausers.add(msg.sender);
56   }
57 
58   modifier onlyPauser() {
59     require(isPauser(msg.sender));
60     _;
61   }
62 
63   function isPauser(address account) public view returns (bool) {
64     return pausers.has(account);
65   }
66 
67   function addPauser(address account) public onlyPauser {
68     pausers.add(account);
69     emit PauserAdded(account);
70   }
71 
72   function renouncePauser() public {
73     pausers.remove(msg.sender);
74   }
75 
76   function _removePauser(address account) internal {
77     pausers.remove(account);
78     emit PauserRemoved(account);
79   }
80 }
81 
82 // File: contracts/lib/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
83 
84 /**
85  * @title Pausable
86  * @dev Base contract which allows children to implement an emergency stop mechanism.
87  */
88 contract Pausable is PauserRole {
89   event Paused();
90   event Unpaused();
91 
92   bool private _paused = false;
93 
94 
95   /**
96    * @return true if the contract is paused, false otherwise.
97    */
98   function paused() public view returns(bool) {
99     return _paused;
100   }
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!_paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(_paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() public onlyPauser whenNotPaused {
122     _paused = true;
123     emit Paused();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() public onlyPauser whenPaused {
130     _paused = false;
131     emit Unpaused();
132   }
133 }
134 
135 // File: contracts/lib/openzeppelin-solidity/contracts/math/SafeMath.sol
136 
137 /**
138  * @title SafeMath
139  * @dev Math operations with safety checks that revert on error
140  */
141 library SafeMath {
142 
143   /**
144   * @dev Multiplies two numbers, reverts on overflow.
145   */
146   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148     // benefit is lost if 'b' is also tested.
149     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
150     if (a == 0) {
151       return 0;
152     }
153 
154     uint256 c = a * b;
155     require(c / a == b);
156 
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
162   */
163   function div(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b > 0); // Solidity only automatically asserts when dividing by 0
165     uint256 c = a / b;
166     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168     return c;
169   }
170 
171   /**
172   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b <= a);
176     uint256 c = a - b;
177 
178     return c;
179   }
180 
181   /**
182   * @dev Adds two numbers, reverts on overflow.
183   */
184   function add(uint256 a, uint256 b) internal pure returns (uint256) {
185     uint256 c = a + b;
186     require(c >= a);
187 
188     return c;
189   }
190 
191   /**
192   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
193   * reverts when dividing by zero.
194   */
195   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
196     require(b != 0);
197     return a % b;
198   }
199 }
200 
201 // File: contracts/lib/openzeppelin-solidity/contracts/ownership/Ownable.sol
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209   address private _owner;
210 
211 
212   event OwnershipRenounced(address indexed previousOwner);
213   event OwnershipTransferred(
214     address indexed previousOwner,
215     address indexed newOwner
216   );
217 
218 
219   /**
220    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
221    * account.
222    */
223   constructor() public {
224     _owner = msg.sender;
225   }
226 
227   /**
228    * @return the address of the owner.
229    */
230   function owner() public view returns(address) {
231     return _owner;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(isOwner());
239     _;
240   }
241 
242   /**
243    * @return true if `msg.sender` is the owner of the contract.
244    */
245   function isOwner() public view returns(bool) {
246     return msg.sender == _owner;
247   }
248 
249   /**
250    * @dev Allows the current owner to relinquish control of the contract.
251    * @notice Renouncing to ownership will leave the contract without an owner.
252    * It will not be possible to call the functions with the `onlyOwner`
253    * modifier anymore.
254    */
255   function renounceOwnership() public onlyOwner {
256     emit OwnershipRenounced(_owner);
257     _owner = address(0);
258   }
259 
260   /**
261    * @dev Allows the current owner to transfer control of the contract to a newOwner.
262    * @param newOwner The address to transfer ownership to.
263    */
264   function transferOwnership(address newOwner) public onlyOwner {
265     _transferOwnership(newOwner);
266   }
267 
268   /**
269    * @dev Transfers control of the contract to a newOwner.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function _transferOwnership(address newOwner) internal {
273     require(newOwner != address(0));
274     emit OwnershipTransferred(_owner, newOwner);
275     _owner = newOwner;
276   }
277 }
278 
279 // File: contracts/access/roles/OperatorRole.sol
280 
281 contract OperatorRole is Ownable {
282     using Roles for Roles.Role;
283 
284     event OperatorAdded(address indexed account);
285     event OperatorRemoved(address indexed account);
286 
287     Roles.Role private operators;
288 
289     constructor() public {
290         operators.add(msg.sender);
291     }
292 
293     modifier onlyOperator() {
294         require(isOperator(msg.sender));
295         _;
296     }
297     
298     function isOperator(address account) public view returns (bool) {
299         return operators.has(account);
300     }
301 
302     function addOperator(address account) public onlyOwner() {
303         operators.add(account);
304         emit OperatorAdded(account);
305     }
306 
307     function removeOperator(address account) public onlyOwner() {
308         operators.remove(account);
309         emit OperatorRemoved(account);
310     }
311 
312 }
313 
314 // File: contracts/access/roles/ReferrerRole.sol
315 
316 contract ReferrerRole is OperatorRole {
317     using Roles for Roles.Role;
318 
319     event ReferrerAdded(address indexed account);
320     event ReferrerRemoved(address indexed account);
321 
322     Roles.Role private referrers;
323 
324     uint32 internal index;
325     mapping(uint32 => address) internal indexToAddress;
326     mapping(address => uint32) internal addressToIndex;
327 
328     modifier onlyReferrer() {
329         require(isReferrer(msg.sender));
330         _;
331     }
332 
333     function getNumberOfAddresses() public view onlyOperator() returns (uint32) {
334         return index;
335     }
336 
337     function addressOfIndex(uint32 _index) onlyOperator() public view returns (address) {
338         return indexToAddress[_index];
339     }
340     
341     function isReferrer(address _account) public view returns (bool) {
342         return referrers.has(_account);
343     }
344 
345     function addReferrer(address _account) public onlyOperator() {
346         referrers.add(_account);
347         indexToAddress[index] = _account;
348         addressToIndex[_account] = index;
349         index++;
350         emit ReferrerAdded(_account);
351     }
352 
353     function removeReferrer(address _account) public onlyOperator() {
354         referrers.remove(_account);
355         indexToAddress[addressToIndex[_account]] = address(0x0);
356         emit ReferrerRemoved(_account);
357     }
358 
359 }
360 
361 // File: contracts/shop/DailyAction.sol
362 
363 contract DailyAction is Ownable, Pausable {
364     using SafeMath for uint256;
365 
366     mapping(address => uint256) public latestActionTime;
367     uint256 public term;
368 
369     event Action(
370         address indexed user,
371         address indexed referrer,
372         uint256 at
373     );
374 
375     event UpdateTerm(
376         uint256 term
377     );
378     
379     constructor() public {
380         term = 86400;
381     }
382 
383     function withdrawEther() external onlyOwner() {
384         owner().transfer(address(this).balance);
385     }
386 
387     function updateTerm(uint256 num) external onlyOwner() {
388         term = num;
389 
390         emit UpdateTerm(
391             term
392         );
393     }
394 
395     function requestDailyActionReward(address referrer) external whenNotPaused() {
396         require(!isInTerm(msg.sender), "this sender got daily reward within term");
397 
398         emit Action(
399             msg.sender,
400             referrer,
401             block.timestamp
402         );
403 
404         latestActionTime[msg.sender] = block.timestamp;
405     }
406 
407     function isInTerm(address sender) public view returns (bool) {
408         if (latestActionTime[sender] == 0) {
409             return false;
410         } else if (block.timestamp >= latestActionTime[sender].add(term)) {
411             return false;
412         }
413         return true;
414     }
415 }
416 
417 // File: contracts/shop/GumGateway.sol
418 
419 contract GumGateway is ReferrerRole, Pausable, DailyAction {
420     using SafeMath for uint256;
421 
422     uint256 internal ethBackRate;
423     uint256 public minimumAmount;
424 
425     event Sold(
426         address indexed user,
427         address indexed referrer,
428         uint256 value,
429         uint256 at
430     );
431     
432     constructor() public {
433         minimumAmount = 10000000000000000;
434     }
435     
436     function updateEthBackRate(uint256 _newEthBackRate) external onlyOwner() {
437         ethBackRate = _newEthBackRate;
438     }
439 
440     function updateMinimumAmount(uint256 _newMinimumAmount) external onlyOwner() {
441         minimumAmount = _newMinimumAmount;
442     }
443 
444     function getEthBackRate() external onlyOwner() view returns (uint256) {
445         return ethBackRate;
446     }
447 
448     function withdrawEther() external onlyOwner() {
449         owner().transfer(address(this).balance);
450     }
451 
452     function buy(address _referrer) external payable whenNotPaused() {
453         require(msg.value >= minimumAmount, "msg.value should be more than minimum ether amount");
454         
455         address referrer;
456         if (_referrer == msg.sender){
457             referrer = address(0x0);
458         } else {
459             referrer = _referrer;
460         }
461         if ((referrer != address(0x0)) && isReferrer(referrer)) {
462             referrer.transfer(msg.value.mul(ethBackRate).div(100));
463         }
464         emit Sold(
465             msg.sender,
466             referrer,
467             msg.value,
468             block.timestamp
469         );
470     }
471 
472 }