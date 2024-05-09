1 pragma solidity ^0.4.19;
2 
3 // File: contracts/BdpBaseData.sol
4 
5 contract BdpBaseData {
6 
7 	address public ownerAddress;
8 
9 	address public managerAddress;
10 
11 	address[16] public contracts;
12 
13 	bool public paused = false;
14 
15 	bool public setupCompleted = false;
16 
17 	bytes8 public version;
18 
19 }
20 
21 // File: contracts/libraries/BdpContracts.sol
22 
23 library BdpContracts {
24 
25 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
26 		return _contracts[0];
27 	}
28 
29 	function getBdpController(address[16] _contracts) pure internal returns (address) {
30 		return _contracts[1];
31 	}
32 
33 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
34 		return _contracts[3];
35 	}
36 
37 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
38 		return _contracts[4];
39 	}
40 
41 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
42 		return _contracts[5];
43 	}
44 
45 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
46 		return _contracts[6];
47 	}
48 
49 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
50 		return _contracts[7];
51 	}
52 
53 }
54 
55 // File: contracts/BdpBase.sol
56 
57 contract BdpBase is BdpBaseData {
58 
59 	modifier onlyOwner() {
60 		require(msg.sender == ownerAddress);
61 		_;
62 	}
63 
64 	modifier onlyAuthorized() {
65 		require(msg.sender == ownerAddress || msg.sender == managerAddress);
66 		_;
67 	}
68 
69 	modifier whileContractIsActive() {
70 		require(!paused && setupCompleted);
71 		_;
72 	}
73 
74 	modifier storageAccessControl() {
75 		require(
76 			(! setupCompleted && (msg.sender == ownerAddress || msg.sender == managerAddress))
77 			|| (setupCompleted && !paused && (msg.sender == BdpContracts.getBdpEntryPoint(contracts)))
78 		);
79 		_;
80 	}
81 
82 	function setOwner(address _newOwner) external onlyOwner {
83 		require(_newOwner != address(0));
84 		ownerAddress = _newOwner;
85 	}
86 
87 	function setManager(address _newManager) external onlyOwner {
88 		require(_newManager != address(0));
89 		managerAddress = _newManager;
90 	}
91 
92 	function setContracts(address[16] _contracts) external onlyOwner {
93 		contracts = _contracts;
94 	}
95 
96 	function pause() external onlyAuthorized {
97 		paused = true;
98 	}
99 
100 	function unpause() external onlyOwner {
101 		paused = false;
102 	}
103 
104 	function setSetupCompleted() external onlyOwner {
105 		setupCompleted = true;
106 	}
107 
108 	function kill() public onlyOwner {
109 		selfdestruct(ownerAddress);
110 	}
111 
112 }
113 
114 // File: contracts/storage/BdpPriceStorage.sol
115 
116 contract BdpPriceStorage is BdpBase {
117 
118 	uint64[1001] public pricePoints;
119 
120 	uint256 public pricePointsLength = 0;
121 
122 	address public forwardPurchaseFeesTo = address(0);
123 
124 	address public forwardUpdateFeesTo = address(0);
125 
126 
127 	function getPricePointsLength() view public returns (uint256) {
128 		return pricePointsLength;
129 	}
130 
131 	function getPricePoint(uint256 _i) view public returns (uint256) {
132 		return pricePoints[_i];
133 	}
134 
135 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
136 		pricePointsLength = 0;
137 		appendPricePoints(_pricePoints);
138 	}
139 
140 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
141 		for (uint i = 0; i < _pricePoints.length; i++) {
142 			pricePoints[pricePointsLength++] = _pricePoints[i];
143 		}
144 	}
145 
146 	function getForwardPurchaseFeesTo() view public returns (address) {
147 		return forwardPurchaseFeesTo;
148 	}
149 
150 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
151 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
152 	}
153 
154 	function getForwardUpdateFeesTo() view public returns (address) {
155 		return forwardUpdateFeesTo;
156 	}
157 
158 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
159 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
160 	}
161 
162 	function BdpPriceStorage(bytes8 _version) public {
163 		ownerAddress = msg.sender;
164 		managerAddress = msg.sender;
165 		version = _version;
166 	}
167 
168 }