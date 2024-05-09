1 contract DaoAccount
2 {
3 	/**************************
4 			    Constants
5 	***************************/
6 
7 	uint256 constant tokenPrice = 1000000000000000; // 1 finney
8 
9 	/**************************
10 					Events
11 	***************************/
12 
13 	// No events
14 	
15 	/**************************
16 	     Public variables
17 	***************************/
18 
19   uint256 public tokenBalance; // number of tokens in this account
20 
21 	/**************************
22 	     Private variables
23 	***************************/
24 
25   address owner;        // owner of the otkens
26 	address daoChallenge; // the DaoChallenge this account belongs to
27 
28   // Owner of the challenge with backdoor access.
29   // Remove for a real DAO contract:
30   address challengeOwner;
31 
32 	/**************************
33 			     Modifiers
34 	***************************/
35 
36 	modifier noEther() {if (msg.value > 0) throw; _}
37 
38 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
39 
40 	modifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}
41 
42 	/**************************
43 	 Constructor and fallback
44 	**************************/
45 
46   function DaoAccount (address _owner, address _challengeOwner) {
47     owner = _owner;
48     daoChallenge = msg.sender;
49 
50     // Remove for a real DAO contract:
51     challengeOwner = _challengeOwner;
52 	}
53 
54   // Only owner can fund:
55 	function () onlyOwner returns (uint256 newBalance){
56 		uint256 amount = msg.value;
57 
58 		// No fractional tokens:
59 		if (amount % tokenPrice != 0) {
60 			throw;
61 		}
62 
63     uint256 tokens = amount / tokenPrice;
64 
65 		tokenBalance += tokens;
66 
67     return tokenBalance;
68 	}
69 
70 	/**************************
71 	     Private functions
72 	***************************/
73 
74 	// This uses call.value()() rather than send(), but only sends to msg.sender
75   // who is also the owner.
76 	function withdrawEtherOrThrow(uint256 amount) private {
77     if (msg.sender != owner) throw;
78 		bool result = owner.call.value(amount)();
79 		if (!result) {
80 			throw;
81 		}
82 	}
83 
84 	/**************************
85 			 Public functions
86 	***************************/
87 
88 	function refund() noEther onlyOwner {
89 		if (tokenBalance == 0) throw;
90 		tokenBalance = 0;
91 		withdrawEtherOrThrow(tokenBalance * tokenPrice);
92 	}
93 
94 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
95 	function terminate() noEther onlyChallengeOwner {
96 		suicide(challengeOwner);
97 	}
98 }
99 contract DaoChallenge
100 {
101 	/**************************
102 					Constants
103 	***************************/
104 
105 	// No Constants
106 
107 	/**************************
108 					Events
109 	***************************/
110 
111 	event notifyTerminate(uint256 finalBalance);
112 
113 	/**************************
114 	     Public variables
115 	***************************/
116 
117 	/**************************
118 			 Private variables
119 	***************************/
120 
121 	// Owner of the challenge; a real DAO doesn't an owner.
122 	address owner;
123 
124 	mapping (address => DaoAccount) private daoAccounts;
125 
126 	/**************************
127 					 Modifiers
128 	***************************/
129 
130 	modifier noEther() {if (msg.value > 0) throw; _}
131 
132 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
133 
134 	/**************************
135 	 Constructor and fallback
136 	**************************/
137 
138 	function DaoChallenge () {
139 		owner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
140 	}
141 
142 	function () noEther {
143 	}
144 
145 	/**************************
146 	     Private functions
147 	***************************/
148 
149 	// No private functions
150 
151 	/**************************
152 	     Public functions
153 	***************************/
154 
155 	function createAccount () noEther returns (DaoAccount account) {
156 		address accountOwner = msg.sender;
157 		address challengeOwner = owner; // Don't use in a real DAO
158 
159 		// One account per address:
160 		if(daoAccounts[accountOwner] != DaoAccount(0x00)) throw;
161 
162 		daoAccounts[accountOwner] = new DaoAccount(accountOwner, challengeOwner);
163 		return daoAccounts[accountOwner];
164 	}
165 
166 	function myAccount () noEther returns (DaoAccount) {
167 		address accountOwner = msg.sender;
168 		return daoAccounts[accountOwner];
169 	}
170 
171 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
172 	function terminate() noEther onlyOwner {
173 		notifyTerminate(this.balance);
174 		suicide(owner);
175 	}
176 }