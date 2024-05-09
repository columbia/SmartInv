1 // File: contracts/ens/AbstractENS.sol
2 
3 pragma solidity ^0.5.0;
4 
5 contract AbstractENS {
6     function owner(bytes32 _node) public view returns(address);
7     function resolver(bytes32 _node) public view returns(address);
8     function ttl(bytes32 _node) public view returns(uint64);
9     function setOwner(bytes32 _node, address _owner) public;
10     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
11     function setResolver(bytes32 _node, address _resolver) public;
12     function setTTL(bytes32 _node, uint64 _ttl) public;
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
27 // File: contracts/ens/PublicResolver.sol
28 
29 pragma solidity ^0.5.0;
30 
31 
32 /**
33  * A simple resolver anyone can use; only allows the owner of a node to set its
34  * address.
35  */
36 contract PublicResolver {
37     AbstractENS ens;
38     mapping(bytes32=>address) addresses;
39     mapping(bytes32=>bytes32) hashes;
40 
41     modifier only_owner(bytes32 _node) {
42         require(ens.owner(_node) == msg.sender);
43         _;
44     }
45 
46     /**
47      * Constructor.
48      * @param _ensAddr The ENS registrar contract.
49      */
50     constructor(AbstractENS _ensAddr) public {
51         ens = _ensAddr;
52     }
53 
54     /**
55      * Returns true if the specified node has the specified record type.
56      * @param _node The ENS node to query.
57      * @param _kind The record type name, as specified in EIP137.
58      * @return True if this resolver has a record of the provided type on the
59      *         provided node.
60      */
61     function has(bytes32 _node, bytes32 _kind) public view returns (bool) {
62         return (_kind == "addr" && addresses[_node] != address(0)) || (_kind == "hash" && hashes[_node] != 0);
63     }
64 
65     /**
66      * Returns true if the resolver implements the interface specified by the provided hash.
67      * @param _interfaceID The ID of the interface to check for.
68      * @return True if the contract implements the requested interface.
69      */
70     function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
71         return _interfaceID == 0x3b3b57de || _interfaceID == 0xd8389dc5;
72     }
73 
74     /**
75      * Returns the address associated with an ENS node.
76      * @param _node The ENS node to query.
77      * @return The associated address.
78      */
79     function addr(bytes32 _node) public view returns (address ret) {
80         ret = addresses[_node];
81     }
82 
83     /**
84      * Sets the address associated with an ENS node.
85      * May only be called by the owner of that node in the ENS registry.
86      * @param _node The node to update.
87      * @param _addr The address to set.
88      */
89     function setAddr(bytes32 _node, address _addr) public only_owner(_node) {
90         addresses[_node] = _addr;
91     }
92 
93     /**
94      * Returns the content hash associated with an ENS node.
95      * Note that this resource type is not standardized, and will likely change
96      * in future to a resource type based on multihash.
97      * @param _node The ENS node to query.
98      * @return The associated content hash.
99      */
100     function content(bytes32 _node) public view returns (bytes32 ret) {
101         ret = hashes[_node];
102     }
103 
104     /**
105      * Sets the content hash associated with an ENS node.
106      * May only be called by the owner of that node in the ENS registry.
107      * Note that this resource type is not standardized, and will likely change
108      * in future to a resource type based on multihash.
109      * @param _node The node to update.
110      * @param _hash The content hash to set
111      */
112     function setContent(bytes32 _node, bytes32 _hash) public only_owner(_node) {
113         hashes[_node] = _hash;
114     }
115 }