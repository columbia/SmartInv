1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC780.sol
4 
5 /// @title ERC780
6 /// @notice The ERC780 interface for storing and interacting with claims.
7 /// See https://github.com/ethereum/EIPs/issues/780
8 contract ERC780 {
9     function setClaim(address subject, bytes32 key, bytes32 value) public;
10     function setSelfClaim(bytes32 key, bytes32 value) public;
11     function getClaim(address issuer, address subject, bytes32 key) public view returns (bytes32);
12     function removeClaim(address issuer, address subject, bytes32 key) public;
13 }
14 
15 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 // File: contracts/RBACInterface.sol
58 
59 /// @title RBACInterface
60 /// @notice The interface for Role-Based Access Control.
61 contract RBACInterface {
62     function hasRole(address addr, string role) public view returns (bool);
63 }
64 
65 // File: contracts/RBACManaged.sol
66 
67 /// @title RBACManaged
68 /// @notice Controls access by delegating to a deployed RBAC contract.
69 contract RBACManaged is Ownable {
70 
71     RBACInterface public rbac;
72 
73     /// @param rbacAddr The address of the RBAC contract which controls access.
74     constructor(address rbacAddr) public {
75         rbac = RBACInterface(rbacAddr);
76     }
77 
78     function roleAdmin() internal pure returns (string);
79 
80     /// @notice Check if an address has a role.
81     /// @param addr The address.
82     /// @param role The role.
83     /// @return A boolean indicating whether the address has the role.
84     function hasRole(address addr, string role) public view returns (bool) {
85         return rbac.hasRole(addr, role);
86     }
87 
88     modifier onlyRole(string role) {
89         require(hasRole(msg.sender, role), "Access denied: missing role");
90         _;
91     }
92 
93     modifier onlyOwnerOrAdmin() {
94         require(
95             msg.sender == owner || hasRole(msg.sender, roleAdmin()), "Access denied: missing role");
96         _;
97     }
98 
99     /// @notice Change the address of the deployed RBAC contract which
100     /// controls access. Only the owner or an admin can change the address.
101     /// @param rbacAddr The address of the RBAC contract which controls access.
102     function setRBACAddress(address rbacAddr) public onlyOwnerOrAdmin {
103         rbac = RBACInterface(rbacAddr);
104     }
105 }
106 
107 // File: contracts/UserAddressAliasable.sol
108 
109 /// @title UserAddressAliasable
110 /// @notice Allows the address that represents an entity (individual) to be
111 /// changed by setting aliases. Any data about an entity should be associated
112 /// to the original (canonical) address.
113 contract UserAddressAliasable is RBACManaged {
114 
115     event UserAddressAliased(address indexed oldAddr, address indexed newAddr);
116 
117     mapping(address => address) addressAlias;  // canonical => alias
118 
119     function roleAddressAliaser() internal pure returns (string);
120 
121     /// @notice Alias a new address to an old address. Requires caller to have
122     /// the address aliaser role returned by roleAddressAliaser(). Requires
123     /// that neither address is already aliased to another address.
124     /// @param oldAddr The old address.
125     /// @param newAddr The new address.
126     function setAddressAlias(address oldAddr, address newAddr) public onlyRole(roleAddressAliaser()) {
127         require(addressAlias[oldAddr] == address(0), "oldAddr is already aliased to another address");
128         require(addressAlias[newAddr] == address(0), "newAddr is already aliased to another address");
129         require(oldAddr != newAddr, "oldAddr and newAddr must be different");
130         setAddressAliasUnsafe(oldAddr, newAddr);
131     }
132 
133     /// @notice Alias a new address to an old address, bypassing all safety
134     /// checks. Can result in broken state, so use at your own peril. Requires
135     /// caller to have the address aliaser role returned by
136     /// roleAddressAliaser().
137     /// @param oldAddr The old address.
138     /// @param newAddr The new address.
139     function setAddressAliasUnsafe(address oldAddr, address newAddr) public onlyRole(roleAddressAliaser()) {
140         addressAlias[newAddr] = oldAddr;
141         emit UserAddressAliased(oldAddr, newAddr);
142     }
143 
144     /// @notice Change an address to no longer alias to anything else. Calling
145     /// setAddressAlias(oldAddr, newAddr) is reversed by calling
146     /// unsetAddressAlias(newAddr).
147     /// @param addr The address to unalias. Equivalent to newAddr in setAddressAlias.
148     function unsetAddressAlias(address addr) public onlyRole(roleAddressAliaser()) {
149         setAddressAliasUnsafe(0, addr);
150     }
151 
152     /// @notice Resolve an address to its canonical address.
153     /// @param addr The address to resolve.
154     /// @return The canonical address.
155     function resolveAddress(address addr) public view returns (address) {
156         address parentAddr = addressAlias[addr];
157         if (parentAddr == address(0)) {
158             return addr;
159         } else {
160             return parentAddr;
161         }
162     }
163 }
164 
165 // File: contracts/ODEMClaimsRegistry.sol
166 
167 /// @title ODEMClaimsRegistry
168 /// @notice When an individual completes an event (educational course) with
169 /// ODEM, ODEM generates a certificate of completion and sets a corresponding
170 /// claim in this contract. The claim contains the URI (usually an IPFS path)
171 /// where the certificate can be downloaded, and its hash (SHA-256) to prove its
172 /// authenticity.
173 /// If an individual changes their Ethereum address, for example if they lose
174 /// access to their account, ODEM may alias the new address to the old
175 /// address. Then claims apply automatically to both addresses.
176 /// Implements the ERC780 interface.
177 contract ODEMClaimsRegistry is RBACManaged, UserAddressAliasable, ERC780 {
178 
179     event ClaimSet(
180         address indexed issuer,
181         address indexed subject,
182         bytes32 indexed key,
183         bytes32 value,
184         uint updatedAt
185     );
186     event ClaimRemoved(
187         address indexed issuer,
188         address indexed subject,
189         bytes32 indexed key,
190         uint removedAt
191     );
192 
193     string constant ROLE_ADMIN = "claims__admin";
194     string constant ROLE_ISSUER = "claims__issuer";
195     string constant ROLE_ADDRESS_ALIASER = "claims__address_aliaser";
196 
197     struct Claim {
198         bytes uri;
199         bytes32 hash;
200     }
201 
202     mapping(address => mapping(bytes32 => Claim)) internal claims;  // subject => key => claim
203 
204     // Used for safe address aliasing. Never reset to false.
205     mapping(address => bool) internal hasClaims;
206 
207     /// @param rbacAddr The address of the RBAC contract which controls access to this
208     /// contract.
209     constructor(address rbacAddr) RBACManaged(rbacAddr) public {}
210 
211     /// @notice Get an ODEM claim.
212     /// @param subject The address of the individual.
213     /// @param key The ODEM event code.
214     /// @return The URI where the certificate can be downloaded, and the hash
215     /// of the certificate file.
216     function getODEMClaim(address subject, bytes32 key) public view returns (bytes uri, bytes32 hash) {
217         address resolved = resolveAddress(subject);
218         return (claims[resolved][key].uri, claims[resolved][key].hash);
219     }
220 
221     /// @notice Set an ODEM claim.
222     /// Only ODEM can set claims.
223     /// @dev Requires caller to have the role "claims__issuer".
224     /// @param subject The address of the individual.
225     /// @param key The ODEM event code.
226     /// @param uri The URI where the certificate can be downloaded.
227     /// @param hash The hash of the certificate file.
228     function setODEMClaim(address subject, bytes32 key, bytes uri, bytes32 hash) public onlyRole(ROLE_ISSUER) {
229         address resolved = resolveAddress(subject);
230         claims[resolved][key].uri = uri;
231         claims[resolved][key].hash = hash;
232         hasClaims[resolved] = true;
233         emit ClaimSet(msg.sender, subject, key, hash, now);
234     }
235 
236     /// @notice Remove an ODEM claim. Anyone can remove a claim about
237     /// themselves.
238     /// Only ODEM can remove claims about others.
239     /// @dev Requires caller to have the role "claims__issuer" or to be the
240     /// subject.
241     /// @param subject The address of the individual.
242     /// @param key The ODEM event code.
243     function removeODEMClaim(address subject, bytes32 key) public {
244         require(hasRole(msg.sender, ROLE_ISSUER) || msg.sender == subject, "Access denied: missing role");
245         address resolved = resolveAddress(subject);
246         delete claims[resolved][key];
247         emit ClaimRemoved(msg.sender, subject, key, now);
248     }
249 
250     /// @notice Alias a new address to an old address.
251     /// Only ODEM can set aliases.
252     /// @dev Requires caller to have the role "claims__address_aliaser".
253     /// Requires that neither address is already aliased to another address,
254     /// and that the new address does not already have claims.
255     /// @param oldAddr The old address.
256     /// @param newAddr The new address.
257     function setAddressAlias(address oldAddr, address newAddr) public onlyRole(ROLE_ADDRESS_ALIASER) {
258         require(!hasClaims[newAddr], "newAddr already has claims");
259         super.setAddressAlias(oldAddr, newAddr);
260     }
261 
262     /// @notice Get a claim. Provided for compatibility with ERC780.
263     /// Only gets claims where the issuer is ODEM.
264     /// @param issuer The address which set the claim.
265     /// @param subject The address of the individual.
266     /// @param key The ODEM event code.
267     /// @return The hash of the certificate file.
268     function getClaim(address issuer, address subject, bytes32 key) public view returns (bytes32) {
269         if (hasRole(issuer, ROLE_ISSUER)) {
270             return claims[subject][key].hash;
271         } else {
272             return bytes32(0);
273         }
274     }
275 
276     /// @notice Provided for compatibility with ERC780. Always fails.
277     function setClaim(address subject, bytes32 key, bytes32 value) public {
278         revert();
279     }
280 
281     /// @notice Provided for compatibility with ERC780. Always fails.
282     function setSelfClaim(bytes32 key, bytes32 value) public {
283         revert();
284     }
285 
286     /// @notice Remove a claim. Provided for compatibility with ERC780.
287     /// Only removes claims where the issuer is ODEM.
288     /// Anyone can remove a claim about themselves. Only ODEM can remove
289     /// claims about others.
290     /// @dev Requires issuer to have the role "claims__issuer".
291     /// Requires caller to have the role "claims__issuer" or to be the
292     /// subject.
293     /// @param issuer The address which set the claim.
294     /// @param subject The address of the individual.
295     /// @param key The ODEM event code.
296     function removeClaim(address issuer, address subject, bytes32 key) public {
297         require(hasRole(issuer, ROLE_ISSUER), "Issuer not recognized");
298         removeODEMClaim(subject, key);
299     }
300 
301     // Required by RBACManaged.
302     function roleAdmin() internal pure returns (string) {
303         return ROLE_ADMIN;
304     }
305 
306     // Required by UserAddressAliasable
307     function roleAddressAliaser() internal pure returns (string) {
308         return ROLE_ADDRESS_ALIASER;
309     }
310 }