1 // This software is a subject to Ambisafe License Agreement.
2 // No use or distribution is allowed without written permission from Ambisafe.
3 // https://www.ambisafe.com/terms-of-use/
4 
5 pragma solidity ^0.4.8;
6 
7 contract Ambi2 {
8     bytes32 constant OWNER = "__root__";
9     uint constant LIFETIME = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
10     mapping(bytes32 => uint) rolesExpiration;
11     mapping(address => bool) nodes;
12 
13     event Assign(address indexed from, bytes32 indexed role, address indexed to, uint expirationDate);
14     event Unassign(address indexed from, bytes32 indexed role, address indexed to);
15     event Error(bytes32 message);
16 
17     modifier onlyNodeOwner(address _node) {
18         if (isOwner(_node, msg.sender)) {
19             _;
20         } else {
21             _error("Access denied: only node owner");
22         }
23     }
24 
25     function claimFor(address _address, address _owner) returns(bool) {
26         if (nodes[_address]) {
27             _error("Access denied: already owned");
28             return false;
29         }
30         nodes[_address] = true;
31         _assignRole(_address, OWNER, _owner, LIFETIME);
32         return true;
33     }
34 
35     function claim(address _address) returns(bool) {
36         return claimFor(_address, msg.sender);
37     }
38 
39     function assignOwner(address _node, address _owner) returns(bool) {
40         return assignRole(_node, OWNER, _owner);
41     }
42 
43     function assignRole(address _from, bytes32 _role, address _to) returns(bool) {
44         return assignRoleWithExpiration(_from, _role, _to, LIFETIME);
45     }
46 
47     function assignRoleWithExpiration(address _from, bytes32 _role, address _to, uint _expirationDate) onlyNodeOwner(_from) returns(bool) {
48         if (hasRole(_from, _role, _to) && rolesExpiration[_getRoleSignature(_from, _role, _to)] == _expirationDate) {
49             _error("Role already assigned");
50             return false;
51         }
52         if (_isPast(_expirationDate)) {
53             _error("Invalid expiration date");
54             return false;
55         }
56 
57         _assignRole(_from, _role, _to, _expirationDate);
58         return true;
59     }
60 
61     function _assignRole(address _from, bytes32 _role, address _to, uint _expirationDate) internal {
62         rolesExpiration[_getRoleSignature(_from, _role, _to)] = _expirationDate;
63         Assign(_from, _role, _to, _expirationDate);
64     }
65 
66     function unassignOwner(address _node, address _owner) returns(bool) {
67         if (_owner == msg.sender) {
68             _error("Cannot remove ownership");
69             return false;
70         }
71 
72         return unassignRole(_node, OWNER, _owner);
73     }
74 
75     function unassignRole(address _from, bytes32 _role, address _to) onlyNodeOwner(_from) returns(bool) {
76         if (!hasRole(_from, _role, _to)) {
77             _error("Role not assigned");
78             return false;
79         }
80 
81         delete rolesExpiration[_getRoleSignature(_from, _role, _to)];
82         Unassign(_from, _role, _to);
83         return true;
84     }
85 
86     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool) {
87         return _isFuture(rolesExpiration[_getRoleSignature(_from, _role, _to)]);
88     }
89 
90     function isOwner(address _node, address _owner) constant returns(bool) {
91         return hasRole(_node, OWNER, _owner);
92     }
93 
94     function _error(bytes32 _message) internal {
95         Error(_message);
96     }
97 
98     function _getRoleSignature(address _from, bytes32 _role, address _to) internal constant returns(bytes32) {
99         return sha3(_from, _role, _to);
100     }
101 
102     function _isPast(uint _timestamp) internal constant returns(bool) {
103         return _timestamp < now;
104     }
105 
106     function _isFuture(uint _timestamp) internal constant returns(bool) {
107         return !_isPast(_timestamp);
108     }
109 }