1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath8 {
5 
6     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
7         if (a == 0) {
8             return 0;
9         }
10         uint8 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint8 a, uint8 b) internal pure returns (uint8) {
16         return a / b;
17     }
18 
19     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint8 a, uint8 b) internal pure returns (uint8) {
25         uint8 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30     function pow(uint8 a, uint8 b) internal pure returns (uint8) {
31         if (a == 0) return 0;
32         if (b == 0) return 1;
33 
34         uint8 c = a ** b;
35         assert(c / (a ** (b - 1)) == a);
36         return c;
37     }
38 }
39 
40 library SafeMath256 {
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         assert(c / a == b);
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a / b;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 
66     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) return 0;
68         if (b == 0) return 1;
69 
70         uint256 c = a ** b;
71         assert(c / (a ** (b - 1)) == a);
72         return c;
73     }
74 }
75 
76 contract Ownable {
77     address public owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     function _validateAddress(address _addr) internal pure {
82         require(_addr != address(0), "invalid address");
83     }
84 
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner() {
90         require(msg.sender == owner, "not a contract owner");
91         _;
92     }
93 
94     function transferOwnership(address newOwner) public onlyOwner {
95         _validateAddress(newOwner);
96         emit OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98     }
99 
100 }
101 
102 contract Controllable is Ownable {
103     mapping(address => bool) controllers;
104 
105     modifier onlyController {
106         require(_isController(msg.sender), "no controller rights");
107         _;
108     }
109 
110     function _isController(address _controller) internal view returns (bool) {
111         return controllers[_controller];
112     }
113 
114     function _setControllers(address[] _controllers) internal {
115         for (uint256 i = 0; i < _controllers.length; i++) {
116             _validateAddress(_controllers[i]);
117             controllers[_controllers[i]] = true;
118         }
119     }
120 }
121 
122 contract Upgradable is Controllable {
123     address[] internalDependencies;
124     address[] externalDependencies;
125 
126     function getInternalDependencies() public view returns(address[]) {
127         return internalDependencies;
128     }
129 
130     function getExternalDependencies() public view returns(address[]) {
131         return externalDependencies;
132     }
133 
134     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
135         for (uint256 i = 0; i < _newDependencies.length; i++) {
136             _validateAddress(_newDependencies[i]);
137         }
138         internalDependencies = _newDependencies;
139     }
140 
141     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
142         externalDependencies = _newDependencies;
143         _setControllers(_newDependencies);
144     }
145 }
146 
147 contract Random {
148     function random(uint256) external view returns (uint256) {}
149     function randomOfBlock(uint256, uint256) external view returns (uint256) {}
150 }
151 
152 
153 
154 
155 //////////////CONTRACT//////////////
156 
157 
158 
159 
160 contract Nest is Upgradable {
161     using SafeMath8 for uint8;
162     using SafeMath256 for uint256;
163 
164     Random random;
165 
166     uint256[2] eggs;
167     uint256 lastBlockNumber;
168 
169     bool isFull;
170 
171     mapping (uint256 => bool) public inNest;
172 
173     function add(
174         uint256 _id
175     ) external onlyController returns (
176         bool isHatched,
177         uint256 hatchedId,
178         uint256 randomForEggOpening
179     ) {
180         require(!inNest[_id], "egg is already in nest");
181         require(block.number > lastBlockNumber, "only 1 egg in a block");
182 
183         lastBlockNumber = block.number;
184         inNest[_id] = true;
185 
186         // if amount of egg = 3, then hatch one
187         if (isFull) {
188             isHatched = true;
189             hatchedId = eggs[0];
190             randomForEggOpening = random.random(2**256 - 1);
191             eggs[0] = eggs[1];
192             eggs[1] = _id;
193             delete inNest[hatchedId];
194         } else {
195             uint8 _index = eggs[0] == 0 ? 0 : 1;
196             eggs[_index] = _id;
197             if (_index == 1) {
198                 isFull = true;
199             }
200         }
201     }
202 
203     // GETTERS
204 
205     function getEggs() external view returns (uint256[2]) {
206         return eggs;
207     }
208 
209     // UPDATE CONTRACT
210 
211     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
212         super.setInternalDependencies(_newDependencies);
213 
214         random = Random(_newDependencies[0]);
215     }
216 }