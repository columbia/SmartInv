1 pragma solidity ^0.4.20;
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
29  * The ENS registry contract.
30  */
31 contract SvEnsRegistry is ENS {
32     struct Record {
33         address owner;
34         address resolver;
35         uint64 ttl;
36     }
37 
38     mapping (bytes32 => Record) records;
39 
40     // Permits modifications only by the owner of the specified node.
41     modifier only_owner(bytes32 node) {
42         require(records[node].owner == msg.sender);
43         _;
44     }
45 
46     /**
47      * @dev Constructs a new ENS registrar.
48      */
49     function SvEnsRegistry() public {
50         records[0x0].owner = msg.sender;
51     }
52 
53     /**
54      * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
55      * @param node The node to transfer ownership of.
56      * @param owner The address of the new owner.
57      */
58     function setOwner(bytes32 node, address owner) external only_owner(node) {
59         emit Transfer(node, owner);
60         records[node].owner = owner;
61     }
62 
63     /**
64      * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
65      * @param node The parent node.
66      * @param label The hash of the label specifying the subnode.
67      * @param owner The address of the new owner.
68      */
69     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external only_owner(node) returns (bytes32) {
70         bytes32 subnode = keccak256(node, label);
71         emit NewOwner(node, label, owner);
72         records[subnode].owner = owner;
73         return subnode;
74     }
75 
76     /**
77      * @dev Sets the resolver address for the specified node.
78      * @param node The node to update.
79      * @param resolver The address of the resolver.
80      */
81     function setResolver(bytes32 node, address resolver) external only_owner(node) {
82         emit NewResolver(node, resolver);
83         records[node].resolver = resolver;
84     }
85 
86     /**
87      * @dev Sets the TTL for the specified node.
88      * @param node The node to update.
89      * @param ttl The TTL in seconds.
90      */
91     function setTTL(bytes32 node, uint64 ttl) external only_owner(node) {
92         emit NewTTL(node, ttl);
93         records[node].ttl = ttl;
94     }
95 
96     /**
97      * @dev Returns the address that owns the specified node.
98      * @param node The specified node.
99      * @return address of the owner.
100      */
101     function owner(bytes32 node) external view returns (address) {
102         return records[node].owner;
103     }
104 
105     /**
106      * @dev Returns the address of the resolver for the specified node.
107      * @param node The specified node.
108      * @return address of the resolver.
109      */
110     function resolver(bytes32 node) external view returns (address) {
111         return records[node].resolver;
112     }
113 
114     /**
115      * @dev Returns the TTL of a node, and any records associated with it.
116      * @param node The specified node.
117      * @return ttl of the node.
118      */
119     function ttl(bytes32 node) external view returns (uint64) {
120         return records[node].ttl;
121     }
122 
123 }