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
29  * A registrar that allocates subdomains to the first admin to claim them
30  */
31 contract SvEnsRegistrar {
32     ENS public ens;
33     bytes32 public rootNode;
34     mapping (bytes32 => bool) knownNodes;
35     mapping (address => bool) admins;
36     address public owner;
37 
38 
39     modifier req(bool c) {
40         require(c);
41         _;
42     }
43 
44 
45     /**
46      * Constructor.
47      * @param ensAddr The address of the ENS registry.
48      * @param node The node that this registrar administers.
49      */
50     function SvEnsRegistrar(ENS ensAddr, bytes32 node) public {
51         ens = ensAddr;
52         rootNode = node;
53         admins[msg.sender] = true;
54         owner = msg.sender;
55     }
56 
57     function addAdmin(address newAdmin) req(admins[msg.sender]) external {
58         admins[newAdmin] = true;
59     }
60 
61     function remAdmin(address oldAdmin) req(admins[msg.sender]) external {
62         require(oldAdmin != msg.sender && oldAdmin != owner);
63         admins[oldAdmin] = false;
64     }
65 
66     function chOwner(address newOwner, bool remPrevOwnerAsAdmin) req(msg.sender == owner) external {
67         if (remPrevOwnerAsAdmin) {
68             admins[owner] = false;
69         }
70         owner = newOwner;
71         admins[newOwner] = true;
72     }
73 
74     /**
75      * Register a name that's not currently registered
76      * @param subnode The hash of the label to register.
77      * @param _owner The address of the new owner.
78      */
79     function register(bytes32 subnode, address _owner) req(admins[msg.sender]) external {
80         _setSubnodeOwner(subnode, _owner);
81     }
82 
83     /**
84      * Register a name that's not currently registered
85      * @param subnodeStr The label to register.
86      * @param _owner The address of the new owner.
87      */
88     function registerName(string subnodeStr, address _owner) req(admins[msg.sender]) external {
89         // labelhash
90         bytes32 subnode = keccak256(subnodeStr);
91         _setSubnodeOwner(subnode, _owner);
92     }
93 
94     /**
95      * INTERNAL - Register a name that's not currently registered
96      * @param subnode The hash of the label to register.
97      * @param _owner The address of the new owner.
98      */
99     function _setSubnodeOwner(bytes32 subnode, address _owner) internal {
100         require(!knownNodes[subnode]);
101         knownNodes[subnode] = true;
102         ens.setSubnodeOwner(rootNode, subnode, _owner);
103     }
104 }