1 pragma solidity ^0.4.18;
2 
3 // ---------------------------
4 // OMGCat coin contract
5 //
6 // Deployed to 	: 0x921beCA00339c458342cF09b4B0f4adb3942e332
7 // symbol		: OMGCAT
8 // name 		: OMGCatCoin
9 // Total supply : 100,000,000,000.000000000000000000
10 // Decimals 	: 18
11 // ------------
12 // Safe maths
13 // ------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c){
16     	c = a + b;
17     	require(c >= a);
18     }
19 
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21     	require(b <= a);
22     	c = a - b;
23     }
24 
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26     	c = a * b;
27     	require(a == 0 || c / a == b);
28     }
29 
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31     	require(b > 0);
32     	c = a / b;
33     }
34 }
35 
36 // ------------------------------------------------
37 // OMGCatCoin Standard #20 Interface
38 // ------------------------------------------------
39 contract ERC20Interface {
40 	function totalSupply() public constant returns (uint);
41 	function balanceOf(address tokenOwner) public constant returns (uint balance);
42 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43 	function transfer(address to, uint tokens) public returns (bool success);
44 	function approve(address spender, uint tokens) public returns (bool success);
45 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47 	event Transfer(address indexed from, address indexed to, uint tokens);
48 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 // -------------
52 // Contract function to receive approval and execute function in one call
53 // -------------
54 contract ApproveAndCallFallBack {
55 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 // -------------
59 // Owned contract
60 // -------------
61 contract Owned {
62 	address public owner;
63 	address public newOwner;
64 
65 	event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67 	function Owned() public {
68 		owner = msg.sender;
69 	}
70 
71 	modifier onlyOwner {
72 		require(msg.sender == owner);
73 		_;
74 	}
75 
76 	function transferOwnership(address _newOwner) public onlyOwner {
77 		newOwner = _newOwner;
78 	}
79 
80 	function acceptOwnership() public {
81 		require(msg.sender == newOwner);
82 		OwnershipTransferred(owner, newOwner);
83 		owner = newOwner;
84 		newOwner = address(0);
85 	}
86 }
87 
88 // ---------
89 // -- ERC20 Token, with the additional of symbol, name, decimals and assisted
90 // ---------
91 contract OMGCatCoin is ERC20Interface, Owned, SafeMath {
92 	string public symbol;
93 	string public  name;
94 	uint8 public decimals;
95 	uint public _totalSupply;
96 
97 	mapping(address => uint) balances;
98 	mapping(address => mapping(address => uint)) allowed;
99 
100 	// -----------
101 	// Constructor 
102 	// -----------
103 	function OMGCatCoin() public {
104 		symbol = 'OMGCAT';
105 		name = 'OMGCatCoin';
106 		decimals = 18;
107 		_totalSupply = 100000000000 * 10**uint(decimals);
108 		balances[0x921beCA00339c458342cF09b4B0f4adb3942e332] = _totalSupply;
109 		Transfer(address(0), 0x921beCA00339c458342cF09b4B0f4adb3942e332, _totalSupply);
110 	}
111 
112 	// ------------
113 	// Total supply
114 	// ------------
115 	function totalSupply() public constant returns (uint) {
116 		return _totalSupply - balances[address(0)];
117 	}
118 
119 	// ----
120 	// Get the coin balance for account coinOwner
121 	// ----
122 	function balanceOf(address tokenOwner) public constant returns (uint balance) {
123 		return balances[tokenOwner];
124 	}
125 
126 	// ------
127 	// transfer the balance from token owner account to 'to' account
128 	// - Owner's account must have sufficient balance to transfer
129 	// - 0 value transfers are allowed
130 	// -------
131 	function transfer(address to, uint tokens) public returns (bool success) {
132 		balances[msg.sender] = safeSub(balances[msg.sender], tokens);
133 		balances[to] = safeAdd(balances[to], tokens);
134 		Transfer(msg.sender, to, tokens);
135 
136 		return true;
137 	}
138 
139 	// -----
140 	// Token owner can approve for spender to transferFrom(...) tokens
141     // Token owner can approve for spender to transferFrom(...) tokens
142     // from the token owner's account
143     //
144     // recommends that there are no checks for the approval double-spend attack
145     // as this should be implemented in user interfaces 	
146     function approve(address spender, uint tokens) public returns (bool success) {
147     	allowed[msg.sender][spender] = tokens;
148     	Approval(msg.sender, spender, tokens);
149     	return true;
150     }
151 
152     // ---------------
153     //
154     // callin accoutn must already have sufficient tokens to approve(...)
155     // for spending from the form account and
156     // - From account must have sufficient balance to transfer
157     // - Spender must have sufficient allownace to transfer
158     // - 0 value transfers are allowed
159     // --------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161     	balances[from] = safeSub(balances[from], tokens);
162     	allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
163     	balances[to] = safeAdd(balances[to], tokens);
164     	Transfer(from, to, tokens);
165     	return true;
166     }
167 
168     // -----------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // -----------
172     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173     	return allowed[tokenOwner][spender];
174     }
175 
176     // ------------
177     // Token owner can approve for spender to transferFrom(...) tokens
178     // from the token owner's account. The spender contract function
179     // receiveApproval(...) is then executed
180     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
181     	allowed[msg.sender][spender] = tokens;
182     	Approval(msg.sender, spender, tokens);
183     	ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
184     	return true;
185     }
186 
187     // ---------
188     // Dont accept ETH;
189     // ---------
190     function () public payable { 
191     	revert();
192     }
193 
194     // -----------
195     // Owner can transfer out any accidentally sent ERC20 tokens
196     // ------------
197     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
198     	return ERC20Interface(tokenAddress).transfer(owner, tokens);
199     }
200 }