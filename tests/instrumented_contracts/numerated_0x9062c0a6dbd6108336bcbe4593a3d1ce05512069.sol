1 pragma solidity ^0.4.10;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function ttl(bytes32 node) constant returns(uint64);
7     function setOwner(bytes32 node, address owner);
8     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
9     function setResolver(bytes32 node, address resolver);
10     function setTTL(bytes32 node, uint64 ttl);
11 }
12 
13 contract Resolver {
14     function setName(bytes32 node, string name) public;
15 }
16 
17 /**
18  * @dev Provides a default implementation of a resolver for reverse records,
19  * which permits only the owner to update it.
20  */
21 contract DefaultReverseResolver is Resolver {
22     // namehash('addr.reverse')
23     bytes32 constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
24 
25     AbstractENS public ens;
26     mapping(bytes32=>string) public name;
27     
28     /**
29      * @dev Constructor
30      * @param ensAddr The address of the ENS registry.
31      */
32     function DefaultReverseResolver(AbstractENS ensAddr) {
33         ens = ensAddr;
34 
35         // Assign ownership of the reverse record to our deployer
36         var registrar = ReverseRegistrar(ens.owner(ADDR_REVERSE_NODE));
37         if(address(registrar) != 0) {
38             registrar.claim(msg.sender);
39         }
40     }
41 
42     /**
43      * @dev Only permits calls by the reverse registrar.
44      * @param node The node permission is required for.
45      */
46     modifier owner_only(bytes32 node) {
47         require(msg.sender == ens.owner(node));
48         _;
49     }
50 
51     /**
52      * @dev Sets the name for a node.
53      * @param node The node to update.
54      * @param _name The name to set.
55      */
56     function setName(bytes32 node, string _name) public owner_only(node) {
57         name[node] = _name;
58     }
59 }
60 
61 contract ReverseRegistrar {
62     // namehash('addr.reverse')
63     bytes32 constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
64 
65     AbstractENS public ens;
66     Resolver public defaultResolver;
67 
68     /**
69      * @dev Constructor
70      * @param ensAddr The address of the ENS registry.
71      * @param resolverAddr The address of the default reverse resolver.
72      */
73     function ReverseRegistrar(AbstractENS ensAddr, Resolver resolverAddr) {
74         ens = ensAddr;
75         defaultResolver = resolverAddr;
76 
77         // Assign ownership of the reverse record to our deployer
78         var oldRegistrar = ReverseRegistrar(ens.owner(ADDR_REVERSE_NODE));
79         if(address(oldRegistrar) != 0) {
80             oldRegistrar.claim(msg.sender);
81         }
82     }
83     
84     /**
85      * @dev Transfers ownership of the reverse ENS record associated with the
86      *      calling account.
87      * @param owner The address to set as the owner of the reverse record in ENS.
88      * @return The ENS node hash of the reverse record.
89      */
90     function claim(address owner) returns (bytes32 node) {
91         return claimWithResolver(owner, 0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the reverse ENS record associated with the
96      *      calling account.
97      * @param owner The address to set as the owner of the reverse record in ENS.
98      * @param resolver The address of the resolver to set; 0 to leave unchanged.
99      * @return The ENS node hash of the reverse record.
100      */
101     function claimWithResolver(address owner, address resolver) returns (bytes32 node) {
102         var label = sha3HexAddress(msg.sender);
103         node = sha3(ADDR_REVERSE_NODE, label);
104         var currentOwner = ens.owner(node);
105 
106         // Update the resolver if required
107         if(resolver != 0 && resolver != ens.resolver(node)) {
108             // Transfer the name to us first if it's not already
109             if(currentOwner != address(this)) {
110                 ens.setSubnodeOwner(ADDR_REVERSE_NODE, label, this);
111                 currentOwner = address(this);
112             }
113             ens.setResolver(node, resolver);
114         }
115 
116         // Update the owner if required
117         if(currentOwner != owner) {
118             ens.setSubnodeOwner(ADDR_REVERSE_NODE, label, owner);
119         }
120 
121         return node;
122     }
123 
124     /**
125      * @dev Sets the `name()` record for the reverse ENS record associated with
126      * the calling account. First updates the resolver to the default reverse
127      * resolver if necessary.
128      * @param name The name to set for this address.
129      * @return The ENS node hash of the reverse record.
130      */
131     function setName(string name) returns (bytes32 node) {
132         node = claimWithResolver(this, defaultResolver);
133         defaultResolver.setName(node, name);
134         return node;
135     }
136 
137     /**
138      * @dev Returns the node hash for a given account's reverse records.
139      * @param addr The address to hash
140      * @return The ENS node hash.
141      */
142     function node(address addr) constant returns (bytes32 ret) {
143         return sha3(ADDR_REVERSE_NODE, sha3HexAddress(addr));
144     }
145 
146     /**
147      * @dev An optimised function to compute the sha3 of the lower-case
148      *      hexadecimal representation of an Ethereum address.
149      * @param addr The address to hash
150      * @return The SHA3 hash of the lower-case hexadecimal encoding of the
151      *         input address.
152      */
153     function sha3HexAddress(address addr) private returns (bytes32 ret) {
154         addr; ret; // Stop warning us about unused variables
155         assembly {
156             let lookup := 0x3031323334353637383961626364656600000000000000000000000000000000
157             let i := 40
158         loop:
159             i := sub(i, 1)
160             mstore8(i, byte(and(addr, 0xf), lookup))
161             addr := div(addr, 0x10)
162             i := sub(i, 1)
163             mstore8(i, byte(and(addr, 0xf), lookup))
164             addr := div(addr, 0x10)
165             jumpi(loop, i)
166             ret := sha3(0, 40)
167         }
168     }
169 }