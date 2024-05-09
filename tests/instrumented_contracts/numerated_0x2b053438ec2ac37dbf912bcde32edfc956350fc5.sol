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
110 contract Name {
111     using SafeMath256 for uint256;
112 
113     uint8 constant MIN_NAME_LENGTH = 2;
114     uint8 constant MAX_NAME_LENGTH = 32;
115 
116     function _convertName(string _input) internal pure returns(bytes32 _initial, bytes32 _lowercase) {
117         bytes memory _initialBytes = bytes(_input);
118         assembly {
119             _initial := mload(add(_initialBytes, 32))
120         }
121         _lowercase = _toLowercase(_input);
122     }
123 
124 
125     function _toLowercase(string _input) internal pure returns(bytes32 result) {
126         bytes memory _temp = bytes(_input);
127         uint256 _length = _temp.length;
128 
129         //sorry limited to 32 characters
130         require (_length <= 32 && _length >= 2, "string must be between 2 and 32 characters");
131         // make sure it doesnt start with or end with space
132         require(_temp[0] != 0x20 && _temp[_length.sub(1)] != 0x20, "string cannot start or end with space");
133         // make sure first two characters are not 0x
134         if (_temp[0] == 0x30)
135         {
136             require(_temp[1] != 0x78, "string cannot start with 0x");
137             require(_temp[1] != 0x58, "string cannot start with 0X");
138         }
139 
140         // create a bool to track if we have a non number character
141         bool _hasNonNumber;
142 
143         // convert & check
144         for (uint256 i = 0; i < _length; i = i.add(1))
145         {
146             // if its uppercase A-Z
147             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
148             {
149                 // convert to lower case a-z
150                 _temp[i] = byte(uint256(_temp[i]).add(32));
151 
152                 // we have a non number
153                 if (_hasNonNumber == false)
154                     _hasNonNumber = true;
155             } else {
156                 require
157                 (
158                     // require character is a space
159                     _temp[i] == 0x20 ||
160                     // OR lowercase a-z
161                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
162                     // or 0-9
163                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
164                     "string contains invalid characters"
165                 );
166                 // make sure theres not 2x spaces in a row
167                 if (_temp[i] == 0x20)
168                     require(_temp[i.add(1)] != 0x20, "string cannot contain consecutive spaces");
169 
170                 // see if we have a character other than a number
171                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
172                     _hasNonNumber = true;
173             }
174         }
175 
176         require(_hasNonNumber == true, "string cannot be only numbers");
177 
178         assembly {
179             result := mload(add(_temp, 32))
180         }
181     }
182 }
183 
184 
185 
186 
187 //////////////CONTRACT//////////////
188 
189 
190 
191 
192 
193 contract User is Upgradable, Name {
194     mapping (bytes32 => bool) public existingNames;
195     mapping (address => bytes32) public names;
196 
197     function getName(address _user) external view returns (bytes32) {
198         return names[_user];
199     }
200 
201     function setName(
202         address _user,
203         string _name
204     ) external onlyController returns (bytes32) {
205         (
206             bytes32 _initial, // initial name that converted to bytes32
207             bytes32 _lowercase // name to lowercase
208         ) = _convertName(_name);
209         require(!existingNames[_lowercase], "this username already exists");
210         require(names[_user] == 0x0, "username is already set");
211         names[_user] = _initial;
212         existingNames[_lowercase] = true;
213 
214         return _initial;
215     }
216 }