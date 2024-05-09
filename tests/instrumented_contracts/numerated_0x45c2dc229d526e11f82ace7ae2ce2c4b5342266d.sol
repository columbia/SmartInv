1 pragma solidity ^0.4.24;
2 
3 // ---------------------------------------------------------------------------------------------------
4 // EnsSubdomainFactory - allows creating and configuring custom ENS subdomains with one contract call.
5 //
6 // (c) Radek Ostrowski / https://startonchain.com - The MIT Licence.
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
30 * @title EnsSubdomainFactory
31 * @dev Allows to create and configure a first level subdomain for Ethereum ENS in one call.
32 * After deploying this contract, change the owner of the top level domain you want to use
33 * to this deployed contract address.
34 */
35 contract EnsSubdomainFactory {
36 	address public owner;
37     EnsRegistry public registry = EnsRegistry(0x314159265dD8dbb310642f98f50C066173C1259b);
38 	EnsResolver public resolver = EnsResolver(0x5FfC014343cd971B7eb70732021E26C35B744cc4);
39     bytes32 ethNameHash = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
40 
41 	event SubdomainCreated(string indexed domain, string indexed subdomain, address indexed creator);
42 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 	constructor() public {
45 		owner = msg.sender;
46 	}
47 
48 	/**
49 	 * @dev Throws if called by any account other than the owner.
50 	 */
51 	modifier onlyOwner() {
52 	  require(msg.sender == owner);
53 	  _;
54 	}
55 
56 	/**
57 	* @dev Allows to create a subdomain (e.g. "radek.startonchain.eth"), 
58 	* set its resolver and set its target address
59 	* @param _topLevelDomain - parent domain name e.g. "startonchain"
60 	* @param _subDomain - sub domain name only e.g. "radek"
61 	* @param _owner - address that will become owner of this new subdomain
62 	* @param _target - address that this new domain will resolve to
63 	*/
64 	function newSubdomain(string _topLevelDomain, string _subDomain, address _owner, address _target) public {
65 	    //create namehash for the top domain
66 	    bytes32 topLevelNamehash = keccak256(abi.encodePacked(ethNameHash, keccak256(abi.encodePacked(_topLevelDomain))));
67 	    //make sure this contract owns the top level domain
68         require(registry.owner(topLevelNamehash) == address(this), "this contract should own top level domain");
69 	    //create labelhash for the sub domain
70 	    bytes32 subDomainLabelhash = keccak256(abi.encodePacked(_subDomain));
71 	    //create namehash for the sub domain
72 	    bytes32 subDomainNamehash = keccak256(abi.encodePacked(topLevelNamehash, subDomainLabelhash));
73         //make sure it is not already owned
74         require(registry.owner(subDomainNamehash) == address(0), "sub domain already owned");
75 		//create new subdomain, temporarily this smartcontract is the owner
76 		registry.setSubnodeOwner(topLevelNamehash, subDomainLabelhash, address(this));
77 		//set public resolver for this domain
78 		registry.setResolver(subDomainNamehash, resolver);
79 		//set the destination address
80 		resolver.setAddr(subDomainNamehash, _target);
81 		//change the ownership back to requested owner
82 		registry.setOwner(subDomainNamehash, _owner);
83 		
84 		emit SubdomainCreated(_topLevelDomain, _subDomain, msg.sender);
85 	}
86 
87 	/**
88 	* @dev The contract owner can take away the ownership of any top level domain owned by this contract.
89 	*/
90 	function transferDomainOwnership(bytes32 _node, address _owner) public onlyOwner {
91 		registry.setOwner(_node, _owner);
92 	}
93 
94 	/**
95 	 * @dev Allows the current owner to transfer control of the contract to a new owner.
96 	 * @param _owner The address to transfer ownership to.
97 	 */
98 	function transferContractOwnership(address _owner) public onlyOwner {
99 	  require(_owner != address(0));
100 	  owner = _owner;
101 	  emit OwnershipTransferred(owner, _owner);
102 	}
103 }