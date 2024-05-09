1 pragma solidity ^0.4.11;
2 
3 /*  Copyright 2017 GoInto, LLC
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 */
17 
18 /** gointo migration tracker
19 
20     Tracks the locations of smart contracts and their libraries should the need 
21     arise for a migration
22  */
23 contract GointoMigration {
24 
25     struct Manager {
26         bool isAdmin;
27         bool isManager;
28         address addedBy;
29     }
30 
31     mapping (address => Manager) internal managers;
32     mapping (string => address) internal contracts;
33 
34     event EventSetContract(address by, string key, address contractAddress);
35     event EventAddAdmin(address by, address admin);
36     event EventRemoveAdmin(address by, address admin);
37     event EventAddManager(address by, address manager);
38     event EventRemoveManager(address by, address manager);
39 
40     /**
41      * Only admins can execute
42      */
43     modifier onlyAdmin() { 
44         require(managers[msg.sender].isAdmin == true);
45         _; 
46     }
47 
48     /**
49      * Only managers can execute
50      */
51     modifier onlyManager() { 
52         require(managers[msg.sender].isManager == true);
53         _; 
54     }
55 
56     function GointoMigration(address originalAdmin) {
57         managers[originalAdmin] = Manager(true, true, msg.sender);
58     }
59 
60     /**
61      * Set a contract location by key
62      * @param key - The string key to be used for lookup.  e.g. 'etherep'
63      * @param contractAddress - The address of the contract
64      */
65     function setContract(string key, address contractAddress) external onlyManager {
66 
67         // Keep the key length down
68         require(bytes(key).length <= 32);
69 
70         // Set
71         contracts[key] = contractAddress;
72 
73         // Send event notification
74         EventSetContract(msg.sender, key, contractAddress);
75 
76     }
77 
78     /**
79      * Get a contract location by key
80      * @param key - The string key to be used for lookup.  e.g. 'etherep'
81      * @return contractAddress - The address of the contract
82      */
83     function getContract(string key) external constant returns (address) {
84 
85         // Keep the key length down
86         require(bytes(key).length <= 32);
87 
88         // Set
89         return contracts[key];
90 
91     }
92 
93     /**
94      * Get permissions of an address
95      * @param who - The address to check
96      * @return isAdmin - Is this address an admin?
97      * @return isManager - Is this address a manager?
98      */
99     function getPermissions(address who) external constant returns (bool, bool) {
100         return (managers[who].isAdmin, managers[who].isManager);
101     }
102 
103     /**
104      * Add an admin
105      * @param adminAddress - The address of the admin
106      */
107     function addAdmin(address adminAddress) external onlyAdmin {
108 
109         // Set
110         managers[adminAddress] = Manager(true, true, msg.sender);
111 
112         // Send event notification
113         EventAddAdmin(msg.sender, adminAddress);
114 
115     }
116 
117     /**
118      * Remove an admin
119      * @param adminAddress - The address of the admin
120      */
121     function removeAdmin(address adminAddress) external onlyAdmin {
122 
123         // Let's make sure we have at least one admin
124         require(adminAddress != msg.sender);
125 
126         // Set
127         managers[adminAddress] = Manager(false, false, msg.sender);
128 
129         // Send event notification
130         EventRemoveAdmin(msg.sender, adminAddress);
131 
132     }
133 
134     /**
135      * Add a manager
136      * @param manAddress - The address of the new manager
137      */
138     function addManager(address manAddress) external onlyAdmin {
139 
140         // Set
141         managers[manAddress] = Manager(false, true, msg.sender);
142 
143         // Send event notification
144         EventAddManager(msg.sender, manAddress);
145 
146     }
147 
148     /**
149      * Remove a manager
150      * @param manAddress - The address of the new manager
151      */
152     function removeManager(address manAddress) external onlyAdmin {
153 
154         // Set
155         managers[manAddress] = Manager(false, false, msg.sender);
156 
157         // Send event notification
158         EventRemoveManager(msg.sender, manAddress);
159 
160     }
161 
162 }