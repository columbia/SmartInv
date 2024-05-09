1 //! SimpleCertifier contract, taken from ethcore/sms-verification
2 //! By Gav Wood (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.7;
6 
7 // From Owned.sol
8 contract Owned {
9 	modifier only_owner { require (msg.sender != owner); _; }
10 
11 	event NewOwner(address indexed old, address indexed current);
12 
13 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
14 
15 	address public owner = msg.sender;
16 }
17 
18 // From Certifier.sol
19 contract Certifier {
20 	event Confirmed(address indexed who);
21 	event Revoked(address indexed who);
22 	function certified(address _who) constant returns (bool);
23 	function get(address _who, string _field) constant returns (bytes32);
24 	function getAddress(address _who, string _field) constant returns (address);
25 	function getUint(address _who, string _field) constant returns (uint);
26 }
27 
28 contract SimpleCertifier is Owned, Certifier {
29 	modifier only_delegate { if (msg.sender != delegate) return; _; }
30 	modifier only_certified(address _who) { if (!certs[_who].active) return; _; }
31 
32 	struct Certification {
33 		bool active;
34 		mapping (string => bytes32) meta;
35 	}
36 
37 	function certify(address _who) only_delegate {
38 		certs[_who].active = true;
39 		Confirmed(_who);
40 	}
41 	function revoke(address _who) only_delegate only_certified(_who) {
42 		certs[_who].active = false;
43 		Revoked(_who);
44 	}
45 	function certified(address _who) constant returns (bool) { return certs[_who].active; }
46 	function get(address _who, string _field) constant returns (bytes32) { return certs[_who].meta[_field]; }
47 	function getAddress(address _who, string _field) constant returns (address) { return address(certs[_who].meta[_field]); }
48 	function getUint(address _who, string _field) constant returns (uint) { return uint(certs[_who].meta[_field]); }
49 	function setDelegate(address _new) only_owner { delegate = _new; }
50 
51 	mapping (address => Certification) certs;
52 	// So that the server posting puzzles doesn't have access to the ETH.
53 	address public delegate = msg.sender;
54 }