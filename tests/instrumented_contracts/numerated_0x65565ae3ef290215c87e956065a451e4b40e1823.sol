1 pragma solidity ^0.5.2;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76     function transfer(address to, uint256 value) external returns (bool);
77 
78     function approve(address spender, uint256 value) external returns (bool);
79 
80     function transferFrom(address from, address to, uint256 value) external returns (bool);
81 
82     function totalSupply() external view returns (uint256);
83 
84     function balanceOf(address who) external view returns (uint256);
85 
86     function allowance(address owner, address spender) external view returns (uint256);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // File: contracts/token/ERC20/SafeERC20.sol
94 
95 /**
96  * @title SafeERC20
97  * @dev Wrappers around ERC20 operations that throw on failure.
98  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
99  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
100  */
101 library SafeERC20 {
102     using SafeMath for uint256;
103 
104     function safeTransfer(IERC20 token, address to, uint256 value) internal {
105         require(token.transfer(to, value));
106     }
107 
108     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
109         require(token.transferFrom(from, to, value));
110     }
111 
112     function safeApprove(IERC20 token, address spender, uint256 value) internal {
113         // safeApprove should only be called when setting an initial allowance,
114         // or when resetting it to zero. To increase and decrease it, use
115         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
116         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
117         require(token.approve(spender, value));
118     }
119 
120     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
121         uint256 newAllowance = token.allowance(address(this), spender).add(value);
122         require(token.approve(spender, newAllowance));
123     }
124 
125     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
126         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
127         require(token.approve(spender, newAllowance));
128     }
129 }
130 
131 // File: contracts/token/ERC20/TokenTimelock.sol
132 
133 /**
134  * @title TokenTimelock
135  * @dev TokenTimelock is a token holder contract that will allow a
136  * beneficiary to extract the tokens after a given release time
137  */
138 contract TokenTimelock {
139     using SafeERC20 for IERC20;
140 
141     // ERC20 basic token contract being held
142     IERC20 private _token;
143 
144     // beneficiary of tokens after they are released
145     address private _beneficiary;
146 
147     // timestamp when token release is enabled
148     uint256 private _releaseTime;
149 
150     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
151         // solhint-disable-next-line not-rely-on-time
152         require(releaseTime > block.timestamp);
153         _token = token;
154         _beneficiary = beneficiary;
155         _releaseTime = releaseTime;
156     }
157 
158     /**
159      * @return the token being held.
160      */
161     function token() public view returns (IERC20) {
162         return _token;
163     }
164 
165     /**
166      * @return the beneficiary of the tokens.
167      */
168     function beneficiary() public view returns (address) {
169         return _beneficiary;
170     }
171 
172     /**
173      * @return the time when the tokens are released.
174      */
175     function releaseTime() public view returns (uint256) {
176         return _releaseTime;
177     }
178 
179     /**
180      * @notice Transfers tokens held by timelock to beneficiary.
181      */
182     function release() public {
183         // solhint-disable-next-line not-rely-on-time
184         require(block.timestamp >= _releaseTime);
185 
186         uint256 amount = _token.balanceOf(address(this));
187         require(amount > 0);
188 
189         _token.safeTransfer(_beneficiary, amount);
190     }
191 }