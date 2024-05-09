1 pragma solidity ^0.4.24;
2 
3 // ---------------------------------------------------------------------------------------------------
4 // EnsSubdomainFactory - allows creating and configuring custom ENS subdomains with one contract call.
5 //
6 // (c) Radek Ostrowski / https://startonchain.com - MIT Licence.
7 // Source: https://github.com/radek1st/ens-subdomain-factory
8 // ---------------------------------------------------------------------------------------------------
9 
10 /**
11 * @title EnsRegistry
12 * @dev Extract of the interface for ENS Registry
13 */
14 contract EnsRegistry {
15 	function setOwner(bytes32 node, address owner) public;
16 	function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
17 	function setResolver(bytes32 node, address resolver) public;
18 	function owner(bytes32 node) public view returns (address);
19 }
20 
21 /**
22 * @title EnsResolver
23 * @dev Extract of the interface for ENS Resolver
24 */
25 contract EnsResolver {
26 	function setAddr(bytes32 node, address addr) public;
27 }
28 
29 /**
30  * @title EnsSubdomainFactory
31  * @dev Allows to create and configure a first level subdomain for Ethereum ENS in one call.
32  * After deploying this contract, change the owner of the top level domain you want to use
33  * to this deployed contract address. For example, transfer the ownership of "startonchain.eth"
34  * so anyone can create subdomains like "radek.startonchain.eth".
35  */
36 contract EnsSubdomainFactory {
37 	address public owner;
38     EnsRegistry public registry;
39 	EnsResolver public resolver;
40 	bool public locked;
41     bytes32 ethNameHash = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
42 
43 	event SubdomainCreated(address indexed creator, address indexed owner, string subdomain, string domain);
44 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 	event RegistryUpdated(address indexed previousRegistry, address indexed newRegistry);
46 	event ResolverUpdated(address indexed previousResolver, address indexed newResolver);
47 	event TopLevelDomainTransfersLocked();
48 
49 	constructor(EnsRegistry _registry, EnsResolver _resolver) public {
50 		owner = msg.sender;
51 		registry = _registry;
52 		resolver = _resolver;
53 		locked = false;
54 	}
55 
56 	/**
57 	 * @dev Throws if called by any account other than the owner.
58 	 *
59 	 */
60 	modifier onlyOwner() {
61 	  require(msg.sender == owner);
62 	  _;
63 	}
64 
65 	/**
66 	 * @dev Allows to create a subdomain (e.g. "radek.startonchain.eth"), 
67 	 * set its resolver and set its target address
68 	 * @param _subDomain - sub domain name only e.g. "radek"
69 	 * @param _topLevelDomain - parent domain name e.g. "startonchain"
70 	 * @param _owner - address that will become owner of this new subdomain
71 	 * @param _target - address that this new domain will resolve to
72 	 */
73 	function newSubdomain(string _subDomain, string _topLevelDomain, address _owner, address _target) public {
74 	    //create namehash for the top domain
75 	    bytes32 topLevelNamehash = keccak256(abi.encodePacked(ethNameHash, keccak256(abi.encodePacked(_topLevelDomain))));
76 	    //make sure this contract owns the top level domain
77         require(registry.owner(topLevelNamehash) == address(this), "this contract should own top level domain");
78 	    //create labelhash for the sub domain
79 	    bytes32 subDomainLabelhash = keccak256(abi.encodePacked(_subDomain));
80 	    //create namehash for the sub domain
81 	    bytes32 subDomainNamehash = keccak256(abi.encodePacked(topLevelNamehash, subDomainLabelhash));
82         //make sure it is free or owned by the sender
83         require(registry.owner(subDomainNamehash) == address(0) ||
84             registry.owner(subDomainNamehash) == msg.sender, "sub domain already owned");
85 		//create new subdomain, temporarily this smartcontract is the owner
86 		registry.setSubnodeOwner(topLevelNamehash, subDomainLabelhash, address(this));
87 		//set public resolver for this domain
88 		registry.setResolver(subDomainNamehash, resolver);
89 		//set the destination address
90 		resolver.setAddr(subDomainNamehash, _target);
91 		//change the ownership back to requested owner
92 		registry.setOwner(subDomainNamehash, _owner);
93 		
94 		emit SubdomainCreated(msg.sender, _owner, _subDomain, _topLevelDomain);
95 	}
96 
97 	/**
98 	 * @dev Returns the owner of top level domain (e.g. "startonchain.eth"), 
99 	 * @param _topLevelDomain - domain name e.g. "startonchain"
100 	 */
101 	function topLevelDomainOwner(string _topLevelDomain) public view returns(address) {
102 		bytes32 namehash = keccak256(abi.encodePacked(ethNameHash, keccak256(abi.encodePacked(_topLevelDomain))));
103 		return registry.owner(namehash);
104 	}
105 	
106 	/**
107 	 * @dev Return the owner of a subdomain (e.g. "radek.startonchain.eth"), 
108 	 * @param _subDomain - sub domain name only e.g. "radek"
109 	 * @param _topLevelDomain - parent domain name e.g. "startonchain"
110 	 */
111 	function subDomainOwner(string _subDomain, string _topLevelDomain) public view returns(address) {
112 		bytes32 topLevelNamehash = keccak256(abi.encodePacked(ethNameHash, keccak256(abi.encodePacked(_topLevelDomain))));
113 		bytes32 subDomainNamehash = keccak256(abi.encodePacked(topLevelNamehash, keccak256(abi.encodePacked(_subDomain))));
114 		return registry.owner(subDomainNamehash);
115 	}
116 
117 	/**
118 	 * @dev The contract owner can take away the ownership of any domain owned by this contract.
119 	 * @param _node - namehash of the domain
120 	 * @param _owner - new owner for the domain
121 	 */
122 	function transferTopLevelDomainOwnership(bytes32 _node, address _owner) public onlyOwner {
123 		require(!locked);
124 		registry.setOwner(_node, _owner);
125 	}
126 
127 	/**
128 	 * @dev The contract owner can lock and prevent any future domain ownership transfers.
129 	 */
130 	function lockTopLevelDomainOwnershipTransfers() public onlyOwner {
131 		require(!locked);
132 		locked = true;
133 		emit TopLevelDomainTransfersLocked();
134 	}
135 
136 	/**
137 	 * @dev Allows to update to new ENS registry.
138 	 * @param _registry The address of new ENS registry to use.
139 	 */
140 	function updateRegistry(EnsRegistry _registry) public onlyOwner {
141 		require(registry != _registry, "new registry should be different from old");
142 		emit RegistryUpdated(registry, _registry);
143 		registry = _registry;
144 	}
145 
146 	/**
147 	 * @dev Allows to update to new ENS resolver.
148 	 * @param _resolver The address of new ENS resolver to use.
149 	 */
150 	function updateResolver(EnsResolver _resolver) public onlyOwner {
151 		require(resolver != _resolver, "new resolver should be different from old");
152 		emit ResolverUpdated(resolver, _resolver);
153 		resolver = _resolver;
154 	}
155 
156 	/**
157 	 * @dev Allows the current owner to transfer control of the contract to a new owner.
158 	 * @param _owner The address to transfer ownership to.
159 	 */
160 	function transferContractOwnership(address _owner) public onlyOwner {
161 		require(_owner != address(0), "cannot transfer to address(0)");
162 		emit OwnershipTransferred(owner, _owner);
163 		owner = _owner;
164 	}
165 }