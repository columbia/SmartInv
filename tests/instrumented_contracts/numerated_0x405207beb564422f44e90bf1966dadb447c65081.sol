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
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 contract AccessService is AccessAdmin {
54     address public addrService;
55     address public addrFinance;
56 
57     modifier onlyService() {
58         require(msg.sender == addrService);
59         _;
60     }
61 
62     modifier onlyFinance() {
63         require(msg.sender == addrFinance);
64         _;
65     }
66 
67     function setService(address _newService) external {
68         require(msg.sender == addrService || msg.sender == addrAdmin);
69         require(_newService != address(0));
70         addrService = _newService;
71     }
72 
73     function setFinance(address _newFinance) external {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_newFinance != address(0));
76         addrFinance = _newFinance;
77     }
78 
79     function withdraw(address _target, uint256 _amount) 
80         external 
81     {
82         require(msg.sender == addrFinance || msg.sender == addrAdmin);
83         require(_amount > 0);
84         address receiver = _target == address(0) ? addrFinance : _target;
85         uint256 balance = this.balance;
86         if (_amount < balance) {
87             receiver.transfer(_amount);
88         } else {
89             receiver.transfer(this.balance);
90         }      
91     }
92 }
93 
94 interface IDataMining {
95     function getRecommender(address _target) external view returns(address);
96     function subFreeMineral(address _target) external returns(bool);
97 }
98 
99 interface IDataEquip {
100     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
101     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
102     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
103 }
104 
105 interface IDataAuction {
106     function isOnSale(uint256 _tokenId) external view returns(bool);
107     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
108     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
109 }
110 
111 contract DataAuction is IDataAuction, AccessAdmin {
112     IDataAuction public ethAuction;
113     IDataAuction public platAuction;
114 
115     function DataAuction(address _ethAddr, address _platAddr) public {
116         ethAuction = IDataAuction(_ethAddr);
117         platAuction = IDataAuction(_platAddr);
118     }
119 
120     function setEthAuction(address _ethAddr) external onlyAdmin {
121         ethAuction = IDataAuction(_ethAddr);
122     }
123 
124     function setPlatAuction(address _platAddr) external onlyAdmin {
125         platAuction = IDataAuction(_platAddr);
126     }
127 
128     function isOnSale(uint256 _tokenId) external view returns(bool) {
129         if (address(ethAuction) != address(0) && ethAuction.isOnSale(_tokenId)) {
130             return true;   
131         }
132         if (address(platAuction) != address(0) && platAuction.isOnSale(_tokenId)) {
133             return true;   
134         }
135     }
136 
137     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool) {
138         if (address(ethAuction) != address(0) && ethAuction.isOnSaleAny2(_tokenId1, _tokenId2)) {
139             return true;   
140         }
141         if (address(platAuction) != address(0) && platAuction.isOnSaleAny2(_tokenId1, _tokenId2)) {
142             return true;   
143         }
144         return false;
145     }
146 
147     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool) {
148         if (address(ethAuction) != address(0) && ethAuction.isOnSaleAny3(_tokenId1, _tokenId2, _tokenId3)) {
149             return true;   
150         }
151         if (address(platAuction) != address(0) && platAuction.isOnSaleAny3(_tokenId1, _tokenId2, _tokenId3)) {
152             return true;   
153         }
154         return false;
155     }
156 }