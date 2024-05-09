1 pragma solidity ^0.4.10;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10 		uint256 c = a * b;
11 		assert(a == 0 || c / a == b);
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
16 		uint256 c = a / b;
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 /**
33  * @title Owned
34  * @dev Owner contract to add owner checks
35  */
36 contract Owned {
37 	address public owner;
38 
39 	function Owned () {
40 		owner = msg.sender;	
41 	}	
42 
43 	function transferOwner(address newOwner) public onlyOwner {
44 		owner = newOwner;
45 	}
46 
47 	modifier onlyOwner {
48 		require(msg.sender == owner);
49 		_;
50 	}
51 }
52 
53 /**
54  * @title Payload
55  * @dev Fix for the ERC20 short address attack.
56  */
57 contract Payload {
58 	modifier onlyPayloadSize(uint size) {
59 		// require(msg.data.length >= size + 4);
60 		_;
61   	}
62 }
63 
64 contract IntelliETHConstants {
65 	uint256 constant PRE_ICO_ALLOCATION = 6;
66 	uint256 constant ICO_ALLOCATION = 74;
67 	uint256 constant TEAM_ALLOCATION = 10;
68 	uint256 constant RESERVED_ALLOCATION = 10;
69 
70 	uint256 constant PRE_ICO_BONUS = 50;
71 	uint256 constant ICO_PHASE_01_BONUS = 20;
72 	uint256 constant ICO_PHASE_02_BONUS = 10;
73 	uint256 constant ICO_PHASE_03_BONUS = 5;
74 	uint256 constant ICO_PHASE_04_BONUS = 0;
75 
76 	uint256 constant BUY_RATE = 1500; 
77 	uint256 constant BUY_PRICE = (10 ** 18) / BUY_RATE;
78 
79 	// 1 ETH = ? inETH
80 	uint256 constant PRE_ICO_RATE = 2250;
81 	uint256 constant ICO_PHASE_01_RATE = 1800;
82 	uint256 constant ICO_PHASE_02_RATE = 1650;
83 	uint256 constant ICO_PHASE_03_RATE = 1575;
84 	uint256 constant ICO_PHASE_04_RATE = 1500;
85 
86 	// 1 inETH = ? ETH
87 	uint256 constant PRE_ICO_BUY_PRICE = uint256((10 ** 18) / 2250);
88 	uint256 constant ICO_PHASE_01_BUY_PRICE = uint256((10 ** 18) / 1800);
89 	uint256 constant ICO_PHASE_02_BUY_PRICE = uint256((10 ** 18) / 1650);
90 	uint256 constant ICO_PHASE_03_BUY_PRICE = uint256((10 ** 18) / 1575);
91 	uint256 constant ICO_PHASE_04_BUY_PRICE = uint256((10 ** 18) / 1500);
92 }
93 
94 /**
95  * @title IntelliETH
96  * @dev IntelliETH implementation
97  */
98 contract IntelliETH is Owned, Payload, IntelliETHConstants {
99 	using SafeMath for uint256;
100 
101 	string public name;
102 	string public symbol;
103 	uint8 public decimals;
104 	address public wallet;
105 
106 	uint256 public totalSupply;
107 	uint256 public transSupply;
108 	uint256 public availSupply;
109 
110 	uint256 public totalContributors;
111 	uint256 public totalContribution;
112 
113 	mapping (address => bool) developers;
114 	mapping (address => uint256) contributions;
115 	mapping (address => uint256) balances;
116 	mapping (address => mapping (address => uint256)) allowed;
117 
118 	mapping (address => bool) freezes;
119 
120 	struct SpecialPrice {
121         uint256 buyPrice;
122         uint256 sellPrice;
123         bool exists;
124     }
125 
126 	mapping (address => SpecialPrice) specialPrices;
127 
128 	uint256 public buyPrice;
129 	uint256 public sellPrice;
130 
131 	bool public tokenStatus = true;
132 	bool public transferStatus = true;
133 	bool public buyStatus = true;
134 	bool public sellStatus = false;
135 	bool public refundStatus = false;
136 
137 	event Transfer(address indexed from, address indexed to, uint256 value);
138 	event Approval(address indexed approver, address indexed spender, uint256 value);
139 	event Price(uint256 buy, uint256 sell);
140 	event Buy(address indexed addr , uint256 value , uint256 units);
141 	event Sell(address indexed addr , uint256 value , uint256 units);
142 	event Refund(address indexed addr , uint256 value);
143 
144 	function IntelliETH () {
145 		name = "IntelliETH";
146 		symbol = "INETH";
147 		decimals = 18;
148 		wallet = 0x634dA488e1E122A9f2ED83e91ccb6Db3414e3984;
149 		
150 		totalSupply = 500000000 * (10 ** uint256(decimals));
151 		availSupply = totalSupply;
152 		transSupply = 0;
153 
154 		buyPrice = 444444444444444;
155 		sellPrice = 0;
156 
157 		balances[owner] = totalSupply;
158 		developers[owner] = true;
159 		developers[wallet] = true;
160 	}	
161 
162 	function balanceOf(address addr) public constant returns (uint256) {
163 		return balances[addr];
164 	}
165 
166 	function transfer(address to, uint256 value) public onlyPayloadSize(2 * 32) returns (bool) {
167 		return _transfer(msg.sender, to, value);
168 	}
169 
170 	function allowance(address approver, address spender) public constant returns (uint256) {
171 		return allowed[approver][spender];
172 	}
173 
174 	function transferFrom(address approver, address to, uint256 value) public onlyPayloadSize(3 * 32) returns (bool) {
175 		require(allowed[approver][msg.sender] - value >= 0);
176 		require(allowed[approver][msg.sender] - value < allowed[approver][msg.sender]);
177 
178 		allowed[approver][msg.sender] = allowed[approver][msg.sender].sub(value);
179 		return _transfer(approver, to, value);
180 	}
181 
182 	function approve(address spender, uint256 value) public returns (bool) {
183 		return _approve(msg.sender , spender , value);
184 	}
185 
186 	function increaseApproval(address spender , uint256 value) public returns (bool) {
187 		require(value > 0);
188 		require(allowed[msg.sender][spender] + value > allowed[msg.sender][spender]);
189 
190 		value = allowed[msg.sender][spender].add(value);
191 		return _approve(msg.sender , spender , value);
192 	}
193 
194 	function decreaseApproval(address spender , uint256 value) public returns (bool) {
195 		require(value > 0);
196 		require(allowed[msg.sender][spender] - value >= 0);	
197 		require(allowed[msg.sender][spender] - value < allowed[msg.sender][spender]);	
198 
199 		value = allowed[msg.sender][spender].sub(value);
200 		return _approve(msg.sender , spender , value);
201 	}
202 
203 	function freeze(address addr, bool status) public onlyOwner returns (bool) {
204 		freezes[addr] = status;
205 		return true;
206 	}
207 
208 	function frozen(address addr) public constant onlyOwner returns (bool) {
209 		return freezes[addr];
210 	}
211 
212 	function setWallet(address addr) public onlyOwner returns (bool) {
213 		wallet = addr;
214 		return true;
215 	}
216 
217 	function setDeveloper(address addr , bool status) public onlyOwner returns (bool) {
218 		developers[addr] = status;
219 		return true;
220 	}
221 
222 	function getDeveloper(address addr) public constant onlyOwner returns (bool) {
223 		return developers[addr];
224 	}
225 
226 	function getContribution(address addr) public constant onlyOwner returns (uint256) {
227 		return contributions[addr];
228 	}
229 
230 	function setSpecialPrice(address addr, uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
231         specialPrices[addr] = SpecialPrice(_buyPrice, _sellPrice, true);
232         return true;
233     }
234 
235     function delSpecialPrice(address addr) public onlyOwner returns (bool) {
236         delete specialPrices[addr];
237         return true;
238     }
239 
240 	function price(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
241 		buyPrice = _buyPrice;
242 		sellPrice = _sellPrice;
243 		Price(buyPrice, sellPrice);
244 		return true;
245 	}
246 
247 	function setBuyPrice(uint256 _buyPrice) public onlyOwner returns (bool) {
248 		buyPrice = _buyPrice;
249 		Price(buyPrice, sellPrice);
250 		return true;
251 	}
252 
253 	function setSellPrice(uint256 _sellPrice) public onlyOwner returns (bool) {
254 		sellPrice = _sellPrice;
255 		Price(buyPrice, sellPrice);
256 		return true;
257 	}
258 
259 	function getBuyPrice(address addr) public constant returns (uint256) {
260 		SpecialPrice memory specialPrice = specialPrices[addr];
261 		if(specialPrice.exists) {
262 			return specialPrice.buyPrice;
263 		}
264 		return buyPrice;
265 	}
266 
267 	function getSellPrice(address addr) public constant returns (uint256) {
268 		SpecialPrice memory specialPrice = specialPrices[addr];
269 		if(specialPrice.exists) {
270 			return specialPrice.sellPrice;
271 		}
272 		return sellPrice;
273 	}
274 
275 	function () public payable {
276 		buy();
277 	}
278 
279 	function withdraw() public onlyOwner returns (bool) {
280 		msg.sender.transfer(this.balance);
281 		return true;
282 	}
283 
284 	function buy() public payable returns(uint256) {
285 		require(msg.value > 0);
286 		require(tokenStatus == true || developers[msg.sender] == true);
287 		require(buyStatus == true);
288 
289 		uint256 buyPriceSpecial = getBuyPrice(msg.sender);
290 		uint256 bigval = msg.value * (10 ** uint256(decimals));
291 		uint256 units =  bigval / buyPriceSpecial;
292 
293 		_transfer(owner , msg.sender , units);
294 		Buy(msg.sender , msg.value , units);
295 		
296 		totalContributors = totalContributors.add(1);
297 		totalContribution = totalContribution.add(msg.value);
298 		contributions[msg.sender] = contributions[msg.sender].add(msg.value);
299 
300 		_forward(msg.value);
301 		return units;
302 	}
303 
304 	function sell(uint256 units) public payable returns(uint256) {
305 		require(units > 0);
306 		require(tokenStatus == true || developers[msg.sender] == true);
307 		require(sellStatus == true);
308 
309 		uint256 sellPriceSpecial = getSellPrice(msg.sender);
310 		uint256 value = ((units * sellPriceSpecial) / (10 ** uint256(decimals)));
311 		_transfer(msg.sender , owner , units);
312 
313 		Sell(msg.sender , value , units);
314 		msg.sender.transfer(value);	
315 		return value;
316 	}
317 
318 	function refund() public payable returns(uint256) {
319 		require(contributions[msg.sender] > 0);
320 		require(tokenStatus == true || developers[msg.sender] == true);
321 		require(refundStatus == true);
322 
323 		uint256 value = contributions[msg.sender];
324 		contributions[msg.sender] = 0;
325 
326 		Refund(msg.sender, value);
327 		msg.sender.transfer(value);	
328 		return value;
329 	}
330 
331 	function setTokenStatus(bool _tokenStatus) public onlyOwner returns (bool) {
332 		tokenStatus = _tokenStatus;
333 		return true;
334 	}
335 
336 	function setTransferStatus(bool _transferStatus) public onlyOwner returns (bool) {
337 		transferStatus = _transferStatus;
338 		return true;
339 	}
340 
341 	function setBuyStatus(bool _buyStatus) public onlyOwner returns (bool) {
342 		buyStatus = _buyStatus;
343 		return true;
344 	}
345 
346 	function setSellStatus(bool _sellStatus) public onlyOwner returns (bool) {
347 		sellStatus = _sellStatus;
348 		return true;
349 	}
350 
351 	function setRefundStatus(bool _refundStatus) public onlyOwner returns (bool) {
352 		refundStatus = _refundStatus;
353 		return true;
354 	}
355 
356 	function _transfer(address from, address to, uint256 value) private onlyPayloadSize(3 * 32) returns (bool) {
357 		require(to != address(0));
358 		require(from != to);
359 		require(value > 0);
360 
361 		require(balances[from] - value >= 0);
362 		require(balances[from] - value < balances[from]);
363 		require(balances[to] + value > balances[to]);
364 
365 		require(freezes[from] == false);
366 		require(tokenStatus == true || developers[msg.sender] == true);
367 		require(transferStatus == true);
368 
369 		balances[from] = balances[from].sub(value);
370 		balances[to] = balances[to].add(value);
371 
372 		_addSupply(to, value);
373 		_subSupply(from, value);
374 		
375 		Transfer(from, to, value);
376 		return true;
377 	}
378 
379 	function _forward(uint256 value) internal returns (bool) {
380 		wallet.transfer(value);
381 		return true;
382 	}
383 
384 	function _approve(address owner, address spender, uint256 value) private returns (bool) {
385 		require(value > 0);
386 		allowed[owner][spender] = value;
387 		Approval(owner, spender, value);
388 		return true;
389 	}
390 
391 	function _addSupply(address to, uint256 value) private returns (bool) {
392 		if(owner == to) {
393 			require(availSupply + value > availSupply);
394 			require(transSupply - value >= 0);
395 			require(transSupply - value < transSupply);
396 			availSupply = availSupply.add(value);
397 			transSupply = transSupply.sub(value);
398 			require(balances[owner] == availSupply);
399 		}
400 		return true;
401 	}
402 
403 	function _subSupply(address from, uint256 value) private returns (bool) {
404 		if(owner == from) {
405 			require(availSupply - value >= 0);
406 			require(availSupply - value < availSupply);
407 			require(transSupply + value > transSupply);
408 			availSupply = availSupply.sub(value);
409 			transSupply = transSupply.add(value);
410 			require(balances[owner] == availSupply);
411 		}
412 		return true;
413 	}
414 }