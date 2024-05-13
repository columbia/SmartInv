1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * Copied from https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts-upgradeable/v3.4.2-solc-0.7
5  * Modified to support solc-8.
6  * Using this instead of the new OZ implementation due to a change in storage slots used.
7  * Also limited access of several functions as we will be using convenience wrappers.
8  */
9 
10 pragma solidity ^0.8.0;
11 
12 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
13 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
14 import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
15 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
16 
17 // solhint-disable
18 
19 /**
20  * @title Implements role-based access control mechanisms.
21  * @dev Contract module that allows children to implement role-based access
22  * control mechanisms.
23  *
24  * Roles are referred to by their `bytes32` identifier. These should be exposed
25  * in the external API and be unique. The best way to achieve this is by
26  * using `public constant` hash digests:
27  *
28  * ```
29  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
30  * ```
31  *
32  * Roles can be used to represent a set of permissions. To restrict access to a
33  * function call, use {hasRole}:
34  *
35  * ```
36  * function foo() public {
37  *     require(hasRole(MY_ROLE, msg.sender));
38  *     ...
39  * }
40  * ```
41  *
42  * Roles can be granted and revoked dynamically via the {grantRole} and
43  * {revokeRole} functions. Each role has an associated admin role, and only
44  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
45  *
46  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
47  * that only accounts with this role will be able to grant or revoke other
48  * roles. More complex role relationships can be created by using
49  * {_setRoleAdmin}.
50  *
51  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
52  * grant and revoke this role. Extra precautions should be taken to secure
53  * accounts that have been granted it.
54  */
55 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable {
56   function __AccessControl_init() internal onlyInitializing {
57     __Context_init_unchained();
58     __AccessControl_init_unchained();
59   }
60 
61   function __AccessControl_init_unchained() internal onlyInitializing {}
62 
63   using EnumerableSet for EnumerableSet.AddressSet;
64   using AddressUpgradeable for address;
65 
66   struct RoleData {
67     EnumerableSet.AddressSet members;
68     bytes32 adminRole;
69   }
70 
71   mapping(bytes32 => RoleData) private _roles;
72 
73   bytes32 internal constant DEFAULT_ADMIN_ROLE = 0x00;
74 
75   /**
76    * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
77    *
78    * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
79    * {RoleAdminChanged} not being emitted signaling this.
80    *
81    * _Available since v3.1._
82    */
83   event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
84 
85   /**
86    * @dev Emitted when `account` is granted `role`.
87    *
88    * `sender` is the account that originated the contract call, an admin role
89    * bearer except when using {_setupRole}.
90    */
91   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
92 
93   /**
94    * @dev Emitted when `account` is revoked `role`.
95    *
96    * `sender` is the account that originated the contract call:
97    *   - if using `revokeRole`, it is the admin role bearer
98    *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
99    */
100   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
101 
102   /**
103    * @dev Returns `true` if `account` has been granted `role`.
104    */
105   function hasRole(bytes32 role, address account) internal view returns (bool) {
106     return _roles[role].members.contains(account);
107   }
108 
109   /**
110    * @dev Returns the number of accounts that have `role`. Can be used
111    * together with {getRoleMember} to enumerate all bearers of a role.
112    */
113   function getRoleMemberCount(bytes32 role) internal view returns (uint256) {
114     return _roles[role].members.length();
115   }
116 
117   /**
118    * @dev Returns one of the accounts that have `role`. `index` must be a
119    * value between 0 and {getRoleMemberCount}, non-inclusive.
120    *
121    * Role bearers are not sorted in any particular way, and their ordering may
122    * change at any point.
123    *
124    * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
125    * you perform all queries on the same block. See the following
126    * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
127    * for more information.
128    */
129   function getRoleMember(bytes32 role, uint256 index) internal view returns (address) {
130     return _roles[role].members.at(index);
131   }
132 
133   /**
134    * @dev Returns the admin role that controls `role`. See {grantRole} and
135    * {revokeRole}.
136    *
137    * To change a role's admin, use {_setRoleAdmin}.
138    */
139   function getRoleAdmin(bytes32 role) internal view returns (bytes32) {
140     return _roles[role].adminRole;
141   }
142 
143   /**
144    * @dev Grants `role` to `account`.
145    *
146    * If `account` had not been already granted `role`, emits a {RoleGranted}
147    * event.
148    *
149    * Requirements:
150    *
151    * - the caller must have ``role``'s admin role.
152    */
153   function grantRole(bytes32 role, address account) internal virtual {
154     require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
155 
156     _grantRole(role, account);
157   }
158 
159   /**
160    * @dev Revokes `role` from `account`.
161    *
162    * If `account` had been granted `role`, emits a {RoleRevoked} event.
163    *
164    * Requirements:
165    *
166    * - the caller must have ``role``'s admin role.
167    */
168   function revokeRole(bytes32 role, address account) internal virtual {
169     require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
170 
171     _revokeRole(role, account);
172   }
173 
174   /**
175    * @dev Revokes `role` from the calling account.
176    *
177    * Roles are often managed via {grantRole} and {revokeRole}: this function's
178    * purpose is to provide a mechanism for accounts to lose their privileges
179    * if they are compromised (such as when a trusted device is misplaced).
180    *
181    * If the calling account had been granted `role`, emits a {RoleRevoked}
182    * event.
183    *
184    * Requirements:
185    *
186    * - the caller must be `account`.
187    */
188   function renounceRole(bytes32 role, address account) internal virtual {
189     require(account == _msgSender(), "AccessControl: can only renounce roles for self");
190 
191     _revokeRole(role, account);
192   }
193 
194   /**
195    * @dev Grants `role` to `account`.
196    *
197    * If `account` had not been already granted `role`, emits a {RoleGranted}
198    * event. Note that unlike {grantRole}, this function doesn't perform any
199    * checks on the calling account.
200    *
201    * [WARNING]
202    * ====
203    * This function should only be called from the constructor when setting
204    * up the initial roles for the system.
205    *
206    * Using this function in any other way is effectively circumventing the admin
207    * system imposed by {AccessControl}.
208    * ====
209    */
210   function _setupRole(bytes32 role, address account) internal {
211     _grantRole(role, account);
212   }
213 
214   /**
215    * @dev Sets `adminRole` as ``role``'s admin role.
216    *
217    * Emits a {RoleAdminChanged} event.
218    */
219   function _setRoleAdmin(bytes32 role, bytes32 adminRole) private {
220     emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
221     _roles[role].adminRole = adminRole;
222   }
223 
224   function _grantRole(bytes32 role, address account) private {
225     if (_roles[role].members.add(account)) {
226       emit RoleGranted(role, account, _msgSender());
227     }
228   }
229 
230   function _revokeRole(bytes32 role, address account) private {
231     if (_roles[role].members.remove(account)) {
232       emit RoleRevoked(role, account, _msgSender());
233     }
234   }
235 
236   /**
237    * @notice This empty reserved space is put in place to allow future versions to add new
238    * variables without shifting down storage in the inheritance chain.
239    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
240    */
241   uint256[49] private __gap;
242 }
