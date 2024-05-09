1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 --------------------
6 Distribute PP Tokens
7 Token: RCN
8 Qty: 12800000
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
33     ERC20 public token = ERC20(0xf970b8e36e23f7fc3fd752eea86f8be8d83375a6); // RCN
34 
35 	// ETH to token exchange rate (in tokens)
36 	uint public ethToTokenRate = 3999; // RCN tokens  THIS RATE WILL LEAVE 3200 TOKENS BEHIND
37 
38 	// ICO multisig address
39 	address public multisig = 0x49a0ffb48c8CBAE349D20df2a7E8e74f6D228804; // RCN Multisig 
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
67 		admins.push(0x8FB9A786BA4670AD13598b01576d247De09C79d1);
68 		admins.push(0x008bEd0B3e3a7E7122D458312bBf47B198D58A48);
69 		admins.push(0x006501524133105eF4C679c40c7df9BeFf8B0FED);
70 		admins.push(0xed4aEddAaEDA94a7617B2C9D4CBF9a9eDC781573);
71 		admins.push(0xff4C40e273b4fAB581428455b1148352D13CCbf1);
72 
73 		// ------------------------- PAYEES ----------------------- //
74 		payees.push(Payee({addr:0x8FB9A786BA4670AD13598b01576d247De09C79d1, contributionWei:500000000000000000, paid:false})); // .5 ETH to contract deployer for gas cost
75 		payees.push(Payee({addr:0xa6E78caa11Ad160c6287a071949bB899a009DafA, contributionWei:90000000000000000000, paid:false}));
76 		payees.push(Payee({addr:0xFDF13343F1E3626491066563aB6D787b9755cc17, contributionWei:20000000000000000000, paid:false}));
77 		payees.push(Payee({addr:0x5F0f119419b528C804C9BbBF15455d36450406B4, contributionWei:400000000000000000000, paid:false}));
78 		payees.push(Payee({addr:0xA534F5b9a5D115563A28FccC5C92ada771da236E, contributionWei:200000000000000000000, paid:false}));
79 		payees.push(Payee({addr:0x3f9265FD0B4f92EEE642703e72d749C077CFfBBB, contributionWei:20000000000000000000, paid:false}));
80 		payees.push(Payee({addr:0xd71932c505bEeb85e488182bCc07471a8CFa93Cb, contributionWei:10000000000000000000, paid:false}));
81 		payees.push(Payee({addr:0x00694C41975E95e435461192aBb86C56A3c2e66f, contributionWei:125000000000000000000, paid:false}));
82 		payees.push(Payee({addr:0x0466A804c880Cd5F225486A5D0f556be25B6fCC8, contributionWei:75000000000000000000, paid:false}));
83 		payees.push(Payee({addr:0x002ecfdA4147e48717cbE6810F261358bDAcC6b5, contributionWei:65500000000000000000, paid:false}));
84 		payees.push(Payee({addr:0x8F212180bF6B8178559a67268502057Fb0043Dd9, contributionWei:30000000000000000000, paid:false}));
85 		payees.push(Payee({addr:0x2a7b8545c9f66e82ac8237d47a609f0cb884c3ce, contributionWei:15000000000000000000, paid:false}));
86 		payees.push(Payee({addr:0x907F6fB76D13Fa7244851Ee390DfE9c6B2135ec5, contributionWei:35000000000000000000, paid:false}));
87 		payees.push(Payee({addr:0xBd59bB57dCa0ca22C5FcFb26A6EAaf64451bfB68, contributionWei:20000000000000000000, paid:false}));
88 		payees.push(Payee({addr:0x491b972AC0E1B26ca9F382493Ce26a8c458a6Ca5, contributionWei:12000000000000000000, paid:false}));
89 		payees.push(Payee({addr:0x63DEFE2bC3567e3309a31b27261fE839Ed35ae3A, contributionWei:10000000000000000000, paid:false}));
90 		payees.push(Payee({addr:0x660E067602dC965F10928B933F21bA6dCb2ece9C, contributionWei:80000000000000000000, paid:false}));
91 		payees.push(Payee({addr:0x00D7b44598E95Abf195e4276f42a3e07F9D130E3, contributionWei:20000000000000000000, paid:false}));
92 		payees.push(Payee({addr:0x4709a3a7b4A0e646e9953459c66913322b8f4195, contributionWei:1000000000000000000, paid:false}));
93 		payees.push(Payee({addr:0xEbf6D2b34DfafC9c9adAed3eca06aC74Ef5afB44, contributionWei:12000000000000000000, paid:false}));
94 		payees.push(Payee({addr:0x7166C092902A0345d9124d90C7FeA75450E3e5b6, contributionWei:5000000000000000000, paid:false}));
95 		payees.push(Payee({addr:0xfeFEaA909C40c40FFa8f1Ad85019496a04636642, contributionWei:10000000000000000000, paid:false}));
96 		payees.push(Payee({addr:0xCbB913B805033226f2c6b11117251c0FF1A3431D, contributionWei:500000000000000000, paid:false}));
97 		payees.push(Payee({addr:0xb922C4e953F85972702af982A0a14e24867C7f8d, contributionWei:6000000000000000000, paid:false}));
98 		payees.push(Payee({addr:0xbD9Fa48f74258AcA384fADebcc0340C74Bd4272B, contributionWei:50000000000000000000, paid:false}));
99 		payees.push(Payee({addr:0xc51fda81966704aD304a4D733a0306CB1ea76729, contributionWei:25000000000000000000, paid:false}));
100 		payees.push(Payee({addr:0x3e638AE8AAc0dB1DfF2f36C399A4621DB064d43a, contributionWei:40000000000000000000, paid:false}));
101 		payees.push(Payee({addr:0x47e48c958628670469c7E67aeb276212015B26fe, contributionWei:20000000000000000000, paid:false}));
102 		payees.push(Payee({addr:0xe204f47c00bf581d3673b194ac2b1d29950d6ad3, contributionWei:12500000000000000000, paid:false}));
103 		payees.push(Payee({addr:0xBd042914c93361E248a56db78403E99ef01a1c14, contributionWei:5000000000000000000, paid:false}));
104 		payees.push(Payee({addr:0x85591bFABB18Be044fA98D72F7093469C588483C, contributionWei:20000000000000000000, paid:false}));
105 		payees.push(Payee({addr:0xa722F9F5D744D508C155fCEb9245CA57B5D13Bb5, contributionWei:21000000000000000000, paid:false}));
106 		payees.push(Payee({addr:0xfBfE2A528067B1bb50B926D79e8575154C1dC961, contributionWei:10000000000000000000, paid:false}));
107 		payees.push(Payee({addr:0x48daFCfd4F76d6274039bc1c459E69A6daA434CC, contributionWei:5000000000000000000, paid:false}));
108 		payees.push(Payee({addr:0x20A2F38c02a27292afEc7C90609e5Bd413Ab4DD9, contributionWei:250000000000000000000, paid:false}));
109 		payees.push(Payee({addr:0x004F444c88EE2ef4120f5F0CE460E6df64FC5E7d, contributionWei:25000000000000000000, paid:false}));
110 		payees.push(Payee({addr:0xBAB1033f57B5a4DdD009dd7cdB601b49ed5c0F58, contributionWei:20000000000000000000, paid:false}));
111 		payees.push(Payee({addr:0x87D9342B59734fA3cC54ef9BE44A6cB469d8F477, contributionWei:10000000000000000000, paid:false}));
112 		payees.push(Payee({addr:0x00505D0a66A0646c85095bBFd75f57c4e1C431ba, contributionWei:30000000000000000000, paid:false}));
113 		payees.push(Payee({addr:0x8f8Ce7C2Ae0860F7F12C613FD85CC82ba292F6eB, contributionWei:10000000000000000000, paid:false}));
114 		payees.push(Payee({addr:0xfBFcb29Ff159a686d2A0A3992E794A3660EAeFE4, contributionWei:25000000000000000000, paid:false}));
115 		payees.push(Payee({addr:0xF69819E5cAdB4b08ef2b905dF3eC6bD5F5b1a985, contributionWei:60000000000000000000, paid:false}));
116 		payees.push(Payee({addr:0xd20718bbE781951CaEA1FaE92f922E6Ddbde529A, contributionWei:25000000000000000000, paid:false}));
117 		payees.push(Payee({addr:0x592b8b0623b2EC93C82034f34D0B554bb56E19D3, contributionWei:25000000000000000000, paid:false}));
118 		payees.push(Payee({addr:0x5fbDE96c736be83bE859d3607FC96D963033E611, contributionWei:5000000000000000000, paid:false}));
119 		payees.push(Payee({addr:0x296b436529DC64C03E9cEB77F032a04071D6c057, contributionWei:200000000000000000000, paid:false}));
120 		payees.push(Payee({addr:0x1C7D8c0131680fFAdcD336e56CF014427B5D9d11, contributionWei:5000000000000000000, paid:false}));
121 		payees.push(Payee({addr:0x808264eeb886d37b706C8e07172d5FdF40dF71A8, contributionWei:3000000000000000000, paid:false}));
122 		payees.push(Payee({addr:0x0b6DF62a52e9c60f07fc8B4d4F90Cab716367fb7, contributionWei:60000000000000000000, paid:false}));
123 		payees.push(Payee({addr:0xFB6c8369065b834d8907406feAe7D331c0e77e07, contributionWei:10000000000000000000, paid:false}));
124 		payees.push(Payee({addr:0x044a9c43e95AA9FD28EEa25131A62b602D304F1f, contributionWei:5000000000000000000, paid:false}));
125 		payees.push(Payee({addr:0x82e4D78C6c62D461251fA5A1D4Deb9F0fE378E30, contributionWei:80000000000000000000, paid:false}));
126 		payees.push(Payee({addr:0x22aAE1D3CaEbAAbAbe90016fCaDe68652414B0e0, contributionWei:20000000000000000000, paid:false}));
127 		payees.push(Payee({addr:0x0584e184Eb509FA6417371C8A171206658792Da0, contributionWei:75000000000000000000, paid:false}));
128 		payees.push(Payee({addr:0x8dCd6294cE580bc6D17304a0a5023289dffED7d6, contributionWei:50000000000000000000, paid:false}));
129 		payees.push(Payee({addr:0x00d59B233818867D15E36A66d5EC30788c78BfB8, contributionWei:500000000000000000000, paid:false}));
130 		payees.push(Payee({addr:0x78d4F243a7F6368f1684C85eDBAC6F2C344B7739, contributionWei:5000000000000000000, paid:false}));
131 		payees.push(Payee({addr:0xcE38Acf94281F16259a1Eee2A4F61ccC537296FF, contributionWei:20000000000000000000, paid:false}));
132 		payees.push(Payee({addr:0xDC95764e664AA9f3E090494989231BD2486F5de0, contributionWei:8000000000000000000, paid:false}));
133 		payees.push(Payee({addr:0x8Ce48629Ac1d65E97e94C3c8ba0667Dcf49C73D9, contributionWei:10000000000000000000, paid:false}));
134 		payees.push(Payee({addr:0x0007216e1eBC0E02B7A45448bECA6e3faA6E4694, contributionWei:25000000000000000000, paid:false}));
135 		payees.push(Payee({addr:0xbc43C8118dAaA128B71fD473154c335a1E7a0d77, contributionWei:150000000000000000000, paid:false}));
136 		payees.push(Payee({addr:0x46ccc6b127d6d4d04080da2d3bb5fa9fb294708a, contributionWei:15500000000000000000, paid:false}));
137 		payees.push(Payee({addr:0x9e7De6F979a72908a0Be23429433813D8bC94a83, contributionWei:3000000000000000000, paid:false}));
138 	}
139 
140 	// Check if user is whitelisted admin
141 	modifier onlyAdmins() {
142 		uint8 isAdmin = 0;
143 		for (uint8 i = 0; i < admins.length; i++) {
144 			if (admins[i] == msg.sender)
145         isAdmin = isAdmin | 1;
146 		}
147 		require(isAdmin == 1);
148 		_;
149 	}
150 
151 	// Calculate tokens due
152 	function tokensDue(uint _contributionWei) public view returns (uint) {
153 		return _contributionWei*ethToTokenRate/ethToWei;
154 	}
155 
156 	// Allow admins to change token contract address, in case the wrong token ends up in this contract
157 	function changeToken(address _token) public onlyAdmins {
158 		token = ERC20(_token);
159 	}
160 
161 	// Withdraw all tokens to contributing members
162 	function withdrawAll() public onlyAdmins {
163 		// Prevent withdrawal function from being called simultaneously by two parties
164 		require(withdrawalDeployed == false);
165 		// Confirm sufficient tokens available
166 		require(validate());
167 		withdrawalDeployed = true;
168 		// Send all tokens
169 		for (uint i = 0; i < payees.length; i++) {
170 			// Confirm that contributor has not yet been paid is owed more than gas withhold
171 			if (payees[i].paid == false && tokensDue(payees[i].contributionWei) >= withhold) {
172 				// Withhold tokens to cover gas cost
173 				uint tokensToSend = tokensDue(payees[i].contributionWei) - withhold;
174 				// Send tokens to payee
175 				require(token.transferFrom(multisig,payees[i].addr, tokensToSend*tokenMultiplier));
176 				// Mark payee as paid
177 				payees[i].paid = true;
178 			}
179 		}
180 	}
181 
182 	// Confirms that enough tokens are available to distribute to all addresses
183 	function validate() public view returns (bool) {
184 		// Calculate total tokens due to all contributors
185 		uint totalTokensDue = 0;
186 		for (uint i = 0; i < payees.length; i++) {
187 			if (!payees[i].paid) {
188 				// Calculate tokens based on ETH contribution
189 				totalTokensDue += tokensDue(payees[i].contributionWei)*tokenMultiplier;
190 			}
191 		}
192 		return token.balanceOf(multisig) >= totalTokensDue && token.allowance(multisig,address(this)) >= totalTokensDue;
193 	}
194 
195   
196 	// Return all ETH and tokens to original multisig
197 	function returnToSender() public onlyAdmins returns (bool) {
198 		require(token.transfer(multisig, token.balanceOf(address(this))));
199 		require(multisig.send(this.balance));
200 		return true;
201 	}
202 
203 	// Return all ETH and tokens to original multisig and then suicide
204 	function abort() public onlyAdmins {
205 		require(returnToSender());
206 		selfdestruct(multisig);
207 	}
208 
209 
210 }