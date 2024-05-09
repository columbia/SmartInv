1 // File: @ensdomains/ens/contracts/ENS.sol
2 
3 pragma solidity >=0.4.24;
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
19     // Logged when an operator is added or removed.
20     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
21 
22     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
23     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
24     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
25     function setResolver(bytes32 node, address resolver) external;
26     function setOwner(bytes32 node, address owner) external;
27     function setTTL(bytes32 node, uint64 ttl) external;
28     function setApprovalForAll(address operator, bool approved) external;
29     function owner(bytes32 node) external view returns (address);
30     function resolver(bytes32 node) external view returns (address);
31     function ttl(bytes32 node) external view returns (uint64);
32     function recordExists(bytes32 node) external view returns (bool);
33     function isApprovedForAll(address owner, address operator) external view returns (bool);
34 }
35 
36 // File: @ensdomains/ens/contracts/ENSRegistry.sol
37 
38 pragma solidity ^0.5.0;
39 
40 
41 /**
42  * The ENS registry contract.
43  */
44 contract ENSRegistry is ENS {
45 
46     struct Record {
47         address owner;
48         address resolver;
49         uint64 ttl;
50     }
51 
52     mapping (bytes32 => Record) records;
53     mapping (address => mapping(address => bool)) operators;
54 
55     // Permits modifications only by the owner of the specified node.
56     modifier authorised(bytes32 node) {
57         address owner = records[node].owner;
58         require(owner == msg.sender || operators[owner][msg.sender]);
59         _;
60     }
61 
62     /**
63      * @dev Constructs a new ENS registrar.
64      */
65     constructor() public {
66         records[0x0].owner = msg.sender;
67     }
68 
69     /**
70      * @dev Sets the record for a node.
71      * @param node The node to update.
72      * @param owner The address of the new owner.
73      * @param resolver The address of the resolver.
74      * @param ttl The TTL in seconds.
75      */
76     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external {
77         setOwner(node, owner);
78         _setResolverAndTTL(node, resolver, ttl);
79     }
80 
81     /**
82      * @dev Sets the record for a subnode.
83      * @param node The parent node.
84      * @param label The hash of the label specifying the subnode.
85      * @param owner The address of the new owner.
86      * @param resolver The address of the resolver.
87      * @param ttl The TTL in seconds.
88      */
89     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external {
90         bytes32 subnode = setSubnodeOwner(node, label, owner);
91         _setResolverAndTTL(subnode, resolver, ttl);
92     }
93 
94     /**
95      * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
96      * @param node The node to transfer ownership of.
97      * @param owner The address of the new owner.
98      */
99     function setOwner(bytes32 node, address owner) public authorised(node) {
100         _setOwner(node, owner);
101         emit Transfer(node, owner);
102     }
103 
104     /**
105      * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
106      * @param node The parent node.
107      * @param label The hash of the label specifying the subnode.
108      * @param owner The address of the new owner.
109      */
110     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public authorised(node) returns(bytes32) {
111         bytes32 subnode = keccak256(abi.encodePacked(node, label));
112         _setOwner(subnode, owner);
113         emit NewOwner(node, label, owner);
114         return subnode;
115     }
116 
117     /**
118      * @dev Sets the resolver address for the specified node.
119      * @param node The node to update.
120      * @param resolver The address of the resolver.
121      */
122     function setResolver(bytes32 node, address resolver) public authorised(node) {
123         emit NewResolver(node, resolver);
124         records[node].resolver = resolver;
125     }
126 
127     /**
128      * @dev Sets the TTL for the specified node.
129      * @param node The node to update.
130      * @param ttl The TTL in seconds.
131      */
132     function setTTL(bytes32 node, uint64 ttl) public authorised(node) {
133         emit NewTTL(node, ttl);
134         records[node].ttl = ttl;
135     }
136 
137     /**
138      * @dev Enable or disable approval for a third party ("operator") to manage
139      *  all of `msg.sender`'s ENS records. Emits the ApprovalForAll event.
140      * @param operator Address to add to the set of authorized operators.
141      * @param approved True if the operator is approved, false to revoke approval.
142      */
143     function setApprovalForAll(address operator, bool approved) external {
144         operators[msg.sender][operator] = approved;
145         emit ApprovalForAll(msg.sender, operator, approved);
146     }
147 
148     /**
149      * @dev Returns the address that owns the specified node.
150      * @param node The specified node.
151      * @return address of the owner.
152      */
153     function owner(bytes32 node) public view returns (address) {
154         address addr = records[node].owner;
155         if (addr == address(this)) {
156             return address(0x0);
157         }
158 
159         return addr;
160     }
161 
162     /**
163      * @dev Returns the address of the resolver for the specified node.
164      * @param node The specified node.
165      * @return address of the resolver.
166      */
167     function resolver(bytes32 node) public view returns (address) {
168         return records[node].resolver;
169     }
170 
171     /**
172      * @dev Returns the TTL of a node, and any records associated with it.
173      * @param node The specified node.
174      * @return ttl of the node.
175      */
176     function ttl(bytes32 node) public view returns (uint64) {
177         return records[node].ttl;
178     }
179 
180     /**
181      * @dev Returns whether a record has been imported to the registry.
182      * @param node The specified node.
183      * @return Bool if record exists
184      */
185     function recordExists(bytes32 node) public view returns (bool) {
186         return records[node].owner != address(0x0);
187     }
188 
189     /**
190      * @dev Query if an address is an authorized operator for another address.
191      * @param owner The address that owns the records.
192      * @param operator The address that acts on behalf of the owner.
193      * @return True if `operator` is an approved operator for `owner`, false otherwise.
194      */
195     function isApprovedForAll(address owner, address operator) external view returns (bool) {
196         return operators[owner][operator];
197     }
198 
199     function _setOwner(bytes32 node, address owner) internal {
200         records[node].owner = owner;
201     }
202 
203     function _setResolverAndTTL(bytes32 node, address resolver, uint64 ttl) internal {
204         if(resolver != records[node].resolver) {
205             records[node].resolver = resolver;
206             emit NewResolver(node, resolver);
207         }
208 
209         if(ttl != records[node].ttl) {
210             records[node].ttl = ttl;
211             emit NewTTL(node, ttl);
212         }
213     }
214 }
215 
216 // File: @ensdomains/ens/contracts/ENSRegistryWithFallback.sol
217 
218 pragma solidity ^0.5.0;
219 
220 
221 
222 /**
223  * The ENS registry contract.
224  */
225 contract ENSRegistryWithFallback is ENSRegistry {
226 
227     ENS public old;
228 
229     /**
230      * @dev Constructs a new ENS registrar.
231      */
232     constructor(ENS _old) public ENSRegistry() {
233         old = _old;
234     }
235 
236     /**
237      * @dev Returns the address of the resolver for the specified node.
238      * @param node The specified node.
239      * @return address of the resolver.
240      */
241     function resolver(bytes32 node) public view returns (address) {
242         if (!recordExists(node)) {
243             return old.resolver(node);
244         }
245 
246         return super.resolver(node);
247     }
248 
249     /**
250      * @dev Returns the address that owns the specified node.
251      * @param node The specified node.
252      * @return address of the owner.
253      */
254     function owner(bytes32 node) public view returns (address) {
255         if (!recordExists(node)) {
256             return old.owner(node);
257         }
258 
259         return super.owner(node);
260     }
261 
262     /**
263      * @dev Returns the TTL of a node, and any records associated with it.
264      * @param node The specified node.
265      * @return ttl of the node.
266      */
267     function ttl(bytes32 node) public view returns (uint64) {
268         if (!recordExists(node)) {
269             return old.ttl(node);
270         }
271 
272         return super.ttl(node);
273     }
274 
275     function _setOwner(bytes32 node, address owner) internal {
276         address addr = owner;
277         if (addr == address(0x0)) {
278             addr = address(this);
279         }
280 
281         super._setOwner(node, addr);
282     }
283 }