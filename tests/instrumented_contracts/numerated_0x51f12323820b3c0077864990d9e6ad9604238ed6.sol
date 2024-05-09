1 pragma solidity 0.5.17;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) 
7             return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner, "permission denied");
48         _;
49     }
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0), "invalid address");
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 interface IERC20 {
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by `account`.
66      */
67     function balanceOf(address account) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transfer(address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `sender` to `recipient` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 library Address {
130     /**
131      * @dev Returns true if `account` is a contract.
132      *
133      * This test is non-exhaustive, and there may be false-negatives: during the
134      * execution of a contract's constructor, its address will be reported as
135      * not containing a contract.
136      *
137      * IMPORTANT: It is unsafe to assume that an address for which this
138      * function returns false is an externally-owned account (EOA) and not a
139      * contract.
140      */
141     function isContract(address account) internal view returns (bool) {
142         // This method relies in extcodesize, which returns 0 for contracts in
143         // construction, since the code is only stored at the end of the
144         // constructor execution.
145 
146         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
147         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
148         // for accounts without code, i.e. `keccak256('')`
149         bytes32 codehash;
150         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
151         // solhint-disable-next-line no-inline-assembly
152         assembly { codehash := extcodehash(account) }
153         return (codehash != 0x0 && codehash != accountHash);
154     }
155 
156     /**
157      * @dev Converts an `address` into `address payable`. Note that this is
158      * simply a type cast: the actual underlying value is not changed.
159      *
160      * _Available since v2.4.0._
161      */
162     function toPayable(address account) internal pure returns (address payable) {
163         return address(uint160(account));
164     }
165 
166     /**
167      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
168      * `recipient`, forwarding all available gas and reverting on errors.
169      *
170      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
171      * of certain opcodes, possibly making contracts go over the 2300 gas limit
172      * imposed by `transfer`, making them unable to receive funds via
173      * `transfer`. {sendValue} removes this limitation.
174      *
175      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
176      *
177      * IMPORTANT: because control is transferred to `recipient`, care must be
178      * taken to not create reentrancy vulnerabilities. Consider using
179      * {ReentrancyGuard} or the
180      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
181      *
182      * _Available since v2.4.0._
183      */
184     function sendValue(address payable recipient, uint256 amount) internal {
185         require(address(this).balance >= amount, "Address: insufficient balance");
186 
187         // solhint-disable-next-line avoid-call-value
188         (bool success, ) = recipient.call.value(amount)("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 }
192 
193 library SafeERC20 {
194     using SafeMath for uint256;
195     using Address for address;
196 
197     function safeTransfer(IERC20 token, address to, uint256 value) internal {
198         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
199     }
200 
201     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
202         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
203     }
204 
205     function safeApprove(IERC20 token, address spender, uint256 value) internal {
206         // safeApprove should only be called when setting an initial allowance,
207         // or when resetting it to zero. To increase and decrease it, use
208         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
209         // solhint-disable-next-line max-line-length
210         require((value == 0) || (token.allowance(address(this), spender) == 0),
211             "SafeERC20: approve from non-zero to non-zero allowance"
212         );
213         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
214     }
215 
216     /**
217      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
218      * on the return value: the return value is optional (but if data is returned, it must not be false).
219      * @param token The token targeted by the call.
220      * @param data The call data (encoded using abi.encode or one of its variants).
221      */
222     function callOptionalReturn(IERC20 token, bytes memory data) private {
223         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
224         // we're implementing it ourselves.
225 
226         // A Solidity high level call has three parts:
227         //  1. The target address is checked to verify it contains contract code
228         //  2. The call itself is made, and success asserted
229         //  3. The return value is decoded, which in turn checks the size of the returned data.
230         // solhint-disable-next-line max-line-length
231         require(address(token).isContract(), "SafeERC20: call to non-contract");
232 
233         // solhint-disable-next-line avoid-low-level-calls
234         (bool success, bytes memory returndata) = address(token).call(data);
235         require(success, "SafeERC20: low-level call failed");
236 
237         if (returndata.length > 0) { // Return data is optional
238             // solhint-disable-next-line max-line-length
239             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
240         }
241     }
242 }
243 
244 contract VestingVault is Ownable {
245     using SafeMath for uint256;
246     using SafeERC20 for IERC20;
247 
248     IERC20 public constant hakka = IERC20(0x0E29e5AbbB5FD88e28b2d355774e73BD47dE3bcd);
249 
250     uint256 public constant vestingPeriod = 19 days;
251     uint256 public constant proportion = 173831376164413312; //17.38%
252 
253     mapping(address => uint256) public balanceOf;
254     mapping(address => uint256) public lastWithdrawalTime;
255 
256     event Deposit(address indexed from, address indexed to, uint256 amount);
257     event Withdraw(address indexed from, uint256 amount);
258 
259     function deposit(address to, uint256 amount) external {
260         hakka.safeTransferFrom(msg.sender, address(this), amount);
261         balanceOf[to] = balanceOf[to].add(amount);
262 
263         emit Deposit(msg.sender, to, amount);
264     }
265 
266     function withdraw() external returns (uint256 amount) {
267         address from = msg.sender;
268         require(lastWithdrawalTime[from].add(vestingPeriod) < now);
269         lastWithdrawalTime[from] = now;
270         amount = balanceOf[from].mul(proportion).div(1e18);
271         balanceOf[from] = balanceOf[from].sub(amount);
272         hakka.safeTransfer(from, amount);
273 
274         emit Withdraw(msg.sender, amount);
275     }
276 
277     function inCaseTokenGetsStuckPartial(IERC20 _TokenAddress, uint256 _amount) onlyOwner public {
278         require(_TokenAddress != hakka);
279         _TokenAddress.safeTransfer(msg.sender, _amount);
280     }
281 
282 }