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
18     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
19     function setResolver(bytes32 node, address resolver) public;
20     function setOwner(bytes32 node, address owner) public;
21     function setTTL(bytes32 node, uint64 ttl) public;
22     function owner(bytes32 node) public view returns (address);
23     function resolver(bytes32 node) public view returns (address);
24     function ttl(bytes32 node) public view returns (uint64);
25 
26 }
27 
28 /**
29  * A simple resolver anyone can use; only allows the owner of a node to set its
30  * address.
31  */
32 contract PublicResolver {
33 
34     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
35     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
36     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
37     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
38     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
39     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
40     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
41     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
42 
43     event AddrChanged(bytes32 indexed node, address a);
44     event ContentChanged(bytes32 indexed node, bytes32 hash);
45     event NameChanged(bytes32 indexed node, string name);
46     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
47     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
48     event TextChanged(bytes32 indexed node, string indexedKey, string key);
49     event MultihashChanged(bytes32 indexed node, bytes hash);
50 
51     struct PublicKey {
52         bytes32 x;
53         bytes32 y;
54     }
55 
56     struct Record {
57         address addr;
58         bytes32 content;
59         string name;
60         PublicKey pubkey;
61         mapping(string=>string) text;
62         mapping(uint256=>bytes) abis;
63         bytes multihash;
64     }
65 
66     ENS ens;
67 
68     mapping (bytes32 => Record) records;
69 
70     modifier only_owner(bytes32 node) {
71         require(ens.owner(node) == msg.sender);
72         _;
73     }
74 
75     /**
76      * Constructor.
77      * @param ensAddr The ENS registrar contract.
78      */
79     constructor(ENS ensAddr) public {
80         ens = ensAddr;
81     }
82 
83     /**
84      * Sets the address associated with an ENS node.
85      * May only be called by the owner of that node in the ENS registry.
86      * @param node The node to update.
87      * @param addr The address to set.
88      */
89     function setAddr(bytes32 node, address addr) public only_owner(node) {
90         records[node].addr = addr;
91         emit AddrChanged(node, addr);
92     }
93 
94     /**
95      * Sets the content hash associated with an ENS node.
96      * May only be called by the owner of that node in the ENS registry.
97      * Note that this resource type is not standardized, and will likely change
98      * in future to a resource type based on multihash.
99      * @param node The node to update.
100      * @param hash The content hash to set
101      */
102     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
103         records[node].content = hash;
104         emit ContentChanged(node, hash);
105     }
106 
107     /**
108      * Sets the multihash associated with an ENS node.
109      * May only be called by the owner of that node in the ENS registry.
110      * @param node The node to update.
111      * @param hash The multihash to set
112      */
113     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
114         records[node].multihash = hash;
115         emit MultihashChanged(node, hash);
116     }
117     
118     /**
119      * Sets the name associated with an ENS node, for reverse records.
120      * May only be called by the owner of that node in the ENS registry.
121      * @param node The node to update.
122      * @param name The name to set.
123      */
124     function setName(bytes32 node, string name) public only_owner(node) {
125         records[node].name = name;
126         emit NameChanged(node, name);
127     }
128 
129     /**
130      * Sets the ABI associated with an ENS node.
131      * Nodes may have one ABI of each content type. To remove an ABI, set it to
132      * the empty string.
133      * @param node The node to update.
134      * @param contentType The content type of the ABI
135      * @param data The ABI data.
136      */
137     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
138         // Content types must be powers of 2
139         require(((contentType - 1) & contentType) == 0);
140         
141         records[node].abis[contentType] = data;
142         emit ABIChanged(node, contentType);
143     }
144     
145     /**
146      * Sets the SECP256k1 public key associated with an ENS node.
147      * @param node The ENS node to query
148      * @param x the X coordinate of the curve point for the public key.
149      * @param y the Y coordinate of the curve point for the public key.
150      */
151     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
152         records[node].pubkey = PublicKey(x, y);
153         emit PubkeyChanged(node, x, y);
154     }
155 
156     /**
157      * Sets the text data associated with an ENS node and key.
158      * May only be called by the owner of that node in the ENS registry.
159      * @param node The node to update.
160      * @param key The key to set.
161      * @param value The text data value to set.
162      */
163     function setText(bytes32 node, string key, string value) public only_owner(node) {
164         records[node].text[key] = value;
165         emit TextChanged(node, key, key);
166     }
167 
168     /**
169      * Returns the text data associated with an ENS node and key.
170      * @param node The ENS node to query.
171      * @param key The text data key to query.
172      * @return The associated text data.
173      */
174     function text(bytes32 node, string key) public view returns (string) {
175         return records[node].text[key];
176     }
177 
178     /**
179      * Returns the SECP256k1 public key associated with an ENS node.
180      * Defined in EIP 619.
181      * @param node The ENS node to query
182      * @return x, y the X and Y coordinates of the curve point for the public key.
183      */
184     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
185         return (records[node].pubkey.x, records[node].pubkey.y);
186     }
187 
188     /**
189      * Returns the ABI associated with an ENS node.
190      * Defined in EIP205.
191      * @param node The ENS node to query
192      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
193      * @return contentType The content type of the return value
194      * @return data The ABI data
195      */
196     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
197         Record storage record = records[node];
198         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
199             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
200                 data = record.abis[contentType];
201                 return;
202             }
203         }
204         contentType = 0;
205     }
206 
207     /**
208      * Returns the name associated with an ENS node, for reverse records.
209      * Defined in EIP181.
210      * @param node The ENS node to query.
211      * @return The associated name.
212      */
213     function name(bytes32 node) public view returns (string) {
214         return records[node].name;
215     }
216 
217     /**
218      * Returns the content hash associated with an ENS node.
219      * Note that this resource type is not standardized, and will likely change
220      * in future to a resource type based on multihash.
221      * @param node The ENS node to query.
222      * @return The associated content hash.
223      */
224     function content(bytes32 node) public view returns (bytes32) {
225         return records[node].content;
226     }
227 
228     /**
229      * Returns the multihash associated with an ENS node.
230      * @param node The ENS node to query.
231      * @return The associated multihash.
232      */
233     function multihash(bytes32 node) public view returns (bytes) {
234         return records[node].multihash;
235     }
236 
237     /**
238      * Returns the address associated with an ENS node.
239      * @param node The ENS node to query.
240      * @return The associated address.
241      */
242     function addr(bytes32 node) public view returns (address) {
243         return records[node].addr;
244     }
245 
246     /**
247      * Returns true if the resolver implements the interface specified by the provided hash.
248      * @param interfaceID The ID of the interface to check for.
249      * @return True if the contract implements the requested interface.
250      */
251     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
252         return interfaceID == ADDR_INTERFACE_ID ||
253         interfaceID == CONTENT_INTERFACE_ID ||
254         interfaceID == NAME_INTERFACE_ID ||
255         interfaceID == ABI_INTERFACE_ID ||
256         interfaceID == PUBKEY_INTERFACE_ID ||
257         interfaceID == TEXT_INTERFACE_ID ||
258         interfaceID == MULTIHASH_INTERFACE_ID ||
259         interfaceID == INTERFACE_META_ID;
260     }
261 }