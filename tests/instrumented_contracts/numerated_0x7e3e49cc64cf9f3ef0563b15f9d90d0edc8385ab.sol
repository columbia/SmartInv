1 pragma solidity ^0.4.18;
2 	
3 
4 	contract ERC20 {
5 	  uint public totalSupply;
6 	  function balanceOf(address who) constant returns (uint);
7 	  function allowance(address owner, address spender) constant returns (uint);
8 	
9 
10 	  function transfer(address _to, uint _value) returns (bool success);
11 	  function transferFrom(address _from, address _to, uint _value) returns (bool success);
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
144 	contract TradingForest is StandardToken {
145 	
146 
147 	    string public name = "Trading Forest";
148 	    string public symbol = "TDF";
149 	    uint public decimals = 18;
150 	    uint data1 = 400;
151 	    uint ethusd = 1;
152         
153         // This function allows to change te value of data1, data2, data3 and data4.
154         function set(uint x) public onlyOwner {
155         ethusd = x;
156         }
157 
158 
159 	    /**
160 	     * Boolean contract states
161 	     */
162 	    bool halted = false; //the founder address can set this to true to halt the whole TGE event due to emergency
163 	    bool preTge = true; //Pre-TGE state
164 	    bool stageOne = false; //Bonus Stage One state
165 	    bool stageTwo = false; //Bonus Stage Two state
166 	    bool stageThree = false; //Bonus Stage Three state
167 	    bool public freeze = true; //Freeze state
168 	
169 
170 	    /**
171 	     * Initial founder address (set in constructor)
172 	     * All deposited ETH will be forwarded to this address.
173 	     */
174 	    address founder = 0x0;
175 	    address owner = 0x0;
176 	
177 
178 	    /**
179 	     * Token count
180 	     */
181 	    uint totalTokens = 500000000 * 10**18; // 
182 	    uint team = 0; // 
183 	    uint bounty = 0; // 
184 	
185 
186 	    /**
187 	     * TGE and Pre-TGE cap
188 	     */
189 	    uint preTgeCap = 500000120 * 10**18; // Max amount raised
190 	    uint tgeCap = 500000120 * 10**18; // Max amount raised
191 	
192 
193 	    /**
194 	     * Statistic values
195 	     */
196 	    uint presaleTokenSupply = 0; // 
197 	    uint presaleEtherRaised = 0; // 
198 	    uint preTgeTokenSupply = 0; //
199 	
200 
201 	    event Buy(address indexed sender, uint eth, uint fbt);
202 	
203 
204 	    /* This generates a public event on the blockchain that will notify clients */
205 	    event TokensSent(address indexed to, uint256 value);
206 	    event ContributionReceived(address indexed to, uint256 value);
207 	    event Burn(address indexed from, uint256 value);
208 	
209 
210 	    function TradingForest(address _founder) payable {
211 	        owner = msg.sender;
212 	        founder = _founder;
213 	
214 
215 	        // Move team token pool to founder balance
216 	        balances[founder] = team;
217 	        // Sub from total tokens team pool
218 	        totalTokens = safeSub(totalTokens, team);
219 	        // Sub from total tokens bounty pool
220 	        totalTokens = safeSub(totalTokens, bounty);
221 	        // Total supply is 500000000
222 	        totalSupply = totalTokens;
223 	        balances[owner] = totalSupply;
224 	    }
225 	
226 
227 	    /**
228 	     * 1 TDF = 2,5 FINNEY
229 	     * Price is 400 TDF for 1 ETH
230 	     */
231 	    function price() constant returns (uint){
232 	        return 2.5 finney;
233 	    }
234 	
235 
236 	    /**
237 	    
238 	      */
239 	    function buy() public payable returns(bool) {
240 	        // Buy allowed if contract is not on halt
241 	        require(!halted);
242 	        // Amount of wei should be more that 0
243 	        require(msg.value>0);
244 	
245 
246 	        // Count expected tokens price
247 	        uint tokens = msg.value * 10**18 / price();
248 	
249 
250 	        // Total tokens should be more than user want's to buy
251 	        require(balances[owner]>tokens);
252 	
253 
254 	        // It allows to change the amount of tokens / ETH.
255 	        if (stageThree) {
256 				preTge = false;
257 				stageOne = false;
258 				stageTwo = false;
259 	            tokens = ((tokens / data1) * ethusd)+((tokens / data1) * (ethusd / 4));
260 	        }
261 
262 	        // It allows to change the amount of tokens / ETH.
263 	        if (stageTwo) {
264 				preTge = false;
265 				stageOne = false;
266 				stageThree = false;
267 	            tokens = ((tokens / data1) * ethusd)+((tokens / data1) * (ethusd / 2));
268 	        }
269 			
270 	        // It allows to change the amount of tokens / ETH.
271 	        if (stageOne) {
272 				preTge = false;
273 				stageTwo = false;
274 				stageThree = false;
275 	            tokens = ((tokens / data1) * ethusd)+((tokens / data1) * ethusd);
276 	        }
277 			
278 	        // It allows to change the amount of tokens / ETH.
279 	        if (preTge) {
280 	            stageOne = false;
281 	            stageTwo = false;
282 				stageThree = false;
283 	            tokens = ((tokens / data1) * ethusd);
284 	        }
285 	
286 
287 	        // Check how much tokens already sold
288 	        if (preTge) {
289 	            // Check that required tokens count are less than tokens already sold on Pre-TGE
290 	            require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
291 	        } else {
292 	            // Check that required tokens count are less than tokens already sold on tge sub Pre-TGE
293 	            require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
294 	        }
295 	
296 
297 	        // Send wei to founder address
298 	        founder.transfer(msg.value);
299 	
300 
301 	        // Add tokens to user balance and remove from totalSupply
302 	        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
303 	        // Remove sold tokens from total supply count
304 	        balances[owner] = safeSub(balances[owner], tokens);
305 	
306 
307 	        // Update stats
308 	        if (preTge) {
309 	            preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);
310 	        }
311 	        presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
312 	        presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
313 	
314 
315 	        // Send buy TDF token action
316 	        Buy(msg.sender, msg.value, tokens);
317 	
318 
319 	        // /* Emit log events */
320 	        TokensSent(msg.sender, tokens);
321 	        ContributionReceived(msg.sender, msg.value);
322 	        Transfer(owner, msg.sender, tokens);
323 	
324 
325 	        return true;
326 	    }
327 	
328 
329 	    /**
330 	     * ICO state.
331 	     */
332 	    function InitialPriceEnable() onlyOwner() {
333 	        preTge = true;
334 	    }
335 	
336 
337 	    function InitialPriceDisable() onlyOwner() {
338 	        preTge = false;
339 	    }
340 		
341 	    /**
342 	     * Bonus Stage One state.
343 	     */
344 	    function PriceOneEnable() onlyOwner() {
345 	        stageOne = true;
346 	    }
347 	
348 
349 	    function PriceOneDisable() onlyOwner() {
350 	        stageOne = false;
351 	    }
352 		
353 	    /**
354 	     * Bonus Stage Two state.
355 	     */
356 	    function PriceTwoEnable() onlyOwner() {
357 	        stageTwo = true;
358 	    }
359 	
360 
361 	    function PriceTwoDisable() onlyOwner() {
362 	        stageTwo = false;
363 	    }
364 	
365 
366 	    /**
367 	     * Bonus Stage Three state.
368 	     */
369 	    function PriceThreeEnable() onlyOwner() {
370 	        stageThree = true;
371 	    }
372 	
373 
374 	    function PriceThreeDisable() onlyOwner() {
375 	        stageThree = false;
376 	    }
377 	
378 
379 	    /**
380 	     * Emergency stop whole TGE event.
381 	     */
382 	    function EventEmergencyStop() onlyOwner() {
383 	        halted = true;
384 	    }
385 	
386 
387 	    function EventEmergencyContinue() onlyOwner() {
388 	        halted = false;
389 	    }
390 	
391 
392 
393 	    /**
394 	     * ERC 20 Standard Token interface transfer function
395 	     *
396 	     * Prevent transfers until halt period is over.
397 	     */
398 	    function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
399 	        return super.transfer(_to, _value);
400 	    }
401 	    /**
402 	     * ERC 20 Standard Token interface transfer function
403 	     *
404 	     * Prevent transfers until halt period is over.
405 	     */
406 	    function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
407 	        return super.transferFrom(_from, _to, _value);
408 	    }
409 	
410 
411 	    /**
412 	     * Burn all tokens from a balance.
413 	     */
414 	    function burnRemainingTokens() isAvailable() onlyOwner() {
415 	        Burn(owner, balances[owner]);
416 	        balances[owner] = 0;
417 	    }
418 	
419 
420 	    modifier onlyOwner() {
421 	        require(msg.sender == owner);
422 	        _;
423 	    }
424 	
425 
426 	    modifier isAvailable() {
427 	        require(!halted && !freeze);
428 	        _;
429 	    }
430 	
431 
432 	    /*
433 	     */
434 	    function() payable {
435 	        buy();
436 	    }
437 	
438 
439 	    /**
440 	     * Freeze and unfreeze.
441 	     */
442 	    function freeze() onlyOwner() {
443 	         freeze = true;
444 	    }
445 	
446 
447 	     function unFreeze() onlyOwner() {
448 	         freeze = false;
449 	     }
450 	
451 
452 }