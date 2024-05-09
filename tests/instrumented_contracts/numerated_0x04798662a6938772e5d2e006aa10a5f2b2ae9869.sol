1 /**
2  * Copyright (C) 2018 Smartz, LLC
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License").
5  * You may not use this file except in compliance with the License.
6  *
7  * Unless required by applicable law or agreed to in writing, software
8  * distributed under the License is distributed on an "AS IS" BASIS,
9  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
10  */
11 
12 pragma solidity ^0.4.20;
13 
14 
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 /**
60  * @title Booking
61  * @author Vladimir Khramov <vladimir.khramov@smartz.io>
62  */
63 contract Ledger is Ownable {
64 
65     function Ledger() public payable {
66 
67         //empty element with id=0
68         records.push(Record('','',0));
69 
70         
71     }
72     
73     /************************** STRUCT **********************/
74     
75     struct Record {
76 string commitHash;
77 string githubUrlPointingToTheCommit;
78 bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain;
79     }
80     
81     /************************** EVENTS **********************/
82     
83     event RecordAdded(uint256 id, string commitHash, string githubUrlPointingToTheCommit, bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain);
84     
85     /************************** CONST **********************/
86     
87     string public constant name = 'MixBytes security audits registry'; 
88     string public constant description = 'Ledger enumerates security audits executed by MixBytes. Each audit is described by a revised version of a code and our report file. Anyone can ascertain that the code was audited by MixBytes and MixBytes can not deny this audit in case overlooked vulnerability is discovered. An audit can be found in this ledger by git commit hash, by full github repository commit url or by existing audit report file. Report files can be found at public audits MixBytes github repository.'; 
89     string public constant recordName = 'Security Audit'; 
90 
91     /************************** PROPERTIES **********************/
92 
93     Record[] public records;
94     mapping (bytes32 => uint256) commitHash_mapping;
95     mapping (bytes32 => uint256) githubUrlPointingToTheCommit_mapping;
96     mapping (bytes32 => uint256) auditReportFileKeccakHashOfTheFileIsStoredInBlockchain_mapping;
97 
98     /************************** EXTERNAL **********************/
99 
100     function addRecord(string _commitHash,string _githubUrlPointingToTheCommit,bytes32 _auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) external onlyOwner returns (uint256) {
101         require(0==findIdByCommitHash(_commitHash));
102         require(0==findIdByGithubUrlPointingToTheCommit(_githubUrlPointingToTheCommit));
103         require(0==findIdByAuditReportFileKeccakHashOfTheFileIsStoredInBlockchain(_auditReportFileKeccakHashOfTheFileIsStoredInBlockchain));
104     
105     
106         records.push(Record(_commitHash, _githubUrlPointingToTheCommit, _auditReportFileKeccakHashOfTheFileIsStoredInBlockchain));
107         
108         commitHash_mapping[keccak256(_commitHash)] = records.length-1;
109         githubUrlPointingToTheCommit_mapping[keccak256(_githubUrlPointingToTheCommit)] = records.length-1;
110         auditReportFileKeccakHashOfTheFileIsStoredInBlockchain_mapping[(_auditReportFileKeccakHashOfTheFileIsStoredInBlockchain)] = records.length-1;
111         
112         RecordAdded(records.length - 1, _commitHash, _githubUrlPointingToTheCommit, _auditReportFileKeccakHashOfTheFileIsStoredInBlockchain);
113         
114         return records.length - 1;
115     }
116     
117     /************************** PUBLIC **********************/
118     
119     function getRecordsCount() public view returns(uint256) {
120         return records.length - 1;
121     }
122     
123     
124     function findByCommitHash(string _commitHash) public view returns (uint256 id, string commitHash, string githubUrlPointingToTheCommit, bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) {
125         Record record = records[ findIdByCommitHash(_commitHash) ];
126         return (
127             findIdByCommitHash(_commitHash),
128             record.commitHash, record.githubUrlPointingToTheCommit, record.auditReportFileKeccakHashOfTheFileIsStoredInBlockchain
129         );
130     }
131     
132     function findIdByCommitHash(string commitHash) internal view returns (uint256) {
133         return commitHash_mapping[keccak256(commitHash)];
134     }
135 
136 
137     function findByGithubUrlPointingToTheCommit(string _githubUrlPointingToTheCommit) public view returns (uint256 id, string commitHash, string githubUrlPointingToTheCommit, bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) {
138         Record record = records[ findIdByGithubUrlPointingToTheCommit(_githubUrlPointingToTheCommit) ];
139         return (
140             findIdByGithubUrlPointingToTheCommit(_githubUrlPointingToTheCommit),
141             record.commitHash, record.githubUrlPointingToTheCommit, record.auditReportFileKeccakHashOfTheFileIsStoredInBlockchain
142         );
143     }
144     
145     function findIdByGithubUrlPointingToTheCommit(string githubUrlPointingToTheCommit) internal view returns (uint256) {
146         return githubUrlPointingToTheCommit_mapping[keccak256(githubUrlPointingToTheCommit)];
147     }
148 
149 
150     function findByAuditReportFileKeccakHashOfTheFileIsStoredInBlockchain(bytes32 _auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) public view returns (uint256 id, string commitHash, string githubUrlPointingToTheCommit, bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) {
151         Record record = records[ findIdByAuditReportFileKeccakHashOfTheFileIsStoredInBlockchain(_auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) ];
152         return (
153             findIdByAuditReportFileKeccakHashOfTheFileIsStoredInBlockchain(_auditReportFileKeccakHashOfTheFileIsStoredInBlockchain),
154             record.commitHash, record.githubUrlPointingToTheCommit, record.auditReportFileKeccakHashOfTheFileIsStoredInBlockchain
155         );
156     }
157     
158     function findIdByAuditReportFileKeccakHashOfTheFileIsStoredInBlockchain(bytes32 auditReportFileKeccakHashOfTheFileIsStoredInBlockchain) internal view returns (uint256) {
159         return auditReportFileKeccakHashOfTheFileIsStoredInBlockchain_mapping[(auditReportFileKeccakHashOfTheFileIsStoredInBlockchain)];
160     }
161 }