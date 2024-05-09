1 pragma solidity ^0.4.19;
2 
3 //--------- OpenZeppelin's Safe Math
4 //Source : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 		if (a == 0) {
12 		return 0;
13 		}
14 		uint256 c = a * b;
15 		assert(c / a == b);
16 		return c;
17 	}
18 
19   	function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     	uint256 c = a / b;
21     	return c;
22   	}
23 
24   	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     	assert(b <= a);
26     	return a - b;
27   	}
28 
29   	function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     	uint256 c = a + b;
31     	assert(c >= a);
32     	return c;
33   	}
34 }
35 //-----------------------------------------------------B
36 
37 
38 //"EXTERN" CONTRACTS
39 //============================
40 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
41 contract ERC20 {
42   	function transfer(address _to, uint256 _value) public returns (bool success);
43   	function balanceOf(address _owner) public constant returns (uint256 balance);
44 }
45 
46 contract Viscous {
47     function is_whitelisted(address) constant returns (bool);
48 }
49 //============================
50 
51 contract Controller {
52 
53 	address public owner;
54   	//event ChangeOwner(address new_owner);
55 
56 	modifier onlyOwner {
57     	require(msg.sender == owner);
58     	_;
59   	}
60 
61   	function change_owner(address new_owner) onlyOwner {
62     	require(new_owner != 0x0);
63     	owner = new_owner;
64     	//ChangeOwner(new_owner);
65   	}
66 
67   	function Controller() {
68     	owner = msg.sender;
69   	}
70 }
71 
72 contract Contract is Controller {
73 
74   //EVENTS
75   //============================
76   /* event BuyTheTokens(address sale, uint256 amount, bytes data);
77   event Whitelist(bool boolean);
78   event Contribution(address sender, uint256 amount, uint256 total_amount, uint256 contract_balance);
79   event Withdraw(address sender, uint256 amount);
80   event Refund(address sender, uint256 amount, uint256 total_amount, uint256 contract_balance); */
81   //============================
82 
83 	using SafeMath for uint256;
84 
85   	struct Contributor {
86 		uint256 balance;
87 	    uint256 fee;
88 	    uint8 rounds;
89 	    bool whitelisted;
90   	}
91 
92 	struct Snapshot {
93 		uint256 tokens_balance;
94 		uint256 eth_balance;
95 	}
96 
97 	modifier minAmountReached {
98 		require(this.balance >= min_amount);
99 		_;
100 	}
101 
102   	modifier underMaxAmount {
103     	require(max_amount == 0 || this.balance <= max_amount);
104     	_;
105   	}
106 
107 	//FEES RELATED
108 	//============================
109 	address constant public DEVELOPER1 = 0x8C006d807EBAe91F341a4308132Fd756808e0126;
110 	address constant public DEVELOPER2 = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
111 	uint256 constant public FEE_DEV = 670; //0.2% fee per dev -> so 0.4% fee in total
112 	//============================
113 
114 	//VARIABLES TO BE CHANGED BY OWNER
115 	//============================
116 	uint256 public FEE_OWNER; //value as divisor (ie. 1 / FEE_OWNER = % Rate) or (1 / 200 = 0.4%)
117 	uint256 public max_amount;  //0 means there is no limit
118 	uint256 public min_amount;
119 	uint256 public individual_cap;
120 	uint256 public gas_price_max;
121 	uint8 public rounds;
122 	//flag controlled by owner to enable/disable whitelists for viscous or temporary whitelist
123 	bool public whitelist_enabled;
124 	//Contract containing the data
125 	Viscous public viscous_contract = Viscous(0x0);
126 	//============================
127 
128   //###############################################################################################################################
129 
130 	//CONTRACT VARIABLES
131 	//============================
132 	//=== ARRAYS & MAPPINGS ===
133 	mapping (address => Contributor) public contributors;
134 	//First element will be the first wave of tokens, and so forth
135 	Snapshot[] public snapshots;
136 
137 	//=== UINT ===
138 	// Record ETH value of tokens currently held by contract.
139 	uint256 public const_contract_eth_value;
140 	//The reduction of the allocation in % | example : 40 -> 40% reduction
141 	uint256 public percent_reduction;
142 
143 	//=== ADDRESSES ===
144 	//The address of the contact.
145 	address public sale;
146 	//Token address
147 	ERC20 public token;
148 	//=== BOOLS ===
149 	//Track whether the contract has bought the tokens yet.
150 	bool public bought_tokens;
151 	//Track if the owner partially refunds his fee in the event of a partial refund post-buy
152 	bool public owner_supplied_eth;
153 	bool public allow_contributions = true;
154   //============================
155 
156 	function Contract(
157 		uint256 _max_amount,
158 		uint256 _min_amount,
159 		bool _whitelist,
160 		uint256 _owner_fee_divisor
161 		) {
162 			max_amount = calculate_with_fees(_max_amount);  //0 means there is no limit
163 		  	min_amount = calculate_with_fees(_min_amount);
164 		  	whitelist_enabled = _whitelist;
165 		  	FEE_OWNER = _owner_fee_divisor;
166 		  	Contributor storage contributor = contributors[msg.sender];
167 		  	contributor.whitelisted = true;
168   		}
169 
170   //###############################################################################################################################
171 
172 	//OWNER FUNCTIONS
173 	//============================
174 	// Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
175 	function buy_the_tokens(bytes _data) onlyOwner minAmountReached {
176 		//Avoids burning the funds
177 		require(!bought_tokens && sale != 0x0);
178 		//Record that the contract has bought the tokens.
179 		bought_tokens = true;
180 		const_contract_eth_value = this.balance;
181 		take_fees_eth_dev();
182 		take_fees_eth_owner();
183 		//Record the amount of ETH sent as the contract's current value.
184 		const_contract_eth_value = this.balance;
185 		// Transfer all the funds to the crowdsale address.
186 		require(sale.call.gas(msg.gas).value(this.balance)(_data));
187 		//BuyTheTokens(sale, const_contract_eth_value, _data);
188 	}
189 
190 	//These two functions concern the "temporary" whitelist
191 	function whitelist_addys(address[] _addys) onlyOwner {
192 		for (uint256 i = 0; i < _addys.length; i++) {
193 			Contributor storage contributor = contributors[_addys[i]];
194 			contributor.whitelisted = true;
195 		}
196 	}
197 
198 	function blacklist_addys(address[] _addys) onlyOwner {
199 		for (uint256 i = 0; i < _addys.length; i++) {
200 			Contributor storage contributor = contributors[_addys[i]];
201 			contributor.whitelisted = false;
202 		}
203 	}
204 
205 	function set_gas_price_max(uint256 _gas_price) onlyOwner {
206 		gas_price_max = _gas_price;
207 	}
208 
209 	function set_sale_address(address _sale) onlyOwner {
210 		//Avoid mistake of putting 0x0
211 		require(_sale != 0x0);
212 		sale = _sale;
213 	}
214 
215 	function set_token_address(address _token) onlyOwner {
216 		require(_token != 0x0);
217 		token = ERC20(_token);
218 	}
219 
220 	function set_allow_contributions(bool _boolean) onlyOwner {
221 		allow_contributions = _boolean;
222 	}
223 
224 	function set_tokens_received() onlyOwner {
225 		tokens_received();
226 	}
227 
228 	function set_percent_reduction(uint256 _reduction) onlyOwner payable {
229 		require(bought_tokens && rounds == 0 && _reduction <= 100);
230 		percent_reduction = _reduction;
231 		if (msg.value > 0) {
232 			owner_supplied_eth = true;
233 		}
234 		//we substract by contract_eth_value*_reduction basically
235 		const_contract_eth_value = const_contract_eth_value.sub((const_contract_eth_value.mul(_reduction)).div(100));
236 	}
237 
238 	function set_whitelist_enabled(bool _boolean) onlyOwner {
239 		whitelist_enabled = _boolean;
240 		//Whitelist(_boolean);
241 	}
242 
243 	function change_viscous_contract(address _addy) onlyOwner {
244 		viscous_contract = Viscous(_addy);
245 	}
246 
247 	function change_individual_cap(uint256 _cap) onlyOwner {
248 		individual_cap = _cap;
249 	}
250 
251 	function change_max_amount(uint256 _amount) onlyOwner {
252 		//ATTENTION! The new amount should be in wei
253 		//Use https://etherconverter.online/
254 		max_amount = calculate_with_fees(_amount);
255 	}
256 
257 	function change_min_amount(uint256 _amount) onlyOwner {
258 		//ATTENTION! The new amount should be in wei
259 		//Use https://etherconverter.online/
260 		min_amount = calculate_with_fees(_amount);
261 	}
262 
263 	function change_fee(uint256 _fee) onlyOwner {
264 		FEE_OWNER = _fee;
265 	}
266 
267 	function emergency_token_withdraw(address _address) onlyOwner {
268 	 	ERC20 temp_token = ERC20(_address);
269 		require(temp_token.transfer(msg.sender, temp_token.balanceOf(this)));
270 	}
271 
272 	function emergency_eth_withdraw() onlyOwner {
273 		msg.sender.transfer(this.balance);
274 	}
275 
276 //###############################################################################################################################
277 
278 
279 	//INTERNAL FUNCTIONS
280 	//============================
281 	// Allows any user to withdraw his tokens.
282 	function withdraw(address _user) internal {
283 		// Disallow withdraw if tokens haven't been bought yet.
284 		require(bought_tokens);
285 		uint256 contract_token_balance = token.balanceOf(address(this));
286 		// Disallow token withdrawals if there are no tokens to withdraw.
287 		require(contract_token_balance != 0);
288 		Contributor storage contributor = contributors[_user];
289 		if (contributor.rounds < rounds) {
290             //contributor can claim his bonus tokens of previous rounds if he didn't withdrawn
291             //uint256 this_contribution_claim = (rounds-contributor.rounds)*contributor.balance;
292 			Snapshot storage snapshot = snapshots[contributor.rounds];
293             uint256 tokens_to_withdraw = contributor.balance.mul(snapshot.tokens_balance).div(snapshot.eth_balance);
294 			snapshot.tokens_balance = snapshot.tokens_balance.sub(tokens_to_withdraw);
295 			snapshot.eth_balance = snapshot.eth_balance.sub(contributor.balance);
296             // Update the value of tokens currently held by the contract.
297             //contract_eth_value -= contributor.balance;
298             contributor.rounds++;
299             // Send the funds.  Throws on failure to prevent loss of funds.
300             require(token.transfer(_user, tokens_to_withdraw));
301             //Withdraw(_user, tokens_to_withdraw);
302         }
303 	}
304 
305 	// Allows any user to get his eth refunded before the purchase is made.
306 	function refund(address _user) internal {
307 		require(!bought_tokens && percent_reduction == 0);
308 		Contributor storage contributor = contributors[_user];
309 		uint256 eth_to_withdraw = contributor.balance.add(contributor.fee);
310 		// Update the user's balance prior to sending ETH to prevent recursive call.
311 		contributor.balance = 0;
312 		contributor.fee = 0;
313 		// Return the user's funds.  Throws on failure to prevent loss of funds.
314 		_user.transfer(eth_to_withdraw);
315 		//Refund(_user, eth_to_withdraw, contributor.balance, this.balance);
316 	}
317 
318 	//Allows any user to get a part of his ETH refunded, in proportion
319 	//to the % reduced of the allocation
320 	function partial_refund(address _user) internal {
321 		require(bought_tokens && rounds == 0 && percent_reduction > 0);
322 		Contributor storage contributor = contributors[_user];
323 		require(contributor.rounds == 0);
324 		uint256 eth_to_withdraw = contributor.balance.mul(percent_reduction).div(100);
325 		contributor.balance = contributor.balance.sub(eth_to_withdraw);
326 		if (owner_supplied_eth) {
327 			//dev fees aren't refunded, only owner fees
328 			//We don't care about updatng contributor's fee, it doesn't matter for receiving the tokens
329 			uint256 fee = contributor.fee.mul(percent_reduction).div(100);
330 			eth_to_withdraw = eth_to_withdraw.add(fee);
331 		}
332 		_user.transfer(eth_to_withdraw);
333 		//Refund(_user, eth_to_withdraw, contributor.balance, this.balance);
334 	}
335 
336 	function take_fees_eth_dev() internal {
337 		if (FEE_DEV != 0) {
338 			DEVELOPER1.transfer(const_contract_eth_value.div(FEE_DEV));
339 			DEVELOPER2.transfer(const_contract_eth_value.div(FEE_DEV));
340 		}
341 	}
342 
343 	function take_fees_eth_owner() internal {
344 	//Owner takes fees on the ETH in this case
345 	//In case owner doesn't want to take fees
346 		if (FEE_OWNER != 0) {
347 			owner.transfer(const_contract_eth_value.div(FEE_OWNER));
348 		}
349 	}
350 
351 	function calculate_with_fees(uint256 _amount) internal returns (uint256) {
352 		//divided by two because 2 devs, so 0.4% in total
353 		uint256 temp = _amount;
354 		if (FEE_DEV != 0) {
355 			temp = temp.add(_amount.div(FEE_DEV/2));
356 		}
357 		if (FEE_OWNER != 0) {
358 			temp = temp.add(_amount.div(FEE_OWNER));
359 		}
360 		return temp;
361 	}
362 
363 	function tokens_received() internal {
364 		//We need to check the previous token balance
365 		uint256 previous_balance;
366 		for (uint8 i = 0; i < snapshots.length; i++) {
367 			previous_balance = previous_balance.add(snapshots[i].tokens_balance);
368 		}
369 		snapshots.push(Snapshot(token.balanceOf(address(this)).sub(previous_balance), const_contract_eth_value));
370 		//we don't leave out the tokens that didn't get withdrawn
371 		rounds++;
372 	}
373 
374 
375 //###############################################################################################################################
376 
377   //PUBLIC FUNCTIONS
378   //============================
379 
380   function tokenFallback(address _from, uint _value, bytes _data) {
381 		if (ERC20(msg.sender) == token) {
382 			tokens_received();
383 		}
384 	}
385 
386 	function withdraw_my_tokens() {
387 		for (uint8 i = contributors[msg.sender].rounds; i < rounds; i++) {
388 			withdraw(msg.sender);
389 		}
390 	}
391 
392 	function withdraw_tokens_for(address _addy) {
393 		for (uint8 i = contributors[_addy].rounds; i < rounds; i++) {
394 			withdraw(_addy);
395 		}
396 	}
397 
398 	function refund_my_ether() {
399 		refund(msg.sender);
400 	}
401 
402 	function partial_refund_my_ether() {
403 		partial_refund(msg.sender);
404 	}
405 
406 	function provide_eth() payable {}
407 
408 	// Default function.  Called when a user sends ETH to the contract.
409 	function () payable underMaxAmount {
410 		require(!bought_tokens && allow_contributions && (gas_price_max == 0 || tx.gasprice <= gas_price_max));
411 		Contributor storage contributor = contributors[msg.sender];
412 		//Checks if contributor is whitelisted
413 		if (whitelist_enabled) {
414 			require(contributor.whitelisted || viscous_contract.is_whitelisted(msg.sender));
415 		}
416 		//Manages cases of dev and/or owner taking fees
417 		//"Worst case", substract 0 from the msg.value
418 		uint256 fee = 0;
419 		if (FEE_OWNER != 0) {
420 			fee = SafeMath.div(msg.value, FEE_OWNER);
421 		}
422 		uint256 fees = fee;
423 		if (FEE_DEV != 0) {
424 			fee = msg.value.div(FEE_DEV/2);
425 			fees = fees.add(fee);
426 		}
427 		//Updates both of the balances
428 		contributor.balance = contributor.balance.add(msg.value).sub(fees);
429 		contributor.fee = contributor.fee.add(fees);
430 
431 		//Checks if the individual cap is respected
432 		//If it's not, changes are reverted
433 		require(individual_cap == 0 || contributor.balance <= individual_cap);
434 		//Contribution(msg.sender, msg.value, contributor.balance, this.balance);
435 	}
436 }