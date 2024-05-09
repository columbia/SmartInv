1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 library Math {
5     function max(uint a, uint b) internal pure returns (uint) {
6         return a >= b ? a : b;
7     }
8     function min(uint a, uint b) internal pure returns (uint) {
9         return a < b ? a : b;
10     }
11 }
12 
13 interface erc20 {
14     function totalSupply() external view returns (uint256);
15     function transfer(address recipient, uint amount) external returns (bool);
16     function decimals() external view returns (uint8);
17     function balanceOf(address) external view returns (uint);
18     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
19     function approve(address spender, uint value) external returns (bool);
20 }
21 
22 interface ve {
23     function locked__end(address) external view returns (uint);
24     function deposit_for(address, uint) external;
25 }
26 
27 interface delegate {
28     function get_adjusted_ve_balance(address, address) external view returns (uint);
29 }
30 
31 interface Gauge {
32     function deposit_reward_token(address, uint) external;
33 }
34 
35 contract GaugeProxy {
36     address constant _rkp3r = 0xEdB67Ee1B171c4eC66E6c10EC43EDBbA20FaE8e9;
37     address constant _vkp3r = 0x2FC52C61fB0C03489649311989CE2689D93dC1a2;
38     address constant ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;
39 
40     uint public totalWeight;
41 
42     address public gov;
43     address public nextgov;
44     uint public commitgov;
45     uint public constant delay = 1 days;
46 
47     address[] internal _tokens;
48     mapping(address => address) public gauges; // token => gauge
49     mapping(address => uint) public weights; // token => weight
50     mapping(address => mapping(address => uint)) public votes; // msg.sender => votes
51     mapping(address => address[]) public tokenVote;// msg.sender => token
52     mapping(address => uint) public usedWeights;  // msg.sender => total voting weight of user
53     mapping(address => bool) public enabled;
54 
55     function tokens() external view returns (address[] memory) {
56         return _tokens;
57     }
58 
59     constructor() {
60         gov = msg.sender;
61     }
62 
63     modifier g() {
64         require(msg.sender == gov);
65         _;
66     }
67 
68     function setGov(address _gov) external g {
69         nextgov = _gov;
70         commitgov = block.timestamp + delay;
71     }
72 
73     function acceptGov() external {
74         require(msg.sender == nextgov && commitgov < block.timestamp);
75         gov = nextgov;
76     }
77 
78     function reset() external {
79         _reset(msg.sender);
80     }
81 
82     function _reset(address _owner) internal {
83         address[] storage _tokenVote = tokenVote[_owner];
84         uint _tokenVoteCnt = _tokenVote.length;
85 
86         for (uint i = 0; i < _tokenVoteCnt; i ++) {
87             address _token = _tokenVote[i];
88             uint _votes = votes[_owner][_token];
89 
90             if (_votes > 0) {
91                 totalWeight -= _votes;
92                 weights[_token] -= _votes;
93                 votes[_owner][_token] = 0;
94             }
95         }
96 
97         delete tokenVote[_owner];
98     }
99 
100     function poke(address _owner) public {
101         address[] memory _tokenVote = tokenVote[_owner];
102         uint _tokenCnt = _tokenVote.length;
103         uint[] memory _weights = new uint[](_tokenCnt);
104 
105         uint _prevUsedWeight = usedWeights[_owner];
106         uint _weight = delegate(_vkp3r).get_adjusted_ve_balance(_owner, ZERO_ADDRESS);
107 
108         for (uint i = 0; i < _tokenCnt; i ++) {
109             uint _prevWeight = votes[_owner][_tokenVote[i]];
110             _weights[i] = _prevWeight * _weight / _prevUsedWeight;
111         }
112 
113         _vote(_owner, _tokenVote, _weights);
114     }
115 
116     function _vote(address _owner, address[] memory _tokenVote, uint[] memory _weights) internal {
117         // _weights[i] = percentage * 100
118         _reset(_owner);
119         uint _tokenCnt = _tokenVote.length;
120         uint _weight = delegate(_vkp3r).get_adjusted_ve_balance(_owner, ZERO_ADDRESS);
121         uint _totalVoteWeight = 0;
122         uint _usedWeight = 0;
123 
124         for (uint i = 0; i < _tokenCnt; i ++) {
125             _totalVoteWeight += _weights[i];
126         }
127 
128         for (uint i = 0; i < _tokenCnt; i ++) {
129             address _token = _tokenVote[i];
130             address _gauge = gauges[_token];
131             uint _tokenWeight = _weights[i] * _weight / _totalVoteWeight;
132 
133             if (_gauge != address(0x0)) {
134                 _usedWeight += _tokenWeight;
135                 totalWeight += _tokenWeight;
136                 weights[_token] += _tokenWeight;
137                 tokenVote[_owner].push(_token);
138                 votes[_owner][_token] = _tokenWeight;
139             }
140         }
141 
142         usedWeights[_owner] = _usedWeight;
143     }
144 
145     function vote(address[] calldata _tokenVote, uint[] calldata _weights) external {
146         require(_tokenVote.length == _weights.length);
147         _vote(msg.sender, _tokenVote, _weights);
148     }
149 
150     function addGauge(address _token, address _gauge) external g {
151         require(gauges[_token] == address(0x0), "exists");
152         _safeApprove(_rkp3r, _gauge, type(uint).max);
153         gauges[_token] = _gauge;
154         enabled[_token] = true;
155         _tokens.push(_token);
156     }
157 
158     function disable(address _token) external g {
159         enabled[_token] = false;
160     }
161 
162     function enable(address _token) external g {
163         enabled[_token] = true;
164     }
165 
166     function length() external view returns (uint) {
167         return _tokens.length;
168     }
169 
170     function distribute() external g {
171         uint _balance = erc20(_rkp3r).balanceOf(address(this));
172         if (_balance > 0 && totalWeight > 0) {
173             uint _totalWeight = totalWeight;
174             for (uint i = 0; i < _tokens.length; i++) {
175                 if (!enabled[_tokens[i]]) {
176                     _totalWeight -= weights[_tokens[i]];
177                 }
178             }
179             for (uint x = 0; x < _tokens.length; x++) {
180                 if (enabled[_tokens[x]]) {
181                     uint _reward = _balance * weights[_tokens[x]] / _totalWeight;
182                     if (_reward > 0) {
183                         address _gauge = gauges[_tokens[x]];
184                         Gauge(_gauge).deposit_reward_token(_rkp3r, _reward);
185                     }
186                 }
187             }
188         }
189     }
190 
191     function _safeApprove(address token, address spender, uint256 value) internal {
192         (bool success, bytes memory data) =
193             token.call(abi.encodeWithSelector(erc20.approve.selector, spender, value));
194         require(success && (data.length == 0 || abi.decode(data, (bool))));
195     }
196 }