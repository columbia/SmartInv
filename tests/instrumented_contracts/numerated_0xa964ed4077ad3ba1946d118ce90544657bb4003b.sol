1 // File: contracts/RegistrarInterface.sol
2 
3 pragma solidity ^0.5.0;
4 
5 interface RegistrarInterface {
6 
7     event Registration(string name, address owner, address addr);
8 
9     function register(string calldata name, address owner, bytes calldata signature) external;
10     function hash(string calldata name, address owner) external pure returns (bytes32);
11 }
12 
13 // File: contracts/Libraries/SignatureValidator.sol
14 
15 pragma solidity ^0.5.0;
16 
17 library SignatureValidator {
18 
19     /// @dev Validates that a hash was signed by a specified signer.
20     /// @param hash Hash which was signed.
21     /// @param signature ECDSA signature {v}{r}{s}.
22     /// @return Returns whether signature is from a specified user.
23     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
24         require(signature.length == 65);
25 
26         uint8 v = uint8(signature[64]);
27         bytes32 r;
28         bytes32 s;
29         assembly {
30             r := mload(add(signature, 32))
31             s := mload(add(signature, 64))
32         }
33 
34         return ecrecover(hash, v, r, s);
35     }
36 }
37 
38 // File: @ensdomains/ens/contracts/ENS.sol
39 
40 pragma solidity >=0.4.24;
41 
42 interface ENS {
43 
44     // Logged when the owner of a node assigns a new owner to a subnode.
45     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
46 
47     // Logged when the owner of a node transfers ownership to a new account.
48     event Transfer(bytes32 indexed node, address owner);
49 
50     // Logged when the resolver for a node changes.
51     event NewResolver(bytes32 indexed node, address resolver);
52 
53     // Logged when the TTL of a node changes
54     event NewTTL(bytes32 indexed node, uint64 ttl);
55 
56 
57     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
58     function setResolver(bytes32 node, address resolver) external;
59     function setOwner(bytes32 node, address owner) external;
60     function setTTL(bytes32 node, uint64 ttl) external;
61     function owner(bytes32 node) external view returns (address);
62     function resolver(bytes32 node) external view returns (address);
63     function ttl(bytes32 node) external view returns (uint64);
64 
65 }
66 
67 // File: @ensdomains/resolver/contracts/PublicResolver.sol
68 
69 pragma solidity >=0.4.25;
70 
71 
72 /**
73  * A simple resolver anyone can use; only allows the owner of a node to set its
74  * address.
75  */
76 contract PublicResolver {
77 
78     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
79     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
80     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
81     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
82     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
83     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
84     bytes4 constant CONTENTHASH_INTERFACE_ID = 0xbc1c58d1;
85 
86     event AddrChanged(bytes32 indexed node, address a);
87     event NameChanged(bytes32 indexed node, string name);
88     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
89     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
90     event TextChanged(bytes32 indexed node, string indexedKey, string key);
91     event ContenthashChanged(bytes32 indexed node, bytes hash);
92 
93     struct PublicKey {
94         bytes32 x;
95         bytes32 y;
96     }
97 
98     struct Record {
99         address addr;
100         string name;
101         PublicKey pubkey;
102         mapping(string=>string) text;
103         mapping(uint256=>bytes) abis;
104         bytes contenthash;
105     }
106 
107     ENS ens;
108 
109     mapping (bytes32 => Record) records;
110 
111     modifier onlyOwner(bytes32 node) {
112         require(ens.owner(node) == msg.sender);
113         _;
114     }
115 
116     /**
117      * Constructor.
118      * @param ensAddr The ENS registrar contract.
119      */
120     constructor(ENS ensAddr) public {
121         ens = ensAddr;
122     }
123 
124     /**
125      * Sets the address associated with an ENS node.
126      * May only be called by the owner of that node in the ENS registry.
127      * @param node The node to update.
128      * @param addr The address to set.
129      */
130     function setAddr(bytes32 node, address addr) external onlyOwner(node) {
131         records[node].addr = addr;
132         emit AddrChanged(node, addr);
133     }
134 
135     /**
136      * Sets the contenthash associated with an ENS node.
137      * May only be called by the owner of that node in the ENS registry.
138      * @param node The node to update.
139      * @param hash The contenthash to set
140      */
141     function setContenthash(bytes32 node, bytes calldata hash) external onlyOwner(node) {
142         records[node].contenthash = hash;
143         emit ContenthashChanged(node, hash);
144     }
145 
146     /**
147      * Sets the name associated with an ENS node, for reverse records.
148      * May only be called by the owner of that node in the ENS registry.
149      * @param node The node to update.
150      * @param name The name to set.
151      */
152     function setName(bytes32 node, string calldata name) external onlyOwner(node) {
153         records[node].name = name;
154         emit NameChanged(node, name);
155     }
156 
157     /**
158      * Sets the ABI associated with an ENS node.
159      * Nodes may have one ABI of each content type. To remove an ABI, set it to
160      * the empty string.
161      * @param node The node to update.
162      * @param contentType The content type of the ABI
163      * @param data The ABI data.
164      */
165     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external onlyOwner(node) {
166         // Content types must be powers of 2
167         require(((contentType - 1) & contentType) == 0);
168 
169         records[node].abis[contentType] = data;
170         emit ABIChanged(node, contentType);
171     }
172 
173     /**
174      * Sets the SECP256k1 public key associated with an ENS node.
175      * @param node The ENS node to query
176      * @param x the X coordinate of the curve point for the public key.
177      * @param y the Y coordinate of the curve point for the public key.
178      */
179     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external onlyOwner(node) {
180         records[node].pubkey = PublicKey(x, y);
181         emit PubkeyChanged(node, x, y);
182     }
183 
184     /**
185      * Sets the text data associated with an ENS node and key.
186      * May only be called by the owner of that node in the ENS registry.
187      * @param node The node to update.
188      * @param key The key to set.
189      * @param value The text data value to set.
190      */
191     function setText(bytes32 node, string calldata key, string calldata value) external onlyOwner(node) {
192         records[node].text[key] = value;
193         emit TextChanged(node, key, key);
194     }
195 
196     /**
197      * Returns the text data associated with an ENS node and key.
198      * @param node The ENS node to query.
199      * @param key The text data key to query.
200      * @return The associated text data.
201      */
202     function text(bytes32 node, string calldata key) external view returns (string memory) {
203         return records[node].text[key];
204     }
205 
206     /**
207      * Returns the SECP256k1 public key associated with an ENS node.
208      * Defined in EIP 619.
209      * @param node The ENS node to query
210      * @return x, y the X and Y coordinates of the curve point for the public key.
211      */
212     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
213         return (records[node].pubkey.x, records[node].pubkey.y);
214     }
215 
216     /**
217      * Returns the ABI associated with an ENS node.
218      * Defined in EIP205.
219      * @param node The ENS node to query
220      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
221      * @return contentType The content type of the return value
222      * @return data The ABI data
223      */
224     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
225         Record storage record = records[node];
226 
227         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
228             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
229                 return (contentType, record.abis[contentType]);
230             }
231         }
232 
233         bytes memory empty;
234         return (0, empty);
235     }
236 
237     /**
238      * Returns the name associated with an ENS node, for reverse records.
239      * Defined in EIP181.
240      * @param node The ENS node to query.
241      * @return The associated name.
242      */
243     function name(bytes32 node) external view returns (string memory) {
244         return records[node].name;
245     }
246 
247     /**
248      * Returns the address associated with an ENS node.
249      * @param node The ENS node to query.
250      * @return The associated address.
251      */
252     function addr(bytes32 node) external view returns (address) {
253         return records[node].addr;
254     }
255 
256     /**
257      * Returns the contenthash associated with an ENS node.
258      * @param node The ENS node to query.
259      * @return The associated contenthash.
260      */
261     function contenthash(bytes32 node) external view returns (bytes memory) {
262         return records[node].contenthash;
263     }
264 
265     /**
266      * Returns true if the resolver implements the interface specified by the provided hash.
267      * @param interfaceID The ID of the interface to check for.
268      * @return True if the contract implements the requested interface.
269      */
270     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
271         return interfaceID == ADDR_INTERFACE_ID ||
272         interfaceID == NAME_INTERFACE_ID ||
273         interfaceID == ABI_INTERFACE_ID ||
274         interfaceID == PUBKEY_INTERFACE_ID ||
275         interfaceID == TEXT_INTERFACE_ID ||
276         interfaceID == CONTENTHASH_INTERFACE_ID ||
277         interfaceID == INTERFACE_META_ID;
278     }
279 }
280 
281 // File: contracts/Registrar.sol
282 
283 pragma solidity ^0.5.0;
284 
285 
286 
287 
288 
289 contract Registrar is RegistrarInterface {
290 
291     ENS public ens;
292     bytes32 public node;
293     PublicResolver public resolver;
294 
295     constructor(ENS _ens, bytes32 _node, PublicResolver _resolver) public {
296         ens = _ens;
297         node = _node;
298         resolver = _resolver;
299     }
300 
301     function register(string calldata name, address owner, bytes calldata signature) external {
302         address token = SignatureValidator.recover(_hash(name, owner), signature);
303 
304         bytes32 label = keccak256(bytes(name));
305         bytes32 subnode = keccak256(abi.encodePacked(node, label));
306 
307         // Create the subdomain and assign it to us.
308         ens.setSubnodeOwner(node, label, address(this));
309 
310         // Set a resolver
311         ens.setResolver(subnode, address(resolver));
312 
313         // Set the resolver's addr record to the new owner
314         resolver.setAddr(subnode, owner);
315 
316         // Transfer ownership of the subdomain to the new owner.
317         ens.setOwner(subnode, owner);
318 
319         emit Registration(name, owner, token);
320     }
321 
322     function hash(string calldata name, address owner) external pure returns (bytes32) {
323         return _hash(name, owner);
324     }
325 
326     function _hash(string memory name, address owner) internal pure returns (bytes32) {
327         return keccak256(abi.encodePacked(name, owner));
328     }
329 }