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
67     // ... transfer tokens to buyer
68 
69     // Send ether to seller:
70     // suicide(owner);
71   }
72 
73   // The owner of the challenge can terminate it. Don't use this in a real DAO.
74   function terminate() noEther onlyChallengeOwner {
75     suicide(challengeOwner);
76   }
77 }
78 
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
210 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
211 	function terminate() noEther onlyChallengeOwner {
212 		suicide(challengeOwner);
213 	}
214 }
215 
216 contract DaoChallenge
217 {
218 	/**************************
219 					Constants
220 	***************************/
221 
222 
223 	/**************************
224 					Events
225 	***************************/
226 
227 	event notifyTerminate(uint256 finalBalance);
228 	event notifyTokenIssued(uint256 n, uint256 price, uint deadline);
229 
230 	event notifyNewAccount(address owner, address account);
231 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
232 	event notifyTransfer(address owner, address recipient, uint256 tokens);
233   event notifyPlaceSellOrder(uint256 tokens, uint256 price);
234   event notifyCancelSellOrder();
235 
236 	/**************************
237 	     Public variables
238 	***************************/
239 
240 	// For the current token issue:
241 	uint public tokenIssueDeadline = now;
242 	uint256 public tokensIssued = 0;
243 	uint256 public tokensToIssue = 0;
244 	uint256 public tokenPrice = 1000000000000000; // 1 finney
245 
246 	mapping (address => DaoAccount) public daoAccounts;
247   mapping (address => SellOrder) public sellOrders;
248 
249   // Owner of the challenge; a real DAO doesn't an owner.
250   address public challengeOwner;
251 
252 	/**************************
253 			 Private variables
254 	***************************/
255 
256 	/**************************
257 					 Modifiers
258 	***************************/
259 
260 	modifier noEther() {if (msg.value > 0) throw; _}
261 
262 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
263 
264 	/**************************
265 	 Constructor and fallback
266 	**************************/
267 
268 	function DaoChallenge () {
269 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
270 	}
271 
272 	function () noEther {
273 	}
274 
275 	/**************************
276 	     Private functions
277 	***************************/
278 
279 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
280 		DaoAccount account = daoAccounts[accountOwner];
281 
282 		if(account == DaoAccount(0x00) && createNew) {
283 			account = new DaoAccount(accountOwner, challengeOwner);
284 			daoAccounts[accountOwner] = account;
285 			notifyNewAccount(accountOwner, address(account));
286 		}
287 
288 		return account;
289 	}
290 
291 	/**************************
292 	     Public functions
293 	***************************/
294 
295 	function createAccount () {
296 		accountFor(msg.sender, true);
297 	}
298 
299 	// Check if a given account belongs to this DaoChallenge.
300 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {
301 		if (account == DaoAccount(0x00)) return false;
302 		if (allegedOwnerAddress == 0x00) return false;
303 		if (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;
304 		// allegedOwnerAddress is passed in for performance reasons, but not trusted
305 		if (daoAccounts[allegedOwnerAddress] != account) return false;
306 		return true;
307 	}
308 
309 	function getTokenBalance () constant noEther returns (uint256 tokens) {
310 		DaoAccount account = accountFor(msg.sender, false);
311 		if (account == DaoAccount(0x00)) return 0;
312 		return account.getTokenBalance();
313 	}
314 
315 	// n: max number of tokens to be issued
316 	// price: in wei, e.g. 1 finney = 0.001 eth = 1000000000000000 wei
317 	// deadline: unix timestamp in seconds
318 	function issueTokens (uint256 n, uint256 price, uint deadline) noEther onlyChallengeOwner {
319 		// Only allow one issuing at a time:
320 		if (now < tokenIssueDeadline) throw;
321 
322 		// Deadline can't be in the past:
323 		if (deadline < now) throw;
324 
325 		// Issue at least 1 token
326 		if (n == 0) throw;
327 
328 		tokenPrice = price;
329 		tokenIssueDeadline = deadline;
330 		tokensToIssue = n;
331 		tokensIssued = 0;
332 
333 		notifyTokenIssued(n, price, deadline);
334 	}
335 
336 	function buyTokens () returns (uint256 tokens) {
337 		tokens = msg.value / tokenPrice;
338 
339 		if (now > tokenIssueDeadline) throw;
340 		if (tokensIssued >= tokensToIssue) throw;
341 
342 		// This hopefully prevents issuing too many tokens
343 		// if there's a race condition:
344 		tokensIssued += tokens;
345 		if (tokensIssued > tokensToIssue) throw;
346 
347 	  DaoAccount account = accountFor(msg.sender, true);
348 		if (account.buyTokens.value(msg.value)() != tokens) throw;
349 
350 		notifyBuyToken(msg.sender, tokens, msg.value);
351 		return tokens;
352  	}
353 
354 	function transfer(uint256 tokens, address recipient) noEther {
355 		DaoAccount account = accountFor(msg.sender, false);
356 		if (account == DaoAccount(0x00)) throw;
357 
358 		DaoAccount recipientAcc = accountFor(recipient, false);
359 		if (recipientAcc == DaoAccount(0x00)) throw;
360 
361 		account.transfer(tokens, recipientAcc);
362 		notifyTransfer(msg.sender, recipient, tokens);
363 	}
364 
365   function placeSellOrder(uint256 tokens, uint256 price) noEther returns (SellOrder) {
366     DaoAccount account = accountFor(msg.sender, false);
367     if (account == DaoAccount(0x00)) throw;
368 
369     SellOrder order = account.placeSellOrder(tokens, price);
370 
371     sellOrders[address(order)] = order;
372 
373     notifyPlaceSellOrder(tokens, price);
374     return order;
375   }
376 
377   function cancelSellOrder(address addr) noEther {
378     DaoAccount account = accountFor(msg.sender, false);
379     if (account == DaoAccount(0x00)) throw;
380 
381     SellOrder order = sellOrders[addr];
382     if (order == SellOrder(0x00)) throw;
383 
384     if (order.owner() != address(account)) throw;
385 
386     sellOrders[addr] = SellOrder(0x00);
387 
388     account.cancelSellOrder(order);
389 
390     notifyCancelSellOrder();
391   }
392 
393 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
394 	function terminate() noEther onlyChallengeOwner {
395 		notifyTerminate(this.balance);
396 		suicide(challengeOwner);
397 	}
398 }