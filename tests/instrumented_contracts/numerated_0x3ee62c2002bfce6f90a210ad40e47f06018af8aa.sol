1 /*
2 
3 * @dev This is the Axia Protocol Staking pool 1 contract (Oracle FUND Pool), 
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
17 */
18 pragma solidity 0.6.4;
19 
20 interface IERC20 {
21 
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      *
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56  
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      *
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return mod(a, b, "SafeMath: modulo by zero");
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts with custom message when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b != 0, errorMessage);
178         return a % b;
179     }
180 }
181 
182 
183 
184 contract OSP{
185     
186     using SafeMath for uint256;
187     
188 //======================================EVENTS=========================================//
189     event StakeEvent(address indexed staker, address indexed pool, uint amount);
190     event UnstakeEvent(address indexed unstaker, address indexed pool, uint amount);
191     event RewardEvent(address indexed staker, address indexed pool, uint amount);
192     event RewardStake(address indexed staker, address indexed pool, uint amount);
193     
194     
195 //======================================STAKING POOLS=========================================//
196     address public Axiatoken;
197     address public OracleIndexFunds;
198     
199     address public administrator;
200     
201     bool public stakingEnabled;
202     
203     uint256 constant private FLOAT_SCALAR = 2**64;
204     uint256 public MINIMUM_STAKE = 1000000000000000000; // 1 minimum
205 	uint256  public MIN_DIVIDENDS_DUR = 18 hours;
206 	
207 	uint public infocheck;
208     
209     struct User {
210 		uint256 balance;
211 		uint256 frozen;
212 		int256 scaledPayout;  
213 		uint256 staketime;
214 	}
215 
216 	struct Info {
217 		uint256 totalSupply;
218 		uint256 totalFrozen;
219 		mapping(address => User) users;
220 		uint256 scaledPayoutPerToken;
221 		address admin;
222 	}
223 	
224 	Info private info;
225 	
226 	
227 	constructor() public {
228 	    
229         info.admin = msg.sender;
230         stakingEnabled = false;
231 	}
232 
233 //======================================ADMINSTRATION=========================================//
234 
235 	modifier onlyCreator() {
236         require(msg.sender == info.admin, "Ownable: caller is not the administrator");
237         _;
238     }
239     
240     modifier onlyAxiaToken() {
241         require(msg.sender == Axiatoken, "Authorization: only token contract can call");
242         _;
243     }
244     
245 	 function tokenconfigs(address _axiatoken, address _oracleindex) public onlyCreator returns (bool success) {
246 	    require(_axiatoken != _oracleindex, "Insertion of same address is not supported");
247 	    require(_axiatoken != address(0) && _oracleindex != address(0), "Insertion of address(0) is not supported");
248         Axiatoken = _axiatoken;
249         OracleIndexFunds = _oracleindex;
250         return true;
251     }
252 	
253 	function _minStakeAmount(uint256 _number) onlyCreator public {
254 		
255 		MINIMUM_STAKE = _number*1000000000000000000;
256 		
257 	}
258 	
259 	function stakingStatus(bool _status) public onlyCreator {
260 	require(Axiatoken != address(0) && OracleIndexFunds != address(0), "Pool addresses are not yet setup");
261 	stakingEnabled = _status;
262     }
263     
264     function MIN_DIVIDENDS_DUR_TIME(uint256 _minDuration) public onlyCreator {
265         
266 	MIN_DIVIDENDS_DUR = _minDuration;
267 	
268     }
269 //======================================USER WRITE=========================================//
270 
271 	function StakeTokens(uint256 _tokens) external {
272 		_stake(_tokens);
273 	}
274 	
275 	function UnstakeTokens(uint256 _tokens) external {
276 		_unstake(_tokens);
277 	}
278     
279 
280 //======================================USER READ=========================================//
281 
282 	function totalFrozen() public view returns (uint256) {
283 		return info.totalFrozen;
284 	}
285 	
286     function frozenOf(address _user) public view returns (uint256) {
287 		return info.users[_user].frozen;
288 	}
289 
290 	function dividendsOf(address _user) public view returns (uint256) {
291 	    
292 	    if(info.users[_user].staketime < MIN_DIVIDENDS_DUR){
293 	        return 0;
294 	    }else{
295 	     return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;   
296 	    }
297 	}
298 	
299 
300 	function userData(address _user) public view 
301 	returns (uint256 totalTokensFrozen, uint256 userFrozen, 
302 	uint256 userDividends, uint256 userStaketime, int256 scaledPayout) {
303 	    
304 		return (totalFrozen(), frozenOf(_user), dividendsOf(_user), info.users[_user].staketime, info.users[_user].scaledPayout);
305 	
306 	    
307 	}
308 	
309 
310 //======================================ACTION CALLS=========================================//	
311 	
312 	function _stake(uint256 _amount) internal {
313 	    
314 	    require(stakingEnabled, "Staking not yet initialized");
315 	    
316 		require(IERC20(OracleIndexFunds).balanceOf(msg.sender) >= _amount, "Insufficient Oracle AFT token balance");
317 		require(frozenOf(msg.sender) + _amount >= MINIMUM_STAKE, "Your amount is lower than the minimum amount allowed to stake");
318 		require(IERC20(OracleIndexFunds).allowance(msg.sender, address(this)) >= _amount, "Not enough allowance given to contract yet to spend by user");
319 		
320 		info.users[msg.sender].staketime = now;
321 		info.totalFrozen += _amount;
322 		info.users[msg.sender].frozen += _amount;
323 		
324 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken); 
325 		IERC20(OracleIndexFunds).transferFrom(msg.sender, address(this), _amount);      
326 		
327         emit StakeEvent(msg.sender, address(this), _amount);
328 	}
329 	
330     
331     
332  
333 	function _unstake(uint256 _amount) internal {
334 	    
335 		require(frozenOf(msg.sender) >= _amount, "You currently do not have up to that amount staked");
336 		
337 		info.totalFrozen -= _amount;
338 		info.users[msg.sender].frozen -= _amount;
339 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
340 		
341 		require(IERC20(OracleIndexFunds).transfer(msg.sender, _amount), "Transaction failed");
342         emit UnstakeEvent(address(this), msg.sender, _amount);
343         
344         TakeDividends();
345 		
346 	}
347 	
348 		
349 	function TakeDividends() public returns (uint256) {
350 		    
351 		uint256 _dividends = dividendsOf(msg.sender);
352 		require(_dividends >= 0, "you do not have any dividend yet");
353 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
354 		
355 		require(IERC20(Axiatoken).transfer(msg.sender, _dividends), "Transaction Failed");    // Transfer dividends to msg.sender
356 		emit RewardEvent(msg.sender, address(this), _dividends);
357 		
358 		return _dividends;
359 	    
360 		    
361 	}
362 	
363  
364     function scaledToken(uint _amount) external onlyAxiaToken returns(bool){
365             
366     		info.scaledPayoutPerToken += _amount * FLOAT_SCALAR / info.totalFrozen;
367     		infocheck = info.scaledPayoutPerToken;
368     		return true;
369             
370     }
371  
372         
373     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
374           (uint l, uint h) = fullMul (x, y);
375           assert (h < z);
376           uint mm = mulmod (x, y, z);
377           if (mm > l) h -= 1;
378           l -= mm;
379           uint pow2 = z & -z;
380           z /= pow2;
381           l /= pow2;
382           l += h * ((-pow2) / pow2 + 1);
383           uint r = 1;
384           r *= 2 - z * r;
385           r *= 2 - z * r;
386           r *= 2 - z * r;
387           r *= 2 - z * r;
388           r *= 2 - z * r;
389           r *= 2 - z * r;
390           r *= 2 - z * r;
391           r *= 2 - z * r;
392           return l * r;
393     }
394     
395      function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
396           uint mm = mulmod (x, y, uint (-1));
397           l = x * y;
398           h = mm - l;
399           if (mm < l) h -= 1;
400     }
401  
402     
403 }