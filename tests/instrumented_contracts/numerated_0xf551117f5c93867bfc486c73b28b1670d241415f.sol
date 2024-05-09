1 pragma solidity ^0.4.18;
2 
3 /**
4  * A simple resolver anyone can use; only allows the owner of a node to set its
5  * address.
6  */
7 contract PublicResolver {
8 
9     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
10     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
11     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
12     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
13     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
14     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
15     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
16     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
17 
18     event AddrChanged(bytes32 indexed node, address a);
19     event ContentChanged(bytes32 indexed node, bytes32 hash);
20     event NameChanged(bytes32 indexed node, string name);
21     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
22     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
23     event TextChanged(bytes32 indexed node, string indexedKey, string key);
24     event MultihashChanged(bytes32 indexed node, bytes hash);
25 
26     struct PublicKey {
27         bytes32 x;
28         bytes32 y;
29     }
30 
31     struct Record {
32         address addr;
33         bytes32 content;
34         string name;
35         PublicKey pubkey;
36         mapping(string=>string) text;
37         mapping(uint256=>bytes) abis;
38         bytes multihash;
39     }
40 
41     ENS ens;
42 
43     mapping (bytes32 => Record) records;
44 
45     modifier only_owner(bytes32 node) {
46         require(ens.owner(node) == msg.sender);
47         _;
48     }
49 
50     /**
51      * Constructor.
52      * @param ensAddr The ENS registrar contract.
53      */
54     function PublicResolver(ENS ensAddr) public {
55         ens = ensAddr;
56     }
57 
58     /**
59      * Sets the address associated with an ENS node.
60      * May only be called by the owner of that node in the ENS registry.
61      * @param node The node to update.
62      * @param addr The address to set.
63      */
64     function setAddr(bytes32 node, address addr) public only_owner(node) {
65         records[node].addr = addr;
66         AddrChanged(node, addr);
67     }
68 
69     /**
70      * Sets the content hash associated with an ENS node.
71      * May only be called by the owner of that node in the ENS registry.
72      * Note that this resource type is not standardized, and will likely change
73      * in future to a resource type based on multihash.
74      * @param node The node to update.
75      * @param hash The content hash to set
76      */
77     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
78         records[node].content = hash;
79         ContentChanged(node, hash);
80     }
81 
82     /**
83      * Sets the multihash associated with an ENS node.
84      * May only be called by the owner of that node in the ENS registry.
85      * @param node The node to update.
86      * @param hash The multihash to set
87      */
88     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
89         records[node].multihash = hash;
90         MultihashChanged(node, hash);
91     }
92     
93     /**
94      * Sets the name associated with an ENS node, for reverse records.
95      * May only be called by the owner of that node in the ENS registry.
96      * @param node The node to update.
97      * @param name The name to set.
98      */
99     function setName(bytes32 node, string name) public only_owner(node) {
100         records[node].name = name;
101         NameChanged(node, name);
102     }
103 
104     /**
105      * Sets the ABI associated with an ENS node.
106      * Nodes may have one ABI of each content type. To remove an ABI, set it to
107      * the empty string.
108      * @param node The node to update.
109      * @param contentType The content type of the ABI
110      * @param data The ABI data.
111      */
112     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
113         // Content types must be powers of 2
114         require(((contentType - 1) & contentType) == 0);
115         
116         records[node].abis[contentType] = data;
117         ABIChanged(node, contentType);
118     }
119     
120     /**
121      * Sets the SECP256k1 public key associated with an ENS node.
122      * @param node The ENS node to query
123      * @param x the X coordinate of the curve point for the public key.
124      * @param y the Y coordinate of the curve point for the public key.
125      */
126     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
127         records[node].pubkey = PublicKey(x, y);
128         PubkeyChanged(node, x, y);
129     }
130 
131     /**
132      * Sets the text data associated with an ENS node and key.
133      * May only be called by the owner of that node in the ENS registry.
134      * @param node The node to update.
135      * @param key The key to set.
136      * @param value The text data value to set.
137      */
138     function setText(bytes32 node, string key, string value) public only_owner(node) {
139         records[node].text[key] = value;
140         TextChanged(node, key, key);
141     }
142 
143     /**
144      * Returns the text data associated with an ENS node and key.
145      * @param node The ENS node to query.
146      * @param key The text data key to query.
147      * @return The associated text data.
148      */
149     function text(bytes32 node, string key) public view returns (string) {
150         return records[node].text[key];
151     }
152 
153     /**
154      * Returns the SECP256k1 public key associated with an ENS node.
155      * Defined in EIP 619.
156      * @param node The ENS node to query
157      * @return x, y the X and Y coordinates of the curve point for the public key.
158      */
159     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
160         return (records[node].pubkey.x, records[node].pubkey.y);
161     }
162 
163     /**
164      * Returns the ABI associated with an ENS node.
165      * Defined in EIP205.
166      * @param node The ENS node to query
167      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
168      * @return contentType The content type of the return value
169      * @return data The ABI data
170      */
171     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
172         Record storage record = records[node];
173         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
174             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
175                 data = record.abis[contentType];
176                 return;
177             }
178         }
179         contentType = 0;
180     }
181 
182     /**
183      * Returns the name associated with an ENS node, for reverse records.
184      * Defined in EIP181.
185      * @param node The ENS node to query.
186      * @return The associated name.
187      */
188     function name(bytes32 node) public view returns (string) {
189         return records[node].name;
190     }
191 
192     /**
193      * Returns the content hash associated with an ENS node.
194      * Note that this resource type is not standardized, and will likely change
195      * in future to a resource type based on multihash.
196      * @param node The ENS node to query.
197      * @return The associated content hash.
198      */
199     function content(bytes32 node) public view returns (bytes32) {
200         return records[node].content;
201     }
202 
203     /**
204      * Returns the multihash associated with an ENS node.
205      * @param node The ENS node to query.
206      * @return The associated multihash.
207      */
208     function multihash(bytes32 node) public view returns (bytes) {
209         return records[node].multihash;
210     }
211 
212     /**
213      * Returns the address associated with an ENS node.
214      * @param node The ENS node to query.
215      * @return The associated address.
216      */
217     function addr(bytes32 node) public view returns (address) {
218         return records[node].addr;
219     }
220 
221     /**
222      * Returns true if the resolver implements the interface specified by the provided hash.
223      * @param interfaceID The ID of the interface to check for.
224      * @return True if the contract implements the requested interface.
225      */
226     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
227         return interfaceID == ADDR_INTERFACE_ID ||
228         interfaceID == CONTENT_INTERFACE_ID ||
229         interfaceID == NAME_INTERFACE_ID ||
230         interfaceID == ABI_INTERFACE_ID ||
231         interfaceID == PUBKEY_INTERFACE_ID ||
232         interfaceID == TEXT_INTERFACE_ID ||
233         interfaceID == MULTIHASH_INTERFACE_ID ||
234         interfaceID == INTERFACE_META_ID;
235     }
236 }
237 
238 pragma solidity ^0.4.18;
239 
240 interface ENS {
241 
242     // Logged when the owner of a node assigns a new owner to a subnode.
243     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
244 
245     // Logged when the owner of a node transfers ownership to a new account.
246     event Transfer(bytes32 indexed node, address owner);
247 
248     // Logged when the resolver for a node changes.
249     event NewResolver(bytes32 indexed node, address resolver);
250 
251     // Logged when the TTL of a node changes
252     event NewTTL(bytes32 indexed node, uint64 ttl);
253 
254 
255     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
256     function setResolver(bytes32 node, address resolver) public;
257     function setOwner(bytes32 node, address owner) public;
258     function setTTL(bytes32 node, uint64 ttl) public;
259     function owner(bytes32 node) public view returns (address);
260     function resolver(bytes32 node) public view returns (address);
261     function ttl(bytes32 node) public view returns (uint64);
262 
263 }