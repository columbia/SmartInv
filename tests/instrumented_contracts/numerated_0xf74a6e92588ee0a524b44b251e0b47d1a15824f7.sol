1 //! Badge Registry contract.
2 //! By Gav Wood (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.0;
6 
7 // From Owned.sol
8 contract Owned {
9 	modifier only_owner { if (msg.sender != owner) return; _; }
10 
11 	event NewOwner(address indexed old, address indexed current);
12 
13 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
14 
15 	address public owner = msg.sender;
16 }
17 
18 contract BadgeReg is Owned {
19 	struct Badge {
20 		address addr;
21 		bytes32 name;
22 		address owner;
23 		mapping (bytes32 => bytes32) meta;
24 	}
25 
26 	modifier when_fee_paid { if (msg.value < fee) return; _; }
27 	modifier when_address_free(address _addr) { if (mapFromAddress[_addr] != 0) return; _; }
28 	modifier when_name_free(bytes32 _name) { if (mapFromName[_name] != 0) return; _; }
29 	modifier when_has_name(bytes32 _name) { if (mapFromName[_name] == 0) return; _; }
30 	modifier only_badge_owner(uint _id) { if (badges[_id].owner != msg.sender) return; _; }
31 
32 	event Registered(bytes32 indexed name, uint indexed id, address addr);
33 	event Unregistered(bytes32 indexed name, uint indexed id);
34 	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
35 	event AddressChanged(uint indexed id, address addr);
36 
37 	function register(address _addr, bytes32 _name) payable returns (bool) {
38 		return registerAs(_addr, _name, msg.sender);
39 	}
40 
41 	function registerAs(address _addr, bytes32 _name, address _owner) payable when_fee_paid when_address_free(_addr) when_name_free(_name) returns (bool) {
42 		badges.push(Badge(_addr, _name, _owner));
43 		mapFromAddress[_addr] = badges.length;
44 		mapFromName[_name] = badges.length;
45 		Registered(_name, badges.length - 1, _addr);
46 		return true;
47 	}
48 
49 	function unregister(uint _id) only_owner {
50 		Unregistered(badges[_id].name, _id);
51 		delete mapFromAddress[badges[_id].addr];
52 		delete mapFromName[badges[_id].name];
53 		delete badges[_id];
54 	}
55 
56 	function setFee(uint _fee) only_owner {
57 		fee = _fee;
58 	}
59 
60 	function badgeCount() constant returns (uint) { return badges.length; }
61 
62 	function badge(uint _id) constant returns (address addr, bytes32 name, address owner) {
63 		var t = badges[_id];
64 		addr = t.addr;
65 		name = t.name;
66 		owner = t.owner;
67 	}
68 
69 	function fromAddress(address _addr) constant returns (uint id, bytes32 name, address owner) {
70 		id = mapFromAddress[_addr] - 1;
71 		var t = badges[id];
72 		name = t.name;
73 		owner = t.owner;
74 	}
75 
76 	function fromName(bytes32 _name) constant returns (uint id, address addr, address owner) {
77 		id = mapFromName[_name] - 1;
78 		var t = badges[id];
79 		addr = t.addr;
80 		owner = t.owner;
81 	}
82 
83 	function meta(uint _id, bytes32 _key) constant returns (bytes32) {
84 		return badges[_id].meta[_key];
85 	}
86 
87 	function setAddress(uint _id, address _newAddr) only_badge_owner(_id) when_address_free(_newAddr) {
88 		var oldAddr = badges[_id].addr;
89 		badges[_id].addr = _newAddr;
90 		mapFromAddress[oldAddr] = 0;
91 		mapFromAddress[_newAddr] = _id;
92 		AddressChanged(_id, _newAddr);
93 	}
94 
95 	function setMeta(uint _id, bytes32 _key, bytes32 _value) only_badge_owner(_id) {
96 		badges[_id].meta[_key] = _value;
97 		MetaChanged(_id, _key, _value);
98 	}
99 
100 	function drain() only_owner {
101 		if (!msg.sender.send(this.balance))
102 			throw;
103 	}
104 
105 	mapping (address => uint) mapFromAddress;
106 	mapping (bytes32 => uint) mapFromName;
107 	Badge[] badges;
108 	uint public fee = 1 ether;
109 }