1 pragma solidity ^0.5.13;
2 
3 interface RNGOracle {
4 	function createSeries(uint256[] calldata _newSeries) external returns (uint256 seriesIndex);
5 	function seriesRequest(uint256 _seriesIndex, uint256 _runs, bytes32 _seed, uint256 _callbackGasLimit) external returns (bytes32 queryId);
6 	function getSeries(uint256 _seriesIndex) external view returns (uint256 sum, uint256 maxRuns, uint256[] memory values, uint256[] memory cumulativeSum, uint256[] memory resolutions);
7 	function queryWallet(address _user) external view returns (uint256);
8 }
9 
10 interface DDN {
11 	function transfer(address _to, uint256 _tokens) external returns (bool);
12 	function balanceOf(address _user) external view returns (uint256);
13 	function dividendsOf(address _user) external view returns (uint256);
14 	function buy() external payable returns (uint256);
15 	function reinvest() external returns (uint256);
16 }
17 
18 contract Pooling {
19 
20 	uint256 constant private FLOAT_SCALAR = 2**64;
21 
22 	struct User {
23 		uint256 shares;
24 		int256 scaledPayout;
25 		bytes32 seed;
26 	}
27 
28 	struct BetInfo {
29 		address user;
30 		uint256 betAmount;
31 	}
32 
33 	struct Info {
34 		uint256 seriesIndex;
35 		uint256 totalShares;
36 		uint256 scaledCumulativeDDN;
37 		mapping(address => User) users;
38 		mapping(bytes32 => BetInfo) betInfo;
39 		RNGOracle oracle;
40 		DDN ddn;
41 	}
42 	Info private info;
43 
44 
45 	event BetPlaced(address indexed user, bytes32 queryId);
46 	event BetResolved(address indexed user, bytes32 indexed queryId, uint256 betAmount, uint256 shares);
47 	event BetFailed(address indexed user, bytes32 indexed queryId, uint256 betAmount);
48 	event Withdraw(address indexed user, uint256 amount);
49 
50 
51 	constructor(address _oracleAddress, address _DDN_address) public {
52 		info.oracle = RNGOracle(_oracleAddress);
53 		info.ddn = DDN(_DDN_address);
54 		uint256[] memory _chances = new uint256[](10);
55 		_chances[0] = 1;
56 		_chances[1] = 2;
57 		_chances[2] = 3;
58 		_chances[3] = 5;
59 		_chances[4] = 7;
60 		_chances[5] = 11;
61 		_chances[6] = 13;
62 		_chances[7] = 17;
63 		_chances[8] = 19;
64 		_chances[9] = 23;
65 		info.seriesIndex = info.oracle.createSeries(_chances);
66 	}
67 
68 	function pool() external payable {
69 		require(msg.value > 0);
70 		reinvestPool();
71 		_placeBet(msg.sender, info.ddn.buy.value(msg.value)());
72 	}
73 
74 	function tokenCallback(address _from, uint256 _tokens, bytes calldata) external returns (bool) {
75 		require(msg.sender == address(info.ddn));
76 		require(_tokens > 0);
77 		reinvestPool();
78 		_placeBet(_from, _tokens);
79 		return true;
80 	}
81 
82 	function withdraw() external returns (uint256) {
83 		uint256 _dividends = dividendsOf(msg.sender);
84 		require(_dividends >= 0);
85 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
86 		info.ddn.transfer(msg.sender, _dividends);
87 		emit Withdraw(msg.sender, _dividends);
88 		return _dividends;
89 	}
90 
91 	function setSeed(bytes32 _seed) public {
92 		info.users[msg.sender].seed = _seed;
93 	}
94 
95 	function reinvestPool() public {
96 		if (info.ddn.dividendsOf(address(this)) > 0) {
97 			info.scaledCumulativeDDN += info.ddn.reinvest() * FLOAT_SCALAR / info.totalShares;
98 		}
99 	}
100 
101 	function seriesCallback(bytes32 _queryId, uint256 _resolution, uint256[] calldata) external {
102 		require(msg.sender == address(info.oracle));
103 		BetInfo memory _betInfo = info.betInfo[_queryId];
104 		uint256 _shares = _betInfo.betAmount * _resolution / FLOAT_SCALAR;
105 		info.totalShares += _shares;
106 		info.users[_betInfo.user].shares += _shares;
107 		info.users[_betInfo.user].scaledPayout += int256(info.scaledCumulativeDDN * _shares);
108 		info.scaledCumulativeDDN += _betInfo.betAmount * FLOAT_SCALAR / info.totalShares / 2;
109 		emit BetResolved(_betInfo.user, _queryId, _betInfo.betAmount, _shares);
110 	}
111 
112 	function queryFailed(bytes32 _queryId) external {
113 		require(msg.sender == address(info.oracle));
114 		BetInfo memory _betInfo = info.betInfo[_queryId];
115 		info.ddn.transfer(_betInfo.user, _betInfo.betAmount);
116 		emit BetFailed(_betInfo.user, _queryId, _betInfo.betAmount);
117 	}
118 
119 
120 	function pooledDDN() public view returns (uint256) {
121 		return info.ddn.balanceOf(address(this));
122 	}
123 
124 	function totalShares() public view returns (uint256) {
125 		return info.totalShares;
126 	}
127 
128 	function sharesOf(address _user) public view returns (uint256) {
129 		return info.users[_user].shares;
130 	}
131 
132 	function dividendsOf(address _user) public view returns (uint256) {
133 		return uint256(int256(info.scaledCumulativeDDN * sharesOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
134 	}
135 
136 	function allInfoFor(address _user) public view returns (uint256 totalPooled, uint256 totalPoolShares, uint256 userQueryWallet, uint256 userBalance, uint256 userShares, uint256 userDividends) {
137 		return (pooledDDN(), totalShares(), info.oracle.queryWallet(_user), info.ddn.balanceOf(_user), sharesOf(_user), dividendsOf(_user));
138 	}
139 
140 	function getPayouts() public view returns (uint256 sum, uint256[] memory chances, uint256[] memory cumulativeSum, uint256[] memory scaledPayouts) {
141 		(sum, , chances, cumulativeSum, scaledPayouts) = info.oracle.getSeries(info.seriesIndex);
142 		for (uint256 i = 0; i < scaledPayouts.length; i++) {
143 			scaledPayouts[i] = 1e18 * scaledPayouts[i] / FLOAT_SCALAR;
144 		}
145 	}
146 
147 
148 	function _placeBet(address _user, uint256 _betAmount) internal {
149 		bytes32 _queryId = info.oracle.seriesRequest(info.seriesIndex, 1, info.users[_user].seed, info.users[_user].shares == 0 ? 300000 : 200000);
150 		BetInfo memory _betInfo = BetInfo({
151 			user: _user,
152 			betAmount: _betAmount
153 		});
154 		info.betInfo[_queryId] = _betInfo;
155 		emit BetPlaced(_user, _queryId);
156 	}
157 }