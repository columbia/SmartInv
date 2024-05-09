1 //! E-mail verification contract
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
25 contract ProofOfEmail is Owned, Certifier {
26 	modifier when_fee_paid { if (msg.value < fee) return; _; }
27 
28 	event Requested(address indexed who, bytes32 indexed emailHash);
29 	event Puzzled(address indexed who, bytes32 indexed emailHash, bytes32 puzzle);
30 
31 	function request(bytes32 _emailHash) payable when_fee_paid {
32 		Requested(msg.sender, _emailHash);
33 	}
34 
35 	function puzzle(address _who, bytes32 _puzzle, bytes32 _emailHash) only_owner {
36 		puzzles[_puzzle] = _emailHash;
37 		Puzzled(_who, _emailHash, _puzzle);
38 	}
39 
40 	function confirm(bytes32 _code) returns (bool) {
41 		var emailHash = puzzles[sha3(_code)];
42 		if (emailHash == 0)
43 			return;
44 		delete puzzles[sha3(_code)];
45 		if (reverse[emailHash] != 0)
46 			return;
47 		entries[msg.sender] = emailHash;
48 		reverse[emailHash] = msg.sender;
49 		Confirmed(msg.sender);
50 		return true;
51 	}
52 
53 	function setFee(uint _new) only_owner {
54 		fee = _new;
55 	}
56 
57 	function drain() only_owner {
58 		if (!msg.sender.send(this.balance))
59 			throw;
60 	}
61 
62 	function certified(address _who) constant returns (bool) {
63 		return entries[_who] != 0;
64 	}
65 
66 	function get(address _who, string _field) constant returns (bytes32) {
67 		entries[_who];
68 	}
69 
70 	mapping (address => bytes32) entries;
71 	mapping (bytes32 => address) public reverse;
72 	mapping (bytes32 => bytes32) puzzles;
73 
74 	uint public fee = 0 finney;
75 }