1 pragma solidity ^0.4.20;
2 
3 interface SvEns {
4     // Logged when the owner of a node assigns a new owner to a subnode.
5     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
6 
7     // Logged when the owner of a node transfers ownership to a new account.
8     event Transfer(bytes32 indexed node, address owner);
9 
10     // Logged when the resolver for a node changes.
11     event NewResolver(bytes32 indexed node, address resolver);
12 
13     // Logged when the TTL of a node changes
14     event NewTTL(bytes32 indexed node, uint64 ttl);
15 
16 
17     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
18     function setResolver(bytes32 node, address resolver) external;
19     function setOwner(bytes32 node, address owner) external;
20     function setTTL(bytes32 node, uint64 ttl) external;
21     function owner(bytes32 node) external view returns (address);
22     function resolver(bytes32 node) external view returns (address);
23     function ttl(bytes32 node) external view returns (uint64);
24 }
25 
26 
27 /**
28  * A registrar that allocates subdomains to the first admin to claim them
29  */
30 contract SvEnsCompatibleRegistrar {
31     SvEns public ens;
32     bytes32 public rootNode;
33     mapping (bytes32 => bool) knownNodes;
34     mapping (address => bool) admins;
35     address public owner;
36 
37 
38     modifier req(bool c) {
39         require(c);
40         _;
41     }
42 
43 
44     /**
45      * Constructor.
46      * @param ensAddr The address of the ENS registry.
47      * @param node The node that this registrar administers.
48      */
49     function SvEnsCompatibleRegistrar(SvEns ensAddr, bytes32 node) public {
50         ens = ensAddr;
51         rootNode = node;
52         admins[msg.sender] = true;
53         owner = msg.sender;
54     }
55 
56     function addAdmin(address newAdmin) req(admins[msg.sender]) external {
57         admins[newAdmin] = true;
58     }
59 
60     function remAdmin(address oldAdmin) req(admins[msg.sender]) external {
61         require(oldAdmin != msg.sender && oldAdmin != owner);
62         admins[oldAdmin] = false;
63     }
64 
65     function chOwner(address newOwner, bool remPrevOwnerAsAdmin) req(msg.sender == owner) external {
66         if (remPrevOwnerAsAdmin) {
67             admins[owner] = false;
68         }
69         owner = newOwner;
70         admins[newOwner] = true;
71     }
72 
73     /**
74      * Register a name that's not currently registered
75      * @param subnode The hash of the label to register.
76      * @param _owner The address of the new owner.
77      */
78     function register(bytes32 subnode, address _owner) req(admins[msg.sender]) external {
79         _setSubnodeOwner(subnode, _owner);
80     }
81 
82     /**
83      * Register a name that's not currently registered
84      * @param subnodeStr The label to register.
85      * @param _owner The address of the new owner.
86      */
87     function registerName(string subnodeStr, address _owner) req(admins[msg.sender]) external {
88         // labelhash
89         bytes32 subnode = keccak256(subnodeStr);
90         _setSubnodeOwner(subnode, _owner);
91     }
92 
93     /**
94      * INTERNAL - Register a name that's not currently registered
95      * @param subnode The hash of the label to register.
96      * @param _owner The address of the new owner.
97      */
98     function _setSubnodeOwner(bytes32 subnode, address _owner) internal {
99         require(!knownNodes[subnode]);
100         knownNodes[subnode] = true;
101         ens.setSubnodeOwner(rootNode, subnode, _owner);
102     }
103 }