1 pragma solidity ^0.4.24;
2 
3 // ---------------------------------------------------------------------------------------------------
4 // EnsSubdomainFactory - allows creating and configuring custom ENS subdomains with one contract call.
5 //
6 // @author Radek Ostrowski / https://startonchain.com - MIT Licence.
7 // Source: https://github.com/radek1st/ens-subdomain-factory
8 // ---------------------------------------------------------------------------------------------------
9 
10 /**
11  * @title EnsResolver
12  * @dev Extract of the interface for ENS Resolver
13  */
14 contract EnsResolver {
15 	function setAddr(bytes32 node, address addr) public;
16 	function addr(bytes32 node) public view returns (address);
17 }
18 
19 /**
20  * @title EnsRegistry
21  * @dev Extract of the interface for ENS Registry
22  */
23 contract EnsRegistry {
24 	function setOwner(bytes32 node, address owner) public;
25 	function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
26 	function setResolver(bytes32 node, address resolver) public;
27 	function owner(bytes32 node) public view returns (address);
28 	function resolver(bytes32 node) public view returns (address);
29 }
30 
31 /**
32  * @title EnsSubdomainFactory
33  * @dev Allows to create and configure a subdomain for Ethereum ENS in one call.
34  * After deploying this contract, change the owner of the domain you want to use
35  * to this deployed contract address. For example, transfer the ownership of "startonchain.eth"
36  * so anyone can create subdomains like "radek.startonchain.eth".
37  */
38 contract EnsSubdomainFactory {
39 	address public owner;
40 	EnsRegistry public registry;
41 	EnsResolver public resolver;
42 	bool public locked;
43     bytes32 emptyNamehash = 0x00;
44 
45 	event SubdomainCreated(address indexed creator, address indexed owner, string subdomain, string domain, string topdomain);
46 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 	event RegistryUpdated(address indexed previousRegistry, address indexed newRegistry);
48 	event ResolverUpdated(address indexed previousResolver, address indexed newResolver);
49 	event DomainTransfersLocked();
50 
51 	constructor(EnsRegistry _registry, EnsResolver _resolver) public {
52 		owner = msg.sender;
53 		registry = _registry;
54 		resolver = _resolver;
55 		locked = false;
56 	}
57 
58 	/**
59 	 * @dev Throws if called by any account other than the owner.
60 	 *
61 	 */
62 	modifier onlyOwner() {
63 		require(msg.sender == owner);
64 		_;
65 	}
66 
67 	/**
68 	 * @dev Allows to create a subdomain (e.g. "radek.startonchain.eth"),
69 	 * set its resolver and set its target address
70 	 * @param _subdomain - sub domain name only e.g. "radek"
71 	 * @param _domain - domain name e.g. "startonchain"
72 	 * @param _topdomain - parent domain name e.g. "eth", "xyz"
73 	 * @param _owner - address that will become owner of this new subdomain
74 	 * @param _target - address that this new domain will resolve to
75 	 */
76 	function newSubdomain(string _subdomain, string _domain, string _topdomain, address _owner, address _target) public {
77 		//create namehash for the topdomain
78 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
79 		//create namehash for the domain
80 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
81 		//make sure this contract owns the domain
82 		require(registry.owner(domainNamehash) == address(this), "this contract should own the domain");
83 		//create labelhash for the sub domain
84 		bytes32 subdomainLabelhash = keccak256(abi.encodePacked(_subdomain));
85 		//create namehash for the sub domain
86 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, subdomainLabelhash));
87 		//make sure it is free or owned by the sender
88 		require(registry.owner(subdomainNamehash) == address(0) ||
89 			registry.owner(subdomainNamehash) == msg.sender, "sub domain already owned");
90 		//create new subdomain, temporarily this smartcontract is the owner
91 		registry.setSubnodeOwner(domainNamehash, subdomainLabelhash, address(this));
92 		//set public resolver for this domain
93 		registry.setResolver(subdomainNamehash, resolver);
94 		//set the destination address
95 		resolver.setAddr(subdomainNamehash, _target);
96 		//change the ownership back to requested owner
97 		registry.setOwner(subdomainNamehash, _owner);
98 
99 		emit SubdomainCreated(msg.sender, _owner, _subdomain, _domain, _topdomain);
100 	}
101 
102 	/**
103 	 * @dev Returns the owner of a domain (e.g. "startonchain.eth"),
104 	 * @param _domain - domain name e.g. "startonchain"
105 	 * @param _topdomain - parent domain name e.g. "eth" or "xyz"
106 	 */
107 	function domainOwner(string _domain, string _topdomain) public view returns (address) {
108 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
109 		bytes32 namehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
110 		return registry.owner(namehash);
111 	}
112 
113 	/**
114 	 * @dev Return the owner of a subdomain (e.g. "radek.startonchain.eth"),
115 	 * @param _subdomain - sub domain name only e.g. "radek"
116 	 * @param _domain - parent domain name e.g. "startonchain"
117 	 * @param _topdomain - parent domain name e.g. "eth", "xyz"
118 	 */
119 	function subdomainOwner(string _subdomain, string _domain, string _topdomain) public view returns (address) {
120 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
121 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
122 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, keccak256(abi.encodePacked(_subdomain))));
123 		return registry.owner(subdomainNamehash);
124 	}
125 
126     /**
127     * @dev Return the target address where the subdomain is pointing to (e.g. "0x12345..."),
128     * @param _subdomain - sub domain name only e.g. "radek"
129     * @param _domain - parent domain name e.g. "startonchain"
130     * @param _topdomain - parent domain name e.g. "eth", "xyz"
131     */
132     function subdomainTarget(string _subdomain, string _domain, string _topdomain) public view returns (address) {
133         bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
134         bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
135         bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, keccak256(abi.encodePacked(_subdomain))));
136         address currentResolver = registry.resolver(subdomainNamehash);
137         return EnsResolver(currentResolver).addr(subdomainNamehash);
138     }
139 
140 	/**
141 	 * @dev The contract owner can take away the ownership of any domain owned by this contract.
142 	 * @param _node - namehash of the domain
143 	 * @param _owner - new owner for the domain
144 	 */
145 	function transferDomainOwnership(bytes32 _node, address _owner) public onlyOwner {
146 		require(!locked);
147 		registry.setOwner(_node, _owner);
148 	}
149 
150 	/**
151 	 * @dev The contract owner can lock and prevent any future domain ownership transfers.
152 	 */
153 	function lockDomainOwnershipTransfers() public onlyOwner {
154 		require(!locked);
155 		locked = true;
156 		emit DomainTransfersLocked();
157 	}
158 
159 	/**
160 	 * @dev Allows to update to new ENS registry.
161 	 * @param _registry The address of new ENS registry to use.
162 	 */
163 	function updateRegistry(EnsRegistry _registry) public onlyOwner {
164 		require(registry != _registry, "new registry should be different from old");
165 		emit RegistryUpdated(registry, _registry);
166 		registry = _registry;
167 	}
168 
169 	/**
170 	 * @dev Allows to update to new ENS resolver.
171 	 * @param _resolver The address of new ENS resolver to use.
172 	 */
173 	function updateResolver(EnsResolver _resolver) public onlyOwner {
174 		require(resolver != _resolver, "new resolver should be different from old");
175 		emit ResolverUpdated(resolver, _resolver);
176 		resolver = _resolver;
177 	}
178 
179 	/**
180 	 * @dev Allows the current owner to transfer control of the contract to a new owner.
181 	 * @param _owner The address to transfer ownership to.
182 	 */
183 	function transferContractOwnership(address _owner) public onlyOwner {
184 		require(_owner != address(0), "cannot transfer to address(0)");
185 		emit OwnershipTransferred(owner, _owner);
186 		owner = _owner;
187 	}
188 }