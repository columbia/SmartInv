1 pragma solidity ^0.4.0;
2 
3 
4 
5 contract AbstractENS {
6     function owner(bytes32 node) constant returns(address);
7     function resolver(bytes32 node) constant returns(address);
8     function ttl(bytes32 node) constant returns(uint64);
9     function setOwner(bytes32 node, address owner);
10     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
11     function setResolver(bytes32 node, address resolver);
12     function setTTL(bytes32 node, uint64 ttl);
13 
14     // Logged when the owner of a node assigns a new owner to a subnode.
15     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
16 
17     // Logged when the owner of a node transfers ownership to a new account.
18     event Transfer(bytes32 indexed node, address owner);
19 
20     // Logged when the resolver for a node changes.
21     event NewResolver(bytes32 indexed node, address resolver);
22 
23     // Logged when the TTL of a node changes
24     event NewTTL(bytes32 indexed node, uint64 ttl);
25 }
26 
27 
28 /**
29  * A simple resolver anyone can use; only allows the owner of a node to set its
30  * address.
31  */
32 contract PublicResolver {
33     AbstractENS ens;
34     mapping(bytes32=>address) addresses;
35     mapping(bytes32=>bytes32) hashes;
36 
37     modifier only_owner(bytes32 node) {
38         if(ens.owner(node) != msg.sender) throw;
39         _;
40     }
41 
42     /**
43      * Constructor.
44      * @param ensAddr The ENS registrar contract.
45      */
46     function PublicResolver(AbstractENS ensAddr) {
47         ens = ensAddr;
48     }
49 
50     /**
51      * Fallback function.
52      */
53     function() {
54         throw;
55     }
56 
57     /**
58      * Returns true if the specified node has the specified record type.
59      * @param node The ENS node to query.
60      * @param kind The record type name, as specified in EIP137.
61      * @return True if this resolver has a record of the provided type on the
62      *         provided node.
63      */
64     function has(bytes32 node, bytes32 kind) constant returns (bool) {
65         return (kind == "addr" && addresses[node] != 0) || (kind == "hash" && hashes[node] != 0);
66     }
67 
68     /**
69      * Returns true if the resolver implements the interface specified by the provided hash.
70      * @param interfaceID The ID of the interface to check for.
71      * @return True if the contract implements the requested interface.
72      */
73     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
74         return interfaceID == 0x3b3b57de || interfaceID == 0xd8389dc5;
75     }
76 
77     /**
78      * Returns the address associated with an ENS node.
79      * @param node The ENS node to query.
80      * @return The associated address.
81      */
82     function addr(bytes32 node) constant returns (address ret) {
83         ret = addresses[node];
84     }
85 
86     /**
87      * Sets the address associated with an ENS node.
88      * May only be called by the owner of that node in the ENS registry.
89      * @param node The node to update.
90      * @param addr The address to set.
91      */
92     function setAddr(bytes32 node, address addr) only_owner(node) {
93         addresses[node] = addr;
94     }
95 
96     /**
97      * Returns the content hash associated with an ENS node.
98      * Note that this resource type is not standardized, and will likely change
99      * in future to a resource type based on multihash.
100      * @param node The ENS node to query.
101      * @return The associated content hash.
102      */
103     function content(bytes32 node) constant returns (bytes32 ret) {
104         ret = hashes[node];
105     }
106 
107     /**
108      * Sets the content hash associated with an ENS node.
109      * May only be called by the owner of that node in the ENS registry.
110      * Note that this resource type is not standardized, and will likely change
111      * in future to a resource type based on multihash.
112      * @param node The node to update.
113      * @param hash The content hash to set
114      */
115     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
116         hashes[node] = hash;
117     }
118 }