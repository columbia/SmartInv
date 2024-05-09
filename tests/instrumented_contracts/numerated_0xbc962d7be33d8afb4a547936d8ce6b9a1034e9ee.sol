1 //"SPDX-License-Identifier: UNLICENSED"
2 
3 pragma solidity ^0.6.6;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      */
166     function isContract(address account) internal view returns (bool) {
167         // This method relies on extcodesize, which returns 0 for contracts in
168         // construction, since the code is only stored at the end of the
169         // constructor execution.
170 
171         uint256 size;
172         // solhint-disable-next-line no-inline-assembly
173         assembly { size := extcodesize(account) }
174         return size > 0;
175     }
176 }
177 
178 interface IERC20 {
179   /**
180    * @dev Returns the amount of tokens in existence.
181    */
182   function totalSupply() external view returns (uint256);
183 
184   /**
185    * @dev Returns the amount of tokens owned by `account`.
186    */
187   function balanceOf(address account) external view returns (uint256);
188 
189   /**
190    * @dev Moves `amount` tokens from the caller's account to `recipient`.
191    *
192    * Returns a boolean value indicating whether the operation succeeded.
193    *
194    * Emits a {Transfer} event.
195    */
196   function transfer(address recipient, uint256 amount) external returns (bool);
197 
198   /**
199    * @dev Returns the remaining number of tokens that `spender` will be
200    * allowed to spend on behalf of `owner` through {transferFrom}. This is
201    * zero by default.
202    *
203    * This value changes when {approve} or {transferFrom} are called.
204    */
205   function allowance(address owner, address spender)
206     external
207     view
208     returns (uint256);
209 
210   /**
211    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
212    *
213    * Returns a boolean value indicating whether the operation succeeded.
214    *
215    * IMPORTANT: Beware that changing an allowance with this method brings the risk
216    * that someone may use both the old and the new allowance by unfortunate
217    * transaction ordering. One possible solution to mitigate this race
218    * condition is to first reduce the spender's allowance to 0 and set the
219    * desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    *
222    * Emits an {Approval} event.
223    */
224   function approve(address spender, uint256 amount) external returns (bool);
225 
226   /**
227    * @dev Moves `amount` tokens from `sender` to `recipient` using the
228    * allowance mechanism. `amount` is then deducted from the caller's
229    * allowance.
230    *
231    * Returns a boolean value indicating whether the operation succeeded.
232    *
233    * Emits a {Transfer} event.
234    */
235   function transferFrom(
236     address sender,
237     address recipient,
238     uint256 amount
239   ) external returns (bool);
240 
241   /**
242    * @dev Emitted when `value` tokens are moved from one account (`from`) to
243    * another (`to`).
244    *
245    * Note that `value` may be zero.
246    */
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 
249   /**
250    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251    * a call to {approve}. `value` is the new allowance.
252    */
253   event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 contract Multiplier{
257     //instantiating SafeMath library
258     using SafeMath for uint;
259     
260     //instance of utility token
261     IERC20 private _token;
262     
263     //struct
264     struct User {
265         uint balance;
266         uint release;
267         address approved;
268     }
269     
270     //address to User mapping
271     mapping(address => User) private _users;
272     
273     //multiplier constance for multiplying rewards
274     uint private constant _MULTIPLIER_CEILING = 2;
275     
276     //events
277     event Deposited(address indexed user, uint amount);
278     event Withdrawn(address indexed user, uint amount, uint time);
279     event NewLockup(address indexed poolstake, address indexed user, uint lockup);
280     event ContractApproved(address indexed user, address contractAddress);
281     
282     /* 
283      * @dev instantiate the multiplier.
284      * --------------------------------
285      * @param token--> the token that will be locked up.
286      */    
287     constructor(address token) public {
288         require(token != address(0), "token must not be the zero address");
289         _token = IERC20(token);
290     }
291 
292     /* 
293      * @dev top up the available balance.
294      * --------------------------------
295      * @param _amount --> the amount to lock up.
296      * -------------------------------
297      * returns whether successfully topped up or not.
298      */  
299     function deposit(uint _amount) external returns(bool) {
300         
301         require(_amount > 0, "amount must be larger than zero");
302         
303         require(_token.transferFrom(msg.sender, address(this), _amount), "amount must be approved");
304         _users[msg.sender].balance = balance(msg.sender).add(_amount);
305         
306         emit Deposited(msg.sender, _amount);
307         return true;
308     }
309     
310     /* 
311      * @dev approve a contract to use Multiplier
312      * -------------------------------------------
313      * @param _traditional --> the contract address to approve
314      * -------------------------------------------------------
315      * returns whether successfully approved or not
316      */ 
317     function approveContract(address _traditional) external returns(bool) {
318         
319         require(_users[msg.sender].approved != _traditional, "already approved");
320         require(Address.isContract(_traditional), "can only approve a contract");
321         
322         _users[msg.sender].approved = _traditional;
323         
324         emit ContractApproved(msg.sender, _traditional);
325         return true;
326     } 
327     
328     /* 
329      * @dev withdraw released multiplier balance.
330      * ----------------------------------------
331      * @param _amount --> the amount to be withdrawn.
332      * -------------------------------------------
333      * returns whether successfully withdrawn or not.
334      */
335     function withdraw(uint _amount) external returns(bool) {
336         
337         require(now >= _users[msg.sender].release, "must wait for release");
338         require(_amount > 0, "amount must be larger than zero");
339         require(balance(msg.sender) >= _amount, "must have a sufficient balance");
340         
341         _users[msg.sender].balance = balance(msg.sender).sub(_amount);
342         require(_token.transfer(msg.sender, _amount), "token transfer failed");
343         
344         emit Withdrawn(msg.sender, _amount, now);
345         return true;
346     }
347     
348     /* 
349      * @dev updates the lockup period (called by pool contract)
350      * ----------------------------------------------------------
351      * IMPORTANT - can only be used to increase lockup
352      * -----------------------------------------------
353      * @param _lockup --> the vesting period
354      * -------------------------------------------
355      * returns whether successfully withdrawn or not.
356      */
357     function updateLockupPeriod(address _user, uint _lockup) external returns(bool) {
358         
359         require(Address.isContract(msg.sender), "only a smart contract can call");
360         require(_users[_user].approved == msg.sender, "contract is not approved");
361         require(now.add(_lockup) > _users[_user].release, "cannot reduce current lockup");
362         
363         _users[_user].release = now.add(_lockup);
364         
365         emit NewLockup(msg.sender, _user, _lockup);
366         return true;
367     }
368     
369     /* 
370      * @dev get the multiplier ceiling for percentage calculations.
371      * ----------------------------------------------------------
372      * returns the multiplication factor.
373      */     
374     function getMultiplierCeiling() external pure returns(uint) {
375         
376         return _MULTIPLIER_CEILING;
377     }
378 
379     /* 
380      * @dev get the multiplier user balance.
381      * -----------------------------------
382      * @param _user --> the address of the user.
383      * ---------------------------------------
384      * returns the multiplier balance.
385      */ 
386     function balance(address _user) public view returns(uint) {
387         
388         return _users[_user].balance;
389     }
390     
391     /* 
392      * @dev get the approved Traditional contract address
393      * --------------------------------------------------
394      * @param _user --> the address of the user
395      * ----------------------------------------
396      * returns the approved contract address
397      */ 
398     function approvedContract(address _user) external view returns(address) {
399         
400         return _users[_user].approved;
401     }
402     
403     /* 
404      * @dev get the release of the multiplier balance.
405      * ---------------------------------------------
406      * @param user --> the address of the user.
407      * ---------------------------------------
408      * returns the release timestamp.
409      */     
410     function lockupPeriod(address _user) external view returns(uint) {
411         
412         uint release = _users[_user].release;
413         if (release > now) return (release.sub(now));
414         else return 0;
415     }
416 }