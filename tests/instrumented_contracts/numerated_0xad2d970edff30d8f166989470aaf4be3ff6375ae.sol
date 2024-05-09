1 pragma solidity ^0.4.8;
2 
3 /*
4 This file is part of Pass DAO.
5 
6 Pass DAO is free software: you can redistribute it and/or modify
7 it under the terms of the GNU lesser General Public License as published by
8 the Free Software Foundation, either version 3 of the License, or
9 (at your option) any later version.
10 
11 Pass DAO is distributed in the hope that it will be useful,
12 but WITHOUT ANY WARRANTY; without even the implied warranty of
13 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 GNU lesser General Public License for more details.
15 
16 You should have received a copy of the GNU lesser General Public License
17 along with Pass DAO.  If not, see <http://www.gnu.org/licenses/>.
18 */
19 
20 /*
21 Smart contract for a Decentralized Autonomous Organization (DAO)
22 to automate organizational governance and decision-making.
23 */
24 
25 /// @title Pass Dao smart contract
26 contract PassDao {
27     
28     struct revision {
29         // Address of the Committee Room smart contract
30         address committeeRoom;
31         // Address of the share manager smart contract
32         address shareManager;
33         // Address of the token manager smart contract
34         address tokenManager;
35         // Address of the project creator smart contract
36         uint startDate;
37     }
38     // The revisions of the application until today
39     revision[] public revisions;
40 
41     struct project {
42         // The address of the smart contract
43         address contractAddress;
44         // The unix effective start date of the contract
45         uint startDate;
46     }
47     // The projects of the Dao
48     project[] public projects;
49 
50     // Map with the indexes of the projects
51     mapping (address => uint) projectID;
52     
53     // The address of the meta project
54     address metaProject;
55 
56     
57 // Events
58 
59     event Upgrade(uint indexed RevisionID, address CommitteeRoom, address ShareManager, address TokenManager);
60     event NewProject(address Project);
61 
62 // Constant functions  
63     
64     /// @return The effective committee room
65     function ActualCommitteeRoom() constant returns (address) {
66         return revisions[0].committeeRoom;
67     }
68     
69     /// @return The meta project
70     function MetaProject() constant returns (address) {
71         return metaProject;
72     }
73 
74     /// @return The effective share manager
75     function ActualShareManager() constant returns (address) {
76         return revisions[0].shareManager;
77     }
78 
79     /// @return The effective token manager
80     function ActualTokenManager() constant returns (address) {
81         return revisions[0].tokenManager;
82     }
83 
84 // modifiers
85 
86     modifier onlyPassCommitteeRoom {if (msg.sender != revisions[0].committeeRoom  
87         && revisions[0].committeeRoom != 0) throw; _;}
88     
89 // Constructor function
90 
91     function PassDao() {
92         projects.length = 1;
93         revisions.length = 1;
94     }
95     
96 // Register functions
97 
98     /// @dev Function to allow the actual Committee Room upgrading the application
99     /// @param _newCommitteeRoom The address of the new committee room
100     /// @param _newShareManager The address of the new share manager
101     /// @param _newTokenManager The address of the new token manager
102     /// @return The index of the revision
103     function upgrade(
104         address _newCommitteeRoom, 
105         address _newShareManager, 
106         address _newTokenManager) onlyPassCommitteeRoom returns (uint) {
107         
108         uint _revisionID = revisions.length++;
109         revision r = revisions[_revisionID];
110 
111         if (_newCommitteeRoom != 0) r.committeeRoom = _newCommitteeRoom; else r.committeeRoom = revisions[0].committeeRoom;
112         if (_newShareManager != 0) r.shareManager = _newShareManager; else r.shareManager = revisions[0].shareManager;
113         if (_newTokenManager != 0) r.tokenManager = _newTokenManager; else r.tokenManager = revisions[0].tokenManager;
114 
115         r.startDate = now;
116         
117         revisions[0] = r;
118         
119         Upgrade(_revisionID, _newCommitteeRoom, _newShareManager, _newTokenManager);
120             
121         return _revisionID;
122     }
123 
124     /// @dev Function to set the meta project
125     /// @param _projectAddress The address of the meta project
126     function addMetaProject(address _projectAddress) onlyPassCommitteeRoom {
127 
128         metaProject = _projectAddress;
129     }
130     
131     /// @dev Function to allow the committee room to add a project when ordering
132     /// @param _projectAddress The address of the project
133     function addProject(address _projectAddress) onlyPassCommitteeRoom {
134 
135         if (projectID[_projectAddress] == 0) {
136 
137             uint _projectID = projects.length++;
138             project p = projects[_projectID];
139         
140             projectID[_projectAddress] = _projectID;
141             p.contractAddress = _projectAddress; 
142             p.startDate = now;
143             
144             NewProject(_projectAddress);
145         }
146     }
147     
148 }