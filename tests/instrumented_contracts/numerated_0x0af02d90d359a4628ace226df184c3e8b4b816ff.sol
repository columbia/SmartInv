1 // WELCOME TO THE EOSBET.IO BUG BOUNTY CONTRACTS!
2 // GOOD LUCK... YOU'LL NEED IT!
3 
4 pragma solidity ^0.4.21;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract EOSBetGameInterface {
53 	uint256 public DEVELOPERSFUND;
54 	uint256 public LIABILITIES;
55 	function payDevelopersFund(address developer) public;
56 	function receivePaymentForOraclize() payable public;
57 	function getMaxWin() public view returns(uint256);
58 }
59 
60 contract EOSBetBankrollInterface {
61 	function payEtherToWinner(uint256 amtEther, address winner) public;
62 	function receiveEtherFromGameAddress() payable public;
63 	function payOraclize(uint256 amountToPay) public;
64 	function getBankroll() public view returns(uint256);
65 }
66 
67 contract ERC20 {
68 	function totalSupply() constant public returns (uint supply);
69 	function balanceOf(address _owner) constant public returns (uint balance);
70 	function transfer(address _to, uint _value) public returns (bool success);
71 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
72 	function approve(address _spender, uint _value) public returns (bool success);
73 	function allowance(address _owner, address _spender) constant public returns (uint remaining);
74 	event Transfer(address indexed _from, address indexed _to, uint _value);
75 	event Approval(address indexed _owner, address indexed _spender, uint _value);
76 }
77 
78 contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {
79 
80 	using SafeMath for *;
81 
82 	// constants for EOSBet Bankroll
83 
84 	address public OWNER;
85 	uint256 public MAXIMUMINVESTMENTSALLOWED;
86 	uint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;
87 	uint256 public DEVELOPERSFUND;
88 
89 	// this will be initialized as the trusted game addresses which will forward their ether
90 	// to the bankroll contract, and when players win, they will request the bankroll contract 
91 	// to send these players their winnings.
92 	// Feel free to audit these contracts on etherscan...
93 	mapping(address => bool) public TRUSTEDADDRESSES;
94 
95 	address public DICE;
96 	address public SLOTS;
97 
98 	// mapping to log the last time a user contributed to the bankroll 
99 	mapping(address => uint256) contributionTime;
100 
101 	// constants for ERC20 standard
102 	string public constant name = "EOSBet Stake Tokens";
103 	string public constant symbol = "EOSBETST";
104 	uint8 public constant decimals = 18;
105 	// variable total supply
106 	uint256 public totalSupply;
107 
108 	// mapping to store tokens
109 	mapping(address => uint256) public balances;
110 	mapping(address => mapping(address => uint256)) public allowed;
111 
112 	// events
113 	event FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);
114 	event CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);
115 	event FailedSend(address sendTo, uint256 amt);
116 
117 	// checks that an address is a "trusted address of a legitimate EOSBet game"
118 	modifier addressInTrustedAddresses(address thisAddress){
119 
120 		require(TRUSTEDADDRESSES[thisAddress]);
121 		_;
122 	}
123 
124 	// initialization function 
125 	function EOSBetBankroll(address dice, address slots) public payable {
126 		// function is payable, owner of contract MUST "seed" contract with some ether, 
127 		// so that the ratios are correct when tokens are being minted
128 		require (msg.value > 0);
129 
130 		OWNER = msg.sender;
131 
132 		// 100 tokens/ether is the inital seed amount, so:
133 		uint256 initialTokens = msg.value * 100;
134 		balances[msg.sender] = initialTokens;
135 		totalSupply = initialTokens;
136 
137 		// log a mint tokens event
138 		emit Transfer(0x0, msg.sender, initialTokens);
139 
140 		// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables
141 		TRUSTEDADDRESSES[dice] = true;
142 		TRUSTEDADDRESSES[slots] = true;
143 
144 		DICE = dice;
145 		SLOTS = slots;
146 
147 		////////////////////////////////////////////////
148 		// CHANGE TO 6 HOURS ON LIVE DEPLOYMENT
149 		////////////////////////////////////////////////
150 		WAITTIMEUNTILWITHDRAWORTRANSFER = 0 seconds;
151 		MAXIMUMINVESTMENTSALLOWED = 500 ether;
152 	}
153 
154 	///////////////////////////////////////////////
155 	// VIEW FUNCTIONS
156 	/////////////////////////////////////////////// 
157 
158 	function checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){
159 		return contributionTime[bankrollerAddress];
160 	}
161 
162 	function getBankroll() view public returns(uint256){
163 		// returns the total balance minus the developers fund, as the amount of active bankroll
164 		return SafeMath.sub(address(this).balance, DEVELOPERSFUND);
165 	}
166 
167 	///////////////////////////////////////////////
168 	// BANKROLL CONTRACT <-> GAME CONTRACTS functions
169 	/////////////////////////////////////////////// 
170 
171 	function payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){
172 		// this function will get called by a game contract when someone wins a game
173 		// try to send, if it fails, then send the amount to the owner
174 		// note, this will only happen if someone is calling the betting functions with
175 		// a contract. They are clearly up to no good, so they can contact us to retreive 
176 		// their ether
177 		// if the ether cannot be sent to us, the OWNER, that means we are up to no good, 
178 		// and the ether will just be given to the bankrollers as if the player/owner lost 
179 
180 		if (! winner.send(amtEther)){
181 
182 			emit FailedSend(winner, amtEther);
183 
184 			if (! OWNER.send(amtEther)){
185 
186 				emit FailedSend(OWNER, amtEther);
187 			}
188 		}
189 	}
190 
191 	function receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){
192 		// this function will get called from the game contracts when someone starts a game.
193 	}
194 
195 	function payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){
196 		// this function will get called when a game contract must pay payOraclize
197 		EOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();
198 	}
199 
200 	///////////////////////////////////////////////
201 	// BANKROLL CONTRACT MAIN FUNCTIONS
202 	///////////////////////////////////////////////
203 
204 
205 	// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional
206 	// amount of tokens so they may withdraw their tokens later
207 	// also if there is only a limited amount of space left in the bankroll, a user can just send as much 
208 	// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.
209 	function () public payable {
210 
211 		// save in memory for cheap access.
212 		// this represents the total bankroll balance before the function was called.
213 		uint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);
214 		uint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;
215 
216 		require(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);
217 
218 		uint256 currentSupplyOfTokens = totalSupply;
219 		uint256 contributedEther;
220 
221 		bool contributionTakesBankrollOverLimit;
222 		uint256 ifContributionTakesBankrollOverLimit_Refund;
223 
224 		uint256 creditedTokens;
225 
226 		if (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){
227 			// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.
228 			contributionTakesBankrollOverLimit = true;
229 			// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)
230 			contributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);
231 			// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))
232 			ifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);
233 		}
234 		else {
235 			contributedEther = msg.value;
236 		}
237         
238 		if (currentSupplyOfTokens != 0){
239 			// determine the ratio of contribution versus total BANKROLL.
240 			creditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;
241 		}
242 		else {
243 			// edge case where ALL money was cashed out from bankroll
244 			// so currentSupplyOfTokens == 0
245 			// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct's to the contract
246 			// but either way, give all the bankroll to person who deposits ether
247 			creditedTokens = SafeMath.mul(contributedEther, 100);
248 		}
249 		
250 		// now update the total supply of tokens and bankroll amount
251 		totalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);
252 
253 		// now credit the user with his amount of contributed tokens 
254 		balances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);
255 
256 		// update his contribution time for stake time locking
257 		contributionTime[msg.sender] = block.timestamp;
258 
259 		// now look if the attempted contribution would have taken the BANKROLL over the limit, 
260 		// and if true, refund the excess ether.
261 		if (contributionTakesBankrollOverLimit){
262 			msg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);
263 		}
264 
265 		// log an event about funding bankroll
266 		emit FundBankroll(msg.sender, contributedEther, creditedTokens);
267 
268 		// log a mint tokens event
269 		emit Transfer(0x0, msg.sender, creditedTokens);
270 	}
271 
272 	function cashoutEOSBetStakeTokens(uint256 _amountTokens) public {
273 		// In effect, this function is the OPPOSITE of the un-named payable function above^^^
274 		// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS
275 		// a proportion of any ether that was earned by the smart contact when their ether was "staking", However
276 		// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.
277 		// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough
278 		// is effectively guaranteed to withdraw more ether than they originally "staked"
279 
280 		// save in memory for cheap access.
281 		uint256 tokenBalance = balances[msg.sender];
282 		// verify that the contributor has enough tokens to cash out this many, and has waited the required time.
283 		require(_amountTokens <= tokenBalance 
284 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
285 			&& _amountTokens > 0);
286 
287 		// save in memory for cheap access.
288 		// again, represents the total balance of the contract before the function was called.
289 		uint256 currentTotalBankroll = getBankroll();
290 		uint256 currentSupplyOfTokens = totalSupply;
291 
292 		// calculate the token withdraw ratio based on current supply 
293 		uint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;
294 
295 		// developers take 1% of withdrawls 
296 		uint256 developersCut = withdrawEther / 100;
297 		uint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);
298 
299 		// now update the total supply of tokens by subtracting the tokens that are being "cashed in"
300 		totalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);
301 
302 		// and update the users supply of tokens 
303 		balances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);
304 
305 		// update the developers fund based on this calculated amount 
306 		DEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);
307 
308 		// lastly, transfer the ether back to the bankroller. Thanks for your contribution!
309 		msg.sender.transfer(contributorAmount);
310 
311 		// log an event about cashout
312 		emit CashOut(msg.sender, contributorAmount, _amountTokens);
313 
314 		// log a destroy tokens event
315 		emit Transfer(msg.sender, 0x0, _amountTokens);
316 	}
317 
318 	// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b
319 	function cashoutEOSBetStakeTokens_ALL() public {
320 
321 		// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance
322 		cashoutEOSBetStakeTokens(balances[msg.sender]);
323 	}
324 
325 	////////////////////
326 	// OWNER FUNCTIONS:
327 	////////////////////
328 	// Please, be aware that the owner ONLY can change:
329 		// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.
330 		// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^
331 		// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee
332 		// 		a certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the 
333 		//		maximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting
334 		// 		in higher dividends for the bankrollers
335 		// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all
336 		//		new bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the 
337 		// 		"refund" function in the respective game smart contract once payouts are un-frozen.
338 		// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,
339 		// 		and TRUE DAO governance so that onlyOwner functions don't have to exist anymore ;) and in order to effectively react to changes 
340 		// 		in the market (lower the percentage because of increased competition in the blockchain casino space, etc.)
341 
342 	function transferOwnership(address newOwner) public {
343 		require(msg.sender == OWNER);
344 
345 		OWNER = newOwner;
346 	}
347 
348 	function changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {
349 		// waitTime MUST be less than or equal to 10 weeks
350 		require (msg.sender == OWNER && waitTime <= 6048000);
351 
352 		WAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;
353 	}
354 
355 	function changeMaximumInvestmentsAllowed(uint256 maxAmount) public {
356 		require(msg.sender == OWNER);
357 
358 		MAXIMUMINVESTMENTSALLOWED = maxAmount;
359 	}
360 
361 
362 	function withdrawDevelopersFund(address receiver) public {
363 		require(msg.sender == OWNER);
364 
365 		// first get developers fund from each game 
366         EOSBetGameInterface(DICE).payDevelopersFund(receiver);
367 		EOSBetGameInterface(SLOTS).payDevelopersFund(receiver);
368 
369 		// now send the developers fund from the main contract.
370 		uint256 developersFund = DEVELOPERSFUND;
371 
372 		// set developers fund to zero
373 		DEVELOPERSFUND = 0;
374 
375 		// transfer this amount to the owner!
376 		receiver.transfer(developersFund);
377 	}
378 
379 	// Can be removed after some testing...
380 	function emergencySelfDestruct() public {
381 		require(msg.sender == OWNER);
382 
383 		selfdestruct(msg.sender);
384 	}
385 
386 	///////////////////////////////
387 	// BASIC ERC20 TOKEN OPERATIONS
388 	///////////////////////////////
389 
390 	function totalSupply() constant public returns(uint){
391 		return totalSupply;
392 	}
393 
394 	function balanceOf(address _owner) constant public returns(uint){
395 		return balances[_owner];
396 	}
397 
398 	// don't allow transfers before the required wait-time
399 	// and don't allow transfers to this contract addr, it'll just kill tokens
400 	function transfer(address _to, uint256 _value) public returns (bool success){
401 		if (balances[msg.sender] >= _value 
402 			&& _value > 0 
403 			&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
404 			&& _to != address(this)){
405 
406 			// safely subtract
407 			balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
408 			balances[_to] = SafeMath.add(balances[_to], _value);
409 
410 			// log event 
411 			emit Transfer(msg.sender, _to, _value);
412 			return true;
413 		}
414 		else {
415 			return false;
416 		}
417 	}
418 
419 	// don't allow transfers before the required wait-time
420 	// and don't allow transfers to the contract addr, it'll just kill tokens
421 	function transferFrom(address _from, address _to, uint _value) public returns(bool){
422 		if (allowed[_from][msg.sender] >= _value 
423 			&& balances[_from] >= _value 
424 			&& _value > 0 
425 			&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp
426 			&& _to != address(this)){
427 
428 			// safely add to _to and subtract from _from, and subtract from allowed balances.
429 			balances[_to] = SafeMath.add(balances[_to], _value);
430 	   		balances[_from] = SafeMath.sub(balances[_from], _value);
431 	  		allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
432 
433 	  		// log event
434     		emit Transfer(_from, _to, _value);
435     		return true;
436    		} 
437     	else { 
438     		return false;
439     	}
440 	}
441 	
442 	function approve(address _spender, uint _value) public returns(bool){
443 		if(_value > 0){
444 
445 			allowed[msg.sender][_spender] = _value;
446 			emit Approval(msg.sender, _spender, _value);
447 			// log event
448 			return true;
449 		}
450 		else {
451 			return false;
452 		}
453 	}
454 	
455 	function allowance(address _owner, address _spender) constant public returns(uint){
456 		return allowed[_owner][_spender];
457 	}
458 }