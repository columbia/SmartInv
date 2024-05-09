1 // File: @ensdomains/ens/contracts/ENS.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface ENS {
6 
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19 
20     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
21     function setResolver(bytes32 node, address resolver) external;
22     function setOwner(bytes32 node, address owner) external;
23     function setTTL(bytes32 node, uint64 ttl) external;
24     function owner(bytes32 node) external view returns (address);
25     function resolver(bytes32 node) external view returns (address);
26     function ttl(bytes32 node) external view returns (uint64);
27 
28 }
29 
30 // File: contracts/Ownable.sol
31 
32 pragma solidity ^0.5.0;
33 
34 contract Ownable {
35 
36     address public owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     modifier onlyOwner {
41         require(isOwner(msg.sender));
42         _;
43     }
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     function transferOwnership(address newOwner) public onlyOwner {
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function isOwner(address addr) public view returns (bool) {
55         return owner == addr;
56     }
57 }
58 
59 // File: contracts/Controllable.sol
60 
61 pragma solidity ^0.5.0;
62 
63 
64 contract Controllable is Ownable {
65     mapping(address=>bool) public controllers;
66 
67     event ControllerChanged(address indexed controller, bool enabled);
68 
69     modifier onlyController {
70         require(controllers[msg.sender]);
71         _;
72     }
73 
74     function setController(address controller, bool enabled) public onlyOwner {
75         controllers[controller] = enabled;
76         emit ControllerChanged(controller, enabled);
77     }
78 }
79 
80 // File: contracts/Root.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 
86 
87 contract Root is Ownable, Controllable {
88     bytes32 constant private ROOT_NODE = bytes32(0);
89 
90     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
91 
92     event TLDLocked(bytes32 indexed label);
93 
94     ENS public ens;
95     mapping(bytes32=>bool) public locked;
96 
97     constructor(ENS _ens) public {
98         ens = _ens;
99     }
100 
101     function setSubnodeOwner(bytes32 label, address owner) external onlyController {
102         require(!locked[label]);
103         ens.setSubnodeOwner(ROOT_NODE, label, owner);
104     }
105 
106     function setResolver(address resolver) external onlyOwner {
107         ens.setResolver(ROOT_NODE, resolver);
108     }
109 
110     function lock(bytes32 label) external onlyOwner {
111         emit TLDLocked(label);
112         locked[label] = true;
113     }
114 
115     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
116         return interfaceID == INTERFACE_META_ID;
117     }
118 }