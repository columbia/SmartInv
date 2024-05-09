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
377     
378 
379 pragma solidity ^0.4.8;
380 
381 /*
382  *
383  * This file is part of Pass DAO.
384  *
385  * The Project smart contract is used for the management of the Pass Dao projects.
386  *
387 */
388 
389 /// @title Contractor smart contract of the Pass Decentralized Autonomous Organisation
390 contract PassContractor {
391     
392     // The project smart contract
393     PassProject passProject;
394     
395     // The address of the creator of this smart contract
396     address public creator;
397     // Address of the recipient;
398     address public recipient;
399 
400     // End date of the setup procedure
401     uint public smartContractStartDate;
402 
403     struct proposal {
404         // Amount (in wei) of the proposal
405         uint amount;
406         // A description of the proposal
407         string description;
408         // The hash of the proposal's document
409         bytes32 hashOfTheDocument;
410         // A unix timestamp, denoting the date when the proposal was created
411         uint dateOfProposal;
412         // The amount submitted to a vote
413         uint submittedAmount;
414         // The sum amount (in wei) ordered for this proposal 
415         uint orderAmount;
416         // A unix timestamp, denoting the date of the last order for the approved proposal
417         uint dateOfLastOrder;
418     }
419     // Proposals to work for Pass Dao
420     proposal[] public proposals;
421 
422 // Events
423 
424     event RecipientUpdated(address indexed By, address LastRecipient, address NewRecipient);
425     event Withdrawal(address indexed By, address indexed Recipient, uint Amount);
426     event ProposalAdded(address Creator, uint indexed ProposalID, uint Amount, string Description, bytes32 HashOfTheDocument);
427     event ProposalSubmitted(address indexed Client, uint Amount);
428     event Order(address indexed Client, uint indexed ProposalID, uint Amount);
429 
430 // Constant functions
431 
432     /// @return the actual committee room of the Dao
433     function Client() constant returns (address) {
434         return passProject.Client();
435     }
436 
437     /// @return the project smart contract
438     function Project() constant returns (PassProject) {
439         return passProject;
440     }
441     
442     /// @notice Function used by the client to check the proposal before submitting
443     /// @param _sender The creator of the Dao proposal
444     /// @param _proposalID The index of the proposal
445     /// @param _amount The amount of the proposal
446     /// @return true if the proposal can be submitted
447     function proposalChecked(
448         address _sender,
449         uint _proposalID, 
450         uint _amount) constant external onlyClient returns (bool) {
451         if (_sender != recipient && _sender != creator) return;
452         if (_amount <= proposals[_proposalID].amount - proposals[_proposalID].submittedAmount) return true;
453     }
454 
455     /// @return The number of proposals     
456     function numberOfProposals() constant returns (uint) {
457         return proposals.length - 1;
458     }
459 
460 
461 // Modifiers
462 
463     // Modifier for contractor functions
464     modifier onlyContractor {if (msg.sender != recipient) throw; _;}
465     
466     // Modifier for client functions
467     modifier onlyClient {if (msg.sender != Client()) throw; _;}
468 
469 // Constructor function
470 
471     function PassContractor(
472         address _creator, 
473         PassProject _passProject, 
474         address _recipient,
475         bool _restore) { 
476 
477         if (address(_passProject) == 0) throw;
478         
479         creator = _creator;
480         if (_recipient == 0) _recipient = _creator;
481         recipient = _recipient;
482         
483         passProject = _passProject;
484         
485         if (!_restore) smartContractStartDate = now;
486 
487         proposals.length = 1;
488     }
489 
490 // Setting functions
491 
492     /// @notice Function to clone a proposal from the last contractor
493     /// @param _amount Amount (in wei) of the proposal
494     /// @param _description A description of the proposal
495     /// @param _hashOfTheDocument The hash of the proposal's document
496     /// @param _dateOfProposal A unix timestamp, denoting the date when the proposal was created
497     /// @param _orderAmount The sum amount (in wei) ordered for this proposal 
498     /// @param _dateOfOrder A unix timestamp, denoting the date of the last order for the approved proposal
499     /// @param _cloneOrder True if the order has to be cloned in the project smart contract
500     /// @return Whether the function was successful or not 
501     function cloneProposal(
502         uint _amount,
503         string _description,
504         bytes32 _hashOfTheDocument,
505         uint _dateOfProposal,
506         uint _orderAmount,
507         uint _dateOfOrder,
508         bool _cloneOrder
509     ) returns (bool success) {
510             
511         if (smartContractStartDate != 0 || recipient == 0
512         || msg.sender != creator) throw;
513         
514         uint _proposalID = proposals.length++;
515         proposal c = proposals[_proposalID];
516 
517         c.amount = _amount;
518         c.description = _description;
519         c.hashOfTheDocument = _hashOfTheDocument; 
520         c.dateOfProposal = _dateOfProposal;
521         c.orderAmount = _orderAmount;
522         c.dateOfLastOrder = _dateOfOrder;
523 
524         ProposalAdded(msg.sender, _proposalID, _amount, _description, _hashOfTheDocument);
525         
526         if (_cloneOrder) passProject.cloneOrder(address(this), _proposalID, _orderAmount, _dateOfOrder);
527         
528         return true;
529     }
530 
531     /// @notice Function to close the setting procedure and start to use this smart contract
532     /// @return True if successful
533     function closeSetup() returns (bool) {
534         
535         if (smartContractStartDate != 0 
536             || (msg.sender != creator && msg.sender != Client())) return;
537 
538         smartContractStartDate = now;
539 
540         return true;
541     }
542     
543 // Account Management
544 
545     /// @notice Function to update the recipent address
546     /// @param _newRecipient The adress of the recipient
547     function updateRecipient(address _newRecipient) onlyContractor {
548 
549         if (_newRecipient == 0) throw;
550 
551         RecipientUpdated(msg.sender, recipient, _newRecipient);
552         recipient = _newRecipient;
553     } 
554 
555     /// @notice Function to receive payments
556     function () payable { }
557     
558     /// @notice Function to allow contractors to withdraw ethers
559     /// @param _amount The amount (in wei) to withdraw
560     function withdraw(uint _amount) onlyContractor {
561         if (!recipient.send(_amount)) throw;
562         Withdrawal(msg.sender, recipient, _amount);
563     }
564     
565 // Project Manager Functions    
566 
567     /// @notice Function to allow the project manager updating the description of the project
568     /// @param _projectDescription A description of the project
569     /// @param _hashOfTheDocument The hash of the last document
570     function updateProjectDescription(string _projectDescription, bytes32 _hashOfTheDocument) onlyContractor {
571         passProject.updateDescription(_projectDescription, _hashOfTheDocument);
572     }
573     
574 // Management of proposals
575 
576     /// @notice Function to make a proposal to work for the client
577     /// @param _creator The address of the creator of the proposal
578     /// @param _amount The amount (in wei) of the proposal
579     /// @param _description String describing the proposal
580     /// @param _hashOfTheDocument The hash of the proposal document
581     /// @return The index of the contractor proposal
582     function newProposal(
583         address _creator,
584         uint _amount,
585         string _description, 
586         bytes32 _hashOfTheDocument
587     ) external returns (uint) {
588         
589         if (msg.sender == Client() && _creator != recipient && _creator != creator) throw;
590         if (msg.sender != Client() && msg.sender != recipient && msg.sender != creator) throw;
591 
592         if (_amount == 0) throw;
593         
594         uint _proposalID = proposals.length++;
595         proposal c = proposals[_proposalID];
596 
597         c.amount = _amount;
598         c.description = _description;
599         c.hashOfTheDocument = _hashOfTheDocument; 
600         c.dateOfProposal = now;
601         
602         ProposalAdded(msg.sender, _proposalID, c.amount, c.description, c.hashOfTheDocument);
603         
604         return _proposalID;
605     }
606     
607     /// @notice Function used by the client to infor about the submitted amount
608     /// @param _sender The address of the sender who submits the proposal
609     /// @param _proposalID The index of the contractor proposal
610     /// @param _amount The amount (in wei) submitted
611     function submitProposal(
612         address _sender, 
613         uint _proposalID, 
614         uint _amount) onlyClient {
615 
616         if (_sender != recipient && _sender != creator) throw;    
617         proposals[_proposalID].submittedAmount += _amount;
618         ProposalSubmitted(msg.sender, _amount);
619     }
620 
621     /// @notice Function used by the client to order according to the contractor proposal
622     /// @param _proposalID The index of the contractor proposal
623     /// @param _orderAmount The amount (in wei) of the order
624     /// @return Whether the order was made or not
625     function order(
626         uint _proposalID,
627         uint _orderAmount
628     ) external onlyClient returns (bool) {
629     
630         proposal c = proposals[_proposalID];
631         
632         uint _sum = c.orderAmount + _orderAmount;
633         if (_sum > c.amount
634             || _sum < c.orderAmount
635             || _sum < _orderAmount) return; 
636 
637         c.orderAmount = _sum;
638         c.dateOfLastOrder = now;
639         
640         Order(msg.sender, _proposalID, _orderAmount);
641         
642         return true;
643     }
644     
645 }
646 
647 contract PassContractorCreator {
648     
649     // Address of the pass Dao smart contract
650     PassDao public passDao;
651     // Address of the Pass Project creator
652     PassProjectCreator public projectCreator;
653     
654     struct contractor {
655         // The address of the creator of the contractor
656         address creator;
657         // The contractor smart contract
658         PassContractor contractor;
659         // The address of the recipient for withdrawals
660         address recipient;
661         // True if meta project
662         bool metaProject;
663         // The address of the existing project smart contract
664         PassProject passProject;
665         // The name of the project (if the project smart contract doesn't exist)
666         string projectName;
667         // A description of the project (can be updated after)
668         string projectDescription;
669         // The unix creation date of the contractor
670         uint creationDate;
671     }
672     // contractors created to work for Pass Dao
673     contractor[] public contractors;
674     
675     event NewPassContractor(address indexed Creator, address indexed Recipient, PassProject indexed Project, PassContractor Contractor);
676 
677     function PassContractorCreator(PassDao _passDao, PassProjectCreator _projectCreator) {
678         passDao = _passDao;
679         projectCreator = _projectCreator;
680         contractors.length = 0;
681     }
682 
683     /// @return The number of created contractors 
684     function numberOfContractors() constant returns (uint) {
685         return contractors.length;
686     }
687     
688     /// @notice Function to create a contractor smart contract
689     /// @param _creator The address of the creator of the contractor
690     /// @param _recipient The address of the recipient for withdrawals
691     /// @param _metaProject True if meta project
692     /// @param _passProject The address of the existing project smart contract
693     /// @param _projectName The name of the project (if the project smart contract doesn't exist)
694     /// @param _projectDescription A description of the project (can be updated after)
695     /// @param _restore True if orders or proposals are to be cloned from other contracts
696     /// @return The address of the created contractor smart contract
697     function createContractor(
698         address _creator,
699         address _recipient, 
700         bool _metaProject,
701         PassProject _passProject,
702         string _projectName, 
703         string _projectDescription,
704         bool _restore) returns (PassContractor) {
705  
706         PassProject _project;
707 
708         if (_creator == 0) _creator = msg.sender;
709         
710         if (_metaProject) _project = PassProject(passDao.MetaProject());
711         else if (address(_passProject) == 0) 
712             _project = projectCreator.createProject(passDao, _projectName, _projectDescription, 0);
713         else _project = _passProject;
714 
715         PassContractor _contractor = new PassContractor(_creator, _project, _recipient, _restore);
716         if (!_metaProject && address(_passProject) == 0 && !_restore) _project.setProjectManager(address(_contractor));
717         
718         uint _contractorID = contractors.length++;
719         contractor c = contractors[_contractorID];
720         c.creator = _creator;
721         c.contractor = _contractor;
722         c.recipient = _recipient;
723         c.metaProject = _metaProject;
724         c.passProject = _passProject;
725         c.projectName = _projectName;
726         c.projectDescription = _projectDescription;
727         c.creationDate = now;
728 
729         NewPassContractor(_creator, _recipient, _project, _contractor);
730  
731         return _contractor;
732     }
733     
734 }