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
110 contract ERC20 {
111     function balanceOf(address) public view returns (uint256) {}
112     function transfer(address, uint256) public returns (bool) {}
113 }
114 
115 contract Gold is ERC20 {
116     function remoteTransfer(address _to, uint256 _value) external {}
117     function burn(uint256 _value) external {}
118 }
119 
120 
121 
122 
123 //////////////CONTRACT//////////////
124 
125 
126 
127 
128 contract Treasury is Upgradable {
129     using SafeMath256 for uint256;
130 
131     Gold goldTokens;
132 
133     uint256 constant GOLD_DECIMALS = 10 ** 18;
134     uint256 constant public hatchingPrice = 1000 * GOLD_DECIMALS;
135 
136     function giveGold(address _user, uint256 _amount) external onlyController {
137         goldTokens.transfer(_user, _amount);
138     }
139 
140     function takeGold(uint256 _amount) external onlyController {
141         goldTokens.remoteTransfer(this, _amount);
142     }
143 
144     function burnGold(uint256 _amount) external onlyController {
145         goldTokens.burn(_amount);
146     }
147 
148     function remainingGold() external view returns (uint256) {
149         return goldTokens.balanceOf(this);
150     }
151 
152     // UPDATE CONTRACT
153 
154     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
155         super.setInternalDependencies(_newDependencies);
156 
157         goldTokens = Gold(_newDependencies[0]);
158     }
159 
160     function migrate(address _newAddress) public onlyOwner {
161         goldTokens.transfer(_newAddress, goldTokens.balanceOf(this));
162     }
163 }