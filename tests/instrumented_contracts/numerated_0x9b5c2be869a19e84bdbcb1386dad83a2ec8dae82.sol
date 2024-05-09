1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'STPL' 'Stream Protocol' token contract
5 //
6 // Symbol	  : STPL
7 // Name		: Stream Protocol
8 // Total supply: 2,000,000,000.000000000000000000
9 // Decimals	: 18
10 //
11 // Enjoy.
12 //
13 // (c) Sam Jeong / SendSquare Co. 2020. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21 	function add(uint a, uint b) internal pure returns (uint c) {
22 		c = a + b;
23 		require(c >= a);
24 	}
25 	function sub(uint a, uint b) internal pure returns (uint c) {
26 		require(b <= a);
27 		c = a - b;
28 	}
29 	function mul(uint a, uint b) internal pure returns (uint c) {
30 		c = a * b;
31 		require(a == 0 || c / a == b);
32 	}
33 	function div(uint a, uint b) internal pure returns (uint c) {
34 		require(b > 0);
35 		c = a / b;
36 	}
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45 	function totalSupply() public view returns (uint);
46 	function balanceOf(address tokenOwner) public view returns (uint balance);
47 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
48 	function transfer(address to, uint tokens) public returns (bool success);
49 	function approve(address spender, uint tokens) public returns (bool success);
50 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52 	event Transfer(address indexed from, address indexed to, uint tokens);
53 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63 	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71 	address public owner;
72 
73 	constructor() public {
74 		owner = msg.sender;
75 	}
76 
77 	modifier onlyOwner {
78 		require(msg.sender == owner);
79 		_;
80 	}
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and a
86 // fixed supply
87 // ----------------------------------------------------------------------------
88 contract StreamProtocol is ERC20Interface, Owned {
89 	using SafeMath for uint;
90 
91 	string public symbol;
92 	string public name;
93 	uint8 public decimals;
94 	uint _totalSupply;
95 	bool _stopTrade;
96 
97 	mapping(address => uint) balances;
98 	mapping(address => mapping(address => uint)) allowed;
99 
100 
101 	// ------------------------------------------------------------------------
102 	// Constructor
103 	// ------------------------------------------------------------------------
104 	constructor() public {
105 		symbol = "STPL";
106 		name = "Stream Protocol";
107 		decimals = 18;
108 		_totalSupply = 2000000000 * 10**uint(decimals);
109 		_stopTrade = false;
110 		balances[owner] = _totalSupply;
111 		emit Transfer(address(0), owner, _totalSupply);
112 	}
113 
114 
115 	// ------------------------------------------------------------------------
116 	// Total supply
117 	// ------------------------------------------------------------------------
118 	function totalSupply() public view returns (uint) {
119 		return _totalSupply.sub(balances[address(0)]);
120 	}
121 
122 
123 	// ------------------------------------------------------------------------
124 	// Stop Trade
125 	// ------------------------------------------------------------------------
126 	function stopTrade() public onlyOwner {
127 		require(_stopTrade != true);
128 		_stopTrade = true;
129 	}
130 
131 
132 	// ------------------------------------------------------------------------
133 	// Start Trade
134 	// ------------------------------------------------------------------------
135 	function startTrade() public onlyOwner {
136 		require(_stopTrade == true);
137 		_stopTrade = false;
138 	}
139 
140 
141 	// ------------------------------------------------------------------------
142 	// Get the token balance for account `tokenOwner`
143 	// ------------------------------------------------------------------------
144 	function balanceOf(address tokenOwner) public view returns (uint balance) {
145 		return balances[tokenOwner];
146 	}
147 
148 
149 	// ------------------------------------------------------------------------
150 	// Transfer the balance from token owner's account to `to` account
151 	// - Owner's account must have sufficient balance to transfer
152 	// - 0 value transfers are allowed
153 	// ------------------------------------------------------------------------
154 	function transfer(address to, uint tokens) public returns (bool success) {
155 		require(_stopTrade != true);
156 		require(to > address(0));
157 
158 		balances[msg.sender] = balances[msg.sender].sub(tokens);
159 		balances[to] = balances[to].add(tokens);
160 		emit Transfer(msg.sender, to, tokens);
161 		return true;
162 	}
163 
164 
165 	// ------------------------------------------------------------------------
166 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
167 	// from the token owner's account
168 	//
169 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
170 	// recommends that there are no checks for the approval double-spend attack
171 	// as this should be implemented in user interfaces
172 	// ------------------------------------------------------------------------
173 	function approve(address spender, uint tokens) public returns (bool success) {
174 		require(_stopTrade != true);
175 
176 		allowed[msg.sender][spender] = tokens;
177 		emit Approval(msg.sender, spender, tokens);
178 		return true;
179 	}
180 
181 
182 	// ------------------------------------------------------------------------
183 	// Transfer `tokens` from the `from` account to the `to` account
184 	//
185 	// The calling account must already have sufficient tokens approve(...)-d
186 	// for spending from the `from` account and
187 	// - From account must have sufficient balance to transfer
188 	// - Spender must have sufficient allowance to transfer
189 	// - 0 value transfers are allowed
190 	// ------------------------------------------------------------------------
191 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192 		require(_stopTrade != true);
193 		require(from > address(0));
194 		require(to > address(0));
195 
196 		balances[from] = balances[from].sub(tokens);
197 		if(from != to && from != msg.sender) {
198 			allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
199 		}
200 		balances[to] = balances[to].add(tokens);
201 		emit Transfer(from, to, tokens);
202 		return true;
203 	}
204 
205 
206 	// ------------------------------------------------------------------------
207 	// Returns the amount of tokens approved by the owner that can be
208 	// transferred to the spender's account
209 	// ------------------------------------------------------------------------
210 	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
211 		require(_stopTrade != true);
212 
213 		return allowed[tokenOwner][spender];
214 	}
215 
216 
217 	// ------------------------------------------------------------------------
218 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
219 	// from the token owner's account. The `spender` contract function
220 	// `receiveApproval(...)` is then executed
221 	// ------------------------------------------------------------------------
222 	function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
223 		require(msg.sender != spender);
224 
225 		allowed[msg.sender][spender] = tokens;
226 		emit Approval(msg.sender, spender, tokens);
227 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
228 		return true;
229 	}
230 
231 
232 	// ------------------------------------------------------------------------
233 	// Don't accept ETH
234 	// ------------------------------------------------------------------------
235 	function () external payable {
236 		revert();
237 	}
238 
239 
240 	// ------------------------------------------------------------------------
241 	// Owner can transfer out any accidentally sent ERC20 tokens
242 	// ------------------------------------------------------------------------
243 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
244 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
245 	}
246 
247 	event Burn(address indexed burner, uint256 value);
248 
249 	// ------------------------------------------------------------------------
250 	// Burns a specific amount of tokens
251 	// ------------------------------------------------------------------------
252 	function burn(uint256 _value) public {
253 		require(_value <= balances[msg.sender]);
254 
255 		address burner = msg.sender;
256 		balances[burner] = balances[burner].sub(_value);
257 		_totalSupply = _totalSupply.sub(_value);
258 		emit Burn(burner, _value);
259 	}
260 }