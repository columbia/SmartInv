1 pragma solidity ^0.5.3;
2 
3     interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21     library SafeMath {
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b);
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0);
36         uint256 c = a / b;
37 
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0);
57         return a % b;
58     }
59 }
60 
61     library SafeERC20 {
62     using SafeMath for uint256;
63 
64     function safeTransfer(IERC20 token, address to, uint256 value) internal {
65         require(token.transfer(to, value));
66     }
67 
68     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
69         require(token.transferFrom(from, to, value));
70     }
71 
72     function safeApprove(IERC20 token, address spender, uint256 value) internal {
73         
74         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
75         require(token.approve(spender, value));
76     }
77 
78     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
79         uint256 newAllowance = token.allowance(address(this), spender).add(value);
80         require(token.approve(spender, newAllowance));
81     }
82 
83     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
84         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
85         require(token.approve(spender, newAllowance));
86     }
87 }
88 
89     contract ReentrancyGuard {
90         
91     uint256 private _guardCounter;
92 
93     constructor () internal {
94         _guardCounter = 1;
95     }
96 
97     modifier nonReentrant() {
98         _guardCounter += 1;
99         uint256 localCounter = _guardCounter;
100         _;
101         require(localCounter == _guardCounter);
102     }
103 }
104 
105     contract Crowdsale is ReentrancyGuard {
106     using SafeMath for uint256;
107     using SafeERC20 for IERC20;
108 
109     IERC20 private _token;
110 
111     address payable private _wallet;
112 
113     uint256 private _rate;
114 
115     uint256 private _weiRaised;
116 
117     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
118 
119     constructor (uint256 rate, address payable wallet, IERC20 token) public {
120         require(rate > 0);
121         require(wallet != address(0));
122         require(address(token) != address(0));
123 
124         _rate = rate;
125         _wallet = wallet;
126         _token = token;
127     }
128 
129     function () external payable {
130         buyTokens(msg.sender);
131     }
132 
133     function token() public view returns (IERC20) {
134         return _token;
135     }
136 
137     function wallet() public view returns (address payable) {
138         return _wallet;
139     }
140 
141     function rate() public view returns (uint256) {
142         return _rate;
143     }
144 
145     function weiRaised() public view returns (uint256) {
146         return _weiRaised;
147     }
148 
149     function buyTokens(address beneficiary) public nonReentrant payable {
150         uint256 weiAmount = msg.value;
151         _preValidatePurchase(beneficiary, weiAmount);
152 
153         uint256 tokens = _getTokenAmount(weiAmount);
154 
155         _weiRaised = _weiRaised.add(weiAmount);
156 
157         _processPurchase(beneficiary, tokens);
158         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
159 
160         _updatePurchasingState(beneficiary, weiAmount);
161 
162         _forwardFunds();
163         _postValidatePurchase(beneficiary, weiAmount);
164     }
165 
166     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
167         require(beneficiary != address(0));
168         require(weiAmount != 0);
169     }
170 
171     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
172 
173     }
174 
175     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
176         _token.safeTransfer(beneficiary, tokenAmount);
177     }
178 
179     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
180         _deliverTokens(beneficiary, tokenAmount);
181     }
182 
183     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
184 
185     }
186 
187     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
188         return weiAmount.mul(_rate);
189     }
190 
191     function _forwardFunds() internal {
192         _wallet.transfer(msg.value);
193     }
194 }