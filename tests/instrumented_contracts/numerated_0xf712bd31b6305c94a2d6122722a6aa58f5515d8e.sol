1 pragma solidity ^0.4.23;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: node_modules/openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
65 
66 /**
67  * @title Roles
68  * @author Francisco Giordano (@frangio)
69  * @dev Library for managing addresses assigned to a Role.
70  *      See RBAC.sol for example usage.
71  */
72 library Roles {
73   struct Role {
74     mapping (address => bool) bearer;
75   }
76 
77   /**
78    * @dev give an address access to this role
79    */
80   function add(Role storage role, address addr)
81     internal
82   {
83     role.bearer[addr] = true;
84   }
85 
86   /**
87    * @dev remove an address' access to this role
88    */
89   function remove(Role storage role, address addr)
90     internal
91   {
92     role.bearer[addr] = false;
93   }
94 
95   /**
96    * @dev check if an address has this role
97    * // reverts
98    */
99   function check(Role storage role, address addr)
100     view
101     internal
102   {
103     require(has(role, addr));
104   }
105 
106   /**
107    * @dev check if an address has this role
108    * @return bool
109    */
110   function has(Role storage role, address addr)
111     view
112     internal
113     returns (bool)
114   {
115     return role.bearer[addr];
116   }
117 }
118 
119 // File: node_modules/openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
120 
121 /**
122  * @title RBAC (Role-Based Access Control)
123  * @author Matt Condon (@Shrugs)
124  * @dev Stores and provides setters and getters for roles and addresses.
125  * @dev Supports unlimited numbers of roles and addresses.
126  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
127  * This RBAC method uses strings to key roles. It may be beneficial
128  *  for you to write your own implementation of this interface using Enums or similar.
129  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
130  *  to avoid typos.
131  */
132 contract RBAC {
133   using Roles for Roles.Role;
134 
135   mapping (string => Roles.Role) private roles;
136 
137   event RoleAdded(address addr, string roleName);
138   event RoleRemoved(address addr, string roleName);
139 
140   /**
141    * @dev reverts if addr does not have role
142    * @param addr address
143    * @param roleName the name of the role
144    * // reverts
145    */
146   function checkRole(address addr, string roleName)
147     view
148     public
149   {
150     roles[roleName].check(addr);
151   }
152 
153   /**
154    * @dev determine if addr has role
155    * @param addr address
156    * @param roleName the name of the role
157    * @return bool
158    */
159   function hasRole(address addr, string roleName)
160     view
161     public
162     returns (bool)
163   {
164     return roles[roleName].has(addr);
165   }
166 
167   /**
168    * @dev add a role to an address
169    * @param addr address
170    * @param roleName the name of the role
171    */
172   function addRole(address addr, string roleName)
173     internal
174   {
175     roles[roleName].add(addr);
176     emit RoleAdded(addr, roleName);
177   }
178 
179   /**
180    * @dev remove a role from an address
181    * @param addr address
182    * @param roleName the name of the role
183    */
184   function removeRole(address addr, string roleName)
185     internal
186   {
187     roles[roleName].remove(addr);
188     emit RoleRemoved(addr, roleName);
189   }
190 
191   /**
192    * @dev modifier to scope access to a single role (uses msg.sender as addr)
193    * @param roleName the name of the role
194    * // reverts
195    */
196   modifier onlyRole(string roleName)
197   {
198     checkRole(msg.sender, roleName);
199     _;
200   }
201 
202   /**
203    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
204    * @param roleNames the names of the roles to scope access to
205    * // reverts
206    *
207    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
208    *  see: https://github.com/ethereum/solidity/issues/2467
209    */
210   // modifier onlyRoles(string[] roleNames) {
211   //     bool hasAnyRole = false;
212   //     for (uint8 i = 0; i < roleNames.length; i++) {
213   //         if (hasRole(msg.sender, roleNames[i])) {
214   //             hasAnyRole = true;
215   //             break;
216   //         }
217   //     }
218 
219   //     require(hasAnyRole);
220 
221   //     _;
222   // }
223 }
224 
225 // File: node_modules/openzeppelin-solidity/contracts/ownership/Whitelist.sol
226 
227 /**
228  * @title Whitelist
229  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
230  * @dev This simplifies the implementation of "user permissions".
231  */
232 contract Whitelist is Ownable, RBAC {
233   event WhitelistedAddressAdded(address addr);
234   event WhitelistedAddressRemoved(address addr);
235 
236   string public constant ROLE_WHITELISTED = "whitelist";
237 
238   /**
239    * @dev Throws if called by any account that's not whitelisted.
240    */
241   modifier onlyWhitelisted() {
242     checkRole(msg.sender, ROLE_WHITELISTED);
243     _;
244   }
245 
246   /**
247    * @dev add an address to the whitelist
248    * @param addr address
249    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
250    */
251   function addAddressToWhitelist(address addr)
252     onlyOwner
253     public
254   {
255     addRole(addr, ROLE_WHITELISTED);
256     emit WhitelistedAddressAdded(addr);
257   }
258 
259   /**
260    * @dev getter to determine if address is in whitelist
261    */
262   function whitelist(address addr)
263     public
264     view
265     returns (bool)
266   {
267     return hasRole(addr, ROLE_WHITELISTED);
268   }
269 
270   /**
271    * @dev add addresses to the whitelist
272    * @param addrs addresses
273    * @return true if at least one address was added to the whitelist,
274    * false if all addresses were already in the whitelist
275    */
276   function addAddressesToWhitelist(address[] addrs)
277     onlyOwner
278     public
279   {
280     for (uint256 i = 0; i < addrs.length; i++) {
281       addAddressToWhitelist(addrs[i]);
282     }
283   }
284 
285   /**
286    * @dev remove an address from the whitelist
287    * @param addr address
288    * @return true if the address was removed from the whitelist,
289    * false if the address wasn't in the whitelist in the first place
290    */
291   function removeAddressFromWhitelist(address addr)
292     onlyOwner
293     public
294   {
295     removeRole(addr, ROLE_WHITELISTED);
296     emit WhitelistedAddressRemoved(addr);
297   }
298 
299   /**
300    * @dev remove addresses from the whitelist
301    * @param addrs addresses
302    * @return true if at least one address was removed from the whitelist,
303    * false if all addresses weren't in the whitelist in the first place
304    */
305   function removeAddressesFromWhitelist(address[] addrs)
306     onlyOwner
307     public
308   {
309     for (uint256 i = 0; i < addrs.length; i++) {
310       removeAddressFromWhitelist(addrs[i]);
311     }
312   }
313 
314 }