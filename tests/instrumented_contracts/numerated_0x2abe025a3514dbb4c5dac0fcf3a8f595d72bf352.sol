1 pragma solidity ^0.4.19;
2 
3 contract BdpBaseData {
4 
5 	address public ownerAddress;
6 
7 	address public managerAddress;
8 
9 	address[16] public contracts;
10 
11 	bool public paused = false;
12 
13 	bool public setupComplete = false;
14 
15 	bytes8 public version;
16 
17 }
18 library BdpContracts {
19 
20 	function getBdpEntryPoint(address[16] _contracts) pure internal returns (address) {
21 		return _contracts[0];
22 	}
23 
24 	function getBdpController(address[16] _contracts) pure internal returns (address) {
25 		return _contracts[1];
26 	}
27 
28 	function getBdpControllerHelper(address[16] _contracts) pure internal returns (address) {
29 		return _contracts[3];
30 	}
31 
32 	function getBdpDataStorage(address[16] _contracts) pure internal returns (address) {
33 		return _contracts[4];
34 	}
35 
36 	function getBdpImageStorage(address[16] _contracts) pure internal returns (address) {
37 		return _contracts[5];
38 	}
39 
40 	function getBdpOwnershipStorage(address[16] _contracts) pure internal returns (address) {
41 		return _contracts[6];
42 	}
43 
44 	function getBdpPriceStorage(address[16] _contracts) pure internal returns (address) {
45 		return _contracts[7];
46 	}
47 
48 }
49 
50 contract BdpBase is BdpBaseData {
51 
52 	modifier onlyOwner() {
53 		require(msg.sender == ownerAddress);
54 		_;
55 	}
56 
57 	modifier onlyAuthorized() {
58 		require(msg.sender == ownerAddress || msg.sender == managerAddress);
59 		_;
60 	}
61 
62 	modifier whenContractActive() {
63 		require(!paused && setupComplete);
64 		_;
65 	}
66 
67 	modifier storageAccessControl() {
68 		require(
69 			(! setupComplete && (msg.sender == ownerAddress || msg.sender == managerAddress))
70 			|| (setupComplete && !paused && (msg.sender == BdpContracts.getBdpEntryPoint(contracts)))
71 		);
72 		_;
73 	}
74 
75 	function setOwner(address _newOwner) external onlyOwner {
76 		require(_newOwner != address(0));
77 		ownerAddress = _newOwner;
78 	}
79 
80 	function setManager(address _newManager) external onlyOwner {
81 		require(_newManager != address(0));
82 		managerAddress = _newManager;
83 	}
84 
85 	function setContracts(address[16] _contracts) external onlyOwner {
86 		contracts = _contracts;
87 	}
88 
89 	function pause() external onlyAuthorized {
90 		paused = true;
91 	}
92 
93 	function unpause() external onlyOwner {
94 		paused = false;
95 	}
96 
97 	function setSetupComplete() external onlyOwner {
98 		setupComplete = true;
99 	}
100 
101 	function kill() public onlyOwner {
102 		selfdestruct(ownerAddress);
103 	}
104 
105 }
106 
107 contract BdpPriceStorage is BdpBase {
108 
109 	uint64[1001] public pricePoints;
110 
111 	uint256 public pricePointsLength = 0;
112 
113 	address public forwardPurchaseFeesTo = address(0);
114 
115 	address public forwardUpdateFeesTo = address(0);
116 
117 
118 	function getPricePointsLength() view public returns (uint256) {
119 		return pricePointsLength;
120 	}
121 
122 	function getPricePoint(uint256 _i) view public returns (uint256) {
123 		return pricePoints[_i];
124 	}
125 
126 	function setPricePoints(uint64[] _pricePoints) public storageAccessControl {
127 		pricePointsLength = 0;
128 		appendPricePoints(_pricePoints);
129 	}
130 
131 	function appendPricePoints(uint64[] _pricePoints) public storageAccessControl {
132 		for (uint i = 0; i < _pricePoints.length; i++) {
133 			pricePoints[pricePointsLength++] = _pricePoints[i];
134 		}
135 	}
136 
137 	function getForwardPurchaseFeesTo() view public returns (address) {
138 		return forwardPurchaseFeesTo;
139 	}
140 
141 	function setForwardPurchaseFeesTo(address _forwardPurchaseFeesTo) public storageAccessControl {
142 		forwardPurchaseFeesTo = _forwardPurchaseFeesTo;
143 	}
144 
145 	function getForwardUpdateFeesTo() view public returns (address) {
146 		return forwardUpdateFeesTo;
147 	}
148 
149 	function setForwardUpdateFeesTo(address _forwardUpdateFeesTo) public storageAccessControl {
150 		forwardUpdateFeesTo = _forwardUpdateFeesTo;
151 	}
152 
153 	function BdpPriceStorage(bytes8 _version) public {
154 		ownerAddress = msg.sender;
155 		managerAddress = msg.sender;
156 		version = _version;
157 	}
158 
159 }