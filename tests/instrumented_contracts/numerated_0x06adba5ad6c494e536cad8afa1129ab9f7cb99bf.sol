1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract EOSBetGameInterface {
50 	uint256 public DEVELOPERSFUND;
51 	uint256 public LIABILITIES;
52 	function payDevelopersFund(address developer) public;
53 	function receivePaymentForOraclize() payable public;
54 	function getMaxWin() public view returns(uint256);
55 }
56 
57 contract EOSBetBankrollInterface {
58 	function payEtherToWinner(uint256 amtEther, address winner) public;
59 	function receiveEtherFromGameAddress() payable public;
60 	function payOraclize(uint256 amountToPay) public;
61 	function getBankroll() public view returns(uint256);
62 }
63 
64 contract ERC20 {
65 	function totalSupply() constant public returns (uint supply);
66 	function balanceOf(address _owner) constant public returns (uint balance);
67 	function transfer(address _to, uint _value) public returns (bool success);
68 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
69 	function approve(address _spender, uint _value) public returns (bool success);
70 	function allowance(address _owner, address _spender) constant public returns (uint remaining);
71 	event Transfer(address indexed _from, address indexed _to, uint _value);
72 	event Approval(address indexed _owner, address indexed _spender, uint _value);
73 }
74 
75 contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {
76 
77 	using SafeMath for *;
78 
79 	// constants for EOSBet Bankroll
80 
81 	address public OWNER;
82 	uint256 public MAXIMUMINVESTMENTSALLOWED;
83 	uint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;
84 	uint256 public DEVELOPERSFUND;
85 
86 	// this will be initialized as the trusted game addresses which will forward their ether
87 	// to the bankroll contract, and when players win, they will request the bankroll contract 
88 	// to send these players their winnings.
89 	// Feel free to audit these contracts on etherscan...
90 	mapping(address => bool) public TRUSTEDADDRESSES;
91 
92 	address public DICE;
93 	address public SLOTS;
94 
95 	// mapping to log the last time a user contributed to the bankroll 
96 	mapping(address => uint256) contributionTime;
97 
98 	// constants for ERC20 standard
99 	string public constant name = "EOSBet Stake Tokens";
100 	string public constant symbol = "EOSBETST";
101 	uint8 public constant decimals = 18;
102 	// variable total supply
103 	uint256 public totalSupply;
104 
105 	// mapping to store tokens
106 	mapping(address => uint256) public balances;
107 	mapping(address => mapping(address => uint256)) public allowed;
108 
109 	// events
110 	event FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);
111 	event CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);
112 	event FailedSend(address sendTo, uint256 amt);
113 
114 	// checks that an address is a "trusted address of a legitimate EOSBet game"
115 	modifier addressInTrustedAddresses(address thisAddress){
116 
117 		require(TRUSTEDADDRESSES[thisAddress]);
118 		_;
119 	}
120 
121 	// initialization function 
122 	function EOSBetBankroll(address dice, address slots) public payable {
123 		// function is payable, owner of contract MUST "seed" contract with some ether, 
124 		// so that the ratios are correct when tokens are being minted
125 		require (msg.value > 0);
126 
127 		OWNER = msg.sender;
128 
129 		// 100 tokens/ether is the inital seed amount, so:
130 		uint256 initialTokens = msg.value * 100;
131 		balances[msg.sender] = initialTokens;
132 		totalSupply = initialTokens;
133 
134 		// log a mint tokens event
135 		emit Transfer(0x0, msg.sender, initialTokens);
136 
137 		// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables
138 		TRUSTEDADDRESSES[dice] = true;
139 		TRUSTEDADDRESSES[slots] = true;
140 
141 		DICE = dice;
142 		SLOTS = slots;
143 
144 		WAITTIMEUNTILWITHDRAWORTRANSFER = 6 hours;
145 		MAXIMUMINVESTMENTSALLOWED = 500 ether;
146 	}
147 
148 	///////////////////////////////////////////////
149 	// VIEW FUNCTIONS
150 	/////////////////////////////////////////////// 
151 
152 	function checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){
153 		return contributionTime[bankrollerAddress];
154 	}
155 
156 	function getBankroll() view public returns(uint256){
157 		// returns the total balance minus the developers fund, as the amount of active bankroll
158 		return SafeMath.sub(address(this).balance, DEVELOPERSFUND);
159 	}
160 
161 	///////////////////////////////////////////////
162 	// BANKROLL CONTRACT <-> GAME CONTRACTS functions
163 	/////////////////////////////////////////////// 
164 
165 	function payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){
166 		// this function will get called by a game contract when someone wins a game
167 		// try to send, if it fails, then send the amount to the owner
168 		// note, this will only happen if someone is calling the betting functions with
169 		// a contract. They are clearly up to no good, so they can contact us to retreive 
170 		// their ether
171 		// if the ether cannot be sent to us, the OWNER, that means we are up to no good, 
172 		// and the ether will just be given to the bankrollers as if the player/owner lost 
173 
174 		if (! winner.send(amtEther)){
175 
176 			emit FailedSend(winner, amtEther);
177 
178 			if (! OWNER.send(amtEther)){
179 
180 				emit FailedSend(OWNER, amtEther);
181 			}
182 		}
183 	}
184 
185 	function receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){
186 		// this function will get called from the game contracts when someone starts a game.
187 	}
188 
189 	function payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){
190 		// this function will get called when a game contract must pay payOraclize
191 		EOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();
192 	}
193 
194 	///////////////////////////////////////////////
195 	// BANKROLL CONTRACT MAIN FUNCTIONS
196 	///////////////////////////////////////////////
197 
198 
199 	// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional
200 	// amount of tokens so they may withdraw their tokens later
201 	// also if there is only a limited amount of space left in the bankroll, a user can just send as much 
202 	// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.
203 	function () public payable {
204 
205 		// save in memory for cheap access.
206 		// this represents the total bankroll balance before the function was called.
207 		uint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);
208 		uint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;
209 
210 		require(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);
211 
212 		uint256 currentSupplyOfTokens = totalSupply;
213 		uint256 contributedEther;
214 
215 		bool contributionTakesBankrollOverLimit;
216 		uint256 ifContributionTakesBankrollOverLimit_Refund;
217 
218 		uint256 creditedTokens;
219 
220 		if (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){
221 			// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.
222 			contributionTakesBankrollOverLimit = true;
223 			// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)
224 			contributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);
225 			// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))
226 			ifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);
227 		}
228 		else {
229 			contributedEther = msg.value;
230 		}
231         
232 		if (currentSupplyOfTokens != 0){
233 			// determine the ratio of contribution versus total BANKROLL.
234 			creditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;
235 		}
236 		else {
237 			// edge case where ALL money was cashed out from bankroll
238 			// so currentSupplyOfTokens == 0
239 			// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct's to the contract
240 			// but either way, give all the bankroll to person who deposits ether
241 			creditedTokens = SafeMath.mul(contributedEther, 100);
242 		}
243 		
244 		// now update the total supply of tokens and bankroll amount
245 		totalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);
246 
247 		// now credit the user with his amount of contributed tokens 
248 		balances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);
249 
250 		// update his contribution time for stake time locking
251 		contributionTime[msg.sender] = block.timestamp;
252 
253 		// now look if the attempted contribution would have taken the BANKROLL over the limit, 
254 		// and if true, refund the excess ether.
255 		if (contributionTakesBankrollOverLimit){
256 			msg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);
257 		}
258 
259 		// log an event about funding bankroll
260 		emit FundBankroll(msg.sender, contributedEther, creditedTokens);
261 
262 		// log a mint tokens event
263 		emit Transfer(0x0, msg.sender, creditedTokens);
264 	}
265 
266 	function cashoutEOSBetStakeTokens(uint256 _amountTokens) public {
267 		// In effect, this function is the OPPOSITE of the un-named payable function above^^^
268 		// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS
269 		// a proportion of any ether that was earned by the smart contact when their ether was "staking", However
270 		// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.
271 		// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough
272 		// is effectively guaranteed to withdraw more ether than they originally "staked"
273 
274 		// save in memory for cheap access.
275 		uint256 tokenBalance = balances[msg.sender];
276 		// verify that the contributor has enough tokens to cash out this many, and has waited the required time.
277 		require(_amountTokens <= tokenBalance 
278 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
279 			&& _amountTokens > 0);
280 
281 		// save in memory for cheap access.
282 		// again, represents the total balance of the contract before the function was called.
283 		uint256 currentTotalBankroll = getBankroll();
284 		uint256 currentSupplyOfTokens = totalSupply;
285 
286 		// calculate the token withdraw ratio based on current supply 
287 		uint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;
288 
289 		// developers take 1% of withdrawls 
290 		uint256 developersCut = withdrawEther / 100;
291 		uint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);
292 
293 		// now update the total supply of tokens by subtracting the tokens that are being "cashed in"
294 		totalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);
295 
296 		// and update the users supply of tokens 
297 		balances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);
298 
299 		// update the developers fund based on this calculated amount 
300 		DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
301 
302 		// lastly, transfer the ether back to the bankroller. Thanks for your contribution!
303 		msg.sender.transfer(contributorAmount);
304 
305 		// log an event about cashout
306 		emit CashOut(msg.sender, contributorAmount, _amountTokens);
307 
308 		// log a destroy tokens event
309 		emit Transfer(msg.sender, 0x0, _amountTokens);
310 	}
311 
312 	// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b
313 	function cashoutEOSBetStakeTokens_ALL() public {
314 
315 		// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance
316 		cashoutEOSBetStakeTokens(balances[msg.sender]);
317 	}
318 
319 	////////////////////
320 	// OWNER FUNCTIONS:
321 	////////////////////
322 	// Please, be aware that the owner ONLY can change:
323 		// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.
324 		// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^
325 		// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee
326 		// 		a certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the 
327 		//		maximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting
328 		// 		in higher dividends for the bankrollers
329 		// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all
330 		//		new bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the 
331 		// 		"refund" function in the respective game smart contract once payouts are un-frozen.
332 		// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,
333 		// 		and TRUE DAO governance so that onlyOwner functions don't have to exist anymore ;) and in order to effectively react to changes 
334 		// 		in the market (lower the percentage because of increased competition in the blockchain casino space, etc.)
335 
336 	function transferOwnership(address newOwner) public {
337 		require(msg.sender == OWNER);
338 
339 		OWNER = newOwner;
340 	}
341 
342 	function changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {
343 		// waitTime MUST be less than or equal to 10 weeks
344 		require (msg.sender == OWNER && waitTime <= 6048000);
345 
346 		WAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;
347 	}
348 
349 	function changeMaximumInvestmentsAllowed(uint256 maxAmount) public {
350 		require(msg.sender == OWNER);
351 
352 		MAXIMUMINVESTMENTSALLOWED = maxAmount;
353 	}
354 
355 
356 	function withdrawDevelopersFund(address receiver) public {
357 		require(msg.sender == OWNER);
358 
359 		// first get developers fund from each game 
360         EOSBetGameInterface(DICE).payDevelopersFund(receiver);
361 		EOSBetGameInterface(SLOTS).payDevelopersFund(receiver);
362 
363 		// now send the developers fund from the main contract.
364 		uint256 developersFund = DEVELOPERSFUND;
365 
366 		// set developers fund to zero
367 		DEVELOPERSFUND = 0;
368 
369 		// transfer this amount to the owner!
370 		receiver.transfer(developersFund);
371 	}
372 
373 	// rescue tokens inadvertently sent to the contract address 
374 	function ERC20Rescue(address tokenAddress, uint256 amtTokens) public {
375 		require (msg.sender == OWNER);
376 
377 		ERC20(tokenAddress).transfer(msg.sender, amtTokens);
378 	}
379 
380 	///////////////////////////////
381 	// BASIC ERC20 TOKEN OPERATIONS
382 	///////////////////////////////
383 
384 	function totalSupply() constant public returns(uint){
385 		return totalSupply;
386 	}
387 
388 	function balanceOf(address _owner) constant public returns(uint){
389 		return balances[_owner];
390 	}
391 
392 	// don't allow transfers before the required wait-time
393 	// and don't allow transfers to this contract addr, it'll just kill tokens
394 	function transfer(address _to, uint256 _value) public returns (bool success){
395 		require(balances[msg.sender] >= _value 
396 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
397 			&& _to != address(this)
398 			&& _to != address(0));
399 
400 		// safely subtract
401 		balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
402 		balances[_to] = SafeMath.add(balances[_to], _value);
403 
404 		// log event 
405 		emit Transfer(msg.sender, _to, _value);
406 		return true;
407 	}
408 
409 	// don't allow transfers before the required wait-time
410 	// and don't allow transfers to the contract addr, it'll just kill tokens
411 	function transferFrom(address _from, address _to, uint _value) public returns(bool){
412 		require(allowed[_from][msg.sender] >= _value 
413 			&& balances[_from] >= _value 
414 			&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
415 			&& _to != address(this)
416 			&& _to != address(0));
417 
418 		// safely add to _to and subtract from _from, and subtract from allowed balances.
419 		balances[_to] = SafeMath.add(balances[_to], _value);
420    		balances[_from] = SafeMath.sub(balances[_from], _value);
421   		allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
422 
423   		// log event
424 		emit Transfer(_from, _to, _value);
425 		return true;
426    		
427 	}
428 	
429 	function approve(address _spender, uint _value) public returns(bool){
430 
431 		allowed[msg.sender][_spender] = _value;
432 		emit Approval(msg.sender, _spender, _value);
433 		// log event
434 		return true;
435 	}
436 	
437 	function allowance(address _owner, address _spender) constant public returns(uint){
438 		return allowed[_owner][_spender];
439 	}
440 }