1 /*
2 
3 * @dev This is the Axia Protocol Staking pool 4 contract (AXIA LONE Pool), a part of the protocol where stakers are rewarded in AXIA tokens 
4 * when they make stakes of Axia tokens.
5 
6 * stakers reward come from the daily emission from the total supply into circulation,
7 * this happens daily and upon the reach of a new epoch each made of 180 days, 
8 * halvings are experienced on the emitting amount of tokens.
9 
10 
11 * on the 11th epoch all the tokens would have been completed emitted into circulation,
12 * from here on, the stakers will still be earning from daily emissions
13 * which would now be coming from the accumulated basis points over the epochs.
14 
15 * upon unstaking, stakers are charged a fee of 1% of their unstaking sum which is
16 * burnt forever, thereby reducing the total supply. this gives the Axia token its deflationary feature.
17 
18 
19 */
20 pragma solidity 0.6.4;
21 
22 
23 interface IERC20 {
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     
37     function supplyeffect(uint _amount) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      *
54      * - Addition cannot overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62  
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      *
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      *
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      *
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
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
179      *
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }
187 
188 
189 
190 contract ASP{
191     
192     using SafeMath for uint256;
193     
194     //======================================EVENTS=========================================//
195     event StakeEvent(address indexed staker, address indexed pool, uint amount);
196     event UnstakeEvent(address indexed unstaker, address indexed pool, uint amount);
197     event RewardEvent(address indexed staker, address indexed pool, uint amount);
198     event RewardStake(address indexed staker, address indexed pool, uint amount);
199     //event BurnEvent(address indexed pool, address indexed burnaddress, uint amount);
200     
201     
202     
203     
204      //======================================STAKING POOL=========================================//
205     address public Axiatoken;
206     
207     address public administrator;
208     
209     bool public stakingEnabled;
210     
211     uint256 constant private FLOAT_SCALAR = 2**64;
212     uint256 public MINIMUM_STAKE = 1000000000000000000; // 1000 AXIA Tokens
213 	uint256 public MIN_DIVIDENDS_DUR = 86400;
214 	uint256 private  UNSTAKE_FEE = 1; //1% burns when you unstake
215 	uint public infocheck;
216 	uint _burnedAmount;
217 	uint actualValue;
218     
219     struct User {
220 		uint256 balance;
221 		uint256 frozen;
222 		int256 scaledPayout;  
223 		uint256 staketime;
224 	}
225 
226 	struct Info {
227 		uint256 totalSupply;
228 		uint256 totalFrozen;
229 		mapping(address => User) users;
230 		uint256 scaledPayoutPerToken; //pool balance 
231 		address admin;
232 	}
233 	
234 	Info private info;
235 	
236 	
237 	constructor() public {
238        
239 	    info.admin = msg.sender;
240 		stakingEnabled = false;
241 		
242 	}
243 	
244 //======================================ADMINSTRATION=========================================//
245 
246 	modifier onlyCreator() {
247         require(msg.sender == info.admin, "Ownable: caller is not the administrator");
248         _;
249     }
250     
251     modifier onlyAxiaToken() {
252         require(msg.sender == Axiatoken, "Authorization: only token contract can call");
253         _;
254     }
255     
256 	 function tokenconfigs(address _axiatoken) public onlyCreator returns (bool success) {
257         Axiatoken = _axiatoken;
258         return true;
259     }
260 	
261 	function _minStakeAmount(uint256 _number) onlyCreator public {
262 		
263 		MINIMUM_STAKE = _number*1000000000000000000;
264 		
265 	}
266     
267     function stakaingStatus(bool _status) public onlyCreator {
268 	stakingEnabled = _status;
269     }
270     
271     function unstakeburnrate(uint _rate) public onlyCreator returns (bool success) {
272         UNSTAKE_FEE = _rate;
273         return true;
274     }
275     
276     
277     function MIN_DIVIDENDS_DUR_TIME(uint256 _minDuration) public onlyCreator {
278         
279 	MIN_DIVIDENDS_DUR = _minDuration;
280 	
281     }
282 //======================================USER WRITE=========================================//
283 
284 	function StakeAxiaTokens(uint256 _tokens) external {
285 		_stake(_tokens);
286 	}
287     
288     function UnstakeAxiaTokens(uint256 _tokens) external {
289 		_unstake(_tokens);
290 	}
291 	
292 //======================================USER READ=========================================//
293 
294 	function totalFrozen() public view returns (uint256) {
295 		return info.totalFrozen;
296 	}
297 	
298     function frozenOf(address _user) public view returns (uint256) {
299 		return info.users[_user].frozen;
300 	}
301 
302 	function dividendsOf(address _user) public view returns (uint256) {
303 	    
304 	    if(info.users[_user].staketime < MIN_DIVIDENDS_DUR){
305 	        return 0;
306 	    }else{
307 	     return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;   
308 	    }
309 	}
310 	
311 
312 	function userData(address _user) public view 
313 	returns (uint256 totalTokensFrozen, uint256 userFrozen, 
314 	uint256 userDividends, uint256 userStaketime, int256 scaledPayout) {
315 	    
316 		return (totalFrozen(), frozenOf(_user), dividendsOf(_user), info.users[_user].staketime, info.users[_user].scaledPayout);
317 	
318 	    
319 	}
320 	
321 
322 //======================================ACTION CALLS=========================================//	
323 	
324 	function _stake(uint256 _amount) internal {
325 	    
326 	    require(stakingEnabled, "Staking not yet initialized");
327 	    
328 		require(IERC20(Axiatoken).balanceOf(msg.sender) >= _amount, "Insufficient Axia token balance");
329 		require(frozenOf(msg.sender) + _amount >= MINIMUM_STAKE, "Your amount is lower than the minimum amount allowed to stake");
330 		require(IERC20(Axiatoken).allowance(msg.sender, address(this)) >= _amount, "Not enough allowance given to contract yet to spend by user");
331 		
332 		info.users[msg.sender].staketime = now;
333 		info.totalFrozen += _amount;
334 		info.users[msg.sender].frozen += _amount;
335 		
336 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken); 
337 		IERC20(Axiatoken).transferFrom(msg.sender, address(this), _amount);      // Transfer liquidity tokens from the sender to this contract
338 		
339         emit StakeEvent(msg.sender, address(this), _amount);
340 	}
341 	
342 	    
343 	
344 	function _unstake(uint256 _amount) internal {
345 	    
346 		require(frozenOf(msg.sender) >= _amount, "You currently do not have up to that amount staked");
347 		
348 		info.totalFrozen -= _amount;
349 		info.users[msg.sender].frozen -= _amount;
350 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
351 		
352 		uint256 interval =  now - info.users[msg.sender].staketime;
353 		
354 		
355 		if(interval < MIN_DIVIDENDS_DUR){
356 		    
357 		_burnedAmount = mulDiv(_amount, UNSTAKE_FEE, 100);
358 		actualValue = _amount.sub(_burnedAmount);
359 		
360 		require(IERC20(Axiatoken).transfer(msg.sender, actualValue), "Transaction failed");
361         emit UnstakeEvent(address(this), msg.sender, actualValue);
362 		
363 		
364 		require(IERC20(Axiatoken).transfer(address(0x0), _burnedAmount), "Transaction failed");
365  		
366  		
367  		IERC20(Axiatoken).supplyeffect(_burnedAmount);
368  		//emit BurnEvent(address(this), address(0x0), _amount);
369 		
370 		
371 		 
372 		}else{
373 		    
374 		require(IERC20(Axiatoken).transfer(msg.sender, _amount), "Transaction failed");
375         emit UnstakeEvent(address(this), msg.sender, _amount);
376 		
377 		}
378 		
379 	}
380 		
381 		
382 	function TakeDividends() external returns (uint256) {
383 		    
384 		uint256 _dividends = dividendsOf(msg.sender);
385 		require(_dividends >= 0, "you do not have any dividend yet");
386 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
387 		
388 		require(IERC20(Axiatoken).transfer(msg.sender, _dividends), "Transaction Failed");    // Transfer dividends to msg.sender
389 		emit RewardEvent(msg.sender, address(this), _dividends);
390 		
391 		return _dividends;
392 	    
393 		    
394 	}
395 		
396 		
397 	function StakeDividends() external returns (uint256) {
398 		    
399 		uint256 _dividends = dividendsOf(msg.sender);
400 		require(_dividends >= 0, "you do not have any dividend yet");
401 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
402 		
403 		require(IERC20(Axiatoken).transfer(msg.sender, _dividends), "Transaction Failed");    // Transfer dividends to msg.sender
404 		
405 		_stake(_dividends);
406 		emit RewardStake(msg.sender, address(this), _dividends);
407 		
408         
409 		return _dividends;
410 	    
411 		    
412 	}
413  
414     function scaledToken(uint _amount) external onlyAxiaToken returns(bool){
415             
416     		info.scaledPayoutPerToken += _amount * FLOAT_SCALAR / info.totalFrozen;
417     		infocheck = info.scaledPayoutPerToken;
418     		return true;
419             
420     }
421  
422         
423     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
424               (uint l, uint h) = fullMul (x, y);
425               assert (h < z);
426               uint mm = mulmod (x, y, z);
427               if (mm > l) h -= 1;
428               l -= mm;
429               uint pow2 = z & -z;
430               z /= pow2;
431               l /= pow2;
432               l += h * ((-pow2) / pow2 + 1);
433               uint r = 1;
434               r *= 2 - z * r;
435               r *= 2 - z * r;
436               r *= 2 - z * r;
437               r *= 2 - z * r;
438               r *= 2 - z * r;
439               r *= 2 - z * r;
440               r *= 2 - z * r;
441               r *= 2 - z * r;
442               return l * r;
443     }
444         
445     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
446               uint mm = mulmod (x, y, uint (-1));
447               l = x * y;
448               h = mm - l;
449               if (mm < l) h -= 1;
450     }
451  
452     
453 }