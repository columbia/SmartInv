1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Fusionchain' Token contract
5 //
6 // Deployed to : 0xAfa5b5e0C7cd2E1882e710B63EAb0D6f8cbDbf43
7 // Symbol      : FIX	
8 // Name        : Fusionchain
9 // Total supply: 7,300,000,000 FIX
10 // Decimals    : 7
11 //
12 // by Fusionchain Developer Team --- Oct 31,2018.
13 //
14 // All-in-One the decentralized financial network.
15 
16 // ----------------------------------------------------------------------------
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 
21 contract FusionchainSafeMath 
22 {
23 	function safeAdd(uint a, uint b) public pure returns (uint c) 
24 	{
25 		c = a + b;
26 		require(c >= a);
27 	}
28 
29 	function safeSub(uint a, uint b) public pure returns (uint c) 
30 	{
31 		require(b <= a);
32 		c = a - b;
33 	}
34 
35 	function safeMul(uint a, uint b) public pure returns (uint c) 
36 	{
37 		c = a * b;
38 		require(a == 0 || c / a == b);
39 	}
40 	
41 	function safeDiv(uint a, uint b) public pure returns (uint c) 
42 	{
43 		require(b > 0);
44 		c = a / b;
45 	}
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 //  Interface
51 // ----------------------------------------------------------------------------
52 
53 contract FusionchainInterface 
54 {
55 	function totalSupply() public constant returns (uint);
56 	function balanceOf(address tokenOwner) public constant returns (uint balance);
57 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
58 	function transfer(address to, uint tokens) public returns (bool success);
59 	function approve(address spender, uint tokens) public returns (bool success);
60 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
61 	function burn(uint _value) returns (bool success);
62 
63 	// This generates a public event on the blockchain that will notify clients
64 	event Transfer(address indexed from, address indexed to, uint tokens);
65 
66 	// This generates a public event on the blockchain that will notify clients
67 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 //
74 // Contract function to receive approval and execute function in one call
75 //
76 // ----------------------------------------------------------------------------
77 
78 contract FusionchainApproveAndCallFallBack 
79 {
80 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
81 }
82 
83 // ----------------------------------------------------------------------------
84 // FusionchainOwned contract
85 // ----------------------------------------------------------------------------
86 
87 contract FusionchainOwned 
88 {
89 	address public owner;
90 	address public newOwner;
91 
92 	event OwnershipTransferred(address indexed _from, address indexed _to);
93 
94 	constructor() public 
95 	{
96 		owner = msg.sender;
97 	}
98 
99 	modifier onlyOwner 
100 	{
101 		require(msg.sender == owner);
102 		_;
103 	}
104 
105 	function transferOwnership(address _newOwner) public onlyOwner 
106 	{
107 		newOwner = _newOwner;
108 	}
109 
110 	function acceptOwnership() public 
111 	{
112 		require(msg.sender == newOwner);
113 		emit OwnershipTransferred(owner, newOwner);
114 		owner = newOwner;
115 		newOwner = address(0);
116 	}
117 }
118 
119 // ----------------------------------------------------------------------------
120 // Fusionchain ERC20 Token, with the addition of symbol, name and decimals and assisted
121 // token transfers
122 // ----------------------------------------------------------------------------
123 
124 contract Fusionchain is FusionchainInterface, FusionchainOwned, FusionchainSafeMath
125  {
126 	// Public variables of the token
127 	string public symbol; 	
128 	string public name;  	
129 	uint   public decimals;  
130 	uint   public _totalSupply;
131 
132 	// This creates an array with all balances
133 	mapping(address => uint) balances;
134 	// Owner of account approves the transfer of an amount to another account    
135 	mapping(address => mapping(address => uint)) allowed;
136 
137 
138 	/**
139      * Constructor function
140      *
141      * Initializes contract with initial supply tokens to the creator of the contract
142     */
143 
144 	function Fusionchain () public 
145 	{
146 		symbol = "FIX";       //Token symbol
147 		name = "Fusionchain";    //Token name
148 		decimals = 7;        // 7 is the most common number of decimal places
149 		_totalSupply = 7300000000*10**decimals; // 7,300,000,000 FIX, 7 decimal places 
150 		balances[0xAfa5b5e0C7cd2E1882e710B63EAb0D6f8cbDbf43] = _totalSupply;
151 		
152 		emit Transfer(address(0), 0xAfa5b5e0C7cd2E1882e710B63EAb0D6f8cbDbf43, _totalSupply);
153 	}
154 
155 	// ------------------------------------------------------------------------
156 	// Total supply
157 	// ------------------------------------------------------------------------
158 
159 	function totalSupply() public constant returns (uint) 
160 	{
161 		return _totalSupply  - balances[address(0)];
162 	}
163 
164 	// ------------------------------------------------------------------------
165 	// Get the token balance for account tokenOwner
166 	// ------------------------------------------------------------------------
167 
168 	function balanceOf(address _tokenOwner) public constant returns (uint balance) 
169 	{
170 		return balances[_tokenOwner];
171 	}
172 
173 	/**
174      * Transfer tokens
175      *
176      * Send `_value` tokens to `_to` from your account
177      *
178      * @param _to The address of the recipient
179      * @param _value the amount to send
180     */
181 
182 	function transfer(address _to, uint _value) public returns (bool success)
183 	{
184 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
185 		balances[_to] = safeAdd(balances[_to], _value);
186 
187 		emit Transfer(msg.sender, _to, _value);
188 
189 		return true;
190 	}
191 
192 	/**
193      * Set allowance for other address
194      *
195      * Allows `_spender` to spend no more than `_value` tokens on your behalf
196      *
197      * @param _spender The address authorized to spend
198      * @param _value the max amount they can spend
199     */
200 
201 	function approve(address _spender, uint _value) public returns (bool success) 
202 	{
203 		allowed[msg.sender][_spender] = _value;
204 		
205 		emit Approval(msg.sender, _spender, _value);
206 
207 		return true;
208 	}
209 
210 
211 	/**
212      * Transfer tokens from other address
213      *
214      * Send `_value` tokens to `_to` on behalf of `_from`
215      *
216      * @param _from The address of the sender
217      * @param _to The address of the recipient
218      * @param _value the amount to send
219     */
220 
221 	function transferFrom(address _from, address _to, uint _value) public returns (bool success) 
222 	{
223 		balances[_from] = safeSub(balances[_from], _value);
224 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
225 		balances[_to] = safeAdd(balances[_to], _value);
226 		
227 		emit Transfer(_from, _to, _value);
228 
229 		return true;
230 	}
231 
232 	// ------------------------------------------------------------------------
233 	// Returns the amount of tokens approved by the owner that can be
234 	// transferred to the spender's account
235 	// ------------------------------------------------------------------------
236 
237 	function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) 
238 	{
239 		return allowed[_tokenOwner][_spender];
240 	}
241 
242 
243 	/**
244      * Set allowance for other address and notify
245      *
246      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
247      *
248      * @param _spender The address authorized to spend
249      * @param _value the max amount they can spend
250      * @param _data some extra information to send to the approved contract
251     */
252 
253 	function approveAndCall(address _spender, uint _value, bytes _data) public returns (bool success) 
254 	{
255 		allowed[msg.sender][_spender] = _value;
256 
257 		emit Approval(msg.sender, _spender, _value);
258 		FusionchainApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data);
259 
260 		return true;
261 	}
262 
263 	// ------------------------------------------------------------------------
264 	// Don't accept ETH 
265 	// ------------------------------------------------------------------------
266 
267 	function () public payable 
268 	{
269 		revert();
270 	}
271 
272 	// ------------------------------------------------------------------------
273 	// Owner can transfer out any accidentally sent ERC20 tokens
274 	// ------------------------------------------------------------------------
275 
276 	function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) 
277 	{
278 		return FusionchainInterface(_tokenAddress).transfer(owner, _value);
279 	}
280 
281 	/**
282      * Destroy tokens
283      *
284      * Remove `_value` tokens from the system irreversibly
285      *
286      * @param _value the amount of money to burn
287     */
288 
289 	function burn(uint _value) returns (bool success) 
290 	{
291 		//Check if the sender has enough
292 		if (balances[msg.sender] < _value) 
293 			throw; 
294 
295 		if (_value <= 0) 
296 		    throw; 
297 
298 		// Subtract from the sender
299 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
300 
301 		// Updates totalSupply 
302 		_totalSupply =safeSub(_totalSupply,_value);
303 		
304 		emit Transfer(msg.sender,0x0,_value);
305 		return true;
306 	}
307 }