1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeERC20
5  * @dev Wrappers around ERC20 operations that throw on failure.
6  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
7  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
8  */
9 library SafeERC20 {
10     using SafeMath for uint256;
11 
12     function safeTransfer(IERC20 token, address to, uint256 value) internal {
13         require(token.transfer(to, value));
14     }
15 
16     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
17         require(token.transferFrom(from, to, value));
18     }
19 
20     function safeApprove(IERC20 token, address spender, uint256 value) internal {
21         // safeApprove should only be called when setting an initial allowance,
22         // or when resetting it to zero. To increase and decrease it, use
23         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
24         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
25         require(token.approve(spender, value));
26     }
27 
28     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
29         uint256 newAllowance = token.allowance(address(this), spender).add(value);
30         require(token.approve(spender, newAllowance));
31     }
32 
33     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
34         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
35         require(token.approve(spender, newAllowance));
36     }
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Unsigned math operations with safety checks that revert on error
42  */
43 library SafeMath {
44     /**
45     * @dev Multiplies two unsigned integers, reverts on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
63     */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Solidity only automatically asserts when dividing by 0
66         require(b > 0);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Adds two unsigned integers, reverts on overflow.
85     */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a);
89 
90         return c;
91     }
92 
93     /**
94     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
95     * reverts when dividing by zero.
96     */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0);
99         return a % b;
100     }
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 interface IERC20 {
109     function transfer(address to, uint256 value) external returns (bool);
110 
111     function approve(address spender, uint256 value) external returns (bool);
112 
113     function transferFrom(address from, address to, uint256 value) external returns (bool);
114 
115     function totalSupply() external view returns (uint256);
116 
117     function balanceOf(address who) external view returns (uint256);
118 
119     function allowance(address owner, address spender) external view returns (uint256);
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 /**
128  * @title Ownable
129  * @dev The Ownable contract has an owner address, and provides basic authorization control
130  * functions, this simplifies the implementation of "user permissions".
131  */
132 contract Ownable {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
139      * account.
140      */
141     constructor () internal {
142         _owner = msg.sender;
143         emit OwnershipTransferred(address(0), _owner);
144     }
145 
146     /**
147      * @return the address of the owner.
148      */
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if called by any account other than the owner.
155      */
156     modifier onlyOwner() {
157         require(isOwner());
158         _;
159     }
160 
161     /**
162      * @return true if `msg.sender` is the owner of the contract.
163      */
164     function isOwner() public view returns (bool) {
165         return msg.sender == _owner;
166     }
167 
168     /**
169      * @dev Allows the current owner to relinquish control of the contract.
170      * @notice Renouncing to ownership will leave the contract without an owner.
171      * It will not be possible to call the functions with the `onlyOwner`
172      * modifier anymore.
173      */
174     function renounceOwnership() public onlyOwner {
175         emit OwnershipTransferred(_owner, address(0));
176         _owner = address(0);
177     }
178 
179     /**
180      * @dev Allows the current owner to transfer control of the contract to a newOwner.
181      * @param newOwner The address to transfer ownership to.
182      */
183     function transferOwnership(address newOwner) public onlyOwner {
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers control of the contract to a newOwner.
189      * @param newOwner The address to transfer ownership to.
190      */
191     function _transferOwnership(address newOwner) internal {
192         require(newOwner != address(0));
193         emit OwnershipTransferred(_owner, newOwner);
194         _owner = newOwner;
195     }
196 }
197 
198 
199 /**
200  * @title TokenVesting
201  * @dev A token holder contract that can release its token balance gradually like a
202  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
203  * owner.
204  */
205 contract TokenVesting is Ownable {
206     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
207     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
208     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a cliff
209     // period of a year and a duration of four years, are safe to use.
210     // solhint-disable not-rely-on-time
211 
212     using SafeMath for uint256;
213     using SafeERC20 for IERC20;
214 
215     event TokensReleased(address token, uint256 amount);
216     event TokenVestingRevoked(address token);
217 
218     // beneficiary of tokens after they are released
219     address private _beneficiary;
220 
221     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
222     uint256 private _cliff;
223     uint256 private _start;
224     uint256 private _duration;
225 
226     bool private _revocable;
227 
228     mapping (address => uint256) private _released;
229     mapping (address => bool) private _revoked;
230 
231        /**
232      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
233      * beneficiary, gradually in a linear fashion until start + duration. By then all
234      * of the balance will have vested.
235      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
236      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
237      * @param start the time (as Unix time) at which point vesting starts
238      * @param duration duration in seconds of the period in which the tokens will vest
239      * @param revocable whether the vesting is revocable or not
240      */
241     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
242         require(beneficiary != address(0));
243         require(cliffDuration <= duration);
244         require(duration > 0);
245         require(start.add(duration) > block.timestamp);
246 
247         _beneficiary = beneficiary;
248         _revocable = revocable;
249         _duration = duration;
250         _cliff = start.add(cliffDuration);
251         _start = start;
252     }
253 
254 
255     /**
256      * @return the beneficiary of the tokens.
257      */
258     function beneficiary() public view returns (address) {
259         return _beneficiary;
260     }
261 
262     /**
263      * @return the cliff time of the token vesting.
264      */
265     function cliff() public view returns (uint256) {
266         return _cliff;
267     }
268 
269     /**
270      * @return the start time of the token vesting.
271      */
272     function start() public view returns (uint256) {
273         return _start;
274     }
275 
276     /**
277      * @return the duration of the token vesting.
278      */
279     function duration() public view returns (uint256) {
280         return _duration;
281     }
282 
283     /**
284      * @return true if the vesting is revocable.
285      */
286     function revocable() public view returns (bool) {
287         return _revocable;
288     }
289 
290     /**
291      * @return the amount of the token released.
292      */
293     function released(address token) public view returns (uint256) {
294         return _released[token];
295     }
296 
297     /**
298      * @return true if the token is revoked.
299      */
300     function revoked(address token) public view returns (bool) {
301         return _revoked[token];
302     }
303 
304     /**
305      * @notice Transfers vested tokens to beneficiary.
306      * @param token ERC20 token which is being vested
307      */
308     function release(IERC20 token) public {
309         uint256 unreleased = _releasableAmount(token);
310 
311         require(unreleased > 0);
312 
313         _released[address(token)] = _released[address(token)].add(unreleased);
314 
315         token.safeTransfer(_beneficiary, unreleased);
316 
317         emit TokensReleased(address(token), unreleased);
318     }
319 
320     /**
321      * @notice Allows the owner to revoke the vesting. Tokens already vested
322      * remain in the contract, the rest are returned to the owner.
323      * @param token ERC20 token which is being vested
324      */
325     function revoke(IERC20 token) public onlyOwner {
326         require(_revocable);
327         require(!_revoked[address(token)]);
328 
329         uint256 balance = token.balanceOf(address(this));
330 
331         uint256 unreleased = _releasableAmount(token);
332         uint256 refund = balance.sub(unreleased);
333 
334         _revoked[address(token)] = true;
335 
336         token.safeTransfer(owner(), refund);
337 
338         emit TokenVestingRevoked(address(token));
339     }
340 
341     /**
342      * @dev Calculates the amount that has already vested but hasn't been released yet.
343      * @param token ERC20 token which is being vested
344      */
345     function _releasableAmount(IERC20 token) private view returns (uint256) {
346         return _vestedAmount(token).sub(_released[address(token)]);
347     }
348 
349     /**
350      * @dev Calculates the amount that has already vested.
351      * @param token ERC20 token which is being vested
352      */
353     function _vestedAmount(IERC20 token) private view returns (uint256) {
354         uint256 currentBalance = token.balanceOf(address(this));
355         uint256 totalBalance = currentBalance.add(_released[address(token)]);
356 
357         if (block.timestamp < _cliff) {
358             return 0;
359         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
360             return totalBalance;
361         } else {
362             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
363         }
364     }
365 }
366 
367 contract MineUnlock is TokenVesting{
368      constructor()
369         TokenVesting(
370             0x6F0Ac61E8533AD0972319a72297e54AEe85d7F8b,
371             1549296000,//2019/02/05 00:00:00
372             0,
373             432000000,//2019/02/05 00:00:00 ~ 2032/10/14 00:00:00
374             false
375         )
376      public {}
377 }