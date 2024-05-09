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
129 
130 contract DaoChallenge
131 {
132 	/**************************
133 					Constants
134 	***************************/
135 
136 	uint256 constant public tokenPrice = 1000000000000000; // 1 finney
137 
138 	/**************************
139 					Events
140 	***************************/
141 
142 	event notifyTerminate(uint256 finalBalance);
143 
144 	event notifyNewAccount(address owner, address account);
145 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
146 	event notifyWithdraw(address owner, uint256 tokens);
147 	event notifyTransfer(address owner, address recipient, uint256 tokens);
148 
149 	/**************************
150 	     Public variables
151 	***************************/
152 
153 	mapping (address => DaoAccount) public daoAccounts;
154 
155 	/**************************
156 			 Private variables
157 	***************************/
158 
159 	// Owner of the challenge; a real DAO doesn't an owner.
160 	address challengeOwner;
161 
162 	/**************************
163 					 Modifiers
164 	***************************/
165 
166 	modifier noEther() {if (msg.value > 0) throw; _}
167 
168 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
169 
170 	/**************************
171 	 Constructor and fallback
172 	**************************/
173 
174 	function DaoChallenge () {
175 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
176 	}
177 
178 	function () noEther {
179 	}
180 
181 	/**************************
182 	     Private functions
183 	***************************/
184 
185 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
186 		DaoAccount account = daoAccounts[accountOwner];
187 
188 		if(account == DaoAccount(0x00) && createNew) {
189 			account = new DaoAccount(accountOwner, tokenPrice, challengeOwner);
190 			daoAccounts[accountOwner] = account;
191 			notifyNewAccount(accountOwner, address(account));
192 		}
193 
194 		return account;
195 	}
196 
197 	/**************************
198 	     Public functions
199 	***************************/
200 
201 	function createAccount () {
202 		accountFor(msg.sender, true);
203 	}
204 
205 	// Check if a given account belongs to this DaoChallenge.
206 	function isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {
207 		if (account == DaoAccount(0x00)) return false;
208 		if (allegedOwnerAddress == 0x00) return false;
209 		if (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;
210 		// allegedOwnerAddress is passed in for performance reasons, but not trusted
211 		if (daoAccounts[allegedOwnerAddress] != account) return false;
212 		return true;
213 	}
214 
215 	function getTokenBalance () constant noEther returns (uint256 tokens) {
216 		DaoAccount account = accountFor(msg.sender, false);
217 		if (account == DaoAccount(0x00)) return 0;
218 		return account.getTokenBalance();
219 	}
220 
221 	function buyTokens () returns (uint256 tokens) {
222 	  DaoAccount account = accountFor(msg.sender, true);
223 		tokens = account.buyTokens.value(msg.value)();
224 
225 		notifyBuyToken(msg.sender, tokens, msg.value);
226 		return tokens;
227  	}
228 
229 	function withdraw(uint256 tokens) noEther {
230 		DaoAccount account = accountFor(msg.sender, false);
231 		if (account == DaoAccount(0x00)) throw;
232 
233 		account.withdraw(tokens);
234 		notifyWithdraw(msg.sender, tokens);
235 	}
236 
237 	function transfer(uint256 tokens, address recipient) noEther {
238 		DaoAccount account = accountFor(msg.sender, false);
239 		if (account == DaoAccount(0x00)) throw;
240 
241 		DaoAccount recipientAcc = accountFor(recipient, false);
242 		if (recipientAcc == DaoAccount(0x00)) throw;
243 
244 		account.transfer(tokens, recipientAcc);
245 		notifyTransfer(msg.sender, recipient, tokens);
246 	}
247 
248 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
249 	function terminate() noEther onlyChallengeOwner {
250 		notifyTerminate(this.balance);
251 		suicide(challengeOwner);
252 	}
253 }