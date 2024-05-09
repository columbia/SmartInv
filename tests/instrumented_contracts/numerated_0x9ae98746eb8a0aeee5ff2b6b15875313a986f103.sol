1 //! SMS verification contract
2 //! By Gav Wood, 2016.
3 
4 pragma solidity ^0.4.0;
5 
6 contract Owned {
7 	modifier only_owner { if (msg.sender != owner) return; _; }
8 
9 	event NewOwner(address indexed old, address indexed current);
10 
11 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
12 
13 	address public owner = msg.sender;
14 }
15 
16 contract Certifier {
17 	event Confirmed(address indexed who);
18 	event Revoked(address indexed who);
19 	function certified(address _who) constant returns (bool);
20 	function get(address _who, string _field) constant returns (bytes32) {}
21 	function getAddress(address _who, string _field) constant returns (address) {}
22 	function getUint(address _who, string _field) constant returns (uint) {}
23 }
24 
25 contract SimpleCertifier is Owned, Certifier {
26 	modifier only_delegate { if (msg.sender != delegate) return; _; }
27 	modifier only_certified(address _who) { if (!certs[_who].active) return; _; }
28 
29 	struct Certification {
30 		bool active;
31 		mapping (string => bytes32) meta;
32 	}
33 
34 	function certify(address _who) only_delegate {
35 		certs[_who].active = true;
36 		Confirmed(_who);
37 	}
38 	function revoke(address _who) only_delegate only_certified(_who) {
39 		certs[_who].active = false;
40 		Revoked(_who);
41 	}
42 	function certified(address _who) constant returns (bool) { return certs[_who].active; }
43 	function get(address _who, string _field) constant returns (bytes32) { return certs[_who].meta[_field]; }
44 	function getAddress(address _who, string _field) constant returns (address) { return address(certs[_who].meta[_field]); }
45 	function getUint(address _who, string _field) constant returns (uint) { return uint(certs[_who].meta[_field]); }
46 	function setDelegate(address _new) only_owner { delegate = _new; }
47 
48 	mapping (address => Certification) certs;
49 	// So that the server posting puzzles doesn't have access to the ETH.
50 	address public delegate = msg.sender;
51 }
52 
53 
54 
55 contract ProofOfSMS is SimpleCertifier {
56 
57 	modifier when_fee_paid { if (msg.value < fee) return; _; }
58 
59 	event Requested(address indexed who);
60 	event Puzzled(address indexed who, bytes32 puzzle);
61 
62 	function request() payable when_fee_paid {
63 		if (certs[msg.sender].active)
64 			return;
65 		Requested(msg.sender);
66 	}
67 
68 	function puzzle(address _who, bytes32 _puzzle) only_delegate {
69 		puzzles[_who] = _puzzle;
70 		Puzzled(_who, _puzzle);
71 	}
72 
73 	function confirm(bytes32 _code) returns (bool) {
74 		if (puzzles[msg.sender] != sha3(_code))
75 			return;
76 		delete puzzles[msg.sender];
77 		certs[msg.sender].active = true;
78 		Confirmed(msg.sender);
79 		return true;
80 	}
81 
82 	function setFee(uint _new) only_owner {
83 		fee = _new;
84 	}
85 
86 	function drain() only_owner {
87 		if (!msg.sender.send(this.balance))
88 			throw;
89 	}
90 
91 	function certified(address _who) constant returns (bool) {
92 		return certs[_who].active;
93 	}
94 
95 	mapping (address => bytes32) puzzles;
96 
97 	uint public fee = 30 finney;
98 }