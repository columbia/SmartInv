1 pragma solidity ^0.4.21;
2 
3 
4 interface SvEns {
5     // Logged when the owner of a node assigns a new owner to a subnode.
6     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
7 
8     // Logged when the owner of a node transfers ownership to a new account.
9     event Transfer(bytes32 indexed node, address owner);
10 
11     // Logged when the resolver for a node changes.
12     event NewResolver(bytes32 indexed node, address resolver);
13 
14     // Logged when the TTL of a node changes
15     event NewTTL(bytes32 indexed node, uint64 ttl);
16 
17 
18     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
19     function setResolver(bytes32 node, address resolver) external;
20     function setOwner(bytes32 node, address owner) external;
21     function setTTL(bytes32 node, uint64 ttl) external;
22     function owner(bytes32 node) external view returns (address);
23     function resolver(bytes32 node) external view returns (address);
24     function ttl(bytes32 node) external view returns (uint64);
25 }
26 
27 
28 interface ENS {
29     // Logged when the owner of a node assigns a new owner to a subnode.
30     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
31 
32     // Logged when the owner of a node transfers ownership to a new account.
33     event Transfer(bytes32 indexed node, address owner);
34 
35     // Logged when the resolver for a node changes.
36     event NewResolver(bytes32 indexed node, address resolver);
37 
38     // Logged when the TTL of a node changes
39     event NewTTL(bytes32 indexed node, uint64 ttl);
40 
41 
42     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
43     function setResolver(bytes32 node, address resolver) external;
44     function setOwner(bytes32 node, address owner) external;
45     function setTTL(bytes32 node, uint64 ttl) external;
46     function owner(bytes32 node) external view returns (address);
47     function resolver(bytes32 node) external view returns (address);
48     function ttl(bytes32 node) external view returns (uint64);
49 }
50 
51 
52 contract SvEnsRegistry is SvEns {
53     struct Record {
54         address owner;
55         address resolver;
56         uint64 ttl;
57     }
58 
59     mapping (bytes32 => Record) records;
60 
61     // Permits modifications only by the owner of the specified node.
62     modifier only_owner(bytes32 node) {
63         require(records[node].owner == msg.sender);
64         _;
65     }
66 
67     /**
68      * @dev Constructs a new ENS registrar.
69      */
70     function SvEnsRegistry() public {
71         records[0x0].owner = msg.sender;
72     }
73 
74     /**
75      * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
76      * @param node The node to transfer ownership of.
77      * @param owner The address of the new owner.
78      */
79     function setOwner(bytes32 node, address owner) external only_owner(node) {
80         emit Transfer(node, owner);
81         records[node].owner = owner;
82     }
83 
84     /**
85      * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
86      * @param node The parent node.
87      * @param label The hash of the label specifying the subnode.
88      * @param owner The address of the new owner.
89      */
90     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external only_owner(node) returns (bytes32) {
91         bytes32 subnode = keccak256(node, label);
92         emit NewOwner(node, label, owner);
93         records[subnode].owner = owner;
94         return subnode;
95     }
96 
97     /**
98      * @dev Sets the resolver address for the specified node.
99      * @param node The node to update.
100      * @param resolver The address of the resolver.
101      */
102     function setResolver(bytes32 node, address resolver) external only_owner(node) {
103         emit NewResolver(node, resolver);
104         records[node].resolver = resolver;
105     }
106 
107     /**
108      * @dev Sets the TTL for the specified node.
109      * @param node The node to update.
110      * @param ttl The TTL in seconds.
111      */
112     function setTTL(bytes32 node, uint64 ttl) external only_owner(node) {
113         emit NewTTL(node, ttl);
114         records[node].ttl = ttl;
115     }
116 
117     /**
118      * @dev Returns the address that owns the specified node.
119      * @param node The specified node.
120      * @return address of the owner.
121      */
122     function owner(bytes32 node) external view returns (address) {
123         return records[node].owner;
124     }
125 
126     /**
127      * @dev Returns the address of the resolver for the specified node.
128      * @param node The specified node.
129      * @return address of the resolver.
130      */
131     function resolver(bytes32 node) external view returns (address) {
132         return records[node].resolver;
133     }
134 
135     /**
136      * @dev Returns the TTL of a node, and any records associated with it.
137      * @param node The specified node.
138      * @return ttl of the node.
139      */
140     function ttl(bytes32 node) external view returns (uint64) {
141         return records[node].ttl;
142     }
143 
144 }
145 
146 contract PublicResolver {
147 
148     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
149     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
150     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
151     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
152     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
153     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
154     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
155 
156     event AddrChanged(bytes32 indexed node, address a);
157     event ContentChanged(bytes32 indexed node, bytes32 hash);
158     event NameChanged(bytes32 indexed node, string name);
159     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
160     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
161     event TextChanged(bytes32 indexed node, string indexedKey, string key);
162 
163     struct PublicKey {
164         bytes32 x;
165         bytes32 y;
166     }
167 
168     struct Record {
169         address addr;
170         bytes32 content;
171         string name;
172         PublicKey pubkey;
173         mapping(string=>string) text;
174         mapping(uint256=>bytes) abis;
175     }
176 
177     ENS ens;
178 
179     mapping (bytes32 => Record) records;
180 
181     modifier only_owner(bytes32 node) {
182         require(ens.owner(node) == msg.sender);
183         _;
184     }
185 
186     /**
187      * Constructor.
188      * @param ensAddr The ENS registrar contract.
189      */
190     function PublicResolver(ENS ensAddr) public {
191         ens = ensAddr;
192     }
193 
194     /**
195      * Sets the address associated with an ENS node.
196      * May only be called by the owner of that node in the ENS registry.
197      * @param node The node to update.
198      * @param addr The address to set.
199      */
200     function setAddr(bytes32 node, address addr) public only_owner(node) {
201         records[node].addr = addr;
202         emit AddrChanged(node, addr);
203     }
204 
205     /**
206      * Sets the content hash associated with an ENS node.
207      * May only be called by the owner of that node in the ENS registry.
208      * Note that this resource type is not standardized, and will likely change
209      * in future to a resource type based on multihash.
210      * @param node The node to update.
211      * @param hash The content hash to set
212      */
213     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
214         records[node].content = hash;
215         emit ContentChanged(node, hash);
216     }
217 
218     /**
219      * Sets the name associated with an ENS node, for reverse records.
220      * May only be called by the owner of that node in the ENS registry.
221      * @param node The node to update.
222      * @param name The name to set.
223      */
224     function setName(bytes32 node, string name) public only_owner(node) {
225         records[node].name = name;
226         emit NameChanged(node, name);
227     }
228 
229     /**
230      * Sets the ABI associated with an ENS node.
231      * Nodes may have one ABI of each content type. To remove an ABI, set it to
232      * the empty string.
233      * @param node The node to update.
234      * @param contentType The content type of the ABI
235      * @param data The ABI data.
236      */
237     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
238         // Content types must be powers of 2
239         require(((contentType - 1) & contentType) == 0);
240 
241         records[node].abis[contentType] = data;
242         emit ABIChanged(node, contentType);
243     }
244 
245     /**
246      * Sets the SECP256k1 public key associated with an ENS node.
247      * @param node The ENS node to query
248      * @param x the X coordinate of the curve point for the public key.
249      * @param y the Y coordinate of the curve point for the public key.
250      */
251     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
252         records[node].pubkey = PublicKey(x, y);
253         emit PubkeyChanged(node, x, y);
254     }
255 
256     /**
257      * Sets the text data associated with an ENS node and key.
258      * May only be called by the owner of that node in the ENS registry.
259      * @param node The node to update.
260      * @param key The key to set.
261      * @param value The text data value to set.
262      */
263     function setText(bytes32 node, string key, string value) public only_owner(node) {
264         records[node].text[key] = value;
265         emit TextChanged(node, key, key);
266     }
267 
268     /**
269      * Returns the text data associated with an ENS node and key.
270      * @param node The ENS node to query.
271      * @param key The text data key to query.
272      * @return The associated text data.
273      */
274     function text(bytes32 node, string key) public view returns (string) {
275         return records[node].text[key];
276     }
277 
278     /**
279      * Returns the SECP256k1 public key associated with an ENS node.
280      * Defined in EIP 619.
281      * @param node The ENS node to query
282      * @return x, y the X and Y coordinates of the curve point for the public key.
283      */
284     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
285         return (records[node].pubkey.x, records[node].pubkey.y);
286     }
287 
288     /**
289      * Returns the ABI associated with an ENS node.
290      * Defined in EIP205.
291      * @param node The ENS node to query
292      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
293      * @return contentType The content type of the return value
294      * @return data The ABI data
295      */
296     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
297         Record storage record = records[node];
298         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
299             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
300                 data = record.abis[contentType];
301                 return;
302             }
303         }
304         contentType = 0;
305     }
306 
307     /**
308      * Returns the name associated with an ENS node, for reverse records.
309      * Defined in EIP181.
310      * @param node The ENS node to query.
311      * @return The associated name.
312      */
313     function name(bytes32 node) public view returns (string) {
314         return records[node].name;
315     }
316 
317     /**
318      * Returns the content hash associated with an ENS node.
319      * Note that this resource type is not standardized, and will likely change
320      * in future to a resource type based on multihash.
321      * @param node The ENS node to query.
322      * @return The associated content hash.
323      */
324     function content(bytes32 node) public view returns (bytes32) {
325         return records[node].content;
326     }
327 
328     /**
329      * Returns the address associated with an ENS node.
330      * @param node The ENS node to query.
331      * @return The associated address.
332      */
333     function addr(bytes32 node) public view returns (address) {
334         return records[node].addr;
335     }
336 
337     /**
338      * Returns true if the resolver implements the interface specified by the provided hash.
339      * @param interfaceID The ID of the interface to check for.
340      * @return True if the contract implements the requested interface.
341      */
342     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
343         return interfaceID == ADDR_INTERFACE_ID ||
344         interfaceID == CONTENT_INTERFACE_ID ||
345         interfaceID == NAME_INTERFACE_ID ||
346         interfaceID == ABI_INTERFACE_ID ||
347         interfaceID == PUBKEY_INTERFACE_ID ||
348         interfaceID == TEXT_INTERFACE_ID ||
349         interfaceID == INTERFACE_META_ID;
350     }
351 }
352 
353 contract SvEnsRegistrar {
354     SvEns public ens;
355     bytes32 public rootNode;
356     mapping (bytes32 => bool) knownNodes;
357     mapping (address => bool) admins;
358     address public owner;
359 
360 
361     modifier req(bool c) {
362         require(c);
363         _;
364     }
365 
366 
367     /**
368      * Constructor.
369      * @param ensAddr The address of the ENS registry.
370      * @param node The node that this registrar administers.
371      */
372     function SvEnsRegistrar(SvEns ensAddr, bytes32 node) public {
373         ens = ensAddr;
374         rootNode = node;
375         admins[msg.sender] = true;
376         owner = msg.sender;
377     }
378 
379     function addAdmin(address newAdmin) req(admins[msg.sender]) external {
380         admins[newAdmin] = true;
381     }
382 
383     function remAdmin(address oldAdmin) req(admins[msg.sender]) external {
384         require(oldAdmin != msg.sender && oldAdmin != owner);
385         admins[oldAdmin] = false;
386     }
387 
388     function chOwner(address newOwner, bool remPrevOwnerAsAdmin) req(msg.sender == owner) external {
389         if (remPrevOwnerAsAdmin) {
390             admins[owner] = false;
391         }
392         owner = newOwner;
393         admins[newOwner] = true;
394     }
395 
396     /**
397      * Register a name that's not currently registered
398      * @param subnode The hash of the label to register.
399      * @param _owner The address of the new owner.
400      */
401     function register(bytes32 subnode, address _owner) req(admins[msg.sender]) external {
402         _setSubnodeOwner(subnode, _owner);
403     }
404 
405     /**
406      * Register a name that's not currently registered
407      * @param subnodeStr The label to register.
408      * @param _owner The address of the new owner.
409      */
410     function registerName(string subnodeStr, address _owner) req(admins[msg.sender]) external {
411         // labelhash
412         bytes32 subnode = keccak256(subnodeStr);
413         _setSubnodeOwner(subnode, _owner);
414     }
415 
416     /**
417      * INTERNAL - Register a name that's not currently registered
418      * @param subnode The hash of the label to register.
419      * @param _owner The address of the new owner.
420      */
421     function _setSubnodeOwner(bytes32 subnode, address _owner) internal {
422         require(!knownNodes[subnode]);
423         knownNodes[subnode] = true;
424         ens.setSubnodeOwner(rootNode, subnode, _owner);
425     }
426 }
427 
428 contract SvEnsEverythingPx {
429     address public owner;
430     mapping (address => bool) public admins;
431     address[] public adminLog;
432 
433     SvEnsRegistrar public registrar;
434     SvEnsRegistry public registry;
435     PublicResolver public resolver;
436     bytes32 public rootNode;
437 
438     modifier only_admin() {
439         require(admins[msg.sender]);
440         _;
441     }
442 
443 
444     function SvEnsEverythingPx(SvEnsRegistrar _registrar, SvEnsRegistry _registry, PublicResolver _resolver, bytes32 _rootNode) public {
445         registrar = _registrar;
446         registry = _registry;
447         resolver = _resolver;
448         rootNode = _rootNode;
449         owner = msg.sender;
450         _addAdmin(msg.sender);
451     }
452 
453     function _addAdmin(address a) internal {
454         admins[a] = true;
455         adminLog.push(a);
456     }
457 
458     function addAdmin(address a) only_admin() external {
459         _addAdmin(a);
460     }
461 
462     function remAdmin(address a) only_admin() external {
463         require(a != owner && a != msg.sender);
464         admins[a] = false;
465     }
466 
467     function regName(string name, address resolveTo) only_admin() external returns (bytes32 node) {
468         bytes32 labelhash = keccak256(name);
469         registrar.register(labelhash, this);
470         node = keccak256(rootNode, labelhash);
471         registry.setResolver(node, resolver);
472         resolver.setAddr(node, resolveTo);
473         registry.setOwner(node, msg.sender);
474     }
475 }