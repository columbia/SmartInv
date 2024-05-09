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
79 
80 contract VouchFor {
81     
82     event Vouched(address who, bytes32 what);
83 
84     function VouchFor(address _certifier) public {
85         certifier = Certifier(_certifier);
86     }
87     
88     function vouch(bytes32 _what)
89         public
90         only_certified
91     {
92         vouchers[_what].push(msg.sender);
93         Vouched(msg.sender, _what);
94     }
95     
96     function vouched(bytes32 _what, uint _index)
97         public
98         constant
99         returns (address)
100     {
101         return vouchers[_what][_index];
102     }
103     
104     function unvouch(bytes32 _what, uint _index)
105         public
106     {
107         uint count = vouchers[_what].length;
108         require (count > 0);
109         require (_index < count);
110         require (vouchers[_what][_index] == msg.sender);
111         if (_index != count - 1) {
112             vouchers[_what][_index] = vouchers[_what][count - 1];
113         }
114         delete vouchers[_what][count - 1];
115         vouchers[_what].length = count - 1;
116     }
117     
118     modifier only_certified {
119         require (certifier.certified(msg.sender));
120         _;
121     }
122     
123     mapping (bytes32 => address[]) public vouchers;
124     Certifier public certifier;
125 }