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
12 	  event Transfer(address indexed from, address indexed to, uint value);
13 	}
14 	
15 
16 	/**
17 	 * Math operations with safety checks
18 	 */
19 	contract SafeMath {
20 	  function safeMul(uint a, uint b) internal returns (uint) {
21 	    uint c = a * b;
22 	    assert(a == 0 || c / a == b);
23 	    return c;
24 	  }
25 	
26 
27 	  function safeDiv(uint a, uint b) internal returns (uint) {
28 	    assert(b > 0);
29 	    uint c = a / b;
30 	    assert(a == b * c + a % b);
31 	    return c;
32 	  }
33 	
34 
35 	  function safeSub(uint a, uint b) internal returns (uint) {
36 	    assert(b <= a);
37 	    return a - b;
38 	  }
39 	
40 
41 	  function safeAdd(uint a, uint b) internal returns (uint) {
42 	    uint c = a + b;
43 	    assert(c>=a && c>=b);
44 	    return c;
45 	  }
46 	
47 
48 	  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49 	    return a >= b ? a : b;
50 	  }
51 	
52 
53 	  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54 	    return a < b ? a : b;
55 	  }
56 	
57 
58 	  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59 	    return a >= b ? a : b;
60 	  }
61 	
62 
63 	  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
64 	    return a < b ? a : b;
65 	  }
66 	
67 
68 	}
69 	
70 
71 	contract StandardToken is ERC20, SafeMath {
72 	
73 	  /* Actual balances of token holders */
74 	  mapping(address => uint) balances;
75 	
76 
77 	  /* approve() allowances */
78 	  mapping (address => mapping (address => uint)) allowed;
79 	
80 
81 	  /* Interface declaration */
82 	  function isToken() public constant returns (bool weAre) {
83 	    return true;
84 	  }
85 	
86 
87 	  function transfer(address _to, uint _value) returns (bool success) {
88 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
89 	    balances[_to] = safeAdd(balances[_to], _value);
90 	    Transfer(msg.sender, _to, _value);
91 	    return true;
92 	  }
93 	
94 
95 	  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
96 	    uint _allowance = allowed[_from][msg.sender];
97 	
98 
99 	    balances[_to] = safeAdd(balances[_to], _value);
100 	    balances[_from] = safeSub(balances[_from], _value);
101 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
102 	    Transfer(_from, _to, _value);
103 	    return true;
104 	  }
105 	
106 
107 	  function balanceOf(address _owner) constant returns (uint balance) {
108 	    return balances[_owner];
109 	  }
110 	
111 
112 	  function approve(address _spender, uint _value) private returns (bool success) {
113 	
114 
115 
116 
117 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
118 	
119 
120 	    allowed[msg.sender][_spender] = _value;
121 	    return true;
122 	  }
123 	
124 
125 	  function allowance(address _owner, address _spender) constant returns (uint remaining) {
126 	    return allowed[_owner][_spender];
127 	  }
128 	
129 
130 	}
131 	
132 
133 	contract SmartNodeToken is StandardToken {
134 	
135 
136 	    string public name = "Smart Node";
137 	    string public symbol = "Node";
138 	    uint public decimals = 0;
139 	
140 
141 	    /**
142 	     * Boolean contract states
143 	     */
144 	    bool halted = false; //the founder address can set this to true to halt the whole ICO event due to emergency
145 	    bool preTge = true; //ICO Sale state
146 	    bool public freeze = true; //Freeze state
147 	
148 
149 	    /**
150 	     * Initial founder address (set in constructor)
151 	     * All deposited ETH will be forwarded to this address.
152 	     */
153 	    address founder = 0x0;
154 	    address owner = 0x0;
155 	
156 
157 	    /**
158 	     * Token count
159 	     */
160 	    uint totalTokens = 40000000; // Unsold tokens will be burned when ICO ends
161 	    uint team = 0; // Disabled
162 	    uint bounty = 0; // Disabled
163 	
164 
165 	    /**
166 	     *Ico-Sale cap
167 	     */
168 	    uint preTgeCap = 40000120; // Max amount raised during Ico-Sale is 36.000 // 1 ETH = 1000 Node tokens
169 	    uint tgeCap = 40000120; // Disabled
170 	
171 
172 	    /**
173 	     * Statistic values
174 	     */
175 	    uint presaleTokenSupply = 0; // Unused
176 	    uint presaleEtherRaised = 0; // Unused
177 	    uint preTgeTokenSupply = 0; // This will keep track of the token supply created during the Ico-Sale
178 	
179 
180 	    event Buy(address indexed sender, uint eth, uint fbt);
181 	
182 
183 	    /* This generates a public event on the blockchain that will notify clients */
184 	    event TokensSent(address indexed to, uint256 value);
185 	    event ContributionReceived(address indexed to, uint256 value);
186 	    event Burn(address indexed from, uint256 value);
187 	
188 
189 	    function SmartNodeToken(address _founder) payable {
190 	        owner = msg.sender;
191 	        founder = _founder;
192 	
193 
194 	        // Move team token pool to founder balance
195 	        balances[founder] = team;
196 	        // Sub from total tokens team pool
197 	        totalTokens = safeSub(totalTokens, team);
198 	        // Sub from total tokens bounty pool
199 	        totalTokens = safeSub(totalTokens, bounty);
200 	        // Total supply is 40000000
201 	        totalSupply = totalTokens;
202 	        balances[owner] = totalSupply;
203 	    }
204 	
205 
206 	    /**
207 	     * 1 ERC20 = 1 FINNEY
208 	     * Price is 1000 Node for 1 ETH
209 	     */
210 	    function price() constant returns (uint){
211 	        return 1 finney;
212 	    }
213 	
214 
215 	    /**
216 	      * The basic entry point to participate the TGE event process.
217 	      *
218 	      * Pay for funding, get invested tokens back in the sender address.
219 	      */
220 	    function buy() public payable returns(bool) {
221 	        // Buy allowed if contract is not on halt
222 	        require(!halted);
223 	        // Amount of wei should be more that 0
224 	        require(msg.value>0);
225 	
226 
227 	        // Count expected tokens price
228 	        uint tokens = msg.value / price();
229 	
230 
231 	        // Total tokens should be more than user want's to buy
232 	        require(balances[owner]>tokens);
233 	
234 
235 	        if (preTge) {
236 	            tokens = tokens;
237 	        }
238 	
239 
240 	        // Check how much tokens already sold
241 	        if (preTge) {
242 	            // Check that required tokens count are less than tokens already sold on Pre-TGE
243 	            require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
244 	        } else {
245 	            // Check that required tokens count are less than tokens already sold on tge sub Pre-TGE
246 	            require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
247 	        }
248 	
249 
250 	        // Send wei to founder address
251 	        founder.transfer(msg.value);
252 	
253 
254 	        // Add tokens to user balance and remove from totalSupply
255 	        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
256 	        // Remove sold tokens from total supply count
257 	        balances[owner] = safeSub(balances[owner], tokens);
258 	
259 
260 	        // Update stats
261 	        if (preTge) {
262 	            preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);
263 	        }
264 	        presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
265 	        presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
266 	
267 
268 	        // Send buy TBCH token action
269 	        Buy(msg.sender, msg.value, tokens);
270 	
271 
272 	        // /* Emit log events */
273 	        TokensSent(msg.sender, tokens);
274 	        ContributionReceived(msg.sender, msg.value);
275 	        Transfer(owner, msg.sender, tokens);
276 	
277 
278 	        return true;
279 	    }
280 
281 
282 	    /**
283 	     * Transfer bounty to target address from bounty pool
284 	     */
285 	    function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
286 	        balances[owner] = safeSub(balances[owner], _value);
287 	        balances[_to] = safeAdd(balances[_to], _value);
288 	        // /* Emit log events */
289 	        TokensSent(_to, _value);
290 	        Transfer(owner, _to, _value);
291 	    }
292 	
293 
294 	    /**
295 	     * ERC 20 Standard Token interface transfer function
296 	     *
297 	     * Prevent transfers until halt period is over.
298 	     */
299 	    function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
300 	        return super.transfer(_to, _value);
301 	    }
302 	    /**
303 	     * ERC 20 Standard Token interface transfer function
304 	     *
305 	     * Prevent transfers until halt period is over.
306 	     */
307 	    function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
308 	        return super.transferFrom(_from, _to, _value);
309 	    }
310 	
311 
312 	    /**
313 	     * Burn all tokens from a balance.
314 	     */
315 	    function burnRemainingTokens() isAvailable() onlyOwner() {
316 	        Burn(owner, balances[owner]);
317 	        balances[owner] = 0;
318 	    }
319 	
320 
321 	    modifier onlyOwner() {
322 	        require(msg.sender == owner);
323 	        _;
324 	    }
325 	
326 
327 	    modifier isAvailable() {
328 	        require(!halted && !freeze);
329 	        _;
330 	    }
331 	
332 
333 	    /**
334 	     */
335 	    function() payable {
336 	        buy();
337 	    }
338 	
339 
340 	    /**
341 	     * Freeze and unfreeze 
342 	     */
343 	    function freeze() onlyOwner() {
344 	         freeze = true;
345 	    }
346 	
347 
348 	     function unFreeze() onlyOwner() {
349 	         freeze = false;
350 	     }
351 	
352 
353 	    /**
354 	     * Replaces an owner
355 	     */
356 	    function changeOwner(address _to) onlyOwner() {
357 	        balances[_to] = balances[owner];
358 	        balances[owner] = 0;
359 	        owner = _to;
360 	    }
361 	
362 
363 	    /**
364 	     * Replaces a founder, transfer team pool to new founder balance
365 	     */
366 	    function changeFounder(address _to) onlyOwner() {
367 	        balances[_to] = balances[founder];
368 	        balances[founder] = 0;
369 	        founder = _to;
370 	    }
371 	}