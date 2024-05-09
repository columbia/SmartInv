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
57 		payees.push(Payee({addr:0x28d804bf2212e220bc2b7b6252993db8286df07f, contributionWei:1058514661000000000000, paid:false}));
58 		payees.push(Payee({addr:0x20A2F38c02a27292afEc7C90609e5Bd413Ab4DD9, contributionWei:942000000000000000000, paid:false}));
59 		payees.push(Payee({addr:0x5F0f119419b528C804C9BbBF15455d36450406B4, contributionWei:760000000000000000000, paid:false}));
60 		payees.push(Payee({addr:0x31C715aD3403F85060614bE744FCb8826d33E8Df, contributionWei:530000000000000000000, paid:false}));
61 		payees.push(Payee({addr:0xE2Ae58AFecF6195D51DA29250f8Db4C8F3222440, contributionWei:471200000000000000000, paid:false}));
62 		payees.push(Payee({addr:0x296b436529DC64C03E9cEB77F032a04071D6c057, contributionWei:400000000000000000000, paid:false}));
63 		payees.push(Payee({addr:0x8dCd6294cE580bc6D17304a0a5023289dffED7d6, contributionWei:365000000000000000000, paid:false}));
64 		payees.push(Payee({addr:0xb9C336A4bA0f25eaa67ee5Ca89ECF3491a1407f3, contributionWei:300000000000000000000, paid:false}));
65 		payees.push(Payee({addr:0xA534F5b9a5D115563A28FccC5C92ada771da236E, contributionWei:288000000000000000000, paid:false}));
66 		payees.push(Payee({addr:0x82e4ad6af565598e5af655c941d4d8995f9783db, contributionWei:270000000000000000000, paid:false}));
67 		payees.push(Payee({addr:0xA4f8506E30991434204BC43975079aD93C8C5651, contributionWei:260000000000000000000, paid:false}));
68 		payees.push(Payee({addr:0x000354015865e6A7F83B8973418c9a0CF6B6DA3C, contributionWei:238000000000000000000, paid:false}));
69 		payees.push(Payee({addr:0x00505D0a66A0646c85095bBFd75f57c4e1C431ba, contributionWei:225000000000000000000, paid:false}));
70 		payees.push(Payee({addr:0x9ebab12563968d8255f546831ec4833449234fFa, contributionWei:200000000000000000000, paid:false}));
71 		payees.push(Payee({addr:0xFf651EAD42b8EeA0B9cB88EDc92704ef6af372Ce, contributionWei:200000000000000000000, paid:false}));
72 		payees.push(Payee({addr:0x001f95c5a0e8B7Dce28311F334345a330EF7c3c5, contributionWei:200000000000000000000, paid:false}));
73 		payees.push(Payee({addr:0x608a8116eA6A3607f6d444AFBD9bEce6d8308c6C, contributionWei:160000000000000000000, paid:false}));
74 		payees.push(Payee({addr:0x0Be0D78fA3af2fc0863c6AC3fD8e13411B2471b4, contributionWei:155000000000000000000, paid:false}));
75 		payees.push(Payee({addr:0x85591bFABB18Be044fA98D72F7093469C588483C, contributionWei:140000000000000000000, paid:false}));
76 		payees.push(Payee({addr:0xb09E4B177856C95003E806e2f07dDCA38257df6D, contributionWei:125000000000000000000, paid:false}));
77 		payees.push(Payee({addr:0x2B3f65Ed823d1D44790fBd96BD51Fa22196Fff82, contributionWei:120000000000000000000, paid:false}));
78 		payees.push(Payee({addr:0xa722F9F5D744D508C155fCEb9245CA57B5D13Bb5, contributionWei:120000000000000000000, paid:false}));
79 		payees.push(Payee({addr:0x00694C41975E95e435461192aBb86C56A3c2e66f, contributionWei:115000000000000000000, paid:false}));
80 		payees.push(Payee({addr:0xd20718bbE781951CaEA1FaE92f922E6Ddbde529A, contributionWei:107500000000000000000, paid:false}));
81 		payees.push(Payee({addr:0x867D6B56809D4545A7F53E1d4faBE9086FDeb60B, contributionWei:106000000000000000000, paid:false}));
82 		payees.push(Payee({addr:0x00566011c133ccBD50aB7088DFA1434e31e42946, contributionWei:105000000000000000000, paid:false}));
83 		payees.push(Payee({addr:0x008C4142Cc1B40D30557DFb976cDc1ba1F75d11a, contributionWei:101000000000000000000, paid:false}));
84 		payees.push(Payee({addr:0x82e4D78C6c62D461251fA5A1D4Deb9F0fE378E30, contributionWei:100000000000000000000, paid:false}));
85 		payees.push(Payee({addr:0x0466A804c880Cd5F225486A5D0f556be25B6fCC8, contributionWei:100000000000000000000, paid:false}));
86 		payees.push(Payee({addr:0x660E067602dC965F10928B933F21bA6dCb2ece9C, contributionWei:100000000000000000000, paid:false}));
87 		payees.push(Payee({addr:0x5bc788e50c6eb950fed19ddb488fad9bbb22300e, contributionWei:100000000000000000000, paid:false}));
88 		payees.push(Payee({addr:0x78577F346253c63266C6E6603797bBc4F20d2d20, contributionWei:100000000000000000000, paid:false}));
89 		payees.push(Payee({addr:0xe6497414EB0b19BbeB1d41451cA096ad1656Fa17, contributionWei:85000000000000000000, paid:false}));
90 		payees.push(Payee({addr:0xf506D090bFcBc73D1E9ea9770aB0d428515Ac858, contributionWei:80000000000000000000, paid:false}));
91 		payees.push(Payee({addr:0x8E6340BB3F73DF84214ec52A446E03AE6DdFfC21, contributionWei:72000000000000000000, paid:false}));
92 		payees.push(Payee({addr:0x8F212180bF6B8178559a67268502057Fb0043Dd9, contributionWei:70000000000000000000, paid:false}));
93 		payees.push(Payee({addr:0x410a99f620D6382ce5e78b697519668817aFbD5D, contributionWei:67000000000000000000, paid:false}));
94 		payees.push(Payee({addr:0xCAbA2231Bc28f0fCE76FEa1f97e4c9225899B4eE, contributionWei:60000000000000000000, paid:false}));
95 		payees.push(Payee({addr:0xF1EA52AC3B0998B76e2DB8394f91224c06BEEf1c, contributionWei:50000000000000000000, paid:false}));
96 		payees.push(Payee({addr:0x46cCc6b127D6d4d04080Da2D3bb5Fa9Fb294708a, contributionWei:50000000000000000000, paid:false}));
97 		payees.push(Payee({addr:0x2a7B8545c9f66e82Ac8237D47a609f0cb884C3cE, contributionWei:50000000000000000000, paid:false}));
98 		payees.push(Payee({addr:0x63DEFE2bC3567e3309a31b27261fE839Ed35ae3A, contributionWei:50000000000000000000, paid:false}));
99 		payees.push(Payee({addr:0xFFfe1F5D42DC16AF7c05D0Aa24D2C649A869B367, contributionWei:50000000000000000000, paid:false}));
100 		payees.push(Payee({addr:0x0AF8997f94229407C53620cd30C6d9e37653221d, contributionWei:50000000000000000000, paid:false}));
101 		payees.push(Payee({addr:0x0007216e1eBC0E02B7A45448bECA6e3faA6E4694, contributionWei:50000000000000000000, paid:false}));
102 		payees.push(Payee({addr:0x4a4d944301507a175824de2dae490e9aeca5c347, contributionWei:50000000000000000000, paid:false}));
103 		payees.push(Payee({addr:0xc9cc554d35824fdc3b086ac22e62a5b11c1bde90, contributionWei:50000000000000000000, paid:false}));
104 		payees.push(Payee({addr:0x00B15358eE23E65ad02F07Bd66FB556c21C6b613, contributionWei:47000000000000000000, paid:false}));
105 		payees.push(Payee({addr:0x0006b0A9bf479Bc741265073E34fCf646Ff0BC90, contributionWei:47000000000000000000, paid:false}));
106 		payees.push(Payee({addr:0x8f8Ce7C2Ae0860F7F12C613FD85CC82ba292F6eB, contributionWei:45000000000000000000, paid:false}));
107 
108 	}
109 
110 
111 	// Check if user is whitelisted admin
112 	modifier onlyAdmins() {
113 		uint8 isAdmin = 0;
114 		for (uint8 i = 0; i < admins.length; i++) {
115 			if (admins[i] == msg.sender)
116         isAdmin = isAdmin | 1;
117 		}
118 		require(isAdmin == 1);
119 		_;
120 	}
121 
122 	// Calculate tokens due
123 	function tokensDue(uint _contributionWei) public view returns (uint) {
124 		return _contributionWei*ethToTokenRate/ethToWei;
125 	}
126 
127 	// Allow admins to change token contract address, in case the wrong token ends up in this contract
128 	function changeToken(address _token) public onlyAdmins {
129 		token = ERC20(_token);
130 	}
131 
132 	// Withdraw all tokens to contributing members
133 	function withdrawAll() public onlyAdmins {
134 		// Prevent withdrawal function from being called simultaneously by two parties
135 		require(withdrawalDeployed == false);
136 		// Confirm sufficient tokens available
137 		require(validate());
138 		withdrawalDeployed = true;
139 		// Send all tokens
140 		for (uint i = 0; i < payees.length; i++) {
141 			// Confirm that contributor has not yet been paid is owed more than gas withhold
142 			if (payees[i].paid == false && tokensDue(payees[i].contributionWei) >= withhold) {
143 				// Withhold tokens to cover gas cost
144 				uint tokensToSend = tokensDue(payees[i].contributionWei) - withhold;
145 				// Send tokens to payee
146 				require(token.transferFrom(multisig,payees[i].addr, tokensToSend*tokenMultiplier));
147 				// Mark payee as paid
148 				payees[i].paid = true;
149 			}
150 		}
151 	}
152 
153 	// Confirms that enough tokens are available to distribute to all addresses
154 	function validate() public view returns (bool) {
155 		// Calculate total tokens due to all contributors
156 		uint totalTokensDue = 0;
157 		for (uint i = 0; i < payees.length; i++) {
158 			if (!payees[i].paid) {
159 				// Calculate tokens based on ETH contribution
160 				totalTokensDue += tokensDue(payees[i].contributionWei)*tokenMultiplier;
161 			}
162 		}
163 		return token.balanceOf(multisig) >= totalTokensDue && token.allowance(multisig,address(this)) >= totalTokensDue;
164 	}
165 
166   
167 	// Return all ETH and tokens to original multisig
168 	function returnToSender() public onlyAdmins returns (bool) {
169 		require(token.transfer(multisig, token.balanceOf(address(this))));
170 		require(multisig.send(this.balance));
171 		return true;
172 	}
173 
174 	// Return all ETH and tokens to original multisig and then suicide
175 	function abort() public onlyAdmins {
176 		require(returnToSender());
177 		selfdestruct(multisig);
178 	}
179 
180 
181 }