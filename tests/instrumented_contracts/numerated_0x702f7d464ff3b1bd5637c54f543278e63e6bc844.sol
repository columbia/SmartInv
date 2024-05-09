1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 }
50 
51 
52 /**
53  * @title Roles
54  * @author Francisco Giordano (@frangio)
55  * @dev Library for managing addresses assigned to a Role.
56  *      See RBAC.sol for example usage.
57  */
58 library Roles {
59   struct Role {
60     mapping (address => bool) bearer;
61   }
62 
63   /**
64    * @dev give an address access to this role
65    */
66   function add(Role storage role, address addr)
67     internal
68   {
69     role.bearer[addr] = true;
70   }
71 
72   /**
73    * @dev remove an address' access to this role
74    */
75   function remove(Role storage role, address addr)
76     internal
77   {
78     role.bearer[addr] = false;
79   }
80 
81   /**
82    * @dev check if an address has this role
83    * // reverts
84    */
85   function check(Role storage role, address addr)
86     view
87     internal
88   {
89     require(has(role, addr));
90   }
91 
92   /**
93    * @dev check if an address has this role
94    * @return bool
95    */
96   function has(Role storage role, address addr)
97     view
98     internal
99     returns (bool)
100   {
101     return role.bearer[addr];
102   }
103 }
104 
105 
106 /**
107  * @title RBAC (Role-Based Access Control)
108  * @author Matt Condon (@Shrugs)
109  * @dev Stores and provides setters and getters for roles and addresses.
110  * @dev Supports unlimited numbers of roles and addresses.
111  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
112  * This RBAC method uses strings to key roles. It may be beneficial
113  *  for you to write your own implementation of this interface using Enums or similar.
114  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
115  *  to avoid typos.
116  */
117 contract RBAC {
118   using Roles for Roles.Role;
119 
120   mapping (string => Roles.Role) private roles;
121 
122   event RoleAdded(address addr, string roleName);
123   event RoleRemoved(address addr, string roleName);
124 
125   /**
126    * @dev reverts if addr does not have role
127    * @param addr address
128    * @param roleName the name of the role
129    * // reverts
130    */
131   function checkRole(address addr, string roleName)
132     view
133     public
134   {
135     roles[roleName].check(addr);
136   }
137 
138   /**
139    * @dev determine if addr has role
140    * @param addr address
141    * @param roleName the name of the role
142    * @return bool
143    */
144   function hasRole(address addr, string roleName)
145     view
146     public
147     returns (bool)
148   {
149     return roles[roleName].has(addr);
150   }
151 
152   /**
153    * @dev add a role to an address
154    * @param addr address
155    * @param roleName the name of the role
156    */
157   function addRole(address addr, string roleName)
158     internal
159   {
160     roles[roleName].add(addr);
161     emit RoleAdded(addr, roleName);
162   }
163 
164   /**
165    * @dev remove a role from an address
166    * @param addr address
167    * @param roleName the name of the role
168    */
169   function removeRole(address addr, string roleName)
170     internal
171   {
172     roles[roleName].remove(addr);
173     emit RoleRemoved(addr, roleName);
174   }
175 
176   /**
177    * @dev modifier to scope access to a single role (uses msg.sender as addr)
178    * @param roleName the name of the role
179    * // reverts
180    */
181   modifier onlyRole(string roleName)
182   {
183     checkRole(msg.sender, roleName);
184     _;
185   }
186 
187   /**
188    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
189    * @param roleNames the names of the roles to scope access to
190    * // reverts
191    *
192    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
193    *  see: https://github.com/ethereum/solidity/issues/2467
194    */
195   // modifier onlyRoles(string[] roleNames) {
196   //     bool hasAnyRole = false;
197   //     for (uint8 i = 0; i < roleNames.length; i++) {
198   //         if (hasRole(msg.sender, roleNames[i])) {
199   //             hasAnyRole = true;
200   //             break;
201   //         }
202   //     }
203 
204   //     require(hasAnyRole);
205 
206   //     _;
207   // }
208 }
209 
210 
211 /**
212  * @title Whitelist
213  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
214  * @dev This simplifies the implementation of "user permissions".
215  */
216 contract Whitelist is Ownable, RBAC {
217   event WhitelistedAddressAdded(address addr);
218   event WhitelistedAddressRemoved(address addr);
219 
220   string public constant ROLE_WHITELISTED = "whitelist";
221 
222   /**
223    * @dev Throws if called by any account that's not whitelisted.
224    */
225   modifier onlyWhitelisted() {
226     checkRole(msg.sender, ROLE_WHITELISTED);
227     _;
228   }
229 
230   /**
231    * @dev add an address to the whitelist
232    * @param addr address
233    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
234    */
235   function addAddressToWhitelist(address addr)
236     onlyOwner
237     public
238   {
239     addRole(addr, ROLE_WHITELISTED);
240     emit WhitelistedAddressAdded(addr);
241   }
242 
243   /**
244    * @dev getter to determine if address is in whitelist
245    */
246   function whitelist(address addr)
247     public
248     view
249     returns (bool)
250   {
251     return hasRole(addr, ROLE_WHITELISTED);
252   }
253 
254   /**
255    * @dev add addresses to the whitelist
256    * @param addrs addresses
257    * @return true if at least one address was added to the whitelist,
258    * false if all addresses were already in the whitelist
259    */
260   function addAddressesToWhitelist(address[] addrs)
261     onlyOwner
262     public
263   {
264     for (uint256 i = 0; i < addrs.length; i++) {
265       addAddressToWhitelist(addrs[i]);
266     }
267   }
268 
269   /**
270    * @dev remove an address from the whitelist
271    * @param addr address
272    * @return true if the address was removed from the whitelist,
273    * false if the address wasn't in the whitelist in the first place
274    */
275   function removeAddressFromWhitelist(address addr)
276     onlyOwner
277     public
278   {
279     removeRole(addr, ROLE_WHITELISTED);
280     emit WhitelistedAddressRemoved(addr);
281   }
282 
283   /**
284    * @dev remove addresses from the whitelist
285    * @param addrs addresses
286    * @return true if at least one address was removed from the whitelist,
287    * false if all addresses weren't in the whitelist in the first place
288    */
289   function removeAddressesFromWhitelist(address[] addrs)
290     onlyOwner
291     public
292   {
293     for (uint256 i = 0; i < addrs.length; i++) {
294       removeAddressFromWhitelist(addrs[i]);
295     }
296   }
297 
298 }