1 pragma solidity ^0.4.18;
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
41 
42     event AddrChanged(bytes32 indexed node, address a);
43     event ContentChanged(bytes32 indexed node, bytes32 hash);
44     event NameChanged(bytes32 indexed node, string name);
45     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
46     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
47     event TextChanged(bytes32 indexed node, string indexedKey, string key);
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
63     ENS ens;
64 
65     mapping (bytes32 => Record) records;
66 
67     modifier only_owner(bytes32 node) {
68         require(ens.owner(node) == msg.sender);
69         _;
70     }
71 
72     /**
73      * Constructor.
74      * @param ensAddr The ENS registrar contract.
75      */
76     function PublicResolver(ENS ensAddr) public {
77         ens = ensAddr;
78     }
79 
80     /**
81      * Sets the address associated with an ENS node.
82      * May only be called by the owner of that node in the ENS registry.
83      * @param node The node to update.
84      * @param addr The address to set.
85      */
86     function setAddr(bytes32 node, address addr) public only_owner(node) {
87         records[node].addr = addr;
88         emit AddrChanged(node, addr);
89     }
90 
91     /**
92      * Sets the content hash associated with an ENS node.
93      * May only be called by the owner of that node in the ENS registry.
94      * Note that this resource type is not standardized, and will likely change
95      * in future to a resource type based on multihash.
96      * @param node The node to update.
97      * @param hash The content hash to set
98      */
99     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
100         records[node].content = hash;
101         emit ContentChanged(node, hash);
102     }
103 
104     /**
105      * Sets the name associated with an ENS node, for reverse records.
106      * May only be called by the owner of that node in the ENS registry.
107      * @param node The node to update.
108      * @param name The name to set.
109      */
110     function setName(bytes32 node, string name) public only_owner(node) {
111         records[node].name = name;
112         emit NameChanged(node, name);
113     }
114 
115     /**
116      * Sets the ABI associated with an ENS node.
117      * Nodes may have one ABI of each content type. To remove an ABI, set it to
118      * the empty string.
119      * @param node The node to update.
120      * @param contentType The content type of the ABI
121      * @param data The ABI data.
122      */
123     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
124         // Content types must be powers of 2
125         require(((contentType - 1) & contentType) == 0);
126 
127         records[node].abis[contentType] = data;
128         emit ABIChanged(node, contentType);
129     }
130 
131     /**
132      * Sets the SECP256k1 public key associated with an ENS node.
133      * @param node The ENS node to query
134      * @param x the X coordinate of the curve point for the public key.
135      * @param y the Y coordinate of the curve point for the public key.
136      */
137     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
138         records[node].pubkey = PublicKey(x, y);
139         emit PubkeyChanged(node, x, y);
140     }
141 
142     /**
143      * Sets the text data associated with an ENS node and key.
144      * May only be called by the owner of that node in the ENS registry.
145      * @param node The node to update.
146      * @param key The key to set.
147      * @param value The text data value to set.
148      */
149     function setText(bytes32 node, string key, string value) public only_owner(node) {
150         records[node].text[key] = value;
151         emit TextChanged(node, key, key);
152     }
153 
154     /**
155      * Returns the text data associated with an ENS node and key.
156      * @param node The ENS node to query.
157      * @param key The text data key to query.
158      * @return The associated text data.
159      */
160     function text(bytes32 node, string key) public view returns (string) {
161         return records[node].text[key];
162     }
163 
164     /**
165      * Returns the SECP256k1 public key associated with an ENS node.
166      * Defined in EIP 619.
167      * @param node The ENS node to query
168      * @return x, y the X and Y coordinates of the curve point for the public key.
169      */
170     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
171         return (records[node].pubkey.x, records[node].pubkey.y);
172     }
173 
174     /**
175      * Returns the ABI associated with an ENS node.
176      * Defined in EIP205.
177      * @param node The ENS node to query
178      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
179      * @return contentType The content type of the return value
180      * @return data The ABI data
181      */
182     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
183         Record storage record = records[node];
184         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
185             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
186                 data = record.abis[contentType];
187                 return;
188             }
189         }
190         contentType = 0;
191     }
192 
193     /**
194      * Returns the name associated with an ENS node, for reverse records.
195      * Defined in EIP181.
196      * @param node The ENS node to query.
197      * @return The associated name.
198      */
199     function name(bytes32 node) public view returns (string) {
200         return records[node].name;
201     }
202 
203     /**
204      * Returns the content hash associated with an ENS node.
205      * Note that this resource type is not standardized, and will likely change
206      * in future to a resource type based on multihash.
207      * @param node The ENS node to query.
208      * @return The associated content hash.
209      */
210     function content(bytes32 node) public view returns (bytes32) {
211         return records[node].content;
212     }
213 
214     /**
215      * Returns the address associated with an ENS node.
216      * @param node The ENS node to query.
217      * @return The associated address.
218      */
219     function addr(bytes32 node) public view returns (address) {
220         return records[node].addr;
221     }
222 
223     /**
224      * Returns true if the resolver implements the interface specified by the provided hash.
225      * @param interfaceID The ID of the interface to check for.
226      * @return True if the contract implements the requested interface.
227      */
228     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
229         return interfaceID == ADDR_INTERFACE_ID ||
230         interfaceID == CONTENT_INTERFACE_ID ||
231         interfaceID == NAME_INTERFACE_ID ||
232         interfaceID == ABI_INTERFACE_ID ||
233         interfaceID == PUBKEY_INTERFACE_ID ||
234         interfaceID == TEXT_INTERFACE_ID ||
235         interfaceID == INTERFACE_META_ID;
236     }
237 }