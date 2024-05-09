1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     int256 constant private INT256_MIN = -2**255;
31 
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Multiplies two signed integers, reverts on overflow.
51     */
52     function mul(int256 a, int256 b) internal pure returns (int256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
61 
62         int256 c = a * b;
63         require(c / a == b);
64 
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
82     */
83     function div(int256 a, int256 b) internal pure returns (int256) {
84         require(b != 0); // Solidity only automatically asserts when dividing by 0
85         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
86 
87         int256 c = a / b;
88 
89         return c;
90     }
91 
92     /**
93     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94     */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103     * @dev Subtracts two signed integers, reverts on overflow.
104     */
105     function sub(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a - b;
107         require((b >= 0 && c <= a) || (b < 0 && c > a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Adds two unsigned integers, reverts on overflow.
114     */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Adds two signed integers, reverts on overflow.
124     */
125     function add(int256 a, int256 b) internal pure returns (int256) {
126         int256 c = a + b;
127         require((b >= 0 && c >= a) || (b < 0 && c < a));
128 
129         return c;
130     }
131 
132     /**
133     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
134     * reverts when dividing by zero.
135     */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b != 0);
138         return a % b;
139     }
140 }
141 
142 /**
143  * @title SafeERC20
144  * @dev Wrappers around ERC20 operations that throw on failure.
145  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
146  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
147  */
148 library SafeERC20 {
149     using SafeMath for uint256;
150 
151     function safeTransfer(IERC20 token, address to, uint256 value) internal {
152         require(token.transfer(to, value));
153     }
154 
155     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
156         require(token.transferFrom(from, to, value));
157     }
158 
159     function safeApprove(IERC20 token, address spender, uint256 value) internal {
160         // safeApprove should only be called when setting an initial allowance,
161         // or when resetting it to zero. To increase and decrease it, use
162         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
163         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
164         require(token.approve(spender, value));
165     }
166 
167     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
168         uint256 newAllowance = token.allowance(address(this), spender).add(value);
169         require(token.approve(spender, newAllowance));
170     }
171 
172     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
173         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
174         require(token.approve(spender, newAllowance));
175     }
176 }
177 /**
178  * @title TokenTimelock
179  * @dev TokenTimelock is a token holder contract that will allow a
180  * beneficiary to extract the tokens after a given release time
181  */
182 contract TokenTimelock {
183     using SafeERC20 for IERC20;
184 
185     // ERC20 basic token contract being held
186     IERC20 private _token;
187 
188     // beneficiary of tokens after they are released
189     address private _beneficiary;
190 
191     // timestamp when token release is enabled
192     uint256 private _releaseTime;
193 
194     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
195         // solium-disable-next-line security/no-block-members
196         require(releaseTime > block.timestamp);
197         _token = token;
198         _beneficiary = beneficiary;
199         _releaseTime = releaseTime;
200     }
201     
202     /**
203      * @return the token being held.
204      */
205     function token() public view returns (IERC20) {
206         return _token;
207     }
208 
209     /**
210      * @return the beneficiary of the tokens.
211      */
212     function beneficiary() public view returns (address) {
213         return _beneficiary;
214     }
215 
216     /**
217      * @return the time when the tokens are released.
218      */
219     function releaseTime() public view returns (uint256) {
220         return _releaseTime;
221     }
222 
223     /**
224      * @notice Transfers tokens held by timelock to beneficiary.
225      */
226     function release() public {
227         // solium-disable-next-line security/no-block-members
228         require(block.timestamp >= _releaseTime);
229 
230         uint256 amount = _token.balanceOf(address(this));
231         require(amount > 0, "amount less than 0");
232 
233         _token.safeTransfer(_beneficiary, amount);
234     }
235 }