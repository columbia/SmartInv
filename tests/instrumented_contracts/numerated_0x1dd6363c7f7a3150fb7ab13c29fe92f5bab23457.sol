1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
155 
156 /**
157  * @title Roles
158  * @author Francisco Giordano (@frangio)
159  * @dev Library for managing addresses assigned to a Role.
160  * See RBAC.sol for example usage.
161  */
162 library Roles {
163   struct Role {
164     mapping (address => bool) bearer;
165   }
166 
167   /**
168    * @dev give an address access to this role
169    */
170   function add(Role storage _role, address _addr)
171     internal
172   {
173     _role.bearer[_addr] = true;
174   }
175 
176   /**
177    * @dev remove an address' access to this role
178    */
179   function remove(Role storage _role, address _addr)
180     internal
181   {
182     _role.bearer[_addr] = false;
183   }
184 
185   /**
186    * @dev check if an address has this role
187    * // reverts
188    */
189   function check(Role storage _role, address _addr)
190     internal
191     view
192   {
193     require(has(_role, _addr));
194   }
195 
196   /**
197    * @dev check if an address has this role
198    * @return bool
199    */
200   function has(Role storage _role, address _addr)
201     internal
202     view
203     returns (bool)
204   {
205     return _role.bearer[_addr];
206   }
207 }
208 
209 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
210 
211 /**
212  * @title RBAC (Role-Based Access Control)
213  * @author Matt Condon (@Shrugs)
214  * @dev Stores and provides setters and getters for roles and addresses.
215  * Supports unlimited numbers of roles and addresses.
216  * See //contracts/mocks/RBACMock.sol for an example of usage.
217  * This RBAC method uses strings to key roles. It may be beneficial
218  * for you to write your own implementation of this interface using Enums or similar.
219  */
220 contract RBAC {
221   using Roles for Roles.Role;
222 
223   mapping (string => Roles.Role) private roles;
224 
225   event RoleAdded(address indexed operator, string role);
226   event RoleRemoved(address indexed operator, string role);
227 
228   /**
229    * @dev reverts if addr does not have role
230    * @param _operator address
231    * @param _role the name of the role
232    * // reverts
233    */
234   function checkRole(address _operator, string _role)
235     public
236     view
237   {
238     roles[_role].check(_operator);
239   }
240 
241   /**
242    * @dev determine if addr has role
243    * @param _operator address
244    * @param _role the name of the role
245    * @return bool
246    */
247   function hasRole(address _operator, string _role)
248     public
249     view
250     returns (bool)
251   {
252     return roles[_role].has(_operator);
253   }
254 
255   /**
256    * @dev add a role to an address
257    * @param _operator address
258    * @param _role the name of the role
259    */
260   function addRole(address _operator, string _role)
261     internal
262   {
263     roles[_role].add(_operator);
264     emit RoleAdded(_operator, _role);
265   }
266 
267   /**
268    * @dev remove a role from an address
269    * @param _operator address
270    * @param _role the name of the role
271    */
272   function removeRole(address _operator, string _role)
273     internal
274   {
275     roles[_role].remove(_operator);
276     emit RoleRemoved(_operator, _role);
277   }
278 
279   /**
280    * @dev modifier to scope access to a single role (uses msg.sender as addr)
281    * @param _role the name of the role
282    * // reverts
283    */
284   modifier onlyRole(string _role)
285   {
286     checkRole(msg.sender, _role);
287     _;
288   }
289 
290   /**
291    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
292    * @param _roles the names of the roles to scope access to
293    * // reverts
294    *
295    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
296    *  see: https://github.com/ethereum/solidity/issues/2467
297    */
298   // modifier onlyRoles(string[] _roles) {
299   //     bool hasAnyRole = false;
300   //     for (uint8 i = 0; i < _roles.length; i++) {
301   //         if (hasRole(msg.sender, _roles[i])) {
302   //             hasAnyRole = true;
303   //             break;
304   //         }
305   //     }
306 
307   //     require(hasAnyRole);
308 
309   //     _;
310   // }
311 }
312 
313 // File: contracts/access/RBACManager.sol
314 
315 contract RBACManager is RBAC, Ownable {
316   string constant ROLE_MANAGER = "manager";
317 
318   modifier onlyOwnerOrManager() {
319     require(
320       msg.sender == owner || hasRole(msg.sender, ROLE_MANAGER),
321       "unauthorized"
322     );
323     _;
324   }
325 
326   constructor() public {
327     addRole(msg.sender, ROLE_MANAGER);
328   }
329 
330   function addManager(address _manager) public onlyOwner {
331     addRole(_manager, ROLE_MANAGER);
332   }
333 
334   function removeManager(address _manager) public onlyOwner {
335     removeRole(_manager, ROLE_MANAGER);
336   }
337 }
338 
339 // File: contracts/CharityProject.sol
340 
341 contract CharityProject is RBACManager {
342   using SafeMath for uint256;
343 
344   modifier canWithdraw() {
345     require(
346       canWithdrawBeforeEnd || closingTime == 0 || block.timestamp > closingTime, // solium-disable-line security/no-block-members
347       "can't withdraw");
348     _;
349   }
350 
351   uint256 public withdrawn;
352 
353   uint256 public maxGoal;
354   uint256 public openingTime;
355   uint256 public closingTime;
356   address public wallet;
357   ERC20 public token;
358   bool public canWithdrawBeforeEnd;
359 
360   constructor (
361     uint256 _maxGoal,
362     uint256 _openingTime,
363     uint256 _closingTime,
364     address _wallet,
365     ERC20 _token,
366     bool _canWithdrawBeforeEnd,
367     address _additionalManager
368   ) public {
369     require(_wallet != address(0), "_wallet can't be zero");
370     require(_token != address(0), "_token can't be zero");
371     require(
372       _closingTime == 0 || _closingTime >= _openingTime,
373       "wrong value for _closingTime"
374     );
375 
376     maxGoal = _maxGoal;
377     openingTime = _openingTime;
378     closingTime = _closingTime;
379     wallet = _wallet;
380     token = _token;
381     canWithdrawBeforeEnd = _canWithdrawBeforeEnd;
382 
383     if (wallet != owner) {
384       addManager(wallet);
385     }
386 
387     // solium-disable-next-line max-len
388     if (_additionalManager != address(0) && _additionalManager != owner && _additionalManager != wallet) {
389       addManager(_additionalManager);
390     }
391   }
392 
393   function withdrawTokens(
394     address _to,
395     uint256 _value
396   )
397   public
398   onlyOwnerOrManager
399   canWithdraw
400   {
401     token.transfer(_to, _value);
402     withdrawn = withdrawn.add(_value);
403   }
404 
405   function totalRaised() public view returns (uint256) {
406     uint256 raised = token.balanceOf(this);
407     return raised.add(withdrawn);
408   }
409 
410   function hasStarted() public view returns (bool) {
411     // solium-disable-next-line security/no-block-members
412     return openingTime == 0 ? true : block.timestamp > openingTime;
413   }
414 
415   function hasClosed() public view returns (bool) {
416     // solium-disable-next-line security/no-block-members
417     return closingTime == 0 ? false : block.timestamp > closingTime;
418   }
419 
420   function maxGoalReached() public view returns (bool) {
421     return totalRaised() >= maxGoal;
422   }
423 
424   function setMaxGoal(uint256 _newMaxGoal) public onlyOwner {
425     maxGoal = _newMaxGoal;
426   }
427 
428   function setTimes(
429     uint256 _openingTime,
430     uint256 _closingTime
431   )
432   public
433   onlyOwner
434   {
435     require(
436       _closingTime == 0 || _closingTime >= _openingTime,
437       "wrong value for _closingTime"
438     );
439 
440     openingTime = _openingTime;
441     closingTime = _closingTime;
442   }
443 
444   function setCanWithdrawBeforeEnd(
445     bool _canWithdrawBeforeEnd
446   )
447   public
448   onlyOwner
449   {
450     canWithdrawBeforeEnd = _canWithdrawBeforeEnd;
451   }
452 }