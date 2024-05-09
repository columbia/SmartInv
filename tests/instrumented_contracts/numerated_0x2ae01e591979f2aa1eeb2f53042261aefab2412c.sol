1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Roles
6  * @author Francisco Giordano (@frangio)
7  * @dev Library for managing addresses assigned to a Role.
8  * See RBAC.sol for example usage.
9  */
10 library Roles {
11   struct Role {
12     mapping (address => bool) bearer;
13   }
14 
15   /**
16    * @dev give an address access to this role
17    */
18   function add(Role storage _role, address _addr)
19     internal
20   {
21     _role.bearer[_addr] = true;
22   }
23 
24   /**
25    * @dev remove an address' access to this role
26    */
27   function remove(Role storage _role, address _addr)
28     internal
29   {
30     _role.bearer[_addr] = false;
31   }
32 
33   /**
34    * @dev check if an address has this role
35    * // reverts
36    */
37   function check(Role storage _role, address _addr)
38     internal
39     view
40   {
41     require(has(_role, _addr));
42   }
43 
44   /**
45    * @dev check if an address has this role
46    * @return bool
47    */
48   function has(Role storage _role, address _addr)
49     internal
50     view
51     returns (bool)
52   {
53     return _role.bearer[_addr];
54   }
55 }
56 
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address _who) public view returns (uint256);
67   function transfer(address _to, uint256 _value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 
73 
74 
75 /**
76  * @title RBAC (Role-Based Access Control)
77  * @author Matt Condon (@Shrugs)
78  * @dev Stores and provides setters and getters for roles and addresses.
79  * Supports unlimited numbers of roles and addresses.
80  * See //contracts/mocks/RBACMock.sol for an example of usage.
81  * This RBAC method uses strings to key roles. It may be beneficial
82  * for you to write your own implementation of this interface using Enums or similar.
83  */
84 contract RBAC {
85   using Roles for Roles.Role;
86 
87   mapping (string => Roles.Role) private roles;
88 
89   event RoleAdded(address indexed operator, string role);
90   event RoleRemoved(address indexed operator, string role);
91 
92   /**
93    * @dev reverts if addr does not have role
94    * @param _operator address
95    * @param _role the name of the role
96    * // reverts
97    */
98   function checkRole(address _operator, string _role)
99     public
100     view
101   {
102     roles[_role].check(_operator);
103   }
104 
105   /**
106    * @dev determine if addr has role
107    * @param _operator address
108    * @param _role the name of the role
109    * @return bool
110    */
111   function hasRole(address _operator, string _role)
112     public
113     view
114     returns (bool)
115   {
116     return roles[_role].has(_operator);
117   }
118 
119   /**
120    * @dev add a role to an address
121    * @param _operator address
122    * @param _role the name of the role
123    */
124   function addRole(address _operator, string _role)
125     internal
126   {
127     roles[_role].add(_operator);
128     emit RoleAdded(_operator, _role);
129   }
130 
131   /**
132    * @dev remove a role from an address
133    * @param _operator address
134    * @param _role the name of the role
135    */
136   function removeRole(address _operator, string _role)
137     internal
138   {
139     roles[_role].remove(_operator);
140     emit RoleRemoved(_operator, _role);
141   }
142 
143   /**
144    * @dev modifier to scope access to a single role (uses msg.sender as addr)
145    * @param _role the name of the role
146    * // reverts
147    */
148   modifier onlyRole(string _role)
149   {
150     checkRole(msg.sender, _role);
151     _;
152   }
153 
154   /**
155    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
156    * @param _roles the names of the roles to scope access to
157    * // reverts
158    *
159    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
160    *  see: https://github.com/ethereum/solidity/issues/2467
161    */
162   // modifier onlyRoles(string[] _roles) {
163   //     bool hasAnyRole = false;
164   //     for (uint8 i = 0; i < _roles.length; i++) {
165   //         if (hasRole(msg.sender, _roles[i])) {
166   //             hasAnyRole = true;
167   //             break;
168   //         }
169   //     }
170 
171   //     require(hasAnyRole);
172 
173   //     _;
174   // }
175 }
176 
177 
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipRenounced(address indexed previousOwner);
189   event OwnershipTransferred(
190     address indexed previousOwner,
191     address indexed newOwner
192   );
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   constructor() public {
200     owner = msg.sender;
201   }
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211   /**
212    * @dev Allows the current owner to relinquish control of the contract.
213    * @notice Renouncing to ownership will leave the contract without an owner.
214    * It will not be possible to call the functions with the `onlyOwner`
215    * modifier anymore.
216    */
217   function renounceOwnership() public onlyOwner {
218     emit OwnershipRenounced(owner);
219     owner = address(0);
220   }
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param _newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address _newOwner) public onlyOwner {
227     _transferOwnership(_newOwner);
228   }
229 
230   /**
231    * @dev Transfers control of the contract to a newOwner.
232    * @param _newOwner The address to transfer ownership to.
233    */
234   function _transferOwnership(address _newOwner) internal {
235     require(_newOwner != address(0));
236     emit OwnershipTransferred(owner, _newOwner);
237     owner = _newOwner;
238   }
239 }
240 
241 
242 
243 
244 
245 
246 
247 
248 
249 
250 /**
251 * @title Operable
252 * @dev Adds operator role to SC functionality
253 */
254 contract Operable is Ownable, RBAC {
255     // role key
256     string public constant ROLE_OPERATOR = "operator";
257 
258     /**
259     * @dev Reverts in case account is not Operator role
260     */
261     modifier hasOperatePermission() {
262         require(hasRole(msg.sender, ROLE_OPERATOR));
263         _;
264     }
265 
266     /**
267     * @dev Reverts in case account is not Owner or Operator role
268     */
269     modifier hasOwnerOrOperatePermission() {
270         require(msg.sender == owner || hasRole(msg.sender, ROLE_OPERATOR));
271         _;
272     }
273 
274     /**
275     * @dev getter to determine if address is in whitelist
276     */
277     function operator(address _operator) public view returns (bool) {
278         return hasRole(_operator, ROLE_OPERATOR);
279     }
280 
281     /**
282     * @dev Method to add accounts with Operator role
283     * @param _operator address that will receive Operator role access
284     */
285     function addOperator(address _operator) onlyOwner public {
286         addRole(_operator, ROLE_OPERATOR);
287     }
288 
289     /**
290     * @dev Method to remove accounts with Operator role
291     * @param _operator address that will loose Operator role access
292     */
293     function removeOperator(address _operator) onlyOwner public {
294         removeRole(_operator, ROLE_OPERATOR);
295     }
296 }
297 
298 
299 
300 
301 
302 /**
303  * @title ERC20 interface
304  * @dev see https://github.com/ethereum/EIPs/issues/20
305  */
306 contract ERC20 is ERC20Basic {
307   function allowance(address _owner, address _spender)
308     public view returns (uint256);
309 
310   function transferFrom(address _from, address _to, uint256 _value)
311     public returns (bool);
312 
313   function approve(address _spender, uint256 _value) public returns (bool);
314   event Approval(
315     address indexed owner,
316     address indexed spender,
317     uint256 value
318   );
319 }
320 
321 
322 
323 /**
324  * @title FlipNpik Airdrop Tool.
325  */
326 contract FlipNpikAirdrop is Operable {
327     // FlipNpik token address
328     ERC20 public token;
329 
330     /**
331     * @param _token Token address
332     * @param _owner Smart contract owner address
333     */
334     constructor (ERC20 _token, address _owner) public {
335         require(_token != address(0), "Token address is invalid.");
336         token = _token;
337 
338         require(_owner != address(0), "Owner address is invalid.");
339         owner = _owner;
340     }
341     
342     /**
343     * @dev Distibutes tokens based on provided lists of wallets and values
344     * @param _wallets List of wallets
345     * @param _values List of values
346     */
347     function distribute(address[] _wallets, uint256[] _values) external hasOwnerOrOperatePermission returns(bool) {
348         require(_wallets.length == _values.length, "Lists are of different length.");
349         for (uint256 j = 0; j < _wallets.length; ++j) {
350             token.transferFrom(msg.sender, _wallets[j], _values[j]);
351         }
352         return true;
353     }
354 }