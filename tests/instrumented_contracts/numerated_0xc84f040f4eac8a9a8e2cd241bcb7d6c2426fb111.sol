1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 interface ERC20 {
5 	function allowance(address, address) external view returns (uint256);
6 	function balanceOf(address) external view returns (uint256);
7 	function transfer(address, uint256) external returns (bool);
8 	function transferFrom(address, address, uint256) external returns (bool);
9 }
10 
11 contract LastRetardWins {
12 
13 	ERC20 constant public USDC = ERC20(0x9abC68B33961268A3Ea4116214d7039226de01E1);
14 
15 	uint256 constant private FLOAT_SCALAR = 2**64;
16 	uint256 constant private MAX_TIME = 24 hours;
17 	uint256 constant private INCREASE_PER_SHARE = 30 seconds;
18 	uint256 constant private INITIAL_PRICE = 1e23; // 100k
19 	uint256 constant private INCREMENT = 1e20; // 100
20 
21 	struct RoundPlayer {
22 		uint256 shares;
23 		int256 scaledPayout;
24 	}
25 
26 	struct Round {
27 		uint256 targetTimestamp;
28 		uint256 jackpotValue;
29 		uint256 totalShares;
30 		uint256 scaledCumulativeRewards;
31 		mapping(address => RoundPlayer) roundPlayers;
32 		address lastPlayer;
33 	}
34 
35 	struct Info {
36 		uint256 totalRounds;
37 		mapping(uint256 => Round) rounds;
38 	}
39 	Info private info;
40 
41 
42 	event BuyShares(address indexed player, uint256 indexed round, uint256 amount, uint256 cost);
43 	event RoundStarted(uint256 indexed round);
44 	event RoundEnded(uint256 indexed round, uint256 endTime, uint256 jackpotValue, uint256 totalShares, address lastPlayer);
45 	event Withdraw(address indexed player, uint256 indexed round, uint256 amount);
46 
47 
48 	modifier _checkRound {
49 		uint256 _round = currentRoundIndex();
50 		uint256 _target = roundTargetTimestamp(_round);
51 		if (_target <= block.timestamp) {
52 			uint256 _shares = roundTotalShares(_round);
53 			uint256 _jackpot = roundJackpotValue(_round);
54 			if (_shares > 0) {
55 				info.rounds[_round].scaledCumulativeRewards += _jackpot * FLOAT_SCALAR / _shares;
56 			}
57 			emit RoundEnded(_round, _target, _jackpot, _shares, roundLastPlayer(_round));
58 			_newRound();
59 		}
60 		_;
61 	}
62 
63 
64 	constructor() {
65 		_newRound();
66 	}
67 
68 	function buyShares(uint256 _amount, uint256 _maxSpend) external _checkRound {
69 		require(_amount > 0);
70 		uint256 _cost = currentRoundCalculateCost(_amount);
71 		require(_cost <= _maxSpend);
72 		USDC.transferFrom(msg.sender, address(this), _cost);
73 		Round storage _currentRound = info.rounds[currentRoundIndex()];
74 		_currentRound.totalShares += _amount;
75 		_currentRound.roundPlayers[msg.sender].shares += _amount;
76 		_currentRound.roundPlayers[msg.sender].scaledPayout += int256(_amount * _currentRound.scaledCumulativeRewards);
77 		_currentRound.lastPlayer = msg.sender;
78 		uint256 _newTarget = _currentRound.targetTimestamp + _amount * INCREASE_PER_SHARE;
79 		_currentRound.targetTimestamp = _newTarget < block.timestamp + MAX_TIME ? _newTarget : block.timestamp + MAX_TIME;
80 		_currentRound.jackpotValue += 2 * _cost / 3;
81 		_currentRound.scaledCumulativeRewards += _cost * FLOAT_SCALAR / _currentRound.totalShares / 3;
82 		emit BuyShares(msg.sender, currentRoundIndex(), _amount, _cost);
83 	}
84 
85 	function donateToJackpot(uint256 _amount) external _checkRound {
86 		require(_amount > 0);
87 		USDC.transferFrom(msg.sender, address(this), _amount);
88 		info.rounds[currentRoundIndex()].jackpotValue += _amount;
89 	}
90 
91 	function withdrawRound(uint256 _round) public returns (uint256) {
92 		uint256 _withdrawable = roundRewardsOf(msg.sender, _round);
93 		if (_withdrawable > 0) {
94 			info.rounds[_round].roundPlayers[msg.sender].scaledPayout += int256(_withdrawable * FLOAT_SCALAR);
95 		}
96 		if (_round != currentRoundIndex() && roundLastPlayer(_round) == msg.sender) {
97 			_withdrawable += roundJackpotValue(_round);
98 			info.rounds[_round].lastPlayer = address(0x0);
99 		}
100 		if (_withdrawable > 0) {
101 			USDC.transfer(msg.sender, _withdrawable);
102 			emit Withdraw(msg.sender, _round, _withdrawable);
103 		}
104 		return _withdrawable;
105 	}
106 
107 	function withdrawCurrent() external returns (uint256) {
108 		return withdrawRound(currentRoundIndex());
109 	}
110 
111 	function withdrawAll() external _checkRound returns (uint256) {
112 		uint256 _withdrawn = 0;
113 		for (uint256 i = 0; i < info.totalRounds; i++) {
114 			_withdrawn += withdrawRound(i);
115 		}
116 		return _withdrawn;
117 	}
118 
119 
120 	function currentRoundIndex() public view returns (uint256) {
121 		return info.totalRounds - 1;
122 	}
123 
124 	function roundTargetTimestamp(uint256 _round) public view returns (uint256) {
125 		return info.rounds[_round].targetTimestamp;
126 	}
127 
128 	function roundJackpotValue(uint256 _round) public view returns (uint256) {
129 		return info.rounds[_round].jackpotValue / 2;
130 	}
131 
132 	function roundTotalShares(uint256 _round) public view returns (uint256) {
133 		return info.rounds[_round].totalShares;
134 	}
135 
136 	function roundLastPlayer(uint256 _round) public view returns (address) {
137 		return info.rounds[_round].lastPlayer;
138 	}
139 
140 	function roundSharesOf(address _player, uint256 _round) public view returns (uint256) {
141 		return info.rounds[_round].roundPlayers[_player].shares;
142 	}
143 
144 	function roundCurrentPrice(uint256 _round) public view returns (uint256) {
145 		return INITIAL_PRICE + INCREMENT * roundTotalShares(_round);
146 	}
147 
148 	function roundCalculateCost(uint256 _amount, uint256 _round) public view returns (uint256) {
149 		return roundCurrentPrice(_round) * _amount + INCREMENT * _amount * (_amount + 1) / 2;
150 	}
151 
152 	function currentRoundCalculateCost(uint256 _amount) public view returns (uint256) {
153 		return roundCalculateCost(_amount, currentRoundIndex());
154 	}
155 
156 	function roundRewardsOf(address _player, uint256 _round) public view returns (uint256) {
157 		return uint256(int256(info.rounds[_round].scaledCumulativeRewards * roundSharesOf(_player, _round)) - info.rounds[_round].roundPlayers[_player].scaledPayout) / FLOAT_SCALAR;
158 	}
159 
160 	function roundWithdrawableOf(address _player, uint256 _round) public view returns (uint256) {
161 		uint256 _withdrawable = roundRewardsOf(_player, _round);
162 		if (_round != currentRoundIndex() && roundLastPlayer(_round) == _player) {
163 			_withdrawable += roundJackpotValue(_round);
164 		}
165 		return _withdrawable;
166 	}
167 
168 	function allWithdrawableOf(address _player) public view returns (uint256) {
169 		uint256 _withdrawable = 0;
170 		for (uint256 i = 0; i < info.totalRounds; i++) {
171 			_withdrawable += roundWithdrawableOf(_player, i);
172 		}
173 		return _withdrawable;
174 	}
175 
176 	function allRoundInfoFor(address _player, uint256 _round) public view returns (uint256[4] memory compressedRoundInfo, address roundLast, uint256 playerBalance, uint256 playerAllowance, uint256[3] memory compressedPlayerRoundInfo) {
177 		return (_compressedRoundInfo(_round), roundLastPlayer(_round), USDC.balanceOf(_player), USDC.allowance(_player, address(this)), _compressedPlayerRoundInfo(_player, _round));
178 	}
179 
180 	function allCurrentInfoFor(address _player) public view returns (uint256[4] memory compressedInfo, address lastPlayer, uint256 playerBalance, uint256 playerAllowance, uint256[3] memory compressedPlayerRoundInfo, uint256 round) {
181 		round = currentRoundIndex();
182 		(compressedInfo, lastPlayer, playerBalance, playerAllowance, compressedPlayerRoundInfo) = allRoundInfoFor(_player, round);
183 	}
184 
185 
186 	function _newRound() internal {
187 		Round storage _round = info.rounds[info.totalRounds++];
188 		_round.targetTimestamp = block.timestamp + MAX_TIME;
189 		emit RoundStarted(currentRoundIndex());
190 	}
191 
192 
193 	function _compressedRoundInfo(uint256 _round) internal view returns (uint256[4] memory data) {
194 		data[0] = block.number;
195 		data[1] = roundTargetTimestamp(_round);
196 		data[2] = roundJackpotValue(_round);
197 		data[3] = roundTotalShares(_round);
198 	}
199 
200 	function _compressedPlayerRoundInfo(address _player, uint256 _round) internal view returns (uint256[3] memory data) {
201 		data[0] = roundSharesOf(_player, _round);
202 		data[1] = roundWithdrawableOf(_player, _round);
203 		data[2] = allWithdrawableOf(_player);
204 	}
205 }