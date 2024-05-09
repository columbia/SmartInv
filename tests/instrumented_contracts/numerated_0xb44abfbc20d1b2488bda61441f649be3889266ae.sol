1 pragma solidity ^0.5.2;
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
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96     address private _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /**
101      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102      * account.
103      */
104     constructor () internal {
105         _owner = msg.sender;
106         emit OwnershipTransferred(address(0), _owner);
107     }
108 
109     /**
110      * @return the address of the owner.
111      */
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     /**
117      * @dev Throws if called by any account other than the owner.
118      */
119     modifier onlyOwner() {
120         require(isOwner());
121         _;
122     }
123 
124     /**
125      * @return true if `msg.sender` is the owner of the contract.
126      */
127     function isOwner() public view returns (bool) {
128         return msg.sender == _owner;
129     }
130 
131     /**
132      * @dev Allows the current owner to relinquish control of the contract.
133      * @notice Renouncing to ownership will leave the contract without an owner.
134      * It will not be possible to call the functions with the `onlyOwner`
135      * modifier anymore.
136      */
137     function renounceOwnership() public onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     /**
143      * @dev Allows the current owner to transfer control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function transferOwnership(address newOwner) public onlyOwner {
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers control of the contract to a newOwner.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function _transferOwnership(address newOwner) internal {
155         require(newOwner != address(0));
156         emit OwnershipTransferred(_owner, newOwner);
157         _owner = newOwner;
158     }
159 }
160 
161 
162 
163 /**
164  * @title TokenVesting
165  * @dev A token holder contract that can release its token balance gradually like a
166  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
167  * owner.
168  */
169 contract TokenVesting is Ownable {
170     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
171     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree).Therefore,
172     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
173     // cliff period of a year and a duration of four years, are safe to use.
174     // solhint-disable not-rely-on-time
175 
176     using SafeMath for uint256;
177 
178     event TokensReleased(address token, uint256 amount);
179     event TokenVestingRevoked(address token);
180 
181     // beneficiary of tokens after they are released
182     address private _beneficiary;
183 
184     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
185     uint256 private _cliff;
186     uint256 private _start;
187     uint256 private _duration;
188 
189     bool private _revocable;
190 
191     mapping (address => uint256) private _released;
192     mapping (address => bool) private _revoked;
193 
194     /**
195      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
196      * beneficiary, gradually in a linear fashion until start + duration. By then all
197      * of the balance will have vested.
198      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
199      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
200      * @param start the time (as Unix time) at which point vesting starts
201      * @param duration duration in seconds of the period in which the tokens will vest
202      * @param revocable whether the vesting is revocable or not
203      */
204     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
205         require(beneficiary != address(0));
206         require(cliffDuration <= duration);
207         require(duration > 0);
208         require(start.add(duration) > block.timestamp);
209 
210         _beneficiary = beneficiary;
211         _revocable = revocable;
212         _duration = duration;
213         _cliff = start.add(cliffDuration);
214         _start = start;
215     }
216 
217     /**
218      * @return the beneficiary of the tokens.
219      */
220     function beneficiary() public view returns (address) {
221         return _beneficiary;
222     }
223 
224     /**
225      * @return the cliff time of the token vesting.
226      */
227     function cliff() public view returns (uint256) {
228         return _cliff;
229     }
230 
231     /**
232      * @return the start time of the token vesting.
233      */
234     function start() public view returns (uint256) {
235         return _start;
236     }
237 
238     /**
239      * @return the duration of the token vesting.
240      */
241     function duration() public view returns (uint256) {
242         return _duration;
243     }
244 
245     /**
246      * @return true if the vesting is revocable.
247      */
248     function revocable() public view returns (bool) {
249         return _revocable;
250     }
251 
252     /**
253      * @return the amount of the token released.
254      */
255     function released(address token) public view returns (uint256) {
256         return _released[token];
257     }
258 
259     /**
260      * @return true if the token is revoked.
261      */
262     function revoked(address token) public view returns (bool) {
263         return _revoked[token];
264     }
265 
266     /**
267      * @notice Transfers vested tokens to beneficiary.
268      * @param token ERC20 token which is being vested
269      */
270     function release(IERC20 token) public {
271         uint256 unreleased = _releasableAmount(token);
272 
273         require(unreleased > 0);
274 
275         _released[address(token)] = _released[address(token)].add(unreleased);
276 
277         token.transfer(_beneficiary, unreleased);
278 
279         emit TokensReleased(address(token), unreleased);
280     }
281 
282     /**
283      * @notice Allows the owner to revoke the vesting. Tokens already vested
284      * remain in the contract, the rest are returned to the owner.
285      * @param token ERC20 token which is being vested
286      */
287     function revoke(IERC20 token) public onlyOwner {
288         require(_revocable);
289         require(!_revoked[address(token)]);
290 
291         uint256 balance = token.balanceOf(address(this));
292 
293         uint256 unreleased = _releasableAmount(token);
294         uint256 refund = balance.sub(unreleased);
295 
296         _revoked[address(token)] = true;
297 
298         token.transfer(owner(), refund);
299 
300         emit TokenVestingRevoked(address(token));
301     }
302 
303     /**
304      * @dev Calculates the amount that has already vested but hasn't been released yet.
305      * @param token ERC20 token which is being vested
306      */
307     function _releasableAmount(IERC20 token) private view returns (uint256) {
308         return _vestedAmount(token).sub(_released[address(token)]);
309     }
310 
311     /**
312      * @dev Calculates the amount that has already vested.
313      * @param token ERC20 token which is being vested
314      */
315     function _vestedAmount(IERC20 token) private view returns (uint256) {
316         uint256 currentBalance = token.balanceOf(address(this));
317         uint256 totalBalance = currentBalance.add(_released[address(token)]);
318 
319         if (block.timestamp < _cliff) {
320             return 0;
321         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
322             return totalBalance;
323         } else {
324             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
325         }
326     }
327 }