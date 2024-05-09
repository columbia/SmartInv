1 pragma solidity ^0.4.24;
2 /**
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6 
7 	function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
8 		uint256 c = a * b;
9 		judgement(a == 0 || c / a == b);
10 		return c;
11 	}
12 
13 	function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
14 		judgement(b > 0);
15 		uint256 c = a / b;
16 		judgement(a == b * c + a % b);
17 		return c;
18 	}
19 
20 	function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
21 		judgement(b <= a);
22 		return a - b;
23 	}
24 
25 	function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
26 		uint256 c = a + b;
27 		judgement(c >= a && c >= b);
28 		return c;
29 	}
30 
31 	function safeMulWithPresent(uint256 a, uint256 b) pure internal returns (uint256){
32 		uint256 c = safeDiv(safeMul(a, b), 1000);
33 		judgement(b == (c * 1000) / a);
34 		return c;
35 	}
36 
37 	function judgement(bool assertion) pure internal {
38 		if (!assertion) {
39 			revert();
40 		}
41 	}
42 }
43 
44 contract CREAuth {
45 	address public owner;
46 	constructor () public{
47 		owner = msg.sender;
48 	}
49 	event LogOwnerChanged (address msgSender);
50 
51 	///@notice check if the msgSender is owner
52 	modifier onlyOwner{
53 		assert(msg.sender == owner);
54 		_;
55 	}
56 
57 	function setOwner(address newOwner) public onlyOwner returns (bool){
58 		require(newOwner != address(0));
59 		owner = newOwner;
60 		emit LogOwnerChanged(msg.sender);
61 		return true;
62 	}
63 
64 }
65 
66 contract Token is SafeMath {
67 	/*
68 		Standard ERC20 token
69 	*/
70 	uint256 public totalSupply;
71 	uint256 internal maxSupply;
72 	/// total amount of tokens
73 	/// @param _owner The address from which the balance will be retrieved
74 	/// @return The balance
75 	function balanceOf(address _owner) public view returns (uint256 balance);
76 
77 	/// @notice send `_value` token to `_to` from `msg.sender`
78 	/// @param _to The address of the recipient
79 	/// @param _value The amount of token to be transferred
80 	/// @return Whether the transfer was successful or not
81 	function transfer(address _to, uint256 _value) public returns (bool success);
82 
83 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
84 	/// @param _from The address of the sender
85 	/// @param _to The address of the recipient
86 	/// @param _value The amount of token to be transferred
87 	/// @return Whether the transfer was successful or not
88 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89 
90 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
91 	/// @param _spender The address of the account able to transfer the tokens
92 	/// @param _value The amount of tokens to be approved for transfer
93 	/// @return Whether the approval was successful or not
94 	function approve(address _spender, uint256 _value) public returns (bool success);
95 
96 	/// @param _owner The address of the account owning tokens
97 	/// @param _spender The address of the account able to transfer the tokens
98 	/// @return Amount of remaining tokens allowed to spent
99 	function allowance(address _owner, address _spender) view public returns (uint256 remaining);
100 
101 	/// @notice transferred
102 	/// @param amount The amount need to burn
103 
104 	function burn(uint256 amount) public returns (bool);
105 
106 	/// mapping the main chain's key to eth key
107 	/// @param key Tf main chain
108 	function register(string key) public returns (bool);
109 
110 	/// mint the token to token owner
111 	/// @param amountOfMint of token mint
112 	function mint(uint256 amountOfMint) public returns (bool);
113 
114 	event Transfer                           (address indexed _from, address indexed _to, uint256 _value);
115 	event Approval                           (address indexed _owner, address indexed _spender, uint256 _value);
116 	event Burn                               (address indexed _owner, uint256 indexed _value);
117 	event LogRegister                        (address user, string key);
118 	event Mint                               (address user,uint256 indexed amountOfMint);
119 }
120 
121 contract StandardToken is Token, CREAuth {
122 
123 	function transfer(address _to, uint256 _value) public returns (bool ind) {
124 		//Default assumes totalSupply can't be over max (2^256 - 1).
125 		//If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
126 		//Replace the if with this one instead.
127 
128 		require(_to != address(0));
129 		assert(balances[msg.sender] >= _value && _value > 0);
130 
131 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
132 		balances[_to] = safeAdd(balances[_to], _value);
133 		emit Transfer(msg.sender, _to, _value);
134 		return true;
135 	}
136 
137 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138 		//same as above. Replace this line with the following if you want to protect against wrapping uints.
139 		require(_to != address(0));
140 		assert(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
141 
142 		balances[_to] = safeAdd(balances[_to], _value);
143 		balances[_from] = safeSub(balances[_from], _value);
144 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
145 		emit Transfer(_from, _to, _value);
146 		return true;
147 	}
148 
149 	function balanceOf(address _owner) public view returns (uint256 balance) {
150 		return balances[_owner];
151 	}
152 
153 	function approve(address _spender, uint256 _value) public returns (bool success) {
154 		require(_spender != address(0));
155 		require(_value > 0);
156 		require(allowed[msg.sender][_spender] == 0);
157 		allowed[msg.sender][_spender] = _value;
158 		emit Approval(msg.sender, _spender, _value);
159 		return true;
160 	}
161 
162 	function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
163 		return allowed[_owner][_spender];
164 	}
165 
166 	function burn(uint256 amount) public onlyOwner returns (bool){
167 
168 		require(balances[msg.sender] >= amount);
169 		balances[msg.sender] = safeSub(balances[msg.sender], amount);
170 		totalSupply = safeSub(totalSupply, amount);
171 		emit Burn(msg.sender, amount);
172 		return true;
173 
174 	}
175 
176 	function register(string key) public returns (bool){
177 		assert(bytes(key).length <= 64);
178 
179 		keys[msg.sender] = key;
180 		emit LogRegister(msg.sender, key);
181 		return true;
182 	}
183 
184 	function mint(uint256 amountOfMint) public onlyOwner returns (bool){
185 		//if totalSupply + amountOfMint <= maxSupply then mint token to contract owner
186 		require(safeAdd(totalSupply, amountOfMint) <= maxSupply);
187 		totalSupply = safeAdd(totalSupply, amountOfMint);
188 		balances[msg.sender] = safeAdd(balances[msg.sender], amountOfMint);
189 		emit Mint(msg.sender ,amountOfMint);
190 		return true;
191 	}
192 
193 	mapping(address => uint256)                      internal balances;
194 	mapping(address => mapping(address => uint256))  private  allowed;
195 	mapping(address => string)                       private  keys;
196 
197 }
198 
199 contract CREToken is StandardToken {
200 
201 	string public name = "CoinRealEcosystem";                                   /// Set the full name of this contract
202 	uint256 public decimals = 18;                                 /// Set the decimal
203 	string public symbol = "CRE";                                 /// Set the symbol of this contract
204 
205 
206 	constructor() public {/// Should have sth in this
207 		owner = msg.sender;
208 		totalSupply = 1000000000000000000000000000;
209 		/// 10 Billion for init mint
210 		maxSupply = 2000000000000000000000000000;
211 		/// set Max supply as 20 billion
212 		balances[msg.sender] = totalSupply;
213 	}
214 
215 	function() public {
216 		revert();
217 	}
218 
219 }