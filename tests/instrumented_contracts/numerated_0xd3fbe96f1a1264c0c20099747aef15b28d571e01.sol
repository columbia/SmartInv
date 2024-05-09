1 pragma solidity ^0.4.11;
2 
3 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
4 contract ERC20 {
5 	function transfer(address _to, uint _value) returns (bool success);
6 	function balanceOf(address _owner) constant returns (uint balance);
7 	function approve(address _spender, uint256 value) public returns (bool);
8 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract Distribute {
15 
16 	// The ICO token address
17     ERC20 public token = ERC20(0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27); // ZIL   
18 
19 	// ETH to token exchange rate (in tokens)
20 	uint public ethToTokenRate = 129857; // ZIL Tokens
21 
22 	// ICO multisig address
23 	address public multisig = 0x91e65a0e5ff0F0E8fBA65F3636a7cd74f4c9f0E2; // ZIL Wallet
24 
25 	// Tokens to withhold per person (to cover gas costs)  // SEE ABOVE
26 	uint public withhold = 0;  // NOT USED WITH ZIL, SEE ABOVE
27 
28 	// Payees
29 	struct Payee {
30 		address addr;
31 		uint contributionWei;
32 		bool paid;
33 	}
34 
35 	Payee[] public payees;
36 
37 	address[] public admins;
38 
39 	// Token decimal multiplier - 12 decimals
40 	uint public tokenMultiplier = 1000000000000;
41 
42 	// ETH to wei
43 	uint public ethToWei = 1000000000000000000;
44 
45 	// Has withdrawal function been deployed to distribute tokens?
46 	bool public withdrawalDeployed = false;
47 
48 
49 	function Distribute() public {
50 		//--------------------------ADMINS--------------------------//
51 		
52 		admins.push(msg.sender);
53 		admins.push(0x91e65a0e5ff0F0E8fBA65F3636a7cd74f4c9f0E2);
54 
55 		// ------------------------- PAYEES ----------------------- //
56 
57 		payees.push(Payee({addr:0x9e7De6F979a72908a0Be23429433813D8bC94a83, contributionWei:40000000000000000000, paid:false}));		
58 		payees.push(Payee({addr:0xEA8356f5e9B8206EaCDc3176B2AfEcB4F44DD1b8, contributionWei:40000000000000000000, paid:false}));		
59 		payees.push(Payee({addr:0x739EB2b1eF52dF7eb8666D70b1608118AF8c2e30, contributionWei:40000000000000000000, paid:false}));		
60 		payees.push(Payee({addr:0xb72b7B33Af65CF47785D70b02c7E896482b77205, contributionWei:40000000000000000000, paid:false}));		
61 		payees.push(Payee({addr:0x491b972AC0E1B26ca9F382493Ce26a8c458a6Ca5, contributionWei:37000000000000000000, paid:false}));		
62 		payees.push(Payee({addr:0xfBFcb29Ff159a686d2A0A3992E794A3660EAeFE4, contributionWei:30000000000000000000, paid:false}));		
63 		payees.push(Payee({addr:0xBAB1033f57B5a4DdD009dd7cdB601b49ed5c0F58, contributionWei:30000000000000000000, paid:false}));		
64 		payees.push(Payee({addr:0xecc996953e976a305ee585a9c7bbbcc85d1c467b, contributionWei:30000000000000000000, paid:false}));		
65 		payees.push(Payee({addr:0x5BF688EEb7857748CdD99d269DFa08B3f56f900B, contributionWei:30000000000000000000, paid:false}));		
66 		payees.push(Payee({addr:0x0eD760957da606b721D4E68238392a2EB03B940B, contributionWei:30000000000000000000, paid:false}));		
67 		payees.push(Payee({addr:0xfa97c22a03d8522988c709c24283c0918a59c795, contributionWei:30000000000000000000, paid:false}));		
68 		payees.push(Payee({addr:0x0AC776c3109f673B9737Ca1b208B20084cf931B8, contributionWei:25000000000000000000, paid:false}));		
69 		payees.push(Payee({addr:0xF1BB2d74C9A0ad3c6478A3b87B417132509f673F, contributionWei:25000000000000000000, paid:false}));		
70 		payees.push(Payee({addr:0xd71932c505beeb85e488182bcc07471a8cfa93cb, contributionWei:25000000000000000000, paid:false}));		
71 		payees.push(Payee({addr:0xfBfE2A528067B1bb50B926D79e8575154C1dC961, contributionWei:25000000000000000000, paid:false}));		
72 		payees.push(Payee({addr:0xe6c769559926F615CFe6bac952e28A40525c9CF6, contributionWei:22000000000000000000, paid:false}));		
73 		payees.push(Payee({addr:0x6944bd031a455eF1db6f3b3761290D8200245f64, contributionWei:21000000000000000000, paid:false}));		
74 		payees.push(Payee({addr:0xacedc52037D18C39f38E5A3A78a80e32ffFA34D3, contributionWei:20000000000000000000, paid:false}));		
75 		payees.push(Payee({addr:0xeC6CAF005C7b8Db6b51dAf125443a6bCe292dFc3, contributionWei:20000000000000000000, paid:false}));		
76 		payees.push(Payee({addr:0xe204f47c00bf581d3673b194ac2b1d29950d6ad3, contributionWei:20000000000000000000, paid:false}));		
77 		payees.push(Payee({addr:0xf41Dcd2a852eC72440426EA70EA686E8b67e4922, contributionWei:20000000000000000000, paid:false}));		
78 		payees.push(Payee({addr:0x589bD9824EA125BF59a76A6CB79468336955dCEa, contributionWei:20000000000000000000, paid:false}));		
79 		payees.push(Payee({addr:0x1240Cd12B3A0F324272d729613473A5Aed241607, contributionWei:20000000000000000000, paid:false}));		
80 		payees.push(Payee({addr:0xdD7194415d1095916aa54a301d954A9a82c591EC, contributionWei:20000000000000000000, paid:false}));		
81 		payees.push(Payee({addr:0xce38acf94281f16259a1eee2a4f61ccc537296ff, contributionWei:20000000000000000000, paid:false}));		
82 		payees.push(Payee({addr:0xD291Cd1ad826eF30D40aA44799b5BA6F33cC26de, contributionWei:15000000000000000000, paid:false}));		
83 		payees.push(Payee({addr:0x7166C092902A0345d9124d90C7FeA75450E3e5b6, contributionWei:15000000000000000000, paid:false}));		
84 		payees.push(Payee({addr:0xbbe343ED0E7823F4E0F3420D20c6Eb9789c14AD8, contributionWei:15000000000000000000, paid:false}));		
85 		payees.push(Payee({addr:0xDC95764e664AA9f3E090494989231BD2486F5de0, contributionWei:15000000000000000000, paid:false}));		
86 		payees.push(Payee({addr:0xA664beecd0e6E04EE48f5B4Fb5183bd548b4A912, contributionWei:15000000000000000000, paid:false}));		
87 		payees.push(Payee({addr:0x00D7b44598E95Abf195e4276f42a3e07F9D130E3, contributionWei:15000000000000000000, paid:false}));		
88 		payees.push(Payee({addr:0x48daFCfd4F76d6274039bc1c459E69A6daA434CC, contributionWei:12000000000000000000, paid:false}));		
89 		payees.push(Payee({addr:0xADBD3F608677bEF61958C13Fd6d758bd7A9a25d6, contributionWei:10500000000000000000, paid:false}));		
90 		payees.push(Payee({addr:0x044a9c43e95aa9fd28eea25131a62b602d304f1f, contributionWei:10000000000000000000, paid:false}));		
91 		payees.push(Payee({addr:0x20Ec8fE549CD5978bcCC184EfAeE20027eD0c154, contributionWei:10000000000000000000, paid:false}));		
92 		payees.push(Payee({addr:0xecFe6c6676a25Ee86f2B717011AA52394d43E17a, contributionWei:10000000000000000000, paid:false}));		
93 		payees.push(Payee({addr:0x0D032b245004849D50cd3FF7a84bf9f8057f24F9, contributionWei:10000000000000000000, paid:false}));		
94 		payees.push(Payee({addr:0x64CD180d8382b153e3acb6218c54b498819D3905, contributionWei:10000000000000000000, paid:false}));		
95 		payees.push(Payee({addr:0x59FD8C50d174d9683DA90A515C30fc4997bDc556, contributionWei:10000000000000000000, paid:false}));		
96 		payees.push(Payee({addr:0x83CA062Ea4a1725B9E7841DFCB1ae342a10d8c1F, contributionWei:6000000000000000000, paid:false}));		
97 		payees.push(Payee({addr:0x2c1f43348d4bDFFdA271bD2b8Bae04f3d3542DAE, contributionWei:5000000000000000000, paid:false}));		
98 		payees.push(Payee({addr:0x78d4F243a7F6368f1684C85eDBAC6F2C344B7739, contributionWei:5000000000000000000, paid:false}));		
99 		payees.push(Payee({addr:0x8d4f315df4860758E559d63734BD96Fd3C9f86d8, contributionWei:5000000000000000000, paid:false}));		
100 		payees.push(Payee({addr:0x0584e184Eb509FA6417371C8A171206658792Da0, contributionWei:2000000000000000000, paid:false}));		
101 		payees.push(Payee({addr:0x861038738e10bA2963F57612179957ec521089cD, contributionWei:1800000000000000000, paid:false}));		
102 		payees.push(Payee({addr:0xCbB913B805033226f2c6b11117251c0FF1A3431D, contributionWei:1000000000000000000, paid:false}));		
103 		payees.push(Payee({addr:0x3E08FC7Cb11366c6E0091fb0fD64E0E5F8190bCa, contributionWei:1000000000000000000, paid:false}));		
104 
105 
106 	}
107 
108 
109 	// Check if user is whitelisted admin
110 	modifier onlyAdmins() {
111 		uint8 isAdmin = 0;
112 		for (uint8 i = 0; i < admins.length; i++) {
113 			if (admins[i] == msg.sender)
114         isAdmin = isAdmin | 1;
115 		}
116 		require(isAdmin == 1);
117 		_;
118 	}
119 
120 	// Calculate tokens due
121 	function tokensDue(uint _contributionWei) public view returns (uint) {
122 		return _contributionWei*ethToTokenRate/ethToWei;
123 	}
124 
125 	// Allow admins to change token contract address, in case the wrong token ends up in this contract
126 	function changeToken(address _token) public onlyAdmins {
127 		token = ERC20(_token);
128 	}
129 
130 	// Withdraw all tokens to contributing members
131 	function withdrawAll() public onlyAdmins {
132 		// Prevent withdrawal function from being called simultaneously by two parties
133 		require(withdrawalDeployed == false);
134 		// Confirm sufficient tokens available
135 		require(validate());
136 		withdrawalDeployed = true;
137 		// Send all tokens
138 		for (uint i = 0; i < payees.length; i++) {
139 			// Confirm that contributor has not yet been paid is owed more than gas withhold
140 			if (payees[i].paid == false && tokensDue(payees[i].contributionWei) >= withhold) {
141 				// Withhold tokens to cover gas cost
142 				uint tokensToSend = tokensDue(payees[i].contributionWei) - withhold;
143 				// Send tokens to payee
144 				require(token.transferFrom(multisig,payees[i].addr, tokensToSend*tokenMultiplier));
145 				// Mark payee as paid
146 				payees[i].paid = true;
147 			}
148 		}
149 	}
150 
151 	// Confirms that enough tokens are available to distribute to all addresses
152 	function validate() public view returns (bool) {
153 		// Calculate total tokens due to all contributors
154 		uint totalTokensDue = 0;
155 		for (uint i = 0; i < payees.length; i++) {
156 			if (!payees[i].paid) {
157 				// Calculate tokens based on ETH contribution
158 				totalTokensDue += tokensDue(payees[i].contributionWei)*tokenMultiplier;
159 			}
160 		}
161 		return token.balanceOf(multisig) >= totalTokensDue && token.allowance(multisig,address(this)) >= totalTokensDue;
162 	}
163 
164   
165 	// Return all ETH and tokens to original multisig
166 	function returnToSender() public onlyAdmins returns (bool) {
167 		require(token.transfer(multisig, token.balanceOf(address(this))));
168 		require(multisig.send(this.balance));
169 		return true;
170 	}
171 
172 	// Return all ETH and tokens to original multisig and then suicide
173 	function abort() public onlyAdmins {
174 		require(returnToSender());
175 		selfdestruct(multisig);
176 	}
177 
178 
179 }