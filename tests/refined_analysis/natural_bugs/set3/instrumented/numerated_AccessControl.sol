1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 // This is adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/access/AccessControl.sol
6 // The only difference is added getRoleMemberIndex(bytes32 role, address account) function.
7 
8 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
9 import "@openzeppelin/contracts/utils/Address.sol";
10 import "@openzeppelin/contracts/utils/Context.sol";
11 
12 /**
13  * @dev Contract module that allows children to implement role-based access
14  * control mechanisms.
15  *
16  * Roles are referred to by their `bytes32` identifier. These should be exposed
17  * in the external API and be unique. The best way to achieve this is by
18  * using `public constant` hash digests:
19  *
20  * ```
21  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
22  * ```
23  *
24  * Roles can be used to represent a set of permissions. To restrict access to a
25  * function call, use {hasRole}:
26  *
27  * ```
28  * function foo() public {
29  *     require(hasRole(MY_ROLE, msg.sender));
30  *     ...
31  * }
32  * ```
33  *
34  * Roles can be granted and revoked dynamically via the {grantRole} and
35  * {revokeRole} functions. Each role has an associated admin role, and only
36  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
37  *
38  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
39  * that only accounts with this role will be able to grant or revoke other
40  * roles. More complex role relationships can be created by using
41  * {_setRoleAdmin}.
42  *
43  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
44  * grant and revoke this role. Extra precautions should be taken to secure
45  * accounts that have been granted it.
46  */
47 abstract contract AccessControl is Context {
48     using EnumerableSet for EnumerableSet.AddressSet;
49     using Address for address;
50 
51     struct RoleData {
52         EnumerableSet.AddressSet members;
53         bytes32 adminRole;
54     }
55 
56     mapping (bytes32 => RoleData) private _roles;
57 
58     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
59 
60     /**
61      * @dev Emitted when `account` is granted `role`.
62      *
63      * `sender` is the account that originated the contract call, an admin role
64      * bearer except when using {_setupRole}.
65      */
66     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
67 
68     /**
69      * @dev Emitted when `account` is revoked `role`.
70      *
71      * `sender` is the account that originated the contract call:
72      *   - if using `revokeRole`, it is the admin role bearer
73      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
74      */
75     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
76 
77     /**
78      * @dev Returns `true` if `account` has been granted `role`.
79      */
80     function hasRole(bytes32 role, address account) public view returns (bool) {
81         return _roles[role].members.contains(account);
82     }
83 
84     /**
85      * @dev Returns the number of accounts that have `role`. Can be used
86      * together with {getRoleMember} to enumerate all bearers of a role.
87      */
88     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
89         return _roles[role].members.length();
90     }
91 
92     /**
93      * @dev Returns one of the accounts that have `role`. `index` must be a
94      * value between 0 and {getRoleMemberCount}, non-inclusive.
95      *
96      * Role bearers are not sorted in any particular way, and their ordering may
97      * change at any point.
98      *
99      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
100      * you perform all queries on the same block. See the following
101      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
102      * for more information.
103      */
104     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
105         return _roles[role].members.at(index);
106     }
107 
108     /**
109      * @dev Returns the index of the account that have `role`.
110      */
111     function getRoleMemberIndex(bytes32 role, address account) public view returns (uint256) {
112         return _roles[role].members._inner._indexes[bytes32(uint256(uint160(account)))];
113     }
114 
115     /**
116      * @dev Returns the admin role that controls `role`. See {grantRole} and
117      * {revokeRole}.
118      *
119      * To change a role's admin, use {_setRoleAdmin}.
120      */
121     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
122         return _roles[role].adminRole;
123     }
124 
125     /**
126      * @dev Grants `role` to `account`.
127      *
128      * If `account` had not been already granted `role`, emits a {RoleGranted}
129      * event.
130      *
131      * Requirements:
132      *
133      * - the caller must have ``role``'s admin role.
134      */
135     function grantRole(bytes32 role, address account) public virtual {
136         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
137 
138         _grantRole(role, account);
139     }
140 
141     /**
142      * @dev Revokes `role` from `account`.
143      *
144      * If `account` had been granted `role`, emits a {RoleRevoked} event.
145      *
146      * Requirements:
147      *
148      * - the caller must have ``role``'s admin role.
149      */
150     function revokeRole(bytes32 role, address account) public virtual {
151         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
152 
153         _revokeRole(role, account);
154     }
155 
156     /**
157      * @dev Revokes `role` from the calling account.
158      *
159      * Roles are often managed via {grantRole} and {revokeRole}: this function's
160      * purpose is to provide a mechanism for accounts to lose their privileges
161      * if they are compromised (such as when a trusted device is misplaced).
162      *
163      * If the calling account had been granted `role`, emits a {RoleRevoked}
164      * event.
165      *
166      * Requirements:
167      *
168      * - the caller must be `account`.
169      */
170     function renounceRole(bytes32 role, address account) public virtual {
171         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
172 
173         _revokeRole(role, account);
174     }
175 
176     /**
177      * @dev Grants `role` to `account`.
178      *
179      * If `account` had not been already granted `role`, emits a {RoleGranted}
180      * event. Note that unlike {grantRole}, this function doesn't perform any
181      * checks on the calling account.
182      *
183      * [WARNING]
184      * ====
185      * This function should only be called from the constructor when setting
186      * up the initial roles for the system.
187      *
188      * Using this function in any other way is effectively circumventing the admin
189      * system imposed by {AccessControl}.
190      * ====
191      */
192     function _setupRole(bytes32 role, address account) internal virtual {
193         _grantRole(role, account);
194     }
195 
196     /**
197      * @dev Sets `adminRole` as ``role``'s admin role.
198      */
199     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
200         _roles[role].adminRole = adminRole;
201     }
202 
203     function _grantRole(bytes32 role, address account) private {
204         if (_roles[role].members.add(account)) {
205             emit RoleGranted(role, account, _msgSender());
206         }
207     }
208 
209     function _revokeRole(bytes32 role, address account) private {
210         if (_roles[role].members.remove(account)) {
211             emit RoleRevoked(role, account, _msgSender());
212         }
213     }
214 }
