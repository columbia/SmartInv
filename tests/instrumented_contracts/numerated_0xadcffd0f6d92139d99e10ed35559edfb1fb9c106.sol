1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Context {
55     constructor () internal { }
56 
57     function _msgSender() internal view returns (address payable) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view returns (bytes memory) {
62         this;
63         return msg.data;
64     }
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () internal {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(isOwner(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function isOwner() public view returns (bool) {
88         return _msgSender() == _owner;
89     }
90 
91     function renounceOwnership() public onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 interface ISmartexOracle {
108   function currentETHPrice() external view returns (uint256);
109   function lastETHPriceUpdate() external view returns (uint256);
110 
111   function currentTokenPrice() external view returns (uint256);
112   function lastTokenPriceUpdate() external view returns (uint256);
113 
114   function setETHPrice(uint256 price) external;
115   function updateTokenPrice() external;
116 
117   event ETHPriceUpdated(uint256 price, uint256 timestamp);
118   event TokenPriceUpdated(uint256 price, uint256 timestamp);
119 }
120 
121 contract SmartexOracle is ISmartexOracle, Ownable {
122   using SafeMath for uint256;
123 
124   mapping (address => bool) public authorizedCallers;
125 
126   uint256 constant private TOKEN_PRICE_UPDATE_PERIOD = 7 days;
127 
128   uint256 private _currentTokenPrice;
129   uint256 private _lastTokenPriceUpdate;
130 
131   uint256 private _currentETHPrice;
132   uint256 private _lastETHPriceUpdate;
133 
134   modifier onlyAuthorizedCaller() {
135     require(_msgSender() == owner() || authorizedCallers[_msgSender()], "SmartexOracle: caller is not authorized");
136     _;
137   }
138 
139   constructor() public {
140     _currentTokenPrice = 10 ** 8;
141     _lastTokenPriceUpdate = now;
142   }
143 
144   function currentETHPrice() public view returns (uint256) {
145     return _currentETHPrice;
146   }
147 
148   function currentTokenPrice() public view returns (uint256) {
149     return _currentTokenPrice;
150   }
151 
152   function lastETHPriceUpdate() public view returns (uint256) {
153     return _lastETHPriceUpdate;
154   }
155 
156   function lastTokenPriceUpdate() public view returns (uint256) {
157     return _lastTokenPriceUpdate;
158   }
159 
160   function setAuthorizedCaller(address caller, bool allowed) public onlyOwner {
161     authorizedCallers[caller] = allowed;
162   }
163 
164   function setETHPrice(uint256 price) external onlyAuthorizedCaller {
165     require(price > 0, "Price cannot be 0");
166 
167     _lastETHPriceUpdate = now;
168     _currentETHPrice = price;
169 
170     emit ETHPriceUpdated(_currentETHPrice, _lastETHPriceUpdate);
171   }
172 
173   function updateTokenPrice() external onlyAuthorizedCaller {
174     require(_lastTokenPriceUpdate + TOKEN_PRICE_UPDATE_PERIOD <= now, "Token price can be changed once within a period");
175 
176     _lastTokenPriceUpdate = now;
177 
178     _currentTokenPrice = _currentTokenPrice.mul(120).div(100);
179 
180     emit TokenPriceUpdated(_currentTokenPrice, _lastTokenPriceUpdate);
181   }
182 }