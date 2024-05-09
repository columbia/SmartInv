1 pragma solidity 0.4.24;
2 // File: @aragon/os/contracts/lib/ens/AbstractENS.sol
3 interface AbstractENS {
4     function owner(bytes32 _node) public constant returns (address);
5     function resolver(bytes32 _node) public constant returns (address);
6     function ttl(bytes32 _node) public constant returns (uint64);
7     function setOwner(bytes32 _node, address _owner) public;
8     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
9     function setResolver(bytes32 _node, address _resolver) public;
10     function setTTL(bytes32 _node, uint64 _ttl) public;
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed _node, address _owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed _node, address _resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed _node, uint64 _ttl);
23 }
24 // File: contracts/ens/IPublicResolver.sol
25 interface IPublicResolver {
26     function supportsInterface(bytes4 interfaceID) constant returns (bool);
27     function addr(bytes32 node) constant returns (address ret);
28     function setAddr(bytes32 node, address addr);
29     function hash(bytes32 node) constant returns (bytes32 ret);
30     function setHash(bytes32 node, bytes32 hash);
31 }
32 // File: contracts/IFIFSResolvingRegistrar.sol
33 interface IFIFSResolvingRegistrar {
34     function register(bytes32 _subnode, address _owner) external;
35     function registerWithResolver(bytes32 _subnode, address _owner, IPublicResolver _resolver) public;
36 }
37 // File: contracts/FIFSResolvingRegistrar.sol
38 /**
39  * A registrar that allocates subdomains and sets resolvers to the first person to claim them.
40  *
41  * Adapted from ENS' FIFSRegistrar:
42  *   https://github.com/ethereum/ens/blob/master/contracts/FIFSRegistrar.sol
43  */
44 contract FIFSResolvingRegistrar is IFIFSResolvingRegistrar {
45     bytes32 public rootNode;
46     AbstractENS internal ens;
47     IPublicResolver internal defaultResolver;
48 
49     bytes4 private constant ADDR_INTERFACE_ID = 0x3b3b57de;
50 
51     event ClaimSubdomain(bytes32 indexed subnode, address indexed owner, address indexed resolver);
52 
53     /**
54      * Constructor.
55      * @param _ensAddr The address of the ENS registry.
56      * @param _defaultResolver The address of the default resolver to use for subdomains.
57      * @param _node The node that this registrar administers.
58      */
59     constructor(AbstractENS _ensAddr, IPublicResolver _defaultResolver, bytes32 _node)
60         public
61     {
62         ens = _ensAddr;
63         defaultResolver = _defaultResolver;
64         rootNode = _node;
65     }
66 
67     /**
68      * Register a subdomain with the default resolver if it hasn't been claimed yet.
69      * @param _subnode The hash of the label to register.
70      * @param _owner The address of the new owner.
71      */
72     function register(bytes32 _subnode, address _owner) external {
73         registerWithResolver(_subnode, _owner, defaultResolver);
74     }
75 
76     /**
77      * Register a subdomain if it hasn't been claimed yet.
78      * @param _subnode The hash of the label to register.
79      * @param _owner The address of the new owner.
80      * @param _resolver The address of the resolver.
81      *                  If the resolver supports the address interface, the subdomain's address will
82      *                  be set to the new owner.
83      */
84     function registerWithResolver(bytes32 _subnode, address _owner, IPublicResolver _resolver) public {
85         bytes32 node = keccak256(rootNode, _subnode);
86         address currentOwner = ens.owner(node);
87         require(currentOwner == address(0));
88 
89         ens.setSubnodeOwner(rootNode, _subnode, address(this));
90         ens.setResolver(node, _resolver);
91         if (_resolver.supportsInterface(ADDR_INTERFACE_ID)) {
92             _resolver.setAddr(node, _owner);
93         }
94 
95         // Give ownership to the claimer
96         ens.setOwner(node, _owner);
97 
98         emit ClaimSubdomain(_subnode, _owner, address(_resolver));
99     }
100 }