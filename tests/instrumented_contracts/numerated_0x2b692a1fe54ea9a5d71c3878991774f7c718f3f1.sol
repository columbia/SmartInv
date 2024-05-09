1 pragma solidity ^0.4.18;
2 
3 
4 
5 interface AbstractENS {
6     function owner(bytes32 _node) public constant returns (address);
7     function resolver(bytes32 _node) public constant returns (address);
8     function ttl(bytes32 _node) public constant returns (uint64);
9     function setOwner(bytes32 _node, address _owner) public;
10     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
11     function setResolver(bytes32 _node, address _resolver) public;
12     function setTTL(bytes32 _node, uint64 _ttl) public;
13 
14     // Logged when the owner of a node assigns a new owner to a subnode.
15     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
16 
17     // Logged when the owner of a node transfers ownership to a new account.
18     event Transfer(bytes32 indexed _node, address _owner);
19 
20     // Logged when the resolver for a node changes.
21     event NewResolver(bytes32 indexed _node, address _resolver);
22 
23     // Logged when the TTL of a node changes
24     event NewTTL(bytes32 indexed _node, uint64 _ttl);
25 }
26 
27 pragma solidity ^0.4.0;
28 
29 /**
30  * A simple resolver anyone can use; only allows the owner of a node to set its
31  * address.
32  */
33 contract PublicResolver {
34     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
35     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
36     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
37     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
38     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
39     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
40     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
41 
42     event AddrChanged(bytes32 indexed node, address a);
43     event ContentChanged(bytes32 indexed node, bytes32 hash);
44     event NameChanged(bytes32 indexed node, string name);
45     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
46     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
47     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
48 
49     struct PublicKey {
50         bytes32 x;
51         bytes32 y;
52     }
53 
54     struct Record {
55         address addr;
56         bytes32 content;
57         string name;
58         PublicKey pubkey;
59         mapping(string=>string) text;
60         mapping(uint256=>bytes) abis;
61     }
62 
63     AbstractENS ens;
64     mapping(bytes32=>Record) records;
65 
66     modifier only_owner(bytes32 node) {
67         if (ens.owner(node) != msg.sender) throw;
68         _;
69     }
70 
71     /**
72      * Constructor.
73      * @param ensAddr The ENS registrar contract.
74      */
75     function PublicResolver(AbstractENS ensAddr) public {
76         ens = ensAddr;
77     }
78 
79     /**
80      * Returns true if the resolver implements the interface specified by the provided hash.
81      * @param interfaceID The ID of the interface to check for.
82      * @return True if the contract implements the requested interface.
83      */
84     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
85         return interfaceID == ADDR_INTERFACE_ID ||
86                interfaceID == CONTENT_INTERFACE_ID ||
87                interfaceID == NAME_INTERFACE_ID ||
88                interfaceID == ABI_INTERFACE_ID ||
89                interfaceID == PUBKEY_INTERFACE_ID ||
90                interfaceID == TEXT_INTERFACE_ID ||
91                interfaceID == INTERFACE_META_ID;
92     }
93 
94     /**
95      * Returns the address associated with an ENS node.
96      * @param node The ENS node to query.
97      * @return The associated address.
98      */
99     function addr(bytes32 node) public constant returns (address ret) {
100         ret = records[node].addr;
101     }
102 
103     /**
104      * Sets the address associated with an ENS node.
105      * May only be called by the owner of that node in the ENS registry.
106      * @param node The node to update.
107      * @param addr The address to set.
108      */
109     function setAddr(bytes32 node, address addr) only_owner(node) public {
110         records[node].addr = addr;
111         AddrChanged(node, addr);
112     }
113 
114     /**
115      * Returns the content hash associated with an ENS node.
116      * Note that this resource type is not standardized, and will likely change
117      * in future to a resource type based on multihash.
118      * @param node The ENS node to query.
119      * @return The associated content hash.
120      */
121     function content(bytes32 node) public constant returns (bytes32 ret) {
122         ret = records[node].content;
123     }
124 
125     /**
126      * Sets the content hash associated with an ENS node.
127      * May only be called by the owner of that node in the ENS registry.
128      * Note that this resource type is not standardized, and will likely change
129      * in future to a resource type based on multihash.
130      * @param node The node to update.
131      * @param hash The content hash to set
132      */
133     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
134         records[node].content = hash;
135         ContentChanged(node, hash);
136     }
137 
138     /**
139      * Returns the name associated with an ENS node, for reverse records.
140      * Defined in EIP181.
141      * @param node The ENS node to query.
142      * @return The associated name.
143      */
144     function name(bytes32 node) public constant returns (string ret) {
145         ret = records[node].name;
146     }
147 
148     /**
149      * Sets the name associated with an ENS node, for reverse records.
150      * May only be called by the owner of that node in the ENS registry.
151      * @param node The node to update.
152      * @param name The name to set.
153      */
154     function setName(bytes32 node, string name) only_owner(node) public {
155         records[node].name = name;
156         NameChanged(node, name);
157     }
158 
159     /**
160      * Returns the ABI associated with an ENS node.
161      * Defined in EIP205.
162      * @param node The ENS node to query
163      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
164      * @return contentType The content type of the return value
165      * @return data The ABI data
166      */
167     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
168         var record = records[node];
169         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
170             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
171                 data = record.abis[contentType];
172                 return;
173             }
174         }
175         contentType = 0;
176     }
177 
178     /**
179      * Sets the ABI associated with an ENS node.
180      * Nodes may have one ABI of each content type. To remove an ABI, set it to
181      * the empty string.
182      * @param node The node to update.
183      * @param contentType The content type of the ABI
184      * @param data The ABI data.
185      */
186     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
187         // Content types must be powers of 2
188         if (((contentType - 1) & contentType) != 0) throw;
189 
190         records[node].abis[contentType] = data;
191         ABIChanged(node, contentType);
192     }
193 
194     /**
195      * Returns the SECP256k1 public key associated with an ENS node.
196      * Defined in EIP 619.
197      * @param node The ENS node to query
198      * @return x, y the X and Y coordinates of the curve point for the public key.
199      */
200     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
201         return (records[node].pubkey.x, records[node].pubkey.y);
202     }
203 
204     /**
205      * Sets the SECP256k1 public key associated with an ENS node.
206      * @param node The ENS node to query
207      * @param x the X coordinate of the curve point for the public key.
208      * @param y the Y coordinate of the curve point for the public key.
209      */
210     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
211         records[node].pubkey = PublicKey(x, y);
212         PubkeyChanged(node, x, y);
213     }
214 
215     /**
216      * Returns the text data associated with an ENS node and key.
217      * @param node The ENS node to query.
218      * @param key The text data key to query.
219      * @return The associated text data.
220      */
221     function text(bytes32 node, string key) public constant returns (string ret) {
222         ret = records[node].text[key];
223     }
224 
225     /**
226      * Sets the text data associated with an ENS node and key.
227      * May only be called by the owner of that node in the ENS registry.
228      * @param node The node to update.
229      * @param key The key to set.
230      * @param value The text data value to set.
231      */
232     function setText(bytes32 node, string key, string value) only_owner(node) public {
233         records[node].text[key] = value;
234         TextChanged(node, key, key);
235     }
236 }
237 
238 
239 /*
240  * SPDX-License-Identitifer:    MIT
241  */
242 
243 pragma solidity ^0.4.24;
244 
245 
246 contract ENSConstants {
247     bytes32 constant public ENS_ROOT = bytes32(0);
248     bytes32 constant public ETH_TLD_LABEL = keccak256("eth");
249     bytes32 constant public ETH_TLD_NODE = keccak256(abi.encodePacked(ENS_ROOT, ETH_TLD_LABEL));
250     bytes32 constant public PUBLIC_RESOLVER_LABEL = keccak256("resolver");
251     bytes32 constant public PUBLIC_RESOLVER_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL));
252 }
253 
254 
255 contract dwebregistry is ENSConstants {
256     
257     AbstractENS public ens;
258     bytes32 public rootNode;
259     
260     event NewDWeb(bytes32 indexed node, bytes32 indexed label, string hash);
261 
262     function initialize(AbstractENS _ens, bytes32 _rootNode) public {
263 
264         // We need ownership to create subnodes
265         require(_ens.owner(_rootNode) == address(this));
266         require(ens == address(0));
267         require(rootNode == 0);
268 
269         ens = _ens;
270         rootNode = _rootNode;
271     }
272     
273     function createDWeb(bytes32 _label, string hash) external returns (bytes32 node) {
274         return _createDWeb(_label, msg.sender, hash);
275     }
276 
277     function _createDWeb(bytes32 _label, address _owner, string hash) internal returns (bytes32 node) {
278         node = getNodeForLabel(_label);
279     
280         require(ens.owner(rootNode) == address(this));
281         require(ens.owner(node) == address(0)); // avoid name reset
282         
283         ens.setSubnodeOwner(rootNode, _label, address(this));
284         
285         address publicResolver = getAddr(PUBLIC_RESOLVER_NODE);
286         ens.setResolver(node, publicResolver);
287 
288         PublicResolver(publicResolver).setText(node,'dnslink', hash);
289         PublicResolver(publicResolver).setContent(node, bytes(hash)[32]);
290     
291         ens.setSubnodeOwner(rootNode, _label, _owner);
292 
293         emit NewDWeb(node, _label, hash);
294 
295         return node;
296     }
297     
298     function getAddr(bytes32 node) internal view returns (address) {
299         address resolver = ens.resolver(node);
300         return PublicResolver(resolver).addr(node);
301     }
302     
303     function getNodeForLabel(bytes32 _label) internal view returns (bytes32) {
304         return keccak256(abi.encodePacked(rootNode, _label));
305     }
306 
307 }