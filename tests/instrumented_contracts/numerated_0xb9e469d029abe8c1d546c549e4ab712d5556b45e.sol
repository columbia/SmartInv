1 pragma solidity ^0.4.18;
2 	
3 	contract ERC20 {
4 	  uint public totalSupply;
5 	  function balanceOf(address who) constant returns (uint);
6 	  function allowance(address owner, address spender) constant returns (uint);
7 	
8 
9 	  function transfer(address _to, uint _value) returns (bool success);
10 	  function transferFrom(address _from, address _to, uint _value) returns (bool success);
11 	  function approve(address spender, uint value) returns (bool ok);
12 	  event Transfer(address indexed from, address indexed to, uint value);
13 	  event Approval(address indexed owner, address indexed spender, uint value);
14 	}
15 	
16 
17 	/**
18 	 * Math operations with safety checks
19 	 */
20 	contract SafeMath {
21 	  function safeMul(uint a, uint b) internal returns (uint) {
22 	    uint c = a * b;
23 	    assert(a == 0 || c / a == b);
24 	    return c;
25 	  }
26 	
27 
28 	  function safeDiv(uint a, uint b) internal returns (uint) {
29 	    assert(b > 0);
30 	    uint c = a / b;
31 	    assert(a == b * c + a % b);
32 	    return c;
33 	  }
34 	
35 
36 	  function safeSub(uint a, uint b) internal returns (uint) {
37 	    assert(b <= a);
38 	    return a - b;
39 	  }
40 	
41 
42 	  function safeAdd(uint a, uint b) internal returns (uint) {
43 	    uint c = a + b;
44 	    assert(c>=a && c>=b);
45 	    return c;
46 	  }
47 	
48 
49 	  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50 	    return a >= b ? a : b;
51 	  }
52 	
53 
54 	  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55 	    return a < b ? a : b;
56 	  }
57 	
58 
59 	  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
60 	    return a >= b ? a : b;
61 	  }
62 	
63 
64 	  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
65 	    return a < b ? a : b;
66 	  }
67 	}
68 	
69 
70 	contract StandardToken is ERC20, SafeMath {
71 	
72 
73 	  /* Token supply got increased and a new owner received these tokens */
74 	  event Minted(address receiver, uint amount);
75 	
76 
77 	  /* Actual balances of token holders */
78 	  mapping(address => uint) balances;
79 	
80 
81 	  /* approve() allowances */
82 	  mapping (address => mapping (address => uint)) allowed;
83 	
84 
85 	  /* Interface declaration */
86 	  function isToken() public constant returns (bool weAre) {
87 	    return true;
88 	  }
89 	
90 
91 	  function transfer(address _to, uint _value) returns (bool success) {
92 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
93 	    balances[_to] = safeAdd(balances[_to], _value);
94 	    Transfer(msg.sender, _to, _value);
95 	    return true;
96 	  }
97 	
98 
99 	  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
100 	    uint _allowance = allowed[_from][msg.sender];
101 	
102 
103 	    balances[_to] = safeAdd(balances[_to], _value);
104 	    balances[_from] = safeSub(balances[_from], _value);
105 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
106 	    Transfer(_from, _to, _value);
107 	    return true;
108 	  }
109 	
110 
111 	  function balanceOf(address _owner) constant returns (uint balance) {
112 	    return balances[_owner];
113 	  }
114 	
115 
116 	  function approve(address _spender, uint _value) returns (bool success) {
117 
118 	
119 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
120 	
121 
122 	    allowed[msg.sender][_spender] = _value;
123 	    Approval(msg.sender, _spender, _value);
124 	    return true;
125 	  }
126 	
127 
128 	  function allowance(address _owner, address _spender) constant returns (uint remaining) {
129 	    return allowed[_owner][_spender];
130 	  }
131 	}
132 
133 	contract RealstateOceanProject1 is StandardToken {
134 	
135 
136 	    string public name = "Realstate Ocean Project 1";
137 	    string public symbol = "RSO-P1";
138 	    uint public decimals = 18;
139 	    uint EthPrice = 385;
140 	 
141         function set(uint x) public onlyOwner {
142         EthPrice = x;
143         }
144 
145 
146 	    /**
147 	     * Boolean contract states
148 	     */
149 	    bool halted = false; //the founder address can set this to true to halt the whole ICO event due to emergency
150 	    bool ICO = true; //ICO state
151 	    bool public freeze = true; //Freeze state
152 	
153 
154 	    /**
155 	     * Initial founder address (set in constructor)
156 	     * All deposited ETH will be forwarded to this address.
157 	     */
158 	    address founder = 0x0;
159 	    address owner = 0x0;
160 	
161 
162 	    /**
163 	     * Token count
164 	     */
165 	    uint totalTokens = 100000000 * 10**18;
166 	    uint team = 0; // No Team
167 	    uint bounty = 0; // No Bounty
168 	
169 
170 	    /**
171 	     * ICO cap
172 	     */
173 	    uint ICOCap = 10000000120 * 10**18; // Max amount raised during ICO is 10.000.000 // 1000 unidades representan 1 ETH 
174 
175 
176 	    /**
177 	     * Statistic values
178 	     */
179 	    uint presaleTokenSupply = 0; // This will keep track of the token supply created during the event
180 	    uint presaleEtherRaised = 0; // This will keep track of the Ether raised during the event
181 	    uint ICOTokenSupply = 0; // This will keep track of the token supply created during the ICO
182 	
183 
184 	    event Buy(address indexed sender, uint eth, uint fbt);
185 	
186 
187 	    /* This generates a public event on the blockchain that will notify clients */
188 	    event TokensSent(address indexed to, uint256 value);
189 	    event ContributionReceived(address indexed to, uint256 value);
190 	    event Burn(address indexed from, uint256 value);
191 	
192 
193 	    function RealstateOceanProject1(address _founder) payable {
194 	        owner = msg.sender;
195 	        founder = _founder;
196 	
197 
198 	        // Move team token pool to founder balance
199 	        balances[founder] = team;
200 	        // Sub from total tokens team pool
201 	        totalTokens = safeSub(totalTokens, team);
202 	        // Sub from total tokens bounty pool
203 	        totalTokens = safeSub(totalTokens, bounty);
204 	        // Total supply is 100000000
205 	        totalSupply = totalTokens;
206 	        balances[owner] = totalSupply;
207 	    }
208 	
209 
210 	    /**
211 	     * 1 RSO-P1 = 1 FINNEY
212 	     * Price is 1000 Realstate Ocean Projetc 1 for 1 ETH
213 	     */
214 	    function price() constant returns (uint){
215 	        return 1 finney;
216 	    }
217 	
218 
219 	    /**
220 	      * The basic entry point to participate the event process.
221 	      *
222 	      * Pay for funding, get invested tokens back in the sender address.
223 	      */
224 	    function buy() public payable returns(bool) {
225 	        // Buy allowed if contract is not on halt
226 	        require(!halted);
227 	        // Amount of wei should be more that 0
228 	        require(msg.value>0);
229 	
230 
231 	        // Count expected tokens price
232 	        uint tokens = msg.value * 10**18 / price();
233 	
234 
235 	        // Total tokens should be more than user want's to buy
236 	        require(balances[owner]>tokens);
237 	
238 
239 	        // ICO Token Price
240 	        if (ICO) {
241 	            tokens = (tokens / 1000) * EthPrice;
242 	        }
243 	
244 
245 	        // Check how much tokens already sold
246 	        if (ICO) {
247 	            // Check that required tokens count are less than tokens already sold on ICO
248 	            require(safeAdd(presaleTokenSupply, tokens) < ICOCap);
249 	        } 
250 
251 	        // Send wei to founder address
252 	        founder.transfer(msg.value);
253 	
254 
255 	        // Add tokens to user balance and remove from totalSupply
256 	        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
257 	        // Remove sold tokens from total supply count
258 	        balances[owner] = safeSub(balances[owner], tokens);
259 	
260 
261 	        // Update stats
262 	        if (ICO) {
263 	            ICOTokenSupply  = safeAdd(ICOTokenSupply, tokens);
264 	        }
265 	        presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
266 	        presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
267 	
268 
269 	        // Send buy RSO-P1 token action
270 	        Buy(msg.sender, msg.value, tokens);
271 	
272 
273 	        // /* Emit log events */
274 	        TokensSent(msg.sender, tokens);
275 	        ContributionReceived(msg.sender, msg.value);
276 	        Transfer(owner, msg.sender, tokens);
277 	
278 
279 	        return true;
280 	    }
281 	
282 
283 	    /**
284 	     * ICO state.
285 	     */
286 	    function InitialPriceEnable() onlyOwner() {
287 	        ICO = true;
288 	    }
289 	
290 
291 	    function InitialPriceDisable() onlyOwner() {
292 	        ICO = false;
293 	    }
294 		
295 	  
296 	    /**
297 	     * Emergency stop whole ICO event.
298 	     */
299 	    function EventEmergencyStop() onlyOwner() {
300 	        halted = true;
301 	    }
302 	
303 
304 	    function EventEmergencyContinue() onlyOwner() {
305 	        halted = false;
306 	    }
307 	
308 
309 	    /**
310 	     * ERC 20 Standard Token interface transfer function
311 	     *
312 	     * Prevent transfers until halt period is over.
313 	     */
314 	    function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
315 	        return super.transfer(_to, _value);
316 	    }
317 	    /**
318 	     * ERC 20 Standard Token interface transfer function
319 	     *
320 	     * Prevent transfers until halt period is over.
321 	     */
322 	    function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
323 	        return super.transferFrom(_from, _to, _value);
324 	    }
325 	
326 
327 	    /**
328 	     * Burn all tokens from a balance.
329 	     */
330 	    function burnRemainingTokens() isAvailable() onlyOwner() {
331 	        Burn(owner, balances[owner]);
332 	        balances[owner] = 0;
333 	    }
334 	
335 
336 	    modifier onlyOwner() {
337 	        require(msg.sender == owner);
338 	        _;
339 	    }
340 	
341 
342 	    modifier isAvailable() {
343 	        require(!halted && !freeze);
344 	        _;
345 	    }
346 	
347 
348 	    /**
349 	     * Buy tokens
350 	     */
351 	    function() payable {
352 	        buy();
353 	    }
354 	
355 
356 	    /**
357 	     * Freeze and unfreeze ICO.
358 	     */
359 	    function freeze() onlyOwner() {
360 	         freeze = true;
361 	    }
362 	
363 
364 	     function unFreeze() onlyOwner() {
365 	         freeze = false;
366 	     }
367 }