1 // This contract extends the contracts provided by 
2 //! SMS verification contract
3 //! By Gav Wood, 2016.
4 
5 pragma solidity ^0.4.15;
6 
7 contract Owned {
8 	modifier only_owner {
9 		if (msg.sender != owner)
10 			return;
11 		_; 
12 	}
13 
14 	event NewOwner(address indexed old, address indexed current);
15 
16 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
17 
18 	address public owner = msg.sender;
19 }
20 
21 contract Certifier {
22 	event Confirmed(address indexed who);
23 	event Revoked(address indexed who);
24 	function certified(address _who) constant returns (bool);
25 	function get(address _who, string _field) constant returns (bytes32) {}
26 	function getAddress(address _who, string _field) constant returns (address) {}
27 	function getUint(address _who, string _field) constant returns (uint) {}
28 }
29 
30 contract SimpleCertifier is Owned, Certifier {
31 
32 	modifier only_delegate {
33 		assert(msg.sender == delegate);
34 		_; 
35 	}
36 	modifier only_certified(address _who) {
37 		if (!certs[_who].active)
38 			return;
39 		_; 
40 	}
41 
42 	struct Certification {
43 		bool active;
44 		mapping (string => bytes32) meta;
45 	}
46 
47 	function certify(address _who) only_delegate {
48 		certs[_who].active = true;
49 		Confirmed(_who);
50 	}
51 	function revoke(address _who) only_delegate only_certified(_who) {
52 		certs[_who].active = false;
53 		Revoked(_who);
54 	}
55 	function certified(address _who) constant returns (bool) { return certs[_who].active; }
56 	function get(address _who, string _field) constant returns (bytes32) { return certs[_who].meta[_field]; }
57 	function getAddress(address _who, string _field) constant returns (address) { return address(certs[_who].meta[_field]); }
58 	function getUint(address _who, string _field) constant returns (uint) { return uint(certs[_who].meta[_field]); }
59 	function setDelegate(address _new) only_owner { delegate = _new; }
60 
61 	mapping (address => Certification) certs;
62 	// So that the server posting puzzles doesn't have access to the ETH.
63 	address public delegate = msg.sender;
64 }
65 
66 
67 
68 contract ProofOfSMS is SimpleCertifier {
69 
70 	modifier when_fee_paid {
71 		if (msg.value < fee)  {
72 		RequiredFeeNotMet(fee, msg.value);
73 			return;
74 		}
75 		_; 
76 	}
77 	event RequiredFeeNotMet(uint required, uint provided);
78 	event Requested(address indexed who);
79 	event Puzzled(address who, bytes32 puzzle);
80 
81 	event LogAddress(address test);
82 
83 	function request() payable when_fee_paid {
84 		if (certs[msg.sender].active) {
85 			return;
86 		}
87 		Requested(msg.sender);
88 	}
89 
90 	function puzzle (address _who, bytes32 _puzzle) only_delegate {
91 		puzzles[_who] = _puzzle;
92 		Puzzled(_who, _puzzle);
93 	}
94 
95 	function confirm(bytes32 _code) returns (bool) {
96 		LogAddress(msg.sender);
97 		if (puzzles[msg.sender] != sha3(_code))
98 			return;
99 
100 		delete puzzles[msg.sender];
101 		certs[msg.sender].active = true;
102 		Confirmed(msg.sender);
103 		return true;
104 	}
105 
106 	function setFee(uint _new) only_owner {
107 		fee = _new;
108 	}
109 
110 	function drain() only_owner {
111 		require(msg.sender.send(this.balance));
112 	}
113 
114 	function certified(address _who) constant returns (bool) {
115 		return certs[_who].active;
116 	}
117 
118 	mapping (address => bytes32) puzzles;
119 
120 	uint public fee = 30 finney;
121 }