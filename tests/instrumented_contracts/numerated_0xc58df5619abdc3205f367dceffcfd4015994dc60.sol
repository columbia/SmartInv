1 pragma solidity ^0.4.18;
2 
3 interface AbstractENS {
4     function owner(bytes32 _node) public constant returns (address);
5     function resolver(bytes32 _node) public constant returns (address);
6     function ttl(bytes32 _node) public constant returns (uint64);
7     function setOwner(bytes32 _node, address _owner) public;
8     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
9     function setResolver(bytes32 _node, address _resolver) public;
10     function setTTL(bytes32 _node, uint64 _ttl) public;
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed _node, address _owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed _node, address _resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed _node, uint64 _ttl);
23 }
24 
25 pragma solidity ^0.4.0;
26 
27 /**
28  * A simple resolver anyone can use; only allows the owner of a node to set its
29  * address.
30  */
31 contract PublicResolver {
32     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
33     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
34     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
35     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
36     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
37     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
38     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
39 
40     event AddrChanged(bytes32 indexed node, address a);
41     event ContentChanged(bytes32 indexed node, bytes32 hash);
42     event NameChanged(bytes32 indexed node, string name);
43     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
44     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
45     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
46 
47     struct PublicKey {
48         bytes32 x;
49         bytes32 y;
50     }
51 
52     struct Record {
53         address addr;
54         bytes32 content;
55         string name;
56         PublicKey pubkey;
57         mapping(string=>string) text;
58         mapping(uint256=>bytes) abis;
59     }
60 
61     AbstractENS ens;
62     mapping(bytes32=>Record) records;
63 
64     modifier only_owner(bytes32 node) {
65         if (ens.owner(node) != msg.sender) throw;
66         _;
67     }
68 
69     /**
70      * Constructor.
71      * @param ensAddr The ENS registrar contract.
72      */
73     function PublicResolver(AbstractENS ensAddr) public {
74         ens = ensAddr;
75     }
76 
77     /**
78      * Returns true if the resolver implements the interface specified by the provided hash.
79      * @param interfaceID The ID of the interface to check for.
80      * @return True if the contract implements the requested interface.
81      */
82     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
83         return interfaceID == ADDR_INTERFACE_ID ||
84                interfaceID == CONTENT_INTERFACE_ID ||
85                interfaceID == NAME_INTERFACE_ID ||
86                interfaceID == ABI_INTERFACE_ID ||
87                interfaceID == PUBKEY_INTERFACE_ID ||
88                interfaceID == TEXT_INTERFACE_ID ||
89                interfaceID == INTERFACE_META_ID;
90     }
91 
92     /**
93      * Returns the address associated with an ENS node.
94      * @param node The ENS node to query.
95      * @return The associated address.
96      */
97     function addr(bytes32 node) public constant returns (address ret) {
98         ret = records[node].addr;
99     }
100 
101     /**
102      * Sets the address associated with an ENS node.
103      * May only be called by the owner of that node in the ENS registry.
104      * @param node The node to update.
105      * @param addr The address to set.
106      */
107     function setAddr(bytes32 node, address addr) only_owner(node) public {
108         records[node].addr = addr;
109         AddrChanged(node, addr);
110     }
111 
112     /**
113      * Returns the content hash associated with an ENS node.
114      * Note that this resource type is not standardized, and will likely change
115      * in future to a resource type based on multihash.
116      * @param node The ENS node to query.
117      * @return The associated content hash.
118      */
119     function content(bytes32 node) public constant returns (bytes32 ret) {
120         ret = records[node].content;
121     }
122 
123     /**
124      * Sets the content hash associated with an ENS node.
125      * May only be called by the owner of that node in the ENS registry.
126      * Note that this resource type is not standardized, and will likely change
127      * in future to a resource type based on multihash.
128      * @param node The node to update.
129      * @param hash The content hash to set
130      */
131     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
132         records[node].content = hash;
133         ContentChanged(node, hash);
134     }
135 
136     /**
137      * Returns the name associated with an ENS node, for reverse records.
138      * Defined in EIP181.
139      * @param node The ENS node to query.
140      * @return The associated name.
141      */
142     function name(bytes32 node) public constant returns (string ret) {
143         ret = records[node].name;
144     }
145 
146     /**
147      * Sets the name associated with an ENS node, for reverse records.
148      * May only be called by the owner of that node in the ENS registry.
149      * @param node The node to update.
150      * @param name The name to set.
151      */
152     function setName(bytes32 node, string name) only_owner(node) public {
153         records[node].name = name;
154         NameChanged(node, name);
155     }
156 
157     /**
158      * Returns the ABI associated with an ENS node.
159      * Defined in EIP205.
160      * @param node The ENS node to query
161      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
162      * @return contentType The content type of the return value
163      * @return data The ABI data
164      */
165     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
166         var record = records[node];
167         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
168             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
169                 data = record.abis[contentType];
170                 return;
171             }
172         }
173         contentType = 0;
174     }
175 
176     /**
177      * Sets the ABI associated with an ENS node.
178      * Nodes may have one ABI of each content type. To remove an ABI, set it to
179      * the empty string.
180      * @param node The node to update.
181      * @param contentType The content type of the ABI
182      * @param data The ABI data.
183      */
184     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
185         // Content types must be powers of 2
186         if (((contentType - 1) & contentType) != 0) throw;
187 
188         records[node].abis[contentType] = data;
189         ABIChanged(node, contentType);
190     }
191 
192     /**
193      * Returns the SECP256k1 public key associated with an ENS node.
194      * Defined in EIP 619.
195      * @param node The ENS node to query
196      * @return x, y the X and Y coordinates of the curve point for the public key.
197      */
198     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
199         return (records[node].pubkey.x, records[node].pubkey.y);
200     }
201 
202     /**
203      * Sets the SECP256k1 public key associated with an ENS node.
204      * @param node The ENS node to query
205      * @param x the X coordinate of the curve point for the public key.
206      * @param y the Y coordinate of the curve point for the public key.
207      */
208     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
209         records[node].pubkey = PublicKey(x, y);
210         PubkeyChanged(node, x, y);
211     }
212 
213     /**
214      * Returns the text data associated with an ENS node and key.
215      * @param node The ENS node to query.
216      * @param key The text data key to query.
217      * @return The associated text data.
218      */
219     function text(bytes32 node, string key) public constant returns (string ret) {
220         ret = records[node].text[key];
221     }
222 
223     /**
224      * Sets the text data associated with an ENS node and key.
225      * May only be called by the owner of that node in the ENS registry.
226      * @param node The node to update.
227      * @param key The key to set.
228      * @param value The text data value to set.
229      */
230     function setText(bytes32 node, string key, string value) only_owner(node) public {
231         records[node].text[key] = value;
232         TextChanged(node, key, key);
233     }
234 }
235 
236 /*
237  * SPDX-License-Identitifer:    MIT
238  */
239 
240 pragma solidity ^0.4.24;
241 
242 
243 contract ENSConstants {
244     bytes32 constant public ENS_ROOT = bytes32(0);
245     bytes32 constant public ETH_TLD_LABEL = keccak256("eth");
246     bytes32 constant public ETH_TLD_NODE = keccak256(abi.encodePacked(ENS_ROOT, ETH_TLD_LABEL));
247     bytes32 constant public PUBLIC_RESOLVER_LABEL = keccak256("resolver");
248     bytes32 constant public PUBLIC_RESOLVER_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL));
249     address constant public PORTAL_NETWORK_RESOLVER = 0x1da022710dF5002339274AaDEe8D58218e9D6AB5;
250 }
251 
252 
253 contract dwebregistry is ENSConstants {
254     
255     AbstractENS public ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
256     event NewDWeb(bytes32 indexed node, string label, string hash);
257 
258     function createDWeb(bytes32 _rootNode, string _label, string dnslink, bytes32 content) external returns (bytes32 node) {
259         return _createDWeb(_rootNode, _label, msg.sender, dnslink, content);
260     }
261 
262     function _createDWeb(bytes32 _rootNode, string _label, address _owner, string dnslink, bytes32 content) internal returns (bytes32 node) {
263         require(ens.owner(_rootNode) == address(this));
264 
265         node = getNodeForLabel(_rootNode, getKeccak256Label(_label));
266         require(ens.owner(node) == address(0)); // avoid name reset
267         
268         ens.setSubnodeOwner(_rootNode, getKeccak256Label(_label), address(this));
269         
270         address publicResolver = getAddr(PUBLIC_RESOLVER_NODE);
271         ens.setResolver(node, publicResolver);
272 
273         PublicResolver(publicResolver).setText(node,'dnslink', dnslink);
274         PublicResolver(publicResolver).setContent(node, content);
275         
276         ens.setSubnodeOwner(_rootNode, getKeccak256Label(_label), _owner);
277 
278         emit NewDWeb(node, _label, dnslink);
279 
280         return node;
281     }
282     
283     function getAddr(bytes32 node) internal view returns (address) {
284         address resolver = ens.resolver(node);
285         return PublicResolver(resolver).addr(node);
286     }
287     
288     function getNodeForLabel(bytes32 _rootNode, bytes32 _label) internal pure returns (bytes32) {
289         return keccak256(abi.encodePacked(_rootNode, _label));
290     }
291     
292     function getKeccak256Label(string _label) internal pure returns (bytes32) {
293         return keccak256(abi.encodePacked(_label));
294     }
295 
296 }