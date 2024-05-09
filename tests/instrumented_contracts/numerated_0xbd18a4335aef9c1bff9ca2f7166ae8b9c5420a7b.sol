1 /**
2  * Edgeless Casino Proxy Contract. Serves as a proxy for game functionality.
3  * Allows the players to deposit and withdraw funds.
4  * Allows authorized addresses to make game transactions.
5  * author: Julia Altenried
6  **/
7 
8 pragma solidity ^0.4.17;
9 
10 
11 contract token {
12 	function transferFrom(address sender, address receiver, uint amount) public returns(bool success) {}
13 	
14 	function transfer(address receiver, uint amount) public returns(bool success) {}
15 	
16 	function balanceOf(address holder) public constant returns(uint) {}
17 }
18 
19 contract owned {
20   address public owner;
21   modifier onlyOwner {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   function owned() public{
27     owner = msg.sender;
28   }
29 
30   function changeOwner(address newOwner) onlyOwner public{
31     owner = newOwner;
32   }
33 }
34 
35 contract safeMath {
36 	//internals
37 	function safeSub(uint a, uint b) constant internal returns(uint) {
38 		assert(b <= a);
39 		return a - b;
40 	}
41 
42 	function safeAdd(uint a, uint b) constant internal returns(uint) {
43 		uint c = a + b;
44 		assert(c >= a && c >= b);
45 		return c;
46 	}
47 	
48 	function safeMul(uint a, uint b) constant internal returns (uint) {
49     uint c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 }
54 
55 contract casinoBank is owned, safeMath{
56 	/** the total balance of all players with 4 virtual decimals **/
57 	uint public playerBalance;
58 	/** the balance per player in edgeless tokens with 4 virtual decimals */
59   mapping(address=>uint) public balanceOf;
60 	/** in case the user wants/needs to call the withdraw function from his own wallet, he first needs to request a withdrawal */
61 	mapping(address=>uint) public withdrawAfter;
62 	/** the price per kgas in tokens (4 decimals) */
63 	uint public gasPrice = 4;
64 	/** the average amount of gas consumend per game **/
65 	mapping(address=>uint) public avgGas;
66 	/** the edgeless token contract */
67 	token edg;
68 	/** owner should be able to close the contract is nobody has been using it for at least 30 days */
69 	uint public closeAt;
70 	/** informs listeners how many tokens were deposited for a player */
71 	event Deposit(address _player, uint _numTokens, bool _chargeGas);
72 	/** informs listeners how many tokens were withdrawn from the player to the receiver address */
73 	event Withdrawal(address _player, address _receiver, uint _numTokens);
74 	
75 	function casinoBank(address tokenContract) public{
76 		edg = token(tokenContract);
77 	}
78 	
79 	/**
80 	* accepts deposits for an arbitrary address.
81 	* retrieves tokens from the message sender and adds them to the balance of the specified address.
82 	* edgeless tokens do not have any decimals, but are represented on this contract with 4 decimals.
83 	* @param receiver  address of the receiver
84 	*        numTokens number of tokens to deposit (0 decimals)
85 	*				 chargeGas indicates if the gas cost is subtracted from the user's edgeless token balance
86 	**/
87 	function deposit(address receiver, uint numTokens, bool chargeGas) public isAlive{
88 		require(numTokens > 0);
89 		uint value = safeMul(numTokens,10000); 
90 		if(chargeGas) value = safeSub(value, msg.gas/1000 * gasPrice);
91 		assert(edg.transferFrom(msg.sender, address(this), numTokens));
92 		balanceOf[receiver] = safeAdd(balanceOf[receiver], value);
93 		playerBalance = safeAdd(playerBalance, value);
94 		Deposit(receiver, numTokens, chargeGas);
95   }
96 	
97 	/**
98 	* If the user wants/needs to withdraw his funds himself, he needs to request the withdrawal first.
99 	* This method sets the earliest possible withdrawal date to 7 minutes from now. 
100 	* Reason: The user should not be able to withdraw his funds, while the the last game methods have not yet been mined.
101 	**/
102 	function requestWithdrawal() public{
103 		withdrawAfter[msg.sender] = now + 7 minutes;
104 	}
105 	
106 	/**
107 	* In case the user requested a withdrawal and changes his mind.
108 	* Necessary to be able to continue playing.
109 	**/
110 	function cancelWithdrawalRequest() public{
111 		withdrawAfter[msg.sender] = 0;
112 	}
113 	
114 	/**
115 	* withdraws an amount from the user balance if 7 minutes passed since the request.
116 	* @param amount the amount of tokens to withdraw
117 	**/
118 	function withdraw(uint amount) public keepAlive{
119 		require(withdrawAfter[msg.sender]>0 && now>withdrawAfter[msg.sender]);
120 		withdrawAfter[msg.sender] = 0;
121 		uint value = safeMul(amount,10000);
122 		balanceOf[msg.sender]=safeSub(balanceOf[msg.sender],value);
123 		playerBalance = safeSub(playerBalance, value);
124 		assert(edg.transfer(msg.sender, amount));
125 		Withdrawal(msg.sender, msg.sender, amount);
126 	}
127 	
128 	/**
129 	* lets the owner withdraw from the bankroll
130 	* @param numTokens the number of tokens to withdraw (0 decimals)
131 	**/
132 	function withdrawBankroll(uint numTokens) public onlyOwner {
133 		require(numTokens <= bankroll());
134 		assert(edg.transfer(owner, numTokens));
135 	}
136 	
137 	/**
138 	* returns the current bankroll in tokens with 0 decimals
139 	**/
140 	function bankroll() constant public returns(uint){
141 		return safeSub(edg.balanceOf(address(this)), playerBalance/10000);
142 	}
143 	
144 	/** 
145 	* lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days 
146 	*/
147   function close() onlyOwner public{
148 		if(playerBalance == 0) selfdestruct(owner);
149 		if(closeAt == 0) closeAt = now + 30 days;
150 		else if(closeAt < now) selfdestruct(owner);
151   }
152 	
153 	/**
154 	* in case close has been called accidentally.
155 	**/
156 	function open() onlyOwner public{
157 		closeAt = 0;
158 	}
159 	
160 	/**
161 	* make sure the contract is not in process of being closed.
162 	**/
163 	modifier isAlive {
164 		require(closeAt == 0);
165 		_;
166 	}
167 	
168 	/**
169 	* delays the time of closing.
170 	**/
171 	modifier keepAlive {
172 		if(closeAt > 0) closeAt = now + 30 days;
173 		_;
174 	}
175 }
176 
177 contract casinoProxy is casinoBank{
178 	/** indicates if an address is authorized to call game functions  */
179   mapping(address => bool) public authorized;
180   /** indicates if the user allowed a casino game address to move his/her funds **/
181   mapping(address => mapping(address => bool)) public authorizedByUser;
182   /** counts how often an address has been deauthorized by the user => make sure signatzures can't be reused**/
183   mapping(address => mapping(address => uint8)) public lockedByUser;
184 	/** list of casino game contract addresses */
185   address[] public casinoGames;
186 	/** a number to count withdrawal signatures to ensure each signature is different even if withdrawing the same amount to the same address */
187 	mapping(address => uint) public count;
188 
189 	modifier onlyAuthorized {
190     require(authorized[msg.sender]);
191     _;
192   }
193 	
194 	modifier onlyCasinoGames {
195 		bool isCasino;
196 		for (uint i = 0; i < casinoGames.length; i++){
197 			if(msg.sender == casinoGames[i]){
198 				isCasino = true;
199 				break;
200 			}
201 		}
202 		require(isCasino);
203 		_;
204 	}
205   
206   /**
207   * creates a new casino wallet.
208   * @param authorizedAddress the address which may send transactions to the Edgeless Casino
209   *        blackjackAddress  the address of the Edgeless blackjack contract
210 	*				 tokenContract     the address of the Edgeless token contract
211   **/
212   function casinoProxy(address authorizedAddress, address blackjackAddress, address tokenContract) casinoBank(tokenContract) public{
213     authorized[authorizedAddress] = true;
214     casinoGames.push(blackjackAddress);
215   }
216 
217 	/**
218 	* shifts tokens from the contract balance to the player or the other way round.
219 	* only callable from an edgeless casino contract. sender must have been approved by the user.
220 	* @param player the address of the player
221 	*        numTokens the amount of tokens to shift with 4 decimals
222 	*				 isReceiver tells if the player is receiving token or the other way round
223 	**/
224 	function shift(address player, uint numTokens, bool isReceiver) public onlyCasinoGames{
225 		require(authorizedByUser[player][msg.sender]);
226 		var gasCost = avgGas[msg.sender] * gasPrice;
227 		if(isReceiver){
228 			numTokens = safeSub(numTokens, gasCost);
229 			balanceOf[player] = safeAdd(balanceOf[player], numTokens);
230 			playerBalance = safeAdd(playerBalance, numTokens);
231 		}
232 		else{
233 			numTokens = safeAdd(numTokens, gasCost);
234 			balanceOf[player] = safeSub(balanceOf[player], numTokens);
235 			playerBalance = safeSub(playerBalance, numTokens);
236 		}
237 	}
238   
239   /**
240   * transfers an amount from the contract balance to the owner's wallet.
241   * @param receiver the receiver address
242 	*				 amount   the amount of tokens to withdraw (0 decimals)
243 	*				 v,r,s 		the signature of the player
244   **/
245   function withdrawFor(address receiver, uint amount, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized keepAlive{
246 		uint gasCost =  msg.gas/1000 * gasPrice;
247 		var player = ecrecover(keccak256(receiver, amount, count[receiver]), v, r, s);
248 		count[receiver]++;
249 		uint value = safeAdd(safeMul(amount,10000), gasCost);
250     balanceOf[player] = safeSub(balanceOf[player], value);
251 		playerBalance = safeSub(playerBalance, value);
252     assert(edg.transfer(receiver, amount));
253 		Withdrawal(player, receiver, amount);
254   }
255   
256   /**
257   * update a casino game address in case of a new contract or a new casino game
258   * @param game       the index of the game 
259   *        newAddress the new address of the game
260   **/
261   function setGameAddress(uint8 game, address newAddress) public onlyOwner{
262     if(game<casinoGames.length) casinoGames[game] = newAddress;
263     else casinoGames.push(newAddress);
264   }
265   
266   /**
267   * authorize a address to call game functions.
268   * @param addr the address to be authorized
269   **/
270   function authorize(address addr) public onlyOwner{
271     authorized[addr] = true;
272   }
273   
274   /**
275   * deauthorize a address to call game functions.
276   * @param addr the address to be deauthorized
277   **/
278   function deauthorize(address addr) public onlyOwner{
279     authorized[addr] = false;
280   }
281   
282   /**
283    * authorize a casino contract address to access the funds
284    * @param casinoAddress the address of the casino contract
285    *				v, r, s the player's signature of the casino address, the number of times the address has already been locked 
286    *								and a bool stating if the signature is meant for authourization (true) or deauthorization (false)
287    * */
288   function authorizeCasino(address playerAddress, address casinoAddress, uint8 v, bytes32 r, bytes32 s) public{
289   	address player = ecrecover(keccak256(casinoAddress,lockedByUser[playerAddress][casinoAddress],true), v, r, s);
290   	require(player == playerAddress);
291   	authorizedByUser[player][casinoAddress] = true;
292   }
293  
294   /**
295    * deauthorize a casino contract address to access the funds
296    * @param casinoAddress the address of the casino contract
297    *    		v, r, s the player's signature of the casino address, the number of times the address has already been locked 
298    *								and a bool stating if the signature is meant for authourization (true) or deauthorization (false)
299    * */
300   function deauthorizeCasino(address playerAddress, address casinoAddress, uint8 v, bytes32 r, bytes32 s) public{
301   	address player = ecrecover(keccak256(casinoAddress,lockedByUser[playerAddress][casinoAddress],false), v, r, s);
302   	require(player == playerAddress);
303   	authorizedByUser[player][casinoAddress] = false;
304   	lockedByUser[player][casinoAddress]++;//make it impossible to reuse old signature to authorize the address again
305   }
306 	
307 	/**
308 	* updates the price per 1000 gas in EDG.
309 	* @param price the new gas price (4 decimals, max 0.0256 EDG)
310 	**/
311 	function setGasPrice(uint8 price) public onlyOwner{
312 		gasPrice = price;
313 	}
314 	
315 	/**
316 	* updates the average amount of gas consumed by a game
317 	* @param game the index of the game contract
318 	* 			 gas	the new avg gas
319 	**/
320 	function setAvgGas(uint8 game, uint16 gas) public onlyOwner{
321 		avgGas[casinoGames[game]] = gas;
322 	}
323   
324   /**
325   * Forwards a move to the corresponding game contract if the data has been signed by the client.
326   * The casino contract ensures it is no duplicate move.
327   * @param game  specifies which game contract to call
328   *        data  the function call
329   *        v,r,s the player's signature of the data
330   **/
331   function move(uint8 game, bytes data, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized isAlive{
332     require(game < casinoGames.length);
333     var player = ecrecover(keccak256(data), v, r, s);
334 		require(withdrawAfter[player] == 0 || now<withdrawAfter[player]);
335 		assert(checkAddress(player, data));
336     assert(casinoGames[game].call(data));
337   }
338 
339   /**
340    * checks if the given address is passed as first parameters in the bytes field
341    * @param player the player address
342    *				data the function call
343    * */
344   function checkAddress(address player, bytes data) constant internal returns(bool){
345   	bytes memory ba;
346   	assembly {
347       let m := mload(0x40)
348       mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, player))
349       mstore(0x40, add(m, 52))
350       ba := m
351    }
352    for(uint8 i = 0; i < 20; i++){
353    	if(data[16+i]!=ba[i]) return false;
354    }
355    return true;
356   }
357 	
358 	
359 }