1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function _validateAddress(address _addr) internal pure {
9         require(_addr != address(0), "invalid address");
10     }
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner, "not a contract owner");
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         _validateAddress(newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25     }
26 
27 }
28 
29 contract Controllable is Ownable {
30     mapping(address => bool) controllers;
31 
32     modifier onlyController {
33         require(_isController(msg.sender), "no controller rights");
34         _;
35     }
36 
37     function _isController(address _controller) internal view returns (bool) {
38         return controllers[_controller];
39     }
40 
41     function _setControllers(address[] _controllers) internal {
42         for (uint256 i = 0; i < _controllers.length; i++) {
43             _validateAddress(_controllers[i]);
44             controllers[_controllers[i]] = true;
45         }
46     }
47 }
48 
49 contract Upgradable is Controllable {
50     address[] internalDependencies;
51     address[] externalDependencies;
52 
53     function getInternalDependencies() public view returns(address[]) {
54         return internalDependencies;
55     }
56 
57     function getExternalDependencies() public view returns(address[]) {
58         return externalDependencies;
59     }
60 
61     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
62         for (uint256 i = 0; i < _newDependencies.length; i++) {
63             _validateAddress(_newDependencies[i]);
64         }
65         internalDependencies = _newDependencies;
66     }
67 
68     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
69         externalDependencies = _newDependencies;
70         _setControllers(_newDependencies);
71     }
72 }
73 
74 
75 
76 
77 //////////////CONTRACT//////////////
78 
79 
80 
81 
82 
83 contract DragonParams is Upgradable {
84 
85     // 0 - attack, 1 - defense, 2 - stamina, 3 - speed, 4 - intelligence
86     // typesFactors and geneTypesFactors are stored as value * 10
87     uint8[5][11] _dragonTypesFactors_;
88     uint8[5][10] _bodyPartsFactors_;
89     uint8[5][10] _geneTypesFactors_;
90     uint8[10] _experienceToNextLevel_;
91     uint16[11] _dnaPoints_;
92     uint8 _battlePoints_;
93     uint8[99] _geneUpgradeDNAPoints_; // 99 levels
94 
95     // GETTERS BY INDEX
96 
97     function dragonTypesFactors(uint8 _index) external view returns (uint8[5]) {
98         return _dragonTypesFactors_[_index];
99     }
100 
101     function bodyPartsFactors(uint8 _index) external view returns (uint8[5]) {
102         return _bodyPartsFactors_[_index];
103     }
104 
105     function geneTypesFactors(uint8 _index) external view returns (uint8[5]) {
106         return _geneTypesFactors_[_index];
107     }
108 
109     function experienceToNextLevel(uint8 _index) external view returns (uint8) {
110         return _experienceToNextLevel_[_index];
111     }
112 
113     function dnaPoints(uint8 _index) external view returns (uint16) {
114         return _dnaPoints_[_index];
115     }
116 
117     function geneUpgradeDNAPoints(uint8 _index) external view returns (uint8) {
118         return _geneUpgradeDNAPoints_[_index];
119     }
120 
121     // GETTERS
122 
123     function getDragonTypesFactors() external view returns (uint8[55] result) {
124         uint8 _index;
125         for (uint8 i = 0; i < 11; i++) {
126             for (uint8 j = 0; j < 5; j++) {
127                 result[_index] = _dragonTypesFactors_[i][j];
128                 _index++;
129             }
130         }
131     }
132 
133     function _transformArray(uint8[5][10] _array) internal pure returns (uint8[50] result) {
134         uint8 _index;
135         for (uint8 i = 0; i < 10; i++) {
136             for (uint8 j = 0; j < 5; j++) {
137                 result[_index] = _array[i][j];
138                 _index++;
139             }
140         }
141     }
142 
143     function getBodyPartsFactors() external view returns (uint8[50]) {
144         return _transformArray(_bodyPartsFactors_);
145     }
146 
147     function getGeneTypesFactors() external view returns (uint8[50]) {
148         return _transformArray(_geneTypesFactors_);
149     }
150 
151     function getExperienceToNextLevel() external view returns (uint8[10]) {
152         return _experienceToNextLevel_;
153     }
154 
155     function getDNAPoints() external view returns (uint16[11]) {
156         return _dnaPoints_;
157     }
158 
159     function battlePoints() external view returns (uint8) {
160         return _battlePoints_;
161     }
162 
163     function getGeneUpgradeDNAPoints() external view returns (uint8[99]) {
164         return _geneUpgradeDNAPoints_;
165     }
166 
167     // SETTERS
168 
169     function setDragonTypesFactors(uint8[5][11] _types) external onlyOwner {
170         _dragonTypesFactors_ = _types;
171     }
172 
173     function setBodyPartsFactors(uint8[5][10] _bodyParts) external onlyOwner {
174         _bodyPartsFactors_ = _bodyParts;
175     }
176 
177     function setGeneTypesFactors(uint8[5][10] _geneTypes) external onlyOwner {
178         _geneTypesFactors_ = _geneTypes;
179     }
180 
181     function setLevelUpPoints(
182         uint8[10] _experienceToNextLevel,
183         uint16[11] _dnaPoints,
184         uint8 _battlePoints
185     ) external onlyOwner {
186         _experienceToNextLevel_ = _experienceToNextLevel;
187         _dnaPoints_ = _dnaPoints;
188         _battlePoints_ = _battlePoints;
189     }
190 
191     function setGeneUpgradeDNAPoints(uint8[99] _points) external onlyOwner {
192         _geneUpgradeDNAPoints_ = _points;
193     }
194 }