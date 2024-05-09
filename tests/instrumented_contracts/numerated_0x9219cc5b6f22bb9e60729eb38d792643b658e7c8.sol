1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that revert on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, reverts on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50     // benefit is lost if 'b' is also tested.
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52     if (a == 0) {
53       return 0;
54     }
55 
56     uint256 c = a * b;
57     require(c / a == b);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b > 0); // Solidity only automatically asserts when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70     return c;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b <= a);
78     uint256 c = a - b;
79 
80     return c;
81   }
82 
83   /**
84   * @dev Adds two numbers, reverts on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     require(c >= a);
89 
90     return c;
91   }
92 
93   /**
94   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
95   * reverts when dividing by zero.
96   */
97   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b != 0);
99     return a % b;
100   }
101 }
102 
103 
104 /**
105  * @title SafeERC20
106  * @dev Wrappers around ERC20 operations that throw on failure.
107  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
108  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
109  */
110 library SafeERC20 {
111 
112   using SafeMath for uint256;
113 
114   function safeTransfer(
115     IERC20 token,
116     address to,
117     uint256 value
118   )
119     internal
120   {
121     require(token.transfer(to, value));
122   }
123 
124   function safeTransferFrom(
125     IERC20 token,
126     address from,
127     address to,
128     uint256 value
129   )
130     internal
131   {
132     require(token.transferFrom(from, to, value));
133   }
134 
135   function safeApprove(
136     IERC20 token,
137     address spender,
138     uint256 value
139   )
140     internal
141   {
142     // safeApprove should only be called when setting an initial allowance, 
143     // or when resetting it to zero. To increase and decrease it, use 
144     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
145     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
146     require(token.approve(spender, value));
147   }
148 
149   function safeIncreaseAllowance(
150     IERC20 token,
151     address spender,
152     uint256 value
153   )
154     internal
155   {
156     uint256 newAllowance = token.allowance(address(this), spender).add(value);
157     require(token.approve(spender, newAllowance));
158   }
159 
160   function safeDecreaseAllowance(
161     IERC20 token,
162     address spender,
163     uint256 value
164   )
165     internal
166   {
167     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
168     require(token.approve(spender, newAllowance));
169   }
170 }
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address private _owner;
179 
180   event OwnershipTransferred(
181     address indexed previousOwner,
182     address indexed newOwner
183   );
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   constructor() internal {
190     _owner = msg.sender;
191     emit OwnershipTransferred(address(0), _owner);
192   }
193 
194   /**
195    * @return the address of the owner.
196    */
197   function owner() public view returns(address) {
198     return _owner;
199   }
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     require(isOwner());
206     _;
207   }
208 
209   /**
210    * @return true if `msg.sender` is the owner of the contract.
211    */
212   function isOwner() public view returns(bool) {
213     return msg.sender == _owner;
214   }
215 
216   /**
217    * @dev Allows the current owner to relinquish control of the contract.
218    * @notice Renouncing to ownership will leave the contract without an owner.
219    * It will not be possible to call the functions with the `onlyOwner`
220    * modifier anymore.
221    */
222   function renounceOwnership() public onlyOwner {
223     emit OwnershipTransferred(_owner, address(0));
224     _owner = address(0);
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address newOwner) public onlyOwner {
232     _transferOwnership(newOwner);
233   }
234 
235   /**
236    * @dev Transfers control of the contract to a newOwner.
237    * @param newOwner The address to transfer ownership to.
238    */
239   function _transferOwnership(address newOwner) internal {
240     require(newOwner != address(0));
241     emit OwnershipTransferred(_owner, newOwner);
242     _owner = newOwner;
243   }
244 }
245 
246 /**
247  * @title TokenVesting
248  * @dev A token holder contract that can release its token balance gradually like a
249  * typical vesting scheme, with a cliff and vesting period.
250  *
251  * Note you do not want to transfer tokens you have withdrawn back to this contract. This will
252  * result in some fraction of your transferred tokens being locked up again.
253  *
254  * Code taken from OpenZeppelin/openzeppelin-solidity at commit 4115686b4f8c1abf29f1f855eb15308076159959.
255  * (Revocation options removed by Reserve.)
256  */
257 contract TokenVesting is Ownable {
258   using SafeMath for uint256;
259   using SafeERC20 for IERC20;
260 
261   event TokensReleased(address token, uint256 amount);
262 
263   // beneficiary of tokens after they are released
264   address private _beneficiary;
265 
266   uint256 private _cliff;
267   uint256 private _start;
268   uint256 private _duration;
269 
270   mapping (address => uint256) private _released;
271   /**
272    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
273    * beneficiary, gradually in a linear fashion until start + duration. By then all
274    * of the balance will have vested.
275    * @param beneficiary address of the beneficiary to whom vested tokens are transferred
276    * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
277    * @param start the time (as Unix time) at which point vesting starts
278    * @param duration duration in seconds of the period in which the tokens will vest
279    */
280   constructor(
281     address beneficiary,
282     uint256 start,
283     uint256 cliffDuration,
284     uint256 duration
285   )
286     public
287   {
288     require(beneficiary != address(0));
289     require(cliffDuration <= duration);
290     require(duration > 0);
291     require(start.add(duration) > block.timestamp);
292 
293     _beneficiary = beneficiary;
294     _duration = duration;
295     _cliff = start.add(cliffDuration);
296     _start = start;
297   }
298 
299   /**
300    * @return the beneficiary of the tokens.
301    */
302   function beneficiary() public view returns(address) {
303     return _beneficiary;
304   }
305 
306   /**
307    * @return the cliff time of the token vesting.
308    */
309   function cliff() public view returns(uint256) {
310     return _cliff;
311   }
312 
313   /**
314    * @return the start time of the token vesting.
315    */
316   function start() public view returns(uint256) {
317     return _start;
318   }
319 
320   /**
321    * @return the duration of the token vesting.
322    */
323   function duration() public view returns(uint256) {
324     return _duration;
325   }
326 
327   /**
328    * @return the amount of the token released.
329    */
330   function released(address token) public view returns(uint256) {
331     return _released[token];
332   }
333 
334   /**
335    * @return the amount of token that can be released at the current block timestamp.
336    */
337   function releasable(address token) public view returns(uint256) {
338     return _releasableAmount(IERC20(token));
339   }
340 
341   /**
342    * @notice Transfers vested tokens to beneficiary.
343    * @param token ERC20 token which is being vested
344    */
345   function release(IERC20 token) public {
346     uint256 unreleased = _releasableAmount(token);
347 
348     require(unreleased > 0);
349 
350     _released[token] = _released[token].add(unreleased);
351 
352     token.safeTransfer(_beneficiary, unreleased);
353 
354     emit TokensReleased(token, unreleased);
355   }
356 
357   /**
358    * @dev Calculates the amount that has already vested but hasn't been released yet.
359    * @param token ERC20 token which is being vested
360    */
361   function _releasableAmount(IERC20 token) private view returns (uint256) {
362     return _vestedAmount(token).sub(_released[token]);
363   }
364 
365   /**
366    * @dev Calculates the amount that has already vested.
367    * @param token ERC20 token which is being vested
368    */
369   function _vestedAmount(IERC20 token) private view returns (uint256) {
370     uint256 currentBalance = token.balanceOf(this);
371     uint256 totalBalance = currentBalance.add(_released[token]);
372 
373     if (block.timestamp < _cliff) {
374       return 0;
375     } else if (block.timestamp >= _start.add(_duration)) {
376       return totalBalance;
377     } else {
378       return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
379     }
380   }
381 }