1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Roles
57  * @author Francisco Giordano (@frangio)
58  * @dev Library for managing addresses assigned to a Role.
59  *      See RBAC.sol for example usage.
60  */
61 library Roles {
62   struct Role {
63     mapping (address => bool) bearer;
64   }
65 
66   /**
67    * @dev give an address access to this role
68    */
69   function add(Role storage role, address addr)
70     internal
71   {
72     role.bearer[addr] = true;
73   }
74 
75   /**
76    * @dev remove an address' access to this role
77    */
78   function remove(Role storage role, address addr)
79     internal
80   {
81     role.bearer[addr] = false;
82   }
83 
84   /**
85    * @dev check if an address has this role
86    * // reverts
87    */
88   function check(Role storage role, address addr)
89     view
90     internal
91   {
92     require(has(role, addr));
93   }
94 
95   /**
96    * @dev check if an address has this role
97    * @return bool
98    */
99   function has(Role storage role, address addr)
100     view
101     internal
102     returns (bool)
103   {
104     return role.bearer[addr];
105   }
106 }
107 
108 
109 /**
110  * @title RBAC (Role-Based Access Control)
111  * @author Matt Condon (@Shrugs)
112  * @dev Stores and provides setters and getters for roles and addresses.
113  * @dev Supports unlimited numbers of roles and addresses.
114  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
115  * This RBAC method uses strings to key roles. It may be beneficial
116  *  for you to write your own implementation of this interface using Enums or similar.
117  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
118  *  to avoid typos.
119  */
120 contract RBAC {
121   using Roles for Roles.Role;
122 
123   mapping (string => Roles.Role) private roles;
124 
125   event RoleAdded(address addr, string roleName);
126   event RoleRemoved(address addr, string roleName);
127 
128   /**
129    * @dev reverts if addr does not have role
130    * @param addr address
131    * @param roleName the name of the role
132    * // reverts
133    */
134   function checkRole(address addr, string roleName)
135     view
136     public
137   {
138     roles[roleName].check(addr);
139   }
140 
141   /**
142    * @dev determine if addr has role
143    * @param addr address
144    * @param roleName the name of the role
145    * @return bool
146    */
147   function hasRole(address addr, string roleName)
148     view
149     public
150     returns (bool)
151   {
152     return roles[roleName].has(addr);
153   }
154 
155   /**
156    * @dev add a role to an address
157    * @param addr address
158    * @param roleName the name of the role
159    */
160   function addRole(address addr, string roleName)
161     internal
162   {
163     roles[roleName].add(addr);
164     emit RoleAdded(addr, roleName);
165   }
166 
167   /**
168    * @dev remove a role from an address
169    * @param addr address
170    * @param roleName the name of the role
171    */
172   function removeRole(address addr, string roleName)
173     internal
174   {
175     roles[roleName].remove(addr);
176     emit RoleRemoved(addr, roleName);
177   }
178 
179   /**
180    * @dev modifier to scope access to a single role (uses msg.sender as addr)
181    * @param roleName the name of the role
182    * // reverts
183    */
184   modifier onlyRole(string roleName)
185   {
186     checkRole(msg.sender, roleName);
187     _;
188   }
189 }
190 
191 
192 /**
193  * @title Ethereum price feed
194  * @dev Keeps the current ETH price in USD cents to use by crowdsale contracts.
195  * Price kept up to date by external script polling exchanges tickers
196  * @author OnGrid Systems
197  */
198 contract PriceOracle is RBAC {
199   using SafeMath for uint256;
200 
201   // Average ETH price in USD cents
202   uint256 public ethPriceInCents;
203 
204   // The change limit in percent.
205   // Provides basic protection from erroneous input.
206   uint256 public allowedOracleChangePercent;
207 
208   // Roles in the oracle
209   string public constant ROLE_ADMIN = "admin";
210   string public constant ROLE_ORACLE = "oracle";
211 
212   /**
213    * @dev modifier to scope access to admins
214    * // reverts if called not by admin
215    */
216   modifier onlyAdmin()
217   {
218     checkRole(msg.sender, ROLE_ADMIN);
219     _;
220   }
221 
222   /**
223    * @dev modifier to scope access to price keeping oracles (scripts polling exchanges)
224    * // reverts if called not by oracle
225    */
226   modifier onlyOracle()
227   {
228     checkRole(msg.sender, ROLE_ORACLE);
229     _;
230   }
231 
232   /**
233    * @dev Initializes oracle contract
234    * @param _initialEthPriceInCents Initial Ethereum price in USD cents
235    * @param _allowedOracleChangePercent Percent of change allowed per single request
236    */
237   constructor(
238     uint256 _initialEthPriceInCents,
239     uint256 _allowedOracleChangePercent
240   ) public {
241     ethPriceInCents = _initialEthPriceInCents;
242     allowedOracleChangePercent = _allowedOracleChangePercent;
243     addRole(msg.sender, ROLE_ADMIN);
244   }
245 
246   /**
247    * @dev Converts ETH (wei) to USD cents
248    * @param _wei amount of wei (10e-18 ETH)
249    * @return cents amount
250    */
251   function getUsdCentsFromWei(uint256 _wei) public view returns (uint256) {
252     return _wei.mul(ethPriceInCents).div(1 ether);
253   }
254 
255   /**
256    * @dev Converts USD cents to wei
257    * @param _usdCents amount
258    * @return wei amount
259    */
260   function getWeiFromUsdCents(uint256 _usdCents)
261     public view returns (uint256)
262   {
263     return _usdCents.mul(1 ether).div(ethPriceInCents);
264   }
265 
266   /**
267    * @dev Sets current ETH price in cents
268    * @param _cents USD cents
269    */
270   function setEthPrice(uint256 _cents)
271     public
272     onlyOracle
273   {
274     uint256 maxCents = allowedOracleChangePercent.add(100)
275     .mul(ethPriceInCents).div(100);
276     uint256 minCents = SafeMath.sub(100,allowedOracleChangePercent)
277     .mul(ethPriceInCents).div(100);
278     require(
279       _cents <= maxCents && _cents >= minCents,
280       "Price out of allowed range"
281     );
282     ethPriceInCents = _cents;
283   }
284 
285   /**
286    * @dev Add admin role to an address
287    * @param addr address
288    */
289   function addAdmin(address addr)
290     public
291     onlyAdmin
292   {
293     addRole(addr, ROLE_ADMIN);
294   }
295 
296   /**
297    * @dev Revoke admin privileges from an address
298    * @param addr address
299    */
300   function delAdmin(address addr)
301     public
302     onlyAdmin
303   {
304     removeRole(addr, ROLE_ADMIN);
305   }
306 
307   /**
308    * @dev Add oracle role to an address
309    * @param addr address
310    */
311   function addOracle(address addr)
312     public
313     onlyAdmin
314   {
315     addRole(addr, ROLE_ORACLE);
316   }
317 
318   /**
319    * @dev Revoke oracle role from an address
320    * @param addr address
321    */
322   function delOracle(address addr)
323     public
324     onlyAdmin
325   {
326     removeRole(addr, ROLE_ORACLE);
327   }
328 }