1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain 
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.20;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     function AccessAdmin() public {
19         addrAdmin = msg.sender;
20     }  
21 
22     modifier onlyAdmin() {
23         require(msg.sender == addrAdmin);
24         _;
25     }
26 
27     modifier whenNotPaused() {
28         require(!isPaused);
29         _;
30     }
31 
32     modifier whenPaused {
33         require(isPaused);
34         _;
35     }
36 
37     function setAdmin(address _newAdmin) external onlyAdmin {
38         require(_newAdmin != address(0));
39         AdminTransferred(addrAdmin, _newAdmin);
40         addrAdmin = _newAdmin;
41     }
42 
43     function doPause() external onlyAdmin whenNotPaused {
44         isPaused = true;
45     }
46 
47     function doUnpause() external onlyAdmin whenPaused {
48         isPaused = false;
49     }
50 }
51 
52 contract AccessService is AccessAdmin {
53     address public addrService;
54     address public addrFinance;
55 
56     modifier onlyService() {
57         require(msg.sender == addrService);
58         _;
59     }
60 
61     modifier onlyFinance() {
62         require(msg.sender == addrFinance);
63         _;
64     }
65 
66     function setService(address _newService) external {
67         require(msg.sender == addrService || msg.sender == addrAdmin);
68         require(_newService != address(0));
69         addrService = _newService;
70     }
71 
72     function setFinance(address _newFinance) external {
73         require(msg.sender == addrFinance || msg.sender == addrAdmin);
74         require(_newFinance != address(0));
75         addrFinance = _newFinance;
76     }
77 
78     function withdraw(address _target, uint256 _amount) 
79         external 
80     {
81         require(msg.sender == addrFinance || msg.sender == addrAdmin);
82         require(_amount > 0);
83         address receiver = _target == address(0) ? addrFinance : _target;
84         uint256 balance = this.balance;
85         if (_amount < balance) {
86             receiver.transfer(_amount);
87         } else {
88             receiver.transfer(this.balance);
89         }      
90     }
91 }
92 
93 interface IDataMining {
94     function getRecommender(address _target) external view returns(address);
95     function subFreeMineral(address _target) external returns(bool);
96 }
97 
98 interface IDataEquip {
99     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
100     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
101     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
102 }
103 
104 contract DataMining is AccessService, IDataMining {
105     event RecommenderChange(address indexed _target, address _recommender);
106     event FreeMineralChange(address indexed _target, uint32 _accCnt);
107 
108     /// @dev Recommend relationship map
109     mapping (address => address) recommendRelation;
110     /// @dev Free mining count map
111     mapping (address => uint32) freeMineral;
112     /// @dev Trust contract
113     mapping (address => bool) actionContracts;
114 
115     function DataMining() public {
116         addrAdmin = msg.sender;
117         addrService = msg.sender;
118         addrFinance = msg.sender;
119     }
120 
121     function setRecommender(address _target, address _recommender) 
122         external
123         onlyService
124     {
125         require(_target != address(0));
126         recommendRelation[_target] = _recommender;
127         RecommenderChange(_target, _recommender);
128     }
129 
130     function setRecommenderMulti(address[] _targets, address[] _recommenders) 
131         external
132         onlyService
133     {
134         uint256 targetLength = _targets.length;
135         require(targetLength <= 64);
136         require(targetLength == _recommenders.length);
137         address addrZero = address(0);
138         for (uint256 i = 0; i < targetLength; ++i) {
139             if (_targets[i] != addrZero) {
140                 recommendRelation[_targets[i]] = _recommenders[i];
141                 RecommenderChange(_targets[i], _recommenders[i]);
142             }
143         }
144     }
145 
146     function getRecommender(address _target) external view returns(address) {
147         return recommendRelation[_target];
148     }
149 
150     function addFreeMineral(address _target, uint32 _cnt)  
151         external
152         onlyService
153     {
154         require(_target != address(0));
155         require(_cnt <= 32);
156         uint32 oldCnt = freeMineral[_target];
157         freeMineral[_target] = oldCnt + _cnt;
158         FreeMineralChange(_target, freeMineral[_target]);
159     }
160 
161     function addFreeMineralMulti(address[] _targets, uint32[] _cnts)
162         external
163         onlyService
164     {
165         uint256 targetLength = _targets.length;
166         require(targetLength <= 64);
167         require(targetLength == _cnts.length);
168         address addrZero = address(0);
169         uint32 oldCnt;
170         uint32 newCnt;
171         address addr;
172         for (uint256 i = 0; i < targetLength; ++i) {
173             addr = _targets[i];
174             if (addr != addrZero && _cnts[i] <= 32) {
175                 oldCnt = freeMineral[addr];
176                 newCnt = oldCnt + _cnts[i];
177                 assert(oldCnt < newCnt);
178                 freeMineral[addr] = newCnt;
179                 FreeMineralChange(addr, freeMineral[addr]);
180             }
181         }
182     }
183 
184     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
185         actionContracts[_actionAddr] = _useful;
186     }
187 
188     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
189         return actionContracts[_actionAddr];
190     }
191 
192     function subFreeMineral(address _target) external returns(bool) {
193         require(actionContracts[msg.sender]);
194         require(_target != address(0));
195         uint32 cnts = freeMineral[_target];
196         assert(cnts > 0);
197         freeMineral[_target] = cnts - 1;
198         FreeMineralChange(_target, cnts - 1);
199         return true;
200     }
201 
202     function getFreeMineral(address _target) external view returns(uint32) {
203         return freeMineral[_target];
204     }
205 }