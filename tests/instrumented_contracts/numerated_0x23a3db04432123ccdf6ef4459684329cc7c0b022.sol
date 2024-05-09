1 /**
2  * Edgeless Casino Proxy Contract. Serves as a proxy for game functionality.
3  * Allows the players to deposit and withdraw funds.
4  * Allows authorized addresses to make game transactions.
5  * author: Julia Altenried
6  **/
7 
8 pragma solidity ^ 0.4 .17;
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
20 	address public owner;
21 	modifier onlyOwner {
22 		require(msg.sender == owner);
23 		_;
24 	}
25 
26 	function owned() public {
27 		owner = msg.sender;
28 	}
29 
30 	function changeOwner(address newOwner) onlyOwner public {
31 		owner = newOwner;
32 	}
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
48 	function safeMul(uint a, uint b) constant internal returns(uint) {
49 		uint c = a * b;
50 		assert(a == 0 || c / a == b);
51 		return c;
52 	}
53 }
54 
55 contract casinoBank is owned, safeMath {
56 	/** the total balance of all players with 4 virtual decimals **/
57 	uint public playerBalance;
58 	/** the balance per player in edgeless tokens with 4 virtual decimals */
59 	mapping(address => uint) public balanceOf;
60 	/** in case the user wants/needs to call the withdraw function from his own wallet, he first needs to request a withdrawal */
61 	mapping(address => uint) public withdrawAfter;
62 	/** the price per kgas in tokens (4 decimals) */
63 	uint public gasPrice = 20;
64 	/** the edgeless token contract */
65 	token edg;
66 	/** owner should be able to close the contract is nobody has been using it for at least 30 days */
67 	uint public closeAt;
68 	/** informs listeners how many tokens were deposited for a player */
69 	event Deposit(address _player, uint _numTokens, bool _chargeGas);
70 	/** informs listeners how many tokens were withdrawn from the player to the receiver address */
71 	event Withdrawal(address _player, address _receiver, uint _numTokens);
72 
73 	function casinoBank(address tokenContract) public {
74 		edg = token(tokenContract);
75 	}
76 
77 	/**
78 	 * accepts deposits for an arbitrary address.
79 	 * retrieves tokens from the message sender and adds them to the balance of the specified address.
80 	 * edgeless tokens do not have any decimals, but are represented on this contract with 4 decimals.
81 	 * @param receiver  address of the receiver
82 	 *        numTokens number of tokens to deposit (0 decimals)
83 	 *				 chargeGas indicates if the gas cost is subtracted from the user's edgeless token balance
84 	 **/
85 	function deposit(address receiver, uint numTokens, bool chargeGas) public isAlive {
86 		require(numTokens > 0);
87 		uint value = safeMul(numTokens, 10000);
88 		if (chargeGas) value = safeSub(value, msg.gas / 1000 * gasPrice);
89 		assert(edg.transferFrom(msg.sender, address(this), numTokens));
90 		balanceOf[receiver] = safeAdd(balanceOf[receiver], value);
91 		playerBalance = safeAdd(playerBalance, value);
92 		Deposit(receiver, numTokens, chargeGas);
93 	}
94 
95 	/**
96 	 * If the user wants/needs to withdraw his funds himself, he needs to request the withdrawal first.
97 	 * This method sets the earliest possible withdrawal date to 7 minutes from now. 
98 	 * Reason: The user should not be able to withdraw his funds, while the the last game methods have not yet been mined.
99 	 **/
100 	function requestWithdrawal() public {
101 		withdrawAfter[msg.sender] = now + 7 minutes;
102 	}
103 
104 	/**
105 	 * In case the user requested a withdrawal and changes his mind.
106 	 * Necessary to be able to continue playing.
107 	 **/
108 	function cancelWithdrawalRequest() public {
109 		withdrawAfter[msg.sender] = 0;
110 	}
111 
112 	/**
113 	 * withdraws an amount from the user balance if 7 minutes passed since the request.
114 	 * @param amount the amount of tokens to withdraw
115 	 **/
116 	function withdraw(uint amount) public keepAlive {
117 		require(withdrawAfter[msg.sender] > 0 && now > withdrawAfter[msg.sender]);
118 		withdrawAfter[msg.sender] = 0;
119 		uint value = safeMul(amount, 10000);
120 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
121 		playerBalance = safeSub(playerBalance, value);
122 		assert(edg.transfer(msg.sender, amount));
123 		Withdrawal(msg.sender, msg.sender, amount);
124 	}
125 
126 	/**
127 	 * lets the owner withdraw from the bankroll
128 	 * @param numTokens the number of tokens to withdraw (0 decimals)
129 	 **/
130 	function withdrawBankroll(uint numTokens) public onlyOwner {
131 		require(numTokens <= bankroll());
132 		assert(edg.transfer(owner, numTokens));
133 	}
134 
135 	/**
136 	 * returns the current bankroll in tokens with 0 decimals
137 	 **/
138 	function bankroll() constant public returns(uint) {
139 		return safeSub(edg.balanceOf(address(this)), playerBalance / 10000);
140 	}
141 
142 	/** 
143 	 * lets the owner close the contract if there are no player funds on it or if nobody has been using it for at least 30 days 
144 	 */
145 	function close() onlyOwner public {
146 		if (playerBalance == 0) selfdestruct(owner);
147 		if (closeAt == 0) closeAt = now + 30 days;
148 		else if (closeAt < now) selfdestruct(owner);
149 	}
150 
151 	/**
152 	 * in case close has been called accidentally.
153 	 **/
154 	function open() onlyOwner public {
155 		closeAt = 0;
156 	}
157 
158 	/**
159 	 * make sure the contract is not in process of being closed.
160 	 **/
161 	modifier isAlive {
162 		require(closeAt == 0);
163 		_;
164 	}
165 
166 	/**
167 	 * delays the time of closing.
168 	 **/
169 	modifier keepAlive {
170 		if (closeAt > 0) closeAt = now + 30 days;
171 		_;
172 	}
173 }
174 
175 contract casinoProxy is casinoBank {
176 	/** indicates if an address is authorized to call game functions  */
177 	mapping(address => bool) public authorized;
178 	/** list of casino game contract addresses */
179 	address[] public casinoGames;
180 	/** a number to count withdrawal signatures to ensure each signature is different even if withdrawing the same amount to the same address */
181 	mapping(address => uint) public count;
182 
183 	modifier onlyAuthorized {
184 		require(authorized[msg.sender]);
185 		_;
186 	}
187 
188 	modifier onlyCasinoGames {
189 		bool isCasino;
190 		for (uint i = 0; i < casinoGames.length; i++) {
191 			if (msg.sender == casinoGames[i]) {
192 				isCasino = true;
193 				break;
194 			}
195 		}
196 		require(isCasino);
197 		_;
198 	}
199 
200 	/**
201 	 * creates a new casino wallet.
202 	 * @param authorizedAddress the address which may send transactions to the Edgeless Casino
203 	 *        blackjackAddress  the address of the Edgeless blackjack contract
204 	 *				 tokenContract     the address of the Edgeless token contract
205 	 **/
206 	function casinoProxy(address authorizedAddress, address blackjackAddress, address tokenContract) casinoBank(tokenContract) public {
207 		authorized[authorizedAddress] = true;
208 		casinoGames.push(blackjackAddress);
209 	}
210 
211 	/**
212 	 * shifts tokens from the contract balance to the receiver.
213 	 * only callable from an edgeless casino contract.
214 	 * @param receiver the address of the receiver
215 	 *        numTokens the amount of tokens to shift with 4 decimals
216 	 **/
217 	function shift(address receiver, uint numTokens) public onlyCasinoGames {
218 		balanceOf[receiver] = safeAdd(balanceOf[receiver], numTokens);
219 		playerBalance = safeAdd(playerBalance, numTokens);
220 	}
221 
222 	/**
223 	 * transfers an amount from the contract balance to the owner's wallet.
224 	 * @param receiver the receiver address
225 	 *				 amount   the amount of tokens to withdraw (0 decimals)
226 	 *				 v,r,s 		the signature of the player
227 	 **/
228 	function withdrawFor(address receiver, uint amount, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized keepAlive {
229 		uint gasCost = msg.gas / 1000 * gasPrice;
230 		var player = ecrecover(keccak256(receiver, amount, count[receiver]), v, r, s);
231 		count[receiver]++;
232 		uint value = safeAdd(safeMul(amount, 10000), gasCost);
233 		balanceOf[player] = safeSub(balanceOf[player], value);
234 		playerBalance = safeSub(playerBalance, value);
235 		assert(edg.transfer(receiver, amount));
236 		Withdrawal(player, receiver, amount);
237 	}
238 
239 	/**
240 	 * update a casino game address in case of a new contract or a new casino game
241 	 * @param game       the index of the game 
242 	 *        newAddress the new address of the game
243 	 **/
244 	function setGameAddress(uint8 game, address newAddress) public onlyOwner {
245 		if (game < casinoGames.length) casinoGames[game] = newAddress;
246 		else casinoGames.push(newAddress);
247 	}
248 
249 	/**
250 	 * authorize a address to call game functions.
251 	 * @param addr the address to be authorized
252 	 **/
253 	function authorize(address addr) public onlyOwner {
254 		authorized[addr] = true;
255 	}
256 
257 	/**
258 	 * deauthorize a address to call game functions.
259 	 * @param addr the address to be deauthorized
260 	 **/
261 	function deauthorize(address addr) public onlyOwner {
262 		authorized[addr] = false;
263 	}
264 
265 	/**
266 	 * updates the price per 1000 gas in EDG.
267 	 * @param price the new gas price (4 decimals, max 0.0256 EDG)
268 	 **/
269 	function setGasPrice(uint8 price) public onlyOwner {
270 		gasPrice = price;
271 	}
272 
273 	/**
274 	 * Forwards a move to the corresponding game contract if the data has been signed by the client.
275 	 * The casino contract ensures it is no duplicate move.
276 	 * @param game  specifies which game contract to call
277 	 *        value the value to send to the contract in tokens with 4 decimals
278 	 *        data  the function call
279 	 *        v,r,s the player's signature of the data
280 	 **/
281 	function move(uint8 game, uint value, bytes data, uint8 v, bytes32 r, bytes32 s) public onlyAuthorized isAlive {
282 		require(game < casinoGames.length);
283 		require(safeMul(bankroll(), 10000) > value * 8); //make sure, the casino can always pay out the player
284 		var player = ecrecover(keccak256(data), v, r, s);
285 		require(withdrawAfter[player] == 0 || now < withdrawAfter[player]);
286 		value = safeAdd(value, msg.gas / 1000 * gasPrice);
287 		balanceOf[player] = safeSub(balanceOf[player], value);
288 		playerBalance = safeSub(playerBalance, value);
289 		assert(casinoGames[game].call(data));
290 	}
291 
292 
293 }