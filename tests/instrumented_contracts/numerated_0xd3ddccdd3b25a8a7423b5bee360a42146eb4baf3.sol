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
36     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
37     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
38     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
39     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
40     bytes4 constant CONTENTHASH_INTERFACE_ID = 0xbc1c58d1;
41 
42     event AddrChanged(bytes32 indexed node, address a);
43     event NameChanged(bytes32 indexed node, string name);
44     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
45     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
46     event TextChanged(bytes32 indexed node, string indexedKey, string key);
47     event ContenthashChanged(bytes32 indexed node, bytes hash);
48 
49     struct PublicKey {
50         bytes32 x;
51         bytes32 y;
52     }
53 
54     struct Record {
55         address addr;
56         string name;
57         PublicKey pubkey;
58         mapping(string=>string) text;
59         mapping(uint256=>bytes) abis;
60         bytes contenthash;
61     }
62 
63     ENS ens;
64 
65     mapping (bytes32 => Record) records;
66 
67     modifier onlyOwner(bytes32 node) {
68         require(ens.owner(node) == msg.sender);
69         _;
70     }
71 
72     /**
73      * Constructor.
74      * @param ensAddr The ENS registrar contract.
75      */
76     constructor(ENS ensAddr) public {
77         ens = ensAddr;
78     }
79 
80     /**
81      * Sets the address associated with an ENS node.
82      * May only be called by the owner of that node in the ENS registry.
83      * @param node The node to update.
84      * @param addr The address to set.
85      */
86     function setAddr(bytes32 node, address addr) public onlyOwner(node) {
87         records[node].addr = addr;
88         emit AddrChanged(node, addr);
89     }
90 
91     /**
92      * Sets the contenthash associated with an ENS node.
93      * May only be called by the owner of that node in the ENS registry.
94      * @param node The node to update.
95      * @param hash The contenthash to set
96      */
97     function setContenthash(bytes32 node, bytes hash) public onlyOwner(node) {
98         records[node].contenthash = hash;
99         emit ContenthashChanged(node, hash);
100     }
101 
102     /**
103      * Sets the name associated with an ENS node, for reverse records.
104      * May only be called by the owner of that node in the ENS registry.
105      * @param node The node to update.
106      * @param name The name to set.
107      */
108     function setName(bytes32 node, string name) public onlyOwner(node) {
109         records[node].name = name;
110         emit NameChanged(node, name);
111     }
112 
113     /**
114      * Sets the ABI associated with an ENS node.
115      * Nodes may have one ABI of each content type. To remove an ABI, set it to
116      * the empty string.
117      * @param node The node to update.
118      * @param contentType The content type of the ABI
119      * @param data The ABI data.
120      */
121     function setABI(bytes32 node, uint256 contentType, bytes data) public onlyOwner(node) {
122         // Content types must be powers of 2
123         require(((contentType - 1) & contentType) == 0);
124 
125         records[node].abis[contentType] = data;
126         emit ABIChanged(node, contentType);
127     }
128 
129     /**
130      * Sets the SECP256k1 public key associated with an ENS node.
131      * @param node The ENS node to query
132      * @param x the X coordinate of the curve point for the public key.
133      * @param y the Y coordinate of the curve point for the public key.
134      */
135     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public onlyOwner(node) {
136         records[node].pubkey = PublicKey(x, y);
137         emit PubkeyChanged(node, x, y);
138     }
139 
140     /**
141      * Sets the text data associated with an ENS node and key.
142      * May only be called by the owner of that node in the ENS registry.
143      * @param node The node to update.
144      * @param key The key to set.
145      * @param value The text data value to set.
146      */
147     function setText(bytes32 node, string key, string value) public onlyOwner(node) {
148         records[node].text[key] = value;
149         emit TextChanged(node, key, key);
150     }
151 
152     /**
153      * Returns the text data associated with an ENS node and key.
154      * @param node The ENS node to query.
155      * @param key The text data key to query.
156      * @return The associated text data.
157      */
158     function text(bytes32 node, string key) public view returns (string) {
159         return records[node].text[key];
160     }
161 
162     /**
163      * Returns the SECP256k1 public key associated with an ENS node.
164      * Defined in EIP 619.
165      * @param node The ENS node to query
166      * @return x, y the X and Y coordinates of the curve point for the public key.
167      */
168     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
169         return (records[node].pubkey.x, records[node].pubkey.y);
170     }
171 
172     /**
173      * Returns the ABI associated with an ENS node.
174      * Defined in EIP205.
175      * @param node The ENS node to query
176      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
177      * @return contentType The content type of the return value
178      * @return data The ABI data
179      */
180     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
181         Record storage record = records[node];
182         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
183             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
184                 data = record.abis[contentType];
185                 return;
186             }
187         }
188         contentType = 0;
189     }
190 
191     /**
192      * Returns the name associated with an ENS node, for reverse records.
193      * Defined in EIP181.
194      * @param node The ENS node to query.
195      * @return The associated name.
196      */
197     function name(bytes32 node) public view returns (string) {
198         return records[node].name;
199     }
200 
201     /**
202      * Returns the address associated with an ENS node.
203      * @param node The ENS node to query.
204      * @return The associated address.
205      */
206     function addr(bytes32 node) public view returns (address) {
207         return records[node].addr;
208     }
209 
210     /**
211      * Returns the contenthash associated with an ENS node.
212      * @param node The ENS node to query.
213      * @return The associated contenthash.
214      */
215     function contenthash(bytes32 node) public view returns (bytes) {
216         return records[node].contenthash;
217     }
218 
219     /**
220      * Returns true if the resolver implements the interface specified by the provided hash.
221      * @param interfaceID The ID of the interface to check for.
222      * @return True if the contract implements the requested interface.
223      */
224     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
225         return interfaceID == ADDR_INTERFACE_ID ||
226         interfaceID == NAME_INTERFACE_ID ||
227         interfaceID == ABI_INTERFACE_ID ||
228         interfaceID == PUBKEY_INTERFACE_ID ||
229         interfaceID == TEXT_INTERFACE_ID ||
230         interfaceID == CONTENTHASH_INTERFACE_ID ||
231         interfaceID == INTERFACE_META_ID;
232     }
233 }