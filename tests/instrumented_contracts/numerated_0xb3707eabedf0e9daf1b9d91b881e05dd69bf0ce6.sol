1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 --------------------
6 Distribute PP Tokens
7 Token: REQ
8 Qty: 26666680
9 --------------------
10 METHODS:
11 withdrawAll() -- Withdraws tokens to all payee addresses, withholding a quantity for gas cost
12 changeToken(address _token) -- Changes ERC20 token contract address
13 returnToSender() -- Returns all tokens and ETH to the multisig address
14 abort() -- Returns all tokens and ETH to the multisig address, then suicides
15 --------------------
16 
17 */
18 
19 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
20 contract ERC20 {
21 	function transfer(address _to, uint _value) returns (bool success);
22 	function balanceOf(address _owner) constant returns (uint balance);
23 	function approve(address _spender, uint256 value) public returns (bool);
24 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
25 	function allowance(address _owner, address _spender) constant returns (uint remaining);
26 	event Transfer(address indexed _from, address indexed _to, uint _value);
27 	event Approval(address indexed _owner, address indexed _spender, uint _value);
28 }
29 
30 contract Distribute {
31 
32 	// The ICO token address
33     ERC20 public token = ERC20(0x8f8221afbb33998d8584a2b05749ba73c37a938a); // REQ
34 
35 	// ETH to token exchange rate (in tokens)
36 	uint public ethToTokenRate = 6666; // REQ tokens  THIS RATE WILL LEAVE 2680 TOKENS BEHIND
37 
38 	// ICO multisig address
39 	address public multisig = 0x7614bA4b95Cc4F456CAE349B94B8a6992d4818EA; // REQ Multisig
40 
41 	// Tokens to withhold per person (to cover gas costs)  // SEE ABOVE
42 	uint public withhold = 0;  // NOT USED WITH REQ, SEE ABOVE
43 
44 	// Payees
45 	struct Payee {
46 		address addr;
47 		uint contributionWei;
48 		bool paid;
49 	}
50 
51 	Payee[] public payees;
52 
53 	address[] public admins;
54 
55 	// Token decimal multiplier - 18 decimals
56 	uint public tokenMultiplier = 1000000000000000000;
57 
58 	// ETH to wei
59 	uint public ethToWei = 1000000000000000000;
60 
61 	// Has withdrawal function been deployed to distribute tokens?
62 	bool public withdrawalDeployed = false;
63 
64 
65 	function Distribute() public {
66 		//--------------------------ADMINS--------------------------//
67 		admins.push(msg.sender);
68 		admins.push(0x008bEd0B3e3a7E7122D458312bBf47B198D58A48); // Matt
69 		admins.push(0x006501524133105eF4C679c40c7df9BeFf8B0FED); // Mick
70 		admins.push(0xed4aEddAaEDA94a7617B2C9D4CBF9a9eDC781573); // Marcelo
71 		admins.push(0xff4C40e273b4fAB581428455b1148352D13CCbf1); // CptTek
72 
73 		// ------------------------- PAYEES ----------------------- //
74 		payees.push(Payee({addr:0x87d9342b59734fa3cc54ef9be44a6cb469d8f477, contributionWei:250000000000000000, paid:false})); // .25 ETH to contract deployer for gas cost
75 		payees.push(Payee({addr:0x4022Ced7511440480311CC4813FB38925e4dC40b, contributionWei:380000000000000000000, paid:false}));
76 		payees.push(Payee({addr:0xaF2017C09a1713A36953232192FdBcd24a483ba6, contributionWei:345000000000000000000, paid:false}));
77 		payees.push(Payee({addr:0x7cBBf0a59Fc47D864a1515aF2aB62d207aa3320D, contributionWei:320000000000000000000, paid:false}));
78 		payees.push(Payee({addr:0x002ecfdA4147e48717cbE6810F261358bDAcC6b5, contributionWei:255000000000000000000, paid:false}));
79 		payees.push(Payee({addr:0xA4f8506E30991434204BC43975079aD93C8C5651, contributionWei:300000000000000000000, paid:false}));
80 		payees.push(Payee({addr:0xFf651EAD42b8EeA0B9cB88EDc92704ef6af372Ce, contributionWei:250000000000000000000, paid:false}));
81 		payees.push(Payee({addr:0xb603bade19edcd95a780151a694e8e57c15a066b, contributionWei:226500000000000000000, paid:false}));
82 		payees.push(Payee({addr:0xf41Dcd2a852eC72440426EA70EA686E8b67e4922, contributionWei:175000000000000000000, paid:false}));
83 		payees.push(Payee({addr:0x4d308C991859D59fA9086ad18cBdD9c4534C9FCd, contributionWei:90000000000000000000, paid:false}));
84 		payees.push(Payee({addr:0x20A2F38c02a27292afEc7C90609e5Bd413Ab4DD9, contributionWei:120000000000000000000, paid:false}));
85 		payees.push(Payee({addr:0x0466A804c880Cd5F225486A5D0f556be25B6fCC8, contributionWei:100000000000000000000, paid:false}));
86 		payees.push(Payee({addr:0xa722F9F5D744D508C155fCEb9245CA57B5D13Bb5, contributionWei:100000000000000000000, paid:false}));
87 		payees.push(Payee({addr:0x572a26bF9358c099CC2FB0Be9c8B99499acA42C5, contributionWei:100000000000000000000, paid:false}));
88 		payees.push(Payee({addr:0x7C73b0A08eBb4E4C4CdcE5f469E0Ec4E8C788D84, contributionWei:100000000000000000000, paid:false}));
89 		payees.push(Payee({addr:0x00B15358eE23E65ad02F07Bd66FB556c21C6b613, contributionWei:38000000000000000000, paid:false}));
90 		payees.push(Payee({addr:0xFB6c8369065b834d8907406feAe7D331c0e77e07, contributionWei:80000000000000000000, paid:false}));
91 		payees.push(Payee({addr:0x46cCc6b127D6d4d04080Da2D3bb5Fa9Fb294708a, contributionWei:50000000000000000000, paid:false}));
92 		payees.push(Payee({addr:0xc51fda81966704aD304a4D733a0306CB1ea76729, contributionWei:50000000000000000000, paid:false}));
93 		payees.push(Payee({addr:0x000354015865e6A7F83B8973418c9a0CF6B6DA3C, contributionWei:50000000000000000000, paid:false}));
94 		payees.push(Payee({addr:0x1240Cd12B3A0F324272d729613473A5Aed241607, contributionWei:50000000000000000000, paid:false}));
95 		payees.push(Payee({addr:0xfBFcb29Ff159a686d2A0A3992E794A3660EAeFE4, contributionWei:35000000000000000000, paid:false}));
96 		payees.push(Payee({addr:0x87d9342b59734fa3cc54ef9be44a6cb469d8f477, contributionWei:50000000000000000000, paid:false}));
97 		payees.push(Payee({addr:0x00505d0a66a0646c85095bbfd75f57c4e1c431ba, contributionWei:30000000000000000000, paid:false}));
98 		payees.push(Payee({addr:0xBAB1033f57B5a4DdD009dd7cdB601b49ed5c0F58, contributionWei:30000000000000000000, paid:false}));
99 		payees.push(Payee({addr:0x7993d82DCaaE05f60576AbA0F386994AebdEd764, contributionWei:30000000000000000000, paid:false}));
100 		payees.push(Payee({addr:0x00566011c133ccBD50aB7088DFA1434e31e42946, contributionWei:30000000000000000000, paid:false}));
101 		payees.push(Payee({addr:0xacedc52037D18C39f38E5A3A78a80e32ffFA34D3, contributionWei:25000000000000000000, paid:false}));
102 		payees.push(Payee({addr:0x0AC776c3109f673B9737Ca1b208B20084cf931B8, contributionWei:25000000000000000000, paid:false}));
103 		payees.push(Payee({addr:0x22aAE1D3CaEbAAbAbe90016fCaDe68652414B0e0, contributionWei:25000000000000000000, paid:false}));
104 		payees.push(Payee({addr:0xaA03d7f016216f723ddDdE3A5A18e9F640766a5a, contributionWei:20000000000000000000, paid:false}));
105 		payees.push(Payee({addr:0xbC306679FC4c3f51D91b1e8a55aEa3461675da18, contributionWei:20000000000000000000, paid:false}));
106 		payees.push(Payee({addr:0xBd59bB57dCa0ca22C5FcFb26A6EAaf64451bfB68, contributionWei:20000000000000000000, paid:false}));
107 		payees.push(Payee({addr:0x8dCd6294cE580bc6D17304a0a5023289dffED7d6, contributionWei:30000000000000000000, paid:false}));
108 		payees.push(Payee({addr:0xfBfE2A528067B1bb50B926D79e8575154C1dC961, contributionWei:20000000000000000000, paid:false}));
109 		payees.push(Payee({addr:0x7f37dBD0D06A1ba82Ec7C6002C54A46252d22704, contributionWei:20000000000000000000, paid:false}));
110 		payees.push(Payee({addr:0x0DEf032533Cf84020D12C6dDB007128a2C77d775, contributionWei:30000000000000000000, paid:false}));
111 		payees.push(Payee({addr:0x2c1f43348d4bDFFdA271bD2b8Bae04f3d3542DAE, contributionWei:20000000000000000000, paid:false}));
112 		payees.push(Payee({addr:0x9793661F48b61D0b8B6D39D53CAe694b101ff028, contributionWei:20000000000000000000, paid:false}));
113 		payees.push(Payee({addr:0x907F6fB76D13Fa7244851Ee390DfE9c6B2135ec5, contributionWei:30000000000000000000, paid:false}));
114 		payees.push(Payee({addr:0xecc996953e976a305ee585a9c7bbbcc85d1c467b, contributionWei:10000000000000000000, paid:false}));
115 		payees.push(Payee({addr:0x491b972AC0E1B26ca9F382493Ce26a8c458a6Ca5, contributionWei:19000000000000000000, paid:false}));
116 		payees.push(Payee({addr:0xf8b189786bc4a7d595eb6c4d0a43a2b4b0251c33, contributionWei:35500000000000000000, paid:false}));
117 		payees.push(Payee({addr:0xe204f47c00bf581d3673b194ac2b1d29950d6ad3, contributionWei:7000000000000000000, paid:false}));
118 		payees.push(Payee({addr:0xecFe6c6676a25Ee86f2B717011AA52394d43E17a, contributionWei:20000000000000000000, paid:false}));
119 		payees.push(Payee({addr:0xFDF13343F1E3626491066563aB6D787b9755cc17, contributionWei:10000000000000000000, paid:false}));
120 		payees.push(Payee({addr:0x2a7B8545c9f66e82Ac8237D47a609f0cb884C3cE, contributionWei:10000000000000000000, paid:false}));
121 		payees.push(Payee({addr:0x7166C092902A0345d9124d90C7FeA75450E3e5b6, contributionWei:10000000000000000000, paid:false}));
122 		payees.push(Payee({addr:0xCAAd07A7712f720977660447463465a56543c681, contributionWei:10000000000000000000, paid:false}));
123 		payees.push(Payee({addr:0xd71932c505bEeb85e488182bCc07471a8CFa93Cb, contributionWei:20000000000000000000, paid:false}));
124 		payees.push(Payee({addr:0x044a9c43e95AA9FD28EEa25131A62b602D304F1f, contributionWei:10000000000000000000, paid:false}));
125 		payees.push(Payee({addr:0x5fbDE96c736be83bE859d3607FC96D963033E611, contributionWei:10000000000000000000, paid:false}));
126 		payees.push(Payee({addr:0x78d4F243a7F6368f1684C85eDBAC6F2C344B7739, contributionWei:10000000000000000000, paid:false}));
127 		payees.push(Payee({addr:0x8d4f315df4860758E559d63734BD96Fd3C9f86d8, contributionWei:10000000000000000000, paid:false}));
128 		payees.push(Payee({addr:0x2FdEfc1c8F299E378473999707aA5eA7c8639af3, contributionWei:20000000000000000000, paid:false}));
129 		payees.push(Payee({addr:0x9e7De6F979a72908a0Be23429433813D8bC94a83, contributionWei:5000000000000000000, paid:false}));
130 		payees.push(Payee({addr:0x3B55d9401C0e027ECF9DDe39CFeb799a70D038da, contributionWei:5000000000000000000, paid:false}));
131 		payees.push(Payee({addr:0x867D6B56809D4545A7F53E1d4faBE9086FDeb60B, contributionWei:5000000000000000000, paid:false}));
132 		payees.push(Payee({addr:0x7610d0ee9aca8065b69d9d3b7aa37d47f0be145a, contributionWei:3000000000000000000, paid:false}));
133 		payees.push(Payee({addr:0xb922C4e953F85972702af982A0a14e24867C7f8d, contributionWei:2000000000000000000, paid:false}));
134 		payees.push(Payee({addr:0xE2Ae58AFecF6195D51DA29250f8Db4C8F3222440, contributionWei:26000000000000000000, paid:false}));
135 		payees.push(Payee({addr:0xb124201d3bf7ba775552fda1b2b5d8d6a16d8aad, contributionWei:50000000000000000000, paid:false}));
136 		payees.push(Payee({addr:0x4709a3a7b4A0e646e9953459c66913322b8f4195, contributionWei:3000000000000000000, paid:false}));
137 	}
138 
139 	// Check if user is whitelisted admin
140 	modifier onlyAdmins() {
141 		uint8 isAdmin = 0;
142 		for (uint8 i = 0; i < admins.length; i++) {
143 			if (admins[i] == msg.sender)
144         isAdmin = isAdmin | 1;
145 		}
146 		require(isAdmin == 1);
147 		_;
148 	}
149 
150 	// Calculate tokens due
151 	function tokensDue(uint _contributionWei) public view returns (uint) {
152 		return _contributionWei*ethToTokenRate/ethToWei;
153 	}
154 
155 	// Allow admins to change token contract address, in case the wrong token ends up in this contract
156 	function changeToken(address _token) public onlyAdmins {
157 		token = ERC20(_token);
158 	}
159 
160 	// Withdraw all tokens to contributing members
161 	function withdrawAll() public onlyAdmins {
162 		// Prevent withdrawal function from being called simultaneously by two parties
163 		require(withdrawalDeployed == false);
164 		// Confirm sufficient tokens available
165 		require(validate());
166 		withdrawalDeployed = true;
167 		// Send all tokens
168 		for (uint i = 0; i < payees.length; i++) {
169 			// Confirm that contributor has not yet been paid is owed more than gas withhold
170 			if (payees[i].paid == false && tokensDue(payees[i].contributionWei) >= withhold) {
171 				// Withhold tokens to cover gas cost
172 				uint tokensToSend = tokensDue(payees[i].contributionWei) - withhold;
173 				// Send tokens to payee
174 				require(token.transferFrom(multisig,payees[i].addr, tokensToSend*tokenMultiplier));
175 				// Mark payee as paid
176 				payees[i].paid = true;
177 			}
178 		}
179 	}
180 
181 	// Confirms that enough tokens are available to distribute to all addresses
182 	function validate() public view returns (bool) {
183 		// Calculate total tokens due to all contributors
184 		uint totalTokensDue = 0;
185 		for (uint i = 0; i < payees.length; i++) {
186 			if (!payees[i].paid) {
187 				// Calculate tokens based on ETH contribution
188 				totalTokensDue += tokensDue(payees[i].contributionWei)*tokenMultiplier;
189 			}
190 		}
191 		return token.balanceOf(multisig) >= totalTokensDue && token.allowance(multisig,address(this)) >= totalTokensDue;
192 	}
193 
194   
195 	// Return all ETH and tokens to original multisig
196 	function returnToSender() public onlyAdmins returns (bool) {
197 		require(token.transfer(multisig, token.balanceOf(address(this))));
198 		require(multisig.send(this.balance));
199 		return true;
200 	}
201 
202 	// Return all ETH and tokens to original multisig and then suicide
203 	function abort() public onlyAdmins {
204 		require(returnToSender());
205 		selfdestruct(multisig);
206 	}
207 
208 
209 }