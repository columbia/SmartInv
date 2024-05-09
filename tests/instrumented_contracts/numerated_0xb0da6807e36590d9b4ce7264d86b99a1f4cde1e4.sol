1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface IERC20 {
64   function totalSupply() external view returns (uint256);
65 
66   function balanceOf(address who) external view returns (uint256);
67 
68   function allowance(address owner, address spender)
69     external view returns (uint256);
70 
71   function transfer(address to, uint256 value) external returns (bool);
72 
73   function approve(address spender, uint256 value)
74     external returns (bool);
75 
76   function transferFrom(address from, address to, uint256 value)
77     external returns (bool);
78 
79   event Transfer(
80     address indexed from,
81     address indexed to,
82     uint256 value
83   );
84 
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
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
157   // ERC20 basic token contract being held
158   IERC20 private _token;
159 
160   // beneficiary of tokens after they are released
161   address private _beneficiary;
162 
163   // timestamp when token release is enabled
164   uint256 private _releaseTime;
165 
166   constructor(
167     IERC20 token,
168     address beneficiary,
169     uint256 releaseTime
170   )
171     public
172   {
173     // solium-disable-next-line security/no-block-members
174     require(releaseTime > block.timestamp);
175     _token = token;
176     _beneficiary = beneficiary;
177     _releaseTime = releaseTime;
178   }
179 
180   /**
181    * @return the token being held.
182    */
183   function token() public view returns(IERC20) {
184     return _token;
185   }
186 
187   /**
188    * @return the beneficiary of the tokens.
189    */
190   function beneficiary() public view returns(address) {
191     return _beneficiary;
192   }
193 
194   /**
195    * @return the time when the tokens are released.
196    */
197   function releaseTime() public view returns(uint256) {
198     return _releaseTime;
199   }
200 
201   /**
202    * @notice Transfers tokens held by timelock to beneficiary.
203    */
204   function release() public {
205     // solium-disable-next-line security/no-block-members
206     require(block.timestamp >= _releaseTime);
207 
208     uint256 amount = _token.balanceOf(address(this));
209     require(amount > 0);
210 
211     _token.safeTransfer(_beneficiary, amount);
212   }
213 }
214 
215 contract LoomTimelockFactory {
216 
217     IERC20 loom;
218     event LoomTimeLockCreated(address validatorEthAddress, address timelockContractAddress, string validatorName, string validatorPublicKey, uint256 _amount, uint256 _releaseTime);
219 
220     constructor(IERC20 _loom) public { loom = _loom; }
221 
222     function deployTimeLock(address validatorEthAddress, string validatorName, string validatorPublicKey, uint256 amount, uint256 duration) public {
223         // Deploy timelock
224         TokenTimelock timelock = new TokenTimelock(loom, validatorEthAddress, block.timestamp + duration);
225 
226         // Ensure it got an address
227         require(address(timelock) != address(0x0));
228 
229         // Send funds to timelock. -- MUST APPROVE FIRST
230         loom.transferFrom(msg.sender, address(timelock), amount);
231 
232         emit LoomTimeLockCreated(validatorEthAddress, address(timelock), validatorName, validatorPublicKey, amount, block.timestamp + duration);
233     }
234 }