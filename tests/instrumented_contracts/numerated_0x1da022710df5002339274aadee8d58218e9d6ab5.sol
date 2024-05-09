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
36 
37     event AddrChanged(bytes32 indexed node, address a);
38     event ContentChanged(bytes32 indexed node, bytes32 hash);
39     event NameChanged(bytes32 indexed node, string name);
40     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
41     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
42 
43     struct PublicKey {
44         bytes32 x;
45         bytes32 y;
46     }
47 
48     struct Record {
49         address addr;
50         bytes32 content;
51         string name;
52         PublicKey pubkey;
53         mapping(uint256=>bytes) abis;
54     }
55 
56     AbstractENS ens;
57     mapping(bytes32=>Record) records;
58 
59     modifier only_owner(bytes32 node) {
60         if(ens.owner(node) != msg.sender) throw;
61         _;
62     }
63 
64     /**
65      * Constructor.
66      * @param ensAddr The ENS registrar contract.
67      */
68     function PublicResolver(AbstractENS ensAddr) {
69         ens = ensAddr;
70     }
71 
72     /**
73      * Returns true if the resolver implements the interface specified by the provided hash.
74      * @param interfaceID The ID of the interface to check for.
75      * @return True if the contract implements the requested interface.
76      */
77     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
78         return interfaceID == ADDR_INTERFACE_ID ||
79                interfaceID == CONTENT_INTERFACE_ID ||
80                interfaceID == NAME_INTERFACE_ID ||
81                interfaceID == ABI_INTERFACE_ID ||
82                interfaceID == PUBKEY_INTERFACE_ID ||
83                interfaceID == INTERFACE_META_ID;
84     }
85 
86     /**
87      * Returns the address associated with an ENS node.
88      * @param node The ENS node to query.
89      * @return The associated address.
90      */
91     function addr(bytes32 node) constant returns (address ret) {
92         ret = records[node].addr;
93     }
94 
95     /**
96      * Sets the address associated with an ENS node.
97      * May only be called by the owner of that node in the ENS registry.
98      * @param node The node to update.
99      * @param addr The address to set.
100      */
101     function setAddr(bytes32 node, address addr) only_owner(node) {
102         records[node].addr = addr;
103         AddrChanged(node, addr);
104     }
105 
106     /**
107      * Returns the content hash associated with an ENS node.
108      * Note that this resource type is not standardized, and will likely change
109      * in future to a resource type based on multihash.
110      * @param node The ENS node to query.
111      * @return The associated content hash.
112      */
113     function content(bytes32 node) constant returns (bytes32 ret) {
114         ret = records[node].content;
115     }
116 
117     /**
118      * Sets the content hash associated with an ENS node.
119      * May only be called by the owner of that node in the ENS registry.
120      * Note that this resource type is not standardized, and will likely change
121      * in future to a resource type based on multihash.
122      * @param node The node to update.
123      * @param hash The content hash to set
124      */
125     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
126         records[node].content = hash;
127         ContentChanged(node, hash);
128     }
129 
130     /**
131      * Returns the name associated with an ENS node, for reverse records.
132      * Defined in EIP181.
133      * @param node The ENS node to query.
134      * @return The associated name.
135      */
136     function name(bytes32 node) constant returns (string ret) {
137         ret = records[node].name;
138     }
139     
140     /**
141      * Sets the name associated with an ENS node, for reverse records.
142      * May only be called by the owner of that node in the ENS registry.
143      * @param node The node to update.
144      * @param name The name to set.
145      */
146     function setName(bytes32 node, string name) only_owner(node) {
147         records[node].name = name;
148         NameChanged(node, name);
149     }
150 
151     /**
152      * Returns the ABI associated with an ENS node.
153      * Defined in EIP205.
154      * @param node The ENS node to query
155      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
156      * @return contentType The content type of the return value
157      * @return data The ABI data
158      */
159     function ABI(bytes32 node, uint256 contentTypes) constant returns (uint256 contentType, bytes data) {
160         var record = records[node];
161         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
162             if((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
163                 data = record.abis[contentType];
164                 return;
165             }
166         }
167         contentType = 0;
168     }
169 
170     /**
171      * Sets the ABI associated with an ENS node.
172      * Nodes may have one ABI of each content type. To remove an ABI, set it to
173      * the empty string.
174      * @param node The node to update.
175      * @param contentType The content type of the ABI
176      * @param data The ABI data.
177      */
178     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) {
179         // Content types must be powers of 2
180         if(((contentType - 1) & contentType) != 0) throw;
181         
182         records[node].abis[contentType] = data;
183         ABIChanged(node, contentType);
184     }
185     
186     /**
187      * Returns the SECP256k1 public key associated with an ENS node.
188      * Defined in EIP 619.
189      * @param node The ENS node to query
190      * @return x, y the X and Y coordinates of the curve point for the public key.
191      */
192     function pubkey(bytes32 node) constant returns (bytes32 x, bytes32 y) {
193         return (records[node].pubkey.x, records[node].pubkey.y);
194     }
195     
196     /**
197      * Sets the SECP256k1 public key associated with an ENS node.
198      * @param node The ENS node to query
199      * @param x the X coordinate of the curve point for the public key.
200      * @param y the Y coordinate of the curve point for the public key.
201      */
202     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) {
203         records[node].pubkey = PublicKey(x, y);
204         PubkeyChanged(node, x, y);
205     }
206 }