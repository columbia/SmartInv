1 //! MultiCertifier contract.
2 //! By Parity Technologies, 2017.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.16;
6 
7 // From Owned.sol
8 contract Owned {
9 	modifier only_owner { if (msg.sender != owner) return; _; }
10 
11 	event NewOwner(address indexed old, address indexed current);
12 
13 	function setOwner(address _new) public only_owner { NewOwner(owner, _new); owner = _new; }
14 
15 	address public owner = msg.sender;
16 }
17 
18 // From Certifier.sol
19 contract Certifier {
20 	event Confirmed(address indexed who);
21 	event Revoked(address indexed who);
22 	function certified(address) public constant returns (bool);
23 	function get(address, string) public constant returns (bytes32);
24 	function getAddress(address, string) public constant returns (address);
25 	function getUint(address, string) public constant returns (uint);
26 }
27 
28 /**
29  * Contract to allow multiple parties to collaborate over a certification contract.
30  * Each certified account is associated with the delegate who certified it.
31  * Delegates can be added and removed only by the contract owner.
32  */
33 contract MultiCertifier is Owned, Certifier {
34 	modifier only_delegate { require (msg.sender == owner || delegates[msg.sender]); _; }
35 	modifier only_certifier_of(address who) { require (msg.sender == owner || msg.sender == certs[who].certifier); _; }
36 	modifier only_certified(address who) { require (certs[who].active); _; }
37 	modifier only_uncertified(address who) { require (!certs[who].active); _; }
38 
39 	event Confirmed(address indexed who, address indexed by);
40 	event Revoked(address indexed who, address indexed by);
41 
42 	struct Certification {
43 		address certifier;
44 		bool active;
45 	}
46 
47 	function certify(address _who)
48 		public
49 		only_delegate
50 		only_uncertified(_who)
51 	{
52 		certs[_who].active = true;
53 		certs[_who].certifier = msg.sender;
54 		Confirmed(_who, msg.sender);
55 	}
56 
57 	function revoke(address _who)
58 		public
59 		only_certifier_of(_who)
60 		only_certified(_who)
61 	{
62 		certs[_who].active = false;
63 		Revoked(_who, msg.sender);
64 	}
65 
66 	function certified(address _who) public constant returns (bool) { return certs[_who].active; }
67 	function getCertifier(address _who) public constant returns (address) { return certs[_who].certifier; }
68 	function addDelegate(address _new) public only_owner { delegates[_new] = true; }
69 	function removeDelegate(address _old) public only_owner { delete delegates[_old]; }
70 
71 	mapping (address => Certification) certs;
72 	mapping (address => bool) delegates;
73 
74 	/// Unused interface methods.
75 	function get(address, string) public constant returns (bytes32) {}
76 	function getAddress(address, string) public constant returns (address) {}
77 	function getUint(address, string) public constant returns (uint) {}
78 }