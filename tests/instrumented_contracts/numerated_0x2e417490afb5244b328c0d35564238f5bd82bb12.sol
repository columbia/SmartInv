1 pragma solidity ^0.4.13;
2 	
3 
4 	contract ERC20 {
5 	  uint public totalSupply;
6 	  function balanceOf(address who) constant returns (uint);
7 	  function allowance(address owner, address spender) constant returns (uint);
8 	
9 
10 	  function transfer(address to, uint value) returns (bool ok);
11 	  function transferFrom(address from, address to, uint value) returns (bool ok);
12 	  function approve(address spender, uint value) returns (bool ok);
13 	  event Transfer(address indexed from, address indexed to, uint value);
14 	  event Approval(address indexed owner, address indexed spender, uint value);
15 	}
16 	
17 
18 	/**
19 	 * Math operations with safety checks
20 	 */
21 	contract SafeMath {
22 	  function safeMul(uint a, uint b) internal returns (uint) {
23 	    uint c = a * b;
24 	    assert(a == 0 || c / a == b);
25 	    return c;
26 	  }
27 	
28 
29 	  function safeDiv(uint a, uint b) internal returns (uint) {
30 	    assert(b > 0);
31 	    uint c = a / b;
32 	    assert(a == b * c + a % b);
33 	    return c;
34 	  }
35 	
36 
37 	  function safeSub(uint a, uint b) internal returns (uint) {
38 	    assert(b <= a);
39 	    return a - b;
40 	  }
41 	
42 
43 	  function safeAdd(uint a, uint b) internal returns (uint) {
44 	    uint c = a + b;
45 	    assert(c>=a && c>=b);
46 	    return c;
47 	  }
48 	
49 
50 	  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51 	    return a >= b ? a : b;
52 	  }
53 	
54 
55 	  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56 	    return a < b ? a : b;
57 	  }
58 	
59 
60 	  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
61 	    return a >= b ? a : b;
62 	  }
63 	
64 
65 	  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
66 	    return a < b ? a : b;
67 	  }
68 	
69 
70 	}
71 	
72 
73 	contract StandardToken is ERC20, SafeMath {
74 	
75 
76 	  /* Token supply got increased and a new owner received these tokens */
77 	  event Minted(address receiver, uint amount);
78 	
79 
80 	  /* Actual balances of token holders */
81 	  mapping(address => uint) balances;
82 	
83 
84 	  /* approve() allowances */
85 	  mapping (address => mapping (address => uint)) allowed;
86 	
87 
88 	  /* Interface declaration */
89 	  function isToken() public constant returns (bool weAre) {
90 	    return true;
91 	  }
92 	
93 
94 	  function transfer(address _to, uint _value) returns (bool success) {
95 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
96 	    balances[_to] = safeAdd(balances[_to], _value);
97 	    Transfer(msg.sender, _to, _value);
98 	    return true;
99 	  }
100 	
101 
102 	  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
103 	    uint _allowance = allowed[_from][msg.sender];
104 	
105 
106 	    balances[_to] = safeAdd(balances[_to], _value);
107 	    balances[_from] = safeSub(balances[_from], _value);
108 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
109 	    Transfer(_from, _to, _value);
110 	    return true;
111 	  }
112 	
113 
114 	  function balanceOf(address _owner) constant returns (uint balance) {
115 	    return balances[_owner];
116 	  }
117 	
118 
119 	  function approve(address _spender, uint _value) returns (bool success) {
120 	
121 
122 	    // To change the approve amount you first have to reduce the addresses`
123 	    //  allowance to zero by calling `approve(_spender, 0)` if it is not
124 	    //  already 0 to mitigate the race condition described here:
125 	    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126 
127 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 	
129 
130 	    allowed[msg.sender][_spender] = _value;
131 	    Approval(msg.sender, _spender, _value);
132 	    return true;
133 	  }
134 	
135 
136 	  function allowance(address _owner, address _spender) constant returns (uint remaining) {
137 	    return allowed[_owner][_spender];
138 	  }
139 	
140 
141 	}
142 	
143 
144 	contract TechBenchToken is StandardToken {
145 	
146 
147 	    string public name = "Nodium";
148 	    string public symbol = "N";
149 	    uint public decimals = 0;
150 	
151 
152 	    /**
153 	     * Boolean contract states
154 	     */
155 	    bool halted = false; //the founder address can set this to true to halt the whole TGE event due to emergency
156 	    bool preTge = true; //Pre-TGE state
157 	    bool stageOne = false; //Bonus Stage One state
158 	    bool stageTwo = false; //Bonus Stage Two state
159 	    bool stageThree = false; //Bonus Stage Three state
160 	    bool public freeze = true; //Freeze state
161 	
162 
163 	    /**
164 	     * Initial founder address (set in constructor)
165 	     * All deposited ETH will be forwarded to this address.
166 	     * Address is a multisig wallet.
167 	     */
168 	    address founder = 0x0;
169 	    address owner = 0x0;
170 	
171 
172 	    /**
173 	     * Token count
174 	     */
175 	    uint totalTokens = 40000000;
176 	    uint team = 2800000;
177 	    uint bounty = 1200000; // Bounty count
178 	
179 
180 	    /**
181 	     * TGE and Pre-TGE cap
182 	     */
183 	    uint preTgeCap = 36000120; // Max amount raised during Pre-TGE is 30.000 // 1200 unidades representan 1 ETH (10%)
184 	    uint tgeCap = 36000120; // Max amount raised during Pre-TGE is 30.000 // 1200 unidades representan 1 ETH
185 	
186 
187 	    /**
188 	     * Statistic values
189 	     */
190 	    uint presaleTokenSupply = 0; // This will keep track of the token supply created during the TGE event
191 	    uint presaleEtherRaised = 0; // This will keep track of the Ether raised during the TGE event
192 	    uint preTgeTokenSupply = 0; // This will keep track of the token supply created during the Pre-TGE
193 	
194 
195 	    event Buy(address indexed sender, uint eth, uint fbt);
196 	
197 
198 	    /* This generates a public event on the blockchain that will notify clients */
199 	    event TokensSent(address indexed to, uint256 value);
200 	    event ContributionReceived(address indexed to, uint256 value);
201 	    event Burn(address indexed from, uint256 value);
202 	
203 
204 	    function TechBenchToken(address _founder) payable {
205 	        owner = msg.sender;
206 	        founder = _founder;
207 	
208 
209 	        // Move team token pool to founder balance
210 	        balances[founder] = team;
211 	        // Sub from total tokens team pool
212 	        totalTokens = safeSub(totalTokens, team);
213 	        // Sub from total tokens bounty pool
214 	        totalTokens = safeSub(totalTokens, bounty);
215 	        // Total supply is 51000000
216 	        totalSupply = totalTokens;
217 	        balances[owner] = totalSupply;
218 	    }
219 	
220 
221 	    /**
222 	     * 1 TBCH = 1 FINNEY
223 	     * Price is 1000 TechBench for 1 ETH
224 	     */
225 	    function price() constant returns (uint){
226 	        return 1 finney;
227 	    }
228 	
229 
230 	    /**
231 	      * The basic entry point to participate the TGE event process.
232 	      *
233 	      * Pay for funding, get invested tokens back in the sender address.
234 	      */
235 	    function buy() public payable returns(bool) {
236 	        // Buy allowed if contract is not on halt
237 	        require(!halted);
238 	        // Amount of wei should be more that 0
239 	        require(msg.value>0);
240 	
241 
242 	        // Count expected tokens price
243 	        uint tokens = msg.value / price();
244 	
245 
246 	        // Total tokens should be more than user want's to buy
247 	        require(balances[owner]>tokens);
248 	
249 
250 	        // Disable other stages if Stage Three is enabled
251 	        if (stageThree) {
252 				preTge = false;
253 				stageOne = false;
254 				stageTwo = false;
255 	        }
256 			
257 	        // Give +10% of tokents on Stage Two and disable other stages
258 	        if (stageTwo) {
259 				preTge = false;
260 				stageOne = false;
261 	            tokens = tokens + (tokens / 20);
262 	        }
263 			
264 	        // Give +20% of tokents on Stage One and disable other stages
265 	        if (stageOne) {
266 				preTge = false;
267 	            tokens = tokens + (tokens / 10);
268 	        }
269 			
270 	        // Give +50% of tokents on Pre-TGE
271 	        if (preTge) {
272 	            tokens = tokens + (tokens / 5);
273 	        }
274 	
275 
276 	        // Check how much tokens already sold
277 	        if (preTge) {
278 	            // Check that required tokens count are less than tokens already sold on Pre-TGE
279 	            require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
280 	        } else {
281 	            // Check that required tokens count are less than tokens already sold on tge sub Pre-TGE
282 	            require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
283 	        }
284 	
285 
286 	        // Send wei to founder address
287 	        founder.transfer(msg.value);
288 	
289 
290 	        // Add tokens to user balance and remove from totalSupply
291 	        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
292 	        // Remove sold tokens from total supply count
293 	        balances[owner] = safeSub(balances[owner], tokens);
294 	
295 
296 	        // Update stats
297 	        if (preTge) {
298 	            preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);
299 	        }
300 	        presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
301 	        presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
302 	
303 
304 	        // Send buy TBCH token action
305 	        Buy(msg.sender, msg.value, tokens);
306 	
307 
308 	        // /* Emit log events */
309 	        TokensSent(msg.sender, tokens);
310 	        ContributionReceived(msg.sender, msg.value);
311 	        Transfer(owner, msg.sender, tokens);
312 	
313 
314 	        return true;
315 	    }
316 	
317 
318 	    /**
319 	     * Pre-TGE state.
320 	     */
321 	    function PreTgeEnable() onlyOwner() {
322 	        preTge = true;
323 	    }
324 	
325 
326 	    function PreTgeDisable() onlyOwner() {
327 	        preTge = false;
328 	    }
329 		
330 	    /**
331 	     * Bonus Stage One state.
332 	     */
333 	    function StageOneEnable() onlyOwner() {
334 	        stageOne = true;
335 	    }
336 	
337 
338 	    function StageOneDisable() onlyOwner() {
339 	        stageOne = false;
340 	    }
341 		
342 	    /**
343 	     * Bonus Stage Two state.
344 	     */
345 	    function StageTwoEnable() onlyOwner() {
346 	        stageTwo = true;
347 	    }
348 	
349 
350 	    function StageTwoDisable() onlyOwner() {
351 	        stageTwo = false;
352 	    }
353 	
354 
355 	    /**
356 	     * Bonus Stage Three state.
357 	     */
358 	    function StageThreeEnable() onlyOwner() {
359 	        stageThree = true;
360 	    }
361 	
362 
363 	    function StageThreeDisable() onlyOwner() {
364 	        stageThree = false;
365 	    }
366 	
367 
368 	    /**
369 	     * Emergency stop whole TGE event.
370 	     */
371 	    function EventEmergencyStop() onlyOwner() {
372 	        halted = true;
373 	    }
374 	
375 
376 	    function EventEmergencyContinue() onlyOwner() {
377 	        halted = false;
378 	    }
379 	
380 
381 	    /**
382 	     * Transfer bounty to target address from bounty pool
383 	     */
384 	    function sendTeamTokens(address _to, uint256 _value) onlyOwner() {
385 	        balances[founder] = safeSub(balances[founder], _value);
386 	        balances[_to] = safeAdd(balances[_to], _value);
387 	        // /* Emit log events */
388 	        TokensSent(_to, _value);
389 	        Transfer(owner, _to, _value);
390 	    }
391 	
392 
393 	    /**
394 	     * Transfer team tokens to target address
395 	     */
396 	    function sendBounty(address _to, uint256 _value) onlyOwner() {
397 	        bounty = safeSub(bounty, _value);
398 	        balances[_to] = safeAdd(balances[_to], _value);
399 	        // /* Emit log events */
400 	        TokensSent(_to, _value);
401 	        Transfer(owner, _to, _value);
402 	    }
403 	
404 
405 	    /**
406 	     * Transfer bounty to target address from bounty pool
407 	     */
408 	    function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
409 	        balances[owner] = safeSub(balances[owner], _value);
410 	        balances[_to] = safeAdd(balances[_to], _value);
411 	        // /* Emit log events */
412 	        TokensSent(_to, _value);
413 	        Transfer(owner, _to, _value);
414 	    }
415 	
416 
417 	    /**
418 	     * ERC 20 Standard Token interface transfer function
419 	     *
420 	     * Prevent transfers until halt period is over.
421 	     */
422 	    function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
423 	        return super.transfer(_to, _value);
424 	    }
425 	    /**
426 	     * ERC 20 Standard Token interface transfer function
427 	     *
428 	     * Prevent transfers until halt period is over.
429 	     */
430 	    function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
431 	        return super.transferFrom(_from, _to, _value);
432 	    }
433 	
434 
435 	    /**
436 	     * Burn all tokens from a balance.
437 	     */
438 	    function burnRemainingTokens() isAvailable() onlyOwner() {
439 	        Burn(owner, balances[owner]);
440 	        balances[owner] = 0;
441 	    }
442 	
443 
444 	    modifier onlyOwner() {
445 	        require(msg.sender == owner);
446 	        _;
447 	    }
448 	
449 
450 	    modifier isAvailable() {
451 	        require(!halted && !freeze);
452 	        _;
453 	    }
454 	
455 
456 	    /**
457 	     * Just being sent some cash? Let's buy tokens
458 	     */
459 	    function() payable {
460 	        buy();
461 	    }
462 	
463 
464 	    /**
465 	     * Freeze and unfreeze TGE.
466 	     */
467 	    function freeze() onlyOwner() {
468 	         freeze = true;
469 	    }
470 	
471 
472 	     function unFreeze() onlyOwner() {
473 	         freeze = false;
474 	     }
475 	
476 
477 	    /**
478 	     * Replaces an owner
479 	     */
480 	    function changeOwner(address _to) onlyOwner() {
481 	        balances[_to] = balances[owner];
482 	        balances[owner] = 0;
483 	        owner = _to;
484 	    }
485 	
486 
487 	    /**
488 	     * Replaces a founder, transfer team pool to new founder balance
489 	     */
490 	    function changeFounder(address _to) onlyOwner() {
491 	        balances[_to] = balances[founder];
492 	        balances[founder] = 0;
493 	        founder = _to;
494 	    }
495 	}