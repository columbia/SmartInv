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
29 contract Pausable is Ownable {
30     event Pause();
31     event Unpause();
32 
33     bool public paused = false;
34 
35     modifier whenNotPaused() {
36         require(!paused, "contract is paused");
37         _;
38     }
39 
40     modifier whenPaused() {
41         require(paused, "contract is not paused");
42         _;
43     }
44 
45     function pause() public onlyOwner whenNotPaused {
46         paused = true;
47         emit Pause();
48     }
49 
50     function unpause() public onlyOwner whenPaused {
51         paused = false;
52         emit Unpause();
53     }
54 }
55 
56 contract Controllable is Ownable {
57     mapping(address => bool) controllers;
58 
59     modifier onlyController {
60         require(_isController(msg.sender), "no controller rights");
61         _;
62     }
63 
64     function _isController(address _controller) internal view returns (bool) {
65         return controllers[_controller];
66     }
67 
68     function _setControllers(address[] _controllers) internal {
69         for (uint256 i = 0; i < _controllers.length; i++) {
70             _validateAddress(_controllers[i]);
71             controllers[_controllers[i]] = true;
72         }
73     }
74 }
75 
76 contract Upgradable is Controllable {
77     address[] internalDependencies;
78     address[] externalDependencies;
79 
80     function getInternalDependencies() public view returns(address[]) {
81         return internalDependencies;
82     }
83 
84     function getExternalDependencies() public view returns(address[]) {
85         return externalDependencies;
86     }
87 
88     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
89         for (uint256 i = 0; i < _newDependencies.length; i++) {
90             _validateAddress(_newDependencies[i]);
91         }
92         internalDependencies = _newDependencies;
93     }
94 
95     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
96         externalDependencies = _newDependencies;
97         _setControllers(_newDependencies);
98     }
99 }
100 
101 
102 
103 
104 //////////////CONTRACT//////////////
105 
106 
107 
108 
109 contract UpgradeController is Ownable {
110     function migrate(address _oldAddress, address _newAddress) external onlyOwner {
111         require(_oldAddress != _newAddress, "addresses are equal");
112         Upgradable _oldContract = Upgradable(_oldAddress);
113         Upgradable _newContract = Upgradable(_newAddress);
114         Upgradable _externalDependency;
115         Upgradable _internalDependency;
116         address[] memory _externalDependenciesOfInternal;
117         address[] memory _internalDependenciesOfExternal;
118         address[] memory _externalDependencies = _oldContract.getExternalDependencies();
119         address[] memory _internalDependencies = _oldContract.getInternalDependencies();
120         require(
121             _externalDependencies.length > 0 ||
122             _internalDependencies.length > 0,
123             "no dependencies"
124         );
125         uint256 i;
126         uint256 j;
127 
128         for (i = 0; i < _externalDependencies.length; i++) {
129             _externalDependency = Upgradable(_externalDependencies[i]);
130             _internalDependenciesOfExternal = _externalDependency.getInternalDependencies();
131 
132             for (j = 0; j < _internalDependenciesOfExternal.length; j++) {
133                 if (_internalDependenciesOfExternal[j] == _oldAddress) {
134                     _internalDependenciesOfExternal[j] = _newAddress;
135                     break;
136                 }
137             }
138 
139             _externalDependency.setInternalDependencies(_internalDependenciesOfExternal);
140         }
141 
142         for (i = 0; i < _internalDependencies.length; i++) {
143             _internalDependency = Upgradable(_internalDependencies[i]);
144             _externalDependenciesOfInternal = _internalDependency.getExternalDependencies();
145 
146             for (j = 0; j < _externalDependenciesOfInternal.length; j++) {
147                 if (_externalDependenciesOfInternal[j] == _oldAddress) {
148                     _externalDependenciesOfInternal[j] = _newAddress;
149                     break;
150                 }
151             }
152 
153             _internalDependency.setExternalDependencies(_externalDependenciesOfInternal);
154         }
155 
156         _newContract.setInternalDependencies(_internalDependencies);
157         _newContract.setExternalDependencies(_externalDependencies);
158 
159         // Return old contract ownership to original owner for
160         // cases when we want to transfer some data manually
161         returnOwnership(_oldAddress);
162     }
163 
164     // Return ownership to original owner. That's important for cases when
165     // the new contract have an additional dependency that couldn't be
166     // transferred from the old contract. After that original owner
167     // have to transfer ownership to this contract again.
168     function returnOwnership(address _address) public onlyOwner {
169         Upgradable(_address).transferOwnership(owner);
170     }
171 
172     function pause(address _address) external onlyOwner {
173         Pausable(_address).pause();
174     }
175 
176     function unpause(address _address) external onlyOwner {
177         Pausable(_address).unpause();
178     }
179 }