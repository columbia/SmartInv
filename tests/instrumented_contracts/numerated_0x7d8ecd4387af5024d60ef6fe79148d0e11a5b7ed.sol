1 pragma solidity ^0.4.0;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function ttl(bytes32 node) constant returns(uint64);
7     function setOwner(bytes32 node, address owner);
8     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
9     function setResolver(bytes32 node, address resolver);
10     function setTTL(bytes32 node, uint64 ttl);
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed node, address owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed node, address resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed node, uint64 ttl);
23 }
24 
25 /**
26  * ENS resolver that supports MX records for decentralized mail systems.
27  */
28 contract PublicMxResolver {
29     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
30     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
31     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
32     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
33     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
34     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
35     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
36     bytes4 constant MX_INTERFACE_ID = 0x7d753cf6;
37 
38     event AddrChanged(bytes32 indexed node, address a);
39     event ContentChanged(bytes32 indexed node, bytes32 hash);
40     event NameChanged(bytes32 indexed node, string name);
41     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
42     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
43     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
44     event MxRecordChanged(bytes32 indexed node, address mx);
45 
46     struct PublicKey {
47         bytes32 x;
48         bytes32 y;
49     }
50 
51     struct Record {
52         address addr;
53         bytes32 content;
54         string name;
55         PublicKey pubkey;
56         address mx;
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
73     function PublicMxResolver(AbstractENS ensAddr) {
74         ens = ensAddr;
75     }
76 
77     /**
78      * Returns true if the resolver implements the interface specified by the provided hash.
79      * @param interfaceID The ID of the interface to check for.
80      * @return True if the contract implements the requested interface.
81      */
82     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
83         return interfaceID == ADDR_INTERFACE_ID ||
84                interfaceID == CONTENT_INTERFACE_ID ||
85                interfaceID == NAME_INTERFACE_ID ||
86                interfaceID == ABI_INTERFACE_ID ||
87                interfaceID == PUBKEY_INTERFACE_ID ||
88                interfaceID == TEXT_INTERFACE_ID ||
89                interfaceID == INTERFACE_META_ID ||
90                interfaceID == MX_INTERFACE_ID;
91     }
92 
93     /**
94      * Returns the address associated with an ENS node.
95      * @param node The ENS node to query.
96      * @return The associated address.
97      */
98     function addr(bytes32 node) constant returns (address ret) {
99         ret = records[node].addr;
100     }
101 
102     /**
103      * Sets the address associated with an ENS node.
104      * May only be called by the owner of that node in the ENS registry.
105      * @param node The node to update.
106      * @param addr The address to set.
107      */
108     function setAddr(bytes32 node, address addr) only_owner(node) {
109         records[node].addr = addr;
110         AddrChanged(node, addr);
111     }
112 
113     /**
114      * Returns the content hash associated with an ENS node.
115      * Note that this resource type is not standardized, and will likely change
116      * in future to a resource type based on multihash.
117      * @param node The ENS node to query.
118      * @return The associated content hash.
119      */
120     function content(bytes32 node) constant returns (bytes32 ret) {
121         ret = records[node].content;
122     }
123 
124     /**
125      * Sets the content hash associated with an ENS node.
126      * May only be called by the owner of that node in the ENS registry.
127      * Note that this resource type is not standardized, and will likely change
128      * in future to a resource type based on multihash.
129      * @param node The node to update.
130      * @param hash The content hash to set
131      */
132     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
133         records[node].content = hash;
134         ContentChanged(node, hash);
135     }
136 
137     /**
138      * Returns the name associated with an ENS node, for reverse records.
139      * Defined in EIP181.
140      * @param node The ENS node to query.
141      * @return The associated name.
142      */
143     function name(bytes32 node) constant returns (string ret) {
144         ret = records[node].name;
145     }
146     
147     /**
148      * Sets the name associated with an ENS node, for reverse records.
149      * May only be called by the owner of that node in the ENS registry.
150      * @param node The node to update.
151      * @param name The name to set.
152      */
153     function setName(bytes32 node, string name) only_owner(node) {
154         records[node].name = name;
155         NameChanged(node, name);
156     }
157 
158     /**
159      * Returns the ABI associated with an ENS node.
160      * Defined in EIP205.
161      * @param node The ENS node to query
162      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
163      * @return contentType The content type of the return value
164      * @return data The ABI data
165      */
166     function ABI(bytes32 node, uint256 contentTypes) constant returns (uint256 contentType, bytes data) {
167         var record = records[node];
168         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
169             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
170                 data = record.abis[contentType];
171                 return;
172             }
173         }
174         contentType = 0;
175     }
176 
177     /**
178      * Sets the ABI associated with an ENS node.
179      * Nodes may have one ABI of each content type. To remove an ABI, set it to
180      * the empty string.
181      * @param node The node to update.
182      * @param contentType The content type of the ABI
183      * @param data The ABI data.
184      */
185     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) {
186         // Content types must be powers of 2
187         if (((contentType - 1) & contentType) != 0) throw;
188         
189         records[node].abis[contentType] = data;
190         ABIChanged(node, contentType);
191     }
192     
193     /**
194      * Returns the SECP256k1 public key associated with an ENS node.
195      * Defined in EIP 619.
196      * @param node The ENS node to query
197      * @return x, y the X and Y coordinates of the curve point for the public key.
198      */
199     function pubkey(bytes32 node) constant returns (bytes32 x, bytes32 y) {
200         return (records[node].pubkey.x, records[node].pubkey.y);
201     }
202     
203     /**
204      * Sets the SECP256k1 public key associated with an ENS node.
205      * @param node The ENS node to query
206      * @param x the X coordinate of the curve point for the public key.
207      * @param y the Y coordinate of the curve point for the public key.
208      */
209     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) {
210         records[node].pubkey = PublicKey(x, y);
211         PubkeyChanged(node, x, y);
212     }
213 
214     /**
215      * Returns the text data associated with an ENS node and key.
216      * @param node The ENS node to query.
217      * @param key The text data key to query.
218      * @return The associated text data.
219      */
220     function text(bytes32 node, string key) constant returns (string ret) {
221         ret = records[node].text[key];
222     }
223 
224     /**
225      * Sets the text data associated with an ENS node and key.
226      * May only be called by the owner of that node in the ENS registry.
227      * @param node The node to update.
228      * @param key The key to set.
229      * @param value The text data value to set.
230      */
231     function setText(bytes32 node, string key, string value) only_owner(node) {
232         records[node].text[key] = value;
233         TextChanged(node, key, key);
234     }
235 
236     /**
237      * Returns address of MX contract from MX record associated with an ENS node.
238      * Can be called by anyone.
239      * @param node The ENS node to query.
240      */
241     function mx(bytes32 node) constant returns (address) {
242         return records[node].mx;
243     }
244 
245     /**
246      * Sets MX record data associated with an ENS node.
247      * May only be called by the owner of that node in the ENS registry.
248      * @param node The node to update.
249      * @param mx Address of MX contract.
250      */
251     function setMx(bytes32 node, address mx) only_owner(node) {
252         records[node].mx = mx;
253         MxRecordChanged(node, mx);
254     }
255 }