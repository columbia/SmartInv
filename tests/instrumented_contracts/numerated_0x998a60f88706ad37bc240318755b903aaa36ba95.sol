1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 --------------------
6 Distribute PP Tokens
7 Token: AION
8 Qty: 520000
9 --------------------
10 METHODS:
11 tokenTest() -- Sends 1 token to the multisig address
12 withdrawAll() -- Withdraws tokens to all payee addresses, withholding a quantity for gas cost
13 changeToken(address _token) -- Changes ERC20 token contract address
14 returnToSender() -- Returns all tokens and ETH to the multisig address
15 abort() -- Returns all tokens and ETH to the multisig address, then suicides
16 --------------------
17 
18 */
19 
20 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
21 contract ERC20 {
22 	function transfer(address _to, uint _value) returns (bool success);
23 	function balanceOf(address _owner) constant returns (uint balance);
24 }
25 
26 contract Distribute {
27 
28 	// The ICO token address
29 	ERC20 public token = ERC20(0x4CEdA7906a5Ed2179785Cd3A40A69ee8bc99C466); // AION
30 
31 	// ETH to token exchange rate (in tokens)
32 	uint public ethToTokenRate = 584; // AION tokens  THIS RATE WILL LEAVE APPROX 500 TOKENS BEHIND
33 
34 	// ICO multisig address
35 	address public multisig = 0x0d6C24d85680a89152012F9dC81e406183489C1F; // AION multisig
36 
37 	// Tokens to withhold per person (to cover gas costs)  // SEE ABOVE
38 	uint public withhold = 0;  // NOT USED WITH AION, SEE ABOVE
39 
40 	// Payees
41 	struct Payee {
42 		address addr;
43 		uint contributionWei;
44 		bool paid;
45 	}
46 
47 	Payee[] public payees;
48 
49 	address[] public admins;
50 
51 	// Token decimal multiplier - 8 decimals
52 	uint public tokenMultiplier = 100000000;
53 
54 	// ETH to wei
55 	uint public ethToWei = 1000000000000000000;
56 
57 	// Has withdrawal function been deployed to distribute tokens?
58 	bool public withdrawalDeployed = false;
59 
60 
61 	function Distribute() public {
62 		//--------------------------ADMINS--------------------------//
63 		admins.push(msg.sender);
64 		admins.push(0x008bEd0B3e3a7E7122D458312bBf47B198D58A48); // Matt
65 		admins.push(0x006501524133105eF4C679c40c7df9BeFf8B0FED); // Mick
66 		admins.push(0xed4aEddAaEDA94a7617B2C9D4CBF9a9eDC781573); // Marcelo
67 		admins.push(0xff4C40e273b4fAB581428455b1148352D13CCbf1); // CptTek
68 
69 		// ------------------------- PAYEES ----------------------- //
70 		payees.push(Payee({addr:0x87d9342b59734fa3cc54ef9be44a6cb469d8f477, contributionWei:150000000000000000, paid:false})); // .15 ETH to contract deployer for gas cost
71 		payees.push(Payee({addr:0xA4f8506E30991434204BC43975079aD93C8C5651, contributionWei:87599000000000000000, paid:false}));
72 		payees.push(Payee({addr:0x5F0f119419b528C804C9BbBF15455d36450406B4, contributionWei:87599000000000000000, paid:false}));
73 		payees.push(Payee({addr:0xFf651EAD42b8EeA0B9cB88EDc92704ef6af372Ce, contributionWei:87599000000000000000, paid:false}));
74 		payees.push(Payee({addr:0x20A2F38c02a27292afEc7C90609e5Bd413Ab4DD9, contributionWei:87599000000000000000, paid:false}));
75 		payees.push(Payee({addr:0x00072ece87cb5f6582f557634f3a82adc5ce5db2, contributionWei:25000000000000000000, paid:false}));
76 		payees.push(Payee({addr:0x8dCd6294cE580bc6D17304a0a5023289dffED7d6, contributionWei:50000000000000000000, paid:false}));
77 		payees.push(Payee({addr:0xA534F5b9a5D115563A28FccC5C92ada771da236E, contributionWei:38000000000000000000, paid:false}));
78 		payees.push(Payee({addr:0x660E067602dC965F10928B933F21bA6dCb2ece9C, contributionWei:23000000000000000000, paid:false}));
79 		payees.push(Payee({addr:0xfBFcb29Ff159a686d2A0A3992E794A3660EAeFE4, contributionWei:23000000000000000000, paid:false}));
80 		payees.push(Payee({addr:0x9ebab12563968d8255f546831ec4833449234fFa, contributionWei:23000000000000000000, paid:false}));
81 		payees.push(Payee({addr:0x002ecfdA4147e48717cbE6810F261358bDAcC6b5, contributionWei:23000000000000000000, paid:false}));
82 		payees.push(Payee({addr:0x46cCc6b127D6d4d04080Da2D3bb5Fa9Fb294708a, contributionWei:23000000000000000000, paid:false}));
83 		payees.push(Payee({addr:0x0b6DF62a52e9c60f07fc8B4d4F90Cab716367fb7, contributionWei:23000000000000000000, paid:false}));
84 		payees.push(Payee({addr:0x0584e184Eb509FA6417371C8A171206658792Da0, contributionWei:20000000000000000000, paid:false}));
85 		payees.push(Payee({addr:0x82e4D78C6c62D461251fA5A1D4Deb9F0fE378E30, contributionWei:20000000000000000000, paid:false}));
86 		payees.push(Payee({addr:0xbC306679FC4c3f51D91b1e8a55aEa3461675da18, contributionWei:20000000000000000000, paid:false}));
87 		payees.push(Payee({addr:0xa6e78caa11ad160c6287a071949bb899a009dafa, contributionWei:15100000000000000000, paid:false}));
88 		payees.push(Payee({addr:0x5fbDE96c736be83bE859d3607FC96D963033E611, contributionWei:15000000000000000000, paid:false}));
89 		payees.push(Payee({addr:0x7993d82DCaaE05f60576AbA0F386994AebdEd764, contributionWei:15000000000000000000, paid:false}));
90 		payees.push(Payee({addr:0xd594b781901838649950A79d07429CA187Ec5888, contributionWei:15000000000000000000, paid:false}));
91 		payees.push(Payee({addr:0x85591bFABB18Be044fA98D72F7093469C588483C, contributionWei:15000000000000000000, paid:false}));
92 		payees.push(Payee({addr:0x8F212180bF6B8178559a67268502057Fb0043Dd9, contributionWei:10000000000000000000, paid:false}));
93 		payees.push(Payee({addr:0x907F6fB76D13Fa7244851Ee390DfE9c6B2135ec5, contributionWei:15000000000000000000, paid:false}));
94 		payees.push(Payee({addr:0x82e4ad6af565598e5af655c941d4d8995f9783db, contributionWei:15000000000000000000, paid:false}));
95 		payees.push(Payee({addr:0xE751721F1C79e3e24C6c134a7C77c099de9d412a, contributionWei:10000000000000000000, paid:false}));
96 		payees.push(Payee({addr:0x491b972AC0E1B26ca9F382493Ce26a8c458a6Ca5, contributionWei:15000000000000000000, paid:false}));
97 		payees.push(Payee({addr:0x47e48c958628670469c7E67aeb276212015B26fe, contributionWei:10000000000000000000, paid:false}));
98 		payees.push(Payee({addr:0xF1EA52AC3B0998B76e2DB8394f91224c06BEEf1c, contributionWei:10000000000000000000, paid:false}));
99 		payees.push(Payee({addr:0xd71932c505beeb85e488182bcc07471a8cfa93cb, contributionWei:10000000000000000000, paid:false}));
100 		payees.push(Payee({addr:0xAB40F1Bec1bFc341791a45fA037D908989EFBF3D, contributionWei:10000000000000000000, paid:false}));
101 		payees.push(Payee({addr:0xFDF13343F1E3626491066563aB6D787b9755cc17, contributionWei:10000000000000000000, paid:false}));
102 		payees.push(Payee({addr:0x808264eeb886d37b706C8e07172d5FdF40dF71A8, contributionWei:9000000000000000000, paid:false}));
103 		payees.push(Payee({addr:0x044a9c43e95AA9FD28EEa25131A62b602D304F1f, contributionWei:5000000000000000000, paid:false}));
104 		payees.push(Payee({addr:0xfBfE2A528067B1bb50B926D79e8575154C1dC961, contributionWei:5000000000000000000, paid:false}));
105 		payees.push(Payee({addr:0x2a7B8545c9f66e82Ac8237D47a609f0cb884C3cE, contributionWei:5000000000000000000, paid:false}));
106 		payees.push(Payee({addr:0xd9426Fb83321075116b9CF0fCc36F3EcBBe8178C, contributionWei:5000000000000000000, paid:false}));
107 		payees.push(Payee({addr:0x0743DB483E81668bA748fd6cD51bD6fAAc7665F7, contributionWei:3000000000000000000, paid:false}));
108 		payees.push(Payee({addr:0xB2cd0402Bc1C5e2d064C78538dF5837b93d7cC99, contributionWei:2000000000000000000, paid:false}));
109 		payees.push(Payee({addr:0x867D6B56809D4545A7F53E1d4faBE9086FDeb60B, contributionWei:2000000000000000000, paid:false}));
110 		payees.push(Payee({addr:0x9029056Fe2199Fe0727071611138C70AE2bf27ec, contributionWei:1000000000000000000, paid:false}));
111 		payees.push(Payee({addr:0x4709a3a7b4A0e646e9953459c66913322b8f4195, contributionWei:1000000000000000000, paid:false}));
112 	}
113 
114 	// Check if user is whitelisted admin
115 	modifier onlyAdmins() {
116 		uint8 isAdmin = 0;
117 		for (uint8 i = 0; i < admins.length; i++) {
118 			if (admins[i] == msg.sender)
119         isAdmin = isAdmin | 1;
120 		}
121 		require(isAdmin == 1);
122 		_;
123 	}
124 
125 	// Calculate tokens due
126 	function tokensDue(uint _contributionWei) public view returns (uint) {
127 		return _contributionWei*ethToTokenRate/ethToWei;
128 	}
129 
130 	// Allow admins to change token contract address, in case the wrong token ends up in this contract
131 	function changeToken(address _token) public onlyAdmins {
132 		token = ERC20(_token);
133 	}
134 
135     // Individual withdraw function -- Send 0 ETH from contribution address to withdraw tokens
136 	function () payable {
137 		for (uint i = 0; i < payees.length; i++) {
138 			uint _tokensDue = tokensDue(payees[i].contributionWei);
139 			if (payees[i].addr == msg.sender) {
140 				require(!payees[i].paid);
141 				require(_tokensDue >= withhold);
142 				require(token.balanceOf(address(this)) >= _tokensDue*tokenMultiplier);
143 				// Withhold tokens to cover gas cost
144 				uint tokensToSend = _tokensDue - withhold;
145 				// Send tokens to payee
146 				require(token.transfer(payees[i].addr, tokensToSend*tokenMultiplier));
147 				// Mark payee as paid
148 				payees[i].paid = true;
149 			}
150 		}
151 	}
152 	
153 	// Withdraw all tokens to contributing members
154 	function withdrawAll() public onlyAdmins {
155 		// Prevent withdrawal function from being called simultaneously by two parties
156 		require(withdrawalDeployed == false);
157 		// Confirm sufficient tokens available
158 		require(validate());
159 		withdrawalDeployed = true;
160 		// Send all tokens
161 		for (uint i = 0; i < payees.length; i++) {
162 			// Confirm that contributor has not yet been paid is owed more than gas withhold
163 			if (payees[i].paid == false && tokensDue(payees[i].contributionWei) >= withhold) {
164 				// Withhold tokens to cover gas cost
165 				uint tokensToSend = tokensDue(payees[i].contributionWei) - withhold;
166 				// Send tokens to payee
167 				require(token.transfer(payees[i].addr, tokensToSend*tokenMultiplier));
168 				// Mark payee as paid
169 				payees[i].paid = true;
170 			}
171 		}
172 	}
173 
174   // Confirms that enough tokens are available to distribute to all addresses
175   function validate() public view returns (bool) {
176 		// Calculate total tokens due to all contributors
177 		uint totalTokensDue = 0;
178 		for (uint i = 0; i < payees.length; i++) {
179 			if (!payees[i].paid) {
180 				// Calculate tokens based on ETH contribution
181 				totalTokensDue += tokensDue(payees[i].contributionWei);
182 			}
183 		}
184 		return token.balanceOf(address(this)) >= totalTokensDue*tokenMultiplier;
185   }
186 
187 	// Test - Token transfer -- Try 1 token first
188 	function tokenTest() public onlyAdmins {
189 		require(token.transfer(multisig, 1*tokenMultiplier));
190 	}
191 
192 	// Return all ETH and tokens to original multisig
193 	function returnToSender() public onlyAdmins returns (bool) {
194 		require(token.transfer(multisig, token.balanceOf(address(this))));
195 		require(multisig.send(this.balance));
196 		return true;
197 	}
198 
199 	// Return all ETH and tokens to original multisig and then suicide
200 	function abort() public onlyAdmins {
201 		require(returnToSender());
202 		selfdestruct(multisig);
203 	}
204 
205 
206 }