1 // ETHYS Staking 
2 //
3 // Made possible by the KP4R Project.
4 
5 pragma solidity 0.6.6;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint);
9     function balanceOf(address account) external view returns (uint);
10     function transfer(address recipient, uint amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint);
12     function approve(address spender, uint amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint a, uint b) internal pure returns (uint) {
28         uint c = a + b;
29         require(c >= a, "add: +");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
43         uint c = a + b;
44         require(c >= a, errorMessage);
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot underflow.
56      */
57     function sub(uint a, uint b) internal pure returns (uint) {
58         return sub(a, b, "sub: -");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot underflow.
68      */
69     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
70         require(b <= a, errorMessage);
71         uint c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint a, uint b) internal pure returns (uint) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint c = a * b;
93         require(c / a == b, "mul: *");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint c = a * b;
115         require(c / a == b, errorMessage);
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers.
122      * Reverts on division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function div(uint a, uint b) internal pure returns (uint) {
132         return div(a, b, "div: /");
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers.
137      * Reverts with custom message on division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator. Note: this function uses a
140      * `revert` opcode (which leaves remaining gas untouched) while Solidity
141      * uses an invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint a, uint b) internal pure returns (uint) {
167         return mod(a, b, "mod: %");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 // SPDX-License-Identifier: MIT
188 
189 pragma solidity ^0.6.0;
190 
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address payable) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes memory) {
207         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
208         return msg.data;
209     }
210 }
211 
212 contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor () internal {
221         address msgSender = _msgSender();
222         _owner = msgSender;
223         emit OwnershipTransferred(address(0), msgSender);
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         require(_owner == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240 
241     /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 // y = f(x)
265 
266 // 5 = f(10)
267 // 185 = f(365)
268 // y = 1.87255 + 0.2985466*x + 0.001419838*x^2
269 
270 // ETHYS Staking v2 makes some simplifications and improvements to v1 staking.
271 // Modules can reference user data in this contract for more functionality. 
272 
273 contract StakingV2ETHYS is Ownable {
274     using SafeMath for uint256;
275     IERC20 public ethys;
276 
277     bool isClosed = false;
278 
279     // quadratic reward curve constants
280     // a + b*x + c*x^2
281     uint256 public A = 187255; // 1.87255
282     uint256 public B = 29854;  // 0.2985466*x
283     uint256 public C = 141;    // 0.001419838*x^2
284 
285     uint256 public maxDays = 365;
286     uint256 public minDays = 10;
287 
288     uint256 public totalStaked = 0;
289     uint256 public totalRewards = 0;
290 
291     uint256 public earlyExit = 0;
292 
293     struct StakeInfo {
294         uint256 reward;
295         uint256 initial;
296         uint256 payday;
297         uint256 startday;
298     }
299 
300     mapping (address=>StakeInfo) public stakes;
301 
302     address public curveSetter;
303     address public _pendingCurveSetter;
304 
305     modifier onlyCurveSetter {
306         require(
307             msg.sender == curveSetter,
308             "Only curveSetter can call this function."
309         );
310         _;
311     }
312 
313     constructor(address _ethys) public {
314         ethys = IERC20(_ethys);
315         curveSetter = msg.sender;
316     }
317 
318     function stake(uint256 _amount, uint256 _days) public {
319         require(_days > minDays, "less than minimum staking period");
320         require(_days < maxDays, "more than maximum staking period");
321         require(stakes[msg.sender].payday == 0, "already staked");
322         require(_amount > 100, "amount to small");
323         require(!isClosed, "staking is closed");
324 
325         // calculate reward
326         uint256 _reward = calculateReward(_amount, _days);
327 
328         // contract must have funds to keep this commitment
329         require(ethys.balanceOf(address(this)) > totalOwedValue().add(_reward).add(_amount), "insufficient contract bal");
330 
331         require(ethys.transferFrom(msg.sender, address(this), _amount), "transfer failed");
332 
333         stakes[msg.sender].payday = block.timestamp.add(_days * (1 days));
334         stakes[msg.sender].reward = _reward;
335         stakes[msg.sender].startday = block.timestamp;
336         stakes[msg.sender].initial = _amount;
337 
338         // update stats
339         totalStaked = totalStaked.add(_amount);
340         totalRewards = totalRewards.add(_reward);
341     }
342 
343     function claim() public {
344         require(owedBalance(msg.sender) > 0, "nothing to claim");
345         require(block.timestamp > stakes[msg.sender].payday.sub(earlyExit), "too early");
346 
347         uint256 owed = stakes[msg.sender].reward.add(stakes[msg.sender].initial);
348 
349         // update stats
350         totalStaked = totalStaked.sub(stakes[msg.sender].initial);
351         totalRewards = totalRewards.sub(stakes[msg.sender].reward);
352 
353         stakes[msg.sender].initial = 0;
354         stakes[msg.sender].reward = 0;
355         stakes[msg.sender].payday = 0;
356         stakes[msg.sender].startday = 0;
357 
358         require(ethys.transfer(msg.sender, owed), "transfer failed");
359     }
360 
361     function calculateReward(uint256 _amount, uint256 _days) public view returns (uint256) {
362         uint256 _multiplier = _quadraticRewardCurveY(_days);
363         uint256 _AY = _amount.mul(_multiplier);
364         return _AY.div(10000000);
365 
366     }
367 
368     // a + b*x + c*x^2
369     function _quadraticRewardCurveY(uint256 _x) public view returns (uint256) {
370         uint256 _bx = _x.mul(B);
371         uint256 _x2 = _x.mul(_x);
372         uint256 _cx2 = C.mul(_x2);
373         return A.add(_bx).add(_cx2);
374     }
375 
376     // helpers:
377     function totalOwedValue() public view returns (uint256) {
378         return totalStaked.add(totalRewards);
379     }
380 
381     function owedBalance(address acc) public view returns(uint256) {
382         return stakes[acc].initial.add(stakes[acc].reward);
383     }
384 
385     // owner functions:
386     function setLimits(uint256 _minDays, uint256 _maxDays) public onlyOwner {
387         minDays = _minDays;
388         maxDays = _maxDays;
389     }
390 
391     function setEarlyExit(uint256 _earlyExit) public onlyOwner {
392         require(_earlyExit < 1604334278, "too big");
393         close(true);
394         earlyExit = _earlyExit;
395     }
396 
397     function close(bool closed) public onlyOwner {
398         isClosed = closed;
399     }
400 
401     function ownerReclaim(uint256 _amount) public onlyOwner {
402         require(_amount < ethys.balanceOf(address(this)).sub(totalOwedValue()), "cannot withdraw owed funds");
403         ethys.transfer(msg.sender, _amount);
404     }
405 
406     function flushETH() public onlyOwner {
407         uint256 bal = address(this).balance.sub(1);
408         msg.sender.transfer(bal);
409     }
410 
411     // curve setter functions 
412     function transferCurveSetterRole(address _new) public onlyCurveSetter {
413         _pendingCurveSetter = _new;
414     }
415 
416     function acceptCurveSetterRole() public {
417         require(msg.sender == _pendingCurveSetter, "only new curve setter can accept this role");
418         curveSetter = _pendingCurveSetter;
419     }
420 
421     function renounceCurveSetterRole() public onlyCurveSetter {
422         curveSetter = address(0);
423         _pendingCurveSetter = address(0);
424     }
425 
426     function setCurve(uint256 _A, uint256 _B, uint256 _C) public onlyCurveSetter {
427         A = _A;
428         B = _B;
429         C = _C;
430     }
431 
432 
433 }