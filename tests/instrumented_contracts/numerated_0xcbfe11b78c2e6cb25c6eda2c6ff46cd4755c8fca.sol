1 pragma solidity 0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 /**
79  * @title SafeMath
80  * @dev Unsigned math operations with safety checks that revert on error
81  */
82 library SafeMath {
83     /**
84     * @dev Multiplies two unsigned integers, reverts on overflow.
85     */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b);
96 
97         return c;
98     }
99 
100     /**
101     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
102     */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
114     */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b <= a);
117         uint256 c = a - b;
118 
119         return c;
120     }
121 
122     /**
123     * @dev Adds two unsigned integers, reverts on overflow.
124     */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a);
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
142 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149     function transfer(address to, uint256 value) external returns (bool);
150 
151     function approve(address spender, uint256 value) external returns (bool);
152 
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address who) external view returns (uint256);
158 
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
167 
168 /**
169  * @title SafeERC20
170  * @dev Wrappers around ERC20 operations that throw on failure.
171  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
172  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
173  */
174 library SafeERC20 {
175     using SafeMath for uint256;
176 
177     function safeTransfer(IERC20 token, address to, uint256 value) internal {
178         require(token.transfer(to, value));
179     }
180 
181     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
182         require(token.transferFrom(from, to, value));
183     }
184 
185     function safeApprove(IERC20 token, address spender, uint256 value) internal {
186         // safeApprove should only be called when setting an initial allowance,
187         // or when resetting it to zero. To increase and decrease it, use
188         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
189         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
190         require(token.approve(spender, value));
191     }
192 
193     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
194         uint256 newAllowance = token.allowance(address(this), spender).add(value);
195         require(token.approve(spender, newAllowance));
196     }
197 
198     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
199         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
200         require(token.approve(spender, newAllowance));
201     }
202 }
203 
204 // File: contracts/MaticTokenVesting.sol
205 
206 /**
207  * @title TokenVesting
208  * @dev A token holder contract that can release its token balance gradually like a
209  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
210  * owner.
211  */
212 contract MaticTokenVesting is Ownable {
213     using SafeMath for uint256;
214     using SafeERC20 for IERC20;
215 
216     IERC20 private maticToken;
217     uint256 private tokensToVest = 0;
218     uint256 private vestingId = 0;
219 
220     string private constant INSUFFICIENT_BALANCE = "Insufficient balance";
221     string private constant INVALID_VESTING_ID = "Invalid vesting id";
222     string private constant VESTING_ALREADY_RELEASED = "Vesting already released";
223     string private constant INVALID_BENEFICIARY = "Invalid beneficiary address";
224     string private constant NOT_VESTED = "Tokens have not vested yet";
225 
226     struct Vesting {
227         uint256 releaseTime;
228         uint256 amount;
229         address beneficiary;
230         bool released;
231     }
232     mapping(uint256 => Vesting) public vestings;
233 
234     event TokenVestingReleased(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
235     event TokenVestingAdded(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
236     event TokenVestingRemoved(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
237 
238     constructor(IERC20 _token) public {
239         require(address(_token) != address(0x0), "Matic token address is not valid");
240         maticToken = _token;
241 
242         uint256 SCALING_FACTOR = 10 ** 18;
243         uint256 day = 1 days;
244 
245         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 0, 3230085552 * SCALING_FACTOR);
246         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 30 * day, 25000000 * SCALING_FACTOR);
247         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 61 * day, 25000000 * SCALING_FACTOR);
248         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 91 * day, 25000000 * SCALING_FACTOR);
249         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 122 * day, 25000000 * SCALING_FACTOR);
250         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 153 * day, 25000000 * SCALING_FACTOR);
251         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 183 * day, 1088418885 * SCALING_FACTOR);
252         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 214 * day, 25000000 * SCALING_FACTOR);
253         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 244 * day, 25000000 * SCALING_FACTOR);
254         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 275 * day, 25000000 * SCALING_FACTOR);
255         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 306 * day, 25000000 * SCALING_FACTOR);
256         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 335 * day, 25000000 * SCALING_FACTOR);
257         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 366 * day, 1218304816 * SCALING_FACTOR);
258         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 396 * day, 25000000 * SCALING_FACTOR);
259         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 427 * day, 25000000 * SCALING_FACTOR);
260         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 457 * day, 25000000 * SCALING_FACTOR);
261         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 488 * day, 25000000 * SCALING_FACTOR);
262         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 519 * day, 25000000 * SCALING_FACTOR);
263         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 549 * day, 1218304816 * SCALING_FACTOR);
264         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 580 * day, 25000000 * SCALING_FACTOR);
265         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 610 * day, 25000000 * SCALING_FACTOR);
266         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 641 * day, 25000000 * SCALING_FACTOR);
267         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 672 * day, 25000000 * SCALING_FACTOR);
268         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 700 * day, 25000000 * SCALING_FACTOR);
269         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 731 * day, 1084971483 * SCALING_FACTOR);
270         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 761 * day, 25000000 * SCALING_FACTOR);
271         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 792 * day, 25000000 * SCALING_FACTOR);
272         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 822 * day, 25000000 * SCALING_FACTOR);
273         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 853 * day, 25000000 * SCALING_FACTOR);
274         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 884 * day, 25000000 * SCALING_FACTOR);
275         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 914 * day, 618304816 * SCALING_FACTOR);
276         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 945 * day, 25000000 * SCALING_FACTOR);
277         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 975 * day, 25000000 * SCALING_FACTOR);
278         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 1096 * day, 593304816 * SCALING_FACTOR);
279         addVesting(0xb316fa9Fa91700D7084D377bfdC81Eb9F232f5Ff, now + 1279 * day, 273304816 * SCALING_FACTOR);
280     }
281 
282     function token() public view returns (IERC20) {
283         return maticToken;
284     }
285 
286     function beneficiary(uint256 _vestingId) public view returns (address) {
287         return vestings[_vestingId].beneficiary;
288     }
289 
290     function releaseTime(uint256 _vestingId) public view returns (uint256) {
291         return vestings[_vestingId].releaseTime;
292     }
293 
294     function vestingAmount(uint256 _vestingId) public view returns (uint256) {
295         return vestings[_vestingId].amount;
296     }
297 
298     function removeVesting(uint256 _vestingId) public onlyOwner {
299         Vesting storage vesting = vestings[_vestingId];
300         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
301         require(!vesting.released , VESTING_ALREADY_RELEASED);
302         vesting.released = true;
303         tokensToVest = tokensToVest.sub(vesting.amount);
304         emit TokenVestingRemoved(_vestingId, vesting.beneficiary, vesting.amount);
305     }
306 
307     function addVesting(address _beneficiary, uint256 _releaseTime, uint256 _amount) public onlyOwner {
308         require(_beneficiary != address(0x0), INVALID_BENEFICIARY);
309         tokensToVest = tokensToVest.add(_amount);
310         vestingId = vestingId.add(1);
311         vestings[vestingId] = Vesting({
312             beneficiary: _beneficiary,
313             releaseTime: _releaseTime,
314             amount: _amount,
315             released: false
316         });
317         emit TokenVestingAdded(vestingId, _beneficiary, _amount);
318     }
319 
320     function release(uint256 _vestingId) public {
321         Vesting storage vesting = vestings[_vestingId];
322         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
323         require(!vesting.released , VESTING_ALREADY_RELEASED);
324         // solhint-disable-next-line not-rely-on-time
325         require(block.timestamp >= vesting.releaseTime, NOT_VESTED);
326 
327         require(maticToken.balanceOf(address(this)) >= vesting.amount, INSUFFICIENT_BALANCE);
328         vesting.released = true;
329         tokensToVest = tokensToVest.sub(vesting.amount);
330         maticToken.safeTransfer(vesting.beneficiary, vesting.amount);
331         emit TokenVestingReleased(_vestingId, vesting.beneficiary, vesting.amount);
332     }
333 
334     function retrieveExcessTokens(uint256 _amount) public onlyOwner {
335         require(_amount <= maticToken.balanceOf(address(this)).sub(tokensToVest), INSUFFICIENT_BALANCE);
336         maticToken.safeTransfer(owner(), _amount);
337     }
338 }