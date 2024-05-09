1 pragma solidity 0.5.3;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title SafeERC20
91  * @dev Wrappers around ERC20 operations that throw on failure.
92  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
93  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
94  */
95 library SafeERC20 {
96     using SafeMath for uint256;
97 
98     function safeTransfer(IERC20 token, address to, uint256 value) internal {
99         require(token.transfer(to, value));
100     }
101 
102     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
103         require(token.transferFrom(from, to, value));
104     }
105 
106     function safeApprove(IERC20 token, address spender, uint256 value) internal {
107         // safeApprove should only be called when setting an initial allowance,
108         // or when resetting it to zero. To increase and decrease it, use
109         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
110         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
111         require(token.approve(spender, value));
112     }
113 
114     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
115         uint256 newAllowance = token.allowance(address(this), spender).add(value);
116         require(token.approve(spender, newAllowance));
117     }
118 
119     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
121         require(token.approve(spender, newAllowance));
122     }
123 }
124 
125 /**
126  * @title Ownable
127  * @dev The Ownable contract has an owner address, and provides basic authorization control
128  * functions, this simplifies the implementation of "user permissions".
129  */
130 contract Ownable {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137      * account.
138      */
139     constructor () internal {
140         _owner = msg.sender;
141         emit OwnershipTransferred(address(0), _owner);
142     }
143 
144     /**
145      * @return the address of the owner.
146      */
147     function owner() public view returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(isOwner());
156         _;
157     }
158 
159     /**
160      * @return true if `msg.sender` is the owner of the contract.
161      */
162     function isOwner() public view returns (bool) {
163         return msg.sender == _owner;
164     }
165 
166     /**
167      * @dev Allows the current owner to relinquish control of the contract.
168      * @notice Renouncing to ownership will leave the contract without an owner.
169      * It will not be possible to call the functions with the `onlyOwner`
170      * modifier anymore.
171      */
172     function renounceOwnership() public onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     /**
178      * @dev Allows the current owner to transfer control of the contract to a newOwner.
179      * @param newOwner The address to transfer ownership to.
180      */
181     function transferOwnership(address newOwner) public onlyOwner {
182         _transferOwnership(newOwner);
183     }
184 
185     /**
186      * @dev Transfers control of the contract to a newOwner.
187      * @param newOwner The address to transfer ownership to.
188      */
189     function _transferOwnership(address newOwner) internal {
190         require(newOwner != address(0));
191         emit OwnershipTransferred(_owner, newOwner);
192         _owner = newOwner;
193     }
194 }
195 
196 /**
197  * @title TokenDistributor
198  * @dev This contract is a token holder contract that will 
199  * allow beneficiaries to release the tokens in ten six-months period intervals.
200  */
201 contract TokenDistributor is Ownable {
202     using SafeMath for uint256;
203     using SafeERC20 for IERC20;
204 
205     event TokensReleased(address account, uint256 amount);
206 
207     // ERC20 basic token contract being held
208     IERC20 private _token;
209 
210     // timestamp when token release is enabled
211     uint256 private _releaseTime;
212 
213     uint256 private _totalReleased;
214     mapping(address => uint256) private _released;
215 
216     // beneficiary of tokens that are released
217     address private _beneficiary1;
218     address private _beneficiary2;
219     address private _beneficiary3;
220     address private _beneficiary4;
221 
222     uint256 public releasePerStep = uint256(1000000) * 10 ** 18;
223 
224     /**
225      * @dev Constructor
226      */
227     constructor (IERC20 token, uint256 releaseTime, address beneficiary1, address beneficiary2, address beneficiary3, address beneficiary4) public {
228         _token = token;
229         _releaseTime = releaseTime;
230         _beneficiary1 = beneficiary1;
231         _beneficiary2 = beneficiary2;
232         _beneficiary3 = beneficiary3;
233         _beneficiary4 = beneficiary4;
234     }
235 
236     /**
237      * @return the token being held.
238      */
239     function token() public view returns (IERC20) {
240         return _token;
241     }
242 
243     /**
244      * @return the total amount already released.
245      */
246     function totalReleased() public view returns (uint256) {
247         return _totalReleased;
248     }
249 
250     /**
251      * @return the amount already released to an account.
252      */
253     function released(address account) public view returns (uint256) {
254         return _released[account];
255     }
256 
257     /**
258      * @return the beneficiary1 of the tokens.
259      */
260     function beneficiary1() public view returns (address) {
261         return _beneficiary1;
262     }
263 
264     /**
265      * @return the beneficiary2 of the tokens.
266      */
267     function beneficiary2() public view returns (address) {
268         return _beneficiary2;
269     }
270 
271     /**
272      * @return the beneficiary3 of the tokens.
273      */
274     function beneficiary3() public view returns (address) {
275         return _beneficiary3;
276     }
277 
278     /**
279      * @return the beneficiary4 of the tokens.
280      */
281     function beneficiary4() public view returns (address) {
282         return _beneficiary4;
283     }
284 
285     /**
286      * @return the time when the tokens are released.
287      */
288     function releaseTime() public view returns (uint256) {
289         return _releaseTime;
290     }
291 
292     /**
293      * @dev Release one of the beneficiary's tokens.
294      * @param account Whose tokens will be sent to.
295      * @param amount Value in wei to send to the account.
296      */
297     function releaseToAccount(address account, uint256 amount) internal {
298         require(amount != 0, 'The amount must be greater than zero.');
299 
300         _released[account] = _released[account].add(amount);
301         _totalReleased = _totalReleased.add(amount);
302 
303         _token.safeTransfer(account, amount);
304         emit TokensReleased(account, amount);
305     }
306 
307     /**
308      * @notice Transfers 1000000 tokens in each interval(six-months timelocks) to beneficiaries.
309      */
310     function release() onlyOwner public {
311         require(block.timestamp >= releaseTime(), 'Team�s tokens can be released every six months.');
312 
313         uint256 _value1 = releasePerStep.mul(10).div(100);      //10%
314         uint256 _value2 = releasePerStep.mul(68).div(100);      //68%
315         uint256 _value3 = releasePerStep.mul(12).div(100);      //12%
316         uint256 _value4 = releasePerStep.mul(10).div(100);      //10%
317 
318         _releaseTime = _releaseTime.add(180 days);
319 
320         releaseToAccount(_beneficiary1, _value1);
321         releaseToAccount(_beneficiary2, _value2);
322         releaseToAccount(_beneficiary3, _value3);
323         releaseToAccount(_beneficiary4, _value4);
324     }
325 }