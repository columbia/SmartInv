1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 library SafeERC20 {
93 
94   using SafeMath for uint256;
95 
96   function safeTransfer(
97     IERC20 token,
98     address to,
99     uint256 value
100   )
101     internal
102   {
103     require(token.transfer(to, value));
104   }
105 
106   function safeTransferFrom(
107     IERC20 token,
108     address from,
109     address to,
110     uint256 value
111   )
112     internal
113   {
114     require(token.transferFrom(from, to, value));
115   }
116 
117   function safeApprove(
118     IERC20 token,
119     address spender,
120     uint256 value
121   )
122     internal
123   {
124     // safeApprove should only be called when setting an initial allowance, 
125     // or when resetting it to zero. To increase and decrease it, use 
126     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
127     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
128     require(token.approve(spender, value));
129   }
130 
131   function safeIncreaseAllowance(
132     IERC20 token,
133     address spender,
134     uint256 value
135   )
136     internal
137   {
138     uint256 newAllowance = token.allowance(address(this), spender).add(value);
139     require(token.approve(spender, newAllowance));
140   }
141 
142   function safeDecreaseAllowance(
143     IERC20 token,
144     address spender,
145     uint256 value
146   )
147     internal
148   {
149     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
150     require(token.approve(spender, newAllowance));
151   }
152 }
153 
154 contract TokenTimelock {
155   using SafeERC20 for IERC20;
156 
157   IERC20 private _token;
158   address private _sender;
159   address private _beneficiary;
160   uint256 private _releaseTime;
161 
162   constructor(
163     IERC20 token,
164     address beneficiary,
165     uint256 releaseTime
166   )
167     public
168   {
169     // solium-disable-next-line security/no-block-members
170     require(releaseTime > block.timestamp);
171     _token = token;
172     _sender = msg.sender;
173     _beneficiary = beneficiary;
174     _releaseTime = releaseTime;
175   }
176 
177   function token() public view returns(IERC20) {
178     return _token;
179   }
180   function sender() public view returns(address) {
181     return _sender;
182   }
183   function beneficiary() public view returns(address) {
184     return _beneficiary;
185   }
186   function releaseTime() public view returns(uint256) {
187     return _releaseTime;
188   }
189 
190   function release() public {
191     // solium-disable-next-line security/no-block-members
192     require((msg.sender == _sender) || (msg.sender == _beneficiary), "thou shall not pass!");
193     require(block.timestamp >= _releaseTime, "not yet.");
194 
195     uint256 amount = _token.balanceOf(address(this));
196     require(amount > 0, "zero balance");
197 
198     _token.safeTransfer(_beneficiary, amount);
199   }
200 
201   function cancel() public {
202     require(msg.sender == _sender, "Only sender can do this");
203 
204     uint256 amount = _token.balanceOf(address(this));
205     require(amount > 0, "zero balance");
206 
207     _token.safeTransfer(_sender, amount);
208   }
209 }