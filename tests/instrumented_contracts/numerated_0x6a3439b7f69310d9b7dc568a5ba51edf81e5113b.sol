1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract RBAC {
58   using Roles for Roles.Role;
59 
60   mapping (string => Roles.Role) private roles;
61 
62   event RoleAdded(address addr, string roleName);
63   event RoleRemoved(address addr, string roleName);
64 
65   /**
66    * @dev reverts if addr does not have role
67    * @param addr address
68    * @param roleName the name of the role
69    * // reverts
70    */
71   function checkRole(address addr, string roleName)
72     view
73     public
74   {
75     roles[roleName].check(addr);
76   }
77 
78   /**
79    * @dev determine if addr has role
80    * @param addr address
81    * @param roleName the name of the role
82    * @return bool
83    */
84   function hasRole(address addr, string roleName)
85     view
86     public
87     returns (bool)
88   {
89     return roles[roleName].has(addr);
90   }
91 
92   /**
93    * @dev add a role to an address
94    * @param addr address
95    * @param roleName the name of the role
96    */
97   function addRole(address addr, string roleName)
98     internal
99   {
100     roles[roleName].add(addr);
101     emit RoleAdded(addr, roleName);
102   }
103 
104   /**
105    * @dev remove a role from an address
106    * @param addr address
107    * @param roleName the name of the role
108    */
109   function removeRole(address addr, string roleName)
110     internal
111   {
112     roles[roleName].remove(addr);
113     emit RoleRemoved(addr, roleName);
114   }
115 
116   /**
117    * @dev modifier to scope access to a single role (uses msg.sender as addr)
118    * @param roleName the name of the role
119    * // reverts
120    */
121   modifier onlyRole(string roleName)
122   {
123     checkRole(msg.sender, roleName);
124     _;
125   }
126 
127   /**
128    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
129    * @param roleNames the names of the roles to scope access to
130    * // reverts
131    *
132    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
133    *  see: https://github.com/ethereum/solidity/issues/2467
134    */
135   // modifier onlyRoles(string[] roleNames) {
136   //     bool hasAnyRole = false;
137   //     for (uint8 i = 0; i < roleNames.length; i++) {
138   //         if (hasRole(msg.sender, roleNames[i])) {
139   //             hasAnyRole = true;
140   //             break;
141   //         }
142   //     }
143 
144   //     require(hasAnyRole);
145 
146   //     _;
147   // }
148 }
149 
150 contract Whitelist is Ownable, RBAC {
151   event WhitelistedAddressAdded(address addr);
152   event WhitelistedAddressRemoved(address addr);
153 
154   string public constant ROLE_WHITELISTED = "whitelist";
155 
156   /**
157    * @dev Throws if called by any account that's not whitelisted.
158    */
159   modifier onlyWhitelisted() {
160     checkRole(msg.sender, ROLE_WHITELISTED);
161     _;
162   }
163 
164   /**
165    * @dev add an address to the whitelist
166    * @param addr address
167    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
168    */
169   function addAddressToWhitelist(address addr)
170     onlyOwner
171     public
172   {
173     addRole(addr, ROLE_WHITELISTED);
174     emit WhitelistedAddressAdded(addr);
175   }
176 
177   /**
178    * @dev getter to determine if address is in whitelist
179    */
180   function whitelist(address addr)
181     public
182     view
183     returns (bool)
184   {
185     return hasRole(addr, ROLE_WHITELISTED);
186   }
187 
188   /**
189    * @dev add addresses to the whitelist
190    * @param addrs addresses
191    * @return true if at least one address was added to the whitelist,
192    * false if all addresses were already in the whitelist
193    */
194   function addAddressesToWhitelist(address[] addrs)
195     onlyOwner
196     public
197   {
198     for (uint256 i = 0; i < addrs.length; i++) {
199       addAddressToWhitelist(addrs[i]);
200     }
201   }
202 
203   /**
204    * @dev remove an address from the whitelist
205    * @param addr address
206    * @return true if the address was removed from the whitelist,
207    * false if the address wasn't in the whitelist in the first place
208    */
209   function removeAddressFromWhitelist(address addr)
210     onlyOwner
211     public
212   {
213     removeRole(addr, ROLE_WHITELISTED);
214     emit WhitelistedAddressRemoved(addr);
215   }
216 
217   /**
218    * @dev remove addresses from the whitelist
219    * @param addrs addresses
220    * @return true if at least one address was removed from the whitelist,
221    * false if all addresses weren't in the whitelist in the first place
222    */
223   function removeAddressesFromWhitelist(address[] addrs)
224     onlyOwner
225     public
226   {
227     for (uint256 i = 0; i < addrs.length; i++) {
228       removeAddressFromWhitelist(addrs[i]);
229     }
230   }
231 
232 }
233 
234 library Roles {
235   struct Role {
236     mapping (address => bool) bearer;
237   }
238 
239   /**
240    * @dev give an address access to this role
241    */
242   function add(Role storage role, address addr)
243     internal
244   {
245     role.bearer[addr] = true;
246   }
247 
248   /**
249    * @dev remove an address' access to this role
250    */
251   function remove(Role storage role, address addr)
252     internal
253   {
254     role.bearer[addr] = false;
255   }
256 
257   /**
258    * @dev check if an address has this role
259    * // reverts
260    */
261   function check(Role storage role, address addr)
262     view
263     internal
264   {
265     require(has(role, addr));
266   }
267 
268   /**
269    * @dev check if an address has this role
270    * @return bool
271    */
272   function has(Role storage role, address addr)
273     view
274     internal
275     returns (bool)
276   {
277     return role.bearer[addr];
278   }
279 }