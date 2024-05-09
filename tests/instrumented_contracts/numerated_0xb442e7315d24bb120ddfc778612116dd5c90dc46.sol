1 /**
2  * The edgeless casino contract holds the players's funds and provides state channel functionality.
3  * The casino has at no time control over the players's funds.
4  * State channels can be updated and closed from both parties: the player and the casino.
5  * author: Julia Altenried
6  **/
7 
8 pragma solidity ^0.4.17;
9 
10 contract SafeMath {
11 
12 	function safeSub(uint a, uint b) pure internal returns(uint) {
13 		assert(b <= a);
14 		return a - b;
15 	}
16 	
17 	function safeSub(int a, int b) pure internal returns(int) {
18 		if(b < 0) assert(a - b > a);
19 		else assert(a - b <= a);
20 		return a - b;
21 	}
22 
23 	function safeAdd(uint a, uint b) pure internal returns(uint) {
24 		uint c = a + b;
25 		assert(c >= a && c >= b);
26 		return c;
27 	}
28 
29 	function safeMul(uint a, uint b) pure internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 }
35 
36 contract owned {
37   address public owner;
38   modifier onlyOwner {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function owned() public{
44     owner = msg.sender;
45   }
46 
47   function changeOwner(address newOwner) onlyOwner public{
48     owner = newOwner;
49   }
50 }
51 
52 /** owner should be able to close the contract is nobody has been using it for at least 30 days */
53 contract mortal is owned {
54 	/** contract can be closed by the owner anytime after this timestamp if non-zero */
55 	uint public closeAt;
56 	/**
57 	* lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
58 	*/
59   function closeContract(uint playerBalance) internal{
60 		if(playerBalance == 0) selfdestruct(owner);
61 		if(closeAt == 0) closeAt = now + 30 days;
62 		else if(closeAt < now) selfdestruct(owner);
63   }
64 
65 	/**
66 	* in case close has been called accidentally.
67 	**/
68 	function open() onlyOwner public{
69 		closeAt = 0;
70 	}
71 
72 	/**
73 	* make sure the contract is not in process of being closed.
74 	**/
75 	modifier isAlive {
76 		require(closeAt == 0);
77 		_;
78 	}
79 
80 	/**
81 	* delays the time of closing.
82 	**/
83 	modifier keepAlive {
84 		if(closeAt > 0) closeAt = now + 30 days;
85 		_;
86 	}
87 }
88 
89 
90 contract chargingGas is mortal, SafeMath{
91   /** the price per kgas and GWei in tokens (5 decimals) */
92 	uint public gasPrice;
93 	/** the amount of gas used per transaction in kGas */
94 	mapping(bytes4 => uint) public gasPerTx;
95 	
96 	/**
97 	 * sets the amount of gas consumed by methods with the given sigantures.
98 	 * only called from the edgeless casino constructor.
99 	 * @param signatures an array of method-signatures
100 	 *        gasNeeded  the amount of gas consumed by these methods
101 	 * */
102 	function setGasUsage(bytes4[3] signatures, uint[3] gasNeeded) internal{
103 	  require(signatures.length == gasNeeded.length);
104 	  for(uint8 i = 0; i < signatures.length; i++)
105 	    gasPerTx[signatures[i]] = gasNeeded[i];
106 	}
107 	
108 	/**
109 	 * adds the gas cost of the tx to the given value.
110 	 * @param value the value to add the gas cost to
111 	 * */
112 	function addGas(uint value) internal constant returns(uint){
113   	return safeAdd(value,getGasCost());
114 	}
115 	
116 	/**
117 	 * subtracts the gas cost of the tx from the given value.
118 	 * @param value the value to subtract the gas cost from
119 	 * */
120 	function subtractGas(uint value) internal constant returns(uint){
121   	return safeSub(value,getGasCost());
122 	}
123 	
124 	
125 	/**
126 	* updates the price per 1000 gas in EDG.
127 	* @param price the new gas price (4 decimals, max 0.0256 EDG)
128 	**/
129 	function setGasPrice(uint8 price) public onlyOwner{
130 		gasPrice = price;
131 	}
132 	
133 	/**
134 	 * returns the gas cost of the called function.
135 	 * */
136 	function getGasCost() internal constant returns(uint){
137 	  return safeMul(safeMul(gasPerTx[msg.sig], gasPrice), tx.gasprice)/1000000000;
138 	}
139 
140 }
141 
142 contract Token {
143 	function transferFrom(address sender, address receiver, uint amount) public returns(bool success) {}
144 
145 	function transfer(address receiver, uint amount) public returns(bool success) {}
146 
147 	function balanceOf(address holder) public constant returns(uint) {}
148 }
149 
150 contract CasinoBank is chargingGas{
151 	/** the total balance of all players with 5 virtual decimals **/
152 	uint public playerBalance;
153 	/** the balance per player in edgeless tokens with 5 virtual decimals */
154 	mapping(address=>uint) public balanceOf;
155 	/** in case the user wants/needs to call the withdraw function from his own wallet, he first needs to request a withdrawal */
156 	mapping(address=>uint) public withdrawAfter;
157 	/** the edgeless token contract */
158 	Token edg;
159 	/** the maximum amount of tokens the user is allowed to deposit (5 decimals) */
160 	uint public maxDeposit;
161 	/** waiting time for withdrawal if not requested via the server **/
162 	uint public waitingTime;
163 	
164 	/** informs listeners how many tokens were deposited for a player */
165 	event Deposit(address _player, uint _numTokens, bool _chargeGas);
166 	/** informs listeners how many tokens were withdrawn from the player to the receiver address */
167 	event Withdrawal(address _player, address _receiver, uint _numTokens);
168 
169 	function CasinoBank(address tokenContract, uint depositLimit) public{
170 		edg = Token(tokenContract);
171 		maxDeposit = depositLimit;
172 		waitingTime = 90 minutes;
173 	}
174 
175 	/**
176 	* accepts deposits for an arbitrary address.
177 	* retrieves tokens from the message sender and adds them to the balance of the specified address.
178 	* edgeless tokens do not have any decimals, but are represented on this contract with 5 decimals.
179 	* @param receiver  address of the receiver
180 	*        numTokens number of tokens to deposit (0 decimals)
181 	*				 chargeGas indicates if the gas cost is subtracted from the user's edgeless token balance
182 	**/
183 	function deposit(address receiver, uint numTokens, bool chargeGas) public isAlive{
184 		require(numTokens > 0);
185 		uint value = safeMul(numTokens,100000);
186 		if(chargeGas) value = subtractGas(value);
187 		uint newBalance = safeAdd(balanceOf[receiver], value);
188 		require(newBalance <= maxDeposit);
189 		assert(edg.transferFrom(msg.sender, address(this), numTokens));
190 		balanceOf[receiver] = newBalance;
191 		playerBalance = safeAdd(playerBalance, value);
192 		Deposit(receiver, numTokens, chargeGas);
193   }
194 
195 	/**
196 	* If the user wants/needs to withdraw his funds himself, he needs to request the withdrawal first.
197 	* This method sets the earliest possible withdrawal date to 'waitingTime from now (default 90m, but up to 24h).
198 	* Reason: The user should not be able to withdraw his funds, while the the last game methods have not yet been mined.
199 	**/
200 	function requestWithdrawal() public{
201 		withdrawAfter[msg.sender] = now + waitingTime;
202 	}
203 
204 	/**
205 	* In case the user requested a withdrawal and changes his mind.
206 	* Necessary to be able to continue playing.
207 	**/
208 	function cancelWithdrawalRequest() public{
209 		withdrawAfter[msg.sender] = 0;
210 	}
211 
212 	/**
213 	* withdraws an amount from the user balance if the waiting time passed since the request.
214 	* @param amount the amount of tokens to withdraw
215 	**/
216 	function withdraw(uint amount) public keepAlive{
217 		require(withdrawAfter[msg.sender]>0 && now>withdrawAfter[msg.sender]);
218 		withdrawAfter[msg.sender] = 0;
219 		uint value = safeMul(amount,100000);
220 		balanceOf[msg.sender]=safeSub(balanceOf[msg.sender],value);
221 		playerBalance = safeSub(playerBalance, value);
222 		assert(edg.transfer(msg.sender, amount));
223 		Withdrawal(msg.sender, msg.sender, amount);
224 	}
225 
226 	/**
227 	* lets the owner withdraw from the bankroll
228 	* @param numTokens the number of tokens to withdraw (0 decimals)
229 	**/
230 	function withdrawBankroll(uint numTokens) public onlyOwner {
231 		require(numTokens <= bankroll());
232 		assert(edg.transfer(owner, numTokens));
233 	}
234 
235 	/**
236 	* returns the current bankroll in tokens with 0 decimals
237 	**/
238 	function bankroll() constant public returns(uint){
239 		return safeSub(edg.balanceOf(address(this)), playerBalance/100000);
240 	}
241 	
242 	
243 	/**
244 	* updates the maximum deposit.
245 	* @param newMax the new maximum deposit (5 decimals)
246 	**/
247 	function setMaxDeposit(uint newMax) public onlyOwner{
248 		maxDeposit = newMax;
249 	}
250 	
251 	/**
252 	 * sets the time the player has to wait for his funds to be unlocked before withdrawal (if not withdrawing with help of the casino server).
253 	 * the time may not be longer than 24 hours.
254 	 * @param newWaitingTime the new waiting time in seconds
255 	 * */
256 	function setWaitingTime(uint newWaitingTime) public onlyOwner{
257 		require(newWaitingTime <= 24 hours);
258 		waitingTime = newWaitingTime;
259 	}
260 
261 	/**
262 	 * lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days
263 	 * */
264 	function close() public onlyOwner{
265 		closeContract(playerBalance);
266 	}
267 }
268 
269 contract EdgelessCasino is CasinoBank{
270 	/** indicates if an address is authorized to act in the casino's name  */
271     mapping(address => bool) public authorized;
272 	/** a number to count withdrawal signatures to ensure each signature is different even if withdrawing the same amount to the same address */
273 	mapping(address => uint) public withdrawCount;
274 	/** the most recent known state of a state channel */
275 	mapping(address => State) public lastState;
276     /** fired when the state is updated */
277     event StateUpdate(uint128 count, int128 winBalance, int difference, uint gasCost, address player, uint128 lcount);
278     /** fired if one of the parties chooses to log the seeds and results */
279     event GameData(address player, bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results);
280   
281 	struct State{
282 		uint128 count;
283 		int128 winBalance;
284 	}
285 
286     modifier onlyAuthorized {
287         require(authorized[msg.sender]);
288         _;
289     }
290 
291 
292   /**
293   * creates a new edgeless casino contract.
294   * @param authorizedAddress the address which may send transactions to the Edgeless Casino
295   *				 tokenContract     the address of the Edgeless token contract
296   * 			 depositLimit      the maximum deposit allowed
297   * 			 kGasPrice				 the price per kGas in WEI
298   **/
299   function EdgelessCasino(address authorizedAddress, address tokenContract, uint depositLimit, uint8 kGasPrice) CasinoBank(tokenContract, depositLimit) public{
300     authorized[authorizedAddress] = true;
301     //deposit, withdrawFor, updateChannel
302     bytes4[3] memory signatures = [bytes4(0x3edd1128),0x9607610a, 0x713d30c6];
303     //amount of gas consumed by the above methods in GWei
304     uint[3] memory gasUsage = [uint(85),95,60];
305     setGasUsage(signatures, gasUsage);
306     setGasPrice(kGasPrice);
307   }
308 
309 
310   /**
311   * transfers an amount from the contract balance to the owner's wallet.
312   * @param receiver the receiver address
313 	*				 amount   the amount of tokens to withdraw (0 decimals)
314 	*				 v,r,s 		the signature of the player
315   **/
316   function withdrawFor(address receiver, uint amount, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized keepAlive{
317 	var player = ecrecover(keccak256(receiver, amount, withdrawCount[receiver]), v, r, s);
318 	withdrawCount[receiver]++;
319 	uint value = addGas(safeMul(amount,100000));
320     balanceOf[player] = safeSub(balanceOf[player], value);
321 	playerBalance = safeSub(playerBalance, value);
322     assert(edg.transfer(receiver, amount));
323 	Withdrawal(player, receiver, amount);
324   }
325 
326   /**
327   * authorize a address to call game functions.
328   * @param addr the address to be authorized
329   **/
330   function authorize(address addr) public onlyOwner{
331     authorized[addr] = true;
332   }
333 
334   /**
335   * deauthorize a address to call game functions.
336   * @param addr the address to be deauthorized
337   **/
338   function deauthorize(address addr) public onlyOwner{
339     authorized[addr] = false;
340   }
341 
342   /**
343    * closes a state channel. can also be used for intermediate state updates. can be called by both parties.
344    * 1. verifies the signature.
345    * 2. verifies if the signed game-count is higher than the last known game-count of this channel.
346    * 3. updates the balances accordingly. This means: It checks the already performed updates for this channel and computes
347    *    the new balance difference to add or subtract from the player‘s balance.
348    * @param winBalance the current win or loss
349    *				gameCount  the number of signed game moves
350    *				v,r,s      the signature of either the casino or the player
351    * */
352   function updateState(int128 winBalance,  uint128 gameCount, uint8 v, bytes32 r, bytes32 s) public{
353   	address player = determinePlayer(winBalance, gameCount, v, r, s);
354   	uint gasCost = 0;
355   	if(player == msg.sender)//if the player closes the state channel himself, make sure the signer is a casino wallet
356   		require(authorized[ecrecover(keccak256(player, winBalance, gameCount), v, r, s)]);
357   	else//if the casino wallet is the sender, subtract the gas costs from the player balance
358   		gasCost = getGasCost();
359   	State storage last = lastState[player];
360   	require(gameCount > last.count);
361   	int difference = updatePlayerBalance(player, winBalance, last.winBalance, gasCost);
362   	lastState[player] = State(gameCount, winBalance);
363   	StateUpdate(gameCount, winBalance, difference, gasCost, player, last.count);
364   }
365 
366   /**
367    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
368    * @param winBalance the current winBalance, used to calculate the msg hash
369    *				gameCount  the current gameCount, used to calculate the msg.hash
370    *				v, r, s    the signature of the non-sending party
371    * */
372   function determinePlayer(int128 winBalance, uint128 gameCount, uint8 v, bytes32 r, bytes32 s) constant internal returns(address){
373   	if (authorized[msg.sender])//casino is the sender -> player is the signer
374   		return ecrecover(keccak256(winBalance, gameCount), v, r, s);
375   	else
376   		return msg.sender;
377   }
378 
379 	/**
380 	 * computes the difference of the win balance relative to the last known state and adds it to the player's balance.
381 	 * in case the casino is the sender, the gas cost in EDG gets subtracted from the player's balance.
382 	 * @param player the address of the player
383 	 *				winBalance the current win-balance
384 	 *				lastWinBalance the win-balance of the last known state
385 	 *				gasCost the gas cost of the tx
386 	 * */
387   function updatePlayerBalance(address player, int128 winBalance, int128 lastWinBalance, uint gasCost) internal returns(int difference){
388   	difference = safeSub(winBalance, lastWinBalance);
389   	int outstanding = safeSub(difference, int(gasCost));
390   	uint outs;
391   	if(outstanding < 0){
392   		outs = uint256(outstanding * (-1));
393   		playerBalance = safeSub(playerBalance, outs);
394   		balanceOf[player] = safeSub(balanceOf[player], outs);
395   	}
396   	else{
397   		outs = uint256(outstanding);
398   	  playerBalance = safeAdd(playerBalance, outs);
399   	  balanceOf[player] = safeAdd(balanceOf[player], outs);
400   	}
401   }
402   
403   /**
404    * logs some seeds and game results for players wishing to have their game history logged by the contract
405    * @param serverSeeds array containing the server seeds
406    *        clientSeeds array containing the client seeds
407    *        results     array containing the results
408    *        v, r, s     the signature of the non-sending party (to make sure the corrcet results are logged)
409    * */
410   function logGameData(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) public{
411     address player = determinePlayer(serverSeeds, clientSeeds, results, v, r, s);
412     GameData(player, serverSeeds, clientSeeds, results);
413     //charge gas in case the server is logging the results for the player
414     if(player != msg.sender){
415       uint gasCost = (57 + 768 * serverSeeds.length / 1000)*gasPrice;
416       balanceOf[player] = safeSub(balanceOf[player], gasCost);
417       playerBalance = safeSub(playerBalance, gasCost);
418     }
419   }
420   
421   /**
422    * determines if the msg.sender or the signer of the passed signature is the player. returns the player's address
423    * @param serverSeeds array containing the server seeds
424    *        clientSeeds array containing the client seeds
425    *        results     array containing the results
426    *				v, r, s    the signature of the non-sending party
427    * */
428   function determinePlayer(bytes32[] serverSeeds, bytes32[] clientSeeds, int[] results, uint8 v, bytes32 r, bytes32 s) constant internal returns(address){
429   	if (authorized[msg.sender])//casino is the sender -> player is the signer
430   		return ecrecover(keccak256(serverSeeds, clientSeeds, results), v, r, s);
431   	else
432   		return msg.sender;
433   }
434 
435 }