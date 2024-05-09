1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, April 20, 2019
3  (UTC) */
4 
5 pragma solidity 0.5.2;
6 
7 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor () internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29      * @return the address of the owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(isOwner());
40         _;
41     }
42 
43     /**
44      * @return true if `msg.sender` is the owner of the contract.
45      */
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51      * @dev Allows the current owner to relinquish control of the contract.
52      * @notice Renouncing to ownership will leave the contract without an owner.
53      * It will not be possible to call the functions with the `onlyOwner`
54      * modifier anymore.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 /**
83  * @title SafeMath
84  * @dev Unsigned math operations with safety checks that revert on error
85  */
86 library SafeMath {
87     /**
88     * @dev Multiplies two unsigned integers, reverts on overflow.
89     */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b);
100 
101         return c;
102     }
103 
104     /**
105     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
106     */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Solidity only automatically asserts when dividing by 0
109         require(b > 0);
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118     */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127     * @dev Adds two unsigned integers, reverts on overflow.
128     */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a);
132 
133         return c;
134     }
135 
136     /**
137     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
138     * reverts when dividing by zero.
139     */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0);
142         return a % b;
143     }
144 }
145 
146 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 interface IERC20 {
153     function transfer(address to, uint256 value) external returns (bool);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) external returns (bool);
158 
159     function totalSupply() external view returns (uint256);
160 
161     function balanceOf(address who) external view returns (uint256);
162 
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
171 
172 /**
173  * @title SafeERC20
174  * @dev Wrappers around ERC20 operations that throw on failure.
175  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
176  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
177  */
178 library SafeERC20 {
179     using SafeMath for uint256;
180 
181     function safeTransfer(IERC20 token, address to, uint256 value) internal {
182         require(token.transfer(to, value));
183     }
184 
185     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
186         require(token.transferFrom(from, to, value));
187     }
188 
189     function safeApprove(IERC20 token, address spender, uint256 value) internal {
190         // safeApprove should only be called when setting an initial allowance,
191         // or when resetting it to zero. To increase and decrease it, use
192         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
193         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
194         require(token.approve(spender, value));
195     }
196 
197     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
198         uint256 newAllowance = token.allowance(address(this), spender).add(value);
199         require(token.approve(spender, newAllowance));
200     }
201 
202     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
203         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
204         require(token.approve(spender, newAllowance));
205     }
206 }
207 
208 // File: contracts/TRYTokenVesting.sol
209 
210 /**
211  * @title TokenVesting
212  * @dev A token holder contract that can release its token balance gradually like a
213  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
214  * owner.
215  */
216 contract TRYTokenVesting is Ownable {
217     using SafeMath for uint256;
218     using SafeERC20 for IERC20;
219 
220     IERC20 private TRYToken;
221     uint256 private tokensToVest = 0;
222     uint256 private vestingId = 0;
223 
224     string private constant INSUFFICIENT_BALANCE = "Insufficient balance";
225     string private constant INVALID_VESTING_ID = "Invalid vesting id";
226     string private constant VESTING_ALREADY_RELEASED = "Vesting already released";
227     string private constant INVALID_BENEFICIARY = "Invalid beneficiary address";
228     string private constant NOT_VESTED = "Tokens have not vested yet";
229 
230     struct Vesting {
231         uint256 releaseTime;
232         uint256 amount;
233         address beneficiary;
234         bool released;
235     }
236     mapping(uint256 => Vesting) public vestings;
237 
238     event TokenVestingReleased(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
239     event TokenVestingAdded(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
240     event TokenVestingRemoved(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
241 
242     constructor(IERC20 _token) public {
243         require(address(_token) != address(0x0), "Matic token address is not valid");
244         TRYToken = _token;
245 
246         uint256 SCALING_FACTOR = 10 ** 18;
247         uint256 day = 1 days;
248 
249         addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 0, 100 * SCALING_FACTOR);
250         addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 30 * day, 100 * SCALING_FACTOR);
251         addVesting(0x1FD8DFd8Ee9cE53b62C2d5bc944D5F40DA5330C1, now + 61 * day, 100 * SCALING_FACTOR);
252         
253         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 1279 * day, 273304816 * SCALING_FACTOR);
254     }
255 
256     function token() public view returns (IERC20) {
257         return TRYToken;
258     }
259 
260     function beneficiary(uint256 _vestingId) public view returns (address) {
261         return vestings[_vestingId].beneficiary;
262     }
263 
264     function releaseTime(uint256 _vestingId) public view returns (uint256) {
265         return vestings[_vestingId].releaseTime;
266     }
267 
268     function vestingAmount(uint256 _vestingId) public view returns (uint256) {
269         return vestings[_vestingId].amount;
270     }
271 
272     function removeVesting(uint256 _vestingId) public onlyOwner {
273         Vesting storage vesting = vestings[_vestingId];
274         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
275         require(!vesting.released , VESTING_ALREADY_RELEASED);
276         vesting.released = true;
277         tokensToVest = tokensToVest.sub(vesting.amount);
278         emit TokenVestingRemoved(_vestingId, vesting.beneficiary, vesting.amount);
279     }
280 
281     function addVesting(address _beneficiary, uint256 _releaseTime, uint256 _amount) public onlyOwner {
282         require(_beneficiary != address(0x0), INVALID_BENEFICIARY);
283         tokensToVest = tokensToVest.add(_amount);
284         vestingId = vestingId.add(1);
285         vestings[vestingId] = Vesting({
286             beneficiary: _beneficiary,
287             releaseTime: _releaseTime,
288             amount: _amount,
289             released: false
290         });
291         emit TokenVestingAdded(vestingId, _beneficiary, _amount);
292     }
293 
294     function release(uint256 _vestingId) public {
295         Vesting storage vesting = vestings[_vestingId];
296         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
297         require(!vesting.released , VESTING_ALREADY_RELEASED);
298         // solhint-disable-next-line not-rely-on-time
299         require(block.timestamp >= vesting.releaseTime, NOT_VESTED);
300 
301         require(TRYToken.balanceOf(address(this)) >= vesting.amount, INSUFFICIENT_BALANCE);
302         vesting.released = true;
303         tokensToVest = tokensToVest.sub(vesting.amount);
304         TRYToken.safeTransfer(vesting.beneficiary, vesting.amount);
305         emit TokenVestingReleased(_vestingId, vesting.beneficiary, vesting.amount);
306     }
307 
308     function retrieveExcessTokens(uint256 _amount) public onlyOwner {
309         require(_amount <= TRYToken.balanceOf(address(this)).sub(tokensToVest), INSUFFICIENT_BALANCE);
310         TRYToken.safeTransfer(owner(), _amount);
311     }
312 }