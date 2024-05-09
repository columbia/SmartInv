1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
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
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
145 
146 pragma solidity ^0.5.0;
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
172 pragma solidity ^0.5.0;
173 
174 
175 
176 /**
177  * @title SafeERC20
178  * @dev Wrappers around ERC20 operations that throw on failure.
179  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
180  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
181  */
182 library SafeERC20 {
183     using SafeMath for uint256;
184 
185     function safeTransfer(IERC20 token, address to, uint256 value) internal {
186         require(token.transfer(to, value));
187     }
188 
189     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
190         require(token.transferFrom(from, to, value));
191     }
192 
193     function safeApprove(IERC20 token, address spender, uint256 value) internal {
194         // safeApprove should only be called when setting an initial allowance,
195         // or when resetting it to zero. To increase and decrease it, use
196         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
197         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
198         require(token.approve(spender, value));
199     }
200 
201     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
202         uint256 newAllowance = token.allowance(address(this), spender).add(value);
203         require(token.approve(spender, newAllowance));
204     }
205 
206     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
207         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
208         require(token.approve(spender, newAllowance));
209     }
210 }
211 
212 // File: contracts/MaticTokenVesting.sol
213 
214 pragma solidity 0.5.2;
215 
216 
217 
218 
219 
220 
221 /**
222  * @title TokenVesting
223  * @dev A token holder contract that can release its token balance gradually like a
224  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
225  * owner.
226  */
227 contract MaticTokenVesting is Ownable {
228     using SafeMath for uint256;
229     using SafeERC20 for IERC20;
230 
231     IERC20 private maticToken;
232     uint256 private tokensToVest = 0;
233     uint256 private vestingId = 0;
234 
235     string private constant INSUFFICIENT_BALANCE = "Insufficient balance";
236     string private constant INVALID_VESTING_ID = "Invalid vesting id";
237     string private constant VESTING_ALREADY_RELEASED = "Vesting already released";
238     string private constant INVALID_BENEFICIARY = "Invalid beneficiary address";
239     string private constant NOT_VESTED = "Tokens have not vested yet";
240 
241     struct Vesting {
242         uint256 releaseTime;
243         uint256 amount;
244         address beneficiary;
245         bool released;
246     }
247     mapping(uint256 => Vesting) public vestings;
248 
249     event TokenVestingReleased(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
250     event TokenVestingAdded(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
251     event TokenVestingRemoved(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
252 
253     constructor(IERC20 _token) public {
254         require(address(_token) != address(0x0), "Matic token address is not valid");
255         maticToken = _token;
256 
257         uint256 SCALING_FACTOR = 10 ** 18;
258         uint256 day = 1 minutes;
259         day = day.div(15);
260         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 0, 3230085552 * SCALING_FACTOR);
261         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 30 * day, 25000000 * SCALING_FACTOR);
262         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 61 * day, 25000000 * SCALING_FACTOR);
263         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 91 * day, 25000000 * SCALING_FACTOR);
264         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 122 * day, 25000000 * SCALING_FACTOR);
265         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 153 * day, 25000000 * SCALING_FACTOR);
266         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 183 * day, 1088418885 * SCALING_FACTOR);
267         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 214 * day, 25000000 * SCALING_FACTOR);
268         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 244 * day, 25000000 * SCALING_FACTOR);
269         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 275 * day, 25000000 * SCALING_FACTOR);
270         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 306 * day, 25000000 * SCALING_FACTOR);
271         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 335 * day, 25000000 * SCALING_FACTOR);
272         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 366 * day, 1218304816 * SCALING_FACTOR);
273         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 396 * day, 25000000 * SCALING_FACTOR);
274         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 427 * day, 25000000 * SCALING_FACTOR);
275         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 457 * day, 25000000 * SCALING_FACTOR);
276         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 488 * day, 25000000 * SCALING_FACTOR);
277         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 519 * day, 25000000 * SCALING_FACTOR);
278         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 549 * day, 1218304816 * SCALING_FACTOR);
279         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 580 * day, 25000000 * SCALING_FACTOR);
280         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 610 * day, 25000000 * SCALING_FACTOR);
281         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 641 * day, 25000000 * SCALING_FACTOR);
282         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 672 * day, 25000000 * SCALING_FACTOR);
283         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 700 * day, 25000000 * SCALING_FACTOR);
284         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 731 * day, 1084971483 * SCALING_FACTOR);
285         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 761 * day, 25000000 * SCALING_FACTOR);
286         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 792 * day, 25000000 * SCALING_FACTOR);
287         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 822 * day, 25000000 * SCALING_FACTOR);
288         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 853 * day, 25000000 * SCALING_FACTOR);
289         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 884 * day, 25000000 * SCALING_FACTOR);
290         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 914 * day, 618304816 * SCALING_FACTOR);
291         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 945 * day, 25000000 * SCALING_FACTOR);
292         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 975 * day, 25000000 * SCALING_FACTOR);
293         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 1096 * day, 593304816 * SCALING_FACTOR);
294         addVesting(0x9fB29AAc15b9A4B7F17c3385939b007540f4d791, now + 1279 * day, 273304816 * SCALING_FACTOR);
295     }
296 
297     function token() public view returns (IERC20) {
298         return maticToken;
299     }
300 
301     function beneficiary(uint256 _vestingId) public view returns (address) {
302         return vestings[_vestingId].beneficiary;
303     }
304 
305     function releaseTime(uint256 _vestingId) public view returns (uint256) {
306         return vestings[_vestingId].releaseTime;
307     }
308 
309     function vestingAmount(uint256 _vestingId) public view returns (uint256) {
310         return vestings[_vestingId].amount;
311     }
312 
313     function removeVesting(uint256 _vestingId) public onlyOwner {
314         Vesting storage vesting = vestings[_vestingId];
315         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
316         require(!vesting.released , VESTING_ALREADY_RELEASED);
317         vesting.released = true;
318         tokensToVest = tokensToVest.sub(vesting.amount);
319         emit TokenVestingRemoved(_vestingId, vesting.beneficiary, vesting.amount);
320     }
321 
322     function addVesting(address _beneficiary, uint256 _releaseTime, uint256 _amount) public onlyOwner {
323         require(_beneficiary != address(0x0), INVALID_BENEFICIARY);
324         tokensToVest = tokensToVest.add(_amount);
325         vestingId = vestingId.add(1);
326         vestings[vestingId] = Vesting({
327             beneficiary: _beneficiary,
328             releaseTime: _releaseTime,
329             amount: _amount,
330             released: false
331         });
332         emit TokenVestingAdded(vestingId, _beneficiary, _amount);
333     }
334 
335     function release(uint256 _vestingId) public {
336         Vesting storage vesting = vestings[_vestingId];
337         require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
338         require(!vesting.released , VESTING_ALREADY_RELEASED);
339         // solhint-disable-next-line not-rely-on-time
340         require(block.timestamp >= vesting.releaseTime, NOT_VESTED);
341 
342         require(maticToken.balanceOf(address(this)) >= vesting.amount, INSUFFICIENT_BALANCE);
343         vesting.released = true;
344         tokensToVest = tokensToVest.sub(vesting.amount);
345         maticToken.safeTransfer(vesting.beneficiary, vesting.amount);
346         emit TokenVestingReleased(_vestingId, vesting.beneficiary, vesting.amount);
347     }
348 
349     function retrieveExcessTokens(uint256 _amount) public onlyOwner {
350         require(_amount <= maticToken.balanceOf(address(this)).sub(tokensToVest), INSUFFICIENT_BALANCE);
351         maticToken.safeTransfer(owner(), _amount);
352     }
353 }