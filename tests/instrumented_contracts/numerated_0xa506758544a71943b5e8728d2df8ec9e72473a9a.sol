1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title SafeERC20
103  * @dev Wrappers around ERC20 operations that throw on failure.
104  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
105  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
106  */
107 library SafeERC20 {
108     using SafeMath for uint256;
109 
110     function safeTransfer(IERC20 token, address to, uint256 value) internal {
111         require(token.transfer(to, value));
112     }
113 
114     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
115         require(token.transferFrom(from, to, value));
116     }
117 
118     function safeApprove(IERC20 token, address spender, uint256 value) internal {
119         // safeApprove should only be called when setting an initial allowance,
120         // or when resetting it to zero. To increase and decrease it, use
121         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
122         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
123         require(token.approve(spender, value));
124     }
125 
126     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
127         uint256 newAllowance = token.allowance(address(this), spender).add(value);
128         require(token.approve(spender, newAllowance));
129     }
130 
131     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
132         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
133         require(token.approve(spender, newAllowance));
134     }
135 }
136 
137 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
138 
139 pragma solidity ^0.5.0;
140 
141 /**
142  * @title Helps contracts guard against reentrancy attacks.
143  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
144  * @dev If you mark a function `nonReentrant`, you should also
145  * mark it `external`.
146  */
147 contract ReentrancyGuard {
148     /// @dev counter to allow mutex lock with only one SSTORE operation
149     uint256 private _guardCounter;
150 
151     constructor () internal {
152         // The counter starts at one to prevent changing it from zero to a non-zero
153         // value, which is a more expensive operation.
154         _guardCounter = 1;
155     }
156 
157     /**
158      * @dev Prevents a contract from calling itself, directly or indirectly.
159      * Calling a `nonReentrant` function from another `nonReentrant`
160      * function is not supported. It is possible to prevent this from happening
161      * by making the `nonReentrant` function external, and make it call a
162      * `private` function that does the actual work.
163      */
164     modifier nonReentrant() {
165         _guardCounter += 1;
166         uint256 localCounter = _guardCounter;
167         _;
168         require(localCounter == _guardCounter);
169     }
170 }
171 
172 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
173 
174 pragma solidity ^0.5.0;
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     /**
187      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188      * account.
189      */
190     constructor () internal {
191         _owner = msg.sender;
192         emit OwnershipTransferred(address(0), _owner);
193     }
194 
195     /**
196      * @return the address of the owner.
197      */
198     function owner() public view returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(isOwner());
207         _;
208     }
209 
210     /**
211      * @return true if `msg.sender` is the owner of the contract.
212      */
213     function isOwner() public view returns (bool) {
214         return msg.sender == _owner;
215     }
216 
217     /**
218      * @dev Allows the current owner to relinquish control of the contract.
219      * @notice Renouncing to ownership will leave the contract without an owner.
220      * It will not be possible to call the functions with the `onlyOwner`
221      * modifier anymore.
222      */
223     function renounceOwnership() public onlyOwner {
224         emit OwnershipTransferred(_owner, address(0));
225         _owner = address(0);
226     }
227 
228     /**
229      * @dev Allows the current owner to transfer control of the contract to a newOwner.
230      * @param newOwner The address to transfer ownership to.
231      */
232     function transferOwnership(address newOwner) public onlyOwner {
233         _transferOwnership(newOwner);
234     }
235 
236     /**
237      * @dev Transfers control of the contract to a newOwner.
238      * @param newOwner The address to transfer ownership to.
239      */
240     function _transferOwnership(address newOwner) internal {
241         require(newOwner != address(0));
242         emit OwnershipTransferred(_owner, newOwner);
243         _owner = newOwner;
244     }
245 }
246 
247 // File: contracts/token/TokenPurchased.sol
248 
249 pragma solidity ^0.5.0;
250 
251 
252 
253 
254 
255 
256 contract TokensPurchased is ReentrancyGuard,Ownable  {
257     using SafeMath for uint256;
258     using SafeERC20 for IERC20;
259     IERC20 private token;
260 
261     uint256 public tokensSold;
262 
263     event EventPurchased(address _to, uint256 _value);
264     event EventAirdrop(address _to, uint256 _value);
265 
266     address payable _owner;
267 
268     constructor(IERC20 _token)
269         public
270     {
271         _owner = msg.sender;
272         token = IERC20(_token); 
273     }
274 
275     //contract에 eth가 전송되면 실행된다.
276     function () external payable{
277         buyTokens(msg.sender, msg.value);
278     }
279 
280 
281     function buyTokens(address _to, uint256 _amount) internal nonReentrant {   //whenNotPaused
282         validateCheck(_to, _amount*10000);
283 
284         //비율에 해당하여 token 전달 1eth = 10000 pla
285         token.safeTransfer(_to, _amount*10000); 
286 
287         //owner에게 eth 전송
288         _owner.transfer(address(this).balance);
289         emit EventPurchased(_to, _amount);
290     }
291 
292 
293     function airDrop(address _to, uint256 _amount) public nonReentrant onlyOwner { //whenNotPaused
294         validateCheck(_to, _amount);
295 
296         token.safeTransfer(_to, _amount); 
297         emit EventAirdrop(_to, _amount);
298     }
299 
300 
301     function validateCheck(address _to, uint256 _amount) internal view {
302         require(_to != address(0));
303         require(_amount > 0);
304         require(token.balanceOf(address(this)) >= _amount);
305     }
306 
307     /* 컨트랙트 계좌 잔액 확인 함수 */
308     /* eth를 owner에게 바로 전송하므로 필요없음 */
309     // function checkContractBalance() public onlyOwner view returns(uint) {
310     //     address _contract = this;
311     //     return _contract.balance;
312     // }
313 }