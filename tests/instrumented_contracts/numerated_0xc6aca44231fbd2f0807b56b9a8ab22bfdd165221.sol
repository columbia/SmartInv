1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // EnsSubdomainFactory - allows creating and configuring custom ENS subdomains with one contract call.
5 //
6 // (c) Radek Ostrowski / https://startonchain.com - The MIT Licence.
7 // ----------------------------------------------------------------------------
8 
9 /**
10 * @title EnsRegistry
11 * @dev Extract of the interface for ENS Registry
12 */
13 contract EnsRegistry {
14 	function setOwner(bytes32 node, address owner) public;
15 	function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
16 	function setResolver(bytes32 node, address resolver) public;
17 }
18 
19 /**
20 * @title EnsResolver
21 * @dev Extract of the interface for ENS Resolver
22 */
23 contract EnsResolver {
24 	function setAddr(bytes32 node, address addr) public;
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a new owner.
55    * @param _owner The address to transfer ownership to.
56    */
57   function transferOwnership(address _owner) public onlyOwner {
58     require(_owner != address(0));
59     owner = _owner;
60     emit OwnershipTransferred(owner, _owner);
61   }
62 }
63 
64 /**
65 * @title EnsSubdomainFactory
66 * @dev Allows to create and configure a subdomain for Ethereum ENS in one call.
67 * After deploying this contract, change the owner of the top level domain you want to use
68 * to this deployed contract address.
69 */
70 contract EnsSubdomainFactory is Ownable {
71 	EnsRegistry public registry = EnsRegistry(0x314159265dD8dbb310642f98f50C066173C1259b);
72 	EnsResolver public resolver = EnsResolver(0x5FfC014343cd971B7eb70732021E26C35B744cc4);
73 
74 	event SubdomainCreated(bytes32 indexed subdomain, address indexed owner);
75 
76 	constructor() public {
77 		owner = msg.sender;
78 	}
79 
80 	/**
81 	* @dev The owner can take away the ownership of any top level domain owned by this contract.
82 	*/
83 	function setDomainOwner(bytes32 _node, address _owner) onlyOwner public {
84 		registry.setOwner(_node, _owner);
85 	}
86 
87 	/**
88 	* @dev Allows to create a subdomain, set its resolver and set its target address
89 	* @param _node - namehash of parent domain name e.g. namehash("startonchain.eth")
90 	* @param _subnode - namehash of sub with parent domain name e.g. namehash("radek.startonchain.eth")
91 	* @param _label - hash of subdomain name only e.g. "radek"
92 	* @param _owner - address that will become owner of this new subdomain
93 	* @param _target - address that this new domain will resolve to
94 	*/
95 	function newSubdomain(bytes32 _node, bytes32 _subnode, bytes32 _label, address _owner, address _target) public {
96 		//create new subdomain, temporarily this smartcontract is the owner
97 		registry.setSubnodeOwner(_node, _label, address(this));
98 		//set public resolver for this domain
99 		registry.setResolver(_subnode, resolver);
100 		//set the destination address
101 		resolver.setAddr(_subnode, _target);
102 		//change the ownership back to requested owner
103 		registry.setOwner(_subnode, _owner);
104 		emit SubdomainCreated(_label, _owner);
105 	}
106 }