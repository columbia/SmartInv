1 contract AbstractDaoChallenge {
2 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool);
3 	function tokenPrice() returns (uint256);
4 }
5 
6 contract DaoAccount
7 {
8 	/**************************
9 			    Constants
10 	***************************/
11 
12 	/**************************
13 					Events
14 	***************************/
15 
16 	// No events
17 
18 	/**************************
19 	     Public variables
20 	***************************/
21 
22 	address public daoChallenge; // the DaoChallenge this account belongs to
23 
24 	// Owner of the challenge with backdoor access.
25   // Remove for a real DAO contract:
26   address public challengeOwner;
27 
28 	/**************************
29 	     Private variables
30 	***************************/
31 
32 	uint256 tokenBalance; // number of tokens in this account
33   address owner;        // owner of the tokens
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
51   function DaoAccount (address _owner, address _challengeOwner) noEther {
52     owner = _owner;
53     daoChallenge = msg.sender;
54 		tokenBalance = 0;
55 
56     // Remove for a real DAO contract:
57     challengeOwner = _challengeOwner;
58 	}
59 
60 	function () {
61 		throw;
62 	}
63 
64 	/**************************
65 	     Private functions
66 	***************************/
67 
68 	/**************************
69 			 Public functions
70 	***************************/
71 
72 	function getOwnerAddress() constant returns (address ownerAddress) {
73 		return owner;
74 	}
75 
76 	function getTokenBalance() constant returns (uint256 tokens) {
77 		return tokenBalance;
78 	}
79 
80 	function buyTokens() onlyDaoChallenge returns (uint256 tokens) {
81 		uint256 amount = msg.value;
82 		uint256 tokenPrice = AbstractDaoChallenge(daoChallenge).tokenPrice();
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
97 	function transfer(uint256 tokens, DaoAccount recipient) noEther onlyDaoChallenge {
98 		if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
99 		if (tokenBalance - tokens > tokenBalance) throw; // Overflow
100 		tokenBalance -= tokens;
101 		recipient.receiveTokens(tokens);
102 	}
103 
104 	function receiveTokens(uint256 tokens) {
105 		// Check that the sender is a DaoAccount and belongs to our DaoChallenge
106 		DaoAccount sender = DaoAccount(msg.sender);
107 		if (!AbstractDaoChallenge(daoChallenge).isMember(sender, sender.getOwnerAddress())) throw;
108 
109 		if (tokens > sender.getTokenBalance()) throw;
110 
111 		// Protect against overflow:
112 		if (tokenBalance + tokens < tokenBalance) throw;
113 
114 		tokenBalance += tokens;
115 	}
116 
117 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
118 	function terminate() noEther onlyChallengeOwner {
119 		suicide(challengeOwner);
120 	}
121 }
122 
123 contract DaoChallenge
124 {
125 	/**************************
126 					Constants
127 	***************************/
128 
129 
130 	/**************************
131 					Events
132 	***************************/
133 
134 	event notifyTerminate(uint256 finalBalance);
135 	event notifyTokenIssued(uint256 n, uint256 price, uint deadline);
136 
137 	event notifyNewAccount(address owner, address account);
138 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
139 	event notifyTransfer(address owner, address recipient, uint256 tokens);
140 
141 	/**************************
142 	     Public variables
143 	***************************/
144 
145 	// For the current token issue:
146 	uint public tokenIssueDeadline = now;
147 	uint256 public tokensIssued = 0;
148 	uint256 public tokensToIssue = 0;
149 	uint256 public tokenPrice = 1000000000000000; // 1 finney
150 
151 	mapping (address => DaoAccount) public daoAccounts;
152 
153 	/**************************
154 			 Private variables
155 	***************************/
156 
157 	// Owner of the challenge; a real DAO doesn't an owner.
158 	address challengeOwner;
159 
160 	/**************************
161 					 Modifiers
162 	***************************/
163 
164 	modifier noEther() {if (msg.value > 0) throw; _}
165 
166 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
167 
168 	/**************************
169 	 Constructor and fallback
170 	**************************/
171 
172 	function DaoChallenge () {
173 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
174 	}
175 
176 	function () noEther {
177 	}
178 
179 	/**************************
180 	     Private functions
181 	***************************/
182 
183 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
184 		DaoAccount account = daoAccounts[accountOwner];
185 
186 		if(account == DaoAccount(0x00) && createNew) {
187 			account = new DaoAccount(accountOwner, challengeOwner);
188 			daoAccounts[accountOwner] = account;
189 			notifyNewAccount(accountOwner, address(account));
190 		}
191 
192 		return account;
193 	}
194 
195 	/**************************
196 	     Public functions
197 	***************************/
198 
199 	function createAccount () {
200 		accountFor(msg.sender, true);
201 	}
202 
203 	// Check if a given account belongs to this DaoChallenge.
204 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {
205 		if (account == DaoAccount(0x00)) return false;
206 		if (allegedOwnerAddress == 0x00) return false;
207 		if (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;
208 		// allegedOwnerAddress is passed in for performance reasons, but not trusted
209 		if (daoAccounts[allegedOwnerAddress] != account) return false;
210 		return true;
211 	}
212 
213 	function getTokenBalance () constant noEther returns (uint256 tokens) {
214 		DaoAccount account = accountFor(msg.sender, false);
215 		if (account == DaoAccount(0x00)) return 0;
216 		return account.getTokenBalance();
217 	}
218 
219 	// n: max number of tokens to be issued
220 	// price: in szabo, e.g. 1 finney = 1,000 szabo = 0.001 ether
221 	// deadline: unix timestamp in seconds
222 	function issueTokens (uint256 n, uint256 price, uint deadline) noEther onlyChallengeOwner {
223 		// Only allow one issuing at a time:
224 		if (now < tokenIssueDeadline) throw;
225 
226 		// Deadline can't be in the past:
227 		if (deadline < now) throw;
228 
229 		// Issue at least 1 token
230 		if (n == 0) throw;
231 
232 		tokenPrice = price * 1000000000000;
233 		tokenIssueDeadline = deadline;
234 		tokensToIssue = n;
235 		tokensIssued = 0;
236 
237 		notifyTokenIssued(n, price, deadline);
238 	}
239 
240 	function buyTokens () returns (uint256 tokens) {
241 		tokens = msg.value / tokenPrice;
242 
243 		if (now > tokenIssueDeadline) throw;
244 		if (tokensIssued >= tokensToIssue) throw;
245 
246 		// This hopefully prevents issuing too many tokens
247 		// if there's a race condition:
248 		tokensIssued += tokens;
249 		if (tokensIssued > tokensToIssue) throw;
250 
251 	  DaoAccount account = accountFor(msg.sender, true);
252 		if (account.buyTokens.value(msg.value)() != tokens) throw;
253 
254 		notifyBuyToken(msg.sender, tokens, msg.value);
255 		return tokens;
256  	}
257 
258 	function transfer(uint256 tokens, address recipient) noEther {
259 		DaoAccount account = accountFor(msg.sender, false);
260 		if (account == DaoAccount(0x00)) throw;
261 
262 		DaoAccount recipientAcc = accountFor(recipient, false);
263 		if (recipientAcc == DaoAccount(0x00)) throw;
264 
265 		account.transfer(tokens, recipientAcc);
266 		notifyTransfer(msg.sender, recipient, tokens);
267 	}
268 
269 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
270 	function terminate() noEther onlyChallengeOwner {
271 		notifyTerminate(this.balance);
272 		suicide(challengeOwner);
273 	}
274 }