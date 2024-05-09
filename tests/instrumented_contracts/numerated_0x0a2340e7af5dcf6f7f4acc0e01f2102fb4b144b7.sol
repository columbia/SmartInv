1 pragma solidity ^0.4.24;
2 
3 interface ENS {
4 
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
18     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
19     function setResolver(bytes32 node, address resolver) external;
20     function setOwner(bytes32 node, address owner) external;
21     function setTTL(bytes32 node, uint64 ttl) external;
22     function owner(bytes32 node) external view returns (address);
23     function resolver(bytes32 node) external view returns (address);
24     function ttl(bytes32 node) external view returns (uint64);
25 
26 }
27 
28 /**
29  * A simple resolver anyone can use; only allows the owner of a node to set its
30  * address.
31  * Updated with nonfunctional changes
32  */
33 contract PublicResolver {
34 
35     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
36     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
37     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
38     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
39     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
40     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
41     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
42     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
43 
44     event AddrChanged(bytes32 indexed node, address a);
45     event ContentChanged(bytes32 indexed node, bytes32 hash);
46     event NameChanged(bytes32 indexed node, string name);
47     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
48     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
49     event TextChanged(bytes32 indexed node, string indexedKey, string key);
50     event MultihashChanged(bytes32 indexed node, bytes hash);
51 
52     struct PublicKey {
53         bytes32 x;
54         bytes32 y;
55     }
56 
57     struct Record {
58         address addr;
59         bytes32 content;
60         string name;
61         PublicKey pubkey;
62         mapping(string=>string) text;
63         mapping(uint256=>bytes) abis;
64         bytes multihash;
65     }
66 
67     ENS ens;
68 
69     mapping (bytes32 => Record) records;
70 
71     modifier only_owner(bytes32 node) {
72         require(ens.owner(node) == msg.sender);
73         _;
74     }
75 
76     /**
77      * Constructor.
78      * @param ensAddr The ENS registrar contract.
79      */
80     constructor(ENS ensAddr) public {
81         ens = ensAddr;
82     }
83 
84     /**
85      * Sets the address associated with an ENS node.
86      * May only be called by the owner of that node in the ENS registry.
87      * @param node The node to update.
88      * @param addr The address to set.
89      */
90     function setAddr(bytes32 node, address addr) public only_owner(node) {
91         records[node].addr = addr;
92         emit AddrChanged(node, addr);
93     }
94 
95     /**
96      * Sets the content hash associated with an ENS node.
97      * May only be called by the owner of that node in the ENS registry.
98      * Note that this resource type is not standardized, and will likely change
99      * in future to a resource type based on multihash.
100      * @param node The node to update.
101      * @param hash The content hash to set
102      */
103     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
104         records[node].content = hash;
105         emit ContentChanged(node, hash);
106     }
107 
108     /**
109      * Sets the multihash associated with an ENS node.
110      * May only be called by the owner of that node in the ENS registry.
111      * @param node The node to update.
112      * @param hash The multihash to set
113      */
114     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
115         records[node].multihash = hash;
116         emit MultihashChanged(node, hash);
117     }
118     
119     /**
120      * Sets the name associated with an ENS node, for reverse records.
121      * May only be called by the owner of that node in the ENS registry.
122      * @param node The node to update.
123      * @param name The name to set.
124      */
125     function setName(bytes32 node, string name) public only_owner(node) {
126         records[node].name = name;
127         emit NameChanged(node, name);
128     }
129 
130     /**
131      * Sets the ABI associated with an ENS node.
132      * Nodes may have one ABI of each content type. To remove an ABI, set it to
133      * the empty string.
134      * @param node The node to update.
135      * @param contentType The content type of the ABI
136      * @param data The ABI data.
137      */
138     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
139         // Content types must be powers of 2
140         require(((contentType - 1) & contentType) == 0);
141         
142         records[node].abis[contentType] = data;
143         emit ABIChanged(node, contentType);
144     }
145     
146     /**
147      * Sets the SECP256k1 public key associated with an ENS node.
148      * @param node The ENS node to query
149      * @param x the X coordinate of the curve point for the public key.
150      * @param y the Y coordinate of the curve point for the public key.
151      */
152     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
153         records[node].pubkey = PublicKey(x, y);
154         emit PubkeyChanged(node, x, y);
155     }
156 
157     /**
158      * Sets the text data associated with an ENS node and key.
159      * May only be called by the owner of that node in the ENS registry.
160      * @param node The node to update.
161      * @param key The key to set.
162      * @param value The text data value to set.
163      */
164     function setText(bytes32 node, string key, string value) public only_owner(node) {
165         records[node].text[key] = value;
166         emit TextChanged(node, key, key);
167     }
168 
169     /**
170      * Returns the text data associated with an ENS node and key.
171      * @param node The ENS node to query.
172      * @param key The text data key to query.
173      * @return The associated text data.
174      */
175     function text(bytes32 node, string key) public view returns (string) {
176         return records[node].text[key];
177     }
178 
179     /**
180      * Returns the SECP256k1 public key associated with an ENS node.
181      * Defined in EIP 619.
182      * @param node The ENS node to query
183      * @return x, y the X and Y coordinates of the curve point for the public key.
184      */
185     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
186         return (records[node].pubkey.x, records[node].pubkey.y);
187     }
188 
189     /**
190      * Returns the ABI associated with an ENS node.
191      * Defined in EIP205.
192      * @param node The ENS node to query
193      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
194      * @return contentType The content type of the return value
195      * @return data The ABI data
196      */
197     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
198         Record storage record = records[node];
199         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
200             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
201                 data = record.abis[contentType];
202                 return;
203             }
204         }
205         contentType = 0;
206     }
207 
208     /**
209      * Returns the name associated with an ENS node, for reverse records.
210      * Defined in EIP181.
211      * @param node The ENS node to query.
212      * @return The associated name.
213      */
214     function name(bytes32 node) public view returns (string) {
215         return records[node].name;
216     }
217 
218     /**
219      * Returns the content hash associated with an ENS node.
220      * Note that this resource type is not standardized, and will likely change
221      * in future to a resource type based on multihash.
222      * @param node The ENS node to query.
223      * @return The associated content hash.
224      */
225     function content(bytes32 node) public view returns (bytes32) {
226         return records[node].content;
227     }
228 
229     /**
230      * Returns the multihash associated with an ENS node.
231      * @param node The ENS node to query.
232      * @return The associated multihash.
233      */
234     function multihash(bytes32 node) public view returns (bytes) {
235         return records[node].multihash;
236     }
237 
238     /**
239      * Returns the address associated with an ENS node.
240      * @param node The ENS node to query.
241      * @return The associated address.
242      */
243     function addr(bytes32 node) public view returns (address) {
244         return records[node].addr;
245     }
246 
247     /**
248      * Returns true if the resolver implements the interface specified by the provided hash.
249      * @param interfaceID The ID of the interface to check for.
250      * @return True if the contract implements the requested interface.
251      */
252     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
253         return interfaceID == ADDR_INTERFACE_ID ||
254         interfaceID == CONTENT_INTERFACE_ID ||
255         interfaceID == NAME_INTERFACE_ID ||
256         interfaceID == ABI_INTERFACE_ID ||
257         interfaceID == PUBKEY_INTERFACE_ID ||
258         interfaceID == TEXT_INTERFACE_ID ||
259         interfaceID == MULTIHASH_INTERFACE_ID ||
260         interfaceID == INTERFACE_META_ID;
261     }
262 }