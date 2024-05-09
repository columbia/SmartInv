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
118 contract SkillMarketplace is Upgradable {
119     using SafeMath256 for uint256;
120 
121     mapping (uint256 => uint256) allTokensIndex;
122     mapping (uint256 => uint256) tokenToPrice;
123 
124     uint256[] allTokens;
125 
126     function _checkTokenExistence(uint256 _id) internal view {
127         require(tokenToPrice[_id] > 0, "skill is not on sale");
128     }
129 
130     function sellToken(
131         uint256 _tokenId,
132         uint256 _price
133     ) external onlyController {
134         require(_price > 0, "price must be more than 0");
135 
136         if (tokenToPrice[_tokenId] == 0) {
137             allTokensIndex[_tokenId] = allTokens.length;
138             allTokens.push(_tokenId);
139         }
140         tokenToPrice[_tokenId] = _price;
141     }
142 
143     function removeFromAuction(uint256 _tokenId) external onlyController {
144         _checkTokenExistence(_tokenId);
145         _remove(_tokenId);
146     }
147 
148     function _remove(uint256 _tokenId) internal {
149         require(allTokens.length > 0, "no auctions");
150 
151         delete tokenToPrice[_tokenId];
152 
153         uint256 tokenIndex = allTokensIndex[_tokenId];
154         uint256 lastTokenIndex = allTokens.length.sub(1);
155         uint256 lastToken = allTokens[lastTokenIndex];
156 
157         allTokens[tokenIndex] = lastToken;
158         allTokens[lastTokenIndex] = 0;
159 
160         allTokens.length--;
161         allTokensIndex[_tokenId] = 0;
162         allTokensIndex[lastToken] = tokenIndex;
163     }
164 
165     // GETTERS
166 
167     function getAuction(uint256 _id) external view returns (uint256) {
168         _checkTokenExistence(_id);
169         return tokenToPrice[_id];
170     }
171 
172     function getAllTokens() external view returns (uint256[]) {
173         return allTokens;
174     }
175 
176     function totalSupply() public view returns (uint256) {
177         return allTokens.length;
178     }
179 }