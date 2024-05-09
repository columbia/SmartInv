1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipRenounced(address indexed previousOwner);
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to relinquish control of the contract.
35    * @notice Renouncing to ownership will leave the contract without an owner.
36    * It will not be possible to call the functions with the `onlyOwner`
37    * modifier anymore.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 interface ENS {
65 
66     // Logged when the owner of a node assigns a new owner to a subnode.
67     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
68 
69     // Logged when the owner of a node transfers ownership to a new account.
70     event Transfer(bytes32 indexed node, address owner);
71 
72     // Logged when the resolver for a node changes.
73     event NewResolver(bytes32 indexed node, address resolver);
74 
75     // Logged when the TTL of a node changes
76     event NewTTL(bytes32 indexed node, uint64 ttl);
77 
78 
79     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
80     function setResolver(bytes32 node, address resolver) public;
81     function setOwner(bytes32 node, address owner) public;
82     function setTTL(bytes32 node, uint64 ttl) public;
83     function owner(bytes32 node) public view returns (address);
84     function resolver(bytes32 node) public view returns (address);
85     function ttl(bytes32 node) public view returns (uint64);
86 
87 }
88 
89 
90 contract ResolverInterface {
91     function PublicResolver(address ensAddr) public;
92     function setAddr(bytes32 node, address addr) public;
93     function setHash(bytes32 node, bytes32 hash) public;
94     function addr(bytes32 node) public view returns (address);
95     function hash(bytes32 node) public view returns (bytes32);
96     function supportsInterface(bytes4 interfaceID) public pure returns (bool);
97 }
98 
99 
100 
101 contract TopmonksRegistrar is Ownable {
102     bytes32 public rootNode;
103     ENS public ens;
104     ResolverInterface public resolver;
105 
106     modifier onlyDomainOwner(bytes32 subnode) {
107         address currentOwner = ens.owner(keccak256(abi.encodePacked(rootNode, subnode)));
108         require(currentOwner == 0 || currentOwner == msg.sender, "Only owner");
109         _;
110     }
111 
112     constructor(bytes32 _node, address _ensAddr, address _resolverAddr) public {
113         rootNode = _node;
114         ens = ENS(_ensAddr);
115         resolver = ResolverInterface(_resolverAddr);
116     }
117 
118     function setRootNode(bytes32 _node) public onlyOwner {
119         rootNode = _node;
120     }
121 
122     function setResolver(address _resolverAddr) public onlyOwner {
123         resolver = ResolverInterface(_resolverAddr);
124     }
125 
126     function setNodeOwner(address _newOwner) public onlyOwner {
127         ens.setOwner(rootNode, _newOwner);
128     }
129 
130     function setSubnodeOwner(bytes32 _subnode, address _addr) public onlyOwner {
131         ens.setSubnodeOwner(rootNode, _subnode, _addr);
132     }
133 
134     function register(bytes32 _subnode, address _addr) public onlyDomainOwner(_subnode) {
135         ens.setSubnodeOwner(rootNode, _subnode, this);
136         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
137         ens.setResolver(node, resolver);
138         resolver.setAddr(node, _addr);
139         ens.setSubnodeOwner(rootNode, _subnode, _addr);
140     }
141 }