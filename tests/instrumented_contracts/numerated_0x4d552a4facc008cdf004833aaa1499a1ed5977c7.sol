1 pragma solidity 0.4.20;
2 
3 /**
4  * @title  PriceOracle
5  * @author Kirill Varlamov (@ongrid)
6  * @dev    Oracle for keeping actual ETH price (USD cents per 1 ETH).
7  */
8  
9  
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Roles
58  * @author Francisco Giordano (@frangio)
59  * @dev Library for managing addresses assigned to a Role.
60  *      See RBAC.sol for example usage.
61  */
62 library Roles {
63   struct Role {
64     mapping (address => bool) bearer;
65   }
66 
67   /**
68    * @dev give an address access to this role
69    */
70   function add(Role storage role, address addr)
71     internal
72   {
73     role.bearer[addr] = true;
74   }
75 
76   /**
77    * @dev remove an address' access to this role
78    */
79   function remove(Role storage role, address addr)
80     internal
81   {
82     role.bearer[addr] = false;
83   }
84 
85   /**
86    * @dev check if an address has this role
87    * // reverts
88    */
89   function check(Role storage role, address addr)
90     view
91     internal
92   {
93     require(has(role, addr));
94   }
95 
96   /**
97    * @dev check if an address has this role
98    * @return bool
99    */
100   function has(Role storage role, address addr)
101     view
102     internal
103     returns (bool)
104   {
105     return role.bearer[addr];
106   }
107 }
108 
109 
110 /**
111  * @title RBAC (Role-Based Access Control)
112  * @author Matt Condon (@Shrugs)
113  * @dev Stores and provides setters and getters for roles and addresses.
114  *      Supports unlimited numbers of roles and addresses.
115  *      See //contracts/mocks/RBACMock.sol for an example of usage.
116  * This RBAC method uses strings to key roles. It may be beneficial
117  *  for you to write your own implementation of this interface using Enums or similar.
118  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
119  *  to avoid typos.
120  */
121 contract RBAC {
122   using Roles for Roles.Role;
123 
124   mapping (string => Roles.Role) private roles;
125 
126   event RoleAdded(address addr, string roleName);
127   event RoleRemoved(address addr, string roleName);
128 
129   /**
130    * A constant role name for indicating admins.
131    */
132   string public constant ROLE_ADMIN = "admin";
133 
134   /**
135    * @dev constructor. Sets msg.sender as admin by default
136    */
137   function RBAC()
138     public
139   {
140     addRole(msg.sender, ROLE_ADMIN);
141   }
142 
143   /**
144    * @dev reverts if addr does not have role
145    * @param addr address
146    * @param roleName the name of the role
147    * // reverts
148    */
149   function checkRole(address addr, string roleName)
150     view
151     public
152   {
153     roles[roleName].check(addr);
154   }
155 
156   /**
157    * @dev determine if addr has role
158    * @param addr address
159    * @param roleName the name of the role
160    * @return bool
161    */
162   function hasRole(address addr, string roleName)
163     view
164     public
165     returns (bool)
166   {
167     return roles[roleName].has(addr);
168   }
169 
170   /**
171    * @dev add a role to an address
172    * @param addr address
173    * @param roleName the name of the role
174    */
175   function adminAddRole(address addr, string roleName)
176     onlyAdmin
177     public
178   {
179     addRole(addr, roleName);
180   }
181 
182   /**
183    * @dev remove a role from an address
184    * @param addr address
185    * @param roleName the name of the role
186    */
187   function adminRemoveRole(address addr, string roleName)
188     onlyAdmin
189     public
190   {
191     removeRole(addr, roleName);
192   }
193 
194   /**
195    * @dev add a role to an address
196    * @param addr address
197    * @param roleName the name of the role
198    */
199   function addRole(address addr, string roleName)
200     internal
201   {
202     roles[roleName].add(addr);
203     RoleAdded(addr, roleName);
204   }
205 
206   /**
207    * @dev remove a role from an address
208    * @param addr address
209    * @param roleName the name of the role
210    */
211   function removeRole(address addr, string roleName)
212     internal
213   {
214     roles[roleName].remove(addr);
215     RoleRemoved(addr, roleName);
216   }
217 
218   /**
219    * @dev modifier to scope access to a single role (uses msg.sender as addr)
220    * @param roleName the name of the role
221    * // reverts
222    */
223   modifier onlyRole(string roleName)
224   {
225     checkRole(msg.sender, roleName);
226     _;
227   }
228 
229   /**
230    * @dev modifier to scope access to admins
231    * // reverts
232    */
233   modifier onlyAdmin()
234   {
235     checkRole(msg.sender, ROLE_ADMIN);
236     _;
237   }
238 }
239 
240 
241 /**
242  * @title  PriceOracle
243  * @dev    Contract for actual ETH price injection into Ethereum ledger.
244  *         Contract gets periodically updated by external script polling major exchanges for actual ETH/SDH price.
245  * @author Kirill Varlamov, OnGrid systems
246  */
247 contract PriceOracle is RBAC {
248     using SafeMath for uint256;
249     string constant ROLE_BOT = "bot";
250     // current ETHereum price in USD cents.
251     uint256 public priceUSDcETH;
252     event PriceUpdate(uint256 price);
253 
254     /**
255      * @param _initialPrice Starting ETHereum price in USD cents.
256      */
257     function PriceOracle(uint256 _initialPrice) RBAC() public {
258         priceUSDcETH = _initialPrice;
259         addRole(msg.sender, ROLE_BOT);
260     }
261 
262     /**
263      * @dev Updates in-contract price upon external bot request.
264      *      New price is checked for validity (the single-request change is limited to 10%)
265      * @param _priceUSDcETH Requested ETHereum price in USD cents.
266      */
267     function setPrice(uint256 _priceUSDcETH) public onlyRole(ROLE_BOT) {
268         // don't allow to change price more than 10%
269         // to avoid typos
270         assert(_priceUSDcETH < priceUSDcETH.mul(110).div(100));
271         assert(_priceUSDcETH > priceUSDcETH.mul(90).div(100));
272         priceUSDcETH = _priceUSDcETH;
273         PriceUpdate(priceUSDcETH);
274     }
275 }