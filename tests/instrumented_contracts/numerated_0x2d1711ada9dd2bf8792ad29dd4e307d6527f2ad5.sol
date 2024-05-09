1 /**
2  * Copyright (c) 2018 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6 
7 
8 pragma solidity 0.4.25;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address _newOwner) public onlyOwner {
59     _transferOwnership(_newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address _newOwner) internal {
67     require(_newOwner != address(0));
68     emit OwnershipTransferred(owner, _newOwner);
69     owner = _newOwner;
70   }
71 }
72 
73 
74 /**
75  * @title Claimable
76  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
77  * This allows the new owner to accept the transfer.
78  */
79 contract Claimable is Ownable {
80   address public pendingOwner;
81 
82   /**
83    * @dev Modifier throws if called by any account other than the pendingOwner.
84    */
85   modifier onlyPendingOwner() {
86     require(msg.sender == pendingOwner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to set the pendingOwner address.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() public onlyPendingOwner {
102     emit OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 
109 /**
110  * @title Roles
111  * @author Francisco Giordano (@frangio)
112  * @dev Library for managing addresses assigned to a Role.
113  * See RBAC.sol for example usage.
114  */
115 library Roles {
116   struct Role {
117     mapping (address => bool) bearer;
118   }
119 
120   /**
121    * @dev give an address access to this role
122    */
123   function add(Role storage _role, address _addr)
124     internal
125   {
126     _role.bearer[_addr] = true;
127   }
128 
129   /**
130    * @dev remove an address' access to this role
131    */
132   function remove(Role storage _role, address _addr)
133     internal
134   {
135     _role.bearer[_addr] = false;
136   }
137 
138   /**
139    * @dev check if an address has this role
140    * // reverts
141    */
142   function check(Role storage _role, address _addr)
143     internal
144     view
145   {
146     require(has(_role, _addr));
147   }
148 
149   /**
150    * @dev check if an address has this role
151    * @return bool
152    */
153   function has(Role storage _role, address _addr)
154     internal
155     view
156     returns (bool)
157   {
158     return _role.bearer[_addr];
159   }
160 }
161 
162 
163 /**
164  * @title RBAC (Role-Based Access Control)
165  * @author Matt Condon (@Shrugs)
166  * @dev Stores and provides setters and getters for roles and addresses.
167  * Supports unlimited numbers of roles and addresses.
168  * See //contracts/mocks/RBACMock.sol for an example of usage.
169  * This RBAC method uses strings to key roles. It may be beneficial
170  * for you to write your own implementation of this interface using Enums or similar.
171  */
172 contract RBAC {
173   using Roles for Roles.Role;
174 
175   mapping (string => Roles.Role) private roles;
176 
177   event RoleAdded(address indexed operator, string role);
178   event RoleRemoved(address indexed operator, string role);
179 
180   /**
181    * @dev reverts if addr does not have role
182    * @param _operator address
183    * @param _role the name of the role
184    * // reverts
185    */
186   function checkRole(address _operator, string _role)
187     public
188     view
189   {
190     roles[_role].check(_operator);
191   }
192 
193   /**
194    * @dev determine if addr has role
195    * @param _operator address
196    * @param _role the name of the role
197    * @return bool
198    */
199   function hasRole(address _operator, string _role)
200     public
201     view
202     returns (bool)
203   {
204     return roles[_role].has(_operator);
205   }
206 
207   /**
208    * @dev add a role to an address
209    * @param _operator address
210    * @param _role the name of the role
211    */
212   function addRole(address _operator, string _role)
213     internal
214   {
215     roles[_role].add(_operator);
216     emit RoleAdded(_operator, _role);
217   }
218 
219   /**
220    * @dev remove a role from an address
221    * @param _operator address
222    * @param _role the name of the role
223    */
224   function removeRole(address _operator, string _role)
225     internal
226   {
227     roles[_role].remove(_operator);
228     emit RoleRemoved(_operator, _role);
229   }
230 
231   /**
232    * @dev modifier to scope access to a single role (uses msg.sender as addr)
233    * @param _role the name of the role
234    * // reverts
235    */
236   modifier onlyRole(string _role)
237   {
238     checkRole(msg.sender, _role);
239     _;
240   }
241 
242   /**
243    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
244    * @param _roles the names of the roles to scope access to
245    * // reverts
246    *
247    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
248    *  see: https://github.com/ethereum/solidity/issues/2467
249    */
250   // modifier onlyRoles(string[] _roles) {
251   //     bool hasAnyRole = false;
252   //     for (uint8 i = 0; i < _roles.length; i++) {
253   //         if (hasRole(msg.sender, _roles[i])) {
254   //             hasAnyRole = true;
255   //             break;
256   //         }
257   //     }
258 
259   //     require(hasAnyRole);
260 
261   //     _;
262   // }
263 }
264 
265 
266 /**
267  * @title Whitelist
268  * @dev A minimal, simple database mapping public addresses (ie users) to their permissions.
269  *
270  * `TokenizedProperty` references `this` to only allow tokens to be transferred to addresses with necessary permissions.
271  * `TokenSale` references `this` to only allow tokens to be purchased by addresses within the necessary permissions.
272  *
273  * `WhitelistProxy` enables `this` to be easily and reliably upgraded if absolutely necessary.
274  * `WhitelistProxy` and `this` are controlled by a centralized entity (blockimmo).
275  *  This centralization is required by our legal framework to ensure investors are known and fully-legal.
276  */
277 contract Whitelist is Claimable, RBAC {
278   function grantPermission(address _operator, string _permission) public onlyOwner {
279     addRole(_operator, _permission);
280   }
281 
282   function revokePermission(address _operator, string _permission) public onlyOwner {
283     removeRole(_operator, _permission);
284   }
285 
286   function grantPermissionBatch(address[] _operators, string _permission) public onlyOwner {
287     for (uint256 i = 0; i < _operators.length; i++) {
288       addRole(_operators[i], _permission);
289     }
290   }
291 
292   function revokePermissionBatch(address[] _operators, string _permission) public onlyOwner {
293     for (uint256 i = 0; i < _operators.length; i++) {
294       removeRole(_operators[i], _permission);
295     }
296   }
297 }