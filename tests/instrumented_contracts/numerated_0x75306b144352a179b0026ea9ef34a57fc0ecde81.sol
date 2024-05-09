1 //Copyright (c) 2016-2019 zOS Global Limited, licensed under the MIT license.
2 //https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
3 
4 pragma solidity ^0.5.2;
5 
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11 
12         uint256 c = a * b;
13         require(c / a == b);
14 
15         return c;
16     }
17     
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b > 0);
20         uint256 c = a / b;
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b <= a);
27         uint256 c = a - b;
28 
29         return c;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a);
35 
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 }
44 
45 library Address {
46     function isContract(address account) internal view returns (bool) {
47         uint256 size;
48         assembly { size := extcodesize(account) }
49         return size > 0;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address who) external view returns (uint256);
56     function allowance(address owner, address spender) external view returns (uint256);
57     
58     event Transfer(address indexed from, address indexed to, uint256 value);    
59     function transfer(address to, uint256 value) external returns (bool);
60     
61     event Approval(address indexed owner, address indexed spender, uint256 value);    
62     function approve(address spender, uint256 value) external returns (bool);
63     function transferFrom(address from, address to, uint256 value) external returns (bool);
64 }
65 
66 library SafeERC20 {
67     using SafeMath for uint256;
68     using Address for address;
69 
70     function safeTransfer(IERC20 token, address to, uint256 value) internal {
71         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
72     }
73 
74     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
75         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
76     }
77 
78     function safeApprove(IERC20 token, address spender, uint256 value) internal {
79         require((value == 0) || (token.allowance(address(this), spender) == 0));
80         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
81     }
82 
83     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
84         uint256 newAllowance = token.allowance(address(this), spender).add(value);
85         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
86     }
87 
88     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
89         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
90         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
91     }
92 
93     function callOptionalReturn(IERC20 token, bytes memory data) private {
94         require(address(token).isContract());
95 
96         (bool success, bytes memory returndata) = address(token).call(data);
97         require(success);
98 
99         if (returndata.length > 0) {
100             require(abi.decode(returndata, (bool)));
101         }
102     }
103 }
104 
105 contract ReentrancyGuard {
106     uint256 private _guardCounter;
107 
108     constructor () internal {
109         _guardCounter = 1;
110     }
111 
112     modifier nonReentrant() {
113         _guardCounter += 1;
114         uint256 localCounter = _guardCounter;
115         _;
116         require(localCounter == _guardCounter);
117     }
118 }
119 
120 contract Crowdsale is ReentrancyGuard {
121     using SafeMath for uint256;
122     using SafeERC20 for IERC20;
123 
124     IERC20 private _token;
125     address payable private _wallet;
126 
127     uint256 private _rate;
128     uint256 private _weiRaised;
129 
130     uint256 private _openingTime;
131     uint256 private _closingTime;
132 
133     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
134 
135     constructor () public {
136         _rate = 10000000000;
137         _wallet = 0x4b09b4aeA5f9C616ebB6Ee0097B62998Cb332275;
138         _token = IERC20(0x1a9ECb05376Bf8BB32F7F038A845DbAfb22041cd);
139         
140         _openingTime = block.timestamp;
141         _closingTime = 1567296000;
142     }
143     
144     function isOpen() public view returns (bool) {
145         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
146     }
147 
148     modifier onlyWhileOpen {
149         require(isOpen());
150         _;
151     }
152     
153     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
154         require(beneficiary != address(0));
155         require(weiAmount != 0);
156     }
157 
158     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
159         return weiAmount.div(_rate);
160     }
161     
162     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
163         _token.safeTransfer(beneficiary, tokenAmount);
164     }
165     
166     function _forwardFunds() internal {
167         _wallet.transfer(msg.value);
168     }
169     
170     function buyTokens(address beneficiary) public nonReentrant payable {
171         uint256 weiAmount = msg.value;
172         _preValidatePurchase(beneficiary, weiAmount);
173 
174         uint256 tokens = _getTokenAmount(weiAmount);
175 
176         _weiRaised = _weiRaised.add(weiAmount);
177 
178         _deliverTokens(beneficiary, tokens);
179         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
180 
181         _forwardFunds();
182     }
183 
184     function () external payable {
185         buyTokens(msg.sender);
186     }
187     
188     function token() public view returns (IERC20) {
189         return _token;
190     }
191     function wallet() public view returns (address payable) {
192         return _wallet;
193     }
194     
195     function rate() public view returns (uint256) {
196         return _rate;
197     }
198     function weiRaised() public view returns (uint256) {
199         return _weiRaised;
200     }
201 
202     function openingTime() public view returns (uint256) {
203         return _openingTime;
204     }
205     function closingTime() public view returns (uint256) {
206         return _closingTime;
207     }
208 }