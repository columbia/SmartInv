1 pragma solidity ^0.5.2;
2 
3 // File: contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: contracts/utils/Address.sol
94 
95 /**
96  * Utility library of inline functions on addresses
97  */
98 library Address {
99     /**
100      * Returns whether the target address is a contract
101      * @dev This function will return false if invoked during the constructor of a contract,
102      * as the code is not actually created until after the constructor finishes.
103      * @param account address of the account to check
104      * @return whether the target address is a contract
105      */
106     function isContract(address account) internal view returns (bool) {
107         uint256 size;
108         // XXX Currently there is no better way to check if there is a contract in an address
109         // than to check the size of the code at that address.
110         // See https://ethereum.stackexchange.com/a/14016/36603
111         // for more details about how this works.
112         // TODO Check this again before the Serenity release, because all addresses will be
113         // contracts then.
114         // solhint-disable-next-line no-inline-assembly
115         assembly { size := extcodesize(account) }
116         return size > 0;
117     }
118 }
119 
120 // File: contracts/token/ERC20/SafeERC20.sol
121 
122 /**
123  * @title SafeERC20
124  * @dev Wrappers around ERC20 operations that throw on failure (when the token
125  * contract returns false). Tokens that return no value (and instead revert or
126  * throw on failure) are also supported, non-reverting calls are assumed to be
127  * successful.
128  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
130  */
131 library SafeERC20 {
132     using SafeMath for uint256;
133     using Address for address;
134 
135     function safeTransfer(IERC20 token, address to, uint256 value) internal {
136         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
137     }
138 
139     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
140         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
141     }
142 
143     function safeApprove(IERC20 token, address spender, uint256 value) internal {
144         // safeApprove should only be called when setting an initial allowance,
145         // or when resetting it to zero. To increase and decrease it, use
146         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147         require((value == 0) || (token.allowance(address(this), spender) == 0));
148         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
149     }
150 
151     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
152         uint256 newAllowance = token.allowance(address(this), spender).add(value);
153         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
154     }
155 
156     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
157         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
158         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
159     }
160 
161     /**
162      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
163      * on the return value: the return value is optional (but if data is returned, it must equal true).
164      * @param token The token targeted by the call.
165      * @param data The call data (encoded using abi.encode or one of its variants).
166      */
167     function callOptionalReturn(IERC20 token, bytes memory data) private {
168         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
169         // we're implementing it ourselves.
170 
171         // A Solidity high level call has three parts:
172         //  1. The target address is checked to verify it contains contract code
173         //  2. The call itself is made, and success asserted
174         //  3. The return value is decoded, which in turn checks the size of the returned data.
175 
176         require(address(token).isContract());
177 
178         // solhint-disable-next-line avoid-low-level-calls
179         (bool success, bytes memory returndata) = address(token).call(data);
180         require(success);
181 
182         if (returndata.length > 0) { // Return data is optional
183             require(abi.decode(returndata, (bool)));
184         }
185     }
186 }
187 
188 // File: contracts/token/ERC20/TokenTimelock.sol
189 
190 /**
191  * @title TokenTimelock
192  * @dev TokenTimelock is a token holder contract that will allow a
193  * beneficiary to extract the tokens after a given release time
194  */
195 contract TokenTimelock {
196     using SafeERC20 for IERC20;
197 
198     // ERC20 basic token contract being held
199     IERC20 private _token;
200 
201     // beneficiary of tokens after they are released
202     address private _beneficiary;
203 
204     // timestamp when token release is enabled
205     uint256 private _releaseTime;
206 
207     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
208         // solhint-disable-next-line not-rely-on-time
209         require(releaseTime > block.timestamp);
210         _token = token;
211         _beneficiary = beneficiary;
212         _releaseTime = releaseTime;
213     }
214 
215     /**
216      * @return the token being held.
217      */
218     function token() public view returns (IERC20) {
219         return _token;
220     }
221 
222     /**
223      * @return the beneficiary of the tokens.
224      */
225     function beneficiary() public view returns (address) {
226         return _beneficiary;
227     }
228 
229     /**
230      * @return the time when the tokens are released.
231      */
232     function releaseTime() public view returns (uint256) {
233         return _releaseTime;
234     }
235 
236     /**
237      * @notice Transfers tokens held by timelock to beneficiary.
238      */
239     function release() public {
240         // solhint-disable-next-line not-rely-on-time
241         require(block.timestamp >= _releaseTime);
242 
243         uint256 amount = _token.balanceOf(address(this));
244         require(amount > 0);
245 
246         _token.safeTransfer(_beneficiary, amount);
247     }
248 }