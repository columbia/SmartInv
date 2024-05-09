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
74 contract ERC721Token {
75     function ownerOf(uint256) public view returns (address);
76     function exists(uint256) public view returns (bool);
77     function getAllTokens() external view returns (uint256[]);
78     function totalSupply() public view returns (uint256);
79 
80 }
81 
82 contract EggStorage is ERC721Token {
83     function push(address, uint256[2], uint8) public returns (uint256);
84     function get(uint256) external view returns (uint256[2], uint8);
85     function remove(address, uint256) external;
86 }
87 
88 
89 
90 
91 //////////////CONTRACT//////////////
92 
93 
94 
95 
96 contract EggCore is Upgradable {
97     EggStorage _storage_;
98 
99     function getAmount() external view returns (uint256) {
100         return _storage_.totalSupply();
101     }
102 
103     function getAllEggs() external view returns (uint256[]) {
104         return _storage_.getAllTokens();
105     }
106 
107     function isOwner(address _user, uint256 _tokenId) external view returns (bool) {
108         return _user == _storage_.ownerOf(_tokenId);
109     }
110 
111     function ownerOf(uint256 _tokenId) external view returns (address) {
112         return _storage_.ownerOf(_tokenId);
113     }
114 
115     function create(
116         address _sender,
117         uint256[2] _parents,
118         uint8 _dragonType
119     ) external onlyController returns (uint256) {
120         return _storage_.push(_sender, _parents, _dragonType);
121     }
122 
123     function remove(address _owner, uint256 _id) external onlyController {
124         _storage_.remove(_owner, _id);
125     }
126 
127     function get(uint256 _id) external view returns (uint256[2], uint8) {
128         require(_storage_.exists(_id), "egg doesn't exist");
129         return _storage_.get(_id);
130     }
131 
132     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
133         super.setInternalDependencies(_newDependencies);
134 
135         _storage_ = EggStorage(_newDependencies[0]);
136     }
137 }