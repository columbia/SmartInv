1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Implementation of token that conforms the ERC-20 Token Standard
5  */
6 contract Restriction {
7 	address internal owner = msg.sender;
8 	mapping(address => bool) internal granted;
9 
10 	modifier onlyOwner {
11 		require(msg.sender == owner);
12 		_;
13 	}
14 	/**
15 	* @notice Change the owner of the contract
16 	* @param _owner New owner
17 	*/
18 	function changeOwner(address _owner) external onlyOwner {
19 		require(_owner != address(0) && _owner != owner);
20 		owner = _owner;
21 		ChangeOwner(owner);
22 	}
23 	event ChangeOwner(address indexed _owner);
24 } 
25 
26 /**
27  * @dev Interface of contracts that will receive tokens
28  */
29 interface TokenReceiver {
30     function tokenFallback(address, uint256, bytes) external;
31 }
32 
33 /**
34  * @dev Basic token
35  */
36 contract BasicToken is Restriction {
37 	string public name;
38 	string public symbol;
39 	uint8 public decimals = 0;
40 	uint256 public totalSupply = 0;
41 
42 	mapping(address => uint256) private balances;
43 
44 	event Transfer(address indexed _from, address indexed _to, uint256 _value);	
45 
46 	/**
47 	* @dev Construct a token.
48 	* @param _name The name of the token.
49 	* @param _symbol The symbol of the token.
50 	* @param _decimals The decimals of the token.
51 	* @param _supply The initial supply of the token.
52 	*/
53 	function BasicToken(string _name, string _symbol, uint8 _decimals, uint256 _supply) public {
54 		name = _name;
55 		symbol = _symbol;
56 		decimals = _decimals;
57 		_mintTokens(_supply);
58 	}
59 	/**
60 	* @dev Get the balance of the given holder.
61 	* @param _holder The address of the token holder to query the the balance of.
62 	* @return The token amount owned by the holder.
63 	*/
64 	function balanceOf(address _holder) external view returns (uint256) {
65 		return balances[_holder];
66 	}
67 	/**
68 	* @dev Transfer tokens to a specified holder.
69 	* @param _to The address to transfer to.
70 	* @param _amount The amount to be transferred.
71 	* @return returns true on success or throw on failure
72 	*/
73 	function transfer(address _to, uint256 _amount) external returns (bool) {
74 		return _transfer(msg.sender, _to, _amount, "");
75 	}
76 	/**
77 	* @dev Transfer tokens to a specified holder.
78 	* @param _to The address to transfer to.
79 	* @param _amount The amount to be transferred.
80 	* @param _data The data that is attached to this transaction.
81 	* @return returns true on success or throw on failure
82 	*/
83 	function transfer(address _to, uint256 _amount, bytes _data) external returns (bool) {
84 		return _transfer(msg.sender, _to, _amount, _data);
85 	}
86 	/**
87 	* @dev Transfer tokens from one address to another
88 	* @param _from The address from which you want to transfer tokens
89 	* @param _to The address to which you want to transfer tokens
90 	* @param _amount The amount of tokens to be transferred
91 	* @param _data The data that is attached to this transaction.
92 	* @return returns true on success or throw on failure
93 	*/
94 	function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal returns (bool) {
95 		require(_to != address(0)
96 			&& _to != address(this)
97 			&& _from != address(0)
98 			&& _from != _to
99 			&& _amount > 0
100 			&& balances[_from] >= _amount
101 			&& balances[_to] + _amount > balances[_to]
102 		);
103 		balances[_from] -= _amount;
104 		balances[_to] += _amount;
105 		uint size;
106 		assembly {
107 			size := extcodesize(_to)
108 		}
109 		if(size > 0){
110 			TokenReceiver(_to).tokenFallback(msg.sender, _amount, _data);
111 		}
112 		Transfer(_from, _to, _amount);
113 		return true;
114 	}
115 	/**
116 	* @dev Mint tokens.
117 	* @param _amount The amount of tokens to mint.
118 	* @return returns true on success or throw on failure
119 	*/
120 	function _mintTokens(uint256 _amount) internal onlyOwner returns (bool success){
121 		require(totalSupply + _amount > totalSupply);
122 		totalSupply += _amount;
123 		balances[msg.sender] += _amount;
124 		Transfer(address(0), msg.sender, _amount);
125 		return true;
126 	}
127 	/**
128 	* @dev Burn tokens.
129 	* @param _amount The amount of tokens to burn.
130 	* @return returns true on success or throw on failure
131 	*/
132 	function _burnTokens(uint256 _amount) internal returns (bool success){
133 		require(balances[msg.sender] > _amount);
134 		totalSupply -= _amount;
135 		balances[owner] -= _amount;
136 		Transfer(msg.sender, address(0), _amount);
137 		return true;
138 	}
139 }
140 
141 contract ERC20Compatible {
142 	mapping(address => mapping(address => uint256)) private allowed;
143 
144 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);	
145 	function _transfer(address _from, address _to, uint256 _amount, bytes _data) internal returns (bool success);
146 
147 	/**
148 	* @dev Get the amount of tokens that a holder allowed other holder to spend.
149 	* @param _owner The address of the owner.
150 	* @param _spender The address of the spender.
151 	* @return amount The amount of tokens still available for the spender.
152 	*/
153 	function allowance(address _owner, address _spender) external constant returns (uint256 amount) {
154 		return allowed[_owner][_spender];
155 	}
156 	/**
157 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158 	* @param _spender The address of the holder who will spend the tokens of the msg.sender.
159 	* @param _amount The amount of tokens allow to be spent.
160 	* @return returns true on success or throw on failure
161 	*/
162 	function approve(address _spender, uint256 _amount) external returns (bool success) {
163 		require( _spender != address(0) 
164 			&& _spender != msg.sender 
165 			&& (_amount == 0 || allowed[msg.sender][_spender] == 0)
166 		);
167 		allowed[msg.sender][_spender] = _amount;
168 		Approval(msg.sender, _spender, _amount);
169 		return true;
170 	}
171 	/**
172 	* @dev Transfer tokens from one holder to the other holder.
173 	* @param _from The address from which the tokens will be transfered.
174 	* @param _to The address to which the tokens will be transfered.
175 	* @param _amount The amount of tokens to be transferred.
176 	* @return returns true on success or throw on failure
177 	*/
178 	function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
179 		require(allowed[_from][msg.sender] >= _amount);
180 		allowed[_from][msg.sender] -= _amount;
181 		return _transfer(_from, _to, _amount, "");
182 	}
183 }
184 
185 contract Regulatable is Restriction {
186 	function _mintTokens(uint256 _amount) internal onlyOwner returns (bool success);
187 	function _burnTokens(uint256 _amount) internal returns (bool success);
188 	/**
189 	* @notice Mint more tokens
190 	* @param _amount The amount of token to be minted
191 	* @return returns true on success or throw on failure
192 	*/
193 	function mintTokens(uint256 _amount) external onlyOwner returns (bool){
194 		return _mintTokens(_amount);
195 	}
196 	/**
197 	* @notice Burn some tokens
198 	* @param _amount The amount of token to be burnt
199 	* @return returns true on success or throw on failure
200 	*/
201 	function burnTokens(uint256 _amount) external returns (bool){
202 		return _burnTokens(_amount);
203 	}
204 }
205 
206 contract Token is ERC20Compatible, Regulatable, BasicToken {
207 	string private constant NAME = "Crypto USD";
208 	string private constant SYMBOL = "USDc";
209 	uint8 private constant DECIMALS = 2;
210 	uint256 private constant SUPPLY = 201205110 * uint256(10) ** DECIMALS;
211 	
212 	function Token() public 
213 		BasicToken(NAME, SYMBOL, DECIMALS, SUPPLY) {
214 	}
215 }