1 /* ==================================================================== */
2 /* Copyright (c) 2018 The CryptoRacing Project.  All rights reserved.
3 /* 
4 /*   The first idle car race game of blockchain                 
5 /* ==================================================================== */
6 
7 pragma solidity ^0.4.20;
8 
9 contract AccessAdmin {
10     bool public isPaused = false;
11     address public addrAdmin;  
12 
13     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
14 
15     constructor() public {
16         addrAdmin = msg.sender;
17     }  
18 
19     modifier onlyAdmin() {
20         require(msg.sender == addrAdmin);
21         _;
22     }
23 
24     modifier whenNotPaused() {
25         require(!isPaused);
26         _;
27     }
28 
29     modifier whenPaused {
30         require(isPaused);
31         _;
32     }
33 
34     function setAdmin(address _newAdmin) external onlyAdmin {
35         require(_newAdmin != address(0));
36         emit AdminTransferred(addrAdmin, _newAdmin);
37         addrAdmin = _newAdmin;
38     }
39 
40     function doPause() external onlyAdmin whenNotPaused {
41         isPaused = true;
42     }
43 
44     function doUnpause() external onlyAdmin whenPaused {
45         isPaused = false;
46     }
47 }
48 
49 contract AccessService is AccessAdmin {
50     address public addrService;
51     address public addrFinance;
52 
53     modifier onlyService() {
54         require(msg.sender == addrService);
55         _;
56     }
57 
58     modifier onlyFinance() {
59         require(msg.sender == addrFinance);
60         _;
61     }
62 
63     function setService(address _newService) external {
64         require(msg.sender == addrService || msg.sender == addrAdmin);
65         require(_newService != address(0));
66         addrService = _newService;
67     }
68 
69     function setFinance(address _newFinance) external {
70         require(msg.sender == addrFinance || msg.sender == addrAdmin);
71         require(_newFinance != address(0));
72         addrFinance = _newFinance;
73     }
74 
75     function withdraw(address _target, uint256 _amount) 
76         external 
77     {
78         require(msg.sender == addrFinance || msg.sender == addrAdmin);
79         require(_amount > 0);
80         address receiver = _target == address(0) ? addrFinance : _target;
81         uint256 balance = this.balance;
82         if (_amount < balance) {
83             receiver.transfer(_amount);
84         } else {
85             receiver.transfer(this.balance);
86         }      
87     }
88 }
89 
90 interface IDataMining {
91     function subFreeMineral(address _target) external returns(bool);
92 }
93 
94 interface IDataEquip {
95     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
96     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
97     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
98 }
99 
100 contract DataMiningController is AccessService, IDataMining {
101     event FreeMineralChange(address indexed _target, uint32 _accCnt);
102 
103 
104     /// @dev Free mining count map
105     mapping (address => uint32) freeMineral;
106     /// @dev Trust contract
107     mapping (address => bool) actionContracts;
108 
109     constructor() public {
110         addrAdmin = msg.sender;
111         addrService = msg.sender;
112         addrFinance = msg.sender;
113     }
114 
115    
116     function addFreeMineral(address _target, uint32 _cnt)  
117         external
118         onlyService
119     {
120         require(_target != address(0));
121         require(_cnt <= 32);
122         uint32 oldCnt = freeMineral[_target];
123         freeMineral[_target] = oldCnt + _cnt;
124         emit FreeMineralChange(_target, freeMineral[_target]);
125     }
126 
127     function addFreeMineralMulti(address[] _targets, uint32[] _cnts)
128         external
129         onlyService
130     {
131         uint256 targetLength = _targets.length;
132         require(targetLength <= 64);
133         require(targetLength == _cnts.length);
134         address addrZero = address(0);
135         uint32 oldCnt;
136         uint32 newCnt;
137         address addr;
138         for (uint256 i = 0; i < targetLength; ++i) {
139             addr = _targets[i];
140             if (addr != addrZero && _cnts[i] <= 32) {
141                 oldCnt = freeMineral[addr];
142                 newCnt = oldCnt + _cnts[i];
143                 assert(oldCnt < newCnt);
144                 freeMineral[addr] = newCnt;
145                 emit FreeMineralChange(addr, freeMineral[addr]);
146             }
147         }
148     }
149 
150     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
151         actionContracts[_actionAddr] = _useful;
152     }
153 
154     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
155         return actionContracts[_actionAddr];
156     }
157 
158     function subFreeMineral(address _target) external returns(bool) {
159         require(actionContracts[msg.sender]);
160         require(_target != address(0));
161         uint32 cnts = freeMineral[_target];
162         assert(cnts > 0);
163         freeMineral[_target] = cnts - 1;
164         emit FreeMineralChange(_target, cnts - 1);
165         return true;
166     }
167 
168     function getFreeMineral(address _target) external view returns(uint32) {
169         return freeMineral[_target];
170     }
171 }