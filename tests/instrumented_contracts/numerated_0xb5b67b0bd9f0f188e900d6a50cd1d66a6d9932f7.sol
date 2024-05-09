1 pragma solidity 0.4.25;
2 
3 library SafeConvert {
4 
5     function toUint8(uint256 _value) internal pure returns (uint8) {
6         assert(_value <= 255);
7         return uint8(_value);
8     }
9 
10     function toUint16(uint256 _value) internal pure returns (uint16) {
11         assert(_value <= 2**16 - 1);
12         return uint16(_value);
13     }
14 
15     function toUint32(uint256 _value) internal pure returns (uint32) {
16         assert(_value <= 2**32 - 1);
17         return uint32(_value);
18     }
19 }
20 
21 library SafeMath256 {
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a / b;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) return 0;
49         if (b == 0) return 1;
50 
51         uint256 c = a ** b;
52         assert(c / (a ** (b - 1)) == a);
53         return c;
54     }
55 }
56 
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     function _validateAddress(address _addr) internal pure {
63         require(_addr != address(0), "invalid address");
64     }
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner() {
71         require(msg.sender == owner, "not a contract owner");
72         _;
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         _validateAddress(newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 
81 }
82 
83 contract Controllable is Ownable {
84     mapping(address => bool) controllers;
85 
86     modifier onlyController {
87         require(_isController(msg.sender), "no controller rights");
88         _;
89     }
90 
91     function _isController(address _controller) internal view returns (bool) {
92         return controllers[_controller];
93     }
94 
95     function _setControllers(address[] _controllers) internal {
96         for (uint256 i = 0; i < _controllers.length; i++) {
97             _validateAddress(_controllers[i]);
98             controllers[_controllers[i]] = true;
99         }
100     }
101 }
102 
103 contract Upgradable is Controllable {
104     address[] internalDependencies;
105     address[] externalDependencies;
106 
107     function getInternalDependencies() public view returns(address[]) {
108         return internalDependencies;
109     }
110 
111     function getExternalDependencies() public view returns(address[]) {
112         return externalDependencies;
113     }
114 
115     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
116         for (uint256 i = 0; i < _newDependencies.length; i++) {
117             _validateAddress(_newDependencies[i]);
118         }
119         internalDependencies = _newDependencies;
120     }
121 
122     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
123         externalDependencies = _newDependencies;
124         _setControllers(_newDependencies);
125     }
126 }
127 
128 
129 
130 
131 //////////////CONTRACT//////////////
132 
133 
134 
135 contract Distribution is Upgradable {
136     using SafeMath256 for uint256;
137     using SafeConvert for uint256;
138 
139     uint256 restAmount;
140     uint256 releasedAmount;
141     uint256 lastBlock;
142     uint256 interval; // in blocks
143 
144     uint256 constant NUMBER_OF_DRAGON_TYPES = 5; // [0..4]
145 
146     constructor() public {
147         releasedAmount = 10000; // released amount of eggs
148         restAmount = releasedAmount;
149         lastBlock = 6790679; // start block number
150         interval = 1;
151     }
152 
153     function _updateInterval() internal {
154         if (restAmount == 5000) {
155             interval = 2;
156         } else if (restAmount == 3750) {
157             interval = 4;
158         } else if (restAmount == 2500) {
159             interval = 8;
160         } else if (restAmount == 1250) {
161             interval = 16;
162         }
163     }
164 
165     function _burnGas() internal pure {
166         uint256[26950] memory _local;
167         for (uint256 i = 0; i < _local.length; i++) {
168             _local[i] = i;
169         }
170     }
171 
172     function claim(uint8 _requestedType) external onlyController returns (uint256, uint256, uint256) {
173         require(restAmount > 0, "eggs are over");
174         require(lastBlock.add(interval) <= block.number, "too early");
175         uint256 _index = releasedAmount.sub(restAmount); // next egg index
176         uint8 currentType = (_index % NUMBER_OF_DRAGON_TYPES).toUint8();
177         require(currentType == _requestedType, "not a current type of dragon");
178         lastBlock = block.number;
179         restAmount = restAmount.sub(1);
180         _updateInterval();
181         _burnGas();
182         return (restAmount, lastBlock, interval);
183     }
184 
185     function getInfo() external view returns (uint256, uint256, uint256, uint256, uint256) {
186         return (
187             restAmount,
188             releasedAmount,
189             lastBlock,
190             interval,
191             NUMBER_OF_DRAGON_TYPES
192         );
193     }
194 }