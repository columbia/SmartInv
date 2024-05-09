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
31  * @dev Allows to create and configure a subdomain for Ethereum ENS in one call.
32  * After deploying this contract, change the owner of the domain you want to use
33  * to this deployed contract address. For example, transfer the ownership of "startonchain.eth"
34  * so anyone can create subdomains like "radek.startonchain.eth".
35  */
36 contract EnsSubdomainFactory {
37 	address public owner;
38 	EnsRegistry public registry;
39 	EnsResolver public resolver;
40 	bool public locked;
41         bytes32 emptyNamehash = 0x00;
42 
43 	event SubdomainCreated(address indexed creator, address indexed owner, string subdomain, string domain, string topdomain);
44 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 	event RegistryUpdated(address indexed previousRegistry, address indexed newRegistry);
46 	event ResolverUpdated(address indexed previousResolver, address indexed newResolver);
47 	event DomainTransfersLocked();
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
61 		require(msg.sender == owner);
62 		_;
63 	}
64 
65 	/**
66 	 * @dev Allows to create a subdomain (e.g. "radek.startonchain.eth"),
67 	 * set its resolver and set its target address
68 	 * @param _subdomain - sub domain name only e.g. "radek"
69 	 * @param _domain - domain name e.g. "startonchain"
70 	 * @param _topdomain - parent domain name e.g. "eth", "xyz"
71 	 * @param _owner - address that will become owner of this new subdomain
72 	 * @param _target - address that this new domain will resolve to
73 	 */
74 	function newSubdomain(string _subdomain, string _domain, string _topdomain, address _owner, address _target) public {
75 		//create namehash for the topdomain
76 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
77 		//create namehash for the domain
78 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
79 		//make sure this contract owns the domain
80 		require(registry.owner(domainNamehash) == address(this), "this contract should own the domain");
81 		//create labelhash for the sub domain
82 		bytes32 subdomainLabelhash = keccak256(abi.encodePacked(_subdomain));
83 		//create namehash for the sub domain
84 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, subdomainLabelhash));
85 		//make sure it is free or owned by the sender
86 		require(registry.owner(subdomainNamehash) == address(0) ||
87 			registry.owner(subdomainNamehash) == msg.sender, "sub domain already owned");
88 		//create new subdomain, temporarily this smartcontract is the owner
89 		registry.setSubnodeOwner(domainNamehash, subdomainLabelhash, address(this));
90 		//set public resolver for this domain
91 		registry.setResolver(subdomainNamehash, resolver);
92 		//set the destination address
93 		resolver.setAddr(subdomainNamehash, _target);
94 		//change the ownership back to requested owner
95 		registry.setOwner(subdomainNamehash, _owner);
96 
97 		emit SubdomainCreated(msg.sender, _owner, _subdomain, _domain, _topdomain);
98 	}
99 
100 	/**
101 	 * @dev Returns the owner of a domain (e.g. "startonchain.eth"),
102 	 * @param _domain - domain name e.g. "startonchain"
103 	 * @param _topdomain - parent domain name e.g. "eth"
104 	 */
105 	function domainOwner(string _domain, string _topdomain) public view returns(address) {
106 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
107 		bytes32 namehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
108 		return registry.owner(namehash);
109 	}
110 
111 	/**
112 	 * @dev Return the owner of a subdomain (e.g. "radek.startonchain.eth"),
113 	 * @param _subdomain - sub domain name only e.g. "radek"
114 	 * @param _domain - parent domain name e.g. "startonchain"
115 	 */
116 	function subdomainOwner(string _subdomain, string _domain, string _topdomain) public view returns(address) {
117 		bytes32 topdomainNamehash = keccak256(abi.encodePacked(emptyNamehash, keccak256(abi.encodePacked(_topdomain))));
118 		bytes32 domainNamehash = keccak256(abi.encodePacked(topdomainNamehash, keccak256(abi.encodePacked(_domain))));
119 		bytes32 subdomainNamehash = keccak256(abi.encodePacked(domainNamehash, keccak256(abi.encodePacked(_subdomain))));
120 		return registry.owner(subdomainNamehash);
121 	}
122 
123 	/**
124 	 * @dev The contract owner can take away the ownership of any domain owned by this contract.
125 	 * @param _node - namehash of the domain
126 	 * @param _owner - new owner for the domain
127 	 */
128 	function transferDomainOwnership(bytes32 _node, address _owner) public onlyOwner {
129 		require(!locked);
130 		registry.setOwner(_node, _owner);
131 	}
132 
133 	/**
134 	 * @dev The contract owner can lock and prevent any future domain ownership transfers.
135 	 */
136 	function lockDomainOwnershipTransfers() public onlyOwner {
137 		require(!locked);
138 		locked = true;
139 		emit DomainTransfersLocked();
140 	}
141 
142 	/**
143 	 * @dev Allows to update to new ENS registry.
144 	 * @param _registry The address of new ENS registry to use.
145 	 */
146 	function updateRegistry(EnsRegistry _registry) public onlyOwner {
147 		require(registry != _registry, "new registry should be different from old");
148 		emit RegistryUpdated(registry, _registry);
149 		registry = _registry;
150 	}
151 
152 	/**
153 	 * @dev Allows to update to new ENS resolver.
154 	 * @param _resolver The address of new ENS resolver to use.
155 	 */
156 	function updateResolver(EnsResolver _resolver) public onlyOwner {
157 		require(resolver != _resolver, "new resolver should be different from old");
158 		emit ResolverUpdated(resolver, _resolver);
159 		resolver = _resolver;
160 	}
161 
162 	/**
163 	 * @dev Allows the current owner to transfer control of the contract to a new owner.
164 	 * @param _owner The address to transfer ownership to.
165 	 */
166 	function transferContractOwnership(address _owner) public onlyOwner {
167 		require(_owner != address(0), "cannot transfer to address(0)");
168 		emit OwnershipTransferred(owner, _owner);
169 		owner = _owner;
170 	}
171 }