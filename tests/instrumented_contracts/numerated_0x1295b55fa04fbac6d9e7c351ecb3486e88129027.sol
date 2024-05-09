1 pragma solidity 0.4.18;
2 
3 /**
4 
5  * Math operations with safety checks
6 
7  */
8 
9 contract BaseSafeMath {
10 
11 
12     /*
13     standard uint256 functions
14      */
15 
16 
17 
18     function add(uint256 a, uint256 b) internal pure
19 
20     returns (uint256) {
21 
22         uint256 c = a + b;
23 
24         assert(c >= a);
25 
26         return c;
27 
28     }
29 
30 
31     function sub(uint256 a, uint256 b) internal pure
32 
33     returns (uint256) {
34 
35         assert(b <= a);
36 
37         return a - b;
38 
39     }
40 
41 
42     function mul(uint256 a, uint256 b) internal pure
43 
44     returns (uint256) {
45 
46         uint256 c = a * b;
47 
48         assert(a == 0 || c / a == b);
49 
50         return c;
51 
52     }
53 
54 
55     function div(uint256 a, uint256 b) internal pure
56 
57     returns (uint256) {
58 
59 	    assert( b > 0 );
60 		
61         uint256 c = a / b;
62 
63         return c;
64 
65     }
66 
67 
68     function min(uint256 x, uint256 y) internal pure
69 
70     returns (uint256 z) {
71 
72         return x <= y ? x : y;
73 
74     }
75 
76 
77     function max(uint256 x, uint256 y) internal pure
78 
79     returns (uint256 z) {
80 
81         return x >= y ? x : y;
82 
83     }
84 
85 
86 
87     /*
88 
89     uint128 functions
90 
91      */
92 
93 
94 
95     function madd(uint128 a, uint128 b) internal pure
96 
97     returns (uint128) {
98 
99         uint128 c = a + b;
100 
101         assert(c >= a);
102 
103         return c;
104 
105     }
106 
107 
108     function msub(uint128 a, uint128 b) internal pure
109 
110     returns (uint128) {
111 
112         assert(b <= a);
113 
114         return a - b;
115 
116     }
117 
118 
119     function mmul(uint128 a, uint128 b) internal pure
120 
121     returns (uint128) {
122 
123         uint128 c = a * b;
124 
125         assert(a == 0 || c / a == b);
126 
127         return c;
128 
129     }
130 
131 
132     function mdiv(uint128 a, uint128 b) internal pure
133 
134     returns (uint128) {
135 
136 	    assert( b > 0 );
137 	
138         uint128 c = a / b;
139 
140         return c;
141 
142     }
143 
144 
145     function mmin(uint128 x, uint128 y) internal pure
146 
147     returns (uint128 z) {
148 
149         return x <= y ? x : y;
150 
151     }
152 
153 
154     function mmax(uint128 x, uint128 y) internal pure
155 
156     returns (uint128 z) {
157 
158         return x >= y ? x : y;
159 
160     }
161 
162 
163 
164     /*
165 
166     uint64 functions
167 
168      */
169 
170 
171 
172     function miadd(uint64 a, uint64 b) internal pure
173 
174     returns (uint64) {
175 
176         uint64 c = a + b;
177 
178         assert(c >= a);
179 
180         return c;
181 
182     }
183 
184 
185     function misub(uint64 a, uint64 b) internal pure
186 
187     returns (uint64) {
188 
189         assert(b <= a);
190 
191         return a - b;
192 
193     }
194 
195 
196     function mimul(uint64 a, uint64 b) internal pure
197 
198     returns (uint64) {
199 
200         uint64 c = a * b;
201 
202         assert(a == 0 || c / a == b);
203 
204         return c;
205 
206     }
207 
208 
209     function midiv(uint64 a, uint64 b) internal pure
210 
211     returns (uint64) {
212 
213 	    assert( b > 0 );
214 	
215         uint64 c = a / b;
216 
217         return c;
218 
219     }
220 
221 
222     function mimin(uint64 x, uint64 y) internal pure
223 
224     returns (uint64 z) {
225 
226         return x <= y ? x : y;
227 
228     }
229 
230 
231     function mimax(uint64 x, uint64 y) internal pure
232 
233     returns (uint64 z) {
234 
235         return x >= y ? x : y;
236 
237     }
238 
239 
240 }
241 
242 
243 // Abstract contract for the full ERC 20 Token standard
244 
245 // https://github.com/ethereum/EIPs/issues/20
246 
247 
248 
249 contract BaseERC20 {
250 
251     // Public variables of the token
252     string public name;
253     string public symbol;
254     uint8 public decimals;
255     // 18 decimals is the strongly suggested default, avoid changing it
256     uint256 public totalSupply;
257 
258     // This creates an array with all balances
259     mapping(address => uint256) public balanceOf;
260     mapping(address => mapping(address => uint256)) public allowed;
261 
262     // This generates a public event on the blockchain that will notify clients
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 	
265     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
266 
267     /**
268      * Internal transfer, only can be called by this contract
269      */
270     function _transfer(address _from, address _to, uint _value) internal;
271 
272     /**
273      * Transfer tokens
274      *
275      * Send `_value` tokens to `_to` from your account
276      *
277      * @param _to The address of the recipient
278      * @param _value the amount to send
279      */
280     function transfer(address _to, uint256 _value) public returns (bool success);
281     /**
282      * Transfer tokens from other address
283      *
284      * Send `_value` tokens to `_to` on behalf of `_from`
285      *
286      * @param _from The address of the sender
287      * @param _to The address of the recipient
288      * @param _value the amount to send
289      */
290     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
291 
292     /**
293      * Set allowance for other address
294      *
295      * Allows `_spender` to spend no more than `_value` tokens on your behalf
296      *
297      * @param _spender The address authorized to spend
298      * @param _value the max amount they can spend
299      */
300     function approve(address _spender, uint256 _value) public returns (bool success);
301 }
302 
303 /** 
304    * @title Ownable 
305    * @dev The Ownable contract has an owner address, and provides basic authorization control 
306    * functions, this simplifies the implementation of 
307    "user permissions". 
308 */ 
309 
310 contract Ownable { 
311 	address public publishOwner; 
312 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 
313 	
314 	/**
315 	   * @dev The Ownable constructor sets the original `owner` of the contract to the sender 
316 	   * account. 
317 	   */
318 	function Ownable() public {
319 		publishOwner = msg.sender; 
320 	} 
321 	
322 	/**
323 	   * @dev Throws if called by any account other than the owner. 
324 	   */ 
325 	modifier onlyOwner() { 
326 		require(msg.sender == publishOwner); 
327 		_; 
328 	}
329  
330 	/** 
331       * @dev Allows the current owner to transfer control of the contract to a newOwner. 
332       * @param newOwner The address to transfer ownership to. 
333       */ 
334 	function transferOwnership(address newOwner) onlyOwner public { 
335 		require(newOwner != address(0)); 
336 		OwnershipTransferred(publishOwner, newOwner); 
337 		publishOwner = newOwner; 
338 	} 
339 } 
340 
341 /**
342  * @title Pausable
343  * @dev Base contract which allows children to implement an emergency stop mechanism.
344  */
345 contract Pausable is Ownable { 
346 	event Pause(); 
347 	event Unpause(); 
348 	bool public paused = false;
349  
350 	/** 
351       * @dev Modifier to make a function callable only when the contract is not paused. 
352       */
353 	modifier whenNotPaused() 
354 	{ 
355 		require(!paused); 
356 		_; 
357 	}
358 	 /** 
359        * @dev Modifier to make a function callable only when the contract is paused. 
360        */
361 	modifier whenPaused() { 
362 		require(paused); 
363 		_;
364 	} 
365 
366 	/** 
367       * @dev called by the owner to pause, triggers stopped state 
368       */ 
369 	function pause() onlyOwner whenNotPaused public { 
370 		paused = true; 
371 		Pause(); 
372 	} 
373 
374 	/** 
375       * @dev called by the owner to unpause, returns to normal state 
376       */ 
377 	function unpause() onlyOwner whenPaused public {
378 		paused = false; 
379 		Unpause(); 
380 	} 
381 } 
382 
383 
384 /**
385 
386  * @title Standard ERC20 token
387 
388  *
389 
390  * @dev Implementation of the basic standard token.
391 
392  * @dev https://github.com/ethereum/EIPs/issues/20
393 
394  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
395 
396  */
397 
398 contract LightCoinToken is BaseERC20, BaseSafeMath, Pausable {
399 
400     //The solidity created time
401 	address public owner;
402 	address public lockOwner;
403 	uint256 public lockAmount ;
404 	uint256 public startTime ;
405     function LightCoinToken() public {
406 		owner = 0x55ae8974743DB03761356D703A9cfc0F24045ebb;
407 		lockOwner = 0x07d4C8CC52BB7c4AB46A1A65DCEEdC1ab29aBDd6;
408 		startTime = 1515686400;
409         name = "Lightcoin";
410         symbol = "Light";
411         decimals = 8;
412         ///totalSupply = 21000000000000000000;
413         totalSupply = 2.1e19;
414 		balanceOf[owner] = totalSupply * 90 /100;
415 		lockAmount = totalSupply * 10 / 100 ;
416 	    Transfer(address(0), owner, balanceOf[owner]);
417     }
418 
419 	/// @param _owner The address from which the balance will be retrieved
420     /// @return The balance
421     function getBalanceOf(address _owner) public constant returns (uint256 balance) {
422 		 return balanceOf[_owner];
423 	}
424 	
425     function _transfer(address _from, address _to, uint256 _value) internal {
426         // Prevent transfer to 0x0 address. Use burn() instead
427         require(_to != 0x0);
428 
429         // Save this for an assertion in the future
430         uint previousBalances = add(balanceOf[_from], balanceOf[_to]);
431 		
432         // Subtract from the sender
433         balanceOf[_from] = sub(balanceOf[_from], _value);
434         // Add the same to the recipient
435         balanceOf[_to] = add(balanceOf[_to], _value);
436 		
437 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
438         assert(add(balanceOf[_from], balanceOf[_to]) == previousBalances);
439 		
440         Transfer(_from, _to, _value);
441 
442     }
443 
444     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success)  {
445         _transfer(msg.sender, _to, _value);
446 		return true;
447     }
448 
449     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
450         // Check allowance
451         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
452 		
453         _transfer(_from, _to, _value);
454         return true;
455     }
456 
457     function approve(address _spender, uint256 _value) public
458     returns (bool success) {
459         allowed[msg.sender][_spender] = _value;
460 		
461 		Approval(msg.sender, _spender, _value);
462         return true;
463     }
464 
465     /// @param _owner The address of the account owning tokens
466     /// @param _spender The address of the account able to transfer the tokens
467     /// @return Amount of remaining tokens allowed to spent
468     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
469         return allowed[_owner][_spender];
470 	}
471 	
472 	function releaseToken() public{
473 	   uint256 releaseBegin = add(startTime,  2 * 365 * 86400);
474 	   require(now >= releaseBegin );
475 	   
476 	   uint256 interval = sub(now, releaseBegin);
477        uint256 i = div(interval, (0.5 * 365 * 86400));
478        if (i > 3) 
479        {
480             i = 3;
481        }
482 
483 	   uint256 releasevalue = div(totalSupply, 40);
484 	   uint256 remainInterval = sub(3, i);
485 	   
486 	   require(lockAmount > mul(remainInterval, releasevalue));
487 	   lockAmount = sub(lockAmount, releasevalue);
488 	   
489 	   balanceOf[lockOwner] = add( balanceOf[lockOwner],  releasevalue);
490 	   Transfer(address(0), lockOwner, releasevalue);
491     }
492     
493     function () public payable{ revert(); }
494 }