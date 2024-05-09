1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 }
45 
46 contract RBAC {
47   using Roles for Roles.Role;
48 
49   mapping (string => Roles.Role) private roles;
50 
51   event RoleAdded(address addr, string roleName);
52   event RoleRemoved(address addr, string roleName);
53 
54   /**
55    * @dev reverts if addr does not have role
56    * @param addr address
57    * @param roleName the name of the role
58    * // reverts
59    */
60   function checkRole(address addr, string roleName)
61     view
62     public
63   {
64     roles[roleName].check(addr);
65   }
66 
67   /**
68    * @dev determine if addr has role
69    * @param addr address
70    * @param roleName the name of the role
71    * @return bool
72    */
73   function hasRole(address addr, string roleName)
74     view
75     public
76     returns (bool)
77   {
78     return roles[roleName].has(addr);
79   }
80 
81   /**
82    * @dev add a role to an address
83    * @param addr address
84    * @param roleName the name of the role
85    */
86   function addRole(address addr, string roleName)
87     internal
88   {
89     roles[roleName].add(addr);
90     emit RoleAdded(addr, roleName);
91   }
92 
93   /**
94    * @dev remove a role from an address
95    * @param addr address
96    * @param roleName the name of the role
97    */
98   function removeRole(address addr, string roleName)
99     internal
100   {
101     roles[roleName].remove(addr);
102     emit RoleRemoved(addr, roleName);
103   }
104 
105   /**
106    * @dev modifier to scope access to a single role (uses msg.sender as addr)
107    * @param roleName the name of the role
108    * // reverts
109    */
110   modifier onlyRole(string roleName)
111   {
112     checkRole(msg.sender, roleName);
113     _;
114   }
115 
116   /**
117    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
118    * @param roleNames the names of the roles to scope access to
119    * // reverts
120    *
121    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
122    *  see: https://github.com/ethereum/solidity/issues/2467
123    */
124   // modifier onlyRoles(string[] roleNames) {
125   //     bool hasAnyRole = false;
126   //     for (uint8 i = 0; i < roleNames.length; i++) {
127   //         if (hasRole(msg.sender, roleNames[i])) {
128   //             hasAnyRole = true;
129   //             break;
130   //         }
131   //     }
132 
133   //     require(hasAnyRole);
134 
135   //     _;
136   // }
137 }
138 
139 contract SaleWhitelist is Ownable, RBAC {
140     event WhitelistedAddressAdded(address addr);
141     event WhitelistedAddressRemoved(address addr);
142 
143     string public constant ROLE_CONTROLLER = "controller";
144     string public constant ROLE_WHITELISTED = "whitelist";
145 
146     Whitelist public list;
147 
148     /* constructor */
149     constructor(address whitelist) public {
150         require(whitelist != address(0));
151         list = Whitelist(whitelist);
152     }
153 
154     /* whitelist controller */
155     function setWhitelist(address addr)
156         onlyOwner
157         public
158     {
159         list = Whitelist(addr);
160     }
161 
162     /* ownership controller */
163     function addController(address addr)
164         onlyOwner
165         public
166     {
167         addRole(addr, ROLE_CONTROLLER);
168     }
169 
170     function removeController(address addr)
171         onlyOwner
172         public
173     {
174         removeRole(addr, ROLE_CONTROLLER);
175     }
176 
177     /* listing functions */
178     function whitelist(address addr)
179         public
180         view
181         returns (bool)
182     {
183         return (hasRole(addr, ROLE_WHITELISTED) || list.whitelist(addr));
184     }
185 
186     function addAddressToWhitelist(address addr)
187         onlyRole(ROLE_CONTROLLER)
188         public
189     {
190         addRole(addr, ROLE_WHITELISTED);
191         emit WhitelistedAddressAdded(addr);
192     }
193 
194     function addAddressesToWhitelist(address[] addrs)
195         onlyRole(ROLE_CONTROLLER)
196         public
197     {
198         for (uint256 i = 0; i < addrs.length; i++) {
199             addAddressToWhitelist(addrs[i]);
200         }
201     }
202 
203     function removeAddressFromWhitelist(address addr)
204         onlyRole(ROLE_CONTROLLER)
205         public
206     {
207         removeRole(addr, ROLE_WHITELISTED);
208         emit WhitelistedAddressRemoved(addr);
209     }
210 
211     function removeAddressesFromWhitelist(address[] addrs)
212         onlyRole(ROLE_CONTROLLER)
213         public
214     {
215         for (uint256 i = 0; i < addrs.length; i++) {
216             removeAddressFromWhitelist(addrs[i]);
217         }
218     }
219 }
220 
221 contract Whitelist is Ownable, RBAC {
222   event WhitelistedAddressAdded(address addr);
223   event WhitelistedAddressRemoved(address addr);
224 
225   string public constant ROLE_WHITELISTED = "whitelist";
226 
227   /**
228    * @dev Throws if called by any account that's not whitelisted.
229    */
230   modifier onlyWhitelisted() {
231     checkRole(msg.sender, ROLE_WHITELISTED);
232     _;
233   }
234 
235   /**
236    * @dev add an address to the whitelist
237    * @param addr address
238    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
239    */
240   function addAddressToWhitelist(address addr)
241     onlyOwner
242     public
243   {
244     addRole(addr, ROLE_WHITELISTED);
245     emit WhitelistedAddressAdded(addr);
246   }
247 
248   /**
249    * @dev getter to determine if address is in whitelist
250    */
251   function whitelist(address addr)
252     public
253     view
254     returns (bool)
255   {
256     return hasRole(addr, ROLE_WHITELISTED);
257   }
258 
259   /**
260    * @dev add addresses to the whitelist
261    * @param addrs addresses
262    * @return true if at least one address was added to the whitelist,
263    * false if all addresses were already in the whitelist
264    */
265   function addAddressesToWhitelist(address[] addrs)
266     onlyOwner
267     public
268   {
269     for (uint256 i = 0; i < addrs.length; i++) {
270       addAddressToWhitelist(addrs[i]);
271     }
272   }
273 
274   /**
275    * @dev remove an address from the whitelist
276    * @param addr address
277    * @return true if the address was removed from the whitelist,
278    * false if the address wasn't in the whitelist in the first place
279    */
280   function removeAddressFromWhitelist(address addr)
281     onlyOwner
282     public
283   {
284     removeRole(addr, ROLE_WHITELISTED);
285     emit WhitelistedAddressRemoved(addr);
286   }
287 
288   /**
289    * @dev remove addresses from the whitelist
290    * @param addrs addresses
291    * @return true if at least one address was removed from the whitelist,
292    * false if all addresses weren't in the whitelist in the first place
293    */
294   function removeAddressesFromWhitelist(address[] addrs)
295     onlyOwner
296     public
297   {
298     for (uint256 i = 0; i < addrs.length; i++) {
299       removeAddressFromWhitelist(addrs[i]);
300     }
301   }
302 
303 }
304 
305 library Roles {
306   struct Role {
307     mapping (address => bool) bearer;
308   }
309 
310   /**
311    * @dev give an address access to this role
312    */
313   function add(Role storage role, address addr)
314     internal
315   {
316     role.bearer[addr] = true;
317   }
318 
319   /**
320    * @dev remove an address' access to this role
321    */
322   function remove(Role storage role, address addr)
323     internal
324   {
325     role.bearer[addr] = false;
326   }
327 
328   /**
329    * @dev check if an address has this role
330    * // reverts
331    */
332   function check(Role storage role, address addr)
333     view
334     internal
335   {
336     require(has(role, addr));
337   }
338 
339   /**
340    * @dev check if an address has this role
341    * @return bool
342    */
343   function has(Role storage role, address addr)
344     view
345     internal
346     returns (bool)
347   {
348     return role.bearer[addr];
349   }
350 }