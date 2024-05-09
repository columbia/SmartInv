1 /*
2 
3 * @dev This is the Axia Protocol Staking pool 2 contract (Defi Fund Pool), 
4 * a part of the protocol where stakers are rewarded in AXIA tokens 
5 * when they make stakes of liquidity tokens from the oracle pool.
6 
7 * stakers reward come from the daily emission from the total supply into circulation,
8 * this happens daily and upon the reach of a new epoch each made of 180 days, 
9 * halvings are experienced on the emitting amount of tokens.
10 
11 * on the 11th epoch all the tokens would have been completed emitted into circulation,
12 * from here on, the stakers will still be earning from daily emissions
13 * which would now be coming from the accumulated basis points over the epochs.
14 
15 * stakers are not charged any fee for unstaking.
16 
17 
18 */
19 pragma solidity 0.6.4;
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      *
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57  
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the multiplication of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `*` operator.
94      *
95      * Requirements:
96      *
97      * - Multiplication cannot overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b > 0, errorMessage);
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return mod(a, b, "SafeMath: modulo by zero");
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts with custom message when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 
184 
185 contract DSP{
186     
187     using SafeMath for uint256;
188     
189 //======================================EVENTS=========================================//
190     event StakeEvent(address indexed staker, address indexed pool, uint amount);
191     event UnstakeEvent(address indexed unstaker, address indexed pool, uint amount);
192     event RewardEvent(address indexed staker, address indexed pool, uint amount);
193     event RewardStake(address indexed staker, address indexed pool, uint amount);
194     
195     
196 //======================================STAKING POOLS=========================================//
197     address public Axiatoken;
198     address public DefiIndexFunds;
199     
200     address public administrator;
201     
202     bool public stakingEnabled;
203     
204     uint256 constant private FLOAT_SCALAR = 2**64;
205     uint256 public MINIMUM_STAKE = 1000000000000000000; // 1 minimum
206 	uint256 public MIN_DIVIDENDS_DUR = 18 hours;
207 	
208 	uint public infocheck;
209     
210     struct User {
211 		uint256 balance;
212 		uint256 frozen;
213 		int256 scaledPayout;  
214 		uint256 staketime;
215 	}
216 
217 	struct Info {
218 		uint256 totalSupply;
219 		uint256 totalFrozen;
220 		mapping(address => User) users;
221 		uint256 scaledPayoutPerToken; //pool balance 
222 		address admin;
223 	}
224 	
225 	Info private info;
226 	
227 	
228 	constructor() public {
229 	    
230         info.admin = msg.sender;
231         stakingEnabled = false;
232 	}
233 
234 //======================================ADMINSTRATION=========================================//
235 
236 	modifier onlyCreator() {
237         require(msg.sender == info.admin, "Ownable: caller is not the administrator");
238         _;
239     }
240     
241     modifier onlyAxiaToken() {
242         require(msg.sender == Axiatoken, "Authorization: only token contract can call");
243         _;
244     }
245     
246 	 function tokenconfigs(address _axiatoken, address _defiindex) public onlyCreator returns (bool success) {
247         require(_axiatoken != _defiindex, "Insertion of same address is not supported");
248         require(_axiatoken != address(0) && _defiindex != address(0), "Insertion of address(0) is not supported");
249         Axiatoken = _axiatoken;
250         DefiIndexFunds = _defiindex;
251         return true;
252     }
253 	
254 	function _minStakeAmount(uint256 _number) onlyCreator public {
255 		
256 		MINIMUM_STAKE = _number*1000000000000000000;
257 		
258 	}
259 	
260 	function stakingStatus(bool _status) public onlyCreator {
261 	    require(Axiatoken != address(0) && DefiIndexFunds != address(0), "Pool addresses are not yet setup");
262 	stakingEnabled = _status;
263     }
264     
265     
266     function MIN_DIVIDENDS_DUR_TIME(uint256 _minDuration) public onlyCreator {
267         
268 	MIN_DIVIDENDS_DUR = _minDuration;
269 	
270     }
271     
272 //======================================USER WRITE=========================================//
273 
274 	function StakeTokens(uint256 _tokens) external {
275 		_stake(_tokens);
276 	}
277 	
278 	function UnstakeTokens(uint256 _tokens) external {
279 		_unstake(_tokens);
280 	}
281     
282 
283 //======================================USER READ=========================================//
284 
285 	function totalFrozen() public view returns (uint256) {
286 		return info.totalFrozen;
287 	}
288 	
289     function frozenOf(address _user) public view returns (uint256) {
290 		return info.users[_user].frozen;
291 	}
292 
293 	function dividendsOf(address _user) public view returns (uint256) {
294 	    
295 	    if(info.users[_user].staketime < MIN_DIVIDENDS_DUR){
296 	        return 0;
297 	    }else{
298 	     return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;   
299 	    }
300 	    
301 	}
302 	
303 
304 	function userData(address _user) public view 
305 	returns (uint256 totalTokensFrozen, uint256 userFrozen, 
306 	uint256 userDividends, uint256 userStaketime, int256 scaledPayout) {
307 	    
308 		return (totalFrozen(), frozenOf(_user), dividendsOf(_user), info.users[_user].staketime, info.users[_user].scaledPayout);
309 	
310 	    
311 	}
312 	
313 
314 //======================================ACTION CALLS=========================================//	
315 	
316 	function _stake(uint256 _amount) internal {
317 	    
318 	    require(stakingEnabled, "Staking not yet initialized");
319 	    
320 		require(IERC20(DefiIndexFunds).balanceOf(msg.sender) >= _amount, "Insufficient DeFi AFT balance");
321 		require(frozenOf(msg.sender) + _amount >= MINIMUM_STAKE, "Your amount is lower than the minimum amount allowed to stake");
322 		require(IERC20(DefiIndexFunds).allowance(msg.sender, address(this)) >= _amount, "Not enough allowance given to contract yet to spend by user");
323 		
324 		info.users[msg.sender].staketime = now;
325 		info.totalFrozen += _amount;
326 		info.users[msg.sender].frozen += _amount;
327 		
328 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken); 
329 		IERC20(DefiIndexFunds).transferFrom(msg.sender, address(this), _amount);      // Transfer liquidity tokens from the sender to this contract
330 		
331         emit StakeEvent(msg.sender, address(this), _amount);
332 	}
333 	
334     
335     
336  
337 	function _unstake(uint256 _amount) internal {
338 	    
339 		require(frozenOf(msg.sender) >= _amount, "You currently do not have up to that amount staked");
340 		
341 		info.totalFrozen -= _amount;
342 		info.users[msg.sender].frozen -= _amount;
343 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
344 		
345 		require(IERC20(DefiIndexFunds).transfer(msg.sender, _amount), "Transaction failed");
346         emit UnstakeEvent(address(this), msg.sender, _amount);
347 		
348 		TakeDividends();
349 	}
350 	
351 		
352 	function TakeDividends() public returns (uint256) {
353 		    
354 		uint256 _dividends = dividendsOf(msg.sender);
355 		require(_dividends >= 0, "you do not have any dividend yet");
356 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
357 		
358 		require(IERC20(Axiatoken).transfer(msg.sender, _dividends), "Transaction Failed");    // Transfer dividends to msg.sender
359 		emit RewardEvent(msg.sender, address(this), _dividends);
360 		
361 		return _dividends;
362 	    
363 		    
364 	}
365  
366     function scaledToken(uint _amount) external onlyAxiaToken returns(bool){
367             
368     		info.scaledPayoutPerToken += _amount * FLOAT_SCALAR / info.totalFrozen;
369     		infocheck = info.scaledPayoutPerToken;
370     		return true;
371             
372     }
373  
374         
375     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
376           (uint l, uint h) = fullMul (x, y);
377           assert (h < z);
378           uint mm = mulmod (x, y, z);
379           if (mm > l) h -= 1;
380           l -= mm;
381           uint pow2 = z & -z;
382           z /= pow2;
383           l /= pow2;
384           l += h * ((-pow2) / pow2 + 1);
385           uint r = 1;
386           r *= 2 - z * r;
387           r *= 2 - z * r;
388           r *= 2 - z * r;
389           r *= 2 - z * r;
390           r *= 2 - z * r;
391           r *= 2 - z * r;
392           r *= 2 - z * r;
393           r *= 2 - z * r;
394           return l * r;
395     }
396     
397      function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
398           uint mm = mulmod (x, y, uint (-1));
399           l = x * y;
400           h = mm - l;
401           if (mm < l) h -= 1;
402     }
403  
404     
405 }