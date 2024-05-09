1 contract DaoAccount
2 {
3 	/**************************
4 			    Constants
5 	***************************/
6 
7 	/**************************
8 					Events
9 	***************************/
10 
11 	// No events
12 
13 	/**************************
14 	     Public variables
15 	***************************/
16 
17 
18 	/**************************
19 	     Private variables
20 	***************************/
21 
22 	uint256 tokenBalance; // number of tokens in this account
23   address owner;        // owner of the otkens
24 	address daoChallenge; // the DaoChallenge this account belongs to
25 	uint256 tokenPrice;
26 
27   // Owner of the challenge with backdoor access.
28   // Remove for a real DAO contract:
29   address challengeOwner;
30 
31 	/**************************
32 			     Modifiers
33 	***************************/
34 
35 	modifier noEther() {if (msg.value > 0) throw; _}
36 
37 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
38 
39 	modifier onlyDaoChallenge() {if (daoChallenge != msg.sender) throw; _}
40 
41 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
42 
43 	/**************************
44 	 Constructor and fallback
45 	**************************/
46 
47   function DaoAccount (address _owner, uint256 _tokenPrice, address _challengeOwner) noEther {
48     owner = _owner;
49 		tokenPrice = _tokenPrice;
50     daoChallenge = msg.sender;
51 		tokenBalance = 0;
52 
53     // Remove for a real DAO contract:
54     challengeOwner = _challengeOwner;
55 	}
56 
57 	function () {
58 		throw;
59 	}
60 
61 	/**************************
62 	     Private functions
63 	***************************/
64 
65 	/**************************
66 			 Public functions
67 	***************************/
68 
69 	function getTokenBalance() constant returns (uint256 tokens) {
70 		return tokenBalance;
71 	}
72 
73 	function buyTokens() onlyDaoChallenge returns (uint256 tokens) {
74 		uint256 amount = msg.value;
75 
76 		// No free tokens:
77 		if (amount == 0) throw;
78 
79 		// No fractional tokens:
80 		if (amount % tokenPrice != 0) throw;
81 
82 		tokens = amount / tokenPrice;
83 
84 		tokenBalance += tokens;
85 
86 		return tokens;
87 	}
88 
89 	function withdraw(uint256 tokens) noEther onlyDaoChallenge {
90 		if (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;
91 		tokenBalance -= tokens;
92 		if(!owner.call.value(tokens * tokenPrice)()) throw;
93 	}
94 
95 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
96 	function terminate() noEther onlyChallengeOwner {
97 		suicide(challengeOwner);
98 	}
99 }
100 
101 contract DaoChallenge
102 {
103 	/**************************
104 					Constants
105 	***************************/
106 
107 	uint256 constant public tokenPrice = 1000000000000000; // 1 finney
108 
109 	/**************************
110 					Events
111 	***************************/
112 
113 	event notifyTerminate(uint256 finalBalance);
114 
115 	event notifyNewAccount(address owner, address account);
116 	event notifyBuyToken(address owner, uint256 tokens, uint256 price);
117 	event notifyWithdraw(address owner, uint256 tokens);
118 
119 	/**************************
120 	     Public variables
121 	***************************/
122 
123 	mapping (address => DaoAccount) public daoAccounts;
124 
125 	/**************************
126 			 Private variables
127 	***************************/
128 
129 	// Owner of the challenge; a real DAO doesn't an owner.
130 	address challengeOwner;
131 
132 	/**************************
133 					 Modifiers
134 	***************************/
135 
136 	modifier noEther() {if (msg.value > 0) throw; _}
137 
138 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
139 
140 	/**************************
141 	 Constructor and fallback
142 	**************************/
143 
144 	function DaoChallenge () {
145 		challengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
146 	}
147 
148 	function () noEther {
149 	}
150 
151 	/**************************
152 	     Private functions
153 	***************************/
154 
155 	function accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {
156 		DaoAccount account = daoAccounts[accountOwner];
157 
158 		if(account == DaoAccount(0x00) && createNew) {
159 			account = new DaoAccount(accountOwner, tokenPrice, challengeOwner);
160 			daoAccounts[accountOwner] = account;
161 			notifyNewAccount(accountOwner, address(account));
162 		}
163 
164 		return account;
165 	}
166 
167 	/**************************
168 	     Public functions
169 	***************************/
170 
171 	function getTokenBalance () constant noEther returns (uint256 tokens) {
172 		DaoAccount account = accountFor(msg.sender, false);
173 		if (account == DaoAccount(0x00)) return 0;
174 		return account.getTokenBalance();
175 	}
176 
177 	function buyTokens () returns (uint256 tokens) {
178 	  DaoAccount account = accountFor(msg.sender, true);
179 		tokens = account.buyTokens.value(msg.value)();
180 
181 		notifyBuyToken(msg.sender, tokens, msg.value);
182 		return tokens;
183  	}
184 
185 	function withdraw(uint256 tokens) noEther {
186 		DaoAccount account = accountFor(msg.sender, false);
187 		if (account == DaoAccount(0x00)) throw;
188 
189 		account.withdraw(tokens);
190 		notifyWithdraw(msg.sender, tokens);
191 	}
192 
193 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
194 	function terminate() noEther onlyChallengeOwner {
195 		notifyTerminate(this.balance);
196 		suicide(challengeOwner);
197 	}
198 }