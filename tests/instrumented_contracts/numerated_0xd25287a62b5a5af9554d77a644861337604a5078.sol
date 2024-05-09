1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  *      See RBAC.sol for example usage.
10  */
11 library Roles {
12   struct Role {
13     mapping (address => bool) bearer;
14   }
15 
16   /**
17    * @dev give an address access to this role
18    */
19   function add(Role storage role, address addr)
20     internal
21   {
22     role.bearer[addr] = true;
23   }
24 
25   /**
26    * @dev remove an address' access to this role
27    */
28   function remove(Role storage role, address addr)
29     internal
30   {
31     role.bearer[addr] = false;
32   }
33 
34   /**
35    * @dev check if an address has this role
36    * // reverts
37    */
38   function check(Role storage role, address addr)
39     view
40     internal
41   {
42     require(has(role, addr));
43   }
44 
45   /**
46    * @dev check if an address has this role
47    * @return bool
48    */
49   function has(Role storage role, address addr)
50     view
51     internal
52     returns (bool)
53   {
54     return role.bearer[addr];
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
59 
60 /**
61  * @title RBAC (Role-Based Access Control)
62  * @author Matt Condon (@Shrugs)
63  * @dev Stores and provides setters and getters for roles and addresses.
64  *      Supports unlimited numbers of roles and addresses.
65  *      See //contracts/mocks/RBACMock.sol for an example of usage.
66  * This RBAC method uses strings to key roles. It may be beneficial
67  *  for you to write your own implementation of this interface using Enums or similar.
68  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
69  *  to avoid typos.
70  */
71 contract RBAC {
72   using Roles for Roles.Role;
73 
74   mapping (string => Roles.Role) private roles;
75 
76   event RoleAdded(address addr, string roleName);
77   event RoleRemoved(address addr, string roleName);
78 
79   /**
80    * A constant role name for indicating admins.
81    */
82   string public constant ROLE_ADMIN = "admin";
83 
84   /**
85    * @dev constructor. Sets msg.sender as admin by default
86    */
87   function RBAC()
88     public
89   {
90     addRole(msg.sender, ROLE_ADMIN);
91   }
92 
93   /**
94    * @dev reverts if addr does not have role
95    * @param addr address
96    * @param roleName the name of the role
97    * // reverts
98    */
99   function checkRole(address addr, string roleName)
100     view
101     public
102   {
103     roles[roleName].check(addr);
104   }
105 
106   /**
107    * @dev determine if addr has role
108    * @param addr address
109    * @param roleName the name of the role
110    * @return bool
111    */
112   function hasRole(address addr, string roleName)
113     view
114     public
115     returns (bool)
116   {
117     return roles[roleName].has(addr);
118   }
119 
120   /**
121    * @dev add a role to an address
122    * @param addr address
123    * @param roleName the name of the role
124    */
125   function adminAddRole(address addr, string roleName)
126     onlyAdmin
127     public
128   {
129     addRole(addr, roleName);
130   }
131 
132   /**
133    * @dev remove a role from an address
134    * @param addr address
135    * @param roleName the name of the role
136    */
137   function adminRemoveRole(address addr, string roleName)
138     onlyAdmin
139     public
140   {
141     removeRole(addr, roleName);
142   }
143 
144   /**
145    * @dev add a role to an address
146    * @param addr address
147    * @param roleName the name of the role
148    */
149   function addRole(address addr, string roleName)
150     internal
151   {
152     roles[roleName].add(addr);
153     RoleAdded(addr, roleName);
154   }
155 
156   /**
157    * @dev remove a role from an address
158    * @param addr address
159    * @param roleName the name of the role
160    */
161   function removeRole(address addr, string roleName)
162     internal
163   {
164     roles[roleName].remove(addr);
165     RoleRemoved(addr, roleName);
166   }
167 
168   /**
169    * @dev modifier to scope access to a single role (uses msg.sender as addr)
170    * @param roleName the name of the role
171    * // reverts
172    */
173   modifier onlyRole(string roleName)
174   {
175     checkRole(msg.sender, roleName);
176     _;
177   }
178 
179   /**
180    * @dev modifier to scope access to admins
181    * // reverts
182    */
183   modifier onlyAdmin()
184   {
185     checkRole(msg.sender, ROLE_ADMIN);
186     _;
187   }
188 
189   /**
190    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
191    * @param roleNames the names of the roles to scope access to
192    * // reverts
193    *
194    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
195    *  see: https://github.com/ethereum/solidity/issues/2467
196    */
197   // modifier onlyRoles(string[] roleNames) {
198   //     bool hasAnyRole = false;
199   //     for (uint8 i = 0; i < roleNames.length; i++) {
200   //         if (hasRole(msg.sender, roleNames[i])) {
201   //             hasAnyRole = true;
202   //             break;
203   //         }
204   //     }
205 
206   //     require(hasAnyRole);
207 
208   //     _;
209   // }
210 }
211 
212 // File: contracts/CourseCertification.sol
213 
214 contract CourseCertification is RBAC {
215     mapping (string => address[]) private associations;
216 
217     string public constant ROLE_MANAGER = "manager";
218 
219     modifier onlyAdminOrManager()
220     {
221         require(hasRole(msg.sender, ROLE_ADMIN) || hasRole(msg.sender, ROLE_MANAGER));
222         _;
223     }
224 
225     function CourseCertification() public {
226         addRole(msg.sender, ROLE_MANAGER);
227     }
228 
229     /**
230      * @dev get user course list
231      * @param user string
232      */
233     function getCourseList(string user) view public returns (address[]) {
234         return associations[user];
235     }
236 
237     /**
238      * @dev add a course to a user
239      * @param user string
240      * @param course string
241      */
242     function addCourse(string user, address course) onlyAdminOrManager public {
243         associations[user].push(course);
244     }
245 
246     /**
247      * @dev add courses to a user
248      * @param user string
249      * @param courses address[]
250      */
251     function addCourses(string user, address[] courses) onlyAdminOrManager public {
252         for (uint256 i = 0; i < courses.length; i++) {
253             address course = courses[i];
254             associations[user].push(course);
255         }
256     }
257 }