1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 
111 
112 
113 //////////////CONTRACT//////////////
114 
115 
116 
117 
118 contract DragonLeaderboard is Upgradable {
119     using SafeMath256 for uint256;
120 
121     struct Leaderboard {
122         uint256 id;
123         uint32 coolness;
124     }
125 
126     Leaderboard[10] leaderboard;
127 
128     uint8[10] rewardCoefficients = [50, 45, 40, 35, 30, 25, 20, 15, 10, 5]; // multiplied by 10
129     uint8 constant COEFFS_MULTIPLIER = 10;
130     uint256 rewardPeriod = 24 hours;
131     uint256 lastRewardDate;
132 
133     constructor() public {
134         lastRewardDate = now;
135     }
136 
137     function update(uint256 _id, uint32 _coolness) external onlyController {
138         uint256 _index;
139         bool _isIndex;
140         uint256 _existingIndex;
141         bool _isExistingIndex;
142 
143         // if coolness is more than coolness of the last dragon
144         if (_coolness > leaderboard[leaderboard.length.sub(1)].coolness) {
145 
146             for (uint256 i = 0; i < leaderboard.length; i = i.add(1)) {
147                 // if a place for a dragon is found
148                 if (_coolness > leaderboard[i].coolness && !_isIndex) {
149                     _index = i;
150                     _isIndex = true;
151                 }
152                 // if dragon is already in leaderboard
153                 if (leaderboard[i].id == _id && !_isExistingIndex) {
154                     _existingIndex = i;
155                     _isExistingIndex = true;
156                 }
157                 if(_isIndex && _isExistingIndex) break;
158             }
159             // if dragon stayed at the same place
160             if (_isExistingIndex && _index >= _existingIndex) {
161                 leaderboard[_existingIndex] = Leaderboard(_id, _coolness);
162             } else if (_isIndex) {
163                 _add(_index, _existingIndex, _isExistingIndex, _id, _coolness);
164             }
165         }
166     }
167 
168     function _add(
169         uint256 _index,
170         uint256 _existingIndex,
171         bool _isExistingIndex,
172         uint256 _id,
173         uint32 _coolness
174     ) internal {
175         uint256 _length = leaderboard.length;
176         uint256 _indexTo = _isExistingIndex ? _existingIndex : _length.sub(1);
177 
178         // shift other dragons
179         for (uint256 i = _indexTo; i > _index; i = i.sub(1)){
180             leaderboard[i] = leaderboard[i.sub(1)];
181         }
182 
183         leaderboard[_index] = Leaderboard(_id, _coolness);
184     }
185 
186     function getDragonsFromLeaderboard() external view returns (uint256[10] result) {
187         for (uint256 i = 0; i < leaderboard.length; i = i.add(1)) {
188             result[i] = leaderboard[i].id;
189         }
190     }
191 
192     function updateRewardTime() external onlyController {
193         require(lastRewardDate.add(rewardPeriod) < now, "too early");
194         lastRewardDate = now;
195     }
196 
197     function getRewards(uint256 _hatchingPrice) external view returns (uint256[10] rewards) {
198         for (uint8 i = 0; i < 10; i++) {
199             rewards[i] = _hatchingPrice.mul(rewardCoefficients[i]).div(COEFFS_MULTIPLIER);
200         }
201     }
202 
203     function getDate() external view returns (uint256, uint256) {
204         return (lastRewardDate, rewardPeriod);
205     }
206 }