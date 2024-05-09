1 pragma solidity ^0.4.19;
2 
3 contract EthermiumTokenList {
4 	function safeMul(uint a, uint b) returns (uint) {
5 	    uint c = a * b;
6 	    assert(a == 0 || c / a == b);
7 	    return c;
8 	}
9 
10 	function safeSub(uint a, uint b) returns (uint) {
11 	    assert(b <= a);
12 	    return a - b;
13 	}
14 
15 	function safeAdd(uint a, uint b) returns (uint) {
16 	    uint c = a + b;
17 	    assert(c>=a && c>=b);
18 	    return c;
19 	}
20 	
21 	struct Token {
22 		address tokenAddress; // token ethereum address
23 		uint256 decimals; // number of token decimals
24 		string url; // token website url
25 		string symbol; // token symbol
26 		string name; // token name
27 		string logoUrl; // link to logo
28 		bool verified; // true if the url was verified
29 		address owner; // address from which the token was added
30 		bool enabled; // owner of the token can disable it
31 	}
32 
33 	address public owner;
34 	mapping (address => bool) public admins;
35 	address public feeAccount;
36 	address[] public tokenList;
37 	mapping(address => Token) public tokens; 
38 	uint256 public listTokenFee; // in wei per block
39 	uint256 public modifyTokenFee; // in wei
40 
41 	event TokenAdded(address tokenAddress, uint256 decimals, string url, string symbol, string name, address owner, string logoUrl);
42 	event TokenModified(address tokenAddress, uint256 decimals, string url, string symbol, string name, bool enabled, string logoUrl);
43 	event FeeChange(uint256 listTokenFee, uint256 modifyTokenFee);
44 	event TokenVerify(address tokenAddress, bool verified);
45 	event TokenOwnerChanged(address tokenAddress, address newOwner);
46 
47 	modifier onlyOwner {
48 		assert(msg.sender == owner);
49 		_;
50 	}
51 
52 	modifier onlyAdmin {
53 	    if (msg.sender != owner && !admins[msg.sender]) throw;
54 	    _;
55 	}
56 
57 	function setAdmin(address admin, bool isAdmin) public onlyOwner {
58     	admins[admin] = isAdmin;
59   	}
60 
61   	function setOwner(address newOwner) public onlyOwner {
62 	    owner = newOwner;
63 	}
64 
65 	function setFeeAccount(address feeAccount_) public onlyOwner {
66 	    feeAccount = feeAccount_;
67 	}
68 
69 	function setFees(uint256 listTokenFee_, uint256 modifyTokenFee_) public onlyOwner
70 	{
71 		listTokenFee = listTokenFee_;
72 		modifyTokenFee = modifyTokenFee_;
73 		FeeChange(listTokenFee, modifyTokenFee);
74 	}
75 
76 	
77 
78 	function EthermiumTokenList (address owner_, address feeAccount_, uint256 listTokenFee_, uint256 modifyTokenFee_)
79 	{
80 		owner = owner_;
81 		feeAccount = feeAccount_;
82 		listTokenFee = listTokenFee_;
83 		modifyTokenFee = modifyTokenFee_;
84 	}
85 
86 
87 	function addToken(address tokenAddress, uint256 decimals, string url, string symbol, string name, string logoUrl) public payable
88 	{
89 		require(tokens[tokenAddress].tokenAddress == address(0x0));
90 		if (msg.sender != owner && !admins[msg.sender])
91 		{
92 			require(msg.value >= listTokenFee);
93 		}
94 
95 		tokens[tokenAddress] = Token({
96 			tokenAddress: tokenAddress, 
97 			decimals: decimals,
98 			url: url,
99 			symbol: symbol,
100 			name: name,
101 			verified: false,
102 			owner: msg.sender,
103 			enabled: true,
104 			logoUrl: logoUrl
105 		});
106 		
107 		if (!feeAccount.send(msg.value)) throw;
108 		tokenList.push(tokenAddress);
109 		TokenAdded(tokenAddress, decimals, url, symbol, name, msg.sender, logoUrl);
110 	}
111 
112 	function modifyToken(address tokenAddress, uint256 decimals, string url, string symbol, string name,  string logoUrl, bool enabled) public payable
113 	{
114 		require(tokens[tokenAddress].tokenAddress != address(0x0));
115 		require(msg.sender == tokens[tokenAddress].owner);
116 
117 		if (keccak256(url) != keccak256(tokens[tokenAddress].url))
118 			tokens[tokenAddress].verified = false;
119 
120 		tokens[tokenAddress].decimals = decimals;
121 		tokens[tokenAddress].url = url;
122 		tokens[tokenAddress].symbol = symbol;
123 		tokens[tokenAddress].name = name;
124 		tokens[tokenAddress].enabled = enabled;
125 		tokens[tokenAddress].logoUrl = logoUrl;
126 
127 		TokenModified(tokenAddress, decimals, url, symbol, name, enabled, logoUrl);
128 	}
129 
130 	function changeOwner(address tokenAddress, address newOwner) public
131 	{
132 		require(tokens[tokenAddress].tokenAddress != address(0x0));
133 		require(msg.sender == tokens[tokenAddress].owner || msg.sender == owner);
134 
135 		tokens[tokenAddress].owner = newOwner;
136 
137 		TokenOwnerChanged(tokenAddress, newOwner);
138 	}
139 
140 	function setVerified(address tokenAddress, bool verified_) onlyAdmin public
141 	{
142 		require(tokens[tokenAddress].tokenAddress != address(0x0));
143 
144 		tokens[tokenAddress].verified = verified_;
145 
146 		TokenVerify(tokenAddress, verified_);
147 	}
148 
149 	function isTokenInList(address tokenAddress) public constant returns (bool)
150 	{
151 		if (tokens[tokenAddress].tokenAddress != address(0x0))
152 		{
153 			return true;
154 		}
155 		else
156 		{
157 			return false;
158 		}
159 	}
160 
161 	function getToken(address tokenAddress) public constant returns ( uint256, string, string, string, bool, string)
162 	{
163 		require(tokens[tokenAddress].tokenAddress != address(0x0));
164 		
165 		return ( 
166 			tokens[tokenAddress].decimals, 
167 			tokens[tokenAddress].url,
168 			tokens[tokenAddress].symbol,
169 			tokens[tokenAddress].name,
170 			tokens[tokenAddress].enabled,
171 			tokens[tokenAddress].logoUrl
172 		);
173 	}
174 
175 	function getTokenCount() public constant returns(uint count)
176 	{
177 		return tokenList.length;
178 	}
179 
180 	function isTokenVerified(address tokenAddress) public constant returns (bool)
181 	{
182 		if (tokens[tokenAddress].tokenAddress != address(0x0) && tokens[tokenAddress].verified)
183 		{
184 			return true;
185 		}
186 		else
187 		{
188 			return false;
189 		}
190 	}
191 
192 }