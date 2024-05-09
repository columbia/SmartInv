1 pragma solidity ^0.4.11;
2 
3 /**
4 	* @title SafeMath
5 	* @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9 		uint256 c = a * b;
10 		assert(a == 0 || c / a == b);
11 		return c;
12 	}
13 	
14 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
15 		// assert(b > 0); // Solidity automatically throws when dividing by 0
16 		uint256 c = a / b;
17 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
18 		return c;
19 	}
20 	
21 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 	
26 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c >= a);
29 		return c;
30 	}
31 	
32 	function toUINT112(uint256 a) internal constant returns(uint112) {
33 		assert(uint112(a) == a);
34 		return uint112(a);
35 	}
36 	
37 	function toUINT120(uint256 a) internal constant returns(uint120) {
38 		assert(uint120(a) == a);
39 		return uint120(a);
40 	}
41 	
42 	function toUINT128(uint256 a) internal constant returns(uint128) {
43 		assert(uint128(a) == a);
44 		return uint128(a);
45 	}
46 	
47 	function percent(uint256 a, uint256 b) internal constant returns (uint256) {
48 		uint256 c = (b*a/100) ;
49 		assert(c <= a);
50 		return c;
51 	}
52 }
53 
54 contract Owned {
55 	
56 	address public owner;
57 	
58 	function Owned() {
59 		owner = msg.sender;
60 	}
61 	
62 	modifier onlyOwner() {
63 		require(msg.sender == owner);
64 		_;
65 	}
66 	
67 	function setOwner(address _newOwner) onlyOwner {
68 		owner = _newOwner;
69 	}
70 }
71 
72 /**
73 	* @title ERC20Basic
74 	* @dev Simpler version of ERC20 interface
75 	* @dev see https://github.com/ethereum/EIPs/issues/179
76 */
77 contract ERC20Basic {
78 	function balanceOf(address who) public constant returns (uint256);
79 	function transfer(address to, uint256 value) public returns (bool);
80 	event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84 	* @title ERC20 interface
85 	* @dev see https://github.com/ethereum/EIPs/issues/20
86 */
87 contract ERC20 is ERC20Basic {
88 	function allowance(address owner, address spender) public constant returns (uint256);
89 	function transferFrom(address from, address to, uint256 value) public returns (bool);
90 	function approve(address spender, uint256 value) public returns (bool);
91 	event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95 	* @title Basic token
96 	* @dev Basic version of StandardToken, with no allowances.
97 */
98 contract BasicToken is ERC20Basic {
99 	using SafeMath for uint256;
100 	
101 	struct Account {
102 		uint256 balances;
103 		uint256 rawTokens;
104 		uint32 lastMintedTimestamp;
105 	}
106 	
107 	// Balances for each account
108 	mapping(address => Account) accounts;
109 	
110 	
111 	/**
112 		* @dev transfer token for a specified address
113 		* @param _to The address to transfer to.
114 		* @param _value The amount to be transferred.
115 	*/
116 	function transfer(address _to, uint256 _value) public returns (bool) {
117 		require(_to != address(0));
118 		require(_value <= accounts[msg.sender].balances);
119 		
120 		// SafeMath.sub will throw if there is not enough balance.
121 		accounts[msg.sender].balances = accounts[msg.sender].balances.sub(_value);
122 		accounts[_to].balances = accounts[_to].balances.add(_value);
123 		Transfer(msg.sender, _to, _value);
124 		return true;
125 	}
126 	
127 	/**
128 		* @dev Gets the balance of the specified address.
129 		* @param _owner The address to query the the balance of.
130 		* @return An uint256 representing the amount owned by the passed address.
131 	*/
132 	function balanceOf(address _owner) public constant returns (uint256 balance) {
133 		return accounts[_owner].balances;
134 	}
135 	
136 }
137 
138 /**
139 	* @title Standard ERC20 token
140 	*
141 	* @dev Implementation of the basic standard token.
142 	* @dev https://github.com/ethereum/EIPs/issues/20
143 	* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144 */
145 contract StandardToken is ERC20, BasicToken {
146 	
147 	mapping (address => mapping (address => uint256)) internal allowed;
148 	
149 	
150 	/**
151 		* @dev Transfer tokens from one address to another
152 		* @param _from address The address which you want to send tokens from
153 		* @param _to address The address which you want to transfer to
154 		* @param _value uint256 the amount of tokens to be transferred
155 	*/
156 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157 		require(_to != address(0));
158 		require(_value <= accounts[_from].balances);
159 		require(_value <= allowed[_from][msg.sender]);
160 		
161 		accounts[_from].balances = accounts[_from].balances.sub(_value);
162 		accounts[_to].balances = accounts[_to].balances.add(_value);
163 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164 		Transfer(_from, _to, _value);
165 		return true;
166 	}
167 	
168 	/**
169 		* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170 		*
171 		* Beware that changing an allowance with this method brings the risk that someone may use both the old
172 		* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173 		* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175 		* @param _spender The address which will spend the funds.
176 		* @param _value The amount of tokens to be spent.
177 	*/
178 	function approve(address _spender, uint256 _value) public returns (bool) {
179 		allowed[msg.sender][_spender] = _value;
180 		Approval(msg.sender, _spender, _value);
181 		return true;
182 	}
183 	
184 	/**
185 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
186 		* @param _owner address The address which owns the funds.
187 		* @param _spender address The address which will spend the funds.
188 		* @return A uint256 specifying the amount of tokens still available for the spender.
189 	*/
190 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191 		return allowed[_owner][_spender];
192 	}
193 	
194 	/**
195 		* approve should be called when allowed[_spender] == 0. To increment
196 		* allowed value is better to use this function to avoid 2 calls (and wait until
197 		* the first transaction is mined)
198 		* From MonolithDAO Token.sol
199 	*/
200 	function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
201 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203 		return true;
204 	}
205 	
206 	function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
207 		uint oldValue = allowed[msg.sender][_spender];
208 		if (_subtractedValue > oldValue) {
209 			allowed[msg.sender][_spender] = 0;
210 			} else {
211 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212 		}
213 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 		return true;
215 	}
216 	
217 }
218 
219 contract TEC is StandardToken, Owned {
220 	string public constant name    = "TECHTRADECOIN";  
221 	uint8 public constant decimals = 8;               
222 	string public constant symbol  = "TEC";
223 	bool public canClaimToken = false;
224 	uint256 public constant maxSupply  = 300000000*10**uint256(decimals);
225 	uint256 public constant dateInit=1516924800 ;
226 	
227 	/*          50 days     12months   12months
228 		|------------------|--x--x--x--|--x--x--x--|------------>
229 		01-26-18    ICO         LEND(*)       ECO    FINALIZED
230 		                        DEV
231 		                        MARK
232 		                        ADMIN
233 		(*): 100% tokens
234 	*/
235 	uint256 public constant dateICO=dateInit + 50 days;
236 	uint256 public constant dateRelease3=dateICO + 90 days;
237 	uint256 public constant dateRelease6=dateRelease3 + 90 days;
238 	uint256 public constant dateRelease9=dateRelease6 + 90 days;
239 	uint256 public constant dateRelease12=dateRelease9 + 90 days;
240 	
241 	uint256 public constant dateEcoRelease3=dateRelease12 + 90 days;
242 	uint256 public constant dateEcoRelease6=dateEcoRelease3 + 90 days;
243 	uint256 public constant dateEcoRelease9=dateEcoRelease6 + 90 days;
244 	uint256 public constant dateEcoRelease12=dateEcoRelease9 + 90 days;
245 
246 	bool public isAllocatedICO=false;
247 	
248 	bool public isAllocatedLending=false;
249 	
250 	bool public isAllocated3=false;
251 	bool public isAllocated6=false;
252 	bool public isAllocated9=false;
253 	bool public isAllocated12=false;
254 	
255 	bool public isEcoAllocated3=false;
256 	bool public isEcoAllocated6=false;
257 	bool public isEcoAllocated9=false;
258 	bool public isEcoAllocated12=false;
259 	
260 	enum Stage {
261 		Finalized,
262 		ICO,
263 		Release3,
264 		Release6,
265 		Release9,
266 		Release12,
267 		Eco3,
268 		Eco6,
269 		Eco9,
270 		Eco12
271 	}
272 	
273 	struct Supplies {
274 		uint256 total;
275 		uint256 rawTokens;
276 	}
277 	
278 	//the stage for releasing Tokens
279 	struct StageRelease {
280 		uint256 rawTokens;
281 		uint256 totalRawTokens;
282 	}
283 	
284 	Supplies supplies;
285 	StageRelease public stageICO=StageRelease(maxSupply.percent(21),maxSupply.percent(21));
286 	StageRelease public stageLending=StageRelease(maxSupply.percent(25),maxSupply.percent(25));
287 	StageRelease public stageDevelop=StageRelease(maxSupply.percent(35),maxSupply.percent(35));
288 	StageRelease public stageMarketing=StageRelease(maxSupply.percent(5),maxSupply.percent(5));
289 	StageRelease public stageAdmin=StageRelease(maxSupply.percent(2), maxSupply.percent(2));
290 	StageRelease public stageEco=StageRelease(maxSupply.percent(12), maxSupply.percent(12));
291 	
292 	// Send back ether 
293 	function () {
294 		revert();
295 	}
296 	//getter totalSupply
297 	function totalSupply() public constant returns (uint256 total) {
298 		return supplies.total;
299 	}
300 	
301 	function mintToken(address _owner, uint256 _amount, bool _isRaw) onlyOwner internal {
302 		require(_amount.add(supplies.total)<=maxSupply);
303 		if (_isRaw) {
304 			accounts[_owner].rawTokens=_amount.add(accounts[_owner].rawTokens);
305 			supplies.rawTokens=_amount.add(supplies.rawTokens);
306 			} else {
307 			accounts[_owner].balances=_amount.add(accounts[_owner].balances);
308 		}
309 		supplies.total=_amount.add(supplies.total);
310 		Transfer(0, _owner, _amount);
311 	}
312 	
313 	function transferRaw(address _to, uint256 _value) public returns (bool) {
314 		require(_to != address(0));
315 		require(_value <= accounts[msg.sender].rawTokens);
316 		
317 		
318 		// SafeMath.sub will throw if there is not enough balance.
319 		accounts[msg.sender].rawTokens = accounts[msg.sender].rawTokens.sub(_value);
320 		accounts[_to].rawTokens = accounts[_to].rawTokens.add(_value);
321 		Transfer(msg.sender, _to, _value);
322 		return true;
323 	}
324 	
325 	function setClaimToken(bool approve) onlyOwner public returns (bool) {
326 		canClaimToken=true;
327 		return canClaimToken;
328 	}
329 	
330 	function claimToken(address _owner) public returns (bool amount) {
331 		require(accounts[_owner].rawTokens!=0);
332 		require(canClaimToken);
333 		
334 		uint256 amountToken = accounts[_owner].rawTokens;
335 		accounts[_owner].rawTokens = 0;
336 		accounts[_owner].balances = amountToken + accounts[_owner].balances;
337 		return true;
338 	}
339 	
340 	function balanceOfRaws(address _owner) public constant returns (uint256 balance) {
341 		return accounts[_owner].rawTokens;
342 	}
343 	
344 	function blockTime() constant returns (uint32) {
345 		return uint32(block.timestamp);
346 	}
347 	
348 	function stage() constant returns (Stage) {
349 		
350 		if(blockTime()<=dateICO) {
351 			return Stage.ICO;
352 		}
353 		
354 		if(blockTime()<=dateRelease3) {
355 			return Stage.Release3;
356 		}
357 		
358 		if(blockTime()<=dateRelease6) {
359 			return Stage.Release6;
360 		}
361 		
362 		if(blockTime()<=dateRelease9) {
363 			return Stage.Release9;
364 		}
365 		
366 		if(blockTime()<=dateRelease12) {
367 			return Stage.Release12;
368 		}
369 		
370 		if(blockTime()<=dateEcoRelease3) {
371 			return Stage.Eco3;
372 		}
373 		
374 		if(blockTime()<=dateEcoRelease6) {
375 			return Stage.Eco6;
376 		}
377 		
378 		if(blockTime()<=dateEcoRelease9) {
379 			return Stage.Eco9;
380 		}
381 		
382 		if(blockTime()<=dateEcoRelease12) {
383 			return Stage.Eco12;
384 		}
385 		
386 		return Stage.Finalized;
387 	}
388 	
389 	function releaseStage (uint256 amount, StageRelease storage stageRelease, bool isRaw) internal returns (uint256) {
390 		if(stageRelease.rawTokens>0) {
391 			int256 remain=int256(stageRelease.rawTokens - amount);
392 			if(remain<0)
393 			amount=stageRelease.rawTokens;
394 			stageRelease.rawTokens=stageRelease.rawTokens.sub(amount);
395 			mintToken(owner, amount, isRaw);
396 			return amount;
397 		}
398 		return 0;
399 	}
400 	
401 	function releaseNotEco(uint256 percent, bool isRaw) internal returns (uint256) {
402 		
403 		uint256 amountDevelop = stageDevelop.totalRawTokens.percent(percent);
404 		uint256 amountMarketing = stageMarketing.totalRawTokens.percent(percent);
405 		uint256 amountAdmin = stageAdmin.totalRawTokens.percent(percent);
406 		uint256 amountSum = amountDevelop+amountMarketing+amountAdmin;
407 		
408 		releaseStage(amountDevelop, stageDevelop, isRaw);
409 		releaseStage(amountMarketing, stageMarketing, isRaw);
410 		releaseStage(amountAdmin, stageAdmin, isRaw);
411 		return amountSum;
412 	}
413 	
414 	function releaseEco(uint256 percent, bool isRaw) internal returns (uint256) {
415 		uint256 amountEco = stageEco.totalRawTokens.percent(percent);
416 		releaseStage(amountEco, stageEco, isRaw);      
417 		return amountEco;
418 	}
419 	
420 	function release100Percent(bool isRaw, StageRelease storage stageRelease) internal returns (uint256) {
421 		uint256 amount = stageRelease.totalRawTokens.percent(100);
422 		releaseStage(amount, stageRelease, isRaw);      
423 		return amount;
424 	}
425 	
426 	//main function, must run for releasing.
427 	//##################################################################33
428 	function release(bool isRaw) onlyOwner public returns (uint256) {
429 		uint256 amountSum=0;
430 		
431 		if(stage()==Stage.ICO && isAllocatedICO==false) {
432 			uint256 amountICO=release100Percent(isRaw, stageICO);
433 			amountSum=amountSum.add(amountICO);
434 			isAllocatedICO=true;
435 			return amountSum;
436 		}
437 		
438 		if(stage()==Stage.Release3 && isAllocated3==false) {
439 			uint256 amountRelease3=releaseNotEco(30, isRaw);
440 			amountSum=amountSum.add(amountRelease3);
441 			//for lending
442 			amountRelease3=release100Percent(isRaw, stageLending);
443 			amountSum=amountSum.add(amountRelease3);
444 			isAllocated3=true;
445 			return amountSum;
446 		}
447 		
448 		if(stage()==Stage.Release6 && isAllocated6==false) {
449 			uint256 amountRelease6=releaseNotEco(20, isRaw);
450 			amountSum=amountSum.add(amountRelease6);
451 			isAllocated6=true;
452 			return amountSum;
453 		}
454 		
455 		if(stage()==Stage.Release9 && isAllocated9==false) {
456 			uint256 amountRelease9=releaseNotEco(28, isRaw);
457 			amountSum=amountSum.add(amountRelease9);
458 			isAllocated9=true;
459 			return amountSum;
460 		}
461 		
462 		if(stage()==Stage.Release12 && isAllocated12==false) {
463 			uint256 amountRelease12=releaseNotEco(22, isRaw);
464 			amountSum=amountSum.add(amountRelease12);
465 			isAllocated12=true;
466 			return amountSum;
467 		}
468 		
469 		if(stage()==Stage.Eco3 && isEcoAllocated3==false) {
470 			uint256 amountEcoRelease3=releaseEco(30, isRaw);
471 			amountSum=amountSum.add(amountEcoRelease3);
472 			isEcoAllocated3=true;
473 			return amountSum;
474 		}
475 		
476 		if(stage()==Stage.Eco6 && isEcoAllocated6==false) {
477 			uint256 amountEcoRelease6=releaseEco(20, isRaw);
478 			amountSum=amountSum.add(amountEcoRelease6);
479 			isEcoAllocated6=true;
480 			return amountSum;
481 		}
482 		
483 		if(stage()==Stage.Eco9 && isEcoAllocated9==false) {
484 			uint256 amountEcoRelease9=releaseEco(28, isRaw);
485 			amountSum=amountSum.add(amountEcoRelease9);
486 			isEcoAllocated9=true;
487 			return amountSum;
488 		}
489 		if(stage()==Stage.Eco12 && isEcoAllocated12==false) {
490 			uint256 amountEcoRelease12=releaseEco(22, isRaw);
491 			amountSum=amountSum.add(amountEcoRelease12);
492 			isEcoAllocated12=true;
493 			return amountSum;
494 		}
495 		return amountSum;
496 	}
497 }