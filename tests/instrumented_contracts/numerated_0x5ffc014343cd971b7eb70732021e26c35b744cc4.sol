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
26  * A simple resolver anyone can use; only allows the owner of a node to set its
27  * address.
28  */
29 contract PublicResolver {
30     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
31     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
32     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
33     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
34     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
35     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
36     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
37 
38     event AddrChanged(bytes32 indexed node, address a);
39     event ContentChanged(bytes32 indexed node, bytes32 hash);
40     event NameChanged(bytes32 indexed node, string name);
41     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
42     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
43     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
44 
45     struct PublicKey {
46         bytes32 x;
47         bytes32 y;
48     }
49 
50     struct Record {
51         address addr;
52         bytes32 content;
53         string name;
54         PublicKey pubkey;
55         mapping(string=>string) text;
56         mapping(uint256=>bytes) abis;
57     }
58 
59     AbstractENS ens;
60     mapping(bytes32=>Record) records;
61 
62     modifier only_owner(bytes32 node) {
63         if(ens.owner(node) != msg.sender) throw;
64         _;
65     }
66 
67     /**
68      * Constructor.
69      * @param ensAddr The ENS registrar contract.
70      */
71     function PublicResolver(AbstractENS ensAddr) {
72         ens = ensAddr;
73     }
74 
75     /**
76      * Returns true if the resolver implements the interface specified by the provided hash.
77      * @param interfaceID The ID of the interface to check for.
78      * @return True if the contract implements the requested interface.
79      */
80     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
81         return interfaceID == ADDR_INTERFACE_ID ||
82                interfaceID == CONTENT_INTERFACE_ID ||
83                interfaceID == NAME_INTERFACE_ID ||
84                interfaceID == ABI_INTERFACE_ID ||
85                interfaceID == PUBKEY_INTERFACE_ID ||
86                interfaceID == TEXT_INTERFACE_ID ||
87                interfaceID == INTERFACE_META_ID;
88     }
89 
90     /**
91      * Returns the address associated with an ENS node.
92      * @param node The ENS node to query.
93      * @return The associated address.
94      */
95     function addr(bytes32 node) constant returns (address ret) {
96         ret = records[node].addr;
97     }
98 
99     /**
100      * Sets the address associated with an ENS node.
101      * May only be called by the owner of that node in the ENS registry.
102      * @param node The node to update.
103      * @param addr The address to set.
104      */
105     function setAddr(bytes32 node, address addr) only_owner(node) {
106         records[node].addr = addr;
107         AddrChanged(node, addr);
108     }
109 
110     /**
111      * Returns the content hash associated with an ENS node.
112      * Note that this resource type is not standardized, and will likely change
113      * in future to a resource type based on multihash.
114      * @param node The ENS node to query.
115      * @return The associated content hash.
116      */
117     function content(bytes32 node) constant returns (bytes32 ret) {
118         ret = records[node].content;
119     }
120 
121     /**
122      * Sets the content hash associated with an ENS node.
123      * May only be called by the owner of that node in the ENS registry.
124      * Note that this resource type is not standardized, and will likely change
125      * in future to a resource type based on multihash.
126      * @param node The node to update.
127      * @param hash The content hash to set
128      */
129     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
130         records[node].content = hash;
131         ContentChanged(node, hash);
132     }
133 
134     /**
135      * Returns the name associated with an ENS node, for reverse records.
136      * Defined in EIP181.
137      * @param node The ENS node to query.
138      * @return The associated name.
139      */
140     function name(bytes32 node) constant returns (string ret) {
141         ret = records[node].name;
142     }
143     
144     /**
145      * Sets the name associated with an ENS node, for reverse records.
146      * May only be called by the owner of that node in the ENS registry.
147      * @param node The node to update.
148      * @param name The name to set.
149      */
150     function setName(bytes32 node, string name) only_owner(node) {
151         records[node].name = name;
152         NameChanged(node, name);
153     }
154 
155     /**
156      * Returns the ABI associated with an ENS node.
157      * Defined in EIP205.
158      * @param node The ENS node to query
159      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
160      * @return contentType The content type of the return value
161      * @return data The ABI data
162      */
163     function ABI(bytes32 node, uint256 contentTypes) constant returns (uint256 contentType, bytes data) {
164         var record = records[node];
165         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
166             if((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
167                 data = record.abis[contentType];
168                 return;
169             }
170         }
171         contentType = 0;
172     }
173 
174     /**
175      * Sets the ABI associated with an ENS node.
176      * Nodes may have one ABI of each content type. To remove an ABI, set it to
177      * the empty string.
178      * @param node The node to update.
179      * @param contentType The content type of the ABI
180      * @param data The ABI data.
181      */
182     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) {
183         // Content types must be powers of 2
184         if(((contentType - 1) & contentType) != 0) throw;
185         
186         records[node].abis[contentType] = data;
187         ABIChanged(node, contentType);
188     }
189     
190     /**
191      * Returns the SECP256k1 public key associated with an ENS node.
192      * Defined in EIP 619.
193      * @param node The ENS node to query
194      * @return x, y the X and Y coordinates of the curve point for the public key.
195      */
196     function pubkey(bytes32 node) constant returns (bytes32 x, bytes32 y) {
197         return (records[node].pubkey.x, records[node].pubkey.y);
198     }
199     
200     /**
201      * Sets the SECP256k1 public key associated with an ENS node.
202      * @param node The ENS node to query
203      * @param x the X coordinate of the curve point for the public key.
204      * @param y the Y coordinate of the curve point for the public key.
205      */
206     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) {
207         records[node].pubkey = PublicKey(x, y);
208         PubkeyChanged(node, x, y);
209     }
210 
211     /**
212      * Returns the text data associated with an ENS node and key.
213      * @param node The ENS node to query.
214      * @param key The text data key to query.
215      * @return The associated text data.
216      */
217     function text(bytes32 node, string key) constant returns (string ret) {
218         ret = records[node].text[key];
219     }
220 
221     /**
222      * Sets the text data associated with an ENS node and key.
223      * May only be called by the owner of that node in the ENS registry.
224      * @param node The node to update.
225      * @param key The key to set.
226      * @param value The text data value to set.
227      */
228     function setText(bytes32 node, string key, string value) only_owner(node) {
229         records[node].text[key] = value;
230         TextChanged(node, key, key);
231     }
232 }