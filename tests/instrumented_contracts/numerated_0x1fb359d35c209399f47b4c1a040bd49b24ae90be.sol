1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns (uint c) {
8 		c = a + b;
9 		require(c >= a);
10 	}
11 	function sub(uint a, uint b) internal pure returns (uint c) {
12 		require(b <= a);
13 		c = a - b;
14 	}
15 	function mul(uint a, uint b) internal pure returns (uint c) {
16 		c = a * b;
17 		require(a == 0 || c / a == b);
18 	}
19 	function div(uint a, uint b) internal pure returns (uint c) {
20 		require(b > 0);
21 		c = a / b;
22 	}
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31 	function totalSupply() public view returns (uint);
32 	function balanceOf(address tokenOwner) public view returns (uint balance);
33 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34 	function transfer(address to, uint tokens) public returns (bool success);
35 	function approve(address spender, uint tokens) public returns (bool success);
36 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38 	event Transfer(address indexed from, address indexed to, uint tokens);
39 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49 	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57 	address public owner;
58 
59 	constructor() public {
60 		owner = msg.sender;
61 	}
62 
63 	modifier onlyOwner {
64 		require(msg.sender == owner);
65 		_;
66 	}
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // ERC20 Token, with the addition of symbol, name and decimals and a
72 // fixed supply
73 // ----------------------------------------------------------------------------
74 contract AutobahnToken is ERC20Interface, Owned {
75 	using SafeMath for uint;
76 
77 	string public symbol;
78 	string public name;
79 	uint8 public decimals;
80 	uint _totalSupply;
81 	bool _stopTrade;
82 
83 	mapping(address => uint) balances;
84 	mapping(address => mapping(address => uint)) allowed;
85 
86 
87 	// ------------------------------------------------------------------------
88 	// Constructor
89 	// ------------------------------------------------------------------------
90 	constructor() public {
91 		symbol = "ATB";
92 		name = "Autobahn";
93 		decimals = 18;
94 		_totalSupply = 10000000000 * 10**uint(decimals);
95 		_stopTrade = false;
96 		balances[owner] = _totalSupply;
97 		emit Transfer(address(0), owner, _totalSupply);
98 	}
99 
100 
101 	// ------------------------------------------------------------------------
102 	// Total supply
103 	// ------------------------------------------------------------------------
104 	function totalSupply() public view returns (uint) {
105 		return _totalSupply.sub(balances[address(0)]);
106 	}
107 
108 
109 	// ------------------------------------------------------------------------
110 	// Stop Trade
111 	// ------------------------------------------------------------------------
112 	function stopTrade() public onlyOwner {
113 		require(_stopTrade != true);
114 		_stopTrade = true;
115 	}
116 
117 
118 	// ------------------------------------------------------------------------
119 	// Start Trade
120 	// ------------------------------------------------------------------------
121 	function startTrade() public onlyOwner {
122 		require(_stopTrade == true);
123 		_stopTrade = false;
124 	}
125 
126 
127 	// ------------------------------------------------------------------------
128 	// Get the token balance for account `tokenOwner`
129 	// ------------------------------------------------------------------------
130 	function balanceOf(address tokenOwner) public view returns (uint balance) {
131 		return balances[tokenOwner];
132 	}
133 
134 
135 	// ------------------------------------------------------------------------
136 	// Transfer the balance from token owner's account to `to` account
137 	// - Owner's account must have sufficient balance to transfer
138 	// - 0 value transfers are allowed
139 	// ------------------------------------------------------------------------
140 	function transfer(address to, uint tokens) public returns (bool success) {
141 		require(_stopTrade != true);
142 		require(to > address(0));
143 
144 		balances[msg.sender] = balances[msg.sender].sub(tokens);
145 		balances[to] = balances[to].add(tokens);
146 		emit Transfer(msg.sender, to, tokens);
147 		return true;
148 	}
149 
150 
151 	// ------------------------------------------------------------------------
152 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
153 	// from the token owner's account
154 	//
155 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156 	// recommends that there are no checks for the approval double-spend attack
157 	// as this should be implemented in user interfaces
158 	// ------------------------------------------------------------------------
159 	function approve(address spender, uint tokens) public returns (bool success) {
160 		require(_stopTrade != true);
161 
162 		allowed[msg.sender][spender] = tokens;
163 		emit Approval(msg.sender, spender, tokens);
164 		return true;
165 	}
166 
167 
168 	// ------------------------------------------------------------------------
169 	// Transfer `tokens` from the `from` account to the `to` account
170 	//
171 	// The calling account must already have sufficient tokens approve(...)-d
172 	// for spending from the `from` account and
173 	// - From account must have sufficient balance to transfer
174 	// - Spender must have sufficient allowance to transfer
175 	// - 0 value transfers are allowed
176 	// ------------------------------------------------------------------------
177 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178 		require(_stopTrade != true);
179 		require(from > address(0));
180 		require(to > address(0));
181 
182 		balances[from] = balances[from].sub(tokens);
183 		if(from != to && from != msg.sender) {
184 			allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185 		}
186 		balances[to] = balances[to].add(tokens);
187 		emit Transfer(from, to, tokens);
188 		return true;
189 	}
190 
191 
192 	// ------------------------------------------------------------------------
193 	// Returns the amount of tokens approved by the owner that can be
194 	// transferred to the spender's account
195 	// ------------------------------------------------------------------------
196 	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
197 		require(_stopTrade != true);
198 
199 		return allowed[tokenOwner][spender];
200 	}
201 
202 
203 	// ------------------------------------------------------------------------
204 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
205 	// from the token owner's account. The `spender` contract function
206 	// `receiveApproval(...)` is then executed
207 	// ------------------------------------------------------------------------
208 	function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
209 		require(msg.sender != spender);
210 
211 		allowed[msg.sender][spender] = tokens;
212 		emit Approval(msg.sender, spender, tokens);
213 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
214 		return true;
215 	}
216 
217 
218 	// ------------------------------------------------------------------------
219 	// Don't accept ETH
220 	// ------------------------------------------------------------------------
221 	function () external payable {
222 		revert();
223 	}
224 
225 
226 	// ------------------------------------------------------------------------
227 	// Owner can transfer out any accidentally sent ERC20 tokens
228 	// ------------------------------------------------------------------------
229 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
231 	}
232 
233 	event Burn(address indexed burner, uint256 value);
234 
235 	// ------------------------------------------------------------------------
236 	// Burns a specific amount of tokens
237 	// ------------------------------------------------------------------------
238 	function burn(uint256 _value) public {
239 		require(_value <= balances[msg.sender]);
240 
241 		address burner = msg.sender;
242 		balances[burner] = balances[burner].sub(_value);
243 		_totalSupply = _totalSupply.sub(_value);
244 		emit Burn(burner, _value);
245 		emit Transfer(burner, address(0), _value);
246 	}
247 }