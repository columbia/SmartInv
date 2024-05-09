1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Ownable {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 
33 contract Pausable is Ownable {
34 	event Pause();
35 	event Unpause();
36 
37 	bool public paused = false;
38 
39 
40 	/**
41 	 * @dev modifier to allow actions only when the contract IS paused
42 	 */
43 	modifier whenNotPaused() {
44 		require(!paused);
45 		_;
46 	}
47 
48 	/**
49 	 * @dev modifier to allow actions only when the contract IS NOT paused
50 	 */
51 	modifier whenPaused {
52 		require(paused);
53 		_;
54 	}
55 
56 	/**
57 	 * @dev called by the owner to pause, triggers stopped state
58 	 */
59 	function pause() onlyOwner whenNotPaused public returns (bool) {
60 		paused = true;
61 		emit Pause();
62 		return true;
63 	}
64 
65 	/**
66 	 * @dev called by the owner to unpause, returns to normal state
67 	 */
68 	function unpause() onlyOwner whenPaused public returns (bool) {
69 		paused = false;
70 		emit Unpause();
71 		return true;
72 	}
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80 
81   /**
82   * @dev Multiplies two numbers, throws on overflow.
83   */
84   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     if (a == 0) {
86       return 0;
87     }
88     c = a * b;
89     assert(c / a == b);
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers, truncating the quotient.
95   */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     // uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return a / b;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   /**
112   * @dev Adds two numbers, throws on overflow.
113   */
114   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
115     c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 library ContractLib {
122 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
123 	function isContract(address _addr) internal view returns (bool) {
124 		uint length;
125 		assembly {
126 			//retrieve the size of the code on target address, this needs assembly
127 			length := extcodesize(_addr)
128 		}
129 		return (length>0);
130 	}
131 }
132 
133 /*
134 * Contract that is working with ERC223 tokens
135 */
136  
137 contract ContractReceiver {
138 	function tokenFallback(address _from, uint _value, bytes _data) public pure;
139 }
140 
141 // ----------------------------------------------------------------------------
142 // ERC Token Standard #20 Interface
143 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
144 // ----------------------------------------------------------------------------
145 contract ERC20Interface {
146 	function totalSupply() public constant returns (uint);
147 	function balanceOf(address tokenOwner) public constant returns (uint);
148 	function allowance(address tokenOwner, address spender) public constant returns (uint);
149 	function transfer(address to, uint tokens) public returns (bool);
150 	function approve(address spender, uint tokens) public returns (bool);
151 	function transferFrom(address from, address to, uint tokens) public returns (bool);
152 
153 	function name() public constant returns (string);
154 	function symbol() public constant returns (string);
155 	function decimals() public constant returns (uint8);
156 
157 	event Transfer(address indexed from, address indexed to, uint tokens);
158 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
159 }
160 
161 
162  /**
163  * ERC223 token by Dexaran
164  *
165  * https://github.com/Dexaran/ERC223-token-standard
166  */
167  
168 
169  /* New ERC223 contract interface */
170  
171 contract ERC223 is ERC20Interface {
172 	function transfer(address to, uint value, bytes data) public returns (bool);
173 	
174 	event Transfer(address indexed from, address indexed to, uint tokens);
175 	event Transfer(address indexed from, address indexed to, uint value, bytes data);
176 }
177 
178  
179 contract NXX is ERC223, Pausable {
180 
181 	using SafeMath for uint256;
182 	using ContractLib for address;
183 
184 	mapping(address => uint) balances;
185 	mapping(address => mapping(address => uint)) allowed;
186 	
187 	string public name;
188 	string public symbol;
189 	uint8 public decimals;
190 	uint256 public totalSupply;
191 
192 	event Burn(address indexed from, uint256 value);
193 	
194 	// ------------------------------------------------------------------------
195 	// Constructor
196 	// ------------------------------------------------------------------------
197 	function NXX() public {
198 		symbol = "NASHXX";
199 		name = "XXXX CASH";
200 		decimals = 18;
201 		totalSupply = 100000000000 * 10**uint(decimals);
202 		balances[msg.sender] = totalSupply;
203 		emit Transfer(address(0), msg.sender, totalSupply);
204 	}
205 	
206 	
207 	// Function to access name of token .
208 	function name() public constant returns (string) {
209 		return name;
210 	}
211 	// Function to access symbol of token .
212 	function symbol() public constant returns (string) {
213 		return symbol;
214 	}
215 	// Function to access decimals of token .
216 	function decimals() public constant returns (uint8) {
217 		return decimals;
218 	}
219 	// Function to access total supply of tokens .
220 	function totalSupply() public constant returns (uint256) {
221 		return totalSupply;
222 	}
223 	
224 	// Function that is called when a user or another contract wants to transfer funds .
225 	function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
226 		require(_to != 0x0);
227 		if(_to.isContract()) {
228 			return transferToContract(_to, _value, _data);
229 		}
230 		else {
231 			return transferToAddress(_to, _value, _data);
232 		}
233 	}
234 	
235 	// Standard function transfer similar to ERC20 transfer with no _data .
236 	// Added due to backwards compatibility reasons .
237 	function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
238 		//standard function transfer similar to ERC20 transfer with no _data
239 		//added due to backwards compatibility reasons
240 		require(_to != 0x0);
241 
242 		bytes memory empty;
243 		if(_to.isContract()) {
244 			return transferToContract(_to, _value, empty);
245 		}
246 		else {
247 			return transferToAddress(_to, _value, empty);
248 		}
249 	}
250 
251 
252 
253 	//function that is called when transaction target is an address
254 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
255 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);
256 		balances[_to] = balanceOf(_to).add(_value);
257 		emit Transfer(msg.sender, _to, _value);
258 		emit Transfer(msg.sender, _to, _value, _data);
259 		return true;
260 	}
261 	
262   //function that is called when transaction target is a contract
263   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
264 	    balances[msg.sender] = balanceOf(msg.sender).sub(_value);
265 	    balances[_to] = balanceOf(_to).add(_value);
266 	    ContractReceiver receiver = ContractReceiver(_to);
267 	    receiver.tokenFallback(msg.sender, _value, _data);
268 	    emit Transfer(msg.sender, _to, _value);
269 	    emit Transfer(msg.sender, _to, _value, _data);
270 	    return true;
271 	}
272 	
273 	function balanceOf(address _owner) public constant returns (uint) {
274 		return balances[_owner];
275 	}  
276 
277 	function burn(uint256 _value) public whenNotPaused returns (bool) {
278 		require (_value > 0); 
279 		require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
280 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
281 		totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
282 		emit Burn(msg.sender, _value);
283 		return true;
284 	}
285 
286 	// ------------------------------------------------------------------------
287 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
288 	// from the token owner's account
289 	//
290 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
291 	// recommends that there are no checks for the approval double-spend attack
292 	// as this should be implemented in user interfaces 
293 	// ------------------------------------------------------------------------
294 	function approve(address spender, uint tokens) public whenNotPaused returns (bool) {
295 		allowed[msg.sender][spender] = tokens;
296 		emit Approval(msg.sender, spender, tokens);
297 		return true;
298 	}
299 
300 	function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
301 	    returns (bool success) {
302 	    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
303 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304 	    return true;
305 	}
306 
307 	function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
308 	    returns (bool success) {
309 	    uint oldValue = allowed[msg.sender][_spender];
310 	    if (_subtractedValue > oldValue) {
311 	      allowed[msg.sender][_spender] = 0;
312 	    } else {
313 	      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314 	    }
315 	    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316 	    return true;
317 	}	
318 
319 	// ------------------------------------------------------------------------
320 	// Transfer `tokens` from the `from` account to the `to` account
321 	// 
322 	// The calling account must already have sufficient tokens approve(...)-d
323 	// for spending from the `from` account and
324 	// - From account must have sufficient balance to transfer
325 	// - Spender must have sufficient allowance to transfer
326 	// - 0 value transfers are allowed
327 	// ------------------------------------------------------------------------
328 	function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {
329 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
330 		balances[from] = balances[from].sub(tokens);
331 		balances[to] = balances[to].add(tokens);
332 		emit Transfer(from, to, tokens);
333 		return true;
334 	}
335 
336 	// ------------------------------------------------------------------------
337 	// Returns the amount of tokens approved by the owner that can be
338 	// transferred to the spender's account
339 	// ------------------------------------------------------------------------
340 	function allowance(address tokenOwner, address spender) public constant returns (uint) {
341 		return allowed[tokenOwner][spender];
342 	}
343 
344 	// ------------------------------------------------------------------------
345 	// Don't accept ETH
346 	// ------------------------------------------------------------------------
347 	function () public payable {
348 		revert();
349 	}
350 
351 	// ------------------------------------------------------------------------
352 	// Owner can transfer out any accidentally sent ERC20 tokens
353 	// ------------------------------------------------------------------------
354 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
355 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
356 	}
357 
358 	/* RO Token 预售 */
359 	address[] supportedERC20Token;
360 	mapping (address => uint256) prices;
361 	mapping (address => uint256) starttime;
362 	mapping (address => uint256) endtime;
363 
364 	uint256 maxTokenCountPerTrans = 10000;
365 	uint256 nashInPool;
366 
367 	event AddSupportedToken(
368 		address _address, 
369 		uint256 _price, 
370 		uint256 _startTime, 
371 		uint256 _endTime);
372 
373 	event RemoveSupportedToken(
374 		address _address
375 	);
376 
377 	function addSupportedToken(
378 		address _address, 
379 		uint256 _price, 
380 		uint256 _startTime, 
381 		uint256 _endTime
382 	) public onlyOwner returns (bool) {
383 		
384 		require(_address != 0x0);
385 		require(_address.isContract());
386 		require(_startTime < _endTime);
387 		require(_endTime > block.timestamp);
388 
389 		supportedERC20Token.push(_address);
390 		prices[_address] = _price;
391 		starttime[_address] = _startTime;
392 		endtime[_address] = _endTime;
393 
394 		emit AddSupportedToken(_address, _price, _startTime, _endTime);
395 
396 		return true;
397 	}
398 
399 	function removeSupportedToken(address _address) public onlyOwner returns (bool) {
400 		require(_address != 0x0);
401 		uint256 length = supportedERC20Token.length;
402 		for (uint256 i = 0; i < length; i++) {
403 			if (supportedERC20Token[i] == _address) {
404 				if (i != length - 1) {
405 					supportedERC20Token[i] = supportedERC20Token[length - 1];
406 				}
407                 delete supportedERC20Token[length-1];
408 				supportedERC20Token.length--;
409 
410 				prices[_address] = 0;
411 				starttime[_address] = 0;
412 				endtime[_address] = 0;
413 
414 				emit RemoveSupportedToken(_address);
415 
416 				break;
417 			}
418 		}
419 		return true;
420 	}
421 
422 	modifier canBuy(address _address) { 
423 		bool found = false;
424 		uint256 length = supportedERC20Token.length;
425 		for (uint256 i = 0; i < length; i++) {
426 			if (supportedERC20Token[i] == _address) {
427 				require(block.timestamp > starttime[_address]);
428 				require(block.timestamp < endtime[_address]);
429 				found = true;
430 				break;
431 			}
432 		}		
433 		require (found); 
434 		_; 
435 	}
436 
437 	function joinPreSale(address _tokenAddress, uint256 _tokenCount) public canBuy(_tokenAddress) returns (bool) {
438 		require(_tokenCount <= maxTokenCountPerTrans); 
439 		uint256 total = _tokenCount * prices[_tokenAddress]; // will not overflow here since the price will not be high
440 		balances[msg.sender].sub(total);
441 		nashInPool.add(total);
442 
443 		emit Transfer(_tokenAddress, this, total);
444 
445 		return ERC20Interface(_tokenCount).transfer(msg.sender, _tokenCount);
446 	}
447 
448 	function transferNashOut(address _to, uint256 count) public onlyOwner returns(bool) {
449 		require(_to != 0x0);
450 		nashInPool.sub(count);
451 		balances[_to].add(count);
452 
453 		emit Transfer(this, _to, count);
454 	}
455 }