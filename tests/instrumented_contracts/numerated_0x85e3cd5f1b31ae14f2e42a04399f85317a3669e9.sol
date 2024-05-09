1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns (uint c) {
8 		c = a + b; require(c >= a);
9 	}
10 	function sub(uint a, uint b) internal pure returns (uint c) {
11 		require(b <= a); c = a - b;
12 	}
13 	function mul(uint a, uint b) internal pure returns (uint c) {
14 		c = a * b; require(a == 0 || c / a == b);
15 	}
16 	function div(uint a, uint b) internal pure returns (uint c) {
17 		require(b > 0); c = a / b;
18 	}
19 }
20 
21 // ----------------------------------------------------------------------------
22 // ERC Token Standard #20 Interface
23 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
24 // ----------------------------------------------------------------------------
25 contract ERC20Interface {
26 	function totalSupply() public constant returns (uint);
27 	function balanceOf(address tokenOwner) public constant returns (uint balance);
28 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29 	function transfer(address to, uint tokens) public returns (bool success);
30 	function approve(address spender, uint tokens) public returns (bool success);
31 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 	event Transfer(address indexed from, address indexed to, uint tokens);
33 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 // ----------------------------------------------------------------------------
37 // Owned contract
38 // ----------------------------------------------------------------------------
39 contract Owned {
40 	address public owner;
41 	address public parityOwner;
42 	address public newOwner;
43 	address public newParityOwner;
44 	event OwnershipTransferred(address indexed _from, address indexed _to);
45 	event ParityOwnershipTransferred(address indexed _from, address indexed _to);
46 	constructor() public {
47 		owner = 0xF355F9f411A5580a5f9e74203458906a90d39DE1;
48 		parityOwner = 0x0057015543016dadc0Df0f1df1Cc79d496602f03;
49 	}
50 	modifier onlyOwner {
51 		bool isOwner = (msg.sender == owner);
52 		require(isOwner);
53 		_;
54 	}
55 	modifier onlyOwners {
56 		bool isOwner = (msg.sender == owner);
57 		bool isParityOwner = (msg.sender == parityOwner);
58 		require(owner != parityOwner);
59 		require(isOwner || isParityOwner);
60 		_;
61 	}
62 	function transferOwnership(address _newOwner) public onlyOwner {
63 		require(_newOwner != parityOwner);
64 		require(_newOwner != newParityOwner);
65 		newOwner = _newOwner;
66 	}
67 	function acceptOwnership() public {
68 		require(msg.sender == newOwner);
69 		emit OwnershipTransferred(owner, newOwner);
70 		owner = newOwner;
71 		newOwner = address(0);
72 	}
73 	function transferParityOwnership(address _newParityOwner) public onlyOwner {
74 		require(_newParityOwner != owner);
75 		require(_newParityOwner != newOwner);
76 		newParityOwner = _newParityOwner;
77 	}
78 	function acceptParityOwnership() public {
79 		require(msg.sender == newParityOwner);
80 		emit ParityOwnershipTransferred(parityOwner, newParityOwner);
81 		parityOwner = newParityOwner;
82 		newParityOwner = address(0);
83 	}
84 }
85 
86 // ----------------------------------------------------------------------------
87 // NZO (Release Candidate)
88 // ----------------------------------------------------------------------------
89 contract NZO is ERC20Interface, Owned {
90 	using SafeMath for uint;
91 
92 	string public symbol;
93 	string public  name;
94 	uint8  public decimals;
95 	uint   public _totalSupply;
96 	uint   public releasedSupply;
97 	uint   public crowdSaleBalance;
98 	uint   public crowdSaleAmountRaised;
99 	bool   public crowdSaleOngoing;
100 	uint   public crowdSalesCompleted;
101 	uint   public crowdSaleBonusADeadline;
102 	uint   public crowdSaleBonusBDeadline;
103 	uint   public crowdSaleBonusAPercentage;
104 	uint   public crowdSaleBonusBPercentage;
105 	uint   public crowdSaleWeiMinimum;
106 	uint   public crowdSaleWeiMaximum;
107 	bool   public supplyLocked;
108 	bool   public supplyLockedA;
109 	bool   public supplyLockedB;
110 	uint   public weiCostOfToken;
111 
112 	mapping(address => uint) balances;
113 	mapping(address => mapping(address => uint)) allowed;
114 	mapping(address => mapping(address => uint)) owed;
115 	mapping(address => uint) crowdSaleAllowed;
116 
117 	event SupplyLocked(bool isLocked);
118 	event AddOwed(address indexed from, address indexed to, uint tokens);
119 	event CrowdSaleLocked(bool status, uint indexed completed, uint amountRaised);
120 	event CrowdSaleOpened(bool status);
121 	event CrowdSaleApproval(address approver, address indexed buyer, uint tokens);
122 	event CrowdSalePurchaseCompleted(address indexed buyer, uint ethAmount, uint tokens);
123 	event ChangedWeiCostOfToken(uint newCost, uint weiMinimum, uint weiMaximum);
124 
125 	// ------------------------------------------------------------------------
126 	// Constructor
127 	// 900,000,000 total.
128 	// 540,000,000 for crowd sale.
129 	// 360,000,000 for normal.
130 	// Starting cost: 0.10 USD for 1 token.
131 	// ------------------------------------------------------------------------
132 	constructor() public {
133 		symbol                    = "NZO";
134 		name                      = "Non-Zero";
135 		decimals                  = 18;
136 		_totalSupply              = 900000000 * 10**uint(decimals);
137 		releasedSupply            = 0;
138 		crowdSaleBalance          = 0;
139 		crowdSaleAmountRaised     = 0;
140 		crowdSaleOngoing          = false;
141 		crowdSalesCompleted       = 0;
142 		crowdSaleBonusADeadline   = 0;
143 		crowdSaleBonusBDeadline   = 0;
144 		crowdSaleBonusAPercentage = 100;
145 		crowdSaleBonusBPercentage = 100;
146 		crowdSaleWeiMinimum       = 0;
147 		crowdSaleWeiMaximum       = 0;
148 		supplyLocked              = false;
149 		supplyLockedA             = false;
150 		supplyLockedB             = false;
151 		weiCostOfToken            = 168000000000000 * 1 wei;
152 		balances[owner]           = _totalSupply;
153 		emit Transfer(address(0), owner, _totalSupply);
154 	}
155 
156 	// ------------------------------------------------------------------------
157 	// Getters
158 	// ------------------------------------------------------------------------
159 	function totalSupply() public constant returns (uint) {
160 		return _totalSupply  - balances[address(0)];
161 	}
162 	function balanceOf(address tokenOwner) public constant returns (uint balance) {
163 		return balances[tokenOwner];
164 	}
165 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166 		return allowed[tokenOwner][spender];
167 	}
168 	function getOwed(address from, address to) public constant returns (uint tokens) {
169 		return owed[from][to];
170 	}
171 
172 	// ------------------------------------------------------------------------
173 	// Lock token supply. CAUTION: IRREVERSIBLE
174 	// ------------------------------------------------------------------------
175 	function lockSupply() public onlyOwners returns (bool isSupplyLocked) {
176 		require(!supplyLocked);
177 		if (msg.sender == owner) {
178 			supplyLockedA = true;
179 		} else if (msg.sender == parityOwner) {
180 			supplyLockedB = true;
181 		}
182 		supplyLocked = (supplyLockedA && supplyLockedB);
183 		emit SupplyLocked(true);
184 		return supplyLocked;
185 	}
186 
187 	// ------------------------------------------------------------------------
188 	// Increase total supply ("issue" new tokens)
189 	// ------------------------------------------------------------------------
190 	function increaseTotalSupply(uint tokens) public onlyOwner returns (bool success) {
191 		require(!supplyLocked);
192 		_totalSupply = _totalSupply.add(tokens);
193 		balances[owner] = balances[owner].add(tokens);
194 		emit Transfer(address(0), owner, tokens);
195 		return true;
196 	}
197 
198 	// ------------------------------------------------------------------------
199 	// End crowd sale. Increments crowdSalesCompleted counter.
200 	// Returns remaining crowdSaleBalance to owner.
201 	// ------------------------------------------------------------------------
202 	function lockCrowdSale() public onlyOwner returns (bool success) {
203 		require(crowdSaleOngoing);
204 		crowdSaleOngoing = false;
205 		crowdSalesCompleted = crowdSalesCompleted.add(1);
206 		balances[owner] = balances[owner].add(crowdSaleBalance);
207 		crowdSaleBalance = 0;
208 		crowdSaleBonusADeadline = 0;
209 		crowdSaleBonusBDeadline = 0;
210 		crowdSaleBonusAPercentage = 100;
211 		crowdSaleBonusBPercentage = 100;
212 		emit CrowdSaleLocked(!crowdSaleOngoing, crowdSalesCompleted, crowdSaleAmountRaised);
213 		return !crowdSaleOngoing;
214 	}
215 
216 	// ------------------------------------------------------------------------
217 	// Open a new crowd sale.
218 	// bonusBDeadline must always be more in the future than bonusADeadline.
219 	// ------------------------------------------------------------------------
220 	function openCrowdSale(
221 		uint supply, uint bonusADeadline, uint bonusBDeadline, uint bonusAPercentage, uint bonusBPercentage
222 	) public onlyOwner returns (bool success) {
223 		require(!crowdSaleOngoing);
224 		require(supply <= balances[owner]);
225 		require(bonusADeadline > now);
226 		require(bonusBDeadline > now);
227 		require(bonusAPercentage >= 100);
228 		require(bonusBPercentage >= 100);
229 		balances[owner] = balances[owner].sub(supply);
230 		crowdSaleBalance = supply;
231 		crowdSaleBonusADeadline = bonusADeadline;
232 		crowdSaleBonusBDeadline = bonusBDeadline;
233 		crowdSaleBonusAPercentage = bonusAPercentage;
234 		crowdSaleBonusBPercentage = bonusBPercentage;
235 		crowdSaleOngoing = true;
236 		emit CrowdSaleOpened(crowdSaleOngoing);
237 		return crowdSaleOngoing;
238 	}
239 
240 	// ------------------------------------------------------------------------
241 	// Add amount owed (usually from broker to user)
242 	// Amount can only be increased, and can only be decreased by paying.
243 	// ------------------------------------------------------------------------
244 	function addOwed(address to, uint tokens) public returns (uint newOwed) {
245 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
246 		owed[msg.sender][to] = owed[msg.sender][to].add(tokens);
247 		emit AddOwed(msg.sender, to, tokens);
248 		return owed[msg.sender][to];
249 	}
250 
251 	// ------------------------------------------------------------------------
252 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
253 	// from the token owner's account
254 	//
255 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
256 	// recommends that there are no checks for the approval double-spend attack
257 	// as this should be implemented in user interfaces 
258 	// ------------------------------------------------------------------------
259 	function approve(address spender, uint tokens) public returns (bool success) {
260 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
261 		allowed[msg.sender][spender] = tokens;
262 		emit Approval(msg.sender, spender, tokens);
263 		return true;
264 	}
265 
266 	// ------------------------------------------------------------------------
267 	// Allow an address to participate in the crowd sale up to some limit
268 	// ------------------------------------------------------------------------
269 	function crowdSaleApprove(address[] buyers, uint[] tokens) public onlyOwner returns (bool success) {
270 		require(buyers.length == tokens.length);
271 		uint buyersLength = buyers.length;
272 		for (uint i = 0; i < buyersLength; i++) {
273 			require(tokens[i] <= crowdSaleBalance);
274 			crowdSaleAllowed[buyers[i]] = tokens[i];
275 			emit CrowdSaleApproval(msg.sender, buyers[i], tokens[i]);
276 		}
277 		return true;
278 	}
279 
280 	// ------------------------------------------------------------------------
281 	// Transfer the balance from token owner's account to `to` account
282 	// - Owner's account must have sufficient balance to transfer
283 	// - 0 value transfers are allowed
284 	// ------------------------------------------------------------------------
285 	function transfer(address to, uint tokens) public returns (bool success) {
286 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
287 		require(msg.sender != to);
288 		require(to != owner);
289 		balances[msg.sender] = balances[msg.sender].sub(tokens);
290 		balances[to] = balances[to].add(tokens);
291 		if (owed[msg.sender][to] >= tokens) {
292 			owed[msg.sender][to].sub(tokens);
293 		} else if (owed[msg.sender][to] < tokens) {
294 			owed[msg.sender][to] = uint(0);
295 		}
296 		if (msg.sender == owner) {
297 			releasedSupply.add(tokens);
298 		}
299 		emit Transfer(msg.sender, to, tokens);
300 		return true;
301 	}
302 
303 	// ------------------------------------------------------------------------
304 	// Utility function for the above transfer function, to pass arrays.
305 	// ------------------------------------------------------------------------
306 	function batchTransfer(address[] tos, uint[] tokens) public returns (bool success) {
307 		require(tos.length == tokens.length);
308 		uint tosLength = tos.length;
309 		for (uint i = 0; i < tosLength; i++) {
310 			transfer(tos[i], tokens[i]);
311 		}
312 		return true;
313 	}
314 
315 	// ------------------------------------------------------------------------
316 	// Transfer `tokens` from the `from` account to the `to` account
317 	// 
318 	// The calling account must already have sufficient tokens approve(...)-d
319 	// for spending from the `from` account and
320 	// - From account must have sufficient balance to transfer
321 	// - Spender must have sufficient allowance to transfer
322 	// - 0 value transfers are allowed
323 	// ------------------------------------------------------------------------
324 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
325 		require((from == owner) || (crowdSalesCompleted > 0));
326 		require(from != to);
327 		require(to != owner);
328 		balances[from] = balances[from].sub(tokens);
329 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
330 		balances[to] = balances[to].add(tokens);
331 		if (owed[from][to] >= tokens) {
332 			owed[from][to].sub(tokens);
333 		} else if (owed[from][to] < tokens) {
334 			owed[from][to] = uint(0);
335 		}
336 		if (from == owner) {
337 			releasedSupply.add(tokens);
338 		}
339 		emit Transfer(from, to, tokens);
340 		return true;
341 	}
342 
343 	// ------------------------------------------------------------------------
344 	// Change ETH cost of token (goal is to keep it pegged to 0.10 USD)
345 	// Cost must be specified in Wei
346 	// ------------------------------------------------------------------------
347 	function changeWeiCostOfToken(uint newCost, uint weiMinimum, uint weiMaximum) public onlyOwners returns (bool success) {
348 		require(crowdSaleOngoing);
349 		require(newCost > 0);
350 		require(weiMinimum >= 0);
351 		require(weiMaximum >= 0);
352 		weiCostOfToken = newCost * 1 wei;
353 		crowdSaleWeiMinimum = weiMinimum;
354 		crowdSaleWeiMaximum = weiMaximum;
355 		emit ChangedWeiCostOfToken(weiCostOfToken, crowdSaleWeiMinimum, crowdSaleWeiMaximum);
356 		return true;
357 	}
358 
359 	// ------------------------------------------------------------------------
360 	// Only accept ETH during crowd sale period
361 	// Crowdsale purchaser must be KYCed and added to allowed map
362 	// ------------------------------------------------------------------------
363 	function () public payable {
364 		require(msg.value > 0);
365 		require(crowdSaleOngoing);
366 		require(msg.value >= crowdSaleWeiMinimum);
367 		require((msg.value <= crowdSaleWeiMaximum) || (crowdSaleWeiMaximum <= 0));
368 
369 		uint tokens = (msg.value * (10**uint(decimals))) / weiCostOfToken;
370 		uint remainder = msg.value % weiCostOfToken;
371 
372 		if (now < crowdSaleBonusADeadline) {
373 			tokens = (crowdSaleBonusAPercentage * tokens) / 100;
374 		} else if (now < crowdSaleBonusBDeadline) {
375 			tokens = (crowdSaleBonusBPercentage * tokens) / 100;
376 		}
377 
378 		crowdSaleAllowed[msg.sender] = crowdSaleAllowed[msg.sender].sub(tokens);
379 		crowdSaleBalance = crowdSaleBalance.sub(tokens);
380 		balances[msg.sender] = balances[msg.sender].add(tokens);
381 		crowdSaleAmountRaised = crowdSaleAmountRaised.add(msg.value);
382 		owner.transfer(msg.value - remainder);
383 		emit Transfer(owner, msg.sender, tokens);
384 		emit CrowdSalePurchaseCompleted(msg.sender, msg.value, tokens);
385 		
386 		if (crowdSaleBalance == 0) {
387 			crowdSaleOngoing = false;
388 			crowdSalesCompleted = crowdSalesCompleted.add(1);
389 			emit CrowdSaleLocked(!crowdSaleOngoing, crowdSalesCompleted, crowdSaleAmountRaised);
390 		}
391 		if (remainder > 0) {
392 			msg.sender.transfer(remainder);
393 		}
394 	}
395 }