1 pragma solidity ^0.5.2;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7     /**
8      * Returns whether the target address is a contract
9      * @dev This function will return false if invoked during the constructor of a contract,
10      * as the code is not actually created until after the constructor finishes.
11      * @param account address of the account to check
12      * @return whether the target address is a contract
13      */
14     function isContract(address account) internal view returns (bool) {
15         uint256 size;
16         // XXX Currently there is no better way to check if there is a contract in an address
17         // than to check the size of the code at that address.
18         // See https://ethereum.stackexchange.com/a/14016/36603
19         // for more details about how this works.
20         // TODO Check this again before the Serenity release, because all addresses will be
21         // contracts then.
22         // solhint-disable-next-line no-inline-assembly
23         assembly { size := extcodesize(account) }
24         return size > 0;
25     }
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error.
31  */
32 library SafeMath {
33     /**
34      * @dev Multiplies two unsigned integers, reverts on overflow.
35      */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b);
46 
47         return c;
48     }
49 
50     /**
51      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
52      */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Adds two unsigned integers, reverts on overflow.
74      */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a);
78 
79         return c;
80     }
81 
82     /**
83      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
84      * reverts when dividing by zero.
85      */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0);
88         return a % b;
89     }
90 }
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://eips.ethereum.org/EIPS/eip-20
95  */
96 interface IERC20 {
97     function transfer(address to, uint256 value) external returns (bool);
98 
99     function approve(address spender, uint256 value) external returns (bool);
100 
101     function transferFrom(address from, address to, uint256 value) external returns (bool);
102 
103     function totalSupply() external view returns (uint256);
104 
105     function balanceOf(address who) external view returns (uint256);
106 
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title SafeERC20
116  * @dev Wrappers around ERC20 operations that throw on failure (when the token
117  * contract returns false). Tokens that return no value (and instead revert or
118  * throw on failure) are also supported, non-reverting calls are assumed to be
119  * successful.
120  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
121  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
122  */
123 library SafeERC20 {
124     using SafeMath for uint256;
125     using Address for address;
126 
127     function safeTransfer(IERC20 token, address to, uint256 value) internal {
128         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
129     }
130 
131     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
132         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
133     }
134 
135     function safeApprove(IERC20 token, address spender, uint256 value) internal {
136         // safeApprove should only be called when setting an initial allowance,
137         // or when resetting it to zero. To increase and decrease it, use
138         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
139         require((value == 0) || (token.allowance(address(this), spender) == 0));
140         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
141     }
142 
143     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
144         uint256 newAllowance = token.allowance(address(this), spender).add(value);
145         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
146     }
147 
148     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
149         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
150         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
151     }
152 
153     /**
154      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
155      * on the return value: the return value is optional (but if data is returned, it must not be false).
156      * @param token The token targeted by the call.
157      * @param data The call data (encoded using abi.encode or one of its variants).
158      */
159     function callOptionalReturn(IERC20 token, bytes memory data) private {
160         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
161         // we're implementing it ourselves.
162 
163         // A Solidity high level call has three parts:
164         //  1. The target address is checked to verify it contains contract code
165         //  2. The call itself is made, and success asserted
166         //  3. The return value is decoded, which in turn checks the size of the returned data.
167 
168         require(address(token).isContract());
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = address(token).call(data);
172         require(success);
173 
174         if (returndata.length > 0) { // Return data is optional
175             require(abi.decode(returndata, (bool)));
176         }
177     }
178 }
179 
180 /**
181  * @title TokenTimelock
182  * @dev TokenTimelock is a token holder contract that will allow a
183  * beneficiary to extract the tokens after a given release time.
184  */
185 contract TokenTimelock {
186     using SafeERC20 for IERC20;
187 
188     // ERC20 basic token contract being held
189     IERC20 private _token;
190 
191     // beneficiary of tokens after they are released
192     address private _beneficiary;
193 
194     // timestamp when token release is enabled
195     uint256 private _releaseTime;
196 
197     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
198         // solhint-disable-next-line not-rely-on-time
199         require(releaseTime > block.timestamp);
200         _token = token;
201         _beneficiary = beneficiary;
202         _releaseTime = releaseTime;
203     }
204 
205     /**
206      * @return the token being held.
207      */
208     function token() public view returns (IERC20) {
209         return _token;
210     }
211 
212     /**
213      * @return the beneficiary of the tokens.
214      */
215     function beneficiary() public view returns (address) {
216         return _beneficiary;
217     }
218 
219     /**
220      * @return the time when the tokens are released.
221      */
222     function releaseTime() public view returns (uint256) {
223         return _releaseTime;
224     }
225 
226     /**
227      * @notice Transfers tokens held by timelock to beneficiary.
228      */
229     function release() public {
230         // solhint-disable-next-line not-rely-on-time
231         require(block.timestamp >= _releaseTime);
232 
233         uint256 amount = _token.balanceOf(address(this));
234         require(amount > 0);
235 
236         _token.safeTransfer(_beneficiary, amount);
237     }
238 }