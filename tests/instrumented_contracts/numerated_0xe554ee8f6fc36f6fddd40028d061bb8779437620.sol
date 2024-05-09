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
55 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
56 
57 /**
58  * @title Roles
59  * @author Francisco Giordano (@frangio)
60  * @dev Library for managing addresses assigned to a Role.
61  * See RBAC.sol for example usage.
62  */
63 library Roles {
64   struct Role {
65     mapping (address => bool) bearer;
66   }
67 
68   /**
69    * @dev give an address access to this role
70    */
71   function add(Role storage _role, address _addr)
72     internal
73   {
74     _role.bearer[_addr] = true;
75   }
76 
77   /**
78    * @dev remove an address' access to this role
79    */
80   function remove(Role storage _role, address _addr)
81     internal
82   {
83     _role.bearer[_addr] = false;
84   }
85 
86   /**
87    * @dev check if an address has this role
88    * // reverts
89    */
90   function check(Role storage _role, address _addr)
91     internal
92     view
93   {
94     require(has(_role, _addr));
95   }
96 
97   /**
98    * @dev check if an address has this role
99    * @return bool
100    */
101   function has(Role storage _role, address _addr)
102     internal
103     view
104     returns (bool)
105   {
106     return _role.bearer[_addr];
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
111 
112 /**
113  * @title RBAC (Role-Based Access Control)
114  * @author Matt Condon (@Shrugs)
115  * @dev Stores and provides setters and getters for roles and addresses.
116  * Supports unlimited numbers of roles and addresses.
117  * See //contracts/mocks/RBACMock.sol for an example of usage.
118  * This RBAC method uses strings to key roles. It may be beneficial
119  * for you to write your own implementation of this interface using Enums or similar.
120  */
121 contract RBAC {
122   using Roles for Roles.Role;
123 
124   mapping (string => Roles.Role) private roles;
125 
126   event RoleAdded(address indexed operator, string role);
127   event RoleRemoved(address indexed operator, string role);
128 
129   /**
130    * @dev reverts if addr does not have role
131    * @param _operator address
132    * @param _role the name of the role
133    * // reverts
134    */
135   function checkRole(address _operator, string _role)
136     public
137     view
138   {
139     roles[_role].check(_operator);
140   }
141 
142   /**
143    * @dev determine if addr has role
144    * @param _operator address
145    * @param _role the name of the role
146    * @return bool
147    */
148   function hasRole(address _operator, string _role)
149     public
150     view
151     returns (bool)
152   {
153     return roles[_role].has(_operator);
154   }
155 
156   /**
157    * @dev add a role to an address
158    * @param _operator address
159    * @param _role the name of the role
160    */
161   function addRole(address _operator, string _role)
162     internal
163   {
164     roles[_role].add(_operator);
165     emit RoleAdded(_operator, _role);
166   }
167 
168   /**
169    * @dev remove a role from an address
170    * @param _operator address
171    * @param _role the name of the role
172    */
173   function removeRole(address _operator, string _role)
174     internal
175   {
176     roles[_role].remove(_operator);
177     emit RoleRemoved(_operator, _role);
178   }
179 
180   /**
181    * @dev modifier to scope access to a single role (uses msg.sender as addr)
182    * @param _role the name of the role
183    * // reverts
184    */
185   modifier onlyRole(string _role)
186   {
187     checkRole(msg.sender, _role);
188     _;
189   }
190 
191   /**
192    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
193    * @param _roles the names of the roles to scope access to
194    * // reverts
195    *
196    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
197    *  see: https://github.com/ethereum/solidity/issues/2467
198    */
199   // modifier onlyRoles(string[] _roles) {
200   //     bool hasAnyRole = false;
201   //     for (uint8 i = 0; i < _roles.length; i++) {
202   //         if (hasRole(msg.sender, _roles[i])) {
203   //             hasAnyRole = true;
204   //             break;
205   //         }
206   //     }
207 
208   //     require(hasAnyRole);
209 
210   //     _;
211   // }
212 }
213 
214 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipRenounced(address indexed previousOwner);
226   event OwnershipTransferred(
227     address indexed previousOwner,
228     address indexed newOwner
229   );
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   constructor() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to relinquish control of the contract.
250    * @notice Renouncing to ownership will leave the contract without an owner.
251    * It will not be possible to call the functions with the `onlyOwner`
252    * modifier anymore.
253    */
254   function renounceOwnership() public onlyOwner {
255     emit OwnershipRenounced(owner);
256     owner = address(0);
257   }
258 
259   /**
260    * @dev Allows the current owner to transfer control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function transferOwnership(address _newOwner) public onlyOwner {
264     _transferOwnership(_newOwner);
265   }
266 
267   /**
268    * @dev Transfers control of the contract to a newOwner.
269    * @param _newOwner The address to transfer ownership to.
270    */
271   function _transferOwnership(address _newOwner) internal {
272     require(_newOwner != address(0));
273     emit OwnershipTransferred(owner, _newOwner);
274     owner = _newOwner;
275   }
276 }
277 
278 // File: contracts/crowdsale/utils/Contributions.sol
279 
280 contract Contributions is RBAC, Ownable {
281   using SafeMath for uint256;
282 
283   uint256 private constant TIER_DELETED = 999;
284   string public constant ROLE_MINTER = "minter";
285   string public constant ROLE_OPERATOR = "operator";
286 
287   uint256 public tierLimit;
288 
289   modifier onlyMinter () {
290     checkRole(msg.sender, ROLE_MINTER);
291     _;
292   }
293 
294   modifier onlyOperator () {
295     checkRole(msg.sender, ROLE_OPERATOR);
296     _;
297   }
298 
299   uint256 public totalSoldTokens;
300   mapping(address => uint256) public tokenBalances;
301   mapping(address => uint256) public ethContributions;
302   mapping(address => uint256) private _whitelistTier;
303   address[] public tokenAddresses;
304   address[] public ethAddresses;
305   address[] private whitelistAddresses;
306 
307   constructor(uint256 _tierLimit) public {
308     addRole(owner, ROLE_OPERATOR);
309     tierLimit = _tierLimit;
310   }
311 
312   function addMinter(address minter) external onlyOwner {
313     addRole(minter, ROLE_MINTER);
314   }
315 
316   function removeMinter(address minter) external onlyOwner {
317     removeRole(minter, ROLE_MINTER);
318   }
319 
320   function addOperator(address _operator) external onlyOwner {
321     addRole(_operator, ROLE_OPERATOR);
322   }
323 
324   function removeOperator(address _operator) external onlyOwner {
325     removeRole(_operator, ROLE_OPERATOR);
326   }
327 
328   function addTokenBalance(
329     address _address,
330     uint256 _tokenAmount
331   )
332     external
333     onlyMinter
334   {
335     if (tokenBalances[_address] == 0) {
336       tokenAddresses.push(_address);
337     }
338     tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
339     totalSoldTokens = totalSoldTokens.add(_tokenAmount);
340   }
341 
342   function addEthContribution(
343     address _address,
344     uint256 _weiAmount
345   )
346     external
347     onlyMinter
348   {
349     if (ethContributions[_address] == 0) {
350       ethAddresses.push(_address);
351     }
352     ethContributions[_address] = ethContributions[_address].add(_weiAmount);
353   }
354 
355   function setTierLimit(uint256 _newTierLimit) external onlyOperator {
356     require(_newTierLimit > 0, "Tier must be greater than zero");
357 
358     tierLimit = _newTierLimit;
359   }
360 
361   function addToWhitelist(
362     address _investor,
363     uint256 _tier
364   )
365     external
366     onlyOperator
367   {
368     require(_tier == 1 || _tier == 2, "Only two tier level available");
369     if (_whitelistTier[_investor] == 0) {
370       whitelistAddresses.push(_investor);
371     }
372     _whitelistTier[_investor] = _tier;
373   }
374 
375   function removeFromWhitelist(address _investor) external onlyOperator {
376     _whitelistTier[_investor] = TIER_DELETED;
377   }
378 
379   function whitelistTier(address _investor) external view returns (uint256) {
380     return _whitelistTier[_investor] <= 2 ? _whitelistTier[_investor] : 0;
381   }
382 
383   function getWhitelistedAddresses(
384     uint256 _tier
385   )
386     external
387     view
388     returns (address[])
389   {
390     address[] memory tmp = new address[](whitelistAddresses.length);
391 
392     uint y = 0;
393     if (_tier == 1 || _tier == 2) {
394       uint len = whitelistAddresses.length;
395       for (uint i = 0; i < len; i++) {
396         if (_whitelistTier[whitelistAddresses[i]] == _tier) {
397           tmp[y] = whitelistAddresses[i];
398           y++;
399         }
400       }
401     }
402 
403     address[] memory toReturn = new address[](y);
404 
405     for (uint k = 0; k < y; k++) {
406       toReturn[k] = tmp[k];
407     }
408 
409     return toReturn;
410   }
411 
412   function isAllowedPurchase(
413     address _beneficiary,
414     uint256 _weiAmount
415   )
416     external
417     view
418     returns (bool)
419   {
420     if (_whitelistTier[_beneficiary] == 2) {
421       return true;
422     } else if (_whitelistTier[_beneficiary] == 1 && ethContributions[_beneficiary].add(_weiAmount) <= tierLimit) {
423       return true;
424     }
425 
426     return false;
427   }
428 
429   function getTokenAddressesLength() external view returns (uint) {
430     return tokenAddresses.length;
431   }
432 
433   function getEthAddressesLength() external view returns (uint) {
434     return ethAddresses.length;
435   }
436 }