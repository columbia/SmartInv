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
149 
150 pragma solidity ^0.4.8;
151 
152 /*
153  *
154  * This file is part of Pass DAO.
155  *
156  * The Project smart contract is used for the management of the Pass Dao projects.
157  *
158 */
159 
160 /// @title Project smart contract of the Pass Decentralized Autonomous Organisation
161 contract PassProject {
162 
163     // The Pass Dao smart contract
164     PassDao public passDao;
165     
166     // The project name
167     string public name;
168     // The project description
169     string public description;
170     // The Hash Of the project Document
171     bytes32 public hashOfTheDocument;
172     // The project manager smart contract
173     address projectManager;
174 
175     struct order {
176         // The address of the contractor smart contract
177         address contractorAddress;
178         // The index of the contractor proposal
179         uint contractorProposalID;
180         // The amount of the order
181         uint amount;
182         // The date of the order
183         uint orderDate;
184     }
185     // The orders of the Dao for this project
186     order[] public orders;
187     
188     // The total amount of orders in wei for this project
189     uint public totalAmountOfOrders;
190 
191     struct resolution {
192         // The name of the resolution
193         string name;
194         // A description of the resolution
195         string description;
196         // The date of the resolution
197         uint creationDate;
198     }
199     // Resolutions of the Dao for this project
200     resolution[] public resolutions;
201     
202 // Events
203 
204     event OrderAdded(address indexed Client, address indexed ContractorAddress, uint indexed ContractorProposalID, uint Amount, uint OrderDate);
205     event ProjectDescriptionUpdated(address indexed By, string NewDescription, bytes32 NewHashOfTheDocument);
206     event ResolutionAdded(address indexed Client, uint indexed ResolutionID, string Name, string Description);
207 
208 // Constant functions  
209 
210     /// @return the actual committee room of the Dao   
211     function Client() constant returns (address) {
212         return passDao.ActualCommitteeRoom();
213     }
214     
215     /// @return The number of orders 
216     function numberOfOrders() constant returns (uint) {
217         return orders.length - 1;
218     }
219     
220     /// @return The project Manager address
221     function ProjectManager() constant returns (address) {
222         return projectManager;
223     }
224 
225     /// @return The number of resolutions 
226     function numberOfResolutions() constant returns (uint) {
227         return resolutions.length - 1;
228     }
229     
230 // modifiers
231 
232     // Modifier for project manager functions 
233     modifier onlyProjectManager {if (msg.sender != projectManager) throw; _;}
234 
235     // Modifier for the Dao functions 
236     modifier onlyClient {if (msg.sender != Client()) throw; _;}
237 
238 // Constructor function
239 
240     function PassProject(
241         PassDao _passDao, 
242         string _name,
243         string _description,
244         bytes32 _hashOfTheDocument) {
245 
246         passDao = _passDao;
247         name = _name;
248         description = _description;
249         hashOfTheDocument = _hashOfTheDocument;
250         
251         orders.length = 1;
252         resolutions.length = 1;
253     }
254     
255 // Internal functions
256 
257     /// @dev Internal function to register a new order
258     /// @param _contractorAddress The address of the contractor smart contract
259     /// @param _contractorProposalID The index of the contractor proposal
260     /// @param _amount The amount in wei of the order
261     /// @param _orderDate The date of the order 
262     function addOrder(
263 
264         address _contractorAddress, 
265         uint _contractorProposalID, 
266         uint _amount, 
267         uint _orderDate) internal {
268 
269         uint _orderID = orders.length++;
270         order d = orders[_orderID];
271         d.contractorAddress = _contractorAddress;
272         d.contractorProposalID = _contractorProposalID;
273         d.amount = _amount;
274         d.orderDate = _orderDate;
275         
276         totalAmountOfOrders += _amount;
277         
278         OrderAdded(msg.sender, _contractorAddress, _contractorProposalID, _amount, _orderDate);
279     }
280     
281 // Setting functions
282 
283     /// @notice Function to allow cloning orders in case of upgrade
284     /// @param _contractorAddress The address of the contractor smart contract
285     /// @param _contractorProposalID The index of the contractor proposal
286     /// @param _orderAmount The amount in wei of the order
287     /// @param _lastOrderDate The unix date of the last order 
288     function cloneOrder(
289         address _contractorAddress, 
290         uint _contractorProposalID, 
291         uint _orderAmount, 
292         uint _lastOrderDate) {
293         
294         if (projectManager != 0) throw;
295         
296         addOrder(_contractorAddress, _contractorProposalID, _orderAmount, _lastOrderDate);
297     }
298     
299     /// @notice Function to set the project manager
300     /// @param _projectManager The address of the project manager smart contract
301     /// @return True if successful
302     function setProjectManager(address _projectManager) returns (bool) {
303 
304         if (_projectManager == 0 || projectManager != 0) return;
305         
306         projectManager = _projectManager;
307         
308         return true;
309     }
310 
311 // Project manager functions
312 
313     /// @notice Function to allow the project manager updating the description of the project
314     /// @param _projectDescription A description of the project
315     /// @param _hashOfTheDocument The hash of the last document
316     function updateDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyProjectManager {
317         description = _projectDescription;
318         hashOfTheDocument = _hashOfTheDocument;
319         ProjectDescriptionUpdated(msg.sender, _projectDescription, _hashOfTheDocument);
320     }
321 
322 // Client functions
323 
324     /// @dev Function to allow the Dao to register a new order
325     /// @param _contractorAddress The address of the contractor smart contract
326     /// @param _contractorProposalID The index of the contractor proposal
327     /// @param _amount The amount in wei of the order
328     function newOrder(
329         address _contractorAddress, 
330         uint _contractorProposalID, 
331         uint _amount) onlyClient {
332             
333         addOrder(_contractorAddress, _contractorProposalID, _amount, now);
334     }
335     
336     /// @dev Function to allow the Dao to register a new resolution
337     /// @param _name The name of the resolution
338     /// @param _description The description of the resolution
339     function newResolution(
340         string _name, 
341         string _description) onlyClient {
342 
343         uint _resolutionID = resolutions.length++;
344         resolution d = resolutions[_resolutionID];
345         
346         d.name = _name;
347         d.description = _description;
348         d.creationDate = now;
349 
350         ResolutionAdded(msg.sender, _resolutionID, d.name, d.description);
351     }
352 }
353 
354 contract PassProjectCreator {
355     
356     event NewPassProject(PassDao indexed Dao, PassProject indexed Project, string Name, string Description, bytes32 HashOfTheDocument);
357 
358     /// @notice Function to create a new Pass project
359     /// @param _passDao The Pass Dao smart contract
360     /// @param _name The project name
361     /// @param _description The project description (not mandatory, can be updated after by the creator)
362     /// @param _hashOfTheDocument The Hash Of the project Document (not mandatory, can be updated after by the creator)
363     function createProject(
364         PassDao _passDao,
365         string _name, 
366         string _description, 
367         bytes32 _hashOfTheDocument
368         ) returns (PassProject) {
369 
370         PassProject _passProject = new PassProject(_passDao, _name, _description, _hashOfTheDocument);
371 
372         NewPassProject(_passDao, _passProject, _name, _description, _hashOfTheDocument);
373 
374         return _passProject;
375     }
376 }