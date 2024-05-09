1 // Copyright (c) 2017 Sweetbridge Inc.
2 //
3 // Licensed under the Apache License, Version 2.0 (the "License");
4 // you may not use this file except in compliance with the License.
5 // You may obtain a copy of the License at
6 //
7 //     http://www.apache.org/licenses/LICENSE-2.0
8 //
9 // Unless required by applicable law or agreed to in writing, software
10 // distributed under the License is distributed on an "AS IS" BASIS,
11 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
12 // See the License for the specific language governing permissions and
13 // limitations under the License.
14 
15 pragma solidity ^0.4.17;
16 
17 contract OwnedEvents {
18     event LogSetOwner (address newOwner);
19 }
20 
21 
22 contract Owned is OwnedEvents {
23     address public owner;
24 
25     function Owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function setOwner(address owner_) public onlyOwner {
35         owner = owner_;
36         LogSetOwner(owner);
37     }
38 
39 }
40 
41 interface SecuredWithRolesI {
42     function hasRole(string roleName) public view returns (bool);
43     function senderHasRole(string roleName) public view returns (bool);
44     function contractHash() public view returns (bytes32);
45 }
46 
47 
48 contract SecuredWithRoles is Owned {
49     RolesI public roles;
50     bytes32 public contractHash;
51     bool public stopped = false;
52 
53     function SecuredWithRoles(string contractName_, address roles_) public {
54         contractHash = keccak256(contractName_);
55         roles = RolesI(roles_);
56     }
57 
58     modifier stoppable() {
59         require(!stopped);
60         _;
61     }
62 
63     modifier onlyRole(string role) {
64         require(senderHasRole(role));
65         _;
66     }
67 
68     modifier roleOrOwner(string role) {
69         require(msg.sender == owner || senderHasRole(role));
70         _;
71     }
72 
73     // returns true if the role has been defined for the contract
74     function hasRole(string roleName) public view returns (bool) {
75         return roles.knownRoleNames(contractHash, keccak256(roleName));
76     }
77 
78     function senderHasRole(string roleName) public view returns (bool) {
79         return hasRole(roleName) && roles.roleList(contractHash, keccak256(roleName), msg.sender);
80     }
81 
82     function stop() public roleOrOwner("stopper") {
83         stopped = true;
84     }
85 
86     function restart() public roleOrOwner("restarter") {
87         stopped = false;
88     }
89 
90     function setRolesContract(address roles_) public onlyOwner {
91         // it must not be possible to change the roles contract on the roles contract itself
92         require(this != address(roles));
93         roles = RolesI(roles_);
94     }
95 
96 }
97 
98 
99 interface RolesI {
100     function knownRoleNames(bytes32 contractHash, bytes32 nameHash) public view returns (bool);
101     function roleList(bytes32 contractHash, bytes32 nameHash, address member) public view returns (bool);
102 
103     function addContractRole(bytes32 ctrct, string roleName) public;
104     function removeContractRole(bytes32 ctrct, string roleName) public;
105     function grantUserRole(bytes32 ctrct, string roleName, address user) public;
106     function revokeUserRole(bytes32 ctrct, string roleName, address user) public;
107 }
108 
109 
110 contract RolesEvents {
111     event LogRoleAdded(bytes32 contractHash, string roleName);
112     event LogRoleRemoved(bytes32 contractHash, string roleName);
113     event LogRoleGranted(bytes32 contractHash, string roleName, address user);
114     event LogRoleRevoked(bytes32 contractHash, string roleName, address user);
115 }
116 
117 
118 contract Roles is RolesEvents, SecuredWithRoles {
119     // mapping is contract -> role -> sender_address -> boolean
120     mapping(bytes32 => mapping (bytes32 => mapping (address => bool))) public roleList;
121     // the intention is
122     mapping (bytes32 => mapping (bytes32 => bool)) public knownRoleNames;
123 
124     function Roles() SecuredWithRoles("RolesRepository", this) public {}
125 
126     function addContractRole(bytes32 ctrct, string roleName) public roleOrOwner("admin") {
127         require(!knownRoleNames[ctrct][keccak256(roleName)]);
128         knownRoleNames[ctrct][keccak256(roleName)] = true;
129         LogRoleAdded(ctrct, roleName);
130     }
131 
132     function removeContractRole(bytes32 ctrct, string roleName) public roleOrOwner("admin") {
133         require(knownRoleNames[ctrct][keccak256(roleName)]);
134         delete knownRoleNames[ctrct][keccak256(roleName)];
135         LogRoleRemoved(ctrct, roleName);
136     }
137 
138     function grantUserRole(bytes32 ctrct, string roleName, address user) public roleOrOwner("admin") {
139         require(knownRoleNames[ctrct][keccak256(roleName)]);
140         roleList[ctrct][keccak256(roleName)][user] = true;
141         LogRoleGranted(ctrct, roleName, user);
142     }
143 
144     function revokeUserRole(bytes32 ctrct, string roleName, address user) public roleOrOwner("admin") {
145         delete roleList[ctrct][keccak256(roleName)][user];
146         LogRoleRevoked(ctrct, roleName, user);
147     }
148 
149 }