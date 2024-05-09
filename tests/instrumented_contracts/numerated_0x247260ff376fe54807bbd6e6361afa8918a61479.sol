1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title Roles
117  * @author Francisco Giordano (@frangio)
118  * @dev Library for managing addresses assigned to a Role.
119  * See RBAC.sol for example usage.
120  */
121 library Roles {
122   struct Role {
123     mapping (address => bool) bearer;
124   }
125 
126   /**
127    * @dev give an address access to this role
128    */
129   function add(Role storage _role, address _addr)
130     internal
131   {
132     _role.bearer[_addr] = true;
133   }
134 
135   /**
136    * @dev remove an address' access to this role
137    */
138   function remove(Role storage _role, address _addr)
139     internal
140   {
141     _role.bearer[_addr] = false;
142   }
143 
144   /**
145    * @dev check if an address has this role
146    * // reverts
147    */
148   function check(Role storage _role, address _addr)
149     internal
150     view
151   {
152     require(has(_role, _addr));
153   }
154 
155   /**
156    * @dev check if an address has this role
157    * @return bool
158    */
159   function has(Role storage _role, address _addr)
160     internal
161     view
162     returns (bool)
163   {
164     return _role.bearer[_addr];
165   }
166 }
167 
168 /**
169  * @title RBAC (Role-Based Access Control)
170  * @author Matt Condon (@Shrugs)
171  * @dev Stores and provides setters and getters for roles and addresses.
172  * Supports unlimited numbers of roles and addresses.
173  * See //contracts/mocks/RBACMock.sol for an example of usage.
174  * This RBAC method uses strings to key roles. It may be beneficial
175  * for you to write your own implementation of this interface using Enums or similar.
176  */
177 contract RBAC {
178   using Roles for Roles.Role;
179 
180   mapping (string => Roles.Role) private roles;
181 
182   event RoleAdded(address indexed operator, string role);
183   event RoleRemoved(address indexed operator, string role);
184 
185   /**
186    * @dev reverts if addr does not have role
187    * @param _operator address
188    * @param _role the name of the role
189    * // reverts
190    */
191   function checkRole(address _operator, string _role)
192     public
193     view
194   {
195     roles[_role].check(_operator);
196   }
197 
198   /**
199    * @dev determine if addr has role
200    * @param _operator address
201    * @param _role the name of the role
202    * @return bool
203    */
204   function hasRole(address _operator, string _role)
205     public
206     view
207     returns (bool)
208   {
209     return roles[_role].has(_operator);
210   }
211 
212   /**
213    * @dev add a role to an address
214    * @param _operator address
215    * @param _role the name of the role
216    */
217   function addRole(address _operator, string _role)
218     internal
219   {
220     roles[_role].add(_operator);
221     emit RoleAdded(_operator, _role);
222   }
223 
224   /**
225    * @dev remove a role from an address
226    * @param _operator address
227    * @param _role the name of the role
228    */
229   function removeRole(address _operator, string _role)
230     internal
231   {
232     roles[_role].remove(_operator);
233     emit RoleRemoved(_operator, _role);
234   }
235 
236   /**
237    * @dev modifier to scope access to a single role (uses msg.sender as addr)
238    * @param _role the name of the role
239    * // reverts
240    */
241   modifier onlyRole(string _role)
242   {
243     checkRole(msg.sender, _role);
244     _;
245   }
246 
247   /**
248    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
249    * @param _roles the names of the roles to scope access to
250    * // reverts
251    *
252    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
253    *  see: https://github.com/ethereum/solidity/issues/2467
254    */
255   // modifier onlyRoles(string[] _roles) {
256   //     bool hasAnyRole = false;
257   //     for (uint8 i = 0; i < _roles.length; i++) {
258   //         if (hasRole(msg.sender, _roles[i])) {
259   //             hasAnyRole = true;
260   //             break;
261   //         }
262   //     }
263 
264   //     require(hasAnyRole);
265 
266   //     _;
267   // }
268 }
269 contract RBACOperator is Ownable, RBAC{
270 
271   /**
272    * A constant role name for indicating operator.
273    */
274   string public constant ROLE_OPERATOR = "operator";
275 
276   /**
277    * @dev the modifier to operate
278    */
279   modifier hasOperationPermission() {
280     checkRole(msg.sender, ROLE_OPERATOR);
281     _;
282   }
283 
284   /**
285    * @dev add a operator role to an address
286    * @param _operator address
287    */
288   function addOperater(address _operator) public onlyOwner {
289     addRole(_operator, ROLE_OPERATOR);
290   }
291 
292   /**
293    * @dev remove a operator role from an address
294    * @param _operator address
295    */
296   function removeOperater(address _operator) public onlyOwner {
297     removeRole(_operator, ROLE_OPERATOR);
298   }
299 }
300 
301 
302 contract IncentivePoolContract is Ownable, RBACOperator{
303   using SafeMath for uint256;
304   uint256 public openingTime;
305 
306 
307   /**
308    * @dev Overridden seOpeningTimed, takes pool opening  times.
309    * @param _newOpeningTime opening time
310    */
311   function setOpeningTime(uint32 _newOpeningTime) public hasOperationPermission {
312      require(_newOpeningTime > 0);
313      openingTime = _newOpeningTime;
314   }
315 
316 
317   /*
318    * @dev get the incentive number
319    * @return yearSum The total amount of tokens released in the current year
320    * @return daySum The total number of tokens released on the day
321    * @return currentYear Current year number
322    */
323   function getIncentiveNum() public view returns(uint256 yearSum, uint256 daySum, uint256 currentYear) {
324     require(openingTime > 0 && openingTime < now);
325     (yearSum, daySum, currentYear) = getIncentiveNumByTime(now);
326   }
327 
328 
329 
330   /*
331    * @dev get the incentive number
332    * @param _time The time to get incentives for
333    * @return yearSum The total amount of tokens released in the current year
334    * @return daySum The total number of tokens released on the day
335    * @return currentYear Current year number
336    */
337   function getIncentiveNumByTime(uint256 _time) public view returns(uint256 yearSum, uint256 daySum, uint256 currentYear) {
338     require(openingTime > 0 && _time > openingTime);
339     uint256 timeSpend = _time - openingTime;
340     uint256 tempYear = timeSpend / 31536000;
341     if (tempYear == 0) {
342       yearSum = 2400000000000000000000000000;
343       daySum = 6575342000000000000000000;
344       currentYear = 1;
345     } else if (tempYear == 1) {
346       yearSum = 1080000000000000000000000000;
347       daySum = 2958904000000000000000000;
348       currentYear = 2;
349     } else if (tempYear == 2) {
350       yearSum = 504000000000000000000000000;
351       daySum = 1380821000000000000000000;
352       currentYear = 3;
353     } else {
354       uint256 year = tempYear - 3;
355       uint256 d = 9 ** year;
356       uint256 e = uint256(201600000000000000000000000).mul(d);
357       uint256 f = 10 ** year;
358       uint256 y2 = e.div(f);
359 
360       yearSum = y2;
361       daySum = y2 / 365;
362       currentYear = tempYear+1;
363     }
364   }
365 }