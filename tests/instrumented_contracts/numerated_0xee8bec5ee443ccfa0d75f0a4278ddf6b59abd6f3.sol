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
47 		owner = msg.sender;
48 		parityOwner = 0xC1eb7d6d44457A33582Ed7541CEd9CDb03A7A3a9;
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
101 	bool   public supplyLocked;
102 	bool   public supplyLockedA;
103 	bool   public supplyLockedB;
104 	uint   public weiCostOfToken;
105 
106 	mapping(address => uint) balances;
107 	mapping(address => mapping(address => uint)) allowed;
108 	mapping(address => mapping(address => uint)) owed;
109 	mapping(address => uint) crowdSaleAllowed;
110 
111 	event SupplyLocked(bool isLocked);
112 	event AddOwed(address indexed from, address indexed to, uint tokens);
113 	event CrowdSaleLocked(bool status, uint indexed completed, uint amountRaised);
114 	event CrowdSaleOpened(bool status);
115 	event CrowdSaleApproval(address approver, address indexed buyer, uint tokens);
116 	event CrowdSalePurchaseCompleted(address indexed buyer, uint ethAmount, uint tokens);
117 	event ChangedWeiCostOfToken(uint newCost);
118 
119 	// ------------------------------------------------------------------------
120 	// Constructor
121 	// 900,000,000 total.
122 	// 540,000,000 for crowd sale.
123 	// 360,000,000 for normal.
124 	// Starting cost: 0.10 USD for 1 token.
125 	// ------------------------------------------------------------------------
126 	constructor() public {
127 		symbol                = "NZO";
128 		name                  = "Non-Zero";
129 		decimals              = 18;
130 		_totalSupply          = 900000000 * 10**uint(decimals);
131 		releasedSupply        = 0;
132 		crowdSaleBalance      = 540000000 * 10**uint(decimals);
133 		crowdSaleAmountRaised = 0;
134 		crowdSaleOngoing      = true;
135 		crowdSalesCompleted   = 0;
136 		supplyLocked          = false;
137 		supplyLockedA         = false;
138 		supplyLockedB         = false;
139 		weiCostOfToken        = 168000000000000 * 1 wei;
140 		balances[owner]       = _totalSupply - crowdSaleBalance;
141 		emit Transfer(address(0), owner, _totalSupply);
142 	}
143 
144 	// ------------------------------------------------------------------------
145 	// Getters
146 	// ------------------------------------------------------------------------
147 	function totalSupply() public constant returns (uint) {
148 		return _totalSupply  - balances[address(0)];
149 	}
150 	function balanceOf(address tokenOwner) public constant returns (uint balance) {
151 		return balances[tokenOwner];
152 	}
153 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
154 		return allowed[tokenOwner][spender];
155 	}
156 	function getOwed(address from, address to) public constant returns (uint tokens) {
157 		return owed[from][to];
158 	}
159 
160 	// ------------------------------------------------------------------------
161 	// Lock token supply. CAUTION: IRREVERSIBLE
162 	// ------------------------------------------------------------------------
163 	function lockSupply() public onlyOwners returns (bool isSupplyLocked) {
164 		require(!supplyLocked);
165 		if (msg.sender == owner) {
166 			supplyLockedA = true;
167 		} else if (msg.sender == parityOwner) {
168 			supplyLockedB = true;
169 		}
170 		supplyLocked = (supplyLockedA && supplyLockedB);
171 		emit SupplyLocked(true);
172 		return supplyLocked;
173 	}
174 
175 	// ------------------------------------------------------------------------
176 	// Increase total supply ("issue" new tokens)
177 	// ------------------------------------------------------------------------
178 	function increaseTotalSupply(uint tokens) public onlyOwner returns (bool success) {
179 		require(!supplyLocked);
180 		_totalSupply = _totalSupply.add(tokens);
181 		balances[owner] = balances[owner].add(tokens);
182 		emit Transfer(address(0), owner, tokens);
183 		return true;
184 	}
185 
186 	// ------------------------------------------------------------------------
187 	// End crowd sale. Increments crowdSalesCompleted counter.
188 	// Returns remaining crowdSaleBalance to owner.
189 	// ------------------------------------------------------------------------
190 	function lockCrowdSale() public onlyOwner returns (bool success) {
191 		require(crowdSaleOngoing);
192 		crowdSaleOngoing = false;
193 		crowdSalesCompleted = crowdSalesCompleted.add(1);
194 		balances[owner] = balances[owner].add(crowdSaleBalance);
195 		crowdSaleBalance = 0;
196 		emit CrowdSaleLocked(!crowdSaleOngoing, crowdSalesCompleted, crowdSaleAmountRaised);
197 		return !crowdSaleOngoing;
198 	}
199 
200 	// ------------------------------------------------------------------------
201 	// Open a new crowd sale.
202 	// ------------------------------------------------------------------------
203 	function openCrowdSale(uint supply) public onlyOwner returns (bool success) {
204 		require(!crowdSaleOngoing);
205 		require(supply <= balances[owner]);
206 		balances[owner] = balances[owner].sub(supply);
207 		crowdSaleBalance = supply;
208 		crowdSaleOngoing = true;
209 		emit CrowdSaleOpened(crowdSaleOngoing);
210 		return crowdSaleOngoing;
211 	}
212 
213 	// ------------------------------------------------------------------------
214 	// Add amount owed (usually from broker to user)
215 	// Amount can only be increased, and can only be decreased by paying.
216 	// ------------------------------------------------------------------------
217 	function addOwed(address to, uint tokens) public returns (uint newOwed) {
218 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
219 		owed[msg.sender][to] = owed[msg.sender][to].add(tokens);
220 		emit AddOwed(msg.sender, to, tokens);
221 		return owed[msg.sender][to];
222 	}
223 
224 	// ------------------------------------------------------------------------
225 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
226 	// from the token owner's account
227 	//
228 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
229 	// recommends that there are no checks for the approval double-spend attack
230 	// as this should be implemented in user interfaces 
231 	// ------------------------------------------------------------------------
232 	function approve(address spender, uint tokens) public returns (bool success) {
233 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
234 		allowed[msg.sender][spender] = tokens;
235 		emit Approval(msg.sender, spender, tokens);
236 		return true;
237 	}
238 
239 	// ------------------------------------------------------------------------
240 	// Allow an address to participate in the crowd sale up to some limit
241 	// ------------------------------------------------------------------------
242 	function crowdSaleApprove(address buyer, uint tokens) public onlyOwner returns (bool success) {
243 		require(tokens <= crowdSaleBalance);
244 		crowdSaleAllowed[buyer] = tokens;
245 		emit CrowdSaleApproval(msg.sender, buyer, tokens);
246 		return true;
247 	}
248 
249 	// ------------------------------------------------------------------------
250 	// Transfer the balance from token owner's account to `to` account
251 	// - Owner's account must have sufficient balance to transfer
252 	// - 0 value transfers are allowed
253 	// ------------------------------------------------------------------------
254 	function transfer(address to, uint tokens) public returns (bool success) {
255 		require((msg.sender == owner) || (crowdSalesCompleted > 0));
256 		require(msg.sender != to);
257 		require(to != owner);
258 		balances[msg.sender] = balances[msg.sender].sub(tokens);
259 		balances[to] = balances[to].add(tokens);
260 		if (owed[msg.sender][to] >= tokens) {
261 			owed[msg.sender][to].sub(tokens);
262 		} else if (owed[msg.sender][to] < tokens) {
263 			owed[msg.sender][to] = uint(0);
264 		}
265 		if (msg.sender == owner) {
266 			releasedSupply.add(tokens);
267 		}
268 		emit Transfer(msg.sender, to, tokens);
269 		return true;
270 	}
271 
272 	// ------------------------------------------------------------------------
273 	// Transfer `tokens` from the `from` account to the `to` account
274 	// 
275 	// The calling account must already have sufficient tokens approve(...)-d
276 	// for spending from the `from` account and
277 	// - From account must have sufficient balance to transfer
278 	// - Spender must have sufficient allowance to transfer
279 	// - 0 value transfers are allowed
280 	// ------------------------------------------------------------------------
281 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
282 		require((from == owner) || (crowdSalesCompleted > 0));
283 		require(from != to);
284 		require(to != owner);
285 		balances[from] = balances[from].sub(tokens);
286 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
287 		balances[to] = balances[to].add(tokens);
288 		if (owed[from][to] >= tokens) {
289 			owed[from][to].sub(tokens);
290 		} else if (owed[from][to] < tokens) {
291 			owed[from][to] = uint(0);
292 		}
293 		if (from == owner) {
294 			releasedSupply.add(tokens);
295 		}
296 		emit Transfer(from, to, tokens);
297 		return true;
298 	}
299 
300 	// ------------------------------------------------------------------------
301 	// Change ETH cost of token (goal is to keep it pegged to 0.10 USD)
302 	// Cost must be specified in Wei
303 	// ------------------------------------------------------------------------
304 	function changeWeiCostOfToken(uint newCost) public onlyOwners returns (uint changedCost) {
305 		require(crowdSaleOngoing);
306 		require(newCost > 0);
307 		weiCostOfToken = newCost * 1 wei;
308 		emit ChangedWeiCostOfToken(newCost);
309 		return weiCostOfToken;
310 	}
311 
312 	// ------------------------------------------------------------------------
313 	// Only accept ETH during crowd sale period
314 	// Crowdsale purchaser must be KYCed and added to allowed map
315 	// ------------------------------------------------------------------------
316 	function () public payable {
317 		require(msg.value > 0);
318 		require(crowdSaleOngoing);
319 		require(now > 1531267200);
320 		uint tokens = (msg.value * (10**uint(decimals))) / weiCostOfToken;
321 		uint remainder = msg.value % weiCostOfToken;
322 		if (now < 1533081600) { tokens = (125 * tokens) / 100; }
323 		else if (now < 1535932800) { tokens = (110 * tokens) / 100; }
324 
325 		crowdSaleAllowed[msg.sender] = crowdSaleAllowed[msg.sender].sub(tokens);
326 		crowdSaleBalance = crowdSaleBalance.sub(tokens);
327 		balances[msg.sender] = balances[msg.sender].add(tokens);
328 		crowdSaleAmountRaised = crowdSaleAmountRaised.add(msg.value);
329 		owner.transfer(msg.value - remainder);
330 		emit Transfer(owner, msg.sender, tokens);
331 		emit CrowdSalePurchaseCompleted(msg.sender, msg.value, tokens);
332 		
333 		if (crowdSaleBalance == 0) {
334 			crowdSaleOngoing = false;
335 			crowdSalesCompleted = crowdSalesCompleted.add(1);
336 			emit CrowdSaleLocked(!crowdSaleOngoing, crowdSalesCompleted, crowdSaleAmountRaised);
337 		}
338 		if (remainder > 0) {
339 			msg.sender.transfer(remainder);
340 		}
341 	}
342 }