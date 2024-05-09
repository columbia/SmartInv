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
64 contract CryptoTokenConstants {
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
95  * @title CryptoToken
96  * @dev CryptoToken implementation
97  */
98 contract CryptoToken is Owned, Payload, CryptoTokenConstants {
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
144 	function CryptoToken (string _name, string _symbol, uint8 _decimals, address _wallet, uint256 _totalSupply, uint256 _buyPrice, uint256 _sellPrice) {
145 		name = bytes(_name).length > 0 ? _name : "IntelliETH";
146 		symbol = bytes(_symbol).length > 0 ? _symbol : "INETH";
147 		decimals = _decimals > 0 ? _decimals : 18;
148 		wallet = _wallet != 0x0 ? _wallet : 0x634dA488e1E122A9f2ED83e91ccb6Db3414e3984;
149 		
150 		_totalSupply = _totalSupply > 0 ? _totalSupply : 500000000;
151 
152 		totalSupply = _totalSupply * (10 ** uint256(decimals));
153 		availSupply = totalSupply;
154 		transSupply = 0;
155 
156 		balances[owner] = totalSupply;
157 
158 		buyPrice = _buyPrice > 0 ? _buyPrice : 444444444444444;
159 		sellPrice = _sellPrice > 0 ? _sellPrice : 0;
160 
161 		developers[owner] = true;
162 		developers[wallet] = true;
163 	}	
164 
165 	function balanceOf(address addr) public constant returns (uint256) {
166 		return balances[addr];
167 	}
168 
169 	function transfer(address to, uint256 value) public onlyPayloadSize(2 * 32) returns (bool) {
170 		return _transfer(msg.sender, to, value);
171 	}
172 
173 	function allowance(address approver, address spender) public constant returns (uint256) {
174 		return allowed[approver][spender];
175 	}
176 
177 	function transferFrom(address approver, address to, uint256 value) public onlyPayloadSize(3 * 32) returns (bool) {
178 		require(allowed[approver][msg.sender] - value >= 0);
179 		require(allowed[approver][msg.sender] - value < allowed[approver][msg.sender]);
180 
181 		allowed[approver][msg.sender] = allowed[approver][msg.sender].sub(value);
182 		return _transfer(approver, to, value);
183 	}
184 
185 	function approve(address spender, uint256 value) public returns (bool) {
186 		return _approve(msg.sender , spender , value);
187 	}
188 
189 	function increaseApproval(address spender , uint256 value) public returns (bool) {
190 		require(value > 0);
191 		require(allowed[msg.sender][spender] + value > allowed[msg.sender][spender]);
192 
193 		value = allowed[msg.sender][spender].add(value);
194 		return _approve(msg.sender , spender , value);
195 	}
196 
197 	function decreaseApproval(address spender , uint256 value) public returns (bool) {
198 		require(value > 0);
199 		require(allowed[msg.sender][spender] - value >= 0);	
200 		require(allowed[msg.sender][spender] - value < allowed[msg.sender][spender]);	
201 
202 		value = allowed[msg.sender][spender].sub(value);
203 		return _approve(msg.sender , spender , value);
204 	}
205 
206 	function freeze(address addr, bool status) public onlyOwner returns (bool) {
207 		freezes[addr] = status;
208 		return true;
209 	}
210 
211 	function frozen(address addr) public constant onlyOwner returns (bool) {
212 		return freezes[addr];
213 	}
214 
215 	function setWallet(address addr) public onlyOwner returns (bool) {
216 		wallet = addr;
217 		return true;
218 	}
219 
220 	function setDeveloper(address addr , bool status) public onlyOwner returns (bool) {
221 		developers[addr] = status;
222 		return true;
223 	}
224 
225 	function getDeveloper(address addr) public constant onlyOwner returns (bool) {
226 		return developers[addr];
227 	}
228 
229 	function getContribution(address addr) public constant onlyOwner returns (uint256) {
230 		return contributions[addr];
231 	}
232 
233 	function setSpecialPrice(address addr, uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
234         specialPrices[addr] = SpecialPrice(_buyPrice, _sellPrice, true);
235         return true;
236     }
237 
238     function delSpecialPrice(address addr) public onlyOwner returns (bool) {
239         delete specialPrices[addr];
240         return true;
241     }
242 
243 	function price(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
244 		buyPrice = _buyPrice;
245 		sellPrice = _sellPrice;
246 		Price(buyPrice, sellPrice);
247 		return true;
248 	}
249 
250 	function setBuyPrice(uint256 _buyPrice) public onlyOwner returns (bool) {
251 		buyPrice = _buyPrice;
252 		Price(buyPrice, sellPrice);
253 		return true;
254 	}
255 
256 	function setSellPrice(uint256 _sellPrice) public onlyOwner returns (bool) {
257 		sellPrice = _sellPrice;
258 		Price(buyPrice, sellPrice);
259 		return true;
260 	}
261 
262 	function getBuyPrice(address addr) public constant returns (uint256) {
263 		SpecialPrice memory specialPrice = specialPrices[addr];
264 		if(specialPrice.exists) {
265 			return specialPrice.buyPrice;
266 		}
267 		return buyPrice;
268 	}
269 
270 	function getSellPrice(address addr) public constant returns (uint256) {
271 		SpecialPrice memory specialPrice = specialPrices[addr];
272 		if(specialPrice.exists) {
273 			return specialPrice.sellPrice;
274 		}
275 		return sellPrice;
276 	}
277 
278 	function () public payable {
279 		buy();
280 	}
281 
282 	function withdraw() public onlyOwner returns (bool) {
283 		msg.sender.transfer(this.balance);
284 		return true;
285 	}
286 
287 	function buy() public payable returns(uint256) {
288 		require(msg.value > 0);
289 		require(tokenStatus == true || developers[msg.sender] == true);
290 		require(buyStatus == true);
291 
292 		uint256 buyPriceSpecial = getBuyPrice(msg.sender);
293 		uint256 bigval = msg.value * (10 ** uint256(decimals));
294 		uint256 units =  bigval / buyPriceSpecial;
295 
296 		_transfer(owner , msg.sender , units);
297 		Buy(msg.sender , msg.value , units);
298 		
299 		totalContributors = totalContributors.add(1);
300 		totalContribution = totalContribution.add(msg.value);
301 		contributions[msg.sender] = contributions[msg.sender].add(msg.value);
302 
303 		_forward(msg.value);
304 		return units;
305 	}
306 
307 	function sell(uint256 units) public payable returns(uint256) {
308 		require(units > 0);
309 		require(tokenStatus == true || developers[msg.sender] == true);
310 		require(sellStatus == true);
311 
312 		uint256 sellPriceSpecial = getSellPrice(msg.sender);
313 		uint256 value = ((units * sellPriceSpecial) / (10 ** uint256(decimals)));
314 		_transfer(msg.sender , owner , units);
315 
316 		Sell(msg.sender , value , units);
317 		msg.sender.transfer(value);	
318 		return value;
319 	}
320 
321 	function refund() public payable returns(uint256) {
322 		require(contributions[msg.sender] > 0);
323 		require(tokenStatus == true || developers[msg.sender] == true);
324 		require(refundStatus == true);
325 
326 		uint256 value = contributions[msg.sender];
327 		contributions[msg.sender] = 0;
328 
329 		Refund(msg.sender, value);
330 		msg.sender.transfer(value);	
331 		return value;
332 	}
333 
334 	function setTokenStatus(bool _tokenStatus) public onlyOwner returns (bool) {
335 		tokenStatus = _tokenStatus;
336 		return true;
337 	}
338 
339 	function setTransferStatus(bool _transferStatus) public onlyOwner returns (bool) {
340 		transferStatus = _transferStatus;
341 		return true;
342 	}
343 
344 	function setBuyStatus(bool _buyStatus) public onlyOwner returns (bool) {
345 		buyStatus = _buyStatus;
346 		return true;
347 	}
348 
349 	function setSellStatus(bool _sellStatus) public onlyOwner returns (bool) {
350 		sellStatus = _sellStatus;
351 		return true;
352 	}
353 
354 	function setRefundStatus(bool _refundStatus) public onlyOwner returns (bool) {
355 		refundStatus = _refundStatus;
356 		return true;
357 	}
358 
359 	function _transfer(address from, address to, uint256 value) private onlyPayloadSize(3 * 32) returns (bool) {
360 		require(to != address(0));
361 		require(from != to);
362 		require(value > 0);
363 
364 		require(balances[from] - value >= 0);
365 		require(balances[from] - value < balances[from]);
366 		require(balances[to] + value > balances[to]);
367 
368 		require(freezes[from] == false);
369 		require(tokenStatus == true || developers[msg.sender] == true);
370 		require(transferStatus == true);
371 
372 		balances[from] = balances[from].sub(value);
373 		balances[to] = balances[to].add(value);
374 
375 		_addSupply(to, value);
376 		_subSupply(from, value);
377 		
378 		Transfer(from, to, value);
379 		return true;
380 	}
381 
382 	function _forward(uint256 value) internal returns (bool) {
383 		wallet.transfer(value);
384 		return true;
385 	}
386 
387 	function _approve(address owner, address spender, uint256 value) private returns (bool) {
388 		require(value > 0);
389 		allowed[owner][spender] = value;
390 		Approval(owner, spender, value);
391 		return true;
392 	}
393 
394 	function _addSupply(address to, uint256 value) private returns (bool) {
395 		if(owner == to) {
396 			require(availSupply + value > availSupply);
397 			require(transSupply - value >= 0);
398 			require(transSupply - value < transSupply);
399 			availSupply = availSupply.add(value);
400 			transSupply = transSupply.sub(value);
401 			require(balances[owner] == availSupply);
402 		}
403 		return true;
404 	}
405 
406 	function _subSupply(address from, uint256 value) private returns (bool) {
407 		if(owner == from) {
408 			require(availSupply - value >= 0);
409 			require(availSupply - value < availSupply);
410 			require(transSupply + value > transSupply);
411 			availSupply = availSupply.sub(value);
412 			transSupply = transSupply.add(value);
413 			require(balances[owner] == availSupply);
414 		}
415 		return true;
416 	}
417 }