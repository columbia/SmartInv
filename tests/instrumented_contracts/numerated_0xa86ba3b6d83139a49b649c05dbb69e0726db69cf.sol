1 pragma solidity ^0.4.24;
2 
3 // File: @ensdomains/ens/contracts/ENS.sol
4 
5 interface ENS {
6 
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19 
20     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
21     function setResolver(bytes32 node, address resolver) public;
22     function setOwner(bytes32 node, address owner) public;
23     function setTTL(bytes32 node, uint64 ttl) public;
24     function owner(bytes32 node) public view returns (address);
25     function resolver(bytes32 node) public view returns (address);
26     function ttl(bytes32 node) public view returns (uint64);
27 
28 }
29 
30 // File: contracts/Roles.sol
31 
32 /**
33  * @title Roles
34  * @author Francisco Giordano (@frangio)
35  * @dev Library for managing addresses assigned to a Role.
36  * See RBAC.sol for example usage.
37  */
38 library Roles {
39   struct Role {
40     mapping (address => bool) bearer;
41   }
42 
43   /**
44    * @dev give an account access to this role
45    */
46   function add(Role storage _role, address _account)
47     internal
48   {
49     _role.bearer[_account] = true;
50   }
51 
52   /**
53    * @dev remove an account's access to this role
54    */
55   function remove(Role storage _role, address _account)
56     internal
57   {
58     _role.bearer[_account] = false;
59   }
60 
61   /**
62    * @dev check if an account has this role
63    * // reverts
64    */
65   function check(Role storage _role, address _account)
66     internal
67     view
68   {
69     require(has(_role, _account));
70   }
71 
72   /**
73    * @dev check if an account has this role
74    * @return bool
75    */
76   function has(Role storage _role, address _account)
77     internal
78     view
79     returns (bool)
80   {
81     return _role.bearer[_account];
82   }
83 }
84 
85 // File: contracts/RBAC.sol
86 
87 /**
88  * @title RBAC (Role-Based Access Control)
89  * @author Matt Condon (@Shrugs)
90  * @dev Stores and provides setters and getters for roles and addresses.
91  * Supports unlimited numbers of roles and addresses.
92  * See //contracts/mocks/RBACMock.sol for an example of usage.
93  * This RBAC method uses strings to key roles. It may be beneficial
94  * for you to write your own implementation of this interface using Enums or similar.
95  */
96 contract RBAC {
97   using Roles for Roles.Role;
98 
99   mapping (string => Roles.Role) private roles;
100 
101   event RoleAdded(address indexed operator, string role);
102   event RoleRemoved(address indexed operator, string role);
103 
104   /**
105    * @dev reverts if addr does not have role
106    * @param _operator address
107    * @param _role the name of the role
108    * // reverts
109    */
110   function checkRole(address _operator, string _role)
111     public
112     view
113   {
114     roles[_role].check(_operator);
115   }
116 
117   /**
118    * @dev determine if addr has role
119    * @param _operator address
120    * @param _role the name of the role
121    * @return bool
122    */
123   function hasRole(address _operator, string _role)
124     public
125     view
126     returns (bool)
127   {
128     return roles[_role].has(_operator);
129   }
130 
131   /**
132    * @dev add a role to an address
133    * @param _operator address
134    * @param _role the name of the role
135    */
136   function _addRole(address _operator, string _role)
137     internal
138   {
139     roles[_role].add(_operator);
140     emit RoleAdded(_operator, _role);
141   }
142 
143   /**
144    * @dev remove a role from an address
145    * @param _operator address
146    * @param _role the name of the role
147    */
148   function _removeRole(address _operator, string _role)
149     internal
150   {
151     roles[_role].remove(_operator);
152     emit RoleRemoved(_operator, _role);
153   }
154 
155   /**
156    * @dev modifier to scope access to a single role (uses msg.sender as addr)
157    * @param _role the name of the role
158    * // reverts
159    */
160   modifier onlyRole(string _role)
161   {
162     checkRole(msg.sender, _role);
163     _;
164   }
165 
166   /**
167    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
168    * @param _roles the names of the roles to scope access to
169    * // reverts
170    *
171    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
172    *  see: https://github.com/ethereum/solidity/issues/2467
173    */
174   // modifier onlyRoles(string[] _roles) {
175   //     bool hasAnyRole = false;
176   //     for (uint8 i = 0; i < _roles.length; i++) {
177   //         if (hasRole(msg.sender, _roles[i])) {
178   //             hasAnyRole = true;
179   //             break;
180   //         }
181   //     }
182 
183   //     require(hasAnyRole);
184 
185   //     _;
186   // }
187 }
188 
189 // File: contracts/OwnerResolver.sol
190 
191 contract OwnerResolver {
192     ENS public ens;
193 
194     constructor(ENS _ens) public {
195         ens = _ens;
196     }
197 
198     function addr(bytes32 node) public view returns(address) {
199         return ens.owner(node);
200     }
201 
202     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
203         return interfaceID == 0x01ffc9a7 || interfaceID == 0x3b3b57de;
204     }
205 }
206 
207 // File: contracts/OwnedRegistrar.sol
208 
209 pragma experimental ABIEncoderV2;
210 
211 
212 
213 
214 /**
215  * OwnedRegistrar implements an ENS registrar that accepts registrations by a
216  * list of approved parties (IANA registrars). Registrations must be submitted
217  * by a "transactor", and signed by a "registrar". Registrars can be added or
218  * removed by an account with the "authoriser" role.
219  *
220  * An audit of this code is available here: https://hackmd.io/s/SJcPchO57
221  */
222 contract OwnedRegistrar is RBAC {
223     ENS public ens;
224     OwnerResolver public resolver;
225     mapping(uint=>mapping(address=>bool)) public registrars; // Maps IANA IDs to authorised accounts
226     mapping(bytes32=>uint) public nonces; // Maps namehashes to domain nonces
227 
228     event RegistrarAdded(uint id, address registrar);
229     event RegistrarRemoved(uint id, address registrar);
230     event Associate(bytes32 indexed node, bytes32 indexed subnode, address indexed owner);
231     event Disassociate(bytes32 indexed node, bytes32 indexed subnode);
232 
233     constructor(ENS _ens) public {
234         ens = _ens;
235         resolver = new OwnerResolver(_ens);
236         _addRole(msg.sender, "owner");
237     }
238 
239     function addRole(address addr, string role) external onlyRole("owner") {
240         _addRole(addr, role);
241     }
242 
243     function removeRole(address addr, string role) external onlyRole("owner") {
244         // Don't allow owners to remove themselves
245         require(keccak256(abi.encode(role)) != keccak256(abi.encode("owner")) || msg.sender != addr);
246         _removeRole(addr, role);
247     }
248 
249     function setRegistrar(uint id, address registrar) public onlyRole("authoriser") {
250         registrars[id][registrar] = true;
251         emit RegistrarAdded(id, registrar);
252     }
253 
254     function unsetRegistrar(uint id, address registrar) public onlyRole("authoriser") {
255         registrars[id][registrar] = false;
256         emit RegistrarRemoved(id, registrar);
257     }
258 
259     function associateWithSig(bytes32 node, bytes32 label, address owner, uint nonce, uint registrarId, bytes32 r, bytes32 s, uint8 v) public onlyRole("transactor") {
260         bytes32 subnode = keccak256(abi.encode(node, label));
261         require(nonce == nonces[subnode]);
262         nonces[subnode]++;
263 
264         bytes32 sighash = keccak256(abi.encode(subnode, owner, nonce));
265         address registrar = ecrecover(sighash, v, r, s);
266         require(registrars[registrarId][registrar]);
267 
268         ens.setSubnodeOwner(node, label, address(this));
269         if(owner == 0) {
270             ens.setResolver(subnode, 0);
271         } else {
272             ens.setResolver(subnode, resolver);
273         }
274         ens.setOwner(subnode, owner);
275 
276         emit Associate(node, label, owner);
277     }
278 
279     function multicall(bytes[] calls) public {
280         for(uint i = 0; i < calls.length; i++) {
281             require(address(this).delegatecall(calls[i]));
282         }
283     }
284 }