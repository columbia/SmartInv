1 pragma solidity >=0.4.21 <0.6.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 library SafeMath {
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      *
114      * _Available since v2.4.0._
115      */
116     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b <= a, errorMessage);
118         uint256 c = a - b;
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136         if (a == 0) {
137             return 0;
138         }
139 
140         uint256 c = a * b;
141         require(c / a == b, "SafeMath: multiplication overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers. Reverts on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return div(a, b, "SafeMath: division by zero");
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      *
172      * _Available since v2.4.0._
173      */
174     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         // Solidity only automatically asserts when dividing by 0
176         require(b > 0, errorMessage);
177         uint256 c = a / b;
178         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return mod(a, b, "SafeMath: modulo by zero");
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts with custom message when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      *
209      * _Available since v2.4.0._
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b != 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 contract Context {
218     // Empty internal constructor, to prevent people from mistakenly deploying
219     // an instance of this contract, which should be used via inheritance.
220     constructor () internal { }
221     // solhint-disable-previous-line no-empty-blocks
222 
223     function _msgSender() internal view returns (address payable) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 library Roles {
234     struct Role {
235         mapping (address => bool) bearer;
236     }
237 
238     /**
239      * @dev Give an account access to this role.
240      */
241     function add(Role storage role, address account) internal {
242         require(!has(role, account), "Roles: account already has role");
243         role.bearer[account] = true;
244     }
245 
246     /**
247      * @dev Remove an account's access to this role.
248      */
249     function remove(Role storage role, address account) internal {
250         require(has(role, account), "Roles: account does not have role");
251         role.bearer[account] = false;
252     }
253 
254     /**
255      * @dev Check if an account has this role.
256      * @return bool
257      */
258     function has(Role storage role, address account) internal view returns (bool) {
259         require(account != address(0), "Roles: account is the zero address");
260         return role.bearer[account];
261     }
262 }
263 
264 contract WhitelistAdminRole is Context {
265     using Roles for Roles.Role;
266 
267     event WhitelistAdminAdded(address indexed account);
268     event WhitelistAdminRemoved(address indexed account);
269 
270     Roles.Role private _whitelistAdmins;
271 
272     constructor () internal {
273         _addWhitelistAdmin(_msgSender());
274     }
275 
276     modifier onlyWhitelistAdmin() {
277         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
278         _;
279     }
280 
281     function isWhitelistAdmin(address account) public view returns (bool) {
282         return _whitelistAdmins.has(account);
283     }
284 
285     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
286         _addWhitelistAdmin(account);
287     }
288 
289     function renounceWhitelistAdmin() public {
290         _removeWhitelistAdmin(_msgSender());
291     }
292 
293     function _addWhitelistAdmin(address account) internal {
294         _whitelistAdmins.add(account);
295         emit WhitelistAdminAdded(account);
296     }
297 
298     function _removeWhitelistAdmin(address account) internal {
299         _whitelistAdmins.remove(account);
300         emit WhitelistAdminRemoved(account);
301     }
302 }
303 
304 contract BankerWallet is WhitelistAdminRole {
305     event TransferETH(address indexed to, uint256 indexed amount);
306     event TransferERC20(address indexed to, uint256 indexed amount);
307     event BankDeposited(address indexed from, uint256 indexed value);
308 
309     using SafeMath for uint256;
310 
311     function() external payable {
312         emit BankDeposited(msg.sender, msg.value);
313     }
314 
315 
316     function batchTransferETH(address payable[] memory _contributors, uint256[] memory _amount) public payable onlyWhitelistAdmin {
317         uint8 i = 0;
318         for (i; i < _amount.length; i++) {
319             _contributors[i].transfer(_amount[i]);
320             emit TransferETH(_contributors[i], _amount[i]);
321 
322         }
323     }
324 
325     function batchTransferERC20(address token,
326         address[] memory _contributors, uint256[] memory _amounts) public onlyWhitelistAdmin {
327         uint8 i = 0;
328         IERC20 instance = IERC20(token);
329         for (i; i < _contributors.length; i++) {
330             instance.transfer(_contributors[i], _amounts[i]);
331             emit TransferERC20(_contributors[i], _amounts[i]);
332         }
333     }
334 
335     
336 
337 }