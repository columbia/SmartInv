1 contract AbstractDaoChallenge {
2 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool);
3 }
4 
5 contract DaoAccount
6 {
7 	/**************************
8 			    Constants
9 	***************************/
10 
11 	/**************************
12 					Events
13 	***************************/
14 
15 	// No events
16 
17 	/**************************
18 	     Public variables
19 	***************************/
20 
21 
22 	/**************************
23 	     Private variables
24 	***************************/
25 
26 	uint256 tokenBalance; // number of tokens in this account
27   address owner;        // owner of the otkens
28 	address daoChallenge; // the DaoChallenge this account belongs to
29 	uint256 tokenPrice;
30 
31   // Owner of the challenge with backdoor access.
32   // Remove for a real DAO contract:
33   address challengeOwner;
34 
35 	/**************************
36 			     Modifiers
37 	***************************/
38 
39 	modifier noEther() {if (msg.value > 0) throw; _}
40 
41 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
42 
43 	modifier onlyDaoChallenge() {if (daoChallenge != msg.sender) throw; _}
44 
45 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
46 
47 	/**************************
48 	 Constructor and fallback
49 	**************************/
50 
51   function DaoAccount (address _owner, uint256 _tokenPrice, address _challengeOwner) noEther {
52     owner = _owner;
53 		tokenPrice = _tokenPrice;
54     daoChallenge = msg.sender;
55 		tokenBalance = 0;
56 
57     // Remove for a real DAO contract:
58     challengeOwner = _challengeOwner;
59 	}
60 
61 	function () {
62 		throw;
63 	}
64 
65 	/**************************
66 	     Private functions
67 	***************************/
68 
69 	/**************************
70 			 Public functions
71 	***************************/
72 
73 	function getOwnerAddress() constant returns (address ownerAddress) {
74 		return owner;
75 	}
76 
77 	function getTokenBalance() constant returns (uint256 tokens) {
78 		return tokenBalance;
79 	}
80 
81 	function buyTokens() onlyDaoChallenge returns (uint256 tokens) {
82 		uint256 amount = msg.value;
83 
84 		// No free tokens:
85 		if (amount == 0) throw;
86 
87 		// No fractional tokens:
88 		if (amount % tokenPrice != 0) throw;
89 
90 		tokens = amount / tokenPrice;
91 
92 		tokenBalance += tokens;
93 
94 		return tokens;
95 	}
96 
97 	function withdraw(uint256 tokens) noEther onlyDaoChallenge {
98 		if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
99 		tokenBalance -= tokens;
100 		if(!owner.call.value(tokens * tokenPrice)()) throw;
101 	}
102 
103 	function transfer(uint256 tokens, DaoAccount recipient) noEther onlyDaoChallenge {
104 		if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
105 		tokenBalance -= tokens;
106 		recipient.receiveTokens.value(tokens * tokenPrice)(tokens);
107 	}
108 
109 	function receiveTokens(uint256 tokens) {
110 		// Check that the sender is a DaoAccount and belongs to our DaoChallenge
111 		DaoAccount sender = DaoAccount(msg.sender);
112 		if (!AbstractDaoChallenge(daoChallenge).isMember(sender, sender.getOwnerAddress())) throw;
113 
114 		uint256 amount = msg.value;
115 
116 		// No zero transfer:
117 		if (amount == 0) throw;
118 
119 		if (amount / tokenPrice != tokens) throw;
120 
121 		tokenBalance += tokens;
122 	}
123 
124 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
125 	function terminate() noEther onlyChallengeOwner {
126 		suicide(challengeOwner);
127 	}
128 }
129 contract DaoChallenge
130 {
131 	/**************************
132 					Constants
133 	***************************/
134 
135 
136 	/**************************
137 					Events
138 	***************************/
139 
140 	event notifyTerminate(uint256 finalBalance);
141 	event notifyTokenIssued(uint256 n, uint256 price, uint deadline);
142 
143 	event notifyNewAccount(address owner, address account);
144 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
145 	event notifyWithdraw(address owner, uint256 tokens);
146 	event notifyTransfer(address owner, address recipient, uint256 tokens);
147 
148 	/**************************
149 	     Public variables
150 	***************************/
151 
152 	// For the current token issue:
153 	uint public tokenIssueDeadline = now;
154 	uint256 public tokensIssued = 0;
155 	uint256 public tokensToIssue = 0;
156 	uint256 public tokenPrice = 1000000000000000; // 1 finney
157 
158 	mapping (address => DaoAccount) public daoAccounts;
159 
160 	/**************************
161 			 Private variables
162 	***************************/
163 
164 	// Owner of the challenge; a real DAO doesn't an owner.
165 	address challengeOwner;
166 
167 	/**************************
168 					 Modifiers
169 	***************************/
170 
171 	modifier noEther() {if (msg.value > 0) throw; _}
172 
173 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
174 
175 	/**************************
176 	 Constructor and fallback
177 	**************************/
178 
179 	function DaoChallenge () {
180 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
181 	}
182 
183 	function () noEther {
184 	}
185 
186 	/**************************
187 	     Private functions
188 	***************************/
189 
190 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
191 		DaoAccount account = daoAccounts[accountOwner];
192 
193 		if(account == DaoAccount(0x00) && createNew) {
194 			account = new DaoAccount(accountOwner, tokenPrice, challengeOwner);
195 			daoAccounts[accountOwner] = account;
196 			notifyNewAccount(accountOwner, address(account));
197 		}
198 
199 		return account;
200 	}
201 
202 	/**************************
203 	     Public functions
204 	***************************/
205 
206 	function createAccount () {
207 		accountFor(msg.sender, true);
208 	}
209 
210 	// Check if a given account belongs to this DaoChallenge.
211 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {
212 		if (account == DaoAccount(0x00)) return false;
213 		if (allegedOwnerAddress == 0x00) return false;
214 		if (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;
215 		// allegedOwnerAddress is passed in for performance reasons, but not trusted
216 		if (daoAccounts[allegedOwnerAddress] != account) return false;
217 		return true;
218 	}
219 
220 	function getTokenBalance () constant noEther returns (uint256 tokens) {
221 		DaoAccount account = accountFor(msg.sender, false);
222 		if (account == DaoAccount(0x00)) return 0;
223 		return account.getTokenBalance();
224 	}
225 
226 	// n: max number of tokens to be issued
227 	// price: in szabo, e.g. 1 finney = 1,000 szabo = 0.001 ether
228 	// deadline: unix timestamp in seconds
229 	function issueTokens (uint256 n, uint256 price, uint deadline) noEther onlyChallengeOwner {
230 		// Only allow one issuing at a time:
231 		if (now < tokenIssueDeadline) throw;
232 
233 		// Deadline can't be in the past:
234 		if (deadline < now) throw;
235 
236 		// Issue at least 1 token
237 		if (n == 0) throw;
238 
239 		tokenPrice = price * 1000000000000;
240 		tokenIssueDeadline = deadline;
241 		tokensToIssue = n;
242 		tokensIssued = 0;
243 
244 		notifyTokenIssued(n, price, deadline);
245 	}
246 
247 	function buyTokens () returns (uint256 tokens) {
248 		tokens = msg.value / tokenPrice;
249 
250 		if (now > tokenIssueDeadline) throw;
251 		if (tokensIssued >= tokensToIssue) throw;
252 
253 		// This hopefully prevents issuing too many tokens
254 		// if there's a race condition:
255 		tokensIssued += tokens;
256 		if (tokensIssued > tokensToIssue) throw;
257 
258 	  DaoAccount account = accountFor(msg.sender, true);
259 		if (account.buyTokens.value(msg.value)() != tokens) throw;
260 
261 		notifyBuyToken(msg.sender, tokens, msg.value);
262 		return tokens;
263  	}
264 
265 	function withdraw(uint256 tokens) noEther {
266 		DaoAccount account = accountFor(msg.sender, false);
267 		if (account == DaoAccount(0x00)) throw;
268 
269 		account.withdraw(tokens);
270 		notifyWithdraw(msg.sender, tokens);
271 	}
272 
273 	function transfer(uint256 tokens, address recipient) noEther {
274 		DaoAccount account = accountFor(msg.sender, false);
275 		if (account == DaoAccount(0x00)) throw;
276 
277 		DaoAccount recipientAcc = accountFor(recipient, false);
278 		if (recipientAcc == DaoAccount(0x00)) throw;
279 
280 		account.transfer(tokens, recipientAcc);
281 		notifyTransfer(msg.sender, recipient, tokens);
282 	}
283 
284 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
285 	function terminate() noEther onlyChallengeOwner {
286 		notifyTerminate(this.balance);
287 		suicide(challengeOwner);
288 	}
289 }