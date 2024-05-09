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
135 
136 contract Random is Upgradable {
137     using SafeMath256 for uint256;
138     using SafeConvert for uint256;
139 
140     function _safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return b > a ? 0 : a.sub(b);
142     }
143 
144     modifier validBlock(uint256 _blockNumber) {
145         require(
146             _blockNumber < block.number &&
147             _blockNumber >= _safeSub(block.number, 256),
148             "not valid block number"
149         );
150         _;
151     }
152 
153     function getRandom(
154         uint256 _upper,
155         uint256 _blockNumber
156     ) internal view validBlock(_blockNumber) returns (uint256) {
157         bytes32 _hash = keccak256(abi.encodePacked(blockhash(_blockNumber), now));
158         return uint256(_hash) % _upper;
159     }
160 
161     function random(uint256 _upper) external view returns (uint256) {
162         return getRandom(_upper, block.number.sub(1));
163     }
164 
165     function randomOfBlock(
166         uint256 _upper,
167         uint256 _blockNumber
168     ) external view returns (uint256) {
169         return getRandom(_upper, _blockNumber);
170     }
171 }