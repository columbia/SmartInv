1 contract SafeMath {
2 	  function safeMul(uint a, uint b) internal returns (uint) {
3 		uint c = a * b;
4 		assert(a == 0 || c / a == b);
5 		return c;
6 	  }
7 	  function safeSub(uint a, uint b) internal returns (uint) {
8 		assert(b <= a);
9 		return a - b;
10 	  }
11 	  function safeAdd(uint a, uint b) internal returns (uint) {
12 		uint c = a + b;
13 		assert(c>=a && c>=b);
14 		return c;
15 	  }
16 	  // mitigate short address attack
17 	  // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
18 	  // TODO: doublecheck implication of >= compared to ==
19 	  modifier onlyPayloadSize(uint numWords) {
20 		 assert(msg.data.length >= numWords * 32 + 4);
21 		 _;
22 	  }
23 	}
24 
25 	contract Token { // ERC20 standard
26 		function balanceOf(address _owner) public  view returns (uint256 balance);
27 		function transfer(address _to, uint256 _value) public  returns (bool success);
28 		function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
29 		function approve(address _spender, uint256 _value)  returns (bool success);
30 		function allowance(address _owner, address _spender) public  view returns (uint256 remaining);
31 		event Transfer(address indexed _from, address indexed _to, uint256 _value);
32 		event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 	}
34 
35 	contract StandardToken is Token, SafeMath {
36 		uint256 public totalSupply;
37 		// TODO: update tests to expect throw
38 		function transfer(address _to, uint256 _value) public  onlyPayloadSize(2) returns (bool success) {
39 			require(_to != address(0));
40 			require(balances[msg.sender] >= _value && _value > 0);
41 			balances[msg.sender] = safeSub(balances[msg.sender], _value);
42 			balances[_to] = safeAdd(balances[_to], _value);
43 			Transfer(msg.sender, _to, _value);
44 			return true;
45 		}
46 		// TODO: update tests to expect throw
47 		function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
48 			require(_to != address(0));
49 			require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
50 			balances[_from] = safeSub(balances[_from], _value);
51 			balances[_to] = safeAdd(balances[_to], _value);
52 			allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
53 			Transfer(_from, _to, _value);
54 			return true;
55 		}
56 		function balanceOf(address _owner) view returns (uint256 balance) {
57 			return balances[_owner];
58 		}
59 		// To change the approve amount you first have to reduce the addresses'
60 		//  allowance to zero by calling 'approve(_spender, 0)' if it is not
61 		//  already 0 to mitigate the race condition described here:
62 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63 		function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
64 			require((_value == 0) || (allowed[msg.sender][_spender] == 0));
65 			allowed[msg.sender][_spender] = _value;
66 			Approval(msg.sender, _spender, _value);
67 			return true;
68 		}
69 		function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success) {
70 			require(allowed[msg.sender][_spender] == _oldValue);
71 			allowed[msg.sender][_spender] = _newValue;
72 			Approval(msg.sender, _spender, _newValue);
73 			return true;
74 		}
75 		function allowance(address _owner, address _spender) public  view returns (uint256 remaining) {
76 		  return allowed[_owner][_spender];
77 		}
78 		mapping (address => uint256) public  balances;
79 		mapping (address => mapping (address => uint256)) public  allowed;
80 	}
81 
82 	contract STC is StandardToken {
83 		// FIELDS
84 		string public name = "SmarterThanCrypto";
85 		string public symbol = "STC";
86 		uint256 public decimals = 18;
87 		string public version = "10.0";
88 		uint256 public tokenCap = 100000000 * 10**18;
89 		// crowdsale parameters
90 		uint256 public fundingStartTime;
91 		uint256 public fundingEndTime;
92 		// vesting fields
93 		address public vestingContract;
94 		bool private vestingSet = false;
95 		// root control
96 		address public fundWallet;
97 		// control of liquidity and limited control of updatePrice
98 		address public controlWallet;
99 		// time to wait between controlWallet price updates
100 		uint256 public waitTime = 1 hours;
101 		// fundWallet controlled state variables
102 		// halted: halt buying due to emergency, tradeable: signal that assets have been acquired
103 		bool public halted = false;
104 		bool public tradeable = false;
105 		// -- totalSupply defined in StandardToken
106 		// -- mapping to token balances done in StandardToken
107 		uint256 public previousUpdateTime = 0;
108 		Price public currentPrice;
109 		uint256 public minAmount = 0.04 ether;
110 		uint256 public OfferTime = 2592000;
111 	 
112 
113 		// map participant address to a withdrawal request
114 		mapping (address => Withdrawal) public withdrawals;
115 		// maps previousUpdateTime to the next price
116 		mapping (uint256 => Price) public prices;
117 		// maps addresses
118 		mapping (address => bool) public whitelist;
119 		// TYPES
120 		struct Price { // tokensPerEth
121 			uint256 numerator;
122 			uint256 denominator;
123 		}
124 		struct Withdrawal {
125 			uint256 tokens;
126 			uint256 time; // time for each withdrawal is set to the previousUpdateTime
127 		}
128 		// EVENTS
129 		event Buy(address indexed participant, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);
130 		event AllocatePresale(address indexed participant, uint256 amountTokens);
131 		event Whitelist(address indexed participant);
132 		event PriceUpdate(uint256 numerator, uint256 denominator);
133 		event AddLiquidity(uint256 ethAmount);
134 		event RemoveLiquidity(uint256 ethAmount);
135 		event WithdrawRequest(address indexed participant, uint256 amountTokens);
136 		event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
137 		// MODIFIERS
138 		modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
139 			require(tradeable || msg.sender == fundWallet || msg.sender == vestingContract);
140 			_;
141 		}
142 		modifier onlyWhitelist {
143 			require(whitelist[msg.sender]);
144 			_;
145 		}
146 		modifier onlyFundWallet {
147 			require(msg.sender == fundWallet);
148 			_;
149 		}
150 		modifier onlyManagingWallets {
151 			require(msg.sender == controlWallet || msg.sender == fundWallet);
152 			_;
153 		}
154 		modifier only_if_controlWallet {
155 			if (msg.sender == controlWallet) _;
156 		}
157 		modifier require_waited {
158 			require(safeSub(now, waitTime) >= previousUpdateTime);
159 			_;
160 		}
161 		modifier only_if_increase (uint256 newNumerator) {
162 			if (newNumerator > currentPrice.numerator) _;
163 		}
164 		// CONSTRUCTOR
165 		function STC(address controlWalletInput, uint256 priceNumeratorInput, uint256 startTimeInput, uint256 endTimeInput) public  {
166 			require(controlWalletInput != address(0));
167 			require(priceNumeratorInput > 0);
168 			require(endTimeInput > startTimeInput);
169 			fundWallet = msg.sender;
170 			controlWallet = controlWalletInput;
171 			whitelist[fundWallet] = true;
172 			whitelist[controlWallet] = true;
173 			currentPrice = Price(priceNumeratorInput, 10000); // 1 token = 1 usd at ICO start
174 			fundingStartTime = startTimeInput;
175 			fundingEndTime = endTimeInput;
176 			previousUpdateTime = now;
177 		}			
178 		// METHODS	
179 		function setOfferTime(uint256 newOfferTime) external onlyFundWallet {
180 			require(newOfferTime>0);
181 			require(newOfferTime<safeSub(fundingEndTime,fundingStartTime));
182 			OfferTime = newOfferTime;
183 		}		
184 		function setVestingContract(address vestingContractInput) external onlyFundWallet {
185 			require(vestingContractInput != address(0));
186 			vestingContract = vestingContractInput;
187 			whitelist[vestingContract] = true;
188 			vestingSet = true;
189 		}
190 		// allows controlWallet to update the price within a time contstraint, allows fundWallet complete control
191 		function updatePrice(uint256 newNumerator) external onlyManagingWallets {
192 			require(newNumerator > 0);
193 			require_limited_change(newNumerator);
194 			// either controlWallet command is compliant or transaction came from fundWallet
195 			currentPrice.numerator = newNumerator;
196 			// maps time to new Price (if not during ICO)
197 			prices[previousUpdateTime] = currentPrice;
198 			previousUpdateTime = now;
199 			PriceUpdate(newNumerator, currentPrice.denominator);
200 		}
201 		function require_limited_change (uint256 newNumerator)
202 			private
203 			only_if_controlWallet
204 			require_waited
205 			only_if_increase(newNumerator)
206 		{
207 			uint256 percentage_diff = 0;
208 			percentage_diff = safeMul(newNumerator, 10000) / currentPrice.numerator;
209 			percentage_diff = safeSub(percentage_diff, 10000);
210 			// controlWallet can only increase price by max 20% and only every waitTime
211 			//require(percentage_diff <= 20);
212 		}
213 		function updatePriceDenominator(uint256 newDenominator) external onlyManagingWallets {
214 			require(now > fundingEndTime);
215 			require(newDenominator > 0);
216 			currentPrice.denominator = newDenominator;
217 			// maps time to new Price
218 			prices[previousUpdateTime] = currentPrice;
219 			previousUpdateTime = now;
220 			PriceUpdate(currentPrice.numerator, newDenominator);
221 		}
222 		function updatePriceAndDenominator(uint256 newNumerator, uint256 newDenominator) external onlyManagingWallets {
223 			require(now > fundingEndTime);
224 			require(newDenominator > 0);
225 			require(newNumerator > 0);
226 			require(safeSub(now, waitTime) >= previousUpdateTime);
227 			currentPrice.denominator = newDenominator;
228 			currentPrice.numerator = newNumerator;
229 			// maps time to new Price
230 			prices[previousUpdateTime] = currentPrice;
231 			previousUpdateTime = now;
232 			PriceUpdate(currentPrice.numerator, newDenominator);
233 		}
234 		function allocateTokens(address participant, uint256 amountTokens) private {
235 			require(vestingSet);
236 			// 13% of total allocated for PR, Marketing, Team, Advisors
237 			uint256 developmentAllocation = safeMul(amountTokens, 14942528735632200) / 100000000000000000;
238 			// check that token cap is not exceeded
239 			uint256 newTokens = safeAdd(amountTokens, developmentAllocation);
240 			require(safeAdd(totalSupply, newTokens) <= tokenCap);
241 			// increase token supply, assign tokens to participant
242 			totalSupply = safeAdd(totalSupply, newTokens);
243 			balances[participant] = safeAdd(balances[participant], amountTokens);
244 			balances[vestingContract] = safeAdd(balances[vestingContract], developmentAllocation);
245 		}
246 		function allocatePresaleTokens(address participant, uint amountTokens) external onlyManagingWallets {
247 			require(!halted);
248 			require(participant != address(0));
249 			whitelist[participant] = true; // automatically whitelist accepted presale
250 			allocateTokens(participant, amountTokens);
251 			Whitelist(participant);
252 			AllocatePresale(participant, amountTokens);
253 		}
254 		function verifyParticipant(address participant) external onlyManagingWallets {
255 			whitelist[participant] = true;
256 			Whitelist(participant);
257 		}
258 		function buy() external payable {
259 			buyTo(msg.sender);
260 		}
261 		function buyTo(address participant) public payable onlyWhitelist {
262 			require(!halted);
263 			require(participant != address(0));
264 			require(msg.value >= minAmount);
265 			require(now >= fundingStartTime);
266 			uint256 icoDenominator = icoDenominatorPrice();
267 			uint256 tokensToBuy = safeMul(msg.value, currentPrice.numerator) / icoDenominator;
268 			allocateTokens(participant, tokensToBuy);
269 			// send ether to fundWallet
270 			fundWallet.transfer(msg.value);
271 			Buy(msg.sender, participant, msg.value, tokensToBuy);
272 		}
273 		// time based on blocknumbers, assuming a blocktime of 30s
274 		function icoDenominatorPrice() public view returns (uint256) {
275 			uint256 icoDuration = safeSub(now, fundingStartTime);
276 			uint256 denominator;
277 			if (icoDuration < 172800) { // time in sec = (48*60*60) = 172800
278 			   denominator = safeMul(currentPrice.denominator, 95) / 100;
279 			   return denominator;
280 			} else if (icoDuration < OfferTime ) { // time in sec = (((4*7)+2)*24*60*60) = 2592000
281 				denominator = safeMul(currentPrice.denominator, 100) / 100;
282 			   return denominator;
283 			} else if (now > fundingEndTime ) {
284 			   denominator = safeMul(currentPrice.denominator, 100) / 100;
285 			   return denominator;   
286 			} else {
287 				denominator = safeMul(currentPrice.denominator, 105) / 100;
288 			   return denominator;
289 			}
290 		}
291 		function requestWithdrawal(uint256 amountTokensToWithdraw) external isTradeable onlyWhitelist {
292 			require(now > fundingEndTime);
293 			require(amountTokensToWithdraw > 0);
294 			address participant = msg.sender;
295 			require(balanceOf(participant) >= amountTokensToWithdraw);
296 			require(withdrawals[participant].tokens == 0); // participant cannot have outstanding withdrawals
297 			balances[participant] = safeSub(balances[participant], amountTokensToWithdraw);
298 			withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: previousUpdateTime});
299 			WithdrawRequest(participant, amountTokensToWithdraw);
300 		}
301 		function withdraw() external {
302 			address participant = msg.sender;
303 			uint256 tokens = withdrawals[participant].tokens;
304 			require(tokens > 0); // participant must have requested a withdrawal
305 			uint256 requestTime = withdrawals[participant].time;
306 			// obtain the next price that was set after the request
307 			Price price = prices[requestTime];
308 			require(price.numerator > 0); // price must have been set
309 			uint256 withdrawValue  = safeMul(tokens, price.denominator) / price.numerator;
310 			// if contract ethbal > then send + transfer tokens to fundWallet, otherwise give tokens back
311 			withdrawals[participant].tokens = 0;
312 			if (this.balance >= withdrawValue)
313 				enact_withdrawal_greater_equal(participant, withdrawValue, tokens);
314 			else
315 				enact_withdrawal_less(participant, withdrawValue, tokens);
316 		}
317 		function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens)
318 			private
319 		{
320 			assert(this.balance >= withdrawValue);
321 			balances[fundWallet] = safeAdd(balances[fundWallet], tokens);
322 			participant.transfer(withdrawValue);
323 			Withdraw(participant, tokens, withdrawValue);
324 		}
325 		function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens)
326 			private
327 		{
328 			assert(this.balance < withdrawValue);
329 			balances[participant] = safeAdd(balances[participant], tokens);
330 			Withdraw(participant, tokens, 0); // indicate a failed withdrawal
331 		}
332 		function checkWithdrawValue(uint256 amountTokensToWithdraw) public  view returns (uint256 etherValue) {
333 			require(amountTokensToWithdraw > 0);
334 			require(balanceOf(msg.sender) >= amountTokensToWithdraw);
335 			uint256 withdrawValue = safeMul(amountTokensToWithdraw, currentPrice.denominator) / currentPrice.numerator;
336 			require(this.balance >= withdrawValue);
337 			return withdrawValue;
338 		}
339 		function checkWithdrawValueForAddress(address participant,uint256 amountTokensToWithdraw) public  view returns (uint256 etherValue) {
340 			require(amountTokensToWithdraw > 0);
341 			require(balanceOf(participant) >= amountTokensToWithdraw);
342 			uint256 withdrawValue = safeMul(amountTokensToWithdraw, currentPrice.denominator) / currentPrice.numerator;
343 			return withdrawValue;
344 		}
345 		// allow fundWallet or controlWallet to add ether to contract
346 		function addLiquidity() external onlyManagingWallets payable {
347 			require(msg.value > 0);
348 			AddLiquidity(msg.value);
349 		}
350 		// allow fundWallet to remove ether from contract
351 		function removeLiquidity(uint256 amount) external onlyManagingWallets {
352 			require(amount <= this.balance);
353 			fundWallet.transfer(amount);
354 			RemoveLiquidity(amount);
355 		}
356 		function changeFundWallet(address newFundWallet) external onlyFundWallet {
357 			require(newFundWallet != address(0));
358 			fundWallet = newFundWallet;
359 		}
360 		function changeControlWallet(address newControlWallet) external onlyFundWallet {
361 			require(newControlWallet != address(0));
362 			controlWallet = newControlWallet;
363 		}
364 		function changeWaitTime(uint256 newWaitTime) external onlyFundWallet {
365 			waitTime = newWaitTime;
366 		}
367 		function updatefundingStartTime(uint256 newfundingStartTime) external onlyFundWallet {
368 		   // require(now < fundingStartTime);
369 		   // require(now < newfundingStartTime);
370 			fundingStartTime = newfundingStartTime;
371 		}
372 		function updatefundingEndTime(uint256 newfundingEndTime) external onlyFundWallet {
373 		  //  require(now < fundingEndTime);
374 		  //  require(now < newfundingEndTime);
375 			fundingEndTime = newfundingEndTime;
376 		}
377 		function halt() external onlyFundWallet {
378 			halted = true;
379 		}
380 		function unhalt() external onlyFundWallet {
381 			halted = false;
382 		}
383 		function enableTrading() external onlyFundWallet {
384 			require(now > fundingEndTime);
385 			tradeable = true;
386 		}
387 		// fallback function
388 		function() payable {
389 			require(tx.origin == msg.sender);
390 			buyTo(msg.sender);
391 		}
392 		function claimTokens(address _token) external onlyFundWallet {
393 			require(_token != address(0));
394 			Token token = Token(_token);
395 			uint256 balance = token.balanceOf(this);
396 			token.transfer(fundWallet, balance);
397 		 }
398 		// prevent transfers until trading allowed
399 		function transfer(address _to, uint256 _value) isTradeable returns (bool success) {
400 			return super.transfer(_to, _value);
401 		}
402 		function transferFrom(address _from, address _to, uint256 _value) public  isTradeable returns (bool success) {
403 			return super.transferFrom(_from, _to, _value);
404 		}
405 	}