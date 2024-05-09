1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title EnsRegistry
5  * @dev Extract of the interface for ENS Registry
6  */
7 contract EnsRegistry {
8 	function setOwner(bytes32 node, address owner) public;
9 	function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
10 	function setResolver(bytes32 node, address resolver) public;
11 	function owner(bytes32 node) public view returns (address);
12 	function resolver(bytes32 node) public view returns (address);
13 }
14 
15 /**
16  * @title EnsResolver
17  * @dev Extract of the interface for ENS Resolver
18  */
19 contract EnsResolver {
20 	function setAddr(bytes32 node, address addr) public;
21 	function addr(bytes32 node) public view returns (address);
22 }
23 
24 /**
25  * @title Portal Network SubdomainRegistrar
26  * @dev Allows to claim and configure a subdomain for Ethereum ENS in one call.
27  */
28 contract SubdomainRegistrar {
29 	address public owner;
30 	bool public locked;
31     bytes32 emptyNamehash = 0x00;
32 
33 	mapping (string => EnsRegistry) registries;
34 	mapping (string => EnsResolver) resolvers;
35 
36 	event SubdomainCreated(address indexed creator, address indexed owner, string subdomain, string domain, string topdomain);
37 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 	event RegistryUpdated(address indexed previousRegistry, address indexed newRegistry);
39 	event ResolverUpdated(address indexed previousResolver, address indexed newResolver);
40 	event DomainTransfersLocked();
41 	event DomainTransfersUnlocked();
42 
43 	constructor(string tld, EnsRegistry _registry, EnsResolver _resolver) public {
44 		owner = msg.sender;
45 		registries[tld] = _registry;
46 		resolvers[tld] = _resolver;
47 		locked = false;
48 
49 	}
50 
51 	/**
52 	 * @dev Throws if called by any account other than the owner.
53 	 *
54 	 */
55 	modifier onlyOwner() {
56 		require(msg.sender == owner);
57 		_;
58 	}
59 
60 	modifier supportedTLD(string tld) {
61 		require(registries[tld] != address(0) && resolvers[tld] != address(0));
62 		_;
63 	}
64 
65 	/**
66 	 * @dev Allows to create a subdomain (e.g. "hello.portalnetwork.eth"),
67 	 * set its resolver and set its target address
68 	 * @param _subdomain - sub domain name only e.g. "hello"
69 	 * @param _domain - domain name e.g. "portalnetwork"
70 	 * @param _topdomain - parent domain name e.g. "eth", "etc"
71 	 * @param _owner - address that will become owner of this new subdomain
72 	 * @param _target - address that this new domain will resolve to
73 	 */
74 	function newSubdomain(string _subdomain, string _domain, string _topdomain, address _owner, address _target) public supportedTLD(_topdomain) {
75 		//create namehash for the topdomain
76 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
77 		//create namehash for the domain
78 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
79 		//make sure this contract owns the domain
80 		require(registries[_topdomain].owner(domainNamehash) == address(this), "this contract should own the domain");
81 		//create labelhash for the sub domain
82 		bytes32 subdomainLabelhash = keccak256(abi.encodePacked(_subdomain));
83 		//create namehash for the sub domain
84 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, subdomainLabelhash));
85 		//make sure it is free or owned by the sender
86 		require(registries[_topdomain].owner(subdomainNamehash) == address(0) ||
87 			registries[_topdomain].owner(subdomainNamehash) == msg.sender, "sub domain already owned");
88 		//create new subdomain, temporarily this smartcontract is the owner
89 		registries[_topdomain].setSubnodeOwner(domainNamehash, subdomainLabelhash, address(this));
90 		//set public resolver for this domain
91 		registries[_topdomain].setResolver(subdomainNamehash, resolvers[_topdomain]);
92 		//set the destination address
93 		resolvers[_topdomain].setAddr(subdomainNamehash, _target);
94 		//change the ownership back to requested owner
95 		registries[_topdomain].setOwner(subdomainNamehash, _owner);
96 
97 		emit SubdomainCreated(msg.sender, _owner, _subdomain, _domain, _topdomain);
98 	}
99 
100 	/**
101 	 * @dev Returns the owner of a domain (e.g. "portalnetwork.eth"),
102 	 * @param _domain - domain name e.g. "portalnetwork"
103 	 * @param _topdomain - parent domain name e.g. "eth" or "etc"
104 	 */
105 	function domainOwner(string _domain, string _topdomain) public view returns (address) {
106 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
107 		bytes32 namehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
108 		return registries[_topdomain].owner(namehash);
109 	}
110 
111 	/**
112 	 * @dev Return the owner of a subdomain (e.g. "hello.portalnetwork.eth"),
113 	 * @param _subdomain - sub domain name only e.g. "hello"
114 	 * @param _domain - parent domain name e.g. "portalnetwork"
115 	 * @param _topdomain - parent domain name e.g. "eth", "etc"
116 	 */
117 	function subdomainOwner(string _subdomain, string _domain, string _topdomain) public view returns (address) {
118 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
119 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
120 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, keccak256(abi.encodePacked(_subdomain))));
121 		return registries[_topdomain].owner(subdomainNamehash);
122 	}
123 
124     /**
125     * @dev Return the target address where the subdomain is pointing to (e.g. "0x12345..."),
126     * @param _subdomain - sub domain name only e.g. "hello"
127     * @param _domain - parent domain name e.g. "portalnetwork"
128     * @param _topdomain - parent domain name e.g. "eth", "etc"
129     */
130     function subdomainTarget(string _subdomain, string _domain, string _topdomain) public view returns (address) {
131         bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
132         bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
133         bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, keccak256(abi.encodePacked(_subdomain))));
134         address currentResolver = registries[_topdomain].resolver(subdomainNamehash);
135         return EnsResolver(currentResolver).addr(subdomainNamehash);
136     }
137 
138 	/**
139 	 * @dev The contract owner can take away the ownership of any domain owned by this contract.
140 	 * @param _node - namehash of the domain
141 	 * @param _owner - new owner for the domain
142 	 */
143 	function transferDomainOwnership(string tld, bytes32 _node, address _owner) public supportedTLD(tld) onlyOwner {
144 		require(!locked);
145 		registries[tld].setOwner(_node, _owner);
146 	}
147 
148 	/**
149 	 * @dev The contract owner can lock and prevent any future domain ownership transfers.
150 	 */
151 	function lockDomainOwnershipTransfers() public onlyOwner {
152 		require(!locked);
153 		locked = true;
154 		emit DomainTransfersLocked();
155 	}
156 
157 	function unlockDomainOwnershipTransfer() public onlyOwner {
158 		require(locked);
159 		locked = false;
160 		emit DomainTransfersUnlocked();
161 	}
162 
163 	/**
164 	 * @dev Allows to update to new ENS registry.
165 	 * @param _registry The address of new ENS registry to use.
166 	 */
167 	function updateRegistry(string tld, EnsRegistry _registry) public onlyOwner {
168 		require(registries[tld] != _registry, "new registry should be different from old");
169 		emit RegistryUpdated(registries[tld], _registry);
170 		registries[tld] = _registry;
171 	}
172 
173 	/**
174 	 * @dev Allows to update to new ENS resolver.
175 	 * @param _resolver The address of new ENS resolver to use.
176 	 */
177 	function updateResolver(string tld, EnsResolver _resolver) public onlyOwner {
178 		require(resolvers[tld] != _resolver, "new resolver should be different from old");
179 		emit ResolverUpdated(resolvers[tld], _resolver);
180 		resolvers[tld] = _resolver;
181 	}
182 
183 	/**
184 	 * @dev Allows the current owner to transfer control of the contract to a new owner.
185 	 * @param _owner The address to transfer ownership to.
186 	 */
187 	function transferContractOwnership(address _owner) public onlyOwner {
188 		require(_owner != address(0), "cannot transfer to address(0)");
189 		emit OwnershipTransferred(owner, _owner);
190 		owner = _owner;
191 	}
192 }