1 contract SellOrder {
2   /**************************
3           Constants
4   ***************************/
5 
6   /**************************
7           Events
8   ***************************/
9 
10   /**************************
11        Public variables
12   ***************************/
13 
14   // Owner of the challenge with backdoor access.
15   // Remove for a real DAO contract:
16   address public challengeOwner;
17   address public owner; // DaoAccount that created the order
18   uint256 public tokens;
19   uint256 public price; // Wei per token
20 
21   /**************************
22        Private variables
23   ***************************/
24 
25 
26   /**************************
27            Modifiers
28   ***************************/
29 
30   modifier noEther() {if (msg.value > 0) throw; _}
31 
32   modifier onlyOwner() {if (owner != msg.sender) throw; _}
33 
34   modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
35 
36   /**************************
37    Constructor and fallback
38   **************************/
39 
40   function SellOrder (uint256 _tokens, uint256 _price, address _challengeOwner) noEther {
41     owner = msg.sender;
42 
43     tokens = _tokens;
44     price = _price;
45 
46     // Remove for a real DAO contract:
47     challengeOwner = _challengeOwner;
48   }
49 
50   function () {
51     throw;
52   }
53 
54   /**************************
55        Private functions
56   ***************************/
57 
58   /**************************
59        Public functions
60   ***************************/
61 
62   function cancel () noEther onlyOwner {
63     suicide(owner);
64   }
65 
66   function execute () {
67     if (msg.value != tokens * price) throw;
68 
69     // Tokens are sent to the buyer in DaoAccount.executeSellOrder()
70     // Send ether to seller:
71     suicide(owner);
72   }
73 
74   // The owner of the challenge can terminate it. Don't use this in a real DAO.
75   function terminate() noEther onlyChallengeOwner {
76     suicide(challengeOwner);
77   }
78 }
79 contract AbstractDaoChallenge {
80 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool);
81 	function tokenPrice() returns (uint256);
82 }
83 
84 contract DaoAccount
85 {
86 	/**************************
87 			    Constants
88 	***************************/
89 
90 	/**************************
91 					Events
92 	***************************/
93 
94 	// No events
95 
96 	/**************************
97 	     Public variables
98 	***************************/
99 
100 	address public daoChallenge; // the DaoChallenge this account belongs to
101 
102 	// Owner of the challenge with backdoor access.
103   // Remove for a real DAO contract:
104   address public challengeOwner;
105 
106 	/**************************
107 	     Private variables
108 	***************************/
109 
110 	uint256 tokenBalance; // number of tokens in this account
111   address owner;        // owner of the tokens
112 
113 	/**************************
114 			     Modifiers
115 	***************************/
116 
117 	modifier noEther() {if (msg.value > 0) throw; _}
118 
119 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
120 
121 	modifier onlyDaoChallenge() {if (daoChallenge != msg.sender) throw; _}
122 
123 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
124 
125 	/**************************
126 	 Constructor and fallback
127 	**************************/
128 
129   function DaoAccount (address _owner, address _challengeOwner) noEther {
130     owner = _owner;
131     daoChallenge = msg.sender;
132 		tokenBalance = 0;
133 
134     // Remove for a real DAO contract:
135     challengeOwner = _challengeOwner;
136 	}
137 
138 	function () {
139 		throw;
140 	}
141 
142 	/**************************
143 	     Private functions
144 	***************************/
145 
146 	/**************************
147 			 Public functions
148 	***************************/
149 
150 	function getOwnerAddress() constant returns (address ownerAddress) {
151 		return owner;
152 	}
153 
154 	function getTokenBalance() constant returns (uint256 tokens) {
155 		return tokenBalance;
156 	}
157 
158 	function buyTokens() onlyDaoChallenge returns (uint256 tokens) {
159 		uint256 amount = msg.value;
160 		uint256 tokenPrice = AbstractDaoChallenge(daoChallenge).tokenPrice();
161 
162 		// No free tokens:
163 		if (amount == 0) throw;
164 
165 		// No fractional tokens:
166 		if (amount % tokenPrice != 0) throw;
167 
168 		tokens = amount / tokenPrice;
169 
170 		tokenBalance += tokens;
171 
172 		return tokens;
173 	}
174 
175 	function transfer(uint256 tokens, DaoAccount recipient) noEther onlyDaoChallenge {
176 		if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
177 		if (tokenBalance - tokens > tokenBalance) throw; // Overflow
178 		tokenBalance -= tokens;
179 		recipient.receiveTokens(tokens);
180 	}
181 
182 	function receiveTokens(uint256 tokens) {
183 		// Check that the sender is a DaoAccount and belongs to our DaoChallenge
184 		DaoAccount sender = DaoAccount(msg.sender);
185 		if (!AbstractDaoChallenge(daoChallenge).isMember(sender, sender.getOwnerAddress())) throw;
186 
187 		if (tokens > sender.getTokenBalance()) throw;
188 
189 		// Protect against overflow:
190 		if (tokenBalance + tokens < tokenBalance) throw;
191 
192 		tokenBalance += tokens;
193 	}
194 
195   function placeSellOrder(uint256 tokens, uint256 price) noEther onlyDaoChallenge returns (SellOrder) {
196     if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
197     if (tokenBalance - tokens > tokenBalance) throw; // Overflow
198     tokenBalance -= tokens;
199 
200     SellOrder order = new SellOrder(tokens, price, challengeOwner);
201     return order;
202   }
203 
204   function cancelSellOrder(SellOrder order) noEther onlyDaoChallenge {
205     uint256 tokens = order.tokens();
206     tokenBalance += tokens;
207     order.cancel();
208   }
209 
210   function executeSellOrder(SellOrder order) onlyDaoChallenge {
211     uint256 tokens = order.tokens();
212     tokenBalance += tokens;
213     order.execute.value(msg.value)();
214   }
215 
216 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
217 	function terminate() noEther onlyChallengeOwner {
218 		suicide(challengeOwner);
219 	}
220 }
221 
222 contract DaoChallenge
223 {
224 	/**************************
225 					Constants
226 	***************************/
227 
228 
229 	/**************************
230 					Events
231 	***************************/
232 
233 	event notifyTerminate(uint256 finalBalance);
234 	event notifyTokenIssued(uint256 n, uint256 price, uint deadline);
235 
236 	event notifyNewAccount(address owner, address account);
237 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
238 	event notifyTransfer(address owner, address recipient, uint256 tokens);
239   event notifyPlaceSellOrder(uint256 tokens, uint256 price);
240   event notifyCancelSellOrder();
241   event notifyExecuteSellOrder(uint256 tokens, uint256 price);
242 
243 	/**************************
244 	     Public variables
245 	***************************/
246 
247 	// For the current token issue:
248 	uint public tokenIssueDeadline = now;
249 	uint256 public tokensIssued = 0;
250 	uint256 public tokensToIssue = 0;
251 	uint256 public tokenPrice = 1000000000000000; // 1 finney
252 
253 	mapping (address => DaoAccount) public daoAccounts;
254   mapping (address => SellOrder) public sellOrders;
255 
256   // Owner of the challenge; a real DAO doesn't an owner.
257   address public challengeOwner;
258 
259 	/**************************
260 			 Private variables
261 	***************************/
262 
263 	/**************************
264 					 Modifiers
265 	***************************/
266 
267 	modifier noEther() {if (msg.value > 0) throw; _}
268 
269 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
270 
271 	/**************************
272 	 Constructor and fallback
273 	**************************/
274 
275 	function DaoChallenge () {
276 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
277 	}
278 
279 	function () noEther {
280 	}
281 
282 	/**************************
283 	     Private functions
284 	***************************/
285 
286 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
287 		DaoAccount account = daoAccounts[accountOwner];
288 
289 		if(account == DaoAccount(0x00) && createNew) {
290 			account = new DaoAccount(accountOwner, challengeOwner);
291 			daoAccounts[accountOwner] = account;
292 			notifyNewAccount(accountOwner, address(account));
293 		}
294 
295 		return account;
296 	}
297 
298 	/**************************
299 	     Public functions
300 	***************************/
301 
302 	function createAccount () {
303 		accountFor(msg.sender, true);
304 	}
305 
306 	// Check if a given account belongs to this DaoChallenge.
307 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {
308 		if (account == DaoAccount(0x00)) return false;
309 		if (allegedOwnerAddress == 0x00) return false;
310 		if (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;
311 		// allegedOwnerAddress is passed in for performance reasons, but not trusted
312 		if (daoAccounts[allegedOwnerAddress] != account) return false;
313 		return true;
314 	}
315 
316   function getBalance () constant noEther returns (uint256) {
317     DaoAccount account = accountFor(msg.sender, false);
318     if (account == DaoAccount(0x00)) return 0;
319     return account.balance;
320   }
321 
322 	function getTokenBalance () constant noEther returns (uint256 tokens) {
323 		DaoAccount account = accountFor(msg.sender, false);
324 		if (account == DaoAccount(0x00)) return 0;
325 		return account.getTokenBalance();
326 	}
327 
328 	// n: max number of tokens to be issued
329 	// price: in wei, e.g. 1 finney = 0.001 eth = 1000000000000000 wei
330 	// deadline: unix timestamp in seconds
331 	function issueTokens (uint256 n, uint256 price, uint deadline) noEther onlyChallengeOwner {
332 		// Only allow one issuing at a time:
333 		if (now < tokenIssueDeadline) throw;
334 
335 		// Deadline can't be in the past:
336 		if (deadline < now) throw;
337 
338 		// Issue at least 1 token
339 		if (n == 0) throw;
340 
341 		tokenPrice = price;
342 		tokenIssueDeadline = deadline;
343 		tokensToIssue = n;
344 		tokensIssued = 0;
345 
346 		notifyTokenIssued(n, price, deadline);
347 	}
348 
349 	function buyTokens () returns (uint256 tokens) {
350 		tokens = msg.value / tokenPrice;
351 
352 		if (now > tokenIssueDeadline) throw;
353 		if (tokensIssued >= tokensToIssue) throw;
354 
355 		// This hopefully prevents issuing too many tokens
356 		// if there's a race condition:
357 		tokensIssued += tokens;
358 		if (tokensIssued > tokensToIssue) throw;
359 
360 	  DaoAccount account = accountFor(msg.sender, true);
361 		if (account.buyTokens.value(msg.value)() != tokens) throw;
362 
363 		notifyBuyToken(msg.sender, tokens, msg.value);
364 		return tokens;
365  	}
366 
367 	function transfer(uint256 tokens, address recipient) noEther {
368 		DaoAccount account = accountFor(msg.sender, false);
369 		if (account == DaoAccount(0x00)) throw;
370 
371 		DaoAccount recipientAcc = accountFor(recipient, false);
372 		if (recipientAcc == DaoAccount(0x00)) throw;
373 
374 		account.transfer(tokens, recipientAcc);
375 		notifyTransfer(msg.sender, recipient, tokens);
376 	}
377 
378   function placeSellOrder(uint256 tokens, uint256 price) noEther returns (SellOrder) {
379     DaoAccount account = accountFor(msg.sender, false);
380     if (account == DaoAccount(0x00)) throw;
381 
382     SellOrder order = account.placeSellOrder(tokens, price);
383 
384     sellOrders[address(order)] = order;
385 
386     notifyPlaceSellOrder(tokens, price);
387     return order;
388   }
389 
390   function cancelSellOrder(address addr) noEther {
391     DaoAccount account = accountFor(msg.sender, false);
392     if (account == DaoAccount(0x00)) throw;
393 
394     SellOrder order = sellOrders[addr];
395     if (order == SellOrder(0x00)) throw;
396 
397     if (order.owner() != address(account)) throw;
398 
399     sellOrders[addr] = SellOrder(0x00);
400 
401     account.cancelSellOrder(order);
402 
403     notifyCancelSellOrder();
404   }
405 
406   function executeSellOrder(address addr) {
407     // Fefuse if no ether is sent. SellOrder checks the exact amount.
408     if (msg.value == 0) throw;
409 
410     DaoAccount account = accountFor(msg.sender, true);
411 
412     SellOrder order = sellOrders[addr];
413     if (order == SellOrder(0x00)) throw;
414 
415     // Don't execute your own oder:
416     if (order.owner() == address(account)) throw;
417 
418     uint256 tokens = order.tokens();
419     uint256 price = order.price();
420 
421     // If order is successful, forget it (might not be necessary)
422     sellOrders[addr] = SellOrder(0x00);
423 
424     account.executeSellOrder.value(msg.value)(order);
425 
426     notifyExecuteSellOrder(tokens, price);
427   }
428 
429 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
430 	function terminate() noEther onlyChallengeOwner {
431 		notifyTerminate(this.balance);
432 		suicide(challengeOwner);
433 	}
434 }