1 pragma solidity ^0.5.8;
2 
3 /*
4     IdeaFeX Token crowdsale contract
5 
6     Deployed to     : 0xa0f9783497969a160d640bc8a0f5d53838a39416
7     IFX token       : 0x2CF588136b15E47b555331d2f5258063AE6D01ed
8     Funds wallet    : 0x1bD99BA31f1056F962e017410c9514dD4d6da4c6
9     Supply for sale : 400,000,000.000000000000000000
10     Rate            : 2000 IFX = 1 ETH
11     Bonus           : 40% before 20% sold
12                       30% between 20% and 40% sold
13                       20% between 40% and 60% sold
14                       10% between 60% and 80% sold
15 */
16 
17 
18 /* Safe maths */
19 
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint) {
22         uint c = a + b;
23         require(c >= a, "Addition overflow");
24         return c;
25     }
26     function sub(uint a, uint b) internal pure returns (uint) {
27         require(b <= a, "Subtraction overflow");
28         uint c = a - b;
29         return c;
30     }
31     function mul(uint a, uint b) internal pure returns (uint) {
32         if (a==0){
33             return 0;
34         }
35         uint c = a * b;
36         require(c / a == b, "Multiplication overflow");
37         return c;
38     }
39     function div(uint a, uint b) internal pure returns (uint) {
40         require(b > 0,"Division by 0");
41         uint c = a / b;
42         return c;
43     }
44     function mod(uint a, uint b) internal pure returns (uint) {
45         require(b != 0, "Modulo by 0");
46         return a % b;
47     }
48 }
49 
50 
51 /* ERC20 standard interface */
52 
53 interface ERC20Interface {
54     function totalSupply() external view returns (uint);
55     function balanceOf(address account) external view returns (uint);
56     function allowance(address owner, address spender) external view returns (uint);
57     function transfer(address recipient, uint amount) external returns (bool);
58     function approve(address spender, uint amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
60 
61     event Transfer(address indexed sender, address indexed recipient, uint value);
62     event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 
66 /* Safe ERC20 */
67 
68 library SafeERC20 {
69     using SafeMath for uint;
70 
71     function safeTransferFrom(ERC20Interface token, address from, address recipient, uint value) internal {
72         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, recipient, value));
73     }
74 
75     function callOptionalReturn(ERC20Interface token, bytes memory data) private {
76         (bool success, bytes memory returndata) = address(token).call(data);
77         require(success, "SafeERC20: low-level call failed");
78 
79         if (returndata.length > 0) {
80             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
81         }
82     }
83 }
84 
85 
86 /* No nested calls */
87 
88 contract ReentrancyGuard {
89     uint private _guardCounter;
90 
91     constructor () internal {
92         _guardCounter = 1;
93     }
94 
95     modifier nonReentrant() {
96         _guardCounter += 1;
97         uint localCounter = _guardCounter;
98         _;
99         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
100     }
101 }
102 
103 
104 /* IFX crowdsale */
105 
106 contract IFXCrowdsale is ReentrancyGuard {
107     using SafeMath for uint;
108     using SafeERC20 for ERC20Interface;
109 
110     // Addresses!!!
111     ERC20Interface private _IFX = ERC20Interface(0x2CF588136b15E47b555331d2f5258063AE6D01ed);
112     address payable private _fundingWallet = 0x1bD99BA31f1056F962e017410c9514dD4d6da4c6;
113     address payable private _tokenSaleWallet = 0x6924E015c192C0f1839a432B49e1e96e06571227;
114 
115     uint private _rate = 2000;
116     uint private _weiRaised;
117     uint private _ifxSold;
118     uint private _bonus = 40;
119     uint private _rateCurrent = 2800;
120 
121     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint ethValue, uint ifxAmount);
122 
123 
124     // Basics
125 
126     function () external payable {
127         buyTokens(msg.sender);
128     }
129 
130     function token() public view returns (ERC20Interface) {
131         return _IFX;
132     }
133 
134     function fundingWallet() public view returns (address payable) {
135         return _fundingWallet;
136     }
137 
138     function rate() public view returns (uint) {
139         return _rate;
140     }
141 
142     function rateWithBonus() public view returns (uint){
143         return _rateCurrent;
144     }
145 
146     function bonus() public view returns (uint) {
147         return _bonus;
148     }
149 
150     function weiRaised() public view returns (uint) {
151         return _weiRaised;
152     }
153 
154     function ifxSold() public view returns (uint) {
155         return _ifxSold;
156     }
157 
158 
159     // Default when people send ETH to contract address
160 
161     function buyTokens(address beneficiary) public nonReentrant payable {
162 
163         // Ensures that the call is valid
164         require(beneficiary != address(0), "Beneficiary is zero address");
165         require(msg.value != 0, "Value is 0");
166 
167         // Obtain token amount
168         uint tokenAmount = msg.value.mul(_rateCurrent);
169 
170         // Ensures that the hard cap is not breached
171         require(_ifxSold + tokenAmount < 400000000 * 10**18, "Hard cap reached");
172 
173         // Records the purchase internally
174         _weiRaised = _weiRaised.add(msg.value);
175         _ifxSold = _ifxSold.add(tokenAmount);
176 
177         // Update the bonus after each purchase
178         _currentBonus();
179 
180         // Process the purchase
181         _IFX.safeTransferFrom(_tokenSaleWallet, beneficiary, tokenAmount);
182         _fundingWallet.transfer(msg.value);
183 
184         // Announce the purchase event
185         emit TokensPurchased(msg.sender, beneficiary, msg.value, tokenAmount);
186     }
187 
188 
189     // Bonus
190 
191     function _currentBonus() internal {
192         if(_ifxSold < 80000000 * 10**18){
193             _bonus = 40;
194         } else if(_ifxSold >= 80000000 * 10**18 && _ifxSold < 160000000 * 10**18){
195             _bonus = 30;
196         } else if(_ifxSold >= 160000000 * 10**18 && _ifxSold < 240000000 * 10**18){
197             _bonus = 20;
198         } else if(_ifxSold >= 240000000 * 10**18 && _ifxSold < 320000000 * 10**18){
199             _bonus = 10;
200         } else if(_ifxSold >= 320000000 * 10**18){
201             _bonus = 0;
202         }
203 
204         // _rate === 2000
205         // _rate / 100 === 20
206         // (_bonus + 100) * _rate / 100 === _bonus * 20 + _rate
207         _rateCurrent = _bonus * 20 + 2000;
208     }
209 }